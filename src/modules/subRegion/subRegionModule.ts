import type { ModuleContext } from "../../core/Graph.ts"
import type { VNodeTree } from "../../i18n/vnode.ts"
import { rows } from "../shared/dataHelpers.ts"
import { SubRegionDataReader } from "./subRegionData.ts"

export async function subRegionModule(ctx: ModuleContext): Promise<VNodeTree> {
    const reader = new SubRegionDataReader(ctx)
    try {
        const result: VNodeTree[] = []
        for (const item of rows(ctx, "SubRegion").filter(item => item.RegionId && item.SubRegionLevel))
            result.push(await reader.build(item))
        return result
    } finally {
        await reader.close()
    }
}
