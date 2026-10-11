/**
 * behaviorChain — 角色技能行为链的形式化表达。
 *
 * 本模块是 `行为` 字段的唯一生产者（char 模块调用 `generateSkillBehavior`）。
 * 输出保持自由中文字符串（`Part (";" Part)*`，面向最终使用者阅读），注册表保证
 * 每种 `SkillEffects.TaskEffects[].Function` 都有显式策略，不存在静默未定义行为。
 *
 * 文法（`[]` 为位图细节，`()` 为持续/延迟后缀）：
 *
 * ```ebnf
 * Behavior      ::= Part (";" Part)*
 * Part          ::= Damage | CutToughness | AddBuff | RemoveBuff | Shield
 *                 | Recover | SummonCreature | SummonUnit | RemoveUnit | RemoveCreature
 *                 | RecallCreature | PassiveFn | ClientPassive
 *                 | GenericExec | PassiveEffect | BuffOnly
 * Damage        ::= "造成" Base ("12.3%" | "×#1") "的" [DamageType "属性"] "伤害"
 *                   ["(" Tag ("/" Tag)* ")"] ["+" "#n"]
 * CutToughness  ::= "削减战姿" Value [";" "Boss削韧" BossValue]
 * AddBuff       ::= ["延迟" Sec "秒后"] "附加" [Count "层"] BuffRef ["(持续" Sec "秒)"]
 * RemoveBuff    ::= "移除" | "移除" BuffRef
 * BuffRef       ::= "增益(" BuffId ")" ["[" Bit (", " Bit)* "]"]
 * Bit           ::= AttrBit | StackBit | LimitBit | "减伤" Pct | "减伤+#n" | "承伤+#n"
 *                 | DotBit | "激活技能" | "替换动作" | "启用飞行" | "召唤武器" | DisableBit
 *                 | "霸体" | "防抓取" | "无法被命中" | "无法被削韧" | "无敌"
 *                 | "眩晕" | "浮空" | "击飞" | DisperseBit | RemoveEffectBit
 * DisperseBit   ::= "驱散增益(" BuffId (", " BuffId)* ")"
 * RemoveEffectBit ::= "移除时执行技能效果(" EffectId (", " EffectId)* ")"
 * Shield        ::= "获得护盾"
 * Recover       ::= "恢复类效果(" Arg ")"
 * SummonCreature::= "召唤实体(" CreatureId ")"
 * SummonUnit    ::= "召唤单位(" UnitId ")"
 * RemoveUnit    ::= "移除单位(" UnitId ")"
 * RemoveCreature::= "移除实体(" CreatureId ")"
 * RecallCreature::= "收回实体(" CreatureId ")"
 * PassiveFn     ::= "触发被动功能[" Name "]" "(被动效果" Id ["·" BP] ")"
 * ClientPassive ::= "执行[ExecuteClientPassiveFunction]"
 * GenericExec   ::= "执行[" Fn "]"      (* 仅无专属模板的控制类兜底 *)
 * PassiveEffect ::= "被动效果(" Id ")" ["(" BPName ")"]
 * BuffOnly      ::= BuffRef                      (* 被动 BP 映射带入的增益 *)
 * ```
 *
 * 遍历契约（与旧导出一致，不可擅改）：
 * - 入口为技能 `BeginNodeId`，沿 `NextNodeId` 最多走 8 个主节点；每个节点的
 *   `BranchNodeIds/ChildNodeIds` 分支沿 `NextNodeId` 最多走 64 个节点。
 * - 节点的 `SkillNodeEffects` 逐个进入 effect；task 的 `SkillEffect/EffectIds`
 *   子 effect 递归进入（含被隐藏的 task 类型）。
 * - 分句按首次出现顺序追加，重复分句去重；`GT{}` 哨兵在拼接后统一转 `TMap`。
 *
 * Task 策略（`EMIT_TASK_FUNCTIONS` / `HIDDEN_TASK_FUNCTIONS`，未知类型默认隐藏）：
 * - emit（28 种）：见下表，处理器与表项一一对应（构造时自校验，不一致即抛错）。
 * - hidden（5 种）：`PlayFX/PlaySE/MakeSound` 为表现类（特效/音效，无阅读语义）；
 *   `HitStop` 为顿帧，归 weapon 字段表达（char 不表达）；`Executeskilleffect`
 *   为控制流（仅递归其 `EffectIds` 子 effect）。
 *
 * 已知缺口（有意保留原文输出，候选下一步，不在此改动）：
 * - `Buff.BuffEffects/BuffInitEffects`（如 1000/1002 类 ID 在 Buff/SkillEffects 表均无定义，
 *   命名空间无法验证）、`AddPassiveEffect`（被动链过深，收益低）、`ForbidBuffType`
 *   （数字 BuffType 语义不明）、`ForbidenJumpState/DisableEmoIdle`（移动约束，噪音大）。
 * - 召唤参数除 ID 外（`CreateUnit.LifeTime`、`CreateSkillCreature` 位置/朝向）、
 *   `Damage` 的 `Delay/Condition` 与角色不可达的数字 `Value`、`AddBuff.Condition`、
 *   `NotEnterCharacterTagType` 非 Hit 标签。
 */
