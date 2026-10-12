import { describe, expect, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { dungeonModule } from "../src/modules/dungeon/dungeonModule.ts"

async function buildDungeons(): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "Dungeon", deps: [], outputs: true, build: ctx => dungeonModule(ctx) })
    const artifacts = await graph.build({}, undefined, ["Dungeon"])
    return artifacts.get("Dungeon") as Array<Record<string, any>>
}

describe("Dungeon 副本过滤", () => {
    test("剔除奖励为无/仅单条纯铜币、且不在历练委托列表/委托密函入口的副本", async () => {
        const dungeons = await buildDungeons()
        const ids = new Set(dungeons.map(item => item.id))

        // 仅单条铜币结算（Reward 表 Resource#101，如 50900/51006）的剧情/多余波次副本不再输出
        for (const dropped of [30101, 30106, 30601, 30801, 60201, 61001, 60101]) expect(ids.has(dropped)).toBe(false)

        // 奖励 id 在 Reward 表中无对应的副本视为无奖励，不输出
        for (const dropped of [90302, 90303, 90304]) expect(ids.has(dropped)).toBe(false)

        // 多条铜币额度池不属于“只有铜币”，保留
        expect(ids.has(91701)).toBe(true)
        expect(ids.has(91702)).toBe(true)
        expect(ids.has(60601)).toBe(true)

        // 历练“委托列表”（SelectDungeon/WeeklySelectDungeon 的 DungeonList）成员保留
        expect(ids.has(90201)).toBe(true) // 第 2 章勘察
        expect(ids.has(90106)).toBe(true)
        expect(ids.has(91302)).toBe(true) // 周常合成试炼

        // 委托密函（WalnutSelectDungeon）可选副本保留——即使其奖励是单条铜币
        expect(ids.has(60102)).toBe(true)

        // 灾厄（IronSurvival）/SoloRaid/联袂演绎（AsyncCombat）及其实奖励副本保留
        expect(ids.has(91601)).toBe(true)
        expect(ids.has(91602)).toBe(true)
        expect(ids.has(21001)).toBe(true) // SoloRaid
        // Raid 预热赛（分组赛）副本无 DungeonReward 结算字段（奖励走 RaidFloor/排行），仍需输出
        for (const preRaid of [21701, 21702, 21703, 21704]) expect(ids.has(preRaid)).toBe(true)
        expect(ids.has(40601)).toBe(true) // 联袂演绎
        expect(ids.has(90101)).toBe(true) // DefencePro（掉落魔之楔）
        expect(ids.has(90171)).toBe(true) // DefenceMove（掉落魔之楔）
    })

    test("联袂演绎 ac：普通房与免费房分开存，Invalid 行过滤", async () => {
        const dungeons = await buildDungeons()
        const find = (id: number) => dungeons.find(item => item.id === id)!

        // 40604：常规行（普通房）+ 6 行 RoomType=1（免费房，t:1）；带 Invalid 标记的 110061 两边都不含。
        const ac40604 = find(40604).ac as Array<{ id: number; c: number; t?: number }>
        expect(ac40604).toEqual([
            { id: 101, c: 400000 },
            { id: 102, c: 21600 },
            { id: 20013, c: 200 },
            { id: 2013, c: 135 },
            { id: 2009, c: 200 },
            { id: 211, c: 150 },
            { id: 102, c: 21600, t: 1 },
            { id: 20013, c: 200, t: 1 },
            { id: 2013, c: 135, t: 1 },
            { id: 2009, c: 200, t: 1 },
            { id: 211, c: 150, t: 1 },
            { id: 101, c: 400000, t: 1 },
        ])
        // 无 RoomType 行的 40601 只有普通房条目，同样不含 110061，且无 t 标记。
        const ac40601 = find(40601).ac as Array<{ id: number; c: number; t?: number }>
        expect(ac40601).toEqual([
            { id: 101, c: 80000 },
            { id: 102, c: 4320 },
            { id: 20013, c: 40 },
            { id: 2013, c: 30 },
            { id: 2009, c: 45 },
            { id: 211, c: 30 },
        ])
    })

    test("系统房间开关门控 ac 中的免费房（t）条目", async () => {
        // 配置项：CommonConst.AsyncCombatSysRoomOpen（随系统房间功能引入的版本级开关），关闭时 ac 不含 t 条目。
        // 若数据更新后本断言失败，说明开关翻转，需重新确认当前版本启用的房间类型。
        const graph = new Graph()
        let flag: unknown
        graph.defineModule({ name: "Probe", deps: [], build: ctx => ((flag = ctx.dm.getCommonConst("AsyncCombatSysRoomOpen")), []) })
        await graph.build({}, undefined, ["Probe"])
        expect(flag).toBe(true)
    })

    test("Raid 预热赛副本保留怪物/胜负条件（无 r 结算字段）", async () => {
        const dungeons = await buildDungeons()
        const find = (id: number) => dungeons.find(item => item.id === id)!

        // 21702 为单 Boss 分组赛本：无 MonsterID 跳层刷怪源，无 spawn，但保留 Boss 与胜负条件
        expect(find(21702).t).toBe("SoloRaid")
        expect(find(21702).m).toContain(8516701)
        expect(find(21702).sm).toContain(8516701)
        expect(find(21702).win).toBe(2)
    })

    test("奖励阶段波数来自 Defence 波次配置，独立于 spawn 刷怪波数", async () => {
        const dungeons = await buildDungeons()
        const find = (id: number) => dungeons.find(item => item.id === id)!

        expect(find(60102).t).toBe("Defence")
        expect(find(60102).waves).toBe(2)
        expect(find(90106).t).toBe("Defence")
        expect(find(90106).waves).toBe(1)
        expect(find(91701).t).toBe("Defence")
        expect(find(91701).waves).toBe(1)
    })
})

