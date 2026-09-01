import type { ModuleContext } from "../../core/Graph.ts"
import type { VNodeTree } from "../../i18n/vnode.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"
import { type Row, sequence, table } from "../shared/dataHelpers.ts"

interface GuidePointIndex {
    byName: Map<string, Row[]>
    byToken: Map<string, Row[]>
    byTerminalToken: Map<string, Row[]>
}

function normalizeGuidePointToken(value: unknown): string {
    return typeof value === "string" ? value.replaceAll(/[^0-9A-Za-z]+/g, "").toLowerCase() : ""
}

function appendIndex(index: Map<string, Row[]>, key: string, point: Row): void {
    if (!key) return
    const entries = index.get(key)
    if (entries) {
        if (!entries.includes(point)) entries.push(point)
    } else index.set(key, [point])
}

export function buildNpcGuidePointIndex(points: Row[]): GuidePointIndex {
    const index: GuidePointIndex = { byName: new Map(), byToken: new Map(), byTerminalToken: new Map() }
    for (const point of points) {
        const name = typeof point.__key === "string" ? point.__key : ""
        if (!name) continue
        appendIndex(index.byName, normalizeGuidePointToken(name), point)

        const seen = new Set<string>()
        const parts = name.split(/[^0-9A-Za-z]+/).filter(Boolean)
        for (const part of parts) {
            const normalizedPart = normalizeGuidePointToken(part)
            if (normalizedPart && !seen.has(normalizedPart)) {
                seen.add(normalizedPart)
                appendIndex(index.byToken, normalizedPart, point)
            }
            for (const chunk of part.match(/[0-9]+|[A-Za-z]+/g) ?? []) {
                const normalizedChunk = normalizeGuidePointToken(chunk)
                if (!normalizedChunk || (!/^\d+$/.test(normalizedChunk) && normalizedChunk.length < 3) || seen.has(normalizedChunk))
                    continue
                seen.add(normalizedChunk)
                appendIndex(index.byToken, normalizedChunk, point)
            }
        }

        const terminalTokens = new Set<string>()
        if (parts.length) terminalTokens.add(normalizeGuidePointToken(parts.at(-1)))
        const chunks = name.match(/[0-9]+|[A-Za-z]+/g)
        if (chunks?.length) terminalTokens.add(normalizeGuidePointToken(chunks.at(-1)))
        for (const token of terminalTokens) appendIndex(index.byTerminalToken, token, point)
    }
    return index
}

export function findNpcGuidePoint(index: GuidePointIndex, value: unknown): Row | undefined {
    const token = normalizeGuidePointToken(value)
    if (!token) return undefined
    const exactNames = index.byName.get(token) ?? []
    if (exactNames.length === 1) return exactNames[0]
    const candidates = index.byToken.get(token) ?? []
    if (candidates.length === 1) return candidates[0]
    if (!candidates.length) return undefined
    const candidateSet = new Set(candidates)
    const terminalCandidates = (index.byTerminalToken.get(token) ?? []).filter(point => candidateSet.has(point))
    return terminalCandidates.length === 1 ? terminalCandidates[0] : undefined
}

function extractPathToken(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const name = value.replaceAll("\\", "/").split("/").at(-1)?.split(".")[0] ?? ""
    return name.includes("_") ? (name.split("_").at(-1) ?? "") : name
}

function sortedStoryKeys(value: Row): string[] {
    return Object.keys(value).sort((left, right) => {
        const leftNumeric = /^\d+$/.test(left)
        const rightNumeric = /^\d+$/.test(right)
        if (leftNumeric !== rightNumeric) return leftNumeric ? -1 : 1
        if (leftNumeric) return BigInt(left) < BigInt(right) ? -1 : BigInt(left) > BigInt(right) ? 1 : 0
        return left.localeCompare(right)
    })
}

export function npcStoryDialogues(dialogue: DialogueService, path: unknown): Row[] {
    const story = dialogue.story(path)
    const parents = story?.storyNodeData && typeof story.storyNodeData === "object" ? (story.storyNodeData as Row) : {}
    const result: Row[] = []
    const append = (value: unknown): void => {
        const node = value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : undefined
        const props = node?.propsData
        if (node?.type !== "TalkNode" || !props?.FirstDialogueId) return
        result.push(...(dialogue.chain(props.FirstDialogueId) as Row[]))
    }
    for (const parentKey of sortedStoryKeys(parents)) {
        const parent = parents[parentKey] as Row
        append(parent)
        const nodeData = parent?.questNodeData?.nodeData
        if (!nodeData || typeof nodeData !== "object") continue
        for (const nodeKey of sortedStoryKeys(nodeData as Row)) append((nodeData as Row)[nodeKey])
    }
    return result
}

export function npcModule(ctx: ModuleContext): VNodeTree {
    const triggers = table(ctx, "TalkTrigger")
    const camps = table(ctx, "CharCamp")
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    const guidePoints = buildNpcGuidePointIndex(
        ctx.dm.loadScriptTableRows("Script/BluePrints/UI/TaskPanel/QuestGuidePointLocData.lua", ["X", "Y", "SubRegionId"])
    )
    return Object.values(table(ctx, "Npc"))
        .filter((value): value is Row => !!value && typeof value === "object" && !Array.isArray(value))
        .map(item => {
            const campName = camps[String(item.Camp)]?.CampName
            const output: Row = { id: item.UnitId }
            if (item.UnitName) output.name = { __t: "t", key: item.UnitName }
            if (campName) output.camp = { __t: "t", key: campName }
            else if (item.Camp) output.camp = item.Camp
            if (item.CharId) output.charId = item.CharId
            if (item.NpcType) output.type = item.NpcType
            if (item.MailHead) output.icon = (String(item.MailHead).split(/[./]/).at(-1)?.replaceAll("'", "") ?? "").replace(/^T_Head_/, "")

            const hasStoryPath = [item.RelatedTalks, item.RelatedBubble]
                .flatMap(sequence)
                .some(
                    triggerId => typeof triggers[String(triggerId)]?.StoryLinePath === "string" && triggers[String(triggerId)].StoryLinePath
                )
            const primaryToken = extractPathToken(item.UnitBPPath || item.UnitName)
            const point = hasStoryPath
                ? (findNpcGuidePoint(guidePoints, primaryToken) ?? findNpcGuidePoint(guidePoints, extractPathToken(item.UnitName)))
                : undefined
            if (point && Number(point.SubRegionId) > 0 && Number.isFinite(Number(point.X)) && Number.isFinite(Number(point.Y))) {
                output.srId = Number(point.SubRegionId)
                output.pos = [Math.round(Number(point.X)), Math.round(Number(point.Y))]
            }
            const talks: Row[] = []
            for (const triggerId of sequence(item.RelatedTalks)) {
                const trigger = triggers[String(triggerId)]
                if (!trigger?.StoryLinePath || !dialogue) continue
                talks.push(...npcStoryDialogues(dialogue, trigger.StoryLinePath))
            }
            if (talks.length) {
                const seen = new Set<string>()
                output.talks = talks.filter(talk => {
                    const key = String(talk.id)
                    if (seen.has(key)) return false
                    seen.add(key)
                    return true
                })
            }
            return output
        })
}
