import { describe, expect, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { dungeonModule } from "../src/modules/dungeon/dungeonModule.ts"

async function buildDungeons(): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "Dungeon", deps: [], outputs: true, build: ctx => dungeonModule(ctx) })
    const artifacts = await graph.build({}, undefined, ["Dungeon"])
    return artifacts.get("Dungeon") as Array<Record<string, any>>
}

describe("Dungeon 扼守奖励波次", () => {
    test("奖励阶段波数独立于 spawn 刷怪波数，并区分扼守类型", async () => {
        const dungeons = await buildDungeons()
        const find = (id: number) => dungeons.find(item => item.id === id)!

        const standardDefault = find(30101)
        expect(standardDefault.t).toBe("Defence")
        expect(standardDefault.wavesPerStage).toBe(3)
        expect(standardDefault.spawn.length).toBe(6)

        expect(find(60102).wavesPerStage).toBe(2)
        expect(find(90102).wavesPerStage).toBe(1)
        expect(find(90171).t).toBe("DefenceMove")
        expect(find(90171).wavesPerStage).toBe(2)
        expect(find(90101)).not.toHaveProperty("wavesPerStage")
    })
})
