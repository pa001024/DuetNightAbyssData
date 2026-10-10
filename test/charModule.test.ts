import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { charModule, formatTraceValue } from "../src/modules/char/charModule.ts"
import { skillModule } from "../src/modules/skill/skillModule.ts"

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")
const textmap = getTextMap(baseDir)
setDefaultTimeout(60000)

describe("char 溯源参数", () => {
    test("表达式中的 GText 单位保留并展开为米", () => {
        const dm = getLuaDataManager()
        const battleChar = (dm.getTable("BattleChar") as Record<string, any>)["1504"]
        const expression = battleChar.CharGradeParameter[1] as string
        const computed = dm.calcSkillDesc(expression, 1)

        expect(renderTree(formatTraceValue(computed), "cn", textmap)).toBe("10米")
    })
})

describe("char 模块", () => {
    test("行为保留动态倍率公式且角色字段不使用武器前缀动画", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        graph.defineModule({ name: "Char", deps: ["Skill"], outputs: true, build: ctx => charModule(ctx) })

        const artifacts = await graph.build({}, undefined, ["Char"])
        const chars = (artifacts.get("Char") as { Char: Array<Record<string, any>> }).Char
        const suyiBehavior = chars.find(item => item.id === 1504)?.技能?.find((item: Record<string, any>) => item.id === 150403)?.子技能?.[0]
            ?.行为
        const liseField = chars
            .find(item => item.id === 4101)
            ?.技能?.find((item: Record<string, any>) => item.id === 410102)
            ?.字段?.find((item: Record<string, any>) => item.名称?.key === "SKILL_410102_DESC_6")

        expect(suyiBehavior).toContain("$0.25*math.exp(")
        expect(liseField?.取消).toBeUndefined()
    })

    test("540201 追踪弹伤害的影响映射为多重", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        graph.defineModule({ name: "Char", deps: ["Skill"], outputs: true, build: ctx => charModule(ctx) })

        const artifacts = await graph.build({}, undefined, ["Char"])
        const chars = (artifacts.get("Char") as { Char: Array<Record<string, any>> }).Char
        const field = chars
            .find(item => item.id === 5402)
            ?.技能?.find((item: Record<string, any>) => item.id === 540201)
            ?.字段?.find((item: Record<string, any>) => item.名称?.key === "SKILL_DESC_5402_Skill01_Dmg")

        expect(field?.影响).toBe("多重")
    })

    test("540202 传颂之诗伤害的影响映射为技能威力与充盈威力", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        graph.defineModule({ name: "Char", deps: ["Skill"], outputs: true, build: ctx => charModule(ctx) })

        const artifacts = await graph.build({}, undefined, ["Char"])
        const chars = (artifacts.get("Char") as { Char: Array<Record<string, any>> }).Char
        const field = chars
            .find(item => item.id === 5402)
            ?.技能?.find((item: Record<string, any>) => item.id === 540202)
            ?.字段?.find((item: Record<string, any>) => item.名称?.key === "SKILL_DESC_5402_Passive_Dmg")

        expect(field?.影响).toBe("技能威力,充盈威力")
    })

    test("增益行为中的技能速度不再泄漏 Attr key", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        graph.defineModule({ name: "Char", deps: ["Skill"], outputs: true, build: ctx => charModule(ctx) })

        const artifacts = await graph.build({}, undefined, ["Char"])
        const chars = (artifacts.get("Char") as { Char: Array<Record<string, any>> }).Char
        // 3202（叠加层数路径：每层+#1…）、1103（直接加成路径：…+30%）的增益均含 SkillSpeed 属性
        const behaviors = [1103, 3202]
            .flatMap(id => (chars.find(item => item.id === id)?.技能 as Array<Record<string, any>> | undefined) ?? [])
            .map(skill => String(renderTree(skill.行为, "cn", textmap)))
            .join("\n")

        expect(behaviors).toContain("技能速度")
        expect(behaviors).not.toContain("Attr_SkillSpeed_Name")
    })

    test("特质按派遣标签槽位聚合，同名标签叠加等级并保留各自突破阶段", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        graph.defineModule({ name: "Char", deps: ["Skill"], outputs: true, build: ctx => charModule(ctx) })

        const artifacts = await graph.build({}, undefined, ["Char"])
        const chars = (artifacts.get("Char") as { Char: Array<Record<string, any>> }).Char
        const traits = (id: number) => chars.find(item => item.id === id)?.特质 as Array<Record<string, any>>
        const brief = (id: number, lang: string) =>
            (renderTree(traits(id), lang, textmap) as Array<Record<string, any>>).map(trait => ({
                名称: trait.名称,
                icon: trait.icon,
                等级: trait.等级,
                解锁: trait.解锁,
            }))

        // 1501：Battle/Empathy/Empathy + 突破阶段 0/2/4 → 战斗 1 级、共情 2 级
        expect(brief(1501, "cn")).toEqual([
            { 名称: "冒险家", icon: "T_Dispatch_A09", 等级: 1, 解锁: [0] },
            { 名称: "印象：共情", icon: "T_Dispatch_B03", 等级: 2, 解锁: [2, 4] },
        ])
        expect(brief(1501, "en")).toEqual([
            { 名称: "Adventurer", icon: "T_Dispatch_A09", 等级: 1, 解锁: [0] },
            { 名称: "Impression: Empathy", icon: "T_Dispatch_B03", 等级: 2, 解锁: [2, 4] },
        ])
        // 描述取 CharDispatchTag 的 TextMap key，未命中会原样输出 key
        const empathyDesc = (renderTree(traits(1501), "cn", textmap) as Array<Record<string, any>>)[1].描述
        expect(empathyDesc).not.toBe("UI_DispatchTag_Des_Empathy")
        expect(empathyDesc.length).toBeGreaterThan(0)

        // 2102：Morality/Lucky/Lucky → 诸神宠儿 2 级
        expect(brief(2102, "cn")[1]).toEqual({ 名称: "诸神宠儿", icon: "T_Dispatch_A08", 等级: 2, 解锁: [2, 4] })

        // 3202：Benefit/Benefit/Skilled + 突破阶段 0/2/5（唯一非 0/2/4 的角色）
        expect(brief(3202, "cn")).toEqual([
            { 名称: "印象：功利", icon: "T_Dispatch_B02", 等级: 2, 解锁: [0, 2] },
            { 名称: "左右逢源", icon: "T_Dispatch_A06", 等级: 1, 解锁: [5] },
        ])
    })
})
