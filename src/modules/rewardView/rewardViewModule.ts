/** RewardView module - rewards exposed by the game UI. */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, TTrim, type VNodeTree } from "../../i18n/vnode.ts"

type Row = Record<string, any>

function tableItem(ctx: ModuleContext, table: string, id: unknown): Row | undefined {
    const value = ctx.dm.getTableItem(table, id as number | string)
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : undefined
}

function normalizeArray(value: unknown, minLength = 0): unknown[] {
    let result: unknown[]
    if (Array.isArray(value)) result = [...value]
    else if (value && typeof value === "object") {
        result = []
        for (const [key, item] of Object.entries(value)) {
            const index = Number(key) - 1
            if (!Number.isInteger(index) || index < 0) continue
            while (result.length <= index) result.push(0)
            result[index] = item
        }
    } else if (value === null || value === undefined) result = []
    else result = [value]
    while (result.length < minLength) result.push(0)
    return result
}

function productName(ctx: ModuleContext, id: unknown, type: string): VNodeTree | undefined {
    const numericId = Number(id)
    if (type === "Drop") {
        const item = tableItem(ctx, "Drop", id)
        return T(item?.DropName || String(id))
    }
    if (type === "Mod") return TTrim(tableItem(ctx, "Mod", id)?.Name ?? "")
    if (type === "Resource") return T(tableItem(ctx, "Resource", id)?.ResourceName ?? "")
    if (type === "Reward") return undefined
    if (type === "IronTicket") return T("UI_IronTicket_Survival_Name")
    if (type === "Draft") {
        const draft = tableItem(ctx, "Draft", id)
        const productType = String(draft?.ProductType ?? "")
        const productId = Number(draft?.ProductId ?? 0)
        if (productType === "Resource") return T(tableItem(ctx, "Resource", productId)?.ResourceName ?? "")
        if (productType === "Mod") return TTrim(tableItem(ctx, "Mod", productId)?.Name ?? "")
        if (productType === "Char") return T(`UI_CHAR_NAME_${productId}`)
        if (productType === "Weapon") return T(`UI_WEAPON_NAME_${productId}`)
        if (productType === "CharAccessory") return T(`UI_Accessory_Name_${productId}`)
        if (productType === "IronTicket") return T("UI_IronTicket_Survival_Name")
        return `${type}_${id}`
    }

    const knownTypes = new Set([
        "Walnut",
        "Item",
        "Char",
        "Weapon",
        "Monster",
        "Title",
        "TitleFrame",
        "CharAccessory",
        "Pet",
        "HeadSculpture",
        "HeadFrame",
        "Skin",
        "WeaponSkin",
        "WeaponAccessory",
    ])
    if (knownTypes.has(type)) {
        const field = type === "Weapon" ? "WeaponName" : type === "Skin" ? "SkinName" : "Name"
        const value = tableItem(ctx, type, id)?.[field]
        return value ? T(value) : undefined
    }
    return `${type}_${numericId}`
}

function buildChildren(ctx: ModuleContext, item: Row): VNodeTree[] {
    const ids = normalizeArray(item.Id)
    const types = normalizeArray(item.Type)
    const length = Math.min(ids.length, types.length)
    const params = normalizeArray(item.Param, length)
    const quantities = normalizeArray(item.Quantity, length)
    const children: VNodeTree[] = []

    for (let index = 0; index < length; index++) {
        const itemId = ids[index]
        const originalType = String(types[index] ?? "")
        let param: any = params[index] ?? 0
        if (Array.isArray(param)) param = param[index] ?? 0
        let quantity: any = quantities[index] ?? 0
        if (Array.isArray(quantity)) quantity = quantity[0] ?? 0

        const child: Row = { id: itemId, t: originalType }
        const count = Number(quantity)
        if (Number.isFinite(count) && count > 0) child.c = Math.trunc(count)
        if (param !== 0) child.p = param

        if (originalType === "Draft") {
            const draft = tableItem(ctx, "Draft", itemId)
            child.t = draft?.ProductType ?? "Draft"
            child.d = 1
        }
        if (originalType === "Drop") {
            const drop = tableItem(ctx, "Drop", itemId)
            if (drop?.UseEffectType === "GetMod") {
                child.id = drop.UseParam ?? 0
                child.t = "Mod"
                child.dp = 1
            }
        }

        const name = productName(ctx, itemId, originalType)
        if (name !== undefined) {
            child.n = name
            if (originalType === "Draft") child.id = tableItem(ctx, "Draft", itemId)?.ProductId ?? 0
        }
        children.push(child)
    }
    return children
}

export function rewardViewModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("RewardView") as Record<string, Row>) || {}
    const result: VNodeTree[] = []
    for (const item of Object.values(table)) {
        if (!item || typeof item !== "object") continue
        const rewardId = item.RewardViewId ?? 0
        if (!rewardId) continue
        const output: Row = { id: rewardId }
        if (item.Mode) output.m = item.Mode
        output.child = buildChildren(ctx, item)
        result.push(output)
    }
    return result
}
