import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import type { DialogueService } from "../src/modules/dialogue/dialogueModule.ts"
import { partyTopicModule } from "../src/modules/partyTopic/partyTopicModule.ts"

describe("partyTopicModule", () => {
    test("keeps a standalone first dialogue at its TalkNode position", async () => {
        const dialogue = {
            prepareStoryFlows: async () => {},
            storyTalks: () => [
                { firstDialogueId: 0, flowAssetPath: "flow" },
                { firstDialogueId: 1, flowAssetPath: "" },
            ],
            flowChain: () => [{ id: 1 }, { id: 2 }],
            chain: () => [{ id: 1 }],
        } as unknown as DialogueService
        const tables: Record<string, unknown> = {
            PartyNpc: { npc: { CharId: 10, PartyTopicList: [100] } },
            PartyTopic: { topic: { PartyTopicId: 100, PartyTopicName: "name", PartyTopicTalkId: "story" } },
        }
        const ctx = {
            dm: { getTable: (name: string) => tables[name] },
            getArtifact: () => dialogue,
        } as unknown as ModuleContext

        const result = (await partyTopicModule(ctx)) as Array<Record<string, any>>
        expect(result[0].dialogues.map((item: Record<string, unknown>) => item.id)).toEqual([2, 1])
    })
})
