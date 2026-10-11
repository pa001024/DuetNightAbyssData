/** ShopData - 商店在售数据共享（纯依赖模块，不直接输出文件）。 */
import type { ModuleContext } from "../../core/Graph.ts"

type Row = Record<string, any>

function toInt(value: unknown): number | undefined {
    if (typeof value === "number" && Number.isInteger(value)) return value
    if (typeof value !== "string" || !/^-?\d+$/.test(value.trim())) return undefined
    return Number(value)
}

/**
 * 前端商店时间过滤同口径（DBShopDetailItem.vue isItemAvailableAtTime）：起止缺失视为无界，结束取严格小于。
 */
export function isShopItemAvailableAtTime(
    item: { startTime?: number | null; endTime?: number | null },
    timestamp: number
): boolean {
    const started = item.startTime == null || item.startTime <= timestamp
    const notEnded = item.endTime == null || timestamp < item.endTime
    return started && notEnded
}

export interface ShopDataArtifact {
    /** 商店体系→当前在售密函 id（前端时间口径，按导出时刻判定）。注意：商品行 ItemId 是商店条目号，售卖物在 TypeId。 */
    walnutsBySystem: Map<string, Set<number>>
}

export function shopDataModule(ctx: ModuleContext): ShopDataArtifact {
    const timestamp = Math.floor(Date.now() / 1000)
    const shopTable = ctx.dm.getTable("Shop") as Record<string, unknown> | undefined
    const mainToSystem = new Map<number, string>()
    for (const [system, row] of Object.entries(shopTable ?? {})) {
        if (!row || typeof row !== "object") continue
        const mains = (row as Row).MainTabId
        for (const main of Array.isArray(mains) ? mains : []) {
            const n = toInt(main)
            if (n !== undefined && !mainToSystem.has(n)) mainToSystem.set(n, String(system))
        }
    }
    const subToSystem = new Map<number, string>()
    const subTable = ctx.dm.getTable("ShopTabSub") as Record<string, unknown> | undefined
    for (const [key, row] of Object.entries(subTable ?? {})) {
        if (!row || typeof row !== "object") continue
        const system = mainToSystem.get(toInt((row as Row).MainTabId) ?? -1)
        if (system === undefined) continue
        const subId = toInt(key) ?? toInt((row as Row).SubTabId)
        if (subId !== undefined && !subToSystem.has(subId)) subToSystem.set(subId, system)
    }
    const walnutsBySystem = new Map<string, Set<number>>()
    const items = ctx.dm.getTable("ShopItem") as Record<string, unknown> | undefined
    for (const row of Object.values(items ?? {})) {
        if (!row || typeof row !== "object") continue
        const item = row as Row
        if (item.ItemType !== "Walnut") continue
        const system = subToSystem.get(toInt(item.SubTabId) ?? -1)
        if (system === undefined) continue
        const id = toInt(item.TypeId)
        if (id === undefined) continue
        if (!isShopItemAvailableAtTime({ startTime: toInt(item.StartTime) ?? null, endTime: toInt(item.EndTime) ?? null }, timestamp))
            continue
        let set = walnutsBySystem.get(system)
        if (!set) {
            set = new Set<number>()
            walnutsBySystem.set(system, set)
        }
        set.add(id)
    }
    return { walnutsBySystem }
}
