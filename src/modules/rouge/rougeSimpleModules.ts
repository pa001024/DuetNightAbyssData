/** Rouge simple modules - 仅做 Lua 字段映射，不解析剧情或地图资产。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { compile, LTemplate, T, type VNodeTree } from "../../i18n/vnode.ts"

type Row = Record<string, any>

function table(ctx: ModuleContext, name: string): Row {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Row) : {}
}

function rows(ctx: ModuleContext, name: string): Row[] {
    return Object.values(table(ctx, name)).filter((item): item is Row => !!item && typeof item === "object")
}

function icon(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const short = value.split("/").pop() ?? ""
    return short.split(".", 1)[0].replace(/^'/, "").replace(/'$/, "")
}

function camelCase(key: string): string {
    return key
        .replace(/([A-Z]+)([A-Z][a-z])/g, "$1_$2")
        .replace(/([a-z0-9])([A-Z])/g, "$1_$2")
        .split(/[_-]+/)
        .filter(Boolean)
        .map((part, index) => (index === 0 ? part.toLowerCase() : `${part[0].toUpperCase()}${part.slice(1).toLowerCase()}`))
        .join("")
}

function camelize(value: unknown): unknown {
    if (Array.isArray(value)) return value.map(camelize)
    if (value && typeof value === "object") {
        const out: Record<string, unknown> = {}
        for (const [key, item] of Object.entries(value as Row)) out[camelCase(key)] = camelize(item)
        return out
    }
    return value
}

function sequence(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return value === undefined || value === null || value === "" ? [] : [value]
    return Object.entries(value as Row)
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

function linkedDescription(ctx: ModuleContext, descKey: unknown, modId: unknown, level = 1): VNodeTree {
    const key = typeof descKey === "string" ? descKey : ""
    if (!key) return ""
    const id = Number(modId ?? 0)
    const mod = id ? (ctx.dm.getTableItem("Mod", id) as Row | undefined) : undefined
    const values = sequence(mod?.DescValues).map(value => compile(ctx.dm.calcModDescValue(String(value), id, level)))
    return values.length > 0 ? LTemplate(key, values, true) : T(key)
}

function serverBuildDescription(ctx: ModuleContext, descKey: unknown, values: unknown, level = 1): VNodeTree {
    const key = typeof descKey === "string" ? descKey : ""
    if (!key) return ""
    const rendered = sequence(values).map(value => compile(ctx.dm.calcSkillDesc(String(value), level)))
    return rendered.length > 0 ? LTemplate(key, rendered, true) : T(key)
}

function genericRows(ctx: ModuleContext, tableName: string, idField: string): Row[] {
    return rows(ctx, tableName)
        .map(item => ({ item, id: Number(item[idField] ?? 0) }))
        .filter(({ id }) => id > 0)
        .sort((a, b) => a.id - b.id)
        .map(({ item }) => item)
}

export function rougeLikeBlessingGroupModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "BlessingGroup", "GroupId").map(item => ({
        id: Number(item.GroupId),
        name: T(item.Name ?? ""),
        icon: icon(item.Icon),
        bigIcon: icon(item.BigIcon),
        activateNeed: camelize(item.ActivateNeed) as VNodeTree,
        groupEffectDesc: T(item.GroupEffectDesc ?? ""),
    }))
}

export function rougeLikeTreasureGroupModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "TreasureGroup", "GroupId").map(item => ({
        id: Number(item.GroupId),
        name: T(item.Name ?? ""),
        icon: icon(item.Icon),
        bigIcon: icon(item.BigIcon),
        activateNeed: camelize(item.ActivateNeed) as VNodeTree,
        groupEffectDesc: T(item.GroupEffectDesc ?? ""),
    }))
}

export function rougeLikeContractModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "RougeLikeContract", "Id").map(item => ({
        id: Number(item.Id),
        name: T(item.Name ?? ""),
        desc: serverBuildDescription(ctx, item.Desc, item.DescValues, 1),
        descLevels:
            Number(item.MaxLevel ?? 0) > 1
                ? Array.from({ length: Number(item.MaxLevel) }, (_, index) =>
                      serverBuildDescription(ctx, item.Desc, item.DescValues, index + 1)
                  )
                : [],
        globalPassiveId: item.GlobalPassiveId ?? 0,
        heatValue: item.HeatValue ?? 0,
        icon: icon(item.Icon),
        maxLevel: item.MaxLevel ?? 0,
    }))
}

export function rougeLikeBlessingModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "RougeLikeBlessing", "BlessingId").map(item => ({
        id: Number(item.BlessingId),
        name: T(item.Name ?? ""),
        desc: linkedDescription(ctx, item.Desc, item.BlessingMod),
        simpleDesc: T(item.SimpleDesc ?? ""),
        blessingGroup: item.BlessingGroup ?? 0,
        rarity: item.BlessingRarity ?? 0,
        weight: item.BlessingWeight ?? 0,
        maxLevel: item.MaxLevel ?? 0,
        modEquip: item.ModEquip ?? "",
        roomCondition: camelize(item.Condition) as VNodeTree,
        icon: icon(item.Icon),
        typeIcon: icon(item.TypeIcon),
        endPoints: camelize(item.EndPoints) as VNodeTree,
        shopPrices: item.ShopPrices ?? 0,
        rlArchiveId: item.RLArchiveId ?? 0,
        canSell: item.CanSell ?? 0,
    }))
}

export function rougeLikeTalentModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "RougeLikeTalent", "TalentId").map(item => ({
        id: Number(item.TalentId),
        name: T(item.Name ?? ""),
        desc: linkedDescription(ctx, item.Desc, item.TalentMod),
        branch: item.Branch ?? 0,
        type: item.Type ?? 0,
        maxLevel: item.MaxLevel ?? 0,
        point: item.LevelUpPoint ?? 0,
        modEquip: item.ModEquip ?? "",
        mod: item.TalentMod ?? 0,
        icon: icon(item.Icon),
        unlock: camelize(item.UnLock) as VNodeTree,
    }))
}

export function rougeLikeTreasureModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "RougeLikeTreasure", "TreasureId").map(item => ({
        id: Number(item.TreasureId),
        name: T(item.Name ?? ""),
        desc: item.ServerBuildValue
            ? serverBuildDescription(ctx, item.Desc, item.ServerBuildValue)
            : linkedDescription(ctx, item.Desc, item.TreasureMod),
        simpleDesc: T(item.SimpleDesc ?? ""),
        ipDesc: T(item.IPDesc ?? ""),
        treasureGroup: item.TreasureGroup ?? 0,
        rarity: item.TreasureRarity ?? 0,
        weight: item.TreasureWeight ?? 0,
        maxLevel: item.MaxLevel ?? 0,
        modEquip: item.ModEquip ?? "",
        mod: item.TreasureMod ?? 0,
        icon: icon(item.Icon),
        endPoints: camelize(item.EndPoints) as VNodeTree,
        shopPrices: item.ShopPrices ?? 0,
        roomCondition: camelize(item.Condition) as VNodeTree,
        rlArchiveId: item.RLArchiveId ?? 0,
        canSell: item.CanSell ?? 0,
    }))
}

export function rougeProClassModule(ctx: ModuleContext): VNodeTree {
    const output: VNodeTree[] = []
    for (const item of rows(ctx, "RougeProClass")) {
        const id = Number(item.Id ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id }
        for (const [key, value] of Object.entries(item)) {
            if (key === "Id") continue
            const target = camelCase(key)
            if (key === "Name" || key === "Desc") row[target] = T(value as string)
            else row[target] = camelize(value) as VNodeTree
        }
        output.push(row)
    }
    output.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    return output
}

export function rougeLikeTalentBranchModule(ctx: ModuleContext): VNodeTree {
    const output: VNodeTree[] = []
    for (const item of rows(ctx, "RougeLikeTalentBranch")) {
        const id = Number(item.BranchId ?? 0)
        if (!id) continue
        output.push({
            id,
            name: T(item.Name ?? ""),
            subTitle: T(item.SubTitle ?? ""),
            icon: icon(item.Icon),
        })
    }
    output.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    return output
}
