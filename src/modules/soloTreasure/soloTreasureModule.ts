/** Solo treasure modules. */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function rows(ctx: ModuleContext, name: string): Record<string, any>[] {
    return Object.values(table(ctx, name)).filter(v => v && typeof v === "object") as Record<string, any>[]
}

function byId(value: Record<string, any>, id: unknown): Record<string, any> | undefined {
    return value[String(id)] ?? value[id as number]
}

function sequence(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    return Object.entries(value as Record<string, unknown>)
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

export function soloTreasureModule(ctx: ModuleContext): VNodeTree {
    const randomCreators = table(ctx, "RandomCreator")
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "SoloTreasure")) {
        const id = Number(item.DungeonId ?? 0)
        if (!id) continue
        const rainy: VNodeTree[] = []
        for (const rainyId of sequence(item.RainyRandomId)) {
            const random = byId(randomCreators, rainyId)
            if (!random) continue
            const creator: Record<string, VNodeTree> = {
                id: random.RandomId ?? rainyId,
                type: random.UnitType ?? "",
                count: random.Count ?? 0,
                rc: [],
            }
            const randomItems: VNodeTree[] = []
            for (const info of sequence(random.RandomInfos)) {
                if (!info || typeof info !== "object") continue
                const unitId = (info as Record<string, any>).UnitId
                if (!unitId) continue
                randomItems.push({ id: unitId, w: (info as Record<string, any>).Weight ?? 0 })
            }
            creator.rc = randomItems
            rainy.push(creator)
        }
        result.push({
            id,
            desc: T(item.DifficultyDesc ?? ""),
            etime: item.EvacuationTime ?? 0,
            gtime: item.GameTotalTime ?? 0,
            rtime: item.TurnRainyTime ?? 0,
            wtime: item.WarningTime ?? 0,
            gamePlayId: item.GamePlayId ?? [],
            rainy,
        })
    }
    return result
}

function buildSpawn(ctx: ModuleContext, spawnId: unknown): Record<string, VNodeTree> | undefined {
    if (!spawnId) return undefined
    const spawn = byId(table(ctx, "MonsterSpawn"), spawnId)
    if (!spawn) return undefined
    const result: Record<string, VNodeTree> = { id: spawn.UnitSpawnId ?? spawnId }
    if (spawn.DetectTime) result.time = spawn.DetectTime
    if (spawn.Threshold) result.th = spawn.Threshold
    const radius = [
        spawn.UnitSpawnRadiusMin ?? 0,
        spawn.UnitSpawnRadiusMax ?? 0,
        spawn.PhoneUnitSpawnRadiusMin ?? 0,
        spawn.PhoneUnitSpawnRadiusMax ?? 0,
    ]
    if (radius.some(value => Boolean(value))) result.radius = radius
    const monsters: VNodeTree[] = []
    for (const info of sequence(spawn.MonsterSpawnInfos)) {
        if (!info || typeof info !== "object") continue
        const item = info as Record<string, any>
        if (!item.UnitId) continue
        const monster: Record<string, VNodeTree> = { id: item.UnitId, num: item.UnitNum ?? 0 }
        if ((item.UnitNumFix ?? 0) !== (item.UnitNum ?? 0)) monster.numf = item.UnitNumFix ?? 0
        if (item.UnitLevel) monster.lv = item.UnitLevel
        monsters.push(monster)
    }
    if (monsters.length) result.m = monsters

    if (spawn.RelationId !== undefined && spawn.RelationId !== null) {
        const relation = byId(table(ctx, "RelationSpawn"), spawn.RelationId)
        if (relation) {
            const ids = sequence(relation.UnitId)
            const weights = sequence(relation.UnitWeight)
            const relationUnits: VNodeTree[] = ids.map((id, index) => {
                const item: Record<string, VNodeTree> = { id: id as VNodeTree, w: (weights[index] ?? 0) as VNodeTree }
                if (relation.UnitLevel) item.lv = relation.UnitLevel
                return item
            })
            if (relationUnits.length) result.sm = relationUnits
            if (relation.RelationSpawnTotalNum) result.smnum = relation.RelationSpawnTotalNum
        }
    }
    return result
}

function findStaticCreator(ctx: ModuleContext, containerId: unknown): Record<string, any> | undefined {
    for (const level of Object.values(table(ctx, "ServerDomLevel_data/ServerDomStaticCreator"))) {
        if (!level || typeof level !== "object") continue
        const creator = byId(level as Record<string, any>, containerId)
        if (creator) return creator
    }
    return undefined
}

function buildDom(ctx: ModuleContext, containers: unknown): VNodeTree[] {
    if (!Array.isArray(containers)) return []
    const mechanisms = table(ctx, "Mechanism")
    const result: VNodeTree[] = []
    for (const containerId of containers) {
        const creator = findStaticCreator(ctx, containerId)
        if (!creator) continue
        const mechanism = byId(mechanisms, creator.UnitId) ?? {}
        const item: Record<string, VNodeTree> = {
            id: containerId,
            type: creator.UnitType ?? "",
            uid: creator.UnitId ?? 0,
        }
        const guideIcon = String(mechanism.GuideIconBPPath ?? "")
        if (guideIcon.includes("T_Gp_")) item.icon = guideIcon.split("/").pop()?.split(".", 1)[0] ?? ""
        const tribute = Number(mechanism.UnitParams?.TributeId)
        if (Number.isFinite(tribute) && tribute !== 0) item.tributeId = tribute
        const actorLoc = creator.ActorLoc
        if (actorLoc && typeof actorLoc === "object") item.pos = [actorLoc.x ?? 0, actorLoc.y ?? 0]
        result.push(item)
    }
    return result
}

export function soloTreasureGamePlayModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx, "SoloTreasureGamePlay")) {
        const id = Number(item.GamePlayId ?? 0)
        if (!id) continue
        const row: Record<string, VNodeTree> = { id }
        const title = String(item.Title ?? "")
        if (title && !ctx.textmap.get(title, "cn").startsWith("UI_")) row.name = T(title)
        row.type = item.type ?? 0
        if (item.CountDown !== undefined && item.CountDown !== null) row.cd = item.CountDown
        if (item.TaskGains !== undefined && item.TaskGains !== null) row.gain = item.TaskGains
        const spawn = buildSpawn(ctx, item.MonsterSpawn)
        if (spawn) row.spawn = spawn
        const dom = buildDom(ctx, item.Container)
        if (dom.length) row.dom = dom
        for (let i = 1; i <= 4; i++) {
            if (item[`Gear${i}`]) row[`g${i}`] = item[`Gear${i}`]
        }
        for (let i = 1; i <= 4; i++) {
            if (item[`Monster${i}`]) row[`m${i}`] = item[`Monster${i}`]
        }
        result.push(row)
    }
    return result
}
