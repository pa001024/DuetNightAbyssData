import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { rows } from "../shared/dataHelpers.ts"

export function subRegionModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "SubRegion")
        .filter(item => item.RegionId && item.SubRegionLevel)
        .map(item => ({
            id: item.SubRegionId,
            rid: item.RegionId,
            name: T(item.SubRegionName ?? ""),
            desc: T(item.SubRegionDes ?? ""),
            map: item.SubRegionLevel,
            pos: item.SubRegionCenter,
        }))
}
