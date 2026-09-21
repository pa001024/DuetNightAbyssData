import { join } from "node:path"
import { AssetReader } from "../../lua/AssetReader.ts"
import { getExportsRoot } from "../../lua/UAssetServer.ts"

type Row = Record<string, any>
type Rect = [number, number, number, number]
type Maps = ReturnType<typeof buildObjectMaps>

export interface RegionMapEntry {
    name: string
    pos: number[]
    opacity: number
    zOrder: number
}

export interface RegionMapLayout {
    entries: RegionMapEntry[]
    /** 地图控件是否含 `Img_Map` 子部件。含则游戏直接用作者坐标渲染图层，不含则运行时按世界坐标重排。 */
    hasImageMap: boolean
    /** 运行时重排口的建议地图中心（世界坐标），仅在不含 `Img_Map` 且锚点可用时给出。 */
    mapCenter?: [number, number]
}

/** 运行时重排锚点：`pos` 为锚点作者 slotPos，`world` 为锚点世界坐标，`worldBySplice` 为各拼接图层名对应的世界坐标。 */
export interface RegionMapAnchor {
    pos: number[]
    world: [number, number]
    worldBySplice: Map<string, [number, number]>
}

/** 世界坐标与地图像素的换算比例：`LevelMap_Wild_Dialog_PC_C.lua` 的 `self.Scale = 1/30`。 */
const WORLD_UNITS_PER_PIXEL = 30

function refParts(value: unknown): [string | undefined, string | undefined] {
    if (typeof value !== "string" || !value) return [undefined, undefined]
    let raw = value.replace(/^'+|'+$/g, "")
    const colon = raw.indexOf(":")
    if (colon >= 0) raw = raw.slice(colon + 1)
    const parts = raw.split(".")
    return parts.length >= 2 ? [parts.at(-2), parts.at(-1)] : [undefined, parts[0]]
}

function buildObjectMaps(nodes: Row[]) {
    const byOuter = new Map<string, Row>()
    const byName = new Map<string, Row[]>()
    const byPath = new Map<string, Row>()
    for (const node of nodes) {
        const name = typeof node.Name === "string" ? node.Name : undefined
        if (name) byName.set(name, [...(byName.get(name) ?? []), node])
        const outerValue = node.Outer && typeof node.Outer === "object" ? node.Outer.ObjectName : node.Outer
        const outer = typeof outerValue === "string" ? outerValue : undefined
        const [, outerShort] = refParts(outer)
        if (outer && name) byOuter.set(`${outer}\0${name}`, node)
        if (outerShort && name) byOuter.set(`${outerShort}\0${name}`, node)
        if (typeof node.ObjectPath === "string") byPath.set(node.ObjectPath, node)
    }
    return { byOuter, byName, byPath }
}

function resolveRef(ref: unknown, maps: Maps): Row | undefined {
    if (!ref || typeof ref !== "object") return undefined
    const row = ref as Row
    if (typeof row.ObjectPath === "string") {
        const found = maps.byPath.get(row.ObjectPath)
        if (found) return found
    }
    const [outer, name] = refParts(row.ObjectName)
    if (!name) return undefined
    if (outer) {
        const found = maps.byOuter.get(`${outer}\0${name}`)
        if (found) return found
    }
    const candidates = maps.byName.get(name) ?? []
    return candidates.length > 0 ? candidates[0] : undefined
}

function num(value: unknown): number {
    const result = Number(value ?? 0)
    return Number.isFinite(result) ? result : 0
}

function roundEven(value: number): number {
    const sign = value < 0 ? -1 : 1
    const absolute = Math.abs(value)
    const floor = Math.floor(absolute)
    const fraction = absolute - floor
    if (fraction < 0.5) return sign * floor
    if (fraction > 0.5) return sign * (floor + 1)
    return sign * (floor % 2 === 0 ? floor : floor + 1)
}

/**
 * 按游戏运行时规则重排 `IsRandom` 子区域图层：锚点保留作者 slotPos，其余子区域
 * `slotPos(i) = 锚点作者 slotPos + (world_i - world_anchor) / 30`，尺寸不变。
 * 未命中世界坐标的图层（非 `IsRandom` 子区域，如背景层）保持原位。
 */
