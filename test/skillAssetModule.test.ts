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
import { buildSkillAssetDoc } from "../src/modules/skillAsset/skillAssetModule.ts"
import { SKILL_BEHAVIOR_SCHEMA_VERSION } from "../src/modules/skillAsset/types.ts"

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
        700: { ID: 700, BPPath: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_Test.BP_Test" },
    }
    const tables = {
        skillNode: (id: number | string) => nodeTable[String(id)],
        skillEffect: (id: number | string) => effectTable[String(id)],
        passiveEffect: (id: number | string) => passiveTable[String(id)],
        bpAddBuff: { BP_Test: [601, 602] },
    }
    const skillTable: Record<string, unknown> = {
        1: [{ "0": { SkillId: 1, SkillType: "Skill1", BeginNodeId: 100, PassiveEffects: [700] } }],
    }
    const dm = {
        getTableItem: (table: string, id: number | string) => (table === "Skill" ? skillTable[String(id)] : undefined),
    } as any

    test("沿主链/分支收集节点、effect、Buff、PassiveEffect 与 BPAddBuff 静态映射", () => {
        const evidence = collectSkillEvidence(dm, 1, tables)
        expect(evidence).not.toBeNull()
        expect(evidence!.nodes.map(node => node.id)).toEqual([100, 101, 102, 103])
        expect(evidence!.effects.map(effect => effect.id)).toEqual([10, 11, 12, 13])
        expect(evidence!.buffIds).toEqual([500, 501, 502, 601, 602])
        expect(evidence!.passiveIds).toEqual([700])
        expect(evidence!.passiveEffectBPs).toEqual([
            { id: 700, path: "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Player/BP_Test.BP_Test" },
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
    })

    test("重复构建结果稳定（进程级 memo + DuckDB 命中）", async () => {
        const first = await buildDoc()
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
