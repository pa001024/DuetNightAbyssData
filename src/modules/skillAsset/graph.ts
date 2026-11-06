/**
 * 技能行为图遍历（v2）。
 *
 * 边契约（与 PLAN-R2 §3 一致）：
 * - SkillNode → SkillEffects（SkillNodeEffects）、SkillNode（NextNodeId/BranchNodeIds/ChildNodeIds）
 * - SkillEffects → CreateSkillCreature / CreateUnit / AddBuff / SkillEffect / EffectIds / PassiveEffectId
 * - SkillCreature → HitEnemy / HitScene / DestroyEffects / RealDestroyEffects / CreatureEffects /
 *   LoopExecuteSkillEffects.SkillEffects / EffectCreatureID
 * - Buff → DotDatas(SkillEffect).EffectId / HaloDatas.BuffId / ExecSkillEffectWhenRemoved /
 *   ActivateSkills / AddPassiveEffect / InitialEffect / ReplaceSkillNodes / LayerExtraBuff
 * - Unit → BattleMonster.SkillList、Monster/MechanismSummon.BluePrintParams.SkillEffectId*
 *
 * visited 以 `${kind}:${id}` 为单位，深度上限 24、单次遍历节点预算 4096、单节点分支上限 64。
 * 缺行、未知命名空间与上限命中全部进入 unresolved，不静默跳过；同名 Unit/SkillCreature
 * 没有显式字段，只作为 conventionRefs 标注，不当作表边。
 */
import type {
    BpSeedSource,
    ConventionRef,
    CreatureEntry,
    CreatureLoop,
    EffectEntry,
    GraphSource,
    UnitEntry,
    UnresolvedRef,
} from "./types.ts"

export type GraphKind = "SkillEffects" | "SkillCreature" | "Buff" | "PassiveEffect" | "SkillNode" | "Skill" | "Unit" | "EffectCreature"

export const MAX_GRAPH_DEPTH = 24
export const MAX_GRAPH_NODES = 4096
export const MAX_GRAPH_BRANCHES = 64

export interface GraphSeed {
    kind: GraphKind
    id: number
    relation: string
    descIndex: number | null
    /** Blueprint 展平动作引入的种子来源；普通种子为 null */
    bp?: BpSeedSource | null
}

export interface GraphSkillInput {
    skillId: number
    seeds: GraphSeed[]
}

export interface GraphTables {
    skill(id: number): Record<string, unknown> | undefined
    skillNode(id: number): Record<string, unknown> | undefined
    skillEffects(id: number): Record<string, unknown> | undefined
    skillCreature(id: number): Record<string, unknown> | undefined
    buff(id: number): Record<string, unknown> | undefined
    passiveEffect(id: number): Record<string, unknown> | undefined
    effectCreature(id: number): Record<string, unknown> | undefined
    unitParts(id: number): {
        battleMonster: Record<string, unknown> | undefined
        monster: Record<string, unknown> | undefined
        mechanismSummon: Record<string, unknown> | undefined
    }
}

export interface GraphReach {
    effects: Set<number>
    creatures: Set<number>
    units: Set<number>
    buffs: Set<number>
    passives: Set<number>
    skills: Set<number>
}

export interface GraphMissing {
    effects: Set<number>
    creatures: Set<number>
    effectCreatures: Set<number>
    units: Set<number>
    buffs: Set<number>
    passives: Set<number>
    skills: Set<number>
}

export interface GraphResult {
    effects: Map<number, EffectEntry>
    creatures: Map<number, CreatureEntry>
    units: Map<number, UnitEntry>
    buffIds: Set<number>
    /** 每个可达 Buff id 的来源边（Buff 行由模块侧从 Lua 表读取） */
    buffSources: Map<number, GraphSource[]>
    passiveIds: Set<number>
    /** 图内到达的内部技能（如 BattleMonster.SkillList） */
    skillIds: Set<number>
    /** 每个根技能的可达集合（用于校验边不跨技能） */
    reachBySkill: Map<number, GraphReach>
    missing: GraphMissing
    unresolved: UnresolvedRef[]
    conventionRefs: ConventionRef[]
    depthLimitHits: number
}

interface QueueNode {
    kind: GraphKind
    id: number
    from: string
    relation: string
    descIndex: number | null
    depth: number
    /** 该节点作为 BP 种子被直接加入时的来源；图内后继节点不继承，保留边的真实来源。 */
    bp: BpSeedSource | null
}

