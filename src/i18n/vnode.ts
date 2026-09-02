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
    /** 是否按 SkillUtils.FormatDescValue1 规则格式化替换值 */
    readonly formatValues: boolean
    readonly preserveHighlight?: boolean
    readonly dollarOffset?: number
    readonly groups?: { hash?: VNode[]; dollar?: VNode[]; at?: VNode[] }
}
/** 固定语言文本 key（如 CV 名：日文CV 始终用 jp 文本，不随输出语言变） */
export interface TFixedNode {
    readonly __t: "tf"
    readonly key: string
    readonly lang: string
}
/** 翻译文本去除首尾空白（仅用于老处理器明确 trim 的字段）。 */
export interface TTrimNode {
    readonly __t: "ttrim"
    readonly key: string
}
export interface TUnlessEqualNode {
    readonly __t: "tne"
    readonly key: string
    readonly otherKey: string
}

export type VNode =
    | TVNode
    | TLNode
    | SeqNode
    | IntNode
    | RecordNode
    | LTemplateNode
    | TFixedNode
    | TTrimNode
    | TUnlessEqualNode
    | string
    | number
    | boolean
    | null
    | undefined
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
export function LTemplate(
    key: string,
    values: VNode[],
    formatValues = false,
    preserveHighlight = false,
    dollarOffset = 0,
    groups?: { hash?: VNode[]; dollar?: VNode[]; at?: VNode[] }
): LTemplateNode {
    return { __t: "lt", key, values, formatValues, preserveHighlight, dollarOffset, groups }
}

/** 固定语言文本 key（CV 名等始终用指定语言文本，不随输出语言变） */
export function TFixed(key: string | null | undefined, lang: string): VNode {
    if (!key) return ""
    return { __t: "tf", key, lang }
}

export function TTrim(key: string | null | undefined): VNode {
    if (!key) return ""
    return { __t: "ttrim", key }
}

export function TUnlessEqual(key: string, otherKey: string): TUnlessEqualNode {
    return { __t: "tne", key, otherKey }
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

const OMIT = Symbol("omit")

function renderVNode(v: VNode, lang: string, textmap: TextMap): unknown {
    if (v === null || v === undefined) return null
    if (typeof v === "string" || typeof v === "number" || typeof v === "boolean") return v
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
        case "ttrim":
            return textmap.get(v.key, lang).trim()
        case "tne": {
            const value = textmap.get(v.key, lang)
            return value === textmap.get(v.otherKey, lang) ? OMIT : value
        }
        case "lt": {
            // TextMap 模板（含 #N 占位）+ 值替换
            let template = textmap.get(v.key, lang)
            if (template === v.key) template = textmap.get(v.key, "cn")
            if (v.groups) {
                for (const [marker, values] of [
                    ["#", v.groups.hash],
                    ["\\$", v.groups.dollar],
                    ["@", v.groups.at],
                ] as const) {
                    if (!values) continue
                    for (let i = 0; i < values.length; i++) {
                        let value = String(renderVNode(values[i], lang, textmap) ?? "")
                        if (v.formatValues) value = formatDescValue1(value, descValueCast(template, i + 1).cast)
                        template = template.replace(new RegExp(`${marker}${i + 1}(?!\\d)`, "g"), value)
                    }
                }
                if (v.preserveHighlight) return template.replace(/\{int\}/gi, "")
                return template.replace(/<[^>]*>/g, "").replace(/\{int\}/gi, "")
            }
            for (let i = 0; i < v.values.length; i++) {
                let val = String(renderVNode(v.values[i], lang, textmap) ?? "")
                if (v.formatValues) {
                    const cast = descValueCast(template, i + 1)
                    template = cast.template
                    val = formatDescValue1(val, cast.cast)
                }
                template = template.replace(new RegExp(`#${i + 1}(?!\\d)`, "g"), val)
                template = template.replace(new RegExp(`\\$${i + 1 + (v.dollarOffset ?? 0)}(?!\\d)`, "g"), val)
                template = template.replace(new RegExp(`@${i + 1}(?!\\d)`, "g"), val)
            }
            // 移除高亮标签（对齐老代码）
            if (v.preserveHighlight) return template.replace(/\{int\}/gi, "")
            return template.replace(/<[^>]*>/g, "").replace(/\{int\}/gi, "")
        }
    }
}

