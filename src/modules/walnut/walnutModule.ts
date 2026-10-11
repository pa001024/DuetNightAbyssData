/** Walnut module - 输出委托密函数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import type { HardBossDataArtifact } from "../hardBoss/hardBossModule.ts"
import type { ShopDataArtifact } from "../shop/shopDataModule.ts"

function toInt(value: unknown): number | undefined {
    if (typeof value === "number" && Number.isInteger(value)) return value
    if (typeof value !== "string" || !/^-?\d+$/.test(value.trim())) return undefined
    return Number(value)
}

function normalizeList(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return value === undefined || value === null ? [] : [value]
    const entries = Object.entries(value as Record<string, unknown>)
        .map(([key, item]) => [Number(key), item] as const)
        .filter(([key]) => Number.isInteger(key) && key > 0)
        .sort(([a], [b]) => a - b)
    if (entries.length === 0) return []
    const result: unknown[] = []
    for (const [index, item] of entries) result[index - 1] = item
    return result
}

/**
 * 奖励嵌套中收集密函 id（Reward 类型递归，Walnut 类型收集；Resource/Drop 等与密函无关，跳过）。
 * 环截断并按顶层 RewardId 记忆化。
 */
export function createWalnutResolver(
    rewardTable: Record<string, unknown> | undefined,
    walnutTable: Record<string, unknown> | undefined
): (rewardId: number) => Set<number> {
    const memo = new Map<number, Set<number>>()
    const resolve = (rewardId: number, seen: Set<number>): Set<number> => {
        const cached = memo.get(rewardId)
        if (cached) return cached
        const result = new Set<number>()
        memo.set(rewardId, result)
        if (seen.has(rewardId)) return result
        seen.add(rewardId)
        const reward = rewardTable?.[rewardId] as Record<string, unknown> | undefined
        if (reward && typeof reward === "object") {
            const ids = normalizeList(reward.Id)
            const types = normalizeList(reward.Type)
            for (let i = 0; i < types.length; i++) {
                if (types[i] !== "Reward" && types[i] !== "Walnut") continue
                const id = toInt(ids[i])
                if (id === undefined) continue
                if (types[i] === "Walnut") {
                    if (walnutTable?.[id] !== undefined) result.add(id)
                } else {
                    for (const walnutId of resolve(id, seen)) result.add(walnutId)
                }
            }
        }
        seen.delete(rewardId)
        return result
    }
    return (rewardId: number) => resolve(rewardId, new Set<number>())
}

/** 副本掉落引用的密函：Dungeon.DropReward 的 Mon.Reward.* →奖励传递→密函（用户确认：副本基本没有）。 */
export function dungeonWalnutIds(ctx: ModuleContext, resolve: (rewardId: number) => Set<number>): Set<number> {
    const result = new Set<number>()
    const walnutTable = ctx.dm.getTable("Walnut") as Record<string, unknown> | undefined
    const table = ctx.dm.getTable("Dungeon") as Record<string, unknown> | undefined
    if (!table || typeof table !== "object") return result
    for (const row of Object.values(table)) {
        if (!row || typeof row !== "object") continue
        const drop = (row as Record<string, unknown>).DropReward
        if (!drop || typeof drop !== "object") continue
        for (const [key, value] of Object.entries(drop as Record<string, unknown>)) {
            if (!key.startsWith("Mon.Reward")) continue
            const id = toInt(value)
            if (id === undefined) continue
            if (walnutTable?.[id] !== undefined) result.add(id)
            else for (const walnutId of resolve(id)) result.add(walnutId)
        }
    }
    return result
}

/** 梦魇残声引用的密函：HardBossData artifact 的末段奖励（已过 DynamicReward），经奖励传递解析。 */
export function hardBossWalnutIds(
    artifact: Pick<HardBossDataArtifact, "lastRewards">,
    resolve: (rewardId: number) => Set<number>
): Set<number> {
    const result = new Set<number>()
    for (const rewardId of artifact?.lastRewards() ?? []) {
        for (const walnutId of resolve(rewardId)) result.add(walnutId)
    }
    return result
}

/** 密函获取途径过滤（保序）：Return 项按实际引用判定展示；其余（Abyss 等暂无可验证来源）保持展示。 */
export function filterWalnutAccess(
    keys: string[],
    sets: { dungeon: Set<number>; shop: Set<number>; abyssShop: Set<number>; hardBoss: Set<number> },
    id: number
): string[] {
    return keys.filter(key => {
        switch (key) {
            case "Dungeon":
                return sets.dungeon.has(id)
            case "Shop_Main":
                return sets.shop.has(id)
            case "Shop_Abyss":
                return sets.abyssShop.has(id)
            case "HardBoss":
                return sets.hardBoss.has(id)
            default:
                return true
        }
    })
}

