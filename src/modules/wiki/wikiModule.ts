/**
 * Wiki module - 游戏内百科（Encyclopedia）。
 *
 * 数据源（Script/Datas）：
 * - WikiMain      条目主表，按 EntryId 索引；含 MainType/SubType、EntryTitle（文本 key）、
 *                 EntryImg（可选插图）、AssociatedEntry1..4（可选的相关条目交叉引用）。
 * - WikiMainType  四大类：1 势力 / 2 人物 / 3 风土 / 4 文明，含 MainTypeIcon 与 MainTypeText。
 * - WikiSubType   子类（政体/地域/历史等），含所属 MainType 与 SubTypeText。
 * - WikiText      条目正文段：TextDetail（文本 key）、TextRelatedDialogue（关联对话 id）、
 *                 TextUnlock（正文解锁条件 id，指向 Condition 表）。
 *
 * 层级：大类 → 子类 → 条目 → 正文段。正文段文本本身含换行分段，按原样输出。
 * 无玩家存档，故不导出解锁态；但正文段的解锁条件 id 属于数据配置，按原值输出。
 */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { iconName, rows } from "../shared/dataHelpers.ts"

type Row = Record<string, any>

function toInt(value: unknown): number | undefined {
    if (typeof value === "number" && Number.isInteger(value)) return value
    if (typeof value !== "string" || !/^-?\d+$/.test(value.trim())) return undefined
    return Number(value)
}

function idList(value: unknown): number[] {
    const values = Array.isArray(value) ? value : value && typeof value === "object" ? Object.values(value) : []
    return values.map(toInt).filter((item): item is number => item !== undefined)
}

function textNodes(texts: Row[], entryId: number): VNodeTree[] {
    return texts
        .filter(text => toInt(text.EntryId) === entryId)
        .sort((a, b) => (toInt(a.TextId) ?? 0) - (toInt(b.TextId) ?? 0))
        .map(text => {
            const out: Record<string, VNodeTree> = {
                id: toInt(text.TextId) ?? 0,
                text: T(text.TextDetail ?? ""),
            }
            const dialogues = idList(text.TextRelatedDialogue)
            if (dialogues.length > 0) out.dialogues = dialogues
            const unlock = toInt(text.TextUnlock)
            if (unlock !== undefined) out.unlock = unlock
            return out
        })
}

function entryNode(entry: Row, texts: Row[]): VNodeTree {
    const id = toInt(entry.EntryId) ?? 0
    const out: Record<string, VNodeTree> = {
        id,
        title: T(entry.EntryTitle ?? ""),
    }
    const img = iconName(entry.EntryImg ?? "")
    if (img) out.img = img
    const related: number[] = []
    for (let i = 1; i <= 4; i++) {
        const ref = toInt(entry[`AssociatedEntry${i}`])
        if (ref !== undefined) related.push(ref)
    }
    if (related.length > 0) out.related = related
    out.texts = textNodes(texts, id)
    return out
}

export function wikiModule(ctx: ModuleContext): VNodeTree {
    const entries = rows(ctx, "WikiMain")
    const texts = rows(ctx, "WikiText")

    const entriesBySubType = new Map<number, Row[]>()
    for (const entry of entries) {
        const subType = toInt(entry.SubType)
        if (subType === undefined) continue
        const list = entriesBySubType.get(subType) ?? []
        list.push(entry)
        entriesBySubType.set(subType, list)
    }

    const subTypes = rows(ctx, "WikiSubType")
        .map(row => ({ mainType: toInt(row.MainType), subType: toInt(row.SubType), row }))
        .filter(
            (item): item is { mainType: number; subType: number; row: Row } => item.mainType !== undefined && item.subType !== undefined
        )
        .sort((a, b) => a.subType - b.subType)

    return rows(ctx, "WikiMainType")
        .map(typeRow => {
            const mainType = toInt(typeRow.MainType)
            if (mainType === undefined) throw new Error("WikiMainType row is missing MainType")

            let count = 0
            const subTypeNodes: VNodeTree[] = []
            for (const { mainType: subMainType, subType, row } of subTypes) {
                if (subMainType !== mainType) continue
                const group = entriesBySubType.get(subType)
                if (!group || group.length === 0) continue
                const sorted = group.slice().sort((a, b) => (toInt(a.EntryId) ?? 0) - (toInt(b.EntryId) ?? 0))
                count += sorted.length
                subTypeNodes.push({
                    id: subType,
                    name: T(row.SubTypeText ?? ""),
                    entries: sorted.map(entry => entryNode(entry, texts)),
                })
            }

            const node: Record<string, VNodeTree> = {
                id: mainType,
                name: T(typeRow.MainTypeText ?? ""),
                count,
                subTypes: subTypeNodes,
            }
            const icon = iconName(typeRow.MainTypeIcon ?? "")
            if (icon) node.icon = icon
            return node
        })
        .sort((a, b) => toInt((a as Row).id)! - toInt((b as Row).id)!)
}
