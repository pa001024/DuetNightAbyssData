import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"

type Row = Record<string, any>

interface StoryIndex {
    parents: Row[]
    byQuest: Map<number, Row[]>
}

function table(ctx: ModuleContext, name: string): Row {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : {}
}

function row(value: unknown): Row | undefined {
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : undefined
}

function id(value: unknown): number | undefined {
    const n = Number(value)
    return Number.isInteger(n) && n > 0 ? n : undefined
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

export function collectSpecialStoryPaths(story: Row, configs: Row): string[] {
    const result: string[] = []
    const seen = new Set<string>()
    const parents = row(story.storyNodeData) ?? {}
    for (const parentKey of sortedKeys(parents)) {
        const parent = row(parents[parentKey])
        const nodes = row(row(parent?.questNodeData)?.nodeData) ?? {}
        for (const nodeKey of sortedKeys(nodes)) {
            const node = row(nodes[nodeKey])
            if (node?.type !== "WaitingSpecialQuestStartAndFinishNode") continue
            const specialConfigId = id(row(node.propsData)?.SpecialConfigId)
            if (specialConfigId === undefined) continue
            const path = row(configs[String(specialConfigId)])?.StoryPath
            if (typeof path !== "string" || !path || seen.has(path)) continue
            seen.add(path)
            result.push(path)
        }
    }
    return result
}

function guideToken(value: unknown): string {
    if (typeof value !== "string") return ""
    return value.replace(/[^0-9A-Za-z]/g, "").toLowerCase()
}

function iconName(value: unknown): string {
    if (typeof value !== "string") return ""
    return value.split("_").at(-1)?.replaceAll(".", "") ?? ""
}

export async function questStoryModule(ctx: ModuleContext): Promise<VNodeTree> {
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    if (!dialogue) throw new Error("QuestStory 需要 Dialogue 依赖")
    const chains = table(ctx, "QuestChain")
    const stl = table(ctx, "STLExportQuestChain")
    const detectiveQuestions = table(ctx, "DetectiveQuestion")
    const detectiveAnswers = table(ctx, "DetectiveAnswer")
    const specialConfigs = table(ctx, "SpecialQuestConfig")
    const guidePoints = loadGuidePoints(ctx)
    const output: VNodeTree[] = []
    const entries: Array<{ chainId: number; storyPath: unknown; story: Row; questRows: Row }> = []

    for (const chain of Object.values(chains)) {
        const chainRow = row(chain)
        const chainId = id(chainRow?.QuestChainId)
        if (!chainRow || chainId === undefined || !chainRow.StoryPath) continue
        const story = dialogue.story(chainRow.StoryPath)
        const questRows = row(stl[String(chainId)])?.Quests
        if (!story || !questRows || typeof questRows !== "object" || Array.isArray(questRows)) continue
        entries.push({ chainId, storyPath: chainRow.StoryPath, story, questRows: questRows as Row })
    }
    const specialStories = new Map<string, Row>()
    for (const path of entries.flatMap(entry => collectSpecialStoryPaths(entry.story, specialConfigs))) {
        const story = dialogue.story(path)
        if (story) specialStories.set(path, story)
    }
    await dialogue.prepareStoryFlows([...entries.map(entry => entry.storyPath), ...specialStories.keys()])
    dialogue.prefetchReachable([
        ...entries.flatMap(entry => collectDialogueStarts(entry.story)),
        ...[...specialStories.values()].flatMap(collectDialogueStarts),
    ])

    for (const entry of entries) {
        const { chainId, story, questRows } = entry
        const storyIndex = indexStory(story)

        const quests: VNodeTree[] = []
        for (const questKey of Object.keys(questRows)) {
            const questId = id(questKey)
            if (questId === undefined) continue
            const parents = storyIndex.byQuest.get(questId) ?? []
            const owner = parents[0]
            const ownerProps = row(owner?.propsData) ?? {}
            const nameKey = typeof ownerProps.QuestDescription === "string" ? ownerProps.QuestDescription : ""
            const descKey = typeof ownerProps.QuestDeatil === "string" ? ownerProps.QuestDeatil : ""
            const specialParents = collectSpecialStoryPaths(
                { storyNodeData: Object.fromEntries(parents.map(parent => [parent.key, parent])) },
                specialConfigs
            ).flatMap(path => indexStory(specialStories.get(path) ?? {}).parents)
            const mainNodes = processNodes(ctx, dialogue, parents, guidePoints, detectiveQuestions, detectiveAnswers)
            if (mainNodes.length === 0) {
                mainNodes.push(...collectUnreachableNodes(ctx, dialogue, parents, guidePoints, detectiveQuestions, detectiveAnswers))
            }
            const specialNodes = processNodes(ctx, dialogue, specialParents, guidePoints, detectiveQuestions, detectiveAnswers)
            const nodes = dedupeNodes([...mainNodes, ...specialNodes])
            const allParents = [...parents, ...specialParents]
            if (nodes.length === 0 && !nameKey && !descKey) continue
            const quest: Record<string, VNodeTree> = { id: questId }
            if (nameKey) quest.name = T(nameKey)
            if (descKey && descKey !== nameKey) quest.desc = T(descKey)
            if (nodes.length > 0) {
                quest.nodes = nodes
                const starts = startIds(allParents, nodes)
                if (starts.length > 1) quest.startIds = starts
            }
            quests.push(quest)
        }
        if (quests.length > 0) output.push({ id: chainId, quests })
    }
    return output
}

function collectDialogueStarts(story: Row): number[] {
    const result: number[] = []
    const visit = (value: unknown): void => {
        const node = row(value)
        if (!node) return
        if (node.type === "TalkNode") {
            const props = row(node.propsData) ?? {}
            const first = id(props.FirstDialogueId)
            if (first !== undefined) result.push(first)
        }
        const quest = row(node.questNodeData)
        const children = row(quest?.nodeData)
        for (const child of Object.values(children ?? {})) visit(child)
    }
    for (const node of Object.values(row(story.storyNodeData) ?? {})) visit(node)
    return result
}

function indexStory(story: Row): StoryIndex {
    const parents: Row[] = []
    const byQuest = new Map<number, Row[]>()
    const storyNodeData = row(story.storyNodeData) ?? {}
    for (const key of sortedKeys(storyNodeData)) {
        const value = storyNodeData[key]
        const parent = row(value)
        if (!parent) continue
        parents.push(parent)
        const props = row(parent.propsData) ?? {}
        const questIds = new Set<number>()
        const explicit = id(props.QuestId)
        if (explicit !== undefined) questIds.add(explicit)
        if (props.QuestId === undefined || Number(props.QuestId) === 0) {
            for (const key of ["QuestDescription", "QuestDeatil"]) {
                const match = typeof props[key] === "string" ? props[key].match(/_(\d+)_/) : null
                const parsed = id(match?.[1])
                if (parsed !== undefined) questIds.add(parsed)
            }
        }
        for (const questId of questIds) {
            const list = byQuest.get(questId) ?? []
            list.push(parent)
            byQuest.set(questId, list)
        }
    }
    return { parents, byQuest }
}

function loadGuidePoints(ctx: ModuleContext): Row {
    const points: Row = {}
    for (const item of ctx.dm.loadScriptTableRows("Script/BluePrints/UI/TaskPanel/QuestGuidePointLocData.lua", ["X", "Y", "SubRegionId"])) {
        if (
            typeof item.__key !== "string" ||
            typeof item.X !== "number" ||
            typeof item.Y !== "number" ||
            typeof item.SubRegionId !== "number"
        )
            continue
        points[item.__key] = item
    }
    return points
}

function findGuidePoint(points: Row, token: unknown): Row | undefined {
    const normalized = guideToken(token)
    if (!normalized) return undefined
    const exact = points[String(token)]
    if (row(exact)) return exact
    const candidates = Object.entries(points).filter(([name]) => {
        const value = guideToken(name)
        return value === normalized || value.endsWith(normalized) || value.includes(normalized)
    })
    return candidates.length === 1 ? row(candidates[0][1]) : undefined
}

function pointForNode(points: Row, node: Row | undefined, context: Row | undefined): { srId?: number; pos?: number[] } {
    const resolve = (value: Row | undefined): { srId?: number; pos?: number[] } => {
        if (!value) return {}
        const props = row(value.propsData) ?? {}
        let token = props.GuidePointName || props.StoryGuidePointName
        if (!token) token = props.UnitBPPath || props.UnitName
        if (typeof token === "string" && (token.includes("/") || token.includes("\\"))) token = token.split(/[\\/]/).at(-1)?.split(".")[0]
        const point = findGuidePoint(points, token)
        if (!point) {
            const srId = id(props.SubRegionId)
            return srId === undefined ? {} : { srId }
        }
        const srId = id(point.SubRegionId) ?? id(props.SubRegionId)
        const x = Number(point.X)
        const y = Number(point.Y)
        const result: { srId?: number; pos?: number[] } = {}
        if (srId !== undefined) result.srId = srId
        if (Number.isFinite(x) && Number.isFinite(y)) result.pos = [Math.round(x), Math.round(y)]
        return result
    }
    return { ...resolve(context), ...resolve(node) }
}

function validEdge(edge: Row): boolean {
    const port = String(edge.startPort ?? "").toLowerCase()
    return port !== "queststart" && port !== "fail" && port !== "passivefail" && port !== "false"
}

function processNodes(
    ctx: ModuleContext,
    dialogue: DialogueService,
    parents: Row[],
    guidePoints: Row,
    questions: Row,
    answers: Row
): Row[] {
    const result: Row[] = []
    const nextMap = new Map<string, string[]>()
    const incoming = new Map<string, string[]>()
    for (const parent of parents) {
        const questData = row(parent.questNodeData)
        const nodeData = row(questData?.nodeData) ?? {}
        const edges = Array.isArray(questData?.lineData) ? questData.lineData.map(row).filter((v): v is Row => !!v) : []
        const nodeMap = new Map(Object.entries(nodeData))
        const outgoingByStart = new Map<string, string[]>()
        const starts: string[] = []
        for (const edge of edges) {
            const start = String(edge.startQuest ?? "")
            const end = String(edge.endQuest ?? "")
            if (String(edge.startPort ?? "").toLowerCase() === "queststart") {
                if (end) starts.push(end)
                continue
            }
            if (!start || !end || !validEdge(edge)) continue
            const outgoing = outgoingByStart.get(start) ?? []
            outgoing.push(end)
            outgoingByStart.set(start, outgoing)
        }
        const queue = [...starts]
        const visited = new Set<string>()
        while (queue.length > 0) {
            const key = queue.shift()!
            if (visited.has(key)) continue
            visited.add(key)
            const outgoing = outgoingByStart.get(key) ?? []
            nextMap.set(key, outgoing)
            for (const child of outgoing) {
                const list = incoming.get(child) ?? []
                if (!list.includes(key)) list.push(key)
                incoming.set(child, list)
                if (!visited.has(child)) queue.push(child)
            }
            const node = row(nodeMap.get(key))
            if (!node) continue
            const built = buildNode(ctx, dialogue, key, node, parent, guidePoints, questions, answers)
            if (built) result.push(built)
        }
    }
    for (const parent of parents) {
        if (parent.type !== "TalkNode") continue
        const props = row(parent.propsData) ?? {}
        if (props.FirstDialogueId || props.FlowAssetPath) {
            const built = buildNode(
                ctx,
                dialogue,
                String(parent.key ?? parent.name ?? ""),
                parent,
                undefined,
                guidePoints,
                questions,
                answers
            )
            if (built) result.push(built)
        }
    }
    const outputIds = new Set(result.map(node => String(node.id)))
    for (const node of result) {
        const rawNext = nextMap.get(String(node.id)) ?? []
        const resolved: string[] = []
        const queue = [...rawNext]
        const seen = new Set<string>()
        while (queue.length > 0) {
            const key = queue.shift()!
            if (seen.has(key)) continue
            seen.add(key)
            if (outputIds.has(key)) resolved.push(key)
            else queue.push(...(nextMap.get(key) ?? []))
        }
        if (resolved.length > 0) node.next = [...new Set(resolved)]
    }
    return dedupeNodes(result)
}

function collectUnreachableNodes(
    ctx: ModuleContext,
    dialogue: DialogueService,
    parents: Row[],
    guidePoints: Row,
    questions: Row,
    answers: Row
): Row[] {
    const result: Row[] = []
    for (const parent of parents) {
        const nodeData = row(row(parent.questNodeData)?.nodeData) ?? {}
        for (const key of sortedKeys(nodeData)) {
            const node = row(nodeData[key])
            if (!node) continue
            const built = buildNode(ctx, dialogue, String(node.key ?? key), node, parent, guidePoints, questions, answers)
            if (built) result.push(built)
        }
    }
    return dedupeNodes(result)
}

function dedupeNodes(nodes: Row[]): Row[] {
    const deduped: Row[] = []
    const seen = new Set<string>()
    for (const node of nodes) {
        const key = JSON.stringify(Object.fromEntries(Object.entries(node).filter(([name]) => name !== "id")))
        if (seen.has(key)) continue
        seen.add(key)
        deduped.push(node)
    }
    return deduped
}

function buildNode(
    _ctx: ModuleContext,
    dialogue: DialogueService,
    nodeId: string,
    node: Row,
    context: Row | undefined,
    guidePoints: Row,
    questions: Row,
    answers: Row
): Row | undefined {
    const type = node.type
    if (type !== "TalkNode" && type !== "UnlockDetectiveQuestionNode" && type !== "UnlockDetectiveAnswerNode") return undefined
    const output: Row = { id: nodeId, type, name: node.name ?? "" }
    const point = pointForNode(guidePoints, node, context)
    if (point.srId !== undefined) output.srId = point.srId
    if (point.pos) output.pos = point.pos
    const props = row(node.propsData) ?? {}
    if (type === "TalkNode") {
        const chain = props.FlowAssetPath ? dialogue.flowChain(props.FlowAssetPath) : dialogue.chain(props.FirstDialogueId)
        if (chain.length > 0) output.dialogues = chain
        else return undefined
    } else if (type === "UnlockDetectiveQuestionNode") {
        const values: Row[] = []
        for (const qid of Array.isArray(props.QuestionIds) ? props.QuestionIds : []) {
            const data = row(questions[String(qid)])
            if (!data) continue
            values.push({
                id: data.QuestionID,
                name: T(data.QuestName ?? ""),
                answers: data.ProbablyNeededAnswers ?? [],
                tips: T(data.Tips ?? ""),
            })
        }
        if (values.length > 0) output.questions = values
    } else {
        const values: Row[] = []
        for (const aid of Array.isArray(props.AnswerIds) ? props.AnswerIds : []) {
            const data = row(answers[String(aid)])
            if (!data) continue
            values.push({
                id: data.AnswerID,
                qid: data.QuestionID,
                name: T(data.Name ?? ""),
                desc: T(data.Detail ?? ""),
                icon: iconName(data.Icon),
            })
        }
        if (values.length > 0) output.answers = values
    }
    return output
}

function startIds(parents: Row[], nodes: VNodeTree[]): VNodeTree[] {
    const ids = new Set(nodes.map(node => String((node as Row).id)))
    const incoming = new Map<string, string[]>()
    for (const parent of parents) {
        const questData = row(parent.questNodeData)
        for (const edge of Array.isArray(questData?.lineData) ? questData.lineData.map(row).filter((v): v is Row => !!v) : []) {
            if (String(edge.startPort ?? "").toLowerCase() === "queststart") continue
            const end = String(edge.endQuest ?? "")
            if (!ids.has(end)) continue
            const start = String(edge.startQuest ?? "")
            const sources = incoming.get(end) ?? []
            if (!sources.includes(start)) sources.push(start)
            incoming.set(end, sources)
        }
    }
    return nodes.filter(node => (incoming.get(String((node as Row).id)) ?? []).length === 0).map(node => (node as Row).id)
}
