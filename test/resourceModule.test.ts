import { describe, expect, test } from "bun:test"
import {
    buildAccessRules,
    buildAccessTexts,
    buildLinkMaps,
    buildObjectMaps,
    createRewardResolver,
    extractPosition,
    normalizeAccessKeys,
    resourcePairs,
    visibleAccessKeys,
} from "../src/modules/resource/resourceModule.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"

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

describe("Resource UnitId 命名空间分流", () => {
    // 回归 31005001 误导出 srId 107601：Drop.DropId 与 Mechanism.UnitId 数值重叠
    // （90007 既是 GetResource 31005001 的掉落，也是 Haiboliya_Thc_Boss 里 Mechanism_2840061
    //  HardBossOpenMechanism 的机关），必须按节点声明的 UnitType 分流。
    const resourceMap = new Map([[31005001, {}]]) as Map<number, Record<string, unknown>>
    const links = {
        rarelyToDrop: new Map<number, number[]>([[7018007, [90007]]]),
        dropToResource: new Map<number, number[]>([[90007, [31005001]]]),
        mechanismToResource: new Map<number, Array<[number, number | undefined]>>([[90007, []]]),
        randomRuleToResource: new Map<number, Array<[number, number | undefined]>>(),
    }
    const unitIds = new Map<number, number>()

    test("Mechanism 声明的节点不命中 Drop 链路", () => {
        expect(resourcePairs({ UnitType: "Mechanism", UnitId: 90007 }, resourceMap, links, unitIds)).toEqual([])
    })

    test("Mechanism 声明的节点不命中 Rarely→Drop 链路", () => {
        expect(resourcePairs({ UnitType: "Mechanism", UnitId: 90007, RarelyId: 7018007 }, resourceMap, links, unitIds)).toEqual([])
    })

    test("Drop 声明的节点保持命中 Drop 链路", () => {
        expect(resourcePairs({ UnitType: "Drop", UnitId: 90007 }, resourceMap, links, unitIds)).toEqual([[31005001, undefined]])
    })

    test("无 UnitType 的节点（Explore actor、组件）保持原行为", () => {
        expect(resourcePairs({ UnitId: 90007 }, resourceMap, links, unitIds)).toEqual([[31005001, undefined]])
        expect(resourcePairs({ UnitId: 90007, RarelyId: 7018007 }, resourceMap, links, unitIds)).toEqual([[31005001, undefined]])
    })

    test("缺失 UnitType 时回退到创角记录：模板默认组件同样分流", () => {
        // Chapter01_Sew02 的 PanPickUp 模板组件 asset 内无 UnitType，但创角 1730284 登记为 Mechanism（蘑菇机关 1027），
        // 与 Drop 1027（角色经验 2011）碰撞：必须拦截，否则与 PanPickUp1/2 的处理不一致。
        const expMap = new Map([[2011, {}]]) as Map<number, Record<string, unknown>>
        const expLinks = {
            ...links,
            dropToResource: new Map<number, number[]>([[1027, [2011]]]),
        }
        const types = new Map<number, string>([[1730284, "Mechanism"]])
        expect(resourcePairs({ UnitId: 1027, StaticCreatorId: 1730284, RarelyId: 7021029 }, expMap, expLinks, unitIds, types)).toEqual([])
    })

    test("创角记录为 Drop 时保持命中 Drop 链路", () => {
        // Chapter01_Kuangkeng_Part_04 的 KuangKeng4_Explore2.Drop 组件：创角 1440185 登记为 Drop，UnitId 90007 即掉落 90007。
        const types = new Map<number, string>([[1440185, "Drop"]])
        expect(
            resourcePairs({ UnitId: 90007, StaticCreatorId: 1440185, RarelyId: 7018007 }, resourceMap, links, unitIds, types)
        ).toEqual([[31005001, undefined]])
    })
})

