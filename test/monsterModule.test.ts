import { describe, expect, test } from "bun:test"
import { Graph } from "../src/core/Graph.ts"
import { monsterModule } from "../src/modules/monster/monsterModule.ts"

async function buildMonsters(): Promise<Array<Record<string, any>>> {
    const graph = new Graph()
    graph.defineModule({ name: "Monster", deps: [], outputs: true, build: ctx => monsterModule(ctx) })
    const artifacts = await graph.build({}, undefined, ["Monster"])
    return artifacts.get("Monster") as Array<Record<string, any>>
}

describe("Monster 公会 Boss 单位", () => {
    test("GuildBossInfo.ID（运行时 Boss 单位）包含在导出白名单", async () => {
        const monsters = await buildMonsters()
        const ids = new Set(monsters.map(item => item.id))
        for (const id of [8502701, 8505701, 8509701, 8512701]) expect(ids.has(id)).toBe(true)
    })
})
