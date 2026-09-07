import { mkdtempSync, mkdirSync, rmSync, writeFileSync } from "node:fs"
import { join } from "node:path"
import { tmpdir } from "node:os"
import { describe, expect, test } from "bun:test"
import {
    collectTiles,
    extractResourceStems,
    isImageHidden,
    parseLayoutPlacements,
    textureInputDir,
} from "../src/tools/exportMapsLayout.ts"

type RowFixture = Record<string, any>

function imageRow(name: string, resourceStem: string, overrides: RowFixture = {}): RowFixture {
    const brush = {
        ImageSize: { X: 512, Y: 512 },
        ResourceObject: { ObjectName: `Texture2D'${resourceStem}'`, ObjectPath: `EM/Content/UI/Texture/Static/Image/Map/X/${resourceStem}.0` },
        ...(overrides.Brush ?? {}),
    }
    return {
        Name: name,
        Type: "Image",
        Properties: { Brush: brush, ...overrides },
    }
}

function slotRow(slotName: string, row: number | undefined, col: number | undefined, contentName: string): RowFixture {
    const props: RowFixture = {}
    if (row !== undefined) props.Row = row
    if (col !== undefined) props.Column = col
    if (contentName) props.Content = { ObjectName: `Image'WBP_X_C:WidgetTree.${contentName}'` }
    return { Name: slotName, Type: "UniformGridSlot", Properties: props }
}

/** 构造 FModel 同构布局：Root 网格 + 3x3 槽位（含一个空槽、一个隐藏槽、一个缺失贴图槽）。 */
function buildLayout(): RowFixture[] {
    const images = [
        imageRow("Map01_1", "T_Tile_01"),
        imageRow("Map02_1", "T_Tile_02"),
        imageRow("Map03_1", "T_Tile_03"),
        imageRow("Map04_1", "T_Tile_04"),
        imageRow("Map05_1", "T_Tile_05"),
        imageRow("Map06_1", "T_Tile_06"),
        imageRow("Map07_1", "T_Tile_07", { RenderOpacity: 0 }),
        imageRow("Map08_1", "T_Missing_08"),
    ]
    // 覆盖 name 冲突场景：与 uniform grid 同一 Name 的 slot 引用在 name_map 里必须取到。
    const slots = [
        slotRow("UniformGridSlot_0", 0, 0, "Map01_1"),
        slotRow("UniformGridSlot_1", 0, 1, "Map02_1"),
        slotRow("UniformGridSlot_2", 0, 2, "Map03_1"),
        slotRow("UniformGridSlot_3", 1, 0, "Map04_1"),
        slotRow("UniformGridSlot_4", 1, 1, ""),
        slotRow("UniformGridSlot_5", 1, 2, "Map05_1"),
        slotRow("UniformGridSlot_6", 2, 0, "Map07_1"),
        slotRow("UniformGridSlot_7", 2, 1, "Map08_1"),
        slotRow("UniformGridSlot_8", undefined, 2, "Map06_1"),
    ]
    const grid: RowFixture = {
        Name: "Main",
        Type: "UniformGridPanel",
        Properties: {
            Slots: slots.map(s => ({ ObjectName: `UniformGridPanel'WBP_X_C:WidgetTree.${s.Name}'` })),
        },
    }
    return [
        { Name: "Root", Type: "CanvasPanel", Properties: { Slots: [] } },
        grid,
        ...slots,
        ...images,
    ]
}

