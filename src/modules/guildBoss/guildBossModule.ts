/** GuildBoss module - 公会 Boss 讨伐（狭义公会战）。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { LTemplate, T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext, name: string): Record<string, any>[] {
    const table = ctx.dm.getTable(name)
    if (!table || typeof table !== "object") return []
    return Object.values(table).filter((v): v is Record<string, any> => !!v && typeof v === "object")
}

function iconName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const match = value.match(/(T_[^./']+)/)
    return match ? match[1] : ""
}

function seqList(value: unknown): any[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    return Object.entries(value as Record<string, unknown>)
        .filter(([k]) => /^\d+$/.test(k))
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, v]) => v)
}

function num(value: unknown): number {
    const n = Number(value)
    return Number.isFinite(n) ? n : 0
}

/** GuildWarBuff 参数经游戏计算串解析（仅 id=1 有参，其余为空）。 */
function buffParams(ctx: ModuleContext, item: Record<string, any>): VNodeTree[] {
    return seqList(item.BuffParameter)
        .filter(v => typeof v === "string")
        .map(v => ctx.dm.calcSkillDesc(v as string, 1))
}

function buffs(ctx: ModuleContext): VNodeTree[] {
    const result: Record<string, VNodeTree>[] = []
    for (const item of rows(ctx, "GuildWarBuff")) {
        const id = num(item.GuildWarBuffID)
        if (!id) continue
        const params = buffParams(ctx, item)
        result.push({
            id,
            buffIds: seqList(item.BuffID).map(num) as VNodeTree,
            desc: LTemplate(String(item.BuffDes ?? ""), params as any),
            icon: iconName(item.Icon),
        })
    }
    result.sort((a, b) => Number(a.id) - Number(b.id))
    return result
}

/** 与 GuildBossUtils.BuildGuildWarTestParameter 对齐：Rate→百分比串，Hit→原值串。 */
function testParam(rule: Record<string, any> | undefined): string[] | undefined {
    if (!rule || typeof rule !== "object") return undefined
    if (rule.Rate !== undefined) return [`${Math.floor(Number(rule.Rate) * 100 + 0.5)}%`]
    if (rule.Hit !== undefined) return [String(rule.Hit)]
    return undefined
}

function tests(ctx: ModuleContext): VNodeTree[] {
    const result: Record<string, VNodeTree>[] = []
    for (const item of rows(ctx, "GuildWarTest")) {
        const id = num(item.GuildWarTestID)
        if (!id) continue
        const rule = (item.CalulationRule ?? {}) as Record<string, any>
        const param = testParam(rule)
        result.push({
            id,
            type: num(item.TestType),
            keyword: T(String(item.TestKeyWord ?? "")),
            desc: LTemplate(String(item.TestDes ?? ""), (param ?? []) as any),
            cond: (item.DamageCondition ?? {}) as VNodeTree,
            rule: { ...(rule as Record<string, unknown>) } as VNodeTree,
            rate: num(item.ContributionRate),
        })
    }
    result.sort((a, b) => Number(a.id) - Number(b.id))
    return result
}

function bosses(ctx: ModuleContext): VNodeTree[] {
    const result: Record<string, VNodeTree>[] = []
    for (const item of rows(ctx, "GuildBossInfo")) {
        const id = num(item.ID)
        if (!id) continue
        result.push({
            id,
            name: T(String(item.Name ?? "")),
            desc: T(String(item.Desc ?? "")),
            dungeonId: num(item.DungeonID),
            timeLimit: num(item.TimeLimit),
            hp: num(item.BossTotalHP),
            baseRate: num(item.GuildBossBaseRate),
            buffs: seqList(item.GuildWarBuff).map(num) as VNodeTree,
            testTypes: seqList(item.RandomTest).map(num) as VNodeTree,
        })
    }
    result.sort((a, b) => Number(a.id) - Number(b.id))
    return result
}

function refresh(ctx: ModuleContext): VNodeTree[] {
    const result: Record<string, VNodeTree>[] = []
    for (const item of rows(ctx, "GuildBossRefresh")) {
        const id = num(item.ID)
        if (!id) continue
        result.push({
            id,
            startTime: num(item.StartTime),
            bossIds: seqList(item.BossID).map(num) as VNodeTree,
        })
    }
    result.sort((a, b) => Number(a.id) - Number(b.id))
    return result
}

function pointRewards(ctx: ModuleContext): VNodeTree[] {
    const result: Record<string, VNodeTree>[] = []
    for (const item of rows(ctx, "GuildBossPonitReward")) {
        const id = num(item.ID)
        if (!id) continue
        result.push({
            id,
            lv: num(item.Lv),
            eachPoints: num(item.EachGradePoints),
            rewards: seqList(item.Reward).map(num) as VNodeTree,
        })
    }
    result.sort((a, b) => Number(a.id) - Number(b.id))
    return result
}

function weekRewards(ctx: ModuleContext): VNodeTree[] {
    const result: Record<string, VNodeTree>[] = []
    for (const item of rows(ctx, "GuildBossWeekReward")) {
        const stage = num(item.Stage)
        if (!stage) continue
        result.push({
            stage,
            constructionPoint: num(item.GuildConstructionPoint),
            reward: num(item.StageReward),
        })
    }
    result.sort((a, b) => Number(a.stage) - Number(b.stage))
    return result
}

export function guildBossModule(ctx: ModuleContext): VNodeTree {
    return {
        bosses: bosses(ctx),
        buffs: buffs(ctx),
        tests: tests(ctx),
        refresh: refresh(ctx),
        pointRewards: pointRewards(ctx),
        weekRewards: weekRewards(ctx),
    }
}
