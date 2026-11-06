/**
 * AssetReader — 动画资产读取（纯 .uasset 直读，零 fmodel json/log 依赖）。
 *
 * 动画 Montage（取消/连段/装填/射击间隔的数据源）直接解析解包目录中的 .uasset：
 * - 按 SkillNode 的 AnimPath/AnimSubPath 定位 .uasset，经 UAssetCLI fmodel 导出
 * - uasset 缺失/server 不可用时返回零值，不再回退 FModel 预导出 .json
 *
 * fmodel 返回 FModel 同构数组 [{ Type, Properties }]，读 SlotAnimTracks / Notifies
 * 提取 cancel / combo / skillEffectLink / shootingInterval（对齐老 weapon 处理器）。
 *
 * 生命周期：每个 reader 通过 `acquireUAssetServer` 引用进程与共享 DuckDB；
 * `close()` 只释放引用，最后一个持有者关闭进程，但缓存由 CLI 退出时统一关闭。
 * fmodel 结果与解析结果按绝对路径做进程级 memo，跨模块去重 JSON.parse。
 */

import { existsSync, readdirSync } from "node:fs"
import { basename, join } from "node:path"
import {
    acquireUAssetServer,
    getExportsRoot,
    getUAssetServerStats,
    packagePathFor,
    releaseUAssetServer,
    type UAssetServer,
    type UAssetServerStats,
} from "./UAssetServer.ts"

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

// ---------- Montage / AnimSequence / AnimBlueprint 解析（纯函数，可单测） ----------

export interface MontageSection {
    name: string
    begin: number
    length: number
    next: string | null
    sequence: string | null
}

export interface MontageSegment {
    slot: string | null
    sequence: string | null
    start: number
    end: number
    rate: number
    startPos: number
    loopingCount: number
}

export interface NotifyPayload {
    /** fmodel 导出数组下标（与资产 export index 一致） */
    index: number
    class: string
    export: string
    properties: Record<string, unknown>
}

export interface MontageNotify {
    name: string
    /** 触发时间（秒），取 notify LinkValue */
    time: number
    duration: number
    endTime: number | null
    trackIndex: number | null
    /** True 表示 NotifyStateClass（有持续时间），False 表示瞬时 Notify */
    state: boolean
    payload: NotifyPayload | null
    /** 所有匹配到的 notify 类 export 下标；显式 ObjectPath 引用时为单元素 */
    payloadMatches: number[]
    /** payload 的关联依据：`objectPath` 为资产内显式引用，`name` 为 NotifyName 归一化匹配 */
    payloadSource: "objectPath" | "name" | null
    /** 多个候选时全部保留并标注，不做猜测 */
    payloadAmbiguous?: boolean
    payloads?: NotifyPayload[]
}

export interface MontageBranchingPoint {
    notifyIndex: number
    time: number
    type: string
}

export interface MontageTimeline {
    /** 包路径（相对 Exports 根，如 EM/Content/Asset/...） */
    asset: string
    length: number | null
    sections: MontageSection[]
    segments: MontageSegment[]
    notifies: MontageNotify[]
    branchingPoints: MontageBranchingPoint[]
}

export interface SequenceNotify {
    name: string
    time: number
    duration: number
}

export interface SequenceMeta {
    asset: string
    length: number | null
    frames: number | null
    /** 帧率 = frames / length（资产不单独存 fps） */
    fps: number | null
    rootMotion: boolean
    skeleton: string | null
    notifies: SequenceNotify[]
}

export interface AnimGraphNode {
    /** AnimGraphNode_* 节点类型（由 CDO 属性名前缀得到） */
    node: string
    /** CDO 属性名，如 AnimGraphNode_SequencePlayer_192 */
    name: string
    properties: Record<string, unknown>
}

export interface AnimBPInfo {
    asset: string
    className: string | null
    targetSkeleton: string | null
    syncGroupNames: string[]
    linkedLayerClass: string | null
    /** BakedStateMachines 原样结构；缺失时为空数组并在 unavailable 说明原因 */
    stateMachines: unknown[]
    stateMachinesUnavailable?: string
    graph: AnimGraphNode[]
}

