/** Mod module - mod cards, attributes, passive descriptions and skill replacements. */

import type { ModuleContext } from "../../core/Graph.ts"
import { compile, LTemplate, T, type VNode, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
import type { SkillArtifacts } from "../skill/skillModule.ts"
import { P_MAP } from "../skill/skillModule.ts"

type Row = Record<string, any>

const QUALITY = ["白", "绿", "蓝", "紫", "金"]
const POLARITY = ["", "A", "D", "V", "O"]
const TYPE_MAP: Record<string, string> = {
    Shooting: "射击",
    Attack: "普通攻击",
    HeavyAttack: "蓄力攻击",
    FallAttack: "下落攻击",
    SlideAttack: "滑行攻击",
}

function table(ctx: ModuleContext, name: string): Row {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : {}
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

function passiveDescription(ctx: ModuleContext, mod: Row, modId: number, level: number): VNodeTree | undefined {
    if (!mod.PassiveEffectsDesc) return undefined
    const values = sequence(mod.DescValues)
    const rendered: VNode[] = []
    for (const value of values) {
        if (typeof value !== "string") continue
        const computed = ctx.dm.calcModDescValue(value, modId, level)
        rendered.push(compile(computed))
    }
    return LTemplate(String(mod.PassiveEffectsDesc), rendered, true)
}

function skillEntry(ctx: ModuleContext, id: number): Row | undefined {
    const value = ctx.dm.getTableItem("Skill", id) as any
    const first = value?.[0]
    if (!first || typeof first !== "object") return undefined
    return (first[0] ?? first["0"] ?? first) as Row
}

function skillDisplayName(id: number, entry: Row | undefined): VNodeTree {
    if (entry?.SkillName) return T(entry.SkillName)
    return TYPE_MAP[String(entry?.SkillType ?? "")] ?? String(id)
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
    const result: VNodeTree[] = []
    for (const [idText, mod] of Object.entries(mods)) {
        if (!mod || typeof mod !== "object") continue
        const id = Number(mod.Id ?? idText)
        if (id < 100 || id > 999999) continue
        const level = Number(mod.MaxLevel ?? 0) + Number(mod.ModCardLevelMax ?? 0)
        const tag = tags[String(mod.ApplicationType)] ?? tags[mod.ApplicationType]
        const tagTexts = sequence(tag?.ModTagText).map(value => ctx.textmap.get(String(value), "cn"))
        const type = P_MAP[String(tagTexts[0] ?? "")] ?? String(tagTexts[0] ?? "")
        const output: Row = {
            id,
            icon: String(mod.Icon ?? "")
                .replace("/Game/UI/Texture/Dynamic/Atlas/Prop/Mod/T_Mod_", "")
                .split(".")[0],
            名称: T(String(mod.Name ?? "").replace("【待包装】", "")),
            版本: release(mod.ReleaseVersion ?? 100),
            系列: String(ctx.textmap.get(String(mod.TypeName ?? ""), "cn")).replace("之", ""),
            品质: QUALITY[Math.max(0, Math.min(QUALITY.length - 1, Number(mod.Rarity ?? 1) - 1))],
        }
        const polarity = POLARITY[Math.max(0, Math.min(POLARITY.length - 1, Number(mod.Polarity ?? -1)))]
        if (polarity) output.极性 = polarity
        if (tagTexts.length >= 2) output.属性 = String(tagTexts[1]).replace("属性", "").trim()
        output.耐受 = Number(mod.Cost ?? 0) + level * Number(mod.CostChange ?? 1)
        output.类型 = type
        if (mod.CardLevelNeedModId) output.消耗 = mod.CardLevelNeedModId
        for (const [attrIndex, attr] of sequence(mod.AddAttrs).entries()) {
            const attrRow = attr as Row
            if (!attrRow || typeof attrRow !== "object" || !attrRow.AttrName) continue
            const cfg = config[attrConfigKey(attrRow, config)] ?? {}
            let name = cfg.Name ? ctx.textmap.get(String(cfg.Name), "cn") : String(attrRow.AttrName)
            if (String(attrRow.AttrName).startsWith("BonusDamage_")) name = "追加伤害"
            if (["切割攻击", "贯穿攻击", "震荡攻击"].includes(name)) output.限定 = name.slice(0, 2)
            name = P_MAP[name] ?? name
            let value = ctx.dm.calcModAttr(id, level, attrIndex + 1)
            if (name === "攻击范围") value = value / 100
            output[name === "受到的伤害" ? "减伤" : name] = name === "受到的伤害" ? -value : value
        }
        const desc = passiveDescription(ctx, mod, id, level)
        if (desc) output.效果 = desc
        const replacements = await skillReplacements(ctx, mod, skill, assetReader)
        if (replacements) output.技能替换 = replacements
        result.push(output)
    }
    result.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    await assetReader.close()
    return result
}
