/**
 * weaponModule — 输出 Weapon.json。
 *
 * 对齐老 processor/weapon_processor.py 的核心输出路径：
 * - 基础信息（id/icon/名称/版本/描述/类型）
 * - 属性（伤害类型/攻击/暴击/暴伤/触发/弹匣…）
 * - 加成 / 突破 / 熔炼 / 熔炉
 * - 技能（字段/削韧/tag/取消/连段/实体）
 *
 * 翻译部分一律 vnode；数值/结构普通 JS。语言无关，一次 build 多语言渲染。
 * 数据源：Script/Datas/*.lua（按需加载）。
 * 动画资源由 AssetReader 通过 UAssetCLI 读取；仅保留既有静态资源目录兼容路径。
 */

import type { ModuleContext } from "../../core/Graph.ts"
import { compile, LTemplate, record, T, TLang, TMap, type VNode, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
import type { SkillArtifacts } from "../skill/skillModule.ts"
import { extractFieldValueAndFormatFromSource, P_MAP, resolveFieldCombatMetaImpl, roundValue } from "../skill/skillModule.ts"

const TYPE_MAP: Record<string, string> = {
    Shooting: "射击",
    Attack: "普通攻击",
    HeavyAttack: "蓄力攻击",
    FallAttack: "下落攻击",
    SlideAttack: "滑行攻击",
}

/** 武器标签映射（对齐 BaseProcessor.process_tags 的 WeaponType_* 部分） */
const WEAPON_TYPE_KEY: Record<string, string> = {
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

const WEAPON_TYPE_CN: Record<string, string> = {
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

/** AttrConfig 键拼接（port get_attr_config_key_from_attr_data 核心分支） */
function attrConfigKey(attr: Record<string, any>, attrConfig: Record<string, any>): string {
    const attrName = attr.AttrName
    if (!attrName) return ""
    if (attrName === "DamageRate" || attrName === "DamagedRate") {
        const tag = attr.IndividualRateZone ? "NoTag" : (attr.DamageTag ?? attr.Tag)
        const zone = attr.RateZone
        if (tag || zone) {
            const clientKey = `${attrName}_${tag ?? "NoTag"}_${zone ?? "Normal"}`
            if (clientKey in attrConfig) return clientKey
            const zoneKey = `${attrName}_${zone ?? "Normal"}`
            if (zoneKey in attrConfig) return zoneKey
        }
    }
    if (attrName in attrConfig) return attrName
    const normalKey = `${attrName}_Normal`
    if (normalKey in attrConfig) return normalKey
    return attrName
}

function processRelease(v: unknown): string {
    const release = Number(v) || 0
    if (!release) return "1.0"
    return `${Math.floor(release / 100)}.${Math.floor((release % 100) / 10)}`
}

/** 资源名（Resource.json → ResourceName 翻译 key） */
function resourceNameKey(dm: ModuleContext["dm"], resourceId: number): string | undefined {
    const res = dm.getTable("Resource") as Record<string, any> | undefined
    if (!res) return undefined
    for (const v of Object.values(res)) {
        if (v && v.ResourceId === resourceId && v.ResourceName) return v.ResourceName
    }
    return undefined
}

export async function weaponModule(ctx: ModuleContext) {
    const dm = ctx.dm
    const skillArtifacts = ctx.getArtifact<SkillArtifacts>("Skill")!

    // 资产读取（uassetcli server 优先，json 回退）
    const assetReader = new AssetReader(dm.root, true, true)
    await assetReader.ensureServer()

    // 原始表
    const weaponData = () => (dm.getTable("Weapon") as Record<string, any>) || {}
    const battleWeaponData = () => (dm.getTable("BattleWeapon") as Record<string, any>) || {}
    const weaponBreakData = () => (dm.getTable("WeaponBreak") as Record<string, any>) || {}
    const _weaponCardLevelData = () => (dm.getTable("WeaponCardLevel") as Record<string, any>) || {}
    const hyperCardLevelData = () => (dm.getTable("HyperWeaponCardLevel") as Record<string, any>) || {}
    const hyperSkillTreeData = () => (dm.getTable("HyperWeaponSkillTree") as Record<string, any>) || {}
    const attrConfig = () => (dm.getTable("AttrConfig") as Record<string, any>) || {}
    const attributeData = () => (dm.getTable("Attribute") as Record<string, any>) || {}
    const skillData = (id: number | string) => dm.getTableItem("Skill", id) as any
    const skillEffectsData = (id: number | string) => dm.getTableItem("SkillEffects", id) as any
    const buffData = (id?: number | string) =>
        id === undefined ? (dm.getTable("Buff") as Record<string, any>) || {} : (dm.getTableItem("Buff", id) as any)
    const skillNodeData = (id: number | string) => dm.getTableItem("SkillNode", id) as any

    const _getWeapon = (id: number): any => weaponData()[String(id)] ?? weaponData()[id]
    const getBattleWeapon = (id: number): any => battleWeaponData()[String(id)] ?? battleWeaponData()[id]

    /** 武器标签 → 类型列表 */
    function processTags(tags: unknown): VNodeTree {
        if (!Array.isArray(tags)) return []
        const out: VNodeTree[] = []
        for (const tag of tags) {
            const direct = WEAPON_TYPE_KEY[String(tag)]
            if (direct === "同律" || direct === "近战" || direct === "远程") {
                out.push(direct)
            } else if (direct) {
                out.push(WEAPON_TYPE_CN[String(tag)] ?? direct)
            } else {
                // Positioning 表兜底
                const pos = (dm.getTable("Positioning") as Record<string, any>)?.[String(tag)]
                if (pos?.Name) out.push(T(pos.Name))
            }
        }
        return out
    }

    /** 属性（伤害类型/攻击/暴击/暴伤/触发） */
    function processAttributes(battleWeapon: Record<string, any>): Record<string, any> {
        const attributes: Record<string, unknown> = {}
        const attrData = attributeData()
        for (const attrName of Object.keys(attrData)) {
            const attrKey = `ATK_${attrName}`
            if (battleWeapon[attrKey] !== undefined && battleWeapon[attrKey] !== null) {
                if (attrName === "Psionic") {
                    attributes.伤害类型 = "灾厄"
                    attributes.攻击 = battleWeapon[attrKey]
                    continue
                }
                const cfg = attrConfig()[attrKey] ?? {}
                const atkType = ctx.textmap.get(cfg.Name ?? "", "cn")
                if (!atkType) continue
                attributes.伤害类型 = atkType.slice(0, 2)
                attributes[atkType.slice(2)] = battleWeapon[attrKey]
            }
        }
        attributes.暴击 = battleWeapon.CRI ?? 0
        attributes.暴伤 = battleWeapon.CRD ?? 0
        attributes.触发 = battleWeapon.TriggerProbability ?? 0
        if (battleWeapon.MagazineCapacity !== undefined) attributes.弹匣 = battleWeapon.MagazineCapacity
        if (battleWeapon.BulletMax !== undefined) attributes.最大弹药 = battleWeapon.BulletMax
        if (battleWeapon.BulletConver !== undefined) attributes.弹药转化率 = battleWeapon.BulletConver
        if (battleWeapon.MaxDistance !== undefined) attributes.最大射程 = battleWeapon.MaxDistance
        return attributes
    }

    /** 加成（AddAttrs → 属性名: 值） */
    function processAddAttr(battleWeapon: Record<string, any>, localize: boolean): Array<[VNode, VNode]> {
        const out: Array<[VNode, VNode]> = []
        for (const attr of battleWeapon.AddAttrs ?? []) {
            if (!attr?.AttrName) continue
            const key = attrConfigKey(attr, attrConfig())
            const cfg = attrConfig()[key] ?? {}
            const nameKey = cfg.Name ?? ""
            if (!nameKey) {
                out.push([
                    P_MAP[String(attr.AttrName)] ?? String(attr.AttrName),
                    calcAttrByLevelLua({ ...attr, tableId: battleWeapon.WeaponId }, ctx),
                ])
                continue
            }
            const attrCopy = { ...attr, tableId: battleWeapon.WeaponId }
            if (!("Type" in attrCopy)) attrCopy.Type = "BattleWeapon"
            const cnName = ctx.textmap.get(nameKey, "cn")
            out.push([localize ? TMap(nameKey, P_MAP) : (P_MAP[cnName] ?? cnName), calcAttrByLevelLua(attrCopy, ctx)])
        }
        return out
    }

    /** 突破材料 */
    function processBreak(weaponId: number): VNodeTree {
        const breakList = weaponBreakData()[String(weaponId)] ?? weaponBreakData()[weaponId]
        if (!Array.isArray(breakList)) return []
        const out: VNodeTree[] = []
        for (const stage of breakList) {
            const itemIds = stage.ItemId ?? []
            const itemNums = stage.ItemNum ?? []
            // 可翻译键对象：{ 资源名: 数量 }
            const entries: Array<[VNode, VNode]> = []
            for (let i = 0; i < itemIds.length; i++) {
                if (i >= itemNums.length) continue
                const rid = itemIds[i]
                const nameKey = resourceNameKey(dm, rid)
                const key: VNode = nameKey ? T(nameKey) : String(rid)
                entries.push([key, itemNums[i]])
            }
            out.push(record(entries))
        }
        return out
    }

    /** 熔炼（TextMap 模板 + 逐级值替换） */
    function processSmelting(battleWeapon: Record<string, any>): VNodeTree {
        const passiveDesc = battleWeapon.PassiveEffectsDesc
        const descValues = battleWeapon.PassiveEffectsDescValues ?? []
        if (!passiveDesc) return []
        const out: VNode[] = []
        for (let grade = 1; grade <= 6; grade++) {
            // 每个占位 #N 用 Lua CalcSkillDesc 计算该等级的值
            const values: VNode[] = []
            for (const dv of descValues) {
                if (typeof dv !== "string") continue
                values.push(compile(dm.calcSkillDesc(dv, grade)))
            }
            out.push(LTemplate(String(passiveDesc), values, true))
        }
        return out
    }

    function processFurnace(weaponId: number, battleWeapon: Record<string, any>): { rows: VNodeTree[]; addon: Array<[VNode, VNode]> } {
        const cards = hyperCardLevelData()[String(weaponId)]
        if (!Array.isArray(cards)) return { rows: [], addon: [] }
        const trees = Object.values(hyperSkillTreeData()).filter(
            (tree: any) => tree && Number(tree.WeaponId) === Number(weaponId) && Number(tree.WeaponCardLevel ?? 0) >= 0
        ) as Array<Record<string, any>>
        trees.sort(
            (a, b) =>
                Number(a.WeaponCardLevel ?? 0) - Number(b.WeaponCardLevel ?? 0) || Number(a.SkillIndex ?? 0) - Number(b.SkillIndex ?? 0)
        )
        const rows: VNodeTree[] = []
        const addon: Array<[VNode, VNode]> = []
        const formatFurnaceValue = (value: string): string => {
            const match = value.match(/-?\d+(?:\.\d+)?/)
            if (!match) return value
            const number = Number(match[0])
            if (!Number.isFinite(number)) return value
            const formatted = Number.isInteger(number) ? number.toFixed(1) : number.toFixed(2).replace(/0+$/, "")
            return `${value.slice(0, match.index)}${formatted}${value.slice((match.index ?? 0) + match[0].length)}`
        }
        const buildSkill = (tree: Record<string, any>): Record<string, VNodeTree> => {
            const params = Array.isArray(tree.SkillDescParameter)
                ? tree.SkillDescParameter.filter((value: unknown) => typeof value === "string").map((value: string) =>
                      compile(formatFurnaceValue(dm.calcSkillDesc(value, 1)))
                  )
                : []
            const skill: Record<string, VNodeTree> = {
                id: tree.WeaponSkillId ?? tree.SkillId,
                名称: T(tree.WeaponSkillName ?? ""),
                icon: String(tree.SkillIcon ?? "").match(/(T_[^.'"]+)/)?.[1] ?? "",
            }
            if (tree.SkillDescription) skill.描述 = LTemplate(String(tree.SkillDescription), params)
            const treeId = tree.WeaponSkillId ?? tree.SkillId
            const treeAttrs = (battleWeapon.AddAttrs ?? []).filter((attr: any) => Number(attr?.HyperWeaponSkillTreeID) === Number(treeId))
            const directAddon = processAddAttr({ ...battleWeapon, AddAttrs: treeAttrs }, true)
            const descAddon: Array<[VNode, VNode]> = []
            for (const parameter of Array.isArray(tree.SkillDescParameter) ? tree.SkillDescParameter : []) {
                const match = String(parameter).match(/Buff\[(\d+)\]/)
                if (!match) continue
                const buff = buffData(match[1])
                for (const attr of Array.isArray(buff?.AddAttrs) ? buff.AddAttrs : []) {
                    const attrName = String(attr?.AttrName ?? "")
                    const value = Number(attr?.Rate ?? attr?.Value)
                    if (!Number.isFinite(value)) continue
                    if (attrName === "BonusDamage") descAddon.push(["追加伤害", value])
                    else if (attrName === "DamageRate" && String(attr?.RateZone ?? "") === "Almighty") descAddon.push(["属性穿透", value])
                }
            }
            const skillAddon = [...directAddon, ...descAddon]
            if (skillAddon.length > 0) skill.加成 = record(skillAddon)
            if (descAddon.length > 0) {
                const bonusDamage = descAddon.find(([key]) => key === "追加伤害")?.[1]
                const penetration = descAddon.find(([key]) => key === "属性穿透")?.[1]
                if (bonusDamage && ctx.textmap.get(String(tree.SkillDescription ?? ""), "cn").includes("追加伤害")) {
                    skill.__fieldLangs = { 描述: ["en", "jp", "kr", "fr", "tc"] }
                    addon.push([TLang("追加伤害", ["cn"]), bonusDamage])
                }
                if (penetration) addon.push(["属性穿透", penetration])
            }
            const resourceIds = Array.isArray(tree.ResourceId) ? tree.ResourceId : []
            const resourceNums = Array.isArray(tree.ResourceNum) ? tree.ResourceNum : []
            const unlock: Array<[VNode, VNode]> = []
            for (let i = 0; i < resourceIds.length; i++) {
                const key = resourceNameKey(dm, resourceIds[i])
                unlock.push([key ? T(key) : String(resourceIds[i]), resourceNums[i]])
            }
            if (unlock.length > 0) skill.解锁 = record(unlock)
            return skill
        }
        const baseSkills = trees.filter(tree => Number(tree.WeaponCardLevel ?? 0) === 0).map(buildSkill)
        if (baseSkills.length > 0) rows.push({ lv: 0, 技能: baseSkills })
        for (const card of cards) {
            const level = Number(card?.WeaponCardLevel ?? 0)
            if (level <= 0) continue
            const levelSkills = trees.filter(tree => Number(tree.WeaponCardLevel ?? 0) === level).map(buildSkill)
            const resourceIds = Array.isArray(card.ResourceId) ? card.ResourceId : []
            const resourceNums = Array.isArray(card.ResourceNum) ? card.ResourceNum : []
            const unlock: Array<[VNode, VNode]> = []
            for (let i = 0; i < resourceIds.length; i++) {
                const key = resourceNameKey(dm, resourceIds[i])
                unlock.push([key ? T(key) : String(resourceIds[i]), resourceNums[i]])
            }
            const row: Record<string, VNodeTree> = { lv: level }
            if (unlock.length > 0) row.解锁 = record(unlock)
            if (levelSkills.length > 0) row.技能 = levelSkills
            rows.push(row)
        }
        return { rows, addon }
    }

    /** 技能字段（武器技能风格：名称/值/削韧/tag/延迟/卡肉） */
    async function processWeaponSkillFields(skillEntry: Record<string, any>, _weaponId: number): Promise<VNodeTree[]> {
        const normalize = (value: unknown): unknown[] => {
            if (Array.isArray(value)) return value
            if (!value || typeof value !== "object") return []
            const entries = Object.entries(value as Record<string, unknown>)
                .filter(([key]) => /^\d+$/.test(key))
                .sort(([a], [b]) => Number(a) - Number(b))
            if (entries.length === 0) return []
            const result: unknown[] = []
            for (const [key, item] of entries) result[Number(key) - 1] = item
            return result
        }
        const descKeys = normalize(skillEntry.SkillDescKeys)
        const descValues = normalize(skillEntry.SkillDescValues)
        if (descKeys.length === 0 || descValues.length === 0) return []

        const out: VNodeTree[] = []
        for (let i = 0; i < descKeys.length; i++) {
            const descKey = descKeys[i]
            const descValue = descValues[i]
            if (descKey === null || descKey === undefined || descValue === null || descValue === undefined) continue

            const computed = skillArtifacts.calcSkillDesc(String(descValue), 1)
            const meta = resolveFieldCombatMetaImpl(String(descValue), skillEffectsData)

            const item: Record<string, any> = {
                名称: T(String(descKey)),
            }
            // 数值（用 skill 模块的 extractFieldValueAndFormat：保留 GText 哨兵在格式段）
            const [value, value2, format] = extractFieldValueAndFormatFromSource(String(descValue), computed)
            item.值 = value
            if (value2 !== null) item.值2 = value2
            if (format && format !== "{%}") item.格式 = compile(format)
            if (meta.削韧) item.削韧 = meta.削韧
            if (meta.Boss削韧 !== undefined) item.Boss削韧 = meta.Boss削韧
            if (meta.延迟) item.延迟 = meta.延迟
            if (meta.卡肉) item.卡肉 = meta.卡肉
            if (meta.isDamage && meta.tag) item.tag = meta.tag
            if (meta.isDamage) (item as any).__isDamage = true
            out.push(item)
        }
        // 取消/连段（由 skill 模块统一解析动画节点链）
        await skillArtifacts.applySkillTiming(skillEntry, out as Array<Record<string, any>>, {
            skillNodeData,
            animMetaForNode: node => assetReader.animMetaForNode(node),
        })
        return out
    }

    /** 技能列表 */
    async function processSkills(battleWeapon: Record<string, any>, weaponId: number) {
        const weaponSkillList = battleWeapon.WeaponSkillList
        if (!Array.isArray(weaponSkillList) || weaponSkillList.length === 0) return { skills: [], reload: 0, interval: 0 }
        const isRanged = isRangedWeapon(battleWeapon)
        const skills: VNodeTree[] = []
        let reloadValue = 0
        let shootingInterval = 0
        const loopIntervalMap = collectLoopIntervalMap(weaponSkillList, weaponId)
        // 只预取武器声明的根技能；实体链上的其他技能由 getTableItem 懒加载。
        dm.getTableItems("Skill", weaponSkillList)

        for (const skillId of weaponSkillList) {
            const skillInfo = skillData(skillId)
            if (!Array.isArray(skillInfo) || skillInfo.length === 0) continue
            // Lua 形状: skill[skillId][0][grade] — grade 表键 "0"/"1"...，grade 0 是技能条目
            // (对齐 char 处理器 _process_single_skill 的 skill_info[0][0])
            const gradeTable = skillInfo[0]
            const skillEntry = gradeTable && typeof gradeTable === "object" ? (gradeTable["0"] ?? gradeTable[0]) : gradeTable
            if (!skillEntry || typeof skillEntry !== "object") continue

            const skillType = skillEntry.SkillType ?? ""
            const item: Record<string, any> = {
                id: skillId,
                名称: skillType,
            }
            if (skillType === "Reload") {
                const r = await extractReload(skillEntry)
                if (r) reloadValue = Math.max(reloadValue, r)
            }
            if (isRanged && skillType === "Shooting") {
                const candidate =
                    loopIntervalMap.get(weaponId) ?? loopIntervalMap.get(skillId) ?? (await extractShootingInterval(skillEntry))
                if (candidate) shootingInterval = shootingInterval ? Math.min(shootingInterval, candidate) : candidate
            }
            const descKeys = skillEntry.SkillDescKeys
            const hasDescKeys = Array.isArray(descKeys)
                ? descKeys.length > 0
                : !!descKeys && typeof descKeys === "object" && Object.keys(descKeys).length > 0
            if (hasDescKeys) {
                const fields = await processWeaponSkillFields(skillEntry, weaponId)
                if (fields.length > 0) item.字段 = fields
            }
            const creatures = skillArtifacts.extractCreatures(skillId)
            if (creatures && creatures.length > 0) item.实体 = creatures
            skills.push(item)
        }

        // 归一化名称 + 类型
        const rst: VNodeTree[] = []
        for (const skill of skills as Array<Record<string, any>>) {
            const outItem: Record<string, VNodeTree> = {}
            if (skill.id !== undefined) outItem.id = skill.id
            outItem.名称 = TYPE_MAP[String(skill.名称)] ?? skill.名称
            outItem.类型 = "武器伤害"
            if (skill.字段) outItem.字段 = skill.字段
            if (skill.实体) outItem.实体 = skill.实体
            if (skill.字段 || skill.实体) rst.push(outItem)
        }
        return { skills: rst, reload: roundValue(reloadValue), interval: roundValue(shootingInterval) }
    }

    function isRangedWeapon(battleWeapon: Record<string, any>): boolean {
        for (const key of ["MagazineCapacity", "BulletMax", "BulletConver"]) {
            if (battleWeapon[key] !== undefined && battleWeapon[key] !== null) return true
        }
        const tags = Array.isArray(battleWeapon.WeaponTag) ? battleWeapon.WeaponTag : []
        for (const tag of tags) {
            const lower = String(tag).toLowerCase()
            if (lower.includes("range") || lower.includes("shoot") || lower.includes("gun")) return true
        }
        return false
    }

    function collectLoopIntervalMap(weaponSkillList: number[], weaponId: number): Map<number, number> {
        const map = new Map<number, number>()
        const targetIds = new Set(weaponSkillList.map(String))
        targetIds.add(String(weaponId))
        for (const targetId of targetIds) {
            for (const effectId of dm.findTableKeysByTaskField("SkillEffects", "LoopShootId", Number(targetId))) {
                const effect = skillEffectsData(effectId) as Record<string, any> | undefined
                if (!effect || typeof effect !== "object") continue
                for (const task of effect.TaskEffects ?? []) {
                    if (!task || typeof task !== "object") continue
                    if (!["StartLoopShoot", "UpdateLoopShoot"].includes(task.Function)) continue
                    const loopShootId = task.LoopShootId
                    if (!targetIds.has(String(loopShootId))) continue
                    const interval = task.LoopInterval
                    if (typeof interval === "number") {
                        const r = roundValue(interval)
                        const cur = map.get(loopShootId)
                        map.set(loopShootId, cur === undefined ? r : Math.min(cur, r))
                    }
                }
            }
        }
        return map
    }

    async function extractReload(skillEntry: Record<string, any>): Promise<number> {
        const begin = skillEntry.BeginNodeId
        if (!begin) return 0
        let node = skillNodeData(String(begin))
        let steps = 0
        let reload = 0
        while (node && steps < 8) {
            const meta = await assetReader.animMetaForNode(node)
            if (meta.skillEffectLink) reload = Math.max(reload, meta.skillEffectLink)
            node = node.NextNodeId ? skillNodeData(String(node.NextNodeId)) : null
            steps++
        }
        return roundValue(reload)
    }

    async function extractShootingInterval(skillEntry: Record<string, any>): Promise<number> {
        const begin = skillEntry.BeginNodeId
        if (!begin) return 0
        let node = skillNodeData(String(begin))
        let steps = 0
        let interval = 0
        while (node && steps < 8) {
            const meta = await assetReader.animMetaForNode(node)
            interval = Math.max(interval, meta.shootingInterval)
            node = node.NextNodeId ? skillNodeData(String(node.NextNodeId)) : null
            steps++
        }
        return interval
    }

    // ---------- 主输出 ----------
    const items: any[] = []
    const weapons = weaponData()
    for (const [idStr, weapon] of Object.entries(weapons)) {
        if (!weapon || typeof weapon !== "object") continue
        const weaponId = weapon.WeaponId ?? Number(idStr)
        if (typeof weaponId === "number" && weaponId < 1000) continue
        const battleWeapon = getBattleWeapon(weaponId)
        if (!battleWeapon) continue

        const furnace = processFurnace(weaponId, battleWeapon)
        const item: Record<string, any> = {
            id: weaponId,
            icon: String(weapon.Icon ?? "").replace("/Game/UI/Texture/Dynamic/Image/Head/Weapon/T_Head_", ""),
            名称: T(weapon.WeaponName ?? ""),
            版本: processRelease(weapon.ReleaseVersion),
            描述: T(weapon.WeaponDescribe ?? ""),
            类型: processTags(battleWeapon.WeaponTag),
            ...processAttributes(battleWeapon),
            加成: record([...processAddAttr(battleWeapon, false), ...furnace.addon]),
            突破: processBreak(weaponId),
            熔炼: processSmelting(battleWeapon),
        }
        if (furnace.rows.length > 0) item.熔炉 = furnace.rows
        const { skills, reload, interval } = await processSkills(battleWeapon, weaponId)
        item.技能 = skills
        if (reload) item.装填 = reload
        if (interval) item.射击间隔 = interval
        items.push(item)
    }

    // 关闭 uasset server（构建结束回收子进程）
    await assetReader.close()

    return {
        Weapon: items,
    }
}

/** 按老代码规则计算属性值（BattleWeapon 表，level=1）——通过 SkillGrow 表查找 */
function calcAttrByLevelLua(attr: Record<string, any>, ctx: ModuleContext): number | string {
    const value = attr.Rate !== undefined ? attr.Rate : attr.Value
    if (typeof value === "number") {
        const levelGrow = Number(attr.LevelGrow ?? 0)
        return roundValue(value + levelGrow * 0)
    }
    const strVal = String(value ?? 0)
    if (strVal.startsWith("#")) {
        const growIndex = Number(strVal.slice(1))
        const growType = attr.Type ?? "Skill"
        const tableIdStr = String(attr.tableId ?? "")
        const skillGrow = (ctx.dm.getTable("SkillGrow") as Record<string, any>)?.[growType]
        const idData = skillGrow?.[tableIdStr] ?? skillGrow?.[attr.tableId]
        if (Array.isArray(idData) && idData.length > 0) {
            const levelData = idData[0]
            if (Array.isArray(levelData)) {
                for (const entry of levelData) {
                    if (entry && typeof entry === "object" && entry.Index === growIndex) {
                        return roundValue(Number(entry.Value ?? 0))
                    }
                }
            }
        }
        return 0
    }
    return roundValue(Number(strVal ?? 0))
}
