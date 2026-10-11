import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { hardBossDataModule } from "../src/modules/hardBoss/hardBossModule.ts"

describe("HardBossData artifact（供 Walnut/Resource 复用，不自写解析）", () => {
    test("8 boss，每 boss 6 段难度，末段为最高难度", () => {
        const ctx = { dm: getLuaDataManager() } as unknown as ModuleContext
        const { bosses } = hardBossDataModule(ctx)
        expect(bosses.length).toBe(8)
        expect(bosses.map(boss => boss.id)).toEqual([1, 2, 3, 4, 5, 6, 7, 8])
        for (const boss of bosses) {
            expect(boss.difficulties.length).toBe(6)
        }
        expect(bosses.map(boss => boss.difficulties[boss.difficulties.length - 1].id)).toEqual([
            1006, 1016, 1026, 1036, 1046, 1056, 1066, 1076,
        ])
        expect(bosses[0].difficulties.map(diff => diff.id)).toEqual([1001, 1002, 1003, 1004, 1005, 1006])
    })

    test("DynamicReward 取末段（Index 最大），无轮换回退自身", () => {
        const ctx = { dm: getLuaDataManager() } as unknown as ModuleContext
        const artifact = hardBossDataModule(ctx)
        expect(artifact.dynamicRewardOf(1033)).toBe(1411033)
        expect(artifact.dynamicRewardOf(1021)).toBe(1311021)
        expect(artifact.dynamicRewardOf(999999)).toBe(999999)
        expect(artifact.lastRewards().length).toBe(8)
    })
})
