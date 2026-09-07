#!/usr/bin/env bun
/**
 * storysummary agent —— 独立 agent 工具：对每个含对白的 QuestChain 生成 AI 剧情总结。
 *
 * 设计要点：
 * - 与主流水线解耦，显式运行，默认 `bun out` 不会触发任何网络调用；
 * - 每次只生成“缺失/剧情内容已变化”的链（.cache/storysummary/state.json 记录指纹）；
 * - --dry-run 只报告待生成清单，不读取 API key、不发任何请求（测试用）；
 * - 上下文为链元数据 + 该链全部对白（来源：final/i18n/cn/QuestChain.json、QuestStory.json，
 *   由 `bun run src/cli.ts -f QuestChain QuestStory` 生成）；
 * - 输出 final/i18n/cn/storySummary.json = { "<链id>": "<中文总结>" }，仅含对白的链才生成。
 *
 * 环境变量（写入 .env）：
 *   STORY_SUMMARY_API_KEY / STORY_SUMMARY_BASE_URL（默认 https://api.openai.com/v1）/
 *   STORY_SUMMARY_MODEL（默认 gpt-4o-mini）/ STORY_SUMMARY_MAX_CHARS / STORY_SUMMARY_CONCURRENCY /
 *   STORY_SUMMARY_TIMEOUT_MS
 */
import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"
import { createChatClient, type GenerateResult } from "./client.ts"
import { buildPrompt, type ChainDigest, collectChainDigests, loadCnContext } from "./context.ts"
import { readStorySummaryOutput, writeStorySummaryOutput } from "./output.ts"
import { loadState, pendingChainIds, type StoryState, saveState } from "./state.ts"

type Log = (msg: string) => void

export const ENV = {
    API_KEY: "STORY_SUMMARY_API_KEY",
    BASE_URL: "STORY_SUMMARY_BASE_URL",
    MODEL: "STORY_SUMMARY_MODEL",
    MAX_CHARS: "STORY_SUMMARY_MAX_CHARS",
    CONCURRENCY: "STORY_SUMMARY_CONCURRENCY",
    TIMEOUT_MS: "STORY_SUMMARY_TIMEOUT_MS",
} as const

const DEFAULT_BASE_URL = "https://api.openai.com/v1"
const DEFAULT_MODEL = "gpt-4o-mini"
const DEFAULT_MAX_CHARS = 60_000
const DEFAULT_CONCURRENCY = 1
const DEFAULT_TIMEOUT_MS = 180_000

/** 生成函数签名，测试可注入 fake 实现（不触网） */
export type GenerateFn = (prompt: string) => Promise<GenerateResult>

export interface StorySummaryOptions {
    cnDir: string
    manifestFile: string
    outputFile: string
    dryRun: boolean
    force: boolean
    apiKey?: string
    baseUrl?: string
    model?: string
    maxChars?: number
    concurrency?: number
    timeoutMs?: number
    /** 缺省时使用 OpenAI 兼容客户端；测试传 fake */
    generate?: GenerateFn
    log?: Log
}

export interface RunStats {
    eligible: number
    pending: number
    generated: number
    failed: number
    written: number
    failedIds: number[]
}

/** 简单 .env 解析补充到 process.env（Bun 自动加载 .env 失败时兜底；已有环境变量优先） */
export function loadDotEnv(file: string): void {
    if (!existsSync(file)) return
    for (const line of readFileSync(file, "utf8").split(/\r?\n/)) {
        const match = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*?)\s*$/)
        if (!match?.[2]) continue
        if (process.env[match[1]] !== undefined) continue
        let value = match[2].trim()
        if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
            value = value.slice(1, -1)
        }
        process.env[match[1]] = value
    }
}

function sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
}

async function attemptWithRetry(attempt: (round: number) => Promise<GenerateResult>, log: Log, chainId: number): Promise<GenerateResult> {
    let last: GenerateResult = { ok: false, error: "未执行" }
    for (let round = 1; round <= 2; round++) {
        last = await attempt(round)
        if (last.ok) return last
        if (round < 2) {
            log(`[重试 ${chainId}] ${last.error}（第 ${round} 次失败，稍后重试）`)
            await sleep(500 * round)
        }
    }
    return last
}

