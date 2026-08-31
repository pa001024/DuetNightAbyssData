/** Mount module - 输出坐骑数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function iconName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const match = value.match(/T_([^.]+)\./)
    return match?.[1] ?? ""
}

export function mountModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("Mount") as Record<string, any>) || {}
    const access = (ctx.dm.getTable("Access") as Record<string, any>) || {}
    const result: VNodeTree[] = []
    for (const item of Object.values(table)) {
        if (!item || typeof item !== "object") continue
        const id = Number(item.MountId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = {
            id,
            name: T(item.MountName ?? ""),
            des: T(item.MountDes ?? ""),
            icon: iconName(item.MountIcon),
            resourceIcon: iconName(item.ResourceIcon),
            rarity: item.MountRarity,
            sort: item.SortPriority,
            resourceId: item.ResourceId,
        }
        if (item.FlyLicense !== undefined && item.FlyLicense !== null) row.fly = item.FlyLicense
        if (Array.isArray(item.AccessKey) && item.AccessKey.length > 0) {
            row.access = item.AccessKey.filter(Boolean).map((key: unknown) => {
                const entry = access[String(key)]
                return T(entry?.AccessText ?? String(key))
            })
        }
        result.push(row)
    }
    return result
}
