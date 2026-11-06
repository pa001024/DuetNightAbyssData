/**
 * skillAsset — 产出语言无关的 final/skill-behavior.json（SkillAssetDoc）。
 *
 * 数据来源（只处理可达资产）：
 * - 角色：Char + BattleChar.SkillList（排除超限被动，与 Char.json 口径一致）
 * - 武器/宠物/MOD：BattleWeapon.WeaponSkillList、BattlePet.SupportSkillId、Mod.ModActivateSkills
 * - 技能链：Skill → SkillNode → SkillEffects → Buff / PassiveEffect（遍历契约同 behaviorChain）
 * - v2 图：SkillEffects/SkillCreature/Unit/Buff 的显式引用边（见 graph.ts），
 *   SkillDescValues 的字段引用（见 fieldRefs.ts）与 SkillGrow 等级序列（见 grow.ts）
 * - 节点全量与变体：SkillNode 整表投影为 `skillNodes`；每个技能按 BeginNodeId 与
 *   SubSkills 的 BeginNodeId 生成 `variants`（见 skillNodes.ts）
 * - 动画：Montage/AnimSequence 通过 UAssetCLI fmodel 读取（DuckDB 缓存；进程级 memo）
 * - Blueprint：PassiveEffect.BPPath / Buff.BPPath，按绝对路径去重后调用 UAssetCLI bytecode
 * - AnimBlueprint：Model.AnimInstancePath → AnimBlueprintGeneratedClass CDO 图节点
 *
 * 不做游戏语义归一；无法解析的资产写入 coverage，不猜测、不静默丢弃。
 */
import { execFileSync } from "node:child_process"
import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import {
    type AnimBPInfo,
    AssetReader,
    assetPathFromGamePath,
    assetPathFromObjectPath,
    type MontageTimeline,
    type SequenceMeta,
} from "../../lua/AssetReader.ts"
import { getExportsRoot, packagePathFor, type UAssetBytecodeDocument, type UAssetServer } from "../../lua/UAssetServer.ts"
import type { SkillArtifacts } from "../skill/skillModule.ts"
import { generateSkillBehaviorText, getSkillEntry } from "../skillBehavior/behaviorChain.ts"
import { type BlueprintFlattenResult, flattenBlueprintActions } from "../skillBehavior/bpEval.ts"
import { collectSkillEvidence, type SkillEvidence } from "./evidence.ts"
import { extractFieldRefs, type FieldRefResult } from "./fieldRefs.ts"
import { collectSkillGraph, type GraphResult, type GraphSeed, type GraphTables } from "./graph.ts"
import { readGrowRows } from "./grow.ts"
import { buildSkillVariants, collectSkillNodeRows, planSkillVariants, toSkillNodeEntries } from "./skillNodes.ts"
import {
    BLUEPRINT_ACTION_CHARACTER_IDS,
    type BlueprintAction,
    type BuffDotRef,
    type BuffEntry,
    type CharacterEntry,
    type GrowRows,
    type PassiveEntry,
    SKILL_BEHAVIOR_FEATURES,
    SKILL_BEHAVIOR_PARSER_VERSION,
    SKILL_BEHAVIOR_SCHEMA_VERSION,
    type SkillAnimationRef,
    type SkillAssetCoverage,
    type SkillAssetDoc,
    type SkillEntry,
    type SkillOwner,
    type UnresolvedBpRef,
    type UnresolvedRef,
} from "./types.ts"

const PROJECT_ROOT = join(import.meta.dir, "..", "..", "..")
const SLOT_BY_SKILL_TYPE: Record<string, string> = {
    Skill1: "E",
    Skill2: "Q",
    Passive: "P",
    ExtraPassive: "A",
    PhantomPassive: "T",
    UltraPassive: "U",
}

interface OwnedSkill {
    owner: SkillOwner
    characterId: number | null
    model: Record<string, any> | null
    parentSkillId: number | null
}

function asRecord(value: unknown): Record<string, any> | null {
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Record<string, any>) : null
}

function asString(value: unknown): string | null {
    return value === null || value === undefined || value === "" ? null : String(value)
}

function asNumber(value: unknown): number | null {
    if (value === null || value === undefined || value === "") return null
    const num = Number(value)
    return Number.isFinite(num) ? num : null
}

/** 保留数值/字符串原文（等级值可能是 `"#N"`），其余形态为 null。 */
function asScalar(value: unknown): number | string | null {
    if (typeof value === "number") return value
    if (typeof value === "string") return value
    return null
}

function stringList(value: unknown): string[] {
    const list = Array.isArray(value) ? value : value === undefined || value === null || value === "" ? [] : [value]
    return list.map(item => String(item)).filter(Boolean)
}

/** 按数字 id 升序生成记录对象，保证导出稳定。 */
function sortedRecord<T>(entries: Iterable<[number, T]>): Record<string, T> {
    return Object.fromEntries([...entries].sort(([a], [b]) => a - b).map(([id, value]) => [String(id), value]))
}

function buffDotRefs(value: unknown): BuffDotRef[] {
    const out: BuffDotRef[] = []
    for (const item of Array.isArray(value) ? value : []) {
        const dot = asRecord(item)
        if (!dot) continue
        out.push({
            type: asString(dot.Type),
            damageType: asString(dot.DamageType),
            damageTag: stringList(dot.DamageTag),
            interval: asNumber(dot.Interval),
            rate: asScalar(dot.Rate),
            value: asScalar(dot.Value),
            effectId: asNumber(dot.EffectId),
        })
    }
    return out
}

function haloBuffIds(value: unknown): number[] {
    const out: number[] = []
    for (const item of Array.isArray(value) ? value : []) {
        const buffId = asNumber(asRecord(item)?.BuffId)
        if (buffId !== null && !out.includes(buffId)) out.push(buffId)
    }
    return out
}

/**
 * 技能/被动 id 列表归一化：Lua 表可能是数组、1 起始 map 或普通对象 map
 * （真实数据里 `Mod.ModActivateSkills` 就是 `{"1010101":1010201}`），也允许单值。
 */
