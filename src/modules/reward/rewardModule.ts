/** Reward and OptReward modules - 奖励树一次解析，多语言渲染。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, TTrim, type VNodeTree } from "../../i18n/vnode.ts"

function row(ctx: ModuleContext, table: string, id: unknown): Record<string, any> | undefined {
    const value = ctx.dm.getTable(table)
    if (!value || typeof value !== "object") return undefined
    const rows = value as Record<string, any>
    return rows[String(id)] ?? rows[id as number]
}

function iconName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const normalized = value
        .replaceAll("\\", "/")
        .trim()
        .replace(/^'+|'+$/g, "")
    const pos = normalized.lastIndexOf("T_")
    const name = pos >= 0 ? normalized.slice(pos) : (normalized.split("/").pop() ?? "")
    return name.split(".", 1)[0].replace(/'+$/, "")
}

function productName(ctx: ModuleContext, id: number, type: string): VNodeTree | undefined {
    if (type === "Drop") {
        const item = row(ctx, "Drop", id)
        return T(item?.DropName || String(id))
    }
    if (type === "Mod") return TTrim(row(ctx, "Mod", id)?.Name ?? "")
    if (type === "Resource") return T(row(ctx, "Resource", id)?.ResourceName ?? "")
    if (type === "Reward") return undefined
    if (type === "IronTicket") return T("UI_IronTicket_Survival_Name")
    if (type === "Mount") return T(row(ctx, "Mount", id)?.MountName ?? "")
    if (type === "Draft") {
        const draft = row(ctx, "Draft", id)
        const productType = String(draft?.ProductType ?? "")
        const productId = Number(draft?.ProductId ?? 0)
        if (productType === "Resource") return T(row(ctx, "Resource", productId)?.ResourceName ?? "")
        if (productType === "Mod") return T(row(ctx, "Mod", productId)?.Name ?? "")
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
        const fields: Record<string, string> = { Weapon: "WeaponName", Skin: "SkinName" }
        const field = fields[type] ?? "Name"
        const value = row(ctx, type, id)?.[field]
        return value ? T(value) : undefined
    }
    return `${type}_${id}`
}

function childItems(ctx: ModuleContext, item: Record<string, any>): VNodeTree[] {
    const ids = Array.isArray(item.Id) ? item.Id : []
    const types = Array.isArray(item.Type) ? item.Type : []
    const params = Array.isArray(item.Param) ? [...item.Param] : []
    const counts = Array.isArray(item.Count) ? [...item.Count] : []
    const length = Math.min(ids.length, types.length)
    const children: VNodeTree[] = []
    for (let i = 0; i < length; i++) {
        const id = Number(ids[i] ?? 0)
        const originalType = String(types[i] ?? "")
        let param: any = params[i] ?? 0
        if (Array.isArray(param)) param = param[i] ?? 0
        let count: any = counts[i] ?? 0
        if (Array.isArray(count)) count = count[0] ?? 0
        const child: Record<string, VNodeTree> = { id, t: originalType }
        const numericCount = Number(count)
        if (numericCount > 0) child.c = numericCount
        if (param !== 0) child.p = param

        if (originalType === "Draft") {
            child.t = row(ctx, "Draft", id)?.ProductType ?? "Draft"
            child.d = 1
        }
        if (originalType === "Drop") {
            const drop = row(ctx, "Drop", id)
            if (drop?.UseEffectType === "GetMod") {
                child.id = drop.UseParam ?? 0
                child.t = "Mod"
                child.dp = 1
            }
        }
        const name = productName(ctx, id, originalType)
        if (name !== undefined) {
            child.n = name
            if (originalType === "Draft") child.id = row(ctx, "Draft", id)?.ProductId ?? 0
        }
        children.push(child)
    }
    return children
}

function buildReward(ctx: ModuleContext, item: Record<string, any>, idField: string): VNodeTree | undefined {
    const id = Number(item[idField] ?? 0)
    if (!id) return undefined
    const result: Record<string, VNodeTree> = { id }
    if (item.Mode) result.m = item.Mode
    const icon = iconName(item.Icon)
    if (icon) result.icon = icon
    result.child = childItems(ctx, item)
    return result
}

export function rewardModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("Reward") as Record<string, any>) || {}
    const result: VNodeTree[] = []
    for (const item of Object.values(table)) {
        if (!item || typeof item !== "object") continue
        const built = buildReward(ctx, item, "RewardId")
        if (built) result.push(built)
    }
    return result
}

export function optRewardModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("OptReward") as Record<string, any>) || {}
    const result: VNodeTree[] = []
    for (const item of Object.values(table)) {
        if (!item || typeof item !== "object") continue
        const built = buildReward(ctx, item, "OptRewardId")
        if (built) result.push(built)
    }
    return result
}
