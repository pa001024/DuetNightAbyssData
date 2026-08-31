import { getLuaDataManager } from "./src/lua/LuaDataManager.ts"

const dm = getLuaDataManager()
// 直接调 lua 的两个核心函数
const template = "昂扬+<H>#1</>。暗属性角色造成伤害时，每有1点连击点数，造成的伤害提高<H>{float4}#2</>。消耗连击点数后，昂扬提高[<H>{float4}#3</>×消耗量]，持续<H>#4</>秒。"

// 测 ReplaceAndChekDescValueCast 对每个 index
for (let i = 1; i <= 4; i++) {
    const result = dm.callSkillUtilsTableFn("ReplaceAndChekDescValueCast", [template, i])
    const [newDesc, castTo] = Array.isArray(result) ? result : [undefined, undefined]
    console.log(`idx${i}: castTo=${JSON.stringify(castTo)}`)
    if (i === 2) console.log(`  newDesc(含idx2剥离):`, JSON.stringify(newDesc))
}

// 测 FormatDescValue1：float4 + %
console.log("FormatDescValue1('0.2%', {float,4}) =", JSON.stringify(dm.callSkillUtilsTableFn("FormatDescValue1", ["0.2%", ["float", "4"]])))
console.log("FormatDescValue1('0.25%', {float,4}) =", JSON.stringify(dm.callSkillUtilsTableFn("FormatDescValue1", ["0.25%", ["float", "4"]])))
console.log("FormatDescValue1('8', nil) =", JSON.stringify(dm.callSkillUtilsTableFn("FormatDescValue1", ["8", null])))
console.log("FormatDescValue1('6', nil) =", JSON.stringify(dm.callSkillUtilsTableFn("FormatDescValue1", ["6", null])))
console.log("FormatDescValue1('15.0%', nil) =", JSON.stringify(dm.callSkillUtilsTableFn("FormatDescValue1", ["15.0%", null])))
console.log("FormatDescValue1('4.32%', nil) =", JSON.stringify(dm.callSkillUtilsTableFn("FormatDescValue1", ["4.32%", null])))
console.log("FormatDescValue1('75.0%', nil) =", JSON.stringify(dm.callSkillUtilsTableFn("FormatDescValue1", ["75.0%", null])))
console.log("FormatDescValue1('12', nil) =", JSON.stringify(dm.callSkillUtilsTableFn("FormatDescValue1", ["12", null])))
