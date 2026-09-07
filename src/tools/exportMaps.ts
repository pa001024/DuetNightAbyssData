#!/usr/bin/env bun
/**
 * exportMaps — 批量导出 Map_Splice 地图（TypeScript 独立工具）。
 *
 * 数据源：解包目录（DNA_UNPACK_DIR）中 FModel Exports 的 UMG 布局资产
 * （.uasset 经 UAssetCLI server 解析，或同路径 .json 静态回退）与贴图 PNG。
 * 行为：遍历 Map_Splice 目录下每个布局 → 读 UniformGridPanel 槽位的
 * Row/Column → 按网格坐标把整张贴图 alpha 合成进透明画布 → 输出拼接 PNG，
 * 保留 Map_Splice 下的相对目录结构。
 *
 * 用法：bun run src/tools/exportMaps.ts [--splice-dir X] [--texture-root X]
 *       [--output-root X] [--grid-name Main] [--force-static-json]
 */
import { copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from "node:fs"
import { dirname, join } from "node:path"
import { PNG } from "pngjs"
import { getExportsRoot, getUassetExe, getUnpackDir, UAssetServer } from "../lua/UAssetServer.ts"
import {
    collectTiles,
    extractResourceStems,
    type GridBounds,
    parseLayoutPlacements,
    type TilePlacement,
    textureInputDir,
} from "./exportMapsLayout.ts"

const projectRoot = join(import.meta.dir, "..", "..")

interface Options {
    spliceDir: string
    textureRoot: string
    outputRoot: string
    gridName: string
    forceStaticJson: boolean
}

interface Counts {
    total: number
    ok: number
    skip: number
    fail: number
}

function helpText(): string {
    return `用法: bun run src/tools/exportMaps.ts [选项]

批量导出 Map_Splice 地图拼接 PNG。

选项:
  --splice-dir <dir>     Map_Splice uasset/json 根目录
                         (默认: <解包目录>/Fmodel/Output/Exports/EM/Content/UI/WBP/Map/Widget/Map_Splice)
  --texture-root <dir>   地图贴图根目录
                         (默认: <解包目录>/Fmodel/Output/Exports/EM/Content/UI/Texture/Static)
  --output-root <dir>    输出根目录 (默认: <仓库>/out/map_splice, 保留相对目录结构)
  --grid-name <name>     UniformGridPanel 名称 (默认: Main)
  --force-static-json    强制使用静态 .json 布局 (不走 UAssetCLI server)
  -h, --help             显示本帮助`
}

function parseArgs(argv: string[]): Options | "help" {
    const fallbackSplice = defaultSpliceDir()
    const fallbackTexture = defaultTextureRoot()
    if (!fallbackSplice || !fallbackTexture) {
        throw new Error("无法定位解包目录: 请设置 .env 的 DNA_UNPACK_DIR 或提供 --splice-dir/--texture-root")
    }
    const options: Options = {
        spliceDir: fallbackSplice,
        textureRoot: fallbackTexture,
        outputRoot: join(projectRoot, "out", "map_splice"),
        gridName: "Main",
        forceStaticJson: false,
    }
    for (let i = 0; i < argv.length; i++) {
        const arg = argv[i]
        const value = (): string => {
            const next = argv[++i]
            if (next === undefined) throw new Error(`缺少参数值: ${arg}`)
            return next
        }
        switch (arg) {
            case "--splice-dir":
                options.spliceDir = value()
                break
            case "--texture-root":
                options.textureRoot = value()
                break
            case "--output-root":
                options.outputRoot = value()
                break
            case "--grid-name":
                options.gridName = value()
                break
            case "--force-static-json":
                options.forceStaticJson = true
                break
            case "-h":
            case "--help":
                return "help"
            default:
                throw new Error(`未知参数: ${arg}`)
        }
    }
    return options
}

function defaultSpliceDir(): string | null {
    const unpack = getUnpackDir()
    if (!unpack) return null
    const dir = join(unpack, "Fmodel", "Output", "Exports", "EM", "Content", "UI", "WBP", "Map", "Widget", "Map_Splice")
    return existsSync(dir) ? dir : null
}

function defaultTextureRoot(): string | null {
    const unpack = getUnpackDir()
    if (!unpack) return null
    const dir = join(unpack, "Fmodel", "Output", "Exports", "EM", "Content", "UI", "Texture", "Static")
    return existsSync(dir) ? dir : null
}

/** 递归收集某后缀文件并按路径排序。 */
function collectFiles(root: string, suffix: string): string[] {
    const result: string[] = []
    const walk = (dir: string): void => {
        let entries: string[]
        try {
            entries = readdirSync(dir)
        } catch {
            return
        }
        for (const entry of entries) {
            const full = join(dir, entry)
            let stat: ReturnType<typeof statSync>
            try {
                stat = statSync(full)
            } catch {
                continue
            }
            if (stat.isDirectory()) walk(full)
            else if (stat.isFile() && full.toLowerCase().endsWith(suffix)) result.push(full)
        }
    }
    walk(root)
    return result.sort()
}

/** 读取布局数据：server 模式经 UAssetCLI fmodel，静态模式读 .json。失败返回 null。 */
async function loadLayoutData(server: UAssetServer | null, source: string, exportsRoot: string): Promise<unknown[] | null> {
    if (server !== null) {
        const data = await server.fmodel(source, exportsRoot)
        if (data === null) return null
        return data
    }
    try {
        const text = readFileSync(source, "utf8")
        const data = JSON.parse(text)
        return Array.isArray(data) ? data : null
    } catch {
        return null
    }
}

/**
 * 把贴图按 (row, col) 合成到透明画布。
 * 画布尺寸由网格边界与首张贴图尺寸决定（保留网格原点 0 起排布）。
 */
function stitchPlacements(
    placements: TilePlacement[],
    bounds: GridBounds,
    decode: (path: string) => { width: number; height: number; data: Buffer }
): PNG {
    const [, maxRow, , maxCol] = bounds
    const first = decode(placements[0].tilePath)
    const tileWidth = first.width
    const tileHeight = first.height
    const width = (maxCol + 1) * tileWidth
    const height = (maxRow + 1) * tileHeight
    const canvas = new PNG({ width, height })
    const rawCache = new Map<string, { width: number; height: number; data: Buffer }>()
    const rawFor = (path: string): { width: number; height: number; data: Buffer } => {
        const cached = rawCache.get(path)
        if (cached) return cached
        const raw = decode(path)
        rawCache.set(path, raw)
        return raw
    }
    for (const placement of placements) {
        const tile = rawFor(placement.tilePath)
        const x = placement.col * tileWidth
        const y = placement.row * tileHeight
        pasteWithAlpha(canvas.data, width, height, tile.data, tile.width, tile.height, x, y)
    }
    return canvas
}

/**
 * 把 src（RGBA）以自身 alpha 为掩码粘贴进 dst（RGBA）的 (x, y)。
 * alpha=255 直接覆盖；alpha=0 跳过；中间值按 PIL paste 的线性加权混合。
 */
function pasteWithAlpha(
    dst: Buffer,
    canvasWidth: number,
    canvasHeight: number,
    src: Buffer,
    srcWidth: number,
    srcHeight: number,
    x: number,
    y: number
): void {
    if (x >= canvasWidth || y >= canvasHeight) return
    const rows = Math.min(srcHeight, canvasHeight - y)
    const cols = Math.min(srcWidth, canvasWidth - x)
    if (rows <= 0 || cols <= 0) return
    for (let ty = 0; ty < rows; ty++) {
        let si = ty * srcWidth * 4
        let di = (y + ty) * canvasWidth * 4 + x * 4
        for (let tx = 0; tx < cols; tx++) {
            const alpha = src[si + 3]
            if (alpha === 0) {
                // 完全透明：保留背景
            } else if (alpha === 255) {
                dst[di] = src[si]
                dst[di + 1] = src[si + 1]
                dst[di + 2] = src[si + 2]
                dst[di + 3] = 255
            } else {
                const inverse = 255 - alpha
                for (let c = 0; c < 4; c++) {
                    dst[di + c] = Math.round((src[si + c] * alpha + dst[di + c] * inverse) / 255)
                }
            }
            si += 4
            di += 4
        }
    }
}

function decodeTile(path: string): { width: number; height: number; data: Buffer } {
    const buffer = readFileSync(path)
    const png = PNG.sync.read(buffer)
    return { width: png.width, height: png.height, data: png.data }
}

/** 无 UniformGridPanel 的回退：把布局引用的贴图原样复制为输出。 */
function copyFallback(outFile: string, stems: string[], tileByStem: Map<string, string>): number {
    const matched: string[] = []
    for (const stem of stems) {
        const path = tileByStem.get(stem)
        if (path !== undefined) matched.push(path)
    }
    if (matched.length === 0) return 0
    mkdirSync(dirname(outFile), { recursive: true })
    copyFileSync(matched[0], outFile)
    for (let i = 1; i < matched.length; i++) {
        const extra = outFile.replace(/(\.[^.]+)$/, `_${i + 1}$1`)
        copyFileSync(matched[i], extra)
    }
    return matched.length
}

export async function exportMaps(options: Options): Promise<Counts> {
    const { spliceDir, textureRoot, outputRoot, gridName, forceStaticJson } = options
    if (!existsSync(spliceDir)) throw new Error(`Map_Splice 目录不存在: ${spliceDir}`)
    if (!existsSync(textureRoot)) throw new Error(`贴图根目录不存在: ${textureRoot}`)
    mkdirSync(outputRoot, { recursive: true })

    const exportsRoot = getExportsRoot()
    const exe = getUassetExe()
    const uassets = collectFiles(spliceDir, ".uasset")
    const useServer = !forceStaticJson && exe !== null && exportsRoot !== null && uassets.length > 0
    const sources = useServer ? uassets : collectFiles(spliceDir, ".json")
    if (useServer) {
        console.log(`[INFO] 数据源: UAssetCLI server 模式（${uassets.length} 个 uasset）`)
    } else {
        console.log(`[INFO] 数据源: 静态 JSON（${forceStaticJson ? "已强制" : "无 uasset / exe"}）`)
    }
    console.log(`[INFO] 扫描目录: ${spliceDir}`)
    console.log(`[INFO] 输出目录: ${outputRoot}`)

    const server = useServer ? new UAssetServer(exe!) : null
    const counts: Counts = { total: sources.length, ok: 0, skip: 0, fail: 0 }
    try {
        for (const source of sources) {
            const rel = source.slice(spliceDir.length).replace(/^[\\/]+/, "")
            const layout = await loadLayoutData(server, source, exportsRoot ?? "")
            if (layout === null) {
                console.log(`[SKIP] ${source} / 布局数据不可用`)
                counts.skip++
                continue
            }
            console.log(`[RUN ] ${rel}`)

            const inputDir = textureInputDir(layout, textureRoot)
            if (inputDir === null) {
                counts.skip++
                continue
            }
            const tileByStem = collectTiles(inputDir)
            if (tileByStem.size === 0) {
                console.log(`[SKIP] 未找到 png 贴图: ${inputDir}`)
                counts.skip++
                continue
            }

            const parsed = parseLayoutPlacements(layout, gridName, tileByStem)
            const outFile = join(outputRoot, `${rel.replace(/\.[^.]+$/, "")}.png`)
            if (parsed !== null && parsed.placements.length > 0 && parsed.bounds !== undefined) {
                try {
                    const canvas = stitchPlacements(parsed.placements, parsed.bounds, decodeTile)
                    mkdirSync(dirname(outFile), { recursive: true })
                    const encoded = PNG.sync.write(canvas, { colorType: 6, inputColorType: 6 })
                    writeFileSync(outFile, encoded)
                    console.log(
                        `[ OK ] ${rel}  slots=${parsed.slotCount}  used=${parsed.placements.length}  size=${canvas.width}x${canvas.height}`
                    )
                    counts.ok++
                } catch (error) {
                    console.log(`[FAIL] ${rel} / ${error instanceof Error ? error.message : error}`)
                    counts.fail++
                }
                continue
            }

            if (parsed === null) {
                // 无 UniformGridPanel：复制布局直接引用的贴图
                const stems = extractResourceStems(layout)
                const fileCount = copyFallback(outFile, stems, tileByStem)
                if (fileCount === 0) {
                    console.log(`[SKIP] ${rel} / 无 UniformGridPanel 且无可复制图片`)
                    counts.skip++
                } else {
                    console.log(`[ OK ] ${rel}  fallback=copy  file=${fileCount}`)
                    counts.ok++
                }
                continue
            }

            console.log(`[SKIP] ${rel} / 布局中没有可用贴图`)
            counts.skip++
        }
    } finally {
        if (server !== null) await server.close()
    }
    return counts
}

if (import.meta.main) {
    let options: Options
    try {
        const parsed = parseArgs(process.argv.slice(2))
        if (parsed === "help") {
            console.log(helpText())
            process.exit(0)
        }
        options = parsed
    } catch (error) {
        console.error(error instanceof Error ? error.message : String(error))
        console.error(helpText())
        process.exit(2)
    }
    const counts = await exportMaps(options)
    console.log("===== 完成 =====")
    console.log(`TOTAL=${counts.total}  OK=${counts.ok}  SKIP=${counts.skip}  FAIL=${counts.fail}`)
    console.log(`输出目录: ${options.outputRoot}`)
    if (counts.fail > 0) process.exitCode = 1
}