function toIdList(value: unknown): number[] {
    if (value === null || value === undefined || value === "") return []
    const list = Array.isArray(value) ? value : typeof value === "object" ? Object.values(value) : [value]
    const out: number[] = []
    for (const item of list) {
        const num = Number(item)
        if (Number.isFinite(num) && !out.includes(num)) out.push(num)
    }
    return out
}

/**
 * Blueprint 展平动作引用的 id → 图种子。
 * kind 由动作语义决定（效果数组 → SkillEffects，creature → SkillCreature，增益动作 → Buff），
 * 不按目标表是否存在推断，避免同一 id 在多张表出现时选错行。
 */
export function blueprintSeeds(actions: BlueprintAction[]): GraphSeed[] {
    const seeds: GraphSeed[] = []
    const seen = new Set<string>()
    const add = (kind: GraphSeed["kind"], id: number | null, relation: string, action: BlueprintAction): void => {
        if (id === null || !Number.isFinite(id)) return
        const bp = { bpPackage: action.source.bpPackage, function: action.source.function, nodeId: action.source.nodeId }
        const key = [kind, id, relation, bp.bpPackage, bp.function, bp.nodeId].join("\u0000")
        if (seen.has(key)) return
        seen.add(key)
        seeds.push({ kind, id, relation, descIndex: null, bp })
    }
    for (const action of actions) {
        switch (action.kind) {
            case "executeEffects":
                for (const effectId of action.effectIds) add("SkillEffects", effectId, "bp.executeEffects", action)
                break
            case "createCreature":
                for (const effectId of action.effectIds ?? []) add("SkillEffects", effectId, "bp.createCreature.effect", action)
                for (const creatureId of action.creatureIds ?? []) {
                    add("SkillCreature", creatureId, "bp.createCreature.creature", action)
                }
                break
            case "applyBuff":
                add("Buff", action.buffId, "bp.applyBuff", action)
                break
            case "removeBuff":
                add("Buff", action.buffId, "bp.removeBuff", action)
                break
            case "reduceBuffLayer":
                add("Buff", action.buffId, "bp.reduceBuffLayer", action)
                break
            case "damage":
                break
        }
    }
    return seeds
}

function joinGamePath(...parts: string[]): string {
    return parts
        .map(part => part.replace(/\\/g, "/"))
        .join("/")
        .replace(/\/+/g, "/")
}

function gitValue(args: string[]): string | null {
    try {
        const value = execFileSync("git", args, { cwd: PROJECT_ROOT, encoding: "utf8", windowsHide: true }).trim()
        return value || null
    } catch {
        return null
    }
}

/** 收集所有可达技能及其归属（角色优先；同一技能被多个持有者引用时保留第一个）。 */
function collectOwners(dm: ModuleContext["dm"]): {
    characters: CharacterEntry[]
    owned: Map<number, OwnedSkill>
    ownerPassives: Map<number, SkillOwner[]>
} {
    const charData = (dm.getTable("Char") as Record<string, any>) ?? {}
    const battleCharData = (dm.getTable("BattleChar") as Record<string, any>) ?? {}
    const modelData = (dm.getTable("Model") as Record<string, any>) ?? {}
    const ultraPassive = (dm.getTable("CharId2UltraPassiveSkillId") as Record<string, any>) ?? {}
    const battleWeaponData = (dm.getTable("BattleWeapon") as Record<string, any>) ?? {}
    const battlePetData = (dm.getTable("BattlePet") as Record<string, any>) ?? {}
    const modData = (dm.getTable("Mod") as Record<string, any>) ?? {}

    const owned = new Map<number, OwnedSkill>()
    const characters: CharacterEntry[] = []
    const ownerPassives = new Map<number, SkillOwner[]>()

    const register = (skillId: number, context: OwnedSkill) => {
        if (!Number.isFinite(skillId) || owned.has(skillId)) return
        owned.set(skillId, context)
    }
    const registerPassives = (value: unknown, owner: SkillOwner) => {
        for (const id of toIdList(value)) {
            const owners = ownerPassives.get(id) ?? []
            if (!owners.some(item => item.kind === owner.kind && item.id === owner.id)) owners.push(owner)
            ownerPassives.set(id, owners)
        }
    }

    const charIds = Object.entries(charData)
        .map(([key, char]) => {
            const record = asRecord(char)
            if (!record) return null
            const charId = Number(record.CharId ?? key)
            return Number.isFinite(charId) && charId <= 100000 ? charId : null
        })
        .filter((id): id is number => id !== null)
        .sort((a, b) => a - b)

    for (const charId of charIds) {
        const char = asRecord(charData[String(charId)] ?? charData[charId])
        const battleChar = asRecord(battleCharData[String(charId)] ?? battleCharData[charId])
        if (!char || !battleChar) continue
        const modelId = Number(battleChar.ModelId ?? charId)
        const model = asRecord(modelData[String(modelId)] ?? modelData[modelId])
        const skipSkillId = ultraPassive[String(charId)] ?? ultraPassive[charId]
        const skills = (Array.isArray(battleChar.SkillList) ? battleChar.SkillList : [])
            .map(Number)
            .filter((id: number) => Number.isFinite(id) && String(id) !== String(skipSkillId))
        const subSkillIds: number[] = []
        for (const skillId of skills) {
            register(skillId, { owner: { kind: "char", id: charId }, characterId: charId, model, parentSkillId: null })
            // 子技能（Skill.SubSkills）与 Char.json 的子技能口径一致：同属该角色，可被渲染为子技能条目。
            const entry = getSkillEntry(dm, skillId)
            const subSkills = Array.isArray(entry?.SubSkills) ? entry.SubSkills : []
            for (const raw of subSkills) {
                const subId = Number(raw)
                if (Number.isFinite(subId) && String(subId) !== String(skillId)) {
                    subSkillIds.push(subId)
                    register(subId, { owner: { kind: "char", id: charId }, characterId: charId, model, parentSkillId: skillId })
                }
            }
        }
        registerPassives(battleChar.PassiveEffects, { kind: "char", id: charId })
        characters.push({
            id: charId,
            nameKey: String(char.CharName ?? ""),
            modelId: Number.isFinite(modelId) ? modelId : null,
            skills,
            subSkills: subSkillIds,
            animBP: null,
        })
    }

    const registerList = (entries: Record<string, any>, kind: "weapon" | "pet" | "mod", listKey: string | null) => {
        for (const [key, value] of Object.entries(entries)) {
            const record = asRecord(value)
            if (!record) continue
            const id = Number(record.WeaponId ?? record.PetId ?? record.Id ?? key)
            if (!Number.isFinite(id)) continue
            const skills = listKey ? toIdList(record[listKey]) : toIdList(record.SupportSkillId)
            for (const skillId of skills) {
                register(skillId, { owner: { kind, id }, characterId: null, model: null, parentSkillId: null })
            }
            registerPassives(record.PassiveEffects, { kind, id })
        }
    }
    registerList(battleWeaponData, "weapon", "WeaponSkillList")
    registerList(battlePetData, "pet", null)
    registerList(modData, "mod", "ModActivateSkills")

    return { characters, owned, ownerPassives }
}

