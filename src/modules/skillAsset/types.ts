/**
 * SkillAssetDoc — 语言无关的技能行为证据文档（final/skill-behavior.json）。
 *
 * 只记录"可验证的原始结构 + 来源"：Lua 技能链证据、Montage/AnimSequence 时间轴、
 * 可达 Blueprint 字节码、AnimBlueprint 图；不做游戏语义归一（由 dna-builder 负责）。
 * 无法解析的资产进入 coverage，不静默丢弃。
 */
import type { AnimBPInfo, MontageTimeline, SequenceMeta } from "../../lua/AssetReader.ts"
import type { UAssetBytecodeDocument, UAssetServerStats } from "../../lua/UAssetServer.ts"

export const SKILL_BEHAVIOR_SCHEMA_VERSION = 1
export const SKILL_BEHAVIOR_PARSER_VERSION = 1

export type SkillOwnerKind = "char" | "weapon" | "pet" | "mod"

export interface SkillOwner {
    kind: SkillOwnerKind
    id: number
}

export interface CharacterEntry {
    id: number
    /** Char.CharName（TextMap key，不渲染） */
    nameKey: string
    modelId: number | null
    /** 该角色的主技能 id（顺序同 BattleChar.SkillList，已排除超限被动） */
    skills: number[]
    /** 子技能 id（Skill.SubSkills，Char.json 子技能口径） */
    subSkills: number[]
    /** AnimBlueprint 包路径（存在于 animBPs 表中） */
    animBP: string | null
}

export interface SkillNodeEvidence {
    id: number
    animPath: string | null
    animResource: string | null
    animName: string | null
    animSubPath: string | null
    playRate: number | null
    effects: number[]
    nextNodeId: number | null
    branchNodeIds: number[]
}

export interface SkillEffectEvidence {
    id: number
    notifyNames: string[]
    raw: Record<string, unknown>
}

export interface SkillLuaEvidence {
    skillType: string | null
    nameKey: string | null
    beginNodeId: number | null
    /** 行为文本（保留 GT{} 哨兵与 Attr key，未做翻译替换） */
    behavior: string
    /** explainSkillFields 的字段 vnode 树 */
    fields: unknown[]
    nodes: SkillNodeEvidence[]
    effects: SkillEffectEvidence[]
    buffIds: number[]
    passiveEffectIds: number[]
    passiveEffectBPs: Array<{ id: number; path: string | null }>
}

export interface SkillAnimationRef {
    nodeId: number
    /** 解析到的包路径；未解析为 null */
    asset: string | null
    animPath: string | null
    animResource: string | null
    animName: string | null
    animSubPath: string | null
    playRate: number | null
}

export interface SkillSources {
    /** 主 Montage 包路径（第一个解析到的动画资产） */
    montage: string | null
    /** 该技能可达的全部 Montage 包路径（去重） */
    montages: string[]
    /** 可达 Blueprint 包路径（PassiveEffect/Buff 的 BPPath），按路径去重 */
    bpPackages: string[]
    /** 角色 AnimBlueprint 包路径 */
    animBPs: string[]
}

export interface SkillEntry {
    id: number
    characterId: number | null
    /** 主技能 id（子技能指向其父技能；主技能为 null） */
    parentSkillId: number | null
    owner: SkillOwner
    /** E/Q/P/A/T/U；非角色技能为原始 SkillType */
    slot: string
    lua: SkillLuaEvidence
    sources: SkillSources
    /** 主 Montage 时间轴 */
    montage: MontageTimeline | null
    /** 主 Montage 之外的其他 Montage 时间轴 */
    additionalMontages: MontageTimeline[]
    sequences: SequenceMeta[]
    animationRefs: SkillAnimationRef[]
    /** 该技能引用的 AnimBlueprint 包路径（等同 sources.animBPs[0]） */
    animBP: string | null
    /** 解析失败的 Blueprint（失败路径与错误），成功时为空数组 */
    blueprintErrors: Array<{ path: string; error: string }>
}

export interface BuffEntry {
    id: number
    lua: Record<string, unknown>
    bpPackages: string[]
    /** BPAddBuff.json 中映射到该 Buff 的 BP 名（静态表，无资产路径，不解析） */
    bpNames: string[]
}

