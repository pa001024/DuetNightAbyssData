/** Music/MusicScore modules - 音乐与乐谱基础数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext, tableName: string): Record<string, any>[] {
    const table = ctx.dm.getTable(tableName)
    return table && typeof table === "object" ? (Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[]) : []
}

export function musicModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "Music").map(item => ({
        id: item.MusicId,
        name: T(item.MusicName ?? ""),
        desc: T(item.MusicDes ?? ""),
        scoreId: item.MusicScoreId,
        rId: item.Resource,
        music: String(item.Event ?? "").replace(/^event:/, ""),
    }))
}

export function musicScoreModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "MusicScore").map(item => ({
        id: item.MusicScoreId,
        name: T(item.MusicScoreName ?? ""),
        icon:
            String(item.MusicScorePic ?? "")
                .split(".", 2)
                .at(-1)
                ?.replace(/'+$/, "") ?? "",
    }))
}
