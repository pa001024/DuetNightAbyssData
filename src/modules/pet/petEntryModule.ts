/** PetEntry module - 魔灵词条。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { LTemplate, T, type VNodeTree } from "../../i18n/vnode.ts"

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function rows(ctx: ModuleContext, name: string): Record<string, any>[] {
    return Object.values(table(ctx, name)).filter(v => v && typeof v === "object") as Record<string, any>[]
}

function iconName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const base = value.replaceAll("\\", "/").split("/").pop() ?? ""
    return (base.split(".", 1)[0] ?? "").replace(/^T_Armory_Pet_Attr_/, "").replace(/^'+|'+$/g, "")
}

function formatValue(value: string): string {
    const match = value.match(/^(-?\d+(?:\.\d+)?)(.*)$/)
    if (!match) return value
    const rounded = Math.round(Number(match[1]) * 10000) / 10000
    return `${rounded}${match[2]}`
}

export function petEntryModule(ctx: ModuleContext): VNodeTree {
    const battlePets = table(ctx, "BattlePet")
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "PetEntry")) {
        const id = Number(item.PetEntryID ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = {
            id,
            bid: item.BattlePetID ?? 0,
            icon: iconName(item.Icon),
            name: T(item.PetEntryName ?? ""),
            r: item.Rarity ?? 0,
            upid: item.PetEntryUPID ?? 0,
        }
        const battlePet = battlePets[String(item.BattlePetID)] ?? battlePets[item.BattlePetID]
        const descKey = battlePet?.PassiveEffectDesc
        const params = Array.isArray(battlePet?.PassiveEffectDescParameter)
            ? battlePet.PassiveEffectDescParameter.filter((value: unknown): value is string => typeof value === "string").map(
                  (value: string) => formatValue(ctx.dm.calcSkillDesc(value, Number(item.BattlePetLevel ?? 1)))
              )
            : []
        if (descKey) row.desc = LTemplate(String(descKey), params)
        for (const key of Object.keys(row)) {
            const value = row[key]
            if (value === 0 || value === "" || value === null || (Array.isArray(value) && value.length === 0)) delete row[key]
        }
        result.push(row)
    }
    result.sort((a, b) => Number((a as Record<string, any>).id) - Number((b as Record<string, any>).id))
    return result
}
