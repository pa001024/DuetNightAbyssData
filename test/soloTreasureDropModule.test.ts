import { describe, expect, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { soloTreasureDropModule } from "../src/modules/soloTreasure/soloTreasureModule.ts"

async function buildDrop(): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "SoloTreasureDrop", deps: [], outputs: true, build: ctx => soloTreasureDropModule(ctx) })
    const artifacts = await graph.build({}, undefined, ["SoloTreasureDrop"])
    return artifacts.get("SoloTreasureDrop") as Array<Record<string, any>>
}

describe("SoloTreasureDrop 容器数据", () => {
    test("容器标签输出 BoxDropRate 与 DropMechanismId，点位标签只输出 KillScore", async () => {
        const rows = await buildDrop()
        const containers = rows.filter(item => String(item.tag).endsWith("Container"))
        const points = rows.filter(item => String(item.tag).endsWith("Point"))

        expect(containers.length).toBe(6)
        expect(points.length).toBe(6)
        for (const item of containers) {
            expect(typeof item.boxDropRate).toBe("number")
            expect(typeof item.dropMechanismId).toBe("number")
            expect(item).not.toHaveProperty("killScore")
        }
        for (const item of points) {
            expect(typeof item.killScore).toBe("number")
            expect(item).not.toHaveProperty("boxDropRate")
        }
    })

    test("按 Lua 原值导出容器掉落率与掉落机关", async () => {
        const rows = await buildDrop()
        const find = (tag: string) => rows.find(item => item.tag === `Mon.SoloTreasure.${tag}`)!

        expect(find("AContainer").boxDropRate).toBe(0.03)
        expect(find("AContainer").dropMechanismId).toBe(131076)
        expect(find("BContainer").dropMechanismId).toBe(131061)
        expect(find("CContainer").boxDropRate).toBe(0.3)
        expect(find("CContainer").dropMechanismId).toBe(131079)
        expect(find("DContainer").dropMechanismId).toBe(131064)
        expect(find("EContainer").boxDropRate).toBe(1)
        expect(find("EContainer").dropMechanismId).toBe(131080)
        expect(find("FContainer").dropMechanismId).toBe(131065)
        expect(find("APoint").killScore).toBe(400)
        expect(find("EPoint").killScore).toBe(10000)
    })

    test("DropMechanismId 指向 FirstSeenTag=Container 的机关", async () => {
        const rows = await buildDrop()
        const mechanisms = (await getLuaDataManager().getTable("Mechanism")) as Record<string, any>
        for (const item of rows.filter(row => row.dropMechanismId)) {
            expect(mechanisms[String(item.dropMechanismId)]?.FirstSeenTag).toBe("Container")
        }
    })

    test("标签按字典序稳定排序", async () => {
        const rows = await buildDrop()
        const tags = rows.map(item => String(item.tag))
        expect(tags).toEqual([...tags].sort())
    })
})
