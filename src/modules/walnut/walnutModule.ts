/** Walnut module - 输出委托密函数据。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

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
        const access = Array.isArray(item.AccessKey) ? item.AccessKey.map((key: unknown) => accessMap[String(key)] ?? String(key)) : []
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
