/**
 * 技能链证据收集 — 遍历契约与 char/behaviorChain.ts 保持一致：
 * - 入口 BeginNodeId，沿 NextNodeId 最多 8 个主节点；
 * - 分支（BranchNodeIds/ChildNodeIds）沿 NextNodeId，总节点数上限 64；
 * - TaskEffects 的 SkillEffect/EffectIds 递归进入，effect 去重。
 *
 * 差异只在产物：这里收集节点/effect/Buff/PassiveEffect/动画引用原始数据，
 * 不生成中文行为文本。
 */
import { getSkillEntry, normalizeMapOrArray } from "../char/behaviorChain.ts"
import type { SkillEffectEvidence, SkillNodeEvidence } from "./types.ts"

export interface EvidenceTables {
    skillNode(id: number | string): Record<string, any> | undefined
    skillEffect(id: number | string): Record<string, any> | undefined
    passiveEffect(id: number | string): Record<string, any> | undefined
    /** BPAddBuff.json（BP 名 → Buff id 列表） */
    bpAddBuff: Record<string, number[]>
}

export interface SkillEvidence {
    skillId: number
    entry: Record<string, any>
    beginNodeId: number | null
    nodes: SkillNodeEvidence[]
    effects: SkillEffectEvidence[]
    buffIds: number[]
    passiveIds: number[]
    passiveEffectBPs: Array<{ id: number; path: string | null }>
}

function asIdList(value: unknown): number[] {
    if (value === null || value === undefined || value === "") return []
    const list = Array.isArray(value) ? value : [value]
    const out: number[] = []
    for (const item of list) {
        const num = Number(item)
        if (Number.isFinite(num) && !out.includes(num)) out.push(num)
    }
    return out
}

function notifyNamesOf(effect: Record<string, any>): string[] {
    const value = effect.NotifyName
    if (value === null || value === undefined || value === "") return []
    const list = Array.isArray(value) ? value : [value]
    return list.map(item => String(item)).filter(Boolean)
}

function bpNameOf(path: string | null): string {
    if (!path) return ""
    return path.split("/").pop()?.split(".")[0] ?? ""
}

