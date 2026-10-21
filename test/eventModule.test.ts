import { describe, expect, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree, type VNodeTree } from "../src/i18n/vnode.ts"
import { eventModule } from "../src/modules/event/eventModule.ts"

const baseDir = new URL("../out/", import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")
const textmap = getTextMap(baseDir)

async function buildEvents(lang = "cn"): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "Event", deps: [], outputs: true, build: ctx => eventModule(ctx) })
    const artifacts = await graph.build({}, undefined, ["Event"])
    return renderTree(artifacts.get("Event") as VNodeTree, lang, textmap) as Array<Record<string, any>>
}

describe("Event 联袂演绎", () => {
    test("121001~121004 名含副标题且内联同一副本列表", async () => {
        const events = await buildEvents()
        for (const id of [121001, 121002, 121003, 121004]) {
            const event = events.find(item => item.id === id)!
            expect(event).toBeDefined()
            expect(event.name).toBe("沉浸式戏剧·联袂演绎")
            expect((event.asyncCombat as Record<string, any>).dungeons).toEqual([40601, 40602, 40603, 40604])
        }
    })

    test("深渊事件名带勇者们的传说且无 asyncCombat，不与联袂演绎混淆", async () => {
        const events = await buildEvents()
        const event = events.find(item => item.id === 103002)!
        expect(event.name).toBe("沉浸式戏剧·勇者们的传说")
        expect(event).not.toHaveProperty("asyncCombat")
        for (const item of events)
            if (![121001, 121002, 121003, 121004].includes(item.id)) expect(item).not.toHaveProperty("asyncCombat")
    })

    test("无副标题事件名不变，副标题无文本时不拼接原始 key", async () => {
        const events = await buildEvents()
        expect(events.find(item => item.id === 103036)!.name).toBe("永恒梦魇")
        // 103017 的 EventSName 无 TextMap，不拼接。
        expect(events.find(item => item.id === 103017)!.name).toBe("定格的往事")
        expect(JSON.stringify(events)).not.toContain("Event_STitle_103017")
    })

    test("en 名取官方对照翻译", async () => {
        const events = await buildEvents("en")
        expect(events.find(item => item.id === 121001)!.name).toBe("Immersive Theatre·Ensemble Act")
        expect(events.find(item => item.id === 103002)!.name).toBe("Immersive Theatre·Legends of the Brave")
    })
}) 

describe("Event 永恒梦魇内联", () => {
    test("103036 输出 5 Boss 双模式及周奖励元数据", async () => {
        const events = await buildEvents()
        const event = events.find(item => item.id === 103036)!
        expect(event).toBeDefined()
        const hb = event.hardBossEvent as Record<string, any>
        expect(hb.weeklyRewards).toBe(20)
        expect(hb.period).toBe("Week")
        expect(hb.bosses.map((boss: Record<string, any>) => boss.id)).toEqual([1, 2, 3, 4, 5])
        expect(hb.bosses.map((boss: Record<string, any>) => boss.name)).toEqual([
            "西比尔",
            "羽化者",
            "炼火的典狱长",
            "神秘怪物",
            "「审判」兔妈妈",
        ])
        // 图标取短名且无 Texture2D 引用外壳残留的单引号（Tuosi 行回归）。
        for (const boss of hb.bosses as Array<Record<string, any>>)
            expect(boss.icon).toMatch(/^T_Permanent_HardBoss_\w+_S$/)
        // 西比尔：永恒 28001 / 高难 28002。
        const xibi = hb.bosses[0] as Record<string, any>
        expect(xibi.monster).toEqual([8500801])
        expect(xibi.modes.map((mode: Record<string, any>) => mode.dungeonId)).toEqual([28001, 28002])
        expect(xibi.modes[0]).toMatchObject({ mode: "eternal", lv: 80, reward: 2800101, firstReward: 2800102, buff: 1001 })
        expect(xibi.modes[0]).not.toHaveProperty("unlock")
        expect(xibi.modes[1]).toMatchObject({
            mode: "challenge",
            lv: 160,
            reward: 2800202,
            firstReward: 2800201,
            buff: 1001,
            unlock: [28001],
        })
        // 兔妈妈高难本的固定奖励与首次称号。
        const aida = hb.bosses[4] as Record<string, any>
        expect(aida.modes[1]).toMatchObject({ dungeonId: 28010, mode: "challenge", reward: 2801002, firstReward: 2801001 })
    })

    test("内联只含 reward，不含 rewardView/预览/event 冗余", async () => {
        const events = await buildEvents()
        const event = events.find(item => item.id === 103036)!
        const hb = event.hardBossEvent as Record<string, any>
        expect(hb).not.toHaveProperty("event")
        for (const boss of hb.bosses as Array<Record<string, any>>) {
            expect(boss).not.toHaveProperty("previewRewardView")
            expect(boss).not.toHaveProperty("event")
            for (const mode of boss.modes as Array<Record<string, any>>) expect(mode).not.toHaveProperty("rewardView")
        }
        expect(JSON.stringify(hb)).not.toContain("rewardView")
        // 其他事件不受影响。
        for (const item of events) if (item.id !== 103036) expect(item).not.toHaveProperty("hardBossEvent")
    })
})
