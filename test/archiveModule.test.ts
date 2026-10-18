import { describe, expect, test } from "bun:test"
import { archiveModule, groupMonsterIds, splitWeaponIds } from "../src/modules/archive/archiveModule.ts"
import type { ModuleContext } from "../src/core/Graph.ts"
import { getLuaDataManager } from "../src/lua/LuaDataManager.ts"

function fakeCtx(artifacts: Record<string, unknown>): ModuleContext {
    const dm = getLuaDataManager()
    return {
        graph: {} as ModuleContext["graph"],
        dm,
        textmap: {} as ModuleContext["textmap"],
        getArtifact: (name: string) => artifacts[name] as never,
        args: {},
        log: () => {},
    } as ModuleContext
}

describe("archive 武器划分", () => {
    test("10xxx 为近战，20xxx 为远程", () => {
        expect(splitWeaponIds([20201, 10101, 20601, 10199])).toEqual({ melee: [10101, 10199], ranged: [20201, 20601] })
    })
})

describe("archive 敌人分组", () => {
    test("按 TabPara 归属，可多归属，无标签归 OtherMonster", () => {
        const groups = groupMonsterIds([
            { id: 1, tags: ["Mon.Jt", "Mon.Melee"] },
            { id: 2, tags: ["Mon.Boss"] },
            { id: 3, tags: ["Mon.Gr", "Mon.Boss"] },
            { id: 4, tags: ["Mon.Melee"] },
            { id: 5 },
        ])
        expect(groups.AllMonster).toEqual([1, 2, 3, 4, 5])
        expect(groups["Mon.Jt"]).toEqual([1])
        expect(groups["Mon.Boss"]).toEqual([2, 3])
        expect(groups["Mon.Gr"]).toEqual([3])
        expect(groups.OtherMonster).toEqual([4, 5])
    })
})

describe("archive 模块", () => {
    test("骨架与条目 id 引用：6 档案，物件 190+19=209", () => {
        const dm = getLuaDataManager()
        const resourceTable = dm.getTable("Resource") as Record<string, Record<string, unknown>>
        const resourceMap = new Map<number, Record<string, unknown>>()
        for (const [key, row] of Object.entries(resourceTable)) {
            if (row && typeof row === "object") resourceMap.set(Number(key), row)
        }
        const ctx = fakeCtx({
            ResourceData: { resourceMap },
            Char: { Char: [{ id: 1101 }, { id: 1102 }] },
            Weapon: { Weapon: [{ id: 10101 }, { id: 20201 }] },
            BookSeriesArchive: { BookSeriesArchive: [{ id: 1001 }, { id: 1002 }] },
            Monster: { Monster: [{ id: 115, tags: ["Mon.Jt"] }] },
        })
        const archives = archiveModule(ctx) as Array<Record<string, any>>
        expect(archives.map(a => a.id)).toEqual([1001, 1002, 1003, 1004, 1005, 1006])

        const byId = new Map(archives.map(a => [a.id, a]))
        expect(byId.get(1001)!.entries).toEqual([1101, 1102])
        expect(byId.get(1002)!.entries).toEqual([10101])
        expect(byId.get(1003)!.entries).toEqual([20201])
        expect(byId.get(1005)!.series).toEqual([1001, 1002])

        // 物件：ItemArchiveType=1 常规 190，=2 特殊 19（截图 200/209 的分母来源）
        expect(byId.get(1004)!.normal.length).toBe(190)
        expect(byId.get(1004)!.task.length).toBe(19)
        expect(byId.get(1004)!.tabs.length).toBe(3)
        expect(byId.get(1006)!.tabs.length).toBe(8)
        expect(byId.get(1006)!.groups.AllMonster).toEqual([115])
    })
})
