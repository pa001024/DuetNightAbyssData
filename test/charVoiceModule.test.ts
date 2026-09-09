import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { charVoiceModule } from "../src/modules/charVoice/charVoiceModule.ts"

setDefaultTimeout(60000)

describe("CharVoice 模块", () => {
    test("主角 2201(WeitaF) 数据源缺组时按库存补齐 14 条标准战斗语音", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "CharVoice", deps: [], outputs: true, build: ctx => ({ CharVoice: charVoiceModule(ctx) }) })
        const artifacts = await graph.build({}, undefined, ["CharVoice"])
        const rows = (artifacts.get("CharVoice") as { CharVoice: Array<Record<string, any>> }).CharVoice

        const weitaF = rows.filter(row => row.charId === 2201).sort((a, b) => Number(a.id) - Number(b.id))
        expect(weitaF).toHaveLength(14)
        expect(weitaF.map(row => row.id)).toEqual(Array.from({ length: 14 }, (_, i) => 22010001 + i))
        expect(new Set(weitaF.map(row => row.res)).size).toBe(14)
        expect(weitaF[0].res).toBe("char_WeitaF_vo_appear")

        // 既有条目不受影响，id 全局唯一
        expect(rows.filter(row => row.charId === 1101)).toHaveLength(35)
        const ids = rows.map(row => Number((row as Record<string, unknown>).id))
        expect(new Set(ids).size).toBe(ids.length)

        // 名称模板与其余角色同后缀一致；文本按语言取自 TextMap 键
        const textmap = getTextMap()
        const die = weitaF.find(row => row.res === "char_WeitaF_vo_die_r02")!
        expect(renderTree(die.name, "cn", textmap)).toBe("无法行动·其二")
        expect(renderTree(die.text, "cn", textmap)).toContain("你的困兽之斗结束了。接下来，由我肃清这个世界。")
        expect(renderTree(die.text, "en", textmap)).toContain("I'll purge the world")
    })

    test("主角 1601(主角-光) 语音 token 为 NvzhuLight，缺组时同样补齐 14 条", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "CharVoice", deps: [], outputs: true, build: ctx => ({ CharVoice: charVoiceModule(ctx) }) })
        const artifacts = await graph.build({}, undefined, ["CharVoice"])
        const rows = (artifacts.get("CharVoice") as { CharVoice: Array<Record<string, any>> }).CharVoice

        const light = rows.filter(row => row.charId === 1601).sort((a, b) => Number(a.id) - Number(b.id))
        expect(light).toHaveLength(14)
        expect(light.map(row => row.id)).toEqual(Array.from({ length: 14 }, (_, i) => 16010001 + i))
        expect(new Set(light.map(row => row.res)).size).toBe(14)
        expect(light[0].res).toBe("char_NvzhuLight_vo_appear")

        const ids = rows.map(row => Number((row as Record<string, unknown>).id))
        expect(new Set(ids).size).toBe(ids.length)

        const textmap = getTextMap()
        const die = light.find(row => row.res === "char_NvzhuLight_vo_die_r02")!
        expect(renderTree(die.name, "cn", textmap)).toBe("无法行动·其二")
        expect(renderTree(die.text, "cn", textmap)).toContain("约定的地方")
        expect(renderTree(die.text, "en", textmap)).toContain("If only")
    })
})
