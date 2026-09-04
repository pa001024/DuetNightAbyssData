/** Draft module — 输出图纸及其材料。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNode, type VNodeTree } from "../../i18n/vnode.ts"

function byId(table: Record<string, any>, id: number | string): any {
    return table[String(id)] ?? table[id as number]
}

function productNameKey(ctx: ModuleContext, type: string, id: number): VNode {
    const tableNames: Record<string, string> = {
        Resource: "Resource",
        Mod: "Mod",
        Char: "Char",
        Weapon: "Weapon",
        CharAccessory: "CharAccessory",
    }
    const fieldNames: Record<string, string> = {
        Resource: "ResourceName",
        Mod: "Name",
        Char: "CharName",
        Weapon: "WeaponName",
        CharAccessory: "Name",
    }
    const table = tableNames[type] ? (ctx.dm.getTable(tableNames[type]) as Record<string, any>) || {} : {}
    const row = byId(table, id)
    const key = row?.[fieldNames[type]]
    if (key) return T(key)
    if (type === "IronTicket") {
        const ticket = byId((ctx.dm.getTable("IronTicket") as Record<string, any>) || {}, id)
        if (ticket?.Name) return T(ticket.Name)
    }
    return `${type}_${id}`
}

function resourceNameKey(ctx: ModuleContext, type: string, id: number): VNode {
    return productNameKey(ctx, type, id)
}

export function draftModule(ctx: ModuleContext): VNodeTree {
    const drafts = (ctx.dm.getTable("Draft") as Record<string, any>) || {}
    const items: VNodeTree[] = []
    for (const draft of Object.values(drafts)) {
        if (!draft || draft.DraftId === undefined) continue
        const foundry = draft.FoundryCost && typeof draft.FoundryCost === "object" ? Object.values(draft.FoundryCost) : []
        const item: Record<string, VNodeTree> = {
            id: draft.DraftId,
            n: productNameKey(ctx, String(draft.ProductType ?? ""), Number(draft.ProductId ?? 0)),
            r: draft.Rarity ?? 0,
            v: processRelease(draft.ReleaseVersion ?? 100),
            t: draft.ProductType ?? "",
            c: draft.ProductNum ?? 1,
            p: draft.ProductId ?? 0,
            d: draft.Time ?? 0,
            ...(draft.Batch ? { b: 1 } : {}),
            ...(draft.IsInfinity ? { i: 1 } : {}),
            ...(draft.ShowInDraftArchive ? { s: 1 } : {}),
            x: processResources(ctx, draft.Resource),
            m: foundry.length > 0 ? (foundry[0] as VNodeTree) : undefined,
        }
        items.push(item)
    }
    items.sort((a, b) => Number((a as Record<string, unknown>).id ?? 0) - Number((b as Record<string, unknown>).id ?? 0))
    return items
}

function processRelease(version: unknown): string {
    const value = Number(version) || 0
    return value ? `${Math.floor(value / 100)}.${Math.floor((value % 100) / 10)}` : "1.0"
}

function processResources(ctx: ModuleContext, resources: unknown): VNodeTree {
    if (!Array.isArray(resources)) return []
    return resources
        .filter(resource => resource && typeof resource === "object")
        .map((resource: any) => ({
            id: resource.Id ?? 0,
            n: resourceNameKey(ctx, String(resource.Type ?? ""), Number(resource.Id ?? 0)),
            c: resource.Num ?? 0,
            t: resource.Type ?? "",
        }))
}