/** 动画解析只依赖节点的动画字段；证据节点与 SkillNode 全量行结构兼容。 */
type AnimationNode = Pick<SkillEvidence["nodes"][number], "animPath" | "animResource" | "animName" | "animSubPath">

/** 一个节点可能的动画资产候选：显式 AnimPath 优先，其次角色 Model 的 MontageFolder + MontagePrefix。 */
function animationCandidates(node: AnimationNode, model: Record<string, any> | null, exportsRoot: string): string[] {
    const resource = node.animResource ?? node.animName
    if (!resource) return []
    const candidates: string[] = []
    if (node.animPath?.includes("/Game/")) {
        const file = assetPathFromGamePath(joinGamePath(node.animPath, resource), exportsRoot)
        if (file) candidates.push(file)
    }
    if (model) {
        const folder = asString(model.MontageFolder)
        const prefix = asString(model.MontagePrefix) ?? ""
        const subPath = node.animSubPath ?? ""
        if (folder) {
            if (prefix) {
                const file = assetPathFromGamePath(joinGamePath(folder, subPath, `${prefix}${resource}`), exportsRoot)
                if (file) candidates.push(file)
            }
            const file = assetPathFromGamePath(joinGamePath(folder, subPath, resource), exportsRoot)
            if (file) candidates.push(file)
        }
    }
    return candidates
}

function buffNameIndex(bpAddBuff: Record<string, number[]>): Map<number, string[]> {
    const index = new Map<number, string[]>()
    for (const [name, buffs] of Object.entries(bpAddBuff)) {
        for (const buffId of Array.isArray(buffs) ? buffs : []) {
            const id = Number(buffId)
            if (!Number.isFinite(id)) continue
            const names = index.get(id) ?? []
            if (!names.includes(name)) names.push(name)
            index.set(id, names)
        }
    }
    return index
}

export interface SkillAssetDeps {
    /** 注入点（测试用）：默认使用真实 AssetReader + UAssetCLI。 */
    reader?: AssetReader
    gitCommit?: string | null
    gameVersion?: string | null
}