function asExportArray(data: unknown): any[] {
    if (Array.isArray(data)) return data as any[]
    if (data && typeof data === "object") return [data as any]
    return []
}

function findExport(arr: any[], type: string): any | null {
    return arr.find(item => item && typeof item === "object" && item.Type === type) ?? null
}

function propsOf(entry: any): Record<string, any> {
    const props = entry?.Properties
    return props && typeof props === "object" ? props : {}
}

/** ObjectPath 去掉末尾 `.0` 形式的 export 下标，得到包路径。 */
export function packagePathFromObjectPath(objectPath: unknown): string | null {
    if (typeof objectPath !== "string" || !objectPath) return null
    return objectPath.replace(/\.\d+$/, "")
}

/** ObjectPath 末尾的下标（`<package>.<exportIndex>`）。 */
function exportIndexOfObjectPath(objectPath: unknown): number | null {
    if (typeof objectPath !== "string") return null
    const match = objectPath.match(/\.(\d+)$/)
    return match ? Number(match[1]) : null
}

function numberOrNull(value: unknown): number | null {
    const num = toNum(value)
    return num !== null && Number.isFinite(num) ? num : null
}

function payloadAt(exports: any[], index: number): NotifyPayload | null {
    const entry = exports[index]
    if (!entry || typeof entry !== "object") return null
    return {
        index,
        class: String(entry.Type ?? ""),
        export: String(entry.Name ?? ""),
        properties: propsOf(entry),
    }
}

/**
 * notify 名称归一化：Montage 里的 `NotifyName` 是 notify 类的短名（`BP_Sound_C`），
 * 而资产导出名是类名（`BP_AnimNotify_Sound_C` / `BP_AnimNotifyState_Sound_C`）。
 * 只剥除引擎/蓝图固定的 `BP_` 与 `AnimNotify(State)_` 前缀，不做模糊匹配。
 */
function normalizedNotifyName(name: string): string {
    return name
        .replace(/^(?:BP_)?AnimNotifyState_/, "")
        .replace(/^(?:BP_)?AnimNotify_/, "")
        .replace(/^BP_/, "")
}

function resolveNotifyPayload(
    exports: any[],
    notify: Record<string, any>
): {
    payload: NotifyPayload | null
    matches: number[]
    source: "objectPath" | "name" | null
    ambiguous?: boolean
    payloads?: NotifyPayload[]
} {
    const ref = notify.Notify ?? notify.NotifyStateClass
    const index = exportIndexOfObjectPath(ref?.ObjectPath)
    if (index !== null && index > 0 && index < exports.length) {
        const payload = payloadAt(exports, index)
        if (payload) return { payload, matches: [index], source: "objectPath" }
    }
    // 没有可用的显式下标时，按归一化后的 notify 类名匹配；多候选时全部保留，不选第一个。
    const name = String(notify.NotifyName ?? "")
    if (!name) return { payload: null, matches: [], source: null }
    const target = normalizedNotifyName(name)
    const matches: number[] = []
    for (let i = 1; i < exports.length; i++) {
        const entry = exports[i]
        if (!entry || typeof entry !== "object") continue
        const exportType = String(entry.Type ?? "")
        const exportName = String(entry.Name ?? "")
        if (
            exportType === name ||
            exportName === name ||
            exportName.startsWith(`${name}_`) ||
            normalizedNotifyName(exportType) === target ||
            normalizedNotifyName(exportName.replace(/_\d+$/, "")) === target
        ) {
            matches.push(i)
        }
    }
    if (matches.length === 1) {
        const payload = payloadAt(exports, matches[0]!)
        return payload ? { payload, matches, source: "name" } : { payload: null, matches: [], source: null }
    }
    if (matches.length > 1) {
        const payloads = matches.map(i => payloadAt(exports, i)).filter((item): item is NotifyPayload => item !== null)
        return { payload: null, matches, source: "name", ambiguous: true, payloads }
    }
    return { payload: null, matches: [], source: null }
}

