import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { skillModule } from "../src/modules/skill/skillModule.ts"
import { weaponModule } from "../src/modules/weapon/weaponModule.ts"

setDefaultTimeout(60000)

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")
const textmap = getTextMap(baseDir)

async function buildWeapons(): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
    graph.defineModule({ name: "Weapon", deps: ["Skill"], outputs: true, build: ctx => weaponModule(ctx) })

    const artifacts = await graph.build({}, undefined, ["Weapon"])
    const weapons = (artifacts.get("Weapon") as { Weapon: Array<Record<string, any>> }).Weapon
    return renderTree(weapons, "cn", textmap) as Array<Record<string, any>>
}

describe("weapon 模块", () => {
    test("武器 20405 的技能 2040501 导出字段", async () => {
        const weapons = await buildWeapons()
        const weapon = weapons.find(item => item.id === 20405)
        const skill = weapon?.技能?.find((item: Record<string, any>) => item.id === 2040501)

        expect(skill?.字段).toHaveLength(4)
        expect(skill?.字段?.[0]?.值).toBe(0.33)
        expect(skill?.字段?.[1]?.值).toBe(2)
        expect(skill?.字段?.[2]?.值).toBe(2.8)
        expect(skill?.字段?.[3]?.值).toBe(10)
        expect(skill?.字段?.[0]?.取消).toBe(0.2667)
        expect(skill?.字段?.[0]?.连段).toBe(0.4667)
        expect(skill?.字段?.[1]?.取消).toBe(0.2667)
        expect(skill?.字段?.[1]?.连段).toBe(0.4667)
        expect(skill?.字段?.[2]?.取消).toBeUndefined()
        expect(skill?.字段?.[3]?.连段).toBeUndefined()
    })

    test("熔炼为「模板 + 各占位符逐级值」，恒定列退火进模板", async () => {
        const weapons = await buildWeapons()

        // 10102：模板含 #1/#2/#3；#3（持续 6.0 秒）各级恒定，退火后只剩两列
        const weapon = weapons.find(item => item.id === 10102)
        const smelting = weapon?.熔炼 as [string, ...string[][]]
        const [template, ...columns] = smelting

        expect(typeof template).toBe("string")
        expect(template).toContain("#1")
        expect(template).toContain("#2")
        expect(template).toContain("持续6.0秒")
        expect(template).not.toContain("#3")
        expect(columns).toHaveLength(2)
        for (const column of columns) expect(column).toHaveLength(6)

        // 第 i 个数组对应重排后的 #i：代入第 1 级即完整文案
        const render = (grade: number): string => {
            let text = template
            columns.forEach((column: string[], index: number) => {
                text = text.split(`#${index + 1}`).join(column[grade])
            })
            return text
        }
        expect(render(0)).toBe("触发概率+75.0%。水属性角色使用此武器造成的伤害触发额外效果时，为其他队友附加攻击提高33.0%，持续6.0秒。")
        expect(render(5)).toBe("触发概率+150.0%。水属性角色使用此武器造成的伤害触发额外效果时，为其他队友附加攻击提高66.0%，持续6.0秒。")
        // 模板不再携带高亮标签
        expect(template).not.toContain("<H>")

        // 10101：单占位符且各级变化，保留一列
        const single = weapons.find(item => item.id === 10101)
        expect(single?.熔炼).toEqual(["角色攻击+#1。", ["60.0%", "72.0%", "84.0%", "96.0%", "108.0%", "120.0%"]])
    })

    test("各级完全一致的熔炼退化为纯文案", async () => {
        const weapons = await buildWeapons()

        const smelting = weapons.find(item => item.id === 10299)?.熔炼
        expect(smelting).toEqual(["可通过灾厄熔炼解锁武器潜能，潜能仅在角色的精通武器与该武器类型相同时生效。"])
    })
})