/** 构建 SkillAssetDoc。导出与测试共用；不做文件写入。 */
export async function buildSkillAssetDoc(ctx: ModuleContext, deps: SkillAssetDeps = {}): Promise<SkillAssetDoc> {
    const dm = ctx.dm
    const skillArtifacts = ctx.getArtifact<SkillArtifacts>("Skill")
    if (!skillArtifacts) throw new Error("SkillAsset 依赖 Skill artifacts，但 Skill 模块未构建")

    const exportsRoot = getExportsRoot()
    const reader = deps.reader ?? new AssetReader(dm.root)
    const ownsReader = !deps.reader

    const bpAddBuff = await loadBpAddBuff()
    const passiveEffectData = (id: number | string) => dm.getTableItem("PassiveEffect", id) as Record<string, any> | undefined
    const buffData = (id: number | string) => dm.getTableItem("Buff", id) as Record<string, any> | undefined
    const skillNodeData = (id: number | string) => dm.getTableItem("SkillNode", id) as Record<string, any> | undefined
    const skillEffectData = (id: number | string) => dm.getTableItem("SkillEffects", id) as Record<string, any> | undefined

    const { characters, owned, ownerPassives } = collectOwners(dm)
    const buffToBpNames = buffNameIndex(bpAddBuff)
    // SkillNode 全量表：一次性物化后同时用于 skillNodes 导出与变体解析。
    const skillNodeRows = collectSkillNodeRows(dm)

    // ---- 技能证据 ----
    const evidences = new Map<number, SkillEvidence>()
    const skillsMissing: number[] = []
    for (const skillId of [...owned.keys()].sort((a, b) => a - b)) {
        const evidence = collectSkillEvidence(dm, skillId, {
            skillNode: skillNodeData,
            skillEffect: skillEffectData,
            passiveEffect: passiveEffectData,
            bpAddBuff,
        })
        if (evidence) evidences.set(skillId, evidence)
        else skillsMissing.push(skillId)
    }

    // ---- 字段引用（v2）----
    const fieldRefs = new Map<number, FieldRefResult>()
    for (const [skillId, evidence] of evidences) {
        fieldRefs.set(
            skillId,
            extractFieldRefs(evidence.entry.SkillDescKeys, evidence.entry.SkillDescValues, { skillEffects: skillEffectData }, skillId)
        )
    }

    // ---- 行为图种子（v2）----
    // 只有行为链相关命名空间作为图种子；描述串里的 SkillNode/Skill/TargetFilter 等是数据查表
    // （消耗/半径），不是行为边，避免跨技能错误连通。节点链本身由 evidence 的节点集合提供。
    const graphTables: GraphTables = {
        skill: skillId => getSkillEntry(dm, skillId) ?? undefined,
        skillNode: skillNodeData,
        skillEffects: skillEffectData,
        skillCreature: id => dm.getTableItem("SkillCreature", id) as Record<string, any> | undefined,
        buff: buffData,
        passiveEffect: passiveEffectData,
        effectCreature: id => dm.getTableItem("EffectCreature", id) as Record<string, any> | undefined,
        unitParts: id => ({
            battleMonster: dm.getTableItem("BattleMonster", id) as Record<string, any> | undefined,
            monster: dm.getTableItem("Monster", id) as Record<string, any> | undefined,
            mechanismSummon: dm.getTableItem("MechanismSummon", id) as Record<string, any> | undefined,
        }),
    }
    const graphSeeds = new Map<number, GraphSeed[]>()
    for (const [skillId, evidence] of [...evidences.entries()].sort(([a], [b]) => a - b)) {
        const seeds: GraphSeed[] = []
        for (const node of evidence.nodes) seeds.push({ kind: "SkillNode", id: node.id, relation: "node", descIndex: null })
        for (const effect of evidence.effects) seeds.push({ kind: "SkillEffects", id: effect.id, relation: "effect", descIndex: null })
        for (const buffId of evidence.buffIds) seeds.push({ kind: "Buff", id: buffId, relation: "skill.buff", descIndex: null })
        for (const passiveId of evidence.passiveIds) {
            seeds.push({ kind: "PassiveEffect", id: passiveId, relation: "skill.passive", descIndex: null })
        }
        for (const group of fieldRefs.get(skillId)!.groups) {
            for (const ref of group.refs) {
                if (ref.kind === "SkillEffects" || ref.kind === "SkillCreature" || ref.kind === "Buff" || ref.kind === "PassiveEffect") {
                    seeds.push({ kind: ref.kind, id: ref.id, relation: "desc", descIndex: group.descIndex })
                }
            }
        }
        graphSeeds.set(skillId, seeds)
    }

    // ---- 动画解析（按绝对路径去重） ----
    const animFileByKey = new Map<string, string | null>()
    const montageByKey = new Map<string, MontageTimeline | null>()
    const sequenceByKey = new Map<string, SequenceMeta | null>()
    const sequenceMissing = new Set<string>()
    const montagesFailed: Array<{ asset: string; reason: string }> = []
    const sequencesFailed: Array<{ asset: string; reason: string }> = []
    const montagesMissing: SkillAssetCoverage["montagesMissing"] = []

    const resolveAnimFile = (node: AnimationNode, ownedSkill: OwnedSkill): string | null => {
        if (!exportsRoot) return null
        for (const candidate of animationCandidates(node, ownedSkill.model, exportsRoot)) {
            const key = candidate.replace(/\\/g, "/").toLowerCase()
            if (!animFileByKey.has(key)) animFileByKey.set(key, existsSync(candidate) ? candidate : null)
            const resolved = animFileByKey.get(key)
            if (resolved) return resolved
        }
        return null
    }

    const readMontage = async (file: string): Promise<MontageTimeline | null> => {
        const key = file.replace(/\\/g, "/").toLowerCase()
        if (montageByKey.has(key)) return montageByKey.get(key) ?? null
        const read = await reader.readMontageTimeline(file)
        if (!read.timeline && exportsRoot) {
            montagesFailed.push({ asset: packagePathFor(file, exportsRoot), reason: read.error ?? "unknown read failure" })
        }
        montageByKey.set(key, read.timeline)
        return read.timeline
    }

    const readSequence = async (packagePath: string): Promise<SequenceMeta | null> => {
        const key = packagePath.toLowerCase()
        if (sequenceByKey.has(key)) return sequenceByKey.get(key) ?? null
        if (!exportsRoot) {
            sequenceMissing.add(packagePath)
            sequenceByKey.set(key, null)
            return null
        }
        const file = assetPathFromObjectPath(`${packagePath}.0`, exportsRoot)
        if (!file || !existsSync(file)) {
            sequenceMissing.add(packagePath)
            sequenceByKey.set(key, null)
            return null
        }
        const read = await reader.readSequence(file)
        if (!read.meta) {
            sequencesFailed.push({ asset: packagePath, reason: read.error ?? "unknown read failure" })
            sequenceMissing.add(packagePath)
            sequenceByKey.set(key, null)
            return null
        }
        sequenceByKey.set(key, read.meta)
        return read.meta
    }

    // ---- Blueprint / AnimBlueprint ----
    const blueprintDocs = new Map<string, UAssetBytecodeDocument>()
    const blueprintErrors: Array<{ path: string; error: string }> = []
    const blueprintMissing = new Set<string>()
    const bpFileByPackage = new Map<string, string>()
    /**
     * BP 动作展平结果（按包缓存）：同一包被多个技能引用时只求值一次，
     * coverage.blueprintUnresolved 也只记录一次。
     */
    const blueprintActionResult = new Map<string, BlueprintFlattenResult>()
    const blueprintUnresolved: UnresolvedBpRef[] = []
    /** SkillEffects id → 该效果任务里 CreateSkillCreature.CreatureId；行缺失返回 null。 */
    const effectCreatures = (effectId: number): number[] | null => {
        const row = skillEffectData(effectId)
        if (!row) return null
        const ids: number[] = []
        for (const item of Array.isArray(row.TaskEffects) ? row.TaskEffects : []) {
            const task = asRecord(item)
            if (task?.Function !== "CreateSkillCreature") continue
            const creatureId = asNumber(task.CreatureId)
            if (creatureId !== null && !ids.includes(creatureId)) ids.push(creatureId)
        }
        return ids
    }
    const animBPDocs = new Map<string, AnimBPInfo>()
    const animBPMissing: SkillAssetCoverage["animBPsMissing"] = []
    let server: UAssetServer | null = null
    try {
        server = await reader.ensureServer()
    } catch {
        server = null
    }

    const loadBlueprint = async (file: string): Promise<UAssetBytecodeDocument | null> => {
        if (!exportsRoot) return null
        const packagePath = packagePathFor(file, exportsRoot)
        const cached = blueprintDocs.get(packagePath)
        if (cached) return cached
        if (!server) {
            blueprintErrors.push({ path: packagePath, error: "UAssetCLI server unavailable" })
            return null
        }
        try {
            const doc = await server.bytecode(file)
            blueprintDocs.set(packagePath, doc)
            return doc
        } catch (error) {
            blueprintErrors.push({ path: packagePath, error: error instanceof Error ? error.message : String(error) })
            return null
        }
    }

    const charAnimBP = new Map<number, string | null>()
    for (const character of characters) {
        const model =
            character.modelId === null ? null : asRecord((dm.getTable("Model") as Record<string, any>)?.[String(character.modelId)])
        const path = asString(model?.AnimInstancePath)
        if (!path || !exportsRoot) {
            charAnimBP.set(character.id, null)
            animBPMissing.push({
                characterId: character.id,
                path,
                reason: exportsRoot ? "Model.AnimInstancePath missing" : "DNA_UNPACK_DIR unavailable",
            })
            continue
        }
        const file = assetPathFromGamePath(path, exportsRoot)
        if (!file || !existsSync(file)) {
            charAnimBP.set(character.id, null)
            animBPMissing.push({ characterId: character.id, path, reason: "AnimBlueprint asset not found" })
            continue
        }
        const packagePath = packagePathFor(file, exportsRoot)
        if (!animBPDocs.has(packagePath)) {
            const read = await reader.readAnimBP(file)
            if (!read.info) {
                charAnimBP.set(character.id, null)
                animBPMissing.push({ characterId: character.id, path, reason: read.error ?? "unknown read failure" })
                continue
            }
            animBPDocs.set(packagePath, read.info)
        }
        charAnimBP.set(character.id, packagePath)
        character.animBP = packagePath
    }

    // ---- 逐技能组装 ----
    const skills: Record<string, SkillEntry> = {}
    const buffIds = new Set<number>()
    const skillBpPaths = new Set<string>()
    /** 变体归纳中缺失的子技能行 / 节点行；不静默丢弃。 */
    const variantIssues: UnresolvedRef[] = []

    for (const skillId of [...evidences.keys()].sort((a, b) => a - b)) {
        const evidence = evidences.get(skillId)!
        const ownedSkill = owned.get(skillId)!
        const skillType = asString(evidence.entry.SkillType)
        const slot = (skillType && SLOT_BY_SKILL_TYPE[skillType]) ?? skillType ?? "?"
        const maxLevelInfo = dm.getTableItem("Skill", skillId)
        const maxLevel = Array.isArray(maxLevelInfo) ? Math.min(maxLevelInfo.length, 12) : 1

        const animationRefs: SkillAnimationRef[] = []
        const montagePackages: string[] = []
        const montageTimelines: MontageTimeline[] = []
        const seenMontages = new Set<string>()
        for (const node of evidence.nodes) {
            const file = resolveAnimFile(node, ownedSkill)
            const packagePath = file && exportsRoot ? packagePathFor(file, exportsRoot) : null
            animationRefs.push({
                nodeId: node.id,
                asset: packagePath,
                animPath: node.animPath,
                animResource: node.animResource,
                animName: node.animName,
                animSubPath: node.animSubPath,
                playRate: node.playRate,
            })
            if (!file) {
                if (node.animResource || node.animName) {
                    montagesMissing.push({
                        skillId,
                        nodeId: node.id,
                        animPath: node.animPath,
                        animSubPath: node.animSubPath,
                        animResource: node.animResource,
                        animName: node.animName,
                    })
                }
                continue
            }
            if (!packagePath || seenMontages.has(packagePath)) continue
            seenMontages.add(packagePath)
            const timeline = await readMontage(file)
            if (timeline) {
                montagePackages.push(packagePath)
                montageTimelines.push(timeline)
            }
        }

        // 变体：BeginNodeId（默认）+ SubSkills 各自 BeginNodeId；不合并互斥分支的 effects。
        const variantPlan = planSkillVariants(dm, evidence.entry)
        const variantResult = buildSkillVariants(skillNodeRows, variantPlan, row => {
            const file = resolveAnimFile(row, ownedSkill)
            return file && exportsRoot ? packagePathFor(file, exportsRoot) : null
        })
        for (const subSkillId of variantPlan.missingSubSkillIds) {
            variantIssues.push({
                kind: "Skill",
                id: subSkillId,
                from: `skill:${skillId}`,
                reason: "missing-row",
                detail: "SubSkills",
            })
        }
        for (const nodeId of variantResult.missingNodeIds) {
            variantIssues.push({
                kind: "SkillNode",
                id: nodeId,
                from: `skill:${skillId}`,
                reason: "missing-row",
                detail: "variant-root",
            })
        }

        const sequences: SequenceMeta[] = []
        const seenSequences = new Set<string>()
        for (const timeline of montageTimelines) {
            for (const segment of timeline.segments) {
                if (!segment.sequence || seenSequences.has(segment.sequence)) continue
                seenSequences.add(segment.sequence)
                const meta = await readSequence(segment.sequence)
                if (meta) sequences.push(meta)
            }
        }

        const bpPackages: string[] = []
        const addBlueprintPath = (path: string | null): void => {
            if (!path || !exportsRoot) return
            const file = assetPathFromGamePath(path, exportsRoot)
            if (!file) return
            const packagePath = packagePathFor(file, exportsRoot)
            bpFileByPackage.set(packagePath, file)
            if (!existsSync(file)) {
                blueprintMissing.add(packagePath)
                return
            }
            if (!bpPackages.includes(packagePath)) bpPackages.push(packagePath)
        }
        for (const passive of evidence.passiveEffectBPs) addBlueprintPath(passive.path)
        for (const buffId of evidence.buffIds) {
            buffIds.add(buffId)
            addBlueprintPath(asString(buffData(buffId)?.BPPath))
        }
        for (const packagePath of bpPackages) skillBpPaths.add(packagePath)

        const skillErrors: Array<{ path: string; error: string }> = []
        for (const packagePath of bpPackages) {
            if (blueprintDocs.has(packagePath)) continue
            const file = bpFileByPackage.get(packagePath)
            if (!file) continue
            const before = blueprintErrors.length
            await loadBlueprint(file)
            for (const item of blueprintErrors.slice(before)) skillErrors.push(item)
        }

        const animBP = ownedSkill.characterId !== null ? (charAnimBP.get(ownedSkill.characterId) ?? null) : null
        let blueprintActions: BlueprintAction[] | undefined
        if (ownedSkill.characterId !== null && (BLUEPRINT_ACTION_CHARACTER_IDS as readonly number[]).includes(ownedSkill.characterId)) {
            const collected: BlueprintAction[] = []
            for (const packagePath of bpPackages) {
                const doc = blueprintDocs.get(packagePath)
                if (!doc) {
                    blueprintUnresolved.push({
                        bpPackage: packagePath,
                        function: "",
                        nodeId: "",
                        call: "",
                        reason: "blueprint-not-available",
                    })
                    continue
                }
                let result = blueprintActionResult.get(packagePath)
                if (!result) {
                    result = flattenBlueprintActions(packagePath, doc, { effectCreatures })
                    blueprintActionResult.set(packagePath, result)
                    blueprintUnresolved.push(...result.unresolved)
                }
                collected.push(...result.actions)
            }
            blueprintActions = collected
        }
        // BP 字面量引用的效果/实体/增益同样要导出完整行：按动作语义加入图种子（见 blueprintSeeds）。
        if (blueprintActions) graphSeeds.get(skillId)?.push(...blueprintSeeds(blueprintActions))
        skills[String(skillId)] = {
            id: skillId,
            characterId: ownedSkill.characterId,
            parentSkillId: ownedSkill.parentSkillId,
            owner: ownedSkill.owner,
            slot,
            lua: {
                skillType,
                nameKey: asString(evidence.entry.SkillName),
                beginNodeId: evidence.beginNodeId,
                behavior: generateSkillBehaviorText(dm, skillArtifacts, skillId),
                fields: skillArtifacts.explainSkillFields(evidence.entry, skillId, maxLevel),
                nodes: evidence.nodes,
                effects: evidence.effects,
                buffIds: evidence.buffIds,
                passiveEffectIds: evidence.passiveIds,
                passiveEffectBPs: evidence.passiveEffectBPs,
                fieldRefs: fieldRefs.get(skillId)!.groups,
            },
            skillRow: variantPlan.skillRow,
            variants: variantResult.variants,
            sources: {
                montage: montagePackages[0] ?? null,
                montages: montagePackages,
                bpPackages,
                animBPs: animBP ? [animBP] : [],
            },
            montage: montageTimelines[0] ?? null,
            additionalMontages: montageTimelines.slice(1),
            sequences,
            animationRefs,
            animBP,
            blueprintErrors: skillErrors,
            ...(blueprintActions ? { blueprintActions } : {}),
        }
    }

    // ---- 行为图（v2）----
    // 在 blueprintActions 展平之后遍历：BP 引用的 id 按动作语义作为种子加入，
    // 不按「目标表里是否存在」推断 kind（同名/跨表 id 冲突不得混淆）。
    const graphInputs = [...graphSeeds.entries()].sort(([a], [b]) => a - b).map(([skillId, seeds]) => ({ skillId, seeds }))
    const graph: GraphResult = collectSkillGraph(graphTables, graphInputs)

    // BP 种子缺行：图遍历已写入 unresolvedRefs；Blueprint 侧再按 BP 包/函数/节点记一次，便于定位调用点。
    for (const [skillId, seeds] of graphSeeds) {
        for (const seed of seeds) {
            if (!seed.bp) continue
            const missing =
                seed.kind === "SkillEffects"
                    ? graph.missing.effects
                    : seed.kind === "SkillCreature"
                      ? graph.missing.creatures
                      : seed.kind === "Buff"
                        ? graph.missing.buffs
                        : null
            if (!missing?.has(seed.id)) continue
            blueprintUnresolved.push({
                bpPackage: seed.bp.bpPackage,
                function: seed.bp.function,
                nodeId: seed.bp.nodeId,
                call: seed.relation,
                reason: "seed-row-missing",
                detail: `${seed.kind}:${seed.id} (skill:${skillId})`,
            })
        }
    }

    // ---- SkillGrow 等级序列（v2，按需加载分区）----
    const growSections = new Map<string, Record<string, unknown> | undefined>()
    const growFor = (section: string, id: number): GrowRows | null => {
        if (!growSections.has(section)) {
            growSections.set(section, dm.getTableItem("SkillGrow", section) as Record<string, unknown> | undefined)
        }
        const rows = growSections.get(section)
        return rows ? readGrowRows(rows[String(id)]) : null
    }

    // ---- Buff ----
    const buffs: Record<string, BuffEntry> = {}
    const buffsMissing: number[] = [...graph.missing.buffs].sort((a, b) => a - b)
    for (const buffId of [...graph.buffIds].sort((a, b) => a - b)) {
        const raw = buffData(buffId)
        if (!raw) {
            if (!buffsMissing.includes(buffId)) buffsMissing.push(buffId)
            continue
        }
        const path = asString(raw.BPPath)
        let bpPackages: string[] = []
        if (path && exportsRoot) {
            const file = assetPathFromGamePath(path, exportsRoot)
            if (file && existsSync(file)) bpPackages = [packagePathFor(file, exportsRoot)]
        }
        buffs[String(buffId)] = {
            id: buffId,
            lua: raw,
            bpPackages,
            sources: graph.buffSources.get(buffId) ?? [],
            bpNames: buffToBpNames.get(buffId) ?? [],
            grow: growFor("Buff", buffId),
            dotDatas: buffDotRefs(raw.DotDatas),
            haloBuffIds: haloBuffIds(raw.HaloDatas),
            execEffectIds: toIdList(raw.ExecSkillEffectWhenRemoved),
            activateSkillIds: toIdList(raw.ActivateSkills),
            passiveEffectIds: toIdList(raw.AddPassiveEffect),
            initialEffectIds: toIdList(raw.InitialEffect),
        }
    }

    // ---- PassiveEffect：持有者级 + 技能链引用（TaskEffects.PassiveEffectId / 描述串 / 图） ----
    const passiveReferences = new Map<number, number[]>()
    for (const [skillId, reach] of [...graph.reachBySkill.entries()].sort(([a], [b]) => a - b)) {
        for (const passiveId of reach.passives) {
            const refs = passiveReferences.get(passiveId) ?? []
            if (!refs.includes(skillId)) refs.push(skillId)
            passiveReferences.set(passiveId, refs)
        }
    }
    const passives: Record<string, PassiveEntry> = {}
    const passivesMissing: number[] = [...graph.missing.passives].sort((a, b) => a - b)
    const allPassiveIds = [
        ...new Set([...ownerPassives.keys(), ...passiveReferences.keys(), ...graph.passiveIds, ...graph.missing.passives]),
    ].sort((a, b) => a - b)
    for (const passiveId of allPassiveIds) {
        const raw = passiveEffectData(passiveId)
        if (!raw) {
            if (!passivesMissing.includes(passiveId)) passivesMissing.push(passiveId)
            continue
        }
        const bpPackages: string[] = []
        const path = asString(raw.BPPath)
        if (path && exportsRoot) {
            const file = assetPathFromGamePath(path, exportsRoot)
            if (file) {
                const packagePath = packagePathFor(file, exportsRoot)
                bpFileByPackage.set(packagePath, file)
                if (!existsSync(file)) blueprintMissing.add(packagePath)
                else {
                    bpPackages.push(packagePath)
                    skillBpPaths.add(packagePath)
                    if (!blueprintDocs.has(packagePath)) await loadBlueprint(file)
                }
            }
        }
        passives[String(passiveId)] = {
            id: passiveId,
            lua: raw,
            bpPackages,
            owners: ownerPassives.get(passiveId) ?? [],
            referencedBySkills: passiveReferences.get(passiveId) ?? [],
            grow: growFor("PassiveEffect", passiveId),
        }
    }

    // ---- Effect / Creature / Unit（v2 图产物；grow 在模块侧补齐）----
    for (const effect of graph.effects.values()) effect.grow = growFor("SkillEffects", effect.id)

    const fieldRefIssues: UnresolvedRef[] = []
    let fieldRefsTotal = 0
    for (const result of fieldRefs.values()) {
        fieldRefsTotal += result.total
        for (const issue of result.unresolved) fieldRefIssues.push(issue)
    }
    const unresolvedRefs = mergeUnresolved(graph.unresolved, fieldRefIssues, variantIssues)

    const assetStats = reader.stats()
    if (ownsReader) await reader.close()

    const skillList = Object.values(skills)

    // notify payload 关联统计：无 export 的原生 notify 与多候选都显式进入覆盖清单。
    let notifiesTotal = 0
    let notifiesWithPayload = 0
    const notifiesWithoutPayload: SkillAssetCoverage["notifiesWithoutPayload"] = []
    const notifiesAmbiguousPayload: SkillAssetCoverage["notifiesAmbiguousPayload"] = []
    const seenNotifyGaps = new Set<string>()
    for (const skill of skillList) {
        for (const timeline of [skill.montage, ...skill.additionalMontages]) {
            if (!timeline) continue
            for (const notify of timeline.notifies) {
                notifiesTotal++
                if (notify.payload || notify.payloads) notifiesWithPayload++
                if (!notify.payload && !notify.payloads) {
                    const key = [timeline.asset, notify.name, notify.time].join("\u0000")
                    if (!seenNotifyGaps.has(key)) {
                        seenNotifyGaps.add(key)
                        notifiesWithoutPayload.push({ asset: timeline.asset, name: notify.name, time: notify.time, state: notify.state })
                    }
                }
                if (notify.payloadAmbiguous) {
                    notifiesAmbiguousPayload.push({ asset: timeline.asset, name: notify.name, matches: notify.payloadMatches })
                }
            }
        }
    }

    const coverage: SkillAssetCoverage = {
        skillsTotal: skillList.length,
        skillsMissing,
        skillsWithMontage: skillList.filter(skill => skill.montage !== null).length,
        skillsWithBlueprint: skillList.filter(skill => skill.sources.bpPackages.length > 0).length,
        skillsWithAnimBP: skillList.filter(skill => skill.animBP !== null).length,
        skillsWithLuaOnly: skillList.filter(skill => skill.montage === null && skill.sources.bpPackages.length === 0).length,
        montagesResolved: montagePackagesResolved(montageByKey),
        skillNodesTotal: skillNodeRows.size,
        montagesMissing,
        montagesFailed: dedupeBy(montagesFailed, item => item.asset),
        notifiesTotal,
        notifiesWithPayload,
        notifiesWithoutPayload,
        notifiesAmbiguousPayload,
        sequencesResolved: [...sequenceByKey.values()].filter((item): item is SequenceMeta => item !== null).length,
        sequencesMissing: [...sequenceMissing].sort(),
        sequencesFailed: dedupeBy(sequencesFailed, item => `${item.asset}\u0000${item.reason}`),
        blueprintsTotal: skillBpPaths.size + [...blueprintMissing].length,
        blueprintsParsed: blueprintDocs.size,
        blueprintsFailed: dedupeBy(blueprintErrors, item => `${item.path}\u0000${item.error}`),
        blueprintsMissing: [...blueprintMissing].sort(),
        animBPsTotal: characters.length,
        animBPsResolved: characters.filter(character => character.animBP !== null).length,
        animBPsWithStateMachines: [...animBPDocs.values()].filter(info => info.stateMachines.length > 0).length,
        animBPsMissing: animBPMissing,
        passiveEffectsTotal: new Set(skillList.flatMap(skill => skill.lua.passiveEffectIds)).size,
        ownerPassivesTotal: ownerPassives.size,
        ownerPassivesWithBlueprint: [...ownerPassives.keys()].filter(id => (passives[String(id)]?.bpPackages.length ?? 0) > 0).length,
        passivesTotal: Object.keys(passives).length,
        passivesWithBlueprint: Object.values(passives).filter(passive => passive.bpPackages.length > 0).length,
        passivesMissing,
        buffsTotal: Object.keys(buffs).length,
        buffsWithBlueprint: Object.values(buffs).filter(buff => buff.bpPackages.length > 0).length,
        buffsMissing,
        effectsTotal: graph.effects.size,
        effectsMissing: [...graph.missing.effects].sort((a, b) => a - b),
        creaturesTotal: graph.creatures.size,
        creaturesMissing: [...graph.missing.creatures].sort((a, b) => a - b),
        unitsTotal: graph.units.size,
        unitsMissing: [...graph.missing.units].sort((a, b) => a - b),
        fieldRefsTotal,
        fieldRefsUnresolved: fieldRefIssues.length,
        unresolvedRefs,
        depthLimitHits: graph.depthLimitHits,
        conventionRefs: graph.conventionRefs,
        blueprintUnresolved: dedupeBlueprintUnresolved(blueprintUnresolved),
        owners: ownerBreakdown(skillList),
        nativeCallsUnknown: collectNativeCalls(blueprintDocs),
        assets: assetStats,
    }

    return {
        schemaVersion: SKILL_BEHAVIOR_SCHEMA_VERSION,
        features: [...SKILL_BEHAVIOR_FEATURES],
        exporter: {
            gitCommit: deps.gitCommit !== undefined ? deps.gitCommit : gitValue(["rev-parse", "--short", "HEAD"]),
            parserVersion: SKILL_BEHAVIOR_PARSER_VERSION,
            gameVersion: deps.gameVersion !== undefined ? deps.gameVersion : gitValue(["log", "-1", "--format=%s", "--grep", "^v[0-9]"]),
        },
        characters,
        skills,
        skillNodes: toSkillNodeEntries(skillNodeRows),
        effects: sortedRecord(graph.effects.entries()),
        creatures: sortedRecord(graph.creatures.entries()),
        units: sortedRecord(graph.units.entries()),
        buffs,
        passives,
        blueprints: Object.fromEntries([...blueprintDocs.entries()].sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0))),
        animBPs: Object.fromEntries([...animBPDocs.entries()].sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0))),
        coverage,
    }
}

