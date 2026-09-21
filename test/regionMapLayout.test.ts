import { describe, expect, test } from "bun:test"
import { centerFromAnchor, relayoutIsRandom } from "../src/modules/region/regionMap.ts"
import type { RegionMapAnchor, RegionMapEntry } from "../src/modules/region/regionMap.ts"

/**
 * 净界岛（Region 1001）真实数据：`WBP_Map_Reg_Prologue` 不含 `Img_Map`，游戏在运行时按
 * `SubRegion.SubRegionCenter` 重排图层。作者 slotPos 与 SubRegion 世界坐标取自
 * `WBP_Map_Prologue_*.uasset` 与 `Script/Datas/SubRegion.lua`。
 */
const anchor: RegionMapAnchor = {
    pos: [152, 44, 1024, 1024],
    world: [3500, 500],
    worldBySplice: new Map([
        ["WBP_Map_Prologue_100101", [3500, 500]],
        ["WBP_Map_Prologue_100102", [23500, 4500]],
        ["WBP_Map_Prologue_100103", [27500, 32000]],
    ]),
}

const entries: RegionMapEntry[] = [
    { name: "WBP_Map_Prologue_Bg", pos: [-512, -512, 3072, 3072], opacity: 0.6, zOrder: -10 },
    { name: "WBP_Map_Prologue_100101", pos: [152, 44, 1024, 1024], opacity: 1, zOrder: 0 },
    { name: "WBP_Map_Prologue_100102", pos: [748, 207, 1024, 1024], opacity: 1, zOrder: 0 },
    { name: "WBP_Map_Prologue_100103", pos: [1014, 1124, 1024, 1024], opacity: 1, zOrder: 0 },
]

describe("relayoutIsRandom", () => {
    test("锚点保持作者坐标，其余子区域按世界坐标差 / 30 平移，尺寸不变", () => {
        const relaid = relayoutIsRandom(entries, anchor)
        expect(relaid.map(entry => entry.pos)).toEqual([
            // 背景层对不上子区域 id，保持原位
            [-512, -512, 3072, 3072],
            // 锚点：世界坐标即锚点世界坐标，位移为 0
            [152, 44, 1024, 1024],
            // (23500-3500)/30 = 666.67 → 819，(4500-500)/30 = 133.33 → 177
            [819, 177, 1024, 1024],
            // (27500-3500)/30 = 800，(32000-500)/30 = 1050
            [952, 1094, 1024, 1024],
        ])
        expect(relaid.map(entry => entry.opacity)).toEqual(entries.map(entry => entry.opacity))
        expect(relaid.map(entry => entry.zOrder)).toEqual(entries.map(entry => entry.zOrder))
    })

    test("未命中世界坐标的图层保持原位，不产生位移", () => {
        const extra: RegionMapEntry = { name: "WBP_Map_Prologue_Unknown", pos: [10, 20, 30, 40], opacity: 1, zOrder: 1 }
        const relaid = relayoutIsRandom([...entries, extra], anchor)
        expect(relaid.at(-1)!.pos).toEqual([10, 20, 30, 40])
    })

    test("取整与 Lua 的 FormatDescValue1 一致（0.5 向偶数舍入）", () => {
        const half: RegionMapAnchor = {
            pos: [152, 44, 1024, 1024],
            world: [3500, 500],
            // (3515-3500)/30 = 0.5 → 偶舍入 152；(545-500)/30 = 1.5 → 偶舍入 46
            worldBySplice: new Map([["WBP_Map_Prologue_100101", [3515, 545]]]),
        }
        const relaid = relayoutIsRandom([entries[1]], half)
        expect(relaid[0].pos).toEqual([152, 46, 1024, 1024])
    })
})

describe("centerFromAnchor", () => {
    test("以 _Bg 图层并集中心对齐锚点，mapCenter = 锚点世界坐标 + 帧中心偏移 × 30", () => {
        const relaid = relayoutIsRandom(entries, anchor)
        // _Bg 帧 [-512,-512] → [2560,2560]，中心 (1024,1024)；锚点中心 (664,556)
        // 3500 + (1024-664)*30 = 14300；500 + (1024-556)*30 = 14540
        expect(centerFromAnchor(relaid, anchor)).toEqual([14300, 14540])
    })

    test("无 _Bg 图层时投影帧退化为全部图层并集", () => {
        const anchorAtOrigin: RegionMapAnchor = { pos: [0, 0, 100, 100], world: [0, 0], worldBySplice: new Map() }
        const only: RegionMapEntry[] = [{ name: "WBP_Map_Solo_A", pos: [0, 0, 100, 100], opacity: 1, zOrder: 0 }]
        expect(centerFromAnchor(only, anchorAtOrigin)).toEqual([0, 0])
    })
})
