/** ExtraExcelWeapon module - 溢渗武器解锁材料。 */

import type { ModuleContext } from "../../core/Graph.ts"
import type { VNodeTree } from "../../i18n/vnode.ts"

const WEAPON_TYPE_CN: Record<string, string> = {
    Bow: "弓",
    Bow01: "弓（短弓）",
    Bow02: "弓（长弓）",
    Cannon: "榴炮",
    Claymore: "重剑",
    Crossbow: "双枪",
    Dualblade: "双刀",
    Katana: "太刀",
    Machinegun: "突击枪",
    Pistol: "手枪",
    Polearm: "长柄",
    Shotgun: "霰弹枪",
    Sword: "单手剑",
    Swordwhip: "鞭刃",
}

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
            名称: WEAPON_TYPE_CN[weaponTag] ?? weaponTag,
            消耗: consume,
        })
    }
    return result
}