function asRecord(value: unknown): Record<string, any> | null {
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Record<string, any>) : null
}

/** Lua 1 起始 map / 数组 / 单值 → id 数组（去重、保序）。 */
export function toIdList(value: unknown): number[] {
    if (value === null || value === undefined || value === "") return []
    const list = Array.isArray(value) ? value : typeof value === "object" ? Object.values(value as Record<string, unknown>) : [value]
    const out: number[] = []
    for (const item of list) {
        const num = Number(item)
        if (Number.isFinite(num) && !out.includes(num)) out.push(num)
    }
    return out
}

function asNumber(value: unknown): number | null {
    if (value === null || value === undefined || value === "") return null
    const num = Number(value)
    return Number.isFinite(num) ? num : null
}

function createCreatureEntry(id: number, row: Record<string, any>): CreatureEntry {
    return {
        id,
        hitEnemy: toIdList(row.HitEnemy),
        hitScene: toIdList(row.HitScene),
        loop: loopOf(row),
        creatureEffectIds: toIdList(row.CreatureEffects),
        destroyEffectIds: toIdList(row.DestroyEffects),
        realDestroyEffectIds: toIdList(row.RealDestroyEffects),
        effectCreatureEffectIds: toIdList(row.EffectCreatureID),
        attachOwner: toIdList(row.AttachOwner),
        timeLife: asNumber(row.TimeLife),
        speed: asNumber(row.Speed),
        referencedBySkills: [],
        sources: [],
        lua: row,
    }
}

function loopOf(raw: Record<string, any>): CreatureLoop | null {
    const loop = asRecord(raw.LoopExecuteSkillEffects)
    if (!loop) return null
    const rawLoop = loop.Loop
    return {
        interval: asNumber(loop.Interval),
        loop: typeof rawLoop === "boolean" || typeof rawLoop === "number" ? rawLoop : null,
        effectIds: toIdList(loop.SkillEffects),
    }
}

/** BluePrintParams 里的 SkillEffectId 家族（含 Enter/Exit/2/3 与 Grade6）。 */
function collectBluePrintEffectIds(params: Record<string, any> | null): number[] {
    if (!params) return []
    const out: number[] = []
    for (const [key, value] of Object.entries(params)) {
        if (!/^SkillEffectI[dD]/.test(key) && !/^Grade6SkillEffectI[Dd]$/.test(key)) continue
        for (const id of toIdList(value)) if (!out.includes(id)) out.push(id)
    }
    return out
}

function collectStringList(value: unknown): string[] {
    const list = Array.isArray(value) ? value : value === undefined || value === null || value === "" ? [] : [value]
    return list.map(item => String(item)).filter(Boolean)
}

/** 图遍历一次的结果容器；同一目标可能被多个技能到达，sources 累积去重。 */
class Accumulator {
    readonly effects = new Map<number, EffectEntry>()
    readonly creatures = new Map<number, CreatureEntry>()
    readonly units = new Map<number, UnitEntry>()
    readonly buffIds = new Set<number>()
    readonly buffSources = new Map<number, GraphSource[]>()
    readonly passiveIds = new Set<number>()
    readonly skillIds = new Set<number>()
    readonly reachBySkill = new Map<number, GraphReach>()
    readonly missing: GraphMissing = {
        effects: new Set(),
        creatures: new Set(),
        effectCreatures: new Set(),
        units: new Set(),
        buffs: new Set(),
        passives: new Set(),
        skills: new Set(),
    }
    readonly unresolved: UnresolvedRef[] = []
    readonly conventionRefs: ConventionRef[] = []
    depthLimitHits = 0
    private readonly unresolvedSeen = new Set<string>()
    private readonly sourceSeen = new Map<string, Set<string>>()
    private readonly conventionSeen = new Set<string>()

    constructor(private readonly tables: GraphTables) {}

    addUnresolved(ref: UnresolvedRef): void {
        const key = [ref.kind, ref.id, ref.from, ref.reason, ref.detail ?? ""].join("\u0000")
        if (this.unresolvedSeen.has(key)) return
        this.unresolvedSeen.add(key)
        this.unresolved.push(ref)
    }

