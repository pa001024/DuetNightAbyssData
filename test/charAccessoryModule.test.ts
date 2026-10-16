import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import { charAccessoryModule } from "../src/modules/charAccessory/charAccessoryModule.ts"

function mockCtx(table: Record<string, unknown>): ModuleContext {
    return {
        dm: { getTable: (name: string) => (name === "CharAccessory" ? table : undefined) },
    } as unknown as ModuleContext
}

describe("CharAccessory 模块", () => {
    test("IsHide 行保留并打 hide: 1 标记，其余行无 hide 字段", () => {
        const rows = charAccessoryModule(
            mockCtx({
                visible: {
                    AccessoryId: 30001,
                    Name: "UI_Accessory_Name_30001",
                    Des: "UI_Accessory_Desc_30001",
                    Icon: "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Fashion/T_Fashion_Waist_Card_Wegame.T_Fashion_Waist_Card_Wegame'",
                    Rarity: 4,
                },
                // 30015 真实形状：IsHide + ExcludeCollect
                hidden: {
                    AccessoryId: 30015,
                    Name: "UI_Accessory_Name_30015",
                    Des: "UI_Accessory_Desc_30010",
                    Icon: "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Fashion/T_Fashion_Waist_Card_Wegame.T_Fashion_Waist_Card_Wegame'",
                    Rarity: 4,
                    IsHide: true,
                    ExcludeCollect: true,
                    ExcludeCollectServer: true,
                },
                noId: { Name: "UI_Accessory_Name_X", IsHide: true },
            })
        ) as Array<Record<string, unknown>>

        expect(rows.map(row => row.id)).toEqual([30001, 30015])
        expect(rows[0].hide).toBeUndefined()
        expect(rows[1].hide).toBe(1)
    })
})
