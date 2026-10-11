import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { skillModule } from "../src/modules/skill/skillModule.ts"
import { weaponModule } from "../src/modules/weapon/weaponModule.ts"

setDefaultTimeout(60000)

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")
const textmap = getTextMap(baseDir)

async function buildAllWeapons(): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
    graph.defineModule({ name: "Weapon", deps: ["Skill"], outputs: true, build: ctx => weaponModule(ctx) })

    const artifacts = await graph.build({}, undefined, ["Weapon"])
    return (artifacts.get("Weapon") as { Weapon: Array<Record<string, any>> }).Weapon
}

async function buildWeapons(): Promise<Array<Record<string, any>>> {
    return renderTree(await buildAllWeapons(), "cn", textmap) as Array<Record<string, any>>
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

    test("武器技能名按语言渲染（官方词条 + 无词条补充译名）", async () => {
        const weapons = await buildAllWeapons()
        const nameOf = (lang: Parameters<typeof renderTree>[1], weaponId: number, skillId: number): unknown => {
            const rendered = renderTree(weapons, lang, textmap) as Array<Record<string, any>>
            const weapon = rendered.find(item => item.id === weaponId)
            const skill = weapon?.技能?.find((s: Record<string, any>) => s.id === skillId)
            return skill?.名称
        }

        // 官方词条：蓄力攻击 / 下落攻击 / 滑行攻击 / 射击
        expect(nameOf("cn", 10101, 1010101)).toBe("普通攻击")
        expect(nameOf("en", 10101, 1010101)).toBe("Normal Attack")
        expect(nameOf("en", 10101, 1010102)).toBe("Charged Attack")
        expect(nameOf("jp", 10101, 1010102)).toBe("溜め攻撃")
        expect(nameOf("kr", 10101, 1010103)).toBe("낙하 공격")
        expect(nameOf("fr", 10101, 1010104)).toBe("Attaque en glissade")
        expect(nameOf("tc", 10101, 1010101)).toBe("普通攻擊")

        // HeavyShooting 曾因映射缺失直接输出枚举名，现补为「蓄力射击」
        expect(nameOf("cn", 20405, 2040502)).toBe("蓄力射击")
        expect(nameOf("en", 20405, 2040502)).toBe("Charged Shot")
    })

    test("各级完全一致的熔炼退化为纯文案", async () => {
        const weapons = await buildWeapons()

        const smelting = weapons.find(item => item.id === 10299)?.熔炼
        expect(smelting).toEqual(["可通过灾厄熔炼解锁武器潜能，潜能仅在角色的精通武器与该武器类型相同时生效。"])
    })

    test("追加伤害去重只隐藏纯数值句：10199 保留追伤描述，10399/20599 仍隐藏", async () => {
        const weapons = await buildWeapons()
        const furnaceSkill = (weaponId: number, level: number): Record<string, any> | undefined =>
            weapons
                .find(item => item.id === weaponId)
                ?.熔炉?.find((row: Record<string, any>) => row.lv === level)
                ?.技能?.[0]

        // 10199 lv5 描述有后半段追伤（SkillEffects[1019901]/PassiveEffect 参数），cn 必须保留
        const truth = furnaceSkill(10199, 5)
        expect(truth?.id).toBe(10199010)
        expect(truth?.描述).toContain("3.0")
        expect(truth?.描述).toContain("3500.0%")
        expect(truth?.描述).toContain("1.0")
        // Buff 来的追加伤害与 SkillEffects 来的技能追伤分开字段
        expect(truth?.加成).toEqual({ 技能追伤: 0.5 })

        // 10399/20599 描述只有“自属性追加伤害+#1”一句，与加成重复，cn 仍隐藏
        expect(furnaceSkill(10399, 4)?.描述).toBeUndefined()
        expect(furnaceSkill(10399, 4)?.加成).toEqual({ 追加伤害: 0.35 })
        expect(furnaceSkill(20599, 4)?.描述).toBeUndefined()
        expect(furnaceSkill(20599, 4)?.加成).toEqual({ 追加伤害: 0.35 })
    })

    test("技能追伤改名：带 Skill 追伤的技能改记技能追伤，Weapon 追伤走原先追加伤害", async () => {
        const weapons = await buildWeapons()
        const furnaceSkill = (weaponId: number, level: number): Record<string, any> | undefined =>
            weapons
                .find(item => item.id === weaponId)
                ?.熔炉?.find((row: Record<string, any>) => row.lv === level)
                ?.技能?.[0]

        // 10199 lv5：只有技能追伤 0.5（改名，无追加伤害键）
        expect(furnaceSkill(10199, 5)?.加成).toEqual({ 技能追伤: 0.5 })
        // 顶层汇总同步改名
        expect(weapons.find(item => item.id === 10199)?.加成).toMatchObject({ 技能追伤: 0.5 })
        expect(weapons.find(item => item.id === 10199)?.加成).not.toHaveProperty("追加伤害")
        // Weapon 追伤 / 纯数值句保留原先追加伤害路径
        expect(furnaceSkill(10399, 4)?.加成).toEqual({ 追加伤害: 0.35 })
        expect(weapons.find(item => item.id === 10399)?.加成).toMatchObject({ 追加伤害: 0.35 })
        expect(weapons.find(item => item.id === 10399)?.加成).not.toHaveProperty("技能追伤")
        for (const weaponId of [10299, 20599, 20298]) {
            expect(furnaceSkill(weaponId, 0)?.加成 ?? {}).not.toHaveProperty("技能追伤")
        }
    })
})
