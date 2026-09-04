/** Achievement module - 成就数据及奖励。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { LTemplate, record, seq, T, TL, TTrim, type VNode, type VNodeTree } from "../../i18n/vnode.ts"

const VERSION_IDS: Record<string, ReadonlySet<number>> = {
    "1.1": new Set([
        1012901, 1013201, 7012701, 10100401, 10100501, 10100502, 10100503, 10100504, 50520301, 50520302, 50520303, 52000601, 52020101,
    ]),
    "1.2": new Set([
        200901, 200902, 200903, 201001, 201002, 201003, 7012801, 17002001, 17002002, 17002004, 17002005, 17002007, 17002008, 17002010,
        17002011, 17002012, 17002014, 17002015, 17002017, 17002018, 17002021, 17002022, 17002023, 17002024, 17002025, 17002026, 17003001,
        17003002, 17003003, 17003004, 17003005, 17003007, 17003008, 17003010, 17003011, 17003012, 17003014, 17003015, 17003017, 17003018,
        17003019, 17003020, 17003021, 17003022, 17003023, 17003024, 17003025, 17003026,
    ]),
    "1.3": new Set([
        1013601, 7014201, 7014301, 7014401, 7014501, 7014601, 7014701, 7014801, 7014901, 7015001, 7015501, 7015601, 7015701, 10100601,
        17002006, 17002016, 17002019, 17002020, 17003006, 17003016, 52000701,
    ]),
    "1.4": new Set([1013801, 17002013, 17002027, 17003013, 17003027, 52000801]),
    "1.5": new Set([10200301]),
    "1.6": new Set([1014001, 7015801, 7015901, 7016001, 7016101, 7016201, 7016301, 7016401, 7016501, 10100801, 52000901]),
}

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function row(ctx: ModuleContext, name: string, id: unknown): Record<string, any> | undefined {
    const rows = table(ctx, name)
    if (Array.isArray(rows)) {
        const index = Number(id) - 1
        return Number.isInteger(index) && index >= 0 ? (rows[index] as Record<string, any> | undefined) : undefined
    }
    return rows[String(id)] ?? rows[id as number]
}

function sequence(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return value === undefined || value === null || value === "" ? [] : [value]
    return Object.entries(value as Record<string, unknown>)
        .filter(([key]) => /^\d+$/.test(key))
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

function numberValue(value: unknown, fallback = 1): number {
    const candidate = Array.isArray(value) ? numberValue(value[0], fallback) : Number(value)
    return Number.isFinite(candidate) && candidate !== 0 ? Math.trunc(candidate) : fallback
}

function versionOf(id: number): string {
    for (const [version, ids] of Object.entries(VERSION_IDS)) if (ids.has(id)) return version
    return "1.0"
}

function titleLabel(ctx: ModuleContext, id: unknown, frame: boolean): VNode {
    const item = row(ctx, frame ? "TitleFrame" : "Title", id)
    const nameKey = item?.Name
    if (!nameKey) {
        const prefix = frame
            ? TL("样式-", { en: "Style-", jp: "Style-", kr: "Style-", tc: "样式-", fr: "Style-" })
            : TL("称号-", { en: "Title-", jp: "称号-", kr: "称号-", tc: "称号-", fr: "Title-" })
        return seq([prefix, String(id)])
    }
    const opening = frame
        ? TL("“", { en: "Title Frame: ", jp: "「", kr: "", tc: "“", fr: "Title Frame: " })
        : TL("“", { en: "Title: ", jp: "「", kr: "", tc: "“", fr: "Title: " })
    const closing = frame
        ? TL("”样式", { en: " Style", jp: "」スタイル", kr: " 스타일", tc: "”样式", fr: " Style" })
        : TL("”称号", { en: "", jp: "」称号", kr: " 칭호", tc: "”称号", fr: "" })
    // 英文/法文前缀包含冒号，不能将其放在名称后；中文/日文/韩文仍保持包裹格式。
    if (frame || nameKey) {
        const translated = TTrim(nameKey)
        return seq([opening, translated, closing])
    }
    return ""
}

function productName(ctx: ModuleContext, type: string, id: number): VNode | undefined {
    const source: Record<string, [string, string]> = {
        Resource: ["Resource", "ResourceName"],
        Mod: ["Mod", "Name"],
        Char: ["Char", "CharName"],
        Weapon: ["Weapon", "WeaponName"],
    }
    const config = source[type]
    if (!config) return undefined
    const item = row(ctx, config[0], id)
    return item?.[config[1]] ? TTrim(item[config[1]]) : undefined
}

function draftLabel(ctx: ModuleContext, id: number): VNode | undefined {
    const draft = row(ctx, "Draft", id)
    if (!draft) return undefined
    const type = String(draft.ProductType ?? "")
    const productId = Number(draft.ProductId ?? 0)
    const name = productName(ctx, type, productId)
    if (name === undefined) {
        if (type === "Mod" || type === "Char" || type === "Weapon") return undefined
        return TL(`图纸: ${type}${productId}`, {
            en: `Draft: ${type}${productId}`,
            jp: `Draft: ${type}${productId}`,
            kr: `Draft: ${type}${productId}`,
            tc: `图纸: ${type}${productId}`,
            fr: `Draft: ${type}${productId}`,
        })
    }
    return seq([TL("图纸: ", { en: "Draft: ", jp: "Draft: ", kr: "Draft: ", tc: "图紙: ", fr: "Draft: " }), name])
}

function rewardLabel(ctx: ModuleContext, type: string, id: number): VNode {
    if (type === "Resource") return productName(ctx, type, id) ?? String(id)
    if (type === "Draft") return draftLabel(ctx, id) ?? String(id)
    if (type === "Title") return titleLabel(ctx, id, false)
    if (type === "TitleFrame") return titleLabel(ctx, id, true)
    return `${type}-${id}`
}

function rewardEntries(ctx: ModuleContext, rewardId: number, seen = new Set<number>()): Array<[VNode, VNode]> {
    if (!rewardId || seen.has(rewardId)) return []
    seen.add(rewardId)
    const reward = row(ctx, "Reward", rewardId)
    if (!reward) return []
    const ids = sequence(reward.Id)
    const types = sequence(reward.Type)
    const counts = sequence(reward.Count)
    const entries: Array<[VNode, VNode]> = []
    for (let i = 0; i < ids.length; i++) {
        const id = Number(ids[i] ?? 0)
        const type = String(types[i] ?? "")
        if (!id || !type) continue
        const count = numberValue(counts[i])
        if (type === "Reward") entries.push(...rewardEntries(ctx, id, new Set(seen)))
        else entries.push([rewardLabel(ctx, type, id), count])
    }
    return entries
}

export function achievementModule(ctx: ModuleContext): VNodeTree {
    const achievements = table(ctx, "Achievement")
    const result: VNodeTree[] = []
    for (const item of Object.values(achievements)) {
        if (!item || typeof item !== "object") continue
        const id = Number(item.AchievementId ?? 0)
        if (!id) continue
        const describe = String(item.AchievementDescribe ?? "")
        const completion = item.CompletionValue ?? item.TargetProgress ?? 1
        result.push({
            id,
            名称: T(item.AchievementName ?? ""),
            分类: T(row(ctx, "AchievementType", item.AchievementType)?.AchievementTypeName ?? ""),
            品质: item.AchievementRarity ?? 0,
            描述: describe ? LTemplate(describe, [String(completion)], false, "capitalized") : "",
            版本: versionOf(id),
            奖励: record(rewardEntries(ctx, Number(item.AchievementReward ?? 0))),
        })
    }
    result.sort((a, b) => Number((a as Record<string, any>).id) - Number((b as Record<string, any>).id))
    return result
}
