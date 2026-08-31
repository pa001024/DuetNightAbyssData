import { getLuaDataManager } from "./src/lua/LuaDataManager.ts"

const dm = getLuaDataManager()
// 直接调用 lua 引擎的 CalcWeaponPassiveEffectsDesc，传入 WeaponData
const bw = dm.getTable("BattleWeapon") as any
const entry = bw["10107"]
// 构造 WeaponData（含 WeaponId + GradeLevel）
const weaponData = { WeaponId: 10107, GradeLevel: 0 }
try {
    const r = dm.callSkillUtilsTableFn("CalcWeaponPassiveEffectsDesc", [weaponData, 1])
    console.log("grade1:", JSON.stringify(r))
    const r2 = dm.callSkillUtilsTableFn("CalcWeaponPassiveEffectsDesc", [weaponData, 2])
    console.log("grade2:", JSON.stringify(r2))
    const r6 = dm.callSkillUtilsTableFn("CalcWeaponPassiveEffectsDesc", [weaponData, 6])
    console.log("grade6:", JSON.stringify(r6))
} catch (e) {
    console.log("ERR:", (e as Error).message)
}
