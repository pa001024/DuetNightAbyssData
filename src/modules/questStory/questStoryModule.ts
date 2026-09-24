import type { ModuleContext } from "../../core/Graph.ts"
import { T, TRaw, TUnlessEqual, type VNodeTree } from "../../i18n/vnode.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"
import { fmodEventMediaName, hasExportedBgmAudio } from "../shared/dataHelpers.ts"
import { cinematicVideoWithMedia, dialogueFlowCgVideo, dialogueStageTalkVideo } from "../shared/storyStageMedia.ts"

type Row = Record<string, any>

interface StoryIndex {
    parents: Row[]
    byQuest: Map<number, Row[]>
}

interface ProcessedNodes {
    nodes: Row[]
    nextMap: Map<string, string[]>
    incomingMap: Map<string, string[]>
}

function mediaResource(value: unknown): string | undefined {
    if (typeof value !== "string" || !value) return undefined
    const quoted = value.match(/'([^']+)'/)?.[1]
    return (quoted ?? value).replaceAll("\\", "/") || undefined
}

function mediaResourceName(resource: string): string {
    return resource.split(/[./]/).at(-1)?.replaceAll("'", "") ?? ""
}

/**
 * BGM 节点只导出实际播放的音频事件。mute 事件（路径末段为 mute / mute.xxx）用于
 * 静音当前 BGM，SoundType=2 是 FMOD snapshot 控制事件（混响/静音等，无音频内容），
 * 都不属于具体曲目，不作为 BGM 媒体节点导出。
 */
function isMuteBgmEvent(resource: string): boolean {
    return /(?:^|\/)mute(?:\.|$)/i.test(resource.replaceAll("\\", "/").toLowerCase())
}

function storyMediaNode(nodeId: string, node: Row): Row | undefined {
    const props = row(node.propsData) ?? {}
    if (node.type === "VideoNode") {
        const resource = mediaResource(props.MediaSourceRef)
        if (!resource) return undefined
        return { id: nodeId, type: "VideoNode", name: node.name ?? "", resource: mediaResourceName(resource) }
    }
    if (node.type === "PlayOrStopBGMNode" && Number(props.SoundStateType) === 0) {
        const resource = mediaResource(props.SoundPath)
        if (!resource || Number(props.SoundType) === 2 || isMuteBgmEvent(resource)) return undefined
        const sound = fmodEventMediaName(resource)
        if (!sound || !hasExportedBgmAudio(sound)) return undefined
        return { id: nodeId, type: "PlayOrStopBGMNode", name: node.name ?? "", resource: sound }
    }
    return undefined
}

interface GuidePoints {
    values: Row
    ambiguous: Set<string>
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
        const questId = id(row(parent?.propsData)?.QuestId)
        const nodes = row(row(parent?.questNodeData)?.nodeData) ?? {}
        for (const nodeKey of sortedKeys(nodes)) {
            const node = row(nodes[nodeKey])
            if (node?.type !== "WaitingSpecialQuestStartAndFinishNode") continue
            const specialConfigId = id(row(node.propsData)?.SpecialConfigId) ?? questId
            if (specialConfigId === undefined) continue
            const path = row(configs[String(specialConfigId)])?.StoryPath
            if (typeof path !== "string" || !path || seen.has(path)) continue
            seen.add(path)
            result.push(path)
        }
    }
    return result
}

function iconName(value: unknown): string {
    if (typeof value !== "string") return ""
    return value.split("_").at(-1)?.replaceAll(".", "") ?? ""
}

