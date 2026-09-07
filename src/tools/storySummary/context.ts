/**
 * storysummary 上下文构建 —— 从主流水线导出的 cn 数据（QuestChain/QuestStory）提取每个
 * QuestChain 的全量对白，组成喂给 AI 的正文，并计算内容指纹。
 *
 * 数据契约：final/i18n/cn/QuestChain.json 与 QuestStory.json 由 `bun out -f QuestChain QuestStory`
 * 生成，本工具读取已渲染的中文文本，不在内部重放 Lua 构建。链与任务顺序以 QuestChain 的
 * quests 数组为准（该数组按 next 链排好），QuestStory 负责提供任务名/目标与对白内容。
 */
import { createHash } from "node:crypto"
import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"

type Row = Record<string, any>

export interface QuestBlock {
    questId: number
    questName?: string
    desc?: string
    /** 对白行（已含可选的说话人提示） */
    lines: string[]
}

export interface ChainDigest {
    id: number
    meta: Row
    quests: QuestBlock[]
    /** 该链全部内容的规范化文本，用于指纹与作为 prompt 正文 */
    text: string
    /** 对白行总数（>0 才视为“含对白的链”） */
    dialogueLines: number
    /** 内容 sha256，剧情变化即变化 */
    fingerprint: string
}

function row(value: unknown): Row | undefined {
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : undefined
}

function numberId(value: unknown): number | undefined {
    const n = Number(value)
    return Number.isInteger(n) && n >= 0 ? n : undefined
}

function text(value: unknown): string {
    return typeof value === "string" && value.trim() ? value : ""
}

/** 平铺一段对白（含选项文本），只收有实际内容的行 */
function dialogueLines(item: Row): string[] {
    const lines: string[] = []
    const content = text(item.content)
    if (content) {
        const npc = numberId(item.npc)
        lines.push(npc === undefined ? content : `[npc ${npc}] ${content}`)
    }
    if (Array.isArray(item.options)) {
        for (const option of item.options) {
            const o = row(option)
            const optionContent = o ? text(o.content) : ""
            if (optionContent) lines.push(`- ${optionContent}`)
        }
    }
    return lines
}

/** 从一条任务导出数据中收集对白块 */
function questLines(quest: Row): QuestBlock | undefined {
    const questId = numberId(quest.id)
    if (questId === undefined) return undefined
    const lines: string[] = []
    for (const node of Array.isArray(quest.nodes) ? quest.nodes : []) {
        const n = row(node)
        if (n?.type !== "TalkNode") continue
        for (const item of Array.isArray(n.dialogues) ? n.dialogues : []) {
            const d = row(item)
            if (d) lines.push(...dialogueLines(d))
        }
    }
    if (lines.length === 0) return undefined
    const block: QuestBlock = { questId, lines }
    const name = text(quest.name)
    if (name) block.questName = name
    const desc = text(quest.desc)
    if (desc) block.desc = desc
    return block
}

function orderedQuestIds(chainMeta: Row | undefined, storyQuestRows: Row[]): number[] {
    const ordered: number[] = []
    const seen = new Set<number>()
    for (const quest of Array.isArray(chainMeta?.quests) ? (chainMeta.quests as Row[]) : []) {
        const id = numberId(quest.id)
        if (id !== undefined && !seen.has(id)) {
            seen.add(id)
            ordered.push(id)
        }
    }
    for (const quest of storyQuestRows) {
        const id = numberId(quest.id)
        if (id !== undefined && !seen.has(id)) {
            seen.add(id)
            ordered.push(id)
        }
    }
    return ordered
}

function metaLine(label: string, value: string): string | undefined {
    return value ? `${label}: ${value}` : undefined
}

