/**
 * AssetReader — 动画资产读取（零 fmodel json 依赖）。
 *
 * 把动画 Montage（取消/连段/装填/射击间隔的数据源）从"FModel 预导出 JSON"迁移为
 * "UAssetCLI server 直接解析 .uasset"：
 * - 优先按 SkillNode 的 AnimPath/AnimSubPath 定位 .uasset，经 UAssetCLI fmodel 导出
 * - uasset 缺失/exe 缺失时回退同路径 .json（兼容旧环境）
 *
 * fmodel 返回 FModel 同构数组 [{ Type, Properties }]，读 SlotAnimTracks / Notifies
 * 提取 cancel / combo / skillEffectLink / shootingInterval（对齐老 weapon 处理器）。
 */

import { existsSync, readdirSync, readFileSync } from "node:fs"
import { basename, join } from "node:path"
import { closeUAssetServer, getExportsRoot, getUAssetServer, type UAssetServer } from "./UAssetServer.ts"

export interface AnimMeta {
    cancel: number
    combo: number
    skillEffectLink: number
    shootingInterval: number
}

const EMPTY: AnimMeta = { cancel: 0, combo: 0, skillEffectLink: 0, shootingInterval: 0 }

/** 从 FModel 同构数组（uassetcli fmodel 或 json）读动画元数据 */
export function animMetaFromFModelData(data: unknown): AnimMeta {
    const arr = Array.isArray(data) && data.length > 0 ? data : [data]
    const montage = (arr[0] as any) ?? {}
    const props = montage.Properties ?? {}
    const result: AnimMeta = { ...EMPTY }

    for (const slot of props.SlotAnimTracks ?? []) {
        const segments = slot?.AnimTrack?.AnimSegments ?? []
        if (segments.length === 0) continue
        let seg = segments[segments.length - 1]
        const firstRef = segments[0]?.AnimReference
        if (firstRef && typeof firstRef === "object") {
            const firstRefKey = firstRef.ObjectPath || firstRef.ObjectName
            if (firstRefKey) {
                for (let i = segments.length - 1; i >= 0; i--) {
                    const candidateRef = segments[i]?.AnimReference
                    if (!candidateRef || typeof candidateRef !== "object") continue
                    const candidateRefKey = candidateRef.ObjectPath || candidateRef.ObjectName
                    if (candidateRefKey === firstRefKey) {
                        seg = segments[i]
                        break
                    }
                }
            }
        }
        const start = Number(seg?.AnimStartTime ?? 0)
        const end = Number(seg?.AnimEndTime ?? 0)
        const playRate = Number(seg?.AnimPlayRate ?? 1)
        if (end - start < 0.1) result.shootingInterval = playRate
        else {
            const interval = Math.max(0, (end - start) * playRate)
            if (interval) result.shootingInterval = Math.max(result.shootingInterval, interval)
        }
    }

    const cancelWindows: Array<[number, number]> = []
    const comboWindows: Array<[number, number]> = []
    for (const notify of props.Notifies ?? []) {
        if (notify?.NotifyName === "BP_SkillCancel_C") {
            const num = toNum(notify.LinkValue)
            if (num !== null) result.cancel = Math.max(result.cancel, num)
            const end = toNum(notify.EndLink?.LinkValue)
            if (num !== null && end !== null) cancelWindows.push([num, end])
        }
        if (notify?.NotifyName === "BP_NextCombo_C") {
            const lv = notify.LinkValue
            const val = lv === null || lv === undefined || lv === "" ? notify.EndLink?.LinkValue : lv
            const num = toNum(val)
            if (num !== null) result.combo = Math.max(result.combo, num)
            const end = toNum(notify.EndLink?.LinkValue)
            if (num !== null && end !== null) comboWindows.push([num, end])
        }
        if (notify?.NotifyName === "BP_SkillEffect_C") {
            const num = toNum(notify.LinkValue)
            if (num !== null) result.skillEffectLink = Math.max(result.skillEffectLink, num)
        }
    }
    for (const [combo, comboEnd] of comboWindows) {
        if (comboEnd >= combo) continue
        if (cancelWindows.some(([start, end]) => start <= combo && combo < end)) {
            result.shootingInterval = result.shootingInterval ? Math.min(result.shootingInterval, combo) : combo
        }
    }
    return result
}

