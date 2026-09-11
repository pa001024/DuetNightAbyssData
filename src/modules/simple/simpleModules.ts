import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function iconName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    return value.match(/(T_[^./']+)/)?.[1] ?? ""
}

function rows(ctx: ModuleContext, tableName: string): Record<string, any>[] {
    const table = ctx.dm.getTable(tableName)
    return table && typeof table === "object" ? (Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[]) : []
}

function basicCosmetic(ctx: ModuleContext, tableName: string, idField: string, descField: string, includeRarity = true): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, tableName)) {
        if (item.IsHide) continue
        const id = Number(item[idField] ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = {
            id,
            name: T(item.Name ?? ""),
            desc: T(item[descField] ?? ""),
            icon: iconName(item.Icon),
        }
        if (includeRarity) row.rarity = item.Rarity ?? 0
        row.unlock = T(item.UnlockOption ?? "")
        result.push(row)
    }
    result.sort((a, b) => Number((a as any).id) - Number((b as any).id))
    return result
}

export function weaponAccessoryModule(ctx: ModuleContext): VNodeTree {
    return basicCosmetic(ctx, "WeaponAccessory", "WeaponAccessoryId", "Des")
}

export function weaponSkinModule(ctx: ModuleContext): VNodeTree {
    const result = basicCosmetic(ctx, "WeaponSkin", "SkinID", "Dec") as VNodeTree[]
    for (const item of result as Array<Record<string, VNodeTree>>) {
        if (item.icon === "T_Head_Bow_jinggong") item.icon = "T_Head_Bow_Jinggong"
    }
    return result
}

export function headFrameModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "HeadFrame")) {
        const id = Number(item.FrameID ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id, name: T(item.Name ?? ""), desc: T(item.Des ?? ""), icon: iconName(item.Icon) }
        if (item.AccessText) row.access = T(item.AccessText)
        result.push(row)
    }
    result.sort((a, b) => Number((a as any).id) - Number((b as any).id))
    return result
}

export function titleFrameModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "TitleFrame")) {
        const id = Number(item.TitleFrameID ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id, name: T(item.Name ?? ""), desc: T(item.Des ?? ""), icon: iconName(item.Icon) }
        if (item.AccessText) row.access = T(item.AccessText)
        result.push(row)
    }
    result.sort((a, b) => Number((a as any).id) - Number((b as any).id))
    return result
}

export function headSculptureModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "HeadSculpture")) {
        const id = Number(item.HeadId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id, name: T(item.Name ?? ""), desc: T(item.Des ?? ""), icon: iconName(item.Icon) }
        if (item.UnlockOption && ctx.textmap.get(item.UnlockOption, "cn") !== item.UnlockOption) row.unlock = T(item.UnlockOption)
        result.push(row)
    }
    result.sort((a, b) => Number((a as any).id) - Number((b as any).id))
    return result
}

export function hairModule(ctx: ModuleContext): VNodeTree {
    const skinRows = rows(ctx, "Skin")
    const fallback = new Map<string, string>()
    for (const skin of skinRows) {
        const ids = new Set<string>()
        if (skin.AutoHair) ids.add(String(skin.AutoHair))
        if (skin.DefaultItem?.Hair && typeof skin.DefaultItem.Hair === "object")
            for (const id of Object.keys(skin.DefaultItem.Hair)) ids.add(id)
        for (const id of ids) if (skin.SkinName) fallback.set(id, skin.SkinName)
    }
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "Hair")) {
        const id = Number(item.HairId ?? 0)
        if (!id) continue
        const nameKey = item.Name || fallback.get(String(id))
        const icon = iconName(item.Icon)
        if (!nameKey || !icon) continue
        const row: Record<string, VNodeTree> = {
            id,
            name: T(nameKey),
            ...(item.HairDescribe ? { desc: T(item.HairDescribe) } : {}),
            icon,
            rarity: item.Rarity ?? 0,
        }
        if (item.CharId !== undefined && item.CharId !== "") row.charId = item.CharId
        result.push(row)
    }
    result.sort((a, b) => Number((a as any).id) - Number((b as any).id))
    return result
}