function roundTiesToEven(value: number): number {
    const lower = Math.floor(value)
    const fraction = value - lower
    if (fraction < 0.5) return lower
    if (fraction > 0.5) return lower + 1
    return lower % 2 === 0 ? lower : lower + 1
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
            const specialPaths = collectSpecialStoryPaths(
                { storyNodeData: Object.fromEntries(parents.map(parent => [parent.key, parent])) },
                specialConfigs
            )
            const mainResult = processNodes(ctx, dialogue, parents, guidePoints, detectiveQuestions, detectiveAnswers)
            const mainNodes = mainResult.nodes
            if (mainNodes.length === 0) {
                mainNodes.push(...collectUnreachableNodes(ctx, dialogue, parents, guidePoints, detectiveQuestions, detectiveAnswers))
            }
            const specialNodes: Row[] = []
            let activeNextMap = mainResult.nextMap
            let activeIncomingMap = mainResult.incomingMap
            for (const path of specialPaths) {
                const specialStory = specialStories.get(path)
                if (!specialStory) continue
                const specialResult = processNodes(
                    ctx,
                    dialogue,
                    indexStory(specialStory).parents,
                    guidePoints,
                    detectiveQuestions,
                    detectiveAnswers
                )
                specialNodes.push(...specialResult.nodes)
                activeNextMap = specialResult.nextMap
                activeIncomingMap = specialResult.incomingMap
            }
            const combinedNodes = [...mainNodes, ...specialNodes]
            resolveNodeNext(combinedNodes, activeNextMap)
            const nodes = dedupeNodes(combinedNodes)
            if (nodes.length === 0 && !nameKey && !descKey) continue
            const quest: Record<string, VNodeTree> = { id: questId, name: nameKey ? TRaw(nameKey) : "" }
            if (descKey && descKey !== nameKey) quest.desc = TUnlessEqual(descKey, nameKey)
            if (nodes.length > 0) {
                quest.nodes = nodes
                const starts = startIds(parents, nodes, activeIncomingMap)
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

function guidePointCollisionKey(value: string): string {
    return value.replace(/[^0-9A-Za-z]/g, "").toLowerCase()
}

function loadGuidePoints(ctx: ModuleContext): GuidePoints {
    const values: Row = {}
    const names = new Map<string, string>()
    const ambiguous = new Set<string>()
    for (const item of ctx.dm.loadScriptTableRows("Script/BluePrints/UI/TaskPanel/QuestGuidePointLocData.lua", ["X", "Y", "SubRegionId"])) {
        if (
            typeof item.__key !== "string" ||
            typeof item.X !== "number" ||
            typeof item.Y !== "number" ||
            typeof item.SubRegionId !== "number"
        )
            continue
        values[item.__key] = item
        const collisionKey = guidePointCollisionKey(item.__key)
        const existing = names.get(collisionKey)
        if (existing !== undefined && existing !== item.__key) ambiguous.add(collisionKey)
        else names.set(collisionKey, item.__key)
    }
    return { values, ambiguous }
}

function findGuidePoint(points: GuidePoints, token: unknown): Row | undefined {
    if (typeof token !== "string" || !token) return undefined
    const exact = points.values[token]
    if (points.ambiguous.has(guidePointCollisionKey(token))) return undefined
    return row(exact)
}

function pointForNode(points: GuidePoints, node: Row | undefined, context: Row | undefined): { srId?: number; pos?: number[] } {
    const resolve = (value: Row | undefined): { srId?: number; pos?: number[] } => {
        if (!value) return {}
        const props = row(value.propsData) ?? {}
        let token = props.GuidePointName || props.StoryGuidePointName
        if (!token) token = props.UnitBPPath || props.UnitName
        if (typeof token === "string" && (token.includes("/") || token.includes("\\"))) token = token.split(/[\\/]/).at(-1)?.split(".")[0]
        const point = findGuidePoint(points, token)
        if (!point) return {}
        const srId = id(point.SubRegionId)
        const x = Number(point.X)
        const y = Number(point.Y)
        const result: { srId?: number; pos?: number[] } = {}
        if (srId !== undefined) result.srId = srId
        if (Number.isFinite(x) && Number.isFinite(y)) result.pos = [roundTiesToEven(x), roundTiesToEven(y)]
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
    guidePoints: GuidePoints,
    questions: Row,
    answers: Row
): ProcessedNodes {
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
            const sources = incoming.get(end) ?? []
            if (!sources.includes(start)) sources.push(start)
            incoming.set(end, sources)
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
                if (!visited.has(child)) queue.push(child)
            }
            const node = row(nodeMap.get(key))
            if (!node) continue
            const built = buildNode(ctx, dialogue, key, node, parent, guidePoints, questions, answers, outgoing)
            if (built) {
                result.push(built)
            }
        }
    }
    // Media nodes without a valid incoming edge are standalone outputs. Keep
    // them without expanding other unreachable node types.
    for (const parent of parents) {
        const questData = row(parent.questNodeData)
        const nodeData = row(questData?.nodeData) ?? {}
        const edges = Array.isArray(questData?.lineData) ? questData.lineData.map(row).filter((v): v is Row => !!v) : []
        const incomingKeys = new Set<string>()
        const outgoingByStart = new Map<string, string[]>()
        for (const edge of edges) {
            if (!validEdge(edge)) continue
            const end = String(edge.endQuest ?? "")
            if (end) incomingKeys.add(end)
            const start = String(edge.startQuest ?? "")
            if (start && end) outgoingByStart.set(start, [...(outgoingByStart.get(start) ?? []), end])
        }
        for (const [key, value] of Object.entries(nodeData)) {
            const node = row(value)
            const nodeId = String(node?.key ?? key)
            if (!node || incomingKeys.has(key) || incomingKeys.has(nodeId) || !storyMediaNode(nodeId, node)) continue
            const outgoing = outgoingByStart.get(nodeId) ?? outgoingByStart.get(key) ?? []
            nextMap.set(nodeId, outgoing)
            const built = buildNode(ctx, dialogue, nodeId, node, parent, guidePoints, questions, answers, outgoing)
            if (built && !result.some(existing => String(existing.id) === nodeId)) result.push(built)
        }
    }
    const hasOrderedNodes = result.length > 0
    for (const parent of parents) {
        if (parent.type !== "TalkNode" && !storyMediaNode(String(parent.key ?? parent.name ?? ""), parent)) continue
        const props = row(parent.propsData) ?? {}
        if (props.FirstDialogueId || props.FlowAssetPath || storyMediaNode(String(parent.key ?? parent.name ?? ""), parent)) {
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
    return {
        nodes: result,
        nextMap: hasOrderedNodes ? nextMap : new Map(),
        incomingMap: hasOrderedNodes ? incoming : new Map(),
    }
}

function resolveNodeNext(nodes: Row[], nextMap: Map<string, string[]>): void {
    const outputIds = new Set(nodes.map(node => String(node.id)))
    for (const node of nodes) {
        const rawNext = Array.isArray(node.next) ? node.next.map(String) : []
        if (rawNext.length === 0) continue
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
        else delete node.next
    }
}

function collectUnreachableNodes(
    ctx: ModuleContext,
    dialogue: DialogueService,
    parents: Row[],
    guidePoints: GuidePoints,
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
    return result
}

function dedupeNodes(nodes: Row[]): Row[] {
    const deduped: Row[] = []
    const contentToId = new Map<string, string>()
    const duplicateToKept = new Map<string, string>()
    for (const node of nodes) {
        const key = JSON.stringify(Object.fromEntries(Object.entries(node).filter(([name]) => name !== "id")))
        const keptId = contentToId.get(key)
        if (keptId !== undefined) {
            duplicateToKept.set(String(node.id), keptId)
            continue
        }
        contentToId.set(key, String(node.id))
        deduped.push(node)
    }
    for (const node of deduped) {
        if (!Array.isArray(node.next)) continue
        const remapped: string[] = []
        for (const value of node.next) {
            let nextId = String(value)
            while (duplicateToKept.has(nextId)) nextId = duplicateToKept.get(nextId)!
            if (!remapped.includes(nextId)) remapped.push(nextId)
        }
        if (remapped.length > 0) node.next = remapped
        else delete node.next
    }
    return deduped
}

function buildNode(
    _ctx: ModuleContext,
    dialogue: DialogueService,
    nodeId: string,
    node: Row,
    context: Row | undefined,
    guidePoints: GuidePoints,
    questions: Row,
    answers: Row,
    next: string[] = []
): Row | undefined {
    const type = node.type
    const media = storyMediaNode(nodeId, node)
    if (media) {
        if (next.length > 0) media.next = [...next]
        const point = pointForNode(guidePoints, node, context)
        if (point.srId !== undefined) media.srId = point.srId
        if (point.pos) media.pos = point.pos
        return media
    }
    if (type !== "TalkNode" && type !== "UnlockDetectiveQuestionNode" && type !== "UnlockDetectiveAnswerNode") return undefined
    const output: Row = { id: nodeId, type, name: node.name ?? "" }
    const point = pointForNode(guidePoints, node, context)
    if (point.srId !== undefined) output.srId = point.srId
    if (point.pos) output.pos = point.pos
    if (next.length > 0) output.next = [...next]
    const props = row(node.propsData) ?? {}
    if (type === "TalkNode") {
        const video = cinematicVideoWithMedia(props) ?? dialogueStageTalkVideo(props) ?? dialogueFlowCgVideo(props)
        if (!("FirstDialogueId" in props) && !props.FlowAssetPath && !video) return undefined
        if (video) output.video = video
        const chain = props.FlowAssetPath ? dialogue.flowChain(props.FlowAssetPath) : dialogue.chain(props.FirstDialogueId)
        if (chain.length > 0) {
            output.dialogues = chain
            const dialogueLangs = new Set<string>()
            for (const value of chain) {
                const langs = row(value)?.__langs
                if (!Array.isArray(langs)) {
                    dialogueLangs.clear()
                    break
                }
                for (const lang of langs) dialogueLangs.add(String(lang))
            }
            if (dialogueLangs.size > 0) output.__fieldLangs = { dialogues: [...dialogueLangs] }
        }
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

function buildIncomingMap(parents: Row[]): Map<string, string[]> {
    const incoming = new Map<string, string[]>()
    for (const parent of parents) {
        const questData = row(parent.questNodeData)
        for (const edge of Array.isArray(questData?.lineData) ? questData.lineData.map(row).filter((v): v is Row => !!v) : []) {
            if (!validEdge(edge)) continue
            const end = String(edge.endQuest ?? "")
            const start = String(edge.startQuest ?? "")
            const sources = incoming.get(end) ?? []
            if (!sources.includes(start)) sources.push(start)
            incoming.set(end, sources)
        }
    }
    return incoming
}

function startIds(parents: Row[], nodes: VNodeTree[], activeIncoming: Map<string, string[]>): VNodeTree[] {
    let incoming = activeIncoming
    if (incoming.size === 0) incoming = buildIncomingMap(parents)
    if (incoming.size > 0) {
        return nodes.filter(node => (incoming.get(String((node as Row).id)) ?? []).length === 0).map(node => (node as Row).id)
    }

    const orderedIds = nodes.map(node => (node as Row).id)
    const nodeIds = new Set(orderedIds.map(String))
    const incomingIds = new Set<string>()
    for (const node of nodes) {
        for (const nextId of Array.isArray((node as Row).next) ? (node as Row).next : []) {
            const key = String(nextId)
            if (nodeIds.has(key)) incomingIds.add(key)
        }
    }
    const starts = orderedIds.filter(nodeId => !incomingIds.has(String(nodeId)))
    return starts.length > 0 ? starts : orderedIds.slice(0, 1)
}
