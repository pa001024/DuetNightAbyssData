import { describe, expect, setDefaultTimeout, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import { Graph } from "../src/core/Graph.ts"
import { getTextMap } from "../src/i18n/TextMap.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { titleFrameModule } from "../src/modules/simple/simpleModules.ts"

setDefaultTimeout(60000)

describe("TitleFrame 模块", () => {
    test("按 TitleFrameID 升序输出 id/name/desc/icon，access 仅在有 AccessText 时出现", async () => {
        const graph = new Graph()
        graph.defineModule({ name: "TitleFrame", deps: [], outputs: true, build: ctx => ({ TitleFrame: titleFrameModule(ctx) }) })
        const artifacts = await graph.build({}, undefined, ["TitleFrame"])
        const rows = (artifacts.get("TitleFrame") as { TitleFrame: Array<Record<string, any>> }).TitleFrame

        expect(rows).toHaveLength(56)
        expect(rows.map(row => row.id)).toEqual([...rows.map(row => row.id)].sort((a, b) => a - b))

        const textmap = getTextMap()
        expect(rows[0].id).toBe(10001)
        expect(renderTree(rows[0].name, "cn", textmap)).toBe("默认")
        expect(renderTree(rows[0].desc, "cn", textmap)).toBe("可在称号样式中佩戴")
        expect(renderTree(rows[0].name, "en", textmap)).toBe("Default")
        expect(rows[0].icon).toBe("T_Icon_Random_TitleFrame")
        expect(rows[0].access).toBeUndefined()

        const level20 = rows.find(row => row.id === 10002)!
        expect(renderTree(level20.name, "cn", textmap)).toBe("二重螺旋I")
        expect(renderTree(level20.access, "cn", textmap)).toBe("历练等级达到Lv.20后解锁")
        expect(rows.filter(row => row.access !== undefined)).toHaveLength(6)

        // 文本 key 缺失时保持 key 原样（与 HeadFrame 一致，不新增回退）
        expect(renderTree(rows.find(row => row.id === 10043)!.name, "cn", textmap)).toBe("TitleFrame_10043")
    })

    test("跳过无 TitleFrameID 的行，Icon 解析为资源简称", () => {
        const ctx = {
            dm: {
                getTable: (name: string) =>
                    name === "TitleFrame"
                        ? {
                              a: {
                                  TitleFrameID: 10002,
                                  Name: "TitleFrame_10002",
                                  Des: "TitleFrame_Des",
                                  Icon: "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Icon_Random_TitleFrame.T_Icon_Random_TitleFrame'",
                                  AccessText: "Condition_Toast_PlayerLv_20",
                              },
                              b: { TitleFrameID: 0, Name: "TitleFrame_1b" },
                              c: { Name: "TitleFrame_1c" },
                              d: { TitleFrameID: 10001, Name: "TitleFrame_10001", Des: "TitleFrame_Des", Icon: "" },
                          }
                        : undefined,
            },
        } as unknown as ModuleContext

        const rows = titleFrameModule(ctx) as Array<Record<string, any>>
        expect(rows.map(row => row.id)).toEqual([10001, 10002])
        expect(rows[0].icon).toBe("")
        expect(rows[0].access).toBeUndefined()
        expect(rows[1].icon).toBe("T_Icon_Random_TitleFrame")
        expect(rows[1].access).toBeDefined()
    })
})
