#!/usr/bin/env bun
/**
 * storysummary agent —— 独立 agent 工具：对每个含对白的 QuestChain 生成 AI 剧情总结。
 *
 * 设计要点：
 * - 与主流水线解耦，显式运行，默认 `bun out` 不会触发任何网络调用；
 * - final/i18n/cn/storySummary.json 是“已生成总结”的唯一权威：总结正文只存于 final，
 *   .cache/storysummary/state.json 只是指纹账本（可丢弃）。每次运行先以 final 对账：
 *   在 final 中删除某条即视为未生成，下次运行会重新生成该链，绝不从账本恢复旧正文；
 * - 除“缺失”外，剧情内容变化（账本指纹 ≠ 当前指纹）的链也会重生成；
 * - --dry-run 只报告待生成清单，不读取 API key、不发任何请求（测试用）；
 * - --limit N 单步/限量模式：一次最多生成 N 条（按 id 升序取前 N 条待生成项，N=1 即单步），
 *   每批都即时写状态与输出，可反复执行逐条/逐批推进；
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
import { loadState, pendingChainIds, type StoryLedger, saveState } from "./state.ts"

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
    /** 单步/限量：本次最多生成的条数（升序取前 N 条待生成项；缺省为全部，N=1 即单步模式） */
    limit?: number
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

/** 以 final 输出（唯一权威）对账指纹账本：账本里有、final 已删除的链 → 清除账本记录（视为未生成，
 *  下次运行重新生成）；final 里有、账本缺失的链 → 按当前内容指纹补账本（视为已生成，避免全新检出时全量重生成）。 */
function reconcileLedger(
    ledger: StoryLedger,
    summaries: Readonly<Record<string, string>>,
    digests: ReadonlyMap<number, ChainDigest>,
    now: string
): boolean {
    let changed = false
    for (const key of Object.keys(ledger)) {
        if (summaries[key] === undefined) {
            delete ledger[key]
            changed = true
        }
    }
    for (const [key, summary] of Object.entries(summaries)) {
        if (!summary.trim() || ledger[key]) continue
        const digest = digests.get(Number(key))
        if (!digest) continue
        ledger[key] = { fingerprint: digest.fingerprint, updatedAt: now }
        changed = true
    }
    return changed
}

