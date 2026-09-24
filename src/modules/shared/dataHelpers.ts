import { existsSync } from "node:fs"
import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"

export type Row = Record<string, any>

export function table(ctx: ModuleContext, name: string): Row {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Row) : {}
}

export function rows(ctx: ModuleContext, name: string): Row[] {
    return Object.values(table(ctx, name)).filter((value): value is Row => !!value && typeof value === "object" && !Array.isArray(value))
}

export function sequence(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    return Object.entries(value as Row)
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

export function iconName(value: unknown): string {
    if (typeof value !== "string") return ""
    const name = value.split(/[./]/).at(-1)?.replaceAll("'", "") ?? ""
    return name.startsWith("T_Head_") ? name.slice("T_Head_".length) : name
}

export function camelCase(value: unknown): unknown {
    if (Array.isArray(value)) return value.map(camelCase)
    if (!value || typeof value !== "object") return value
    const out: Row = {}
    for (const [key, item] of Object.entries(value as Row)) out[key ? key[0].toLowerCase() + key.slice(1) : key] = camelCase(item)
    return out
}

export function putIfPresent(out: Row, key: string, value: unknown): void {
    if (value === undefined || value === null || value === "") return
    if (Array.isArray(value) && value.length === 0) return
    out[key] = value
}

/**
 * 归一 UE 资源引用路径（ShowFilePath / MediaSourceRef 等）：
 * - 去除 `Type'…'` 引用外壳（如 `LevelSequence'…'`、`FileMediaSource'…'`）
 * - 反斜杠归一为 `/`
 * - 去掉包路径末段 `.对象名` 尾缀（`SQ_X.SQ_X`）或 `.导出序号`（`X.0`）
 * 返回干净的包路径（可能以 `/Game/…` 开头）。
 */
export function quotedPackagePath(value: unknown): string | undefined {
    if (typeof value !== "string" || !value) return undefined
    const raw = (value.match(/'([^']+)'/)?.[1] ?? value).replaceAll("\\", "/").trim()
    if (!raw) return undefined
    const slash = raw.lastIndexOf("/")
    const segment = raw.slice(slash + 1)
    const dot = segment.lastIndexOf(".")
    if (dot > 0) {
        const stem = segment.slice(0, dot)
        const tail = segment.slice(dot + 1)
        if (tail === stem || /^\d+$/.test(tail)) return raw.slice(0, slash + 1) + stem
    }
    return raw
}

/**
 * 剧情视频规范名：资源引用包的基名（不含扩展与对象尾缀）。
 * 例如 `/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC020/SQ_OBT0102_SC020.SQ_OBT0102_SC020`
 * → `SQ_OBT0102_SC020`。exportStoryMedia 以该名写入 out/Video，剧情 JSON 的 video 字段
 * 使用同名，保证两侧一一对应。
 */
export function storyVideoName(value: unknown): string | undefined {
    const path = quotedPackagePath(value)
    if (!path) return undefined
    const segment = path.slice(path.lastIndexOf("/") + 1)
    return segment || undefined
}

/**
 * FMOD 事件引用（剧情节点 SoundPath）→ BGM 媒体规范名。
 *
 * SoundPath 有 `event:/bgm/1_1/0109_combat_black_market`、
 * `FMODEvent'/Game/Asset/Audio/FMOD/Events/cine/Ver0103/sc002.sc002'` 等形态；只取末段
 * （如 `sc002`）无法区分不同目录下的同名事件。规范名取事件在 `Events/` 下的完整相对路径、
 * 保留目录分隔（`cine/Ver0103/sc002`、`bgm/1_1/0109_combat_black_market`），与 Music 模块
 * 导出的事件路径（`/bgm/1_4/musicbox/…`）同构，同时也是导出音频相对输出根的路径。
 * 剧情 JSON 的 BGM resource 与 exportStoryMedia 落盘的音频使用同一名字，保证一一对应。
 */
export function fmodEventMediaName(value: unknown): string | undefined {
    const path = quotedPackagePath(value)
    if (!path) return undefined
    let rel = path.replace(/^event:\/*/i, "")
    const events = /(?:^|\/)Events\/(.+)$/i.exec(rel)
    if (events) rel = events[1]
    const segments = rel
        .replace(/\.(?:uasset|umap)$/i, "")
        .split("/")
        .filter(Boolean)
    if (segments.length === 0) return undefined
    return segments.join("/")
}

/**
 * BGM 事件规范名对应的音频是否已导出（供剧情节点过滤）。
 *
 * 剧情媒体导出按规范名落盘到 `.env` 的 DNA_BGM_EXPORT_DIR（如 `<root>/bgm/1_1/xxx.ogg`）。
 * 该目录未配置时无从判定，按"保留节点"处理（未配置解包/导出目录的环境行为不变）。
 */
export function hasExportedBgmAudio(name: string): boolean {
    const root = process.env.DNA_BGM_EXPORT_DIR?.trim()
    if (!root) return true
    return existsSync(join(root, `${name}.ogg`))
}

/**
 * 过场 TalkNode 的视频规范名：TalkType=Cinematic 且 ShowFilePath 指向
 * `/Game/Asset/Cinematics/…`（真实影片/过场资产）时返回媒体规范名
 * （供剧情节点 video 字段使用）；引擎内演出/战斗/UI 等非影片序列返回 undefined。
 */
export function cinematicTalkVideo(props: Row | undefined): string | undefined {
    if (!props || typeof props !== "object") return undefined
    if (props.TalkType !== "Cinematic") return undefined
    const path = quotedPackagePath(props.ShowFilePath)
    if (!path) return undefined
    const rel = path.replace(/^\/+/, "")
    if (!/^Game\/Asset\/Cinematics\//i.test(rel)) return undefined
    const segment = path.slice(path.lastIndexOf("/") + 1)
    return segment || undefined
}
