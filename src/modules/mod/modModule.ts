/** Mod module - mod cards, attributes, passive descriptions and skill replacements. */

import type { ModuleContext } from "../../core/Graph.ts"
import { compile, LTemplateColumns, record, T, TMap, TReplace, type VNode, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
import type { SkillArtifacts } from "../skill/skillModule.ts"
import { P_MAP, roundValue, weaponSkillName } from "../skill/skillModule.ts"
import { WEAPON_TYPE_CN } from "../weapon/weaponModule.ts"

type Row = Record<string, any>

const QUALITY = ["白", "绿", "蓝", "紫", "金"]
const POLARITY = ["", "A", "D", "V", "O"]
function table(ctx: ModuleContext, name: string): Row {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : {}
}

/**
 * 架势 mod（id>100000 非角色）的武器限定：ModActivateSkills 被替换旧技能 →
 * 反查 BattleWeapon.WeaponSkillList 归属武器 → 取其专属类型（单手剑/长柄/……）。
 * 归属武器的专属类型必须一致（现状一致）且至少命中一把，否则返回 undefined
 * （下游“改变X的”老口径继续兜底）。TaskEffects/稀疏表两种形态都按 sequence 归一。
 */
function stanceWeaponLimit(mod: Row, cache: Map<string, string[]>): string | undefined {
    const activates = mod.ModActivateSkills
    if (!activates || typeof activates !== "object") return undefined
    const labels = new Set<string>()
    let hit = false
    for (const skillId of Object.keys(activates)) {
        const owners = cache.get(String(skillId))
        if (!owners) continue
        hit = true
        for (const label of owners) labels.add(label)
    }
    if (!hit || labels.size !== 1) return undefined
    return [...labels][0]
}

/** 技能 id → 归属武器的专属类型表（首访建索引，复用 LuaDataManager 表缓存）。 */
function skillWeaponIndex(ctx: ModuleContext): Map<string, string[]> {
    const index = new Map<string, string[]>()
    const battleWeapons = (ctx.dm.getTable("BattleWeapon") as Record<string, any>) || {}
    for (const weapon of Object.values(battleWeapons)) {
        if (!weapon || typeof weapon !== "object") continue
        const tags = Array.isArray(weapon.WeaponTag) ? weapon.WeaponTag : []
        const label = tags.map((tag: unknown) => WEAPON_TYPE_CN[String(tag)]).find((name: unknown): name is string => !!name)
        if (!label) continue
        for (const skillId of sequence(weapon.WeaponSkillList)) {
            if (skillId === null || skillId === undefined || skillId === "") continue
            const list = index.get(String(skillId)) ?? []
            list.push(label)
            index.set(String(skillId), list)
        }
    }
    return index
}

function sequence(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return value === undefined || value === null || value === "" ? [] : [value]
    return Object.entries(value as Row)
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, v]) => v)
}

function release(value: unknown): string {
    const n = Number(value) || 0
    return n ? `${Math.floor(n / 100)}.${Math.floor((n % 100) / 10)}` : ""
}

function attrConfigKey(attr: Row, config: Row): string {
    const name = String(attr.AttrName ?? "")
    if (!name) return ""
    if (name === "DamageRate" || name === "DamagedRate") {
        const tag = attr.IndividualRateZone ? "NoTag" : (attr.DamageTag ?? attr.Tag)
        const zone = attr.RateZone
        if (tag || zone) {
            const specific = `${name}_${tag ?? "NoTag"}_${zone ?? "Normal"}`
            if (config[specific]) return specific
            const zoned = `${name}_${zone ?? "Normal"}`
            if (config[zoned]) return zoned
        }
    }
    if (config[name]) return name
    if (config[`${name}_Normal`]) return `${name}_Normal`
    return name
}

/**
 * 某条 AddAttr 在 0~满级的逐级取值（CalcModAttrByLevel 语义：纯数字恒定，#N 查 SkillGrow）。
 */
function curveValues(ctx: ModuleContext, modId: number, attrIndex: number, maxLevel: number): number[] {
    const curve: number[] = []
    for (let lv = 0; lv <= maxLevel; lv++) curve.push(ctx.dm.calcModAttr(modId, lv, attrIndex))
    return curve
}