/** 构建单条链的 digest（text 同时用于指纹与 prompt） */
export function buildChainDigest(chainMeta: Row | undefined, story: Row): ChainDigest {
    const id = numberId(story.id)
    if (id === undefined) throw new Error(`QuestStory 条目缺少数值 id: ${JSON.stringify(story).slice(0, 120)}`)
    const questRows = (Array.isArray(story.quests) ? story.quests : []).filter(q => row(q) !== undefined) as Row[]
    const byId = new Map<number, Row>()
    for (const quest of questRows) {
        const qid = numberId(quest.id)
        if (qid !== undefined) byId.set(qid, quest)
    }

    const blocks: QuestBlock[] = []
    let dialogueLinesCount = 0
    for (const questId of orderedQuestIds(chainMeta, questRows)) {
        const quest = byId.get(questId)
        if (!quest) continue
        const block = questLines(quest)
        if (!block) continue
        dialogueLinesCount += block.lines.length
        blocks.push(block)
    }

    const parts: string[] = []
    const meta = chainMeta ?? {}
    const head: string[] = []
    const name = text(meta.name)
    head.push(`【剧情链 ${id}】${name || "（无名称）"}`)
    const lines: Array<string | undefined> = []
    if (text(meta.chapterName)) lines.push(`章节: ${text(meta.chapterName)}`)
    if (text(meta.chapterNumber)) lines.push(`章节号: ${text(meta.chapterNumber)}`)
    if (text(meta.episode)) lines.push(`剧集: ${text(meta.episode)}`)
    if (meta.type !== undefined && meta.type !== null) lines.push(`类型: ${meta.type}`)
    if (meta.main !== undefined && meta.main !== null) lines.push(`主线标记: ${meta.main}`)
    if (text(meta.desc)) lines.push(metaLine("简介", text(meta.desc)))
    if (text(meta.detail)) lines.push(metaLine("详情", text(meta.detail)))
    head.push(...lines.filter((l): l is string => !!l))
    parts.push(head.join("\n"))

    for (const block of blocks) {
        const qHead = [`【任务 ${block.questId}】${block.questName ?? ""}`.trim()]
        if (block.desc) qHead.push(`目标: ${block.desc}`)
        parts.push(qHead.join("\n"))
        parts.push(...block.lines)
    }

    const fullText = parts.join("\n")
    return {
        id,
        meta,
        quests: blocks,
        text: fullText,
        dialogueLines: dialogueLinesCount,
        fingerprint: createHash("sha256").update(fullText, "utf8").digest("hex"),
    }
}

/** 超长正文保留首尾截断，避免超出模型上下文 */
export function truncateText(textValue: string, maxChars: number): string {
    if (maxChars <= 0 || textValue.length <= maxChars) return textValue
    const headChars = Math.floor(maxChars * 0.6)
    const tailChars = maxChars - headChars
    const note = `\n……（中段截断，原文 ${textValue.length} 字符）……\n`
    return `${textValue.slice(0, headChars)}${note}${textValue.slice(-tailChars)}`
}

/** 组装发送给模型的 user 正文 */
export function buildPrompt(digest: ChainDigest, maxChars: number): string {
    const body = truncateText(digest.text, maxChars)
    return [
        "请阅读下面的剧情链信息与全部对白，写一段该链的剧情总结（300～500 字中文）。",
        "要求：只依据所给内容，不得虚构或脑补未出现的情节；概述起因、经过、结果与关键转折；",
        "行文自然连贯，让没玩过游戏的读者也能看懂这章讲了什么；只输出总结正文本身，",
        "不要输出标题、Markdown、列表或任何解释。",
        "【内容开始】",
        body,
        "【内容结束】",
    ].join("\n")
}

export interface CnContext {
    chains: Row[]
    stories: Row[]
}

/** 读取 cn 导出文件；缺失时报错并给出生成命令 */
export function loadCnContext(cnDir: string): CnContext {
    const chainsFile = join(cnDir, "QuestChain.json")
    const storiesFile = join(cnDir, "QuestStory.json")
    if (!existsSync(chainsFile) || !existsSync(storiesFile)) {
        throw new Error(`缺少剧情导出文件（${chainsFile} 或 ${storiesFile}）。请先运行: bun run src/cli.ts -f QuestChain QuestStory`)
    }
    const parseArray = (file: string): Row[] => {
        const parsed = JSON.parse(readFileSync(file, "utf8")) as unknown
        if (!Array.isArray(parsed)) throw new Error(`${file} 顶层不是数组`)
        return parsed
    }
    return { chains: parseArray(chainsFile), stories: parseArray(storiesFile) }
}

/** 汇总所有链的 digest；只保留含对白的链（dialogueLines > 0） */
export function collectChainDigests(ctx: CnContext): Map<number, ChainDigest> {
    const chainsById = new Map<number, Row>()
    for (const chain of ctx.chains) {
        const c = row(chain)
        const id = c ? numberId(c.id) : undefined
        if (c && id !== undefined) chainsById.set(id, c)
    }
    const result = new Map<number, ChainDigest>()
    for (const story of ctx.stories) {
        const s = row(story)
        if (!s) continue
        const digest = buildChainDigest(chainsById.get(Number(s.id)), s)
        if (digest.dialogueLines > 0) result.set(digest.id, digest)
    }
    return result
}