function montagePackagesResolved(montageByKey: Map<string, MontageTimeline | null>): number {
    return [...montageByKey.values()].filter((item): item is MontageTimeline => item !== null).length
}

/** 按持有者类型拆分技能口径：角色 169 主技能与武器/宠物/MOD 分开计数，避免混读。 */
function ownerBreakdown(skills: SkillEntry[]): SkillAssetCoverage["owners"] {
    const out: SkillAssetCoverage["owners"] = {}
    for (const skill of skills) {
        const entry = (out[skill.owner.kind] ??= { skills: 0, withMontage: 0, withBlueprint: 0 })
        entry.skills++
        if (skill.montage) entry.withMontage++
        if (skill.sources.bpPackages.length > 0) entry.withBlueprint++
    }
    return out
}

/**
 * 收集 Blueprint 字节码中调用、但未在同一资产内定义的函数名（引擎/蓝图外部调用）。
 * 只做频次统计与溯源，语义归一由 dna-builder 负责。
 */
function collectNativeCalls(blueprints: Map<string, UAssetBytecodeDocument>): Array<{ name: string; count: number }> {
    const counts = new Map<string, number>()
    const visit = (node: unknown, defined: Set<string>) => {
        if (!node || typeof node !== "object") return
        if (Array.isArray(node)) {
            for (const item of node) visit(item, defined)
            return
        }
        const record = node as Record<string, unknown>
        const op = record.op
        if (op === "EX_FinalFunction" || op === "EX_CallMath" || op === "EX_VirtualFunction") {
            const fn = record.function
            if (typeof fn === "string" && fn && !defined.has(fn) && !fn.startsWith("ExecuteUbergraph_")) {
                counts.set(fn, (counts.get(fn) ?? 0) + 1)
            }
        }
        for (const [key, value] of Object.entries(record)) {
            if (key === "op" || key === "function") continue
            if (value && typeof value === "object") visit(value, defined)
        }
    }
    for (const doc of blueprints.values()) {
        const defined = new Set(doc.functions.map(fn => fn.name))
        for (const fn of doc.functions) visit(fn.body, defined)
    }
    return [...counts.entries()].map(([name, count]) => ({ name, count })).sort((a, b) => b.count - a.count || (a.name < b.name ? -1 : 1))
}