/** 回灌：manifest 尚不存在且 cn 输出已有总结时，把现有总结视为最新（指纹对齐当前内容）。 */
function seedState(state: StoryState, digests: ReadonlyMap<number, ChainDigest>, outputFile: string, now: string): boolean {
    if (Object.keys(state).length > 0) return false
    const output = readStorySummaryOutput(outputFile)
    let seeded = false
    for (const [key, record] of Object.entries(output)) {
        const digest = digests.get(Number(key))
        if (!digest || state[key]) continue
        state[key] = { summary: record.summary, fingerprint: digest.fingerprint, updatedAt: record.updatedAt || now }
        seeded = true
    }
    return seeded
}

export async function runStorySummary(options: StorySummaryOptions): Promise<RunStats> {
    const log: Log = options.log ?? ((msg: string) => console.log(msg))
    const now = new Date().toISOString()
    const ctx = loadCnContext(options.cnDir)
    const digests = collectChainDigests(ctx)
    const eligibleIds = new Set(digests.keys())
    const eligible = digests.size

    const state = loadState(options.manifestFile)
    const seeded = seedState(state, digests, options.outputFile, now)

    const pending = pendingChainIds(digests, state, options.force)
    const stats: RunStats = { eligible, pending: pending.length, generated: 0, failed: 0, written: 0, failedIds: [] }

    if (options.dryRun) {
        log(
            `[dry-run] 共 ${eligible} 条含对白链，待生成 ${pending.length} 条（缺失/内容变化），` +
                `${eligible - pending.length} 条已是最新，跳过。`
        )
        for (const id of pending) {
            const meta = digests.get(id)?.meta
            const name = typeof meta?.name === "string" ? meta.name : ""
            log(`  - ${id}${name ? ` ${name}` : ""}（对白 ${digests.get(id)?.dialogueLines ?? 0} 行）`)
        }
        if (pending.length === 0) log("[dry-run] 无需生成（未调用任何 API，未写文件）")
        return stats
    }

    if (pending.length === 0) {
        if (seeded) saveState(options.manifestFile, state)
        stats.written = writeStorySummaryOutput(options.outputFile, state, eligibleIds)
        log(`[storysummary] 无缺失项，跳过生成（输出保持 ${stats.written} 条）`)
        return stats
    }

    let generate: GenerateFn
    if (options.generate) {
        generate = options.generate
    } else {
        if (!options.apiKey) throw new Error("未配置 API key")
        const client = createChatClient({
            apiKey: options.apiKey,
            baseUrl: options.baseUrl ?? DEFAULT_BASE_URL,
            model: options.model ?? DEFAULT_MODEL,
            timeoutMs: options.timeoutMs ?? DEFAULT_TIMEOUT_MS,
        })
        generate = (prompt: string) => client.summarize(prompt)
    }

    const maxChars = options.maxChars ?? DEFAULT_MAX_CHARS
    log(`[storysummary] 待生成 ${pending.length}/${eligible} 条（缺失或剧情内容变化）`)
    const failures = new Map<number, string>()
    let nextIndex = 0
    const commit = (id: number, summary: string, fingerprint: string): void => {
        state[String(id)] = { summary, fingerprint, updatedAt: now }
        saveState(options.manifestFile, state)
    }

    const worker = async (): Promise<void> => {
        for (;;) {
            const index = nextIndex++
            if (index >= pending.length) return
            const id = pending[index]
            const digest = digests.get(id)
            if (!digest) continue
            const prompt = buildPrompt(digest, maxChars)
            const result = await attemptWithRetry(() => generate(prompt), log, id)
            if (result.ok) {
                commit(id, result.summary, digest.fingerprint)
                stats.generated++
                log(`[ok] ${id}（对白 ${digest.dialogueLines} 行，总结 ${result.summary.length} 字）`)
            } else {
                failures.set(id, result.error)
                stats.failed++
                stats.failedIds.push(id)
                log(`[失败] ${id}: ${result.error}`)
            }
        }
    }

    const workers = Math.min(Math.max(options.concurrency ?? DEFAULT_CONCURRENCY, 1), Math.max(pending.length, 1))
    await Promise.all(Array.from({ length: workers }, () => worker()))
    if (seeded || stats.generated > 0 || stats.failed > 0) saveState(options.manifestFile, state)
    stats.written = writeStorySummaryOutput(options.outputFile, state, eligibleIds)
    log(
        `[storysummary] 完成: 生成 ${stats.generated}，失败 ${stats.failed}，输出 ${stats.written} 条 → ${options.outputFile}` +
            (stats.failed > 0 ? `（失败链: ${[...failures.keys()].join(", ")}，下次运行会重试）` : "")
    )
    return stats
}

