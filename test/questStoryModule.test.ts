import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import { renderTree } from "../src/i18n/vnode.ts"
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

    test("keeps a TalkNode with an explicit empty dialogue chain", async () => {
        const story = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10 },
                    questNodeData: {
                        lineData: [{ startQuest: "start", startPort: "QuestStart", endQuest: "talk" }],
                        nodeData: {
                            start: { key: "start", type: "QuestStartNode", propsData: {} },
                            talk: {
                                key: "talk",
                                type: "TalkNode",
                                name: "empty",
                                propsData: { FirstDialogueId: 0, SubRegionId: 123 },
                            },
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
        expect(result[0].quests[0].name).toBe("")
        expect(result[0].quests[0].nodes).toEqual([{ id: "talk", type: "TalkNode", name: "empty" }])
    })

    test("does not treat failure edges as incoming start links", async () => {
        const story = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10, QuestDescription: "name", QuestDeatil: "desc" },
                    questNodeData: {
                        lineData: [
                            { startQuest: "start", startPort: "QuestStart", endQuest: "a" },
                            { startQuest: "start", startPort: "QuestStart", endQuest: "b" },
                            { startQuest: "a", startPort: "Fail", endQuest: "b" },
                        ],
                        nodeData: {
                            start: { key: "start", type: "QuestStartNode", propsData: {} },
                            a: { key: "a", type: "TalkNode", name: "a", propsData: { FirstDialogueId: 1, GuidePointName: "rounding" } },
                            b: { key: "b", type: "TalkNode", name: "b", propsData: { FirstDialogueId: 2 } },
                        },
                    },
                },
            },
        }
        const dialogue = {
            story: () => story,
            prepareStoryFlows: async () => {},
            prefetchReachable: () => {},
            chain: (dialogueId: number) => [{ id: dialogueId }],
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
                loadScriptTableRows: () => [{ __key: "rounding", X: 2.5, Y: -3.5, SubRegionId: 5 }],
            },
            getArtifact: () => dialogue,
        } as unknown as ModuleContext

        const result = (await questStoryModule(ctx)) as Array<Record<string, any>>
        const rendered = renderTree(result, "cn", { get: () => "same" } as never) as Array<Record<string, any>>
        expect(result[0].quests[0].nodes[0]).toMatchObject({ srId: 5, pos: [2, -4] })
        expect(result[0].quests[0].startIds).toEqual(["a", "b"])
        expect(rendered[0].quests[0].desc).toBeUndefined()
    })

    test("remaps edges after deduplicating identical output nodes", async () => {
        const story = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10 },
                    questNodeData: {
                        lineData: [
                            { startQuest: "start", startPort: "QuestStart", endQuest: "root" },
                            { startQuest: "start", startPort: "QuestStart", endQuest: "kept" },
                            { startQuest: "root", startPort: "Out", endQuest: "bridge" },
                            { startQuest: "bridge", startPort: "Out", endQuest: "duplicate" },
                        ],
                        nodeData: {
                            root: { key: "root", type: "TalkNode", name: "root", propsData: { FirstDialogueId: 1 } },
                            kept: { key: "kept", type: "TalkNode", name: "same", propsData: { FirstDialogueId: 2 } },
                            bridge: { key: "bridge", type: "DelayNode", name: "bridge", propsData: {} },
                            duplicate: { key: "duplicate", type: "TalkNode", name: "same", propsData: { FirstDialogueId: 2 } },
                        },
                    },
                },
            },
        }
        const dialogue = {
            story: () => story,
            prepareStoryFlows: async () => {},
            prefetchReachable: () => {},
            chain: (dialogueId: number) => [{ id: dialogueId }],
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
        expect(result[0].quests[0].nodes).toEqual([
            { id: "root", type: "TalkNode", name: "root", dialogues: [{ id: 1 }], next: ["kept"] },
            { id: "kept", type: "TalkNode", name: "same", dialogues: [{ id: 2 }] },
        ])
    })

})