/** 收集一个技能的可达链证据；技能条目不存在时返回 null。 */
export function collectSkillEvidence(
    dm: { getTableItem(table: string, id: number | string): unknown },
    skillId: number,
    tables: EvidenceTables
): SkillEvidence | null {
    const entry = getSkillEntry(dm as any, skillId)
    if (!entry) return null

    const nodes: SkillNodeEvidence[] = []
    const effects: SkillEffectEvidence[] = []
    const buffIds: number[] = []
    const passiveIds: number[] = []
    const passiveEffectBPs: Array<{ id: number; path: string | null }> = []
    const seenNodes = new Set<string>()
    const seenEffects = new Set<string>()

    const addBuff = (id: number) => {
        if (!buffIds.includes(id)) buffIds.push(id)
    }
    const addPassive = (id: number) => {
        if (!passiveIds.includes(id)) passiveIds.push(id)
    }

    const walkEffect = (rawId: unknown): void => {
        const num = Number(rawId)
        if (!Number.isFinite(num)) return
        const key = String(num)
        if (seenEffects.has(key)) return
        seenEffects.add(key)
        const effect = tables.skillEffect(key)
        if (!effect || typeof effect !== "object") return
        const evidence: SkillEffectEvidence = { id: num, notifyNames: notifyNamesOf(effect), raw: effect }
        effects.push(evidence)

        for (const task of Array.isArray(effect.TaskEffects) ? effect.TaskEffects : []) {
            if (!task || typeof task !== "object") continue
            if (task.BuffId !== undefined && task.BuffId !== null && task.BuffId !== "") addBuff(Number(task.BuffId))
            if (task.PassiveEffectId !== undefined && task.PassiveEffectId !== null && task.PassiveEffectId !== "") {
                addPassive(Number(task.PassiveEffectId))
            }
            for (const childKey of ["SkillEffect", "EffectIds"] as const) {
                const children = task[childKey]
                if (children === null || children === undefined || children === "") continue
                for (const child of Array.isArray(children) ? children : [children]) walkEffect(child)
            }
        }
    }

    const walkNode = (rawId: unknown): void => {
        const num = Number(rawId)
        if (!Number.isFinite(num) || seenNodes.has(String(num))) return
        seenNodes.add(String(num))
        const node = tables.skillNode(num)
        if (!node || typeof node !== "object") return
        const effectIds = asIdList(node.SkillNodeEffects)
        for (const effectId of effectIds) walkEffect(effectId)
        const branchesValue = node.BranchNodeIds ?? node.ChildNodeIds
        nodes.push({
            id: num,
            animPath: node.AnimPath === undefined || node.AnimPath === null || node.AnimPath === "" ? null : String(node.AnimPath),
            animResource:
                node.AnimResource === undefined || node.AnimResource === null || node.AnimResource === ""
                    ? null
                    : String(node.AnimResource),
            animName: node.AnimName === undefined || node.AnimName === null || node.AnimName === "" ? null : String(node.AnimName),
            animSubPath:
                node.AnimSubPath === undefined || node.AnimSubPath === null || node.AnimSubPath === "" ? null : String(node.AnimSubPath),
            playRate: Number.isFinite(Number(node.AnimPlayRate)) ? Number(node.AnimPlayRate) : null,
            effects: effectIds,
            nextNodeId: node.NextNodeId === undefined || node.NextNodeId === null ? null : Number(node.NextNodeId),
            branchNodeIds: asIdList(branchesValue),
        })
    }

    // 与 behaviorChain 相同：主链在节点总数 < 8 时推进；分支与主链共享 64 个节点的总上限。
    let current: unknown = entry.BeginNodeId
    while (current !== undefined && current !== null && current !== "" && seenNodes.size < 8) {
        const before = seenNodes.size
        walkNode(current)
        if (seenNodes.size === before) break
        const node = tables.skillNode(Number(current))
        current = node?.NextNodeId
        const branchesValue = node?.BranchNodeIds ?? node?.ChildNodeIds
        const branchIds = Array.isArray(branchesValue)
            ? branchesValue
            : branchesValue && typeof branchesValue === "object"
              ? Object.values(branchesValue)
              : []
        for (const branchId of branchIds) {
            let branchNodeId: unknown = branchId
            let branchSteps = 0
            while (branchNodeId !== undefined && branchNodeId !== null && branchNodeId !== "" && branchSteps < 64 && seenNodes.size < 64) {
                const beforeBranch = seenNodes.size
                walkNode(branchNodeId)
                if (seenNodes.size === beforeBranch) break
                branchSteps++
                const branchNode = tables.skillNode(Number(branchNodeId))
                branchNodeId = branchNode?.NextNodeId
            }
        }
    }

    // 描述串引用（`$#SkillEffects[..]$` / `$#Buff[..]$` / `$#PassiveEffect[..]$`）
    for (const value of normalizeMapOrArray(entry.SkillDescValues)) {
        if (typeof value !== "string") continue
        for (const match of value.matchAll(/\$#SkillEffects\[(\d+)\]/g)) walkEffect(match[1])
        for (const match of value.matchAll(/\$#Buff\[(\d+)\]/g)) addBuff(Number(match[1]))
        for (const match of value.matchAll(/\$#PassiveEffect\[(\d+)\]/g)) addPassive(Number(match[1]))
    }

    for (const passiveId of asIdList(entry.PassiveEffects)) {
        addPassive(passiveId)
        const passive = tables.passiveEffect(passiveId)
        const path = passive && typeof passive === "object" && passive.BPPath ? String(passive.BPPath) : null
        passiveEffectBPs.push({ id: passiveId, path })
        // BPAddBuff 是静态映射：BP 名 → 额外的 Buff id（与行为链一致地并入可达 Buff）。
        for (const buffId of tables.bpAddBuff[bpNameOf(path)] ?? []) addBuff(Number(buffId))
    }

    return {
        skillId,
        entry,
        beginNodeId: entry.BeginNodeId === undefined || entry.BeginNodeId === null ? null : Number(entry.BeginNodeId),
        nodes,
        effects,
        buffIds: buffIds.filter(id => Number.isFinite(id)),
        passiveIds: passiveIds.filter(id => Number.isFinite(id)),
        passiveEffectBPs,
    }
}
