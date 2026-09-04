/**
 * OutputCollector — 多语言输出集。
 *
 * 每个模块 build 后把"输出清单"注册进来：{ name, tree }，tree 是含 vnode 的纯数据树。
 * 渲染阶段对每个语言 renderTree 一次，产出该语言完整输出集。
 *
 * 由此实现：解析一次（build 产物 vnode 树）→ 多份语言输出（逐语言渲染）。
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

export class OutputCollector {
    private entries: OutputEntry[] = []

    /** 注册一个输出文件（name 为文件名，如 Weapon.json） */
    add(name: string, tree: VNodeTree): void {
        this.entries.push({ name, tree })
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
     * 写入 final/i18n/<lang>/<name>.json。
     * 文件名把 .json 后缀交给调用方（name 含或不含均可）。
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
        return written
    }
}
