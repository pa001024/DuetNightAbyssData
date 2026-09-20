/** Event module - 活动配置及关联明细。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { iconName, sequence } from "../shared/dataHelpers.ts"

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function lowerFirstKeys(value: unknown): unknown {
    if (!value || typeof value !== "object" || Array.isArray(value)) return value
    const result: Record<string, unknown> = {}
    for (const [key, item] of Object.entries(value as Record<string, unknown>))
        result[key ? key[0].toLowerCase() + key.slice(1) : key] = item
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

/**
 * PhotoEvent 拍摄活动的逐日拍摄任务，按 EventId 分组。
 * 每条任务内联其 RegionPoint 拍照地点（id / 名称 / 坐标 / 子区域）；
 * RegionPoint 行缺失时不输出 location。
 */
function photoTasksByEvent(ctx: ModuleContext): Map<string, VNodeTree[]> {
    const result = new Map<string, VNodeTree[]>()
    const regionPoints = table(ctx, "RegionPoint")
    for (const [eventId, entry] of Object.entries(table(ctx, "PhotoEvent"))) {
        if (!entry || typeof entry !== "object") continue
        const tasks: VNodeTree[] = []
        for (const item of sequence(entry)) {
            const row = item as Record<string, any>
            const point = (regionPoints[String(row.RegionPoint)] ?? null) as Record<string, any> | null
            tasks.push({
                id: Number(row.PhotoTaskId ?? 0),
                startTime: row.StartTime,
                endTime: row.EndTime,
                photoView: iconName(row.PhotoView),
                questChain: Number(row.QuestChain ?? 0),
                reward: Number(row.Reward ?? 0),
                rewardView: Number(row.RewardView ?? 0),
                ...(point
                    ? {
                          location: {
                              id: Number(row.RegionPoint ?? 0),
                              name: T(point.Name ?? ""),
                              pos: point.Pos ?? [],
                              subRegion: point.SubRegion,
                          },
                      }
                    : {}),
            })
        }
        result.set(eventId, tasks)
    }
    return result
}

export function eventModule(ctx: ModuleContext): VNodeTree {
    const boxDrops = rowsByEvent(ctx, "BoxDrop")
    const topUps = rowsByEvent(ctx, "CumulativeTopUpEvent")
    const photoTasks = photoTasksByEvent(ctx)
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
        const tasks = photoTasks.get(String(id))
        if (tasks) output.photoTasks = tasks
        result.push(output)
    }
    result.sort((a, b) => Number((a as Record<string, any>).id) - Number((b as Record<string, any>).id))
    return result
}
