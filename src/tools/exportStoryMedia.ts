#!/usr/bin/env bun

import { copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync } from "node:fs"
import { basename, extname, isAbsolute, join } from "node:path"
import { AssetReader } from "../lua/AssetReader.ts"
import { LuaDataManager } from "../lua/LuaDataManager.ts"
import { getExportsRoot } from "../lua/UAssetServer.ts"
import { quotedPackagePath, storyVideoName } from "../modules/shared/dataHelpers.ts"
import {
    dialogueFlowCgVideo,
    dialogueFlowDir,
    dialogueStageFiles,
    stageSequenceName,
    storyMoviesForCode,
} from "../modules/shared/storyStageMedia.ts"

type Row = Record<string, any>
type MediaItem = { resource: string; story: string; node: string }
type StageMediaItem = { stage: string; flowDir: string; story: string; node: string }
type CgMediaItem = { cg: string; story: string; node: string }

const projectRoot = join(import.meta.dir, "..", "..")
const exportsRoot = getExportsRoot()
if (!exportsRoot) throw new Error("无法定位 DNA_UNPACK_DIR/Fmodel/Output/Exports")
const contentRoot = join(exportsRoot, "EM", "Content")
const assetRoot = join(contentRoot, "Asset")
const outputRoot = join(projectRoot, "out")
const fmodelLogRoot = join(exportsRoot, "..", "Logs")

function quotedPath(value: unknown): string | undefined {
    return quotedPackagePath(value)
}

function isBgmResource(value: string): boolean {
    const normalized = value.replaceAll("\\", "/").toLowerCase()
    return (normalized.startsWith("event:/bgm/") || normalized.includes("/events/bgm/")) && !/(?:^|\/)mute(?:\.|$)/i.test(normalized)
}

