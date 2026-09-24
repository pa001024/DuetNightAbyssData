import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { modModule } from "../src/modules/mod/modModule.ts"
import { skillModule } from "../src/modules/skill/skillModule.ts"

setDefaultTimeout(60000)

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")
const textmap = getTextMap(baseDir)

async function buildMods(): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
    graph.defineModule({ name: "Mod", deps: ["Skill"], outputs: true, build: async ctx => ({ Mod: await modModule(ctx) }) })

    const artifacts = await graph.build({}, undefined, ["Mod"])
    const mods = (artifacts.get("Mod") as { Mod: Array<Record<string, any>> }).Mod
    return renderTree(mods, "cn", textmap) as Array<Record<string, any>>
}

describe("mod 模块", () => {
    test("恒定列退火进模板，剩余列重排为连续编号", async () => {
        const mods = await buildMods()

        // 51311：MaxLevel=5 且 ModCardLevelMax=5，共 10 级；#3（30 秒）与 #4（15 层）各级恒定
        const mod = mods.find(item => item.id === 51311)
        const effect = mod?.效果 as [string, ...string[][]]
        const [template, ...columns] = effect

        expect(template).toBe("受到的伤害降低#1。消灭敌人时，获得1层攻击提高#2，持续30.0秒，最多叠加15.0层，叠加时刷新剩余时间。")
        expect(columns).toHaveLength(2)
        for (const column of columns) expect(column).toHaveLength(10)

        expect(columns[0][0]).toBe("4.0%")
        expect(columns[0][9]).toBe("22.0%")
        expect(columns[1][0]).toBe("2.0%")
        expect(columns[1][9]).toBe("11.0%")

        // 代入最后一级应还原为完整的满级文案
        const render = (grade: number): string => {
            let text = template
            columns.forEach((column: string[], index: number) => {
                text = text.split(`#${index + 1}`).join(column[grade])
            })
            return text
        }
        expect(render(9)).toBe("受到的伤害降低22.0%。消灭敌人时，获得1层攻击提高11.0%，持续30.0秒，最多叠加15.0层，叠加时刷新剩余时间。")
    })

    test("各级完全一致的效果退化为纯文案", async () => {
        const mods = await buildMods()

        // 「强化至+5.0后…」各级取值恒为 5.0，退火后只留模板
        const effect = mods.find(item => item.id === 51754)?.效果
        expect(effect).toEqual(["强化至+5.0后，此魔之楔可同时重复装备多个。"])

        // 42701 本身无占位符
        expect(mods.find(item => item.id === 42701)?.效果).toEqual(["击败等级不高于自身的敌人后，获得自身远程武器最大弹药量的子弹并装填。"])
    })

    test("部分列退火时保留的列按原顺序重排编号", async () => {
        const mods = await buildMods()

        // 56141：模板引用 #1（恒定 130.0%）与 #2（逐级变化）
        // 退火后 #1 代入模板，原 #2 重排为 #1
        const effect = mods.find(item => item.id === 56141)?.效果 as [string, ...string[][]]
        const [template, ...columns] = effect

        expect(template).toBe("技能效益大于等于130.0%时，自身技能威力提高#1。")
        expect(columns).toHaveLength(1)
        expect(columns[0][0]).toBe("16.0%")
        expect(columns[0][9]).toBe("88.0%")
    })

    test("仅在取值内部互引、未被模板引用的条目会被截断", async () => {
        const mods = await buildMods()

        // 201001 的 DescValues 为 ["$#Mod[201001].DescValues[2]*100$%", "#2"]，
        // 第 2 项只服务于第 1 项的内部互引，模板仅引用 #1，故不产出第二列
        // （否则会按占位符编号算出 "SkillUtils.NewGrowDesc(N).2" 这类无意义字面串）。
        const effect = mods.find(item => item.id === 201001)?.效果 as [string, ...string[][]]
        const [template, ...columns] = effect

        expect(template).toBe("改变单手剑的普通攻击招式和威力。对比默认招式，综合威力提高#1。")
        expect(columns).toHaveLength(1)
        expect(columns[0][0]).toBe("110.0%")
        expect(columns[0][9]).toBe("200.0%")
        expect(JSON.stringify(effect)).not.toContain("NewGrowDesc")
    })

    test("模板引用 #2 时保留编号空洞，列仍按编号对齐", async () => {
        const mods = await buildMods()

        // 41725 模板只引用 #2；截断上限为 2，故 #1 列保留（不被引用）以保证 #2 取到第 2 个数组
        const effect = mods.find(item => item.id === 41725)?.效果 as [string, ...string[][]]
        const [template, ...columns] = effect

        expect(template).toBe("仅当装备的魔之楔各不相同时，属性效果生效，自身召唤物造成的伤害提高#1。")
        expect(columns).toHaveLength(1)
        expect(columns[0][0]).toBe("20.0%")
        expect(columns[0][4]).toBe("60.0%")
    })
})
