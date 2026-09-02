import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import { T, TL, type VNode, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
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

function sortedKeys(value: Row): string[] {
    return Object.keys(value).sort((left, right) => {
        const leftNumeric = /^\d+$/.test(left)
        const rightNumeric = /^\d+$/.test(right)
        if (leftNumeric !== rightNumeric) return leftNumeric ? -1 : 1
        if (leftNumeric) return BigInt(left) < BigInt(right) ? -1 : BigInt(left) > BigInt(right) ? 1 : 0
        return left.localeCompare(right)
    })
}

function guidOf(value: unknown): string | undefined {
    if (typeof value === "string" && value) return value
    const nested = row(value)?.NodeGuid
    return typeof nested === "string" && nested ? nested : undefined
}

export function flowDialogueIds(flow: unknown): number[] {
    if (!Array.isArray(flow)) return []
    const nodes = new Map<string, Row>()
    const starts: string[] = []
    const next = new Map<string, string[]>()
    for (const value of flow) {
        const item = row(value)
        const props = row(item?.Properties)
        const guid = guidOf(props?.NodeGuid)
        if (!guid || !item) continue
        nodes.set(guid, item)
        if (item.Type === "FlowNode_Start") starts.push(guid)
        for (const connection of Array.isArray(props?.Connections) ? props.Connections : []) {
            const target = guidOf(row(row(connection)?.Value)?.NodeGuid)
            if (target) {
                const list = next.get(guid) ?? []
                list.push(target)
                next.set(guid, list)
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
    return dialogueIds
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
    prepareStoryFlows(paths: unknown[]): Promise<void>
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
    private readonly assetReader: AssetReader

    constructor(private readonly ctx: ModuleContext) {
        this.assetReader = new AssetReader(ctx.dm.root)
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

    private content(data: { base: Row; localized: Record<string, Row> }): { node: VNode; onlyLangs?: string[] } | undefined {
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
        if (cn) return { node: TL(cn, values) }
        const onlyLangs = Object.keys(values)
        if (onlyLangs.length > 0) return { node: TL("", values), onlyLangs }

        const optionTopic = typeof data.base.OptionTopic === "string" ? data.base.OptionTopic : ""
        return optionTopic ? { node: optionTopic } : undefined
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
                if (content !== undefined) {
                    item.content = content.node
                    if (content.onlyLangs && !voice) item.__langs = content.onlyLangs
                    if (content.onlyLangs && voice) item.__fieldLangs = { content: content.onlyLangs }
                }
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
                        if (optionContent !== undefined) {
                            option.content = optionContent.node
                            if (optionContent.onlyLangs && !optionVoice) option.__langs = optionContent.onlyLangs
                            if (optionContent.onlyLangs && optionVoice) option.__fieldLangs = { content: optionContent.onlyLangs }
                        }
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
        return structuredClone(items)
    }

    private flowFile(path: unknown): unknown[] | undefined {
        const file = this.flowFilePath(path)
        return file ? this.flowCache.get(file) : undefined
    }

    private flowFilePath(path: unknown, extension = ".uasset"): string | undefined {
        if (typeof path !== "string" || !path) return undefined
        const match = path.match(/\/Game\/Dialogue\/([^']+)/)
        if (!match) return undefined
        const relative = match[1].split(".")[0]
        const exportsRoot = getExportsRoot()
        if (!exportsRoot) return undefined
        return join(exportsRoot, "EM", "Content", "Dialogue", `${relative}${extension}`)
    }

    async prepareStoryFlows(paths: unknown[]): Promise<void> {
        const flowPaths = paths.flatMap(path => this.storyTalks(path).map(talk => talk.flowAssetPath)).filter(path => path)
        for (const path of new Set(flowPaths)) {
            const file = this.flowFilePath(path)
            if (!file || this.flowCache.has(file)) continue
            let data = await this.assetReader.readFModelAsset(file)
            if (!data) {
                const jsonFile = this.flowFilePath(path, ".json")
                if (jsonFile && existsSync(jsonFile)) {
                    const parsed = JSON.parse(readFileSync(jsonFile, "utf8"))
                    data = Array.isArray(parsed) ? parsed : null
                }
            }
            this.flowCache.set(file, data ?? undefined)
        }
    }

    flowChain(flowAssetPath: unknown): VNodeTree[] {
        const flow = this.flowFile(flowAssetPath)
        if (!flow) return []
        const cacheKey = String(flowAssetPath)
        const cached = this.flowChainCache.get(cacheKey)
        if (cached) return this.copyItems(cached)
        const nodes = new Map<string, Row>()
        const incoming = new Map<string, string[]>()
        const startGuids: string[] = []
        for (const value of flow) {
            const item = row(value)
            const props = row(item?.Properties)
            const guid = guidOf(props?.NodeGuid)
            if (!item || !guid) continue
            nodes.set(guid, item)
            if (item.Type === "FlowNode_Start") startGuids.push(guid)
            for (const connection of Array.isArray(props?.Connections) ? props.Connections : []) {
                const target = guidOf(row(row(connection)?.Value)?.NodeGuid)
                if (!target) continue
                const parents = incoming.get(target) ?? []
                if (!parents.includes(guid)) parents.push(guid)
                incoming.set(target, parents)
            }
        }
        const optionGuids: string[] = []
        const visitedGuids = new Set<string>()
        const guidQueue = [...startGuids]
        while (guidQueue.length > 0) {
            const guid = guidQueue.shift()!
            if (visitedGuids.has(guid)) continue
            visitedGuids.add(guid)
            const item = nodes.get(guid)
            if (!item) continue
            if (item.Type === "FlowNode_Option" || item.Type === "FlowNode_ImpressingOption") optionGuids.push(guid)
            const props = row(item.Properties)
            for (const connection of Array.isArray(props?.Connections) ? props.Connections : []) {
                const target = guidOf(row(row(connection)?.Value)?.NodeGuid)
                if (target && !visitedGuids.has(target)) guidQueue.push(target)
            }
        }
        const dialogueIds = flowDialogueIds(flow)
        const result: VNodeTree[] = []
        const emitted = new Set<number>()
        const itemMap = new Map<number, Record<string, VNodeTree>>()
        this.loadData(dialogueIds)
        for (const id of dialogueIds) {
            for (const item of this.chain(id, false)) {
                const itemId = idOf(row(item)?.id)
                if (itemId === undefined || emitted.has(itemId)) continue
                emitted.add(itemId)
                result.push(item)
                itemMap.set(itemId, item as Record<string, VNodeTree>)
            }
        }

        const attachedOptionIds = new Set<number>()
        const markAttachedOptions = (value: unknown): void => {
            const item = row(value)
            const itemId = idOf(item?.id)
            if (itemId !== undefined) attachedOptionIds.add(itemId)
            for (const option of Array.isArray(item?.options) ? item.options : []) markAttachedOptions(option)
        }
        for (const optionGuid of optionGuids) {
            const optionNode = nodes.get(optionGuid)
            const optionProps = row(optionNode?.Properties) ?? {}
            const optionIds = (Array.isArray(optionProps.OptionData) ? optionProps.OptionData : [])
                .map(value => idOf(row(value)?.DialogueId))
                .filter((id): id is number => id !== undefined)
            if (optionIds.length === 0) continue

            let parent: Record<string, VNodeTree> | undefined
            const parentQueue = [...(incoming.get(optionGuid) ?? [])]
            const parentVisited = new Set<string>()
            while (parentQueue.length > 0 && !parent) {
                const guid = parentQueue.shift()!
                if (parentVisited.has(guid)) continue
                parentVisited.add(guid)
                const candidate = nodes.get(guid)
                const candidateProps = row(candidate?.Properties)
                const ids = (Array.isArray(candidateProps?.DialogueData) ? candidateProps.DialogueData : [])
                    .map(value => idOf(row(value)?.DialogueId))
                    .filter((id): id is number => id !== undefined)
                for (const id of ids.reverse()) {
                    parent = itemMap.get(id)
                    if (parent) break
                }
                if (!parent) parentQueue.push(...(incoming.get(guid) ?? []).filter(value => !parentVisited.has(value)))
            }
            if (!parent) continue

            const pinByOption = new Map<number, string>()
            for (const value of Array.isArray(optionProps.OptionPinName) ? optionProps.OptionPinName : []) {
                const item = row(value)
                const id = idOf(item?.Key)
                if (id !== undefined && typeof item?.Value === "string") pinByOption.set(id, item.Value)
            }
            const targetByPin = new Map<string, string>()
            for (const value of Array.isArray(optionProps.Connections) ? optionProps.Connections : []) {
                const item = row(value)
                const target = guidOf(row(item?.Value)?.NodeGuid)
                if (typeof item?.Key === "string" && target) targetByPin.set(item.Key, target)
            }
            const existingOptions = Array.isArray(parent.options) ? parent.options : []
            const existingById = new Map<number, Record<string, VNodeTree>>()
            for (const value of existingOptions) {
                const item = row(value)
                const id = idOf(item?.id)
                if (id !== undefined && item) existingById.set(id, item as Record<string, VNodeTree>)
            }

            this.loadData(optionIds)
            for (const optionId of optionIds) {
                const option = row(this.chain(optionId, false)[0]) as Record<string, VNodeTree> | undefined
                if (!option) continue
                const pin = pinByOption.get(optionId)
                if (option.next === undefined && pin) {
                    const nextQueue = [targetByPin.get(pin)].filter((value): value is string => !!value)
                    const nextVisited = new Set<string>()
                    while (nextQueue.length > 0 && option.next === undefined) {
                        const guid = nextQueue.shift()!
                        if (nextVisited.has(guid)) continue
                        nextVisited.add(guid)
                        const nextNode = nodes.get(guid)
                        const nextProps = row(nextNode?.Properties)
                        const nextId = idOf(row(Array.isArray(nextProps?.DialogueData) ? nextProps.DialogueData[0] : undefined)?.DialogueId)
                        if (nextId !== undefined) {
                            option.next = nextId
                            break
                        }
                        for (const connection of Array.isArray(nextProps?.Connections) ? nextProps.Connections : []) {
                            const target = guidOf(row(row(connection)?.Value)?.NodeGuid)
                            if (target && !nextVisited.has(target)) nextQueue.push(target)
                        }
                    }
                }

                const existing = existingById.get(optionId)
                if (existing) {
                    for (const field of ["next", "impr", "imprCheck", "voice", "content"] as const) {
                        if (existing[field] === undefined && option[field] !== undefined) existing[field] = option[field]
                    }
                } else {
                    existingOptions.push(option)
                    existingById.set(optionId, option)
                }
                markAttachedOptions(option)
            }
            if (existingOptions.length > 0) {
                parent.options = existingOptions
                delete parent.next
            }
        }

        const output = attachedOptionIds.size > 0 ? result.filter(item => !attachedOptionIds.has(idOf(row(item)?.id) ?? 0)) : result
        this.flowChainCache.set(cacheKey, output)
        return this.copyItems(output)
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
        const data = row(story?.storyNodeData) ?? {}
        for (const key of sortedKeys(data)) {
            const node = data[key]
            const parent = row(node)
            if (!parent) continue
            append(parent)
            const questData = row(parent.questNodeData)
            const nodeData = row(questData?.nodeData) ?? {}
            for (const childKey of sortedKeys(nodeData)) append(nodeData[childKey])
        }
        return result
    }
}

export function dialogueModule(ctx: ModuleContext): DialogueService {
    return new DialogueServiceImpl(ctx)
}
