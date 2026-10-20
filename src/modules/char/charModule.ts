/**
 * charModule — 输出 Char.json。
 *
 * 对齐旧版导出的核心输出路径：
 * - 基础信息（id/icon/名称/版本/别名/出生地/势力/生日/CV/阵营/属性/精通/标签/特质）
 * - 基础属性（攻击/生命/防御/护盾/神智）、加成、突破、溯源、碎片、第七溯源消耗、专武
 * - 技能（名称/类型/描述/字段/升级/实体/术语解释/子技能/行为）
 *
 * 翻译部分一律 vnode；数值/结构普通 JS。语言无关，一次 build 多语言渲染。
 * 技能字段/值计算走游戏 SkillUtils（skill 模块 artifacts）。
 */
import type { ModuleContext } from "../../core/Graph.ts"
import { compile, LTemplate, record, seq, T, TFixed, TMap, TSection, type VNode, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
import type { SkillArtifacts } from "../skill/skillModule.ts"
import { extractFieldValueAndFormatFromSource, roundValue } from "../skill/skillModule.ts"
import { generateSkillBehavior, getSkillEntry, normalizeMapOrArray } from "./behaviorChain.ts"

/** 阵营：Camp 表 */
/** 属性缩写 */
const _CAMP_NAME_OVERRIDES: Record<string, string> = {}
const ATTR_NAME_MAP: Record<string, string> = {
    武器暴击率: "暴击",
    武器多重射击: "多重",
}

/** 武器类型标签 → 中文（对齐旧版导出） */
const WEAPON_TYPE_CN: Record<string, string> = {
    Ultra: "同律",
    Melee: "近战",
    Ranged: "远程",
    Bow: "弓",
    Bow01: "弓（短弓）",
    Bow02: "弓（长弓）",
    Cannon: "榴炮",
    Claymore: "重剑",
    Crossbow: "双枪",
    Dualblade: "双刀",
    Katana: "太刀",
    Machinegun: "突击枪",
    Pistol: "手枪",
    Polearm: "长柄",
    Shotgun: "霰弹枪",
    Sword: "单手剑",
    Swordwhip: "鞭刃",
}
export async function charModule(ctx: ModuleContext) {
    const dm = ctx.dm
    const skillArtifacts = ctx.getArtifact<SkillArtifacts>("Skill")!
    // 动画数据源：UAssetCLI 直读 .uasset（已用 Lise_Skill01 验证与旧 FModel JSON 逐值一致）。
    const assetReader = new AssetReader(dm.root)
    await assetReader.ensureServer()

    // 原始表
    const charData = () => (dm.getTable("Char") as Record<string, any>) || {}
    const battleCharData = () => (dm.getTable("BattleChar") as Record<string, any>) || {}
    const characterData = () => (dm.getTable("CharacterData") as Record<string, any>) || {}
    const campData = () => (dm.getTable("CharCamp") as Record<string, any>) || {}
    const weaponTagData = () => (dm.getTable("WeaponTag") as Record<string, any>) || {}
    const dispatchTagData = () => (dm.getTable("CharDispatchTag") as Record<string, any>) || {}
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

    /**
     * 特质（派遣标签）。
     *
     * Char.DispatchTag 的每个槽位在突破到 Char.DispatchUnlock 对应阶段后解锁；同名标签每占
     * 一个槽位提升一级（对齐 Character:GetCurrentUnlockDispatchTag 的计数语义）。这里按标签
     * 首次出现顺序聚合：名称/描述取 CharDispatchTag 的 TextMap key，icon 取该标签的 T_ 贴图名，
     * 标签为槽位里的原始标签 key（Battle / Collect / Pet / Lucky …，界面按
     * UIUtils.GetDispathchColorNameByType 用它决定图标的配色分组；与角色自身的 标签（定位标签）无关），
     * 等级为已占槽位数，解锁为各级对应的突破阶段（0..5，对应 突破 数组的第 N+1 段）。
     */
    function processTraits(char: Record<string, any>): VNodeTree {
        const tags = normalizeMapOrArray(char.DispatchTag)
        if (tags.length === 0) return []
        const unlockStages = normalizeMapOrArray(char.DispatchUnlock)
        const order: string[] = []
        const stagesByTag = new Map<string, number[]>()
        for (let i = 0; i < tags.length; i++) {
            const tag = String(tags[i] ?? "")
            if (!tag) continue
            let stages = stagesByTag.get(tag)
            if (!stages) {
                stages = []
                stagesByTag.set(tag, stages)
                order.push(tag)
            }
            const stage = Number(unlockStages[i])
            if (Number.isFinite(stage)) stages.push(stage)
        }
        return order.map(tag => {
            const row = dispatchTagData()[tag] ?? {}
            const stages = stagesByTag.get(tag) ?? []
            return {
                名称: T(row.Name ?? ""),
                描述: T(row.Description ?? ""),
                icon: textureName(row.Icon),
                标签: tag,
                等级: stages.length,
                解锁: stages,
            }
        })
    }

    /** 武器类型标签（UWeapon 的 WeaponTag：Ultra/Melee/Sword 等） */
    function processWeaponTags(tags: unknown): VNodeTree {
        if (!Array.isArray(tags)) return []
        const out: VNodeTree[] = []
        for (const tag of tags) {
            const mapped = WEAPON_TYPE_CN[String(tag)]
            if (mapped) {
                out.push(mapped)
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
    function processAddon(_charId: number, battleChar: Record<string, any>): VNodeTree {
        const out = new Map<string, number>()
        const addonAttrs = battleChar.CharAddonAttr ?? []
        if (!Array.isArray(addonAttrs)) return record([])
        for (const attrId of addonAttrs) {
            const row = charAddonAttrData()[String(attrId)]
            const attr = row?.AddAttrs
            if (!attr?.AttrName) continue
            const key = attrConfig()[attr.AttrName] ? attr.AttrName : `${attr.AttrName}_Normal`
            const cfg = attrConfig()[key] ?? {}
            const nameKey = cfg.Name ?? ""
            if (!nameKey) continue
            const value = roundValue(attr.Rate ?? attr.Value ?? 0)
            out.set(nameKey, (out.get(nameKey) ?? 0) + value)
        }
        return record([...out].map(([key, value]) => [TMap(key, ATTR_NAME_MAP), value]))
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
            if (ctx.textmap.get(k, "cn") === k) continue
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
                    if (typeof value === "string") {
                        const computed = skillArtifacts.calcSkillDesc(value, 1)
                        return formatTraceValue(computed.replace(/\x01GT\{[^}]*\}\x01/g, ""))
                    }
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

        const behavior = generateSkillBehavior(dm, skillArtifacts, skillId, inheritedDescValues)

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
                if (key === "id" || key === "子技能" || key === "行为") return false
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
            // 无自有名称的子技能：名称在 processSingleSkill 之后追加，天然落在对象末尾，
            // 与旧导出固定顺序一致（名称列在最后）。
            child.名称 = explanationName
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
            const item: Record<string, any> = {
                名称: groupName ? TSection(groupName, String(descKey)) : T(String(descKey)),
                __descIndex: i,
            }

            // 影响（SkillDescHints → 技能效益/技能威力/技能范围/技能耐久/技能速度/多重/充盈威力）
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
            const meta = skillArtifacts.resolveFieldCombatMeta(String(descValue))
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
        const getNode = (id: unknown): Record<string, any> | null => {
            const node = dm.getTableItem("SkillNode", String(id)) as Record<string, any> | undefined
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
            额外精通: processMastery(battleChar.ExcelWeaponTagsExpand),
            标签: processTags(battleChar.Positioning),
            特质: processTraits(char),
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
        if ((processed.加成 as { entries?: unknown[] } | undefined)?.entries?.length === 0) delete processed.加成
        if (!(processed.标签 as VNodeTree[])?.length) delete processed.标签
        if (!(processed.特质 as VNodeTree[])?.length) delete processed.特质
        if (!(processed.额外精通 as string[])?.length) delete processed.额外精通

        items.push(processed)
    }

    await assetReader.close()
    // 字段顺序由各构建点的插入顺序固定（对齐旧 Python 导出），不做写入后排序。
    return { Char: items }
}

// ---------- 模块级辅助 ----------

const HINT_MAP: Record<string, string> = {
    HyperTriggerRate: "充盈威力",
    MultiShoot: "多重",
    SkillEfficiency: "技能效益",
    SkillIntensity: "技能威力",
    SkillRange: "技能范围",
    SkillSpeed: "技能速度",
    SkillSustain: "技能耐久",
}

/**
 * 输出对象的字段顺序由各构建点的对象字面量/属性赋值顺序直接固定（对齐旧 Python 导出），
 * 不做写入后排序。各类对象的固定顺序：
 * - 角色：id/icon/名称/版本/别名/出生地/势力/生日/中文CV/日文CV/英文CV/韩文CV/
 *   阵营/属性/精通/额外精通/标签/特质/基础攻击/基础生命/基础防御/基础护盾/基础神智/
 *   加成/突破/技能/溯源/碎片/第七溯源消耗/专武/同律武器
 * - 特质：名称/描述/icon/等级/解锁
 * - 技能：id/名称/类型/描述/icon/cd/实体/字段/升级/术语解释/子技能/行为
 *   （无自有名称的子技能，名称追加在对象末尾）
 * - 字段：名称/影响/值/值2/格式/tag/削韧/Boss削韧/取消/连段
 * - 同律武器：id/名称/类型/icon/伤害类型/攻击/暴击/暴伤/触发
 * 新增字段时必须按上述顺序插入，保持与旧导出一致。
 */

function resourceNameKey(dm: ModuleContext["dm"], resourceId: number): string | undefined {
    const res = dm.getTable("Resource") as Record<string, any> | undefined
    if (!res) return undefined
    for (const v of Object.values(res)) {
        if (v && v.ResourceId === resourceId && v.ResourceName) return v.ResourceName
    }
    return undefined
}

/** 技能等级数 */
function skillInfoLevels(dm: ModuleContext["dm"], skillId: number): number {
    const info = dm.getTableItem("Skill", skillId) as any
    return Array.isArray(info) ? info.length : 1
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
    // 0 起始键放到末尾（对齐旧版导出的列表末位语义），其余按数值序
    const zero = entries.filter(([k]) => k === 0).map(([, v]) => v)
    const rest = entries
        .filter(([k]) => k !== 0)
        .sort((a, b) => a[0] - b[0])
        .map(([, v]) => v)
    return [...rest, ...zero]
}

/**
 * 溯源参数格式化（对齐老代码 _process_traces 的数值格式化）：
 * - 整数不显示小数点：8.0 → "8"
 * - 带 % 后缀：8.0% → "8%"
 * - 含 GText 单位时保留哨兵，交由 compile 在渲染阶段展开
 */
export function formatTraceValue(computed: string | number): VNode {
    const str = String(computed)
    // 含 GText 哨兵时不能走纯数字快捷分支，否则单位会丢失。
    const hasGText = /\x01GT\{[^}]*\}\x01/.test(str)
    const clean = str.replace(/\x01GT\{[^}]*\}\x01/g, "")
    const percentMatch = clean.match(/^(-?\d+(?:\.\d+)?)%$/)
    if (percentMatch && !hasGText) {
        const num = roundValue(Number(percentMatch[1]))
        return `${num}%`
    }
    const numMatch = clean.match(/^(-?\d+(?:\.\d+)?)$/)
    if (numMatch && !hasGText) {
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

/**
 * T_ 贴图名（派遣标签图标等）：取路径中的 `T_xxx` 资源名，与 CharAccessory/HardBoss 等模块一致，
 * 结果即解包资源的文件名（如 `/Game/…/Dispatch/T_Dispatch_A09.T_Dispatch_A09` → `T_Dispatch_A09`）。
 */
function textureName(v: unknown): string {
    if (typeof v !== "string") return ""
    return v.match(/(T_[^./']+)/)?.[1] ?? ""
}
