import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import { T, TL, type VNode, type VNodeTree } from "../../i18n/vnode.ts"
import { getExportsRoot } from "../../lua/UAssetServer.ts"

type Row = Record<string, any>
type Story = Row

const DIALOGUE_TABLES: Record<string, string> = {
    cn: "Dialogue_TextMapContent",
    en: "Dialogue_ContentEN",
    jp: "Dialogue_ContentJP",
    kr: "Dialogue_ContentKR",
    fr: "Dialogue_ContentFR",
    tc: "Dialogue_ContentTC",
}

function row(value: unknown): Row | undefined {
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : undefined
}

function idOf(value: unknown): number | undefined {
    const id = Number(value)
    return Number.isInteger(id) && id > 0 ? id : undefined
}

function simplifyVoice(value: unknown): string {
    if (typeof value !== "string") return ""
    const voice = value.trim().replaceAll("\\", "/")
    if (!voice) return ""
    for (const prefix of [
        "voice/$Locale$/",
        "voice/ch/",
        "voice/en/",
        "voice/jp/",
        "voice/kr/",
        "voice/fr/",
        "voice/es/",
        "voice/tc/",
        "voice/de/",
    ]) {
        if (voice.startsWith(prefix)) return voice.slice(prefix.length)
    }
    const match = voice.match(/^voice\/[^/]+\/(.+)$/)
    return match ? match[1] : voice.replace(/^\/+/, "")
}

function inlineImpressionCheck(table: Row, id: unknown): VNodeTree | undefined {
    const data = row(table[String(id)])
    if (!data) return undefined
    const fields: Array<[string, string]> = [
        ["BenefitCheck", "Benefit"],
        ["MoralityCheck", "Morality"],
        ["WisdomCheck", "Wisdom"],
        ["EmpathyCheck", "Empathy"],
        ["ChaosCheck", "Chaos"],
    ]
    for (const [field, name] of fields) {
        const value = Number(data[field] ?? 0)
        if (value > 0) return [data.RegionId ?? 0, name, value]
    }
    return undefined
}

function inlineImpressionPlus(table: Row, id: unknown): VNodeTree | undefined {
    const data = row(table[String(id)])
    if (!data) return undefined
    const fields: Array<[string, string]> = [
        ["BenefitPlus", "Benefit"],
        ["MoralityPlus", "Morality"],
        ["WisdomPlus", "Wisdom"],
        ["EmpathyPlus", "Empathy"],
        ["ChaosPlus", "Chaos"],
    ]
    for (const [field, name] of fields) {
        const value = Number(data[field] ?? 0)
        if (value > 0) return [data.RegionId ?? 0, name, value]
    }
    return undefined
}

export interface DialogueService {
    prefetch(firstIds: unknown[]): void
    prefetchReachable(firstIds: unknown[]): void
    chain(firstId: unknown, includeContentlessNodes?: boolean): VNodeTree[]
    flowChain(flowAssetPath: unknown): VNodeTree[]
    story(path: unknown): Story | undefined
    storyTalks(path: unknown): Array<{ firstDialogueId: unknown; flowAssetPath: unknown }>
}

class DialogueServiceImpl implements DialogueService {
    private readonly storyCache = new Map<string, Story | undefined>()
    private readonly flowCache = new Map<string, unknown[] | undefined>()
    private readonly impressionCheck: Row
    private readonly impressionPlus: Row
    private readonly dataCache = new Map<number, { base: Row; localized: Record<string, Row> } | undefined>()
    private readonly chainCache = new Map<string, VNodeTree[]>()
    private readonly flowChainCache = new Map<string, VNodeTree[]>()

    constructor(private readonly ctx: ModuleContext) {
        this.impressionCheck = (ctx.dm.getTable("ImpressionCheck") as Row | undefined) ?? {}
        this.impressionPlus = (ctx.dm.getTable("ImpressionPlus") as Row | undefined) ?? {}
    }

    private data(id: unknown): { base: Row; localized: Record<string, Row> } | undefined {
        const numericId = idOf(id)
        if (numericId === undefined) return undefined
        if (this.dataCache.has(numericId)) return this.dataCache.get(numericId)
        this.loadData([numericId])
        return this.dataCache.get(numericId)
    }

    private loadData(ids: number[]): void {
        const pending = [...new Set(ids)].filter(id => !this.dataCache.has(id))
        if (pending.length === 0) return
        const tables = Object.values(DIALOGUE_TABLES)
        const loaded = this.ctx.dm.getDialogueItems(tables, pending)
        for (const numericId of pending) {
            const localized: Record<string, Row> = {}
            for (const [lang, table] of Object.entries(DIALOGUE_TABLES)) {
                const item = row(loaded.get(table)?.get(String(numericId)))
                if (item) localized[lang] = item
            }
            const base = localized.cn
            this.dataCache.set(numericId, base ? { base, localized } : undefined)
        }
    }

    prefetch(firstIds: unknown[]): void {
        this.loadData(firstIds.map(idOf).filter((id): id is number => id !== undefined))
    }