import { readFileSync } from "node:fs"
import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import { seq, TMap, type VNode, type VNodeTree } from "../../i18n/vnode.ts"
import { GT_RE } from "../../lua/stubs.ts"
import type { SkillArtifacts } from "../skill/skillModule.ts"
import { ACTION_CN, BASE_ATTR_CN, DAMAGE_TAG_CN, DAMAGE_TYPE_CN, P_MAP, roundValue } from "../skill/skillModule.ts"

const BEHAVIOR_ATTR_CN: Record<string, string> = {
    SkillIntensity: "技能威力",
    SkillSpeed: "技能速度",
}

const PASSIVE_FUNCTION_CN: Record<string, string> = {
    AddMspOnHit: "命中回复神智",
    AddShield: "获得护盾",
    AddbuffSkill02: "附加终结技增益",
    AddbuffSkillintensity: "附加技能威力增益",
    BombCreate: "生成炸弹",
    CheckAndRemoveBuff: "检测并移除增益",
    ClearSkill01TargetNum: "清空战技目标计数",
    DownStage: "解除变身/离场",
    ExecuteSkill01: "释放战技",
    ExecuteSkill02: "释放终结技",
    Falu_Skill01_On: "法露茜战技开启",
    FunnelCreate: "生成浮游炮",
    HenshinBuff: "变身增益",
    HenshinOff: "解除变身",
    LaunchShadowSword: "释放暗影剑",
    OnZhiliuMarkRemove: "滞留标记移除时",
    PassiveAdditionalSummon: "被动追加召唤",
    QuitSkill02: "退出终结技",
    SetSkill02Level: "设置终结技等级",
    Skill1AddBuff: "战技附加增益",
    Skill1AddMsp1: "战技回复神智1",
    Skill1AddMsp2: "战技回复神智2",
    Skill1AddPassive: "战技叠加被动层数",
    Skill2AddBuff: "终结技附加增益",
    Skill2AddPassive: "终结技叠加被动层数",
    Skill2Off: "终结技关闭",
    Skill2SummonAttack: "终结技召唤攻击",
    SummonSkill1: "召唤战技实体",
    BladeUp: "武器强化/剑气蓄力",
    CheckBullet: "检查弹体",
    ClearComboCount: "清空连击数",
    ConsumeSkill02AttackBullet: "消耗终结技攻击弹体",
    EndGrab: "结束抓取",
    FlyingSkill1: "飞行战技",
    GradeAutoShoot: "按等级自动射击",
    HeavyAttackEnd: "重击结束",
    HeavyAttackStart: "重击开始",
    HitWall: "命中墙体",
    OnSkill02Hit: "终结技命中",
    OnStage: "登场",
    OnSummonHitWall: "召唤物命中墙体",
    PauseLifeTime: "暂停寿命计时",
    Promotion_Queen: "升变·皇后",
    Promotion_Rook: "升变·堡垒",
    ResumeLifeTime: "恢复寿命计时",
    SetRate: "设置倍率",
    ShootJudge: "射击判定",
    ShootLoopStart: "开始循环射击",
    Skill01ConsumeEnergy: "战技消耗能量",
    Skill01_GatherTarget: "战技聚怪",
    Skill02Off: "终结技关闭",
    Skill2AddMsp: "终结技回复神智",
    Skill1Beat: "战技命中",
    Skill1End: "战技结束",
    StartDash: "开始冲刺",
    StartGrab: "开始抓取",
    StartShoot: "开始射击",
    StopDash: "停止冲刺",
}