    addConvention(ref: ConventionRef): void {
        const key = [ref.kind, ref.id, ref.relatedKind, ref.relatedId, ref.note].join("\u0000")
        if (this.conventionSeen.has(key)) return
        this.conventionSeen.add(key)
        this.conventionRefs.push(ref)
    }

    addSource(node: QueueNode, skillId: number): void {
        const relation = {
            from: node.from,
            relation: node.relation,
            skillId,
            descIndex: node.descIndex,
            ...(node.bp ? { bp: node.bp } : {}),
        }
        const key = `${node.kind}:${node.id}`
        const seen = this.sourceSeen.get(key) ?? new Set<string>()
        this.sourceSeen.set(key, seen)
        const dedupeKey = [
            relation.from,
            relation.relation,
            relation.skillId,
            relation.descIndex ?? "",
            node.bp ? `${node.bp.bpPackage}#${node.bp.function}#${node.bp.nodeId}` : "",
        ].join("\u0000")
        if (seen.has(dedupeKey)) return
        seen.add(dedupeKey)
        if (node.kind === "Buff") {
            const sources = this.buffSources.get(node.id) ?? []
            sources.push(relation as GraphSource)
            this.buffSources.set(node.id, sources)
            return
        }
        const entry =
            node.kind === "SkillEffects"
                ? this.effects.get(node.id)
                : node.kind === "SkillCreature"
                  ? this.creatures.get(node.id)
                  : node.kind === "Unit"
                    ? this.units.get(node.id)
                    : undefined
        if (entry) entry.sources.push(relation as GraphSource)
    }

    resolve(node: QueueNode): Record<string, unknown> | undefined {
        switch (node.kind) {
            case "SkillEffects":
                return this.tables.skillEffects(node.id)
            case "SkillCreature":
                return this.tables.skillCreature(node.id)
            case "Buff":
                return this.tables.buff(node.id)
            case "PassiveEffect":
                return this.tables.passiveEffect(node.id)
            case "SkillNode":
                return this.tables.skillNode(node.id)
            case "Skill":
                return this.tables.skill(node.id)
            case "EffectCreature":
                return this.tables.effectCreature(node.id)
            case "Unit":
                return undefined
        }
    }

    markMissing(node: QueueNode, reason = "missing-row"): void {
        if (node.kind === "SkillEffects") this.missing.effects.add(node.id)
        if (node.kind === "SkillCreature") this.missing.creatures.add(node.id)
        if (node.kind === "Buff") this.missing.buffs.add(node.id)
        if (node.kind === "PassiveEffect") this.missing.passives.add(node.id)
        if (node.kind === "Skill") this.missing.skills.add(node.id)
        if (node.kind === "Unit") this.missing.units.add(node.id)
        if (node.kind === "EffectCreature") this.missing.effectCreatures.add(node.id)
        this.addUnresolved({ kind: node.kind, id: node.id, from: node.from, reason })
    }

