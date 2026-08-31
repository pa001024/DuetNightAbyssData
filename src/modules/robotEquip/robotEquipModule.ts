/** RobotEquip module - Auto Chess rune equipment. */

import type { ModuleContext } from "../../core/Graph.ts"
import { compile, LTemplate, T, type VNode, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext): Record<string, any>[] {
    const table = ctx.dm.getTable("RobotEquip")
    if (!table || typeof table !== "object") return []
    return Object.values(table).filter((value): value is Record<string, any> => !!value && typeof value === "object")
}

function iconName(value: unknown): string {
    if (typeof value !== "string") return ""
    return value.match(/T_Activity_Autochess_Item(\d+)\./)?.[1] ? `Item${value.match(/T_Activity_Autochess_Item(\d+)\./)![1]}` : ""
}

function calculatedNumber(ctx: ModuleContext, expression: unknown): number {
    if (typeof expression !== "string" || expression.length === 0) return 0
    const calculated = ctx.dm.calcSkillDesc(expression, 1)
    const match = calculated.match(/-?\d+(?:\.\d+)?/)
    if (!match) return 0
    const value = Number(match[0])
    return calculated.includes("%") ? value / 100 : value
}

function formattedExpression(ctx: ModuleContext, expression: unknown): VNode {
    if (typeof expression !== "string" || expression.length === 0) return "0"
    return compile(ctx.dm.calcSkillDesc(expression, 1))
}

export function robotEquipModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx)) {
        const id = Number(item.EquipId ?? 0)
        if (!id) continue

        const descValues = Array.isArray(item.DescValue) ? item.DescValue : []
        const row: Record<string, VNodeTree> = {
            id,
            name: T(item.EquipName ?? ""),
            icon: iconName(item.EquipIcon),
            rarity: item.EquipRarity ?? 0,
            cost: item.DeployCost ?? 0,
            buffId: item.AttrBuffId ?? 0,
            extraBuffDesc: item.ExtraBuffDesc
                ? LTemplate(
                      String(item.ExtraBuffDesc),
                      descValues.map(value => formattedExpression(ctx, value)),
                      true
                  )
                : "",
        }

        if (item.ExtraBuffId !== undefined && item.ExtraBuffId !== null) row.extraBuffId = item.ExtraBuffId
        if (item.UnlockQuestId !== undefined && item.UnlockQuestId !== null) row.unlockQuestId = item.UnlockQuestId
        for (const [source, target] of [
            ["ATKValue", "atk"],
            ["DEFValue", "def"],
            ["HPValue", "hp"],
            ["ShieldValue", "shield"],
        ] as const) {
            const value = calculatedNumber(ctx, item[source])
            if (value !== 0) row[target] = value
        }
        result.push(row)
    }
    result.sort((a, b) => Number((a as any).id) - Number((b as any).id))
    return result
}
