import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { skillModule } from "../src/modules/skill/skillModule.ts"
import { weaponModule } from "../src/modules/weapon/weaponModule.ts"

setDefaultTimeout(60000)

describe("weapon 模块", () => {
    test("武器 20405 的技能 2040501 导出字段", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        graph.defineModule({ name: "weapon", deps: ["skill"], outputs: true, build: ctx => weaponModule(ctx) })

        const artifacts = await graph.build({}, undefined, ["weapon"])
        const weapons = (artifacts.get("weapon") as { Weapon: Array<Record<string, any>> }).Weapon
        const weapon = weapons.find(item => item.id === 20405)
        const skill = weapon?.技能?.find((item: Record<string, any>) => item.id === 2040501)

        expect(skill?.字段).toHaveLength(4)
        expect(skill?.字段?.[0]?.值).toBe(0.33)
        expect(skill?.字段?.[1]?.值).toBe(2)
        expect(skill?.字段?.[2]?.值).toBe(2.8)
        expect(skill?.字段?.[3]?.值).toBe(10)
    })
})
