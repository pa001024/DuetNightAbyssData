/**
 * skillModule — ★ 纯依赖模块（不输出文件）。
 *
 * 被 char / weapon / mod 等模块依赖。职责：
 *
 * 1. **数值计算**：封装 LuaDataManager 里的游戏 SkillUtils 调用
 *    （CalcSkillDesc / GetSkillName / GetMaxLevel…），正确性由游戏引擎保证。
 * 2. **数据解释**：把原始 Skill/SkillNode/SkillEffects 表"解释"为输出结构
 *    （字段/影响/值/削韧/tag/取消/连段/术语/实体），这部分游戏 Utils 不产出，
 *    在 TS 遍历原始表实现（相对机械、可测）。
 * 3. **术语/标签映射**：P_MAP / _DAMAGE_TAG_CN / attr 键拼接（port 老代码）。
 *
 * 输出结构里的可翻译部分一律 vnode（T/TL/compile），语言无关；多语言渲染在下游。
 */

import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import { compile, seq, T, TL, type VNode } from "../../i18n/vnode.ts"
import { GT_RE } from "../../lua/stubs.ts"

// ---------- 常量映射（port 老代码） ----------

/** P_MAP：属性名缩写（port processor/_util.py） */
export const P_MAP: Record<string, string> = {
    最大神智: "神智",
    造成的伤害: "增伤",
    造成技能伤害: "技能伤害",
    暴击率: "暴击",
    暴击伤害: "暴伤",
    触发概率: "触发",
    切割攻击: "物理",
    贯穿攻击: "物理",
    震荡攻击: "物理",
    攻击速度: "攻速",
    远程武器: "远程",
    近战武器: "近战",
    近战同律武器: "同律近战",
    远程同律武器: "同律远程",
    角色: "角色",
    暗属性攻击: "属性攻击",
    水属性攻击: "属性攻击",
    火属性攻击: "属性攻击",
    雷属性攻击: "属性攻击",
    风属性攻击: "属性攻击",
    光属性攻击: "属性攻击",
    ExtraComboProb: "额外连击",
    多重射击: "多重",
    最大弹药: "弹药",
    弹匣容量: "弹匣",
    子弹装填速度: "装填",
    GrRate: "歧视",
    JtRate: "歧视",
    JhRate: "歧视",
    SqRate: "歧视",
    全属性穿透: "属性穿透",
    普通攻击伤害: "普攻增伤",
    蓄力攻击伤害: "蓄力增伤",
    下落攻击伤害: "下落增伤",
    HyperTriggerCovertRate: "充盈转化",
    WeaponCRDModifierRate: "暴伤",
    WeaponCRDModifierValue: "暴伤",
    Def: "防御",
    Sp: "神智",
    SpRate: "神智比例",
    SkillSpeed: "技能速度",
    MoveSpeedAddRate: "移动速度加成",
    WalkSpeedModifier: "移动速度",
    FlySpeedModifier: "飞行速度",
}

/** 伤害标签 → 中文（port base_processor._DAMAGE_TAG_CN，仅常用部分；未知原样） */
export const DAMAGE_TAG_CN: Record<string, string> = {
    Attack: "普攻",
    Skill: "技能",
    Skill1: "战技",
    Skill2: "终结技",
    Ultra: "同律",
    Weapon: "武器",
    Melee: "近战",
    Ranged: "远程",
    MeleeWord: "近战词条",
    HeavyAttack: "蓄力攻击",
    FallAttack: "下落攻击",
    SlideAttack: "滑行攻击",
    Dodge: "闪避",
    Dot: "持续",
    Hot: "治疗",
    Explode: "爆炸",
    BonusDamage: "追加",
    HyperTrigger: "充盈",
}