    /** 记录目标并（首次）创建条目；返回原始行。 */
    ensure(node: QueueNode): Record<string, any> | undefined {
        if (node.kind === "Unit") {
            const existing = this.units.get(node.id)
            if (existing) return existing as unknown as Record<string, any>
            const parts = this.tables.unitParts(node.id)
            const battleMonster = asRecord(parts.battleMonster)
            const monster = asRecord(parts.monster)
            const mechanismSummon = asRecord(parts.mechanismSummon)
            if (!battleMonster && !monster && !mechanismSummon) {
                this.markMissing(node)
                return undefined
            }
            if (!this.units.has(node.id)) {
                const skillIds = toIdList(battleMonster?.SkillList)
                const passiveEffectIds: number[] = []
                for (const skillId of skillIds) {
                    const skill = asRecord(this.tables.skill(skillId))
                    if (!skill) {
                        this.missing.skills.add(skillId)
                        this.addUnresolved({ kind: "Skill", id: skillId, from: `Unit:${node.id}`, reason: "missing-row" })
                        continue
                    }
                    for (const passiveId of toIdList(skill.PassiveEffects)) {
                        if (!passiveEffectIds.includes(passiveId)) passiveEffectIds.push(passiveId)
                    }
                }
                const creature = asRecord(this.tables.skillCreature(node.id))
                if (creature) {
                    // 同名约定：Unit 与 SkillCreature 没有显式字段相连，只记录约定，不建表边。
                    // 但实体本身仍要导出，供召唤模型读取命中/循环行为。
                    this.addConvention({
                        kind: "Unit",
                        id: node.id,
                        relatedKind: "SkillCreature",
                        relatedId: node.id,
                        note: "unit-creature-same-id",
                    })
                    if (!this.creatures.has(node.id)) this.creatures.set(node.id, createCreatureEntry(node.id, creature))
                }
                const bluePrintEffectIds: number[] = []
                for (const id of collectBluePrintEffectIds(monster?.BluePrintParams ?? null)) {
                    if (!bluePrintEffectIds.includes(id)) bluePrintEffectIds.push(id)
                }
                for (const id of collectBluePrintEffectIds(mechanismSummon?.BluePrintParams ?? null)) {
                    if (!bluePrintEffectIds.includes(id)) bluePrintEffectIds.push(id)
                }
                this.units.set(node.id, {
                    id: node.id,
                    battleMonster,
                    monster,
                    mechanismSummon,
                    skillIds,
                    passiveEffectIds,
                    bluePrintEffectIds,
                    gamePlayTags: collectStringList(monster?.GamePlayTags),
                    unitBPPath:
                        typeof monster?.UnitBPPath === "string"
                            ? monster.UnitBPPath
                            : typeof mechanismSummon?.UnitBPPath === "string"
                              ? mechanismSummon.UnitBPPath
                              : null,
                    referencedBySkills: [],
                    sameIdCreatureId: creature ? node.id : null,
                    sources: [],
                    lua: { battleMonster, monster, mechanismSummon },
                })
            }
            return this.units.get(node.id) as unknown as Record<string, any>
        }

        const row = this.resolve(node)
        if (!row) {
            this.markMissing(node)
            return undefined
        }
        switch (node.kind) {
            case "SkillEffects":
                if (!this.effects.has(node.id)) {
                    this.effects.set(node.id, {
                        id: node.id,
                        taskId: asNumber(row.TaskId),
                        lua: row,
                        grow: null,
                        sources: [],
                    })
                }
                break
            case "SkillCreature":
                if (!this.creatures.has(node.id)) this.creatures.set(node.id, createCreatureEntry(node.id, row))
                break
            case "Buff":
                this.buffIds.add(node.id)
                break
            case "PassiveEffect":
                this.passiveIds.add(node.id)
                break
            case "Skill":
                this.skillIds.add(node.id)
                break
            default:
                break
        }
        return row
    }

