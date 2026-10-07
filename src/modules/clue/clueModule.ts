/** Clue module - 调查墙线索板：页类型 → 页 → 线索 → 内容条目。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { iconName, rows, table } from "../shared/dataHelpers.ts"

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

/**
 * 内容条目的解锁触发源。ClueContent 互斥地持有 DialogueId1 或 ResourceId1，
 * 对应 ClueContentTrigger 的 Dialogue / Resource 两个分组。
 */
function contentTrigger(row: Row): Record<string, VNodeTree> | undefined {
    const dialogueId = toInt(row.DialogueId1)
    if (dialogueId !== undefined) return { type: "Dialogue", id: dialogueId }
    const resourceId = toInt(row.ResourceId1)
    if (resourceId !== undefined) return { type: "Resource", id: resourceId }
    return undefined
}

function contentEntry(row: Row): Record<string, VNodeTree> {
    const output: Record<string, VNodeTree> = {
        id: toInt(row.ClueContentID) ?? 0,
        text: T(row.TextMapId ?? ""),
    }
    const trigger = contentTrigger(row)
    if (trigger) output.trigger = trigger
    return output
}

function clueEntry(clue: Row, contents: Row): Record<string, VNodeTree> {
    const id = toInt(clue.ClueID) ?? 0
    const output: Record<string, VNodeTree> = {
        id,
        name: T(clue.ClueName ?? ""),
        contents: idList(clue.ClueContent).map(contentId => contentEntry(contents[String(contentId)] ?? { ClueContentID: contentId })),
    }
    const pic1 = iconName(clue.CluePic1 ?? "")
    const pic2 = iconName(clue.CluePic2 ?? "")
    if (pic1) output.pic1 = pic1
    if (pic2) output.pic2 = pic2
    if (clue.ClueType !== undefined && clue.ClueType !== null) output.type = clue.ClueType
    return output
}

export function clueModule(ctx: ModuleContext): VNodeTree {
    const clues = table(ctx, "Clue")
    const contents = table(ctx, "ClueContent")

    const grouped = new Map<string, Record<string, any>[]>()
    for (const page of rows(ctx, "CluePage")) {
        const type = String(page.ClueTabType ?? "")
        if (!type) continue
        const list = grouped.get(type) ?? []
        list.push(page)
        grouped.set(type, list)
    }

    const types = rows(ctx, "CluePageType").sort((a, b) => (toInt(b.Priority) ?? 0) - (toInt(a.Priority) ?? 0))

    return types.map(typeRow => {
        const typeKey = String(typeRow.ClueTabType ?? "")
        const pages = (grouped.get(typeKey) ?? []).sort((a, b) => {
            const seqA = toInt(a.ClueTabNum) ?? 0
            const seqB = toInt(b.ClueTabNum) ?? 0
            if (seqA !== seqB) return seqA - seqB
            return String(a.CluePageId).localeCompare(String(b.CluePageId))
        })

        const builtPages: VNodeTree[] = pages.map(page => {
            const entry: Record<string, VNodeTree> = {
                id: String(page.CluePageId ?? ""),
                name: T(page.CluePageName ?? ""),
                clues: idList(page.ClueList).map(clueId => clueEntry(clues[String(clueId)] ?? { ClueID: clueId }, contents)),
            }
            if (page.UnlockConditionID) entry.unlock = page.UnlockConditionID
            return entry
        })

        return {
            type: typeKey,
            name: T(typeRow.ClueTabTypeName ?? ""),
            priority: toInt(typeRow.Priority) ?? 0,
            pages: builtPages,
        }
    })
}
