/**
 * skillAsset — 产出语言无关的 final/skill-behavior.json（SkillAssetDoc）。
 *
 * 数据来源（只处理可达资产）：
 * - 角色：Char + BattleChar.SkillList（排除超限被动，与 Char.json 口径一致）
 * - 武器/宠物/MOD：BattleWeapon.WeaponSkillList、BattlePet.SupportSkillId、Mod.ModActivateSkills
 * - 技能链：Skill → SkillNode → SkillEffects → Buff / PassiveEffect（遍历契约同 behaviorChain）
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
import { generateSkillBehaviorText, getSkillEntry } from "../char/behaviorChain.ts"
import type { SkillArtifacts } from "../skill/skillModule.ts"
import { collectSkillEvidence, type SkillEvidence } from "./evidence.ts"
import {
    type BuffEntry,
    type CharacterEntry,
    type PassiveEntry,
    SKILL_BEHAVIOR_PARSER_VERSION,
    SKILL_BEHAVIOR_SCHEMA_VERSION,
    type SkillAnimationRef,
    type SkillAssetCoverage,
    type SkillAssetDoc,
    type SkillEntry,
    type SkillOwner,
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
        for (const raw of Array.isArray(value) ? value : []) {
            const id = Number(raw)
            if (!Number.isFinite(id)) continue
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
            const skills = listKey
                ? (Array.isArray(record[listKey]) ? record[listKey] : []).map(Number)
                : record.SupportSkillId === undefined || record.SupportSkillId === null
                  ? []
                  : [Number(record.SupportSkillId)]
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

/** 一个节点可能的动画资产候选：显式 AnimPath 优先，其次角色 Model 的 MontageFolder + MontagePrefix。 */
function animationCandidates(node: SkillEvidence["nodes"][number], model: Record<string, any> | null, exportsRoot: string): string[] {
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

    // ---- 动画解析（按绝对路径去重） ----
    const animFileByKey = new Map<string, string | null>()
    const montageByKey = new Map<string, MontageTimeline | null>()
    const sequenceByKey = new Map<string, SequenceMeta | null>()
    const sequenceMissing = new Set<string>()
    const montagesFailed: Array<{ asset: string; reason: string }> = []
    const montagesMissing: SkillAssetCoverage["montagesMissing"] = []

    const resolveAnimFile = (node: SkillEvidence["nodes"][number], ownedSkill: OwnedSkill): string | null => {
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
        const timeline = await reader.readMontageTimeline(file)
        if (!timeline && exportsRoot) montagesFailed.push({ asset: packagePathFor(file, exportsRoot), reason: "not an AnimMontage export" })
        montageByKey.set(key, timeline)
        return timeline
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
        const meta = await reader.readSequence(file)
        if (!meta) {
            sequenceMissing.add(packagePath)
            sequenceByKey.set(key, null)
            return null
        }
        sequenceByKey.set(key, meta)
        return meta
    }

    // ---- Blueprint / AnimBlueprint ----
    const blueprintDocs = new Map<string, UAssetBytecodeDocument>()
    const blueprintErrors: Array<{ path: string; error: string }> = []
    const blueprintMissing = new Set<string>()
    const bpFileByPackage = new Map<string, string>()
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
            const info = await reader.readAnimBP(file)
            if (!info) {
                charAnimBP.set(character.id, null)
                animBPMissing.push({ characterId: character.id, path, reason: "not an AnimBlueprintGeneratedClass export" })
                continue
            }
            animBPDocs.set(packagePath, info)
        }
        charAnimBP.set(character.id, packagePath)
        character.animBP = packagePath
    }

    // ---- 逐技能组装 ----
    const skills: Record<string, SkillEntry> = {}
    const buffIds = new Set<number>()
    const skillBpPaths = new Set<string>()

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
            },
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
        }
    }

    // ---- Buff ----
    const buffs: Record<string, BuffEntry> = {}
    for (const buffId of [...buffIds].sort((a, b) => a - b)) {
        const raw = buffData(buffId)
        if (!raw) continue
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
            bpNames: buffToBpNames.get(buffId) ?? [],
        }
    }

    // ---- 持有者级 PassiveEffect（BattleChar/BattleWeapon/BattlePet/Mod.PassiveEffects） ----
    const passives: Record<string, PassiveEntry> = {}
    for (const passiveId of [...ownerPassives.keys()].sort((a, b) => a - b)) {
        const raw = passiveEffectData(passiveId)
        if (!raw) continue
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
        }
    }

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
                    const key = `${timeline.asset} ${notify.name} ${notify.time}`
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
        montagesMissing,
        montagesFailed: dedupeBy(montagesFailed, item => item.asset),
        notifiesTotal,
        notifiesWithPayload,
        notifiesWithoutPayload,
        notifiesAmbiguousPayload,
        sequencesResolved: [...sequenceByKey.values()].filter((item): item is SequenceMeta => item !== null).length,
        sequencesMissing: [...sequenceMissing].sort(),
        blueprintsTotal: skillBpPaths.size + [...blueprintMissing].length,
        blueprintsParsed: blueprintDocs.size,
        blueprintsFailed: dedupeBy(blueprintErrors, item => `${item.path}\u0000${item.error}`),
        blueprintsMissing: [...blueprintMissing].sort(),
        animBPsTotal: characters.length,
        animBPsResolved: characters.filter(character => character.animBP !== null).length,
        animBPsMissing: animBPMissing,
        passiveEffectsTotal: new Set(skillList.flatMap(skill => skill.lua.passiveEffectIds)).size,
        ownerPassivesTotal: Object.keys(passives).length,
        ownerPassivesWithBlueprint: Object.values(passives).filter(passive => passive.bpPackages.length > 0).length,
        buffsTotal: Object.keys(buffs).length,
        buffsWithBlueprint: Object.values(buffs).filter(buff => buff.bpPackages.length > 0).length,
        assets: assetStats,
    }

    return {
        schemaVersion: SKILL_BEHAVIOR_SCHEMA_VERSION,
        exporter: {
            gitCommit: deps.gitCommit !== undefined ? deps.gitCommit : gitValue(["rev-parse", "--short", "HEAD"]),
            parserVersion: SKILL_BEHAVIOR_PARSER_VERSION,
            gameVersion: deps.gameVersion !== undefined ? deps.gameVersion : gitValue(["log", "-1", "--format=%s", "--grep", "^v[0-9]"]),
        },
        characters,
        skills,
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
