/**
 * SkillAssetDoc — 语言无关的技能行为证据文档（final/skill-behavior.json）。
 *
 * 只记录"可验证的原始结构 + 来源"：Lua 技能链证据、Montage/AnimSequence 时间轴、
 * 可达 Blueprint 字节码、AnimBlueprint 图；不做游戏语义归一（由 dna-builder 负责）。
 * 无法解析的资产进入 coverage，不静默丢弃。
 */
import type { AnimBPInfo, MontageTimeline, SequenceMeta } from "../../lua/AssetReader.ts"
import type { UAssetBytecodeDocument, UAssetServerStats } from "../../lua/UAssetServer.ts"
import type { BlueprintAction, BpActionSource, UnresolvedBpRef } from "../skillBehavior/bpEval.ts"

export const SKILL_BEHAVIOR_SCHEMA_VERSION = 2
export const SKILL_BEHAVIOR_PARSER_VERSION = 4

/** v2 新增能力的显式标记；读取方按此判断字段是否存在。 */
export const SKILL_BEHAVIOR_FEATURES = [
    "fieldRefs",
    "creatureGraph",
    "unitGraph",
    "buffGraph",
    "grow",
    "blueprintActions",
    "skillNodes",
    "skillVariants",
] as const

/**
 * 目前展平 Blueprint 动作的角色（B 组）。其他角色即使有 BP 也不产出 `blueprintActions`，
 * 避免把未验证的 BP 语义扩散到全部角色；读取方以字段是否存在区分「未展平」与「展平后为空」。
 */
export const BLUEPRINT_ACTION_CHARACTER_IDS = [1102, 1502, 1503, 3102, 5102] as const

export type { BlueprintAction, BpActionSource, UnresolvedBpRef }

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

/**
 * SkillGrow 的等级序列：按 `Index` 分组、按 `Level` 升序。
 * `SkillGrow` 同时存在「按等级排列的数组」与「以 Level 为键的对象」两种外层形态，
 * 读取时统一成同一结构；缺失为 null，不补造数值。
 */
export interface GrowRow {
    level: number
    value: number | string
}

export type GrowRows = Record<string, GrowRow[]>

/** 描述串里的一条 `#命名空间[id]路径` 引用（不解析数值，只保留结构与原文）。 */
export interface SkillFieldRef {
    /** 命名空间原文（SkillEffects / Buff / PassiveEffect / SkillCreature / SkillNode / Skill / ...） */
    kind: string
    id: number
    /** SkillEffects 引用的 TaskId（效果行缺失时为 null） */
    taskId: number | null
    /** `.TaskEffects[N].Rate` 的 0 起始索引；仅 Rate 引用填写 */
    taskIndex: number | null
    /** `.TaskEffects[N].Rate` 的 1 起始原文索引；仅 Rate 引用填写 */
    rawTaskIndex: number | null
    /** `.DotDatas[N]` 的 0 起始索引；非 DotDatas 引用为 null */
    dotIndex: number | null
    /** `]` 之后的字段路径（去掉前导点）；无字段路径时为 null */
    path: string | null
    /** 完整匹配原文，含命名空间与字段路径 */
    raw: string
}

export interface SkillFieldRefGroup {
    /** SkillDescValues 中该字符串的 0 起始索引 */
    descIndex: number
    /** 同索引的 SkillDescKeys；缺失或错位时为 null */
    descKey: string | null
    refs: SkillFieldRef[]
}

/** Blueprint 展平种子的来源（BP 包 / 函数 / 节点），用于回溯该 id 由哪条 BP 调用引入。 */
export interface BpSeedSource {
    bpPackage: string
    function: string
    nodeId: string
}

/** 图上一条边的来源。`from` 为 `${kind}:${id}`，`skillId` 为遍历根技能。 */
export interface GraphSource {
    from: string
    relation: string
    skillId: number
    descIndex: number | null
    /** 仅当该节点由 `blueprintActions` 的 id 直接作为种子加入时填写 */
    bp?: BpSeedSource
}

