/**
 * exportMapsLayout — Map_Splice UMG 布局解析（纯数据，不依赖图片库）。
 *
 * 输入为 FModel / UAssetCLI `fmodel` 同构的 Widget 对象数组：
 * 每个元素 `{ Name, Type, Properties, ... }`，跨对象通过 Name/ObjectName 引用。
 *
 * 输出 UniformGridPanel 每个槽位的 (row, col) → 贴图文件路径的解析结果，
 * 供拼接工具按网格坐标整张贴入画布。行为契约来自真实游戏资产与既有产物，
 * 与本仓库地图工具的目标对齐（不再依赖 Python 实现）。
 */
import { readdirSync, statSync } from "node:fs"
import { basename, extname, join } from "node:path"

export type Row = Record<string, any>

/** 拼接单元：网格 (row, col) 与来源贴图文件。 */
export interface TilePlacement {
    row: number
    col: number
    tilePath: string
}

/** 网格边界 [minRow, maxRow, minCol, maxCol]，由全部槽位的 Row/Column 决定。 */
export type GridBounds = [number, number, number, number]

export interface LayoutParseResult {
    placements: TilePlacement[]
    /** UniformGridPanel 槽位引用总数（含空槽/隐藏槽）。 */
    slotCount: number
    bounds: GridBounds | undefined
    /** 布局引用了但输入目录缺失的贴图资源名（去重）。 */
    missing: string[]
}

/** 把 UE 对象名取末尾短名：`Main.UniformGridSlot_0` → `UniformGridSlot_0`。 */
export function tailObjectName(objectName: unknown): string | undefined {
    if (typeof objectName !== "string" || !objectName) return undefined
    const tail = objectName.split(".").at(-1)
    if (!tail) return undefined
    const trimmed = tail.replace(/'+$/g, "").trim()
    return trimmed || undefined
}

/** 从 `Texture2D'Xxx'` 形式（或裸名）提取资源名。 */
export function quotedResourceName(raw: unknown): string | undefined {
    if (typeof raw !== "string" || !raw) return undefined
    const match = raw.match(/'([^']+)'/)
    if (!match) return undefined
    const name = match[1]
    return name || undefined
}

/** UE 颜色字段（数字 / {A} / {SpecifiedColor:{A}}）里的 Alpha。 */
export function colorAlpha(value: unknown): number | undefined {
    if (typeof value === "number") return value
    if (value && typeof value === "object") {
        const obj = value as Row
        if (typeof obj.A === "number") return obj.A
        const specified = obj.SpecifiedColor
        if (specified && typeof specified === "object") {
            const inner = specified as Row
            if (typeof inner.A === "number") return inner.A
        }
    }
    return undefined
}

/** Image 是否在 UI 中被隐藏（任一透明度通道 <= 0）。 */
export function isImageHidden(image: Row): boolean {
    const props = image.Properties ?? {}
    const renderOpacity = props.RenderOpacity
    if (typeof renderOpacity === "number" && renderOpacity <= 0) return true
    const colorAlphaValue = colorAlpha(props.ColorAndOpacity)
    if (colorAlphaValue !== undefined && colorAlphaValue <= 0) return true
    const tintAlpha = colorAlpha(props.Brush?.TintColor)
    if (tintAlpha !== undefined && tintAlpha <= 0) return true
    return false
}

/**
 * 从布局数据推断贴图输入目录：取第一张 Image 的 Brush.ResourceObject.ObjectPath。
 * 期望形如 `EM/Content/UI/Texture/Static/Image/Map/<...>/<Texture>.0` 或
 * `EM/Content/UI/Texture/Static/Atlas/Map_Splice_Mobile/<...>/<Texture>.0`；
 * 返回该贴图所在目录（相对 Static 的父目录），否则 null。
 */
export function textureInputDir(layout: unknown, textureRoot: string): string | null {
    const data = layout
    if (!Array.isArray(data)) return null
    let objectPath: string | undefined
    for (const obj of data) {
        if (!obj || typeof obj !== "object") continue
        const row = obj as Row
        if (row.Type !== "Image") continue
        const resource = row.Properties?.Brush?.ResourceObject
        const path = resource && typeof resource === "object" ? (resource as Row).ObjectPath : undefined
        if (typeof path === "string" && path) {
            objectPath = path
            break
        }
    }
    if (!objectPath) return null
    const normalized = objectPath.replace(/\.\d+$/, "")
    const match = normalized.match(/^(EM\/Content\/UI\/Texture\/Static\/(?:Image\/Map|Atlas\/Map_Splice_Mobile)\/.+)$/)
    if (!match) return null
    const relative = match[1].slice("EM/Content/UI/Texture/Static/".length)
    const dir = join(textureRoot, dirnameOf(relative))
    return statSync(dir, { throwIfNoEntry: false })?.isDirectory() ? dir : null
}

