import { getLuaDataManager } from "./src/lua/LuaDataManager.ts"

const dm = getLuaDataManager()
const bw = dm.getTable("BattleWeapon") as any
for (const id of [10102, 10107, 10201, 10208, 10299]) {
    const entry = bw[String(id)] ?? bw[id]
    if (!entry) { console.log(id, "NO ENTRY"); continue }
    const values = entry.PassiveEffectsDescValues ?? []
    console.log(`\n=== weapon ${id} PassiveEffectsDescValues =`, JSON.stringify(values))
    for (const grade of [1, 2, 6]) {
        const out = []
        for (const dv of values) {
            if (typeof dv !== "string") { out.push(`<non-string ${typeof dv}>`); continue }
            try {
                const r = dm.calcSkillDesc(dv, grade)
                out.push(r)
            } catch (e) { out.push(`ERR ${(e as Error).message}`) }
        }
        console.log(`  grade${grade}:`, JSON.stringify(out))
    }
}
