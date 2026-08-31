/** Monster module - 图鉴怪物及战斗属性。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function row(ctx: ModuleContext, name: string, id: unknown): Record<string, any> | undefined {
    const rows = table(ctx, name)
    if (Array.isArray(rows)) {
        const index = Number(id) - 1
        return Number.isInteger(index) && index >= 0 ? (rows[index] as Record<string, any> | undefined) : undefined
    }
    return rows[String(id)] ?? rows[id as number]
}

function list(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return value === undefined || value === null || value === "" ? [] : [value]
    return Object.entries(value as Record<string, unknown>)
        .filter(([key]) => /^\d+$/.test(key))
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

function addNumbers(set: Set<number>, value: unknown): void {
    for (const item of list(value)) {
        const n = Number(item)
        if (Number.isFinite(n) && n) set.add(n)
    }
}

function addSpawnSources(ctx: ModuleContext, valid: Set<number>, dungeon: Record<string, any>): void {
    const monsterSpawns = table(ctx, "MonsterSpawn")
    const relations = table(ctx, "RelationSpawn")
    const sourceNames = [
        "DefencePro",
        "Defence",
        "DefenceMove",
        "Survival",
        "SurvivalMini",
        "SurvivalMiniPro",
        "SurvivalPro",
        "IronSurvival",
        "Excavation",
        "ExtermPro",
        "Exterminate",
        "SabotagePro",
    ]
    const byDungeon = new Map<number, Record<string, any>>()
    for (const name of sourceNames) {
        for (const item of Object.values(table(ctx, name))) {
            if (item && typeof item === "object" && Number((item as any).DungeonId))
                byDungeon.set(Number((item as any).DungeonId), item as Record<string, any>)
        }
    }
    for (const [dungeonIdText, dungeonInfo] of Object.entries(dungeon)) {
        const dungeonId = Number(dungeonIdText)
        if (!Number.isFinite(dungeonId) || dungeonId <= 20000 || !dungeonInfo || typeof dungeonInfo !== "object") continue
        const source = byDungeon.get(dungeonId)
        if (!source) continue
        const waves: unknown[] = []
        const append = (value: unknown, split = false) => {
            const values = list(value)
            if (values.length === 0) return
            if (Array.isArray(value) && values.every(item => Array.isArray(item))) waves.push(...values)
            else if (split) for (const item of values) waves.push([item])
            else waves.push(values)
        }
        append(source.WaveSpawnRule, true)
        for (const key of [
            "MonsterFirstSpawnId",
            "MonsterSpawnId",
            "MonsterSpawnIds",
            "StrongLoopSpawnId",
            "OnInitSpawnRule",
            "NormalSpawnRule",
            "EliteSpawnRule",
            "SpMonsterSpawnId",
        ])
            append(source[key])
        for (const item of list(source.SpMonster)) if (item && typeof item === "object") append((item as any).SpMonsterSpawnId)
        for (const item of list(source.Excavation)) if (item && typeof item === "object") append((item as any).MonsterSpawnId)
        for (const wave of waves) {
            for (const spawnId of list(wave)) {
                const spawn = monsterSpawns[String(spawnId)] ?? monsterSpawns[spawnId as number]
                if (!spawn) continue
                for (const info of list(spawn.MonsterSpawnInfos))
                    if (info && typeof info === "object") addNumbers(valid, (info as any).UnitId)
                const relation = relations[String(spawn.RelationId)] ?? relations[spawn.RelationId as number]
                if (relation) addNumbers(valid, relation.UnitId)
            }
        }
    }
}

function validMonsterIds(ctx: ModuleContext): Set<number> {
    const valid = new Set<number>()
    const gallery = table(ctx, "GalleryRule")
    for (const id of Object.keys(gallery)) if (Number(id)) valid.add(Number(id))
    const dungeon = table(ctx, "Dungeon")
    for (const [idText, info] of Object.entries(dungeon)) {
        const id = Number(idText)
        if (!Number.isFinite(id) || id <= 20000 || !info || typeof info !== "object") continue
        addNumbers(valid, (info as any).DungeonMonsters)
        const overrides = (info as any).BPOverrideVars
        if (overrides && typeof overrides === "object") for (const key of ["BossID", "Elite1", "Elite2"]) addNumbers(valid, overrides[key])
        addNumbers(valid, (info as any).DungeonInitGuideUnitId)
    }
    const weaponVerify = table(ctx, "WeaponVerify")
    for (const info of Object.values(weaponVerify)) if (info && typeof info === "object") addNumbers(valid, (info as any).DungeonMonsters)

    const solo = table(ctx, "SoloTreasure")
    const randomCreators = table(ctx, "RandomCreator")
    for (const info of Object.values(solo)) {
        if (!info || typeof info !== "object") continue
        for (const randomId of list((info as any).RainyRandomId)) {
            const creator = randomCreators[String(randomId)] ?? randomCreators[randomId as number]
            if (!creator || typeof creator !== "object") continue
            for (const randomInfo of list((creator as any).RandomInfos))
                if (randomInfo && typeof randomInfo === "object") addNumbers(valid, (randomInfo as any).UnitId)
        }
    }
    const soloGameplay = table(ctx, "SoloTreasureGamePlay")
    const monsterSpawns = table(ctx, "MonsterSpawn")
    const relations = table(ctx, "RelationSpawn")
    for (const info of Object.values(soloGameplay)) {
        if (!info || typeof info !== "object") continue
        for (let i = 1; i <= 4; i++) addNumbers(valid, (info as any)[`Monster${i}`])
        const spawn = monsterSpawns[String((info as any).MonsterSpawn)] ?? monsterSpawns[(info as any).MonsterSpawn]
        if (!spawn) continue
        for (const spawnInfo of list(spawn.MonsterSpawnInfos))
            if (spawnInfo && typeof spawnInfo === "object") addNumbers(valid, (spawnInfo as any).UnitId)
        const relation = relations[String(spawn.RelationId)] ?? relations[spawn.RelationId]
        if (relation) addNumbers(valid, relation.UnitId)
    }
    for (const info of Object.values(table(ctx, "AbyssDungeon")))
        if (info && typeof info === "object") addNumbers(valid, (info as any).DungeonMonsters)
    for (const info of list(table(ctx, "AsyncCombat"))) if (info && typeof info === "object") addNumbers(valid, (info as any).BossUnitID)
    for (const info of list(table(ctx, "HardBossMain"))) if (info && typeof info === "object") addNumbers(valid, (info as any).MonsterId)
    addSpawnSources(ctx, valid, dungeon)
    return valid
}

function iconFor(ctx: ModuleContext, monster: Record<string, any>, modelToIcon: Map<number, string>): string {
    const modelId = Number(monster.ModelId)
    if (modelId && modelToIcon.has(modelId)) return modelToIcon.get(modelId)!
    const gallery = row(ctx, "GalleryRule", monster.GalleryRuleId ?? monster.UnitId)
    const path = gallery?.MonsterIcon
    if (typeof path !== "string") return ""
    const match = path.match(/T_Head_([^./']+)/)
    return match?.[1] ?? ""
}

export function monsterModule(ctx: ModuleContext): VNodeTree {
    const valid = validMonsterIds(ctx)
    const tabs = table(ctx, "ArchiveTab")
    const tabFinal: Record<string, number> = { "Mon.Gr": 1, "Mon.Jt": 2, "Mon.Sq": 3, "Mon.Jh": 4, "Mon.Hx": 5 }
    const tabNames = new Set(
        Object.values(tabs)
            .filter(v => v && typeof v === "object")
            .map(v => String((v as any).TabPara))
    )
    const unitToModel = new Map<number, number>()
    for (const item of Object.values(table(ctx, "Monster"))) {
        if (item && typeof item === "object" && Number((item as any).UnitId) && Number((item as any).ModelId))
            unitToModel.set(Number((item as any).UnitId), Number((item as any).ModelId))
    }
    const modelToIcon = new Map<number, string>()
    for (const info of Object.values(table(ctx, "GalleryRule"))) {
        if (!info || typeof info !== "object") continue
        const preferred = Number((info as any).PreferredMonsterId)
        const model = unitToModel.get(preferred)
        const path = (info as any).MonsterIcon
        const match = typeof path === "string" ? path.match(/T_Head_([^./']+)/) : null
        if (model && match) modelToIcon.set(model, match[1])
    }
    const result: VNodeTree[] = []
    for (const item of Object.values(table(ctx, "Monster"))) {
        if (!item || typeof item !== "object") continue
        const monster = item as Record<string, any>
        const id = Number(monster.UnitId ?? 0)
        if (!id || !valid.has(id)) continue
        const battle = row(ctx, "BattleMonster", monster.BattleRoleId) ?? {}
        const tags = list(monster.GamePlayTags)
        const fact = tags.find(tag => tabNames.has(String(tag)))
        const output: Record<string, VNodeTree> = {
            id,
            n: T(monster.UnitName ?? ""),
            t: monster.BloodUIParmas?.UIStyleNodeName,
            f: tabFinal[String(fact)] ?? undefined,
            atk: battle.ATK ?? 0,
            def: battle.DEF ?? 0,
            es: battle.MaxES ?? 0,
            hp: battle.MaxHp ?? 0,
            tn: battle.TN ?? 0,
        }
        const icon = iconFor(ctx, monster, modelToIcon)
        if (icon) output.icon = icon
        if (!output.t) delete output.t
        if (!output.f) delete output.f
        if (output.es === 0) delete output.es
        if (tags.length > 0) output.tags = tags as VNodeTree
        result.push(output)
    }
    return result
}
