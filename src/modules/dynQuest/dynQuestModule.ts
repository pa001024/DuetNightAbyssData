import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"
import { type Row, rows } from "../shared/dataHelpers.ts"
import { storylineNodes } from "../storyline/storyline.ts"

function row(value: unknown): Row | undefined {
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : undefined
}

function impression(ctx: ModuleContext, value: unknown): VNodeTree | undefined {
    if (typeof value !== "string" && typeof value !== "number") return undefined
    const item = ctx.dm.getTableItem("ImpressionPlus", value) as Row | undefined
    if (!item) return undefined
    for (const [field, name] of [
        ["BenefitPlus", "Benefit"],
        ["MoralityPlus", "Morality"],
        ["WisdomPlus", "Wisdom"],
        ["EmpathyPlus", "Empathy"],
        ["ChaosPlus", "Chaos"],
    ] as const) {
        const amount = Number(item[field] ?? 0)
        if (amount > 0) return [item.RegionId ?? 0, name, amount]
    }
    return undefined
}

function applyDynamicImpression(ctx: ModuleContext, nodes: VNodeTree[], values: unknown): void {
    if (!values || typeof values !== "object" || Array.isArray(values)) return
    const dialogues = nodes.flatMap(node => (Array.isArray((node as Row).dialogues) ? ((node as Row).dialogues as Row[]) : []))
    const direct = new Map<string, Row>()
    const byNext = new Map<string, Row[]>()
    for (const dialogue of dialogues) {
        direct.set(String(dialogue.id), dialogue)
        for (const option of Array.isArray(dialogue.options) ? (dialogue.options as Row[]) : []) {
            direct.set(String(option.id), option)
            if (option.next !== undefined) byNext.set(String(option.next), [...(byNext.get(String(option.next)) ?? []), option])
        }
    }
    for (const [dialogueId, impressionId] of Object.entries(values as Row)) {
        const value = impression(ctx, impressionId)
        if (!value) continue
        const targets = direct.has(dialogueId) ? [direct.get(dialogueId)!] : (byNext.get(dialogueId) ?? [])
        for (const target of targets) if (target.impr === undefined) target.impr = value
    }
}

function storyGraph(ctx: ModuleContext, path: unknown, nodes: VNodeTree[], linkUnimportGuideNext: boolean): Row | undefined {
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    const story = dialogue?.story(path)
    if (!story) return undefined
    const outputNodes = nodes as Row[]
    const dialogueMap = new Map<string, Row>()
    const optionMap = new Map<string, Row>()
    for (const output of outputNodes) {
        for (const item of Array.isArray(output.dialogues) ? (output.dialogues as Row[]) : []) {
            dialogueMap.set(String(item.id), item)
            for (const option of Array.isArray(item.options) ? (item.options as Row[]) : []) optionMap.set(String(option.id), option)
        }
    }

    for (const parentValue of Object.values(row(story.storyNodeData) ?? {})) {
        const parent = row(parentValue)
        const quest = row(parent?.questNodeData)
        const nodeData = row(quest?.nodeData) ?? {}
        const edges = Array.isArray(quest?.lineData) ? quest.lineData.map(row).filter((value): value is Row => !!value) : []
        const adjacency = new Map<string, string[]>()
        const incoming = new Map<string, Array<[string, string]>>()
        const byPort = new Map<string, string[]>()
        for (const edge of edges) {
            const start = String(edge.startQuest ?? "")
            const end = String(edge.endQuest ?? "")
            if (!start || !end) continue
            const port = String(edge.startPort ?? "")
            const children = adjacency.get(start) ?? []
            if (!children.includes(end)) children.push(end)
            adjacency.set(start, children)
            const sources = incoming.get(end) ?? []
            sources.push([start, port])
            incoming.set(end, sources)
            const portKey = `${start}\x00${port}`
            const portChildren = byPort.get(portKey) ?? []
            if (!portChildren.includes(end)) portChildren.push(end)
            byPort.set(portKey, portChildren)
        }

        const resolveTargets = (starts: string[]): number[] => {
            const queue = [...starts]
            const visited = new Set<string>()
            const targets: number[] = []
            while (queue.length) {
                const key = queue.shift()!
                if (visited.has(key)) continue
                visited.add(key)
                const node = row(nodeData[key])
                if (node?.type === "TalkNode") {
                    const first = Number(row(node.propsData)?.FirstDialogueId)
                    if (Number.isInteger(first) && first > 0 && !targets.includes(first)) targets.push(first)
                    continue
                }
                queue.push(...(adjacency.get(key) ?? []))
            }
            return targets
        }

        for (const [nodeKey, nodeValue] of Object.entries(nodeData)) {
            const node = row(nodeValue)
            const props = row(node?.propsData) ?? {}
            const first = Number(props.FirstDialogueId)
            if (node?.type !== "TalkNode" || !Number.isInteger(first) || first <= 0) continue
            const output = outputNodes.find(item => String(item.id) === String(node.key ?? nodeKey))
            const chain = Array.isArray(output?.dialogues) ? (output.dialogues as Row[]) : []
            if (!chain.length) continue
            const entries = new Map<string, Row>()
            const orderedOptions: Row[] = []
            for (const item of chain) {
                entries.set(String(item.id), item)
                for (const option of Array.isArray(item.options) ? (item.options as Row[]) : []) {
                    entries.set(String(option.id), option)
                    orderedOptions.push(option)
                }
            }
            const terminals = (start: unknown): string[] => {
                const queue = [String(start)]
                const visited = new Set<string>()
                const result: string[] = []
                while (queue.length) {
                    const key = queue.shift()!
                    if (visited.has(key)) continue
                    visited.add(key)
                    const item = entries.get(key)
                    if (!item) continue
                    const options = Array.isArray(item.options) ? (item.options as Row[]) : []
                    if (options.length) {
                        queue.push(...options.map(option => String(option.id)))
                        continue
                    }
                    if (item.next !== undefined) {
                        if (entries.has(String(item.next))) queue.push(String(item.next))
                        continue
                    }
                    result.push(key)
                }
                return result
            }
            const mergeNext = (ids: string[], targets: number[]): void => {
                const target = targets[0]
                if (target === undefined) return
                for (const id of ids) {
                    const item = optionMap.get(id) ?? dialogueMap.get(id)
                    if (item && item.next === undefined) item.next = target
                }
            }

            for (let index = 0; index < orderedOptions.length; index++) {
                const targets = resolveTargets(byPort.get(`${nodeKey}\x00Option_${index + 1}`) ?? [])
                mergeNext(terminals(orderedOptions[index].id), targets)
            }
            const ordinaryTargets: number[] = []
            for (const [key, children] of byPort) {
                const [start, port] = key.split("\x00")
                if (start !== nodeKey || port === "QuestStart" || port.startsWith("Option_")) continue
                for (const target of resolveTargets(children)) if (!ordinaryTargets.includes(target)) ordinaryTargets.push(target)
            }
            mergeNext(terminals(first), ordinaryTargets)

            if (linkUnimportGuideNext && props.TalkType === "UnimportGuide") {
                const siblingTargets: number[] = []
                for (const [source, port] of incoming.get(nodeKey) ?? []) {
                    const siblings = (byPort.get(`${source}\x00${port}`) ?? []).filter(value => value !== nodeKey)
                    for (const target of resolveTargets(siblings)) if (!siblingTargets.includes(target)) siblingTargets.push(target)
                }
                mergeNext(terminals(first), siblingTargets)
            }
        }
    }
    return story
}

