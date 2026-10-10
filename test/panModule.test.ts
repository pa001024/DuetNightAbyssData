import { mkdtempSync, mkdirSync, rmSync, writeFileSync } from "node:fs"
import { join } from "node:path"
import { tmpdir } from "node:os"
import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import type { DialogueService } from "../src/modules/dialogue/dialogueModule.ts"
import { PAN_REWARD_ID, assertPanReward, collectPanGroups, firstPoint, levelSrMap, panModule, regionOfLevel } from "../src/modules/pan/panModule.ts"

function designFile(dir: string, level: string): void {
    writeFileSync(join(dir, `${level}.lua`), "-- stub")
}

function fakeCtx(
    tables: Record<string, unknown>,
    levels: string[],
    dialogue?: { story?: unknown; chains?: Record<number, Array<Record<string, unknown>>> }
): { ctx: ModuleContext; cleanup: () => void } {
    const root = mkdtempSync(join(tmpdir(), "dna-pan-test-"))
    const designDir = join(root, "Script", "Datas", "DesignLevel_data")
    mkdirSync(designDir, { recursive: true })
    for (const level of levels) designFile(designDir, level)
    const ctx = {
        dm: {
            root,
            scriptDataRoot: root,
            getTable: (name: string) => (tables[name] ?? {}) as Record<string, unknown>,
        },
        getArtifact: () =>
            ({
                story: () => dialogue?.story,
                chain: (id: unknown) => dialogue?.chains?.[Number(id)] ?? [{ id }],
            }) as unknown as DialogueService,
    } as unknown as ModuleContext
    return { ctx, cleanup: () => rmSync(root, { recursive: true, force: true }) }
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
        100101: { SubRegionId: 100101, SubRegionLevel: "Prologue_Village" },
        101702: { SubRegionId: 101702, SubRegionLevel: "Chapter01_Sew02" },
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

    test("未归属 Region 的关卡 fail loud，不静默丢弃", () => {
        const { ctx, cleanup } = fakeCtx(EXPLORE_TABLES, ["Prologue_Village"])
        try {
            expect(regionOfLevel("Prologue_Village")).toBe(1001)
            expect(regionOfLevel("Chapter01_Sew02")).toBe(1017)
            expect(regionOfLevel("SomeFuture_Level")).toBeUndefined()
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
    test("仅外语有文本的过场节点在所有语言统一丢弃", async () => {
        const story = {
            storyNodeData: {
                s: {
                    type: "StoryNode",
                    questNodeData: {
                        nodeData: {
                            a: { type: "TalkNode", propsData: { FirstDialogueId: 1 } },
                            b: { type: "TalkNode", propsData: { FirstDialogueId: 2 } },
                            c: { type: "TalkNode", propsData: { FirstDialogueId: 3 } },
                        },
                    },
                },
            },
        }
        const chains = {
            1: [{ id: 1 }],
            2: [{ id: 2, __langs: ["en"] }],
            3: [{ id: 3 }, { id: 3 }],
        }
        const { ctx, cleanup } = fakeCtx(EXPLORE_TABLES, ["Prologue_Village"], { story, chains })
        try {
            const entries = (await panModule(ctx)) as Array<Record<string, unknown>>
            for (const entry of entries) {
                const ids = (entry.dialogues as Array<Record<string, unknown>>).map(talk => talk.id)
                expect(ids).toEqual([1, 3])
            }
        } finally {
            cleanup()
        }
    })
})

describe("Pan entries", () => {
    test("输出无 story 字段、奖励只写 rewardId，id 为规范 RegionId", async () => {
        const { ctx, cleanup } = fakeCtx(EXPLORE_TABLES, ["Prologue_Village", "Huaxu_Haojing_Jlc", "Chapter01_Sew02"])
        try {
            const entries = (await panModule(ctx)) as Array<Record<string, unknown>>
            expect(entries).toHaveLength(10)
            expect(entries.map(entry => entry.id)).toEqual([1001, 1017, 1060, 1063, 1011, 1013, 1021, 1070, 1071, 1072])
            for (const entry of entries) {
                expect(entry).not.toHaveProperty("story")
                expect(entry.rewardId).toBe(3011)
            }
            const prologue = entries.find(entry => entry.id === 1001)!
            expect(prologue.groups).toHaveLength(2)
            for (const group of prologue.groups as Array<Record<string, unknown>>) {
                expect(Object.keys(group).sort()).toEqual(["id", "pos", "srId"])
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
