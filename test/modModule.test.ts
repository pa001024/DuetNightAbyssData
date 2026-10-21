import { describe, expect, setDefaultTimeout, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { modModule } from "../src/modules/mod/modModule.ts"
import { skillModule } from "../src/modules/skill/skillModule.ts"

setDefaultTimeout(60000)

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")
const textmap = getTextMap(baseDir)

async function buildMods(): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) })
    graph.defineModule({ name: "Mod", deps: ["Skill"], outputs: true, build: async ctx => ({ Mod: await modModule(ctx) }) })

    const artifacts = await graph.build({}, undefined, ["Mod"])
    const mods = (artifacts.get("Mod") as { Mod: Array<Record<string, any>> }).Mod
    return renderTree(mods, "cn", textmap) as Array<Record<string, any>>
}

describe("mod 模块", () => {
    test("恒定列退火进模板，剩余列重排为连续编号", async () => {
        const mods = await buildMods()

        // 51311：MaxLevel=5 且 ModCardLevelMax=5，0~10 级共 11 列；#3（30 秒）与 #4（15 层）各级恒定
        const mod = mods.find(item => item.id === 51311)
        const effect = mod?.效果 as [string, ...string[][]]
        const [template, ...columns] = effect

        expect(template).toBe("受到的伤害降低#1。消灭敌人时，获得1层攻击提高#2，持续30.0秒，最多叠加15.0层，叠加时刷新剩余时间。")
        expect(columns).toHaveLength(2)
        for (const column of columns) expect(column).toHaveLength(11)

        expect(columns[0][0]).toBe("2.0%")
        expect(columns[0][10]).toBe("22.0%")
        expect(columns[1][0]).toBe("1.0%")
        expect(columns[1][10]).toBe("11.0%")

        // 代入最后一级应还原为完整的满级文案
        const render = (grade: number): string => {
            let text = template
            columns.forEach((column: string[], index: number) => {
                text = text.split(`#${index + 1}`).join(column[grade])
            })
            return text
        }
        expect(render(10)).toBe("受到的伤害降低22.0%。消灭敌人时，获得1层攻击提高11.0%，持续30.0秒，最多叠加15.0层，叠加时刷新剩余时间。")
    })

    test("各级完全一致的效果退化为纯文案", async () => {
        const mods = await buildMods()

        // 「强化至+5.0后…」各级取值恒为 5.0，退火后只留模板
        const effect = mods.find(item => item.id === 51754)?.效果
        expect(effect).toEqual(["强化至+5.0后，此魔之楔可同时重复装备多个。"])

        // 42701 本身无占位符
        expect(mods.find(item => item.id === 42701)?.效果).toEqual(["击败等级不高于自身的敌人后，获得自身远程武器最大弹药量的子弹并装填。"])
    })

    test("部分列退火时保留的列按原顺序重排编号", async () => {
        const mods = await buildMods()

        // 56141：模板引用 #1（恒定 130.0%）与 #2（逐级变化）
        // 退火后 #1 代入模板，原 #2 重排为 #1
        const effect = mods.find(item => item.id === 56141)?.效果 as [string, ...string[][]]
        const [template, ...columns] = effect

        expect(template).toBe("技能效益大于等于130.0%时，自身技能威力提高#1。")
        expect(columns).toHaveLength(1)
        expect(columns[0][0]).toBe("8.0%")
        expect(columns[0][10]).toBe("88.0%")
    })

    test("仅在取值内部互引、未被模板引用的条目会被截断", async () => {
        const mods = await buildMods()

        // 201001 的 DescValues 为 ["$#Mod[201001].DescValues[2]*100$%", "#2"]，
        // 第 2 项只服务于第 1 项的内部互引，模板仅引用 #1，故不产出第二列
        // （否则会按占位符编号算出 "SkillUtils.NewGrowDesc(N).2" 这类无意义字面串）。
        const effect = mods.find(item => item.id === 201001)?.效果 as [string, ...string[][]]
        const [template, ...columns] = effect

        expect(template).toBe("改变单手剑的普通攻击招式和威力。对比默认招式，综合威力提高#1。")
        expect(columns).toHaveLength(1)
        expect(columns[0][0]).toBe("100.0%")
        expect(columns[0][10]).toBe("200.0%")
        expect(JSON.stringify(effect)).not.toContain("NewGrowDesc")
    })

    test("模板引用 #2 时保留编号空洞，列仍按编号对齐", async () => {
        const mods = await buildMods()

        // 41725 模板只引用 #2；截断上限为 2，故 #1 列保留（不被引用）以保证 #2 取到第 2 个数组
        const effect = mods.find(item => item.id === 41725)?.效果 as [string, ...string[][]]
        const [template, ...columns] = effect

        expect(template).toBe("仅当装备的魔之楔各不相同时，属性效果生效，自身召唤物造成的伤害提高#1。")
        expect(columns).toHaveLength(1)
        expect(columns[0][0]).toBe("10.0%")
        expect(columns[0][5]).toBe("60.0%")
    })

    test("属性字段收拢进加成，不再平铺顶层", async () => {
        const mods = await buildMods()

        // 11001：AddAttrs ATK → 加成.攻击（满级值），顶层不再出现攻击
        const basic = mods.find(item => item.id === 11001)
        expect(basic?.加成).toEqual({ 攻击: 0.15 })
        expect(basic).not.toHaveProperty("攻击")

        // 32202：属性与效果同源（GetModValue 取 AddAttrs），加成持整列数组，效果保持参数化模板
        const combo = mods.find(item => item.id === 32202)
        expect(combo?.加成).toEqual({ 额外连击: [0.17, 0.33, 0.5, 0.67, 0.84, 1] })
        expect(combo).not.toHaveProperty("额外连击")
        const effect = combo?.效果 as [string, ...string[][]]
        expect(effect[0]).toBe("通过攻击获得连击点数时，有#1概率额外获得1点。")
        expect(effect[1]).toEqual(["17.0%", "33.0%", "50.0%", "67.0%", "84.0%", "100.0%"])

        // 12101：限定仍保留顶层，数值进加成
        const limit = mods.find(item => item.id === 12101)
        expect(limit?.限定).toBe("切割")
        expect(limit?.加成).toEqual({ 物理: 0.2 })
        expect(limit).not.toHaveProperty("物理")

        // 56111：受到的伤害 → 加成.减伤（取反，常数项取 [v]）
        expect(mods.find(item => item.id === 56111)?.加成).toEqual({ 减伤: [0.3] })
    })

    test("AddCharModCost 补最大耐受（满级耐受 × 系数下取整）", async () => {
        const mods = await buildMods()

        // 31502：Cost=2，MaxLevel=5，满级耐受=7；AddCharModCost=2.5 → floor(7*2.5)=17
        const aura = mods.find(item => item.id === 31502)
        expect(aura?.耐受).toBe(7)
        expect(aura?.加成).toEqual({ 最大耐受: 17 })
        expect(aura).not.toHaveProperty("最大耐受")

        // 无 AddCharModCost 的魔之楔不带最大耐受；无任何属性时不输出加成
        expect(mods.find(item => item.id === 11001)?.加成).not.toHaveProperty("最大耐受")
        const noBonus = mods.find(item => item.id === 31513)
        expect(noBonus?.加成).toEqual({ 最大耐受: 17 })
    })

    test("常数项导出 [v]，非线性写整列数组", async () => {
        const mods = await buildMods()

        // 41413：技能伤害纯数字恒定 -0.5（MaxLevel=5）→ 老规则 [v]，无曲线
        expect(mods.find(item => item.id === 41413)?.加成).toMatchObject({ 技能伤害: [-0.5] })
        expect(mods.find(item => item.id === 41413)).not.toHaveProperty("曲线")
        // 56111：受到的伤害翻转为正数减伤 → [0.3]
        expect(mods.find(item => item.id === 56111)?.加成).toMatchObject({ 减伤: [0.3] })
        expect(mods.find(item => item.id === 56111)).not.toHaveProperty("曲线")
        // 11001：等比成长 → 标量，无曲线
        expect(mods.find(item => item.id === 11001)?.加成).toMatchObject({ 攻击: 0.15 })
        expect(mods.find(item => item.id === 11001)).not.toHaveProperty("曲线")
        // 32202：4 级取值 0.84 偏离等比超过舍入 → 加成直接写整列数组
        expect(mods.find(item => item.id === 32202)?.加成).toMatchObject({ 额外连击: [0.17, 0.33, 0.5, 0.67, 0.84, 1] })
        // 51768：先快后慢的特殊成长（多条）→ 各自写整列数组；无曲线字段
        expect(mods.find(item => item.id === 51768)?.加成).toMatchObject({
            攻击: [0.12, 0.3, 0.468, 0.624, 0.768, 0.9, 1.008, 1.104, 1.188, 1.26, 1.32],
            技能威力: [0.05, 0.125, 0.195, 0.26, 0.32, 0.375, 0.42, 0.46, 0.495, 0.525, 0.55],
        })
        expect(mods.find(item => item.id === 51768)).not.toHaveProperty("曲线")
        expect(mods.find(item => item.id === 32202)).not.toHaveProperty("曲线")
    })

    test("角色专属魔之楔输出数字限定", async () => {
        const mods = await buildMods()
        expect(mods.find(item => item.id === 150401)?.限定).toBe(1504)
        expect(mods.find(item => item.id === 510101)?.限定).toBe(5101)
        // 普通角色魔之楔不受影响
        expect(mods.find(item => item.id === 11001)).not.toHaveProperty("限定")
    })

    test("架势魔之楔按被替换技能反查武器定限定", async () => {
        const mods = await buildMods()
        // 与下游“改变X的”老口径逐项一致（24 个全覆盖）；数字限定与角色类型不受影响
        expect(mods.find(item => item.id === 204001)?.限定).toBe("双刀")
        expect(mods.find(item => item.id === 101001)?.限定).toBe("单手剑")
        expect(mods.find(item => item.id === 102001)?.限定).toBe("长柄")
        expect(mods.find(item => item.id === 103001)?.限定).toBe("重剑")
        expect(mods.find(item => item.id === 105001)?.限定).toBe("鞭刃")
        expect(mods.find(item => item.id === 106001)?.限定).toBe("太刀")
        expect(mods.find(item => item.id === 201001)?.限定).toBe("单手剑")
        expect(mods.find(item => item.id === 150401)?.限定).toBe(1504)
        // 角色类架势（如锋芒）无数值限定
        expect(mods.find(item => item.id === 41801)).not.toHaveProperty("限定")
    })

    test("被动效果派生无条件数值字段（并入加成）", async () => {
        const mods = await buildMods()
        const bonusOf = (id: number) => mods.find(item => item.id === id)?.加成 as Record<string, unknown>
        // 充盈·巧力：DOT 计算读取技能触发字段
        expect(bonusOf(51317)).toMatchObject({ 技能触发: 1 })
        expect(bonusOf(41317)).toMatchObject({ 技能触发: 0.54 })
        expect(bonusOf(41414)).toMatchObject({ 神智回复: 7 })
        expect(bonusOf(51454)).toMatchObject({ 神智回复: 12 })
        expect(bonusOf(41415)).toMatchObject({ 增伤: 0.11 })
        expect(bonusOf(51727)).toMatchObject({ 召唤物伤害: 0.55 })
        expect(bonusOf(41315)).toMatchObject({ 失衡易伤: 0.24 })
        expect(bonusOf(41921)).toMatchObject({ 召唤物攻击速度转化: 0.27, 召唤物范围转化: 0.132 })
        expect(bonusOf(31526)).toMatchObject({ 独立增伤: -0.15 })
        expect(bonusOf(43604)).toMatchObject({ 独立增伤: -0.6 })
        // 派生字段不散在顶层
        expect(mods.find(item => item.id === 51454)).not.toHaveProperty("神智回复")
        expect(mods.find(item => item.id === 51317)).not.toHaveProperty("技能触发")
        // 条件类模板不产出顶层值（归消费侧生效）；情境加成（秽兽/爆炸/按敌人数量/概率回复）不归一化
        expect(mods.find(item => item.id === 56111)).not.toHaveProperty("追加伤害")
        expect(mods.find(item => item.id === 510101)).not.toHaveProperty("背水")
        expect(mods.find(item => item.id === 41801)).not.toHaveProperty("增伤")
        expect(mods.find(item => item.id === 42501)).not.toHaveProperty("增伤")
        expect(mods.find(item => item.id === 43401)).not.toHaveProperty("增伤")
        expect(mods.find(item => item.id === 41313)).not.toHaveProperty("增伤")
        expect(mods.find(item => item.id === 41314)).not.toHaveProperty("增伤")
        expect(mods.find(item => item.id === 43701)).not.toHaveProperty("神智回复")
        expect(mods.find(item => item.id === 54204)).not.toHaveProperty("神智回复")
        // 41727 与 51727 同机制（无条件召唤物增伤），旧 patch 漏了前者，此处补上
        expect(bonusOf(41727)).toMatchObject({ 召唤物伤害: 0.3 })
    })

    test("被动效果派生条件数值（生效）", async () => {
        const mods = await buildMods()
        const bonusOf = (id: number) => mods.find(item => item.id === id)?.加成 as Record<string, unknown>
        // 趋向套装：纯条件模板将其数值移入生效（最大耐受除外）
        expect(mods.find(item => item.id === 41715)?.生效).toEqual({ 条件: [["D趋向", ">=", 4]], 技能耐久: 0.36 })
        expect(bonusOf(41715)).toMatchObject({ 最大耐受: 30 })
        expect(bonusOf(41715)).not.toHaveProperty("技能耐久")
        expect(mods.find(item => item.id === 41716)?.生效).toEqual({ 条件: [["*id", "<=", 1]], 昂扬: 0.36 })
        // 趋向套装：带取值子句只取末列值
        expect(mods.find(item => item.id === 41725)?.生效).toEqual({ 条件: [["*id", "<=", 1]], 召唤物伤害: 0.6 })
        expect(mods.find(item => item.id === 51725)?.生效).toEqual({ 条件: [["*id", "<=", 1]], 召唤物伤害: 1.1 })
        // 阈值：条件 + 子句属性末列值
        expect(mods.find(item => item.id === 56111)?.生效).toEqual({ 条件: [["昂扬", ">=", 0.6]], 追加伤害: 0.66 })
        expect(bonusOf(56111)).toMatchObject({ 减伤: [0.3] })
        expect(mods.find(item => item.id === 56132)?.生效).toEqual({ 条件: [["充盈威力", ">=", 5]], 技能威力: 0.88 })
        expect(mods.find(item => item.id === 56143)?.生效).toEqual({ 条件: [["神智", ">=", 300]], 昂扬: 0.66 })
        // 锋芒：武器条件 + 增伤[末#1,末#2]
        expect(mods.find(item => item.id === 41801)?.生效).toEqual({ 条件: [["单手剑", "*"]], 增伤: [0.06, 0.18] })
        expect(mods.find(item => item.id === 51801)?.生效).toEqual({ 条件: [["单手剑", "*"]], 增伤: [0.11, 0.33] })
        // 倍率：属性条件 + 攻击[末#1,末#2]，基础技能耐久保留在加成
        expect(mods.find(item => item.id === 41962)?.生效).toEqual({ 条件: [["技能耐久", "*"]], 攻击: [0.486, 1.17] })
        expect(mods.find(item => item.id === 51962)?.生效).toEqual({ 条件: [["技能耐久", "*"]], 攻击: [0.891, 2.15] })
        expect(Object.keys(bonusOf(41962))).toContain("技能耐久")
        // 无条件模板不产出生效
        expect(mods.find(item => item.id === 11001)).not.toHaveProperty("生效")
        expect(mods.find(item => item.id === 32202)).not.toHaveProperty("生效")
        expect(mods.find(item => item.id === 41415)).not.toHaveProperty("生效")
    })

    test("无描述键的替换技能从节点链合成字段（103004→1030302）", async () => {
        const mods = await buildMods()

        // Skill[1030302] 无 SkillDescKeys，伤害在 SkillNode[1030321] → SkillEffects[1030321]；
        // 名称按被替换旧技能 1030102 的 DescKey 顺序复用首个（蓄力攻击伤害），取消/连段随资产走不断言。
        const replacement = (mods.find(item => item.id === 103004)?.技能替换 as Record<string, any>)?.["1030102"]
        expect(replacement?.id).toBe(1030302)
        const fields = replacement?.字段 as Array<Record<string, any>>
        expect(fields).toHaveLength(1)
        expect(fields[0].名称).toBe("蓄力攻击伤害")
        expect(fields[0].值).toBe(5.66)
        expect(fields[0].削韧).toBe(120)
        expect(fields[0].tag).toEqual(expect.arrayContaining(["近战", "武器"]))
        expect(fields[0].卡肉).toBe(0.13)
    })
})
