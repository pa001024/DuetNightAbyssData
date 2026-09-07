#!/usr/bin/env bun

import { copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync } from "node:fs"
import { basename, extname, join } from "node:path"
import { AssetReader } from "../lua/AssetReader.ts"
import { LuaDataManager } from "../lua/LuaDataManager.ts"
import { getExportsRoot } from "../lua/UAssetServer.ts"

type Row = Record<string, any>
type MediaItem = { resource: string; story: string; node: string }

const projectRoot = join(import.meta.dir, "..", "..")
const exportsRoot = getExportsRoot()
if (!exportsRoot) throw new Error("无法定位 DNA_UNPACK_DIR/Fmodel/Output/Exports")
const contentRoot = join(exportsRoot, "EM", "Content")
const assetRoot = join(contentRoot, "Asset")
const outputRoot = join(projectRoot, "out")
const fmodelLogRoot = join(exportsRoot, "..", "Logs")

function quotedPath(value: unknown): string | undefined {
    if (typeof value !== "string" || !value) return undefined
    return (value.match(/'([^']+)'/)?.[1] ?? value).replaceAll("\\", "/") || undefined
}

function resourceName(value: string): string {
    return basename(value.replaceAll("\\", "/"))
        .replace(/\.[^.]+$/, "")
        .replaceAll("'", "")
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
    const normalized = path.replaceAll("\\", "/")
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

function specialStoryPaths(dm: LuaDataManager, story: Row): string[] {
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

function objectName(value: unknown): string {
    if (!value || typeof value !== "object") return ""
    return String((value as Row).ObjectName ?? "")
}

function objectRefName(value: unknown): string {
    return objectName(value)
        .replace(/^[^']*'/, "")
        .replace(/'.*$/, "")
}

function packageToUasset(path: string): string {
    const normalized = path.replace(/\.[0-9]+$/, "").replace(/\.(?:uasset|umap)$/i, "")
    return join(exportsRoot!, `${normalized}.uasset`)
}

function mediaObjectCandidates(path: string): string[] {
    const normalized = path
        .replace(/^\/?Game\//, "")
        .replace(/^Asset\//, "")
        .replace(/^\/+/, "")
    const segments = normalized.split("/").filter(Boolean)
    const name = segments.pop()
    if (!name) return []
    const directory = join(assetRoot, ...segments)
    return [join(directory, `${name}.uasset`), join(directory, `${name.replace(/^SQ_/, "")}.uasset`)]
}

function mediaRefs(data: unknown[]): unknown[] {
    return data
        .filter(item => ["EMMovieSceneMediaSection", "MovieSceneMediaSection"].includes(String((item as Row)?.Type ?? "")))
        .map(item => (item as Row)?.Properties?.MediaSource)
        .filter(Boolean)
}

function localMediaFilePath(data: unknown[], ref: unknown): string | undefined {
    const wantedPath = objectPath(ref)
    const wantedName = objectRefName(ref)
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
    for (const ref of mediaRefs(data)) {
        const path = await mediaFilePath(reader, data, ref)
        if (path) result.push(path)
    }
    for (const ref of subSequenceRefs(data)) result.push(...(await sequenceMedia(reader, packageToUasset(ref), seen)))
    return [...new Set(result)]
}

export function sequenceCandidates(showPath: string): string[] {
    const token = basename(showPath).replace(/^SQ_/, "")
    const scene = showPath.match(/(SC\d+)$/)?.[1]
    if (!scene) return []
    const directories = new Set<string>()
    const visit = (directory: string): void => {
        for (const entry of readdirSync(directory, { withFileTypes: true })) {
            const path = join(directory, entry.name)
            if (entry.isDirectory()) {
                visit(path)
                continue
            }
            if (entry.name.includes(token) && entry.name.endsWith(".uasset")) directories.add(directory)
        }
    }
    visit(join(assetRoot, "Cinematics", "Story"))
    const result: string[] = []
    for (const directory of directories)
        for (const entry of readdirSync(directory, { withFileTypes: true }))
            if (entry.isFile() && entry.name.startsWith("SQ_") && entry.name.includes(scene) && entry.name.endsWith(".uasset"))
                result.push(join(directory, entry.name))
    return result
}

function locateSource(filePath: string): string | undefined {
    const relativePath = filePath.replace(/^\.\//, "").replaceAll("\\", "/")
    const exact = join(contentRoot, relativePath)
    return existsSync(exact) ? exact : undefined
}

export async function collectVideoFiles(reader: AssetReader, items: MediaItem[]): Promise<Map<string, string>> {
    const candidateCache = new Map<string, string[]>()
    const output = new Map<string, string>()
    for (const item of items) {
        const directCandidates = mediaObjectCandidates(item.resource).filter(existsSync)
        const sequences =
            directCandidates.length > 0 ? directCandidates : (candidateCache.get(item.resource) ?? sequenceCandidates(item.resource))
        candidateCache.set(item.resource, sequences)
        if (sequences.length === 0) continue
        const paths: string[] = []
        for (const sequence of sequences) {
            const media = await sequenceMedia(reader, sequence)
            if (media.length) paths.push(...media)
        }
        if (paths.length === 0) continue
        for (const filePath of paths) {
            const source = locateSource(filePath)
            if (!source) throw new Error(`找不到视频文件 ${filePath}，来源 ${item.story}:${item.node}`)
            const name = resourceName(source)
            const previous = output.get(name)
            if (previous && previous !== source) throw new Error(`视频缩名冲突: ${name}`)
            output.set(name, source)
        }
    }
    return output
}

export function collectBgmFiles(items: MediaItem[], soundMap: ReadonlyMap<string, readonly string[]>): Map<string, string> {
    const output = new Map<string, string>()
    for (const item of items) {
        const name = resourceName(item.resource)
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

export async function exportStoryMedia(): Promise<{ videos: number; bgm: number }> {
    const reader = new AssetReader(projectRoot)
    try {
        const dm = new LuaDataManager(projectRoot)
        const storyPaths = collectReferencedStoryPaths(dm)
        const processedStories = new Set<string>()
        const allVideos: MediaItem[] = []
        const allBgm: MediaItem[] = []
        while (storyPaths.size > processedStories.size) {
            const pending = [...storyPaths].filter(path => !processedStories.has(path))
            for (const path of pending) processedStories.add(path)
            const media = collectMedia(dm, pending)
            allVideos.push(...media.videos)
            allBgm.push(...media.bgm)
            for (const path of pending) {
                const story = dm.loadStoryFile(join("Script", "StoryCreator", "StoryFiles", storyFilePath(path))) as Row | undefined
                if (!story) continue
                for (const special of specialStoryPaths(dm, story)) storyPaths.add(special)
            }
        }
        const videos = await collectVideoFiles(reader, allVideos)
        const wantedBgmPaths = new Set(allBgm.map(item => normalizeBgmAssetPath(item.resource)))
        const soundMap = loadFModelSoundMap(fmodelLogRoot, wantedBgmPaths)
        const bgm = collectBgmFiles(allBgm, soundMap)
        writeFiles("Video", videos)
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
