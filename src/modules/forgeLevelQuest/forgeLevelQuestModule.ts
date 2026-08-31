/** ForgeLevelQuest module - 锻造等级任务。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext): Record<string, any>[] {
    const table = ctx.dm.getTable("ForgeLevelQuest")
    return table && typeof table === "object" ? Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[] : []
}

function normalizeArray(value: unknown): VNodeTree[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    const entries = Object.entries(value as Record<string, unknown>)
        .map(([key, item]) => [Number(key), item] as const)
        .filter(([key]) => Number.isInteger(key) && key > 0)
        .sort((a, b) => a[0] - b[0])
    return entries.map(([, item]) => item as VNodeTree).filter(item => item !== null && item !== undefined)
}

export function forgeLevelQuestModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx)) {
        const id = Number(item.ForgeQuestId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id }
        const desc = T(item.DailyTasktDes ?? "")
        if (desc) row.desc = desc
        if (item.Target !== undefined && item.Target !== null) row.target = item.Target
        const targetId = normalizeArray(item.TargetId)
        if (targetId.length > 0) row.targetId = targetId
        const reward = normalizeArray(item.QuestReward)
        if (reward.length > 0) row.reward = reward
        result.push(row)
    }
    return result
}