export function relayoutIsRandom(entries: RegionMapEntry[], anchor: RegionMapAnchor): RegionMapEntry[] {
    return entries.map(entry => {
        const world = anchor.worldBySplice.get(entry.name)
        if (!world) return entry
        return {
            ...entry,
            pos: [
                roundEven(anchor.pos[0] + (world[0] - anchor.world[0]) / WORLD_UNITS_PER_PIXEL),
                roundEven(anchor.pos[1] + (world[1] - anchor.world[1]) / WORLD_UNITS_PER_PIXEL),
                entry.pos[2],
                entry.pos[3],
            ],
        }
    })
}

/**
 * 推导地图中心：前端以「投影帧」中心对齐 `mapCenter`，帧为含 `_Bg` 图层时取这些图层的并集，
 * 否则取全部图层并集。世界坐标与像素为线性关系，故
 * `mapCenter = world_anchor + (帧中心 - 锚点中心) * 30`。
 */
export function centerFromAnchor(entries: RegionMapEntry[], anchor: RegionMapAnchor): [number, number] {
    const base = entries.filter(item => item.name.includes("_Bg"))
    const frame = base.length > 0 ? base : entries
    const minX = Math.min(...frame.map(item => item.pos[0]))
    const minY = Math.min(...frame.map(item => item.pos[1]))
    const maxX = Math.max(...frame.map(item => item.pos[0] + item.pos[2]))
    const maxY = Math.max(...frame.map(item => item.pos[1] + item.pos[3]))
    const centerX = anchor.pos[0] + anchor.pos[2] / 2
    const centerY = anchor.pos[1] + anchor.pos[3] / 2
    return [
        roundEven(anchor.world[0] + ((minX + maxX) / 2 - centerX) * WORLD_UNITS_PER_PIXEL),
        roundEven(anchor.world[1] + ((minY + maxY) / 2 - centerY) * WORLD_UNITS_PER_PIXEL),
    ]
}

function slotGeometry(parent: Rect, props: Row, fallback: [number, number]): Rect {
    const layout = props.LayoutData && typeof props.LayoutData === "object" ? props.LayoutData : {}
    const offsets = layout.Offsets && typeof layout.Offsets === "object" ? layout.Offsets : {}
    const anchors = layout.Anchors && typeof layout.Anchors === "object" ? layout.Anchors : {}
    const alignment = layout.Alignment && typeof layout.Alignment === "object" ? layout.Alignment : {}
    const minimum = anchors.Minimum && typeof anchors.Minimum === "object" ? anchors.Minimum : {}
    const maximum = anchors.Maximum && typeof anchors.Maximum === "object" ? anchors.Maximum : minimum
    const left = num(offsets.Left)
    const top = num(offsets.Top)
    const right = num(offsets.Right)
    const bottom = num(offsets.Bottom)
    const minX = num(minimum.X)
    const minY = num(minimum.Y)
    const maxX = maximum.X === undefined ? minX : num(maximum.X)
    const maxY = maximum.Y === undefined ? minY : num(maximum.Y)
    const [px, py, pw, ph] = parent

    if (Math.abs(minX - maxX) < 1e-6 && Math.abs(minY - maxY) < 1e-6) {
        const width = props.bAutoSize ? fallback[0] : Math.max(0, roundEven(right))
        const height = props.bAutoSize ? fallback[1] : Math.max(0, roundEven(bottom))
        return [
            roundEven(px + pw * minX + left - num(alignment.X) * width),
            roundEven(py + ph * minY + top - num(alignment.Y) * height),
            width,
            height,
        ]
    }

    const x = px + pw * minX + left
    const y = py + ph * minY + top
    let width = roundEven(px + pw * maxX - right - x)
    let height = roundEven(py + ph * maxY - bottom - y)
    if (width <= 0) width = fallback[0]
    if (height <= 0) height = fallback[1]
    return [roundEven(x), roundEven(y), width, height]
}

function inferCanvasSize(nodes: Row[]): [number, number] {
    let width = 0
    let height = 0
    for (const node of nodes) {
        if (node.Type !== "CanvasPanelSlot") continue
        const offsets = node.Properties?.LayoutData?.Offsets
        if (!offsets || typeof offsets !== "object") continue
        width = Math.max(width, num(offsets.Right))
        height = Math.max(height, num(offsets.Bottom))
    }
    return [width > 0 ? roundEven(width) : 4096, height > 0 ? roundEven(height) : 4096]
}

