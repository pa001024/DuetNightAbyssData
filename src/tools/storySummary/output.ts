/**
 * storysummary 输出 —— final/i18n/cn/storySummary.json 是“已生成总结”的唯一权威来源：
 * 链是否已生成、总结正文是什么，都以它为准（.cache 账本只记指纹，不参与决策正文）。
 *
 * 结构为 { "<链id>": "<总结>" } 的对象（按数字 id 升序），只包含当前数据里仍含对白、
 * 且已有总结的链。格式对齐 OutputCollector：JSON.stringify(..., null, 2) + 换行。
 */
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs"
import { dirname } from "node:path"

/** 读取已提交的 cn 输出（结构为 id → 总结正文）：已生成总结的唯一权威 */
export function readStorySummaryOutput(file: string): Record<string, string> {
    if (!existsSync(file)) return {}
    const parsed = JSON.parse(readFileSync(file, "utf8")) as unknown
    if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
        throw new Error(`storySummary.json 格式非法: ${file}`)
    }
    const result: Record<string, string> = {}
    for (const [key, value] of Object.entries(parsed as Record<string, unknown>)) {
        if (typeof value === "string" && value.trim()) result[key] = value
    }
    return result
}

export function buildOutputObject(summaries: Record<string, string>, eligibleIds: ReadonlySet<number>): Record<string, string> {
    const ids = [...eligibleIds].filter(id => summaries[String(id)]?.trim()).sort((a, b) => a - b)
    const output: Record<string, string> = {}
    for (const id of ids) output[String(id)] = summaries[String(id)]
    return output
}

export function writeStorySummaryOutput(file: string, summaries: Record<string, string>, eligibleIds: ReadonlySet<number>): number {
    mkdirSync(dirname(file), { recursive: true })
    const output = buildOutputObject(summaries, eligibleIds)
    writeFileSync(file, `${JSON.stringify(output, null, 2)}\n`, "utf8")
    return Object.keys(output).length
}
