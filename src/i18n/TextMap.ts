/**
 * TextMap — 翻译索引。
 *
 * ★ 从 Lua 读取（零 out 依赖）：
 * - TextMap_I18n.lua（Script/Datas，24MB，各语言字段）→ 主索引
 * - TextMap_TextMapContent.lua（分片懒加载表，用 __materialize 物化）→ cn 回退
 *
 * 仅在 Lua 源缺失/失败时回退 out/*.json（兼容旧环境）。
 *
 * 语言字段映射（对齐老代码）：
 *   cn→TextMapContent, en→ContentEN, jp→ContentJP, kr→ContentKR,
 *   fr→ContentFR, es→ContentES, tc→ContentTC
 */

import { getLuaDataManager } from "../lua/LuaDataManager.ts"
import type { LuaValue } from "../lua/luaToJs.ts"

export type LangCode = "cn" | "en" | "jp" | "kr" | "tc" | "fr" | "es" | "de"

export const LANGS: LangCode[] = ["cn", "en", "jp", "kr", "tc", "fr"]

export const LANG_FIELD_MAP: Record<string, string> = {
    cn: "TextMapContent",
    en: "ContentEN",
    jp: "ContentJP",
    kr: "ContentKR",
    fr: "ContentFR",
    es: "ContentES",
    tc: "ContentTC",
    de: "ContentDE",
}

/** 旧 Python 导出保留的未实装/占位文本。 */
export const TEXT_FALLBACK: Record<string, string> = {
    UI_CHAR_NAME_5402: "莉莉蔻",
    UI_CHAR_NAME_4103: "SP黎瑟",
    UI_ChapterNumber_Ex02: "第二章",
}

/** 回退字段优先顺序（对齐老代码 translate） */
const FALLBACK_FIELDS = ["TextMapContent", "ContentEN", "ContentJP", "ContentKR", "ContentFR", "ContentES", "ContentTC"]

export type TextMapEntry = Record<string, string>

export class TextMap {
    private data = new Map<string, TextMapEntry>()
    private cnAlt = new Map<string, string>()
    private loaded = false
    /** 从 Lua 还是 JSON 加载（调试信息） */
    source = ""

    constructor(_baseDir?: string) {
        void _baseDir
    }

    private load(): void {
        if (this.loaded) return
        const dm = getLuaDataManager()

        // 主源：TextMap_I18n.lua
        const i18n = dm.getTable("TextMap_I18n") as Record<string, TextMapEntry> | undefined
        if (i18n && Object.keys(i18n).length > 0) {
            for (const [k, v] of Object.entries(i18n)) this.data.set(k, v)
            this.source = "lua"
        }
        // cn 回退源：TextMap_TextMapContent.lua（分片懒加载表，物化）
        const content = dm.materializeTable("TextMap_TextMapContent") as Record<string, LuaValue> | undefined
        if (content && Object.keys(content).length > 0) {
            for (const [k, v] of Object.entries(content)) {
                const entry = v as Record<string, string> | undefined
                if (entry && typeof entry.TextMapContent === "string") {
                    this.cnAlt.set(k, entry.TextMapContent)
                }
            }
        }

        this.loaded = true
    }

    /** 原始条目（key → 各语言字段） */
    entry(key: string): TextMapEntry | undefined {
        this.load()
        return this.data.get(key)
    }

    /**
     * 取指定语言文本。
     * 逻辑对齐老代码 get_translated_text：
     * - 无条目时用 cnAlt（TextMapContent）兜底，再兜底 T_FALLBACK / 原 key
     * - cn 优先 cnAlt（Loader 里的最新中文）
     * - 目标字段为空时按 FALLBACK_FIELDS 顺序回退
     */
    get(key: string, lang: string = "cn", tFallback?: Record<string, string>): string {
        this.load()
        const entry = this.data.get(key)
        if (!entry) {
            const alt = this.cnAlt.get(key)
            if (alt) return alt
            return tFallback?.[key] || TEXT_FALLBACK[key] || key
        }
        if (lang === "cn") {
            const alt = this.cnAlt.get(key)
            if (alt) return alt
        }
        const field = LANG_FIELD_MAP[lang] ?? "TextMapContent"
        let content = entry[field] ?? ""
        if (!content) {
            for (const f of FALLBACK_FIELDS) {
                if (entry[f]) {
                    content = entry[f]
                    break
                }
            }
        }
        return (content || tFallback?.[key] || TEXT_FALLBACK[key] || key).replace(/\{空格\}/g, " ")
    }

    /** 是否有该 key */
    has(key: string): boolean {
        this.load()
        return this.data.has(key) || this.cnAlt.has(key)
    }

    get size(): number {
        this.load()
        return this.data.size
    }
}

let _instance: TextMap | null = null
export function getTextMap(_baseDir?: string): TextMap {
    if (!_instance) _instance = new TextMap()
    return _instance
}
