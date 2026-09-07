/**
 * 模块插件契约与自动发现。
 *
 * 领域模块以"插件"形式自我声明注册信息，主程序（src/cli.ts）不再逐个静态 import/登记：
 * 每个模块目录 src/modules/<dir>/register.ts 具名导出 plugins: ModulePlugin[]（或 default 导出数组）。
 * 新增模块只需新增目录与 register.ts 即可被自动加载，无需修改主程序；目录内其余文件自由组织。
 *
 * 目录约定：register.ts 是唯一被发现的文件名；不含 register.ts 的目录（如 shared/ 助手代码）被跳过。
 * 加载时做统一校验（name/build 必填、跨插件 name 唯一），并按 name 排序保证确定性。
 */
import { existsSync, readdirSync } from "node:fs"
import { join } from "node:path"
import type { ModuleDefinition } from "./Graph.ts"

/** 插件注册条目：在 ModuleDefinition 上补充主程序（CLI）可见的标记。 */
export interface ModulePlugin extends ModuleDefinition {
    /**
     * 构建期是否请求 uasset（调用 AssetReader/ensureServer 的模块）。
     * 为 true 的插件进入 `bun run warmup` 的默认预热构建集。
     */
    uasset?: boolean
}

/** 模块目录内插件注册文件名（目录约定） */
const REGISTER_FILE = "register.ts"

function normalizePlugin(folder: string, index: number, raw: unknown): ModulePlugin {
    const where = `${folder}/${REGISTER_FILE} 第 ${index + 1} 项`
    if (!raw || typeof raw !== "object") throw new Error(`模块插件 ${where} 不是对象`)
    const rec = raw as Record<string, unknown>
    if (typeof rec.name !== "string" || !rec.name) throw new Error(`模块插件 ${where} 缺少非空字符串 name`)
    if (typeof rec.build !== "function") throw new Error(`模块插件 ${where}（${rec.name}）缺少 build 函数`)
    const { deps, outputs, uasset, build } = rec
    if (deps !== undefined && (!Array.isArray(deps) || deps.some(d => typeof d !== "string")))
        throw new Error(`模块插件 ${where}（${rec.name}）的 deps 必须是字符串数组`)
    if (outputs !== undefined && typeof outputs !== "boolean") throw new Error(`模块插件 ${where}（${rec.name}）的 outputs 必须是布尔值`)
    if (uasset !== undefined && typeof uasset !== "boolean") throw new Error(`模块插件 ${where}（${rec.name}）的 uasset 必须是布尔值`)
    return {
        name: rec.name,
        deps: (deps as string[] | undefined) ?? [],
        outputs: (outputs as boolean | undefined) ?? true,
        uasset: (uasset as boolean | undefined) ?? false,
        build: build as ModulePlugin["build"],
    }
}

/** 扫描并加载 src/modules 下全部插件；返回按注册名排序的确定性列表。 */
export async function loadPlugins(): Promise<ModulePlugin[]> {
    const moduleRoot = join(import.meta.dir, "..", "modules")
    const dirs = readdirSync(moduleRoot, { withFileTypes: true })
        .filter(e => e.isDirectory())
        .map(e => e.name)
        .sort()

    const plugins: ModulePlugin[] = []
    for (const dir of dirs) {
        if (!existsSync(join(moduleRoot, dir, REGISTER_FILE))) continue
        // 相对本文件（src/core）解析，保证 register.ts 的动态加载与目录扫描一致。
        const mod = (await import(`../modules/${dir}/${REGISTER_FILE}`)) as { plugins?: unknown; default?: unknown }
        const raw = mod.plugins ?? mod.default
        if (!Array.isArray(raw)) throw new Error(`模块插件 ${dir}/${REGISTER_FILE} 须具名导出 plugins 数组（或 default 导出数组）`)
        raw.forEach((entry, index) => plugins.push(normalizePlugin(dir, index, entry)))
    }

    const seen = new Set<string>()
    for (const p of plugins) {
        if (seen.has(p.name)) throw new Error(`模块重复注册: ${p.name}（多个 register.ts 声明了同名插件）`)
        seen.add(p.name)
    }
    return plugins.sort((a, b) => (a.name < b.name ? -1 : a.name > b.name ? 1 : 0))
}
