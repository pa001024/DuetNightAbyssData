/** Backpack puzzle item/level modules. */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext, name: string): Record<string, any>[] {
    const table = ctx.dm.getTable(name)
    return table && typeof table === "object" ? Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[] : []
}

function grid(value: unknown): number[][] {
    if (Array.isArray(value)) return value.filter(Array.isArray).map(row => (row as unknown[]).map(v => v == null ? 0 : Number(v)))
    if (typeof value !== "string") return []
    const clean = value.replaceAll("\\n", "").replaceAll("/n", "").replaceAll("\r", "").replaceAll("\n", "")
    const result: number[][] = []
    for (const match of clean.matchAll(/\[([^\]]+)\]/g)) {
        const row = [...match[1].matchAll(/-?\d+/g)].map(v => Number(v[0]))
        if (row.length > 0) result.push(row)
    }
    return result
}

function icon(value: unknown): string {
    return typeof value === "string" ? value.match(/(T_[^./']+)/)?.[1] ?? "" : ""
}

export function backpackPuzzleItemModule(ctx: ModuleContext): VNodeTree {
    const templates = new Map<number, Record<string, any>>()
    for (const item of rows(ctx, "PuzzleItemTemplate")) {
        const id = Number(item.ItemId)
        if (id) templates.set(id, item)
    }
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "PuzzleItemAttr")) {
        const id = Number(item.ItemId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id, name: T(item.ItemName ?? ""), type: item.ItemType ?? "", itemGrid: grid(item.ItemGrid) }
        const itemIcon = icon(item.GUIPath)
        if (itemIcon) row.icon = itemIcon
        for (const [source, target] of [["BasicPoint", "basicPoint"], ["MaxAmmo", "maxAmmo"], ["MaxStack", "maxStack"]] as const) {
            if (item[source] !== undefined && item[source] !== null) row[target] = item[source]
        }
        if (item.IsMirror) row.isMirror = true
        const template = templates.get(id)
        if (template?.CurrentAmmo !== undefined) row.currentAmmo = template.CurrentAmmo
        if (template?.CurrentStack !== undefined) row.currentStack = template.CurrentStack
        if (!row.name) delete row.name
        if (!row.type) delete row.type
        if (!(row.itemGrid as number[][]).length) delete row.itemGrid
        result.push(row)
    }
    return result
}

export function backpackPuzzleLevelModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "BackpackPuzzleLevel")) {
        const id = Number(item.LevelId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = {
            id,
            eventId: item.EventId ?? 0,
            name: T(item.LevelName ?? ""),
            desc: T(item.LevelDes ?? ""),
            gridDistribute: grid(item.GridDistribute),
            levelInitialItem: item.LevelInitialItem ?? [],
            targetReward: item.TargetReward ?? [],
            targetScore: item.TargetScore ?? [],
        }
        if (item.UnlockDate !== undefined && item.UnlockDate !== null) row.unlockDate = item.UnlockDate
        if (!row.eventId) delete row.eventId
        if (!row.name) delete row.name
        if (!row.desc) delete row.desc
        if (!row.unlockDate) delete row.unlockDate
        result.push(row)
    }
    return result
}
