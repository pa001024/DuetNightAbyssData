import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import type { DialogueService } from "../src/modules/dialogue/dialogueModule.ts"
import { collectSpecialStoryPaths, questStoryModule } from "../src/modules/questStory/questStoryModule.ts"

describe("QuestStory special stories", () => {
    test("collects only explicit configured story paths", () => {
        const story = {
            storyNodeData: {
                parent: {
                    questNodeData: {
                        nodeData: {
                            first: {
                                type: "WaitingSpecialQuestStartAndFinishNode",
                                propsData: { SpecialConfigId: 10 },
                            },
                            missingId: {
                                type: "WaitingSpecialQuestStartAndFinishNode",
                                propsData: {},
                            },
                            missingConfig: {
                                type: "WaitingSpecialQuestStartAndFinishNode",
                                propsData: { SpecialConfigId: 11 },
                            },
                        },
                    },
                },
            },
        }

        expect(collectSpecialStoryPaths(story, { 10: { StoryPath: "SpecialQuest/10.story" } })).toEqual(["SpecialQuest/10.story"])
    })

    test("keeps a TalkNode when its dialogue chain is empty", async () => {
        const story = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10 },
                    questNodeData: {
                        lineData: [{ startQuest: "start", startPort: "QuestStart", endQuest: "talk" }],
                        nodeData: {
                            start: { key: "start", type: "QuestStartNode", propsData: {} },
                            talk: { key: "talk", type: "TalkNode", name: "empty", propsData: { FirstDialogueId: 0 } },
                        },
                    },
                },
            },
        }
        const dialogue = {
            story: () => story,
            prepareStoryFlows: async () => {},
            prefetchReachable: () => {},
            chain: () => [],
        } as unknown as DialogueService
        const tables: Record<string, unknown> = {
            QuestChain: { 1: { QuestChainId: 1, StoryPath: "main.story" } },
            STLExportQuestChain: { 1: { Quests: { 10: {} } } },
            DetectiveQuestion: {},
            DetectiveAnswer: {},
            SpecialQuestConfig: {},
        }
        const ctx = {
            dm: {
                getTable: (name: string) => tables[name],
                loadScriptTableRows: () => [],
            },
            getArtifact: () => dialogue,
        } as unknown as ModuleContext

        const result = (await questStoryModule(ctx)) as Array<Record<string, any>>
        expect(result[0].quests[0].nodes).toEqual([{ id: "talk", type: "TalkNode", name: "empty" }])
    })
})
