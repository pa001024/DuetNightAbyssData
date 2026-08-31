/** HardBoss module - 梦魇残声数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext, name: string): Record<string, any>[] {
    const table = ctx.dm.getTable(name)
    return table && typeof table === "object" ? Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[] : []
}

function iconName(...values: unknown[]): string {
    for (const value of values) {
        if (typeof value !== "string" || !value) continue
        const match = value.match(/(T_[^./']+)/)
        if (match) return match[1]
    }
    return ""
}

export function hardBossModule(ctx: ModuleContext): VNodeTree {
    const difficulty = new Map<number, Record<string, any>>()
    for (const item of rows(ctx, "HardBossDifficulty")) {
        const id = Number(item.DifficultyID)
        if (id) difficulty.set(id, item)
    }
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "HardBossMain")) {
        const id = Number(item.HardBossId)
        if (!id) continue
        const diff: VNodeTree[] = []
        for (const diffId of Array.isArray(item.DifficultyId) ? item.DifficultyId : []) {
            const info = difficulty.get(Number(diffId))
            if (info) diff.push({ id: diffId, lv: info.DifficultyLevel ?? 0, r: info.DifficultyReward ?? 0 })
        }
        result.push({ id, name: T(item.HardBossName ?? ""), icon: iconName(item.MonsterIcon, item.BossIcon, item.MainIcon), desc: T(item.HardBossDes ?? ""), diff, mid: item.MonsterId })
    }
    result.sort((a, b) => Number((a as any).id) - Number((b as any).id))
    return result
}
