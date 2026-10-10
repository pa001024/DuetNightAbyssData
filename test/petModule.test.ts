import { describe, expect, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { petModule, returnReward } from "../src/modules/pet/petModule.ts"

async function buildPets(): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "Pet", deps: [], outputs: true, build: ctx => petModule(ctx) })
    const artifacts = await graph.build({}, undefined, ["Pet"])
    return artifacts.get("Pet") as Array<Record<string, any>>
}

describe("Pet ReturnReward (放生)", () => {
    test("按 Lua 原值导出放生返还的魔灵告别礼数量", async () => {
        const rows = await buildPets()
        const find = (id: number) => rows.find(item => item.id === id)!

        expect(find(4011).放生).toEqual({ 110075: 3 })
        expect(find(4111).放生).toEqual({ 110075: 10 })
        expect(find(605).放生).toEqual({ 110075: 30 })
    })

    test("无返还或数量为零时省略 rr", async () => {
        const rows = await buildPets()
        const find = (id: number) => rows.find(item => item.id === id)!

        // 601（无由生）在 Pet 表中没有 ReturnReward 字段
        expect(find(601)).not.toHaveProperty("放生")
        // 4911 的 ReturnReward 为 {110075: 0}，按 PetRecycleUtils 只统计 Count > 0 的规则过滤
        expect(find(4911)).not.toHaveProperty("放生")
    })

    test("非对象或空表不输出", () => {
        expect(returnReward({})).toBeUndefined()
        expect(returnReward({ ReturnReward: [] })).toBeUndefined()
        expect(returnReward({ ReturnReward: { 110075: 0 } })).toBeUndefined()
    })
})
