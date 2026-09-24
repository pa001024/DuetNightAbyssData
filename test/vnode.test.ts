/**
 * M2 验收：TextMap + vnode + render + reactive。
 * 覆盖：T/TL/compile 的 cn/en 渲染；哨兵拆分；reactive 派生。
 */
import { describe, expect, test } from "bun:test"
import { TextMap } from "../src/i18n/TextMap.ts"
import { deriveLangViews } from "../src/i18n/textmapReactive.ts"
import { compile, LTemplate, LTemplateColumns, LTemplateValueOrder, record, renderTree, seq, T, TLang, TL, TMap, TReplace, TSection, TUnlessEqual, TRaw } from "../src/i18n/vnode.ts"
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

    test("TMap 仅替换当前语言的精确译文", () => {
        const textmap = { get: (_key: string, lang: string) => (lang === "cn" ? "武器暴击率" : "Weapon CRIT Chance") } as unknown as TextMap
        const node = TMap("attr", { 武器暴击率: "暴击" })

        expect(renderTree(node, "cn", textmap)).toBe("暴击")
        expect(renderTree(node, "en", textmap)).toBe("Weapon CRIT Chance")
    })

    test("TSection 仅在当前语言字段名未自带段名时添加段名", () => {
        const textmap = {
            get: (key: string, lang: string) => {
                if (key === "section") return lang === "en" ? "Samael" : "レチタティーヴォ"
                return lang === "en" ? "Reduced Damage" : "「アダージョ」持続時間"
            },
        } as unknown as TextMap

        expect(renderTree(TSection("section", "field"), "en", textmap)).toBe("[Samael]Reduced Damage")
        expect(renderTree(TSection("section", "field"), "jp", textmap)).toBe("[レチタティーヴォ]「アダージョ」持続時間")
    })

    test("TLang 可省略语言相关的对象键", () => {
        const tree = record([[TLang("仅中文", ["cn"]), 1]])

        expect(renderTree(tree, "cn", makeTextMap())).toEqual({ 仅中文: 1 })
        expect(renderTree(tree, "en", makeTextMap())).toEqual({})
    })

    test("TReplace 在翻译后应用已有字符处理", () => {
        const textmap = { get: (_key: string, lang: string) => (lang === "tc" ? "不死鳥之" : "Phoenix's ") } as unknown as TextMap

        expect(renderTree(TReplace("series", "之", ""), "tc", textmap)).toBe("不死鳥")
        expect(renderTree(TReplace("series", "之", ""), "en", textmap)).toBe("Phoenix's ")
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

    test("LTemplate 对非紧邻 float 标记保留旧流程的原始精度", () => {
        const node = LTemplate("SKILL_20407_DESC", ["90.0%", "0.25%", "75.0%", "24"], true)

        expect(renderTree(node, "en", makeTextMap())).toContain("{float4}+0.25% Skill Intensity per Sanity spent for 24.0s")
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

    test("LTemplateValueOrder 按当前语言模板重排值", () => {
        const textmap = {
            get: (_key: string, lang: string) => (lang === "en" ? "#2 then #1" : "#1 再 #2"),
        } as unknown as TextMap
        const node = LTemplateValueOrder("placeholder", [[10], [20]])

        expect(renderTree(node, "cn", textmap)).toEqual([[10], [20]])
        expect(renderTree(node, "en", textmap)).toEqual([[20], [10]])
    })

    test("LTemplateColumns 输出模板 + 各占位符逐级值", () => {
        const textmap = { get: () => "攻击提高#1，持续#2秒" } as unknown as TextMap
        const node = LTemplateColumns("placeholder", [["20%", "40%"], ["3", "4"]])

        expect(renderTree(node, "cn", textmap)).toEqual(["攻击提高#1，持续#2秒", ["20%", "40%"], ["3", "4"]])
    })

    test("LTemplateColumns 保留占位符并沿用 Lua 数值精度", () => {
        const tm = makeTextMap()
        const node = LTemplateColumns("SKILL_10102_DESC", [["75%", "90%"], ["33.25%", "39.6%"], ["6", "7"]], true)
        const rendered = renderTree(node, "cn", tm) as [string, ...string[][]]

        expect(rendered[0]).toBe("触发概率+#1。水属性角色使用此武器造成的伤害触发额外效果时，为其他队友附加攻击提高#2，持续#3秒。")
        expect(rendered[1]).toEqual(["75.0%", "90.0%"])
        expect(rendered[2]).toEqual(["33.2%", "39.6%"])
        expect(rendered[3]).toEqual(["6.0", "7.0"])
    })

    test("LTemplateColumns 每列独立应用自己的精度标记", () => {
        const tm = makeTextMap()
        const node = LTemplateColumns("SKILL_20407_DESC", [["90%", "99%"], ["0.25", "0.3"], ["75%", "80%"], ["24", "25"]], true)
        const rendered = renderTree(node, "en", tm) as [string, ...string[][]]

        // 第 2 列受 {float4} 影响保留 2 位小数，其余列按默认 1 位
        expect(rendered[2]).toEqual(["0.25", "0.3"])
        expect(rendered[1]).toEqual(["90.0%", "99.0%"])
        expect(rendered[4]).toEqual(["24.0", "25.0"])
    })

    test("LTemplateColumns 模板按语言取且列数不随语言变化", () => {
        const tm = makeTextMap()
        const node = LTemplateColumns("SKILL_10102_DESC", [
            ["75%", "90%"],
            ["33%", "39.6%"],
            ["6", "7"],
        ])
        const cn = renderTree(node, "cn", tm) as [string, ...string[][]]
        const en = renderTree(node, "en", tm) as [string, ...string[][]]

        expect(cn[0]).not.toBe(en[0])
        expect(cn[0]).toContain("#1")
        expect(en[0]).toContain("#1")
        // 值数组语言无关
        expect(cn.slice(1)).toEqual(en.slice(1))
        expect(cn.slice(1)).toHaveLength(3)
    })

    test("LTemplateColumns 保留编号空洞（#2 必须取到第 2 个数组）", () => {
        const textmap = { get: () => "只在#2处取值" } as unknown as TextMap
        const node = LTemplateColumns("placeholder", [
            ["未引用1", "未引用2"],
            ["被引用1", "被引用2"],
        ])

        expect(renderTree(node, "cn", textmap)).toEqual(["只在#2处取值", ["未引用1", "未引用2"], ["被引用1", "被引用2"]])
    })

    test("LTemplateColumns 截断未被模板引用的尾部条目", () => {
        // 值列表有 3 项但模板只引用 #1：第 2、3 项仅服务于取值内部互引，不应产出列
        const textmap = { get: () => "只引用#1" } as unknown as TextMap
        const node = LTemplateColumns("placeholder", [
            ["有效1", "有效2"],
            ["内部1", "内部2"],
            ["内部3", "内部4"],
        ])

        expect(renderTree(node, "cn", textmap)).toEqual(["只引用#1", ["有效1", "有效2"]])
    })

    test("LTemplateColumns 将各级完全一致的列退火进模板", () => {
        // 全部列恒定：退化为只有模板
        const allConst = { get: () => "强化至+#1后，此魔之楔可同时重复装备多个。" } as unknown as TextMap
        expect(renderTree(LTemplateColumns("placeholder", [["5.0", "5.0", "5.0"]]), "cn", allConst)).toEqual([
            "强化至+5.0后，此魔之楔可同时重复装备多个。",
        ])

        // 部分列恒定：#1 代入模板并删除，原 #2 重排为 #1
        const partial = { get: () => "技能效益大于等于#1时，自身技能威力提高#2。" } as unknown as TextMap
        expect(
            renderTree(LTemplateColumns("placeholder", [["130.0%", "130.0%"], ["16.0%", "24.0%"]]), "cn", partial)
        ).toEqual(["技能效益大于等于130.0%时，自身技能威力提高#1。", ["16.0%", "24.0%"]])
    })

    test("LTemplateColumns 退火后占位符重排为连续编号", () => {
        // #2 恒定被代入，#1/#3 保留 → 应重排为 #1/#2
        const textmap = { get: () => "恒定#2，变化#1 与 #3" } as unknown as TextMap
        const node = LTemplateColumns("placeholder", [["a1", "a2"], ["固定", "固定"], ["c1", "c2"]])

        expect(renderTree(node, "cn", textmap)).toEqual(["恒定固定，变化#1 与 #2", ["a1", "a2"], ["c1", "c2"]])
    })

    test("LTemplateColumns 退火时多位数占位符不被误伤", () => {
        // #10 恒定被代入、#1..#9 保留：代入 #10 不会连带影响 #1（(?!\d) 保证不匹配多位数前缀）
        const textmap = { get: () => "#1 与 #10" } as unknown as TextMap
        const columns = [["变化1", "变化2"], ...Array.from({ length: 8 }, () => ["x1", "x2"]), ["固定", "固定"]]
        const rendered = renderTree(LTemplateColumns("placeholder", columns), "cn", textmap) as [string, ...string[][]]

        expect(rendered[0]).toBe("#1 与 固定")
        expect(rendered.slice(1)).toHaveLength(9)
        expect(rendered[1]).toEqual(["变化1", "变化2"])
        expect(rendered[9]).toEqual(["x1", "x2"])
    })

    test("LTemplateColumns 模板 key 缺失时不截断", () => {
        // 文本缺失时 get 回退返回 key 本身，此时不按占位符裁剪，避免误丢数据
        const textmap = { get: (key: string) => key } as unknown as TextMap
        const node = LTemplateColumns("MISSING_KEY", [
            ["a1", "a2"],
            ["b1", "b2"],
        ])

        expect(renderTree(node, "cn", textmap)).toEqual(["MISSING_KEY", ["a1", "a2"], ["b1", "b2"]])
    })

    test("LTemplateColumns 不把 #10 当作 #1（列与编号一一对应）", () => {
        const textmap = { get: () => "第#10项" } as unknown as TextMap
        const columns = Array.from({ length: 10 }, (_, index) => [`v${index + 1}a`, `v${index + 1}b`])
        const rendered = renderTree(LTemplateColumns("placeholder", columns), "cn", textmap) as [string, ...string[][]]

        expect(rendered[0]).toBe("第#10项")
        expect(rendered[10]).toEqual(["v10a", "v10b"])
    })
})
