/** RegionPoint module - 区域点基础数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

export function regionPointModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("RegionPoint") as Record<string, any>) || {}
    const result: VNodeTree[] = []
    for (const item of Object.values(table)) {
        if (!item || typeof item !== "object") continue
        const iconPath = String(item.Icon ?? "")
        const pos = iconPath.lastIndexOf("T_Gp_")
        let icon = ""
        if (pos >= 0) {
            const part = iconPath.slice(pos)
            icon = (part.includes(".") ? part.split(".", 1)[0] : part).replace(/'+$/, "")
        }
        result.push({
            id: item.Id,
            name: T(item.Name ?? ""),
            icon,
            pos: item.Pos ?? [],
            subRegion: item.SubRegion,
            targetSubRegion: item.TargetSubRegion ?? [],
            telepointId: item.TelepointId,
            teleportPointPos: item.TeleportPointPos,
            teleportSubRegion: item.TeleportSubRegion,
            unlockConditionId: item.UnlockConditionId,
            manualItemId: item.ManualItemId,
            staticId: item.StaticId,
            singleCreate: item.SingleCreate ?? false,
        })
    }
    return result
}
