/**
 * M2 验收：TextMap + vnode + render + reactive。
 * 覆盖：T/TL/compile 的 cn/en 渲染；哨兵拆分；reactive 派生。
 */
import { describe, expect, test } from "bun:test"
import { TextMap } from "../src/i18n/TextMap.ts"
import { deriveLangViews } from "../src/i18n/textmapReactive.ts"
import { compile, LTemplate, renderTree, seq, T, TL, TUnlessEqual, TRaw } from "../src/i18n/vnode.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { sentinelOf } from "../src/lua/stubs.ts"

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")

function makeTextMap(): TextMap {
    return new TextMap(baseDir)
}

describe("TextMap", () => {
    test("cn/en/jp 翻译 + 字段映射", () => {
        const tm = makeTextMap()
        // SKILL_110101_NAME 一定存在（来自 TextMap_I18n.json）
        const cn = tm.get("SKILL_110101_NAME", "cn")
        const en = tm.get("SKILL_110101_NAME", "en")
        const jp = tm.get("SKILL_110101_NAME", "jp")
        expect(cn.length).toBeGreaterThan(0)
        expect(en.length).toBeGreaterThan(0)
        expect(jp.length).toBeGreaterThan(0)
        expect(cn).not.toBe(en)
    })

    test("不存在的 key 兜底返回原 key", () => {
        const tm = makeTextMap()
        expect(tm.get("NO_SUCH_KEY_XYZ", "cn")).toBe("NO_SUCH_KEY_XYZ")
    })

    test("旧 Python 文本 fallback", () => {
        const tm = makeTextMap()
        expect(tm.get("UI_CHAR_NAME_4103", "cn")).toBe("SP黎瑟")
        expect(tm.get("UI_CHAR_NAME_5402", "cn")).toBe("莉莉蔻")
        expect(tm.get("UI_ChapterNumber_Ex02", "cn")).toBe("第二章")
    })
})

describe("vnode", () => {
    const tm = makeTextMap()
    const key = "SKILL_DESC_Meter"

    test("T 渲染为对应语言文本", () => {
        const cn = renderTree(T(key), "cn", tm) as any
        const en = renderTree(T(key), "en", tm) as any
        expect(typeof cn).toBe("string")
        expect(cn.length).toBeGreaterThan(0)
        expect(en.length).toBeGreaterThan(0)
    })

    test("TRaw 保留翻译文本中的空格标记", () => {
        expect(renderTree(TRaw("Description_120205_5"), "en", tm)).toBe("Look for Kezhou{空格}")
    })

    test("TL 显式多语言映射", () => {
        const node = TL("输出", { en: "DPS", jp: "アウトプット" })
        expect(renderTree(node, "cn", tm)).toBe("输出")
        expect(renderTree(node, "en", tm)).toBe("DPS")
        expect(renderTree(node, "jp", tm)).toBe("アウトプット")
        // 未指定的语言回退 cn
        expect(renderTree(node, "fr", tm)).toBe("输出")
    })

    test("compile 拆分哨兵计算串", () => {
        // 模拟 SkillUtils.CalcSkillDesc 输出
        const computedStr = `3.0${sentinelOf(key)}`
        const v = compile(computedStr)
        const cn = renderTree(v, "cn", tm)
        const en = renderTree(v, "en", tm)
        // 数值 3.0 保留，文本段按语言翻译
        expect(cn).toContain("3.0")
        expect(en).toContain("3.0")
        expect(cn).not.toContain("\x01GT{")
        expect(en).not.toContain("GT{")
        // cn/en 文本段不同
        expect(cn).not.toBe(en)
    })

    test("compile 纯数值串不产生占位符", () => {
        const v = compile("347.0%")
        expect(v).toBe("347.0%")
        expect(renderTree(v, "en", tm)).toBe("347.0%")
    })

    test("seq 片段", () => {
        const v = seq(["伤害", T(key)])
        const cn = renderTree(v, "cn", tm)
        expect(cn).toContain("伤害")
    })

    test("renderTree 递归整树（数组/对象混合）", () => {
        const tree = {
            name: T("SKILL_110101_NAME"),
            desc: compile(`20${sentinelOf("SKILL_DESC_SpCost")}`),
            tags: [TL("输出", { en: "DPS" }), "固定"],
            num: 3.14,
        }
        const cn = renderTree(tree, "cn", tm) as any
        const en = renderTree(tree, "en", tm) as any
        expect(typeof cn.name).toBe("string")
        expect(typeof en.name).toBe("string")
        expect(cn.name).not.toBe(en.name)
        expect(cn.num).toBe(3.14)
        expect(cn.tags).toHaveLength(2)
        expect(cn.tags[0]).toBe("输出")
        expect(en.tags[0]).toBe("DPS")
        expect(en.desc).toContain("20")
        expect(en.desc).not.toContain("\x01GT{")
    })

    test("TUnlessEqual 仅在当前语言翻译不同时保留字段", () => {
        const textmap = {
            get: (key: string, lang: string) => ({
                cn: { name: "同名", series: "同名" },
                en: { name: "Resource", series: "Series" },
            })[lang as "cn" | "en"][key as "name" | "series"],
        } as unknown as TextMap
        const tree = { name: TUnlessEqual("name", "series") }

        expect(renderTree(tree, "cn", textmap)).toEqual({})
        expect(renderTree(tree, "en", textmap)).toEqual({ name: "Resource" })
    })

    test("renderTree filters array items by internal language metadata", () => {
        const tree = [{ id: 1, __langs: ["en"], name: "English" }, { id: 2 }]

        expect(renderTree(tree, "cn", makeTextMap())).toEqual([{ id: 2 }])
        expect(renderTree(tree, "en", makeTextMap())).toEqual([{ id: 1, name: "English" }, { id: 2 }])
    })

    test("renderTree filters an individual field by internal language metadata", () => {
        const tree = { id: 1, name: "English", voice: "voice", __fieldLangs: { name: ["en"] } }

        expect(renderTree(tree, "cn", makeTextMap())).toEqual({ id: 1, voice: "voice" })
        expect(renderTree(tree, "en", makeTextMap())).toEqual({ id: 1, name: "English", voice: "voice" })
    })
})

