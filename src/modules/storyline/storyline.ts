import type { ModuleContext } from "../../core/Graph.ts"
import type { VNodeTree } from "../../i18n/vnode.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"
import { type Row, sequence } from "../shared/dataHelpers.ts"

export interface StorylineOptions {
    includeNodeNext?: boolean
    linkUnimportDialogueNext?: boolean
    linkDialogueNext?: boolean
    pruneSequentialNodeNext?: boolean
}

export function storylineNodes(ctx: ModuleContext, path: unknown, options: StorylineOptions = {}): VNodeTree[] {
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    const story = dialogue?.story(path)
    if (!story || !dialogue) return []
    const result: Row[] = []
    const data = story.storyNodeData && typeof story.storyNodeData === "object" ? story.storyNodeData : {}
    for (const parentValue of Object.values(data as Row)) {
        const parent = parentValue as Row
        if (parent?.type === "TalkNode") {
            const props = parent.propsData ?? {}
            const chain = props.FlowAssetPath ? dialogue.flowChain(props.FlowAssetPath) : dialogue.chain(props.FirstDialogueId)
            if (props.FirstDialogueId || props.FlowAssetPath) {
                const out: Row = { id: String(parent.key ?? ""), type: "TalkNode", name: parent.name ?? "" }
                if (chain.length) out.dialogues = chain
                result.push(out)
            }
        }
        const quest = parent?.questNodeData
        const nodeData = quest?.nodeData && typeof quest.nodeData === "object" ? quest.nodeData : {}
        const edges = Array.isArray(quest?.lineData) ? quest.lineData : Object.values(quest?.lineData ?? {})
        const next = new Map<string, string[]>()
        const incoming = new Map<string, Array<[string, string]>>()
        const byPort = new Map<string, string[]>()
        const starts: string[] = []
        const appearance: string[] = []
        const appeared = new Set<string>()
        const remember = (value: string): void => {
            if (value && !appeared.has(value)) {
                appeared.add(value)
                appearance.push(value)
            }
        }
        for (const edge of edges as Row[]) {
            if (!edge) continue
            const start = String(edge.startQuest ?? "")
            const end = String(edge.endQuest ?? "")
            remember(end)
            remember(start)
            if (String(edge.startPort ?? "").toLowerCase() === "queststart" && end) starts.push(end)
            if (start && end) {
                incoming.set(end, [...(incoming.get(end) ?? []), [start, String(edge.startPort ?? "")]])
                const portKey = `${start}\x00${String(edge.startPort ?? "")}`
                byPort.set(portKey, [...(byPort.get(portKey) ?? []), end])
                if (String(edge.startPort ?? "").toLowerCase() !== "queststart") next.set(start, [...(next.get(start) ?? []), end])
            }
        }
        const orderedKeys: string[] = []
        const visited = new Set<string>()
        const queue = [...starts]
        const visitQueue = (): void => {
            while (queue.length) {
                const key = queue.shift()!
                if (visited.has(key)) continue
                visited.add(key)
                orderedKeys.push(key)
                const children = [...(next.get(key) ?? [])].sort(child =>
                    (nodeData[child] as Row | undefined)?.propsData?.TalkType === "UnimportGuide" ? -1 : 0
                )
                for (const child of children) if (!visited.has(child) && !queue.includes(child)) queue.push(child)
            }
        }
        visitQueue()
        for (const key of appearance) {
            if (visited.has(key)) continue
            queue.push(key)
            visitQueue()
        }
        for (const key of Object.keys(nodeData)) if (!visited.has(key)) orderedKeys.push(key)
        const resolveTalkTargets = (startIds: string[]): string[] => {
            const pending = [...startIds]
            const visited = new Set<string>()
            const targets: string[] = []
            while (pending.length) {
                const current = pending.shift()!
                if (visited.has(current)) continue
                visited.add(current)
                const candidate = nodeData[current] as Row | undefined
                if (candidate?.type === "TalkNode") {
                    const candidateProps = candidate.propsData ?? {}
                    if (candidateProps.FirstDialogueId || candidateProps.FlowAssetPath) targets.push(current)
                    continue
                }
                pending.push(...(next.get(current) ?? []))
            }
            return [...new Set(targets)]
        }
        const nodeFirstDialogue = new Map<string, { id: number; talkType?: string }>()
        for (const [key, nodeValue] of Object.entries(nodeData as Row)) {
            const node = nodeValue as Row
            if (node?.type !== "TalkNode") continue
            const first = Number(node.propsData?.FirstDialogueId)
            if (Number.isInteger(first) && first > 0)
                nodeFirstDialogue.set(String(node.key ?? key), { id: first, talkType: node.propsData?.TalkType })
        }
        const parentResults: Row[] = []
        for (const key of orderedKeys) {
            const node = nodeData[key] as Row
            if (node?.type !== "TalkNode") continue
            const props = node.propsData ?? {}
            const chain = props.FlowAssetPath ? dialogue.flowChain(props.FlowAssetPath) : dialogue.chain(props.FirstDialogueId)
            if (!props.FirstDialogueId && !props.FlowAssetPath && chain.length === 0) continue
            const id = String(node.key ?? key)
            const out: Row = { id, type: "TalkNode", name: node.name ?? "" }
            let successors = resolveTalkTargets(next.get(id) ?? [])
            let siblingTarget: string | undefined
            if (!successors.length && props.TalkType === "UnimportGuide") {
                const siblings: string[] = []
                for (const [parentId, port] of incoming.get(id) ?? []) {
                    for (const sibling of byPort.get(`${parentId}\x00${port}`) ?? []) {
                        if (sibling !== id) siblings.push(sibling)
                    }
                }
                successors = resolveTalkTargets(siblings)
            } else if (props.TalkType === "UnimportGuide") {
                for (const [parentId, port] of incoming.get(id) ?? []) {
                    const siblingTalks = resolveTalkTargets(byPort.get(`${parentId}\x00${port}`) ?? [])
                    siblingTarget = siblingTalks.find(value => value !== id)
                    if (siblingTarget) break
                }
            }
            if (options.includeNodeNext !== false && successors.length) out.next = successors
            if (chain.length) out.dialogues = chain
            const linkSingleSuccessor = options.linkDialogueNext && successors.length === 1
            const linkUnimportSuccessor = options.linkUnimportDialogueNext && props.TalkType === "UnimportGuide" && successors.length > 0
            if ((linkSingleSuccessor || linkUnimportSuccessor) && chain.length) {
                const target = nodeFirstDialogue.get(String(siblingTarget ?? successors[0]))
                const tail = chain.at(-1) as Row | undefined
                if (target && tail && tail.next === undefined) tail.next = target.id
            }
            if (chain.length || !props.FirstDialogueId) result.push(out)
            if (chain.length || !props.FirstDialogueId) parentResults.push(out)
        }
        const outputIds = new Set(parentResults.map(node => String(node.id)))
        for (const out of parentResults) {
            if (!Array.isArray(out.next)) continue
            const filtered = [...new Set(out.next.map(String))].filter(value => value !== String(out.id) && outputIds.has(value))
            if (filtered.length) out.next = filtered
            else delete out.next
        }
        if (options.pruneSequentialNodeNext !== false)
            for (let index = 0; index < parentResults.length; index++) {
                const out = parentResults[index]
                if (!Array.isArray(out.next)) continue
                const sequential = parentResults[index + 1]?.id
                const filtered = out.next.filter(value => String(value) !== String(sequential))
                if (filtered.length) out.next = filtered
                else delete out.next
            }
    }
    return result
}

export function storylineDialogues(ctx: ModuleContext, path: unknown): Row[] {
    const nodes = storylineNodes(ctx, path)
    return nodes.flatMap(node => sequence((node as Row).dialogues) as Row[])
}
