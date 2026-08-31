/**
 * charModule — 输出 Char.json。
 *
 * 对齐老 processor/char_processor.py 的核心输出路径：
 * - 基础信息（id/icon/名称/版本/别名/出生地/势力/生日/CV/阵营/属性/精通/标签）
 * - 基础属性（攻击/生命/防御/护盾/神智）、加成、突破、溯源、碎片、第七溯源消耗、专武
 * - 技能（名称/类型/描述/字段/升级/实体/术语解释/子技能/行为）
 *
 * 翻译部分一律 vnode；数值/结构普通 JS。语言无关，一次 build 多语言渲染。
 * 技能字段/值计算走游戏 SkillUtils（skill 模块 artifacts）。
 */
import { readFileSync } from "node:fs"
import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import { compile, LTemplate, record, seq, T, TFixed, type VNode, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
import type { SkillArtifacts } from "../skill/skillModule.ts"
import {
    ACTION_CN,
    BASE_ATTR_CN,
    DAMAGE_TAG_CN,
    DAMAGE_TYPE_CN,
    extractFieldValueAndFormatFromSource,
    P_MAP,
    roundValue,
} from "../skill/skillModule.ts"

/** 阵营：Camp 表 */
/** 属性缩写 */
const _CAMP_NAME_OVERRIDES: Record<string, string> = {}
const ATTR_NAME_MAP: Record<string, string> = {
    武器暴击率: "暴击",
    武器多重射击: "多重",
}

/** 武器类型标签 → 中文（对齐老 BaseProcessor.process_tags） */
const WEAPON_TYPE_CN: Record<string, string> = {
    Ultra: "同律",
    Melee: "近战",
    Ranged: "远程",
    Bow: "WeaponType_Bow",
    Bow01: "WeaponType_Bow01",
    Bow02: "WeaponType_Bow02",
    Cannon: "WeaponType_Cannon",
    Claymore: "WeaponType_Claymore",
    Crossbow: "WeaponType_Crossbow",
    Dualblade: "WeaponType_Dualblade",
    Katana: "WeaponType_Katana",
    Machinegun: "WeaponType_Machinegun",
    Pistol: "WeaponType_Pistol",
    Polearm: "WeaponType_Polearm",
    Shotgun: "WeaponType_Shotgun",
    Sword: "WeaponType_Sword",
    Swordwhip: "WeaponType_Swordwhip",
}
/** WeaponType_* 是翻译 key（非直接中文） */
const WEAPON_TYPE_DIRECT = new Set(["同律", "近战", "远程"])
const BP_ADD_BUFF_CACHE = new Map<string, Record<string, number[]>>()

export async function charModule(ctx: ModuleContext) {
    const dm = ctx.dm
    const skillArtifacts = ctx.getArtifact<SkillArtifacts>("skill")!
    // Char 的旧导出基于 FModel JSON；优先读取同一份 JSON，避免 UAsset 解析的时间线舍入差异。
    const assetReader = new AssetReader(dm.root)
    await assetReader.ensureServer()

    // 原始表
    const charData = () => (dm.getTable("Char") as Record<string, any>) || {}
    const battleCharData = () => (dm.getTable("BattleChar") as Record<string, any>) || {}
    const characterData = () => (dm.getTable("CharacterData") as Record<string, any>) || {}
    const campData = () => (dm.getTable("CharCamp") as Record<string, any>) || {}
    const weaponTagData = () => (dm.getTable("WeaponTag") as Record<string, any>) || {}
    const charAddonAttrData = () => (dm.getTable("CharAddonAttr") as Record<string, any>) || {}
    const charBreakData = () => (dm.getTable("CharBreak") as Record<string, any>) || {}
    const levelUpData = () => (dm.getTable("LevelUp") as Record<string, any>) || {}
    const attrConfig = () => (dm.getTable("AttrConfig") as Record<string, any>) || {}
    const charCardLevelUp = () => (dm.getTable("CharCardLevelUp") as Record<string, any>) || {}
    const ultraCharCardLevelUp = () => (dm.getTable("UltraCharCardLevelUp") as Record<string, any>) || {}
    const ultraPassiveMap = () => (dm.getTable("CharId2UltraPassiveSkillId") as Record<string, any>) || {}
    const skillLevelUp = () => (dm.getTable("SkillLevelUp") as Record<string, any>) || {}
    const combatTerm = () => (dm.getTable("CombatTerm") as Record<string, any>) || {}
    const weaponData = () => (dm.getTable("Weapon") as Record<string, any>) || {}
    const battleWeaponData = () => (dm.getTable("BattleWeapon") as Record<string, any>) || {}
    const uWeaponData = () => (dm.getTable("UWeapon") as Record<string, any>) || {}
    const abyssSeasonList = () => (dm.getTable("AbyssSeasonList") as Record<string, any>) || {}
    const shopItemData = () => (dm.getTable("ShopItem") as Record<string, any>) || {}
    const shopItem2ShopSubId = () => (dm.getTable("ShopItem2ShopSubId") as Record<string, any>) || {}
    const walnutData = () => (dm.getTable("Walnut") as Record<string, any>) || {}
    const draftData = () => (dm.getTable("Draft") as Record<string, any>) || {}

    function processAbyssSpecialWeapon(charId: number): number | undefined {
        const abyssShop = shopItem2ShopSubId().Walnut?.AbyssShop
        if (!abyssShop || typeof abyssShop !== "object") return undefined
        const shopItemIds = new Set<number>()
        for (const entries of Object.values(abyssShop)) {
            if (!Array.isArray(entries)) continue
            for (const entry of entries) {
                const id = Number(entry?.ShopItemId)
                if (Number.isFinite(id) && id) shopItemIds.add(id)
            }
        }
        if (shopItemIds.size === 0) return undefined

        for (const season of Object.values(abyssSeasonList())) {
            if (!season || Number(season.CharId) !== Number(charId)) continue
            const start = Number(season.AbyssStartTime)
            const end = Number(season.AbyssEndTime)
            if (!Number.isFinite(start) || !Number.isFinite(end)) continue
            const walnutIds = new Set<number>()
            for (const shopItem of Object.values(shopItemData())) {
                if (shopItem?.ItemType !== "Walnut" || !shopItemIds.has(Number(shopItem.ItemId))) continue
                const shopStart = Number(shopItem.StartTime)
                const shopEnd = shopItem.EndTime === undefined || shopItem.EndTime === null ? undefined : Number(shopItem.EndTime)
                if (!Number.isFinite(shopStart) || shopStart >= end) continue
                if (shopEnd !== undefined && Number.isFinite(shopEnd) && shopEnd <= start) continue
                const typeId = Number(shopItem.TypeId)
                if (Number.isFinite(typeId)) walnutIds.add(typeId)
            }
            if (walnutIds.size !== 1) continue
            const walnut = getEntry(walnutData(), [...walnutIds][0])
            const draftId = Array.isArray(walnut?.Id) ? walnut.Id[0] : undefined
            const weaponId = Number(walnut?.MainRewardId)
            if (!draftId || !Number.isFinite(weaponId)) continue
            const draft = getEntry(draftData(), draftId)
            if (draft?.ProductType !== "Weapon" || Number(draft.ProductId) !== weaponId) continue
            if (!getEntry(weaponData(), weaponId)) continue
            return weaponId
        }
        return undefined
    }

    const getEntry = (table: Record<string, any>, id: number | string): any => table[String(id)] ?? table[id as number]

    // ---------- 基础 ----------

    function processRelease(v: unknown): string {
        const release = Number(v) || 0
        if (!release) return "1.0"
        return `${Math.floor(release / 100)}.${Math.floor((release % 100) / 10)}`
    }

    function formatBirthday(v: unknown): string {
        if (v === null || v === undefined || v === "") return ""
        const days = Number(v)
        if (Number.isNaN(days)) return String(v)
        const base = Date.UTC(1899, 11, 30) // 1899-12-30
        const d = new Date(base + days * 86400000)
        const mm = String(d.getUTCMonth() + 1).padStart(2, "0")
        const dd = String(d.getUTCDate()).padStart(2, "0")
        return `${mm}-${dd}`
    }

    function processElement(charId: number): string {
        if (!charId) return ""
        const elmId = Math.floor(charId / 1000)
        const map: Record<number, string> = { 2: "水", 3: "火", 4: "雷", 5: "风" }
        if (elmId in map) return map[elmId]
        return charId < 1500 ? "暗" : "光"
    }

    function processCamp(camp: string): VNode {
        if (!camp) return ""
        const row = campData()[camp]
        const nameKey = row?.CampName
        return T(nameKey ?? "")
    }

    function processMastery(weaponTags: unknown): VNodeTree {
        if (!Array.isArray(weaponTags) || weaponTags.length === 0) return []
        return weaponTags.map(tag => {
            const row = weaponTagData()[String(tag)]
            return T(row?.WeaponTagTextmap ?? "")
        })
    }

    function processTags(tags: unknown): VNodeTree {
        if (!Array.isArray(tags)) return []
        const out: VNodeTree[] = []
        const positioning = dm.getTable("Positioning") as Record<string, any> | undefined
        for (const tag of tags) {
            const row = positioning?.[String(tag)]
            if (row?.Name) out.push(T(row.Name))
        }
        return out
    }

    /** 武器类型标签（UWeapon 的 WeaponTag：Ultra/Melee/Sword 等） */
    function processWeaponTags(tags: unknown): VNodeTree {
        if (!Array.isArray(tags)) return []
        const out: VNodeTree[] = []
        for (const tag of tags) {
            const mapped = WEAPON_TYPE_CN[String(tag)]
            if (mapped && WEAPON_TYPE_DIRECT.has(mapped)) {
                out.push(mapped)
            } else if (mapped) {
                out.push(T(mapped)) // WeaponType_* 是翻译 key
            } else {
                const positioning = dm.getTable("Positioning") as Record<string, any> | undefined
                const row = positioning?.[String(tag)]
                if (row?.Name) out.push(T(row.Name))
            }
        }
        return out
    }

    /** 基础属性（Lv.1） */
    function processAttributes(battleChar: Record<string, any>): Record<string, unknown> {
        const out: Record<string, unknown> = {}
        let baseAtk = battleChar.ATK ?? 0
        const atkGrow = battleChar.ATKLevelGrow ?? ""
        const attribute = battleChar.Attribute ?? ""
        if (attribute && battleChar[`ATK_${attribute}`] !== undefined) {
            baseAtk += battleChar[`ATK_${attribute}`]
        }
        // Lv.1 成长因子
        const level1 = levelUpData().find((item: any) => item.Level === 1)
        if (baseAtk && atkGrow && level1) {
            let factor = level1[atkGrow] ?? 1
            if (typeof factor === "string") factor = Number(factor) || 1
            out.攻击 = Math.floor(baseAtk * factor)
        }
        for (const attrName of ["MaxHp", "DEF", "MaxES"]) {
            const base = battleChar[attrName]
            const grow = battleChar[`${attrName}LevelGrow`]
            if (base && grow && level1) {
                let factor = level1[grow] ?? 1
                if (typeof factor === "string") factor = Number(factor) || 1
                const value = base * factor
                // AttrConfig 名称
                const key = attrConfig()[attrName] ? attrName : `${attrName}_Normal`
                const cfg = attrConfig()[key] ?? {}
                const name = ctx.textmap.get(cfg.Name ?? "", "cn") || attrName
                out[name] = Math.floor(value)
            }
        }
        const maxSp = battleChar.MaxSp
        if (maxSp) out.神智 = Math.floor(maxSp)
        return out
    }

    /** 加成 */
    function processAddon(_charId: number, battleChar: Record<string, any>): Record<string, unknown> {
        const out: Record<string, unknown> = {}
        const addonAttrs = battleChar.CharAddonAttr ?? []
        if (!Array.isArray(addonAttrs)) return out
        for (const attrId of addonAttrs) {
            const row = charAddonAttrData()[String(attrId)]
            const attr = row?.AddAttrs
            if (!attr?.AttrName) continue
            const key = attrConfig()[attr.AttrName] ? attr.AttrName : `${attr.AttrName}_Normal`
            const cfg = attrConfig()[key] ?? {}
            const nameKey = cfg.Name ?? ""
            let fkey = ctx.textmap.get(nameKey, "cn")
            fkey = ATTR_NAME_MAP[fkey] ?? fkey
            const value = roundValue(attr.Rate ?? attr.Value ?? 0)
            if (out[fkey]) out[fkey] = (out[fkey] as number) + value
            else out[fkey] = value
        }
        return out
    }

    /** 突破材料 */
    function processBreak(charId: number): VNodeTree {
        const breakList = charBreakData()[String(charId)] ?? charBreakData()[charId]
        if (!Array.isArray(breakList)) return []
        const out: VNodeTree[] = []
        for (const stage of breakList) {
            const itemIds = stage.ItemId ?? []
            const itemNums = stage.ItemNum ?? []
            const entries: Array<[VNode, VNode]> = []
            for (let i = 0; i < itemIds.length; i++) {
                if (i >= itemNums.length) continue
                const rid = itemIds[i]
                const nameKey = resourceNameKey(dm, rid)
                entries.push([nameKey ? T(nameKey) : String(rid), itemNums[i]])
            }
            out.push(record(entries))
        }
        return out
    }

    /** 溯源 */
    function processTraces(battleChar: Record<string, any>, charId: number): VNodeTree[] {
        let gradeDescKeys = battleChar.CharGradeDescription
        if (!Array.isArray(gradeDescKeys) || gradeDescKeys.length === 0) {
            gradeDescKeys = [1, 2, 3, 4, 5, 6].map(n => `GRADEUP_${charId}_0${n}`)
        }
        const gradeParams = battleChar.CharGradeParameter ?? []
        const traces: VNode[] = []
        for (const key of gradeDescKeys) {
            const k = String(key)
            const paramValues: VNode[] = []
            for (const p of gradeParams) {
                if (typeof p === "number") paramValues.push(formatTraceValue(String(p)))
                else if (typeof p === "string") {
                    const computed = skillArtifacts.calcSkillDesc(p, 1)
                    paramValues.push(formatTraceValue(computed))
                } else if (p !== null && p !== undefined) paramValues.push(String(p))
            }
            traces.push(LTemplate(k, paramValues))
        }
        const ultraPassiveId = ultraPassiveMap()[String(charId)] ?? ultraPassiveMap()[charId]
        if (ultraPassiveId !== undefined && ultraPassiveId !== null) {
            const ultraEntry = getSkillEntry(dm, Number(ultraPassiveId))
            if (ultraEntry?.SkillDesc) {
                const values = normalizeMapOrArray(ultraEntry.SkillDescValues).map(value => {
                    if (typeof value === "number") return formatTraceValue(value)
                    if (typeof value === "string") return formatTraceValue(skillArtifacts.calcSkillDesc(value, 1))
                    return String(value ?? "")
                })
                traces.push(LTemplate(String(ultraEntry.SkillDesc), values))
            }
        }
        return traces
    }

    /** 碎片 */
    function processTracePieceId(charId: number): number {
        const levels = charCardLevelUp()[String(charId)]
        const rows = asEntryList(levels)
        for (const lv of rows) {
            const rid = lv?.ResourceId1
            if (rid === null || rid === undefined || rid === 0 || rid === "") continue
            const n = Number(rid)
            if (!Number.isNaN(n)) return n
        }
        return 0
    }

    /** 第七溯源消耗 */
    function processSeventhTraceCost(charId: number): Array<[number, unknown]> {
        const lv = ultraCharCardLevelUp()[String(charId)]
        if (!lv || typeof lv !== "object") return []
        const cost: Array<[number, unknown]> = []
        for (let i = 1; i <= 9; i++) {
            const rid = lv[`ResourceId${i}`]
            const amount = lv[`ResourceNum${i}`]
            if (rid === null || rid === undefined || rid === 0 || rid === "") continue
            if (amount === null || amount === undefined || amount === 0 || amount === "") continue
            const n = Number(rid)
            if (!Number.isNaN(n)) cost.push([n, amount])
        }
        return cost
    }

    // ---------- 技能 ----------

    /** 单个技能 */
    async function processSingleSkill(
        skillId: number,
        inheritedDescValues?: unknown[],
        inheritedCreatures?: unknown[]
    ): Promise<Record<string, unknown> | null> {
        const skillInfo = getSkillEntry(dm, skillId)
        if (!skillInfo) return null

        const result: Record<string, unknown> = { id: skillId }
        if (skillInfo.SkillName) result.名称 = T(skillInfo.SkillName)
        result.类型 = T(skillInfo.SkillBtnDesc ?? "")
        // 描述：TextMap 模板 + #N 值替换
        const descKey = skillInfo.SkillDesc
        if (descKey) {
            const descValues = skillInfo.SkillDescValues ?? []
            const values: VNode[] = []
            for (const dv of descValues) {
                if (typeof dv === "string") values.push(compile(skillArtifacts.calcSkillDesc(dv, 1)))
            }
            result.描述 = LTemplate(String(descKey), values, true)
        }
        result.icon = extractIconName(skillInfo.SkillBtnIcon)
        if (skillInfo.CD !== undefined && skillInfo.CD !== null) result.cd = skillInfo.CD

        // 实体
        const creatures = skillArtifacts.extractCreatures(skillId)
        if (creatures && creatures.length > 0) result.实体 = creatures
        if (inheritedCreatures && skillInfo.SkillType === "Skill2") {
            const merged = Array.isArray(result.实体) ? [...(result.实体 as unknown[])] : []
            for (const creature of inheritedCreatures) {
                if (!merged.some(item => JSON.stringify(item) === JSON.stringify(creature))) merged.push(creature)
            }
            if (merged.length > 0) result.实体 = merged
        }

        const behavior = generateSkillBehavior(dm, skillArtifacts, skillId, inheritedDescValues, ctx.textmap)

        const subSkills = Array.isArray(skillInfo.SubSkills) ? skillInfo.SubSkills : []
        const explanationNames = Array.isArray(skillInfo.ExplanationId)
            ? skillInfo.ExplanationId.map((termId: unknown) => {
                  const term = combatTerm()[String(termId)]
                  return term?.CombatTerm ? T(term.CombatTerm) : ""
              })
            : []
        const childSkills = (
            await Promise.all(
                subSkills
                    .filter((subSkillId: unknown) => String(subSkillId) !== String(skillId))
                    .map((subSkillId: unknown, index: number) =>
                        processChildSkill(Number(subSkillId), explanationNames[index], skillInfo.SkillDescValues)
                    )
            )
        ).filter((child): child is Record<string, unknown> => {
            if (!child) return false
            return Object.entries(child).some(([key, value]) => {
                if (key === "id" || key === "子技能" || key === "行为" || key === "__childNameAppended") return false
                return Boolean(value) && JSON.stringify(value) !== JSON.stringify(result[key])
            })
        })
        // 字段
        const maxLevel = Math.min(skillInfoLevels(dm, skillId), 12)
        const fields = await processSkillDesc(skillInfo, skillId, maxLevel)
        if (fields.length > 0) result.字段 = fields

        // 升级材料
        const upgrades = processSkillLevelUp(skillId)
        if (upgrades.length > 0) result.升级 = upgrades

        // 术语解释
        const terms = processTerms(skillInfo)
        if (terms && typeof terms === "object" && !Array.isArray(terms) && (terms as any).__t === "rec") {
            result.术语解释 = terms
        } else if (Array.isArray(terms) && terms.length > 0) {
            result.术语解释 = terms
        }

        if (childSkills.length > 0) result.子技能 = childSkills

        if (behavior) result.行为 = behavior

        return result
    }

    async function processChildSkill(
        skillId: number,
        explanationName?: VNode,
        inheritedDescValues?: unknown[]
    ): Promise<Record<string, unknown> | null> {
        const child = await processSingleSkill(skillId, inheritedDescValues)
        if (child && explanationName) {
            const info = getSkillEntry(dm, skillId)
            child.名称 = explanationName
            if (!info?.SkillName) child.__childNameAppended = true
        }
        return child
    }

    /** 技能字段（char 风格：影响/值数组/值2/格式/tag/削韧/取消/连段） */
    async function processSkillDesc(skillInfo: Record<string, any>, _skillId: number, maxLevel: number): Promise<any[]> {
        const descKeys = normalizeMapOrArray(skillInfo.SkillDescKeys)
        const descValues = normalizeMapOrArray(skillInfo.SkillDescValues)
        if (descKeys.length === 0 || descValues.length === 0) return []
        const descHints = normalizeMapOrArray(skillInfo.SkillDescHints)

        const out: any[] = []
        for (let i = 0; i < descKeys.length; i++) {
            const descKey = descKeys[i]
            const descValue = descValues[i]
            if (descKey === null || descKey === undefined || descValue === null || descValue === undefined) continue
            // 与旧处理器一致：没有数值引用（#...）的纯文本/常量项不作为字段输出。
            if (typeof descValue !== "string" || !descValue.includes("#")) continue

            const groupName = skillSectionName(skillInfo.SkillDescGroups, i)
            const descTextCn = ctx.textmap.get(String(descKey), "cn")
            const item: Record<string, any> = {
                名称: groupName && !descTextCn.startsWith("[") ? seq(["[", T(groupName), "]", T(String(descKey))]) : T(String(descKey)),
                __descIndex: i,
            }

            // 影响（SkillDescHints → 技能效益/技能威力/技能范围/技能耐久）
            const hints = Array.isArray(descHints) ? descHints[i] : undefined
            if (Array.isArray(hints) && hints.length > 0) {
                const impact = hints.map((h: string) => HINT_MAP[h] ?? h).join(",")
                item.影响 = impact
            }

            // 逐级计算值（1..maxLevel）
            const values: number[] = []
            const values2: number[] = []
            let hasValue2 = false
            const computedFirst = skillArtifacts.calcSkillDesc(String(descValue), 1)
            for (let lv = 1; lv <= maxLevel; lv++) {
                const computed = lv === 1 ? computedFirst : skillArtifacts.calcSkillDesc(String(descValue), lv)
                const [v, v2] = extractFieldValueAndFormatFromSource(String(descValue), computed)
                values.push(typeof v === "number" ? v : Number(v) || 0)
                if (v2 !== null) {
                    hasValue2 = true
                    values2.push(typeof v2 === "number" ? v2 : Number(v2) || 0)
                } else if (hasValue2) {
                    values2.push(0)
                }
            }
            const [, firstValue2, format] = extractFieldValueAndFormatFromSource(String(descValue), computedFirst)
            const isConstant = values.every(v => Math.abs(v - values[0]) < 0.0001)
            item.值 = isConstant ? values[0] : values.map(v => roundValue(v))
            if (firstValue2 !== null && values2.length > 0) {
                const isConstant2 = values2.every(v => Math.abs(v - values2[0]) < 0.0001)
                item.值2 = isConstant2 ? values2[0] : values2.map(v => roundValue(v))
            }
            if (format && format !== "{%}") item.格式 = compile(format)

            // 削韧/Boss削韧/tag（char 不含 HitStop 的延迟/卡肉——那是 weapon 专属，
            // 对齐老代码 char._resolve_field_combat_meta 只解析削韧/Boss削韧）
            const meta = skillArtifacts.resolveFieldCombatMeta(String(descValue), skillEffectsTable(dm))
            if (meta.isDamage && meta.tag) item.tag = meta.tag
            if (meta.削韧) item.削韧 = meta.削韧
            if (meta.Boss削韧 !== undefined) item.Boss削韧 = meta.Boss削韧
            if (meta.isDamage) (item as any).__isDamage = true

            out.push(item)
        }
        await applySkillTiming(skillInfo, out)
        return out
    }

    /** 对齐旧 Python：字段直接引用的 SkillNode 优先，随后按 SkillDescGroups 的段落节点补全。 */
    async function applySkillTiming(skillInfo: Record<string, any>, fields: Array<Record<string, any>>): Promise<void> {
        if (fields.length === 0) return
        const nodeData = (dm.getTable("SkillNode") as Record<string, any>) || {}
        const getNode = (id: unknown): Record<string, any> | null => {
            const node = nodeData[String(id)] ?? nodeData[id as number]
            return node && typeof node === "object" ? node : null
        }
        const timing = async (beginNodeId: unknown): Promise<{ cancel: number; combo: number }> => {
            const node = getNode(beginNodeId)
            if (!node) return { cancel: 0, combo: 0 }
            const meta = await assetReader.animMetaForNode(node)
            return { cancel: meta.cancel, combo: meta.combo }
        }
        const groupTiming = new Map<number, { cancel: number; combo: number }>()
        const mainTiming = await timing(skillInfo.BeginNodeId)
        groupTiming.set(0, mainTiming)
        const subSkills = Array.isArray(skillInfo.SubSkills) ? skillInfo.SubSkills : []
        for (let i = 1; i < fields.length + 1; i++) {
            const subId = subSkills[i - 1]
            if (subId === undefined) continue
            const sub = getSkillEntry(dm, Number(subId))
            if (sub) groupTiming.set(i, await timing(sub.BeginNodeId))
        }
        for (let i = 0; i < fields.length; i++) {
            const field = fields[i]
            const descIndex = Number(field.__descIndex)
            delete field.__descIndex
            if (!field.__isDamage) continue
            const descValue = String(normalizeMapOrArray(skillInfo.SkillDescValues)[descIndex] ?? "")
            let resolved = { cancel: 0, combo: 0 }
            for (const match of descValue.matchAll(/\$#SkillNode\[(\d+)\]/g)) {
                const direct = await timing(Number(match[1]))
                if (direct.cancel || direct.combo) {
                    resolved = direct
                    break
                }
            }
            if (!resolved.cancel && !resolved.combo) {
                const group = skillSectionIndex(skillInfo.SkillDescGroups, descIndex)
                if (group !== undefined) resolved = groupTiming.get(group) ?? resolved
            }
            if (resolved.cancel) field.取消 = roundValue(resolved.cancel)
            if (resolved.combo) field.连段 = roundValue(resolved.combo)
            delete field.__isDamage
        }
    }

    /** 技能升级材料 */
    function processSkillLevelUp(skillId: number): VNodeTree[] {
        const rows = skillLevelUp()[String(skillId)] ?? skillLevelUp()[skillId]
        if (!Array.isArray(rows)) return []
        const out: VNodeTree[] = []
        for (const row of rows) {
            const itemIds = row.ItemId ?? []
            const itemNums = row.ItemNum ?? []
            const entries: Array<[VNode, VNode]> = []
            for (let i = 0; i < itemIds.length; i++) {
                if (i >= itemNums.length) continue
                const rid = itemIds[i]
                const nameKey = resourceNameKey(dm, rid)
                entries.push([nameKey ? T(nameKey) : String(rid), itemNums[i]])
            }
            if (entries.length > 0) out.push(record(entries))
        }
        return out
    }

    /** 术语解释：{术语名: 描述}，键值都可翻译 */
    function processTerms(skillInfo: Record<string, any>): VNodeTree {
        const explanationIds = skillInfo.ExplanationId ?? []
        if (!Array.isArray(explanationIds) || explanationIds.length === 0) return {}
        const entries: Array<[VNode, VNode]> = []
        for (const termId of explanationIds) {
            const row = combatTerm()[String(termId)]
            if (!row) continue
            const termKey = row.CombatTerm
            const explainKey = row.CombatTermExplaination
            if (!termKey || !explainKey) continue
            entries.push([T(termKey), LTemplate(String(explainKey), [])])
        }
        return entries.length > 0 ? record(entries) : {}
    }

    // ---------- 专武 / 同律武器 ----------

    function processUWeapon(uWeapon: unknown): VNodeTree | null {
        if (!Array.isArray(uWeapon) || uWeapon.length === 0) return null
        const out: VNodeTree[] = []
        for (const weaponId of uWeapon) {
            const weapon = uWeaponData()[String(weaponId)] ?? uWeaponData()[weaponId]
            const battleWeapon = battleWeaponData()[String(weaponId)] ?? battleWeaponData()[weaponId]
            if (!weapon) continue
            const tags = battleWeapon?.WeaponTag ?? []
            if (Array.isArray(tags) && tags.includes("Abstract")) continue
            const icon = String(weapon.Icon ?? "").includes("T_Head_") ? (String(weapon.Icon).split("T_Head_")[1]?.split(".")[0] ?? "") : ""
            const item: Record<string, VNodeTree> = {
                id: weaponId,
                名称: T(weapon.WeaponName ?? ""),
                类型: processWeaponTags(tags),
                icon,
            }
            for (const attrName of ["Spike", "Smash", "Slash"]) {
                const attrKey = `ATK_${attrName}`
                if (battleWeapon?.[attrKey] !== undefined) {
                    const cfg = attrConfig()[attrKey] ?? {}
                    const atkType = ctx.textmap.get(cfg.Name ?? "", "cn")
                    if (atkType) {
                        item.伤害类型 = atkType.slice(0, 2)
                        item[atkType.slice(2)] = battleWeapon[attrKey]
                    }
                }
            }
            if ((battleWeapon?.CRI ?? 0) > 0) item.暴击 = battleWeapon.CRI
            if ((battleWeapon?.CRD ?? 0) > 0) item.暴伤 = battleWeapon.CRD
            if ((battleWeapon?.TriggerProbability ?? 0) > 0) item.触发 = battleWeapon.TriggerProbability
            out.push(item)
        }
        return out
    }

    // ---------- 主输出 ----------
    function collectAbstractUWeaponCreatures(uWeapon: unknown): unknown[] {
        if (!Array.isArray(uWeapon)) return []
        const out: unknown[] = []
        for (const weaponId of uWeapon) {
            const battleWeapon = battleWeaponData()[String(weaponId)] ?? battleWeaponData()[weaponId]
            const tags = Array.isArray(battleWeapon?.WeaponTag) ? battleWeapon.WeaponTag : []
            if (!tags.includes("Abstract")) continue
            for (const creature of skillArtifacts.extractCreatures(Number(weaponId))) {
                if (!out.some(item => JSON.stringify(item) === JSON.stringify(creature))) out.push(creature)
            }
        }
        return out
    }

    const items: any[] = []
    const chars = charData()
    for (const [idStr, char] of Object.entries(chars)) {
        if (!char || typeof char !== "object") continue
        const charId = char.CharId ?? Number(idStr)
        if (charId > 100000) continue
        const battleChar = battleCharData()[String(charId)] ?? battleCharData()[charId]
        if (!battleChar) continue

        const baseAttr = processAttributes(battleChar)
        const elm = processElement(charId)
        const cdata = characterData()[String(charId)] ?? {}
        let name: VNode = T(char.CharName ?? "")
        const translatedName = ctx.textmap.get(String(char.CharName ?? ""), "cn")
        if (translatedName === "{nickname}" || translatedName === "{nickname2}") {
            name = seq([`主角-${elm}`])
        }

        const processed: Record<string, any> = {
            id: charId,
            icon: String(char.Icon ?? "").replace("/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_", ""),
            名称: name,
            版本: processRelease(char.ReleaseVersion),
            别名: T(char.CharSubtitle ?? ""),
            出生地: T(cdata.CharBirth ?? ""),
            势力: T(cdata.CharForce ?? ""),
            生日: formatBirthday(cdata.CharBirthday),
            中文CV: TFixed(cdata.CvCNName ?? "", "cn"),
            日文CV: TFixed(cdata.CvJPName ?? "", "jp"),
            英文CV: TFixed(cdata.CvENName ?? "", "en"),
            韩文CV: TFixed(cdata.CvKRName ?? "", "kr"),
            阵营: processCamp(char.Camp ?? "None"),
            属性: elm,
            精通: processMastery(battleChar.ExcelWeaponTags),
            标签: processTags(battleChar.Positioning),
            基础攻击: baseAttr.攻击 ?? 0,
            基础生命: baseAttr.生命 ?? 0,
            基础防御: baseAttr.防御 ?? 0,
            基础护盾: baseAttr.护盾 ?? 0,
            基础神智: baseAttr.神智 ?? 0,
            加成: processAddon(charId, battleChar),
            突破: processBreak(charId),
        }

        // 技能
        const ultraPassiveId = ultraPassiveMap()[String(charId)] ?? ultraPassiveMap()[charId]
        const abstractCreatures = collectAbstractUWeaponCreatures(char.UWeapon)
        const skills: any[] = []
        for (const skillId of battleChar.SkillList ?? []) {
            if (skillId === ultraPassiveId) continue
            const info = await processSingleSkill(skillId, undefined, abstractCreatures)
            if (info) skills.push(info)
        }
        processed.技能 = skills

        // 溯源
        const traces = processTraces(battleChar, charId)
        if (traces.length > 0) processed.溯源 = traces

        // 碎片 / 第七溯源 / 同律武器
        const piece = processTracePieceId(charId)
        if (piece) processed.碎片 = piece
        const seventh = processSeventhTraceCost(charId)
        if (seventh.length > 0) processed.第七溯源消耗 = seventh
        const specialWeapon = processAbyssSpecialWeapon(charId)
        if (specialWeapon !== undefined) processed.专武 = specialWeapon
        const uWeapons = processUWeapon(char.UWeapon)
        if (Array.isArray(uWeapons) && uWeapons.length > 0) processed.同律武器 = uWeapons

        // 空字段清理（对齐老代码）
        for (const field of ["出生地", "生日", "中文CV", "日文CV", "英文CV", "韩文CV", "势力", "别名", "专武"]) {
            if (!processed[field]) delete processed[field]
        }
        if (!Object.keys(processed.加成 ?? {}).length) delete processed.加成
        if (!(processed.标签 as VNodeTree[])?.length) delete processed.标签

        items.push(processed)
    }

    await assetReader.close()
    return { Char: items.map(item => orderCharTree(item)) }
}

// ---------- 模块级辅助 ----------

const HINT_MAP: Record<string, string> = {
    SkillEfficiency: "技能效益",
    SkillIntensity: "技能威力",
    SkillRange: "技能范围",
    SkillSustain: "技能耐久",
}

const BEHAVIOR_ATTR_CN: Record<string, string> = {
    DamagedRate: "受到伤害",
    WeaponCRDModifierRate: "暴伤",
    WeaponCRDModifierValue: "暴伤",
    WeaponCRIModifierRate: "武器暴击率",
    WeaponCRIModifierValue: "武器暴击率",
    AttackSpeedModifierRate: "攻速加成",
    WalkSpeedModifier: "移动速度",
    MoveSpeedAddRate: "移动速度加成",
    FlySpeedModifier: "飞行速度",
    SlideVelocityModifier: "滑移速度",
    BulletJumpVelocityModifier: "螺旋飞跃速度",
    JumpVelocityModifier: "跳跃速度",
    SkillSpeed: "技能速度",
    SkillIntensity: "技能威力",
    SkillEfficiency: "技能效益",
    StrongValue: "昂扬",
    BonusDamage: "追加伤害",
    Sp: "神智",
    SpRate: "神智比例",
    TriggerProbModifierRate: "触发概率加成",
    DropDistance: "拾取范围",
    AttackRangeModifierValue: "攻击范围加成",
    OverShieldLevelGrow: "过载护盾等级成长",
    MaxAvoidExecuteTimes: "闪避次数",
    Def: "防御",
    SkillRange: "技能范围",
}

const PASSIVE_FUNCTION_CN: Record<string, string> = {
    AddMspOnHit: "命中回复神智",
    AddShield: "获得护盾",
    AddbuffSkill02: "附加终结技增益",
    AddbuffSkillintensity: "附加技能威力增益",
    BombCreate: "生成炸弹",
    CheckAndRemoveBuff: "检测并移除增益",
    ClearSkill01TargetNum: "清空战技目标计数",
    DownStage: "解除变身/离场",
    ExecuteSkill01: "释放战技",
    ExecuteSkill02: "释放终结技",
    Falu_Skill01_On: "法露茜战技开启",
    FunnelCreate: "生成浮游炮",
    HenshinBuff: "变身增益",
    HenshinOff: "解除变身",
    LaunchShadowSword: "释放暗影剑",
    OnZhiliuMarkRemove: "滞留标记移除时",
    PassiveAdditionalSummon: "被动追加召唤",
    QuitSkill02: "退出终结技",
    SetSkill02Level: "设置终结技等级",
    Skill1AddBuff: "战技附加增益",
    Skill1AddMsp1: "战技回复神智1",
    Skill1AddMsp2: "战技回复神智2",
    Skill1AddPassive: "战技叠加被动层数",
    Skill2AddBuff: "终结技附加增益",
    Skill2AddPassive: "终结技叠加被动层数",
    Skill2Off: "终结技关闭",
    Skill2SummonAttack: "终结技召唤攻击",
    SummonSkill1: "召唤战技实体",
    BladeUp: "武器强化/剑气蓄力",
    CheckBullet: "检查弹体",
    ClearComboCount: "清空连击数",
    ConsumeSkill02AttackBullet: "消耗终结技攻击弹体",
    EndGrab: "结束抓取",
    FlyingSkill1: "飞行战技",
    GradeAutoShoot: "按等级自动射击",
    HeavyAttackEnd: "重击结束",
    HeavyAttackStart: "重击开始",
    HitWall: "命中墙体",
    OnSkill02Hit: "终结技命中",
    OnStage: "登场",
    OnSummonHitWall: "召唤物命中墙体",
    PauseLifeTime: "暂停寿命计时",
    Promotion_Queen: "升变·皇后",
    Promotion_Rook: "升变·堡垒",
    ResumeLifeTime: "恢复寿命计时",
    SetRate: "设置倍率",
    ShootJudge: "射击判定",
    ShootLoopStart: "开始循环射击",
    Skill01ConsumeEnergy: "战技消耗能量",
    Skill01_GatherTarget: "战技聚怪",
    Skill02Off: "终结技关闭",
    Skill2AddMsp: "终结技回复神智",
    Skill1Beat: "战技命中",
    Skill1End: "战技结束",
    StartDash: "开始冲刺",
    StartGrab: "开始抓取",
    StartShoot: "开始射击",
    StopDash: "停止冲刺",
}

const CHAR_KEY_ORDER = [
    "id",
    "icon",
    "名称",
    "版本",
    "别名",
    "出生地",
    "势力",
    "生日",
    "中文CV",
    "日文CV",
    "英文CV",
    "韩文CV",
    "阵营",
    "属性",
    "精通",
    "标签",
    "基础攻击",
    "基础生命",
    "基础防御",
    "基础护盾",
    "基础神智",
    "加成",
    "突破",
    "技能",
    "溯源",
    "碎片",
    "第七溯源消耗",
    "专武",
    "同律武器",
]
const SKILL_KEY_ORDER = ["id", "名称", "类型", "描述", "icon", "cd", "实体", "字段", "升级", "术语解释", "子技能", "行为"]
const FIELD_KEY_ORDER = ["名称", "影响", "值", "值2", "格式", "tag", "削韧", "Boss削韧", "取消", "连段"]
const U_WEAPON_KEY_ORDER = ["id", "名称", "类型", "icon", "伤害类型", "攻击", "暴击", "暴伤", "触发"]

/** 保持生成 JSON 的字段顺序与旧 Char 导出一致；vnode 自身顺序不能改。 */
function orderCharTree(value: any, parentKey = ""): any {
    if (Array.isArray(value)) return value.map(item => orderCharTree(item, parentKey))
    if (!value || typeof value !== "object" || "__t" in value) return value

    const keys = Object.keys(value).filter(key => key !== "__childNameAppended")
    let order = CHAR_KEY_ORDER
    if (parentKey === "字段") order = FIELD_KEY_ORDER
    else if (parentKey === "同律武器") order = U_WEAPON_KEY_ORDER
    else if (parentKey === "技能" || parentKey === "子技能") order = SKILL_KEY_ORDER
    const childNameAppended = value.__childNameAppended === true
    if (childNameAppended) order = [...SKILL_KEY_ORDER.filter(key => key !== "名称"), "名称"]
    const rank = new Map(order.map((key, index) => [key, index]))
    const sortedKeys = keys
        .map((key, index) => ({ key, index }))
        .sort((a, b) => (rank.get(a.key) ?? order.length + a.index) - (rank.get(b.key) ?? order.length + b.index))
        .map(item => item.key)
    const out: Record<string, any> = {}
    for (const key of sortedKeys) out[key] = orderCharTree(value[key], key)
    return out
}

function resourceNameKey(dm: ModuleContext["dm"], resourceId: number): string | undefined {
    const res = dm.getTable("Resource") as Record<string, any> | undefined
    if (!res) return undefined
    for (const v of Object.values(res)) {
        if (v && v.ResourceId === resourceId && v.ResourceName) return v.ResourceName
    }
    return undefined
}

/** 技能条目：skill[skillId][0]["0"]（兼容数组/对象 grade） */
function getSkillEntry(dm: ModuleContext["dm"], skillId: number): Record<string, any> | null {
    const skill = dm.getTable("Skill") as Record<string, any> | undefined
    if (!skill) return null
    const info = skill[String(skillId)] ?? skill[skillId]
    if (!Array.isArray(info) || info.length === 0) return null
    const gradeTable = info[0]
    if (!gradeTable || typeof gradeTable !== "object") return null
    const entry = gradeTable["0"] ?? gradeTable[0]
    return entry && typeof entry === "object" ? entry : null
}

/** 技能等级数 */
function skillInfoLevels(dm: ModuleContext["dm"], skillId: number): number {
    const skill = dm.getTable("Skill") as Record<string, any> | undefined
    const info = skill?.[String(skillId)] ?? skill?.[skillId]
    return Array.isArray(info) ? info.length : 1
}

/** 技能字段的 SkillEffects 表 */
function skillEffectsTable(dm: ModuleContext["dm"]): Record<string, any> {
    return (dm.getTable("SkillEffects") as Record<string, any>) || {}
}

/** SkillDescGroups 使用 1-based 字段索引；返回该字段所属段名的 TextMap key。 */
function skillSectionName(groups: unknown, index: number): string | undefined {
    if (!Array.isArray(groups)) return undefined
    const fieldIndex = index + 1
    for (const group of groups) {
        if (!group || typeof group !== "object" || Array.isArray(group)) continue
        for (const [nameKey, indices] of Object.entries(group as Record<string, unknown>)) {
            if (Array.isArray(indices) && indices.some(value => Number(value) === fieldIndex)) return nameKey
        }
    }
    return undefined
}

function skillSectionIndex(groups: unknown, index: number): number | undefined {
    if (!Array.isArray(groups)) return undefined
    const fieldIndex = index + 1
    for (let groupIndex = 0; groupIndex < groups.length; groupIndex++) {
        const group = groups[groupIndex]
        if (!group || typeof group !== "object" || Array.isArray(group)) continue
        for (const indices of Object.values(group as Record<string, unknown>)) {
            if (Array.isArray(indices) && indices.some(value => Number(value) === fieldIndex)) return groupIndex
        }
    }
    return undefined
}

/** 生成老导出中的技能行为摘要；只读技能链，不参与翻译或数值解析。 */
function generateSkillBehavior(
    dm: ModuleContext["dm"],
    skillArtifacts: SkillArtifacts,
    skillId: number,
    inheritedDescValues?: unknown[],
    textmap?: ModuleContext["textmap"]
): string {
    const _skillData = (dm.getTable("Skill") as Record<string, any>) || {}
    const nodeData = (dm.getTable("SkillNode") as Record<string, any>) || {}
    const effectData = (dm.getTable("SkillEffects") as Record<string, any>) || {}
    const buffData = (dm.getTable("Buff") as Record<string, any>) || {}
    const passiveData = (dm.getTable("PassiveEffect") as Record<string, any>) || {}
    const attrConfig = () => (dm.getTable("AttrConfig") as Record<string, any>) || {}
    let bpAddBuff = BP_ADD_BUFF_CACHE.get(dm.root)
    if (!bpAddBuff) {
        bpAddBuff = JSON.parse(readFileSync(join(dm.root, "processor", "BPAddBuff.json"), "utf8")) as Record<string, number[]>
        BP_ADD_BUFF_CACHE.set(dm.root, bpAddBuff)
    }
    const entry = getSkillEntry(dm, skillId)
    if (!entry) return ""

    const ownDescValues = normalizeMapOrArray(entry.SkillDescValues)
    const descValues = ownDescValues.length > 0 ? ownDescValues : (inheritedDescValues ?? [])
    const parts: string[] = []
    const seenEffects = new Set<string>()
    const seenNodes = new Set<string>()
    const seenSkills = new Set<string>()

    const effectRate = (effectId: number, rate: unknown): number | null => {
        if (typeof rate === "number") return rate
        const text = String(rate ?? "")
        if (!text.startsWith("#")) return Number.isFinite(Number(text)) ? Number(text) : null
        const source =
            descValues.find(value => typeof value === "string" && value.includes(`SkillEffects[${effectId}]`) && value.includes("*100")) ??
            descValues.find(value => typeof value === "string" && value.includes("SkillEffects[") && value.includes("*100"))
        if (typeof source !== "string") return null
        const ref = source.match(new RegExp(`\\$#SkillEffects\\[${effectId}\\][^$]*\\$`))?.[0]
        if (!ref) return null
        const computed = skillArtifacts.calcSkillDesc(ref, 1)
        const number = computed.match(/-?\d+(?:\.\d+)?/)?.[0]
        return number === undefined ? null : Number(number) / (ref.includes("*100") ? 100 : 1)
    }

    const add = (part: string) => {
        if (part && !parts.includes(part)) parts.push(part)
    }

    const addOrdered = (part: string, before?: string) => {
        if (!part || parts.includes(part)) return
        if (before) {
            const index = parts.findIndex(existing => existing === before || existing.startsWith(before))
            if (index >= 0) {
                parts.splice(index, 0, part)
                return
            }
        }
        parts.push(part)
    }

    const attrConfigKey = (attrName: string, attr: Record<string, any>): string => {
        if (attrName === "DamageRate" || attrName === "DamagedRate") {
            const tag = attr.DamageTag ?? attr.Tag
            const zone = attr.RateZone
            if (tag || zone) {
                const tagName = tag ?? "NoTag"
                const zoneName = zone ?? "Normal"
                const clientKey = `${attrName}_${tagName}_${zoneName}`
                if (attrConfig()[clientKey]) return clientKey
                const zoneKey = `${attrName}_${zoneName}`
                if (attrConfig()[zoneKey]) return zoneKey
            }
        }
        if (attrConfig()[attrName]) return attrName
        const normalKey = `${attrName}_Normal`
        return attrConfig()[normalKey] ? normalKey : attrName
    }

    const attrSummaryName = (attrName: string, attr: Record<string, any>): string => {
        const direct = BEHAVIOR_ATTR_CN[attrName]
        if (direct) return direct
        const config = attrConfig()[attrConfigKey(attrName, attr)]
        const translated = config?.Name && textmap ? textmap.get(String(config.Name), "cn") : ""
        return ATTR_NAME_MAP[translated] ?? P_MAP[translated] ?? P_MAP[attrName] ?? (translated || attrName)
    }

    const formatBuffValue = (attrName: string, attr: Record<string, any>, value: unknown): string => {
        const number = Number(value)
        if (!Number.isFinite(number)) return String(value ?? "")
        const config = attrConfig()[attrConfigKey(attrName, attr)]
        if (config?.IsPercent) return `${roundValue(number * 100)}%`
        return String(roundValue(number))
    }

    const buffSummary = (buffId: unknown): string => {
        const id = String(buffId ?? "")
        const buff = buffData[id]
        if (!buff || typeof buff !== "object") return `增益(${id})`
        const bits: string[] = []
        for (const attr of Array.isArray(buff.AddAttrs) ? buff.AddAttrs : []) {
            if (!attr || typeof attr !== "object") continue
            const attrName = String(attr.AttrName ?? "")
            const name = attrName === "ATK" ? "攻击" : attrSummaryName(attrName, attr)
            const rawValue = attr.Rate ?? attr.Value
            const value = Number(rawValue)
            if (!name || rawValue === undefined || rawValue === null) {
                if (attr.SupLimitValue === undefined) continue
            }
            if (attr.Stackable && (Number.isFinite(value) || (typeof rawValue === "string" && rawValue.startsWith("#")))) {
                const stackValue = typeof rawValue === "string" && rawValue.startsWith("#") ? rawValue : String(roundValue(value))
                bits.push(`每层+${stackValue}${name}(最多${buff.MaxLayer ?? ""}层)`)
            } else if (attr.SupLimitValue !== undefined) {
                bits.push(`${name}上限${roundValue(Number(attr.SupLimitValue))}`)
            } else {
                const displayValue =
                    typeof rawValue === "string" && rawValue.startsWith("#") ? rawValue : formatBuffValue(attrName, attr, rawValue)
                bits.push(`${name}+${displayValue}`)
            }
        }
        for (const dot of Array.isArray(buff.DotDatas) ? buff.DotDatas : []) {
            if ((dot?.Type === "SpChange" || dot?.Type === "SecondSpChange") && typeof dot.Value === "number") {
                const verb = dot.Value < 0 ? "消耗" : "回复"
                bits.push(`每${dot.Interval ?? 1}秒${verb}${Math.abs(dot.Value)}神智`)
            } else if (dot?.Type === "SkillEffect") {
                bits.push(`每${dot.Interval ?? 1}秒执行技能效果(${dot.EffectId})`)
            } else if (dot?.Type === "Dot") {
                const damageType = DAMAGE_TYPE_CN[String(dot.DamageType)] ?? dot.DamageType ?? ""
                const rate = dot.Rate === undefined ? "" : `×${dot.Rate}`
                bits.push(`每${dot.Interval ?? 1}秒造成${damageType}持续伤害${rate}`)
            }
        }
        if (buff.ActivateSkills) bits.push("激活技能")
        if (buff.ReplaceActions) bits.push("替换动作")
        if (buff.EnableFlight) bits.push("启用飞行")
        if (buff.UseSummonWeapon) bits.push("召唤武器")
        if (Array.isArray(buff.DisableSkills) && buff.DisableSkills.length > 0) {
            bits.push(`禁用[${buff.DisableSkills.map((skill: unknown) => ACTION_CN[String(skill)] ?? String(skill)).join(", ")}]`)
        }
        return bits.length > 0 ? `增益(${id})[${bits.join(", ")}]` : `增益(${id})`
    }

    const walkEffect = (effectId: unknown): void => {
        const key = String(effectId)
        if (seenEffects.has(key)) return
        seenEffects.add(key)
        const effect = effectData[key]
        if (!effect || typeof effect !== "object") return
        for (const task of Array.isArray(effect.TaskEffects) ? effect.TaskEffects : []) {
            if (!task || typeof task !== "object") continue
            const fn = String(task.Function ?? "")
            if (fn === "Damage") {
                const rate = effectRate(Number(effectId), task.Rate)
                const base = BASE_ATTR_CN[String(task.BaseAttr)] ?? String(task.BaseAttr ?? "基础伤害")
                let text = `造成${base}`
                if (rate !== null && rate > 0 && rate < 1) text += `${roundValue(rate * 100)}%`
                else if (rate !== null) text += `${(rate * 100).toFixed(1)}%`
                if (rate !== null) {
                    text += "的"
                    text += task.DamageType ? `${DAMAGE_TYPE_CN[String(task.DamageType)] ?? task.DamageType}属性` : ""
                    text += "伤害"
                    const tags = (Array.isArray(task.DamageTag) ? task.DamageTag : [])
                        .map((tag: unknown) => DAMAGE_TAG_CN[String(tag)] ?? String(tag))
                        .filter((tag: string, index: number, list: string[]) => tag && list.indexOf(tag) === index)
                    if (tags.length > 0) text += `(${tags.join("/")})`
                    if (typeof task.Value === "string" && task.Value.startsWith("#")) text += `+${task.Value}`
                    addOrdered(text, `削减战姿${String(task.Value ?? "")}`)
                }
            } else if (fn === "CutToughness" && task.Value !== undefined) {
                add(`削减战姿${task.Value}`)
            } else if (fn === "AddBuff") {
                let summary = `附加${buffSummary(task.BuffId)}`
                if (typeof task.LastTime === "number" && task.LastTime !== -1) summary += `(持续${roundValue(task.LastTime)}秒)`
                if (task.Delay) summary = `延迟${roundValue(Number(task.Delay))}秒后${summary}`
                add(summary)
            } else if (fn === "RemoveBuff") {
                add(task.BuffId === undefined || task.BuffId === null ? "移除" : `移除${buffSummary(task.BuffId)}`)
            } else if (fn === "AddEnergyShield") {
                add("获得护盾")
            } else if (["Heal", "AddHp", "AddHpByRate", "RecoverHp", "AddSp", "RecoverSp", "AddES", "RecoverES"].includes(fn)) {
                add(`恢复类效果(${task.BaseAttr ?? task.BaseChar ?? fn})`)
            } else if (fn === "CreateSkillCreature" && task.CreatureId !== undefined) {
                add(`召唤实体(${task.CreatureId})`)
            } else if (fn === "CreateUnit") {
                add("执行[CreateUnit]")
            } else if (fn === "ExecutePassiveFunction") {
                const functionName = String(task.FunctionName ?? "")
                let summary = `触发被动功能[${PASSIVE_FUNCTION_CN[functionName] ?? functionName}]`
                const passiveId = task.PassiveEffectId
                const passive = passiveId !== undefined ? passiveData[String(passiveId)] : undefined
                if (passive && typeof passive === "object") {
                    const bpPath = String(passive.BPPath ?? "")
                    const bpName = bpPath.split("/").pop()?.split(".")[0] ?? ""
                    summary += `(被动效果${passiveId}${bpName ? `·${bpName}` : ""})`
                }
                add(summary)
            } else if (fn === "ExecuteClientPassiveFunction") {
                add("执行[ExecuteClientPassiveFunction]")
            } else if (
                [
                    "AddBullet",
                    "AdditionalHitFX",
                    "CallBackSkillCreature",
                    "ChangeModel",
                    "ChargeBullet",
                    "Disarm",
                    "PlayerCameraUnlock",
                    "RemoveSkillCreature",
                    "RemoveUnit",
                    "SetToCondemnLoc",
                    "StartTargetCondemn",
                ].includes(fn)
            ) {
                add(`执行[${fn}]`)
            }
            for (const childKey of ["SkillEffect", "EffectIds"]) {
                const children = Array.isArray(task[childKey]) ? task[childKey] : task[childKey] === undefined ? [] : [task[childKey]]
                for (const child of children) walkEffect(child)
            }
        }
    }

    const walkSkill = (innerSkillId: unknown): void => {
        const key = String(innerSkillId)
        if (seenSkills.has(key)) return
        seenSkills.add(key)
        const inner = getSkillEntry(dm, Number(innerSkillId))
        if (!inner) return
        for (const passiveId of Array.isArray(inner.PassiveEffects) ? inner.PassiveEffects : []) {
            const passive = passiveData[String(passiveId)]
            if (!passive || typeof passive !== "object") continue
            const path = String(passive.BPPath ?? "")
            const bpName = path.split("/").pop()?.split(".")[0] ?? ""
            const label = bpName ? `被动效果(${passiveId})(${bpName})` : `被动效果(${passiveId})`
            add(label)
            for (const buffId of bpAddBuff[bpName] ?? []) add(buffSummary(buffId))
        }
        let nodeId = inner.BeginNodeId
        while (nodeId && !seenNodes.has(String(nodeId)) && seenNodes.size < 8) {
            seenNodes.add(String(nodeId))
            const node = nodeData[String(nodeId)]
            if (!node || typeof node !== "object") break
            const effects = Array.isArray(node.SkillNodeEffects) ? node.SkillNodeEffects : [node.SkillNodeEffects]
            for (const effectId of effects) walkEffect(effectId)
            const branches = node.BranchNodeIds ?? node.ChildNodeIds
            const branchIds = Array.isArray(branches) ? branches : branches && typeof branches === "object" ? Object.values(branches) : []
            for (const branchId of branchIds) {
                let branchNodeId = branchId
                while (branchNodeId && !seenNodes.has(String(branchNodeId)) && seenNodes.size < 64) {
                    seenNodes.add(String(branchNodeId))
                    const branchNode = nodeData[String(branchNodeId)]
                    if (!branchNode || typeof branchNode !== "object") break
                    const branchEffects = Array.isArray(branchNode.SkillNodeEffects)
                        ? branchNode.SkillNodeEffects
                        : [branchNode.SkillNodeEffects]
                    for (const effectId of branchEffects) walkEffect(effectId)
                    branchNodeId = branchNode.NextNodeId
                }
            }
            nodeId = node.NextNodeId
        }
    }

    walkSkill(skillId)
    return parts.join(";")
}

/**
 * 把"等级表"规范化为有序条目列表。
 * 兼容：数组、1 起始对象 {"1":..., "2":...}、0 起始对象 {"0":..., "1":...}。
 * 对齐老 Python 转换的 list[-1] 语义：0 起始键的行放到末尾。
 */
function asEntryList(v: unknown): any[] {
    if (Array.isArray(v)) return v
    if (!v || typeof v !== "object") return []
    const entries: Array<[number, any]> = []
    for (const [k, val] of Object.entries(v as Record<string, any>)) {
        if (/^-?\d+$/.test(k) && val && typeof val === "object") {
            entries.push([Number(k), val])
        }
    }
    // 0 起始键放到末尾（对齐 python list[-1]），其余按数值序
    const zero = entries.filter(([k]) => k === 0).map(([, v]) => v)
    const rest = entries
        .filter(([k]) => k !== 0)
        .sort((a, b) => a[0] - b[0])
        .map(([, v]) => v)
    return [...rest, ...zero]
}

/**
 * 把"1 起始 map 或数组"规范化为数组（对齐老代码 _normalize_skill_desc_*）。
 * 如 {"1": a, "2": b} → [a, b]；数组原样返回。
 */
function normalizeMapOrArray(v: unknown): any[] {
    if (Array.isArray(v)) return v
    if (!v || typeof v !== "object") return []
    const items: Array<[number, any]> = []
    let maxIndex = 0
    for (const [k, val] of Object.entries(v as Record<string, any>)) {
        const idx = Number(k)
        if (!Number.isInteger(idx) || idx <= 0) continue
        items.push([idx, val])
        if (idx > maxIndex) maxIndex = idx
    }
    if (items.length === 0) return []
    const result: any[] = new Array(maxIndex).fill(null)
    for (const [idx, val] of items) result[idx - 1] = val
    return result
}

/**
 * 溯源参数格式化（对齐老代码 _process_traces 的数值格式化）：
 * - 整数不显示小数点：8.0 → "8"
 * - 带 % 后缀：8.0% → "8%"
 * - 否则保留原值
 */
function formatTraceValue(computed: string | number): VNode {
    const str = String(computed)
    // 去掉 GText 哨兵（溯源参数通常纯数值）
    const clean = str.replace(/\x01GT\{[^}]*\}\x01/g, "")
    const percentMatch = clean.match(/^(-?\d+(?:\.\d+)?)%$/)
    if (percentMatch) {
        const num = roundValue(Number(percentMatch[1]))
        return `${num}%`
    }
    const numMatch = clean.match(/^(-?\d+(?:\.\d+)?)$/)
    if (numMatch) {
        const num = roundValue(Number(numMatch[1]))
        return `${num}`
    }
    const embedded = clean.match(/-?\d+(?:\.\d+)?/)
    if (embedded) {
        const num = roundValue(Number(embedded[0]))
        const start = embedded.index ?? 0
        return compile(`${str.slice(0, start)}${num}${str.slice(start + embedded[0].length)}`)
    }
    return compile(computed)
}

function extractIconName(v: unknown): string {
    const s = String(v ?? "")
    if (s.includes("Skill_")) return s.split("Skill_")[1]
    return s
}
