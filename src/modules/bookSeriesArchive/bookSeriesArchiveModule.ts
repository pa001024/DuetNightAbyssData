import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { iconName, rows } from "../shared/dataHelpers.ts"

export function bookSeriesArchiveModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "BookSeriesArchive").map(item => ({
        id: item.BookSeriesId,
        name: T(item.Name ?? item.BookSeriesName ?? ""),
        desc: T(item.Desc ?? item.BookSeriesDesc ?? ""),
        icon: iconName(item.Icon),
    }))
}
