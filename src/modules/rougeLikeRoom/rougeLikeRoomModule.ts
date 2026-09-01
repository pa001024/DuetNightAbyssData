import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { camelCase, iconName, rows } from "../shared/dataHelpers.ts"
import { eventStorylineNodes } from "../storyline/storyline.ts"

export async function rougeLikeRoomModule(ctx: ModuleContext): Promise<VNodeTree> {
    const items = rows(ctx, "RougeLikeRoom")
    const dialogue = ctx.getArtifact<any>("Dialogue")
    await dialogue?.prepareStoryFlows(items.map(item => item.EventStoryline))
    return items.map(item => ({
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
        ...(item.EventStoryline ? { eventStoryline: eventStorylineNodes(ctx, item.EventStoryline) } : {}),
    }))
}