function dirnameOf(relativePath: string): string {
    const parts = relativePath.split("/")
    parts.pop()
    return parts.join("/")
}

/**
 * 收集输入目录中带数字序号后缀的贴图：`*_<n>.png`。
 * 返回 stem → 完整路径 的映射（stem 不含扩展名）。
 */
export function collectTiles(inputDir: string): Map<string, string> {
    const result = new Map<string, string>()
    let entries: string[]
    try {
        entries = readdirSync(inputDir)
    } catch {
        return result
    }
    const indexed: Array<{ index: number; path: string }> = []
    for (const entry of entries) {
        const full = join(inputDir, entry)
        if (!statSync(full, { throwIfNoEntry: false })?.isFile()) continue
        if (extname(entry).toLowerCase() !== ".png") continue
        const match = /_(\d+)\.\w+$/.exec(entry)
        if (!match) continue
        indexed.push({ index: Number(match[1]), path: full })
    }
    indexed.sort((a, b) => a.index - b.index)
    for (const item of indexed) result.set(basename(item.path, extname(item.path)), item.path)
    return result
}

/**
 * 解析 UniformGridPanel Slots：每个槽位的 Row/Column 决定拼图坐标。
 * - 找不到指定/任意 UniformGridPanel 时返回 null（调用方走无网格回退）。
 * - 槽位 Row/Column 缺失按 0 处理；隐藏或非 Image 槽位不产生贴图但计入网格边界。
 */
export function parseLayoutPlacements(
    layout: unknown,
    gridName: string,
    tileByStem: ReadonlyMap<string, string>
): LayoutParseResult | null {
    const data = layout
    if (!Array.isArray(data)) return null

    const byName = new Map<string, Row>()
    for (const obj of data) {
        if (obj && typeof obj === "object" && typeof (obj as Row).Name === "string") {
            byName.set((obj as Row).Name, obj as Row)
        }
    }

    let grid = data.find((obj): boolean => {
        const row = obj as Row
        return row?.Type === "UniformGridPanel" && row.Name === gridName
    }) as Row | undefined
    if (!grid) {
        grid = data.find((obj): boolean => (obj as Row)?.Type === "UniformGridPanel") as Row | undefined
    }
    if (!grid) return null

    const slotRefs = grid.Properties?.Slots
    if (!Array.isArray(slotRefs)) return { placements: [], slotCount: 0, bounds: undefined, missing: [] }

    const placements: TilePlacement[] = []
    const missing = new Set<string>()
    const slotRows: number[] = []
    const slotCols: number[] = []

    for (const ref of slotRefs) {
        if (!ref || typeof ref !== "object") continue
        const slotName = tailObjectName((ref as Row).ObjectName)
        if (!slotName) continue
        const slot = byName.get(slotName)
        if (!slot) continue
        const slotProps = slot.Properties ?? {}

        let row = slotProps.Row ?? 0
        let col = slotProps.Column ?? 0
        row = Number(row)
        col = Number(col)
        if (!Number.isFinite(row) || !Number.isFinite(col)) continue
        slotRows.push(row)
        slotCols.push(col)

        const contentRef = slotProps.Content
        if (!contentRef || typeof contentRef !== "object") continue
        const contentName = tailObjectName((contentRef as Row).ObjectName)
        if (!contentName) continue
        const content = byName.get(contentName)
        if (content?.Type !== "Image") continue
        if (isImageHidden(content)) continue

        const resource = content.Properties?.Brush?.ResourceObject
        const resourceName = resource && typeof resource === "object" ? quotedResourceName((resource as Row).ObjectName) : undefined
        if (!resourceName) continue

        const tilePath = tileByStem.get(resourceName)
        if (!tilePath) {
            missing.add(resourceName)
            continue
        }
        placements.push({ row, col, tilePath })
    }

    let bounds: GridBounds | undefined
    if (slotRows.length > 0) {
        bounds = [Math.min(...slotRows), Math.max(...slotRows), Math.min(...slotCols), Math.max(...slotCols)]
    }
    return { placements, slotCount: slotRefs.length, bounds, missing: [...missing] }
}

/** 提取布局中所有 Image 引用的贴图资源名（去重、按出现顺序）。 */
export function extractResourceStems(layout: unknown): string[] {
    const data = layout
    if (!Array.isArray(data)) return []
    const result: string[] = []
    const seen = new Set<string>()
    for (const obj of data) {
        if (!obj || typeof obj !== "object") continue
        const row = obj as Row
        if (row.Type !== "Image") continue
        const resource = row.Properties?.Brush?.ResourceObject
        const resourceName = resource && typeof resource === "object" ? quotedResourceName((resource as Row).ObjectName) : undefined
        if (!resourceName || seen.has(resourceName)) continue
        seen.add(resourceName)
        result.push(resourceName)
    }
    return result
}
