/**
 * vnode — 惰性翻译占位符体系。
 *
 * 模块 build（解析阶段）产出的可翻译字段一律是 vnode，而不是已翻译的文本：
 * - 纯逻辑值（number / 普通 string）原样保留，语言无关
 * - T(key)   → TextMap 文本 key 占位符，render 时按语言查表
 * - TL(...)  → 显式多语言映射（标签类，如 输出→DPS），render 时按语言取
 * - compile(计算串) → 把游戏算好的串（含 GText 哨兵）拆成 数值段 + T(key) 片段
 *
 * 渲染阶段 renderVNode/renderTree 只做"翻译替换"，零游戏逻辑解析。
 * 由此实现：一次解析（模块 build）→ 多份语言输出（逐语言 render）。
 */
import { GT_RE } from "../lua/stubs.ts"
import type { LangCode, TextMap } from "./TextMap.ts"

// ---------- 节点类型 ----------

export interface TVNode {
    readonly __t: "t"
    readonly key: string
}
export interface TLNode {
    readonly __t: "tl"
    readonly cn: string
    readonly map: Partial<Record<LangCode, string>>
}
export interface SeqNode {
    readonly __t: "seq"
    readonly parts: VNode[]
}
export interface IntNode {
    readonly __t: "int"
    readonly value: number
}
/** 可翻译键的对象（如突破材料 { "铜币": 2800 }，键按语言翻译） */
export interface RecordNode {
    readonly __t: "rec"
    readonly entries: Array<[VNode, VNode]>
}
/** TextMap 模板 + 数值替换（如熔炼 "角色攻击+<H>#1</>。" + 值） */
export interface LTemplateNode {
    readonly __t: "lt"
    readonly key: string
    readonly values: VNode[]
}
/** 固定语言文本 key（如 CV 名：日文CV 始终用 jp 文本，不随输出语言变） */
export interface TFixedNode {
    readonly __t: "tf"
    readonly key: string
    readonly lang: string
}

export type VNode = TVNode | TLNode | SeqNode | IntNode | RecordNode | LTemplateNode | TFixedNode | string | number | null | undefined
export type VNodeTree = VNode | VNodeTree[] | { [k: string]: VNodeTree }

// ---------- 构造器 ----------

/** 文本 key 占位符（render 时按语言查 TextMap） */
export function T(key: string | null | undefined): VNode {
    if (!key) return ""
    return { __t: "t", key }
}

/** 显式多语言映射（cn 兜底） */
export function TL(cn: string, map: Partial<Record<LangCode, string>>): TLNode {
    return { __t: "tl", cn, map }
}

/** 整数格式占位（对齐老代码 {INT} 占位） */
export function INT(value: number): IntNode {
    return { __t: "int", value }
}

/** 可翻译键的对象（键/值都可为 vnode；渲染时键用翻译结果） */
export function record(entries: Array<[VNode, VNode]>): RecordNode {
    return { __t: "rec", entries }
}

/** TextMap 模板 + 数值替换（模板含 #N 占位，按语言取模板，逐级替换值） */
export function LTemplate(key: string, values: VNode[]): LTemplateNode {
    return { __t: "lt", key, values }
}

/** 固定语言文本 key（CV 名等始终用指定语言文本，不随输出语言变） */
export function TFixed(key: string | null | undefined, lang: string): VNode {
    if (!key) return ""
    return { __t: "tf", key, lang }
}

/** 片段序列 */
export function seq(parts: VNode[]): VNode {
    const flat = parts.flatMap(p => {
        if (p && typeof p === "object" && p.__t === "seq") return p.parts
        return [p]
    })
    return { __t: "seq", parts: flat }
}

/**
 * 把"游戏算好的计算串"编译为 vnode 片段。
 *
 * SkillUtils.CalcSkillDesc 返回的串里，文本 key 被 GText 哨兵 \x01GT{KEY}\x01 包裹；
 * 数值/标点部分语言无关。按哨兵切分：
 *   "3.0\x01GT{SKILL_DESC_Meter}\x01" → seq("3.0", T("SKILL_DESC_Meter"))
 *   "347.0%"                            → "347.0%"
 *   "20"                                → "20"
 */
export function compile(computedStr: string | number | null | undefined): VNode {
    if (computedStr === null || computedStr === undefined) return ""
    const str = String(computedStr)
    const matches = [...str.matchAll(GT_RE)]
    if (matches.length === 0) return str

    const parts: VNode[] = []
    let last = 0
    for (const m of matches) {
        const idx = m.index!
        if (idx > last) parts.push(str.slice(last, idx))
        parts.push(T(m[1]))
        last = idx + m[0].length
    }
    if (last < str.length) parts.push(str.slice(last))
    return seq(parts)
}

// ---------- 渲染 ----------

function renderVNode(v: VNode, lang: string, textmap: TextMap): unknown {
    if (v === null || v === undefined) return null
    if (typeof v === "string" || typeof v === "number") return v
    switch (v.__t) {
        case "t":
            return textmap.get(v.key, lang)
        case "tl":
            return (v.map as Record<string, string>)[lang] ?? v.cn
        case "seq":
            return v.parts.map(p => renderVNode(p, lang, textmap)).join("")
        case "int":
            return String(Math.round(v.value))
        case "rec": {
            // 可翻译键的对象：键、值各自渲染
            const out: Record<string, unknown> = {}
            for (const [k, val] of v.entries) {
                const key = renderVNode(k, lang, textmap)
                out[String(key)] = renderVNode(val, lang, textmap)
            }
            return out
        }
        case "tf":
            return textmap.get(v.key, v.lang)
        case "lt": {
            // TextMap 模板（含 #N 占位）+ 值替换
            let template = textmap.get(v.key, lang)
            if (template === v.key) template = textmap.get(v.key, "cn")
            for (let i = 0; i < v.values.length; i++) {
                const val = renderVNode(v.values[i], lang, textmap)
                template = template.replace(new RegExp(`#${i + 1}`, "g"), String(val))
            }
            // 移除高亮标签（对齐老代码）
            return template.replace(/<H>/g, "").replace(/<\/>/g, "")
        }
    }
}

/** 判断是否为 VNode 节点（含 __t 标记） */
function isVNode(v: unknown): v is VNode {
    return typeof v === "object" && v !== null && !Array.isArray(v) && (v as any).__t !== undefined
}

/**
 * 递归渲染整棵输出树。
 * - 数组 → map
 * - 对象 → 浅拷贝每个值
 * - VNode → renderVNode
 * 纯逻辑值（number/string）原样保留。
 */
export function renderTree(tree: VNodeTree, lang: string, textmap: TextMap): unknown {
    if (tree === null || tree === undefined) return null
    if (typeof tree === "string" || typeof tree === "number") return tree
    if (isVNode(tree)) return renderVNode(tree, lang, textmap)
    if (Array.isArray(tree)) return tree.map(t => renderTree(t, lang, textmap))
    const out: Record<string, unknown> = {}
    for (const [k, v] of Object.entries(tree)) {
        // __ 前缀键是内部标记（如 __isDamage），不出现在最终输出
        if (k.startsWith("__")) continue
        out[k] = renderTree(v, lang, textmap)
    }
    return out
}
