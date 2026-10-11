import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"
import { hardBossDataModule } from "../src/modules/hardBoss/hardBossModule.ts"
import { isShopItemAvailableAtTime, shopDataModule } from "../src/modules/shop/shopDataModule.ts"
import {
    createWalnutResolver,
    dungeonWalnutIds,
    filterWalnutAccess,
    hardBossWalnutIds,
} from "../src/modules/walnut/walnutModule.ts"

function fakeCtx(): ModuleContext {
    return { dm: getLuaDataManager() } as unknown as ModuleContext
}

describe("ShopData artifact（商店在售，时间口径对齐前端 DBShopDetailItem.vue）", () => {
    test("起止缺失视为无界，结束取严格小于", () => {
        expect(isShopItemAvailableAtTime({}, 100)).toBe(true)
        expect(isShopItemAvailableAtTime({ startTime: 100 }, 100)).toBe(true)
        expect(isShopItemAvailableAtTime({ startTime: 101 }, 100)).toBe(false)
        expect(isShopItemAvailableAtTime({ endTime: 100 }, 100)).toBe(false)
        expect(isShopItemAvailableAtTime({ endTime: 101 }, 100)).toBe(true)
        expect(isShopItemAvailableAtTime({ startTime: 50, endTime: 60 }, 100)).toBe(false)
    })

    test("真实数据：主商店体系在售密函（售卖物在 TypeId）", () => {
        const data = shopDataModule(fakeCtx())
        const shop = data.walnutsBySystem.get("Shop") ?? new Set<number>()
        // 1000（1801 常驻，无结束时间）稳定在售；注意 Walnut 商品卖的是 TypeId（条目号在 ItemId）
        expect(shop.has(1000)).toBe(true)
        // 1010 在商店无售货行
        expect(shop.has(1010)).toBe(false)
    })
})

describe("Walnut 奖励传递闭包", () => {
    test("嵌套/直接/忽略非密函/成环", () => {
        const rewardTable = {
            1: { Id: [2003], Type: ["Walnut"] },
            2: { Id: [1], Type: ["Reward"] },
            3: { Id: [10], Type: ["Resource"] },
            4: { Id: [5], Type: ["Drop"] },
            5: { Id: [6], Type: ["Reward"] },
            6: { Id: [5], Type: ["Reward"] },
            7: { Id: [9999], Type: ["Walnut"] },
        }
        const walnutTable = { 2003: {} }
        const resolve = createWalnutResolver(rewardTable, walnutTable)
        expect([...resolve(1)]).toEqual([2003])
        expect([...resolve(2)]).toEqual([2003])
        expect([...resolve(3)]).toEqual([])
        expect([...resolve(4)]).toEqual([])
        expect([...resolve(999)]).toEqual([])
        expect([...resolve(5)]).toEqual([])
        // 非密函表 id 不收集
        expect([...resolve(7)]).toEqual([])
    })

    test("真实数据：hardboss 取末段轮换奖励", () => {
        const ctx = fakeCtx()
        const artifact = hardBossDataModule(ctx)
        expect(artifact.bosses.length).toBe(8)
        // DynamicReward 按 Index 取末段（如 1033→1411033）；无轮换回退自身
        expect(artifact.dynamicRewardOf(1033)).toBe(1411033)
        expect(artifact.dynamicRewardOf(1021)).toBe(1311021)
        expect(artifact.dynamicRewardOf(999999)).toBe(999999)
        const last = artifact.lastRewards()
        expect(last.length).toBe(8)
        expect(last).toContain(1411033)
        const resolve = createWalnutResolver(
            ctx.dm.getTable("Reward") as Record<string, unknown>,
            ctx.dm.getTable("Walnut") as Record<string, unknown>
        )
        const ids = hardBossWalnutIds(artifact, resolve)
        // 末段含 2060；静态末段（1021）的 2039 已被轮换，不在集合
        expect(ids.has(2060)).toBe(true)
        expect(ids.has(2039)).toBe(false)
    })

    test("真实数据：副本基本没有密函", () => {
        const ctx = fakeCtx()
        const resolve = createWalnutResolver(
            ctx.dm.getTable("Reward") as Record<string, unknown>,
            ctx.dm.getTable("Walnut") as Record<string, unknown>
        )
        expect(dungeonWalnutIds(ctx, resolve).size).toBe(0)
    })
})

describe("Walnut 获取途径过滤", () => {
    test("保序且按实际引用过滤", () => {
        const sets = { dungeon: new Set<number>(), shop: new Set([1]), abyssShop: new Set<number>(), hardBoss: new Set([1]) }
        expect(filterWalnutAccess(["Dungeon", "Shop_Main", "Shop_Abyss", "HardBoss", "Abyss"], sets, 1)).toEqual([
            "Shop_Main",
            "HardBoss",
            "Abyss",
        ])
    })
})