function toNum(v: unknown): number | null {
    if (typeof v === "number") return v
    if (typeof v === "string") {
        const s = v.trim()
        if (!s) return null
        const n = Number(s)
        return Number.isNaN(n) ? null : n
    }
    return null
}

/**
 * AssetReader：解析解包目录、启动 uasset server、按节点读动画元数据（uasset 优先，json 回退）。
 * 带按 uasset/json 路径的元数据缓存。
 */
export class AssetReader {
    private server: UAssetServer | null = null
    private exportsRoot: string | null = null
    private metaCache = new Map<string, AnimMeta>()
    private jsonMetaCache = new Map<string, AnimMeta>()
    private fmodelCache = new Map<string, unknown[] | null>()

    constructor(
        private root: string,
        private preferJson = false,
        private allowPrefixedName = false
    ) {
        this.exportsRoot = getExportsRoot()
    }

    /** 资产根（uasset 与 fmodel json 同源：Exports/EM/Content/Asset） */
    private get assetRoot(): string | null {
        return this.exportsRoot ? join(this.exportsRoot, "EM", "Content", "Asset") : null
    }

    async ensureServer(): Promise<UAssetServer | null> {
        if (this.server) return this.server
        if (!this.exportsRoot) return null
        try {
            this.server = await getUAssetServer()
        } catch {
            this.server = null
        }
        return this.server
    }

    async close(): Promise<void> {
        if (this.server) {
            try {
                await closeUAssetServer()
            } catch {
                /* ignore */
            }
            this.server = null
        }
    }

    /**
     * 按路径读取一个 BP/uasset 的 FModel 结构。
     * server 只在第一次真正请求资产时启动；结果按绝对路径缓存。
     * 该接口不读取同名 JSON，调用方需要明确处理 server 不可用的情况。
     */
    async readFModelAsset(assetPath: string): Promise<unknown[] | null> {
        const key = assetPath.replace(/\\/g, "/")
        if (this.fmodelCache.has(key)) return this.fmodelCache.get(key) ?? null
        if (!existsSync(assetPath)) {
            this.fmodelCache.set(key, null)
            return null
        }
        const server = await this.ensureServer()
        if (!server || !this.exportsRoot) {
            this.fmodelCache.set(key, null)
            return null
        }
        let result: unknown[] | null = null
        try {
            result = await server.fmodel(assetPath, this.exportsRoot)
        } catch {
            result = null
        }
        this.fmodelCache.set(key, result)
        return result
    }

