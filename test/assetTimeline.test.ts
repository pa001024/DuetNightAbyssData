import { describe, expect, test } from "bun:test"
import {
    animBPFromFModelData,
    assetPathFromGamePath,
    assetPathFromObjectPath,
    montageTimelineFromFModelData,
    packagePathFromObjectPath,
    sequenceMetaFromFModelData,
} from "../src/lua/AssetReader.ts"

const PACKAGE = "EM/Content/Asset/Char/Player/Char020_Lise/Animation/Montage/Combat/Skill/Lise_Skill02_Montage"

function montageExport(overrides: Record<string, unknown> = {}): Record<string, unknown> {
    return {
        Type: "AnimMontage",
        Name: "Lise_Skill02_Montage",
        Package: PACKAGE,
        Properties: {
            SequenceLength: 1.8333334,
            CompositeSections: [
                {
                    SectionName: "Default",
                    NextSectionName: "Loop",
                    SegmentBeginTime: 0,
                    SegmentLength: 1.8333334,
                    LinkedSequence: { ObjectPath: "EM/Content/Asset/Char/Player/Char020_Lise/Animation/Sequence/Combat/Skill/Lise_Skill02.0" },
                },
            ],
            SlotAnimTracks: [
                {
                    SlotName: "DefaultSlot",
                    AnimTrack: {
                        AnimSegments: [
                            {
                                AnimReference: { ObjectPath: "EM/Content/Asset/Char/Player/Char020_Lise/Animation/Sequence/Combat/Skill/Lise_Skill02.0" },
                                StartPos: 0,
                                AnimStartTime: 0,
                                AnimEndTime: 1.8333334,
                                AnimPlayRate: 1,
                                LoopingCount: 1,
                            },
                        ],
                    },
                },
            ],
            Notifies: [
                {
                    NotifyName: "BP_SkillEffect_C",
                    Notify: { ObjectPath: `${PACKAGE}.6` },
                    LinkValue: 1.0660003,
                    Duration: 0,
                    EndLink: { LinkValue: 0 },
                    TrackIndex: 1,
                },
                {
                    NotifyName: "BP_SkillCancel_C",
                    NotifyStateClass: { ObjectPath: `${PACKAGE}.13` },
                    LinkValue: 1.0924795,
                    Duration: 0.7408539,
                    EndLink: { LinkValue: 1.8333334 },
                },
            ],
            BranchingPointMarkers: [
                { NotifyIndex: 0, TriggerTime: -0.0001, NotifyEventType: "EAnimNotifyEventType::Begin" },
                { NotifyIndex: 0, TriggerTime: 1.0988079, NotifyEventType: "EAnimNotifyEventType::End" },
            ],
            ...overrides,
        },
    }
}

function notifyClassExport(index: number, name: string, properties: Record<string, unknown>): Record<string, unknown> {
    return {
        Type: name,
        Name: `${name}_${index}`,
        Package: PACKAGE,
        Properties: properties,
    }
}

