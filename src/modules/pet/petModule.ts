/** Pet module - 魔灵基础信息及支援技能。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { LTemplate, LTemplateValueOrder, T, type VNodeTree } from "../../i18n/vnode.ts"
import { roundValue } from "../skill/skillModule.ts"

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function row(ctx: ModuleContext, name: string, id: unknown): Record<string, any> | undefined {
    const rows = table(ctx, name)
    if (Array.isArray(rows)) {
        const index = Number(id) - 1
        return Number.isInteger(index) && index >= 0 ? (rows[index] as Record<string, any> | undefined) : undefined
    }
    return rows[String(id)] ?? rows[id as number]
}

function skillEntry(ctx: ModuleContext, id: unknown): Record<string, any> | undefined {
    const info = ctx.dm.getTableItem("Skill", Number(id)) as any
    if (!Array.isArray(info) || info.length === 0) return undefined
    const grade = info[0]
    if (!grade || typeof grade !== "object") return undefined
    const entry = grade["0"] ?? grade[0]
    return entry && typeof entry === "object" ? entry : undefined
}

function iconName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const match = value.match(/T_Head_Pet_([^./']+)/)
    return match?.[1] ?? ""
}

function skillValues(ctx: ModuleContext, values: unknown): { values: number[][]; markers: string[] } {
    const source = Array.isArray(values) ? values : []
    const result: number[][] = []
    const markers: string[] = []
    for (const value of source) {
        const percent = typeof value === "string" && value.trimEnd().endsWith("%")
        const levels: number[] = []
        for (let level = 1; level <= 5; level++) {
            let current: number | undefined
            if (typeof value === "number") current = roundValue(value)
            else if (typeof value === "string" && value !== "") {
                const computed = ctx.dm.calcSkillDesc(value, level)
                const match = String(computed).match(/-?\d+(?:\.\d+)?/)
                if (match) {
                    const numeric = Number(match[0])
                    if (Number.isFinite(numeric)) current = roundValue(percent ? numeric / 100 : numeric)
                }
            }
            if (current !== undefined) levels.push(current)
        }
        result.push(levels)
        markers.push(percent ? "{%}" : "{}")
    }
    return { values: result, markers }
}

function activeSkill(ctx: ModuleContext, skillId: number): Record<string, VNodeTree> | undefined {
    const skill = skillEntry(ctx, skillId)
    if (!skill?.SkillDesc) return undefined
    const computed = skillValues(ctx, skill.SkillDescValues)
    const output: Record<string, VNodeTree> = {
        id: skill.SkillId ?? skillId,
        描述: LTemplate(String(skill.SkillDesc), computed.markers),
        值: LTemplateValueOrder(String(skill.SkillDesc), computed.values),
    }
    if (skill.CD) output.cd = skill.CD
    return output
}

function passiveSkill(ctx: ModuleContext, battlePet: Record<string, any>): Record<string, VNodeTree> | undefined {
    if (!battlePet.PassiveEffectDesc) return undefined
    const computed = skillValues(ctx, battlePet.PassiveEffectDescParameter)
    return {
        描述: LTemplate(String(battlePet.PassiveEffectDesc), computed.markers),
        值: LTemplateValueOrder(String(battlePet.PassiveEffectDesc), computed.values),
    }
}

export function petModule(ctx: ModuleContext): VNodeTree {
    const pets = table(ctx, "Pet")
    const result: VNodeTree[] = []
    for (const item of Object.values(pets)) {
        if (!item || typeof item !== "object") continue
        const pet = item as Record<string, any>
        const id = Number(pet.UnitId ?? 0)
        if (!id) continue
        const output: Record<string, VNodeTree> = {
            id,
            ...(pet.GUID ? { uid: pet.GUID } : {}),
            名称: T(pet.Name ?? ""),
            描述: T(pet.IpDes ?? ""),
            icon: iconName(pet.Icon),
            异化: pet.PremiumTransform ?? 0,
            品质: pet.Rarity ?? 0,
            类型: pet.PetType ?? 0,
            最大等级: pet.PetMaxLevel ?? 0,
            捕获经验: pet.CollectRewardExp ?? 0,
            经验: pet.PetExp ?? 0,
        }
        if (!pet.PremiumTransform) delete output.异化

        const battle = row(ctx, "BattlePet", pet.BattlePetId ?? 0)
        if (battle) {
            const active = Number(battle.SupportSkillId ?? 0)
            if (active) {
                const skill = activeSkill(ctx, active)
                if (skill) output.主动 = skill
            }
            const passive = passiveSkill(ctx, battle)
            if (passive) output.被动 = passive
        }
        result.push(output)
    }
    result.sort((a, b) => Number((a as Record<string, any>).id) - Number((b as Record<string, any>).id))
    return result
}