    prefetchReachable(firstIds: unknown[]): void {
        const pending = [...new Set(firstIds.map(idOf).filter((id): id is number => id !== undefined))].filter(
            id => !this.dataCache.has(id)
        )
        if (pending.length === 0) return
        const tables = Object.values(DIALOGUE_TABLES)
        const loaded = this.ctx.dm.getDialogueReachableItems(tables, pending)
        for (const map of loaded.values()) {
            for (const key of map.keys()) {
                const numericId = idOf(key)
                if (numericId === undefined || this.dataCache.has(numericId)) continue
                const localized: Record<string, Row> = {}
                for (const [lang, table] of Object.entries(DIALOGUE_TABLES)) {
                    const item = row(loaded.get(table)?.get(String(numericId)))
                    if (item) localized[lang] = item
                }
                this.dataCache.set(numericId, localized.cn ? { base: localized.cn, localized } : undefined)
            }
        }
    }

    private content(data: { base: Row; localized: Record<string, Row> }): VNode | undefined {
        const values: Partial<Record<"en" | "jp" | "kr" | "fr" | "tc", string>> = {}
        const read = (lang: string): string => {
            const item = data.localized[lang]
            const field = lang === "cn" ? "Content" : `Content${lang.toUpperCase()}`
            return typeof item?.[field] === "string" && item[field] ? item[field] : ""
        }
        const cn = read("cn")
        for (const lang of ["en", "jp", "kr", "fr", "tc"] as const) {
            const value = read(lang)
            if (value) values[lang] = value
        }
        if (cn) return TL(cn, values)

        const optionTopic = typeof data.base.OptionTopic === "string" ? data.base.OptionTopic : ""
        return optionTopic ? optionTopic : undefined
    }

    chain(firstId: unknown, includeContentlessNodes = true): VNodeTree[] {
        const first = idOf(firstId)
        if (first === undefined) return []
        const cacheKey = `${first}\x00${includeContentlessNodes ? 1 : 0}`
        const cached = this.chainCache.get(cacheKey)
        if (cached) return this.copyItems(cached)
        const result: VNodeTree[] = []
        const queue: number[] = [first]
        const visited = new Set<number>()
        while (queue.length > 0) {
            const batch = [...new Set(queue.splice(0, 64))]
            this.loadData(batch)
            for (const current of batch) {
                if (visited.has(current)) continue
                visited.add(current)
                const loaded = this.data(current)
                if (!loaded) continue
                const { base } = loaded
                const content = this.content(loaded)
                const voice = simplifyVoice(base.VoiceName)
                const nextOptions = Array.isArray(base.NextOptions) ? base.NextOptions : []
                const next = idOf(base.NextDialogue)
                if (!content && !voice && !(includeContentlessNodes && nextOptions.length > 0)) {
                    if (next !== undefined) queue.push(next)
                    continue
                }

                const item: Record<string, VNodeTree> = { id: current }
                if (content !== undefined) item.content = content
                if (voice) item.voice = voice
                if (base.SpeakNpcId) item.npc = base.SpeakNpcId
                if (base.SpeakNpcName) item.speakerName = T(base.SpeakNpcName)
                if (nextOptions.length === 0) {
                    if (next !== undefined) {
                        item.next = next
                        queue.push(next)
                    }
                } else {
                    this.loadData(nextOptions.map(id => idOf(id)).filter((id): id is number => id !== undefined))
                    const options: VNodeTree[] = []
                    for (const optionId of nextOptions) {
                        const optionLoaded = this.data(optionId)
                        if (!optionLoaded) continue
                        const optionContent = this.content(optionLoaded)
                        const optionVoice = simplifyVoice(optionLoaded.base.VoiceName)
                        if (optionContent === undefined && !optionVoice) continue
                        const option: Record<string, VNodeTree> = { id: idOf(optionId) ?? optionId }
                        if (optionContent !== undefined) option.content = optionContent
                        if (optionVoice) option.voice = optionVoice
                        const optionNext = idOf(optionLoaded.base.NextDialogue)
                        if (optionNext !== undefined && !Array.isArray(optionLoaded.base.NextOptions)) {
                            option.next = optionNext
                            queue.push(optionNext)
                        }
                        const impr = inlineImpressionPlus(this.impressionPlus, optionLoaded.base.ImprPlusId)
                        if (impr !== undefined) option.impr = impr
                        const imprCheck = inlineImpressionCheck(this.impressionCheck, optionLoaded.base.ImprCheckId)
                        if (imprCheck !== undefined) option.imprCheck = imprCheck
                        options.push(option)
                    }
                    if (options.length > 0) item.options = options
                }
                const impr = inlineImpressionPlus(this.impressionPlus, base.ImprPlusId)
                if (impr !== undefined) item.impr = impr
                const imprCheck = inlineImpressionCheck(this.impressionCheck, base.ImprCheckId)
                if (imprCheck !== undefined) item.imprCheck = imprCheck
                result.push(item)
            }
        }
        this.chainCache.set(cacheKey, result)
        return this.copyItems(result)
    }

