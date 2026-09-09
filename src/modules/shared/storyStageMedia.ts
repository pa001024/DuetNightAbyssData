/**
 * 对话演出（FixSimple/SpecialShow 等 TalkStageName）媒体定位。
 *
 * 游戏内 `TalkNode(FlowAssetPath + TalkStageName)` 会播放一段“对话演出”级联序列，
 * 序列资产位于 `/Game/AssetDesign/Story/DialogueSequence/<FlowAsset目录>/SQ_<Stage>*`，
 * 真实影片绑定在其中的 `SQ_<Stage>*_Media`（FileMediaSource）资产上（FilePath 指向 Movies）。
 * 该引用只存在于资产层（Dialogue 流 → DialogueSequence），Lua 侧没有 ShowFilePath。
 *
 * 约定（经解包资产实测）：
 * - FlowAssetPath 形如 `DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020101.11020101'`
 *   → 对话流目录 `MainStory/1102/110201`；
 * - 演出序列包基名 = `SQ_<TalkStageName>`（如 `SQ_Ex02_FixSimple_01`），媒体包为同前缀
 *   `…_Media`（可带数字/平台段，如 `SQ_Ex02_FixSimple_01_1_Media`）；
 * - 剧情 JSON 的 video 值与 out/Video 文件名统一取 `SQ_<TalkStageName>`（同 ShowFilePath 规范名语义）。
 */
import { existsSync, readdirSync } from "node:fs"
import { join } from "node:path"
import { getExportsRoot } from "../../lua/UAssetServer.ts"
import { cinematicTalkVideo, quotedPackagePath } from "./dataHelpers.ts"

const DIALOGUE_ASSET_PREFIX = "/Game/Dialogue/"
const STAGE_SEQUENCE_DIR = join("EM", "Content", "AssetDesign", "Story", "DialogueSequence")

