/**
 * copyTranslation — 翻译词典同步工具（TS 版 copy.tran / create_translation.py）。
 *
 * 历史功能：网页仓库（dna-builder public/i18n）维护各语言的 translation.json
 * （术语/属性短语/称号与剧情文案的中文→目标语言词典），由旧 python
 * create_translation.py 从 final/i18n 导出重建后往返同步。本工具在 bun 下等价移植：
 *
 * 1. pull（可选）：外部网页 i18n 目录 → final/i18n，按语言目录映射拷贝 translation.json
 * 2. 重建（始终）：读 final/i18n/<lang> 输出，以 cn 为键源按 id 对齐目标语言，
 *    按 FIELD_CONFIG / EX_FIELDS / EX_T / 角色标签规则合并更新各语言 translation.json；
 *    查词用的 TextMap 数据直接取自当前 Lua（Script/Datas/TextMap_I18n.lua），
 *    不再依赖已删除的 out/TextMap_I18n.json
 * 3. push（可选）：final/i18n → 外部网页 i18n 目录
 *
 * 用法：
 *   bun run copytrans                                  # 仅重建 final/i18n 各语言词典
 *   bun run copytrans --web <public/i18n 目录>          # pull → 重建 → push（默认全流程）
 *   bun run copytrans --web <dir> --pull-only           # 只拉取
 *   bun run copytrans --web <dir> --push-only           # 只推回
 *   bun run copytrans --gen-only                        # 显式只重建
 *   --web 也可由环境变量 DNA_BUILDER_DIR 提供；--final <dir> 覆盖 i18n 根（测试用）
 */
import { copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs"
import { join } from "node:path"
import { getLuaDataManager } from "../lua/LuaDataManager.ts"

// ============================================================================
// 配置区 —— 与 python create_translation.py 原样迁移，便于对照维护
// ============================================================================

/** 需要提取词条的模块输出文件名（final/i18n/cn 下 *.json 的 stem） */
const ALLOW_TYPES = ["Mod", "Weapon", "Char", "Achievement", "Monster", "Pet", "Dungeon", "Resource", "Npc", "QuestChain", "SubRegion"]

/** 字段提取配置：(字段名, 输出文件名)，支持普通字段/嵌套对象/列表/点号嵌套列表（如 技能.名称） */
const FIELD_CONFIG: Array<[string, string]> = [
    ["name", "translation.json"],
    ["n", "translation.json"],
    ["chapterName", "translation.json"],
    ["chapterNumber", "translation.json"],
    ["episode", "translation.json"],
    ["名称", "translation.json"],
    ["别名", "translation.json"],
    ["势力", "translation.json"],
    ["分类", "translation.json"],
    ["描述", "translation.json"],
    ["溯源", "translation.json"],
    ["技能.名称", "translation.json"],
    ["技能.描述", "translation.json"],
    ["技能.类型", "translation.json"],
    ["技能.字段.名称", "translation.json"],
    ["技能.字段.格式", "translation.json"],
    ["技能.术语解释", "translation.json"],
    ["同律武器.名称", "translation.json"],
    ["奖励", "translation.json"],
]

/** 扩展字段：按 TextMapContent 命中查 TextMap，向非 cn 语言词典补充术语翻译 */
const EX_FIELDS = [
    "第一根源",
    "第二根源",
    "第三根源",
    "第四根源",
    "第五根源",
    "第六根源",
    "第七根源",
    "技能",
    "溯源",
    "下落攻击",
    "普通攻击",
    "蓄力攻击",
    "角色",
    "武器",
    "魔之楔",
    "探险/无尽",
    "驱离",
    "拆解",
    "驱逐",
    "避险",
    "扼守/无尽",
    "护送",
    "勘察/无尽",
    "追缉",
    "调停",
    "迁移",
    "经典剧目",
    "热映剧目",
    "不朽剧目",
    "魔灵",
    "夜航手册",
    "委托密函",
    "活力魔灵",
    "失活魔灵",
    "魔灵潜质",
    "海伯利亚",
    "华胥",
    "全部",
    "任意",
    "共情",
    "混沌",
    "才智",
    "道德",
    "功利",
    "头像框",
    "头像",
    "载具",
    "称号",
    "称号框",
    "密函",
    "武器饰品",
    "武器皮肤",
    "出生地",
    "生日",
    "档案",
    "语音",
    "全部类型",
    "单手剑",
    "长柄",
    "重剑",
    "双刀",
    "鞭刃",
    "太刀",
    "手枪",
    "双枪",
    "榴炮",
    "霰弹枪",
    "突击枪",
    "弓",
    "防御",
    "技能穿透",
    "受到的伤害",
    "灾厄熔炉",
    "灾厄熔炼",
    "烛芯",
    "遗物",
    "烛芯类别",
    "提灯",
    "深潜",
    "深潜深度",
    "海伯利亚帝国",
    "无阵营",
    "卢卡共和国",
    "充盈威力",
    "充盈转化",
    "暗属性",
    "无属性",
    "火属性",
    "光属性",
    "雷属性",
    "水属性",
    "风属性",
]

/** 额外手工翻译表：cn 为简写→完整显示；其他语言经 TextMap 取对应翻译 */
const EX_T_MANUAL: Record<string, string> = {
    属性穿透: "全属性穿透",
    技能伤害: "造成技能伤害",
    增伤: "造成的伤害",
    普攻增伤: "普通攻击伤害",
    蓄力增伤: "蓄力攻击伤害",
    下落增伤: "下落攻击伤害",
}

/** 输出是否加 "字段名:" 前缀（保持 python 默认 false） */
const ADD_FIELD_PREFIX = false
/** 是否跳过空值（保持 python 默认 false） */
const SKIP_EMPTY_VALUES = false

/** cn 键源 → 各语言字段（对齐 python lang_field_map / 旧 out/TextMap_I18n.json 语义） */
const LANG_FIELD: Record<string, string> = {
    cn: "TextMapContent",
    en: "ContentEN",
    jp: "ContentJP",
    kr: "ContentKR",
    tc: "ContentTC",
    fr: "ContentFR",
}

/** 本仓库 final/i18n/<lang> ↔ 外部网页 i18n/<locale> 目录映射（copy.tran.bat 原映射） */
const LOCALE_MAP: Array<[string, string]> = [
    ["en", "en"],
    ["jp", "ja"],
    ["tc", "zh-TW"],
    ["kr", "ko"],
    ["fr", "fr"],
    ["cn", "zh-CN"],
]

type Json = Record<string, unknown>
type Row = Record<string, unknown> & { id?: unknown }
type Value = { item: unknown; kind: "string" | "dict" | "list" }

const PROJECT_ROOT = join(import.meta.dir, "..", "..")

// ============================================================================
// 基础工具
// ============================================================================

function loadJson(file: string): Json | Row[] | null {
    if (!existsSync(file)) return null
    try {
        return JSON.parse(readFileSync(file, "utf8")) as Json | Row[]
    } catch (error) {
        console.log(`  警告: 无法读取 JSON ${file}: ${error}`)
        return null
    }
}

function kindOf(value: unknown): Value["kind"] {
    if (Array.isArray(value)) return "list"
    if (value !== null && typeof value === "object") return "dict"
    return "string"
}

/** 递归移除键值与值相同的未翻译叶子（python remove_untranslated_entries） */
export function removeUntranslated(mapping: Json): Json {
    const cleaned: Json = {}
    for (const [key, value] of Object.entries(mapping)) {
        if (value !== null && typeof value === "object" && !Array.isArray(value)) {
            const child = removeUntranslated(value as Json)
            if (Object.keys(child).length > 0) cleaned[key] = child
        } else if (!(typeof value === "string" && key === value)) {
            // 键值相同的中文叶子 = 未翻译条目，跳过
            cleaned[key] = value
        }
    }
    return cleaned
}

/** 按点号路径写入嵌套值（python set_nested_mapping），如 "tag.输出" → {tag:{输出:...}} */
export function setNested(root: Json, path: string, value: string): void {
    const parts = path.split(".")
    let current = root
    for (const part of parts.slice(0, -1)) {
        const child = current[part]
        if (child === null || typeof child !== "object" || Array.isArray(child)) {
            current[part] = {}
        }
        current = current[part] as Json
    }
    current[parts[parts.length - 1]] = value
}

/** 递归合并（python merge_translation_mapping），保留已有嵌套条目 */
export function mergeTranslation(target: Json, source: Json): void {
    for (const [key, value] of Object.entries(source)) {
        const existing = target[key]
        if (
            value !== null &&
            typeof value === "object" &&
            !Array.isArray(value) &&
            existing !== null &&
            typeof existing === "object" &&
            !Array.isArray(existing)
        ) {
            mergeTranslation(existing as Json, value as Json)
        } else {
            target[key] = value
        }
    }
}

function writeJsonSortedStable(file: string, data: Json): void {
    writeFileSync(file, `${JSON.stringify(data, null, 2)}`, "utf8")
}

/** 保存词典文件：与 python 一致（合并后写入，indent=2，无尾随换行） */
function saveTranslation(file: string, mapping: Json, note: string): void {
    const dir = file.slice(0, Math.max(file.lastIndexOf("/"), file.lastIndexOf("\\")))
    if (dir) mkdirSync(dir, { recursive: true })
    writeJsonSortedStable(file, mapping)
    console.log(
        `    已保存: ${file.slice(Math.max(file.lastIndexOf("/"), file.lastIndexOf("\\")) + 1)} (${Object.keys(mapping).length} 个条目) ${note}`
    )
}

// ============================================================================
// TextMap（等价旧 out/TextMap_I18n.json；直接物化 Script/Datas/TextMap_I18n.lua）
// ============================================================================

type TextMapEntry = Record<string, string>

function loadTextMap(): Json | null {
    const dm = getLuaDataManager()
    const table = dm.getTable("TextMap_I18n") as Json | undefined
    if (!table || Object.keys(table).length === 0) {
        console.log("  警告: 无法从 Lua 读取 TextMap_I18n，扩展字段/根键值查词将被跳过")
        return null
    }
    return table
}

function findTranslationByCnValue(textmap: Json | null, cnValue: string, lang: string): string {
    if (!textmap) return ""
    const field = LANG_FIELD[lang] ?? "TextMapContent"
    for (const entry of Object.values(textmap)) {
        const row = entry as TextMapEntry
        if (row.TextMapContent === cnValue) return row[field] ?? cnValue
    }
    return ""
}

// ============================================================================
// 角色标签（python load_char_tags_into_ex_t / load_char_tag_translations）
// ============================================================================

/** cn/Char.json 的 标签 列表：tag → 所属角色 id 与下标 */
function collectCharTagLocations(basePath: string): Map<string, [string, number]> {
    const locations = new Map<string, [string, number]>()
    const charData = loadJson(join(basePath, "cn", "Char.json"))
    if (!Array.isArray(charData)) return locations
    for (const char of charData as Row[]) {
        const id = char.id
        const tags = char.标签
        if (!Array.isArray(tags)) continue
        tags.forEach((tag, index) => {
            if (typeof tag === "string" && tag && !locations.has(tag)) {
                locations.set(tag, [String(id), index])
            }
        })
    }
    return locations
}

/** 读取目标语言 Char.json 同位置 标签 作为翻译 */
function loadCharTagTranslations(basePath: string, lang: string, locations: Map<string, [string, number]>): Map<string, string> {
    const translations = new Map<string, string>()
    if (locations.size === 0) return translations
    const targetData = loadJson(join(basePath, lang, "Char.json"))
    if (!Array.isArray(targetData)) return translations
    const byId = new Map<string, Row>()
    for (const item of targetData as Row[]) byId.set(String(item.id), item)
    for (const [tag, [charId, index]] of locations) {
        const tags = byId.get(charId)?.标签
        if (Array.isArray(tags) && index < tags.length && typeof tags[index] === "string") {
            translations.set(tag, tags[index] as string)
        }
    }
    return translations
}

/** EX_T = 手工表 + 全部角色标签（value 为嵌套路径 "tag.<tag>"），与 python 一致 */
function buildExT(tagLocations: Map<string, [string, number]>): Json {
    const exT: Json = { ...EX_T_MANUAL }
    for (const tag of tagLocations.keys()) {
        exT[tag] = `tag.${tag}`
    }
    return exT
}

// ============================================================================
// 字段词条提取（python extract_field_mapping 的逐行移植）
// ============================================================================

function collectItems(data: Row[], fieldName: string): Array<[string, Value]> {
    const items: Array<[string, Value]> = []
    for (const item of data) {
        if (!("id" in item) || !(fieldName in item)) continue
        const value = item[fieldName]
        if (SKIP_EMPTY_VALUES && !value) continue
        items.push([String(item.id), { item: value, kind: kindOf(value) }])
    }
    return items
}

/** 提取单个字段：cn 值 → 目标语言值 */
function extractFieldMapping(cnData: Row[], targetData: Row[], fieldName: string): Json {
    const mapping: Json = {}
    let matched = 0
    const addKey = (key: unknown, value: unknown): void => {
        const k = ADD_FIELD_PREFIX ? `${fieldName}:${String(key)}` : String(key)
        if (!(k in mapping)) {
            mapping[k] = value as Json[string]
            matched++
        }
    }

    const isNested = fieldName.includes(".")
    if (isNested) {
        const [parentField, childRest] = fieldName.split(".")
        for (const cnItem of cnData) {
            const itemId = cnItem.id
            if (!itemId || !(parentField in cnItem)) continue
            const cnList = cnItem[parentField]
            if (!Array.isArray(cnList)) continue

            const targetItem = targetData.find(td => td.id === itemId)
            if (!targetItem || !(parentField in targetItem)) continue
            const targetList = targetItem[parentField]
            if (!Array.isArray(targetList) || cnList.length !== targetList.length) continue

            for (let i = 0; i < cnList.length; i++) {
                const cnSkill = cnList[i] as Row
                const targetSkill = targetList[i] as Row
                if (cnSkill === null || typeof cnSkill !== "object" || targetSkill === null || typeof targetSkill !== "object") continue

                if (childRest.includes(".")) {
                    // 多层嵌套：技能.字段.名称 / 技能.字段.格式
                    const [level1, deepField] = childRest.split(".")
                    const cnFields = cnSkill[level1]
                    const targetFields = targetSkill[level1]
                    if (!Array.isArray(cnFields) || !Array.isArray(targetFields) || cnFields.length !== targetFields.length) continue
                    for (let j = 0; j < cnFields.length; j++) {
                        const cnItemRow = cnFields[j] as Row
                        const targetItemRow = targetFields[j] as Row
                        if (
                            cnItemRow === null ||
                            typeof cnItemRow !== "object" ||
                            targetItemRow === null ||
                            typeof targetItemRow !== "object"
                        )
                            continue
                        const cnValue = cnItemRow[deepField]
                        const targetValue = targetItemRow[deepField]
                        if (SKIP_EMPTY_VALUES && (!cnValue || !targetValue)) continue
                        if (cnValue !== targetValue) addKey(cnValue, targetValue)
                    }
                } else {
                    const cnValue = cnSkill[childRest]
                    const targetValue = targetSkill[childRest]
                    if (SKIP_EMPTY_VALUES && (!cnValue || !targetValue)) continue
                    if (
                        cnValue !== null &&
                        typeof cnValue === "object" &&
                        targetValue !== null &&
                        typeof targetValue === "object" &&
                        !Array.isArray(cnValue) &&
                        !Array.isArray(targetValue)
                    ) {
                        // 技能内字典字段（如 术语解释 / 字段），按序匹配键并翻译
                        const cnItems = Object.entries(cnValue as Json)
                        const targetItems = Object.entries(targetValue as Json)
                        const max = Math.min(cnItems.length, targetItems.length)
                        for (let k = 0; k < max; k++) {
                            const [cnKey, cnVal] = cnItems[k]
                            const [targetKey, targetVal] = targetItems[k]
                            if (cnKey !== targetKey) addKey(cnKey, targetKey)
                            if (childRest === "术语解释" && cnVal !== targetVal) addKey(cnVal, targetVal)
                        }
                    } else if (cnValue !== targetValue) {
                        addKey(cnValue, targetValue)
                    }
                }
            }
        }
        console.log(`    匹配 ${fieldName}: ${matched} 个条目`)
        return mapping
    }

    // 普通字段
    const cnItems = collectItems(cnData, fieldName)
    const targetByKey = new Map<string, [unknown, Value["kind"]]>()
    for (const item of targetData) {
        if (!("id" in item) || !(fieldName in item)) continue
        targetByKey.set(String(item.id), [item[fieldName], kindOf(item[fieldName])])
    }

    for (const [itemId, cnEntry] of cnItems) {
        const cnValue = cnEntry.item
        const cnKind = cnEntry.kind
        const targetEntry = targetByKey.get(itemId)
        if (!targetEntry) continue
        const [targetValue, targetKind] = targetEntry

        if (cnKind === "dict" && targetKind === "dict") {
            // 嵌套对象：通过值匹配键（如 奖励）
            const cnMap = cnValue as Json
            const targetMap = targetValue as Json
            const cnValueToKeys = new Map<string, string[]>()
            const targetValueToKeys = new Map<string, string[]>()
            for (const [k, v] of Object.entries(cnMap)) {
                const keyList = cnValueToKeys.get(String(v)) ?? []
                keyList.push(k)
                cnValueToKeys.set(String(v), keyList)
            }
            for (const [k, v] of Object.entries(targetMap)) {
                const keyList = targetValueToKeys.get(String(v)) ?? []
                keyList.push(k)
                targetValueToKeys.set(String(v), keyList)
            }
            for (const [value, cnKeys] of cnValueToKeys) {
                const targetKeys = targetValueToKeys.get(value)
                if (!targetKeys) continue
                if (cnKeys.length === 1 && targetKeys.length === 1) {
                    if (cnKeys[0] !== targetKeys[0]) addKey(cnKeys[0], targetKeys[0])
                } else if (cnKeys.length === targetKeys.length) {
                    for (let k = 0; k < cnKeys.length; k++) {
                        if (cnKeys[k] !== targetKeys[k]) addKey(cnKeys[k], targetKeys[k])
                    }
                }
            }
        } else if (cnKind === "list" && targetKind === "list") {
            const cnList = cnValue as unknown[]
            const targetList = targetValue as unknown[]
            if (cnList.length !== targetList.length) continue
            for (let i = 0; i < cnList.length; i++) {
                const cnItemVal = cnList[i]
                const targetItemVal = targetList[i]
                if (SKIP_EMPTY_VALUES && (!cnItemVal || !targetItemVal)) continue
                if (typeof cnItemVal === "string" && typeof targetItemVal === "string" && cnItemVal !== targetItemVal) {
                    addKey(cnItemVal, targetItemVal)
                }
            }
        } else if (cnKind === "string" && targetKind === "string" && cnValue !== targetValue) {
            addKey(cnValue, targetValue)
        }
    }
    console.log(`    匹配 ${fieldName}: ${matched} 个条目`)
    return mapping
}

// ============================================================================
// 各处理步骤（与 python process_file_type / ex_fields / root_keys / ex_t 对齐）
// ============================================================================

function processFileType(basePath: string, fileName: string, lang: string): void {
    console.log(`\n处理 ${fileName}...`)
    const cnData = loadJson(join(basePath, "cn", fileName))
    if (!Array.isArray(cnData)) {
        console.log(`  跳过 ${fileName}: 中文数据为空`)
        return
    }
    const targetData = loadJson(join(basePath, lang, fileName))
    if (!Array.isArray(targetData)) {
        console.log(`  跳过 ${fileName}: ${lang} 数据为空`)
        return
    }
    for (const [fieldName, outputFileName] of FIELD_CONFIG) {
        console.log(`  提取字段: ${fieldName} -> ${outputFileName}`)
        const fieldMapping = extractFieldMapping(cnData as Row[], targetData as Row[], fieldName)
        if (Object.keys(fieldMapping).length === 0) {
            console.log(`    跳过: 没有找到 ${fieldName} 字段的数据`)
            continue
        }
        const outputFile = join(basePath, lang, outputFileName)
        const existing = loadJson(outputFile)
        let merged: Json = {}
        if (existing && typeof existing === "object" && !Array.isArray(existing)) {
            merged = removeUntranslated(existing as Json)
            console.log(`    合并到现有文件: 现有 ${Object.keys(merged).length} 个条目`)
        } else {
            console.log(`    警告: 无法读取现有文件，将创建新文件`)
        }
        Object.assign(merged, fieldMapping)
        saveTranslation(outputFile, merged, "")
    }
}

function processExFields(basePath: string, lang: string, textmap: Json | null): void {
    if (EX_FIELDS.length === 0) return
    console.log(`\n处理扩展字段: 语言: ${lang}`)
    if (!textmap) {
        console.log("  跳过: TextMap 不可用")
        return
    }
    const field = LANG_FIELD[lang] ?? "TextMapContent"
    const exMapping: Json = {}
    for (const exField of EX_FIELDS) {
        for (const entry of Object.values(textmap)) {
            const row = entry as TextMapEntry
            if (row.TextMapContent !== exField) continue
            const targetValue = row[field] ?? exField
            if (exField !== targetValue) {
                exMapping[exField] = targetValue
                console.log(`  找到扩展字段翻译: ${exField} -> ${targetValue}`)
            }
            break
        }
    }
    const outputFile = join(basePath, lang, "translation.json")
    if (Object.keys(exMapping).length === 0) {
        console.log("  跳过: 没有找到扩展字段的翻译")
        return
    }
    const existing = loadJson(outputFile)
    const merged: Json = removeUntranslated(
        existing !== null && typeof existing === "object" && !Array.isArray(existing) ? (existing as Json) : {}
    )
    if (existing !== null) console.log(`  合并到现有文件: 共 ${Object.keys(merged).length} 个条目`)
    Object.assign(merged, exMapping)
    saveTranslation(outputFile, merged, "")
}

function processRootKeys(basePath: string, lang: string, rootKeyValues: Json, textmap: Json | null): void {
    if (Object.keys(rootKeyValues).length === 0) return
    console.log(`\n处理最外层键值对: 语言: ${lang}`)
    if (!textmap) {
        console.log("  跳过: TextMap 不可用")
        return
    }
    const field = LANG_FIELD[lang] ?? "TextMapContent"
    const rootMapping: Json = {}
    for (const [rootKey, rootValue] of Object.entries(rootKeyValues)) {
        if (rootValue === null || typeof rootValue === "object") continue
        // 先按 cn 值（显示短语）找，再按键找
        const lookupValues = [String(rootValue), rootKey]
        let found = false
        for (const lookup of lookupValues) {
            if (found) break
            for (const entry of Object.values(textmap)) {
                const row = entry as TextMapEntry
                if (row.TextMapContent !== lookup) continue
                const targetValue = row[field] ?? rootKey
                if (rootKey !== targetValue) {
                    rootMapping[rootKey] = String(targetValue).replace(/\{空格\}/g, " ")
                    found = true
                }
                break
            }
        }
    }
    const outputFile = join(basePath, lang, "translation.json")
    if (Object.keys(rootMapping).length === 0) {
        console.log("  跳过: 没有找到键值对的翻译")
        return
    }
    const existing = loadJson(outputFile)
    let merged: Json = {}
    if (existing && typeof existing === "object" && !Array.isArray(existing)) {
        merged = removeUntranslated(existing as Json)
        console.log(`  合并键值对到现有文件: 共 ${Object.keys(merged).length} 个条目`)
    }
    Object.assign(merged, rootMapping)
    saveTranslation(outputFile, merged, "")
}

function processExT(basePath: string, lang: string, exT: Json, textmap: Json | null, charTagTranslations: Map<string, string>): void {
    if (Object.keys(exT).length === 0) return
    console.log(`\n处理EX_T映射: 语言: ${lang}`)

    const exTMapping: Json = {}
    if (lang === "cn") {
        for (const [key, outputPath] of Object.entries(exT)) {
            const path = String(outputPath)
            if (path.includes(".")) {
                setNested(exTMapping, path, key)
            } else {
                exTMapping[key] = path
            }
        }
    } else {
        for (const [key, outputPathRaw] of Object.entries(exT)) {
            const outputPath = String(outputPathRaw)
            const cnValue = outputPath.includes(".") ? key : outputPath
            let targetValue = charTagTranslations.get(key) ?? ""
            if (!targetValue && textmap) {
                targetValue = findTranslationByCnValue(textmap, cnValue, lang)
            }
            if (targetValue && (outputPath.includes(".") || targetValue !== key)) {
                const cleaned = targetValue.replace(/\{空格\}/g, " ")
                if (outputPath.includes(".")) setNested(exTMapping, outputPath, cleaned)
                else exTMapping[key] = cleaned
                console.log(`  找到EX_T翻译: ${key} -> ${cleaned}`)
            }
        }
    }

    const outputFile = join(basePath, lang, "translation.json")
    if (Object.keys(exTMapping).length === 0) {
        console.log("  跳过: 没有找到EX_T的翻译")
        return
    }
    const existing = loadJson(outputFile)
    let merged: Json = {}
    if (existing && typeof existing === "object" && !Array.isArray(existing)) {
        merged = removeUntranslated(existing as Json)
        console.log(`  合并EX_T到现有文件: 共 ${Object.keys(merged).length} 个条目`)
    }
    mergeTranslation(merged, exTMapping)
    saveTranslation(outputFile, merged, "")
}

// ============================================================================
// 主流程
// ============================================================================

function findLangDirs(basePath: string): string[] {
    if (!existsSync(basePath)) return []
    return readdirSync(basePath, { withFileTypes: true })
        .filter(d => d.isDirectory() && d.name !== "cn")
        .map(d => d.name)
        .sort()
}

function copyTranslationFile(srcRoot: string, dstRoot: string, srcLocale: string, dstLocale: string, direction: string): void {
    const src = join(srcRoot, srcLocale, "translation.json")
    const dst = join(dstRoot, dstLocale, "translation.json")
    if (!existsSync(src)) {
        console.log(`  跳过（缺源文件）: ${src}`)
        return
    }
    mkdirSync(join(dstRoot, dstLocale), { recursive: true })
    copyFileSync(src, dst)
    console.log(`  [${direction}] ${src} -> ${dst}`)
}

export async function runCopyTranslation(args: string[]): Promise<void> {
    let webDir: string | null = null
    let finalI18n: string | null = null
    let pullOnly = false
    let pushOnly = false
    let genOnly = false
    let help = false

    let a = 0
    while (a < args.length) {
        const arg = args[a]
        const takeValue = (): string | undefined => {
            a++
            return args[a]
        }
        if (arg === "--web") webDir = takeValue() ?? webDir
        else if (arg.startsWith("--web=")) webDir = arg.slice(6)
        else if (arg === "--final") finalI18n = takeValue() ?? finalI18n
        else if (arg.startsWith("--final=")) finalI18n = arg.slice(8)
        else if (arg === "--pull-only") pullOnly = true
        else if (arg === "--push-only") pushOnly = true
        else if (arg === "--gen-only") genOnly = true
        else if (arg === "--help" || arg === "-h") help = true
        else console.log(`未知参数: ${arg}`)
        a++
    }

    if (help) {
        console.log(`copyTranslation — 翻译词典同步工具（copy.tran.bat / create_translation.py 的 TS 移植）
用法:
  bun run copytrans [--web <外部 public/i18n 目录>] [--pull-only|--push-only|--gen-only] [--final <i18n 根>]
默认（无子命令）: 仅重建 final/i18n 各语言 translation.json
--web 给出时默认: pull → 重建 → push；可用 --pull-only/--push-only 拆分
--web 也可经环境变量 DNA_BUILDER_DIR 提供；--final 供测试/自定义输出根`)
        return
    }

    if (!webDir && process.env.DNA_BUILDER_DIR) webDir = process.env.DNA_BUILDER_DIR

    const basePath = finalI18n ?? join(PROJECT_ROOT, "final", "i18n")

    if (pushOnly && !webDir) throw new Error("--push-only 需要 --web（外部 public/i18n 目录）或 DNA_BUILDER_DIR")
    if (pullOnly && !webDir) throw new Error("--pull-only 需要 --web（外部 public/i18n 目录）或 DNA_BUILDER_DIR")
    if (!existsSync(basePath)) throw new Error(`final/i18n 不存在: ${basePath}，请先运行 bun out`)

    let doPull = webDir !== null
    let doGen = true
    let doPush = webDir !== null
    if (pullOnly) {
        doPull = true
        doGen = false
        doPush = false
    } else if (pushOnly) {
        doPull = false
        doGen = false
        doPush = true
    } else if (genOnly) {
        doPull = false
        doPush = false
    }

    if (webDir && !existsSync(webDir)) throw new Error(`外部 i18n 目录不存在: ${webDir}`)

    if (doPull) {
        console.log("=== 拉取外部网页 translation.json → final/i18n ===")
        for (const [local, external] of LOCALE_MAP) copyTranslationFile(webDir!, basePath, external, local, "pull")
    }

    if (doGen) {
        console.log(`=== 重建翻译词典: ${basePath} ===`)
        const langDirs = findLangDirs(basePath)
        if (langDirs.length === 0) throw new Error(`未找到语言文件夹（${basePath} 下除 cn 外需至少一个语言目录）`)
        console.log(`找到语言文件夹: [${langDirs.join(", ")}]`)

        const cnDir = join(basePath, "cn")
        if (!existsSync(cnDir)) throw new Error(`中文文件夹不存在: ${cnDir}`)

        const tagLocations = collectCharTagLocations(basePath)
        console.log(`收集角色标签: ${tagLocations.size} 个`)
        const exT = buildExT(tagLocations)

        // cn 种子键值对（外部手工维护的 zh-CN 词典）
        let textmap: Json | null = null
        const rootKeyValues: Json = {}
        const cnTranslation = loadJson(join(cnDir, "translation.json"))
        if (cnTranslation && typeof cnTranslation === "object" && !Array.isArray(cnTranslation)) {
            Object.assign(rootKeyValues, cnTranslation)
            console.log(`读取 cn 种子词典: ${Object.keys(rootKeyValues).length} 个键值对`)
        }

        // cn 单独写 EX_T（手工简写→完整显示），主循环只处理非 cn 语言
        processExT(basePath, "cn", exT, textmap, new Map())

        for (const lang of langDirs) {
            console.log(`\n${"=".repeat(60)}`)
            console.log(`处理语言: ${lang}`)
            console.log("=".repeat(60))
            if (!textmap) textmap = loadTextMap()
            const files = readdirSync(cnDir).filter(f => f.endsWith(".json") && ALLOW_TYPES.includes(f.slice(0, -5)))
            for (const file of files) processFileType(basePath, file, lang)
            processExFields(basePath, lang, textmap)
            processRootKeys(basePath, lang, rootKeyValues, textmap)
            const tagTranslations = loadCharTagTranslations(basePath, lang, tagLocations)
            processExT(basePath, lang, exT, textmap, tagTranslations)
        }
        console.log(`\n${"=".repeat(60)}\n完成!`)
    }

    if (doPush) {
        console.log("=== 推回 final/i18n translation.json → 外部网页 ===")
        for (const [local, external] of LOCALE_MAP) copyTranslationFile(basePath, webDir!, local, external, "push")
    }
}

if (import.meta.main) {
    try {
        await runCopyTranslation(process.argv.slice(2))
    } catch (error) {
        console.error(`错误: ${(error as Error).message}`)
        process.exit(1)
    }
}
