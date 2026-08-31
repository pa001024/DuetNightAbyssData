/** Event module - 活动配置及关联明细。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function lowerFirstKeys(value: unknown): unknown {
    if (!value || typeof value !== "object" || Array.isArray(value)) return value
    const result: Record<string, unknown> = {}
    for (const [key, item] of Object.entries(value as Record<string, unknown>)) result[key ? key[0].toLowerCase() + key.slice(1) : key] = item
    return result
}

function rowsByEvent(ctx: ModuleContext, name: string): Map<string, Record<string, any>> {
    const result = new Map<string, Record<string, any>>()
    for (const item of Object.values(table(ctx, name))) {
        if (!item || typeof item !== "object") continue
        const eventId = (item as Record<string, any>).EventId
        if (eventId) result.set(String(eventId), item as Record<string, any>)
    }
    return result
}

export function eventModule(ctx: ModuleContext): VNodeTree {
    const boxDrops = rowsByEvent(ctx, "BoxDrop")
    const topUps = rowsByEvent(ctx, "CumulativeTopUpEvent")
    const result: VNodeTree[] = []
    for (const item of Object.values(table(ctx, "EventMain"))) {
        if (!item || typeof item !== "object") continue
        const row = item as Record<string, any>
        const id = Number(row.EventId ?? 0)
        if (!id) continue
        const output: Record<string, VNodeTree> = {
            id,
            name: T(row.EventName ?? ""),
            desc: T(row.EventDes ?? ""),
            startTime: row.EventStartTime,
            endTime: row.EventEndTime,
        }
        if (row.EventRule) output.rule = T(row.EventRule)
        const boxDrop = boxDrops.get(String(id))
        if (boxDrop) output.boxDrop = lowerFirstKeys(boxDrop) as VNodeTree
        const topUp = topUps.get(String(id))
        if (topUp) {
            const detail = lowerFirstKeys(topUp) as Record<string, VNodeTree>
            delete detail.lastRewardIcon
            delete detail.lastRewardId
            delete detail.lastRewardTypeId
            if (topUp.EventDes) detail.eventDes = T(topUp.EventDes)
            if (topUp.EventRule) detail.eventRule = T(topUp.EventRule)
            output.topUpDetail = detail
        }
        result.push(output)
    }
    result.sort((a, b) => Number((a as Record<string, any>).id) - Number((b as Record<string, any>).id))
    return result
}
