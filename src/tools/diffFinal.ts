#!/usr/bin/env bun
/**
 * diffFinal — 对比 final_ts（新架构）与 final（老代码）的输出。
 *
 * 用法：
 *   bun run src/tools/diffFinal.ts --lang cn
 *   bun run src/tools/diffFinal.ts --lang cn --file Weapon   # 只看某文件
 *
 * 输出每个文件的首个差异（字段级），统计一致率。
 * 这是新架构的回归基准：cn 应与老输出一致（同一文本源）。
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

/** 深比较两个 JSON，收集差异路径（返回首个差异描述） */
function firstDiff(oldV: unknown, newV: unknown, path = ""): string | null {
    if (typeof oldV !== typeof newV)
        return `${path}: 类型 ${typeof oldV} vs ${typeof newV} (${JSON.stringify(oldV)?.slice(0, 40)} vs ${JSON.stringify(newV)?.slice(0, 40)})`
    if (oldV === null || newV === null) {
        return oldV === newV ? null : `${path}: null vs ${JSON.stringify(newV)}`
    }
    if (typeof oldV !== "object") {
        return oldV === newV ? null : `${path}: ${JSON.stringify(oldV)} vs ${JSON.stringify(newV)}`
    }
    if (Array.isArray(oldV) !== Array.isArray(newV)) return `${path}: 数组结构不同`
    if (Array.isArray(oldV)) {
        if (oldV.length !== (newV as unknown[]).length) return `${path}: 长度 ${oldV.length} vs ${(newV as unknown[]).length}`
        for (let i = 0; i < oldV.length; i++) {
            const d = firstDiff(oldV[i], (newV as unknown[])[i], `${path}[${i}]`)
            if (d) return d
        }
        return null
    }
    const o = oldV as Record<string, unknown>
    const n = newV as Record<string, unknown>
    for (const k of Object.keys(o)) {
        if (!(k in n)) return `${path}.${k}: 新输出缺失`
    }
    for (const k of Object.keys(n)) {
        if (!(k in o)) return `${path}.${k}: 新输出多余`
    }
    for (const k of Object.keys(o)) {
        const d = firstDiff(o[k], n[k], `${path}.${k}`)
        if (d) return d
    }
    return null
}

function main() {
    const args = parseArgs(process.argv.slice(2))
    const lang = args.lang || "cn"
    const onlyFile = args.file

    const oldDir = join(baseDir, "final", "i18n", lang)
    const newDir = join(baseDir, "final_ts", "i18n", lang)

    const files = onlyFile ? [onlyFile.endsWith(".json") ? onlyFile : `${onlyFile}.json`] : ["Weapon.json", "Char.json"]

    let total = 0
    let matched = 0
    for (const f of files) {
        const oldPath = join(oldDir, f)
        const newPath = join(newDir, f)
        if (!existsSync(oldPath) || !existsSync(newPath)) {
            console.log(`${f}: 缺失 (old=${existsSync(oldPath)} new=${existsSync(newPath)})`)
            continue
        }
        const oldData = JSON.parse(readFileSync(oldPath, "utf8"))
        const newData = JSON.parse(readFileSync(newPath, "utf8"))
        total++

        const d = firstDiff(oldData, newData)
        if (!d) {
            console.log(`${f}: ✅ 完全一致 (${(Array.isArray(oldData) ? oldData : Object.keys(oldData)).length} 项)`)
            matched++
        } else {
            console.log(`${f}: ❌ ${d}`)
        }
    }
    console.log(`\n一致率: ${matched}/${total}`)
}

main()
