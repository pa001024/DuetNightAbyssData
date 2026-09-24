import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { dirname, join } from "node:path"
import { afterEach, beforeEach, describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import type { DialogueService } from "../src/modules/dialogue/dialogueModule.ts"
import { collectSpecialStoryPaths, questStoryModule } from "../src/modules/questStory/questStoryModule.ts"

describe("QuestStory special stories", () => {
    // BGM 节点只在对应音频已导出时保留：用临时目录固定音频可用性，避免依赖真实数据集。
    let audioRoot: string
    let previousAudioRoot: string | undefined
    beforeEach(() => {
        previousAudioRoot = process.env.DNA_BGM_EXPORT_DIR
        audioRoot = mkdtempSync(join(tmpdir(), "bgm-audio-"))
        const file = join(audioRoot, "bgm/1_0/0091_feina_activity_cs_01.ogg")
        mkdirSync(dirname(file), { recursive: true })
        writeFileSync(file, "ogg")
        process.env.DNA_BGM_EXPORT_DIR = audioRoot
    })
    afterEach(() => {
        if (previousAudioRoot === undefined) delete process.env.DNA_BGM_EXPORT_DIR
        else process.env.DNA_BGM_EXPORT_DIR = previousAudioRoot
        rmSync(audioRoot, { recursive: true, force: true })
    })

    test("keeps a standalone video node alongside reachable dialogue", async () => {
        const story = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10 },
                    questNodeData: {
                        lineData: [{ startQuest: "start", startPort: "QuestStart", endQuest: "talk" }],
                        nodeData: {
                            start: { key: "start", type: "QuestStartNode", propsData: {} },
                            talk: { key: "talk", type: "TalkNode", name: "对白", propsData: { FirstDialogueId: 1 } },
                            video: {
                                key: "video",
                                type: "VideoNode",
                                name: "视频节点",
                                propsData: { MediaSourceRef: "FileMediaSource'/Game/Asset/UIVideo/EX01_SC018.EX01_SC018'" },
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
            chain: () => [{ id: 1 }],
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
            { id: "talk", type: "TalkNode", name: "对白", dialogues: [{ id: 1 }] },
            { id: "video", type: "VideoNode", name: "视频节点", resource: "EX01_SC018" },
        ])
    })

    test("does not export BGM nodes that only mute the current music", async () => {
        const story = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10 },
                    questNodeData: {
                        lineData: [{ startQuest: "start", startPort: "QuestStart", endQuest: "talk" }],
                        nodeData: {
                            start: { key: "start", type: "QuestStartNode", propsData: {} },
                            talk: { key: "talk", type: "TalkNode", name: "对白", propsData: { FirstDialogueId: 1 } },
                            mute: {
                                key: "mute",
                                type: "PlayOrStopBGMNode",
                                name: "静音",
                                propsData: { SoundStateType: 0, SoundPath: "event:/bgm/mute" },
                            },
                            snapshot: {
                                key: "snapshot",
                                type: "PlayOrStopBGMNode",
                                name: "任务提示音静音",
                                propsData: {
                                    SoundStateType: 0,
                                    SoundType: 2,
                                    SoundPath: "FMODEvent'/Game/Asset/Audio/FMOD/Events/snapshot/story/0_1_mute_mission_event.0_1_mute_mission_event'",
                                },
                            },
                            bgm: {
                                key: "bgm",
                                type: "PlayOrStopBGMNode",
                                name: "活动音乐",
                                propsData: { SoundStateType: 0, SoundPath: "event:/bgm/1_0/0091_feina_activity_cs_01" },
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
            chain: () => [{ id: 1 }],
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
            { id: "talk", type: "TalkNode", name: "对白", dialogues: [{ id: 1 }] },
            { id: "bgm", type: "PlayOrStopBGMNode", name: "活动音乐", resource: "bgm/1_0/0091_feina_activity_cs_01" },
        ])
    })

    test("uses the owning quest id when a special story node has no config id", () => {
        const story = {
            storyNodeData: {
                parent: {
                    propsData: { QuestId: 12 },
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

        expect(
            collectSpecialStoryPaths(story, {
                10: { StoryPath: "SpecialQuest/10.story" },
                12: { StoryPath: "SpecialQuest/12.story" },
            })
        ).toEqual(["SpecialQuest/10.story", "SpecialQuest/12.story"])
    })

    test("marks cinematic TalkNode with its canonical video resource", async () => {
        const story = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10 },
                    questNodeData: {
                        lineData: [{ startQuest: "start", startPort: "QuestStart", endQuest: "cinematic" }],
                        nodeData: {
                            start: { key: "start", type: "QuestStartNode", propsData: {} },
                            cinematic: {
                                key: "cinematic",
                                type: "TalkNode",
                                name: "过场动画",
                                propsData: {
                                    FirstDialogueId: 1,
                                    TalkType: "Cinematic",
                                    ShowFilePath:
                                        "LevelSequence'/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC020/SQ_OBT0102_SC020.SQ_OBT0102_SC020'",
                                },
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
            chain: () => [{ id: 1 }],
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
            { id: "cinematic", type: "TalkNode", name: "过场动画", video: "SQ_OBT0102_SC020", dialogues: [{ id: 1 }] },
        ])
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

    test("omits a dialogue field when its chain has no nodes for the rendered language", async () => {
        const story = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10 },
                    questNodeData: {
                        lineData: [{ startQuest: "start", startPort: "QuestStart", endQuest: "talk" }],
                        nodeData: {
                            start: { key: "start", type: "QuestStartNode", propsData: {} },
                            talk: { key: "talk", type: "TalkNode", name: "localized", propsData: { FirstDialogueId: 1 } },
                        },
                    },
                },
            },
        }
        const dialogue = {
            story: () => story,
            prepareStoryFlows: async () => {},
            prefetchReachable: () => {},
            chain: () => [{ id: 1, content: "localized", __langs: ["en"] }],
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
        const cn = renderTree(result, "cn", {} as never) as Array<Record<string, any>>
        const en = renderTree(result, "en", {} as never) as Array<Record<string, any>>
        expect(cn[0].quests[0].nodes[0]).not.toHaveProperty("dialogues")
        expect(en[0].quests[0].nodes[0].dialogues).toEqual([{ id: 1, content: "localized" }])
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

    test("uses the last special story graph for next and startIds like Python", async () => {
        const mainStory = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10 },
                    questNodeData: {
                        lineData: [
                            { startQuest: "start", startPort: "QuestStart", endQuest: "root" },
                            { startQuest: "root", startPort: "Out", endQuest: "bridge" },
                            { startQuest: "bridge", startPort: "Out", endQuest: "tail" },
                        ],
                        nodeData: {
                            start: { key: "start", type: "QuestStartNode", propsData: {} },
                            root: { key: "root", type: "TalkNode", name: "root", propsData: { FirstDialogueId: 1 } },
                            bridge: { key: "bridge", type: "DelayNode", name: "bridge", propsData: {} },
                            tail: { key: "tail", type: "TalkNode", name: "tail", propsData: { FirstDialogueId: 2 } },
                            special: {
                                key: "special",
                                type: "WaitingSpecialQuestStartAndFinishNode",
                                propsData: { SpecialConfigId: 20 },
                            },
                        },
                    },
                },
            },
        }
        const specialStory = {
            storyNodeData: {
                specialParent: {
                    key: "specialParent",
                    propsData: {},
                    questNodeData: {
                        lineData: [
                            { startQuest: "specialStart", startPort: "QuestStart", endQuest: "specialBridge" },
                            { startQuest: "specialBridge", startPort: "Out", endQuest: "specialTalk" },
                        ],
                        nodeData: {
                            specialStart: { key: "specialStart", type: "QuestStartNode", propsData: {} },
                            specialBridge: { key: "specialBridge", type: "DelayNode", propsData: {} },
                            specialTalk: { key: "specialTalk", type: "TalkNode", name: "special", propsData: { FirstDialogueId: 3 } },
                        },
                    },
                },
            },
        }
        const dialogue = {
            story: (path: string) => (path === "main.story" ? mainStory : specialStory),
            prepareStoryFlows: async () => {},
            prefetchReachable: () => {},
            chain: (dialogueId: number) => [{ id: dialogueId }],
        } as unknown as DialogueService
        const tables: Record<string, unknown> = {
            QuestChain: { 1: { QuestChainId: 1, StoryPath: "main.story" } },
            STLExportQuestChain: { 1: { Quests: { 10: {} } } },
            DetectiveQuestion: {},
            DetectiveAnswer: {},
            SpecialQuestConfig: { 20: { StoryPath: "special.story" } },
        }
        const ctx = {
            dm: {
                getTable: (name: string) => tables[name],
                loadScriptTableRows: () => [],
            },
            getArtifact: () => dialogue,
        } as unknown as ModuleContext

        const result = (await questStoryModule(ctx)) as Array<Record<string, any>>
        expect(result[0].quests[0].nodes[0]).not.toHaveProperty("next")
        expect(result[0].quests[0].startIds).toEqual(["root", "tail"])
    })

    test("does not resolve similar or normalized-ambiguous guide point keys", async () => {
        const story = {
            storyNodeData: {
                parent: {
                    key: "parent",
                    propsData: { QuestId: 10 },
                    questNodeData: {
                        lineData: [
                            { startQuest: "start", startPort: "QuestStart", endQuest: "similar" },
                            { startQuest: "start", startPort: "QuestStart", endQuest: "ambiguous" },
                        ],
                        nodeData: {
                            start: { key: "start", type: "QuestStartNode", propsData: {} },
                            similar: {
                                key: "similar",
                                type: "TalkNode",
                                name: "similar",
                                propsData: { FirstDialogueId: 1, GuidePointName: "Mechanism_SideZhuXing_9999999" },
                            },
                            ambiguous: {
                                key: "ambiguous",
                                type: "TalkNode",
                                name: "ambiguous",
                                propsData: { FirstDialogueId: 2, GuidePointName: "Mechanism_Side_ZhuXing_2080078" },
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
            chain: () => [{ id: 1 }],
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
                loadScriptTableRows: () => [
                    { __key: "Mechanism_Side_ZhuXing_9999999", X: 7, Y: 8, SubRegionId: 9 },
                    { __key: "Mechanism_SideZhuXing_2080078", X: 1, Y: 2, SubRegionId: 3 },
                    { __key: "Mechanism_Side_ZhuXing_2080078", X: 4, Y: 5, SubRegionId: 6 },
                ],
            },
            getArtifact: () => dialogue,
        } as unknown as ModuleContext

        const result = (await questStoryModule(ctx)) as Array<Record<string, any>>
        expect(result[0].quests[0].nodes).toEqual([
            { id: "similar", type: "TalkNode", name: "similar", dialogues: [{ id: 1 }] },
            { id: "ambiguous", type: "TalkNode", name: "ambiguous", dialogues: [{ id: 1 }] },
        ])
    })

})
