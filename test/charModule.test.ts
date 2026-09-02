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
})
