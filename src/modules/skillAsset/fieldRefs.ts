/**
 * 描述串字段引用解析（SkillDescValues → `#命名空间[id]路径`）。
 *
 * 描述串不是单一 `$#...$` 形态：真实数据里有 `$math.abs(#Buff[...])$`、
 * `$(#Buff[...])$`、`#TargetFilter[#SkillEffects[...]]` 等嵌套与函数包装，
 * 因此对整串做无锚点扫描，而不是匹配 `$...$` 块。
 *
 * 只有 `.TaskEffects[N].Rate` 这一形态被标记为伤害字段映射（填写 taskIndex /
 * rawTaskIndex）；其他路径只保留结构与原文，数值解释留给下游。
 * 缺行、task 越界与未知命名空间进入 unresolved，不静默跳过。
 */
import { normalizeMapOrArray } from "../skillBehavior/behaviorChain.ts"
import type { SkillFieldRef, SkillFieldRefGroup, UnresolvedRef } from "./types.ts"

/** 描述串里出现的命名空间；不在此集合的 `#Name[...]` 记为未知命名空间。 */
export const FIELD_REF_NAMESPACES: ReadonlySet<string> = new Set([
    "Buff",
    "EffectCreature",
    "GlobalPassiveData",
    "Monster",
    "PassiveEffect",
    "RayCreature",
    "Skill",
    "SkillCreature",
    "SkillEffects",
    "SkillNode",
    "TargetFilter",
])

const FIELD_REF_RE = /#([A-Za-z_][A-Za-z_0-9]*)\[(\d+)\]/g
/** `]` 之后可继续引用字段/索引，遇到 `*`、`/`、`)`、`$` 等运算符即停止。 */
const SUFFIX_RE = /^(?:(?:\.[A-Za-z_][A-Za-z_0-9]*)|(?:\[\d+\]))*/
const RATE_RE = /\.TaskEffects\[(\d+)\]\.Rate$/i
const DOT_RE = /\.DotDatas\[(\d+)\]/i

export interface FieldRefLookup {
    skillEffects(id: number): Record<string, unknown> | undefined
}

export interface FieldRefResult {
    groups: SkillFieldRefGroup[]
    total: number
    unresolved: UnresolvedRef[]
}

function asString(value: unknown): string | null {
    return typeof value === "string" && value !== "" ? value : null
}

/**
 * 解析单个技能的 SkillDescValues。
 * `descKeys` 与 `descValues` 同索引对齐；任一侧缺失时 descKey 为 null。
 */
export function extractFieldRefs(descKeys: unknown, descValues: unknown, lookup: FieldRefLookup, skillId: number): FieldRefResult {
    const values = normalizeMapOrArray(descValues)
    const keys = normalizeMapOrArray(descKeys)
    const groups: SkillFieldRefGroup[] = []
    const unresolved: UnresolvedRef[] = []
    let total = 0
    const issue = (kind: string, id: number, reason: string, detail?: string) => {
        unresolved.push({ kind, id, from: `skill:${skillId}`, reason, ...(detail === undefined ? {} : { detail }) })
    }

    for (let descIndex = 0; descIndex < values.length; descIndex++) {
        const value = values[descIndex]
        if (typeof value !== "string") continue
        const refs: SkillFieldRef[] = []
        const seen = new Set<string>()
        for (const match of value.matchAll(FIELD_REF_RE)) {
            const kind = match[1]!
            const id = Number(match[2])
            if (!Number.isFinite(id)) continue
            total++
            if (!FIELD_REF_NAMESPACES.has(kind)) issue(kind, id, "unknown-namespace", match[0])

            const suffix = value.slice((match.index ?? 0) + match[0].length).match(SUFFIX_RE)?.[0] ?? ""
            const path = suffix.replace(/^\./, "")
            const rate = suffix.match(RATE_RE)
            const dot = suffix.match(DOT_RE)

            let taskId: number | null = null
            let taskIndex: number | null = null
            let rawTaskIndex: number | null = null
            if (kind === "SkillEffects") {
                const effect = lookup.skillEffects(id)
                if (!effect) {
                    issue(kind, id, "missing-row")
                } else {
                    const rawTaskId = Number(effect.TaskId)
                    taskId = Number.isFinite(rawTaskId) ? rawTaskId : null
                }
                if (rate) {
                    rawTaskIndex = Number(rate[1])
                    taskIndex = rawTaskIndex - 1
                    if (effect) {
                        // TaskEffects 是 1 起始的 Lua 数组；越界就是引用断了，不截断、不修正。
                        const taskEffects = Array.isArray(effect.TaskEffects) ? effect.TaskEffects : null
                        if (!taskEffects || rawTaskIndex < 1 || rawTaskIndex > taskEffects.length) {
                            issue(
                                kind,
                                id,
                                "task-index-out-of-range",
                                `TaskEffects[${rawTaskIndex}] (count=${taskEffects ? taskEffects.length : 0})`
                            )
                        }
                    }
                }
            }

            const ref: SkillFieldRef = {
                kind,
                id,
                taskId,
                taskIndex,
                rawTaskIndex,
                dotIndex: dot ? Number(dot[1]) - 1 : null,
                path: path === "" ? null : path,
                raw: `${match[0]}${suffix}`,
            }
            const dedupeKey = [ref.kind, ref.id, ref.path, ref.taskIndex, ref.dotIndex, ref.raw].join("\u0000")
            if (seen.has(dedupeKey)) continue
            seen.add(dedupeKey)
            refs.push(ref)
        }
        if (refs.length > 0) {
            groups.push({ descIndex, descKey: asString(keys[descIndex]), refs })
        }
    }

    return { groups, total, unresolved }
}