/** 解析 AnimMontage 时间轴（sections/segments/notifies + notify payload/branching points）。 */
export function montageTimelineFromFModelData(data: unknown): MontageTimeline | null {
    const exports = asExportArray(data)
    const montage = findExport(exports, "AnimMontage")
    if (!montage) return null
    const props = propsOf(montage)

    const sections: MontageSection[] = []
    for (const section of Array.isArray(props.CompositeSections) ? props.CompositeSections : []) {
        if (!section || typeof section !== "object") continue
        sections.push({
            name: String(section.SectionName ?? ""),
            begin: numberOrNull(section.SegmentBeginTime) ?? 0,
            length: numberOrNull(section.SegmentLength) ?? 0,
            next: section.NextSectionName ? String(section.NextSectionName) : null,
            sequence: packagePathFromObjectPath(section.LinkedSequence?.ObjectPath),
        })
    }

    const segments: MontageSegment[] = []
    for (const slot of Array.isArray(props.SlotAnimTracks) ? props.SlotAnimTracks : []) {
        if (!slot || typeof slot !== "object") continue
        const slotName = slot.SlotName ? String(slot.SlotName) : null
        for (const segment of Array.isArray(slot.AnimTrack?.AnimSegments) ? slot.AnimTrack.AnimSegments : []) {
            if (!segment || typeof segment !== "object") continue
            segments.push({
                slot: slotName,
                sequence: packagePathFromObjectPath(segment.AnimReference?.ObjectPath),
                start: numberOrNull(segment.AnimStartTime) ?? 0,
                end: numberOrNull(segment.AnimEndTime) ?? 0,
                rate: numberOrNull(segment.AnimPlayRate) ?? 1,
                startPos: numberOrNull(segment.StartPos) ?? 0,
                loopingCount: numberOrNull(segment.LoopingCount) ?? 0,
            })
        }
    }

    const notifies: MontageNotify[] = []
    for (const notify of Array.isArray(props.Notifies) ? props.Notifies : []) {
        if (!notify || typeof notify !== "object") continue
        const resolved = resolveNotifyPayload(exports, notify)
        const state = notify.NotifyStateClass !== undefined && notify.NotifyStateClass !== null
        const duration = numberOrNull(notify.Duration) ?? 0
        // 瞬时 notify 的 EndLink 是无效残留（常为 0），只在 state/EndLink 有意义时输出 endTime。
        const rawEnd = numberOrNull(notify.EndLink?.LinkValue)
        const time = numberOrNull(notify.LinkValue) ?? 0
        const endTime = state && rawEnd !== null && rawEnd >= time ? rawEnd : null
        const item: MontageNotify = {
            name: String(notify.NotifyName ?? ""),
            time,
            duration,
            endTime,
            trackIndex: numberOrNull(notify.TrackIndex),
            state,
            payload: resolved.payload,
            payloadMatches: resolved.matches,
            payloadSource: resolved.source,
        }
        if (resolved.ambiguous) item.payloadAmbiguous = true
        if (resolved.payloads) item.payloads = resolved.payloads
        notifies.push(item)
    }

    const branchingPoints: MontageBranchingPoint[] = []
    for (const point of Array.isArray(props.BranchingPointMarkers) ? props.BranchingPointMarkers : []) {
        if (!point || typeof point !== "object") continue
        branchingPoints.push({
            notifyIndex: numberOrNull(point.NotifyIndex) ?? 0,
            time: numberOrNull(point.TriggerTime) ?? 0,
            type: String(point.NotifyEventType ?? ""),
        })
    }

    return {
        asset: String(montage.Package ?? ""),
        length: numberOrNull(props.SequenceLength),
        sections,
        segments,
        notifies,
        branchingPoints,
    }
}

/** 解析 AnimSequence 元数据（无关键帧/曲线）。 */
export function sequenceMetaFromFModelData(data: unknown): SequenceMeta | null {
    const exports = asExportArray(data)
    const sequence = findExport(exports, "AnimSequence")
    if (!sequence) return null
    const props = propsOf(sequence)
    const length = numberOrNull(props.SequenceLength)
    const frames = numberOrNull(props.NumFrames)
    const notifies: SequenceNotify[] = []
    for (const notify of Array.isArray(props.Notifies) ? props.Notifies : []) {
        if (!notify || typeof notify !== "object") continue
        notifies.push({
            name: String(notify.NotifyName ?? ""),
            time: numberOrNull(notify.LinkValue) ?? 0,
            duration: numberOrNull(notify.Duration) ?? 0,
        })
    }
    return {
        asset: String(sequence.Package ?? ""),
        length,
        frames,
        fps: length !== null && length > 0 && frames !== null ? frames / length : null,
        rootMotion: props.bEnableRootMotion === true,
        skeleton: packagePathFromObjectPath(props.Skeleton?.ObjectPath),
        notifies,
    }
}

