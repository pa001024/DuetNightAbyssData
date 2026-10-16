import { mkdtempSync, mkdirSync, rmSync, writeFileSync } from "node:fs"
import { join } from "node:path"
import { tmpdir } from "node:os"
import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import type { DialogueService } from "../src/modules/dialogue/dialogueModule.ts"
import { PAN_REWARD_ID, assertPanReward, collectPanGroups, firstPoint, storyTriggerTalks, levelRegionMap, levelSrMap, panModule } from "../src/modules/pan/panModule.ts"

function designFile(dir: string, level: string): void {
    writeFileSync(join(dir, `${level}.lua`), "-- stub")
}

function fakeCtx(
    tables: Record<string, unknown>,
    levels: string[],
    dialogue?: { story?: unknown; chains?: Record<number, Array<Record<string, unknown>>> }
): { ctx: ModuleContext; logs: string[]; cleanup: () => void } {
    const root = mkdtempSync(join(tmpdir(), "dna-pan-test-"))
    const designDir = join(root, "Script", "Datas", "DesignLevel_data")
    mkdirSync(designDir, { recursive: true })
    for (const level of levels) designFile(designDir, level)
    const logs: string[] = []
    const ctx = {
        dm: {
            root,
            scriptDataRoot: root,
            getTable: (name: string) => (tables[name] ?? {}) as Record<string, unknown>,
        },
        log: (msg: string) => logs.push(msg),
        getArtifact: () =>
            ({
                story: () => dialogue?.story,
                chain: (id: unknown) => dialogue?.chains?.[Number(id)] ?? [{ id }],
            }) as unknown as DialogueService,
    } as unknown as ModuleContext
    return { ctx, logs, cleanup: () => rmSync(root, { recursive: true, force: true }) }
}

const EXPLORE_TABLES = {
    "DesignLevel_data/Prologue_Village": {
        Explore: {
            7000054: { c1: { CreatorId: 11, UnitType: "Mechanism", UnitId: 70799, RarelyId: 7000054 } },
            7000055: { c1: { CreatorId: 12, UnitType: "Mechanism", UnitId: 70704, RarelyId: 7000055 } },
        },
    },
    "DesignLevel_data/Huaxu_Haojing_Jlc": {
        Explore: {
            7072019: {
                c1: { CreatorId: 21, UnitType: "Mechanism", UnitId: 70799, RarelyId: 7072019 },
                c2: { CreatorId: 22, UnitType: "Monster", UnitId: 830001, RarelyId: 7072019 },
            },
        },
    },
    "DesignLevel_data/Chapter01_Sew02": {
        Explore: {
            1730255: { c1: { CreatorId: 31, UnitType: "Mechanism", UnitId: 70798, RarelyId: 1730255 } },
            7021030: { c1: { CreatorId: 32, UnitType: "Mechanism", UnitId: 70800, RarelyId: 7021030 } },
        },
    },
    ExploreGroupReward: {
        7000054: { ExploreGroupId: 7000054, RewardId: 3011 },
        7000055: { ExploreGroupId: 7000055, RewardId: 3011 },
        7072019: { ExploreGroupId: 7072019, RewardId: 3014 },
        7021030: { ExploreGroupId: 7021030, RewardId: 3011 },
    },
    SubRegion: {
        100101: { SubRegionId: 100101, SubRegionLevel: "Prologue_Village", RegionId: 1001 },
        101702: { SubRegionId: 101702, SubRegionLevel: "Chapter01_Sew02", RegionId: 1017 },
    },
    Reward: {
        3011: { RewardId: 3011, Id: [211, 3006], Type: ["Resource", "Resource"], Count: [1, 1] },
    },
}

describe("Pan groups", () => {
    test("只收奖励 3011 的潘神组：排除 3014 组与无奖励组", () => {
        const { ctx, cleanup } = fakeCtx(EXPLORE_TABLES, ["Prologue_Village", "Huaxu_Haojing_Jlc", "Chapter01_Sew02"])
        try {
            const { groups, creatorToGroup } = collectPanGroups(ctx)
            expect(groups.map(group => group.id)).toEqual([7000054, 7000055, 7021030])
            expect(groups.find(group => group.id === 7000054)).toMatchObject({ level: "Prologue_Village", units: [70799] })
            // 非潘神机关（830001）不计入 units，但同组潘神机关保留 CreatorId 映射
            expect(creatorToGroup.get(11)).toBe(7000054)
            expect(creatorToGroup.has(22)).toBe(false)
        } finally {
            cleanup()
        }
    })

    test("Reward 3011 必须包含 Resource 3006，否则 fail loud", () => {
        const { ctx, cleanup } = fakeCtx(EXPLORE_TABLES, ["Prologue_Village"])
        try {
            expect(() => assertPanReward(ctx)).not.toThrow()
            expect(PAN_REWARD_ID).toBe(3011)
        } finally {
            cleanup()
        }
        const bad = { ...EXPLORE_TABLES, Reward: { 3011: { RewardId: 3011, Id: [211], Type: ["Resource"], Count: [1] } } }
        const second = fakeCtx(bad, ["Prologue_Village"])
        try {
            expect(() => assertPanReward(second.ctx)).toThrow(/Resource 3006/)
        } finally {
            second.cleanup()
        }
    })

    test("SubRegion 未覆盖的关卡 warn 跳过，不中断导出", async () => {
        const tables = {
            ...EXPLORE_TABLES,
            "DesignLevel_data/Removed_Level": {
                Explore: {
                    7999999: { c1: { CreatorId: 91, UnitType: "Mechanism", UnitId: 70701, RarelyId: 7999999 } },
                },
            },
            ExploreGroupReward: {
                ...(EXPLORE_TABLES.ExploreGroupReward as Record<string, unknown>),
                7999999: { ExploreGroupId: 7999999, RewardId: 3011 },
            },
        }
        const { ctx, logs, cleanup } = fakeCtx(tables, ["Prologue_Village", "Chapter01_Sew02", "Removed_Level"])
        try {
            const output = (await panModule(ctx)) as Array<{ id: number; groups: Array<{ id: number; srId: number }> }>
            // 条目按快照实际出现的 Region 动态生成：只有 1001/1017 有可用组
            expect(output.map(entry => entry.id)).toEqual([1001, 1017])
            expect(output[0].groups.map(group => group.id)).toEqual([7000054, 7000055])
            expect(output[0].groups[0].srId).toBe(100101)
            expect(output[1].groups.map(group => group.id)).toEqual([7021030])
            // 被删关卡只 warn 跳过
            expect(logs.some(msg => msg.includes("Removed_Level"))).toBe(true)
        } finally {
            cleanup()
        }
    })

    test("归属以 SubRegion 表为准：各版本自带，老快照同样适用", () => {
        const { ctx, cleanup } = fakeCtx(EXPLORE_TABLES, ["Prologue_Village"])
        try {
            expect(levelRegionMap(ctx).get("prologue_village")).toEqual({ srId: 100101, regionId: 1001 })
            expect(levelRegionMap(ctx).get("chapter01_sew02")).toEqual({ srId: 101702, regionId: 1017 })
            expect(levelRegionMap(ctx).get("somefuture_level")).toBeUndefined()
            expect(levelSrMap(ctx).get("prologue_village")).toBe(100101)
        } finally {
            cleanup()
        }
    })
})