function usage(): string {
    return `storysummary agent —— 对每个含对白的 QuestChain 生成 AI 剧情总结（仅生成缺失/变更项）

用法:
  bun run src/tools/storySummary/agent.ts --dry-run  测试：只报告待生成清单，不调 API
  bun run src/tools/storySummary/agent.ts            生成缺失部分并写 final/i18n/cn/storySummary.json
  bun run src/tools/storySummary/agent.ts --force    忽略已有结果全部重生成

环境变量（写入 .env）:
  STORY_SUMMARY_API_KEY     真实运行时必填
  STORY_SUMMARY_BASE_URL    默认 ${DEFAULT_BASE_URL}（DeepSeek 填 https://api.deepseek.com/v1）
  STORY_SUMMARY_MODEL       默认 ${DEFAULT_MODEL}（DeepSeek 填 deepseek-chat）
  STORY_SUMMARY_MAX_CHARS   每链喂给模型的对白上限字符，默认 ${DEFAULT_MAX_CHARS}
  STORY_SUMMARY_CONCURRENCY 并发请求数，默认 ${DEFAULT_CONCURRENCY}
  STORY_SUMMARY_TIMEOUT_MS  单次请求超时毫秒，默认 ${DEFAULT_TIMEOUT_MS}

前置: bun run src/cli.ts -f QuestChain QuestStory 生成 final/i18n/cn/QuestChain.json、QuestStory.json
状态: .cache/storysummary/state.json（gitignored）
输出: final/i18n/cn/storySummary.json = { "<链id>": "<中文总结>" }`
}

async function main(): Promise<void> {
    const args = process.argv.slice(2)
    if (args.includes("--help") || args.includes("-h")) {
        console.log(usage())
        return
    }
    const dryRun = args.includes("--dry-run")
    const force = args.includes("--force")
    const projectRoot = join(import.meta.dir, "..", "..", "..")
    loadDotEnv(join(projectRoot, ".env"))
    const readInt = (key: string, fallback: number): number => {
        const value = Number(process.env[key])
        return Number.isFinite(value) && value > 0 ? value : fallback
    }
    const stats = await runStorySummary({
        cnDir: join(projectRoot, "final", "i18n", "cn"),
        manifestFile: join(projectRoot, ".cache", "storysummary", "state.json"),
        outputFile: join(projectRoot, "final", "i18n", "cn", "storySummary.json"),
        dryRun,
        force,
        apiKey: process.env[ENV.API_KEY],
        baseUrl: process.env[ENV.BASE_URL] ?? DEFAULT_BASE_URL,
        model: process.env[ENV.MODEL] ?? DEFAULT_MODEL,
        maxChars: readInt(ENV.MAX_CHARS, DEFAULT_MAX_CHARS),
        concurrency: readInt(ENV.CONCURRENCY, DEFAULT_CONCURRENCY),
        timeoutMs: readInt(ENV.TIMEOUT_MS, DEFAULT_TIMEOUT_MS),
    })
    if (stats.failed > 0) process.exitCode = 1
}

if (import.meta.main) {
    try {
        await main()
    } catch (error) {
        console.error(`storysummary 运行失败: ${error instanceof Error ? error.message : String(error)}`)
        process.exitCode = 1
    }
}