    /**
     * 定位 SkillNode 的动画资产候选路径（uasset + json 同时尝试，uasset 优先）。
     * 返回第一个存在的候选；都缺失返回空。
     */
    private resolveNodeSources(node: Record<string, any>): { uasset: string | null; json: string | null } {
        const animResource = node.AnimResource || node.AnimName
        if (!animResource || !this.assetRoot) return { uasset: null, json: null }
        const animPath = node.AnimPath ?? ""
        const animSubPath = node.AnimSubPath ?? ""
        const root = this.assetRoot

        const candidates: Array<{ uasset: string; json: string }> = []

        const normalized = String(animPath).replace(/\\/g, "/")
        const marker = "/Game/Asset/"
        if (normalized.includes(marker)) {
            const rel = normalized.split(marker)[1].replace(/^\/+|\/+$/g, "")
            const base = join(root, ...rel.split("/").filter(Boolean), String(animResource))
            candidates.push({ uasset: `${base}.uasset`, json: `${base}.json` })
        }

        // AnimSubPath 兜底：Char/Player/*/Animation/Montage/<subpath>/<AnimResource>
        const subDir = String(animSubPath).replace(/\\/g, "/").split("/").filter(Boolean)
        const playersRoot = join(root, "Char", "Player")
        const prefixedCandidates: Array<{ uasset: string; json: string }> = []
        try {
            if (existsSync(playersRoot)) {
                for (const charName of readdirSync(playersRoot).sort()) {
                    let cur = join(playersRoot, charName, "Animation", "Montage")
                    let ok = true
                    for (const seg of subDir) {
                        cur = join(cur, seg)
                        if (!existsSync(cur)) {
                            ok = false
                            break
                        }
                    }
                    if (!ok) continue
                    candidates.push({ uasset: join(cur, `${animResource}.uasset`), json: join(cur, `${animResource}.json`) })
                    if (this.allowPrefixedName) {
                        for (const name of readdirSync(cur).sort()) {
                            if (!name.endsWith(`_${animResource}.json`) && !name.endsWith(`_${animResource}.uasset`)) continue
                            const base = join(cur, name.replace(/\.(?:json|uasset)$/i, ""))
                            if (!prefixedCandidates.some(candidate => candidate.uasset === `${base}.uasset`)) {
                                prefixedCandidates.push({ uasset: `${base}.uasset`, json: `${base}.json` })
                            }
                        }
                    }
                }
            }
        } catch {
            /* ignore */
        }
        candidates.push(...prefixedCandidates)
        if (this.preferJson) {
            for (const c of candidates) {
                if (c.json && existsSync(c.json)) return c
            }
        }
        // 返回第一个存在的候选（uasset 优先，其次 json）
        for (const c of candidates) {
            if (c.uasset && existsSync(c.uasset)) return c
        }
        for (const c of candidates) {
            if (c.json && existsSync(c.json)) return c
        }
        return { uasset: null, json: null }
    }

    /**
     * 读一个 SkillNode 的动画元数据。uasset 优先（UAssetCLI server），json 回退。带缓存。
     */
    async animMetaForNode(node: Record<string, any>): Promise<AnimMeta> {
        const { uasset, json } = this.resolveNodeSources(node)

        if (this.preferJson && json && existsSync(json)) {
            const cached = this.jsonMetaCache.get(json)
            if (cached) return cached
            try {
                const data = JSON.parse(readFileSync(json, "utf8"))
                const meta = animMetaFromFModelData(data)
                this.jsonMetaCache.set(json, meta)
                return meta
            } catch {
                /* continue with the uasset source */
            }
        }

        // 尝试 uasset（优先）
        if (uasset && existsSync(uasset)) {
            const cached = this.metaCache.get(uasset)
            if (cached) return cached
            const server = await this.ensureServer()
            if (server && (this.exportsRoot || this.assetRoot)) {
                try {
                    const data = await server.fmodel(uasset, this.exportsRoot ?? this.assetRoot ?? this.root)
                    if (data) {
                        const meta = animMetaFromFModelData(data)
                        this.metaCache.set(uasset, meta)
                        return meta
                    }
                } catch {
                    /* fall to json */
                }
            }
        }

        // 回退 json（fmodel 预导出）
        if (json && existsSync(json)) {
            const cached = this.jsonMetaCache.get(json)
            if (cached) return cached
            try {
                const data = JSON.parse(readFileSync(json, "utf8"))
                const meta = animMetaFromFModelData(data)
                this.jsonMetaCache.set(json, meta)
                return meta
            } catch {
                return { ...EMPTY }
            }
        }
        return { ...EMPTY }
    }

    /** 指示是否真正使用 uasset 源（供日志） */
    get source(): "uasset" | "json" | "none" {
        if (this.server) return "uasset"
        if (this.jsonMetaCache.size > 0) return "json"
        return "none"
    }
}

export { basename }
