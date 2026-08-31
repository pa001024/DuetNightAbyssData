/** RegionReputation module - 区域声望与委托。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { record, T, type VNode, type VNodeTree } from "../../i18n/vnode.ts"

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function iconName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    return value.split("/").pop()?.split(".", 1)[0]?.replaceAll("'", "") ?? ""
}

export function regionReputationModule(ctx: ModuleContext): VNodeTree {
    const reputations = table(ctx, "RegionReputation")
    const levels = table(ctx, "ReputationLevel")
    const entrusts = table(ctx, "ReputationEntrust")
    const resources = table(ctx, "Resource")
    const result: VNodeTree[] = []
    for (const item of Object.values(reputations)) {
        if (!item || typeof item !== "object") continue
        const id = Number(item.ReputationID ?? 0)
        if (!id) continue
        const costEntries: Array<[VNode, VNode]> = []
        if (item.ManualRefreshType === "Resource" && item.ManualRefreshId && item.ManualRefreshCount) {
            const resource = resources[String(item.ManualRefreshId)] ?? resources[item.ManualRefreshId]
            const key = resource?.ResourceName ? T(resource.ResourceName) : String(item.ManualRefreshId)
            costEntries.push([key, item.ManualRefreshCount])
        }
        const levelRows = Array.isArray(levels[String(id)]) ? levels[String(id)] : []
        const levelResult = levelRows
            .map((level: any) => ({ lv: level.ReputationLevel ?? 0, exp: level.ReputationLevelMaxExp ?? 0, reward: level.Reward ?? 0 }))
            .sort((a: any, b: any) => Number(a.lv) - Number(b.lv))
        const entrustResult: VNodeTree[] = []
        for (const entrust of Object.values(entrusts)) {
            if (!entrust || typeof entrust !== "object" || entrust.ReputationID !== id) continue
            const types = Array.isArray(entrust.Type) ? entrust.Type : []
            const ids = Array.isArray(entrust.Id) ? entrust.Id : []
            const counts = Array.isArray(entrust.Count) ? entrust.Count : []
            const items: VNodeTree[] = []
            for (let i = 0; i < Math.min(types.length, ids.length, counts.length); i++) items.push([types[i], ids[i], counts[i]])
            entrustResult.push({
                id: entrust.Key ?? 0,
                name: T(entrust.EntrustTitle ?? ""),
                desc: T(entrust.EntrustContent ?? ""),
                icon: iconName(entrust.Icon),
                exp: entrust.ExpCount ?? 0,
                weight: entrust.Weight ?? 0,
                items,
            })
        }
        entrustResult.sort((a, b) => Number((a as any).id) - Number((b as any).id))
        result.push({
            id,
            name: T(item.RegionName ?? ""),
            icon: iconName(item.RegionIconPath),
            refreshCost: record(costEntries),
            weekLimit: item.WeekLimit ?? 0,
            levels: levelResult,
            entrusts: entrustResult,
        })
    }
    result.sort((a, b) => Number((a as any).id) - Number((b as any).id))
    return result
}
