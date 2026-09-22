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

    test("偶遇语音输出同伴角色 companioCharId，非偶遇语音不带该字段", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "CharVoice", deps: [], outputs: true, build: ctx => ({ CharVoice: charVoiceModule(ctx) }) })
        const artifacts = await graph.build({}, undefined, ["CharVoice"])
        const rows = (artifacts.get("CharVoice") as { CharVoice: Array<Record<string, any>> }).CharVoice
        const textmap = getTextMap()

        // 黑桃 companio_02 的对象是松露(5101)，由 UnlockDialogue 定位到 HeitaoSonglu 闲谈
        const heitaoSonglu = rows.find(row => row.res === "char_Heitao_vo_companio_02_1")!
        expect(heitaoSonglu.charId).toBe(1101)
        expect(heitaoSonglu.companioCharId).toBe(5101)
        expect(renderTree(heitaoSonglu.text, "cn", textmap)).toContain("松露小姐")

        // 玛尔 companio_01 的对象是希尔妲(3102)：闲谈 MaerXier，而非 SongluMaer
        const maerXier = rows.find(row => row.res === "char_Maer_vo_companio_01")!
        expect(maerXier.charId).toBe(3301)
        expect(maerXier.companioCharId).toBe(3102)
        expect(renderTree(maerXier.text, "cn", textmap)).toContain("希尔妲")

        // 卡米没有 companio_01（编号空缺），companio_02 是赛琪(5301)而不是第二组闲谈的止流(4102)
        const kami = rows.filter(row => row.charId === 3202 && String(row.res).includes("_vo_companio_"))
        expect(kami.map(row => row.res)).toEqual([
            "char_Kami_vo_companio_02",
            "char_Kami_vo_companio_03",
            "char_Kami_vo_companio_04",
        ])
        expect(kami.map(row => row.companioCharId)).toEqual([5301, 4102, 5102])
        expect(renderTree(kami[0].text, "cn", textmap)).toContain("治愈人心")

        const companioRows = rows.filter(row => String(row.res).includes("_vo_companio_"))
        expect(companioRows).toHaveLength(87)
        expect(companioRows.filter(row => typeof row.companioCharId === "number")).toHaveLength(87)
        const idle = rows.find(row => row.res === "char_Heitao_vo_idle")!
        expect(idle.companioCharId).toBeUndefined()
    })
})
