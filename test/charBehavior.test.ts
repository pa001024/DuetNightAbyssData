import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { charModule } from "../src/modules/char/charModule.ts"
import { EMIT_TASK_FUNCTIONS, getSkillEntry, HIDDEN_TASK_FUNCTIONS, taskFunctionPolicy } from "../src/modules/char/behaviorChain.ts"
import { skillModule } from "../src/modules/skill/skillModule.ts"

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")
const textmap = getTextMap(baseDir)
setDefaultTimeout(120000)

/** 与 behaviorChain 生产遍历同口径（主链 8 节点/分支 64 节点）收集角色技能可达的 task 类型。 */
function collectReachableTaskFunctions(): string[] {
    const dm = getLuaDataManager()
    const battleChar = dm.getTable("BattleChar") as Record<string, any>
    const roots = new Set<number>()
    for (const bc of Object.values(battleChar)) {
        if (!bc || typeof bc !== "object") continue
        for (const s of bc.SkillList ?? []) roots.add(Number(s))
    }
    const all = new Set<number>(roots)
    const queue = [...roots]
    while (queue.length > 0) {
        const entry = getSkillEntry(dm, queue.pop()!)
        if (!entry) continue
        for (const sub of Array.isArray(entry.SubSkills) ? entry.SubSkills : []) {
            const n = Number(sub)
            if (!all.has(n)) {
                all.add(n)
                queue.push(n)
            }
        }
    }
    const found = new Set<string>()
    const walkEffect = (effectId: unknown, seenEffects: Set<string>): void => {
        const key = String(effectId)
        if (seenEffects.has(key)) return
        seenEffects.add(key)
        const effect = dm.getTableItem("SkillEffects", key) as Record<string, any> | undefined
        if (!effect || typeof effect !== "object") return
        for (const task of Array.isArray(effect.TaskEffects) ? effect.TaskEffects : []) {
            if (!task || typeof task !== "object") continue
            found.add(String(task.Function ?? ""))
            for (const childKey of ["SkillEffect", "EffectIds"]) {
                const children = Array.isArray(task[childKey]) ? task[childKey] : task[childKey] === undefined ? [] : [task[childKey]]
                for (const child of children) walkEffect(child, seenEffects)
            }
        }
    }
    for (const skillId of all) {
        const entry = getSkillEntry(dm, skillId)
        if (!entry) continue
        const seenNodes = new Set<string>()
        const seenEffects = new Set<string>()
        let nodeId = entry.BeginNodeId
        while (nodeId && !seenNodes.has(String(nodeId)) && seenNodes.size < 8) {
            seenNodes.add(String(nodeId))
            const node = dm.getTableItem("SkillNode", String(nodeId)) as Record<string, any> | undefined
            if (!node || typeof node !== "object") break
            const effects = Array.isArray(node.SkillNodeEffects) ? node.SkillNodeEffects : [node.SkillNodeEffects]
            for (const effectId of effects) walkEffect(effectId, seenEffects)
            const branches = node.BranchNodeIds ?? node.ChildNodeIds
            const branchIds = Array.isArray(branches) ? branches : branches && typeof branches === "object" ? Object.values(branches) : []
            for (const branchId of branchIds) {
                let branchNodeId = branchId
                while (branchNodeId && !seenNodes.has(String(branchNodeId)) && seenNodes.size < 64) {
                    seenNodes.add(String(branchNodeId))
                    const branchNode = dm.getTableItem("SkillNode", String(branchNodeId)) as Record<string, any> | undefined
                    if (!branchNode || typeof branchNode !== "object") break
                    const branchEffects = Array.isArray(branchNode.SkillNodeEffects)
                        ? branchNode.SkillNodeEffects
                        : [branchNode.SkillNodeEffects]
                    for (const effectId of branchEffects) walkEffect(effectId, seenEffects)
                    branchNodeId = branchNode.NextNodeId
                }
            }
            nodeId = node.NextNodeId
        }
    }
    return [...found].sort()
}

