/**
 * copyTranslation 纯函数单元测试（无 I/O）：词典清洗/嵌套合并逻辑，
 * 对应 python create_translation.py 的 remove_untranslated / set_nested / merge 行为。
 */
import { describe, expect, test } from "bun:test"
import { mergeTranslation, removeUntranslated, setNested } from "../src/tools/copyTranslation.ts"

describe("removeUntranslated", () => {
    test("移除键值相同的中文叶子，保留有效翻译与嵌套结构", () => {
        const input = {
            "暴击": "暴击率",
            "无翻译": "无翻译",
            "tag": { "输出": "Output", "未译": "未译" },
            "其他": { "深": { "同": "同" } },
        }
        const result = removeUntranslated(input)
        expect(result).toEqual({
            "暴击": "暴击率",
            "tag": { "输出": "Output" },
        })
    })
    test("全空结构清空", () => {
        expect(removeUntranslated({ "a": "a", "b": { "c": "c" } })).toEqual({})
    })
})

describe("setNested", () => {
    test("点号路径写入嵌套对象", () => {
        const root: Record<string, unknown> = {}
        setNested(root, "tag.输出", "Output")
        setNested(root, "tag.防御", "Defense")
        expect(root).toEqual({ tag: { 输出: "Output", 防御: "Defense" } })
    })
    test("覆盖已有标量路径", () => {
        const root: Record<string, unknown> = { tag: "x" }
        setNested(root, "tag.输出", "Output")
        expect(root).toEqual({ tag: { 输出: "Output" } })
    })
})

describe("mergeTranslation", () => {
    test("递归合并保留已有嵌套条目", () => {
        const target: Record<string, unknown> = { "a": "1", "tag": { 输出: "Keep" } }
        mergeTranslation(target, { "b": "2", "tag": { 防御: "Defense" } })
        expect(target).toEqual({ "a": "1", "b": "2", tag: { 输出: "Keep", 防御: "Defense" } })
    })
    test("标量覆盖", () => {
        const target: Record<string, unknown> = { 技能伤害: "旧" }
        mergeTranslation(target, { 技能伤害: "造成技能伤害" })
        expect(target).toEqual({ 技能伤害: "造成技能伤害" })
    })
})