describe("Pan first point", () => {
    test("CreatorId 最小者为首点，组件局部赝品先丢弃", () => {
        expect(firstPoint([])).toBeUndefined()
        const got = firstPoint([
            { creator: 1590277, pos: [2, 0], type: "BP_StaticCreatorComponent_C" },
            { creator: undefined, pos: [3306, 5100], type: "Explore_Pan_Common_C" },
        ])
        expect(got).toEqual([3306, 5100])
        const kept = firstPoint([
            { creator: 2480196, pos: [2, 2], type: "Explore_Pan_Common_C" },
            { creator: undefined, pos: [0, 0], type: "Explore_Pan_Common_C" },
            { creator: 2480059, pos: [1, 1], type: "Explore_Pan_Common_C" },
        ])
        expect(kept).toEqual([1, 1])
        expect(firstPoint([{ creator: undefined, pos: [5, 5] }])).toEqual([5, 5])
        // 全是赝品时诚实返回 undefined（调用方落为空数组，不编造坐标）
        expect(firstPoint([{ creator: 1, pos: [0, 0], type: "BP_StaticCreatorComponent_C" }])).toBeUndefined()
    })
})

describe("Pan dialogues", () => {
    const talk = (id: number, firstId: number) => ({ key: `t${id}`, type: "TalkNode", propsData: { FirstDialogueId: firstId } })
    const story = {
        storyNodeData: {
            s: {
                type: "StoryNode",
                questNodeData: {
                    lineData: [
                        { startQuest: "b", startPort: "Branch_1", endQuest: "t1", endPort: "In" },
                        { startQuest: "b", startPort: "Branch_2", endQuest: "t2", endPort: "In" },
                        { startQuest: "t2", startPort: "Out", endQuest: "ok", endPort: "In" },
                        { startQuest: "ok", startPort: "Out", endQuest: "t3", endPort: "In" },
                    ],
                    nodeData: {
                        b: { key: "b", type: "BranchTriggerNode", propsData: { Branches: [720000, 720002] } },
                        t1: talk(1, 10),
                        t2: talk(2, 20),
                        ok: { key: "ok", type: "QuestSuccessNode" },
                        t3: talk(3, 30),
                    },
                },
            },
        },
    }

    test("按 BranchTriggerNode 分支出口把 TalkTrigger 精确对应到各自对话链", () => {
        const { ctx, cleanup } = fakeCtx({}, [], { story })
        try {
            const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
            const talks = storyTriggerTalks(dialogue, "Explore/A_PanTalk_X.story")
            expect(talks.get(720000)).toEqual([{ id: 10 }])
            // 沿连线可达的后续 TalkNode 一并收集
            expect(talks.get(720002)).toEqual([{ id: 20 }, { id: 30 }])
            expect(talks.has(720099)).toBe(false)
        } finally {
            cleanup()
        }
    })
})

describe("Pan entries", () => {
    test("条目按快照实际 Region 动态生成：无 story 字段、奖励只写 rewardId", async () => {
        const { ctx, cleanup } = fakeCtx(EXPLORE_TABLES, ["Prologue_Village", "Huaxu_Haojing_Jlc", "Chapter01_Sew02"])
        try {
            const entries = (await panModule(ctx)) as Array<Record<string, unknown>>
            // 只有 1001/1017 有可用组：无组数据的 Region 不输出
            expect(entries.map(entry => entry.id)).toEqual([1001, 1017])
            for (const entry of entries) {
                expect(entry).not.toHaveProperty("story")
                expect(entry.rewardId).toBe(3011)
            }
            const prologue = entries.find(entry => entry.id === 1001)!
            expect(prologue.groups).toHaveLength(2)
            for (const group of prologue.groups as Array<Record<string, unknown>>) {
                expect(Object.keys(group).sort()).toEqual(["dialogues", "id", "pos", "srId"])
                expect(Array.isArray(group.pos)).toBe(true)
            }
            const sew = entries.find(entry => entry.id === 1017)!
            expect(sew.groups).toHaveLength(1)
            expect((sew.groups as Array<Record<string, unknown>>)[0]).toMatchObject({ id: 7021030, srId: 101702 })
        } finally {
            cleanup()
        }
    })
})