    walk(input: GraphSkillInput): void {
        const reach: GraphReach = {
            effects: new Set(),
            creatures: new Set(),
            units: new Set(),
            buffs: new Set(),
            passives: new Set(),
            skills: new Set(),
        }
        this.reachBySkill.set(input.skillId, reach)

        const queue: QueueNode[] = input.seeds.map(seed => ({
            kind: seed.kind,
            id: seed.id,
            from: `skill:${input.skillId}`,
            relation: seed.relation,
            descIndex: seed.descIndex,
            depth: 0,
            bp: seed.bp ?? null,
        }))
        const visited = new Set<string>()
        let head = 0
        let nodeCount = 0

        const push = (kind: GraphKind, id: number, parent: QueueNode, relation: string, depth: number): void => {
            if (!Number.isFinite(id)) return
            queue.push({ kind, id, from: `${parent.kind}:${parent.id}`, relation, descIndex: parent.descIndex, depth, bp: null })
        }
        const pushList = (kind: GraphKind, value: unknown, parent: QueueNode, relation: string): void => {
            const ids = toIdList(value)
            if (ids.length > MAX_GRAPH_BRANCHES) {
                this.addUnresolved({
                    kind: parent.kind,
                    id: parent.id,
                    from: `${parent.kind}:${parent.id}`,
                    reason: "branch-limit",
                    detail: `${relation}: ${ids.length} > ${MAX_GRAPH_BRANCHES}`,
                })
            }
            for (const id of ids.slice(0, MAX_GRAPH_BRANCHES)) push(kind, id, parent, relation, parent.depth + 1)
        }

        while (head < queue.length) {
            const node = queue[head++]!
            const key = `${node.kind}:${node.id}`

            if (node.depth > MAX_GRAPH_DEPTH) {
                this.depthLimitHits++
                this.addUnresolved({
                    kind: node.kind,
                    id: node.id,
                    from: node.from,
                    reason: "depth-limit",
                    detail: `depth ${node.depth} > ${MAX_GRAPH_DEPTH}`,
                })
                continue
            }

            const row = this.ensure(node)
            if (!row) continue
            // 即使节点已访问，仍要记录这条边的来源（同一目标可由多个前端到达）。
            this.addSource(node, input.skillId)
            if (visited.has(key)) continue
            visited.add(key)
            nodeCount++
            if (nodeCount > MAX_GRAPH_NODES) {
                this.addUnresolved({
                    kind: node.kind,
                    id: node.id,
                    from: node.from,
                    reason: "node-budget",
                    detail: `node ${nodeCount} > ${MAX_GRAPH_NODES}`,
                })
                break
            }

            if (node.kind === "SkillEffects") reach.effects.add(node.id)
            if (node.kind === "SkillCreature") reach.creatures.add(node.id)
            if (node.kind === "Unit") reach.units.add(node.id)
            if (node.kind === "Buff") reach.buffs.add(node.id)
            if (node.kind === "PassiveEffect") reach.passives.add(node.id)
            if (node.kind === "Skill") reach.skills.add(node.id)

            switch (node.kind) {
                case "SkillNode": {
                    pushList("SkillEffects", row.SkillNodeEffects, node, "node.SkillNodeEffects")
                    if (row.NextNodeId !== undefined && row.NextNodeId !== null && row.NextNodeId !== "") {
                        push("SkillNode", Number(row.NextNodeId), node, "node.NextNodeId", node.depth + 1)
                    }
                    const branches = row.BranchNodeIds ?? row.ChildNodeIds
                    pushList("SkillNode", branches, node, row.BranchNodeIds !== undefined ? "node.BranchNodeIds" : "node.ChildNodeIds")
                    break
                }
                case "Skill": {
                    pushList("PassiveEffect", row.PassiveEffects, node, "skill.PassiveEffects")
                    pushList("Skill", row.SubSkills, node, "skill.SubSkills")
                    if (row.BeginNodeId !== undefined && row.BeginNodeId !== null && row.BeginNodeId !== "") {
                        push("SkillNode", Number(row.BeginNodeId), node, "skill.BeginNodeId", node.depth + 1)
                    }
                    break
                }
                case "SkillEffects": {
                    const tasks = Array.isArray(row.TaskEffects) ? row.TaskEffects : []
                    for (const task of tasks) {
                        if (!task || typeof task !== "object") continue
                        const record = task as Record<string, unknown>
                        if (record.Function === "CreateSkillCreature" && record.CreatureId !== undefined) {
                            push("SkillCreature", Number(record.CreatureId), node, "task.CreateSkillCreature", node.depth + 1)
                        }
                        if (record.Function === "CreateUnit" && record.UnitId !== undefined) {
                            push("Unit", Number(record.UnitId), node, "task.CreateUnit", node.depth + 1)
                        }
                        if (record.Function === "AddBuff" && record.BuffId !== undefined) {
                            push("Buff", Number(record.BuffId), node, "task.AddBuff", node.depth + 1)
                        }
                        if (record.PassiveEffectId !== undefined && record.PassiveEffectId !== null && record.PassiveEffectId !== "") {
                            push("PassiveEffect", Number(record.PassiveEffectId), node, "task.PassiveEffectId", node.depth + 1)
                        }
                        pushList("SkillEffects", record.SkillEffect, node, "task.SkillEffect")
                        pushList("SkillEffects", record.EffectIds, node, "task.EffectIds")
                    }
                    break
                }
                case "SkillCreature": {
                    pushList("SkillEffects", row.HitEnemy, node, "creature.hitEnemy")
                    pushList("SkillEffects", row.HitScene, node, "creature.hitScene")
                    pushList("SkillEffects", row.CreatureEffects, node, "creature.creatureEffects")
                    pushList("SkillEffects", row.DestroyEffects, node, "creature.destroyEffects")
                    pushList("SkillEffects", row.RealDestroyEffects, node, "creature.realDestroyEffects")
                    pushList("SkillEffects", asRecord(row.LoopExecuteSkillEffects)?.SkillEffects, node, "creature.loop")
                    if (row.EffectCreatureID !== undefined && row.EffectCreatureID !== null && row.EffectCreatureID !== "") {
                        push("EffectCreature", Number(row.EffectCreatureID), node, "creature.effectCreature", node.depth + 1)
                    }
                    break
                }
                case "Buff": {
                    for (const dot of Array.isArray(row.DotDatas) ? row.DotDatas : []) {
                        const record = asRecord(dot)
                        if (record?.Type === "SkillEffect" && record.EffectId !== undefined) {
                            push("SkillEffects", Number(record.EffectId), node, "buff.dotData", node.depth + 1)
                        }
                    }
                    for (const halo of Array.isArray(row.HaloDatas) ? row.HaloDatas : []) {
                        const buffId = asRecord(halo)?.BuffId
                        if (buffId !== undefined) push("Buff", Number(buffId), node, "buff.halo", node.depth + 1)
                    }
                    pushList("SkillEffects", row.ExecSkillEffectWhenRemoved, node, "buff.execWhenRemoved")
                    pushList("Skill", row.ActivateSkills, node, "buff.activateSkill")
                    pushList("PassiveEffect", row.AddPassiveEffect, node, "buff.addPassiveEffect")
                    pushList("SkillEffects", row.InitialEffect, node, "buff.initialEffect")
                    pushList("SkillNode", row.ReplaceSkillNodes, node, "buff.replaceSkillNode")
                    pushList("Buff", row.LayerExtraBuff, node, "buff.layerExtraBuff")
                    break
                }
                case "Unit": {
                    pushList("Skill", row.skillIds, node, "unit.skillList")
                    pushList("SkillEffects", row.bluePrintEffectIds, node, "unit.bluePrintParams")
                    break
                }
                default:
                    break
            }
        }
    }
}

