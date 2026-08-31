/**
 * textmapReactive — @vue/reactivity 集成。
 *
 * vnode 树是唯一 source of truth（模块 build 产出的不可变树）；
 * 每语言视图是"派生状态"：computed(() => renderTree(tree, lang))。
 * 语言切换/新增语言时自动重算，无需重新解析游戏逻辑。
 *
 * 这既是结构上的 "reactive 翻译 hook"，也为将来接 UI/增量更新留口。
 */

import type { ComputedRef } from "@vue/reactivity"
import { computed, reactive } from "@vue/reactivity"
import type { TextMap } from "./TextMap.ts"
import type { VNodeTree } from "./vnode.ts"
import { renderTree } from "./vnode.ts"

export interface LangViews {
    cn: unknown
    en: unknown
    jp: unknown
    kr: unknown
    tc: unknown
    fr: unknown
}

/**
 * 从一棵 vnode 树派生全部语言的视图。
 * tree 应是不含 VNode 的"纯数据树"（VNode 在叶节点）。返回 reactive 对象，
 * 每个语言字段是 computed。
 */
export function deriveLangViews(tree: VNodeTree, textmap: TextMap): LangViews {
    const langs = ["cn", "en", "jp", "kr", "tc", "fr"] as const
    const views = {} as LangViews
    for (const lang of langs) {
        views[lang] = computed(() => renderTree(tree, lang, textmap))
    }
    return reactive(views) as LangViews
}

export type { ComputedRef }
