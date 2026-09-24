import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import type { DialogueService } from "../src/modules/dialogue/dialogueModule.ts"
import { eventStorylineNodes, storylineNodes, storyMediaNode } from "../src/modules/storyline/storyline.ts"
import { collectBgmFiles, movieStemLabel, normalizeBgmAssetPath, parseFModelSoundLog } from "../src/tools/exportStoryMedia.ts"
import { fmodEventMediaName, storyVideoName } from "../src/modules/shared/dataHelpers.ts"
import { dialogueFlowDir, stageSequenceName } from "../src/modules/shared/storyStageMedia.ts"

function context(story: Record<string, unknown>): ModuleContext {
    const dialogue = {
        story: () => story,
        chain: () => [],
        flowChain: () => [],
    } as unknown as DialogueService
    return { getArtifact: () => dialogue } as unknown as ModuleContext
}

const story = {
    storyNodeData: {
        parent: {
            questNodeData: {
                lineData: [
                    { startQuest: "start", startPort: "QuestStart", endQuest: "video" },
                    { startQuest: "video", startPort: "Next", endQuest: "bgm-stop" },
                    { startQuest: "bgm-stop", startPort: "Next", endQuest: "bgm" },
                ],
                nodeData: {
                    start: { type: "QuestStartNode" },
                    video: {
                        name: "开车",
                        type: "VideoNode",
                        propsData: { MediaSourceRef: "FileMediaSource'/Game/Asset/UIVideo/EX01_SC018.EX01_SC018'" },
                    },
                    "bgm-stop": { type: "PlayOrStopBGMNode", propsData: { SoundStateType: 3 } },
                    bgm: {
                        name: "活动音乐",
                        type: "PlayOrStopBGMNode",
                        propsData: { SoundPath: "event:/bgm/1_0/0091_feina_activity_cs_01", SoundStateType: 0 },
                    },
                },
            },
        },
    },
}

