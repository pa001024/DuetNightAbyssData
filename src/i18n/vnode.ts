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
/** 翻译文本 key，占位标记（如 {空格}）保持原样。 */
export interface TRawNode {
    readonly __t: "traw"
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
    readonly preserveHighlight?: boolean | "capitalized"
    readonly dollarOffset?: number
    readonly groups?: { hash?: VNode[]; dollar?: VNode[]; at?: VNode[] }
}
/** 按当前语言模板中 #N 的出现顺序输出对应值，用于描述与值数组必须同步排序的导出。 */
export interface LTemplateValueOrderNode {
    readonly __t: "ltValues"
    readonly key: string
    readonly values: VNodeTree[]
}
/**
 * TextMap 模板（保留 #N 占位符）+ 每个占位符的逐级填充值。
 * 渲染为 [模板, #1各级值, #2各级值, ...]：数组下标 i（1 起）对应模板中的 #i。
 * 与 LTemplate 的区别是不做替换、保留占位符，由使用方按等级自行取值代入。
 *
 * 「退火」：某列各级取值完全一致时，说明该值不随等级变化，直接代入模板并移除该列，
 * 剩余占位符按原顺序重排为连续的 #1..#k，保证 #N 仍对应第 N 个数组。
 * 若全部列都恒定，结果退化为只剩模板的单元素数组。
 */
