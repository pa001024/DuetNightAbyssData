/** RaidBuff module - raid global passive descriptions. */

import type { ModuleContext } from "../../core/Graph.ts"
import { LTemplate, type VNodeTree } from "../../i18n/vnode.ts"

function normalizeParameters(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    const entries = Object.entries(value as Record<string, unknown>)
        .filter(([key]) => /^\d+$/.test(key) && Number(key) > 0)
        .map(([key, item]) => [Number(key), item] as const)
    if (entries.length === 0) return []
    const result: unknown[] = []
    for (const [index, item] of entries) result[index - 1] = item
    return result
}

function rows(ctx: ModuleContext): Record<string, any>[] {
    const table = ctx.dm.getTable("RaidBuff")
    if (!table || typeof table !== "object") return []
    return Object.values(table).filter((value): value is Record<string, any> => !!value && typeof value === "object")
}

function formatParameter(value: string): string {
    return value.replace(/-?\d+(?:\.\d+)?/g, token => {
        const number = Number(token)
        if (!Number.isFinite(number)) return token
        return Number.isInteger(number) ? String(number) : String(Number(number.toFixed(4)))
    })
}

export function raidBuffModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx)) {
        const id = Number(item.RaidBuffID ?? 0)
        if (!id) continue
        const parameters = normalizeParameters(item.RaidBuffParameter)
        const renderedParameters = parameters.map(value =>
            typeof value === "string" ? formatParameter(ctx.dm.calcSkillDesc(value, 1)) : (value as VNodeTree)
        )
        result.push({
            RaidBuffID: id,
            RaidBuffDes: LTemplate(String(item.RaidBuffDes ?? ""), renderedParameters as any),
            RaidBuffParameter: renderedParameters,
        })
    }
    result.sort((a, b) => Number((a as any).RaidBuffID) - Number((b as any).RaidBuffID))
    return result
}
