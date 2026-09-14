/**
 * exportRaw — 把 Script/Datas 下的 Lua 表整体导出为 JSON（对齐旧版 Python 流水线 step1 的产物形态）。
 *
 * 与主 out 流水线的区别：不做任何领域解释、不渲染多语言，只把每张 Lua 表的原始形状
 * 深度排序后写成一个 JSON 文件，输出路径保持 Datas 下的相对目录结构：
 *
 *   Script/Datas/AbyssBuff.lua       -> out/AbyssBuff.json
 *   Script/Datas/Seat_data/Foo.lua   -> out/Seat_data/Foo.json
 *
 * 取数走共享 LuaDataManager（同一 Fengari state、同一套 stubs），因此 `require` / `DataMgr`
 * 与 -v 历史版本数据根都自然生效；返回值先经 __deep_materialize 展开 __pairs，
 * 避免 TextMap_ContentXX / Dialogue_ContentXX / Talk_SoundXX 这类代理表在 lua_next 下读成空表。
 */

import { mkdirSync, readdirSync, writeFileSync } from "node:fs"
import { dirname, join, relative, sep } from "node:path"
import { deepSortJson, type SortableJson } from "../lua/deepSort.ts"
import type { LuaDataManager } from "../lua/LuaDataManager.ts"

export interface ExportRawOptions {
    /** Lua 数据层；决定 Script/Datas 的位置（CLI 传共享单例以复用 -v 数据根） */
    dm: LuaDataManager
    /** 输出目录 */
    outDir: string
    /** 逐文件进度与失败信息 */
    log?: (message: string) => void
}

export interface ExportRawResult {
    /** 已写出的文件（相对 outDir 的路径，统一用 / 分隔） */
    written: string[]
    /** 跳过的文件与原因（文件缺失、编译/执行失败、无返回值） */
    failed: Array<{ file: string; error: string }>
}

/** 递归列出 Datas 目录下的 Lua 文件（相对路径，按字典序，统一用 / 分隔）。 */
export function listDatasLuaFiles(datasDir: string): string[] {
    const found: string[] = []
    const walk = (dir: string): void => {
        for (const entry of readdirSync(dir, { withFileTypes: true })) {
            const full = join(dir, entry.name)
            if (entry.isDirectory()) walk(full)
            else if (entry.isFile() && entry.name.endsWith(".lua")) found.push(relative(datasDir, full).split(sep).join("/"))
        }
    }
    walk(datasDir)
    return found.sort()
}

/** Lua 值 → 落盘 JSON 文本：键深度排序 + 2 空格缩进 + 末尾换行（与 final/ 输出一致）。 */
export function rawJsonText(value: unknown): string {
    return `${JSON.stringify(deepSortJson(value as SortableJson), null, 2)}\n`
}

/** 把 Script/Datas 下的全部 Lua 表导出到 outDir。 */
export function exportRawDatas(options: ExportRawOptions): ExportRawResult {
    const { dm, outDir, log } = options
    const datasDir = join(dm.scriptDataRoot, "Script", "Datas")
    const result: ExportRawResult = { written: [], failed: [] }

    for (const rel of listDatasLuaFiles(datasDir)) {
        const { value, error } = dm.loadScriptValue(join("Script", "Datas", rel))
        if (value === undefined) {
            result.failed.push({ file: rel, error: error ?? "未知错误" })
            log?.(`! ${rel}: ${error ?? "未知错误"}`)
            continue
        }
        const outRel = rel.replace(/\.lua$/, ".json")
        const outFile = join(outDir, outRel)
        mkdirSync(dirname(outFile), { recursive: true })
        const text = rawJsonText(value)
        writeFileSync(outFile, text, "utf8")
        result.written.push(outRel)
        log?.(`导出 ${outRel} (${text.length} 字符)`)
    }

    return result
}
