import type { ModuleContext } from "../../core/Graph.ts"
import { T, TL, type VNodeTree } from "../../i18n/vnode.ts"

type Row = Record<string, any>

const GROUP_FIELDS: Record<string, string> = {
    GroupUnitSpawnCenterRange: "gr",
    GroupThreshold: "gth",
    GroupReplenishInterval: "gri",
    GroupInitUnitSpawnCenterRange: "gir",
    GroupDetectDelayTime: "gdt",
    GroupDetectTime: "gt",
    GroupLimit: "gl",
    GroupRadius: "gar",
    GroupRangeZ: "gz",
}

const ELEMENTS: Record<string, string> = { Dark: "暗", Light: "光", Water: "水", Fire: "火", Thunder: "雷", Wind: "风" }
const SPAWN_TABLES = [
    "DefencePro",
    "Defence",
    "DefenceMove",
    "Survival",
    "SurvivalMini",
    "SurvivalMiniPro",
    "SurvivalPro",
    "Excavation",
    "ExtermPro",
    "Exterminate",
    "SabotagePro",
]

function table(ctx: ModuleContext, name: string): Row {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Row) : {}
}

function rows(value: unknown): Row[] {
    if (!value || typeof value !== "object") return []
    const values = Array.isArray(value) ? value : Object.values(value)
    return values.filter((item): item is Row => !!item && typeof item === "object" && !Array.isArray(item))
}

function list(value: unknown): any[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    return Object.entries(value as Row)
        .map(([key, item]) => [Number(key), item] as const)
        .filter(([key]) => Number.isInteger(key) && key > 0)
        .sort(([a], [b]) => a - b)
        .map(([, item]) => item)
}

function unique(values: any[]): any[] {
    const result: any[] = []
    const seen = new Set<any>()
    for (const value of values)
        if (!seen.has(value)) {
            seen.add(value)
            result.push(value)
        }
    return result
}

function has(row: Row, key: string): boolean {
    return Object.hasOwn(row, key)
}

class DungeonBuilder {
    private readonly rewards: Row
    private readonly asyncCombat: Row[]
    private readonly monsterSpawns: Row
    private readonly monsterGroups: Row
    private readonly monsterGroupSpawns: Row
    private readonly relationSpawns: Row
    private readonly ironSurvival: Row
    private readonly modConditions = new Map<number, number>()
    private readonly directModConditions = new Map<number, number>()
    private readonly eliteRushDungeonIds = new Set<number>()
    private readonly asyncCombatMap = new Map<number, VNodeTree[]>()
    private readonly spawnSources = new Map<number, Row>()

    constructor(private readonly ctx: ModuleContext) {
        this.rewards = table(ctx, "ModDungeonMonReward")
        this.asyncCombat = rows(ctx.dm.getTable("AsyncCombat"))
        this.monsterSpawns = table(ctx, "MonsterSpawn")
        this.monsterGroups = table(ctx, "MonsterGroup")
        this.monsterGroupSpawns = table(ctx, "MonsterGroupSpawn")
        this.relationSpawns = table(ctx, "RelationSpawn")
        this.ironSurvival = table(ctx, "IronSurvival")
        this.buildModMaps(table(ctx, "EliteRushSelectDungeon"))
        this.buildAsyncCombatMap()
        for (const name of SPAWN_TABLES)
            for (const item of rows(ctx.dm.getTable(name))) {
                const dungeonId = Number(item.DungeonId)
                if (dungeonId && !this.spawnSources.has(dungeonId)) this.spawnSources.set(dungeonId, item)
            }
    }

