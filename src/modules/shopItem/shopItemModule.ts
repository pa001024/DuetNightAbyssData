/** ShopItem module - 商店、分页及商品条目。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { seq, T, TTrim, type VNode, type VNodeTree } from "../../i18n/vnode.ts"

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

function typeName(ctx: ModuleContext, itemType: string, typeId: number): VNode {
    if (!typeId) return ""
    if (itemType === "Resource") {
        const resource = row(ctx, "Resource", typeId)
        return resource?.ResourceName ? T(resource.ResourceName) : ""
    }
    const item = row(ctx, itemType, typeId)
    if (!item) return ""
    if (itemType === "Weapon") return item.WeaponName ? T(item.WeaponName) : ""
    if (itemType === "Mod") return seq([T(item.TypeName ?? ""), TTrim(item.Name ?? "")])
    if (itemType === "Draft") {
        const productType = String(item.ProductType ?? "")
        const productId = Number(item.ProductId ?? 0)
        if (!productType || !productId) return ""
        if (productType === "Mod") {
            const mod = row(ctx, "Mod", productId)
            return mod ? seq([T(mod.TypeName ?? ""), TTrim(mod.Name ?? "")]) : ""
        }
        if (productType === "Resource") {
            const resource = row(ctx, "Resource", productId)
            return resource?.ResourceName ? T(resource.ResourceName) : ""
        }
        if (productType === "Char") {
            const char = row(ctx, "Char", productId)
            return char?.Name ? T(char.Name) : ""
        }
        if (productType === "Weapon") {
            const weapon = row(ctx, "Weapon", productId)
            return weapon?.WeaponName ? T(weapon.WeaponName) : ""
        }
        if (productType === "CharAccessory") {
            const accessory = row(ctx, "CharAccessory", productId)
            return accessory?.Name ? T(accessory.Name) : ""
        }
        return ""
    }
    const field: Record<string, string> = {
        Skin: "SkinName",
        Mount: "MountName",
        WeaponSkin: "Name",
        CharAccessory: "Name",
        WeaponAccessory: "Name",
        HeadSculpture: "Name",
        Hair: "Name",
        HeadFrame: "Name",
        Title: "Name",
        TitleFrame: "Name",
        DailyPack: "Name",
        Walnut: "Name",
        Reward: "Name",
        Pet: "Name",
    }
    const key = field[itemType]
    return key && item[key] ? T(item[key]) : ""
}

function conditionText(ctx: ModuleContext, value: unknown): VNode {
    const ids = Array.isArray(value) ? value : value ? [value] : []
    const keys: string[] = []
    for (const id of ids) {
        const key = row(ctx, "Condition", id)?.ConditionText
        if (typeof key === "string" && key && !keys.includes(key)) keys.push(key)
    }
    return seq(keys.flatMap((key, index) => (index === 0 ? [T(key)] : ["；", T(key)])))
}

function payData(ctx: ModuleContext, itemId: number): Record<string, number> | undefined {
    const relation = row(ctx, "ShopItem2PayGoods", itemId)
    const goodsId = typeof relation === "string" ? relation : undefined
    if (!goodsId) return undefined
    const goods = row(ctx, "PayGoods", goodsId)
    if (!goods) return undefined
    const result: Record<string, number> = {}
    for (const field of ["CNY", "EUR", "GBP", "HKD", "JPY", "KRW", "RUB", "TWD", "USD"]) {
        const value = goods[`Price${field}`]
        if (value !== undefined) result[field] = value
    }
    return Object.keys(result).length > 0 ? result : undefined
}

function itemNode(ctx: ModuleContext, source: Record<string, any>): Record<string, VNodeTree> {
    const id = Number(source.ItemId ?? 0)
    const itemType = String(source.ItemType ?? "")
    const typeId = Number(source.TypeId ?? 0)
    const priceType = Number(source.PriceType ?? 0)
    const output: Record<string, VNodeTree> = {
        id,
        itemType,
        typeId,
        typeName: typeName(ctx, itemType, typeId),
        price: source.Price,
        priceType,
        priceName: typeName(ctx, "Resource", priceType),
        num: source.TypeNum,
        ...(source.PurchaseLimit ? { limit: source.PurchaseLimit } : {}),
        subTabId: source.SubTabId,
    }
    const pay = payData(ctx, id)
    if (pay) output.pay = pay
    if (source.Sequence !== undefined) output.sequence = source.Sequence
    if (source.StartTime !== undefined) output.startTime = source.StartTime
    if (source.EndTime !== undefined) output.endTime = source.EndTime
    if (source.UnlockLevel !== undefined) output.lv = source.UnlockLevel
    const cond = conditionText(ctx, source.ItemCondition)
    if (source.ItemCondition) output.cond = cond
    if (source.Require) output.require = source.Require
    if (source.UnlockRaidPoint) output.unlockRaidPoint = source.UnlockRaidPoint
    if (source.IsSpPopup) output.isSpPopup = 1
    if (id === 140291) {
        delete output.cond
        output.require = 140269
    }
    return output
}

export function shopItemModule(ctx: ModuleContext): VNodeTree {
    const itemsBySubTab = new Map<string, Record<string, VNodeTree>[]>()
    for (const source of Object.values(table(ctx, "ShopItem"))) {
        if (!source || typeof source !== "object") continue
        const item = itemNode(ctx, source as Record<string, any>)
        const key = String((source as Record<string, any>).SubTabId)
        const list = itemsBySubTab.get(key) ?? []
        list.push(item)
        itemsBySubTab.set(key, list)
    }

    const subTabs = table(ctx, "ShopTabSub")
    const mains = table(ctx, "ShopTabMain")
    const shops: VNodeTree[] = []
    for (const [shopId, shop] of Object.entries(table(ctx, "Shop"))) {
        if (!shop || typeof shop !== "object") continue
        const shopRow = shop as Record<string, any>
        const mainTabs: VNodeTree[] = []
        const mainIds = Array.isArray(shopRow.MainTabId) ? shopRow.MainTabId : []
        for (const mainId of mainIds) {
            const main = row(ctx, "ShopTabMain", mainId) ?? mains[String(mainId)]
            if (!main) continue
            const subTabNodes: VNodeTree[] = []
            for (const sub of Object.values(subTabs)) {
                if (!sub || typeof sub !== "object" || Number((sub as any).MainTabId) !== Number(mainId)) continue
                const subRow = sub as Record<string, any>
                const list = itemsBySubTab.get(String(subRow.SubTabId))
                if (!list || list.length === 0) continue
                subTabNodes.push({ id: Number(subRow.SubTabId), name: T(subRow.SubName ?? ""), items: list })
            }
            if (subTabNodes.length > 0) mainTabs.push({ id: Number(mainId), name: T(main.MainName ?? ""), subTabs: subTabNodes })
        }
        if (mainTabs.length > 0) shops.push({ id: shopId, name: T(shopRow.ShopName ?? ""), mainTabs })
    }
    shops.sort((a, b) => String((a as any).id).localeCompare(String((b as any).id)))
    return shops
}
