/** ExtraExcelWeapon module - 溢渗武器解锁材料。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

function rows(ctx: ModuleContext): Record<string, any>[] {
    const table = ctx.dm.getTable("ExcelWeaponExpandItem")
    return table && typeof table === "object" ? (Object.values(table).filter(v => v && typeof v === "object") as Record<string, any>[]) : []
}

export function extraExcelWeaponModule(ctx: ModuleContext): VNodeTree {
    const result: VNodeTree[] = []
    for (const item of rows(ctx)) {
        const weaponTag = typeof item.WeaponTag === "string" ? item.WeaponTag : ""
        const itemIds = Array.isArray(item.ItemId) ? item.ItemId : []
        const itemNums = Array.isArray(item.ItemNum) ? item.ItemNum : []
        if (!weaponTag || itemIds.length === 0 || itemNums.length === 0) continue

        const consume: Record<string, number> = {}
        for (let i = 0; i < Math.min(itemIds.length, itemNums.length); i++) {
            const id = Number(itemIds[i])
            const count = Number(itemNums[i])
            if (Number.isInteger(id) && Number.isFinite(count)) consume[String(id)] = count
        }
        if (Object.keys(consume).length === 0) continue

        result.push({
            id: weaponTag,
            名称: T(`WeaponType_${weaponTag}`),
            消耗: consume,
        })
    }
    return result
}
