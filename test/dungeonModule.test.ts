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
        expect(ids.has(40601)).toBe(true) // 联袂演绎
        expect(ids.has(90101)).toBe(true) // DefencePro（掉落魔之楔）
        expect(ids.has(90171)).toBe(true) // DefenceMove（掉落魔之楔）
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

