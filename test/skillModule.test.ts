/**
 * M3 验收：Graph 依赖图 + skill 纯依赖模块。
 * 验证：
 * 1. Graph 拓扑排序、依赖产物读取、环检测
 * 2. skill 模块 artifacts（calcSkillDesc / explainSkillFields / resolveFieldCombatMeta）
 * 3. 一次解析 → 多语言渲染（依赖 skill 的下游模块只跑一次 build）
 */
import { describe, expect, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import type { SkillArtifacts } from "../src/modules/skill/skillModule.ts"
import { skillModule } from "../src/modules/skill/skillModule.ts"

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")
const textmap = getTextMap(baseDir)

describe("Graph", () => {
    test("拓扑排序：依赖先于依赖者", async () => {
        const g = new Graph()
        const order: string[] = []
        g.defineModule({ name: "skill", deps: [], outputs: false, build: () => ({ v: 1 }) })
        g.defineModule({ name: "weapon", deps: ["skill"], outputs: true, build: ctx => ({ from: ctx.getArtifact("skill") }) })
        g.defineModule({ name: "char", deps: ["skill"], outputs: true, build: ctx => ({ from: ctx.getArtifact("skill") }) })
        const artifacts = await g.build({}, m => order.push(m.replace("[build] ", "")))
        expect(order).toEqual(["skill", "weapon", "char"])
        expect((artifacts.get("weapon") as any).from.v).toBe(1)
        expect((artifacts.get("char") as any).from.v).toBe(1)
    })

    test("环检测", async () => {
        const g = new Graph()
        g.defineModule({ name: "a", deps: ["b"], outputs: false, build: () => ({}) })
        g.defineModule({ name: "b", deps: ["a"], outputs: false, build: () => ({}) })
        await expect(g.build({})).rejects.toThrow(/环/)
    })

    test("依赖不存在报错", async () => {
        const g = new Graph()
        g.defineModule({ name: "a", deps: ["nope"], outputs: false, build: () => ({}) })
        await expect(g.build({})).rejects.toThrow(/不存在/)
    })
})

describe("skill 模块", () => {
    test("calcSkillDesc 计算技能描述值", () => {
        const g = new Graph()
        g.defineModule({ name: "skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        return g.build({}).then(artifacts => {
            const s = artifacts.get("skill") as unknown as SkillArtifacts
            const dm = getLuaDataManager()
            const skill = dm.getTable("Skill") as any
            const values = skill["110101"][0][0].SkillDescValues as string[]
            const computed = values.map((v: string) => s.calcSkillDesc(v, 1))
            expect(computed[0]).toBe("20")
            expect(computed[1]).toMatch(/^347/)
            expect(computed[2]).toContain("3")
        })
    })

    test("explainSkillFields 生成字段（名称/值/削韧/tag）", () => {
        const g = new Graph()
        g.defineModule({ name: "skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        return g.build({}).then(artifacts => {
            const s = artifacts.get("skill") as unknown as SkillArtifacts
            const dm = getLuaDataManager()
            const skill = dm.getTable("Skill") as any
            const entry = skill["110101"][0][0]
            const fields = s.explainSkillFields(entry, 110101) as any[]
            expect(fields.length).toBeGreaterThan(0)
            // 字段名是可翻译 vnode 或字符串
            const rendered = fields.map(f => renderTree(f, "cn", textmap) as any)
            expect(rendered[0].名称.length).toBeGreaterThan(0)
            // 伤害字段有削韧（从 SkillEffects 解析）
            const damageField = rendered.find(f => f.削韧 !== undefined)
            expect(damageField).toBeDefined()
        })
    })

    test("一次解析多语言：字段名称 cn/en 不同", () => {
        const g = new Graph()
        g.defineModule({ name: "skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        return g.build({}).then(artifacts => {
            const s = artifacts.get("skill") as unknown as SkillArtifacts
            const dm = getLuaDataManager()
            const skill = dm.getTable("Skill") as any
            const entry = skill["110101"][0][0]
            const fields = s.explainSkillFields(entry, 110101) as any[]
            const cn = fields.map(f => renderTree(f, "cn", textmap) as any)
            const en = fields.map(f => renderTree(f, "en", textmap) as any)
            expect(cn[0].名称).not.toBe(en[0].名称)
            expect(cn[0].值).toBe(en[0].值) // 数值语言无关
        })
    })

    test("skillNameVNode 渲染多语言", () => {
        const g = new Graph()
        g.defineModule({ name: "skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
        return g.build({}).then(artifacts => {
            const s = artifacts.get("skill") as unknown as SkillArtifacts
            const v = s.skillNameVNode(110101)
            const cn = renderTree(v, "cn", textmap) as any
            const en = renderTree(v, "en", textmap) as any
            expect(cn.length).toBeGreaterThan(0)
            expect(en.length).toBeGreaterThan(0)
            expect(cn).not.toBe(en)
        })
    })
})
