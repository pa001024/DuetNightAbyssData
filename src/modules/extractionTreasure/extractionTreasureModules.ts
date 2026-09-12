/** Extraction treasure modules - 秘宝、背包和机关配置。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import type { SoloTreasureDropRow } from "../soloTreasure/soloTreasureModule.ts"

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

/** 部件蓝图短名（去目录与扩展名），如 BP_Container_Medium3。 */
function bpName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    return (value.split("/").pop() ?? "").split(".", 1)[0]
}

/**
 * ItemLevelLimit / ItemLevelWeight：键是物品等级。
 * Lua 稀疏表读回为对象，等级连续（1..n）时读回为数组；后者必须按 下标 + 1 还原等级，
 * 否则会被当成非对象直接丢弃（整段爆率变空）。
 */
function levelMap(value: unknown): Record<string, VNodeTree> {
    if (Array.isArray(value)) return Object.fromEntries(value.map((item, index) => [String(index + 1), item as VNodeTree]))
    if (!value || typeof value !== "object") return {}
    return Object.fromEntries(Object.entries(value as Row).map(([key, item]) => [String(integer(key) ?? key), item as VNodeTree]))
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

export function extractionTreasureMechanismModule(ctx: ModuleContext): VNodeTree {
    const output: VNodeTree[] = []
    for (const item of rows(ctx, "ExtractionTreasureMechanism")) {
        const id = integer(item.MechanismID)
        if (!id) continue
        const row: Record<string, VNodeTree> = {
            id,
            name: T(item.MechanismName ?? ""),
            itemLevelLimit: levelMap(item.ItemLevelLimit),
            itemLevelWeight: levelMap(item.ItemLevelWeight),
            itemNumRange: shape(item.ItemNumRange),
            shape: shape(item.Shape),
        }
        output.push(row)
    }
    output.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    return output
}

/**
 * ExtractionTreasureContainer：秘宝容器实体表，覆盖 ExtractionTreasureMechanism 的全部容器
 * （撤离与单人寻宝共用，不按玩法过滤）。
 * 名字是翻译 key（如 UI_Extraction_TM_55 = 中型竹篓），实体外形取 Mechanism.UnitBPPath；
 * 爆率全库只存在于 SoloTreasureDrop 的 BoxDropRate，经 DropMechanismId 关联到容器，
 * 未被该表引用的容器没有 dropRate 字段。
 */
export function extractionTreasureContainerModule(ctx: ModuleContext): VNodeTree {
    // 产出文件的模块其 artifact 是 { 文件名: 树 }，这里按 SoloTreasureDrop.json 取出整表。
    const drops = ctx.getArtifact<{ SoloTreasureDrop?: SoloTreasureDropRow[] }>("SoloTreasureDrop")?.SoloTreasureDrop
    if (!drops) throw new Error("ExtractionTreasureContainer 依赖 SoloTreasureDrop 产物")

    const rates = new Map<number, number>()
    for (const drop of drops) {
        const id = integer(drop.dropMechanismId)
        if (!id) continue
        const rate = Number(drop.boxDropRate ?? 0)
        const known = rates.get(id)
        // 同一容器被多个标签引用且爆率不同时口径不唯一，报错而不是静默取其一。
        if (known !== undefined && known !== rate)
            throw new Error(`容器 ${id} 在 SoloTreasureDrop 中存在多个 BoxDropRate: ${known} / ${rate}`)
        rates.set(id, rate)
    }

    const mechanisms = table(ctx, "Mechanism")
    const output: VNodeTree[] = []
    for (const item of rows(ctx, "ExtractionTreasureMechanism")) {
        const id = integer(item.MechanismID)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id, name: T(item.MechanismName ?? "") }
        const rate = rates.get(id)
        if (rate !== undefined) row.dropRate = rate
        row.bp = bpName(mechanisms[String(id)]?.UnitBPPath)
        row.itemLevelLimit = levelMap(item.ItemLevelLimit)
        row.itemLevelWeight = levelMap(item.ItemLevelWeight)
        row.itemNumRange = shape(item.ItemNumRange)
        row.shape = shape(item.Shape)
        output.push(row)
    }
    output.sort((a, b) => Number((a as Row).id) - Number((b as Row).id))
    return output
}
