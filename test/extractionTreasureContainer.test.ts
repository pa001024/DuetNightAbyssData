import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { extractionTreasureContainerModule, extractionTreasureMechanismModule } from "../src/modules/extractionTreasure/extractionTreasureModules.ts"
import { soloTreasureDropModule } from "../src/modules/soloTreasure/soloTreasureModule.ts"

// 渲染翻译 key 会触发 TextMap 分片物化，首次调用远慢于 bun 默认 5s。
setDefaultTimeout(60000)
const textmap = getTextMap()

/** build 阶段保留翻译 key，断言文本时按 cn 渲染（与输出阶段同一路径）。 */
const cn = (value: unknown) => renderTree(value as never, "cn", textmap) as string

async function build(): Promise<{ drops: Array<Record<string, any>>; containers: Array<Record<string, any>> }> {
    const graph = new Graph()
    graph.defineModule({ name: "SoloTreasureDrop", deps: [], outputs: true, build: ctx => ({ SoloTreasureDrop: soloTreasureDropModule(ctx) }) })
    graph.defineModule({
        name: "ExtractionTreasureContainer",
        deps: ["SoloTreasureDrop"],
        outputs: true,
        build: ctx => ({ ExtractionTreasureContainer: extractionTreasureContainerModule(ctx) }),
    })
    const artifacts = await graph.build({}, undefined, ["SoloTreasureDrop", "ExtractionTreasureContainer"])
    return {
        drops: (artifacts.get("SoloTreasureDrop") as any).SoloTreasureDrop as Array<Record<string, any>>,
        containers: (artifacts.get("ExtractionTreasureContainer") as any).ExtractionTreasureContainer as Array<Record<string, any>>,
    }
}

describe("ExtractionTreasureContainer 容器数据表", () => {
    test("导出全部容器实体，不按玩法过滤；只有被 SoloTreasureDrop 引用的带 dropRate", async () => {
        const { containers } = await build()
        const withRate = containers.filter(item => item.dropRate !== undefined)
        const withoutRate = containers.filter(item => item.dropRate === undefined)

        expect(containers.length).toBe(21)
        expect(withRate.length).toBe(6)
        expect(withoutRate.length).toBe(15)
        expect(containers.map(item => item.id)).toEqual([...containers.map(item => item.id)].sort((a, b) => a - b))
    })

    test("dropRate 经 DropMechanismId 关联到 SoloTreasureDrop 的 BoxDropRate", async () => {
        const { drops, containers } = await build()
        const referenced = new Set(drops.filter(row => row.dropMechanismId).map(row => row.dropMechanismId as number))

        expect(new Set(containers.filter(item => item.dropRate !== undefined).map(item => item.id))).toEqual(referenced)
        for (const row of drops.filter(row => row.dropMechanismId)) {
            const container = containers.find(item => item.id === row.dropMechanismId)!
            expect(container.dropRate).toBe(row.boxDropRate)
        }

        expect(containers.find(item => item.id === 131076)!.dropRate).toBe(0.03)
        expect(containers.find(item => item.id === 131079)!.dropRate).toBe(0.3)
        expect(containers.find(item => item.id === 131080)!.dropRate).toBe(1)
        expect(containers.find(item => item.id === 131059)!).not.toHaveProperty("dropRate")
    })

    test("等级连续的 ItemLevelWeight 不会被当成空表丢弃", async () => {
        const { containers } = await build()
        const big = containers.find(item => item.id === 131065)!
        expect(big.itemLevelWeight).toEqual({ "1": 0.17, "2": 0.4, "3": 0.3, "4": 0.02, "5": 0.01, "6": 0.1 })
        expect(containers.find(item => item.id === 131086)!.itemLevelWeight).toEqual({
            "1": 0.15,
            "2": 0.2,
            "3": 0.3,
            "4": 0.2,
            "5": 0.05,
            "6": 0.1,
        })
        for (const item of containers) expect(Object.keys(item.itemLevelWeight).length).toBeGreaterThan(0)
    })

    test("名字取翻译 key，bp 为容器蓝图短名", async () => {
        const { containers } = await build()
        const byId = (id: number) => containers.find(item => item.id === id)!

        for (const item of containers) {
            expect((item.name as { key?: string }).key).toStartWith("UI_Extraction_TM_")
            expect(String(item.bp)).toStartWith("BP_Container_")
        }
        expect(cn(byId(131079).name)).toBe("中型竹篓")
        expect(cn(byId(131061).name)).toBe("妙妙葫芦")
        expect(byId(131060).bp).toBe("BP_Container_Small2")
    })
})

describe("ExtractionTreasureMechanism 等级权重", () => {
    test("等级连续（读回为数组）的行不再丢成空对象", async () => {
        const graph = new Graph()
        graph.defineModule({
            name: "ExtractionTreasureMechanism",
            deps: [],
            outputs: true,
            build: ctx => ({ ExtractionTreasureMechanism: extractionTreasureMechanismModule(ctx) }),
        })
        const artifacts = await graph.build({}, undefined, ["ExtractionTreasureMechanism"])
        const rows = (artifacts.get("ExtractionTreasureMechanism") as any).ExtractionTreasureMechanism as Array<Record<string, any>>

        for (const item of rows) {
            expect(Object.keys(item.itemLevelLimit).length).toBeGreaterThan(0)
            expect(Object.keys(item.itemLevelWeight).length).toBeGreaterThan(0)
        }
        expect(rows.find(item => item.id === 131065)!.itemLevelWeight).toEqual({ "1": 0.17, "2": 0.4, "3": 0.3, "4": 0.02, "5": 0.01, "6": 0.1 })
    })
})