describe("Resource 奖励传递闭包", () => {
    test("直连/嵌套/掉落终端/未知/成环", () => {
        const resourceMap = new Map([[10, {}]]) as Map<number, Record<string, unknown>>
        const dropToResource = new Map<number, number[]>([[5, [10]]])
        const rewardTable = {
            1: { Id: [10], Type: ["Resource"] },
            2: { Id: [1], Type: ["Reward"] },
            3: { Id: [5], Type: ["Drop"] },
            4: { Id: [5], Type: ["Reward"] },
            6: { Id: [7], Type: ["Reward"] },
            7: { Id: [6], Type: ["Reward"] },
        }
        const resolve = createRewardResolver(rewardTable, dropToResource, resourceMap)
        expect([...resolve(1).all]).toEqual([10])
        expect([...resolve(1).direct]).toEqual([10])
        expect([...resolve(2).all]).toEqual([10])
        expect([...resolve(2).direct]).toEqual([])
        expect([...resolve(3).all]).toEqual([10])
        expect([...resolve(3).direct]).toEqual([])
        expect([...resolve(4).all]).toEqual([])
        expect([...resolve(999).all]).toEqual([])
        // 成环必须终止（截断环边）
        expect([...resolve(6).all]).toEqual([])
    })

    test("真实数据：坚果嵌套链与矿石稀有掉落", () => {
        const dm = getLuaDataManager()
        const resourceTable = dm.getTable("Resource") as Record<string, unknown>
        const resourceMap = new Map<number, Record<string, unknown>>()
        for (const value of Object.values(resourceTable ?? {})) {
            const row = value as Record<string, unknown>
            if (row && typeof row === "object" && Number.isInteger(row.ResourceId)) resourceMap.set(row.ResourceId as number, row)
        }
        const links = buildLinkMaps(dm as never, resourceMap)
        // 机关 1003（DropNuts）→奖励 4021002→奖励 4021001→掉落 40101/40102→坚果：净界岛随机刷新坚果的链路
        expect(links.mechanismToResource.get(1003)).toEqual(
            expect.arrayContaining([
                [4020001, 4021002],
                [4020002, 4021002],
            ])
        )
        // 矿石 1008：主奖励 4020003 + 稀有 4020004（RareProb 0.3）
        expect(links.mechanismToResource.get(1008)).toEqual(
            expect.arrayContaining([
                [4020003, 4020003],
                [4020004, 4020004],
            ])
        )
        // 1009 的稀有 4020002 的 RareProb 为 0（不掉落）：不得建模；主奖励 4021005→掉落 40105→4020005 保持
        const pairs1009 = links.mechanismToResource.get(1009) ?? []
        expect(pairs1009.some(pair => pair[1] === 4020002)).toBe(false)
        expect(pairs1009).toEqual(expect.arrayContaining([[4020005, 4021005]]))
        // 直连行为不变：测试机关 111 仍按原奖励归因
        expect(links.mechanismToResource.get(111)).toEqual(
            expect.arrayContaining([
                [2011, 2120101],
                [2012, 2120101],
            ])
        )
        // 嵌套传递只给带采集 key 的资源：宝箱 6（奖励 2010）的传递物（经验/铜币等）均无采集 key，不得产出嵌套对
        expect(links.mechanismToResource.get(6) ?? []).toEqual([])
        // 宝箱 70100（奖励 3004）：直连 2001 保留；甲壳（无采集 key）不得经嵌套展开
        expect(links.mechanismToResource.get(70100)).toEqual(expect.arrayContaining([[2001, 3004]]))
        expect((links.mechanismToResource.get(70100) ?? []).some(pair => pair[0] === 20001)).toBe(false)
    })
})

describe("Resource 来源文本", () => {
    test("AccessKey 去重保序", () => {
        expect(normalizeAccessKeys(["a", "b", "a", "", 1, undefined])).toEqual(["a", "b"])
        expect(normalizeAccessKeys("a")).toEqual(["a"])
        expect(normalizeAccessKeys(undefined)).toEqual([])
    })

    test("真实数据：AccessKey 全覆盖且采集 key 可解析", () => {
        const dm = getLuaDataManager()
        const texts = buildAccessTexts(dm as never)
        expect(texts.get("Text_Collecting_Prologue01")).toBe("Access_Collecting_Prologue01")
        expect(texts.get("Dungeon")).toBe("Access_Dungeon")
        // 锻造模板（%s 运行时填充）降级为基础标签，避免导出带空占位符的括号
        expect(texts.get("Forging")).toBe("MAIN_UI_FORGE")
        const resourceTable = dm.getTable("Resource") as Record<string, unknown>
        const missing: string[] = []
        for (const value of Object.values(resourceTable ?? {})) {
            for (const key of normalizeAccessKeys((value as Record<string, unknown>)?.AccessKey)) {
                if (!texts.has(key)) missing.push(key)
            }
        }
        expect(missing).toEqual([])
    })

    test("Return 规则项静态不可见，keep 例外保留", () => {
        const rules = new Map([["a", "Return"]])
        expect(visibleAccessKeys(["a", "b"], rules)).toEqual(["b"])
        expect(visibleAccessKeys(["a", "b"], rules, key => key === "a")).toEqual(["a", "b"])
    })

    test("真实数据：20010 只剩所有敌人掉落（与游戏内一致）", () => {
        const dm = getLuaDataManager()
        const rules = buildAccessRules(dm as never)
        expect(rules.get("Dungeon")).toBe("Return")
        expect(rules.get("Shop_Main")).toBe("Return")
        expect(rules.get("Text_Monster")).toBeUndefined()
        const resourceTable = dm.getTable("Resource") as Record<string, unknown>
        const row = resourceTable?.["20010"] as Record<string, unknown>
        expect(visibleAccessKeys(normalizeAccessKeys(row?.AccessKey), rules)).toEqual(["Text_Monster"])
    })
})
