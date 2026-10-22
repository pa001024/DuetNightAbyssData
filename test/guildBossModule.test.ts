import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { guildBossModule } from "../src/modules/guildBoss/guildBossModule.ts"

function ctx(): ModuleContext {
    return { dm: getLuaDataManager() } as unknown as ModuleContext
}

describe("GuildBoss 狭义公会战", () => {
    test("4 boss / 6 buff / 12 试炼 / 3 轮换 / 6 点数档 / 5 周阶段", () => {
        const tree = guildBossModule(ctx()) as unknown as Record<string, any[]>
        expect(tree.bosses.map(b => b.id)).toEqual([8502701, 8505701, 8509701, 8512701])
        expect(tree.buffs.map(b => b.id)).toEqual([1, 2, 8502, 8505, 8509, 8512])
        expect(tree.tests.map(b => b.id)).toEqual([101, 102, 201, 202, 203, 204, 301, 302, 303, 304, 305, 306])
        expect(tree.refresh.map(b => b.id)).toEqual([1, 2, 3])
        expect(tree.pointRewards.map(b => b.id)).toEqual([101, 102, 103, 104, 105, 106])
        expect(tree.weekRewards.map(b => b.stage)).toEqual([20, 40, 60, 80, 100])
        for (const boss of tree.bosses) expect("spawn" in boss).toBe(false)
    })

    test("boss 试炼类型与 buff 对位，试炼规则为 Hit", () => {
        const tree = guildBossModule(ctx()) as unknown as Record<string, any[]>
        for (const boss of tree.bosses) {
            expect(boss.testTypes).toEqual([1, 2, 3])
            expect((boss.buffs as number[]).length).toBe(3)
        }
        for (const trial of tree.tests) {
            expect((trial.rule as Record<string, unknown>).Hit).toBeDefined()
            expect(trial.rate).toBe(2000000)
        }
        // Buff 1 经 Buff 表计算为 DEF 3000，vnode 保留 LTemplate 由渲染阶段替换
        const buff1 = tree.buffs.find(b => b.id === 1) as any
        expect(buff1.desc.__t).toBe("lt")
    })
})
