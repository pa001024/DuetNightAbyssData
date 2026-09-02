import { describe, expect, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { rougeProTreasureModule } from "../src/modules/rouge/rougeSimpleModules.ts"

describe("rouge 模块", () => {
    test("合作遗物仅在原始数据存在时导出 modEquip", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "RougeProTreasure", deps: [], outputs: true, build: ctx => rougeProTreasureModule(ctx) })

        const artifacts = await graph.build({}, undefined, ["RougeProTreasure"])
        const treasures = artifacts.get("RougeProTreasure") as Array<Record<string, unknown>>

        expect(treasures.find(item => item.id === 10103)?.modEquip).toBe("Role")
        expect(treasures.find(item => item.id === 10102)).not.toHaveProperty("modEquip")
    })
})