describe("行为链形式化", () => {
    test("task 策略分类：emit 显示分句，hidden 与未知仅递归", () => {
        expect(taskFunctionPolicy("Damage")).toBe("emit")
        expect(taskFunctionPolicy("AddBuff")).toBe("emit")
        expect(taskFunctionPolicy("Heal")).toBe("emit")
        expect(taskFunctionPolicy("PlayFX")).toBe("hidden")
        expect(taskFunctionPolicy("PlaySE")).toBe("hidden")
        expect(taskFunctionPolicy("HitStop")).toBe("hidden")
        expect(taskFunctionPolicy("Executeskilleffect")).toBe("hidden")
        expect(taskFunctionPolicy("SomeFutureFunction")).toBe("hidden")
    })

    test("角色技能可达的 task 类型全部显式注册（27 种；隐藏 5 种）", () => {
        const reachable = collectReachableTaskFunctions()
        expect(reachable).toEqual([
            "AddBuff",
            "AddBullet",
            "AddEnergyShield",
            "AddSp",
            "AdditionalHitFX",
            "CallBackSkillCreature",
            "ChangeModel",
            "ChargeBullet",
            "CreateSkillCreature",
            "CreateUnit",
            "CutToughness",
            "Damage",
            "Disarm",
            "ExecuteClientPassiveFunction",
            "ExecutePassiveFunction",
            "Executeskilleffect",
            "Heal",
            "HitStop",
            "MakeSound",
            "PlayFX",
            "PlaySE",
            "PlayerCameraUnlock",
            "RemoveBuff",
            "RemoveSkillCreature",
            "RemoveUnit",
            "SetToCondemnLoc",
            "StartTargetCondemn",
        ])
        // 可达集合无未知类型：要么 emit，要么在隐藏表里
        for (const fn of reachable) {
            expect([...EMIT_TASK_FUNCTIONS, ...HIDDEN_TASK_FUNCTIONS]).toContain(fn)
        }
        expect([...HIDDEN_TASK_FUNCTIONS].sort()).toEqual(["Executeskilleffect", "HitStop", "MakeSound", "PlayFX", "PlaySE"])
    })

    test("行为分句金样例：模板与遍历顺序锁定", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        graph.defineModule({ name: "Char", deps: ["Skill"], outputs: true, build: ctx => charModule(ctx) })

        const artifacts = await graph.build({}, undefined, ["Char"])
        const chars = (artifacts.get("Char") as { Char: Array<Record<string, any>> }).Char
        const behaviorOf = (charId: number, skillId: number) => {
            const skills = chars.find(item => item.id === charId)?.技能 as Array<Record<string, any>>
            const flat = skills.flatMap(skill => [skill, ...((skill.子技能 as Array<Record<string, any>>) ?? [])])
            return String(renderTree(flat.find(item => item.id === skillId)?.行为, "cn", textmap))
        }
        // 召唤/附加（持续/层数）/通用执行/霸体位图/子技能移除链
        expect(behaviorOf(1503, 150302)).toBe(
            "召唤实体(150322);召唤实体(150324);召唤实体(150323);召唤实体(150321);附加增益(150325)[攻击范围加成+100, 激活技能];召唤单位(150302);附加增益(150327)[减伤25%, 霸体, 防抓取](持续25秒);附加增益(150320)[激活技能, 召唤武器, 驱散增益(150321, 150322, 150323, 150324)];召唤实体(150325)"
        )
        expect(behaviorOf(1503, 150321)).toBe(
            "移除增益(150320)[激活技能, 召唤武器, 驱散增益(150321, 150322, 150323, 150324)];移除增益(150321)[激活技能, 召唤武器, 驱散增益(150320, 150322, 150323, 150324)];移除增益(150322)[激活技能, 召唤武器, 驱散增益(150320, 150321, 150323, 150324)];移除增益(150323)[激活技能, 召唤武器, 驱散增益(150320, 150321, 150322, 150324)];移除增益(150324);移除增益(150325)[攻击范围加成+100, 激活技能];附加增益(150327)[减伤25%, 霸体, 防抓取](持续25秒);收回实体(150321);收回实体(150322);收回实体(150323);收回实体(150324);移除实体(150325);召唤实体(150332);触发被动功能[释放暗影剑](被动效果150301·BP_Kezhou_Passive)"
        )
        // 伤害（含未映射 DamageType 回退原文）/恢复/通用+Boss 削韧/被动功能
        expect(behaviorOf(1201, 120102)).toBe(
            "造成目标最大生命12%的HpConsume属性伤害;附加增益(120102)[追加伤害+#1](持续16秒);恢复类效果(MaxHp);造成角色攻击720.0%的伤害(技能/终结技);削减战姿100;Boss削韧60;召唤实体(120121);触发被动功能[检测并移除增益](被动效果120101·BP_Nvzhu_Dark_Passive)"
        )
        // 叠层附加 + Boss 削韧
        expect(behaviorOf(1102, 110211)).toBe(
            "造成近战武器攻击24%的暗属性伤害(武器/近战);削减战姿25;Boss削韧14;附加10层增益(110201);附加5层增益(110201);召唤实体(110212);召唤实体(110213)"
        )
        // 延迟眩晕 + Boss 削韧
        expect(behaviorOf(3301, 330101)).toBe(
            "造成角色攻击157.0%的伤害(技能/战技);延迟0.2秒后附加增益(201)[眩晕](持续2秒);削减战姿5;Boss削韧23;召唤实体(330103);触发被动功能[清空战技目标计数](被动效果330101·BP_Maer_Passive)"
        )
        // 最小单分句
        expect(behaviorOf(2101, 210101)).toBe("召唤单位(210101)")
    })
})