/** 全相等即常数项（策划定值，无升级成长）。 */
function allEqual(curve: number[]): boolean {
    return curve.every(value => value === curve[0])
}

/**
 * 等比（过原点）即线性：末级为 max 时各级应为 max*(lv+1)/(L+1)。
 * 半个舍入单位（0.005）内的偏差视为策划两位小数舍入噪声；超出则为真正的非线性曲线。
 */
function isProportional(curve: number[], maxLevel: number): boolean {
    const max = curve[maxLevel]
    for (let lv = 0; lv <= maxLevel; lv++) {
        if (Math.abs(curve[lv] - (max * (lv + 1)) / (maxLevel + 1)) > 0.005 + 1e-9) return false
    }
    return true
}

/** DescValue 满级计算串 → 数值（百分数除 100），解析失败返回 undefined。 */
function descMaxNumber(ctx: ModuleContext, dv: string, modId: number, level: number): number | undefined {
    const text = ctx.dm.calcModDescValue(dv, modId, level)
    const num = Number(text.match(/-?\d+(?:\.\d+)?/)?.[0] ?? NaN)
    if (!Number.isFinite(num)) return undefined
    // Lua 算串可能带浮点尘（如 89.0999%），按 roundValue 修约到 4 位小数
    return roundValue(/%\s*$/.test(text) ? num / 100 : num)
}

/** “X提高#N”子句 → 属性名（最长命中优先，如“召唤物造成的伤害”优先于“造成的伤害”）。 */
const VALUE_ATTR_PHRASES: Record<string, string> = {
    召唤物造成的伤害: "召唤物伤害",
    暗属性追加伤害: "追加伤害",
    追加伤害: "追加伤害",
    暴击伤害: "暴伤",
    暴击率: "暴击",
    造成的伤害: "增伤",
    技能威力: "技能威力",
    昂扬: "昂扬",
    背水: "背水",
    攻击: "攻击",
}

function mapValueAttr(clause: string): string | undefined {
    const hits = Object.keys(VALUE_ATTR_PHRASES).filter(phrase => clause.includes(phrase))
    if (hits.length === 0) return undefined
    hits.sort((a, b) => b.length - a.length)
    return VALUE_ATTR_PHRASES[hits[0]]
}

/** “X大于等于N%时”的条件属性映射（最大神智在前端口径里叫神智）。 */
const CONDITION_ATTRS: Record<string, string> = {
    昂扬: "昂扬",
    技能耐久: "技能耐久",
    技能效益: "技能效益",
    技能威力: "技能威力",
    充盈威力: "充盈威力",
    技能范围: "技能范围",
    最大神智: "神智",
}

/** 锋芒系列的武器名（“每装备1把X”），闭集，超出则不建规则。 */
const FENGHUANG_WEAPONS = new Set(["单手剑", "长柄", "重剑", "双刀", "鞭刃", "太刀", "手枪", "双枪", "榴炮", "霰弹枪", "突击枪", "弓"])

/**
 * 被动效果派生的条件数值（生效对象，供消费侧条件机制读取，顶层输出）。
 *
 * 四类模板（互斥，先后为趋向/锋芒/倍率/阈值）：
 * - 趋向套装：“仅当装备X趋向…大于等于N个”→[[X趋向,>=,N]]，“各不相同”→[[*id,<=,1]]；
 *   纯条件模板将其加成数值整体移入生效（最大耐受除外，取满级标量，与旧 patch 一致），
 *   带取值子句的（如 41725）只取末列值；
 * - 锋芒：“每装备1把X”→[[X,*]] + 增伤[末#1,末#2]；
 * - 倍率：“倍率为自身S的#1，最大不超过#2”→[[S,*]] + 攻击[末#1,末#2]；
 * - 阈值：“X大于等于N[%]时”→条件 + 子句属性末列值（属性名最长匹配）。
 * 返回 { effect, remove }：remove 为需从加成剔除的键（旧 patch 合并的 delete 语义）。
 * 不匹配返回 undefined。
 */