describe("montageTimelineFromFModelData", () => {
    test("读取 sections/segments/notifies/branching points，并按 export 下标关联 notify payload", () => {
        const exports = [
            montageExport(),
            { Type: "X", Name: "X_1", Properties: {} },
            { Type: "X", Name: "X_2", Properties: {} },
            { Type: "X", Name: "X_3", Properties: {} },
            { Type: "X", Name: "X_4", Properties: {} },
            { Type: "X", Name: "X_5", Properties: {} },
            notifyClassExport(6, "BP_AnimNotify_SkillEffect_C", { 通知名称: "hit1" }),
            ...Array.from({ length: 6 }, (_, i) => ({ Type: "X", Name: `X_${i + 7}`, Properties: {} })),
            notifyClassExport(13, "BP_AnimNotifyState_SkillCancel_C", { OtherSkillCancel: true }),
        ]
        const timeline = montageTimelineFromFModelData(exports)

        expect(timeline).not.toBeNull()
        expect(timeline!.length).toBeCloseTo(1.8333334, 6)
        expect(timeline!.sections).toEqual([
            {
                name: "Default",
                begin: 0,
                length: 1.8333334,
                next: "Loop",
                sequence: "EM/Content/Asset/Char/Player/Char020_Lise/Animation/Sequence/Combat/Skill/Lise_Skill02",
            },
        ])
        expect(timeline!.segments).toEqual([
            {
                slot: "DefaultSlot",
                sequence: "EM/Content/Asset/Char/Player/Char020_Lise/Animation/Sequence/Combat/Skill/Lise_Skill02",
                start: 0,
                end: 1.8333334,
                rate: 1,
                startPos: 0,
                loopingCount: 1,
            },
        ])
        expect(timeline!.notifies[0]).toMatchObject({
            name: "BP_SkillEffect_C",
            time: 1.0660003,
            duration: 0,
            endTime: null,
            trackIndex: 1,
            state: false,
            payloadMatches: [6],
            payloadSource: "objectPath",
        })
        expect(timeline!.notifies[0]!.payload).toMatchObject({
            index: 6,
            class: "BP_AnimNotify_SkillEffect_C",
            properties: { 通知名称: "hit1" },
        })
        expect(timeline!.notifies[1]).toMatchObject({ name: "BP_SkillCancel_C", state: true, payloadMatches: [13], endTime: 1.8333334 })
        expect(timeline!.notifies[1]!.payload!.properties).toEqual({ OtherSkillCancel: true })
        expect(timeline!.branchingPoints).toEqual([
            { notifyIndex: 0, time: -0.0001, type: "EAnimNotifyEventType::Begin" },
            { notifyIndex: 0, time: 1.0988079, type: "EAnimNotifyEventType::End" },
        ])
    })

    test("notify 类缺失时 payload 为 null 且不崩溃", () => {
        const exports = [{ ...montageExport(), Properties: { ...(montageExport().Properties as object), Notifies: [] } }]
        const timeline = montageTimelineFromFModelData(exports)

        expect(timeline).not.toBeNull()
        expect(timeline!.notifies).toEqual([])
        expect(timeline!.length).toBeCloseTo(1.8333334, 6)
    })

    test("无显式 ObjectPath 时按 NotifyName 匹配；多候选全部保留并标注 ambiguous", () => {
        const base = montageExport()
        const props = base.Properties as Record<string, unknown>
        props.Notifies = [{ NotifyName: "BP_Sound_C", LinkValue: 0.5, Duration: 0, EndLink: { LinkValue: 0 } }]
        const exports = [
            base,
            notifyClassExport(1, "BP_AnimNotify_Sound_C", { EventSuffix: "a" }),
            notifyClassExport(2, "BP_AnimNotify_Sound_C", { EventSuffix: "b" }),
        ]
        const timeline = montageTimelineFromFModelData(exports)

        expect(timeline!.notifies[0]!.payload).toBeNull()
        expect(timeline!.notifies[0]!.payloadSource).toBe("name")
        expect(timeline!.notifies[0]!.payloadMatches).toEqual([1, 2])
        expect(timeline!.notifies[0]!.payloadAmbiguous).toBe(true)
        expect(timeline!.notifies[0]!.payloads?.map(item => item.properties)).toEqual([{ EventSuffix: "a" }, { EventSuffix: "b" }])
    })

    test("非 Montage 资产返回 null", () => {
        expect(montageTimelineFromFModelData([{ Type: "AnimSequence", Name: "Seq", Properties: {} }])).toBeNull()
    })
})

describe("sequenceMetaFromFModelData", () => {
    test("读取长度/帧数/帧率/根运动/骨架/notifies", () => {
        const meta = sequenceMetaFromFModelData([
            {
                Type: "AnimSequence",
                Name: "Lise_Skill02",
                Package: "EM/Content/Asset/Char/Player/Char020_Lise/Animation/Sequence/Combat/Skill/Lise_Skill02",
                Properties: {
                    SequenceLength: 1.8333334,
                    NumFrames: 56,
                    bEnableRootMotion: false,
                    Skeleton: { ObjectPath: "EM/Content/Asset/Char/Player/Skeleton/Biped_Skeleton.0" },
                    Notifies: [{ NotifyName: "BP_AnimNotify_SkillFX_C", LinkValue: 0.5, Duration: 0 }],
                },
            },
        ])

        expect(meta).not.toBeNull()
        expect(meta!.frames).toBe(56)
        expect(meta!.fps).toBeCloseTo(56 / 1.8333334, 6)
        expect(meta!.rootMotion).toBe(false)
        expect(meta!.skeleton).toBe("EM/Content/Asset/Char/Player/Skeleton/Biped_Skeleton")
        expect(meta!.notifies).toEqual([{ name: "BP_AnimNotify_SkillFX_C", time: 0.5, duration: 0 }])
    })
})

