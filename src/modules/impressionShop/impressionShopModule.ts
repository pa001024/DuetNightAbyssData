/** Impression shop module. */

import type { ModuleContext } from "../../core/Graph.ts"
import { seq, T, type VNodeTree } from "../../i18n/vnode.ts"

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function sequence(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (value === null || value === undefined || value === "") return []
    if (typeof value !== "object") return [value]
    return Object.entries(value as Record<string, unknown>)
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

function byId(value: Record<string, any>, id: unknown): Record<string, any> {
    return value[String(id)] ?? value[id as number] ?? {}
}

function itemName(ctx: ModuleContext, type: string, id: unknown): VNodeTree {
    const item = byId(table(ctx, type), id)
    if (type === "Resource") return T(item.ResourceName ?? "")
    if (type === "HeadSculpture" || type === "Title" || type === "CharAccessory") return T(item.Name ?? "")
    if (type === "Weapon") return T(item.WeaponName ?? "")
    if (type === "Mod") return seq([T(item.TypeName ?? ""), T(item.Name ?? "")])
    if (type !== "Draft") return ""
    const productType = String(item.ProductType ?? "")
    const productId = item.ProductId
    if (productType === "Resource") return itemName(ctx, "Resource", productId)
    if (productType === "Weapon") return itemName(ctx, "Weapon", productId)
    if (productType === "Mod") return itemName(ctx, "Mod", productId)
    if (productType === "CharAccessory") return itemName(ctx, "CharAccessory", productId)
    return ""
}

function condition(ctx: ModuleContext, id: unknown): VNodeTree | undefined {
    if (!id) return undefined
    const item = byId(table(ctx, "Condition"), id)
    const values = sequence(item.ConditionMap?.ImprShopUnlock)
    const unlock = values[0]
    if (!Array.isArray(unlock) || unlock.length !== 3) return undefined
    if (!Number.isInteger(unlock[0]) || typeof unlock[1] !== "string" || !Number.isInteger(unlock[2])) return undefined
    return unlock as VNodeTree
}

function processItem(ctx: ModuleContext, item: Record<string, any>, cost: Record<string, any>): Record<string, VNodeTree> {
    const priceType = cost.ResourceId ?? 0
    const priceResource = byId(table(ctx, "Resource"), priceType)
    const output: Record<string, VNodeTree> = {
        id: item.ImpressionShopId ?? 0,
        itemType: item.ItemType ?? "",
        typeId: item.ItemId ?? 0,
        typeName: itemName(ctx, String(item.ItemType ?? ""), item.ItemId),
        price: cost.Count ?? 0,
        priceType,
        priceName: T(priceResource.ResourceName ?? ""),
        num: item.TypeNum ?? 0,
        limit: item.PurchaseLimit ?? 0,
        subTabId: item.SubTabId ?? 0,
        sequence: item.ItemSeq ?? 0,
    }
    const unlock = condition(ctx, item.UnlockCondition)
    const imprCheck = condition(ctx, item.ImprCheckId)
    if (unlock !== undefined) output.unlock = unlock
    if (imprCheck !== undefined) output.imprCheck = imprCheck
    if (!output.limit) delete output.limit
    return output
}

export function impressionShopModule(ctx: ModuleContext): VNodeTree {
    const costs = table(ctx, "ImpressionResource")
    const grouped = new Map<string, Record<string, VNodeTree>[]>()
    for (const item of Object.values(table(ctx, "ImpressionShop"))) {
        if (!item || typeof item !== "object") continue
        const row = item as Record<string, any>
        const key = `${row.RegionId}:${row.SubTabId}`
        const list = grouped.get(key) ?? []
        list.push(processItem(ctx, row, byId(costs, row.RegionId)))
        grouped.set(key, list)
    }

    const mainTabMap = table(ctx, "RegionId2ImpressionMainTab")
    const mainTabs = Object.values(table(ctx, "ImpressionShopMainTab"))
    const subTabs = Object.values(table(ctx, "ImpressionShopSubTab"))
    const regions: VNodeTree[] = []
    for (const [regionKey, infoValue] of Object.entries(table(ctx, "ImpressionShopInfo"))) {
        if (!infoValue || typeof infoValue !== "object") continue
        const regionId = Number(regionKey)
        const info = infoValue as Record<string, any>
        const region: Record<string, VNodeTree> = { id: regionId, name: T(info.ShopName ?? ""), subTabs: [] }
        const mainId = mainTabMap[regionKey] ?? mainTabMap[regionId]
        for (const mainValue of mainTabs) {
            if (!mainValue || typeof mainValue !== "object") continue
            const main = mainValue as Record<string, any>
            if (Number(main.RegionId) !== regionId || (mainId && Number(main.MainTabId) !== Number(mainId))) continue
            region.name = T(main.MainName ?? "")
            const children: VNodeTree[] = []
            for (const subValue of subTabs) {
                if (!subValue || typeof subValue !== "object") continue
                const sub = subValue as Record<string, any>
                if (Number(sub.MainTabId) !== Number(main.MainTabId)) continue
                const items = grouped.get(`${regionId}:${sub.SubTabId}`) ?? []
                if (items.length === 0) continue
                items.sort((a, b) => Number(b.sequence) - Number(a.sequence))
                children.push({ id: Number(sub.SubTabId), name: T(sub.SubName ?? ""), items })
            }
            ;(region.subTabs as VNodeTree[]).push(...children)
        }
        if ((region.subTabs as VNodeTree[]).length > 0) {
            ;(region.subTabs as VNodeTree[]).sort((a, b) => Number((a as Record<string, any>).id) - Number((b as Record<string, any>).id))
            regions.push(region)
        }
    }
    regions.sort((a, b) => Number((a as Record<string, any>).id) - Number((b as Record<string, any>).id))
    return [{ id: "ImpressionShop", name: T("UI_ImpressionShop_ShopName"), mainTabs: regions }]
}
