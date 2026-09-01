import type { ModuleContext } from "../../core/Graph.ts"
import type { VNodeTree } from "../../i18n/vnode.ts"
import { type Row, rows, sequence, table } from "../shared/dataHelpers.ts"

export function ironSurvivalMonsterSpawnModule(ctx: ModuleContext): VNodeTree {
    const survival = table(ctx, "IronSurvival")
    const valid = new Set<number>()
    const collect = (value: unknown): void => {
        if (Array.isArray(value)) value.forEach(collect)
        else if (value && typeof value === "object") Object.values(value as Row).forEach(collect)
        else {
            const n = Number(value)
            if (Number.isInteger(n)) valid.add(n)
        }
    }
    for (const item of Object.values(survival)) {
        collect((item as Row)?.MonsterSpawnId)
        collect((item as Row)?.StrongLoopSpawnId)
    }
    const result: Row[] = []
    for (const item of rows(ctx, "MonsterSpawn")) {
        const id = Number(item.UnitSpawnId)
        if (!valid.has(id)) continue
        const output: Row = { id }
        if (item.DetectTime) output.time = item.DetectTime
        if (item.Threshold) output.th = item.Threshold
        const radius = [
            item.UnitSpawnRadiusMin ?? 0,
            item.UnitSpawnRadiusMax ?? 0,
            item.PhoneUnitSpawnRadiusMin ?? 0,
            item.PhoneUnitSpawnRadiusMax ?? 0,
        ]
        if (radius.some(Boolean)) output.radius = radius
        const monsters = sequence(item.MonsterSpawnInfos)
            .filter((value): value is Row => !!value && typeof value === "object")
            .map(value => {
                const monster: Row = { id: value.UnitId, num: value.UnitNum }
                if (value.UnitNumFix !== undefined && value.UnitNumFix !== value.UnitNum) monster.numf = value.UnitNumFix
                if (value.UnitLevel) monster.lv = value.UnitLevel
                return monster
            })
        if (monsters.length) output.m = monsters
        result.push(output)
    }
    return result.sort((a, b) => a.id - b.id)
}
