/** Fish/FishingSpot modules - 鱼类及鱼池基础数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext, name: string): Record<string, any>[] {
    const table = ctx.dm.getTable(name)
    return table && typeof table === "object" ? (Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[]) : []
}

export function fishModule(ctx: ModuleContext): VNodeTree {
    const resources = new Map<number, Record<string, any>>()
    for (const resource of rows(ctx, "Resource")) {
        const id = Number(resource.ResourceId)
        if (id) resources.set(id, resource)
    }
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "Fish")) {
        const resource = resources.get(Number(item.ResourceId))
        let icon = ""
        const iconPath = String(item.IconPath ?? "")
        const pos = iconPath.indexOf("T_Fish_")
        if (pos >= 0) {
            const part = iconPath.slice(pos)
            icon = part.includes(".") ? part.split(".", 1)[0] : part.replace("T_Fish_", "")
        }
        const row: Record<string, VNodeTree> = {
            id: item.FishId,
            name: T(resource?.ResourceName ?? ""),
            rid: item.ResourceId,
            level: item.FishLevel,
            type: item.FishType,
            rarity: resource?.Rarity ?? 0,
            length: item.FishLength ?? [0, 0],
            icon,
            price: item.PriceOnWeight ?? [],
            appear: item.FishAppearPeriod ?? [],
        }
        if (item.Small2BigFishId) row.s2b = item.Small2BigFishId
        if (Array.isArray(item.VariationFishId) && item.VariationFishId.length > 0) row.var = item.VariationFishId
        if (item.VariationProb) row.varProb = item.VariationProb
        result.push(row)
    }
    return result
}

export function fishingSpotModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "FishingSpot")) {
        if (item.FishCountLimit !== 100) continue
        const rawName = String(item.FishingSpotName ?? "")
        const name: VNodeTree = rawName.startsWith("FishingSpot_Name_") ? T(rawName) : rawName
        const iconPath = String(item.IconPath ?? "")
        const fileName = iconPath.split("/").pop() ?? ""
        const icon = fileName.split(".", 1)[0]
        const row: Record<string, VNodeTree> = {
            id: item.FishingSpotId,
            name,
            icon,
            waterType: item.WaterType,
            fishCountLimit: item.FishCountLimit,
            replenishDay: item.ReplenishDay,
            fishIds: item.FishId ?? [],
            showFishIds: item.ShowFishId ?? [],
            weights: item.FishWeight ?? [],
            extraReward: item.ExtraReward,
            ...(item.ExtraRewardProb ? { extraRewardProb: item.ExtraRewardProb } : {}),
            petId: item.PetId,
            ...(item.PetProb ? { petProb: item.PetProb } : {}),
        }
        if (!item.ExtraRewardProb) delete row.extraReward
        if (!item.PetProb) delete row.petId
        result.push(row)
    }
    return result
}
