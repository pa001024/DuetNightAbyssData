/**
 * OutputCollector — 多语言输出集。
 *
 * 每个模块 build 后把"输出清单"注册进来：{ name, tree }，tree 是含 vnode 的纯数据树。
 * 渲染阶段对每个语言 renderTree 一次，产出该语言完整输出集。
 *
 * 由此实现：解析一次（build 产物 vnode 树）→ 多份语言输出（逐语言渲染）。
 *
 * 语言无关产物（如 skill-behavior.json）走 `addNeutral`：只写一次 `final/<name>`，
 * 不参与逐语言渲染，避免大数据 × 语言数。
 */

import { mkdirSync, writeFileSync } from "node:fs"
import { join } from "node:path"
import type { LangCode, TextMap } from "../i18n/TextMap.ts"
import type { VNodeTree } from "../i18n/vnode.ts"
import { renderTree } from "../i18n/vnode.ts"

export interface OutputEntry {
    name: string
    tree: VNodeTree
}

export interface NeutralOutputEntry {
    name: string
    data: unknown
}

export class OutputCollector {
    private entries: OutputEntry[] = []
    private neutralEntries: NeutralOutputEntry[] = []

    /** 注册一个输出文件（name 为文件名，如 Weapon.json） */
    add(name: string, tree: VNodeTree): void {
        this.entries.push({ name, tree })
    }

    /** 注册一个语言无关输出文件（只写一次，不按语言渲染）。 */
    addNeutral(name: string, data: unknown): void {
        this.neutralEntries.push({ name, data })
    }

    get entryList(): OutputEntry[] {
        return [...this.entries]
    }

    /** 渲染某语言的全部输出 → { 文件名: 渲染结果 } */
    renderLanguage(lang: string, textmap: TextMap): Map<string, unknown> {
        const out = new Map<string, unknown>()
        for (const e of this.entries) {
            out.set(e.name, renderTree(e.tree, lang, textmap))
        }
        return out
    }

    /**
     * 写入 final/i18n/<lang>/<name>.json；语言无关产物写 final/<name>.json 一次。
     * 语言无关产物是机器消费的大体量数据（如 skill-behavior.json），按紧凑 JSON 写入；
     * 逐语言产物保持既有缩进格式。文件名把 .json 后缀交给调用方（name 含或不含均可）。
     */
    writeAll(outputRoot: string, langs: LangCode[], textmap: TextMap): string[] {
        const written: string[] = []
        for (const lang of langs) {
            const dir = join(outputRoot, "i18n", lang)
            mkdirSync(dir, { recursive: true })
            for (const e of this.entries) {
                const rendered = renderTree(e.tree, lang, textmap)
                const file = join(dir, e.name)
                writeFileSync(file, `${JSON.stringify(rendered, null, 2)}\n`, "utf8")
                written.push(file)
            }
        }
        if (this.neutralEntries.length > 0) {
            mkdirSync(outputRoot, { recursive: true })
            for (const e of this.neutralEntries) {
                const file = join(outputRoot, e.name)
                writeFileSync(file, `${JSON.stringify(e.data)}\n`, "utf8")
                written.push(file)
            }
        }
        return written
    }
}