describe("parseLayoutPlacements", () => {
    test("按槽位 Row/Column 生成拼接坐标与网格边界", () => {
        const layout = buildLayout()
        const stems = new Map([
            ["T_Tile_01", "D:/tiles/T_Tile_01.png"],
            ["T_Tile_02", "D:/tiles/T_Tile_02.png"],
            ["T_Tile_03", "D:/tiles/T_Tile_03.png"],
            ["T_Tile_04", "D:/tiles/T_Tile_04.png"],
            ["T_Tile_05", "D:/tiles/T_Tile_05.png"],
            ["T_Tile_06", "D:/tiles/T_Tile_06.png"],
        ])
        const result = parseLayoutPlacements(layout, "Main", stems)
        expect(result).not.toBeNull()
        expect(result!.slotCount).toBe(9)
        // 隐藏槽(2,0)、缺失贴图槽(2,1) 不产生贴图；缺 Row 的槽按 0 处理。
        expect(result!.placements).toEqual([
            { row: 0, col: 0, tilePath: "D:/tiles/T_Tile_01.png" },
            { row: 0, col: 1, tilePath: "D:/tiles/T_Tile_02.png" },
            { row: 0, col: 2, tilePath: "D:/tiles/T_Tile_03.png" },
            { row: 1, col: 0, tilePath: "D:/tiles/T_Tile_04.png" },
            { row: 1, col: 2, tilePath: "D:/tiles/T_Tile_05.png" },
            { row: 0, col: 2, tilePath: "D:/tiles/T_Tile_06.png" },
        ])
        // 边界由全部槽位（含空槽/隐藏槽）的 Row/Column 决定
        expect(result!.bounds).toEqual([0, 2, 0, 2])
        expect(result!.missing).toEqual(["T_Missing_08"])
    })

    test("找不到 UniformGridPanel 时返回 null", () => {
        const layout = [{ Name: "Root", Type: "CanvasPanel", Properties: { Slots: [] } }]
        expect(parseLayoutPlacements(layout, "Main", new Map())).toBeNull()
    })

    test("找不到指定名称时回退到任意 UniformGridPanel", () => {
        const images = [imageRow("Map01_1", "T_Tile_01")]
        const slot = slotRow("UniformGridSlot_0", 0, 0, "Map01_1")
        const grid = { Name: "Other", Type: "UniformGridPanel", Properties: { Slots: [{ ObjectName: `UniformGridSlot'WBP_X_C:WidgetTree.${slot.Name}'` }] } }
        const result = parseLayoutPlacements([grid, slot, ...images], "Main", new Map([["T_Tile_01", "D:/t.png"]]))
        expect(result?.placements).toHaveLength(1)
    })
})

describe("isImageHidden", () => {
    test("RenderOpacity/ColorAndOpacity/Brush.TintColor 任一 alpha<=0 视为隐藏", () => {
        expect(isImageHidden(imageRow("A", "T_1"))).toBe(false)
        expect(isImageHidden(imageRow("A", "T_1", { RenderOpacity: -0.5 }))).toBe(true)
        expect(isImageHidden(imageRow("A", "T_1", { ColorAndOpacity: { A: 0 } }))).toBe(true)
        expect(isImageHidden(imageRow("A", "T_1", { Brush: { TintColor: { SpecifiedColor: { A: 0.1, R: 1 } } } }))).toBe(false)
        const hidden = imageRow("A", "T_1", { Brush: { TintColor: { SpecifiedColor: { A: 1, R: 1 } } } })
        hidden.Properties.Brush.TintColor = { SpecifiedColor: { A: 0 } }
        expect(isImageHidden(hidden)).toBe(true)
    })
})

describe("textureInputDir / collectTiles", () => {
    test("从首张 Image 的 ObjectPath 推断贴图目录并按序号收集贴图", () => {
        const root = mkdtempSync(join(tmpdir(), "exportMapsLayout-"))
        try {
            const textureRoot = join(root, "Static")
            const dir = join(textureRoot, "Image", "Map", "X")
            mkdirSync(dir, { recursive: true })
            writeFileSync(join(dir, "T_MapBg_02.png"), "x")
            writeFileSync(join(dir, "T_MapBg_01.png"), "x")
            writeFileSync(join(dir, "unrelated.png"), "x")
            const layout = [imageRow("Map01_1", "T_MapBg_01")]
            expect(textureInputDir(layout, textureRoot)).toBe(dir)
            const tiles = collectTiles(dir)
            expect([...tiles.keys()]).toEqual(["T_MapBg_01", "T_MapBg_02"])
            expect(collectTiles(join(root, "missing"))).toEqual(new Map())
        } finally {
            rmSync(root, { recursive: true, force: true })
        }
    })

    test("非 Image/Map 或 Atlas/Map_Splice_Mobile 路径不产生输入目录", () => {
        const root = mkdtempSync(join(tmpdir(), "exportMapsLayout-"))
        try {
            const layout = [
                {
                    Name: "A",
                    Type: "Image",
                    Properties: {
                        Brush: {
                            ResourceObject: {
                                ObjectPath: "EM/Content/UI/Texture/Static/Other/T_1.0",
                            },
                        },
                    },
                },
            ]
            expect(textureInputDir(layout, root)).toBeNull()
        } finally {
            rmSync(root, { recursive: true, force: true })
        }
    })
})

describe("extractResourceStems", () => {
    test("去重并按出现顺序返回资源名", () => {
        const layout = [
            imageRow("A", "T_1"),
            imageRow("B", "T_2"),
            imageRow("C", "T_1"),
            { Name: "D", Type: "CanvasPanel", Properties: {} },
        ]
        expect(extractResourceStems(layout)).toEqual(["T_1", "T_2"])
    })
})
