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
    const template = ctx.textmap.get(key, "cn")
    const attrs = /#\d/.test(template) ? sequence(mod?.AddAttrs) : []
    const attrValues = attrs.map((attr, index) => {
        const row = attr as Row
        const value = ctx.dm.calcModAttr(id, level, index + 1)
        const attrName = String(row?.AttrName ?? "")
        if (attrName.startsWith("AttackRange")) return value / 100
        const isRate =
            row?.Rate !== undefined ||
            attrName.includes("Rate") ||
            attrName.includes("Percent") ||
            (Math.abs(value) > 0 && Math.abs(value) < 1 && !attrName.includes("Time") && !attrName.includes("Count"))
        return isRate ? `${(value * 100).toFixed(1)}%` : typeof value === "number" ? value.toFixed(1) : value
    })
    const descValues = sequence(mod?.DescValues)
    const dollarValues = descValues.map(value => compile(ctx.dm.calcModDescValue(String(value), id, level)))
    const values = [...attrValues, ...dollarValues]
    return values.length > 0 ? LTemplate(key, values, true, true, 0, { hash: attrValues, dollar: dollarValues }) : T(key)
}

function serverBuildDescription(ctx: ModuleContext, descKey: unknown, values: unknown, level = 1): VNodeTree {
    const key = typeof descKey === "string" ? descKey : ""
    if (!key) return ""
    const rendered = sequence(values).map(value => compile(ctx.dm.calcSkillDesc(String(value), level)))
    return rendered.length > 0 ? LTemplate(key, rendered, true, true) : T(key)
}

function treasureDescription(ctx: ModuleContext, item: Row): VNodeTree {
    const key = typeof item.Desc === "string" ? item.Desc : ""
    const modId = Number(item.TreasureMod ?? 0)
    const mod = modId ? (ctx.dm.getTableItem("Mod", modId) as Row | undefined) : undefined
    const hash = /#\d/.test(ctx.textmap.get(key, "cn"))
        ? sequence(mod?.AddAttrs).map((attr, index) => {
              const row = attr as Row
              const value = ctx.dm.calcModAttr(modId, 0, index + 1)
              const name = String(row?.AttrName ?? "")
              return name.startsWith("AttackRange")
                  ? value / 100
                  : row?.Rate !== undefined || name.includes("Rate") || (Math.abs(value) > 0 && Math.abs(value) < 1)
                    ? `${(value * 100).toFixed(1)}%`
                    : value.toFixed(1)
          })
        : []
    const dollar = sequence(mod?.DescValues).map(value => compile(ctx.dm.calcModDescValue(String(value), modId, 1)))
    const at = sequence(item.ServerBuildValue).map(value => compile(ctx.dm.calcSkillDesc(String(value), 1)))
    return hash.length || dollar.length || at.length
        ? LTemplate(key, [...hash, ...dollar, ...at], true, true, 0, { hash, dollar, at })
        : T(key)
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
        desc: serverBuildDescription(ctx, item.Desc, item.DescValues, 0),
        descLevels:
            Number(item.MaxLevel ?? 0) > 1
                ? Array.from({ length: Number(item.MaxLevel) }, (_, index) => {
                      const computed = sequence(item.DescValues).map(value => ctx.dm.calcSkillDesc(String(value), index))
                      const first = String(computed[0] ?? "").match(/<Highlight>(.*?)<\/>/)?.[1] ?? computed[0] ?? ""
                      const numeric = String(first).match(/^-?\d+(?:\.\d+)?%?$/)
                      return compile(
                          numeric ? `${Number(String(first).replace("%", "")).toFixed(1)}${String(first).endsWith("%") ? "%" : ""}` : first
                      )
                  })
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
        roomCondition: camelize(item.Condition ?? []) as VNodeTree,
        icon: icon(item.Icon),
        typeIcon: icon(item.TypeIcon),
        endPoints: camelize(item.EndPoints ?? []) as VNodeTree,
        shopPrices: item.ShopPrices ?? 0,
        rlArchiveId: item.RLArchiveId ?? 0,
        canSell: item.CanSell ?? 0,
    }))
}

export function rougeLikeTalentModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "RougeLikeTalent", "TalentId").map(item => ({
        id: Number(item.TalentId),
        name: T(item.Name ?? ""),
        desc: item.ServerBuildValue
            ? LTemplate(String(item.Desc), [compile(ctx.dm.calcSkillDesc(String(item.ServerBuildValue[0]), 1))], true, true, 0, {
                  at: [compile(ctx.dm.calcSkillDesc(String(item.ServerBuildValue[0]), 1))],
              })
            : linkedDescription(ctx, item.Desc, item.TalentMod, 0),
        branch: item.Branch ?? 0,
        type: item.Type ?? 0,
        maxLevel: item.MaxLevel ?? 0,
        point: item.LevelUpPoint ?? 0,
        modEquip: item.ModEquip ?? "",
        mod: item.TalentMod ?? 0,
        icon: icon(item.Icon),
        unlock: camelize(item.UnLock ?? []) as VNodeTree,
    }))
}

