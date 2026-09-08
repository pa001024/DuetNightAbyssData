import { mkdtempSync, rmSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import type { DialogueService } from "../src/modules/dialogue/dialogueModule.ts"
import { eventStorylineNodes, storylineNodes, storyMediaNode } from "../src/modules/storyline/storyline.ts"
import { collectBgmFiles, normalizeBgmAssetPath, parseFModelSoundLog } from "../src/tools/exportStoryMedia.ts"

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
            { id: "bgm", type: "PlayOrStopBGMNode", name: "活动音乐", resource: "0091_feina_activity_cs_01" },
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
        ).toEqual({ id: "ambience", type: "PlayOrStopBGMNode", name: "", resource: "pad_noise_rain_plain_heavy" })
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
        ).toEqual({ id: "noise", type: "PlayOrStopBGMNode", name: "", resource: "char_pick" })
    })

    test("exports the same media nodes from event storylines", () => {
        const nodes = eventStorylineNodes(context(story), "story") as Array<Record<string, any>>
        expect(nodes.map(node => node.type)).toEqual(["VideoNode", "PlayOrStopBGMNode"])
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
            expect(collectBgmFiles([item], new Map([[normalizeBgmAssetPath(item.resource), [source]]]))).toEqual(
                new Map([["0091_feina_activity_cs_01", source]]),
            )
            expect(() => collectBgmFiles([item], new Map())).toThrow("mapped to 0 OGG files")
            expect(() => collectBgmFiles([item], new Map([[normalizeBgmAssetPath(item.resource), [source, source]]]))).toThrow(
                "mapped to 2 OGG files",
            )
        } finally {
            rmSync(directory, { recursive: true, force: true })
        }
    })
})
