import { afterEach, describe, expect, setDefaultTimeout, test } from "bun:test"
import { existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { UAssetCache } from "../src/lua/UAssetCache.ts"
import { UAssetServer } from "../src/lua/UAssetServer.ts"
import { OutputCollector } from "../src/output/OutputCollector.ts"
import { skillModule } from "../src/modules/skill/skillModule.ts"
import { collectSkillEvidence } from "../src/modules/skillAsset/evidence.ts"
import { extractFieldRefs } from "../src/modules/skillAsset/fieldRefs.ts"
import { readGrowRows } from "../src/modules/skillAsset/grow.ts"
import { collectSkillGraph, type GraphTables, MAX_GRAPH_DEPTH } from "../src/modules/skillAsset/graph.ts"
import { buildSkillAssetDoc, blueprintSeeds } from "../src/modules/skillAsset/skillAssetModule.ts"
import { buildSkillVariants, planSkillVariants, type SkillNodeRow } from "../src/modules/skillAsset/skillNodes.ts"
import { SKILL_BEHAVIOR_FEATURES, SKILL_BEHAVIOR_SCHEMA_VERSION } from "../src/modules/skillAsset/types.ts"
import { flattenBlueprintActions } from "../src/modules/skillBehavior/bpEval.ts"

setDefaultTimeout(120_000)

const STUB = join(import.meta.dir, "helpers", "uassetCliStub.ts")
const FIXTURE = join(import.meta.dir, "fixtures", "uassetBytecode.synthetic.json")
const textmap = getTextMap()

let tempDir: string | undefined
let openServers: UAssetServer[] = []
let openCaches: UAssetCache[] = []

afterEach(async () => {
    for (const server of openServers) await server.close().catch(() => undefined)
    for (const cache of openCaches) await cache.close().catch(() => undefined)
    openServers = []
    openCaches = []
    if (tempDir) rmSync(tempDir, { recursive: true, force: true })
    tempDir = undefined
})

function workDir(): string {
    if (!tempDir) tempDir = mkdtempSync(join(tmpdir(), "skill-asset-"))
    return tempDir
}

function readLog(path: string): Array<{ cmd: string; path: string }> {
    if (!existsSync(path)) return []
    return readFileSync(path, "utf8")
        .split("\n")
        .filter(Boolean)
        .map(line => JSON.parse(line))
}

describe("collectSkillEvidence", () => {
    const nodeTable: Record<string, Record<string, unknown>> = {
        100: { NodeId: 100, AnimName: "Skill01_Montage", AnimSubPath: "Combat/Skill/", SkillNodeEffects: [10], NextNodeId: 101 },
        101: { NodeId: 101, SkillNodeEffects: [11], BranchNodeIds: [102] },
        102: { NodeId: 102, SkillNodeEffects: [12], NextNodeId: 103 },
        103: { NodeId: 103, SkillNodeEffects: [13] },
    }
    const effectTable: Record<string, Record<string, unknown>> = {
        10: { TaskId: 10, NotifyName: ["hit1"], TaskEffects: [{ Function: "Damage", BuffId: 500 }] },
        11: { TaskId: 11, TaskEffects: [{ Function: "AddBuff", BuffId: 501 }, { Function: "Executeskilleffect", EffectIds: [12] }] },
        12: { TaskId: 12, NotifyName: "hit2", TaskEffects: [{ Function: "CreateSkillCreature", CreatureId: 900 }] },
        13: { TaskId: 13, TaskEffects: [{ Function: "AddBuff", BuffId: 502, PassiveEffectId: 700 }] },
    }
    const passiveTable: Record<string, Record<string, unknown>> = {
        700: { ID: 700, BPPath: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_FromTask.BP_FromTask" },
        701: { ID: 701, BPPath: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_FromSkill.BP_FromSkill" },
        702: { ID: 702, BPPath: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_FromDesc.BP_FromDesc" },
        703: { ID: 703, BPPath: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_Falu_Passive.BP_Falu_Passive" },
    }
    const tables = {
        skillNode: (id: number | string) => nodeTable[String(id)],
        skillEffect: (id: number | string) => effectTable[String(id)],
        passiveEffect: (id: number | string) => passiveTable[String(id)],
        bpAddBuff: { BP_FromSkill: [601, 602], BP_Falu_Passive: [999] },
    }
    const skillTable: Record<string, unknown> = {
        1: [
            {
                "0": {
                    SkillId: 1,
                    SkillType: "Skill1",
                    BeginNodeId: 100,
                    PassiveEffects: [701, 703],
                    SkillDescValues: ["$#PassiveEffect[702].Vars.X$"],
                },
            },
        ],
    }
    const dm = {
        getTableItem: (table: string, id: number | string) => (table === "Skill" ? skillTable[String(id)] : undefined),
    } as any

    test("沿主链/分支收集节点、effect、Buff、PassiveEffect 与 BPAddBuff 静态映射", () => {
        const evidence = collectSkillEvidence(dm, 1, tables)
        expect(evidence).not.toBeNull()
        expect(evidence!.nodes.map(node => node.id)).toEqual([100, 101, 102, 103])
        expect(evidence!.effects.map(effect => effect.id)).toEqual([10, 11, 12, 13])
        // BPAddBuff 仅对 Skill.PassiveEffects 的 BP 生效，并沿用 behaviorChain 的 BP_Falu_Passive 例外
        // BP_Falu_Passive 的静态映射被 behaviorChain 显式排除，这里同样不并入 Buff。
        expect(evidence!.buffIds).toEqual([500, 501, 502, 601, 602])
        // PassiveEffect 的可达来源三种都要解析 BPPath：TaskEffects / Skill.PassiveEffects / 描述串
        expect(evidence!.passiveIds).toEqual([700, 702, 701, 703])
        expect(evidence!.passiveEffectBPs).toEqual([
            { id: 700, path: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_FromTask.BP_FromTask" },
            { id: 702, path: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_FromDesc.BP_FromDesc" },
            { id: 701, path: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_FromSkill.BP_FromSkill" },
            { id: 703, path: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_Falu_Passive.BP_Falu_Passive" },
        ])
        expect(evidence!.nodes[0]).toMatchObject({
            animName: "Skill01_Montage",
            animSubPath: "Combat/Skill/",
            effects: [10],
            nextNodeId: 101,
        })
        expect(evidence!.nodes[1]!.branchNodeIds).toEqual([102])
        expect(evidence!.effects[1]!.notifyNames).toEqual([])
        expect(evidence!.effects[2]!.notifyNames).toEqual(["hit2"])
    })

    test("技能条目缺失时返回 null（不静默产出空技能）", () => {
        expect(collectSkillEvidence(dm, 2, tables)).toBeNull()
    })
})

describe("extractFieldRefs", () => {
    const effectTable: Record<string, Record<string, unknown>> = {
        410126: { TaskId: 410126, TaskEffects: [{ Function: "Damage" }, { Function: "Damage" }] },
    }
    const lookup = { skillEffects: (id: number) => effectTable[String(id)] }

    test("无锚点扫描：函数包装、嵌套与 DotDatas 索引", () => {
        const result = extractFieldRefs(
            ["K0", "K1", "K2", "K3"],
            [
                "$#SkillEffects[410126].TaskEffects[1].Rate*100$%",
                "$math.abs(#Buff[180102].DotDatas[1].Value)$",
                "$#TargetFilter[#SkillEffects[410126].TargetFilter].LuaFilterParaments.Radius/100$",
                "$(#Buff[180122].DotDatas[1].Rate)*100$%",
            ],
            lookup,
            410102
        )
        expect(result.total).toBe(4)
        expect(result.unresolved).toEqual([])
        expect(result.groups.map(group => group.descKey)).toEqual(["K0", "K1", "K2", "K3"])

        expect(result.groups[0]!.refs[0]).toEqual({
            kind: "SkillEffects",
            id: 410126,
            taskId: 410126,
            taskIndex: 0,
            rawTaskIndex: 1,
            dotIndex: null,
            path: "TaskEffects[1].Rate",
            raw: "#SkillEffects[410126].TaskEffects[1].Rate",
        })
        expect(result.groups[1]!.refs[0]).toMatchObject({ kind: "Buff", id: 180102, path: "DotDatas[1].Value", dotIndex: 0 })
        // 嵌套 TargetFilter 只取内层数值引用；外层参数是表达式而非行 id。
        expect(result.groups[2]!.refs).toHaveLength(1)
        expect(result.groups[2]!.refs[0]).toMatchObject({ kind: "SkillEffects", id: 410126, path: "TargetFilter", taskIndex: null })
        expect(result.groups[3]!.refs[0]).toMatchObject({ kind: "Buff", id: 180122, path: "DotDatas[1].Rate", dotIndex: 0 })
    })

    test("缺行、task 越界与未知命名空间显式进入 unresolved", () => {
        const result = extractFieldRefs(
            [undefined],
            ["$#SkillEffects[410126].TaskEffects[3].Rate$ $#SkillEffects[999].TaskEffects[1].Rate$ $#Foo[7].Bar$"],
            lookup,
            42
        )
        expect(result.total).toBe(3)
        expect(result.groups[0]!.descKey).toBeNull()
        expect(result.unresolved.map(ref => `${ref.kind}:${ref.id}:${ref.reason}`)).toEqual([
            "SkillEffects:410126:task-index-out-of-range",
            "SkillEffects:999:missing-row",
            "Foo:7:unknown-namespace",
        ])
        expect(result.groups[0]!.refs.find(ref => ref.id === 999)?.taskId).toBeNull()
        expect(result.groups[0]!.refs.find(ref => ref.id === 410126)?.taskIndex).toBe(2)
    })
})

describe("readGrowRows", () => {
    test("数组形态按 Index 分组、按 Level 排序", () => {
        const rows = readGrowRows([
            [{ Index: 2, Level: 1, Value: 0.1 }],
            [{ Index: 1, Level: 2, Value: 4.74 }],
            [{ Index: 1, Level: 1, Value: 3.88 }],
        ])
        expect(rows).toEqual({
            "1": [
                { level: 1, value: 3.88 },
                { level: 2, value: 4.74 },
            ],
            "2": [{ level: 1, value: 0.1 }],
        })
    })

    test("对象形态（GlobalPassiveData，含 0 级）与字符串值", () => {
        const rows = readGrowRows({ "0": [{ Index: 1, Level: 0, Value: 0 }], "1": [{ Index: 1, Level: 1, Value: "#1" }] })
        expect(rows).toEqual({
            "1": [
                { level: 0, value: 0 },
                { level: 1, value: "#1" },
            ],
        })
    })

    test("缺失或无效行返回 null", () => {
        expect(readGrowRows(undefined)).toBeNull()
        expect(readGrowRows([])).toBeNull()
        expect(readGrowRows([{ NotARow: true }])).toBeNull()
    })
})

describe("collectSkillGraph 边界", () => {
    function tablesFrom(records: {
        effects?: Record<string, Record<string, unknown>>
        creatures?: Record<string, Record<string, unknown>>
        skills?: Record<string, Record<string, unknown>>
        nodes?: Record<string, Record<string, unknown>>
        buffs?: Record<string, Record<string, unknown>>
        passives?: Record<string, Record<string, unknown>>
        units?: Record<string, { battleMonster?: Record<string, unknown>; monster?: Record<string, unknown>; mechanismSummon?: Record<string, unknown> }>
    }): GraphTables {
        return {
            skill: id => records.skills?.[String(id)],
            skillNode: id => records.nodes?.[String(id)],
            skillEffects: id => records.effects?.[String(id)],
            skillCreature: id => records.creatures?.[String(id)],
            buff: id => records.buffs?.[String(id)],
            passiveEffect: id => records.passives?.[String(id)],
            effectCreature: () => undefined,
            unitParts: id => ({
                battleMonster: records.units?.[String(id)]?.battleMonster,
                monster: records.units?.[String(id)]?.monster,
                mechanismSummon: records.units?.[String(id)]?.mechanismSummon,
            }),
        }
    }

    test("深度上限显式记录，不静默截断", () => {
        const effects: Record<string, Record<string, unknown>> = {}
        for (let id = 1; id <= MAX_GRAPH_DEPTH + 5; id++) {
            effects[String(id)] = { TaskId: id, TaskEffects: [{ Function: "Executeskilleffect", EffectIds: [id + 1] }] }
        }
        const result = collectSkillGraph(tablesFrom({ effects }), [{ skillId: 1, seeds: [{ kind: "SkillEffects", id: 1, relation: "test", descIndex: null }] }])
        expect(result.depthLimitHits).toBeGreaterThan(0)
        expect(result.unresolved.some(ref => ref.reason === "depth-limit")).toBe(true)
        expect(result.effects.has(MAX_GRAPH_DEPTH + 2)).toBe(false)
        expect(result.effects.size).toBe(MAX_GRAPH_DEPTH + 1)
    })

    test("单节点分支上限显式记录", () => {
        const ids = Array.from({ length: 65 }, (_, index) => index + 2)
        const result = collectSkillGraph(
            tablesFrom({
                nodes: { "1": { SkillNodeEffects: ids } },
                effects: Object.fromEntries(ids.map(id => [String(id), { TaskId: id, TaskEffects: [] }])),
            }),
            [{ skillId: 1, seeds: [{ kind: "SkillNode", id: 1, relation: "test", descIndex: null }] }]
        )
        expect(result.unresolved.some(ref => ref.reason === "branch-limit")).toBe(true)
        expect(result.effects.size).toBe(64)
    })

    test("缺行进 unresolved；Unit 与同名 SkillCreature 只记约定、不建边", () => {
        const result = collectSkillGraph(
            tablesFrom({
                effects: { "800": { TaskId: 800, TaskEffects: [] } },
                creatures: { "500": { CreatureId: 500, HitEnemy: [800] } },
                skills: { "600": { SkillId: 600, PassiveEffects: [700] } },
                passives: { "700": { ID: 700 } },
                units: {
                    "500": {
                        battleMonster: { SkillList: [600] },
                        monster: { GamePlayTags: ["Player.Summon"], UnitBPPath: "/Game/BP_Unit.BP_Unit" },
                    },
                },
            }),
            [
                {
                    skillId: 1,
                    seeds: [
                        { kind: "SkillEffects", id: 999, relation: "test", descIndex: null },
                        { kind: "Unit", id: 500, relation: "test", descIndex: null },
                    ],
                },
            ]
        )
        expect(result.missing.effects.has(999)).toBe(true)
        expect(result.unresolved.some(ref => ref.kind === "SkillEffects" && ref.id === 999 && ref.reason === "missing-row")).toBe(true)

        const unit = result.units.get(500)!
        expect(unit.skillIds).toEqual([600])
        expect(unit.passiveEffectIds).toEqual([700])
        expect(unit.gamePlayTags).toEqual(["Player.Summon"])
        expect(unit.unitBPPath).toBe("/Game/BP_Unit.BP_Unit")
        expect(unit.sameIdCreatureId).toBe(500)
        expect(unit.referencedBySkills).toEqual([1])

        // 图走到 Unit 的技能与被动，但不沿同名 creature 建边。
        expect(result.skillIds.has(600)).toBe(true)
        expect(result.passiveIds.has(700)).toBe(true)
        expect(result.effects.has(800)).toBe(false)
        const convention = result.conventionRefs.find(ref => ref.kind === "Unit" && ref.id === 500)!
        expect(convention).toMatchObject({ relatedKind: "SkillCreature", relatedId: 500, note: "unit-creature-same-id" })
    })
})

describe("flattenBlueprintActions", () => {
    type Expr = Record<string, unknown>
    const local = (name: string): Expr => ({ op: "EX_LocalVariable", property: { path: [name], owner: "F" } })
    const instance = (name: string, owner = "PassiveEffectObject"): Expr => ({
        op: "EX_InstanceVariable",
        property: { path: [name], owner },
    })
    const int = (value: number): Expr => ({ op: "EX_IntConst", value })
    const call = (fn: string, args: Expr[], offset: number): Expr => ({ op: "EX_FinalFunction", offset, function: fn, args })
    const context = (fn: string, args: Expr[], offset: number): Expr => ({
        op: "EX_Context",
        offset,
        object: { op: "EX_ObjectConst", object: { kind: "import", name: "Default__BattleFunctionLibrary" } },
        context: call(fn, args, offset + 1),
        property: null,
    })
    const setArray = (name: string, values: number[], offset: number): Expr => ({
        op: "EX_SetArray",
        offset,
        property: local(name),
        innerType: "null",
        elements: values.map(int),
    })
    const fn = (name: string, body: Expr[], blocks: unknown[], params: string[] = []) => ({
        name,
        flags: [],
        params: params.map(param => ({ name: param, type: "IntProperty" })),
        locals: [],
        body,
        blocks,
    })
    const linearBlocks = (count: number) => [
        { index: 0, startOffset: 0, endOffset: 0, statements: Array.from({ length: count }, (_, index) => index), successors: [] },
    ]
    const doc = (functions: unknown[]) => ({
        schemaVersion: 1,
        asset: "BP_Test",
        class: { name: "BP_Test_C", super: "BP_Buff_C", interfaces: [] },
        events: [],
        variables: [],
        components: [],
        functions,
    })

    test("字面量数组、AddBuff 字面量与 ApplyDamage 连接", () => {
        const body = [
            setArray("Arr", [7001, 7002], 0),
            context("ExecuteSkillEffects", [instance("PassiveOwner"), local("Arr"), instance("PassiveOwner")], 10),
            context(
                "AddBuffToTarget",
                [instance("PassiveOwner"), instance("PassiveOwner"), int(8001), int(15), int(0), { op: "EX_NoInterface" }, int(3), { op: "EX_NoObject" }],
                20
            ),
            {
                op: "EX_SetArray",
                offset: 30,
                property: local("DamageTags"),
                innerType: "null",
                elements: [{ op: "EX_NameConst", value: "Dot" }],
            },
            {
                op: "EX_LetObj",
                offset: 40,
                variable: local("CallFunc_GenDamageWithType_ReturnValue"),
                value: context(
                    "GenDamageWithType",
                    [
                        instance("PassiveOwner"),
                        local("Target"),
                        { op: "EX_NameConst", value: "Light" },
                        { op: "EX_FloatConst", value: 0.5 },
                        { op: "EX_NoObject" },
                        local("DamageTags"),
                        int(0),
                    ],
                    41
                ),
            },
            context("ApplyDamage", [local("CallFunc_GenDamageWithType_ReturnValue")], 60),
            context("AddBuffToTarget", [instance("PassiveOwner"), instance("PassiveOwner"), local("UndefinedBuff"), int(-1)], 70),
        ]
        const result = flattenBlueprintActions("EM/Content/BP_Test", doc([fn("F", body, linearBlocks(body.length))]) as any)
        expect(result.actions).toHaveLength(3)
        expect(result.actions[0]).toMatchObject({ kind: "executeEffects", effectIds: [7001, 7002] })
        expect(result.actions[0]!.source).toMatchObject({ bpPackage: "EM/Content/BP_Test", function: "F", nodeId: "F#11", op: "EX_FinalFunction", offset: 11 })
        expect(result.actions[1]).toMatchObject({ kind: "applyBuff", buffId: 8001, duration: 15, count: 3 })
        expect(result.actions[2]).toMatchObject({ kind: "damage", damageType: "Light", rate: 0.5, damageTags: ["Dot"], applied: true })

        // 未赋值的局部变量不猜值：只记录原因，不产出动作。
        expect(result.actions).toHaveLength(3)
        expect(result.unresolved).toEqual([
            {
                bpPackage: "EM/Content/BP_Test",
                function: "F",
                nodeId: "F#71",
                call: "AddBuffToTarget",
                reason: "buff-id-unresolved",
                detail: "uninitialized-local",
            },
        ])
    })

    test("分支合流的不同定义折叠为 ambiguous，不取其中一个分支", () => {
        const body = [
            setArray("Arr", [7001], 0),
            setArray("Arr", [7002], 10),
            context("ExecuteSkillEffects", [instance("PassiveOwner"), local("Arr")], 20),
        ]
        const blocks = [
            { index: 0, statements: [0], successors: [{ kind: "jump", block: 2 }] },
            { index: 1, statements: [1], successors: [{ kind: "jump", block: 2 }] },
            { index: 2, statements: [2], successors: [] },
        ]
        const result = flattenBlueprintActions("EM/Content/BP_Test", doc([fn("F", body, blocks)]) as any)
        expect(result.actions).toEqual([])
        expect(result.unresolved).toHaveLength(1)
        expect(result.unresolved[0]).toMatchObject({ call: "ExecuteSkillEffects", reason: "effect-array-unresolved", detail: "ambiguous-definitions" })
    })

    test("CreateCreature 展开被调函数的字面量效果并解析 creature id", () => {
        const callee = fn("CreateCreature", [setArray("Arr", [9001], 0), context("ExecuteSkillEffects", [instance("PassiveOwner"), local("Arr")], 10)], [
            { index: 0, statements: [0, 1], successors: [] },
        ])
        const caller = fn(
            "Event",
            [
                { op: "EX_LocalVirtualFunction", offset: 5, function: "CreateCreature", args: [] },
                { op: "EX_LocalVirtualFunction", offset: 15, function: "CreateDoubleCreature", args: [] },
            ],
            [{ index: 0, statements: [0, 1], successors: [] }]
        )
        const result = flattenBlueprintActions("EM/Content/BP_Test", doc([callee, caller]) as any, {
            effectCreatures: effectId => (effectId === 9001 ? [777] : null),
        })
        const creatures = result.actions.filter(action => action.kind === "createCreature")
        expect(creatures).toHaveLength(2)
        expect(creatures[0]).toMatchObject({ function: "CreateCreature", effectIds: [9001], creatureIds: [777] })
        // 未在本资产内定义的本地函数：只记录缺口，不补 creature。
        expect(creatures[1]).toMatchObject({ function: "CreateDoubleCreature", effectIds: null, creatureIds: null })
        expect(result.unresolved).toEqual([
            {
                bpPackage: "EM/Content/BP_Test",
                function: "Event",
                nodeId: "Event#15",
                call: "CreateDoubleCreature",
                reason: "local-function-unresolved",
                detail: "被调函数不在本资产内或展开深度超限",
            },
        ])
    })

    test("效果行缺失与缺少 blocks 都显式记录", () => {
        const callee = fn("CreateCreature", [setArray("Arr", [9002], 0), context("ExecuteSkillEffects", [instance("PassiveOwner"), local("Arr")], 10)], [
            { index: 0, statements: [0, 1], successors: [] },
        ])
        const caller = fn("Event", [{ op: "EX_LocalVirtualFunction", offset: 5, function: "CreateCreature", args: [] }], [
            { index: 0, statements: [0], successors: [] },
        ])
        const missingRow = flattenBlueprintActions("EM/Content/BP_Test", doc([callee, caller]) as any, { effectCreatures: () => null })
        expect(missingRow.actions.find(action => action.kind === "createCreature")).toMatchObject({ effectIds: [9002], creatureIds: null })
        expect(missingRow.unresolved.map(item => item.reason)).toContain("creature-effect-row-missing")

        const noBlocks = flattenBlueprintActions("EM/Content/BP_Test", doc([{ name: "F", params: [], locals: [], body: [] }]) as any)
        expect(noBlocks.unresolved.map(item => item.reason)).toEqual(["cfg-missing"])
    })
})

describe("blueprintSeeds", () => {
    const source = (nodeId: string) => ({
        bpPackage: "EM/Content/BP_Test",
        function: "F",
        nodeId,
        op: "EX_FinalFunction",
        offset: 1,
    })

    test("kind 由动作语义决定并保留 BP 来源，不按表存在性推断", () => {
        const seeds = blueprintSeeds([
            { kind: "executeEffects", effectIds: [430113], source: source("F#1") },
            {
                kind: "createCreature",
                function: "CreateCreature",
                effectIds: [430113],
                creatureIds: [510201],
                source: source("F#2"),
            },
            { kind: "applyBuff", buffId: 430113, duration: -1, count: 1, source: source("F#3") },
            { kind: "removeBuff", buffId: 510212, source: source("F#4") },
            { kind: "reduceBuffLayer", buffId: 110201, layers: 1, source: source("F#5") },
            { kind: "damage", damageType: "Light", rate: null, damageTags: null, applied: true, source: source("F#6") },
        ])
        // 同一数字 id 在不同动作语义下分属 SkillEffects / Buff，互不混淆。
        expect(seeds.map(seed => `${seed.kind}:${seed.id}:${seed.relation}`)).toEqual([
            "SkillEffects:430113:bp.executeEffects",
            "SkillEffects:430113:bp.createCreature.effect",
            "SkillCreature:510201:bp.createCreature.creature",
            "Buff:430113:bp.applyBuff",
            "Buff:510212:bp.removeBuff",
            "Buff:110201:bp.reduceBuffLayer",
        ])
        expect(seeds[0]!.bp).toEqual({ bpPackage: "EM/Content/BP_Test", function: "F", nodeId: "F#1" })
        // damage 动作不带可追溯的 id，不产生种子。
        expect(seeds.some(seed => seed.relation === "bp.damage")).toBe(false)
    })

    test("未能解析的 createCreature 参数不产出种子", () => {
        const seeds = blueprintSeeds([
            { kind: "createCreature", function: "CreateDoubleCreature", effectIds: null, creatureIds: null, source: source("F#1") },
        ])
        expect(seeds).toEqual([])
    })
})

describe("skillNodes 变体归纳", () => {
    const row = (nodeId: number, costSp: number | null, effects: number[] = []): SkillNodeRow => ({
        nodeId,
        costSp,
        animPath: null,
        animResource: `M${nodeId}`,
        animName: null,
        animSubPath: null,
        animPlayRate: 1,
        effects,
    })

    // Skill 表与 getSkillEntry 的口径一致：info[0] 是等级行，等级行内的 "1" 是首个 grade。
    const skillTable: Record<string, unknown> = {
        100: [{ "1": { BeginNodeId: 101, SubSkills: [101], LongPressSkill: 101 }, "0": { BeginNodeId: 101 } }],
        101: [{ "1": { BeginNodeId: 102 } }],
        200: [{ "1": { BeginNodeId: 201, SubSkills: [999] } }],
    }
    const dm = {
        getTableItem: (table: string, id: number | string) => (table === "Skill" ? skillTable[String(id)] : undefined),
    }

    test("默认根与子技能根分开；longPress 只按子技能 id 匹配，不按节点 id", () => {
        // 410201 的真实形状：LongPressSkill 数值与默认节点 id 相同，但长按节点是子技能 101 的 BeginNodeId。
        const plan = planSkillVariants(dm, { BeginNodeId: 101, SubSkills: [101], LongPressSkill: 101, SkillBtnIcon: "Icon" })
        expect(plan.skillRow).toEqual({ beginNodeId: 101, subSkills: [101], longPressSkill: 101, skillBtnIcon: "Icon" })
        expect(plan.roots).toEqual([
            { nodeId: 101, isDefault: true, trigger: null },
            { nodeId: 102, isDefault: false, trigger: "longPress" },
        ])
        const result = buildSkillVariants(new Map([[101, row(101, 15, [1])], [102, row(102, 15, [2])]]), plan, item => `pkg/${item.animResource}`)
        expect(result.variants).toEqual([
            { nodeId: 101, costSp: 15, montage: "pkg/M101", effects: [1], isDefault: true },
            { nodeId: 102, costSp: 15, montage: "pkg/M102", effects: [2], isDefault: false, trigger: "longPress" },
        ])
        expect(result.missingNodeIds).toEqual([])
    })

    test("缺失子技能行/节点行只记录，不补造空变体", () => {
        const plan = planSkillVariants(dm, { BeginNodeId: 201, SubSkills: [999] })
        expect(plan.missingSubSkillIds).toEqual([999])
        const result = buildSkillVariants(new Map(), plan, () => null)
        expect(result.variants).toEqual([])
        expect(result.missingNodeIds).toEqual([201])
    })
})

describe("skillAsset 模块", () => {
    async function buildDoc() {
        const graph = new Graph()
        graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        graph.defineModule({ name: "SkillAsset", deps: ["Skill"], outputs: true, build: async () => undefined })
        await graph.build({}, undefined, ["Skill"])
        return buildSkillAssetDoc({
            dm: getLuaDataManager(),
            textmap,
            graph,
            getArtifact: <T>() => graph.getArtifact<T>("Skill"),
            args: {},
            log: () => undefined,
        })
    }

    test("文档结构、覆盖计数与角色/子技能口径", async () => {
        const doc = await buildDoc()
        expect(doc.schemaVersion).toBe(SKILL_BEHAVIOR_SCHEMA_VERSION)
        expect(SKILL_BEHAVIOR_SCHEMA_VERSION).toBe(2)
        expect(doc.features).toEqual([...SKILL_BEHAVIOR_FEATURES])
        expect(doc.exporter.parserVersion).toBeGreaterThan(0)
        expect(doc.characters).toHaveLength(34)

        const lise = doc.characters.find(character => character.id === 4101)
        expect(lise).toBeDefined()
        expect(lise!.skills).toEqual([410101, 410102, 410103, 410104, 410001])
        expect(lise!.subSkills.length).toBeGreaterThan(0)
        expect(lise!.animBP).toBe("EM/Content/AssetDesign/Char/Player/Lise/ABP_Lise")

        const skill = doc.skills["410102"]!
        expect(skill.slot).toBe("Q")
        expect(skill.parentSkillId).toBeNull()
        expect(typeof skill.lua.behavior).toBe("string")
        expect(skill.lua.behavior).toContain("附加增益(410111)")
        // 行为文本保留原始 Attr key（不做语言渲染）
        expect(skill.lua.behavior).toContain("GT{Attr_JumpVelocityModifier_Name}")
        expect(skill.montage).not.toBeNull()
        expect(skill.montage!.length).toBeCloseTo(1.8333334, 5)
        expect(skill.sequences.length).toBeGreaterThan(0)
        expect(skill.sources.animBPs).toEqual(["EM/Content/AssetDesign/Char/Player/Lise/ABP_Lise"])

        const passive = doc.skills["410103"]!
        expect(passive.slot).toBe("P")
        expect(passive.sources.bpPackages).toEqual(["EM/Content/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_Lise_Passive"])

        // 子技能：存在且指向父技能
        const child = Object.values(doc.skills).find(item => item.parentSkillId === 410102)
        expect(child).toBeDefined()

        const coverage = doc.coverage
        expect(coverage.skillsTotal).toBe(Object.keys(doc.skills).length)
        expect(coverage.skillsMissing).toEqual([])
        expect(coverage.blueprintsParsed).toBe(Object.keys(doc.blueprints).length)
        expect(coverage.animBPsResolved).toBe(doc.characters.filter(character => character.animBP !== null).length)
        expect(coverage.assets.fmodelHits + coverage.assets.fmodelLoads).toBeGreaterThan(0)
        expect(coverage.assets.bytecodeHits + coverage.assets.bytecodeLoads).toBeGreaterThan(0)
        // 未解析的动画引用必须进入缺口清单（武器技能 Montage 依赖角色前缀）
        for (const gap of coverage.montagesMissing) {
            expect(doc.skills[String(gap.skillId)]).toBeDefined()
        }
        // notify payload 关联必须显式统计：无 export 的原生 notify 进入缺口清单
        expect(coverage.notifiesTotal).toBeGreaterThan(0)
        expect(coverage.notifiesWithPayload).toBeGreaterThan(0)
        expect(coverage.notifiesTotal - coverage.notifiesWithPayload).toBe(coverage.notifiesWithoutPayload.length)

        // 角色口径：Char.json 的 169 个主技能全部覆盖，子技能单独计数
        expect(doc.characters.reduce((sum, character) => sum + character.skills.length, 0)).toBe(169)
        expect(coverage.owners.char!.skills).toBeGreaterThan(169)

        // Mod.ModActivateSkills 是 Lua map（{"1010101":1010201}），必须归一化后进入 skills
        expect(coverage.owners.mod?.skills ?? 0).toBeGreaterThan(0)
        expect(doc.skills["1010201"]).toBeDefined()
        expect(doc.skills["1010201"]!.owner).toEqual({ kind: "mod", id: 101001 })

        // 技能链引用的 PassiveEffect 必须解析 BPPath（Lise Q → PassiveEffect 410103 → BP_Lise_Skill02_01）
        const liseQ = doc.skills["410102"]!
        expect(liseQ.sources.bpPackages).toContain(
            "EM/Content/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_Lise_Skill02_01"
        )
        expect(doc.passives["410103"]).toBeDefined()
        expect(doc.passives["410103"]!.referencedBySkills).toContain(410102)
        expect(doc.passives["410103"]!.bpPackages).toEqual([
            "EM/Content/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_Lise_Skill02_01",
        ])
        expect(coverage.passivesTotal).toBeGreaterThan(coverage.ownerPassivesTotal)
        expect(coverage.nativeCallsUnknown.length).toBeGreaterThan(0)
        expect(coverage.nativeCallsUnknown[0]!.count).toBeGreaterThan(0)
    })

    test("SkillNode 全量导出与 4102 变体：互斥节点不合并", async () => {
        const doc = await buildDoc()
        const rawNodes = getLuaDataManager().getTable("SkillNode") as Record<string, unknown>
        expect(Object.keys(doc.skillNodes).sort()).toEqual(Object.keys(rawNodes).sort())
        expect(doc.coverage.skillNodesTotal).toBe(Object.keys(rawNodes).length)

        // 410201：默认节点 410211；子技能 410211（同等于 LongPressSkill）的 BeginNodeId 是 410212。
        const e = doc.skills["410201"]!
        expect(e.skillRow).toEqual({ beginNodeId: 410211, subSkills: [410211], longPressSkill: 410211, skillBtnIcon: "Skill_Zhiliu01" })
        expect(e.variants.map(variant => variant.nodeId)).toEqual([410211, 410212])
        expect(e.variants.map(variant => variant.isDefault)).toEqual([true, false])
        expect(e.variants.map(variant => variant.trigger)).toEqual([undefined, "longPress"])
        expect(e.variants.map(variant => variant.costSp)).toEqual([15, 15])
        expect(e.variants[0]!.effects).toEqual([410211, 410212])
        expect(e.variants[1]!.effects).toEqual([410214, 410215])
        expect(e.variants[0]!.montage).toContain("Zhiliu_Skill01_01_Montage")
        expect(e.variants[1]!.montage).toContain("Zhiliu_Skill01_02_Montage")

        // 410202：BeginNodeId 410221 + 子技能链 410222/410223/410224，各自保留 CostSp 与 effects。
        const q = doc.skills["410202"]!
        expect(q.skillRow).toEqual({ beginNodeId: 410221, subSkills: [410221, 410222, 410223], longPressSkill: null, skillBtnIcon: "Skill_Zhiliu02_1" })
        expect(q.variants.map(variant => variant.nodeId)).toEqual([410221, 410222, 410223, 410224])
        expect(q.variants.map(variant => variant.costSp)).toEqual([20, 45, 60, 30])
        expect(q.variants.map(variant => variant.effects)).toEqual([
            [410221],
            [410231, 410227],
            [410240, 410241, 410227],
            [410225, 410226, 410227],
        ])
        expect(q.variants.map(variant => variant.isDefault)).toEqual([true, false, false, false])
        expect(q.variants.every(variant => variant.trigger === undefined)).toBe(true)
        expect(q.variants.every(variant => variant.montage?.includes("Zhiliu_Skill02"))).toBe(true)

        // 410225 没有任何 BeginNodeId/SubSkills 指向它：只进全量 skillNodes，不补造成变体。
        expect(q.variants.some(variant => variant.nodeId === 410225)).toBe(false)
        expect(doc.skillNodes["410225"]).toEqual({
            nodeId: 410225,
            costSp: 60,
            animPath: "/Game/Asset/Char/Player/Char029_Zhiliu/Animation/Montage/Combat/Skill/",
            animResource: "Zhiliu_Skill02_TD_W_Montage",
            animPlayRate: 1,
            effects: [410260, 410261, 410227],
        })

        // 普通多变体技能同样按节点导出，LongPressSkill 只标记对应子技能贡献的节点。
        const fu = doc.skills["110201"]!
        expect(fu.variants.map(variant => variant.nodeId)).toEqual([110211, 110212])
        expect(fu.variants.map(variant => variant.trigger)).toEqual([undefined, "longPress"])

        for (const skill of Object.values(doc.skills)) expect(Array.isArray(skill.variants)).toBe(true)
    })

    test("v2 图与字段引用：8 个 creature/effect 缺失角色的真实数据回归", async () => {
        const doc = await buildDoc()

        // 1601：战技实体命中 effect，伤害字段 ATK_Char / #1
        expect(doc.creatures["160101"]!.hitEnemy).toEqual([160113])
        const hit160113 = doc.effects["160113"]!.lua as Record<string, any>
        expect(hit160113.TaskEffects[0]).toMatchObject({ BaseAttr: "ATK_Char", Rate: "#1" })
        expect(doc.effects["160113"]!.grow?.["1"]?.[0]).toEqual({ level: 1, value: 4.76 })

        // 1801：Buff 180121 的 Halo 指向 180122；Dot 数据与字段引用都在
        expect(doc.buffs["180122"]!.dotDatas[0]).toMatchObject({
            type: "Dot",
            damageType: "Water",
            interval: 2,
            rate: "#1",
        })
        expect(doc.buffs["180121"]!.haloBuffIds).toEqual([180122])
        expect(doc.skills["180102"]!.lua.fieldRefs.some(group => group.refs.some(ref => ref.kind === "Buff" && ref.id === 180122))).toBe(
            true
        )
        expect(doc.buffs["180122"]!.grow?.["1"]?.[0]).toEqual({ level: 1, value: 3.49 })

        // 2401：单位来自 CreateUnit；效果来自字段引用；被动保留原文字段
        expect(doc.units["240101"]).toBeDefined()
        expect(doc.units["240101"]!.skillIds).toEqual([240131])
        expect(doc.units["240101"]!.passiveEffectIds).toEqual([240102])
        expect(doc.units["240101"]!.gamePlayTags).toContain("Player.Summon")
        expect(doc.effects["240141"]).toBeDefined()
        expect(
            doc.skills["240101"]!.lua.fieldRefs.some(group => group.refs.some(ref => ref.kind === "SkillEffects" && ref.id === 240141))
        ).toBe(true)
        expect((doc.passives["240102"]!.lua as Record<string, any>).Vars.BaseIntervalTime).toBeDefined()

        // 3202：实体命中同时产生伤害与 AddBuff
        expect(doc.creatures["320202"]!.hitEnemy).toEqual([320236])
        const hit320236 = doc.effects["320236"]!.lua as Record<string, any>
        expect(hit320236.TaskEffects.some((task: Record<string, any>) => task.Function === "Damage")).toBe(true)
        expect(hit320236.TaskEffects.some((task: Record<string, any>) => task.Function === "AddBuff")).toBe(true)

        // 3301：Q 创建 330111 实体，但 E 的 node effect 不能被当成 Q 的边
        expect(doc.creatures["330111"]!.realDestroyEffectIds).toContain(330123)
        expect(doc.creatures["330112"]!.loop!.effectIds).toContain(330125)
        expect(doc.skills["330102"]!.lua.effects.some(effect => effect.id === 330111)).toBe(false)
        expect(doc.effects["330111"]!.sources.every(source => source.skillId !== 330102)).toBe(true)

        // 4202：HitScene 与循环效果
        expect(doc.creatures["420202"]!.hitScene).toEqual(expect.arrayContaining([420223, 420222, 420225]))
        expect(doc.creatures["420202"]!.loop!.effectIds).toContain(420224)

        // 4301：CreatureEffects 与 Loop 链；无深度上限
        expect(doc.creatures["430111"]!.creatureEffectIds).toEqual([430112])
        expect(doc.creatures["430111"]!.loop!.effectIds).toEqual([430114])
        expect(doc.creatures["430112"]!.loop!.effectIds).toEqual([430113])
        expect(doc.coverage.depthLimitHits).toBe(0)

        // 5101：单位与同名 SkillCreature 只作为 conventionRefs；实体行为仍导出
        expect(doc.units["510101"]).toBeDefined()
        expect(doc.units["510101"]!.sameIdCreatureId).toBe(510101)
        expect(
            doc.coverage.conventionRefs.some(
                ref => ref.kind === "Unit" && ref.id === 510101 && ref.relatedKind === "SkillCreature" && ref.relatedId === 510101
            )
        ).toBe(true)
        expect(doc.creatures["510101"]!.hitEnemy).toEqual([510126, 510127])

        // 覆盖计数与显式缺口
        expect(doc.coverage.effectsTotal).toBe(Object.keys(doc.effects).length)
        expect(doc.coverage.creaturesTotal).toBe(Object.keys(doc.creatures).length)
        expect(doc.coverage.unitsTotal).toBe(Object.keys(doc.units).length)
        expect(doc.coverage.fieldRefsTotal).toBeGreaterThan(0)
        // 当前真实数据没有字段引用缺口；图遍历的缺行单独记录。
        expect(doc.coverage.fieldRefsUnresolved).toBe(0)
        expect(doc.coverage.unresolvedRefs.length).toBeGreaterThan(0)
        for (const ref of doc.coverage.unresolvedRefs) {
            expect(["missing-row", "task-index-out-of-range", "unknown-namespace"]).toContain(ref.reason)
        }
    })

    test("v2 BP 展平：B 组 5 角色的 blueprintActions 与缺口", async () => {
        const doc = await buildDoc()

        // 1102 Q：BP_Buff_110202 只有后处理/材质调用 → 已展平且没有可证明的动作
        expect(doc.skills["110202"]!.blueprintActions).toEqual([])

        // 1502 Q：字面量 AddBuffToTarget（150231）与 ExecuteSkillEffects 数组
        const nifuQ = doc.skills["150202"]!
        expect(nifuQ.blueprintActions).toContainEqual(expect.objectContaining({ kind: "applyBuff", buffId: 150231, duration: -1 }))
        const nifuEffects = nifuQ.blueprintActions!.flatMap(action => (action.kind === "executeEffects" ? action.effectIds : []))
        expect(nifuEffects).toEqual(expect.arrayContaining([150231, 150232]))

        // 1503 E：AddBuff 字面量 + GenDamageWithType（rate/效果数组来自运行期局部，显式为空）
        const kezhouE = doc.skills["150301"]!
        expect(kezhouE.blueprintActions).toContainEqual(expect.objectContaining({ kind: "applyBuff", buffId: 150312 }))
        const kezhouDamage = kezhouE.blueprintActions!.find(action => action.kind === "damage")
        expect(kezhouDamage).toMatchObject({ kind: "damage", damageType: "Light", rate: null, damageTags: ["Dot"], applied: true })

        // 3102 E：字面量 AddBuff + RemoveBuff
        const xierE = doc.skills["310201"]!
        expect(xierE.blueprintActions).toContainEqual(expect.objectContaining({ kind: "applyBuff", buffId: 310203 }))
        expect(xierE.blueprintActions).toContainEqual(expect.objectContaining({ kind: "removeBuff", buffId: 310204 }))

        // 5102 Q：字面量 AddBuff + CreateCreature（creature id 经被调函数执行的效果行解析）
        const aoteQ = doc.skills["510202"]!
        expect(aoteQ.blueprintActions).toContainEqual(expect.objectContaining({ kind: "applyBuff", buffId: 510222, count: 1 }))
        const creature = aoteQ.blueprintActions!.find(action => action.kind === "createCreature")
        expect(creature).toMatchObject({ kind: "createCreature", creatureIds: [510201] })
        expect(creature!.kind === "createCreature" ? creature!.effectIds : null).toEqual(expect.arrayContaining([510231, 510232]))

        // 非 B 组角色不做展平：字段缺失区分于「展平后为空」
        expect(doc.skills["410102"]!.blueprintActions).toBeUndefined()

        // 不可求值项逐条记录（含被调函数缺失与局部 BuffId）
        const reasons = doc.coverage.blueprintUnresolved.map(ref => ref.reason)
        expect(reasons).toEqual(expect.arrayContaining(["local-function-unresolved", "buff-id-unresolved", "damage-rate-unresolved"]))
        for (const ref of doc.coverage.blueprintUnresolved) {
            if (ref.reason === "blueprint-not-available") continue
            expect(Object.keys(doc.blueprints)).toContain(ref.bpPackage)
            expect(ref.nodeId.length).toBeGreaterThan(0)
        }
    })

    test("E3：blueprintActions 引用的效果/实体/增益全部导出（5102/1502/1503/3102/150303）", async () => {
        const doc = await buildDoc()

        // 5102 Q：CreateCreature 的 creature 510201 与命中链 510233
        const aote = doc.creatures["510201"]!
        expect(aote.hitEnemy).toEqual([510233])
        expect(aote.referencedBySkills).toEqual(expect.arrayContaining([510202]))
        for (const effectId of [510231, 510232]) {
            const effect = doc.effects[String(effectId)]!
            expect(effect).toBeDefined()
            expect(effect.lua.TaskEffects).toEqual([
                expect.objectContaining({ Function: "CreateSkillCreature", CreatureId: 510201 }),
            ])
            // 来源带 BP 包/函数/节点，可回溯到 CreateCreature 调用。
            expect(effect.sources).toContainEqual(
                expect.objectContaining({
                    relation: "bp.createCreature.effect",
                    bp: expect.objectContaining({
                        bpPackage: expect.stringContaining("BP_Aote_Passive"),
                        nodeId: expect.stringContaining("#"),
                    }),
                })
            )
        }
        expect(doc.effects["510233"]).toBeDefined()
        expect(doc.buffs["510212"]!.sources).toContainEqual(
            expect.objectContaining({
                relation: "bp.removeBuff",
                bp: expect.objectContaining({ function: "ExecuteUbergraph_BP_Aote_Passive" }),
            })
        )

        // 1502：ExecuteSkillEffects 字面量 150231/150232 与 AddBuffToTarget 150231
        expect(doc.effects["150231"]).toBeDefined()
        expect(doc.effects["150232"]).toBeDefined()
        expect(doc.buffs["150231"]!.sources.some(entry => entry.relation === "bp.applyBuff")).toBe(true)

        // 1503：CreateSword 执行 150344，其 CreateSkillCreature 指向 150333
        expect(doc.effects["150344"]!.lua.TaskEffects).toContainEqual(
            expect.objectContaining({ Function: "CreateSkillCreature", CreatureId: 150333 })
        )
        expect(doc.creatures["150333"]!.hitEnemy).toEqual([150345])
        // 150303：removeBuff 字面量 150371–150374
        for (const buffId of [150371, 150372, 150373, 150374]) {
            expect(doc.buffs[String(buffId)]!.sources).toContainEqual(
                expect.objectContaining({
                    relation: "bp.removeBuff",
                    bp: expect.objectContaining({ bpPackage: expect.stringContaining("BP_Buff_150301") }),
                })
            )
        }

        // 3102：ExecuteSkillEffects 310204（CreateUnit 310201）与 310213
        expect(doc.effects["310204"]!.lua.TaskEffects).toContainEqual(
            expect.objectContaining({ Function: "CreateUnit", UnitId: 310201 })
        )
        expect(doc.effects["310213"]).toBeDefined()
        expect(doc.units["310201"]).toBeDefined()

        // 真实数据里 BP 种子全部解析到原始行；缺失应显式进入 blueprintUnresolved。
        expect(doc.coverage.blueprintUnresolved.some(ref => ref.reason === "seed-row-missing")).toBe(false)
    })

    test("重复构建结果稳定（进程级 memo + DuckDB 命中）", async () => {        const first = await buildDoc()
        const second = await buildDoc()
        expect(second.skills["410102"]!.montage).toEqual(first.skills["410102"]!.montage)
        expect(second.animBPs).toEqual(first.animBPs)
        // 第二次构建不应新增资产加载：所有请求都命中已有 memo/缓存。
        expect(second.coverage.assets.fmodelLoads).toBe(first.coverage.assets.fmodelLoads)
        expect(second.coverage.assets.bytecodeLoads).toBe(first.coverage.assets.bytecodeLoads)
    })

    test("bytecode 缓存命中时不再 spawn（stub 只收到一次请求）", async () => {
        const log = join(workDir(), "requests.log")
        const cache = new UAssetCache(join(workDir(), "bytecode.duckdb"))
        openCaches.push(cache)
        const server = new UAssetServer("unused", "EM/Content", cache, {
            timeoutMs: 5000,
            command: [process.execPath, STUB, "--fixture", FIXTURE, "--log", log],
        })
        openServers.push(server)
        const asset = join(workDir(), "Synthetic.uasset")
        writeFileSync(asset, "uasset")

        await server.bytecode(asset)
        await server.bytecode(asset)
        await server.bytecode(asset)

        const bytecodeRequests = readLog(log).filter(entry => entry.cmd === "bytecode")
        expect(bytecodeRequests).toHaveLength(1)
        expect(server.stats.bytecodeHits).toBe(2)
        expect(server.stats.bytecodeLoads).toBe(1)
    })

    test("解析失败进入 blueprintsFailed，不产出空文档", async () => {
        const cache = new UAssetCache(join(workDir(), "fail.duckdb"))
        openCaches.push(cache)
        const server = new UAssetServer("unused", "EM/Content", cache, {
            timeoutMs: 5000,
            command: [process.execPath, STUB, "--fixture", FIXTURE, "--fail"],
        })
        openServers.push(server)
        const asset = join(workDir(), "Broken.uasset")
        writeFileSync(asset, "uasset")

        await expect(server.bytecode(asset)).rejects.toThrow("bytecode 解析失败")
        expect(server.stats.bytecodeLoads).toBe(1)
    })
})

describe("语言无关输出通道", () => {
    test("addNeutral 只写 final 一次，不按语言渲染", () => {
        const collector = new OutputCollector()
        collector.add("Char.json", { id: 1 })
        collector.addNeutral("skill-behavior.json", { schemaVersion: 1, skills: { 410102: { id: 410102 } } })

        const dir = workDir()
        const written = collector.writeAll(dir, ["cn", "en"] as any, textmap)
        expect(written).toHaveLength(3)
        expect(existsSync(join(dir, "i18n", "cn", "Char.json"))).toBe(true)
        expect(existsSync(join(dir, "i18n", "en", "Char.json"))).toBe(true)
        expect(existsSync(join(dir, "skill-behavior.json"))).toBe(true)
        expect(existsSync(join(dir, "i18n", "cn", "skill-behavior.json"))).toBe(false)
        const parsed = JSON.parse(readFileSync(join(dir, "skill-behavior.json"), "utf8"))
        expect(parsed.schemaVersion).toBe(1)
    })
})
