/** Extraction treasure modules - 秘宝、背包和机关配置。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

type Row = Record<string, any>

function table(ctx: ModuleContext, name: string): Row {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Row) : {}
}

function integer(value: unknown): number | undefined {
    const n = Number(value)
    return Number.isFinite(n) ? Math.trunc(n) : undefined
}

function icon(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const short = value.split("/").pop() ?? ""
    return short.split(".", 1)[0]
}

function shape(value: unknown): number[] {
    if (!Array.isArray(value)) return []
    return value.map(integer).filter((item): item is number => item !== undefined)
}

function shape2d(value: unknown): number[][] {
    if (!Array.isArray(value)) return []
    return value
        .filter(Array.isArray)
        .map(row => row.map(integer).filter((item): item is number => item !== undefined))
        .filter(row => row.length >= 2)
        .map(row => row.slice(0, 2))
}

function rows(ctx: ModuleContext, name: string): Row[] {
    return Object.values(table(ctx, name)).filter((item): item is Row => !!item && typeof item === "object")
}

export function extractionTreasureModule(ctx: ModuleContext): VNodeTree {
    const output: VNodeTree[] = []
    for (const item of rows(ctx, "ExtractionTreasure")) {
        const id = integer(item.TreasureId)
        if (!id) continue
        const row: Record<string, VNodeTree> = {
            id,
            name: T(item.Name ?? ""),
            icon: icon(item.Icon),
            shape: shape(item.Shape),
            type: item.TreasureType ?? 0,
            rarity: item.TreasureRarity ?? 0,
            value: item.TreasureValue ?? 0,
        }
        output.push(row)
    }
    output.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    return output
}

export function extractionTreasureBagModule(ctx: ModuleContext): VNodeTree {
    const output: VNodeTree[] = []
    for (const item of rows(ctx, "ExtractionTreasureBag")) {
        const id = integer(item.BagID)
        if (!id) continue
        const row: Record<string, VNodeTree> = {
            id,
            name: T(item.Name ?? ""),
            desc: item.Desc ?? "",
            price: item.Price ?? 0,
            shape: shape2d(item.Shape),
            shapeType: item.ShapeType ?? 0,
        }
        if (item.EventUnlockCondition !== undefined && item.EventUnlockCondition !== null)
            row.eventUnlockCondition = item.EventUnlockCondition
        if (item.ShopItemId !== undefined && item.ShopItemId !== null) row.shopItemId = item.ShopItemId
        output.push(row)
    }
    output.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    return output
}

function numberMap(value: unknown): Record<string, VNodeTree> {
    if (!value || typeof value !== "object" || Array.isArray(value)) return {}
    return Object.fromEntries(Object.entries(value as Row).map(([key, item]) => [String(integer(key) ?? key), item as VNodeTree]))
}

export function extractionTreasureMechanismModule(ctx: ModuleContext): VNodeTree {
    const output: VNodeTree[] = []
    for (const item of rows(ctx, "ExtractionTreasureMechanism")) {
        const id = integer(item.MechanismID)
        if (!id) continue
        const row: Record<string, VNodeTree> = {
            id,
            name: T(item.MechanismName ?? ""),
            itemLevelLimit: numberMap(item.ItemLevelLimit),
            itemLevelWeight: numberMap(item.ItemLevelWeight),
            itemNumRange: shape(item.ItemNumRange),
            shape: shape(item.Shape),
        }
        output.push(row)
    }
    output.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    return output
}
