import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"

type Row = Record<string, any>

function table(ctx: ModuleContext, name: string): Row {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : {}
}

function nonEmpty(row: Row, key: string, value: unknown): void {
    if (value === undefined || value === null || value === "") return
    if (Array.isArray(value) && value.length === 0) return
    if (typeof value === "object" && !Array.isArray(value) && Object.keys(value as object).length === 0) return
    if (value === 0) return
    row[key] = value
}

export async function partyTopicModule(ctx: ModuleContext): Promise<VNodeTree> {
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    if (!dialogue) throw new Error("PartyTopic 需要 Dialogue 依赖")
    const charByTopic = new Map<number, number>()
    for (const npc of Object.values(table(ctx, "PartyNpc"))) {
        if (!npc || typeof npc !== "object") continue
        const item = npc as Row
        const charId = Number(item.CharId)
        if (!Number.isInteger(charId) || charId <= 0 || !Array.isArray(item.PartyTopicList)) continue
        for (const topicId of item.PartyTopicList) {
            const id = Number(topicId)
            if (Number.isInteger(id)) charByTopic.set(id, charId)
        }
    }
    // 310204 is present in game data although it is omitted from PartyNpc.PartyTopicList.
    if (!charByTopic.has(310204)) charByTopic.set(310204, 3102)

    const topicItems = Object.values(table(ctx, "PartyTopic")).filter((value): value is Row => !!value && typeof value === "object")
    await dialogue.prepareStoryFlows(topicItems.map(item => item.PartyTopicTalkId))
    const result: VNodeTree[] = []
    for (const value of topicItems) {
        if (!value || typeof value !== "object") continue
        const item = value as Row
        const topicId = Number(item.PartyTopicId)
        if (!Number.isInteger(topicId) || topicId <= 0) continue
        const output: Row = { id: topicId }
        const charId = charByTopic.get(topicId)
        nonEmpty(output, "charId", charId)
        output.name = T(item.PartyTopicName ?? "")
        if (item.PartyTopicDescription) output.desc = T(item.PartyTopicDescription)
        if (item.MemoryName) output.memoryName = T(item.MemoryName)
        if (item.MemoryDescription) output.memoryDesc = T(item.MemoryDescription)
        nonEmpty(output, "reward", item.PartyTopicReward)
        nonEmpty(output, "consume", item.PartyTopicConsume)
        nonEmpty(output, "conditionId", item.ConditionId)

        const talks = dialogue.storyTalks(item.PartyTopicTalkId)
        const standaloneFirstIds = new Set(
            talks.filter(talk => !talk.flowAssetPath && Number(talk.firstDialogueId) > 0).map(talk => String(Number(talk.firstDialogueId)))
        )
        const dialogues: VNodeTree[] = []
        const seen = new Set<string>()
        for (const talk of talks) {
            const chain = talk.flowAssetPath ? dialogue.flowChain(talk.flowAssetPath) : dialogue.chain(talk.firstDialogueId)
            for (const entry of chain) {
                const entryId = String((entry as Row).id)
                if (talk.flowAssetPath && standaloneFirstIds.has(entryId)) continue
                if (!seen.has(entryId)) {
                    seen.add(entryId)
                    dialogues.push(entry)
                }
            }
        }
        if (dialogues.length > 0) output.dialogues = dialogues
        result.push(output)
    }
    result.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    return result
}