function renderOpacity(node: Row): number {
    const value = node.Properties?.RenderOpacity
    return typeof value === "number" ? Math.min(1, Math.max(0, value)) : 1
}

function isVisible(node: Row): boolean {
    const visibility = node.Properties?.Visibility
    return typeof visibility !== "string" || (!visibility.includes("Hidden") && !visibility.includes("Collapsed"))
}

function classPath(node: Row): string | undefined {
    const value = typeof node.Class === "string" ? node.Class : ""
    return value.match(/WidgetBlueprintGeneratedClass'([^']+)'/)?.[1]
}

function isMapSplice(node: Row): boolean {
    const type = node.Type
    if (typeof type !== "string" || !type.startsWith("WBP_Map_") || !type.endsWith("_C")) return false
    if (type.includes("Reg_") && !type.endsWith("_BG_C")) return false
    return classPath(node)?.includes("/Map_Splice/") ?? false
}

function rootPanel(nodes: Row[], maps: Maps): Row | undefined {
    const tree = nodes.find(node => node.Type === "WidgetTree")
    const root = resolveRef(tree?.Properties?.RootWidget, maps)
    return root?.Type === "CanvasPanel"
        ? root
        : (nodes.find(node => node.Type === "CanvasPanel" && node.Name === "Main") ?? nodes.find(node => node.Type === "CanvasPanel"))
}

function spliceGridSlot(nodes: Row[], gridName: string): Row | undefined {
    const maps = buildObjectMaps(nodes)
    const panel = rootPanel(nodes, maps)
    let first: Row | undefined
    for (const slotRef of panel?.Properties?.Slots ?? []) {
        const slot = resolveRef(slotRef, maps)
        if (slot?.Type !== "CanvasPanelSlot") continue
        const content = resolveRef(slot.Properties?.Content, maps)
        if (content?.Type !== "UniformGridPanel") continue
        first ??= slot.Properties
        if (content.Name === gridName) return slot.Properties
    }
    if (first) return first
    const grid = nodes.find(node => node.Type === "UniformGridPanel" && node.Name === gridName)
    const slot = resolveRef(grid?.Properties?.Slot, maps)
    return slot?.Type === "CanvasPanelSlot" ? slot.Properties : undefined
}

export class RegionMapReader {
    private readonly reader: AssetReader
    private readonly exportsRoot: string
    private readonly cache = new Map<string, Row[]>()

    constructor(root: string) {
        const exportsRoot = getExportsRoot()
        if (!exportsRoot) throw new Error("Region map export requires DNA_UNPACK_DIR with an FModel Exports directory")
        this.exportsRoot = exportsRoot
        this.reader = new AssetReader(root)
    }

    async close(): Promise<void> {
        await this.reader.close()
    }

    private async load(packagePath: string): Promise<Row[]> {
        const normalized = packagePath.replace(/^\/+|\.[^.]+$/g, "")
        const cached = this.cache.get(normalized)
        if (cached) return cached
        const relative = normalized.startsWith("Game/") ? join("EM", "Content", normalized.slice(5)) : normalized
        const path = join(this.exportsRoot, `${relative}.uasset`)
        const data = await this.reader.readFModelAsset(path)
        if (!data) throw new Error(`UAssetCLI could not read region map asset: ${path}`)
        const nodes = data.filter((item): item is Row => !!item && typeof item === "object" && !Array.isArray(item))
        this.cache.set(normalized, nodes)
        return nodes
    }

