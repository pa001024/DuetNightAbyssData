import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { iconName, type Row, rows } from "../shared/dataHelpers.ts"

export function regionModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "Region").map(item => {
        const output: Row = {
            id: item.RegionId,
            name: T(item.RegionName ?? ""),
            type: item.RegionType,
            mapId: item.RegionMapId,
            mapImage: iconName(item.RegionMapImage),
            mapCenter: item.RegionMapImageCenter,
            mapScale: item.RegionMapWheelScale,
            mapRotation: item.RegionRotation,
            alertDisable: item.AlertDisable,
            mapMapping: item.MapMapping ?? [],
            isRandom: item.IsRandom,
        }
        return Object.fromEntries(
            Object.entries(output).filter(
                ([, value]) => value !== undefined && value !== null && value !== "" && !(Array.isArray(value) && value.length === 0)
            )
        )
    })
}
