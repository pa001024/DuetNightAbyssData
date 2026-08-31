/**
 * M1 验收：LuaDataManager 懒加载 + 游戏 SkillUtils 计算。
 * 验证：
 * 1. DataMgr.Skill[110101][1][0].SkillName 与 out/Skill.json 一致
 * 2. calcSkillDesc 对 110101 的三个 desc value 算出数值（含 GText 哨兵）
 * 3. 懒加载缓存正确（loadedTableNames）
 */
import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { LuaDataManager, getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { GT_RE } from "../src/lua/stubs.ts"

setDefaultTimeout(15000)

describe("LuaDataManager", () => {
    test("DataMgr.Skill[110101] 数字键访问 + 字段一致", () => {
        const dm = getLuaDataManager()
        const skill = dm.getTable("Skill") as { [k: string]: any }
        expect(skill).toBeDefined()
        const entry = skill["110101"]
        expect(entry).toBeDefined()
        const skillInfo = entry[0][0]
        expect(skillInfo.SkillName).toBe("SKILL_110101_NAME")
        expect(skillInfo.SkillDesc).toBe("SKILL_110101_DESC")
        expect(skillInfo.SkillType).toBe("Skill1")
        expect(skillInfo.BeginNodeId).toBe(110111)
    })

    test("calcSkillDesc 计算数值（347% / 20 / 3.0米）", () => {
        const dm = getLuaDataManager()
        const skill = dm.getTable("Skill") as { [k: string]: any }
        const skillInfo = skill["110101"][0][0]
        const values = skillInfo.SkillDescValues as string[]
        expect(Array.isArray(values)).toBe(true)

        const results = values.map((v: string) => dm.calcSkillDesc(v, 1))
        // 第一个：$#SkillNode[110111].CostSp$ -> 20
        expect(results[0]).toBe("20")
        // 第二个：$#SkillEffects[110114].TaskEffects[1].Rate*100$% -> 347.0%
        expect(results[1]).toMatch(/^347/)
        // 第三个：半径/100 + GText("SKILL_DESC_Meter") -> 3.0 + 哨兵
        expect(results[2]).toContain("3")
        const matches = [...results[2].matchAll(GT_RE)]
        expect(matches.length).toBeGreaterThan(0)
        expect(matches[0][1]).toBe("SKILL_DESC_Meter")
    })

    test("GetSkillName 返回翻译 key", () => {
        const dm = getLuaDataManager()
        expect(dm.getSkillNameKey(110101)).toBe("SKILL_110101_NAME")
    })

    test("懒加载缓存：访问过 Skill 后 loadedTableNames 含 Skill", () => {
        const dm = getLuaDataManager()
        dm.getTable("Skill")
        expect(dm.loadedTableNames).toContain("Skill")
    })

    test("按项读取 Skill 不会要求调用方物化整表", () => {
        const dm = new LuaDataManager()
        expect(dm.loadedTableNames).toEqual([])
        expect(dm.materializedTableNames).toEqual([])
        const item = dm.getTableItem("Skill", 110101) as any
        expect(item?.[0]?.[0]?.SkillName).toBe("SKILL_110101_NAME")
        expect(dm.loadedTableNames).toContain("Skill")
        expect(dm.materializedTableNames).not.toContain("Skill")
        expect(dm.findTableKeysByPath("Skill", [1, 0, "SkillType"], "Skill1").length).toBeGreaterThan(0)
        expect(Array.isArray(dm.findTableKeysByTaskField("SkillEffects", "LoopShootId", 150402))).toBe(true)
    })

    test("按 key 批量读取 Skill 只物化请求项", () => {
        const dm = new LuaDataManager()
        const rows = dm.getTableItems("Skill", ["110101", 110102, 999999999])
        expect(rows.get("110101")).toBeDefined()
        expect(rows.get("110102")).toBeDefined()
        expect(rows.has("999999999")).toBe(false)
        expect(dm.materializedTableNames).not.toContain("Skill")
    })

    test("召唤物效果索引在 Lua 内构建并返回 ID", () => {
        const dm = getLuaDataManager()
        const ids = dm.findSummonEffectIds()
        expect(ids).toContain(600401)
        expect(ids).toContain(210263)
    })

    test("Lua 表可直接读取（Fish）", () => {
        const dm = getLuaDataManager()
        const fish = dm.getTable("Fish") as any
        expect(fish).toBeDefined()
    })

    test("稀疏数字键表保持对象形状", () => {
        const dm = getLuaDataManager()
        const skill = dm.getTable("Skill") as { [k: string]: any }
        const hints = skill[120102][0][0].SkillDescHints
        expect(Array.isArray(hints)).toBe(false)
        expect(hints["9"]).toEqual(["SkillSustain"])
    })

    test("按任务字段查询支持整数 ID", () => {
        const dm = new LuaDataManager()
        const keys = dm.findTableKeysByTaskField("SkillEffects", "LoopShootId", 20305)
        expect(keys).toContain(2030519)
    })
})
