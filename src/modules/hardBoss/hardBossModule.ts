/** HardBoss module - 梦魇残声数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext, name: string): Record<string, any>[] {
    const table = ctx.dm.getTable(name)
    return table && typeof table === "object" ? (Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[]) : []
}

function iconName(...values: unknown[]): string {
    for (const value of values) {
        if (typeof value !== "string" || !value) continue
        const match = value.match(/(T_[^./']+)/)
        if (match) return match[1]
    }
    return ""
}

export interface HardBossDifficultyInfo {
    id: number
    level: unknown
    reward: unknown
}

export interface HardBossBossInfo {
    id: number
    nameKey: string
    icon: string
    descKey: string
    monsterId: unknown
    difficulties: HardBossDifficultyInfo[]
}

export interface HardBossDataArtifact {
    bosses: HardBossBossInfo[]
    /**
     * 末段难度奖励 id → DynamicReward 末段实际奖励 id（Index 最大一段，如 1033→1411033）。
     * 无轮换数据时回退自身。
     */
    dynamicRewardOf(baseId: number): number
    /** 每 boss 最后一段难度的待解析奖励 id 列表（已过 DynamicReward，用户口径）。 */
    lastRewards(): number[]
}

function toIntLocal(value: unknown): number | undefined {
    if (typeof value === "number" && Number.isInteger(value)) return value
    if (typeof value !== "string" || !/^-?\d+$/.test(value.trim())) return undefined
    return Number(value)
}

export function hardBossDataModule(ctx: ModuleContext): HardBossDataArtifact {
    const difficulty = new Map<number, Record<string, any>>()
    for (const item of rows(ctx, "HardBossDifficulty")) {
        const id = Number(item.DifficultyID)
        if (id) difficulty.set(id, item)
    }
    const bosses: HardBossBossInfo[] = []
    for (const item of rows(ctx, "HardBossMain")) {
        const id = Number(item.HardBossId)
        if (!id) continue
        const difficulties: HardBossDifficultyInfo[] = []
        for (const diffId of Array.isArray(item.DifficultyId) ? item.DifficultyId : []) {
            const info = difficulty.get(Number(diffId))
            if (info) difficulties.push({ id: Number(diffId), level: info.DifficultyLevel ?? 0, reward: info.DifficultyReward ?? 0 })
        }
        bosses.push({
            id,
            nameKey: String(item.HardBossName ?? ""),
            icon: iconName(item.MonsterIcon, item.BossIcon, item.MainIcon),
            descKey: String(item.HardBossDes ?? ""),
            monsterId: item.MonsterId,
            difficulties,
        })
    }
    bosses.sort((a, b) => a.id - b.id)
    // DynamicReward 按基础奖励 id 分组，取 Index 最大一段为当前生效奖励。
    const dynamicLast = new Map<number, number>()
    const dynamicTable = ctx.dm.getTable("DynamicReward") as Record<string, unknown> | undefined
    if (dynamicTable && typeof dynamicTable === "object") {
        for (const group of Object.values(dynamicTable)) {
            if (!group || typeof group !== "object") continue
            let bestIndex = -1
            let bestReward: number | undefined
            let baseId: number | undefined
            for (const row of Object.values(group as Record<string, unknown>)) {
                if (!row || typeof row !== "object") continue
                const rec = row as Record<string, unknown>
                const base = toIntLocal(rec.DynamicRewardId)
                if (base === undefined) continue
                if (baseId === undefined) baseId = base
                const index = toIntLocal(rec.Index) ?? -1
                const reward = toIntLocal(rec.RewardId)
                if (reward !== undefined && index >= bestIndex) {
                    bestIndex = index
                    bestReward = reward
                }
            }
            if (baseId !== undefined && bestReward !== undefined) dynamicLast.set(baseId, bestReward)
        }
    }
    const dynamicRewardOf = (baseId: number): number => dynamicLast.get(baseId) ?? baseId
    const lastRewards = (): number[] => {
        const result: number[] = []
        for (const boss of bosses) {
            const diffs = boss.difficulties
            if (diffs.length === 0) continue
            const rewardId = toIntLocal(diffs[diffs.length - 1].reward)
            if (rewardId === undefined) continue
            result.push(dynamicRewardOf(rewardId))
        }
        return result
    }
    return { bosses, dynamicRewardOf, lastRewards }
}

export function hardBossModule(ctx: ModuleContext): VNodeTree {
    const data = ctx.getArtifact<HardBossDataArtifact>("HardBossData")
    if (!data) throw new Error("HardBossData artifact is required")
    return data.bosses.map(info => ({
        id: info.id,
        name: T(info.nameKey),
        icon: info.icon,
        desc: T(info.descKey),
        // 难度等级/奖励透传 Lua 原始值（与重构前一致，JSON 输出逐字节不变）。
        diff: info.difficulties.map(diff => ({ id: diff.id, lv: diff.level as VNodeTree, r: diff.reward as VNodeTree })),
        mid: info.monsterId as VNodeTree,
    }))
}