describe("storyline media nodes", () => {
    test("exports video and BGM start nodes with exact resources and skips stop nodes", () => {
        const nodes = storylineNodes(context(story), "story") as Array<Record<string, any>>
        expect(nodes).toEqual([
            { id: "video", type: "VideoNode", name: "开车", resource: "EX01_SC018", next: ["bgm"] },
            { id: "bgm", type: "PlayOrStopBGMNode", name: "活动音乐", resource: "bgm/1_0/0091_feina_activity_cs_01" },
        ])
    })

    test("skips BGM nodes that only mute the current music", () => {
        const media = (key: string, node: Record<string, any>) =>
            storyMediaNode(key, node) as Record<string, any> | undefined
        expect(
            media("mute-event", {
                type: "PlayOrStopBGMNode",
                propsData: { SoundStateType: 0, SoundPath: "event:/bgm/mute" },
            })
        ).toBeUndefined()
        expect(
            media("mute-asset", {
                type: "PlayOrStopBGMNode",
                propsData: { SoundStateType: 0, SoundPath: "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'" },
            })
        ).toBeUndefined()
        expect(
            media("ambience", {
                type: "PlayOrStopBGMNode",
                propsData: { SoundStateType: 0, SoundPath: "event:/ambience/common/pad_noise_rain_plain_heavy" },
            })
        ).toEqual({
            id: "ambience",
            type: "PlayOrStopBGMNode",
            name: "",
            resource: "ambience/common/pad_noise_rain_plain_heavy",
        })
    })

    test("skips snapshot control events that carry no audio content", () => {
        const media = (key: string, node: Record<string, any>) =>
            storyMediaNode(key, node) as Record<string, any> | undefined
        expect(
            media("mission-mute", {
                type: "PlayOrStopBGMNode",
                propsData: {
                    SoundStateType: 0,
                    SoundType: 2,
                    SoundPath: "FMODEvent'/Game/Asset/Audio/FMOD/Events/snapshot/story/0_1_mute_mission_event.0_1_mute_mission_event'",
                },
            })
        ).toBeUndefined()
        expect(
            media("reverb", {
                type: "PlayOrStopBGMNode",
                propsData: { SoundStateType: 0, SoundType: 2, SoundPath: "event:/snapshot/story/0_0_opening" },
            })
        ).toBeUndefined()
        expect(
            media("broadcast", {
                type: "PlayOrStopBGMNode",
                propsData: { SoundStateType: 0, SoundType: 2, SoundPath: "event:/snapshot/story/mute_broadcast" },
            })
        ).toBeUndefined()
        expect(
            media("noise", {
                type: "PlayOrStopBGMNode",
                propsData: { SoundStateType: 0, SoundType: 1, SoundPath: "event:/ambience/world/prologue/char_pick" },
            })
        ).toEqual({ id: "noise", type: "PlayOrStopBGMNode", name: "", resource: "ambience/world/prologue/char_pick" })
    })

    test("exports the same media nodes from event storylines", () => {
        const nodes = eventStorylineNodes(context(story), "story") as Array<Record<string, any>>
        expect(nodes.map(node => node.type)).toEqual(["VideoNode", "PlayOrStopBGMNode"])
    })

    test("derives a canonical video name from UE references", () => {
        expect(
            storyVideoName("LevelSequence'/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC020/SQ_OBT0102_SC020.SQ_OBT0102_SC020'")
        ).toBe("SQ_OBT0102_SC020")
        expect(storyVideoName("/Game/Asset/UIVideo/EX01_SC018.EX01_SC018")).toBe("EX01_SC018")
        expect(storyVideoName("/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC011/SQ_OBT0101_SC011")).toBe("SQ_OBT0101_SC011")
        expect(storyVideoName("")).toBeUndefined()
    })

    test("classifies Movies folder media stems into variants", () => {
        expect(movieStemLabel("Ver0106_SC001_Movie", "Ver0106_SC001")).toBe("")
        expect(movieStemLabel("Ver0106_SC001", "Ver0106_SC001")).toBe("")
        expect(movieStemLabel("Ver0102_SC001_F_Movie", "Ver0102_SC001")).toBe("F")
        expect(movieStemLabel("Ver0102_SC001_M_Movie", "Ver0102_SC001")).toBe("M")
        expect(movieStemLabel("Ver0103_SC003_F", "Ver0103_SC003")).toBe("F")
        expect(movieStemLabel("SQ_Ver0105_SC013_EF", "Ver0105_SC013")).toBe("EF")
        expect(movieStemLabel("Ver0101_SC021", "Ver0101_SC021")).toBe("")
        expect(movieStemLabel("Animatic_Edit_Ver0102_SC001", "Ver0101_SC001")).toBeUndefined()
    })

    test("derives dialogue-flow dir and stage sequence name from TalkNode props", () => {
        expect(dialogueFlowDir("DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020101.11020101'")).toBe(
            "MainStory/1102/110201"
        )
        expect(dialogueFlowDir("/Game/Dialogue/MainStory/1102/110201/11020102")).toBe("MainStory/1102/110201")
        expect(dialogueFlowDir("MainStory/1102/110201")).toBeUndefined()
        expect(stageSequenceName("Ex02_FixSimple_01")).toBe("SQ_Ex02_FixSimple_01")
        expect(stageSequenceName("SQ_Ex02_FixSimple_01")).toBe("SQ_Ex02_FixSimple_01")
        expect(stageSequenceName("")).toBeUndefined()
    })

    test("keeps cinematic TalkNode rows and marks them with their video", () => {
        const cinematic = {
            storyNodeData: {
                parent: {
                    questNodeData: {
                        lineData: [
                            { startQuest: "start", startPort: "QuestStart", endQuest: "cinematic" },
                            { startQuest: "cinematic", startPort: "Out", endQuest: "stage" },
                        ],
                        nodeData: {
                            start: { type: "QuestStartNode" },
                            cinematic: {
                                name: "过场动画",
                                type: "TalkNode",
                                propsData: {
                                    FirstDialogueId: 7,
                                    TalkType: "Cinematic",
                                    ShowFilePath: "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC020/SQ_OBT0102_SC020",
                                },
                            },
                            stage: {
                                name: "演出-战斗",
                                type: "TalkNode",
                                propsData: {
                                    FirstDialogueId: 8,
                                    TalkType: "Cinematic",
                                    ShowFilePath: "/Game/AssetDesign/Story/Sequence/Chapter01/HaerFight",
                                },
                            },
                        },
                    },
                },
            },
        }
        const dialogue = {
            story: () => cinematic,
            chain: () => [],
            flowChain: () => [],
        } as unknown as DialogueService
        const ctx = { getArtifact: () => dialogue } as unknown as ModuleContext
        const nodes = storylineNodes(ctx, "story") as Array<Record<string, any>>
        expect(nodes).toEqual([
            { id: "cinematic", type: "TalkNode", name: "过场动画", video: "SQ_OBT0102_SC020" },
            { id: "stage", type: "TalkNode", name: "演出-战斗" },
        ])
        const eventNodes = eventStorylineNodes(ctx, "story") as Array<Record<string, any>>
        expect(eventNodes[0]).toMatchObject({ id: "cinematic", type: "TalkNode", video: "SQ_OBT0102_SC020" })
        expect(eventNodes[1]).not.toHaveProperty("video")
    })

    test("normalizes FMOD object paths to the event package", () => {
        expect(normalizeBgmAssetPath("/Game/Asset/Audio/FMOD/Events/bgm/1_4/0164_cs_xier_show.0164_cs_xier_show")).toBe(
            "EM/Content/Asset/Audio/FMOD/Events/bgm/1_4/0164_cs_xier_show.uasset",
        )
        expect(normalizeBgmAssetPath("event:/bgm/1_0/0091_feina_activity_cs_01")).toBe(
            "EM/Content/Asset/Audio/FMOD/Events/bgm/1_0/0091_feina_activity_cs_01.uasset",
        )
    })

    test("associates saved OGG files only with the current extracted event", () => {
        const event = "EM/Content/Asset/Audio/FMOD/Events/bgm/1_0/0091_feina_activity_cs_01.uasset"
        const parsed = parseFModelSoundLog(
            [
                "SaveAndPlaySound: Successfully saved D:/stale.ogg",
                "Extract: User DOUBLE-CLICKED to extract 'EM/Content/Asset/Audio/FMOD/Events/bgm/1_0/0091_feina_activity_cs_01.uasset'",
                "SaveAndPlaySound: Successfully saved D:/voice/菲娜活动配乐-01.ogg",
                "Extract: User DOUBLE-CLICKED to extract 'EM/Content/Maps/Other.uasset'",
                "SaveAndPlaySound: Successfully saved D:/stale-after.ogg",
            ].join("\n"),
            new Set([event]),
        )
        expect(parsed.get(event)).toEqual(["D:/voice/菲娜活动配乐-01.ogg"])
    })

    test("requires exactly one existing OGG for each BGM resource", () => {
        const directory = mkdtempSync(join(tmpdir(), "story-media-"))
        try {
            const source = join(directory, "菲娜活动配乐-01.ogg")
            writeFileSync(source, "ogg")
            const item = { resource: "event:/bgm/1_0/0091_feina_activity_cs_01", story: "story", node: "bgm" }
            expect(collectBgmFiles([item], new Map([[normalizeBgmAssetPath(item.resource), [source]]]))).toEqual({
                files: new Map([["bgm/1_0/0091_feina_activity_cs_01", source]]),
                missing: [],
            })
            expect(collectBgmFiles([item], new Map(), new Map(), true).missing).toEqual([
                "bgm/1_0/0091_feina_activity_cs_01 (story:bgm)",
            ])
            expect(() => collectBgmFiles([item], new Map())).toThrow("找不到 BGM 音频文件")
            // 一个 FMOD 事件可能含多条音轨（intro + loop）：主音轨用规范名，附加音轨加序号。
            const loopSource = join(directory, "菲娜活动配乐-01-loop.ogg")
            writeFileSync(loopSource, "ogg")
            expect(collectBgmFiles([item], new Map([[normalizeBgmAssetPath(item.resource), [source, loopSource]]]))).toEqual({
                files: new Map([
                    ["bgm/1_0/0091_feina_activity_cs_01", source],
                    ["bgm/1_0/0091_feina_activity_cs_01_2", loopSource],
                ]),
                missing: [],
            })
        } finally {
            rmSync(directory, { recursive: true, force: true })
        }
    })

    test("names BGM files after the FMOD event path so they mirror the event directory", () => {
        expect(fmodEventMediaName("FMODEvent'/Game/Asset/Audio/FMOD/Events/cine/Ver0103/sc002.sc002'")).toBe("cine/Ver0103/sc002")
        expect(fmodEventMediaName("event:/bgm/1_1/0109_combat_black_market")).toBe("bgm/1_1/0109_combat_black_market")
        expect(fmodEventMediaName("/Game/Asset/Audio/FMOD/Events/cine/Cine00/connect_01_cave")).toBe("cine/Cine00/connect_01_cave")
        expect(fmodEventMediaName("event:/bgm/mute")).toBe("bgm/mute")
        expect(fmodEventMediaName("")).toBeUndefined()
    })

    test("resolves BGM audio from the bank OGG name before the event log", () => {
        const directory = mkdtempSync(join(tmpdir(), "story-media-"))
        try {
            const bankDir = join(directory, "cine")
            mkdirSync(bankDir, { recursive: true })
            const bankSource = join(bankDir, "cine_Ver0103_sc002.ogg")
            writeFileSync(bankSource, "ogg")
            const otherSource = join(directory, "cine_Ver0103_sc002.ogg")
            writeFileSync(otherSource, "ogg")
            const eventSource = join(directory, "过场配乐.ogg")
            writeFileSync(eventSource, "ogg")
            const item = {
                resource: "FMODEvent'/Game/Asset/Audio/FMOD/Events/cine/Ver0103/sc002.sc002'",
                story: "story",
                node: "bgm",
            }
            // 同名 ogg 落盘到多处时优先 bank 子目录下的那份，其余视为冲突而非静默取第一个。
            expect(collectBgmFiles([item], new Map(), new Map([["cine_Ver0103_sc002", [bankSource]]]))).toEqual({
                files: new Map([["cine/Ver0103/sc002", bankSource]]),
                missing: [],
            })
            expect(
                collectBgmFiles([item], new Map(), new Map([["cine_Ver0103_sc002", [bankSource, otherSource]]])).files,
            ).toEqual(new Map([["cine/Ver0103/sc002", bankSource]]))
            // 没有 bank 同名音频时退回事件级提取日志，文件名仍用事件规范名。
            expect(
                collectBgmFiles([item], new Map([[normalizeBgmAssetPath(item.resource), [eventSource]]]), new Map()),
            ).toEqual({ files: new Map([["cine/Ver0103/sc002", eventSource]]), missing: [] })
        } finally {
            rmSync(directory, { recursive: true, force: true })
        }
    })
})
