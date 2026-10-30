import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import { questChainModule } from "../src/modules/questChain/questChainModule.ts"

function fakeCtx(tables: Record<string, unknown>): ModuleContext {
    return { dm: { getTable: (name: string) => tables[name] } } as unknown as ModuleContext
}

describe("QuestChain unlock", () => {
    test("UnlockCondition 按纯 id 原样输出，无条件时省略", () => {
        const rows = questChainModule(
            fakeCtx({
                QuestChain: {
                    100101: { QuestChainId: 100101, QuestChainName: "Name_100101" },
                    100102: { QuestChainId: 100102, QuestChainName: "Name_100102", UnlockCondition: 100101 },
                },
                STLExportQuestChain: {},
            })
        ) as Array<Record<string, any>>

        expect(rows.find(row => row.id === 100101)).not.toHaveProperty("unlock")
        expect(rows.find(row => row.id === 100102)).toMatchObject({ unlock: 100101 })
    })
})