/** 伤害类型 → 中文（port char_processor._DAMAGE_TYPE_CN） */
export const DAMAGE_TYPE_CN: Record<string, string> = {
    Fire: "火",
    Water: "水",
    Thunder: "雷",
    Wind: "风",
    Light: "光",
    Dark: "暗",
    Slash: "切割",
    Pierce: "贯穿",
    Smash: "震荡",
    TrueDamage: "真实",
    Default: "无属性",
}

/** 伤害基值属性 → 中文（port char_processor._BASE_ATTR_CN） */
export const BASE_ATTR_CN: Record<string, string> = {
    ATK: "攻击",
    ATK_Char: "角色攻击",
    ATK_Melee: "近战武器攻击",
    ATK_Ultra: "终结攻击",
    SkillIntensity: "技能威力",
    MaxHp: "目标最大生命",
    MaxES: "目标护盾",
    HpRate: "目标生命比例",
    ES: "护盾",
}

/** 动作/技能名 → 中文（port char_processor._ACTION_CN） */
export const ACTION_CN: Record<string, string> = {
    Attack: "普攻",
    HeavyAttack: "重击",
    SlideAttack: "滑行攻击",
    FallAttack: "下落攻击",
    Shooting: "射击",
    HeavyShooting: "蓄力射击",
    Reload: "装填",
    Dodge: "闪避",
    Skill1: "战技",
    Skill2: "终结技",
}

// ---------- 数据解释辅助 ----------

function asString(v: unknown): string {
    return v === null || v === undefined ? "" : String(v)
}
function asNumber(v: unknown): number | null {
    if (typeof v === "number") return v
    if (typeof v === "string" && v.trim() !== "" && !Number.isNaN(Number(v))) return Number(v)
    return null
}