export function normalizeBgmAssetPath(value: string): string {
    let normalized = value
        .trim()
        .replaceAll("\\", "/")
        .replace(/^'+|'+$/g, "")
    normalized = normalized.replace(/^event:\//i, "EM/Content/Asset/Audio/FMOD/Events/")
    normalized = normalized.replace(/^\/?Game\//i, "EM/Content/")
    normalized = normalized.replace(/^\/?Asset\//i, "EM/Content/Asset/")
    normalized = normalized.replace(/^\/+/, "")
    normalized = normalized.replace(/\.(?:uasset|umap)$/i, "")
    normalized = normalized.replace(/\.([^/.]+)$/, "")
    return `${normalized}.uasset`
}

export function parseFModelSoundLog(text: string, wantedPaths?: ReadonlySet<string>): Map<string, string[]> {
    const result = new Map<string, string[]>()
    let currentEvent: string | undefined
    for (const line of text.split(/\r?\n/)) {
        const extracted = line.match(/Extract: User DOUBLE-CLICKED to extract '([^']+)'/)
        if (extracted) {
            const path = extracted[1].replaceAll("\\", "/")
            currentEvent = /\/Asset\/Audio\/FMOD\/Events\//i.test(path) ? normalizeBgmAssetPath(path) : undefined
            continue
        }
        const saved = line.match(/SaveAndPlaySound: Successfully saved (.+?\.ogg)\s*$/i)
        if (!saved || !currentEvent || (wantedPaths && !wantedPaths.has(currentEvent))) continue
        const paths = result.get(currentEvent) ?? []
        const source = saved[1].replaceAll("\\", "/")
        if (!paths.includes(source)) paths.push(source)
        result.set(currentEvent, paths)
    }
    return result
}

export function loadFModelSoundMap(logRoot: string, wantedPaths: ReadonlySet<string>): Map<string, string[]> {
    const result = new Map<string, string[]>()
    for (const entry of readdirSync(logRoot, { withFileTypes: true })) {
        if (!entry.isFile() || !/^FModel-Log-.*\.log$/i.test(entry.name)) continue
        const parsed = parseFModelSoundLog(readFileSync(join(logRoot, entry.name), "utf8"), wantedPaths)
        for (const [event, paths] of parsed) {
            const existing = result.get(event) ?? []
            for (const path of paths) if (!existing.includes(path)) existing.push(path)
            result.set(event, existing)
        }
    }
    return result
}

function storyNodes(value: Row): Array<{ id: string; node: Row }> {
    const result: Array<{ id: string; node: Row }> = []
    const parents = value.storyNodeData && typeof value.storyNodeData === "object" ? value.storyNodeData : {}
    for (const [parentKey, parentValue] of Object.entries(parents as Row)) {
        const parent = parentValue as Row
        result.push({ id: String(parent.key ?? parentKey), node: parent })
        const childData = parent.questNodeData?.nodeData
        if (childData && typeof childData === "object")
            for (const [nodeKey, node] of Object.entries(childData as Row)) result.push({ id: nodeKey, node: node as Row })
    }
    return result
}

function scalarStoryPaths(dm: LuaDataManager, table: string, fields: string[]): string[] {
    const result: string[] = []
    for (const row of dm.loadScriptTableRows(`Script/Datas/${table}.lua`, fields)) {
        for (const field of fields) {
            const value = row[field]
            if (typeof value === "string" && value) result.push(value)
        }
    }
    return result
}

function storyFilePath(path: string): string {
    // 与 DialogueService.story 一致：`.story` 后缀对应剧情 Lua 文件。
    const normalized = path.replace(/\.story$/i, "").replaceAll("\\", "/")
    return normalized.toLowerCase().endsWith(".lua") ? normalized : `${normalized}.lua`
}

export function collectReferencedStoryPaths(dm: LuaDataManager): Set<string> {
    const paths = new Set<string>()
    for (const path of [
        ...scalarStoryPaths(dm, "QuestChain", ["StoryPath"]),
        ...scalarStoryPaths(dm, "DynQuest", ["StoryPath"]),
        ...scalarStoryPaths(dm, "PartyTopic", ["PartyTopicTalkId"]),
        ...scalarStoryPaths(dm, "RougeLikeStoryEvent", ["EventStoryline"]),
        ...scalarStoryPaths(dm, "RougeLikeRoom", ["EventStoryline"]),
        ...scalarStoryPaths(dm, "CinematicReview", ["StoryLinePath"]),
        ...scalarStoryPaths(dm, "TalkTrigger", ["StoryLinePath"]),
        ...scalarStoryPaths(dm, "NpcGossipTrigger", ["StoryLinePath"]),
    ]) {
        paths.add(path.replaceAll("\\", "/"))
    }
    return paths
}

export function specialStoryPaths(dm: LuaDataManager, story: Row): string[] {
    const configRows = new Map<string, string>()
    for (const row of dm.loadScriptTableRows("Script/Datas/SpecialQuestConfig.lua", ["StoryPath"])) {
        if (typeof row.__key === "string" && typeof row.StoryPath === "string" && row.StoryPath) configRows.set(row.__key, row.StoryPath)
    }
    const result: string[] = []
    for (const { node } of storyNodes(story)) {
        if (node.type !== "WaitingSpecialQuestStartAndFinishNode") continue
        const props = node.propsData && typeof node.propsData === "object" ? node.propsData : {}
        const id = String(props.SpecialConfigId ?? props.QuestId ?? "")
        const path = configRows.get(id)
        if (path) result.push(path.replaceAll("\\", "/"))
    }
    return result
}

export function collectMedia(dm: LuaDataManager, storyPaths: Iterable<string>): { videos: MediaItem[]; bgm: MediaItem[] } {
    const videos: MediaItem[] = []
    const bgm: MediaItem[] = []
    for (const story of storyPaths) {
        const data = dm.loadStoryFile(join("Script", "StoryCreator", "StoryFiles", storyFilePath(story))) as Row | undefined
        if (!data) continue
        for (const { id, node } of storyNodes(data)) {
            const props = node.propsData && typeof node.propsData === "object" ? node.propsData : {}
            if (node.type === "TalkNode" && props.TalkType === "Cinematic" && quotedPath(props.ShowFilePath))
                videos.push({ resource: quotedPath(props.ShowFilePath)!, story, node: id })
            else if (node.type === "VideoNode" && quotedPath(props.MediaSourceRef))
                videos.push({ resource: quotedPath(props.MediaSourceRef)!, story, node: id })
            if (node.type === "PlayOrStopBGMNode" && Number(props.SoundStateType) === 0) {
                const resource = quotedPath(props.SoundPath)
                if (resource && isBgmResource(resource)) bgm.push({ resource, story, node: id })
            }
        }
    }
    return { videos, bgm }
}

function objectPath(value: unknown): string | undefined {
    if (!value || typeof value !== "object") return undefined
    return typeof (value as Row).ObjectPath === "string" ? (value as Row).ObjectPath : undefined
}

function mediaSourceName(value: unknown): string {
    if (!value || typeof value !== "object") return ""
    const name = String((value as Row).ObjectName ?? "")
    return name.replace(/^[^']*'/, "").replace(/'.*$/, "")
}

/**
 * UE 包引用（`/Game/Asset/…`、`EM/Content/…`、`Asset/…`、`Game/…` 等形态）→ 解包目录下的
 * .uasset 绝对路径。包引用可能带 `.导出序号`（如 `SQ_X.0`）或 `.对象名` 尾缀，先归一再拼。
 */
function packageToUasset(path: string): string {
    const normalized = quotedPackagePath(path) ?? path
    const rel = normalized
        .replace(/^\/+/, "")
        .replace(/^EM\/Content\//i, "")
        .replace(/^Game\//i, "")
        .replace(/^\/?Asset\//i, "Asset/")
        .replace(/\.[0-9]+$/, "")
        .replace(/\.(?:uasset|umap)$/i, "")
    if (!rel) return join(exportsRoot!, `${normalized.replace(/^\/+/, "")}.uasset`)
    return join(contentRoot, `${rel}.uasset`)
}

/**
 * 从媒体引用的包路径推导其在解包目录下的资产目录与包基名。
 * 资源引用统一走 quotedPackagePath 归一后的完整包路径（`/Game/…` 前缀优先）。
 */
function packageLocation(resource: string): { directory: string; name: string } | null {
    let normalized = quotedPackagePath(resource) ?? resource
    normalized = normalized
        .replace(/\\/g, "/")
        .replace(/^\/+/, "")
        .replace(/^Game\//i, "")
    if (normalized.startsWith("EM/Content/")) normalized = normalized.slice("EM/Content/".length)
    const segments = normalized.split("/").filter(Boolean)
    const name = segments.pop()
    if (!name) return null
    // `Asset/…` 挂载在 assetRoot（EM/Content/Asset）下，其余（AssetDesign/Movies/…）在 contentRoot 下。
    const underAsset = segments[0] === "Asset"
    const root = underAsset ? assetRoot : contentRoot
    const directory = join(root, ...(underAsset ? segments.slice(1) : segments))
    return { directory, name }
}

function localMediaFilePath(data: unknown[], ref: unknown): string | undefined {
    const wantedPath = objectPath(ref)
    const wantedName = mediaSourceName(ref)
    const source = data.find(item => {
        const row = item as Row
        return (
            row?.Type === "FileMediaSource" &&
            ((wantedPath && row.Outer?.ObjectPath === wantedPath) || (wantedName && row.Name === wantedName))
        )
    }) as Row | undefined
    return typeof source?.Properties?.FilePath === "string" ? source.Properties.FilePath : undefined
}

async function mediaFilePath(reader: AssetReader, data: unknown[], ref: unknown): Promise<string | undefined> {
    const local = localMediaFilePath(data, ref)
    if (local) return local
    const path = objectPath(ref)
    if (!path) return undefined
    const sourceData = await reader.readFModelAsset(packageToUasset(path))
    return sourceData ? localMediaFilePath(sourceData, ref) : undefined
}

function subSequenceRefs(data: unknown[]): string[] {
    return data
        .filter(item => String((item as Row)?.Type ?? "") === "MovieSceneSubSection")
        .map(item => objectPath((item as Row)?.Properties?.SubSequence))
        .filter((value): value is string => !!value)
}

export async function sequenceMedia(reader: AssetReader, sequence: string, seen = new Set<string>()): Promise<string[]> {
    const key = sequence.replaceAll("\\", "/")
    if (seen.has(key)) return []
    seen.add(key)
    const data = await reader.readFModelAsset(sequence)
    if (!data) return []
    const result: string[] = []
    // 包自身直接携带 FileMediaSource（独立媒体源包 / 序列内联源）时直接取用其媒体文件。
    for (const item of data) {
        const row = item as Row
        if (row?.Type === "FileMediaSource" && typeof row.Properties?.FilePath === "string") result.push(row.Properties.FilePath)
    }
    for (const ref of mediaRefs(data)) {
        const path = await mediaFilePath(reader, data, ref)
        if (path) result.push(path)
    }
    for (const ref of subSequenceRefs(data)) result.push(...(await sequenceMedia(reader, packageToUasset(ref), seen)))
    return [...new Set(result)]
}

function mediaRefs(data: unknown[]): unknown[] {
    return data
        .filter(item => ["EMMovieSceneMediaSection", "MovieSceneMediaSection"].includes(String((item as Row)?.Type ?? "")))
        .map(item => (item as Row)?.Properties?.MediaSource)
        .filter(Boolean)
}

/** 变体资产归类：与 Shot/Light/Audio 等纯内部子序列区分，只保留可能携带媒体段的候选。 */
function isCandidateVariant(stem: string, canonical: string): boolean {
    const noSq = canonical.replace(/^SQ_/, "")
    let remainder = ""
    if (stem === canonical || stem === noSq) return true
    if (stem.startsWith(`${canonical}_`)) remainder = stem.slice(canonical.length)
    else if (stem.startsWith(`${noSq}_`)) remainder = stem.slice(noSq.length)
    else return false
    return !/^_(?:Shot|Light|Audio|Common)\d*/i.test(remainder)
}

/**
 * 过场引用对应的候选 LevelSequence：优先精确包名；缺失时在场景目录内找变体
 * （`_F/_M/_EF/_EM/_PC/_Mobile/_VIDEO` 等）。场景目录不存在或空 → 空（对应引擎内演出或未解包）。
 */
export function sequenceCandidates(showPath: string): string[] {
    const location = packageLocation(showPath)
    const canonical = storyVideoName(showPath)
    if (!location || !canonical) return []
    const exact = join(location.directory, `${location.name}.uasset`)
    if (existsSync(exact)) return [exact]
    let entries: string[]
    try {
        entries = readdirSync(location.directory, { withFileTypes: true })
            .filter(entry => entry.isFile() && entry.name.toLowerCase().endsWith(".uasset"))
            .map(entry => entry.name.slice(0, -".uasset".length))
    } catch {
        return []
    }
    const result = entries
        .filter(stem => isCandidateVariant(stem, canonical))
        .sort()
        .map(stem => join(location.directory, `${stem}.uasset`))
    return result
}

function locateSource(filePath: string): string | undefined {
    const normalized = filePath.replace(/^\.\//, "").replaceAll("\\", "/")
    if (isAbsolute(normalized)) return existsSync(normalized) ? normalized : undefined
    const exact = join(contentRoot, normalized)
    return existsSync(exact) ? exact : undefined
}

/** 主变体偏好：精确包名最优，其次常见主视频变体，其余按字典序兜底。 */
const VARIANT_PREFERENCE = ["", "_VIDEO", "_PC", "_EF", "_F", "_EM", "_M", "_Mobile"]

function variantRemainder(stem: string, canonical: string): string {
    for (const prefix of [canonical, canonical.replace(/^SQ_/, "")]) {
        if (stem === prefix) return ""
        if (stem.startsWith(`${prefix}_`)) return stem.slice(prefix.length)
    }
    return `_${stem}`
}

/**
 * Movies 目录媒体文件基名 → 变体段（`''`=主文件，`F`/`EM` 等）。文件基名须以场景码
 * （可带 `SQ_` 前缀）开头；无关文件（如跨场景动画分镜）返回 undefined 予以忽略。
 * `_Movie` 尾缀视为主文件名，不构成变体。
 */
export function movieStemLabel(stem: string, sceneCode: string): string | undefined {
    let rest = stem
    if (rest.startsWith(`SQ_${sceneCode}`)) rest = rest.slice(`SQ_${sceneCode}`.length)
    else if (rest.startsWith(sceneCode)) rest = rest.slice(sceneCode.length)
    else return undefined
    rest = rest.replace(/^_+/, "").replace(/_?Movie$/i, "")
    return rest
}

/**
 * 序列资产缺失时的兜底：按 `Movies/Story/PC/<章节>/<场景>` 目录约定直接定位真实影片。
 * 仅当引用指向 `/Game/Asset/Cinematics/Story/…` 且该目录内存在媒体文件时返回条目，否则 null。
 * 不改变既有序列解析优先序；找不到任何现有文件时仍视为无视频。
 */
function storyMovieFallback(resource: string, canonical: string): Array<{ filePath: string; remainder: string }> | null {
    const pkg = quotedPackagePath(resource)
    if (!pkg || !canonical) return null
    const marker = "/Cinematics/Story/"
    const markerIndex = pkg.indexOf(marker)
    if (markerIndex < 0) return null
    const relative = pkg
        .slice(markerIndex + marker.length)
        .split("/")
        .filter(Boolean)
        .slice(0, -1)
    if (relative.length === 0) return null
    const directory = join(contentRoot, "Movies", "Story", "PC", ...relative)
    let names: string[]
    try {
        names = readdirSync(directory, { withFileTypes: true })
            .filter(entry => entry.isFile() && /\.(mp4|webm|m4v|mov|wmv|bk2)$/i.test(entry.name))
            .map(entry => entry.name)
    } catch {
        return null
    }
    const sceneCode = canonical.replace(/^SQ_/, "")
    const result: Array<{ filePath: string; remainder: string }> = []
    for (const name of names.sort()) {
        const stem = name.replace(/\.[^.]+$/, "")
        const label = movieStemLabel(stem, sceneCode)
        if (label === undefined) continue
        result.push({ filePath: join(directory, name), remainder: label ? `_${label}` : "" })
    }
    return result.length > 0 ? result : null
}

/**
 * 把某场景/演出的媒体条目规划为规范文件名并登记到输出表。
 * - 主文件固定为 `规范名.<扩展>`（与剧情 JSON 的 video 字段一一对应）；
 * - 其余不同媒体变体以 `规范名_变体.<扩展>` 全量导出（同一媒体被多处引用只导出一次）。
 */
function recordMediaEntries(
    canonical: string,
    entries: Array<{ filePath: string; remainder: string }>,
    output: Map<string, string>,
    conflicts: string[],
    origin: string
): void {
    const rank = (remainder: string): number => {
        const index = VARIANT_PREFERENCE.indexOf(remainder)
        return index === -1 ? VARIANT_PREFERENCE.length : index
    }
    entries.sort((left, right) => rank(left.remainder) - rank(right.remainder) || left.filePath.localeCompare(right.filePath))
    const usedName = new Map<string, number>()
    const seenSource = new Set<string>()
    let primaryAssigned = false
    for (const entry of entries) {
        if (seenSource.has(entry.filePath)) continue
        seenSource.add(entry.filePath)
        const label = entry.remainder.replace(/^_/, "")
        const base = !primaryAssigned ? canonical : label ? `${canonical}_${label}` : `${canonical}_alt`
        primaryAssigned = true
        const count = usedName.get(base) ?? 0
        usedName.set(base, count + 1)
        const name = count === 0 ? base : `${base}${count + 1}`
        const source = locateSource(entry.filePath)
        if (!source) throw new Error(`找不到视频文件 ${entry.filePath}，来源 ${origin}`)
        const previous = output.get(name)
        if (previous && previous !== source) {
            conflicts.push(`${name} (${previous} vs ${source}, ${origin})`)
            continue
        }
        output.set(name, source)
    }
}

/**
 * 解析一批剧情视频引用并规划输出文件名。
 * - 主文件固定为 `资源规范名.<扩展>`（如 `SQ_OBT0102_SC020.mp4`），与剧情 JSON 的 video 字段一一对应；
 * - 同一场景的其他媒体变体以 `规范名_变体.<扩展>`（如 `SQ_OBT0102_SC018_EM.mp4`）保留全量导出。
 */
export async function collectVideoFiles(reader: AssetReader, items: MediaItem[]): Promise<Map<string, string>> {
    const output = new Map<string, string>()
    const conflicts: string[] = []
    for (const item of items) {
        const canonical = storyVideoName(item.resource)
        if (!canonical) continue
        const entries: Array<{ filePath: string; remainder: string }> = []
        const sequences = sequenceCandidates(item.resource)
        if (sequences.length > 0) {
            for (const sequence of sequences) {
                const media = await sequenceMedia(reader, sequence)
                if (media.length === 0) continue
                const stem = basename(sequence).replace(/\.(?:uasset|umap)$/i, "")
                const remainder = variantRemainder(stem, canonical)
                for (const filePath of media) entries.push({ filePath, remainder })
            }
        }
        // 序列资产未解包/未携带媒体时，按 Movies 目录约定直接定位真实影片。
        if (entries.length === 0) {
            const fallback = storyMovieFallback(item.resource, canonical)
            if (fallback) entries.push(...fallback)
        }
        if (entries.length === 0) continue
        recordMediaEntries(canonical, entries, output, conflicts, `${item.story}:${item.node}`)
    }
    if (conflicts.length) throw new Error(`视频缩名冲突: ${conflicts.join("; ")}`)
    return output
}

/**
 * 收集带真实影片的对话演出节点（TalkNode 走 FlowAssetPath+TalkStageName、经 DialogueSequence
 * 资产挂接影片的类型，如 FixSimple/SpecialShow）。影片存在性以解包内 `SQ_<stage>*_Media` 资产为准。
 */
export function collectStageMediaItems(dm: LuaDataManager, storyPaths: Iterable<string>): StageMediaItem[] {
    const result: StageMediaItem[] = []
    for (const story of storyPaths) {
        const data = dm.loadStoryFile(join("Script", "StoryCreator", "StoryFiles", storyFilePath(story))) as Row | undefined
        if (!data) continue
        for (const { id, node } of storyNodes(data)) {
            if (node.type !== "TalkNode") continue
            const props = node.propsData && typeof node.propsData === "object" ? node.propsData : {}
            if (props.TalkType === "Cinematic" || quotedPath(props.ShowFilePath)) continue
            const flowDir = dialogueFlowDir(props.FlowAssetPath)
            const stage = typeof props.TalkStageName === "string" && props.TalkStageName.trim() ? props.TalkStageName : undefined
            if (!flowDir || !stage) continue
            if (dialogueStageFiles(stage, flowDir).length === 0) continue
            result.push({ stage, flowDir, story, node: id })
        }
    }
    return result
}

/**
 * 导出对话演出（DialogueSequence）媒体：读取演出目录内 `SQ_<stage>*_Media` 等媒体资产，
 * 以 `SQ_<stage>` 为规范名登记（与剧情 JSON 的 video 字段一致）。
 */
export async function collectStageVideoFiles(reader: AssetReader, items: StageMediaItem[]): Promise<Map<string, string>> {
    const output = new Map<string, string>()
    const conflicts: string[] = []
    const seen = new Set<string>()
    for (const item of items) {
        const key = `${item.flowDir}\x00${item.stage}`
        if (seen.has(key)) continue
        seen.add(key)
        const canonical = stageSequenceName(item.stage)
        if (!canonical) continue
        const entries: Array<{ filePath: string; remainder: string }> = []
        for (const packageFile of dialogueStageFiles(item.stage, item.flowDir)) {
            const media = await sequenceMedia(reader, packageFile)
            if (media.length === 0) continue
            const stem = basename(packageFile).replace(/\.(?:uasset|umap)$/i, "")
            const remainder = variantRemainder(stem, canonical)
            for (const filePath of media) entries.push({ filePath, remainder })
        }
        if (entries.length === 0) continue
        recordMediaEntries(canonical, entries, output, conflicts, `${item.story}:${item.node}`)
    }
    if (conflicts.length) throw new Error(`对话演出视频缩名冲突: ${conflicts.join("; ")}`)
    return output
}

/**
 * 收集 CG/影片型对话流节点（TalkNode.FlowAssetPath 的流对象名即场景码、且 Movies 中有对应影片，
 * 如 `SQ_Ver0101_SC021`）。影片存在性以 Movies 剧情影片库为准。
 */
export function collectFlowCgMediaItems(dm: LuaDataManager, storyPaths: Iterable<string>): CgMediaItem[] {
    const result: CgMediaItem[] = []
    for (const story of storyPaths) {
        const data = dm.loadStoryFile(join("Script", "StoryCreator", "StoryFiles", storyFilePath(story))) as Row | undefined
        if (!data) continue
        for (const { id, node } of storyNodes(data)) {
            if (node.type !== "TalkNode") continue
            const props = node.propsData && typeof node.propsData === "object" ? node.propsData : {}
            if (props.TalkType === "Cinematic" || quotedPath(props.ShowFilePath)) continue
            const cg = dialogueFlowCgVideo(props)
            if (!cg) continue
            result.push({ cg, story, node: id })
        }
    }
    return result
}

/** 导出 CG 对话流影片：以流对象名（如 `SQ_Ver0101_SC021`）为规范名登记（与剧情 JSON 的 video 字段一致）。 */
export function collectFlowCgVideoFiles(items: CgMediaItem[]): Map<string, string> {
    const output = new Map<string, string>()
    const conflicts: string[] = []
    const seen = new Set<string>()
    for (const item of items) {
        if (seen.has(item.cg)) continue
        seen.add(item.cg)
        const canonical = item.cg
        const code = canonical.replace(/^SQ_/, "")
        const entries: Array<{ filePath: string; remainder: string }> = []
        for (const filePath of storyMoviesForCode(code)) {
            const stem = basename(filePath).replace(/\.[^.]+$/, "")
            const remainder = variantRemainder(stem, canonical)
            entries.push({ filePath, remainder })
        }
        if (entries.length === 0) continue
        recordMediaEntries(canonical, entries, output, conflicts, `${item.story}:${item.node}`)
    }
    if (conflicts.length) throw new Error(`CG 对话流视频缩名冲突: ${conflicts.join("; ")}`)
    return output
}

export function collectBgmFiles(items: MediaItem[], soundMap: ReadonlyMap<string, readonly string[]>): Map<string, string> {
    const output = new Map<string, string>()
    for (const item of items) {
        const name = basename(item.resource).replace(/\.[^.]+$/, "")
        const event = normalizeBgmAssetPath(item.resource)
        const matches = soundMap.get(event) ?? []
        if (matches.length !== 1) throw new Error(`BGM 资源 ${name} from ${item.story}:${item.node} mapped to ${matches.length} OGG files`)
        const source = matches[0]
        if (!existsSync(source)) throw new Error(`找不到 BGM 文件 ${source}，来源 ${item.story}:${item.node}`)
        const previous = output.get(name)
        if (previous && previous !== source) throw new Error(`BGM 缩名冲突: ${name}`)
        output.set(name, source)
    }
    return output
}

function writeFiles(kind: string, files: Map<string, string>): void {
    const destination = join(outputRoot, kind)
    mkdirSync(destination, { recursive: true })
    for (const [name, source] of files) copyFileSync(source, join(destination, `${name}${extname(source)}`))
}

/**
 * 枚举 StoryCreator/StoryFiles 下的全部剧情文件（相对路径、不含 .lua），
 * 用于 `--all-stories` 模式：不依赖 QuestChain 等引用表，直接遍历所有剧情文件。
 */
function collectAllStoryPaths(): string[] {
    const storyRoot = join(projectRoot, "Script", "StoryCreator", "StoryFiles")
    const result: string[] = []
    const visit = (directory: string): void => {
        for (const entry of readdirSync(directory, { withFileTypes: true })) {
            const full = join(directory, entry.name)
            if (entry.isDirectory()) {
                visit(full)
                continue
            }
            if (entry.isFile() && /\.lua$/i.test(entry.name)) {
                const rel = full
                    .slice(storyRoot.length + 1)
                    .replace(/\\/g, "/")
                    .replace(/\.lua$/i, "")
                if (rel) result.push(rel)
            }
        }
    }
    visit(storyRoot)
    return result
}

export async function exportStoryMedia(): Promise<{ videos: number; bgm: number }> {
    const reader = new AssetReader(projectRoot)
    try {
        const dm = new LuaDataManager(projectRoot)
        const allStories = Bun.argv.includes("--all-stories")
        const videoOnly = Bun.argv.includes("--video-only")
        const allVideos: MediaItem[] = []
        const allBgm: MediaItem[] = []
        const allStages: StageMediaItem[] = []
        const stageSeen = new Set<string>()
        const allCg: CgMediaItem[] = []
        const cgSeen = new Set<string>()
        const addStageItems = (items: StageMediaItem[]): void => {
            for (const item of items) {
                const key = `${item.flowDir}\x00${item.stage}`
                if (stageSeen.has(key)) continue
                stageSeen.add(key)
                allStages.push(item)
            }
        }
        const addCgItems = (items: CgMediaItem[]): void => {
            for (const item of items) {
                if (cgSeen.has(item.cg)) continue
                cgSeen.add(item.cg)
                allCg.push(item)
            }
        }
        if (allStories) {
            const paths = collectAllStoryPaths()
            const media = collectMedia(dm, paths)
            allVideos.push(...media.videos)
            allBgm.push(...media.bgm)
            addStageItems(collectStageMediaItems(dm, paths))
            addCgItems(collectFlowCgMediaItems(dm, paths))
        } else {
            const storyPaths = collectReferencedStoryPaths(dm)
            const processedStories = new Set<string>()
            while (storyPaths.size > processedStories.size) {
                const pending = [...storyPaths].filter(path => !processedStories.has(path))
                for (const path of pending) processedStories.add(path)
                const media = collectMedia(dm, pending)
                allVideos.push(...media.videos)
                allBgm.push(...media.bgm)
                addStageItems(collectStageMediaItems(dm, pending))
                addCgItems(collectFlowCgMediaItems(dm, pending))
                for (const path of pending) {
                    const story = dm.loadStoryFile(join("Script", "StoryCreator", "StoryFiles", storyFilePath(path))) as Row | undefined
                    if (!story) continue
                    for (const special of specialStoryPaths(dm, story)) storyPaths.add(special)
                }
            }
        }
        const videos = await collectVideoFiles(reader, allVideos)
        const stageVideos = await collectStageVideoFiles(reader, allStages)
        const cgVideos = collectFlowCgVideoFiles(allCg)
        for (const extra of [stageVideos, cgVideos]) {
            for (const [name, source] of extra) {
                const previous = videos.get(name)
                if (previous && previous !== source) throw new Error(`视频缩名冲突: ${name} (过场 ${previous} vs 对话演出 ${source})`)
                videos.set(name, source)
            }
        }
        writeFiles("Video", videos)
        if (videoOnly) return { videos: videos.size, bgm: 0 }
        const wantedBgmPaths = new Set(allBgm.map(item => normalizeBgmAssetPath(item.resource)))
        const soundMap = loadFModelSoundMap(fmodelLogRoot, wantedBgmPaths)
        const bgm = collectBgmFiles(allBgm, soundMap)
        writeFiles("BGM", bgm)
        return { videos: videos.size, bgm: bgm.size }
    } finally {
        await reader.close()
    }
}

if (import.meta.main) {
    const result = await exportStoryMedia()
    console.log(`导出完成: Video ${result.videos}, BGM ${result.bgm}`)
}