    private buildModMaps(eliteRush: Row): void {
        for (const item of rows(eliteRush)) {
            const conditionValue = Array.isArray(item.Condition) ? item.Condition[0] : item.Condition
            const condition = typeof conditionValue === "number" ? conditionValue - 100 : undefined
            for (const rewardId of list(item.MonRewardIdList)) {
                const reward = this.rewards[String(rewardId)]
                if (!reward) continue
                for (const dungeonId of list(reward.DungeonList).map(Number)) {
                    this.eliteRushDungeonIds.add(dungeonId)
                    if (condition !== undefined && !this.modConditions.has(dungeonId)) this.modConditions.set(dungeonId, condition)
                }
            }
        }
        for (const reward of rows(this.rewards)) {
            const conditionValue = Array.isArray(reward.Condition) ? reward.Condition[0] : reward.Condition
            if (typeof conditionValue !== "number") continue
            for (const dungeonId of list(reward.DungeonList).map(Number))
                if (!this.directModConditions.has(dungeonId)) this.directModConditions.set(dungeonId, conditionValue - 100)
        }
    }

    private buildAsyncCombatMap(): void {
        for (const item of this.asyncCombat) {
            const dungeonId = Number(item.DungeonID)
            if (!dungeonId) continue
            this.asyncCombatMap.set(dungeonId, [...(this.asyncCombatMap.get(dungeonId) ?? []), { id: item.ID ?? 0, c: item.Count ?? 0 }])
        }
    }

    private groupMembers(groupId: unknown): VNodeTree[] {
        const group = this.monsterGroups[String(groupId)]
        if (!group) return []
        return list(group.MemberSpawnProb)
            .filter((member): member is Row => !!member && typeof member === "object")
            .map(member => ({ id: member.UnitId ?? 0, ...(member.UnitProb && member.UnitProb !== 1 ? { p: member.UnitProb } : {}) }))
    }

    private appendGroup(node: Record<string, VNodeTree>, spawn: Row): void {
        const groupSpawnId = spawn.GroupSpawnId || spawn.UnitSpawnId
        if (!groupSpawnId) return
        const groupSpawn = this.monsterGroupSpawns[String(groupSpawnId)]
        if (!groupSpawn) return
        const ids = list(groupSpawn.MonsterGroupIds)
        const numbers = list(groupSpawn.GroupNumber)
        const weights = list(groupSpawn.GroupWeight)
        const levels = list(groupSpawn.GroupLevel)
        const groups = ids.map((id, index) => {
            const group: Record<string, VNodeTree> = { id }
            if (index < numbers.length) group.num = numbers[index]
            if (index < weights.length) group.w = weights[index]
            if (index < levels.length) group.lv = levels[index]
            group.m = this.groupMembers(id)
            for (const [field, short] of Object.entries(GROUP_FIELDS)) if (has(groupSpawn, field)) group[short] = groupSpawn[field]
            return group
        })
        if (groups.length) node.mg = groups
    }

    private spawnNodes(spawnIds: unknown[]): VNodeTree[] {
        const result: VNodeTree[] = []
        for (const spawnId of spawnIds) {
            const spawn = this.monsterSpawns[String(spawnId)]
            if (!spawn) continue
            const node: Record<string, VNodeTree> = {
                id: spawn.UnitSpawnId ?? spawnId,
                time: spawn.DetectTime ?? 0,
                th: spawn.Threshold ?? 0,
                radius: [
                    spawn.UnitSpawnRadiusMin ?? 0,
                    spawn.UnitSpawnRadiusMax ?? 0,
                    spawn.PhoneUnitSpawnRadiusMin ?? 0,
                    spawn.PhoneUnitSpawnRadiusMax ?? 0,
                ],
                m: list(spawn.MonsterSpawnInfos)
                    .filter((info): info is Row => !!info && typeof info === "object")
                    .map(info => ({
                        id: info.UnitId ?? 0,
                        num: info.UnitNum ?? 0,
                        ...((info.UnitNumFix ?? 0) !== (info.UnitNum ?? 0) ? { numf: info.UnitNumFix ?? 0 } : {}),
                        ...(info.UnitLevel ? { lv: info.UnitLevel } : {}),
                    })),
            }
            if (spawn.OpenGroupSpawn) this.appendGroup(node, spawn)
            if (spawn.RelationId !== undefined && spawn.RelationId !== null) {
                const relation = this.relationSpawns[String(spawn.RelationId)]
                if (relation) {
                    const weights = list(relation.UnitWeight)
                    const sm = list(relation.UnitId).map((id, index) => ({
                        id,
                        w: index < weights.length ? weights[index] : 0,
                        ...(relation.UnitLevel ? { lv: relation.UnitLevel } : {}),
                    }))
                    if (sm.length) node.sm = sm
                    const total = list(relation.RelationSpawnTotalNum)
                    if (total.length) node.smnum = total
                }
            }
            result.push(node)
        }
        return result
    }

