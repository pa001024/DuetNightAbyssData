import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { camelCase, iconName, rows } from "../shared/dataHelpers.ts"
import { eventStorylineNodes } from "../storyline/storyline.ts"

export async function rougeLikeStoryEventModule(ctx: ModuleContext): Promise<VNodeTree> {
    const dialogue = ctx.getArtifact<any>("Dialogue")
    const items = rows(ctx, "RougeLikeStoryEvent")
    await dialogue?.prepareStoryFlows(items.map(item => item.EventStoryline))
    return items.map(item => ({
        id: item.Id ?? item.StoryEventId,
        name: T(item.StoryEventName ?? ""),
        type: T(item.StoryEventType ?? ""),
        icon: iconName(item.EventMainIcon),
        condition: camelCase(item.EventCondition ?? []) as VNodeTree,
        moment: item.EventMoment ?? 0,
        minRoom: item.EventMinRoom ?? 0,
        probability: camelCase(item.EventProbability ?? []) as VNodeTree,
        rlArchiveSubId: item.RLArchiveSubId ?? 0,
        cutOffEvent: item.CutOffEvent ?? false,
        ...(item.EventStoryline && dialogue?.storyTalks(item.EventStoryline).length
            ? { eventStoryline: eventStorylineNodes(ctx, item.EventStoryline) }
            : {}),
    }))
}
