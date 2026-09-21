import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { iconName, type Row, rows } from "../shared/dataHelpers.ts"
import { RegionMapReader } from "./regionMap.ts"

/** 读取子区域的 `SubRegionCenter` 二元世界坐标。 */
function subRegionCenter(value: unknown): [number, number] | undefined {
    const raw = (value as Row | undefined)?.SubRegionCenter
    if (!Array.isArray(raw) || raw.length < 2) return undefined
    const x = Number(raw[0])
    const y = Number(raw[1])
    return Number.isFinite(x) && Number.isFinite(y) ? [x, y] : undefined
}

export async function regionModule(ctx: ModuleContext): Promise<VNodeTree> {
    const reader = new RegionMapReader(ctx.dm.root)
    try {
        const result: Row[] = []
        for (const item of rows(ctx, "Region")) {
            const mapImage = iconName(item.RegionMapImage)
            const isRandom: number[] = Array.isArray(item.IsRandom) ? item.IsRandom : []
            const layout = mapImage
                ? await reader.layoutFor(item.RegionMapImage, isRandom, ids => {
                      const centers = new Map<string, [number, number]>()
                      for (const [key, value] of ctx.dm.getTableItems("SubRegion", ids)) {
                          const center = subRegionCenter(value)
                          if (center) centers.set(String(key), center)
                      }
                      return centers
                  })
                : undefined
            // 控件含 Img_Map 时游戏直接用作者坐标摆放图层，缺 RegionMapImageCenter 则地图中心取世界原点。
            // 不含 Img_Map 时游戏按世界坐标重排，地图中心由重排结果推导，RegionMapImageCenter 不参与。
            const mapCenter = layout
                ? (layout.mapCenter ?? (layout.hasImageMap ? (item.RegionMapImageCenter ?? [0, 0]) : item.RegionMapImageCenter))
                : item.RegionMapImageCenter
            const output: Row = {
                id: item.RegionId,
                name: T(item.RegionName ?? ""),
                type: item.RegionType,
                mapId: item.RegionMapId,
                mapImage,
                mapCenter,
                mapScale: item.RegionMapWheelScale,
                mapRotation: item.RegionRotation,
                isRandom,
                alertDisable: item.AlertDisable,
                ...(layout ? { mapMapping: layout.entries } : {}),
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
