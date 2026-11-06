/**
 * SkillGrow 等级序列读取。
 *
 * `SkillGrow[分区][id]` 有两种外层形态（真实数据同时存在）：
 * - 数组：`[[{Index,Level,Value}, ...], [{...}], ...]`，外层每项是一级的行数组；
 * - 对象：`{"0":[...], "1":[...]}`（`GlobalPassiveData`），键是等级。
 *
 * 两种形态统一按 `Index` 分组、按 `Level` 升序。缺失或没有有效行时返回 null，
 * 不补造数值；数值可能是数字或 `"#N"` 形式的字符串，原样保留。
 */
import type { GrowRow, GrowRows } from "./types.ts"

function asRecord(value: unknown): Record<string, unknown> | null {
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Record<string, unknown>) : null
}

function collectLevelEntries(value: unknown, out: unknown[]): void {
    if (Array.isArray(value)) {
        // 外层数组：可能是「每级 → 行数组」，也可能是「行数组」。
        for (const item of value) {
            if (Array.isArray(item)) {
                for (const row of item) out.push(row)
            } else if (item && typeof item === "object") {
                out.push(item)
            }
        }
        return
    }
    const record = asRecord(value)
    if (!record) return
    for (const item of Object.values(record)) {
        if (Array.isArray(item)) {
            for (const row of item) out.push(row)
        } else if (item && typeof item === "object") {
            out.push(item)
        }
    }
}

/** 把 `SkillGrow` 的单个 id 行归一化为 `Index → 等级序列`；无有效行返回 null。 */
export function readGrowRows(value: unknown): GrowRows | null {
    if (value === undefined || value === null) return null
    const levelEntries: unknown[] = []
    collectLevelEntries(value, levelEntries)

    const grouped = new Map<string, Map<number, GrowRow>>()
    for (const item of levelEntries) {
        const row = asRecord(item)
        if (!row) continue
        const index = Number(row.Index)
        const level = Number(row.Level)
        const value = row.Value
        if (!Number.isFinite(index) || !Number.isFinite(level)) continue
        if (typeof value !== "number" && typeof value !== "string") continue
        const key = String(index)
        const levels = grouped.get(key) ?? new Map<number, GrowRow>()
        // 同一 Index+Level 重复时保留首次出现的行，顺序稳定。
        if (!levels.has(level)) levels.set(level, { level, value })
        grouped.set(key, levels)
    }
    if (grouped.size === 0) return null

    const result: GrowRows = {}
    for (const key of [...grouped.keys()].sort((a, b) => Number(a) - Number(b))) {
        const levels = grouped.get(key)!
        result[key] = [...levels.values()].sort((a, b) => a.level - b.level)
    }
    return result
}