type DescCast = { kind: "int" } | { kind: "float"; decimals: number } | null

/** 对齐 Script/Utils/SkillUtils.lua 的 ReplaceAndChekDescValueCast。 */
function descValueCast(template: string, index: number): { template: string; cast: DescCast } {
    const marker = "[#@$]"
    const intRe = new RegExp(`\\{int\\}${marker}${index}(?!\\d)`, "i")
    if (intRe.test(template)) return { template: template.replace(intRe, `#${index}`), cast: { kind: "int" } }
    const floatRe = new RegExp(`\\{float(\\d+)\\}${marker}${index}(?!\\d)`, "i")
    const match = template.match(floatRe)
    if (match) {
        return {
            template: template.replace(floatRe, `#${index}`),
            cast: { kind: "float", decimals: Number(match[1]) },
        }
    }
    return { template, cast: null }
}

/** 对齐 Lua FormatDescValue1：默认 1 位小数，int/float 标记覆盖默认精度。 */
function formatDescValue1(value: string, cast: DescCast): string {
    const match = value.match(/-?\d+\.?\d*/)
    if (!match) return value
    const numeric = Number(match[0])
    if (!Number.isFinite(numeric)) return value
    const isPercent = value.endsWith("%")
    let decimals: number
    if (cast?.kind === "int") decimals = 0
    else if (cast?.kind === "float") decimals = isPercent ? Math.max(cast.decimals - 2, 0) : cast.decimals
    else decimals = 1
    const formatted = formatLuaFixed(numeric, decimals)
    return `${value.slice(0, match.index)}${formatted}${value.slice((match.index ?? 0) + match[0].length)}`
}

/** Match the legacy formatter: round the actual binary value to nearest, ties to even. */
function formatLuaFixed(value: number, decimals: number): string {
    const bits = new DataView(new ArrayBuffer(8))
    bits.setFloat64(0, value)
    const raw = bits.getBigUint64(0)
    const sign = raw >> 63n
    const exponentBits = Number((raw >> 52n) & 0x7ffn)
    const fraction = raw & ((1n << 52n) - 1n)
    const mantissa = exponentBits === 0 ? fraction : (1n << 52n) | fraction
    const binaryExponent = exponentBits === 0 ? -1074 : exponentBits - 1023 - 52
    const decimalFactor = 10n ** BigInt(decimals)
    const numerator = mantissa * 5n ** BigInt(decimals)
    const shift = binaryExponent + decimals

    let rounded: bigint
    if (shift >= 0) {
        rounded = numerator << BigInt(shift)
    } else {
        const divisor = 1n << BigInt(-shift)
        const quotient = numerator / divisor
        const remainder = numerator % divisor
        const doubledRemainder = remainder * 2n
        rounded = quotient
        if (doubledRemainder > divisor || (doubledRemainder === divisor && quotient % 2n === 1n)) rounded++
    }

    const absolute = rounded
    const whole = absolute / decimalFactor
    const fractionPart = absolute % decimalFactor
    const signPrefix = sign === 1n && rounded !== 0n ? "-" : ""
    if (decimals === 0) return `${signPrefix}${whole}`
    return `${signPrefix}${whole}.${fractionPart.toString().padStart(decimals, "0")}`
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
    if (typeof tree === "string" || typeof tree === "number" || typeof tree === "boolean") return tree
    if (isVNode(tree)) return renderVNode(tree, lang, textmap)
    if (Array.isArray(tree)) {
        const out: unknown[] = []
        for (const item of tree) {
            const rendered = renderTree(item, lang, textmap)
            if (rendered !== OMIT) out.push(rendered)
        }
        return out
    }
    if (Array.isArray(tree.__langs) && !tree.__langs.includes(lang)) return OMIT
    const fieldLangs = (tree as { __fieldLangs?: Record<string, string[]> }).__fieldLangs
    const out: Record<string, unknown> = {}
    for (const [k, v] of Object.entries(tree)) {
        // __ 前缀键是内部标记（如 __isDamage），不出现在最终输出
        if (k.startsWith("__")) continue
        if (Array.isArray(fieldLangs?.[k]) && !fieldLangs[k].includes(lang)) continue
        const rendered = renderTree(v, lang, textmap)
        if (rendered !== OMIT) out[k] = rendered
    }
    return out
}
