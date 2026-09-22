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

        // 既有条目不受影响，id 全局唯一（35 条表内 + 1 条表外偶遇补全）
        expect(rows.filter(row => row.charId === 1101)).toHaveLength(36)
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

        // 表内 87 条都能解析出同伴角色；另有 15 条表外语音（台词+语音都在，表缺配）被补齐，不带 companioCharId
        const companioRows = rows.filter(row => String(row.res).includes("_vo_companio_"))
        expect(companioRows).toHaveLength(102)
        expect(companioRows.filter(row => typeof row.companioCharId === "number")).toHaveLength(87)
        const idle = rows.find(row => row.res === "char_Heitao_vo_idle")!
        expect(idle.companioCharId).toBeUndefined()
    })

    test("补齐 CharVoice 表缺配但台词与语音都存在的偶遇语音", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "CharVoice", deps: [], outputs: true, build: ctx => ({ CharVoice: charVoiceModule(ctx) }) })
        const artifacts = await graph.build({}, undefined, ["CharVoice"])
        const rows = (artifacts.get("CharVoice") as { CharVoice: Array<Record<string, any>> }).CharVoice
        const textmap = getTextMap()

        const xibi02 = rows.find(row => row.res === "char_Xibi_vo_companio_02")!
        expect(xibi02.charId).toBe(4301)
        expect(xibi02.companioCharId).toBeUndefined()
        expect(xibi02.hide).toBe(true)
        // 数据源原生条目不带 hide
        expect(rows.find(row => row.res === "char_Xibi_vo_companio_01")!.hide).toBeUndefined()
        expect(rows.filter(row => row.hide === true)).toHaveLength(15)
        expect(renderTree(xibi02.name, "cn", textmap)).toBe("闲谈·他人偶遇·其二")
        expect(renderTree(xibi02.text, "cn", textmap)).toContain("你和我踏上的道路完全相反")

        // 本就存在的 01/04/05 未被重复补全
        expect(rows.filter(row => row.charId === 4301 && row.res === "char_Xibi_vo_companio_01")).toHaveLength(1)
        // 止流缺的是同一编号的两句，按 _1/_2 顺序补齐
        const zhiliu = rows.filter(row => row.charId === 4102 && String(row.res).startsWith("char_Zhiliu_vo_companio_02"))
        expect(zhiliu.map(row => row.res)).toEqual(["char_Zhiliu_vo_companio_02_1", "char_Zhiliu_vo_companio_02_2"])

        // 补全条目的 VoiceId 插进数据源预留的空位：溪比 01~05 连续，止流 01~04 连续
        const xibi = rows.filter(row => row.charId === 4301 && String(row.res).includes("_vo_companio_")).sort((a, b) => Number(a.id) - Number(b.id))
        expect(xibi.map(row => row.res)).toEqual([
            "char_Xibi_vo_companio_01",
            "char_Xibi_vo_companio_02",
            "char_Xibi_vo_companio_03",
            "char_Xibi_vo_companio_04",
            "char_Xibi_vo_companio_05",
        ])
        expect(xibi.map(row => Number(row.id))).toEqual([10387, 10388, 10389, 10390, 10391])
        const zhiliuAll = rows.filter(row => row.charId === 4102 && String(row.res).includes("_vo_companio_")).sort((a, b) => Number(a.id) - Number(b.id))
        expect(zhiliuAll.map(row => Number(row.id))).toEqual([10862, 10863, 10864, 10865, 10866])

        const ids = rows.map(row => Number(row.id))
        expect(new Set(ids).size).toBe(ids.length)
    })
})