export function rougeLikeTreasureModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "RougeLikeTreasure", "TreasureId").map(item => ({
        id: Number(item.TreasureId),
        name: T(item.Name ?? ""),
        desc: treasureDescription(ctx, item),
        simpleDesc: T(item.SimpleDesc ?? ""),
        ipDesc: T(item.IPDesc ?? ""),
        treasureGroup: item.TreasureGroup ?? 0,
        rarity: item.TreasureRarity ?? 0,
        weight: item.TreasureWeight ?? 0,
        maxLevel: item.MaxLevel ?? 0,
        modEquip: item.ModEquip ?? "",
        mod: item.TreasureMod ?? 0,
        icon: icon(item.Icon),
        endPoints: camelize(item.EndPoints ?? []) as VNodeTree,
        shopPrices: item.ShopPrices ?? 0,
        roomCondition: camelize(item.Condition ?? []) as VNodeTree,
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

const PRO_CONFIG: Record<string, { id: string; drop?: string[]; rename?: Record<string, string>; translate?: string[] }> = {
    RougeProContract: { id: "Id", translate: ["Name", "Desc"], drop: ["DescValues"] },
    RougeProDifficulty: { id: "ID", rename: { roomLevel: "level" } },
    RougeProEffect: { id: "Id", drop: ["BuffType", "Param"] },
    RougeProSeason: {
        id: "SeasonId",
        drop: [
            "AutoNextRoundTime",
            "BossRandomRule",
            "BossShowTime",
            "ClassChooseTime",
            "ClassLockTime",
            "CollectRegionRefreshCD",
            "CowEventTime",
            "DeadDeductScore",
            "DeadDeductScoreDeadTimes",
            "MaxEventNum",
            "MRTCost",
            "MRTLimitTimes",
            "RegionUnlockTime",
            "RewardCollectTime",
            "RewardMonsterSpawnRule",
            "RewardStageTime",
            "RoundMainTime",
            "ShopRandom",
        ],
    },
    RougeProShopRandom: { id: "ShopRandom" },
    RougeProTreasureGroup: { id: "GroupId", translate: ["Name", "GroupEffectDesc"] },
    RougeProTreasureRandom: { id: "TreasureRandom" },
    RougePro_Defence: { id: "ID" },
    RougePro_Event: { id: "ID" },
    RougePro_EventArea: { id: "ID" },
    RougePro_Exterminate: { id: "ID" },
    RougePro_KillEliteMob: { id: "ID" },
    RougePro_MSRound: { id: "ID" },
    RougePro_MonsterSP: { id: "ID" },
    RougePro_Occupation: { id: "ID" },
    RougePro_RewardDropBox: { id: "ID" },
    RougePro_SabotagePro: { id: "ID" },
    RougePro_SurvivalPro: { id: "ID" },
    RougePro_Room: {
        id: "RoomId",
        drop: ["ArtDataPath", "DesignDataPath", "BossDeliveryDis", "BossDeliveryPointId"],
        rename: { roomWeight: "weight" },
    },
}

export function rougeProTableModule(ctx: ModuleContext, tableName: string): VNodeTree {
    const config = PRO_CONFIG[tableName] ?? { id: "Id" }
    const drop = new Set(config.drop ?? [])
    const source = table(ctx, tableName)
    const proRows = Object.entries(source)
        .map(([key, item]) => ({ item, id: Number((item as Row)[config.id] ?? key) }))
        .filter(({ id }) => id >= -1)
        .sort((a, b) => a.id - b.id)
    return proRows.map(({ item, id }) => {
        const row: Record<string, VNodeTree> = { id }
        for (const [source, value] of Object.entries(item)) {
            if (source === config.id || drop.has(source)) continue
            let key = camelCase(source)
            if (key === "id") continue
            if (config.rename?.[key]) key = config.rename[key]
            if (config.translate?.includes(source) && typeof value === "string") row[key] = T(value)
            else if (source === "Icon" || source === "BigIcon") row[key] = icon(value)
            else row[key] = camelize(value) as VNodeTree
        }
        if (tableName === "RougeProContract" && row.desc) row.desc = serverBuildDescription(ctx, item.Desc, item.DescValues, 0)
        return row
    })
}

export function rougeProConvertModule(ctx: ModuleContext): VNodeTree {
    const table = ctx.dm.getTable("RougeProConvert") as Row
    return [{ treasureMap: camelize(table?.TreasureMap ?? table) as VNodeTree }]
}

export function rougeProTalentModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "RougeProTalent", "TalentId").map(item => ({
        id: Number(item.TalentId),
        name: T(item.Name ?? ""),
        desc: linkedDescription(ctx, item.Desc, item.TalentMod, 0),
        branch: item.Branch ?? 0,
        type: item.Type ?? 0,
        maxLevel: item.MaxLevel ?? 0,
        point: item.LevelUpPoint ?? 0,
        modEquip: item.ModEquip ?? "",
        mod: item.TalentMod ?? 0,
        icon: icon(item.Icon),
    }))
}

export function rougeProTreasureModule(ctx: ModuleContext): VNodeTree {
    return genericRows(ctx, "RougeProTreasure", "TreasureId").map(item => {
        const row: Record<string, VNodeTree> = {
            id: Number(item.TreasureId),
            desc: T(item.Desc ?? ""),
            endPoints: camelize(item.EndPoints ?? []) as VNodeTree,
            ipDesc: T(item.IPDesc ?? ""),
            icon: icon(item.Icon),
            name: T(item.Name ?? ""),
            simpleDesc: T(item.SimpleDesc ?? ""),
            treasureGroup: item.TreasureGroup ?? 0,
            unique: item.Unique ?? false,
            rarity: item.TreasureRarity ?? 0,
            weight: item.TreasureWeight ?? 0,
        }
        if (item.ModEquip) row.modEquip = item.ModEquip
        if (!row.unique) delete row.unique
        return row
    })
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
