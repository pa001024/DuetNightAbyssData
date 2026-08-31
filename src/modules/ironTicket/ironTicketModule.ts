/** IronTicket module - 输出铁券数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function simplifyIcon(value: unknown): string {
    if (typeof value !== "string" || value.length === 0) return ""
    const base = value.split("/").pop() ?? ""
    return base.split(".", 1)[0]
}

export function ironTicketModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("IronTicket") as Record<string, any>) || {}
    const result: VNodeTree[] = []
    for (const item of Object.values(table)) {
        if (!item || typeof item !== "object") continue
        const id = Number(item.TicketId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = {
            id,
            name: T(item.Name ?? ""),
            desc: T(item.DetailDes ?? ""),
            func: T(item.FunctionDes ?? ""),
            icon: simplifyIcon(item.Icon),
            level: item.Level ?? 0,
            rarity: item.Rarity ?? 0,
        }
        if (Array.isArray(item.AccessKey) && item.AccessKey.length > 0) {
            row.accessKey = item.AccessKey
        }
        result.push(row)
    }
    result.sort((a, b) => Number((a as Record<string, unknown>).id ?? 0) - Number((b as Record<string, unknown>).id ?? 0))
    return result
}
