#!/usr/bin/env bun
import { join } from "node:path"
/**
 * CLI — DuetNightAbyssData TS 重构入口。
 *
 * 用法（对齐原版 step3_output.py）：
 *   bun out -f Weapon Char                       # 构建指定模块并输出全部语言
 *   bun out -f Weapon Char --langs cn,en          # 指定语言
 *   bun out --list                                # 列出已注册模块
 *
 * 流程：建图 → 拓扑序执行 build（Lua 混合层取数+计算，产出 vnode 树）→
 *       逐语言渲染 → 写 final_ts/i18n/<lang>/<file>.json
 */
import { Graph } from "./core/Graph.ts"
import { getTextMap, LANGS } from "./i18n/TextMap.ts"
import { charModule } from "./modules/char/charModule.ts"
import { skillModule } from "./modules/skill/skillModule.ts"
import { weaponModule } from "./modules/weapon/weaponModule.ts"
import { OutputCollector } from "./output/OutputCollector.ts"

interface ModuleReg {
    name: string
    deps: string[]
    build: (ctx: any) => unknown
    outputs: boolean
}

const REGISTRY: ModuleReg[] = [
    { name: "skill", deps: [], outputs: false, build: ctx => skillModule(ctx) },
    { name: "weapon", deps: ["skill"], outputs: true, build: ctx => weaponModule(ctx) },
    { name: "char", deps: ["skill"], outputs: true, build: ctx => charModule(ctx) },
]

interface CliArgs {
    files: string[]
    langs: string[]
    list: boolean
}

/** 解析 argv：支持 -f/--file-types 的值列表（对齐原版 nargs="+"，-f 后所有非标志参数）、--langs、--list */
function parseArgs(argv: string[]): CliArgs {
    const files: string[] = []
    const langs: string[] = []
    let list = false
    let i = 0
    while (i < argv.length) {
        const a = argv[i]
        if (a === "-f" || a === "--file-types") {
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
        }
        i++
    }
    return { files, langs, list }
}

async function main() {
    const args = parseArgs(process.argv.slice(2))
    const baseDir = join(import.meta.dir, "..")
    const outputRoot = join(baseDir, "final_ts")

    if (args.list) {
        console.log("已注册模块:")
        for (const m of REGISTRY) {
            console.log(`  ${m.name}${m.outputs ? "" : " (纯依赖, 不输出文件)"}${m.deps.length ? ` <- ${m.deps.join(", ")}` : ""}`)
        }
        return
    }

    // 模块名 → 小写；缺省输出全部产出模块
    const requested = args.files.length > 0 ? args.files.map(n => n.toLowerCase()) : REGISTRY.filter(m => m.outputs).map(m => m.name)
    const langs = (args.langs.length > 0 ? args.langs : LANGS) as any[]

    const g = new Graph()
    for (const m of REGISTRY) {
        g.defineModule({ name: m.name, deps: m.deps, outputs: m.outputs, build: m.build })
    }

    console.log(`构建模块: ${requested.join(", ")}`)
    const t0 = performance.now()
    const artifacts = await g.build({}, msg => console.log(msg))

    // 收集输出（产出文件的模块）：模块返回 { 文件名(可含.json): vnode树 }
    const collector = new OutputCollector()
    const outputModules = REGISTRY.filter(m => m.outputs && requested.includes(m.name))
    for (const m of outputModules) {
        const artifact = artifacts.get(m.name) as Record<string, unknown> | undefined
        if (!artifact) continue
        for (const [fileName, tree] of Object.entries(artifact)) {
            const name = fileName.endsWith(".json") ? fileName : `${fileName}.json`
            collector.add(name, tree as any)
        }
    }

    const textmap = getTextMap(join(baseDir, "out"))
    const written = collector.writeAll(outputRoot, langs, textmap)
    console.log(`\n完成: ${(performance.now() - t0).toFixed(0)}ms, ${written.length} 个文件`)
    console.log(`输出目录: ${outputRoot}`)
}

await main()
