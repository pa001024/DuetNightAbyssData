/** Treasure hunt progress and dungeon modules. */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext, tableName: string): Record<string, any>[] {
    const table = ctx.dm.getTable(tableName)
    return table && typeof table === "object" ? (Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[]) : []
}

function iconName(value: unknown): string {
    if (typeof value !== "string" || !value) return ""
    const normalized = value
        .replaceAll("\\", "/")
        .trim()
        .replace(/^'+|'+$/g, "")
    const base = normalized.split("/").pop() ?? ""
    return (base.split(".", 1)[0] ?? "").replace(/^'+|'+$/g, "")
}

export function treasureHuntProgressModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "TreasureHuntProgress")) {
        const id = Number(item.EventProgressId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id }
        if (item.EventDugeonId) row.did = item.EventDugeonId
        if (item.EventProgressText) row.name = T(item.EventProgressText)
        if (item.NextProgressScore !== undefined && item.NextProgressScore !== null) row.score = item.NextProgressScore
        const icon = iconName(item.PetConBP)
        if (icon) row.icon = icon
        if (item.PetConText) row.petConText = T(item.PetConText)
        if (item.ProgressCondition !== undefined && item.ProgressCondition !== null) row.condition = item.ProgressCondition
        result.push(row)
    }
    return result
}

export function treasureHuntRepeatDungeonModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "TreasureHuntRepeatDungeon")) {
        const id = Number(item.EventDugeonId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id }
        if (item.DungeonName) row.name = T(item.DungeonName)
        if (item.DungeonDes) row.desc = T(item.DungeonDes)
        const image = iconName(item.DungeonImage)
        if (image) row.image = image
        for (const [source, target] of [
            ["EasyDungeonId", "easyDungeonId"],
            ["EasyModeFee", "easyModeFee"],
            ["HardDungeonId", "hardDungeonId"],
            ["HardModeFee", "hardModeFee"],
            ["EasyMaxConvertResource", "easyMaxConvertResource"],
            ["EasyScoreToResource", "easyScoreToResource"],
            ["HardMaxConvertResource", "hardMaxConvertResource"],
            ["HardScoreToResource", "hardScoreToResource"],
        ] as const) {
            if (item[source] !== undefined && item[source] !== null) row[target] = item[source]
        }
        row.banEasyPhantom = Boolean(item.IsBanEasyPhantom)
        row.banHardPhantom = Boolean(item.IsBanHardPhantom)
        for (const [source, target] of [
            ["LevelBackPack", "levelBackPack"],
            ["TrialCharacter", "trialCharacter"],
            ["TrialWeapon", "trialWeapon"],
        ] as const) {
            if (Array.isArray(item[source]) && item[source].length > 0) row[target] = item[source]
        }
        if (item.UnlockCondition !== undefined && item.UnlockCondition !== null) row.unlockCondition = item.UnlockCondition
        result.push(row)
    }
    return result
}

export function treasureHuntStoryDungeonModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "TreasureHuntStoryDungeon")) {
        const id = Number(item.EventDugeonId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id }
        if (item.DungeonId) row.did = item.DungeonId
        if (item.DungeonName) row.name = T(item.DungeonName)
        if (item.DungeonDes) row.desc = T(item.DungeonDes)
        const image = iconName(item.DungeonImage)
        if (image) row.image = image
        for (const [source, target] of [
            ["Fee", "fee"],
            ["FeeResource", "feeResource"],
        ] as const) {
            if (item[source] !== undefined && item[source] !== null) row[target] = item[source]
        }
        row.banPhantom = Boolean(item.IsBanPhantom)
        for (const [source, target] of [
            ["LevelBackPack", "levelBackPack"],
            ["LimitCharacter", "limitCharacter"],
            ["TrialCharacter", "trialCharacter"],
            ["TrialPet", "trialPet"],
            ["TrialWeapon", "trialWeapon"],
        ] as const) {
            if (Array.isArray(item[source]) && item[source].length > 0) row[target] = item[source]
        }
        if (item.UnlockCondition !== undefined && item.UnlockCondition !== null) row.unlockCondition = item.UnlockCondition
        result.push(row)
    }
    return result
}
