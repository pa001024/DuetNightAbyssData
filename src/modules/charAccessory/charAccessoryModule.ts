/** CharAccessory module - 输出角色配件数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function iconName(value: unknown): string {
    if (typeof value !== "string" || value.length === 0) return ""
    const match = value.match(/(T_[^./']+)/)
    return match?.[1] ?? ""
}

export function charAccessoryModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("CharAccessory") as Record<string, any>) || {}
    const result: VNodeTree[] = []
    for (const item of Object.values(table)) {
        if (!item || typeof item !== "object" || item.IsHide) continue
        const id = Number(item.AccessoryId ?? 0)
        if (!id) continue
        result.push({
            id,
            name: T(item.Name ?? ""),
            desc: T(item.Des ?? ""),
            icon: iconName(item.Icon),
            rarity: item.Rarity ?? 0,
            unlock: T(item.UnlockOption ?? ""),
        })
    }
    result.sort((a, b) => Number((a as Record<string, unknown>).id ?? 0) - Number((b as Record<string, unknown>).id ?? 0))
    return result
}
