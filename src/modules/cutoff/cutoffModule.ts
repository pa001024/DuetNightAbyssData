/**
 * Cutoff module — 输出限时折扣配置。
 *
 * 所有数据来自 Lua Datas 表；名称只保存 TextMap vnode，构建阶段不绑定语言。
 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function byId(table: Record<string, any>, id: number | string): any {
    return table[String(id)] ?? table[id as number]
}

function iconName(path: unknown): string {
    const value = String(path ?? "")
    const marker = value.lastIndexOf("T_")
    if (marker < 0) return ""
    return value.slice(marker).split(".")[0].replace(/['"]$/, "")
}

export function cutoffModule(ctx: ModuleContext): VNodeTree {
    const cutoff = (ctx.dm.getTable("Cutoff") as Record<string, any>) || {}
    const shops = (ctx.dm.getTable("ShopItem") as Record<string, any>) || {}
    const resources = (ctx.dm.getTable("Resource") as Record<string, any>) || {}
    const resourceMap = new Map<number, Record<string, any>>()
    for (const value of Object.values(resources)) {
        if (value && value.ResourceId !== undefined) resourceMap.set(Number(value.ResourceId), value)
    }

    const items: VNodeTree[] = []
    for (const value of Object.values(cutoff)) {
        if (!value || value.CutoffId === undefined || value.ItemId === undefined) continue
        const shop = byId(shops, value.ItemId)
        const item: Record<string, VNodeTree> = {
            id: value.CutoffId,
            itemId: value.ItemId,
            price: value.CutoffPrice,
            discount: value.CutoffShow,
            startTime: value.CutoffStartTime,
        }
        if (value.CutoffEndTime !== undefined && value.CutoffEndTime !== null) item.endTime = value.CutoffEndTime
        if (shop && typeof shop === "object") {
            item.originalPrice = shop.Price
            item.itemType = shop.ItemType
            item.typeId = shop.TypeId
            item.subTabId = shop.SubTabId
            if (shop.PriceType !== undefined && shop.PriceType !== null) {
                item.priceType = shop.PriceType
                const resource = resourceMap.get(Number(shop.PriceType))
                if (resource?.ResourceName) item.priceName = T(resource.ResourceName)
            }
        }
        items.push(item)
    }
    return items
}

export { iconName }
