import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { rows } from "../shared/dataHelpers.ts"

export function dungeonModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "Dungeon")
        .filter(item => Number(item.DungeonID) >= 20000)
        .map(item => ({
            id: item.DungeonID,
            n: T(item.DungeonName ?? ""),
            t: item.DungeonType,
            e: item.AttributeType,
            ts: T(item.DungeonTypeShow ?? ""),
            lv: item.DungeonLevel ?? 0,
            rd: item.IsRandom ?? 0,
            m: item.DungeonMonsters ?? [],
            r: item.DungeonReward ?? [],
        }))
}