/** 对话流目录：FlowAssetPath → `MainStory/1102/110201`（非 `/Game/Dialogue/…` 或无资产则 undefined）。 */
export function dialogueFlowDir(flowAssetPath: unknown): string | undefined {
    const path = quotedPackagePath(flowAssetPath)
    if (!path || !/^\/?Game\/Dialogue\//i.test(path)) return undefined
    const rel = path.replace(/^\/?Game\/Dialogue\//i, "")
    const slash = rel.lastIndexOf("/")
    if (slash <= 0) return undefined
    const dir = rel.slice(0, slash)
    return dir || undefined
}

/** 演出规范名：`Ex02_FixSimple_01` → `SQ_Ex02_FixSimple_01`（已带 SQ_ 前缀则原样返回）。 */
export function stageSequenceName(stageName: unknown): string | undefined {
    if (typeof stageName !== "string" || !stageName.trim()) return undefined
    const stage = stageName.trim().replace(/^SQ_/i, "")
    return `SQ_${stage}`
}

function dialogueStageRoot(flowDir: string): string | undefined {
    const exportsRoot = getExportsRoot()
    if (!exportsRoot) return undefined
    return join(exportsRoot, ...STAGE_SEQUENCE_DIR.split("/"), ...flowDir.split("/"))
}

/** 演出目录下与 stage 前缀匹配且确为影片承载资产的基名（带 `_Media`/`_Movie`/`_VIDEO` 标识；
 *  同名纯演出序列（实时渲染）不算媒体包。 */
function stageMediaStem(stem: string, prefix: string): boolean {
    if (!stem.startsWith(prefix)) return false
    const remainder = stem.slice(prefix.length)
    return /_?(?:Media|Movie|VIDEO)(?:_|$)/i.test(remainder)
}

/** 递归（≤1 层子目录）收集演出目录下匹配的 .uasset（影片绑定可能放在 Media/Light 等子目录）。 */
function collectStageMediaUnder(directory: string, prefix: string, depth: number, result: string[]): void {
    let entries: Array<{ name: string; isDir: boolean; isFile: boolean }>
    try {
        entries = readdirSync(directory, { withFileTypes: true }).map(entry => ({
            name: entry.name,
            isDir: entry.isDirectory(),
            isFile: entry.isFile(),
        }))
    } catch {
        return
    }
    for (const entry of entries) {
        if (entry.isFile && entry.name.toLowerCase().endsWith(".uasset")) {
            const stem = entry.name.slice(0, -".uasset".length)
            if (stageMediaStem(stem, prefix)) result.push(join(directory, entry.name))
            continue
        }
        if (entry.isDir && depth > 0) collectStageMediaUnder(join(directory, entry.name), prefix, depth - 1, result)
    }
}

/** 演出序列目录（AssetDesign DialogueSequence）下命中影片承载资产的候选（不存在返回空数组）。 */
export function dialogueStageFiles(stageName: unknown, flowDir: string): string[] {
    const root = dialogueStageRoot(flowDir)
    const prefix = stageSequenceName(stageName)
    if (!root || !prefix || !existsSync(root)) return []
    const result: string[] = []
    collectStageMediaUnder(root, prefix, 1, result)
    return result.sort()
}

/** 该演出（TalkStageName + 对话流目录）是否挂接了真实影片（存在 `SQ_<stage>*_Media` 等资产）。 */
export function stageHasMedia(stageName: unknown, flowDir: string): boolean {
    return dialogueStageFiles(stageName, flowDir).length > 0
}

/** TalkNode 对话演出媒体规范名：非 Cinematic、带 FlowAssetPath+TalkStageName 且该演出挂接影片时返回 `SQ_<stage>`。 */
export function dialogueStageTalkVideo(props: Record<string, any> | undefined): string | undefined {
    if (!props || typeof props !== "object") return undefined
    if (props.TalkType === "Cinematic") return undefined
    const flowDir = dialogueFlowDir(props.FlowAssetPath)
    const stage = stageSequenceName(props.TalkStageName)
    if (!flowDir || !stage) return undefined
    return stageHasMedia(props.TalkStageName, flowDir) ? stage : undefined
}

/** 剧情影片库：Movies/Story/PC 下的媒体文件（进程内懒缓存，供 CG 对话流定位）。 */
interface StoryMovieEntry {
    filePath: string
    stem: string
    folder: string
}
let storyMoviesCache: StoryMovieEntry[] | null = null
export function storyMovies(): StoryMovieEntry[] {
    if (storyMoviesCache) return storyMoviesCache
    const exportsRoot = getExportsRoot()
    const result: StoryMovieEntry[] = []
    if (exportsRoot) {
        const walk = (directory: string): void => {
            let entries: Array<{ name: string; isDir: boolean; isFile: boolean }>
            try {
                entries = readdirSync(directory, { withFileTypes: true }).map(entry => ({
                    name: entry.name,
                    isDir: entry.isDirectory(),
                    isFile: entry.isFile(),
                }))
            } catch {
                return
            }
            for (const entry of entries) {
                if (entry.isFile && /\.(mp4|webm|m4v|mov|wmv|bk2)$/i.test(entry.name)) {
                    result.push({ filePath: join(directory, entry.name), stem: entry.name.replace(/\.[^.]+$/, ""), folder: directory })
                } else if (entry.isDir) walk(join(directory, entry.name))
            }
        }
        walk(join(exportsRoot, "EM", "Content", "Movies", "Story", "PC"))
    }
    storyMoviesCache = result
    return result
}

/** 某场景码（如 `Ver0101_SC021`）对应的剧情影片文件（文件名/所在目录以场景码开头）。 */
export function storyMoviesForCode(code: string): string[] {
    const entries = storyMovies()
    const folder = code.split("/").at(-1) ?? code
    const matches = entries
        .filter(entry => {
            const folderName = entry.folder.split(/[\\/]/).at(-1) ?? ""
            return folderName === folder || entry.stem === folder || entry.stem.startsWith(`${folder}_`) || entry.stem === `SQ_${folder}`
        })
        .sort((a, b) => a.stem.localeCompare(b.stem))
    return matches.map(entry => entry.filePath)
}

/**
 * 过场 TalkNode（ShowFilePath 指向 `/Game/Asset/Cinematics/…`）：仅当 Movies 剧情影片库中确有
 * 对应影片时才返回规范名（排除纯实时渲染的演出）。值 = ShowFilePath 包基名。
 */
export function cinematicVideoWithMedia(props: Record<string, any> | undefined): string | undefined {
    const video = cinematicTalkVideo(props)
    if (!video) return undefined
    const code = video.replace(/^SQ_/, "")
    return storyMoviesForCode(code).length > 0 ? video : undefined
}

/** CG/影片型对话流（TalkNode.FlowAssetPath 的流对象名即场景码，TalkStageName 为空）的媒体规范名。 */
export function dialogueFlowCgVideo(props: Record<string, any> | undefined): string | undefined {
    if (!props || typeof props !== "object") return undefined
    if (props.TalkType === "Cinematic") return undefined
    const path = quotedPackagePath(props.FlowAssetPath)
    if (!path) return undefined
    const flowName = path.slice(path.lastIndexOf("/") + 1)
    // 形如 SQ_Ver0101_SC021 / Ver0101_SC021 的场景码型对话流
    const code = flowName.replace(/^SQ_/, "")
    if (!/^[\w]+_(?:SC|CG|Show)\d+/i.test(code) && !/^SC\d+/i.test(code)) return undefined
    if (storyMoviesForCode(code).length === 0) return undefined
    return flowName
}
