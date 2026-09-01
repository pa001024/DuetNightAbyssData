import type { ModuleContext } from "../../core/Graph.ts"
import type { VNodeTree } from "../../i18n/vnode.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"
import { type Row, sequence } from "../shared/dataHelpers.ts"

export interface StorylineOptions {
    includeNodeNext?: boolean
    linkUnimportDialogueNext?: boolean
    linkDialogueNext?: boolean
    pruneSequentialNodeNext?: boolean
    questStartThenKeyOrder?: boolean
    includeSelfNodeNext?: boolean
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

export function storylineNodes(ctx: ModuleContext, path: unknown, options: StorylineOptions = {}): VNodeTree[] {
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    const story = dialogue?.story(path)
    if (!story || !dialogue) return []
    const result: Row[] = []
    const data = story.storyNodeData && typeof story.storyNodeData === "object" ? story.storyNodeData : {}
    const parentKeys = sortedKeys(data as Row)
    for (const parentKey of parentKeys) {
        const parent = (data as Row)[parentKey] as Row
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
        if (options.questStartThenKeyOrder) {
            for (const key of [...starts, ...sortedKeys(nodeData as Row)]) if (!orderedKeys.includes(key)) orderedKeys.push(key)
        } else {
            const visited = new Set<string>()
            const queue = [...starts]
            const visitQueue = (): void => {
                while (queue.length) {
                    const key = queue.shift()!
                    if (visited.has(key)) continue
                    visited.add(key)
                    orderedKeys.push(key)
                    const priority = (child: string): number =>
                        (nodeData[child] as Row | undefined)?.propsData?.TalkType === "UnimportGuide" ? 0 : 1
                    const children = [...(next.get(key) ?? [])].sort((left, right) => priority(left) - priority(right))
                    for (const child of children) if (!visited.has(child) && !queue.includes(child)) queue.push(child)
                }
            }
            visitQueue()
            for (const key of appearance) {
                if (visited.has(key)) continue
                queue.push(key)
                visitQueue()
            }
            if (orderedKeys.length === 0) orderedKeys.push(...sortedKeys(nodeData as Row))
        }
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
            if (!options.includeSelfNodeNext) successors = successors.filter(value => value !== id)
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
            result.push(out)
            parentResults.push(out)
        }
        const outputIds = new Set(parentResults.map(node => String(node.id)))
        for (const out of parentResults) {
            if (!Array.isArray(out.next)) continue
            const filtered = [...new Set(out.next.map(String))].filter(
                value => (options.includeSelfNodeNext || value !== String(out.id)) && outputIds.has(value)
            )
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

export function eventStorylineNodes(ctx: ModuleContext, path: unknown): VNodeTree[] {
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    const story = dialogue?.story(path)
    if (!story || !dialogue) return []
    const result: Row[] = []
    const parents = story.storyNodeData && typeof story.storyNodeData === "object" ? (story.storyNodeData as Row) : {}
    for (const parentKey of sortedKeys(parents)) {
        const quest = parents[parentKey]?.questNodeData
        const nodeData = quest?.nodeData && typeof quest.nodeData === "object" ? (quest.nodeData as Row) : {}
        const edges = Array.isArray(quest?.lineData) ? (quest.lineData as Row[]) : []
        const starts: string[] = []
        const next = new Map<string, string[]>()
        for (const edge of edges) {
            const start = String(edge.startQuest ?? "")
            const end = String(edge.endQuest ?? "")
            const port = String(edge.startPort ?? "").toLowerCase()
            if (port === "queststart") {
                if (end) starts.push(end)
                continue
            }
            if (!start || !end || port === "fail" || port === "passivefail" || port === "false") continue
            const children = next.get(start) ?? []
            if (!children.includes(end)) children.push(end)
            next.set(start, children)
        }
        const queue = [...starts]
        const visited = new Set<string>()
        while (queue.length) {
            const key = queue.shift()!
            if (visited.has(key)) continue
            visited.add(key)
            const node = nodeData[key] as Row | undefined
            if (node?.type === "TalkNode") {
                const props = node.propsData ?? {}
                const out: Row = { id: key, type: "TalkNode", name: node.name ?? "" }
                const children = next.get(key)
                if (children?.length) out.next = children
                const chain = props.FirstDialogueId ? dialogue.chain(props.FirstDialogueId) : []
                if (chain.length) out.dialogues = chain
                result.push(out)
            }
            for (const child of next.get(key) ?? []) if (!visited.has(child)) queue.push(child)
        }
    }
    return result
}
