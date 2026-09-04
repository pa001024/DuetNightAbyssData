/** MonsterStrongAffixes module - 强词条说明及语义参数。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { compile, LTemplate, seq, type VNode, type VNodeTree } from "../../i18n/vnode.ts"

type Row = Record<string, any>

const ATTR_NAMES: Record<string, string> = {
    DEF: "防御",
    ATK: "攻击",
    SkillSpeed: "技能速度",
    MoveSpeedAddRate: "移动速度",
    AtkSpeed: "攻击速度",
}

function list(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    return value === null || value === undefined || value === "" ? [] : [value]
}

function number(value: unknown): number | undefined {
    const n = typeof value === "number" ? value : Number(value)
    return Number.isFinite(n) ? n : undefined
}

function entry(ctx: ModuleContext, table: string, id: unknown): Row | undefined {
    const value = ctx.dm.getTableItem(table, typeof id === "number" ? id : String(id))
    return value && typeof value === "object" && !Array.isArray(value) ? (value as Row) : undefined
}

function putFirst(target: Row, key: string, value: unknown): void {
    if (value === null || value === undefined || value === "" || (Array.isArray(value) && value.length === 0)) return
    if (target[key] === undefined) target[key] = value
}

function mergeFirst(target: Row, source: Row): void {
    for (const [key, value] of Object.entries(source)) putFirst(target, key, value)
}

function radius(filter: unknown): number | undefined {
    if (typeof filter !== "string") return undefined
    const match = filter.match(/(?:Mon|BT)_Sphere_(\d+)_/)
    return match ? Number(match[1]) : undefined
}

function translateAttrs(addAttrs: unknown): Row {
    const result: Row = {}
    for (const attr of list(addAttrs)) {
        if (!attr || typeof attr !== "object") continue
        const row = attr as Row
        const name = ATTR_NAMES[String(row.AttrName)] ?? String(row.AttrName ?? "")
        const value = row.Rate ?? row.Value
        if (name && value !== null && value !== undefined) result[name] = value
    }
    return result
}

function baseVars(vars: Row): Row {
    const result: Row = {}
    const map: Record<string, string> = {
        HealRate: "吸血比例",
        Time: "间隔时间",
        WarningDelay: "预警延迟",
        UseSkillDis: "技能作用距离",
        AddDamageRate: "伤害加成倍率",
    }
    for (const [key, name] of Object.entries(map)) putFirst(result, name, vars[key])
    return result
}

export function monsterStrongAffixesModule(ctx: ModuleContext): VNodeTree {
    const guides = (ctx.dm.getTable("UIGuide") as Record<string, Row> | undefined) ?? {}
    const childGuides = (ctx.dm.getTable("UIChildGuide") as Record<string, Row> | undefined) ?? {}
    const titleChildren = new Map<string, number[]>()
    for (const guide of Object.values(guides)) {
        const title = guide?.MainGuideTitle
        if (typeof title !== "string" || !title.startsWith("Mon_Guide_Title_Strong_")) continue
        titleChildren.set(title, list(guide.ChildGuideId).map(Number).filter(Number.isFinite))
    }

    const buildDescription = (tag: string): { name: VNode; desc: VNode } => {
        const strongName = tag.split(".")[2]
        const titleKey = strongName ? `Mon_Guide_Title_Strong_${strongName}` : ""
        const parts: VNode[] = []
        for (const childId of titleChildren.get(titleKey) ?? []) {
            const child = childGuides[String(childId)]
            const info = child?.GuideInfo1
            const content = info?.GuideContent
            const descKey = content?.PC || content?.Phone || content?.GamePad
            if (!descKey) continue
            const values = list(info?.GuideDescValues).map(value =>
                typeof value === "string" ? compile(ctx.dm.calcSkillDesc(value, 1)) : String(value ?? "")
            ) as VNode[]
            if (parts.length > 0) parts.push("\n")
            parts.push(LTemplate(String(descKey), values))
        }
        return { name: LTemplate(titleKey, []), desc: seq(parts) }
    }

    const processBuff = (buffId: number, seenBuffs: Set<number>, seenEffects: Set<number>): Row => {
        const result: Row = {}
        const buff = entry(ctx, "Buff", buffId)
        if (!buff || seenBuffs.has(buffId)) return result
        const nextBuffs = new Set(seenBuffs).add(buffId)
        putFirst(result, "时间膨胀倍率", buff.TimeDilation)
        putFirst(result, "最大层数", buff.MaxLayer)
        const attrs = translateAttrs(buff.AddAttrs)
        if (Object.keys(attrs).length > 0) result.加成 = attrs
        const dot = list(buff.DotDatas).find(item => item && typeof item === "object" && (item as Row).Type === "Dot") as Row | undefined
        const hot = list(buff.DotDatas).find(item => item && typeof item === "object" && (item as Row).Type === "Hot") as Row | undefined
        if (dot) {
            putFirst(result, "DOT伤害", dot.Rate)
            putFirst(result, "DOT间隔", dot.Interval)
            putFirst(result, "伤害类型", dot.DamageTag)
        }
        if (hot) {
            putFirst(result, "HOT回复", hot.Rate)
            putFirst(result, "HOT间隔", hot.Interval)
        }
        for (const effectId of list(buff.VisualEffects)) {
            const n = number(effectId)
            if (n) processEffect(n, result, nextBuffs, seenEffects)
        }
        return result
    }

    const processCreature = (creatureId: number, target: Row, seenBuffs: Set<number>, seenEffects: Set<number>): void => {
        const creature = entry(ctx, "SkillCreature", creatureId)
        if (!creature) return
        putFirst(target, "飞行速度", creature.Speed)
        putFirst(target, "持续时间", creature.TimeLife)
        putFirst(target, "命中延迟", creature.TimeToHit)
        putFirst(target, "追踪速度", creature.TraceSpeed)
        putFirst(target, "追踪范围", creature.TraceRange?.Range)
        putFirst(target, "生效延迟", creature.Vars?.Delay)
        processRefs(creature.Vars, target, seenBuffs, seenEffects, true)
        for (const hitId of [...list(creature.HitEnemy), ...list(creature.HitScene)]) {
            const n = number(hitId)
            if (n) processEffect(n, target, seenBuffs, seenEffects)
        }
    }

    const processDanmaku = (templateId: number, target: Row, seenBuffs: Set<number>, seenEffects: Set<number>): void => {
        const template = entry(ctx, "DanmakuTemplate", templateId)
        const creatureId = number(template?.Type)
        if (!creatureId) return
        const creature = entry(ctx, "DanmakuCreature", creatureId)
        if (!creature) return
        putFirst(target, "持续时间", creature.TimeLife)
        putFirst(target, "伤害间隔", creature.Vars?.DamageInterval)
        processRefs(creature.Vars, target, seenBuffs, seenEffects)
        for (const hitId of [...list(creature.HitEnemy), ...list(creature.HitScene)]) {
            const n = number(hitId)
            if (n) processEffect(n, target, seenBuffs, seenEffects)
        }
    }

    const processEffect = (effectId: number, target: Row, seenBuffs: Set<number>, seenEffects: Set<number>): void => {
        if (seenEffects.has(effectId)) return
        const effect = entry(ctx, "SkillEffects", effectId)
        if (!effect) return
        const nextEffects = new Set(seenEffects).add(effectId)
        for (const task of list(effect.TaskEffects)) {
            if (!task || typeof task !== "object") continue
            const row = task as Row
            switch (row.Function) {
                case "Damage":
                    putFirst(target, "伤害倍率", row.Rate)
                    putFirst(target, "伤害类型", row.DamageTag)
                    putFirst(target, "半径", radius(effect.TargetFilter))
                    break
                case "CutToughness":
                    putFirst(target, "削韧值", row.Value)
                    putFirst(target, "受击类型", row.CauseHit)
                    break
                case "CreateUnit":
                    if (row.UnitType === "MechanismSummon") {
                        putFirst(target, "持续时间", row.LifeTime)
                        putFirst(target, "最大召唤数量", row.MaxSummonCount)
                        putFirst(target, "每次召唤数量", row.SingleSummonCount)
                        putFirst(target, "召唤延迟", row.CreateDelay)
                        const summon = entry(ctx, "MechanismSummon", row.UnitId)
                        processRefs(summon?.BluePrintParams, target, seenBuffs, nextEffects)
                    }
                    break
                case "CreateSkillCreature": {
                    const creatureId = number(row.CreatureId)
                    if (creatureId) processCreature(creatureId, target, seenBuffs, nextEffects)
                    break
                }
                case "CreateDanmaku":
                    putFirst(target, "持续时间", row.Duration)
                    if (number(row.DanmakuTemplateId)) processDanmaku(Number(row.DanmakuTemplateId), target, seenBuffs, nextEffects)
                    break
                case "AddBuff": {
                    putFirst(target, "BUFF持续", row.LastTime)
                    const nested = processBuff(number(row.BuffId) ?? 0, seenBuffs, nextEffects)
                    mergeFirst(target, nested)
                    break
                }
            }
        }
    }

    const processRefs = (
        value: unknown,
        target: Row,
        seenBuffs: Set<number>,
        seenEffects: Set<number>,
        insertEffectRadius = false
    ): void => {
        if (!value || typeof value !== "object") return
        const refs = Object.entries(value as Row)
            .map(([key, raw]) => ({ order: key.match(/^SkillEffectId(\d*)$/), raw }))
            .filter(item => item.order)
            .sort((a, b) => Number(a.order?.[1] || 1) - Number(b.order?.[1] || 1))
        for (const ref of refs) {
            const id = number(ref.raw)
            if (id) {
                if (insertEffectRadius) {
                    const effect = entry(ctx, "SkillEffects", id)
                    putFirst(target, "半径", radius(effect?.TargetFilter))
                }
                processEffect(id, target, seenBuffs, seenEffects)
            }
        }
    }

    const table = (ctx.dm.getTable("MonsterStrongAffixes") as Record<string, Row> | undefined) ?? {}
    const output: VNodeTree[] = []
    for (const item of Object.values(table)) {
        if (!item?.GamePlayTag) continue
        const tag = String(item.GamePlayTag)
        const guide = buildDescription(tag)
        const buffId = number(list(item.AffixesBuffIds)[0])
        const vars = baseVars(entry(ctx, "PassiveEffect", entry(ctx, "Buff", buffId)?.AddPassiveEffect?.[0])?.Vars ?? {})
        if (buffId) {
            const buff = entry(ctx, "Buff", buffId)
            const passive = entry(ctx, "PassiveEffect", buff?.AddPassiveEffect?.[0])
            if (passive?.Vars) processRefs(passive.Vars, vars, new Set(), new Set())
        }
        const row: Record<string, VNodeTree> = { id: tag, name: guide.name, desc: guide.desc }
        if (Object.keys(vars).length > 0) row.vars = vars
        output.push(row)
    }
    const order = [
        "Blood",
        "Burst",
        "Empower",
        "Fade",
        "Frozen",
        "IceOrb",
        "Kamikaze",
        "Poison",
        "Reflect",
        "Revenge",
        "Shield",
        "Shred",
        "Threefold",
        "Thunder",
        "ThunderLaser",
        "Vampire",
    ]
    output.sort((a, b) => {
        const aid = String((a as Row).id)
        const bid = String((b as Row).id)
        const abase = aid.split(".")[2] ?? aid
        const bbase = bid.split(".")[2] ?? bid
        const baseOrder = order.indexOf(abase) - order.indexOf(bbase)
        if (baseOrder !== 0) return baseOrder
        const variant = (id: string) => (id.endsWith(".Double") ? 1 : id.endsWith(".Triple") ? 2 : 0)
        return variant(aid) - variant(bid)
    })
    const baseRows = new Map<string, Record<string, VNodeTree>>()
    const deduplicated: VNodeTree[] = []
    const stripId = (value: unknown): unknown => {
        if (Array.isArray(value)) return value.map(stripId)
        if (value && typeof value === "object") {
            const out: Record<string, unknown> = {}
            for (const [key, item] of Object.entries(value as Record<string, unknown>)) {
                if (key !== "id") out[key] = stripId(item)
            }
            return out
        }
        return value
    }
    for (const item of output) {
        const row = item as Record<string, VNodeTree>
        const id = String(row.id)
        const base = id.replace(/\.(Double|Triple)$/, "")
        if (base === id) {
            baseRows.set(id, row)
            deduplicated.push(item)
            continue
        }
        const baseRow = baseRows.get(base)
        if (!baseRow || JSON.stringify(stripId(row)) !== JSON.stringify(stripId(baseRow))) deduplicated.push(item)
    }
    return deduplicated
}