    private resolvePanelRect(panel: Row, base: Rect, maps: Maps, cache: Map<Row, Rect>, visiting: Set<Row>): Rect | undefined {
        const cached = cache.get(panel)
        if (cached) return cached
        if (visiting.has(panel)) return undefined
        visiting.add(panel)
        try {
            const slot = resolveRef(panel.Properties?.Slot, maps)
            if (!slot) {
                if (panel.Name === "Main") cache.set(panel, base)
                return panel.Name === "Main" ? base : undefined
            }
            const [, parentName] = refParts(typeof slot.Outer === "object" ? slot.Outer?.ObjectName : slot.Outer)
            const parent = parentName ? maps.byName.get(parentName)?.find(candidate => candidate.Type === "CanvasPanel") : undefined
            const parentRect = parent ? (this.resolvePanelRect(parent, base, maps, cache, visiting) ?? base) : base
            const rect = slotGeometry(parentRect, slot.Properties ?? {}, [parentRect[2], parentRect[3]])
            cache.set(panel, rect)
            return rect
        } finally {
            visiting.delete(panel)
        }
    }

    private async addSplice(
        node: Row,
        slotProps: Row,
        parent: Rect,
        opacity: number,
        zOrder: number,
        result: RegionMapEntry[],
        seen: Set<Row>
    ): Promise<void> {
        if (!isMapSplice(node) || seen.has(node)) return
        seen.add(node)
        const path = classPath(node)
        if (!path) return
        const packagePath = path.split(".", 1)[0]
        const child = await this.load(packagePath)
        const fallback = inferCanvasSize(child)
        let [x, y, width, height] = slotGeometry(parent, slotProps, fallback)
        const innerSlot = spliceGridSlot(child, process.env.DNA_MAP_SPLICE_GRID_NAME ?? "Main")
        if (innerSlot) {
            const [innerX, innerY, innerWidth, innerHeight] = slotGeometry([0, 0, width, height], innerSlot, fallback)
            x += innerX
            y += innerY
            width = innerWidth
            height = innerHeight
        }
        const roundedOpacity = Math.round(opacity * 1e6) / 1e6
        result.push({ name: packagePath.split("/").at(-1)!, pos: [x, y, width, height], opacity: roundedOpacity, zOrder })
    }

    private async walkPanel(
        panel: Row,
        parent: Rect,
        opacity: number,
        zOrder: number,
        maps: Maps,
        result: RegionMapEntry[],
        seen: Set<Row>,
        stack: Set<Row>
    ): Promise<void> {
        if (stack.has(panel)) return
        stack.add(panel)
        try {
            const slots = (panel.Properties?.Slots ?? [])
                .map((ref: unknown, index: number) => ({ index, slot: resolveRef(ref, maps) }))
                .filter(
                    (item: { index: number; slot?: Row }): item is { index: number; slot: Row } => item.slot?.Type === "CanvasPanelSlot"
                )
                .sort(
                    (a: { index: number; slot: Row }, b: { index: number; slot: Row }) =>
                        num(a.slot.Properties?.ZOrder) - num(b.slot.Properties?.ZOrder) || a.index - b.index
                )
            for (const { slot } of slots) {
                const content = resolveRef(slot.Properties?.Content, maps)
                if (!content || !isVisible(content)) continue
                const childOpacity = opacity * renderOpacity(content)
                if (childOpacity <= 0) continue
                const childZOrder = num(slot.Properties?.ZOrder)
                if (content.Type === "CanvasPanel") {
                    const rect = slotGeometry(parent, slot.Properties ?? {}, [parent[2], parent[3]])
                    await this.walkPanel(content, rect, childOpacity, zOrder + childZOrder, maps, result, seen, stack)
                } else await this.addSplice(content, slot.Properties ?? {}, parent, childOpacity, zOrder + childZOrder, result, seen)
            }
        } finally {
            stack.delete(panel)
        }
    }

    private async widgetFor(imagePath: string): Promise<{ nodes: Row[]; maps: Maps; panel: Row }> {
        const marker = "/Game/UI/WBP/Map/Widget/RegionMap/"
        if (!imagePath.includes(marker)) throw new Error(`Unexpected RegionMapImage path: ${imagePath}`)
        const packagePath = `Game/UI/WBP/Map/Widget/RegionMap/${imagePath.split(marker, 2)[1].split(".", 1)[0]}`
        const nodes = await this.load(packagePath)
        const maps = buildObjectMaps(nodes)
        const panel = rootPanel(nodes, maps)
        if (!panel) throw new Error(`Region map asset has no CanvasPanel: ${imagePath}`)
        return { nodes, maps, panel }
    }