/** 解析 AnimBlueprint（CDO 上的 AnimGraphNode_* 属性；BakedStateMachines 缺失时显式说明）。 */
export function animBPFromFModelData(data: unknown): AnimBPInfo | null {
    const exports = asExportArray(data)
    const classExport = findExport(exports, "AnimBlueprintGeneratedClass")
    if (!classExport) return null
    const classProps = propsOf(classExport)
    const className = String(classExport.Name ?? "")
    const generatedClassName = className
    const cdo =
        exports.find(entry => entry && typeof entry === "object" && String(entry.Name ?? "").startsWith("Default__")) ??
        exports.find(
            entry =>
                entry &&
                typeof entry === "object" &&
                generatedClassName &&
                String(entry.Type ?? "") === generatedClassName &&
                Object.keys(propsOf(entry)).some(key => key.startsWith("AnimGraphNode_"))
        ) ??
        null
    const cdoProps = propsOf(cdo)

    const graph: AnimGraphNode[] = []
    for (const [name, properties] of Object.entries(cdoProps)) {
        if (!name.startsWith("AnimGraphNode_")) continue
        const node = name.replace(/_\d+$/, "")
        graph.push({
            node,
            name,
            properties: properties && typeof properties === "object" ? (properties as Record<string, unknown>) : {},
        })
    }

    const baked = classProps.BakedStateMachines ?? cdoProps.BakedStateMachines
    const stateMachines = Array.isArray(baked) ? baked : []
    const info: AnimBPInfo = {
        asset: String(classExport.Package ?? ""),
        className,
        targetSkeleton: packagePathFromObjectPath(classProps.TargetSkeleton?.ObjectPath),
        syncGroupNames: Array.isArray(classProps.SyncGroupNames) ? classProps.SyncGroupNames.map(String) : [],
        linkedLayerClass: cdoProps.LinkLayerClass ? packagePathFromObjectPath(cdoProps.LinkLayerClass.ObjectPath) : null,
        stateMachines,
        graph,
    }
    if (baked === undefined || baked === null) {
        info.stateMachinesUnavailable = "BakedStateMachines is not serialized by UAssetAPI for cooked AnimBlueprintGeneratedClass"
    }
    return info
}

