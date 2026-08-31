/** Abyss buff module. */

import type { ModuleContext } from "../../core/Graph.ts"
import { LTemplate, T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext): Record<string, any>[] {
    const table = ctx.dm.getTable("AbyssBuff")
    return table && typeof table === "object" ? (Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[]) : []
}

function sequence(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    return Object.entries(value as Record<string, unknown>)
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

function iconName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const match = value.match(/T_Abyss_Buff_([^./']+)/)
    return match?.[1] ?? ""
}

function formatValue(value: string): string {
    const match = value.match(/^(-?\d+(?:\.\d+)?)(.*)$/)
    if (!match) return value
    const rounded = Math.round(Number(match[1]) * 10000) / 10000
    return `${rounded}${match[2]}`
}

export function abyssBuffModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx)) {
        const id = Number(item.AbyssBuffID ?? 0)
        if (!id) continue
        const params = sequence(item.AbyssBuffParameter)
            .filter(value => typeof value === "string")
            .map(value => formatValue(ctx.dm.calcSkillDesc(value as string, Number(item.GlobalPassiveLv ?? 1))))
        const descKey = String(item.AbyssBuffDes ?? "")
        const desc: VNodeTree = LTemplate(descKey, params)
        const row: Record<string, VNodeTree> = {
            id,
            icon: iconName(item.Icon),
            n: T(item.AbyssBuffName ?? ""),
            d: desc,
            t: item.AbyssBuffType ?? 0,
        }
        if (item.BuffLockToast) row.tip = LTemplate(String(item.BuffLockToast), [])
        result.push(row)
    }
    return result
}