describe("animBPFromFModelData", () => {
    test("收集 AnimGraphNode_* 与 TargetSkeleton；BakedStateMachines 缺失时显式说明", () => {
        const info = animBPFromFModelData([
            {
                Type: "AnimBlueprintGeneratedClass",
                Name: "ABP_Lise_C",
                Package: "EM/Content/AssetDesign/Char/Player/Lise/ABP_Lise",
                Properties: {
                    TargetSkeleton: { ObjectPath: "EM/Content/Asset/Char/Player/Skeleton/Biped_Skeleton.0" },
                    SyncGroupNames: ["moving"],
                },
            },
            {
                Type: "ABP_Lise_C",
                Name: "Default__ABP_Lise_C",
                Properties: {
                    AnimGraphNode_SequencePlayer_192: { OverrideSequence: { ObjectPath: "EM/Content/.../Lise_Idle.0" } },
                    AnimGraphNode_SequencePlayer_182: {},
                    LinkLayerClass: { ObjectPath: "EM/Content/.../ABP_Lise_Kawaii.0" },
                },
            },
        ])

        expect(info).not.toBeNull()
        expect(info!.className).toBe("ABP_Lise_C")
        expect(info!.targetSkeleton).toBe("EM/Content/Asset/Char/Player/Skeleton/Biped_Skeleton")
        expect(info!.syncGroupNames).toEqual(["moving"])
        expect(info!.linkedLayerClass).toBe("EM/Content/.../ABP_Lise_Kawaii")
        expect(info!.graph.map(node => node.name)).toEqual(["AnimGraphNode_SequencePlayer_192", "AnimGraphNode_SequencePlayer_182"])
        expect(info!.graph.map(node => node.node)).toEqual(["AnimGraphNode_SequencePlayer", "AnimGraphNode_SequencePlayer"])
        expect(info!.stateMachines).toEqual([])
        expect(info!.stateMachinesUnavailable).toBeTruthy()
    })

    test("BakedStateMachines 存在时原样保留", () => {
        const baked = [{ Name: "Locomotion", States: [] }]
        const info = animBPFromFModelData([
            {
                Type: "AnimBlueprintGeneratedClass",
                Name: "ABP_X_C",
                Package: "EM/Content/AssetDesign/Char/Player/X/ABP_X",
                Properties: { BakedStateMachines: baked },
            },
        ])

        expect(info!.stateMachines).toEqual(baked)
        expect(info!.stateMachinesUnavailable).toBeUndefined()
    })
})

describe("资产路径换算", () => {
    test("packagePathFromObjectPath 去掉 export 下标", () => {
        expect(packagePathFromObjectPath(`${PACKAGE}.0`)).toBe(PACKAGE)
        expect(packagePathFromObjectPath(undefined)).toBeNull()
    })

    test("/Game 路径（含 Class'...' 形式）→ 解包目录 .uasset", () => {
        const root = "D:/dev/dna-unpack/Fmodel/Output/Exports"
        const expected = `${root}/EM/Content/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_Lise_Passive.uasset`
        expect(assetPathFromGamePath("/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_Lise_Passive.BP_Lise_Passive", root)).toBe(
            expected.replace(/\//g, "\\")
        )
        expect(
            assetPathFromGamePath("AnimBlueprint'/Game/AssetDesign/Char/Player/Lise/ABP_Lise.ABP_Lise_C'", root)
        ).toBe(`${root}/EM/Content/AssetDesign/Char/Player/Lise/ABP_Lise.uasset`.replace(/\//g, "\\"))
        expect(assetPathFromGamePath("", root)).toBeNull()
    })

    test("ObjectPath → 解包目录 .uasset", () => {
        const root = "D:/dev/dna-unpack/Fmodel/Output/Exports"
        expect(assetPathFromObjectPath("EM/Content/Asset/Char/Player/Char020_Lise/Animation/Sequence/Combat/Skill/Lise_Skill02.0", root)).toBe(
            `${root}/EM/Content/Asset/Char/Player/Char020_Lise/Animation/Sequence/Combat/Skill/Lise_Skill02.uasset`.replace(/\//g, "\\")
        )
    })
})