function passiveConditionalFields(
    ctx: ModuleContext,
    mod: Row,
    modId: number,
    level: number,
    bonus: Array<[VNode, VNodeTree]>
): { effect: Row; remove: Set<string> } | undefined {
    if (!mod.PassiveEffectsDesc) return undefined
    const template = ctx.textmap.get(String(mod.PassiveEffectsDesc), "cn")
    const dvs = sequence(mod.DescValues).filter((dv): dv is string => typeof dv === "string")
    const dvNum = (n: number): number | undefined => {
        const dv = dvs[n - 1]
        return dv === undefined ? undefined : descMaxNumber(ctx, dv, modId, level)
    }
    const dvLetter = (n: number): string | undefined => {
        const dv = dvs[n - 1]
        if (dv === undefined) return undefined
        return ctx.dm.calcModDescValue(dv, modId, level).trim()
    }
    const maxScalar = (value: unknown): number | undefined => {
        if (typeof value === "number") return value
        if (Array.isArray(value) && value.length > 0) {
            const last = value[value.length - 1]
            return typeof last === "number" ? last : undefined
        }
        return undefined
    }
    const trendM = template.match(/仅当装备(?:<Polarity>#(\d+)<\/>|([DOVA]))趋向的魔之楔大于等于(\d+)个时/)
    const uniqueM = !trendM && /仅当装备的魔之楔各不相同时/.test(template)
    if (trendM || uniqueM) {
        // 趋向字母：字面量或 <Polarity>#N</> 占位求值（GetModPolarity，恒为 D/O/A/V 单字）
        const trendLetter = trendM ? (trendM[2] ?? dvLetter(Number(trendM[1]))) : undefined
        if (trendM && !/^[DOVA]$/.test(trendLetter ?? "")) return undefined
        const condition = trendM ? [[`${trendLetter}趋向`, ">=", Number(trendM[3])]] : [["*id", "<=", 1]]
        const effect: Row = { 条件: condition }
        const remove = new Set<string>()
        // 高亮占位剥离后找取值子句：纯条件模板无剩余 #N，41725 类取子句占位编号
        const rest = template.replace(/<Polarity>#\d+<\/>/g, "")
        const clause = rest.split("，").find(part => /#\d/.test(part))
        const n = clause ? Number(clause.match(/#(\d+)/)?.[1] ?? NaN) : NaN
        if (clause && Number.isFinite(n)) {
            const attr = mapValueAttr(clause)
            const value = dvNum(n)
            if (!attr || value === undefined) return undefined
            effect[attr] = value
            remove.add(attr)
        } else {
            for (const [key, value] of bonus) {
                const name = String(key)
                if (name === "最大耐受") continue
                const scalar = maxScalar(value)
                if (scalar === undefined) continue
                effect[name] = scalar
                remove.add(name)
            }
        }
        return { effect, remove }
    }
    const feng = template.match(/每装备1把(.+?)，/)
    if (feng && FENGHUANG_WEAPONS.has(feng[1]) && dvs.length >= 2) {
        const v1 = dvNum(1)
        const v2 = dvNum(2)
        if (v1 === undefined || v2 === undefined) return undefined
        return { effect: { 条件: [[feng[1], "*"]], 增伤: [v1, v2] }, remove: new Set(["增伤"]) }
    }
    const mult = template.match(/倍率为自身(.+?)的#1，最大不超过#2/)
    if (mult && dvs.length >= 2) {
        const v1 = dvNum(1)
        const v2 = dvNum(2)
        if (v1 === undefined || v2 === undefined) return undefined
        return { effect: { 条件: [[mult[1], "*"]], 攻击: [v1, v2] }, remove: new Set(["攻击"]) }
    }
    // 阈值：阈值本身也是占位符（CompareBase 列），取值用时之后子句的占位编号
    const th = template.match(/(.+?)大于等于#(\d+).*?时/)
    if (th && dvs.length > 0) {
        const condAttr = CONDITION_ATTRS[th[1].replace(/<[^>]*>/g, "").trim()]
        const threshold = dvNum(Number(th[2]))
        if (!condAttr || threshold === undefined) return undefined
        const afterT = template.split("时").slice(1).join("时")
        const clause = afterT.split("，").find(part => /#\d/.test(part)) ?? afterT
        const attr = mapValueAttr(clause)
        const n = Number(clause.match(/#(\d+)/)?.[1] ?? NaN)
        const value = Number.isFinite(n) ? dvNum(n) : undefined
        if (!attr || value === undefined) return undefined
        return { effect: { 条件: [[condAttr, ">=", threshold]], [attr]: value }, remove: new Set([attr]) }
    }
    return undefined
}

/**
 * 被动效果派生的无条件数值字段（调用方并入加成，与 AddAttrs 同一数组/标量语义）。
 *
 * 只覆盖白名单文案，且模板含条件标记（大于等于/仅当/每装备1把/倍率为）时整单跳过——
 * 条件值归消费侧生效机制，本函数只产出满级标量。取值一律按占位符编号取对应 DescValue
 * 的满级计算串（51727 取的是 #2），百分数除 100。与加成已有键冲突时以加成为准。
 */
function passiveExtraFields(ctx: ModuleContext, mod: Row, modId: number, level: number, bonusNames: Set<string>): Row {
    const out: Row = {}
    if (!mod.PassiveEffectsDesc) return out
    const template = ctx.textmap.get(String(mod.PassiveEffectsDesc), "cn")
    if (/大于等于|仅当|每装备1把|倍率为/.test(template)) return out
    const dvs = sequence(mod.DescValues).filter((dv): dv is string => typeof dv === "string")
    if (dvs.length === 0) return out
    const dvValue = (n: number): number | undefined => {
        const dv = dvs[n - 1]
        return dv === undefined ? undefined : descMaxNumber(ctx, dv, modId, level)
    }
    const set = (key: string, value: number | undefined) => {
        if (value === undefined || !Number.isFinite(value) || bonusNames.has(key) || key in out) return
        out[key] = value
    }
    // 独立增伤：降低#N（独立），降低在文本里，取值本身为正数故取反
    const independent = template.match(/降低#(\d)[^。]*?（独立）/)
    if (independent) {
        const value = dvValue(Number(independent[1]))
        if (value !== undefined) set("独立增伤", -Math.abs(value))
        return out
    }
    const placeholderOf = (re: RegExp): number | undefined => {
        const match = template.match(re)
        return match ? Number(match[1]) : undefined
    }
    const trigger = placeholderOf(/#(\d+)[^#。]*触发属性额外效果/)
    if (trigger !== undefined) set("技能触发", dvValue(trigger))
    const imbalance = placeholderOf(/受到的伤害提高效果量提高#(\d+)/)
    if (imbalance !== undefined && template.includes("战姿失衡")) set("失衡易伤", dvValue(imbalance))
    const recover = placeholderOf(/自身及队友[^。]*?回复#(\d+)点神智/)
    if (recover !== undefined) set("神智回复", dvValue(recover))
    const speed = placeholderOf(/攻击速度#(\d+)/)
    const range = placeholderOf(/技能范围#(\d+)/)
    if (speed !== undefined && range !== undefined) {
        set("召唤物攻击速度转化", dvValue(speed))
        set("召唤物范围转化", dvValue(range))
    }
    const summon = placeholderOf(/自身召唤物造成的伤害提高#(\d+)/)
    if (summon !== undefined) set("召唤物伤害", dvValue(summon))
    else {
        // 全队无条件增伤（41415 家族）；秽兽/爆炸/按敌人数量等情境加成不归一化，避免 double count
        const damage = placeholderOf(/自身及队友造成的伤害提高#(\d+)/)
        if (damage !== undefined) set("增伤", dvValue(damage))
    }
    return out
}

/**
 * 被动效果：模板（保留 #N 占位符）+ 每个占位符的逐级填充值。
 *
 * 形如 ["受到伤害降低#1。...", ["4.0%",...], ["2.0%",...]]，第 i 个数组对应模板中的 #i
 * （与 ArmoryUtils.GenModPassiveEffectDesc 逐条 gsub("#" .. i) 的索引语义一致）。
 * 等级上限为 MaxLevel + ModCardLevelMax（卡牌等级额外叠加）。
 */
function passiveDescription(ctx: ModuleContext, mod: Row, modId: number, level: number): VNodeTree | undefined {
    if (!mod.PassiveEffectsDesc) return undefined
    const values = sequence(mod.DescValues)
    const columns: VNode[][] = []
    for (const value of values) {
        if (typeof value !== "string") continue
        const perLevel: VNode[] = []
        for (let lv = 1; lv <= level; lv++) {
            perLevel.push(compile(ctx.dm.calcModDescValue(value, modId, lv)))
        }
        columns.push(perLevel)
    }
    return LTemplateColumns(String(mod.PassiveEffectsDesc), columns, true)
}

function skillEntry(ctx: ModuleContext, id: number): Row | undefined {
    const value = ctx.dm.getTableItem("Skill", id) as any
    const first = value?.[0]
    if (!first || typeof first !== "object") return undefined
    return (first[0] ?? first["0"] ?? first) as Row
}

function skillDisplayName(id: number, entry: Row | undefined): VNodeTree {
    if (entry?.SkillName) return T(entry.SkillName)
    const name = weaponSkillName(entry?.SkillType)
    return name === "" ? String(id) : name
}

/**
 * 收集技能节点链上的伤害任务引用（1-based 任务序号）。
 *
 * 仅用于新技能缺 `SkillDescKeys` 的合成兜底（如 Skill[1030302] 的 RT_143 无描述键，
 * 伤害在 SkillNode[1030321] → SkillEffects[1030321] 的 Damage 任务里）。跟随 NextNodeId，
 * 上限 32 步并去重防环；TaskEffects 支持数组/稀疏数字键两种形态。
 */
function collectChainDamageRefs(ctx: ModuleContext, entry: Row): Array<{ effectId: number; taskIndex: number }> {
    const refs: Array<{ effectId: number; taskIndex: number }> = []
    const seenNodes = new Set<number>()
    let current = entry?.BeginNodeId
    let steps = 0
    while (current !== null && current !== undefined && current !== "" && !seenNodes.has(Number(current)) && steps < 32) {
        seenNodes.add(Number(current))
        steps++
        const raw = ctx.dm.getTableItem("SkillNode", current as number) as Row | undefined
        const node = (Array.isArray(raw) ? ((raw[0] as Row | undefined) ?? undefined) : raw) as Row | undefined
        if (!node || typeof node !== "object") break
        const effectIds = sequence(node.SkillNodeEffects)
        for (const effectId of effectIds) {
            const effectIdNum = Number(effectId)
            if (!Number.isFinite(effectIdNum)) continue
            const effect = ctx.dm.getTableItem("SkillEffects", effectIdNum) as Row | undefined
            if (!effect || typeof effect !== "object") continue
            const tasks = effect.TaskEffects
            const entries: Array<[number, Row]> = Array.isArray(tasks)
                ? tasks.map((task, index) => [index + 1, task as Row])
                : Object.entries((tasks ?? {}) as Row)
                      .filter(([key]) => /^\d+$/.test(key))
                      .sort(([a], [b]) => Number(a) - Number(b))
                      .map(([key, task]) => [Number(key), task as Row])
            for (const [taskIndex, task] of entries) {
                if (!task || typeof task !== "object" || task.Function !== "Damage") continue
                if (task.Rate === null || task.Rate === undefined) continue
                refs.push({ effectId: effectIdNum, taskIndex })
            }
        }
        current = (node as Row).NextNodeId
    }
    return refs
}

/**
 * 无描述键替换技能的字段合成：名称按顺序复用被替换旧技能的 DescKey（超出时复用最后一个），
 * 数值表达式按新技能节点链上的 `$#SkillEffects[E].TaskEffects[I].Rate*100$%` 构造，复用
 * `parseWeaponLikeSkillField` 做值/格式/削韧/tag/延迟/卡肉解析。旧技能亦无 DescKey 时返回空，
 * 不凭空发明名称；多段连击的 `×N` 后缀只来自 authored DescValues，合成不补。
 */
function synthesizeReplacementFields(
    ctx: ModuleContext,
    skill: SkillArtifacts,
    oldIdNum: number,
    newId: number,
    entry: Row
): Array<Record<string, any>> {
    const oldKeys = sequence(skillEntry(ctx, oldIdNum)?.SkillDescKeys).filter((key): key is string => typeof key === "string")
    if (oldKeys.length === 0) return []
    const refs = collectChainDamageRefs(ctx, entry)
    if (refs.length === 0) return []
    const fields: Array<Record<string, any>> = []
    for (let i = 0; i < refs.length; i++) {
        const descKey = oldKeys[i] ?? oldKeys[oldKeys.length - 1]
        const descValue = `$#SkillEffects[${refs[i].effectId}].TaskEffects[${refs[i].taskIndex}].Rate*100$%`
        fields.push(skill.parseWeaponLikeSkillField(descKey, descValue, newId, entry) as Record<string, any>)
    }
    return fields
}

async function skillReplacements(ctx: ModuleContext, mod: Row, skill: SkillArtifacts, assetReader: AssetReader): Promise<Row | undefined> {
    if (!mod.ModActivateSkills || typeof mod.ModActivateSkills !== "object") return undefined
    const out: Row = {}
    for (const [oldId, newIdValue] of Object.entries(mod.ModActivateSkills)) {
        const oldIdNum = Number(oldId)
        const newId = Number(newIdValue)
        const entry = skillEntry(ctx, newId)
        if (!entry) continue
        const fields: Array<Record<string, any>> = []
        const keys = sequence(entry.SkillDescKeys)
        const values = sequence(entry.SkillDescValues)
        for (let i = 0; i < Math.min(keys.length, values.length); i++) {
            if (typeof keys[i] !== "string" || typeof values[i] !== "string") continue
            fields.push(skill.parseWeaponLikeSkillField(String(keys[i]), String(values[i]), newId, entry))
        }
        if (fields.length === 0) fields.push(...synthesizeReplacementFields(ctx, skill, oldIdNum, newId, entry))
        await skill.applySkillTiming(entry, fields, {
            skillNodeData: nodeId => {
                const node = ctx.dm.getTableItem("SkillNode", nodeId) as Row | undefined
                return node && typeof node === "object" ? node : undefined
            },
            animMetaForNode: node => assetReader.animMetaForNode(node),
        })
        const replacement: Row = { id: newId, 名称: skillDisplayName(oldIdNum, skillEntry(ctx, oldIdNum)), 类型: "武器伤害" }
        if (fields.length > 0) replacement.字段 = fields
        out[oldId] = replacement
    }
    return Object.keys(out).length > 0 ? out : undefined
}

export async function modModule(ctx: ModuleContext): Promise<VNodeTree> {
    const skill = ctx.getArtifact<SkillArtifacts>("Skill")!
    const assetReader = new AssetReader(ctx.dm.root, true, true)
    await assetReader.ensureServer()
    const config = table(ctx, "AttrConfig")
    const tags = table(ctx, "ModTag")
    const mods = table(ctx, "Mod")
    // 技能 → 归属武器专属类型索引（架势限定时首访构建，复用 Lua 表缓存）
    let weaponIndex: Map<string, string[]> | undefined
    const result: VNodeTree[] = []
    for (const [idText, mod] of Object.entries(mods)) {
        if (!mod || typeof mod !== "object") continue
        const id = Number(mod.Id ?? idText)
        if (id < 100 || id > 999999) continue
        const level = Number(mod.MaxLevel ?? 0) + Number(mod.ModCardLevelMax ?? 0)
        const tag = tags[String(mod.ApplicationType)] ?? tags[mod.ApplicationType]
        const typeKey = String(sequence(tag?.ModTagText)[0] ?? "")
        const output: Row = {
            id,
            icon: String(mod.Icon ?? "")
                .replace("/Game/UI/Texture/Dynamic/Atlas/Prop/Mod/T_Mod_", "")
                .split(".")[0],
            名称: T(String(mod.Name ?? "").replace("【待包装】", "")),
            版本: release(mod.ReleaseVersion ?? 100),
            系列: TReplace(String(mod.TypeName ?? ""), "之", ""),
            品质: QUALITY[Math.max(0, Math.min(QUALITY.length - 1, Number(mod.Rarity ?? 1) - 1))],
        }
        const polarity = POLARITY[Math.max(0, Math.min(POLARITY.length - 1, Number(mod.Polarity ?? -1)))]
        if (polarity) output.极性 = polarity
        const attrKey = String(sequence(tag?.ModTagText)[1] ?? "")
        if (attrKey) output.属性 = TReplace(attrKey, "属性", "")
        const tolerance = Number(mod.Cost ?? 0) + level * Number(mod.CostChange ?? 1)
        output.耐受 = tolerance
        output.类型 = TMap(typeKey, P_MAP)
        // 角色专属魔之楔（坐骑/魔灵类，ApplicationType 即角色 id）：限定只认角色槽
        if (Number(mod.ApplicationType ?? 0) >= 1000) output.限定 = Number(mod.ApplicationType)
        if (mod.CardLevelNeedModId) output.消耗 = mod.CardLevelNeedModId
        // 属性数值收拢进加成记录（对齐 weapon.加成，不再平铺顶层）；效果保持参数化模板（对齐 weapon.熔炼）
        const bonus: Array<[VNode, VNodeTree]> = []
        for (const [attrIndex, attr] of sequence(mod.AddAttrs).entries()) {
            const attrRow = attr as Row
            if (!attrRow || typeof attrRow !== "object" || !attrRow.AttrName) continue
            const cfg = config[attrConfigKey(attrRow, config)] ?? {}
            let name = cfg.Name ? ctx.textmap.get(String(cfg.Name), "cn") : String(attrRow.AttrName)
            if (String(attrRow.AttrName).startsWith("BonusDamage_")) name = "追加伤害"
            if (["切割攻击", "贯穿攻击", "震荡攻击"].includes(name)) output.限定 = name.slice(0, 2)
            name = P_MAP[name] ?? name
            const finalName = name === "受到的伤害" ? "减伤" : name
            // 升级曲线：0~满级逐级取值（与满级标量走同一换算：减伤翻转取正、攻击范围 /100）。
            // 常数项对齐老规则直接导出 [v] 单元素数组；等比（过原点、半个舍入单位容差）即线性，
            // 下游按 max*(lv+1)/(L+1) 还原线性项；数组（常数 [v] 或整列）按等级取项，超长取末项。
            const curve = curveValues(ctx, id, attrIndex + 1, level).map(
                value => (name === "攻击范围" ? value / 100 : value) * (name === "受到的伤害" ? -1 : 1)
            )
            const value = curve[level]
            if (allEqual(curve)) bonus.push([finalName, [value]])
            else if (isProportional(curve, level)) bonus.push([finalName, value])
            else bonus.push([finalName, curve])
        }
        // 光环类魔之楔（AddCharModCost）：按 Mod:CalcExtralCharVolume(满级耐受) 补最大耐受
        if (mod.AddCharModCost) {
            const costName = ctx.textmap.get("UI_Mod_CostIncrease", "cn")
            bonus.push([P_MAP[costName] ?? costName, Math.floor(tolerance * Number(mod.AddCharModCost))])
        }
        // 被动效果派生的无条件数值：并入加成（与 AddAttrs 同一数组/标量语义，随等级缩放）
        const bonusNames = new Set(bonus.map(([key]) => String(key)))
        for (const [key, value] of Object.entries(passiveExtraFields(ctx, mod, id, level, bonusNames))) {
            bonus.push([key, value])
        }
        // 被动效果派生的条件数值：生效对象顶层输出，加成内同名项剔除（旧 patch 合并语义）
        const conditional = passiveConditionalFields(ctx, mod, id, level, bonus)
        if (conditional) {
            for (let i = bonus.length - 1; i >= 0; i--) {
                if (conditional.remove.has(String(bonus[i][0]))) bonus.splice(i, 1)
            }
        }
        if (bonus.length > 0) output.加成 = record(bonus)
        // 架势 mod（id>100000 非角色）：被替换技能反查武器定限定；角色/已有下限定时跳过
        // （类型判定与输出渲染同口径：TMap(typeKey, P_MAP) 的中文结果）
        if (id > 100000 && output.限定 == null) {
            const typeText = ctx.textmap.get(typeKey, "cn")
            if ((P_MAP[typeText] ?? typeText) !== "角色") {
                weaponIndex ??= skillWeaponIndex(ctx)
                const limit = stanceWeaponLimit(mod, weaponIndex)
                if (limit) output.限定 = limit
            }
        }
        const desc = passiveDescription(ctx, mod, id, level)
        if (desc) output.效果 = desc
        const replacements = await skillReplacements(ctx, mod, skill, assetReader)
        if (replacements) output.技能替换 = replacements
        if (conditional) output.生效 = conditional.effect
        result.push(output)
    }
    result.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    await assetReader.close()
    return result
}