/** `/Game/...` 或 `Class'/Game/...'` 形式的引用 → 解包目录中的 .uasset 绝对路径。 */
export function assetPathFromGamePath(gamePath: unknown, exportsRoot: string): string | null {
    if (typeof gamePath !== "string") return null
    const stripped = gamePath
        .trim()
        .replace(/^[A-Za-z_]+'/, "")
        .replace(/'$/, "")
    const marker = "/Game/"
    const index = stripped.indexOf(marker)
    if (index < 0) return null
    const tail = stripped.slice(index + marker.length)
    const packagePath = tail.split(".")[0]
    if (!packagePath) return null
    return `${join(exportsRoot, "EM", "Content", ...packagePath.split("/").filter(Boolean))}.uasset`
}

/** ObjectPath（`EM/Content/...Name.0`）→ 解包目录中的 .uasset 绝对路径。 */
export function assetPathFromObjectPath(objectPath: unknown, exportsRoot: string): string | null {
    const packagePath = packagePathFromObjectPath(objectPath)
    if (!packagePath) return null
    return `${join(exportsRoot, ...packagePath.split("/").filter(Boolean))}.uasset`
}

// ---------- 读取结果（成功/失败原因） ----------

/** fmodel 读取结果：失败时 `error` 给出真实原因，调用方写入覆盖清单。 */
export interface FModelReadResult {
    data: unknown[] | null
    error: string | null
}

export interface MontageReadResult {
    timeline: MontageTimeline | null
    error: string | null
}

export interface SequenceReadResult {
    meta: SequenceMeta | null
    error: string | null
}

export interface AnimBPReadResult {
    info: AnimBPInfo | null
    error: string | null
}

// ---------- 进程级 memo（跨 Char/Weapon/Mod/SkillAsset 共享） ----------

const fmodelMemo = new Map<string, unknown[]>()
const animMetaMemo = new Map<string, AnimMeta>()
const montageMemo = new Map<string, MontageTimeline>()
const sequenceMemo = new Map<string, SequenceMeta>()
const animBPMemo = new Map<string, AnimBPInfo>()

/**
 * AssetReader：解析解包目录、启动 uasset server、按节点读动画元数据（uasset 优先，json 回退）。
 * 带按 uasset/json 路径的元数据缓存。
 */
export class AssetReader {
    private server: UAssetServer | null = null
    private exportsRoot: string | null = null
    private metaCache = new Map<string, AnimMeta>()
    private fmodelCache = new Map<string, FModelReadResult>()
    private closed = false

    constructor(
        /** 数据根（LuaDataManager.root）；uasset 路径由 DNA_UNPACK_DIR 决定 */
        readonly root: string,
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
            this.server = await acquireUAssetServer()
        } catch {
            this.server = null
        }
        return this.server
    }

    async close(): Promise<void> {
        if (this.closed) return
        this.closed = true
        if (this.server) {
            const server = this.server
            this.server = null
            try {
                await releaseUAssetServer(server)
            } catch {
                /* ignore */
            }
        }
    }

    /** 进程级缓存统计（含其他模块的请求）。 */
    stats(): UAssetServerStats {
        return getUAssetServerStats()
    }

    /**
     * 按路径读取一个 BP/uasset 的 FModel 结构。
     * server 只在第一次真正请求资产时启动；结果按绝对路径做进程级缓存。
     * 该接口不读取同名 JSON，调用方需要明确处理 server 不可用的情况。
     */
    async readFModelAsset(assetPath: string): Promise<unknown[] | null> {
        return (await this.readFModelResult(assetPath)).data
    }

    /** 同 `readFModelAsset`，但保留失败原因（供新模块写入覆盖清单）。 */
    async readFModelResult(assetPath: string): Promise<FModelReadResult> {
        const key = assetPath.replace(/\\/g, "/")
        const memo = fmodelMemo.get(key)
        if (memo) return { data: memo, error: null }
        if (this.fmodelCache.has(key)) return this.fmodelCache.get(key)!
        let result: FModelReadResult
        if (!existsSync(assetPath)) {
            result = { data: null, error: "asset not found" }
        } else {
            const server = await this.ensureServer()
            if (!server || !this.exportsRoot) {
                result = { data: null, error: "DNA_UNPACK_DIR/Fmodel/Output/Exports unavailable" }
            } else {
                try {
                    const data = await server.fmodel(assetPath, this.exportsRoot)
                    result = data ? { data, error: null } : { data: null, error: "UAssetCLI fmodel returned no result" }
                } catch (error) {
                    result = { data: null, error: error instanceof Error ? error.message : String(error) }
                }
            }
        }
        this.fmodelCache.set(key, result)
        if (result.data) fmodelMemo.set(key, result.data)
        return result
    }

    /** 读 Montage 时间轴；失败原因通过 `error` 返回，由调用方写入覆盖清单。 */
    async readMontageTimeline(assetPath: string): Promise<MontageReadResult> {
        const key = assetPath.replace(/\\/g, "/")
        const memo = montageMemo.get(key)
        if (memo) return { timeline: memo, error: null }
        const read = await this.readFModelResult(assetPath)
        if (!read.data) return { timeline: null, error: read.error }
        const timeline = montageTimelineFromFModelData(read.data)
        if (!timeline) return { timeline: null, error: "no AnimMontage export" }
        if (this.exportsRoot) timeline.asset = packagePathFor(assetPath, this.exportsRoot)
        montageMemo.set(key, timeline)
        return { timeline, error: null }
    }

    /** 读 AnimSequence 元数据。 */
    async readSequence(assetPath: string): Promise<SequenceReadResult> {
        const key = assetPath.replace(/\\/g, "/")
        const memo = sequenceMemo.get(key)
        if (memo) return { meta: memo, error: null }
        const read = await this.readFModelResult(assetPath)
        if (!read.data) return { meta: null, error: read.error }
        const meta = sequenceMetaFromFModelData(read.data)
        if (!meta) return { meta: null, error: "no AnimSequence export" }
        if (this.exportsRoot) meta.asset = packagePathFor(assetPath, this.exportsRoot)
        sequenceMemo.set(key, meta)
        return { meta, error: null }
    }

    /** 读 AnimBlueprint（CDO 图节点；无 BakedStateMachines 时在结果中说明）。 */
    async readAnimBP(assetPath: string): Promise<AnimBPReadResult> {
        const key = assetPath.replace(/\\/g, "/")
        const memo = animBPMemo.get(key)
        if (memo) return { info: memo, error: null }
        const read = await this.readFModelResult(assetPath)
        if (!read.data) return { info: null, error: read.error }
        const info = animBPFromFModelData(read.data)
        if (!info) return { info: null, error: "no AnimBlueprintGeneratedClass export" }
        if (this.exportsRoot) info.asset = packagePathFor(assetPath, this.exportsRoot)
        animBPMemo.set(key, info)
        return { info, error: null }
    }

    /**
     * 定位 SkillNode 的动画资产 .uasset 路径。返回第一个存在的候选；缺失返回 null。
     */
    private resolveNodeSources(node: Record<string, any>): string | null {
        const animResource = node.AnimResource || node.AnimName
        if (!animResource || !this.assetRoot) return null
        const animPath = node.AnimPath ?? ""
        const animSubPath = node.AnimSubPath ?? ""
        const root = this.assetRoot

        const candidates: string[] = []

        const normalized = String(animPath).replace(/\\/g, "/")
        const marker = "/Game/Asset/"
        if (normalized.includes(marker)) {
            const rel = normalized.split(marker)[1].replace(/^\/+|\/+$/g, "")
            candidates.push(`${join(root, ...rel.split("/").filter(Boolean), String(animResource))}.uasset`)
        }

        // AnimSubPath 兜底：Char/Player/*/Animation/Montage/<subpath>/<AnimResource>
        const subDir = String(animSubPath).replace(/\\/g, "/").split("/").filter(Boolean)
        const playersRoot = join(root, "Char", "Player")
        const prefixedCandidates: string[] = []
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
                    candidates.push(join(cur, `${animResource}.uasset`))
                    if (this.allowPrefixedName) {
                        for (const name of readdirSync(cur).sort()) {
                            if (!name.endsWith(`_${animResource}.uasset`)) continue
                            const base = join(cur, name.replace(/\.uasset$/i, ""))
                            if (!prefixedCandidates.some(candidate => candidate === `${base}.uasset`)) {
                                prefixedCandidates.push(`${base}.uasset`)
                            }
                        }
                    }
                }
            }
        } catch {
            /* ignore */
        }
        candidates.push(...prefixedCandidates)
        // 返回第一个存在的候选
        for (const c of candidates) {
            if (existsSync(c)) return c
        }
        return null
    }

    /**
     * 读一个 SkillNode 的动画元数据（UAssetCLI server 直读 .uasset）。带缓存。
     * 资产缺失或 server 不可用时返回零值（保持既有错误语义）。
     */
    async animMetaForNode(node: Record<string, any>): Promise<AnimMeta> {
        const uasset = this.resolveNodeSources(node)
        if (uasset) {
            const key = uasset.replace(/\\/g, "/")
            const shared = animMetaMemo.get(key)
            if (shared) return shared
            const cached = this.metaCache.get(uasset)
            if (cached) return cached
            const read = await this.readFModelResult(uasset)
            if (read.data) {
                const meta = animMetaFromFModelData(read.data)
                this.metaCache.set(uasset, meta)
                animMetaMemo.set(key, meta)
                return meta
            }
        }
        return { ...EMPTY }
    }

    /** 指示是否真正使用 uasset 源（供日志） */
    get source(): "uasset" | "none" {
        if (this.server) return "uasset"
        return "none"
    }
}

export { basename }