/** 持身状态标签 → 中文（SetCharacterTag：眩晕/浮空/击飞；未知标签保留原文）。 */
const CHARACTER_TAG_CN: Record<string, string> = {
    Stun: "眩晕",
    StunFloat: "浮空",
    HitFly: "击飞",
}

/** 产生行为分句的 task 类型（28 种；恢复系 8 种共用一个处理器）。 */
export const EMIT_TASK_FUNCTIONS: readonly string[] = [
    "Damage",
    "CutToughness",
    "AddBuff",
    "RemoveBuff",
    "AddEnergyShield",
    "Heal",
    "AddHp",
    "AddHpByRate",
    "RecoverHp",
    "AddSp",
    "RecoverSp",
    "AddES",
    "RecoverES",
    "CreateSkillCreature",
    "CreateUnit",
    "ExecutePassiveFunction",
    "ExecuteClientPassiveFunction",
    "AddBullet",
    "AdditionalHitFX",
    "CallBackSkillCreature",
    "ChangeModel",
    "ChargeBullet",
    "Disarm",
    "PlayerCameraUnlock",
    "RemoveSkillCreature",
    "RemoveUnit",
    "SetToCondemnLoc",
    "StartTargetCondemn",
]

/** 仅递归子 effect、不产生分句的 task 类型（5 种，原因见模块头文档）。 */
export const HIDDEN_TASK_FUNCTIONS: readonly string[] = ["PlayFX", "PlaySE", "MakeSound", "HitStop", "Executeskilleffect"]

/** task 类型策略：emit 产生分句；hidden 与未知类型仅递归子 effect。 */
export function taskFunctionPolicy(fn: string): "emit" | "hidden" {
    if ((EMIT_TASK_FUNCTIONS as readonly string[]).includes(fn)) return "emit"
    return "hidden"
}

const BP_ADD_BUFF_CACHE = new Map<string, Record<string, number[]>>()

/** 技能条目：skill[skillId][0]["0"]（兼容数组/对象 grade，与 char 模块共用）。 */
export function getSkillEntry(dm: ModuleContext["dm"], skillId: number): Record<string, any> | null {
    const info = dm.getTableItem("Skill", skillId) as any
    if (!Array.isArray(info) || info.length === 0) return null
    const gradeTable = info[0]
    if (!gradeTable || typeof gradeTable !== "object") return null
    const entry = gradeTable["1"] ?? gradeTable[1] ?? gradeTable["0"] ?? gradeTable[0]
    return entry && typeof entry === "object" ? entry : null
}

/**
 * 把"1 起始 map 或数组"规范化为数组（对齐老代码 _normalize_skill_desc_*）。
 * 如 {"1": a, "2": b} → [a, b]；数组原样返回（与 char 模块共用）。
 */
export function normalizeMapOrArray(v: unknown): any[] {
    if (Array.isArray(v)) return v
    if (!v || typeof v !== "object") return []
    const items: Array<[number, any]> = []
    let maxIndex = 0
    for (const [k, val] of Object.entries(v as Record<string, any>)) {
        const idx = Number(k)
        if (!Number.isInteger(idx) || idx <= 0) continue
        items.push([idx, val])
        if (idx > maxIndex) maxIndex = idx
    }
    if (items.length === 0) return []
    const result: any[] = new Array(maxIndex).fill(null)
    for (const [idx, val] of items) result[idx - 1] = val
    return result
}

