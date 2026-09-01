import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { iconName, type Row, rows } from "../shared/dataHelpers.ts"
import { RegionMapReader } from "./regionMap.ts"

export async function regionModule(ctx: ModuleContext): Promise<VNodeTree> {
    const reader = new RegionMapReader(ctx.dm.root)
    try {
        const result: Row[] = []
        for (const item of rows(ctx, "Region")) {
            const mapImage = iconName(item.RegionMapImage)
            const output: Row = {
                id: item.RegionId,
                name: T(item.RegionName ?? ""),
                type: item.RegionType,
                mapId: item.RegionMapId,
                mapImage,
                mapCenter: item.RegionMapImageCenter,
                mapScale: item.RegionMapWheelScale,
                mapRotation: item.RegionRotation,
                isRandom: item.IsRandom,
                alertDisable: item.AlertDisable,
                ...(mapImage ? { mapMapping: await reader.mappingFor(item.RegionMapImage) } : {}),
            }
            result.push(
                Object.fromEntries(
                    Object.entries(output).filter(
                        ([, value]) =>
                            value !== undefined && value !== null && value !== "" && !(Array.isArray(value) && value.length === 0)
                    )
                )
            )
            if (mapImage && !Object.hasOwn(result.at(-1)!, "mapMapping")) result.at(-1)!.mapMapping = []
        }
        return result
    } finally {
        await reader.close()
    }
}