    private copyItems(items: VNodeTree[]): VNodeTree[] {
        return items.map(item => (item && typeof item === "object" && !Array.isArray(item) ? { ...(item as Row) } : item))
    }

    private flowFile(path: unknown): unknown[] | undefined {
        if (typeof path !== "string" || !path) return undefined
        const match = path.match(/\/Game\/Dialogue\/([^']+)/)
        if (!match) return undefined
        const relative = match[1].split(".")[0].replaceAll("/", "\\")
        const exportsRoot = getExportsRoot()
        if (!exportsRoot) return undefined
        const file = join(exportsRoot, "EM", "Content", "Dialogue", `${relative}.json`)
        if (this.flowCache.has(file)) return this.flowCache.get(file)
        if (!existsSync(file)) {
            this.flowCache.set(file, undefined)
            return undefined
        }
        try {
            const value = JSON.parse(readFileSync(file, "utf8"))
            const data = Array.isArray(value) ? value : undefined
            this.flowCache.set(file, data)
            return data
        } catch {
            this.flowCache.set(file, undefined)
            return undefined
        }
    }

    flowChain(flowAssetPath: unknown): VNodeTree[] {
        const flow = this.flowFile(flowAssetPath)
        if (!flow) return []
        const cacheKey = String(flowAssetPath)
        const cached = this.flowChainCache.get(cacheKey)
        if (cached) return this.copyItems(cached)
        const nodes = new Map<string, Row>()
        const starts: string[] = []
        const next = new Map<string, string[]>()
        for (const value of flow) {
            const item = row(value)
            const props = row(item?.Properties)
            const guid = props?.NodeGuid
            if (!guid || !item) continue
            const key = String(guid)
            nodes.set(key, item)
            if (item.Type === "FlowNode_Start") starts.push(key)
            for (const connection of Array.isArray(props.Connections) ? props.Connections : []) {
                const target = row(row(connection)?.Value)?.NodeGuid
                if (target) {
                    const list = next.get(key) ?? []
                    list.push(String(target))
                    next.set(key, list)
                }
            }
        }
        const dialogueIds: number[] = []
        const seenGuid = new Set<string>()
        const seenDialogue = new Set<number>()
        const queue = [...starts]
        while (queue.length > 0) {
            const guid = queue.shift()!
            if (seenGuid.has(guid)) continue
            seenGuid.add(guid)
            const item = nodes.get(guid)
            const props = row(item?.Properties)
            if (item?.Type === "FlowNode_Dialogue") {
                for (const entry of Array.isArray(props?.DialogueData) ? props.DialogueData : []) {
                    const id = idOf(row(entry)?.DialogueId)
                    if (id !== undefined && !seenDialogue.has(id)) {
                        seenDialogue.add(id)
                        dialogueIds.push(id)
                    }
                }
            }
            for (const child of next.get(guid) ?? []) queue.push(child)
        }
        const result: VNodeTree[] = []
        const emitted = new Set<number>()
        this.loadData(dialogueIds)
        for (const id of dialogueIds) {
            for (const item of this.chain(id, false)) {
                const itemId = idOf(row(item)?.id)
                if (itemId === undefined || emitted.has(itemId)) continue
                emitted.add(itemId)
                result.push(item)
            }
        }
        this.flowChainCache.set(cacheKey, result)
        return this.copyItems(result)
    }

    story(path: unknown): Story | undefined {
        if (typeof path !== "string" || !path) return undefined
        let relative = path.replace(/\.story$/i, ".lua").replaceAll("\\", "/")
        if (!relative.toLowerCase().endsWith(".lua")) relative += ".lua"
        const key = relative
        if (!this.storyCache.has(key))
            this.storyCache.set(key, row(this.ctx.dm.loadStoryFile(join("Script", "StoryCreator", "StoryFiles", relative))))
        return this.storyCache.get(key)
    }

    storyTalks(path: unknown): Array<{ firstDialogueId: unknown; flowAssetPath: unknown }> {
        const story = this.story(path)
        const result: Array<{ firstDialogueId: unknown; flowAssetPath: unknown }> = []
        const seen = new Set<string>()
        const append = (node: unknown): void => {
            const item = row(node)
            if (item?.type !== "TalkNode") return
            const props = row(item.propsData) ?? {}
            const firstDialogueId = props.FirstDialogueId ?? 0
            const flowAssetPath = props.FlowAssetPath ?? ""
            if (!firstDialogueId && !flowAssetPath) return
            const key = `${String(firstDialogueId)}\x00${String(flowAssetPath)}`
            if (seen.has(key)) return
            seen.add(key)
            result.push({ firstDialogueId, flowAssetPath })
        }
        const data = row(story?.storyNodeData)
        for (const node of Object.values(data ?? {})) {
            const parent = row(node)
            if (!parent) continue
            append(parent)
            const questData = row(parent.questNodeData)
            const nodeData = row(questData?.nodeData)
            for (const subNode of Object.values(nodeData ?? {})) append(subNode)
        }
        return result
    }
}

export function dialogueModule(ctx: ModuleContext): DialogueService {
    return new DialogueServiceImpl(ctx)
}