    /** 取区域部件下某个子区域子部件的拼接图层名（部件名即子区域 id）。 */
    private spliceNameOf(nodes: Row[], subRegionId: number): string | undefined {
        const node = nodes.find(candidate => candidate.Name === String(subRegionId))
        const path = node ? classPath(node) : undefined
        return path?.split(".", 1)[0].split("/").at(-1)
    }

    /**
     * 解析运行时重排的锚点：`IsRandom` 中第一个既能找到同名部件、又有 `SubRegionCenter` 的子区域。
     * 锚点保留作者坐标，其余子区域按世界坐标差平移。
     */
    private runtimeAnchor(
        nodes: Row[],
        entries: RegionMapEntry[],
        isRandom: number[],
        centers: Map<string, [number, number]>
    ): RegionMapAnchor | undefined {
        const worldBySplice = new Map<string, [number, number]>()
        for (const id of isRandom) {
            const splice = this.spliceNameOf(nodes, id)
            const world = centers.get(String(id))
            if (splice && world) worldBySplice.set(splice, world)
        }
        for (const id of isRandom) {
            const splice = this.spliceNameOf(nodes, id)
            if (!splice || !worldBySplice.has(splice)) continue
            const entry = entries.find(item => item.name === splice)
            if (!entry) continue
            return { pos: entry.pos, world: worldBySplice.get(splice)!, worldBySplice }
        }
        return undefined
    }

    /**
     * 读取地图控件的完整布局。
     *
     * 不含 `Img_Map` 的控件由游戏在运行时按 `IsRandom` 子区域的世界坐标重排：
     * `slotPos(i) = 锚点作者 slotPos + (world_i - world_anchor) / 30`，作者坐标不再成立，
     * 因此这里同步重算图层位置并推导地图中心。`resolveCenters` 只在该分支下被调用。
     */
    async layoutFor(
        imagePath: string,
        isRandom: number[],
        resolveCenters: (ids: number[]) => Map<string, [number, number]>
    ): Promise<RegionMapLayout> {
        const { nodes } = await this.widgetFor(imagePath)
        const entries = await this.mappingFor(imagePath)
        const hasImageMap = nodes.some(node => node.Name === "Img_Map")
        if (hasImageMap || isRandom.length === 0) return { entries, hasImageMap }
        const anchor = this.runtimeAnchor(nodes, entries, isRandom, resolveCenters(isRandom))
        if (!anchor) return { entries, hasImageMap }
        const relaid = relayoutIsRandom(entries, anchor)
        return { entries: relaid, hasImageMap, mapCenter: centerFromAnchor(relaid, anchor) }
    }

    async mappingFor(imagePath: string): Promise<RegionMapEntry[]> {
        const { nodes, maps, panel } = await this.widgetFor(imagePath)
        const [width, height] = inferCanvasSize(nodes)
        const base: Rect = [0, 0, width, height]
        const result: RegionMapEntry[] = []
        const seen = new Set<Row>()
        await this.walkPanel(panel, base, 1, 0, maps, result, seen, new Set())

        const panelRects = new Map<Row, Rect>()
        for (const node of nodes) {
            if (!isMapSplice(node) || seen.has(node)) continue
            const slot = resolveRef(node.Properties?.Slot, maps)
            if (slot?.Type !== "CanvasPanelSlot") continue
            const [, parentName] = refParts(typeof slot.Outer === "object" ? slot.Outer?.ObjectName : slot.Outer)
            const parent = parentName ? maps.byName.get(parentName)?.find(candidate => candidate.Type === "CanvasPanel") : undefined
            if (!parent) continue
            const parentRect = this.resolvePanelRect(parent, base, maps, panelRects, new Set())
            if (parentRect) await this.addSplice(node, slot.Properties ?? {}, parentRect, 1, num(slot.Properties?.ZOrder), result, seen)
        }

        if (result.length === 2) {
            const background = result.find(item => item.name.endsWith("_BG"))
            const foreground = result.find(item => !item.name.endsWith("_BG"))
            if (
                background &&
                foreground &&
                background.pos[2] === foreground.pos[2] &&
                background.pos[3] === foreground.pos[3] &&
                foreground.zOrder >= background.zOrder
            )
                foreground.pos = [background.pos[0], background.pos[1], foreground.pos[2], foreground.pos[3]]
        }
        return result
    }
}