export interface LTemplateColumnsNode {
    readonly __t: "ltCols"
    readonly key: string
    /** columns[i] = 占位符 #(i+1) 的逐级值；级数由数据源决定 */
    readonly columns: VNode[][]
    /** 是否按 SkillUtils.FormatDescValue1 规则格式化各列值 */
    readonly formatValues: boolean
    readonly preserveHighlight?: boolean | "capitalized"
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
/** 翻译后按精确映射替换文本，仅用于兼容已发布的字段名缩写。 */
export interface TMapNode {
    readonly __t: "tmap"
    readonly key: string
    readonly map: Readonly<Record<string, string>>
}
/** 字段段名：仅在当前语言的字段名尚未自带 [] 段名时补上。 */
export interface TSectionNode {
    readonly __t: "tsection"
    readonly sectionKey: string
    readonly key: string
}
/** 仅在指定语言渲染的片段，可用于语言相关的对象键。 */
export interface TLangNode {
    readonly __t: "tlang"
    readonly value: VNode
    readonly langs: readonly string[]
}
/** 翻译后替换文本，保留原始字符级处理规则。 */
export interface TReplaceNode {
    readonly __t: "treplace"
    readonly key: string
    readonly search: string
    readonly replacement: string
}
export interface TUnlessEqualNode {
    readonly __t: "tne"
    readonly key: string
    readonly otherKey: string
}

export type VNode =
    | TVNode
    | TRawNode
    | TLNode
    | SeqNode
    | IntNode
    | RecordNode
    | LTemplateNode
    | LTemplateValueOrderNode
    | LTemplateColumnsNode
    | TFixedNode
    | TTrimNode
    | TMapNode
    | TSectionNode
    | TLangNode
    | TReplaceNode
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

/** 翻译文本 key，但保留 TextMap 中的原始占位标记。 */
export function TRaw(key: string | null | undefined): VNode {
    if (!key) return ""
    return { __t: "traw", key }
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
    preserveHighlight: boolean | "capitalized" = false,
    dollarOffset = 0,
    groups?: { hash?: VNode[]; dollar?: VNode[]; at?: VNode[] }
): LTemplateNode {
    return { __t: "lt", key, values, formatValues, preserveHighlight, dollarOffset, groups }
}

/** 按渲染语言的 #N 占位符出现顺序输出值数组。 */
export function LTemplateValueOrder(key: string, values: VNodeTree[]): LTemplateValueOrderNode {
    return { __t: "ltValues", key, values }
}

/**
 * TextMap 模板 + 每个占位符的逐级填充值（保留 #N 占位符不替换）。
 *
 * columns[i] 对应模板中的 #(i+1)，本级数由数据源决定（武器 6 级 / Mod 按 MaxLevel 等）。
 * 渲染结果：[模板, #1 逐级值, #2 逐级值, ...]。
 * 各级完全一致的列会被退火进模板并移除，剩余列重排为连续编号。
 */
export function LTemplateColumns(
    key: string,
    columns: VNode[][],
    formatValues = false,
    preserveHighlight: boolean | "capitalized" = false
): LTemplateColumnsNode {
    return { __t: "ltCols", key, columns, formatValues, preserveHighlight }
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

/** 翻译后应用精确文本映射。 */
export function TMap(key: string | null | undefined, map: Readonly<Record<string, string>>): VNode {
    if (!key) return ""
    return { __t: "tmap", key, map }
}

/** 对齐旧 Char 导出：字段译文未以 [ 开头时，才拼接所属 SkillDescGroups 段名。 */
export function TSection(sectionKey: string, key: string): TSectionNode {
    return { __t: "tsection", sectionKey, key }
}

export function TLang(value: VNode, langs: readonly string[]): TLangNode {
    return { __t: "tlang", value, langs }
}

/** 翻译后替换首次出现的精确文本。 */
export function TReplace(key: string | null | undefined, search: string, replacement: string): VNode {
    if (!key) return ""
    return { __t: "treplace", key, search, replacement }
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
        case "traw":
            return textmap.get(v.key, lang, undefined, false)
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
                if (key === OMIT) continue
                out[String(key)] = renderVNode(val, lang, textmap)
            }
            return out
        }
        case "tf":
            return textmap.get(v.key, v.lang)
        case "ttrim":
            return textmap.get(v.key, lang).trim()
        case "tmap": {
            const value = textmap.get(v.key, lang)
            return v.map[value] ?? value
        }
        case "tsection": {
            const value = textmap.get(v.key, lang)
            return value.startsWith("[") ? value : `[${textmap.get(v.sectionKey, lang)}]${value}`
        }
        case "tlang":
            return v.langs.includes(lang) ? renderVNode(v.value, lang, textmap) : OMIT
        case "treplace":
            return textmap.get(v.key, lang).replace(v.search, v.replacement)
        case "tne": {
            const value = textmap.get(v.key, lang)
            return value === textmap.get(v.otherKey, lang) ? OMIT : value
        }
        case "lt": {
            // TextMap 模板（含 #N 占位）+ 值替换
            let template = textmap.get(v.key, lang)
            if (template === v.key) template = textmap.get(v.key, "cn")
            const originalTemplate = template
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
                if (v.preserveHighlight === true) return template.replace(/\{int\}/gi, "")
                if (v.preserveHighlight === "capitalized") return template.replace(/<(?!Highlight>)[^>]*>/g, "").replace(/\{int\}/gi, "")
                return template.replace(/<[^>]*>/g, "").replace(/\{int\}/gi, "")
            }
            for (let i = 0; i < v.values.length; i++) {
                let val = String(renderVNode(v.values[i], lang, textmap) ?? "")
                if (v.formatValues) {
                    const cast = descValueCast(template, i + 1, originalTemplate)
                    template = cast.template
                    val = formatDescValue1(val, cast.cast)
                }
                template = template.replace(new RegExp(`#${i + 1}(?!\\d)`, "g"), val)
                template = template.replace(new RegExp(`\\$${i + 1 + (v.dollarOffset ?? 0)}(?!\\d)`, "g"), val)
                template = template.replace(new RegExp(`@${i + 1}(?!\\d)`, "g"), val)
            }
            // 移除高亮标签（对齐老代码）
            if (v.preserveHighlight === true) return template.replace(/\{int\}/gi, "")
            if (v.preserveHighlight === "capitalized") return template.replace(/<(?!Highlight>)[^>]*>/g, "").replace(/\{int\}/gi, "")
            return template.replace(/<[^>]*>/g, "").replace(/\{int\}/gi, "")
        }
        case "ltValues": {
            const values: unknown[] = []
            for (const match of textmap.get(v.key, lang).matchAll(/#(\d+)(?!\d)/g)) {
                const value = v.values[Number(match[1]) - 1]
                if (value !== undefined) values.push(renderTree(value, lang, textmap))
            }
            return values
        }
        case "ltCols": {
            // 保留 #N 占位符的模板 + 每个占位符的逐级值；模板仍按语言取。
            let template = textmap.get(v.key, lang)
            if (template === v.key) template = textmap.get(v.key, "cn")
            const originalTemplate = template
            // 列数按 cn 模板（数据主源）引用的最大占位符截断。
            // 数据源的取值列表可能包含未被模板引用的末尾条目：它们只服务于取值内部的
            // 互引（如 DescValues[2]="#2" 被 DescValues[1] 读取），本身不参与文案替换，
            // 但按占位符编号计算会产出无意义的字面串。截断后列与占位符仍按编号对齐。
            const cnTemplate = String(textmap.get(v.key, "cn"))
            const referenced = [...cnTemplate.matchAll(/#(\d+)(?!\d)/g)].map(match => Number(match[1]))
            const limit = referenced.length > 0 ? Math.max(...referenced) : 0
            // 模板 key 无法解析时（文本缺失，get 回退返回 key 本身）不做截断，
            // 避免把仅因文本缺失而看似"未引用"的数据一并丢弃。
            const columnCount = cnTemplate === v.key ? v.columns.length : Math.min(v.columns.length, limit)
            // 与 LTemplate 同一套 cast 处理：逐占位符消费 {int}/{floatN} 标记并解析数值精度。
            // 区别是这里不做替换（占位符原样保留），因此标记消费结果与既有替换路径逐字一致。
            let castTemplate = template
            const casts: DescCast[] = []
            for (let i = 0; i < columnCount; i++) {
                if (!v.formatValues) {
                    casts.push(null)
                    continue
                }
                const resolved = descValueCast(castTemplate, i + 1, originalTemplate)
                castTemplate = resolved.template
                casts.push(resolved.cast)
            }
            // 列与占位符按编号一一对应：columns[i] ↔ #(i+1)。
            const renderedColumns: string[][] = []
            for (let i = 0; i < columnCount; i++) {
                const rendered: string[] = []
                for (const value of v.columns[i]) {
                    const text = String(renderVNode(value, lang, textmap) ?? "")
                    rendered.push(v.formatValues ? formatDescValue1(text, casts[i]) : text)
                }
                renderedColumns.push(rendered)
            }
            // 退火：某列各级取值完全一致时，该值不随等级变化，直接代入模板并移除该列。
            const constantFlags = renderedColumns.map(column => column.length > 0 && column.every(text => text === column[0]))
            let outTemplate = castTemplate
            for (let i = 0; i < constantFlags.length; i++) {
                if (!constantFlags[i]) continue
                // 用函数式替换：取值可能含 $ 等替换字符串的元字符
                outTemplate = outTemplate.replace(new RegExp(`#${i + 1}(?!\\d)`, "g"), () => renderedColumns[i][0])
            }
            // 移除常量列后，把剩余占位符按原顺序重排为连续的 #1..#k，使 #N 始终对应第 N 个数组。
            // 按升序重排（新编号 ≤ 原编号），配合 (?!\d) 不会与 #10 之类的多位数互相干扰。
            const survivors = renderedColumns.filter((_, index) => !constantFlags[index])
            let next = 1
            for (let i = 0; i < renderedColumns.length; i++) {
                if (constantFlags[i]) continue
                const from = i + 1
                const to = next++
                if (from !== to) outTemplate = outTemplate.replace(new RegExp(`#${from}(?!\\d)`, "g"), `#${to}`)
            }
            if (v.preserveHighlight === true) outTemplate = outTemplate.replace(/\{int\}/gi, "")
            else if (v.preserveHighlight === "capitalized")
                outTemplate = outTemplate.replace(/<(?!Highlight>)[^>]*>/g, "").replace(/\{int\}/gi, "")
            else outTemplate = outTemplate.replace(/<[^>]*>/g, "").replace(/\{int\}/gi, "")
            return [outTemplate, ...survivors]
        }
    }
}

type DescCast = { kind: "int" } | { kind: "float"; decimals: number } | { kind: "preserve" } | null

/** 对齐 Script/Utils/SkillUtils.lua 的 ReplaceAndChekDescValueCast。 */
function descValueCast(template: string, index: number, originalTemplate = template): { template: string; cast: DescCast } {
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
    // Python 先以 {floatN} 到 #N 的跨度标记该参数保留精度。若两者并不相邻，
    // 后续格式替换不会消费该标记（如 {float4}+#2），因此值也不能回退为默认 1 位小数。
    const distantFloatRe = new RegExp(`\\{float\\d+\\}[^#]*#${index}(?!\\d)`, "i")
    if (distantFloatRe.test(originalTemplate)) return { template, cast: { kind: "preserve" } }
    return { template, cast: null }
}

/** 对齐 Lua FormatDescValue1：默认 1 位小数，int/float 标记覆盖默认精度。 */
function formatDescValue1(value: string, cast: DescCast): string {
    if (cast?.kind === "preserve") return value
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
