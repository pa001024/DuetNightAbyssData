/** QuestChain module - quest chain metadata and ordered quest links. */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

type Row = Record<string, any>

function iconName(value: unknown): string {
    if (!value) return ""
    return String(value).split(".").at(-1)?.replaceAll("'", "") ?? ""
}

function orderedQuests(chain: Row): VNodeTree[] {
    const quests = chain.Quests
    if (!quests || typeof quests !== "object" || Array.isArray(quests)) return []
    const ordered: VNodeTree[] = []
    const visited = new Set<string>()

    const nextIds = (quest: Row): unknown[] => {
        const next = quest.nextQuestIds
        if (!next || typeof next !== "object" || Array.isArray(next)) return []
        const result: unknown[] = []
        if ((next as Row).Success !== null && (next as Row).Success !== undefined) result.push((next as Row).Success)
        for (const [key, value] of Object.entries(next as Row)) {
            if (key !== "Success" && value !== null && value !== undefined) result.push(value)
        }
        return result
    }

    const visit = (id: unknown): void => {
        const key = String(id)
        if (visited.has(key)) return
        const quest = (quests as Row)[key]
        if (!quest || typeof quest !== "object") return
        visited.add(key)
        const output: Row = { id: Number.isNaN(Number(key)) ? id : Number(key) }
        if (quest.SubRegionId) output.sr = quest.SubRegionId
        if (quest.nextQuestIds && typeof quest.nextQuestIds === "object" && Object.keys(quest.nextQuestIds).length > 0)
            output.next = quest.nextQuestIds
        ordered.push(output)
        for (const next of nextIds(quest)) visit(next)
    }

    if (chain.StartQuestId !== null && chain.StartQuestId !== undefined) visit(chain.StartQuestId)
    for (const [id] of Object.entries(quests as Row)) visit(id)
    return ordered
}

function nonEmpty(output: Row, key: string, value: unknown): void {
    if (typeof value === "boolean") {
        if (value) output[key] = 1
    } else if (typeof value === "string") {
        if (value) output[key] = value
    } else if (typeof value === "number") {
        if (value) output[key] = value
    } else if (Array.isArray(value)) {
        if (value.length > 0) output[key] = value
    } else if (value && typeof value === "object") {
        if (Object.keys(value).length > 0) output[key] = value
    }
}

function processChain(_ctx: ModuleContext, chain: Row, stl: Row | undefined): VNodeTree | undefined {
    const id = chain.QuestChainId
    if (!id) return undefined
    const output: Row = {}
    nonEmpty(output, "id", id)
    nonEmpty(output, "name", chain.QuestChainName ? T(chain.QuestChainName) : "")
    nonEmpty(output, "chapterName", chain.ChapterName ? T(chain.ChapterName) : "")
    nonEmpty(output, "chapterNumber", chain.ChapterNumber ? T(chain.ChapterNumber) : "")
    nonEmpty(output, "episode", chain.Episode ? T(chain.Episode) : "")
    nonEmpty(output, "desc", chain.QuestDescription ? T(chain.QuestDescription) : "")
    nonEmpty(output, "detail", chain.QuestDetail ? T(chain.QuestDetail) : "")
    nonEmpty(output, "type", chain.QuestChainType)
    nonEmpty(output, "main", chain.MainStoryType)
    nonEmpty(output, "icon", iconName(chain.ChapterBeginEndIconPath))
    nonEmpty(output, "reward", chain.QuestChainReward)
    nonEmpty(output, "questReward", chain.QuestReward)
    nonEmpty(output, "npc", chain.QuestNpcId)
    nonEmpty(output, "startTime", chain.StartTime)
    nonEmpty(output, "endTime", chain.EndTime)
    const quests = stl ? orderedQuests(stl) : []
    if (quests.length > 0) output.quests = quests
    return output
}

export function questChainModule(ctx: ModuleContext): VNodeTree {
    const chains = (ctx.dm.getTable("QuestChain") as Record<string, Row>) || {}
    const stl = (ctx.dm.getTable("STLExportQuestChain") as Record<string, Row>) || {}
    const result: VNodeTree[] = []
    for (const chain of Object.values(chains)) {
        if (!chain || typeof chain !== "object") continue
        const built = processChain(ctx, chain, stl[String(chain.QuestChainId)])
        if (built) result.push(built)
    }
    return result
}