/** 从根技能种子集合遍历全部图；返回条目与每技能可达集合。 */
export function collectSkillGraph(tables: GraphTables, inputs: GraphSkillInput[]): GraphResult {
    const accumulator = new Accumulator(tables)
    for (const input of inputs) accumulator.walk(input)

    for (const entry of accumulator.effects.values()) entry.sources.sort(compareSources)
    for (const entry of accumulator.creatures.values()) {
        entry.sources.sort(compareSources)
        entry.referencedBySkills = [...new Set(entry.sources.map(source => source.skillId))].sort((a, b) => a - b)
    }
    for (const entry of accumulator.units.values()) {
        entry.sources.sort(compareSources)
        entry.referencedBySkills = [...new Set(entry.sources.map(source => source.skillId))].sort((a, b) => a - b)
    }
    for (const sources of accumulator.buffSources.values()) sources.sort(compareSources)
    accumulator.unresolved.sort(
        (a, b) =>
            a.kind.localeCompare(b.kind) ||
            (a.id ?? -1) - (b.id ?? -1) ||
            a.from.localeCompare(b.from) ||
            a.reason.localeCompare(b.reason) ||
            (a.detail ?? "").localeCompare(b.detail ?? "")
    )
    accumulator.conventionRefs.sort((a, b) => a.kind.localeCompare(b.kind) || a.id - b.id || a.relatedKind.localeCompare(b.relatedKind))

    return {
        effects: accumulator.effects,
        creatures: accumulator.creatures,
        units: accumulator.units,
        buffIds: accumulator.buffIds,
        buffSources: accumulator.buffSources,
        passiveIds: accumulator.passiveIds,
        skillIds: accumulator.skillIds,
        reachBySkill: accumulator.reachBySkill,
        missing: accumulator.missing,
        unresolved: accumulator.unresolved,
        conventionRefs: accumulator.conventionRefs,
        depthLimitHits: accumulator.depthLimitHits,
    }
}

function compareSources(a: GraphSource, b: GraphSource): number {
    return (
        a.skillId - b.skillId ||
        a.from.localeCompare(b.from) ||
        a.relation.localeCompare(b.relation) ||
        (a.descIndex ?? -1) - (b.descIndex ?? -1) ||
        (a.bp?.bpPackage ?? "").localeCompare(b.bp?.bpPackage ?? "") ||
        (a.bp?.function ?? "").localeCompare(b.bp?.function ?? "") ||
        (a.bp?.nodeId ?? "").localeCompare(b.bp?.nodeId ?? "")
    )
}
