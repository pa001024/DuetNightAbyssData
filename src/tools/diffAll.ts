#!/usr/bin/env bun
/**
 * diffAll — 列出 final_ts（新） vs final（老）的全部字段级差异。
 *
 * 用法：
 *   bun run src/tools/diffAll.ts                     # Char + Weapon
 *   bun run src/tools/diffAll.ts --file Weapon       # 只看某文件
 *   bun run src/tools/diffAll.ts --max 200           # 最多输出 N 条（默认全部）
 */
import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"

const baseDir = join(import.meta.dir, "..", "..")

function parseArgs(argv: string[]) {
    const out: Record<string, string> = {}
    for (let i = 0; i < argv.length; i++) {
        if (argv[i].startsWith("--")) {
            out[argv[i].slice(2)] = argv[i + 1] && !argv[i + 1].startsWith("--") ? argv[i + 1] : ""
        }
    }
    return out
}

/** 收集全部差异路径（对象字段、数组元素、标量值）。返回差异列表 */
function collectDiffs(oldV: unknown, newV: unknown, path = "", out: string[] = [], depth = 0): string[] {
    if (depth > 60) {
        out.push(`${path}: 深度超限`)
        return out
    }
    if (oldV === null || newV === null) {
        if (oldV !== newV) out.push(`${path}: null vs ${JSON.stringify(newV)}`)
        return out
    }
    if (typeof oldV !== typeof newV) {
        out.push(
            `${path}: 类型 ${typeof oldV} vs ${typeof newV} (${JSON.stringify(oldV)?.slice(0, 50)} vs ${JSON.stringify(newV)?.slice(0, 50)})`
        )
        return out
    }
    if (typeof oldV !== "object") {
        if (oldV !== newV) out.push(`${path}: ${JSON.stringify(oldV)} vs ${JSON.stringify(newV)}`)
        return out
    }
    if (Array.isArray(oldV) !== Array.isArray(newV)) {
        out.push(`${path}: 数组结构不同`)
        return out
    }
    if (Array.isArray(oldV)) {
        const o = oldV as unknown[]
        const n = newV as unknown[]
        const len = Math.max(o.length, n.length)
        for (let i = 0; i < len; i++) {
            if (i >= o.length) out.push(`${path}[${i}]: 新输出多余 ${JSON.stringify(n[i])?.slice(0, 50)}`)
            else if (i >= n.length) out.push(`${path}[${i}]: 新输出缺失 ${JSON.stringify(o[i])?.slice(0, 50)}`)
            else collectDiffs(o[i], n[i], `${path}[${i}]`, out, depth + 1)
        }
        return out
    }
    const o = oldV as Record<string, unknown>
    const n = newV as Record<string, unknown>
    for (const k of Object.keys(o)) {
        if (!(k in n)) {
            out.push(`${path}.${k}: 新输出缺失 ${JSON.stringify(o[k])?.slice(0, 60)}`)
            continue
        }
        collectDiffs(o[k], n[k], `${path}.${k}`, out, depth + 1)
    }
    for (const k of Object.keys(n)) {
        if (!(k in o)) out.push(`${path}.${k}: 新输出多余`)
    }
    return out
}

function main() {
    const args = parseArgs(process.argv.slice(2))
    const lang = args.lang || "cn"
    const onlyFile = args.file
    const max = args.max ? Number.parseInt(args.max) : Infinity

    const oldDir = join(baseDir, "final", "i18n", lang)
    const newDir = join(baseDir, "final_ts", "i18n", lang)

    const files = onlyFile ? [onlyFile.endsWith(".json") ? onlyFile : `${onlyFile}.json`] : ["Weapon.json", "Char.json"]

    for (const f of files) {
        const oldPath = join(oldDir, f)
        const newPath = join(newDir, f)
        if (!existsSync(oldPath) || !existsSync(newPath)) {
            console.log(`${f}: 缺失 (old=${existsSync(oldPath)} new=${existsSync(newPath)})`)
            continue
        }
        const oldData = JSON.parse(readFileSync(oldPath, "utf8"))
        const newData = JSON.parse(readFileSync(newPath, "utf8"))

        const diffs = collectDiffs(oldData, newData)
        console.log(`\n===== ${f} 差异 ${diffs.length} 条 =====`)
        for (const d of diffs.slice(0, max)) console.log(d)
        if (diffs.length === 0) console.log("✅ 完全一致")
    }
}

main()