/** 合并图遍历与字段引用的未解析记录；按稳定键去重并排序。 */
function mergeUnresolved(...groups: UnresolvedRef[][]): UnresolvedRef[] {
    const seen = new Set<string>()
    const out: UnresolvedRef[] = []
    for (const group of groups) {
        for (const ref of group) {
            const key = [ref.kind, ref.id ?? "", ref.from, ref.reason, ref.detail ?? ""].join("\u0000")
            if (seen.has(key)) continue
            seen.add(key)
            out.push(ref)
        }
    }
    return out.sort(
        (a, b) =>
            a.kind.localeCompare(b.kind) ||
            (a.id ?? -1) - (b.id ?? -1) ||
            a.from.localeCompare(b.from) ||
            a.reason.localeCompare(b.reason) ||
            (a.detail ?? "").localeCompare(b.detail ?? "")
    )
}

/** BP 展平缺口按 BP/函数/节点/原因去重并稳定排序。 */
function dedupeBlueprintUnresolved(items: UnresolvedBpRef[]): UnresolvedBpRef[] {
    return dedupeBy(items, item =>
        [item.bpPackage, item.function, item.nodeId, item.call, item.reason, item.detail ?? ""].join("\u0000")
    ).sort(
        (a, b) =>
            a.bpPackage.localeCompare(b.bpPackage) ||
            a.function.localeCompare(b.function) ||
            a.nodeId.localeCompare(b.nodeId) ||
            a.call.localeCompare(b.call) ||
            a.reason.localeCompare(b.reason) ||
            (a.detail ?? "").localeCompare(b.detail ?? "")
    )
}

function dedupeBy<T>(items: T[], key: (item: T) => string): T[] {
    const seen = new Set<string>()
    const out: T[] = []
    for (const item of items) {
        const id = key(item)
        if (seen.has(id)) continue
        seen.add(id)
        out.push(item)
    }
    return out
}

/** BPAddBuff 静态表（char 模块数据）；与 behaviorChain 读同一文件。 */
async function loadBpAddBuff(): Promise<Record<string, number[]>> {
    const file = join(import.meta.dir, "..", "char", "data", "BPAddBuff.json")
    const text = readFileSync(file, "utf8")
    return JSON.parse(text) as Record<string, number[]>
}

/** 模块入口：返回语言无关产物 `skill-behavior`（CLI 写入 final/skill-behavior.json）。 */
export async function skillAssetModule(ctx: ModuleContext): Promise<Record<string, unknown>> {
    const doc = await buildSkillAssetDoc(ctx)
    return { "skill-behavior": doc }
}
