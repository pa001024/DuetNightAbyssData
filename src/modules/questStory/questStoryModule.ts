import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"

type Row = Record<string, any>

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

function guideToken(value: unknown): string {
    if (typeof value !== "string") return ""
    return value.replace(/[^0-9A-Za-z]/g, "").toLowerCase()
}

function iconName(value: unknown): string {
    if (typeof value !== "string") return ""
    return value.split("_").at(-1)?.replaceAll(".", "") ?? ""
}

export function questStoryModule(ctx: ModuleContext): VNodeTree {
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    if (!dialogue) throw new Error("QuestStory 需要 Dialogue 依赖")
    const chains = table(ctx, "QuestChain")
    const stl = table(ctx, "STLExportQuestChain")
    const detectiveQuestions = table(ctx, "DetectiveQuestion")
    const detectiveAnswers = table(ctx, "DetectiveAnswer")
    const guidePoints = loadGuidePoints(ctx)
    const output: VNodeTree[] = []

    for (const chain of Object.values(chains)) {
        const chainRow = row(chain)
        const chainId = id(chainRow?.QuestChainId)
        if (!chainRow || chainId === undefined || !chainRow.StoryPath) continue
        const story = dialogue.story(chainRow.StoryPath)
        const questRows = row(stl[String(chainId)])?.Quests
        if (!story || !questRows || typeof questRows !== "object" || Array.isArray(questRows)) continue

        const quests: VNodeTree[] = []
        for (const questKey of Object.keys(questRows)) {
            const questId = id(questKey)
            if (questId === undefined) continue
            const owner = findQuestOwner(story, questId)
            const ownerProps = row(owner?.propsData) ?? {}
            const nameKey = typeof ownerProps.QuestDescription === "string" ? ownerProps.QuestDescription : ""
            const descKey = typeof ownerProps.QuestDeatil === "string" ? ownerProps.QuestDeatil : ""
            const nodes = processNodes(ctx, dialogue, story, questId, guidePoints, detectiveQuestions, detectiveAnswers)
            if (nodes.length === 0 && !nameKey && !descKey) continue
            const quest: Record<string, VNodeTree> = { id: questId }
            if (nameKey) quest.name = T(nameKey)
            if (descKey && descKey !== nameKey) quest.desc = T(descKey)
            if (nodes.length > 0) {
                quest.nodes = nodes
                const starts = startIds(story, questId, nodes)
                if (starts.length > 1) quest.startIds = starts
            }
            quests.push(quest)
        }
        if (quests.length > 0) output.push({ id: chainId, quests })
    }
    return output
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

function matchesQuest(node: Row, questId: number): boolean {
    const props = row(node.propsData) ?? {}
    if (Number(props.QuestId) === questId) return true
    if (props.QuestId !== undefined && Number(props.QuestId) !== 0) return false
    for (const key of ["QuestDescription", "QuestDeatil"]) {
        const match = typeof props[key] === "string" ? props[key].match(/_(\d+)_/) : null
        if (match && Number(match[1]) === questId) return true
    }
    return false
}

function findQuestOwner(story: Row, questId: number): Row | undefined {
    const data = row(story.storyNodeData)
    return Object.values(data ?? {})
        .map(row)
        .find((node): node is Row => !!node && matchesQuest(node, questId))
}

function validEdge(edge: Row): boolean {
    const port = String(edge.startPort ?? "").toLowerCase()
    return port !== "queststart" && port !== "fail" && port !== "passivefail" && port !== "false"
}

function processNodes(
    ctx: ModuleContext,
    dialogue: DialogueService,
    story: Row,
    questId: number,
    guidePoints: Row,
    questions: Row,
    answers: Row
): VNodeTree[] {
    const result: Row[] = []
    const nextMap = new Map<string, string[]>()
    const incoming = new Map<string, string[]>()
    const data = row(story.storyNodeData)
    for (const parent of Object.values(data ?? {}).map(row)) {
        if (!parent || !matchesQuest(parent, questId)) continue
        const questData = row(parent.questNodeData)
        const nodeData = row(questData?.nodeData) ?? {}
        const edges = Array.isArray(questData?.lineData) ? questData.lineData.map(row).filter((v): v is Row => !!v) : []
        const nodeMap = new Map(Object.entries(nodeData))
        const starts = edges.filter(edge => String(edge.startPort ?? "").toLowerCase() === "queststart").map(edge => String(edge.endQuest))
        const queue = [...starts]
        const visited = new Set<string>()
        while (queue.length > 0) {
            const key = queue.shift()!
            if (visited.has(key)) continue
            visited.add(key)
            const outgoing = edges.filter(edge => String(edge.startQuest) === key && validEdge(edge)).map(edge => String(edge.endQuest))
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
    for (const parent of Object.values(data ?? {}).map(row)) {
        if (!parent || !matchesQuest(parent, questId) || parent.type !== "TalkNode") continue
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
    const deduped: Row[] = []
    const seen = new Set<string>()
    for (const node of result) {
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

function startIds(story: Row, questId: number, nodes: VNodeTree[]): VNodeTree[] {
    const ids = new Set(nodes.map(node => String((node as Row).id)))
    const incoming = new Set<string>()
    for (const parent of Object.values(row(story.storyNodeData) ?? {}).map(row)) {
        if (!parent || !matchesQuest(parent, questId)) continue
        const questData = row(parent.questNodeData)
        for (const edge of Array.isArray(questData?.lineData) ? questData.lineData.map(row).filter((v): v is Row => !!v) : []) {
            if (String(edge.startPort ?? "").toLowerCase() === "queststart") continue
            const end = String(edge.endQuest ?? "")
            if (ids.has(end)) incoming.add(end)
        }
    }
    return nodes.filter(node => !incoming.has(String((node as Row).id))).map(node => (node as Row).id)
}
