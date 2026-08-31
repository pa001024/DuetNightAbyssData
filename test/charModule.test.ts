import { describe, expect, test } from "bun:test"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { formatTraceValue } from "../src/modules/char/charModule.ts"

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")
const textmap = getTextMap(baseDir)

describe("char 溯源参数", () => {
    test("表达式中的 GText 单位保留并展开为米", () => {
        const dm = getLuaDataManager()
        const battleChar = (dm.getTable("BattleChar") as Record<string, any>)["1504"]
        const expression = battleChar.CharGradeParameter[1] as string
        const computed = dm.calcSkillDesc(expression, 1)

        expect(renderTree(formatTraceValue(computed), "cn", textmap)).toBe("10米")
    })
})
