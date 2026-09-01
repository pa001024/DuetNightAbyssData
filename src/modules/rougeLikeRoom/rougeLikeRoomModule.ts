import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { camelCase, iconName, rows } from "../shared/dataHelpers.ts"
import { storylineNodes } from "../storyline/storyline.ts"

export function rougeLikeRoomModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "RougeLikeRoom").map(item => ({
        id: item.RoomId,
        name: T(item.Name ?? ""),
        roomType: item.RoomType ?? 0,
        weight: item.RoomWeight ?? 0,
        roomCondition: camelCase(item.RoomCondition ?? []) as VNodeTree,
        blessingAward: item.BlessingAward ?? 0,
        tokenAward: item.TokenAward ?? 0,
        endPointsBase: item.EndPointsBase ?? 0,
        endPointsExtras: item.EndPointsExtras ?? 0,
        eventMainIcon: iconName(item.EventMainIcon),
        ...(item.EventStoryline ? { eventStoryline: storylineNodes(ctx, item.EventStoryline, { pruneSequentialNodeNext: false }) } : {}),
    }))
}