function nodeStartIds(story: Row, nodes: VNodeTree[]): VNodeTree[] {
    const ids = new Set(nodes.map(node => String((node as Row).id)))
    const incoming = new Set<string>()
    for (const parentValue of Object.values(row(story.storyNodeData) ?? {})) {
        const edges = row(parentValue)?.questNodeData?.lineData
        for (const edgeValue of Array.isArray(edges) ? edges : []) {
            const edge = row(edgeValue)
            if (!edge || String(edge.startPort ?? "").toLowerCase() === "queststart") continue
            const end = String(edge.endQuest ?? "")
            if (ids.has(end)) incoming.add(end)
        }
    }
    return nodes.filter(node => !incoming.has(String((node as Row).id))).map(node => (node as Row).id)
}

export function enhanceDynamicStory(
    ctx: ModuleContext,
    path: unknown,
    nodes: VNodeTree[],
    values: unknown,
    linkUnimportGuideNext = true
): VNodeTree[] {
    const story = storyGraph(ctx, path, nodes, linkUnimportGuideNext)
    applyDynamicImpression(ctx, nodes, values)
    return story ? nodeStartIds(story, nodes) : []
}

export async function dynQuestModule(ctx: ModuleContext): Promise<VNodeTree> {
    const items = rows(ctx, "DynQuest")
    const dialogue = ctx.getArtifact<import("../dialogue/dialogueModule.ts").DialogueService>("Dialogue")
    if (!dialogue) throw new Error("DynQuest 需要 Dialogue 依赖")
    await dialogue.prepareStoryFlows(items.map(item => item.StoryPath))
    const result: Row[] = []
    for (const item of items) {
        const id = Number(item.DynQuestId)
        if (!id) continue
        const output: Row = {
            id,
            name: T(item.DynName ?? ""),
            level: item.PlayerLevel ?? [],
            regionId: item.RegionId,
            subRegionId: item.SubRegionId,
            chance: item.Chance,
            completeNum: item.CompleteNum,
            dayLimit: item.DayLimit,
            reward: item.Reward ?? [],
        }
        if (item.StoryPath) {
            const nodes = storylineNodes(ctx, item.StoryPath)
            const starts = enhanceDynamicStory(ctx, item.StoryPath, nodes, item.DynImpression)
            if (nodes.length) {
                output.nodes = nodes
                if (starts.length > 1) output.startIds = starts
            }
        }
        result.push(output)
    }
    return result
}