describe("reactive 派生", () => {
    test("deriveLangViews 产生多语言 computed", () => {
        const tm = makeTextMap()
        const tree = { label: T("SKILL_110101_NAME"), num: 42 }
        const views = deriveLangViews(tree, tm) as any
        // reactive 会自动 unwrap computed ref：views.cn 直接是渲染结果
        expect(typeof views.cn).toBe("object")
        expect(views.cn.num).toBe(42)
        expect(typeof views.cn.label).toBe("string")
        expect(views.en.label).not.toBe(views.cn.label)
    })

    test("真实 SkillUtils 计算串 → compile → 各语言渲染", () => {
        const dm = getLuaDataManager()
        const tm = makeTextMap()
        const skill = dm.getTable("Skill") as any
        const values = skill["110101"][0][0].SkillDescValues as string[]
        const computed = values.map((v: string) => dm.calcSkillDesc(v, 1))
        // 第三条：3.0米
        const v = compile(computed[2])
        const cn = renderTree(v, "cn", tm)
        const en = renderTree(v, "en", tm)
        expect(cn).toContain("3")
        expect(en).toContain("3")
        expect(cn).not.toBe(en)
        expect(cn).not.toContain("GT{")
    })

    test("LTemplate 按 Lua cast 和默认精度渲染", () => {
        const tm = makeTextMap()
        const floatNode = LTemplate("SKILL_10102_DESC", ["75%", "33%", "6"], true)
        const rendered = renderTree(floatNode, "cn", tm) as string
        expect(rendered).toContain("75.0%")
        expect(rendered).toContain("33.0%")
        expect(rendered).toContain("6.0秒")

        const intNode = LTemplate("SKILL_10102_DESC", ["75%", "{int}3", "6"], true)
        expect(renderTree(intNode, "cn", tm)).not.toContain("{int}")
    })

    test("LTemplate 不会把 #10 当作 #1 替换", () => {
        const values = Array.from({ length: 10 }, (_, index) => `value-${index + 1}`)
        values[0] = "first"
        values[9] = "tenth"
        const node = LTemplate("GRADEUP_4201_06", values)
        const rendered = renderTree(node, "cn", makeTextMap()) as string

        expect(rendered).toContain("效果每tenth秒最多触发1次")
        expect(rendered).not.toContain("效果每first0秒最多触发1次")
    })

    test("LTemplate 格式化也按完整占位符索引", () => {
        const values = Array.from({ length: 10 }, () => "0")
        values[9] = "1.6"
        const textmap = { get: () => "每{int}#10秒" } as unknown as TextMap

        expect(renderTree(LTemplate("placeholder", values, true), "cn", textmap)).toBe("每2秒")
    })

    test("LTemplate 小数格式与旧导出舍入一致", () => {
        const textmap = { get: () => "#1/#2" } as unknown as TextMap

        expect(renderTree(LTemplate("placeholder", ["0.35", "0.45"], true), "cn", textmap)).toBe("0.3/0.5")
        const singleTextmap = { get: () => "#1" } as unknown as TextMap
        expect(renderTree(LTemplate("placeholder", ["6.25"], true), "cn", singleTextmap)).toBe("6.2")
    })

    test("LTemplate 分组占位符统一使用 Lua 小数格式", () => {
        const textmap = { get: () => "#1/$1/@1" } as unknown as TextMap
        const node = LTemplate("placeholder", [], true, false, 0, {
            hash: ["6.25"],
            dollar: ["0.35"],
            at: ["0.45"],
        })

        expect(renderTree(node, "cn", textmap)).toBe("6.2/0.3/0.5")
    })
})