    private appendWaves(target: unknown[][], value: unknown, split = false): void {
        const values = list(value)
        if (values.length === 0) {
            if (value !== undefined && value !== null && typeof value !== "object") target.push([value])
            return
        }
        const firstList = list(values[0])
        if (firstList.length > 0) {
            for (const wave of values) {
                const items = list(wave)
                if (items.length) target.push(items)
            }
        } else if (split) for (const item of values) target.push([item])
        else target.push(values)
    }

    private raidSpawn(dungeon: Row): VNodeTree[] {
        const spawnId = dungeon.BPOverrideVars?.MonsterID
        if (!spawnId) return []
        const spawn = this.monsterSpawns[String(spawnId)]
        if (!spawn) return []
        const node: Record<string, VNodeTree> = { id: spawn.UnitSpawnId ?? spawnId }
        if (spawn.DetectTime) node.time = spawn.DetectTime
        if (spawn.Threshold) node.th = spawn.Threshold
        const radius = [
            spawn.UnitSpawnRadiusMin ?? 0,
            spawn.UnitSpawnRadiusMax ?? 0,
            spawn.PhoneUnitSpawnRadiusMin ?? 0,
            spawn.PhoneUnitSpawnRadiusMax ?? 0,
        ]
        if (radius.some(Boolean)) node.radius = radius
        if (spawn.OpenGroupSpawn) this.appendGroup(node, spawn)
        return [[node]]
    }

    private dungeonSpawn(dungeon: Row): VNodeTree[] {
        const source = this.spawnSources.get(Number(dungeon.DungeonID))
        if (!source) return this.raidSpawn(dungeon)
        const waves: unknown[][] = []
        this.appendWaves(waves, source.WaveSpawnRule, true)
        for (const key of [
            "MonsterFirstSpawnId",
            "MonsterSpawnId",
            "MonsterSpawnIds",
            "OnInitSpawnRule",
            "NormalSpawnRule",
            "EliteSpawnRule",
            "SpMonsterSpawnId",
        ])
            this.appendWaves(waves, source[key])
        for (const item of list(source.SpMonster))
            if (item && typeof item === "object") this.appendWaves(waves, (item as Row).SpMonsterSpawnId)
        for (const item of list(source.Excavation))
            if (item && typeof item === "object") this.appendWaves(waves, (item as Row).MonsterSpawnId)
        const result = waves.map(wave => this.spawnNodes(wave)).filter(wave => wave.length > 0)
        return result.length ? result : this.raidSpawn(dungeon)
    }

    private ironSurvivalMonsters(dungeonId: number): number[] {
        const config = this.ironSurvival[String(dungeonId)]
        if (!config) return []
        const spawnIds: number[] = []
        const collect = (value: unknown): void => {
            if (Array.isArray(value)) for (const item of value) collect(item)
            else if (value && typeof value === "object") for (const item of Object.values(value as Row)) collect(item)
            else {
                const id = Number(value)
                if (Number.isInteger(id)) spawnIds.push(id)
            }
        }
        collect(config)
        const monsters = new Set<number>()
        for (const spawnId of spawnIds) {
            const spawn = this.monsterSpawns[String(spawnId)]
            if (!spawn) continue
            for (const info of list(spawn.MonsterSpawnInfos)) {
                const id = info && typeof info === "object" ? Number((info as Row).UnitId) : Number.NaN
                if (Number.isInteger(id)) monsters.add(id)
            }
        }
        return [...monsters].sort((a, b) => a - b)
    }

    private asyncMonsters(dungeonId: number): VNodeTree[] {
        return unique(this.asyncCombat.filter(item => Number(item.DungeonID) === dungeonId).flatMap(item => list(item.BossUnitID)))
    }

