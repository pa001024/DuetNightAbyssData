import { describe, expect, test } from "bun:test"
import { loadPlugins } from "../src/core/plugin.ts"

describe("模块插件自动发现 (src/core/plugin.ts)", () => {
    test("发现全部模块目录 register.ts，结果确定性排序且无重名", async () => {
        const plugins = await loadPlugins()
        expect(plugins.length).toBeGreaterThan(50)
        expect(new Set(plugins.map(p => p.name)).size).toBe(plugins.length)
        expect(plugins.map(p => p.name)).toEqual([...plugins.map(p => p.name)].sort())
        for (const p of plugins) {
            expect(typeof p.name).toBe("string")
            expect(p.name.length).toBeGreaterThan(0)
            expect(typeof p.build).toBe("function")
            expect(Array.isArray(p.deps)).toBe(true)
            expect(typeof p.outputs).toBe("boolean")
            expect(typeof p.uasset).toBe("boolean")
        }
    })

    test("保留纯依赖模块与既有依赖声明", async () => {
        const plugins = await loadPlugins()
        const byName = new Map(plugins.map(p => [p.name, p]))
        expect(byName.get("Skill")?.outputs).toBe(false)
        expect(byName.get("Dialogue")?.outputs).toBe(false)
        expect(byName.get("ResourceData")?.outputs).toBe(false)
        expect(byName.get("Weapon")?.deps).toContain("Skill")
        expect(byName.get("BookSeriesArchive")?.deps).toContain("ResourceData")
        expect(byName.get("RougeLikeRoom")?.deps).toContain("Dialogue")
        expect(byName.get("RougeLikeBlessing")?.deps).toContain("Mod")
        expect(byName.get("AbyssBuff")?.outputs).toBe(true)
    })

    test("uasset 标记覆盖 AssetReader 预热模块", async () => {
        const plugins = await loadPlugins()
        const uasset = plugins.filter(p => p.uasset).map(p => p.name)
        for (const name of ["Resource", "Weapon", "Char", "Mod"]) {
            expect(uasset).toContain(name)
        }
    })
})
