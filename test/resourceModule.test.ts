import { describe, expect, test } from "bun:test"
import { buildObjectMaps, extractPosition } from "../src/modules/resource/resourceModule.ts"

/**
 * 回归：探索点 actor 的根组件只是分组锚点，资源落点取 Drop 创建组件的世界坐标，
 * 且组件局部偏移必须按根组件旋转合成（否则会落到锚点附近，与宝箱坐标重合）。
 * 用例数据取自 Haiboliya_Thc_Lxzs01 的 Explore_Treasure2_8（资源 20661，根组件 yaw=60）：
 * 宝箱组件贴在根组件上，纸张由 Drop 组件偏移放置。
 */
const LEVEL = "Haiboliya_Thc_Lxzs01_Design"
const ACTOR = "Explore_Treasure2_8"
const ACTOR_OUTER = { ObjectName: `Explore_Treasure_C'${LEVEL}:PersistentLevel.${ACTOR}'`, ObjectPath: "actor" }
const ROOT_REF = { ObjectName: `SceneComponent'${LEVEL}:PersistentLevel.${ACTOR}.DefaultSceneRoot'`, ObjectPath: "root" }
const ROOT_LOCATION = { X: -4625.35986328125, Y: -24392.6796875, Z: 510 }
const DROP_LOCATION = { X: -4080, Y: -7610.009765625, Z: -1812.72998046875 }

function exploreNodes(): Array<Record<string, any>> {
    return [
        {
            Type: "Explore_Treasure_C",
            Name: ACTOR,
            Outer: { ObjectName: `Level'${LEVEL}:PersistentLevel'`, ObjectPath: "level" },
            Properties: {
                Drop: { ObjectName: `BP_StaticCreatorComponent_C'${LEVEL}:PersistentLevel.${ACTOR}.Drop'`, ObjectPath: "drop" },
                Chest: { ObjectName: `BP_StaticCreatorComponent_C'${LEVEL}:PersistentLevel.${ACTOR}.Chest'`, ObjectPath: "chest" },
                DefaultSceneRoot: ROOT_REF,
                RootComponent: ROOT_REF,
                ResourceId: 20661,
                ExploreGroupId: 7085021,
            },
        },
        {
            Type: "SceneComponent",
            Name: "DefaultSceneRoot",
            Outer: ACTOR_OUTER,
            Properties: { RelativeLocation: ROOT_LOCATION, RelativeRotation: { Pitch: 0, Yaw: 60, Roll: 0 } },
        },
        {
            Type: "BP_StaticCreatorComponent_C",
            Name: "Drop",
            Outer: ACTOR_OUTER,
            Properties: {
                StaticCreatorId: 292780342,
                UnitId: 20661,
                AttachParent: ROOT_REF,
                RelativeLocation: DROP_LOCATION,
            },
        },
        {
            Type: "BP_StaticCreatorComponent_C",
            Name: "Chest",
            Outer: ACTOR_OUTER,
            Properties: { StaticCreatorId: 292780343, AttachParent: ROOT_REF },
        },
    ]
}

describe("Resource 探索点坐标", () => {
    test("资源坐标取 Drop 组件世界坐标，并按根组件旋转合成局部偏移", () => {
        const nodes = exploreNodes()
        const position = extractPosition(nodes[0], buildObjectMaps(nodes))

        expect(position).toBeDefined()
        expect(position![0]).toBeCloseTo(-74.9, 1)
        expect(position![1]).toBeCloseTo(-31731.07, 1)
        // 未合成旋转会得到根坐标 + 局部偏移（-8705, -32003），不能采用
        expect(Math.round(position![0])).not.toBe(-8705)
        // 根组件坐标（-4625.36, -24392.68）即宝箱世界坐标，不能作为资源坐标
        expect(Math.round(position![0])).not.toBe(-4625)
    })

    test("根组件无旋转时退化为根坐标加局部偏移", () => {
        const nodes = exploreNodes()
        ;(nodes[1].Properties as Record<string, any>).RelativeRotation = undefined
        const position = extractPosition(nodes[0], buildObjectMaps(nodes))

        expect(position).toBeDefined()
        expect(position![0]).toBeCloseTo(-8705.35986328125, 4)
        expect(position![1]).toBeCloseTo(-32002.689453125, 4)
    })

    test("缺少 Drop 组件引用时回退到根组件坐标", () => {
        const nodes = exploreNodes()
        ;(nodes[0].Properties as Record<string, unknown>).Drop = undefined
        const position = extractPosition(nodes[0], buildObjectMaps(nodes))

        expect(position).toBeDefined()
        expect(position![0]).toBeCloseTo(-4625.35986328125, 4)
        expect(position![1]).toBeCloseTo(-24392.6796875, 4)
    })
})