/** 提取引用 ID：$#SkillEffects[N] / $#SkillNode[N]（按出现顺序去重） */
export function extractReferencedIds(descValue: string): { effectIds: number[]; nodeIds: number[] } {
    const effectIds: number[] = []
    const nodeIds: number[] = []
    const seenE = new Set<number>()
    const seenN = new Set<number>()
    for (const m of descValue.matchAll(/\$#SkillEffects\[(\d+)\]/g)) {
        const id = Number(m[1])
        if (!seenE.has(id)) {
            seenE.add(id)
            effectIds.push(id)
        }
    }
    for (const m of descValue.matchAll(/\$#SkillNode\[(\d+)\]/g)) {
        const id = Number(m[1])
        if (!seenN.has(id)) {
            seenN.add(id)
            nodeIds.push(id)
        }
    }
    return { effectIds, nodeIds }
}

/** round_value：四舍五入到最多 3 位小数，对齐老代码 */
export function roundValue(value: number): number {
    const rounded = Math.round(value * 10000) / 10000
    if (Math.abs(rounded - Math.round(rounded)) < 0.00001) return Math.round(rounded)
    return rounded
}

/** 提取值 + 值2 + 格式模板（port weapon_processor._extract_field_value_and_format） */
export function extractFieldValueAndFormat(
    calculatedValue: string | number | null | undefined
): [number | string, number | string | null, string | null] {
    if (calculatedValue === null || calculatedValue === undefined) return [0, null, null]
    const text = String(calculatedValue)
    // GText 哨兵只是单位/说明文本，不应被误识别为值（例如 key 中的 1102）。
    // 用等长掩码扫描，保留哨兵本身供格式 vnode 后续翻译。
    const scanText = text.replace(GT_RE, match => match.replace(/\d/g, " "))
    const matches = [...scanText.matchAll(/-?\d+(?:\.\d+)?/g)]
    if (matches.length === 0) return [text, null, null]

    const prevSignificant = (src: string, index: number): string => {
        let i = index - 1
        while (i >= 0 && /\s/.test(src[i])) i--
        return i >= 0 ? src[i] : ""
    }

    const values: number[] = []
    const fmtParts: string[] = []
    let cursor = 0

    for (const match of matches) {
        const start = match.index!
        const end = start + match[0].length
        fmtParts.push(text.slice(cursor, start))
        const rawNumber = match[0]
        const percent = end < text.length && text[end] === "%"
        const prevChar = prevSignificant(text, start)
        // xN 连击次数是常量，保留在格式里
        const isMultiplierConstant = ["×", "x", "X", "*"].includes(prevChar) && !percent && /^\d+$/.test(rawNumber) && values.length >= 1
        if (isMultiplierConstant) {
            fmtParts.push(rawNumber)
            cursor = end
            continue
        }
        const num = Number(rawNumber)
        if (percent) {
            values.push(roundValue(num / 100.0))
            fmtParts.push("{%}")
            cursor = end + 1
        } else {
            values.push(roundValue(num))
            fmtParts.push("{}")
            cursor = end
        }
    }
    fmtParts.push(text.slice(cursor))

    if (values.length === 0) return [text, null, null]
    const value = values[0]
    const value2 = values.length > 1 ? values[1] : null
    const valueFormat = fmtParts.join("") || null
    return [value, value2, valueFormat]
}

// ---------- 技能模块 ----------

export interface SkillArtifacts {
    /** 游戏 SkillUtils 计算技能描述（返回计算串，可能含 GText 哨兵） */
    calcSkillDesc(desc: string, level?: number): string
    /** 技能名翻译 key */
    getSkillNameKey(skillId: number): string | undefined
    /** 技能最大等级 */
    getSkillMaxLevel(skillId: number): number | undefined
    /** 描述计算串 → vnode 片段（哨兵拆分） */
    compileDesc(computed: string | number | null | undefined): VNode
    /** 技能名 → vnode */
    skillNameVNode(skillId: number): VNode
    /** 伤害标签 → 中文 */
    damageTagCn(tag: string): string
    /** 属性名缩写 */
    pMap(name: string): string
    /** 技能字段解释（数据层）：desc_keys/values → 字段列表（vnode 化的名称/值/削韧/tag） */
    explainSkillFields(skillEntry: Record<string, unknown>, tableId: number, maxLevel?: number): unknown[]
    /** 从 SkillEffects 取字段的削韧/Boss削韧/tag/延迟/卡肉 */
    resolveFieldCombatMeta(
        descValue: string,
        skillEffects: Record<string, any>
    ): {
        isDamage: boolean
        削韧?: number
        Boss削韧?: number
        tag?: string[]
        延迟?: number
        卡肉?: number
    }
    /** 提取技能实体（port skill_creature_utils.extract_skill_creatures） */
    extractCreatures(skillId: number, keepHidden?: boolean): unknown[]
    /** 武器风格技能字段解析（对齐 weapon._process_weapon_skill_desc） */
    parseWeaponLikeSkillField(
        descKey: string,
        descValue: string,
        tableId: number,
        skillEntry: Record<string, unknown>
    ): Record<string, unknown>
}

export function skillModule(ctx: ModuleContext) {
    const dm = ctx.dm
    // 原始表（懒加载）
    const skillData = () => (dm.getTable("Skill") as Record<string, any>) || {}
    const skillNodeData = () => (dm.getTable("SkillNode") as Record<string, any>) || {}
    const skillEffectsData = () => (dm.getTable("SkillEffects") as Record<string, any>) || {}

    const getEntry = (id: number | string, table: Record<string, any>): any => {
        let e = table[String(id)]
        if (!e) e = table[id as number]
        return e
    }

    const damageTagCn = (tag: string): string => DAMAGE_TAG_CN[tag] ?? tag

    /** 从 SkillEffects 解析字段的削韧/Boss削韧/tag/延迟/卡肉 */
    const resolveFieldCombatMeta = (
        descValue: string,
        skillEffects: Record<string, any>
    ): { isDamage: boolean; 削韧?: number; Boss削韧?: number; tag?: string[]; 延迟?: number; 卡肉?: number } =>
        resolveFieldCombatMetaImpl(descValue, skillEffects)

    /** 技能字段解释（对齐 char.process_skill_desc 的核心路径） */
    const explainSkillFields = (skillEntry: Record<string, unknown>, tableId: number, maxLevel?: number): unknown[] => {
        const descKeys = asArray(skillEntry.SkillDescKeys)
        const descValues = asArray(skillEntry.SkillDescValues)
        if (descKeys.length === 0 || descValues.length === 0) return []

        const result: unknown[] = []
        for (let i = 0; i < descKeys.length; i++) {
            const descKey = descKeys[i]
            const descValue = descValues[i]
            if (descKey === null || descKey === undefined || descValue === null || descValue === undefined) continue

            // 名称：T(key)
            const item: Record<string, unknown> = { 名称: T(asString(descKey)) }

            // 计算值（遍历 max_level 取数组 / 常量）
            const computed = dm.calcSkillDesc(asString(descValue), 1)
            // 用 extractFieldValueAndFormat 拆数值与格式（computed 已含数值，哨兵仅文本段）
            const [value, value2, format] = extractFieldValueAndFormat(computed)
            item["值"] = value
            if (value2 !== null) item["值2"] = value2
            if (format && format !== "{%}") item["格式"] = format

            // 削韧/Boss削韧（引用 SkillEffects）
            const meta = resolveFieldCombatMeta(asString(descValue), skillEffectsData())
            if (meta.削韧) item["削韧"] = meta.削韧
            if (meta.Boss削韧 !== undefined) item["Boss削韧"] = meta.Boss削韧
            if (meta.isDamage) item["is_damage"] = true

            result.push(item)
        }
        return result
    }

    const skillNameVNode = (skillId: number): VNode => {
        const key = dm.getSkillNameKey(skillId)
        return T(key)
    }

    const artifacts: SkillArtifacts = {
        calcSkillDesc: (desc, level = 1) => dm.calcSkillDesc(desc, level),
        getSkillNameKey: skillId => dm.getSkillNameKey(skillId),
        getSkillMaxLevel: skillId => dm.getSkillMaxLevel(skillId),
        compileDesc: computed => compile(computed),
        skillNameVNode,
        damageTagCn,
        pMap: name => P_MAP[name] ?? name,
        explainSkillFields,
        resolveFieldCombatMeta,
        extractCreatures: (skillId, keepHidden = false) => {
            return extractCreaturesImpl(skillId, keepHidden, {
                skillData: skillData(),
                skillNodeData: skillNodeData(),
                skillEffectsData: skillEffectsData(),
                creatureData: (dm.getTable("SkillCreature") as Record<string, any>) || {},
            })
        },
        parseWeaponLikeSkillField: (descKey, descValue, tableId, skillEntry) => {
            return parseWeaponLikeSkillFieldImpl(descKey, descValue, tableId, skillEntry, {
                calcSkillDesc: (d, lvl = 1) => dm.calcSkillDesc(d, lvl),
                skillEffects: skillEffectsData(),
            })
        },
    }
    return artifacts
}

// ---------- 技能字段完整解析（对齐 weapon._process_weapon_skill_desc） ----------

function parseWeaponLikeSkillFieldImpl(
    descKey: string,
    descValue: string,
    tableId: number,
    skillEntry: Record<string, unknown>,
    deps: { calcSkillDesc: (d: string, lvl?: number) => string; skillEffects: Record<string, any> }
): Record<string, unknown> {
    const computed = deps.calcSkillDesc(descValue, 1)
    const [value, value2, format] = extractFieldValueAndFormat(computed)
    const item: Record<string, unknown> = { 名称: T(descKey), 值: value }
    if (value2 !== null) item["值2"] = value2
    if (format && format !== "{%}") item["格式"] = format

    const meta = resolveFieldCombatMetaImpl(descValue, deps.skillEffects)
    const isDamage = meta.isDamage
    if (meta.削韧) item["削韧"] = meta.削韧
    if (meta.Boss削韧 !== undefined) item["Boss削韧"] = meta.Boss削韧
    if (meta.延迟) item["延迟"] = meta.延迟
    if (meta.卡肉) item["卡肉"] = meta.卡肉
    if (isDamage && meta.tag) item["tag"] = meta.tag
    if (isDamage) (item as any).isDamage = true
    return item
}

// ---------- 实体提取（port skill_creature_utils） ----------

interface CreatureDeps {
    skillData: Record<string, any>
    skillNodeData: Record<string, any>
    skillEffectsData: Record<string, any>
    creatureData: Record<string, any>
}

function getEntry2(table: Record<string, any>, id: number | string): any {
    let e = table[String(id)]
    if (!e) e = table[id as number]
    return e
}

function unwrapSkillEntry(info: any): any {
    if (!Array.isArray(info) || info.length === 0) return null
    let entry = info[0]
    if (Array.isArray(entry)) entry = entry[0]
    if (entry && typeof entry === "object" && entry.BeginNodeId === undefined) entry = entry["0"] ?? entry[0]
    return entry && typeof entry === "object" ? entry : null
}

function simplifySkillCreature(creatureId: number | string, creatureData: any, keepHidden = false): any {
    if (!creatureData || typeof creatureData !== "object") return { id: creatureId }
    let skipTimeLife = false
    if (creatureData.TimeLife === -1) {
        if (keepHidden) skipTimeLife = true
        else return null
    }
    const result: Record<string, any> = { id: creatureId }
    const shape = creatureData.ShapeInfo
    if (shape && typeof shape === "object") {
        const simplified: Record<string, any> = {}
        if (shape.ShapeType) simplified["类型"] = shape.ShapeType
        for (const [k, v] of Object.entries(shape)) {
            if (k === "ShapeType") continue
            if (v === null || v === "") continue
            simplified[k] = v
        }
        if (Object.keys(simplified).length > 0) result["形状"] = simplified
    }
    for (const [sourceKey, targetKey] of [
        ["TimeLife", "时长"],
        ["Speed", "速度"],
        ["Tags", "标签"],
    ] as const) {
        if (skipTimeLife && sourceKey === "TimeLife") continue
        let value = creatureData[sourceKey]
        if (value === null || value === undefined || value === "" || (Array.isArray(value) && value.length === 0)) continue
        if (sourceKey === "Speed" && value === 0) continue
        if (sourceKey === "Tags" && Array.isArray(value)) {
            value = value.filter((item: string) => item !== "PauseInvisible")
            if (value.length === 0) continue
        }
        result[targetKey] = value
    }
    const vars = creatureData.Vars
    if (vars && typeof vars === "object" && Object.keys(vars).length > 0) result["Vars"] = vars
    const loopEffects = creatureData.LoopExecuteSkillEffects
    if (loopEffects && typeof loopEffects === "object") {
        const interval = loopEffects.Interval
        if (typeof interval === "number") result["特效循环间隔"] = interval
    }
    return result
}

function extractCreaturesImpl(skillId: number, keepHidden: boolean, deps: CreatureDeps): unknown[] {
    const { skillData, skillNodeData, skillEffectsData, creatureData } = deps
    const skillInfo = getEntry2(skillData, skillId)
    if (!Array.isArray(skillInfo) || skillInfo.length === 0) return []
    const skillEntry = unwrapSkillEntry(skillInfo)
    if (!skillEntry || typeof skillEntry !== "object") return []
    const rootSkillType = skillEntry.SkillType
    const beginNodeId = skillEntry.BeginNodeId
    if (!beginNodeId) return []

    const creatures: any[] = []
    const seenCreatureKeys = new Set<string>()
    const visitedNodes = new Set<number>()
    const visitedEffects = new Set<string>()
    const visitedSkills = new Set<string>()

    const collectFromEffect = (
        effectId: number | string,
        inheritedInterval?: number | null,
        sourceLoopShootId?: number | string | null
    ) => {
        const effectKey = String(effectId)
        const visitKey = `${effectKey}|${sourceLoopShootId}`
        if (visitedEffects.has(visitKey)) return
        visitedEffects.add(visitKey)

        const effect = getEntry2(skillEffectsData, effectId)
        if (!effect || typeof effect !== "object") return
        const taskEffects = effect.TaskEffects
        if (!Array.isArray(taskEffects)) return

        for (const taskEffect of taskEffects) {
            if (!taskEffect || typeof taskEffect !== "object") continue
            const fn = taskEffect.Function
            if (fn === "CreateSkillCreature") {
                const creatureId = taskEffect.CreatureId
                const creatureKey = `${creatureId}|${sourceLoopShootId}`
                if (creatureId === null || creatureId === undefined || creatureId === "" || seenCreatureKeys.has(creatureKey)) continue
                seenCreatureKeys.add(creatureKey)
                const creature = simplifySkillCreature(creatureId, getEntry2(creatureData, creatureId), keepHidden)
                if (creature && inheritedInterval !== undefined && inheritedInterval !== null) creature["射击间隔"] = inheritedInterval
                if (creature) creatures.push(creature)
                continue
            }
            let nextInterval: number | null | undefined = inheritedInterval
            let nextSourceLoopShootId = sourceLoopShootId
            if (fn === "StartLoopShoot") {
                const loopInterval = taskEffect.LoopInterval
                if (typeof loopInterval === "number") nextInterval = loopInterval
                const loopShootId = taskEffect.LoopShootId
                if (loopShootId !== null && loopShootId !== undefined && loopShootId !== "") nextSourceLoopShootId = loopShootId
            }
            if (fn === "Executeskilleffect") continue
            for (const childKey of ["SkillEffect", "EffectIds"] as const) {
                let childIds = taskEffect[childKey]
                if (!Array.isArray(childIds)) childIds = childIds === undefined ? [] : [childIds]
                for (const childId of childIds) {
                    if (childId === null || childId === undefined || childId === "") continue
                    collectFromEffect(childId, nextInterval, nextSourceLoopShootId)
                }
            }
        }
    }

    const collectFromSkill = (
        innerSkillId: number | string,
        inheritedInterval?: number | null,
        sourceLoopShootId?: number | string | null
    ) => {
        const skillKey = String(innerSkillId)
        const visitKey = `${skillKey}|${sourceLoopShootId}`
        if (visitedSkills.has(visitKey)) return
        visitedSkills.add(visitKey)

        const innerInfo = getEntry2(skillData, innerSkillId)
        if (!Array.isArray(innerInfo) || innerInfo.length === 0) return
        const innerEntry = unwrapSkillEntry(innerInfo)
        if (!innerEntry || typeof innerEntry !== "object") return
        const innerBegin = innerEntry.BeginNodeId
        if (!innerBegin) return

        let current = innerBegin
        let steps = 0
        while (current && !visitedNodes.has(current) && steps < 8) {
            visitedNodes.add(current)
            steps++
            const node = getEntry2(skillNodeData, current)
            if (!node || typeof node !== "object") break
            let effectIds = node.SkillNodeEffects
            if (!Array.isArray(effectIds)) effectIds = effectIds === undefined ? [] : [effectIds]
            for (const eid of effectIds) collectFromEffect(eid, inheritedInterval, sourceLoopShootId)
            current = node.NextNodeId
        }
    }

    collectFromSkill(skillId, null, skillId)

    // 主技能的 SubSkills 也属于同一条技能链（例如 Skill2 的实体在子技能节点中创建）。
    const rootEntry = getEntry2(skillData, skillId)
    if (Array.isArray(rootEntry) && rootEntry.length > 0) {
        const rootSkillEntry = unwrapSkillEntry(rootEntry)
        if (rootSkillEntry && typeof rootSkillEntry === "object") {
            const subSkills = rootSkillEntry.SubSkills
            if (Array.isArray(subSkills)) {
                for (const subSkillId of subSkills) {
                    if (subSkillId !== null && subSkillId !== undefined && String(subSkillId) !== String(skillId)) {
                        collectFromSkill(subSkillId, null, skillId)
                    }
                }
            }
        }
    }

    // Skill2 的关联技能（ClientSkillLogicId 反向）
    if (rootSkillType === "Skill2") {
        for (const [relatedSkillId, relatedEntries] of Object.entries(skillData)) {
            if (String(relatedSkillId) === String(skillId)) continue
            if (!Array.isArray(relatedEntries) || relatedEntries.length === 0) continue
            const relatedEntry = unwrapSkillEntry(relatedEntries)
            if (!relatedEntry || typeof relatedEntry !== "object") continue
            if (relatedEntry.ClientSkillLogicId !== skillId) continue
            collectFromSkill(relatedSkillId, null, skillId)
        }
        // Skill2 的 StartLoopShoot 效果
        for (const [effectIdStr, effect] of Object.entries(skillEffectsData)) {
            if (!effect || typeof effect !== "object") continue
            const taskEffects = effect.TaskEffects
            if (!Array.isArray(taskEffects)) continue
            for (const taskEffect of taskEffects) {
                if (!taskEffect || typeof taskEffect !== "object") continue
                if (taskEffect.Function !== "StartLoopShoot") continue
                if (taskEffect.LoopShootId !== skillId) continue
                const loopInterval = typeof taskEffect.LoopInterval === "number" ? taskEffect.LoopInterval : null
                let childIds = taskEffect.SkillEffect
                if (!Array.isArray(childIds)) childIds = childIds === undefined ? [] : [childIds]
                for (const childId of childIds) {
                    if (childId === null || childId === undefined || childId === "") continue
                    collectFromEffect(childId, loopInterval, skillId)
                }
            }
        }
    }
    return creatures
}

/** 从 SkillEffects 解析字段的削韧/Boss削韧/tag/延迟/卡肉（独立实现，供多处共用） */
export function resolveFieldCombatMetaImpl(
    descValue: string,
    skillEffects: Record<string, any>
): { isDamage: boolean; 削韧?: number; Boss削韧?: number; tag?: string[]; 延迟?: number; 卡肉?: number } {
    const { effectIds } = extractReferencedIds(descValue)
    if (effectIds.length === 0) return { isDamage: false }
    const result: { isDamage: boolean; 削韧?: number; Boss削韧?: number; tag?: string[]; 延迟?: number; 卡肉?: number } = {
        isDamage: false,
    }

    for (const eid of effectIds) {
        const effect = getEntry2(skillEffects, eid)
        if (!effect) continue
        for (const task of effect.TaskEffects ?? []) {
            const func = task.Function
            if (func === "Damage") {
                result.isDamage = true
                // DamageTask 的 DamageTag（port weapon._parse_skill_effects）
                for (const tag of task.DamageTag ?? []) {
                    const tagCn = DAMAGE_TAG_CN[tag] ?? tag
                    if (tagCn && !(result.tag ?? []).includes(tagCn)) {
                        ;(result.tag ??= []).push(tagCn)
                    }
                }
            }
            if (func === "CutToughness") {
                result.isDamage = true
                const value = asNumber(task.Value)
                if (value !== null) {
                    const prev = asNumber(result.削韧) ?? 0
                    if (result.削韧 === undefined || value > prev) {
                        result.削韧 = value
                        const boss = asNumber(task.BossValue)
                        if (boss !== null && boss !== value) result.Boss削韧 = boss
                        else delete result.Boss削韧
                    }
                }
            }
            if (func === "HitStop") {
                const delay = asNumber(task.Delay)
                if (delay !== null) result.延迟 = delay
                const duration = asNumber(task.Duration)
                if (duration !== null) result.卡肉 = duration
            }
        }
    }
    return result
}

function asArray(v: unknown): unknown[] {
    if (Array.isArray(v)) return v
    return []
}
