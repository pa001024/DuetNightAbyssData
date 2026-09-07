/**
 * storysummary 输出 —— 从状态（manifest）派生出 final/i18n/cn/storySummary.json。
 *
 * 结构为 { "<链id>": "<总结>" } 的对象（按数字 id 升序），只包含当前数据里仍含对白、
 * 且已有总结的链。格式对齐 OutputCollector：JSON.stringify(..., null, 2) + 换行。
 */
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs"
import { dirname } from "node:path"
import type { StoryState } from "./state.ts"

export function buildOutputObject(state: StoryState, eligibleIds: ReadonlySet<number>): Record<string, string> {
    const ids = [...eligibleIds].filter(id => state[String(id)]?.summary).sort((a, b) => a - b)
    const output: Record<string, string> = {}
    for (const id of ids) output[String(id)] = state[String(id)].summary
    return output
}

export function writeStorySummaryOutput(file: string, state: StoryState, eligibleIds: ReadonlySet<number>): number {
    mkdirSync(dirname(file), { recursive: true })
    const output = buildOutputObject(state, eligibleIds)
    writeFileSync(file, `${JSON.stringify(output, null, 2)}\n`, "utf8")
    return Object.keys(output).length
}

/** 读取已提交的 cn 输出（结构为 id → summary），用于 manifest 缺失时的回灌 */
export function readStorySummaryOutput(file: string): StoryState {
    if (!existsSync(file)) return {}
    const parsed = JSON.parse(readFileSync(file, "utf8")) as unknown
    if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
        throw new Error(`storySummary.json 格式非法: ${file}`)
    }
    const result: StoryState = {}
    for (const [key, value] of Object.entries(parsed as Record<string, unknown>)) {
        if (typeof value === "string" && value) {
            result[key] = { summary: value, fingerprint: "", updatedAt: "" }
        }
    }
    return result
}