/** 无法解析的引用不静默丢弃：缺行、越界、未知命名空间与遍历上限都在这里显式记录。 */
export interface UnresolvedRef {
    kind: string
    id: number | null
    /** 引用方 `${kind}:${id}` 或 `skill:${id}` */
    from: string
    reason: string
    detail?: string
}

/** 同名但无显式字段的约定关联（如 Unit 与 SkillCreature 同 id），不当作表边。 */
export interface ConventionRef {
    kind: string
    id: number
    relatedKind: string
    relatedId: number
    note: string
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
    /** 描述串字段 → 效果/增益/实体引用（v2） */
    fieldRefs: SkillFieldRefGroup[]
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

/**
 * SkillNode 全量表行：只导出原始数值与动画引用，不做语义归一。
 * `SkillNodeEffects` 保留原始 id 列表；缺失字段为 null。
 */
export interface SkillNodeEntry {
    nodeId: number
    costSp: number | null
    animPath: string | null
    animResource: string | null
    animPlayRate: number | null
    effects: number[]
}

/** Skill.json 的原始关键字段；只保留数据里直接存在的值，不解释点按/长按语义。 */
export interface SkillRowRef {
    beginNodeId: number | null
    subSkills: number[]
    longPressSkill: number | null
    skillBtnIcon: string | null
}

/**
 * 技能变体入口：默认变体来自技能自身 `BeginNodeId`，其余来自 `SubSkills` 中
 * 子技能自身的 `BeginNodeId`。互斥分支各自成项，不合并 effects。
 */
export interface SkillVariant {
    nodeId: number
    costSp: number | null
    /** 该节点解析到的 Montage 包路径；未解析为 null */
    montage: string | null
    effects: number[]
    isDefault: boolean
    /** 仅当数据里有明确字段可对应时填写（当前只有 `LongPressSkill` → `"longPress"`） */
    trigger?: string
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
    /** Skill.json 原始关键字段（BeginNodeId / SubSkills / LongPressSkill / SkillBtnIcon） */
    skillRow: SkillRowRef
    /** 由 BeginNodeId 与 SubSkills 的 BeginNodeId 得到的节点变体；互斥分支不合并 */
    variants: SkillVariant[]
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
    /**
     * BP 字节码中可静态求值的调用（仅 BLUEPRINT_ACTION_CHARACTER_IDS 角色产出）。
     * 同一 BP 包被多个技能引用时，各技能各自保留一份；按 `source.nodeId` 去重。
     * 字段缺失表示该技能未做展平；空数组表示已展平且没有可证明的动作。
     */
    blueprintActions?: BlueprintAction[]
}

export interface BuffDotRef {
    type: string | null
    damageType: string | null
    damageTag: string[]
    interval: number | null
    rate: number | string | null
    value: number | string | null
    effectId: number | null
}

export interface BuffEntry {
    id: number
    lua: Record<string, unknown>
    bpPackages: string[]
    /** 图遍历到达该增益的来源边（含 blueprintActions 种子） */
    sources: GraphSource[]
    /** BPAddBuff.json 中映射到该 Buff 的 BP 名（静态表，无资产路径，不解析） */
    bpNames: string[]
    grow: GrowRows | null
    dotDatas: BuffDotRef[]
    haloBuffIds: number[]
    execEffectIds: number[]
    activateSkillIds: number[]
    passiveEffectIds: number[]
    initialEffectIds: number[]
}

/** 技能效果（SkillEffects 行）：伤害/增益/召唤任务的原始结构 + 等级序列。 */
export interface EffectEntry {
    id: number
    /** SkillEffects.TaskId（缺失时为 null） */
    taskId: number | null
    lua: Record<string, unknown>
    grow: GrowRows | null
    sources: GraphSource[]
}

/** 技能实体（SkillCreature 行）：命中/循环/销毁效果与生命周期参数。 */
export interface CreatureLoop {
    /** LoopExecuteSkillEffects.Interval；缺失为 null */
    interval: number | null
    /** LoopExecuteSkillEffects.Loop 原文；缺失为 null */
    loop: number | boolean | null
    effectIds: number[]
}

export interface CreatureEntry {
    id: number
    hitEnemy: number[]
    hitScene: number[]
    loop: CreatureLoop | null
    creatureEffectIds: number[]
    destroyEffectIds: number[]
    realDestroyEffectIds: number[]
    /** SkillCreature.EffectCreatureID（EffectCreature 表的 id） */
    effectCreatureEffectIds: number[]
    attachOwner: number[]
    timeLife: number | null
    speed: number | null
    referencedBySkills: number[]
    sources: GraphSource[]
    lua: Record<string, unknown>
}

/** 单位（BattleMonster / Monster / MechanismSummon 三表按同 id 合并）。 */
export interface UnitEntry {
    id: number
    battleMonster: Record<string, unknown> | null
    monster: Record<string, unknown> | null
    mechanismSummon: Record<string, unknown> | null
    /** BattleMonster.SkillList 中的技能 id */
    skillIds: number[]
    /** 上述技能 Skill.PassiveEffects 的并集 */
    passiveEffectIds: number[]
    /** Monster/MechanismSummon.BluePrintParams 中的 SkillEffectId* 引用 */
    bluePrintEffectIds: number[]
    gamePlayTags: string[]
    unitBPPath: string | null
    referencedBySkills: number[]
    /** 与 SkillCreature 同 id 时的 creature id；只是约定标注，不是表边 */
    sameIdCreatureId: number | null
    sources: GraphSource[]
    lua: {
        battleMonster: Record<string, unknown> | null
        monster: Record<string, unknown> | null
        mechanismSummon: Record<string, unknown> | null
    }
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
    grow: GrowRows | null
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
    /** SkillNode 全量表行数（等于 `skillNodes` 的键数） */
    skillNodesTotal: number
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
    /** v2：可达效果/实体/单位计数与缺失行 */
    effectsTotal: number
    effectsMissing: number[]
    creaturesTotal: number
    creaturesMissing: number[]
    unitsTotal: number
    unitsMissing: number[]
    /** v2：描述串引用总数与未解析数（含越界/未知命名空间） */
    fieldRefsTotal: number
    fieldRefsUnresolved: number
    /** v2：图遍历与字段引用中所有无法解析的引用 */
    unresolvedRefs: UnresolvedRef[]
    /** v2：命中深度上限的遍历次数 */
    depthLimitHits: number
    /** v2：同名但无显式字段的约定关联 */
    conventionRefs: ConventionRef[]
    /** v2：Blueprint 展平中无法静态求值的动作参数（按 BP/函数/节点定位，不猜值） */
    blueprintUnresolved: UnresolvedBpRef[]
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
    /** v2 能力标记（fieldRefs/creatureGraph/unitGraph/buffGraph/grow） */
    features: string[]
    exporter: {
        gitCommit: string | null
        parserVersion: number
        gameVersion: string | null
    }
    characters: CharacterEntry[]
    skills: Record<string, SkillEntry>
    /** SkillNode 全量表（键为 NodeId）；覆盖 Lua SkillNode 表的全部行 */
    skillNodes: Record<string, SkillNodeEntry>
    effects: Record<string, EffectEntry>
    creatures: Record<string, CreatureEntry>
    units: Record<string, UnitEntry>
    buffs: Record<string, BuffEntry>
    passives: Record<string, PassiveEntry>
    /** 可达 Blueprint 字节码，按包路径去重（skill.sources.bpPackages 引用） */
    blueprints: Record<string, UAssetBytecodeDocument>
    /** 角色 AnimBlueprint，按包路径去重（characters[].animBP 引用） */
    animBPs: Record<string, AnimBPInfo>
    coverage: SkillAssetCoverage
}
