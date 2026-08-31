/** Skin module - character skin metadata and unlock costs. */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

type Row = Record<string, any>

function item(ctx: ModuleContext, table: string, id: unknown): Row | undefined {
    const value = ctx.dm.getTableItem(table, id as number | string)
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : undefined
}

function rows(ctx: ModuleContext, table: string): Row[] {
    const value = ctx.dm.getTable(table)
    return value && typeof value === "object" ? (Object.values(value).filter(row => row && typeof row === "object") as Row[]) : []
}

function processRelease(value: unknown): string {
    const release = Number(value)
    if (!release) return ""
    return `${Math.floor(release / 100)}.${Math.floor((release % 100) / 10)}`
}

function iconName(value: unknown): string {
    if (!value) return ""
    if (typeof value !== "string" || !value.includes("T_")) return value as string
    const suffix = value.split("T_", 2)[1].split(".", 1)[0]
    return `T_${suffix}`.replace(/'+$/, "")
}

function defaultItemName(ctx: ModuleContext, type: string, id: string): VNodeTree {
    const normalizedId = /^\d+$/.test(id) ? Number(id) : id
    if (type === "Hair") return T(item(ctx, "Hair", normalizedId)?.Name ?? "")
    if (type === "HeadSculpture") return T(item(ctx, "HeadSculpture", normalizedId)?.Name ?? "")
    if (type === "Resource") return T(item(ctx, "Resource", normalizedId)?.ResourceName ?? "")
    if (type === "Title") return T(item(ctx, "Title", normalizedId)?.Name ?? "")
    if (type === "Char") return T(item(ctx, "Char", normalizedId)?.CharName ?? "")
    return String(id)
}

function buildDefaultItems(ctx: ModuleContext, value: unknown): VNodeTree | undefined {
    if (!value || typeof value !== "object" || Array.isArray(value)) return undefined
    const result: Record<string, VNodeTree> = {}
    for (const [type, entries] of Object.entries(value as Row)) {
        if (!entries || typeof entries !== "object" || Array.isArray(entries)) continue
        const converted: VNodeTree[] = []
        for (const [id, amount] of Object.entries(entries as Row)) {
            converted.push({ id: /^\d+$/.test(id) ? Number(id) : id, name: defaultItemName(ctx, type, id), num: amount })
        }
        if (converted.length > 0) result[type] = converted
    }
    return Object.keys(result).length > 0 ? result : undefined
}

function buildUpgrade(ctx: ModuleContext, skinId: number): VNodeTree[] | undefined {
    const upgrade = item(ctx, "SkinUpgrade", skinId)
    if (!upgrade) return undefined
    const result: VNodeTree[] = []
    for (const [stepKey, value] of Object.entries(upgrade).sort(([a], [b]) => Number(a) - Number(b))) {
        if (!value || typeof value !== "object" || Array.isArray(value)) continue
        const step = value as Row
        const currencyId = step.UnlockCurrency
        result.push({
            step: step.Step ?? (Number.isNaN(Number(stepKey)) ? stepKey : Number(stepKey)),
            amount: step.UnlockAmount ?? 0,
            currencyId,
            currency: T(item(ctx, "Resource", currencyId)?.ResourceName ?? ""),
        })
    }
    return result.length > 0 ? result : undefined
}

export function skinModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const skin of rows(ctx, "Skin")) {
        const skinId = Number(skin.SkinId ?? 0)
        if (!skinId) continue
        const output: Row = {
            id: skinId,
            name: T(skin.SkinName ?? ""),
            desc: T(skin.SkinDescribe ?? ""),
            icon: iconName(skin.Icon),
            rarity: skin.Rarity ?? 0,
        }
        if (skin.CharId !== undefined && skin.CharId !== "") output.charId = skin.CharId
        if (skin.SkinTag !== undefined && skin.SkinTag !== "") output.tag = skin.SkinTag
        if (skin.ReleaseVersion) output.release = processRelease(skin.ReleaseVersion)
        const defaults = buildDefaultItems(ctx, skin.DefaultItem)
        if (defaults) output.defaultItem = defaults
        const upgrade = buildUpgrade(ctx, skinId)
        if (upgrade) output.upgrade = upgrade
        result.push(output)
    }
    return result
}
