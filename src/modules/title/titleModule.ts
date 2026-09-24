/** Title module - 称号及获取来源。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { LTemplate, seq, T, TL, TRaw, type VNodeTree } from "../../i18n/vnode.ts"

/**
 * 获取来源的包裹引号。中文/繁中/日文用「」，英/法用双引号；
 * 开引号后是否补空格由各语言自行决定（英法为避免与前置词粘连需要空格）。
 */
const SOURCE_OPEN = TL("「", { en: ": ", fr: ": ", jp: "「", kr: "「", tc: "「" })
const SOURCE_CLOSE = TL("」", { en: "", fr: "", jp: "」", kr: "」", tc: "」" })

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function sequence(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (value === null || value === undefined || value === "") return []
    if (typeof value !== "object") return [value]
    return Object.entries(value as Record<string, unknown>)
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

function sourceName(ctx: ModuleContext, source: { type: string; id: unknown }): VNodeTree | undefined {
    if (source.type === "Achievement") {
        const item = table(ctx, "Achievement")[String(source.id)]
        if (!item?.AchievementName) return undefined
        return seq([T("MAIN_UI_ACHIEVEMENT"), SOURCE_OPEN, T(item.AchievementName), SOURCE_CLOSE])
    }
    if (source.type === "Quest") {
        const item = table(ctx, "QuestChain")[String(source.id)]
        if (!item) return undefined
        const typeKeys: Record<string, string> = {
            "1": "UI_QUEST_SUBTAB_NAME_MAIN",
            "3": "UI_QUEST_SUBTAB_NAME_SIDE",
            "4": "UI_QUEST_SUBTAB_NAME_SpecialSlide",
            "5": "UI_QUEST_SUBTAB_NAME_LimitedtimeActivity",
            "6": "UI_QUEST_SUBTAB_NAME_Activity",
        }
        const typeKey = typeKeys[String(item.QuestChainType)]
        if (!item.QuestChainName || !typeKey) return undefined
        return seq([T(typeKey), SOURCE_OPEN, T(item.QuestChainName), SOURCE_CLOSE])
    }
    if (source.type === "TheaterTask") {
        const item = table(ctx, "TheaterTask")[String(source.id)]
        if (item?.Des) return LTemplate(String(item.Des), item.Target === undefined ? [] : [item.Target])
    }
    return undefined
}

export function titleModule(ctx: ModuleContext): VNodeTree {
    const reward = table(ctx, "Reward")
    const sources = new Map<string, { type: string; id: unknown }>()
    const addRewards = (sourceType: string, sourceId: unknown, rewardIds: unknown): void => {
        for (const rewardId of sequence(rewardIds)) {
            const item = reward[String(rewardId)] ?? reward[rewardId as number]
            if (!item) continue
            const ids = sequence(item.Id)
            const types = sequence(item.Type)
            for (let i = 0; i < ids.length; i++) if (types[i] === "Title") sources.set(String(ids[i]), { type: sourceType, id: sourceId })
        }
    }
    for (const [id, item] of Object.entries(table(ctx, "Achievement"))) {
        if (item && typeof item === "object") addRewards("Achievement", id, (item as Record<string, any>).AchievementReward)
    }
    for (const [id, item] of Object.entries(table(ctx, "QuestChain"))) {
        if (item && typeof item === "object") addRewards("Quest", id, (item as Record<string, any>).QuestChainReward)
    }
    for (const item of Object.values(table(ctx, "TheaterTask"))) {
        if (item && typeof item === "object")
            addRewards("TheaterTask", (item as Record<string, any>).TheaterTaskID, (item as Record<string, any>).RewardId)
    }

    const result: VNodeTree[] = []
    for (const item of Object.values(table(ctx, "Title"))) {
        if (!item || typeof item !== "object") continue
        const row = item as Record<string, any>
        const id = Number(row.TitleID ?? 0)
        if (!id) continue
        const output: Record<string, VNodeTree> = { id, name: TRaw(row.Name ?? ""), suf: Boolean(row.IfSuffix) }
        const source = sources.get(String(id))
        if (source) {
            const value = sourceName(ctx, source)
            if (value) output.src = value
        }
        result.push(output)
    }
    result.sort((a, b) => Number((a as Record<string, any>).id) - Number((b as Record<string, any>).id))
    return result
}
