#!/usr/bin/env bun
import { join } from "node:path"
/**
 * CLI — DuetNightAbyssData TS 重构入口。
 *
 * 用法（对齐旧版导出入口的命令行形态）：
 *   bun out -f Weapon Char                       # 构建指定模块并输出全部语言
 *   bun out -f Weapon Char --langs cn,en          # 指定语言
 *   bun out -v 1.2                                # 用 git 历史版本（tag/commit）的 Script 数据解析
 *   bun out -v 1.6 --langs cn                     # 版本前缀匹配同前缀最新版（1.6 → v1.6.4.1）
 *   bun out --list                                # 列出已注册模块
 *   bun run warmup                                # 清空并预热 UAsset DuckDB 缓存
 *
 * 模块以插件形式加载：每个模块目录 src/modules/<dir>/register.ts 自我声明
 * （name/deps/outputs/build/uasset），主程序在此只做目录级自动发现，不再逐个
 * import/登记模块——新增模块无需修改本文件（见 src/core/plugin.ts）。
 *
 * 流程：发现插件 → 建图 → 拓扑序执行 build（Lua 混合层取数+计算，产出 vnode 树）→
 *       逐语言渲染 → 写 final/i18n/<lang>/<file>.json
 */
import { Graph } from "./core/Graph.ts"
import { loadPlugins } from "./core/plugin.ts"
import { getTextMap, LANGS } from "./i18n/TextMap.ts"
import { setLuaDataRoot } from "./lua/LuaDataManager.ts"
import { resolveScriptVersion, snapshotScriptData } from "./lua/scriptSnapshot.ts"
import { clearUAssetCache, closeUAssetServer } from "./lua/UAssetServer.ts"
import { OutputCollector } from "./output/OutputCollector.ts"

interface CliArgs {
    files: string[]
    langs: string[]
    list: boolean
    warmup: boolean
    /** -v：git 历史中的版本号 / tag 名 / commit，取该版本的 Script 数据解析 */
    version: string | undefined
}

/** 解析 argv：支持文件类型、语言、模块列表和 UAsset DuckDB 缓存预热。 */
function parseArgs(argv: string[]): CliArgs {
    const files: string[] = []
    const langs: string[] = []
    let list = false
    let warmup = false
    let version: string | undefined
    let i = 0
    while (i < argv.length) {
        const a = argv[i]
        if (a === "-v" || a === "--version") {
            if (i + 1 < argv.length) {
                version = argv[i + 1]
                i++
            }
        } else if (a === "-f" || a === "--file-types") {
            // 消费后续所有非标志参数（对齐原版 nargs="+"）
            i++
            while (i < argv.length && !argv[i].startsWith("-")) {
                files.push(
                    ...argv[i]
                        .split(",")
                        .map(s => s.trim())
                        .filter(Boolean)
                )
                i++
            }
            continue
        }
        if (a === "--langs") {
            i++
            while (i < argv.length && !argv[i].startsWith("-")) {
                langs.push(
                    ...argv[i]
                        .split(",")
                        .map(s => s.trim())
                        .filter(Boolean)
                )
                i++
            }
            continue
        }
        if (a === "--list") {
            list = true
        } else if (a === "--warmup") {
            warmup = true
        } else if (a.startsWith("-f") && a.length > 2) {
            files.push(
                ...a
                    .slice(2)
                    .split(",")
                    .map(s => s.trim())
                    .filter(Boolean)
            )
        } else if (a.startsWith("--langs=")) {
            langs.push(
                ...a
                    .slice(8)
                    .split(",")
                    .map(s => s.trim())
                    .filter(Boolean)
            )
        } else if (a.startsWith("--version=")) {
            version = a.slice(10)
        } else if (a.startsWith("-v") && a.length > 2) {
            version = a.slice(2)
        }
        i++
    }
    return { files, langs, list, warmup, version }
}

async function main() {
    const args = parseArgs(process.argv.slice(2))
    const baseDir = join(import.meta.dir, "..")
    const outputRoot = join(baseDir, "final")

    // -v：从 git 历史解析版本（tag 名 / commit subject / commit 哈希），把 Lua 数据层切到
    // 该版本的 Script 快照目录。代码、uasset 解包与 out/ 等当前工作区内容保持不变。
    if (args.version && !args.list) {
        const resolved = resolveScriptVersion(baseDir, args.version)
        const snapshotDir = snapshotScriptData(baseDir, resolved)
        setLuaDataRoot(snapshotDir)
        console.log(`Lua 数据层使用历史版本 ${resolved.version}（来源 ${resolved.label}, commit ${resolved.commit.slice(0, 12)}）`)
        console.log(`数据快照目录: ${snapshotDir}`)
    }

    // 插件自动发现：模块目录 register.ts 自我注册，此处不做任何静态模块引用。
    const registry = await loadPlugins()
    // 构建期请求 uasset 的插件（--warmup 默认预热集）
    const uassetModules = registry.filter(m => m.uasset).map(m => m.name)

    if (args.list) {
        console.log("已注册模块:")
        for (const m of registry) {
            const deps = m.deps ?? []
            console.log(`  ${m.name}${m.outputs ? "" : " (纯依赖, 不输出文件)"}${deps.length ? ` <- ${deps.join(", ")}` : ""}`)
        }
        return
    }

    if (args.warmup) {
        await clearUAssetCache()
        console.log("已清空 UAsset DuckDB 缓存，开始预热资产请求")
    }

    // 只有 -f/--file-types 的值按大小写不敏感匹配；registry 保留规范模块名。
    const moduleNames = new Map(registry.map(m => [m.name.toLowerCase(), m.name]))
    const requested =
        args.files.length > 0
            ? args.files.map(name => moduleNames.get(name.toLowerCase()) ?? name)
            : args.warmup
              ? uassetModules
              : registry.filter(m => m.outputs).map(m => m.name)
    const langs = (args.langs.length > 0 ? args.langs : LANGS) as any[]

    const g = new Graph()
    for (const m of registry) {
        g.defineModule({ name: m.name, deps: m.deps, outputs: m.outputs, build: m.build })
    }

    console.log(`构建模块: ${requested.join(", ")}`)
    const t0 = performance.now()
    const artifacts = await g.build({}, msg => console.log(msg), requested)

    if (args.warmup) {
        await closeUAssetServer()
        console.log(`\n缓存预热完成: ${(performance.now() - t0).toFixed(0)}ms`)
        return
    }

    // 收集输出（产出文件的模块）：模块返回 { 文件名(可含.json): vnode树 }
    const collector = new OutputCollector()
    const outputModules = registry.filter(m => m.outputs && requested.includes(m.name))
    for (const m of outputModules) {
        const artifact = artifacts.get(m.name) as Record<string, unknown> | undefined
        if (!artifact) continue
        for (const [fileName, tree] of Object.entries(artifact)) {
            const name = fileName.endsWith(".json") ? fileName : `${fileName}.json`
            collector.add(name, tree as any)
        }
    }

    const textmap = getTextMap()
    const written = collector.writeAll(outputRoot, langs, textmap)
    console.log(`\n完成: ${(performance.now() - t0).toFixed(0)}ms, ${written.length} 个文件`)
    console.log(`输出目录: ${outputRoot}`)
}

try {
    await main()
} finally {
    await closeUAssetServer()
}