    build(dungeon: Row): Record<string, VNodeTree> | undefined {
        const dungeonId = Number(dungeon.DungeonID)
        if (!dungeonId || dungeonId < 20000) return undefined
        const nameKey = typeof dungeon.DungeonName === "string" ? dungeon.DungeonName : ""
        if (this.ctx.textmap.get(nameKey, "cn").startsWith("DUNGEON_NAME_")) return undefined
        const type = dungeon.DungeonType ?? ""
        const element = ELEMENTS[dungeon.AttributeType]
        const typeShowKey = typeof dungeon.DungeonTypeShow === "string" ? dungeon.DungeonTypeShow : ""
        const cnTypeShow = typeShowKey ? this.ctx.textmap.get(typeShowKey, "cn") : ""
        const item: Record<string, VNodeTree> = {
            id: dungeonId,
            n:
                nameKey === "UI_DUNGEON_ASYNCCOMBAT_1"
                    ? TL("联袂演绎", {
                          tc: "UI_DUNGEON_ASYNCCOMBAT_1",
                          en: "UI_DUNGEON_ASYNCCOMBAT_1",
                          jp: "UI_DUNGEON_ASYNCCOMBAT_1",
                          kr: "UI_DUNGEON_ASYNCCOMBAT_1",
                          fr: "UI_DUNGEON_ASYNCCOMBAT_1",
                      })
                    : T(nameKey),
            t: type,
            ...(element ? { e: element } : {}),
            ...(cnTypeShow && !cnTypeShow.startsWith("DUNGEON_NAME_") ? { ts: T(typeShowKey) } : {}),
            lv: dungeon.DungeonLevel ?? 0,
            rd: dungeon.IsRandom ?? 0,
        }

        const condition = this.modConditions.get(dungeonId) ?? this.directModConditions.get(dungeonId)
        if (condition !== undefined) {
            item.mod = condition
            if (this.eliteRushDungeonIds.has(dungeonId)) item.rush = 1
        }
        const asyncCombat = this.asyncCombatMap.get(dungeonId)
        if (asyncCombat?.length) item.ac = asyncCombat
        if (has(dungeon, "DungeonDes")) item.desc = T(dungeon.DungeonDes)

        const special = [dungeon.BPOverrideVars?.BossID, dungeon.BPOverrideVars?.Elite1, dungeon.BPOverrideVars?.Elite2].filter(Boolean)
        const guideMonsters = list(dungeon.DungeonInitGuideUnitId)
        const specialMonsters = unique([...special, ...guideMonsters])
        if (specialMonsters.length) item.sm = specialMonsters
        if (guideMonsters.length) {
            const rewards: VNodeTree[] = []
            for (const monsterId of guideMonsters)
                for (const reward of rows(this.rewards))
                    if (reward.MonsterUnitId === monsterId && list(reward.DungeonList).includes(dungeonId))
                        rewards.push(reward.DungeonDropReward)
            if (rewards.length) item.sr = rewards
        }

        if (type === "IronSurvival") {
            const monsters = this.ironSurvivalMonsters(dungeonId)
            if (!monsters.length) return undefined
            item.m = monsters
        } else if (has(dungeon, "DungeonMonsters")) item.m = list(dungeon.DungeonMonsters)
        else if (type === "AsyncCombat") item.m = this.asyncMonsters(dungeonId)
        else return undefined

        const spawn = this.dungeonSpawn(dungeon)
        if (spawn.length) item.spawn = spawn
        if (has(dungeon, "DungeonReward")) {
            const rewards = list(dungeon.DungeonReward)
            if (rewards.length === 1 && rewards[0] === 50100) return undefined
            item.r = rewards
        } else if (type !== "AsyncCombat") return undefined
        if (has(dungeon, "DungeonWinMode")) item.win = dungeon.DungeonWinMode
        return item
    }
}

export function dungeonModule(ctx: ModuleContext): VNodeTree {
    const builder = new DungeonBuilder(ctx)
    return rows(ctx.dm.getTable("Dungeon")).flatMap(item => {
        const result = builder.build(item)
        return result ? [result] : []
    })
}