/** 生成技能行为摘要；只读技能链，不参与翻译或数值解析。 */
export function generateSkillBehavior(
    dm: ModuleContext["dm"],
    skillArtifacts: SkillArtifacts,
    skillId: number,
    inheritedDescValues?: unknown[]
): VNodeTree {
    const nodeData = (id: number | string) => dm.getTableItem("SkillNode", id) as Record<string, any> | undefined
    const effectData = (id: number | string) => dm.getTableItem("SkillEffects", id) as Record<string, any> | undefined
    const buffData = (id: number | string) => dm.getTableItem("Buff", id) as Record<string, any> | undefined
    const passiveData = (id: number | string) => dm.getTableItem("PassiveEffect", id) as Record<string, any> | undefined
    const attrConfig = () => (dm.getTable("AttrConfig") as Record<string, any>) || {}
    let bpAddBuff = BP_ADD_BUFF_CACHE.get(dm.root)
    if (!bpAddBuff) {
        bpAddBuff = JSON.parse(readFileSync(join(import.meta.dir, "data", "BPAddBuff.json"), "utf8")) as Record<string, number[]>
        BP_ADD_BUFF_CACHE.set(dm.root, bpAddBuff)
    }
    const entry = getSkillEntry(dm, skillId)
    if (!entry) return ""

    const ownDescValues = normalizeMapOrArray(entry.SkillDescValues)
    const descValues = ownDescValues.length > 0 ? ownDescValues : (inheritedDescValues ?? [])
    const parts: string[] = []
    const seenEffects = new Set<string>()
    const seenNodes = new Set<string>()
    const seenSkills = new Set<string>()

    const effectRate = (effectId: number, rate: unknown): number | string | null => {
        if (typeof rate === "number") return rate
        const text = String(rate ?? "")
        if (!text.startsWith("#")) {
            return Number.isFinite(Number(text)) ? Number(text) : text || null
        }
        const source =
            descValues.find(value => typeof value === "string" && value.includes(`SkillEffects[${effectId}]`) && value.includes("*100")) ??
            descValues.find(value => typeof value === "string" && value.includes("SkillEffects[") && value.includes("*100"))
        if (typeof source !== "string") return null
        const ref = source.match(new RegExp(`\\$#SkillEffects\\[${effectId}\\][^$]*\\$`))?.[0] ?? source.match(/\$[^$]+\$/)?.[0]
        if (!ref) return null
        const computed = skillArtifacts.calcSkillDesc(ref, 1)
        const number = computed.match(/-?\d+(?:\.\d+)?/)?.[0]
        return number === undefined ? null : Number(number) / (ref.includes("*100") ? 100 : 1)
    }

    const add = (part: string) => {
        if (part && !parts.includes(part)) parts.push(part)
    }

    const attrConfigKey = (attrName: string, attr: Record<string, any>): string => {
        if (attrName === "DamageRate" || attrName === "DamagedRate") {
            const tag = attr.DamageTag ?? attr.Tag
            const zone = attr.RateZone
            if (tag || zone) {
                const tagName = tag ?? "NoTag"
                const zoneName = zone ?? "Normal"
                const clientKey = `${attrName}_${tagName}_${zoneName}`
                if (attrConfig()[clientKey]) return clientKey
                const zoneKey = `${attrName}_${zoneName}`
                if (attrConfig()[zoneKey]) return zoneKey
            }
        }
        if (attrConfig()[attrName]) return attrName
        const normalKey = `${attrName}_Normal`
        return attrConfig()[normalKey] ? normalKey : attrName
    }

    const attrSummaryName = (attrName: string, attr: Record<string, any>): string => {
        const direct = BEHAVIOR_ATTR_CN[attrName]
        if (direct) return direct
        const config = attrConfig()[attrConfigKey(attrName, attr)]
        if (config?.Name) return `\x01GT{${config.Name}}\x01`
        return P_MAP[attrName] ?? attrName
    }

    const formatBuffValue = (attrName: string, attr: Record<string, any>, value: unknown): string => {
        const number = Number(value)
        if (!Number.isFinite(number)) return String(value ?? "")
        const config = attrConfig()[attrConfigKey(attrName, attr)]
        if (config?.IsPercent) return `${roundValue(number * 100)}%`
        return String(roundValue(number))
    }

    const buffSummary = (buffId: unknown): string => {
        const id = String(buffId ?? "")
        const buff = buffData(id)
        if (!buff || typeof buff !== "object") return `增益(${id})`
        const bits: string[] = []
        for (const attr of Array.isArray(buff.AddAttrs) ? buff.AddAttrs : []) {
            if (!attr || typeof attr !== "object") continue
            const attrName = String(attr.AttrName ?? "")
            const name = attrName === "ATK" ? "攻击" : attrSummaryName(attrName, attr)
            const rawValue = attr.Rate ?? attr.Value
            const value = Number(rawValue)
            if (!name || rawValue === undefined || rawValue === null) {
                if (attr.SupLimitValue === undefined) continue
            }
            if (attr.Stackable && (Number.isFinite(value) || (typeof rawValue === "string" && rawValue.startsWith("#")))) {
                const stackValue = typeof rawValue === "string" && rawValue.startsWith("#") ? rawValue : String(roundValue(value))
                bits.push(`每层+${stackValue}${name}(最多${buff.MaxLayer ?? ""}层)`)
            } else if (attr.SupLimitValue !== undefined) {
                bits.push(`${name}上限${roundValue(Number(attr.SupLimitValue))}`)
            } else {
                const displayValue =
                    typeof rawValue === "string" && rawValue.startsWith("#") ? rawValue : formatBuffValue(attrName, attr, rawValue)
                bits.push(`${name}+${displayValue}`)
            }
        }
        // 承伤修正（BuffDamagedRate：减伤/易伤；公式引用按图标定方向，数值按符号定方向）。
        const damagedRate = (buff as Record<string, any>).BuffDamagedRate?.Value
        if (typeof damagedRate === "number" && damagedRate !== 0) {
            const pct = roundValue(Math.abs(damagedRate) * 100)
            bits.push(damagedRate < 0 ? `减伤${pct}%` : `承伤+${pct}%`)
        } else if (typeof damagedRate === "string" && damagedRate) {
            bits.push(buff.BuffTypeImgPath === "Damaged_Up" ? `承伤+${damagedRate}` : `减伤+${damagedRate}`)
        }
        for (const dot of Array.isArray(buff.DotDatas) ? buff.DotDatas : []) {
            if ((dot?.Type === "SpChange" || dot?.Type === "SecondSpChange") && typeof dot.Value === "number") {
                const verb = dot.Value < 0 ? "消耗" : "回复"
                bits.push(`每${dot.Interval ?? 1}秒${verb}${Math.abs(dot.Value)}神智`)
            } else if (dot?.Type === "SkillEffect") {
                bits.push(`每${dot.Interval ?? 1}秒执行技能效果(${dot.EffectId})`)
            } else if (dot?.Type === "Dot") {
                const damageType = DAMAGE_TYPE_CN[String(dot.DamageType)] ?? dot.DamageType ?? ""
                const rate = dot.Rate === undefined ? "" : `×${dot.Rate}`
                bits.push(`每${dot.Interval ?? 1}秒造成${damageType}持续伤害${rate}`)
            }
        }
        if (buff.ActivateSkills) bits.push("激活技能")
        if (buff.ReplaceActions) bits.push("替换动作")
        if (buff.EnableFlight) bits.push("启用飞行")
        if (buff.UseSummonWeapon) bits.push("召唤武器")
        if (Array.isArray(buff.DisableSkills) && buff.DisableSkills.length > 0) {
            bits.push(`禁用[${buff.DisableSkills.map((skill: unknown) => ACTION_CN[String(skill)] ?? String(skill)).join(", ")}]`)
        }
        // 隐藏防御词条显式化：Buff 表的抗打断/免伤字段在界面无文本，仅以数值形式生效。
        // NotEnter 含 Hit=不进受击=霸体；其余各防御互不归并，文案区分输出。
        if (Array.isArray(buff.NotEnterCharacterTagType) && buff.NotEnterCharacterTagType.includes("Hit")) bits.push("霸体")
        if (buff.ForbidCatch) bits.push("防抓取")
        if (buff.CannotBeHitted) bits.push("无法被命中")
        if (buff.CannotBeCutTN) bits.push("无法被削韧")
        if (Array.isArray(buff.SpecialEffect) && buff.SpecialEffect.includes("Invincible")) bits.push("无敌")
        // 持身状态（SetCharacterTag：命中后进入眩晕/浮空/击飞等硬控）。
        const setTags =
            buff.SetCharacterTag === undefined || buff.SetCharacterTag === null
                ? []
                : Array.isArray(buff.SetCharacterTag)
                  ? buff.SetCharacterTag
                  : [buff.SetCharacterTag]
        for (const tag of setTags) bits.push(CHARACTER_TAG_CN[String(tag)] ?? `状态[${String(tag)}]`)
        // 施加时驱散其他增益（DisperseBuffType：目标均为 BuffId，已验证命名空间）。
        if (Array.isArray(buff.DisperseBuffType) && buff.DisperseBuffType.length > 0) {
            bits.push(`驱散增益(${buff.DisperseBuffType.join(", ")})`)
        }
        // 移除时联动技能效果（ExecSkillEffectWhenRemoved：SkillEffects ID，直接引用）。
        if (Array.isArray(buff.ExecSkillEffectWhenRemoved) && buff.ExecSkillEffectWhenRemoved.length > 0) {
            bits.push(`移除时执行技能效果(${buff.ExecSkillEffectWhenRemoved.join(", ")})`)
        }
        return bits.length > 0 ? `增益(${id})[${bits.join(", ")}]` : `增益(${id})`
    }

    type TaskHandler = (task: Record<string, any>, effectId: number) => void

    const handleDamage: TaskHandler = (task, effectId) => {
        const rate = effectRate(effectId, task.Rate)
        const baseAttr = String(task.BaseAttr ?? "基础伤害")
        const base = BASE_ATTR_CN[baseAttr] ?? attrSummaryName(baseAttr, { AttrName: baseAttr })
        let text = `造成${base}`
        if (typeof rate === "number" && rate > 0 && rate < 1) text += `${roundValue(rate * 100)}%`
        else if (typeof rate === "number") text += `${(rate * 100).toFixed(1)}%`
        else if (typeof task.Rate === "string") text += `×${task.Rate}`
        if (rate !== null) {
            text += "的"
            text += task.DamageType ? `${DAMAGE_TYPE_CN[String(task.DamageType)] ?? task.DamageType}属性` : ""
            text += "伤害"
            const tags = (Array.isArray(task.DamageTag) ? task.DamageTag : [])
                .map((tag: unknown) => DAMAGE_TAG_CN[String(tag)] ?? String(tag))
                .filter((tag: string, index: number, list: string[]) => tag && list.indexOf(tag) === index)
            if (tags.length > 0) text += `(${tags.join("/")})`
            if (typeof task.Value === "string" && task.Value.startsWith("#")) text += `+${task.Value}`
            add(text)
        }
    }

    const handleCutToughness: TaskHandler = task => {
        if (task.Value !== undefined) add(`削减战姿${task.Value}`)
        // Boss 削韧与通用削韧并列（对齐字段的 削韧/Boss削韧键）；相等时不重复。
        if (task.BossValue !== undefined && task.BossValue !== task.Value) add(`Boss削韧${task.BossValue}`)
    }

    const handleAddBuff: TaskHandler = task => {
        // BuffCount>1：在一次性附加多层时显式层数（如 110213 附加 10 层 110201）。
        const count = Number(task.BuffCount)
        const countPrefix = Number.isFinite(count) && count > 1 ? `${count}层` : ""
        let summary = `附加${countPrefix}${buffSummary(task.BuffId)}`
        if (typeof task.LastTime === "number" && task.LastTime !== -1) summary += `(持续${roundValue(task.LastTime)}秒)`
        if (task.Delay) summary = `延迟${roundValue(Number(task.Delay))}秒后${summary}`
        add(summary)
    }

    const handleRemoveBuff: TaskHandler = task => {
        add(task.BuffId === undefined || task.BuffId === null ? "移除" : `移除${buffSummary(task.BuffId)}`)
    }

    const handleRecover: TaskHandler = task => {
        add(`恢复类效果(${task.BaseAttr ?? task.BaseChar ?? String(task.Function ?? "")})`)
    }

    const handleCreateSkillCreature: TaskHandler = task => {
        if (task.CreatureId !== undefined) add(`召唤实体(${task.CreatureId})`)
    }

    const handleExecutePassiveFunction: TaskHandler = task => {
        const functionName = String(task.FunctionName ?? "")
        let summary = `触发被动功能[${PASSIVE_FUNCTION_CN[functionName] ?? functionName}]`
        const passiveId = task.PassiveEffectId
        const passive = passiveId !== undefined ? passiveData(String(passiveId)) : undefined
        if (passive && typeof passive === "object") {
            const bpPath = String(passive.BPPath ?? "")
            const bpName = bpPath.split("/").pop()?.split(".")[0] ?? ""
            summary += `(被动效果${passiveId}${bpName ? `·${bpName}` : ""})`
        }
        add(summary)
    }

    const handleCreateUnit: TaskHandler = task => {
        add(task.UnitId === undefined ? "执行[CreateUnit]" : `召唤单位(${task.UnitId})`)
    }

    const handleRemoveUnit: TaskHandler = task => {
        add(task.UnitId === undefined ? "执行[RemoveUnit]" : `移除单位(${task.UnitId})`)
    }

    const handleRemoveSkillCreature: TaskHandler = task => {
        add(task.CreatureId === undefined ? "执行[RemoveSkillCreature]" : `移除实体(${task.CreatureId})`)
    }

    const handleCallBackSkillCreature: TaskHandler = task => {
        add(task.CreatureId === undefined ? "执行[CallBackSkillCreature]" : `收回实体(${task.CreatureId})`)
    }

    const handleGenericExec: TaskHandler = task => {
        add(`执行[${String(task.Function ?? "")}]`)
    }

    // 处理器注册表：与 EMIT_TASK_FUNCTIONS 一一对应（构造时自校验，漂移即抛错）。
    const handlers: Record<string, TaskHandler> = {
        Damage: handleDamage,
        CutToughness: handleCutToughness,
        AddBuff: handleAddBuff,
        RemoveBuff: handleRemoveBuff,
        AddEnergyShield: () => add("获得护盾"),
        Heal: handleRecover,
        AddHp: handleRecover,
        AddHpByRate: handleRecover,
        RecoverHp: handleRecover,
        AddSp: handleRecover,
        RecoverSp: handleRecover,
        AddES: handleRecover,
        RecoverES: handleRecover,
        CreateSkillCreature: handleCreateSkillCreature,
        CreateUnit: handleCreateUnit,
        RemoveUnit: handleRemoveUnit,
        RemoveSkillCreature: handleRemoveSkillCreature,
        CallBackSkillCreature: handleCallBackSkillCreature,
        ExecutePassiveFunction: handleExecutePassiveFunction,
        ExecuteClientPassiveFunction: () => add("执行[ExecuteClientPassiveFunction]"),
        AddBullet: handleGenericExec,
        AdditionalHitFX: handleGenericExec,
        ChangeModel: handleGenericExec,
        ChargeBullet: handleGenericExec,
        Disarm: handleGenericExec,
        PlayerCameraUnlock: handleGenericExec,
        SetToCondemnLoc: handleGenericExec,
        StartTargetCondemn: handleGenericExec,
    }
    for (const name of EMIT_TASK_FUNCTIONS) {
        if (!handlers[name]) throw new Error(`行为链处理器缺失: ${name}`)
    }
    for (const name of Object.keys(handlers)) {
        if (!(EMIT_TASK_FUNCTIONS as readonly string[]).includes(name)) throw new Error(`行为链处理器多余: ${name}`)
    }

    const walkEffect = (effectId: unknown): void => {
        const key = String(effectId)
        if (seenEffects.has(key)) return
        seenEffects.add(key)
        const effect = effectData(key)
        if (!effect || typeof effect !== "object") return
        for (const task of Array.isArray(effect.TaskEffects) ? effect.TaskEffects : []) {
            if (!task || typeof task !== "object") continue
            const fn = String(task.Function ?? "")
            handlers[fn]?.(task, Number(effectId))
            for (const childKey of ["SkillEffect", "EffectIds"]) {
                const children = Array.isArray(task[childKey]) ? task[childKey] : task[childKey] === undefined ? [] : [task[childKey]]
                for (const child of children) walkEffect(child)
            }
        }
    }

    const walkSkill = (innerSkillId: unknown): void => {
        const key = String(innerSkillId)
        if (seenSkills.has(key)) return
        seenSkills.add(key)
        const inner = getSkillEntry(dm, Number(innerSkillId))
        if (!inner) return
        for (const passiveId of Array.isArray(inner.PassiveEffects) ? inner.PassiveEffects : []) {
            const passive = passiveData(String(passiveId))
            if (!passive || typeof passive !== "object") continue
            const path = String(passive.BPPath ?? "")
            const bpName = path.split("/").pop()?.split(".")[0] ?? ""
            const label = bpName ? `被动效果(${passiveId})(${bpName})` : `被动效果(${passiveId})`
            add(label)
            // Python's current export does not include the static BP_Falu_Passive map entries.
            if (bpName !== "BP_Falu_Passive") {
                for (const buffId of bpAddBuff[bpName] ?? []) add(buffSummary(buffId))
            }
        }
        let nodeId = inner.BeginNodeId
        while (nodeId && !seenNodes.has(String(nodeId)) && seenNodes.size < 8) {
            seenNodes.add(String(nodeId))
            const node = nodeData(String(nodeId))
            if (!node || typeof node !== "object") break
            const effects = Array.isArray(node.SkillNodeEffects) ? node.SkillNodeEffects : [node.SkillNodeEffects]
            for (const effectId of effects) walkEffect(effectId)
            const branches = node.BranchNodeIds ?? node.ChildNodeIds
            const branchIds = Array.isArray(branches) ? branches : branches && typeof branches === "object" ? Object.values(branches) : []
            for (const branchId of branchIds) {
                let branchNodeId = branchId
                while (branchNodeId && !seenNodes.has(String(branchNodeId)) && seenNodes.size < 64) {
                    seenNodes.add(String(branchNodeId))
                    const branchNode = nodeData(String(branchNodeId))
                    if (!branchNode || typeof branchNode !== "object") break
                    const branchEffects = Array.isArray(branchNode.SkillNodeEffects)
                        ? branchNode.SkillNodeEffects
                        : [branchNode.SkillNodeEffects]
                    for (const effectId of branchEffects) walkEffect(effectId)
                    branchNodeId = branchNode.NextNodeId
                }
            }
            nodeId = node.NextNodeId
        }
    }

    walkSkill(skillId)
    const text = parts.join(";")
    const matches = [...text.matchAll(GT_RE)]
    if (matches.length === 0) return text
    const nodes: VNode[] = []
    let last = 0
    for (const match of matches) {
        const index = match.index!
        if (index > last) nodes.push(text.slice(last, index))
        nodes.push(TMap(match[1], P_MAP))
        last = index + match[0].length
    }
    if (last < text.length) nodes.push(text.slice(last))
    return seq(nodes)
}