/**
 * 可达被动效果：持有者级（BattleChar/BattleWeapon/BattlePet/Mod.PassiveEffects）
 * 或技能链内引用（TaskEffects[].PassiveEffectId / `$#PassiveEffect[...]$`）。
 */
export interface PassiveEntry {
    id: number
    lua: Record<string, unknown>
    bpPackages: string[]
    owners: SkillOwner[]
    /** 引用该被动效果的技能 id */
    referencedBySkills: number[]
}

export interface SkillAssetCoverage {
    skillsTotal: number
    /** Skill 表条目缺失的技能 id */
    skillsMissing: number[]
    skillsWithMontage: number
    skillsWithBlueprint: number
    skillsWithAnimBP: number
    skillsWithLuaOnly: number
    montagesResolved: number
    /**
     * 未解析到文件的动画引用。武器/宠物/MOD 技能的 Montage 按角色名前缀存放在
     * `Char/Player/<角色>/Animation/Montage/` 下，脱离持有角色无法唯一确定，因此保留为缺口。
     */
    montagesMissing: Array<{
        skillId: number
        nodeId: number
        animPath: string | null
        animSubPath: string | null
        animResource: string | null
        animName: string | null
    }>
    /** 文件存在但不是 AnimMontage / 解析失败 */
    montagesFailed: Array<{ asset: string; reason: string }>
    /** notify 总数与无 payload 的 notify（原生 notify 类在资产内没有 export） */
    notifiesTotal: number
    notifiesWithPayload: number
    notifiesWithoutPayload: Array<{ asset: string; name: string; time: number; state: boolean }>
    notifiesAmbiguousPayload: Array<{ asset: string; name: string; matches: number[] }>
    sequencesResolved: number
    sequencesMissing: string[]
    /** 文件存在但不是 AnimSequence / 解析失败 */
    sequencesFailed: Array<{ asset: string; reason: string }>
    blueprintsTotal: number
    blueprintsParsed: number
    blueprintsFailed: Array<{ path: string; error: string }>
    blueprintsMissing: string[]
    animBPsTotal: number
    animBPsResolved: number
    /**
     * 含非空 BakedStateMachines 的 AnimBP 数量。熟化资产经 UAssetAPI 反序列化时
     * BakedStateMachines 不暴露，因此当前恒为 0；状态机不可得是数据面事实，不是解析失败。
     */
    animBPsWithStateMachines: number
    animBPsMissing: Array<{ characterId: number | null; path: string | null; reason: string }>
    passiveEffectsTotal: number
    ownerPassivesTotal: number
    ownerPassivesWithBlueprint: number
    /** 被动效果表中的可达 id 总数与缺失（技能链引用但 PassiveEffect 表无条目） */
    passivesTotal: number
    passivesWithBlueprint: number
    passivesMissing: number[]
    buffsTotal: number
    buffsWithBlueprint: number
    /** 技能链引用但 Buff 表无条目的 id */
    buffsMissing: number[]
    /** 各持有者类型的技能口径（角色 169 主技能 + 子技能；武器/宠物/MOD 独立统计） */
    owners: Record<string, { skills: number; withMontage: number; withBlueprint: number }>
    /**
     * Blueprint 字节码中调用的、未在同一资产内定义的函数（引擎/蓝图外部调用），
     * 供 U3 做 native 语义映射；本模块不做归一。
     */
    nativeCallsUnknown: Array<{ name: string; count: number }>
    /** 进程级 UAsset 缓存命中/加载计数（含本次导出其他模块的请求） */
    assets: UAssetServerStats
}

export interface SkillAssetDoc {
    schemaVersion: number
    exporter: {
        gitCommit: string | null
        parserVersion: number
        gameVersion: string | null
    }
    characters: CharacterEntry[]
    skills: Record<string, SkillEntry>
    buffs: Record<string, BuffEntry>
    passives: Record<string, PassiveEntry>
    /** 可达 Blueprint 字节码，按包路径去重（skill.sources.bpPackages 引用） */
    blueprints: Record<string, UAssetBytecodeDocument>
    /** 角色 AnimBlueprint，按包路径去重（characters[].animBP 引用） */
    animBPs: Record<string, AnimBPInfo>
    coverage: SkillAssetCoverage
}
