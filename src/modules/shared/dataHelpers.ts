import type { ModuleContext } from "../../core/Graph.ts"

export type Row = Record<string, any>

export function table(ctx: ModuleContext, name: string): Row {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Row) : {}
}

export function rows(ctx: ModuleContext, name: string): Row[] {
    return Object.values(table(ctx, name)).filter((value): value is Row => !!value && typeof value === "object" && !Array.isArray(value))
}

export function sequence(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    return Object.entries(value as Row)
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

export function iconName(value: unknown): string {
    if (typeof value !== "string") return ""
    const name = value.split(/[./]/).at(-1)?.replaceAll("'", "") ?? ""
    return name.startsWith("T_Head_") ? name.slice("T_Head_".length) : name
}

export function camelCase(value: unknown): unknown {
    if (Array.isArray(value)) return value.map(camelCase)
    if (!value || typeof value !== "object") return value
    const out: Row = {}
    for (const [key, item] of Object.entries(value as Row)) out[key ? key[0].toLowerCase() + key.slice(1) : key] = camelCase(item)
    return out
}

export function putIfPresent(out: Row, key: string, value: unknown): void {
    if (value === undefined || value === null || value === "") return
    if (Array.isArray(value) && value.length === 0) return
    out[key] = value
}
