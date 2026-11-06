/**
 * SkillNode 全量表与技能变体根节点（skill-behavior 扩展）。
 *
 * 变体只按数据里的显式字段建立：
 * - 技能自身 `BeginNodeId` → 默认变体（`isDefault: true`）；
 * - `SubSkills` 中每个子技能自身的 `BeginNodeId` → 候选变体；
 * - `SubSkills` 中存在与 `LongPressSkill` 相同的子技能 id 时，该子技能贡献的节点
 *   标记 `trigger: "longPress"`。这里只记录原始字段对应关系，不推断点按/长按语义。
 *
 * 子技能没有 `BeginNodeId` 或节点行缺失时不补造节点；缺口由调用方写入 coverage。
 * 节点链（NextNodeId/BranchNodeIds）属于节点内部遍历，不是变体入口，故此处不展开。
 */
import { getSkillEntry } from "../skillBehavior/behaviorChain.ts"
import type { SkillNodeEntry, SkillRowRef, SkillVariant } from "./types.ts"

/** 读取自 Lua SkillNode 表的一行（内部形态；导出时投影为 SkillNodeEntry）。 */
export interface SkillNodeRow {
    nodeId: number
    costSp: number | null
    animPath: string | null
    animResource: string | null
    animName: string | null
    animSubPath: string | null
    animPlayRate: number | null
    effects: number[]
}

export interface SkillVariantRoot {
    nodeId: number
    isDefault: boolean
    trigger: "longPress" | null
}

export interface SkillVariantPlan {
    skillRow: SkillRowRef
    roots: SkillVariantRoot[]
    /** SubSkills 中查不到 Skill 行的 id；原样记录，不补造节点 */
    missingSubSkillIds: number[]
}

export interface SkillVariantResult {
    variants: SkillVariant[]
    /** 变体根节点在 SkillNode 表中缺行的 id */
    missingNodeIds: number[]
}

function asRecord(value: unknown): Record<string, any> | null {
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Record<string, any>) : null
}

function asString(value: unknown): string | null {
    return value === null || value === undefined || value === "" ? null : String(value)
}

function asNumber(value: unknown): number | null {
    if (value === null || value === undefined || value === "") return null
    const num = Number(value)
    return Number.isFinite(num) ? num : null
}

/** 数组 / 1 起始 map / 单值 → 去重的数字 id 列表（保留原始顺序）。 */
function toIdList(value: unknown): number[] {
    if (value === null || value === undefined || value === "") return []
    const list = Array.isArray(value) ? value : typeof value === "object" ? Object.values(value) : [value]
    const out: number[] = []
    for (const item of list) {
        const num = Number(item)
        if (Number.isFinite(num) && !out.includes(num)) out.push(num)
    }
    return out
}

/** 读取整张 SkillNode 表；按 NodeId 升序返回，键与 `NodeId` 字段不一致时以 `NodeId` 为准。 */
export function collectSkillNodeRows(dm: { getTable(name: string): unknown }): Map<number, SkillNodeRow> {
    const table = dm.getTable("SkillNode")
    const entries: Array<[string, unknown]> = Array.isArray(table)
        ? table.map((value, index) => [String(index + 1), value])
        : table && typeof table === "object"
          ? Object.entries(table as Record<string, unknown>)
          : []
    const rows = new Map<number, SkillNodeRow>()
    for (const [key, value] of entries) {
        const raw = asRecord(value)
        if (!raw) continue
        const nodeId = asNumber(raw.NodeId) ?? Number(key)
        if (!Number.isFinite(nodeId) || rows.has(nodeId)) continue
        rows.set(nodeId, {
            nodeId,
            costSp: asNumber(raw.CostSp),
            animPath: asString(raw.AnimPath),
            animResource: asString(raw.AnimResource),
            animName: asString(raw.AnimName),
            animSubPath: asString(raw.AnimSubPath),
            animPlayRate: asNumber(raw.AnimPlayRate),
            effects: toIdList(raw.SkillNodeEffects),
        })
    }
    return new Map([...rows.entries()].sort(([a], [b]) => a - b))
}

/** 投影为导出形态：只保留稳定的原始字段。 */
export function toSkillNodeEntries(rows: Map<number, SkillNodeRow>): Record<string, SkillNodeEntry> {
    const out: Record<string, SkillNodeEntry> = {}
    for (const row of rows.values()) {
        out[String(row.nodeId)] = {
            nodeId: row.nodeId,
            costSp: row.costSp,
            animPath: row.animPath,
            animResource: row.animResource,
            animPlayRate: row.animPlayRate,
            effects: [...row.effects],
        }
    }
    return out
}

/** 从技能行归纳变体根节点；同一节点被默认与子技能同时指向时合并为一项。 */
export function planSkillVariants(
    dm: { getTableItem(table: string, id: number | string): unknown },
    entry: Record<string, any>
): SkillVariantPlan {
    const beginNodeId = asNumber(entry.BeginNodeId)
    const subSkills = toIdList(entry.SubSkills)
    const longPressSkill = asNumber(entry.LongPressSkill)
    const skillRow: SkillRowRef = {
        beginNodeId,
        subSkills,
        longPressSkill,
        skillBtnIcon: asString(entry.SkillBtnIcon),
    }

    const roots: SkillVariantRoot[] = []
    const byNodeId = new Map<number, SkillVariantRoot>()
    const addRoot = (nodeId: number, isDefault: boolean, trigger: "longPress" | null): void => {
        const existing = byNodeId.get(nodeId)
        if (existing) {
            if (isDefault) existing.isDefault = true
            if (trigger && !existing.trigger) existing.trigger = trigger
            return
        }
        const root: SkillVariantRoot = { nodeId, isDefault, trigger }
        byNodeId.set(nodeId, root)
        roots.push(root)
    }

    if (beginNodeId !== null) addRoot(beginNodeId, true, null)

    const missingSubSkillIds: number[] = []
    for (const subSkillId of subSkills) {
        const subEntry = getSkillEntry(dm as any, subSkillId)
        if (!subEntry) {
            missingSubSkillIds.push(subSkillId)
            continue
        }
        const subBeginNodeId = asNumber(subEntry.BeginNodeId)
        if (subBeginNodeId === null) continue
        // 只按子技能 id 与 LongPressSkill 的相等关系打标；不能拿节点 id 比较（两者数值域重叠）。
        addRoot(subBeginNodeId, false, subSkillId === longPressSkill ? "longPress" : null)
    }

    return { skillRow, roots, missingSubSkillIds }
}

/** 把变体根节点落到 SkillNode 行；缺行只记录，不生成空变体。 */
export function buildSkillVariants(
    rows: Map<number, SkillNodeRow>,
    plan: SkillVariantPlan,
    resolveMontage: (row: SkillNodeRow) => string | null
): SkillVariantResult {
    const variants: SkillVariant[] = []
    const missingNodeIds: number[] = []
    for (const root of plan.roots) {
        const row = rows.get(root.nodeId)
        if (!row) {
            missingNodeIds.push(root.nodeId)
            continue
        }
        const variant: SkillVariant = {
            nodeId: row.nodeId,
            costSp: row.costSp,
            montage: resolveMontage(row),
            effects: [...row.effects],
            isDefault: root.isDefault,
        }
        if (root.trigger) variant.trigger = root.trigger
        variants.push(variant)
    }
    return { variants, missingNodeIds }
}