export async function runStorySummary(options: StorySummaryOptions): Promise<RunStats> {
    const log: Log = options.log ?? ((msg: string) => console.log(msg))
    const now = new Date().toISOString()
    const ctx = loadCnContext(options.cnDir)
    const digests = collectChainDigests(ctx)
    const eligibleIds = new Set(digests.keys())
    const eligible = digests.size

    // final 输出是“已生成总结”的唯一权威；账本只记指纹，先按 final 对账再判定待生成项
    const summaries = readStorySummaryOutput(options.outputFile)
    const ledger = loadState(options.manifestFile)
    const ledgerChanged = reconcileLedger(ledger, summaries, digests, now)

    const fullPending = pendingChainIds(digests, ledger, options.force)
    const limit = options.limit !== undefined && options.limit > 0 ? Math.floor(options.limit) : undefined
    const pending = limit === undefined ? fullPending : fullPending.slice(0, limit)
    const remaining = fullPending.length - pending.length
    const stats: RunStats = { eligible, pending: pending.length, generated: 0, failed: 0, written: 0, failedIds: [] }

    if (options.dryRun) {
        log(
            `[dry-run] 共 ${eligible} 条含对白链，待生成 ${fullPending.length} 条（缺失/内容变化），` +
                `${eligible - fullPending.length} 条已是最新，跳过。`
        )
        if (remaining > 0) log(`[dry-run] 单步/限量：本次仅预览前 ${pending.length} 条，剩余 ${remaining} 条留待下次`)
        for (const id of pending) {
            const meta = digests.get(id)?.meta
            const name = typeof meta?.name === "string" ? meta.name : ""
            log(`  - ${id}${name ? ` ${name}` : ""}（对白 ${digests.get(id)?.dialogueLines ?? 0} 行）`)
        }
        if (pending.length === 0) log("[dry-run] 无需生成（未调用任何 API，未写文件）")
        return stats
    }

    if (pending.length === 0) {
        if (ledgerChanged) saveState(options.manifestFile, ledger)
        stats.written = writeStorySummaryOutput(options.outputFile, summaries, eligibleIds)
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
    if (remaining > 0) {
        log(`[storysummary] 单步/限量模式：本次生成前 ${pending.length} 条待生成链，剩余 ${remaining} 条下次运行继续`)
    } else {
        log(`[storysummary] 待生成 ${pending.length}/${eligible} 条（缺失或剧情内容变化）`)
    }
    const failures = new Map<number, string>()
    let nextIndex = 0
    const commit = (id: number, summary: string, fingerprint: string): void => {
        summaries[String(id)] = summary
        ledger[String(id)] = { fingerprint, updatedAt: now }
        saveState(options.manifestFile, ledger)
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
    if (ledgerChanged || stats.generated > 0 || stats.failed > 0) saveState(options.manifestFile, ledger)
    stats.written = writeStorySummaryOutput(options.outputFile, summaries, eligibleIds)
    const notes: string[] = []
    if (stats.failed > 0) notes.push(`失败链: ${[...failures.keys()].join(", ")}（下次运行会重试）`)
    if (remaining > 0) notes.push(`剩余 ${remaining} 条留待下次运行`)
    log(
        `[storysummary] 完成: 生成 ${stats.generated}，失败 ${stats.failed}，输出 ${stats.written} 条 → ${options.outputFile}` +
            (notes.length > 0 ? `（${notes.join("；")}）` : "")
    )
    return stats
}

function usage(): string {
    return `storysummary agent —— 对每个含对白的 QuestChain 生成 AI 剧情总结（仅生成缺失/变更项）

用法:
  bun run src/tools/storySummary/agent.ts --dry-run          测试：只报告待生成清单，不调 API
  bun run src/tools/storySummary/agent.ts                    生成缺失部分并写 final/i18n/cn/storySummary.json
  bun run src/tools/storySummary/agent.ts --limit 1          单步模式：本次最多生成 1 条（可反复执行逐条推进）
  bun run src/tools/storySummary/agent.ts --limit N          限量：本次最多生成 N 条（按 id 升序取前 N 条，剩余下次继续）
  bun run src/tools/storySummary/agent.ts --force            忽略已有结果全部重生成

环境变量（写入 .env）:
  STORY_SUMMARY_API_KEY     真实运行时必填
  STORY_SUMMARY_BASE_URL    默认 ${DEFAULT_BASE_URL}（DeepSeek 填 https://api.deepseek.com/v1）
  STORY_SUMMARY_MODEL       默认 ${DEFAULT_MODEL}（DeepSeek 填 deepseek-chat）
  STORY_SUMMARY_MAX_CHARS   每链喂给模型的对白上限字符，默认 ${DEFAULT_MAX_CHARS}
  STORY_SUMMARY_CONCURRENCY 并发请求数，默认 ${DEFAULT_CONCURRENCY}
  STORY_SUMMARY_TIMEOUT_MS  单次请求超时毫秒，默认 ${DEFAULT_TIMEOUT_MS}

前置: bun run src/cli.ts -f QuestChain QuestStory 生成 final/i18n/cn/QuestChain.json、QuestStory.json
状态: .cache/storysummary/state.json（gitignored，仅指纹账本；总结正文以 final 输出为唯一权威——
      final 中删除某条即视为未生成，下次运行会重新生成，不会从账本恢复）
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
    const limitIndex = args.indexOf("--limit")
    let limit: number | undefined
    if (limitIndex >= 0) {
        const raw = args[limitIndex + 1]
        const value = Number(raw)
        if (!Number.isInteger(value) || value <= 0) {
            console.error(`--limit 需要正整数（单步模式用 1），收到: ${raw ?? "<缺失>"}`)
            process.exitCode = 1
            return
        }
        limit = value
    }
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
        limit,
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