function tableRow(table: unknown, id: unknown): Record<string, any> | undefined {
    if (!table || typeof table !== "object") return undefined
    const rows = table as Record<string, any>
    return rows[String(id)] ?? rows[id as number]
}

function resourceNode(ctx: ModuleContext, id: number, type: string, count: number): Record<string, VNodeTree> {
    const resource: Record<string, VNodeTree> = { id, type, count }
    if (type === "Resource") {
        const row = tableRow(ctx.dm.getTable("Resource"), id)
        if (row?.ResourceName) resource.name = T(row.ResourceName)
    } else if (type === "Draft") {
        const draft = tableRow(ctx.dm.getTable("Draft"), id)
        const productType = String(draft?.ProductType ?? "")
        const productId = Number(draft?.ProductId ?? 0)
        if (productType === "Weapon") {
            const weapon = tableRow(ctx.dm.getTable("Weapon"), productId)
            if (weapon?.WeaponName) {
                resource.id = weapon.WeaponId ?? productId
                resource.name = T(weapon.WeaponName)
                resource.type = "Weapon"
                resource.d = 1
            }
        } else if (productType === "Mod") {
            const mod = tableRow(ctx.dm.getTable("Mod"), productId)
            if (mod?.Name) {
                resource.id = mod.Id ?? productId
                resource.name = T(mod.Name)
                resource.type = "Mod"
                resource.d = 1
            }
        }
    }
    return resource
}

function countAt(counts: unknown, index: number): number {
    if (!Array.isArray(counts) || index >= counts.length) return 1
    const value = Array.isArray(counts[index]) ? counts[index][0] : counts[index]
    return Number(value ?? 1)
}

export function walnutModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("Walnut") as Record<string, any>) || {}
    const result: VNodeTree[] = []
    const accessMap: Record<string, string> = {
        Dungeon: "副本",
        Shop_Main: "委托密函商店",
        Shop_Abyss: "观剧纪念",
        HardBoss: "梦魇残声",
        Abyss: "沉浸式戏剧",
    }
    // Return 类获取途径按实际引用过滤（各集合每构建一次复用）。
    // 商店体系由 Access 表 AccessParam 指定（如 Shop_Main→Shop），在售集合来自 ShopData artifact。
    const accessTable = ctx.dm.getTable("Access") as Record<string, unknown> | undefined
    const shopSystemOf = (key: string): string | undefined => {
        const param = (accessTable?.[key] as Record<string, unknown> | undefined)?.AccessParam
        return typeof param === "string" && param ? param : undefined
    }
    const resolveWalnut = createWalnutResolver(
        ctx.dm.getTable("Reward") as Record<string, unknown> | undefined,
        ctx.dm.getTable("Walnut") as Record<string, unknown> | undefined
    )
    const hardboss = ctx.getArtifact<HardBossDataArtifact>("HardBossData")
    const shopData = ctx.getArtifact<ShopDataArtifact>("ShopData")
    const shopSets = shopData?.walnutsBySystem ?? new Map<string, Set<number>>()
    const sets = {
        dungeon: dungeonWalnutIds(ctx, resolveWalnut),
        shop: shopSets.get(shopSystemOf("Shop_Main") ?? "") ?? new Set<number>(),
        abyssShop: shopSets.get(shopSystemOf("Shop_Abyss") ?? "") ?? new Set<number>(),
        hardBoss: hardboss ? hardBossWalnutIds(hardboss, resolveWalnut) : new Set<number>(),
    }
    for (const item of Object.values(table)) {
        if (!item || typeof item !== "object") continue
        const id = Number(item.WalnutId ?? 0)
        if (!id) continue
        const ids = Array.isArray(item.Id) ? item.Id : []
        const types = Array.isArray(item.Type) ? item.Type : []
        const rewards: VNodeTree[] = []
        for (let i = 0; i < ids.length; i++) {
            const type = String(types[i] ?? "Resource")
            rewards.push(resourceNode(ctx, Number(ids[i] ?? 0), type, countAt(item.Count, i)))
        }
        const rawKeys = Array.isArray(item.AccessKey) ? item.AccessKey.map((key: unknown) => String(key)) : []
        const access = filterWalnutAccess(rawKeys, sets, id).map(key => accessMap[key] ?? key)
        result.push({
            id,
            名称: T(item.Name ?? ""),
            获取途径: access,
            奖励: rewards,
            稀有度: item.Rarity ?? 0,
            模式: item.Mode ?? "",
            参数: item.Param ?? [],
            类型: item.WalnutType ?? 0,
        })
    }
    result.sort((a, b) => Number((a as Record<string, unknown>).id ?? 0) - Number((b as Record<string, unknown>).id ?? 0))
    return result
}
