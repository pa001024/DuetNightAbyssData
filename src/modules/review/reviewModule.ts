/** Review module - 剧情回顾（调查墙回顾页）的页/列/条目结构。 */

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

/** ReviewChainSide 兼容 number / "a,b" 字符串 / 数组三种形态。 */
function sideIds(value: unknown): number[] {
    if (Array.isArray(value)) return idList(value)
    if (typeof value === "number") return value === 0 ? [] : [value]
    if (typeof value === "string") {
        if (!value.trim() || value.trim() === "0") return []
        return value
            .split(",")
            .map(part => toInt(part))
            .filter((item): item is number => item !== undefined && item !== 0)
    }
    return []
}

function reviewEntry(row: Row): Record<string, VNodeTree> {
    const output: Record<string, VNodeTree> = {
        id: toInt(row.ReviewID) ?? 0,
        name: T(row.ReviewName ?? ""),
    }
    if (row.ReviewContent) output.content = T(row.ReviewContent)
    const pic1 = iconName(row.ReviewPic1 ?? "")
    const pic2 = iconName(row.ReviewPic2 ?? "")
    if (pic1) output.pic1 = pic1
    if (pic2) output.pic2 = pic2
    if (row.ReviewType !== undefined && row.ReviewType !== null) output.type = row.ReviewType
    if (row.QuestChainId) output.questChainId = row.QuestChainId
    if (row.UnlockCondition) output.unlock = row.UnlockCondition
    if (row.FinishCondition) output.finish = row.FinishCondition
    return output
}

export function reviewModule(ctx: ModuleContext): VNodeTree {
    const reviews = table(ctx, "Review")
    const chains = table(ctx, "ReviewChain")
    const previous = table(ctx, "ReviewChainPageId2PreReviewChainSequenceId")

    const pages = rows(ctx, "ReviewPage").sort((a, b) => (toInt(a.ReviewChainPage) ?? 0) - (toInt(b.ReviewChainPage) ?? 0))

    return pages.map(page => {
        const pageId = toInt(page.ReviewChainPage) ?? 0
        const chainIds = idList(page.ReviewChainSequence)
        const built: VNodeTree[] = []

        chainIds.forEach((chainId, column) => {
            const chain = chains[String(chainId)]
            if (!chain || typeof chain !== "object") return
            const entry: Record<string, VNodeTree> = {
                id: chainId,
                column,
                main: idList(chain.ReviewChainMain).map(id => reviewEntry(reviews[String(id)] ?? { ReviewID: id })),
                side: sideIds(chain.ReviewChainSide).map(id => reviewEntry(reviews[String(id)] ?? { ReviewID: id })),
            }
            if (chain.FirstShowCondition) entry.firstShow = chain.FirstShowCondition
            const prev = toInt(previous[String(chainId)])
            if (prev !== undefined) entry.prev = prev
            built.push(entry)
        })

        const output: Record<string, VNodeTree> = { id: pageId }
        if (page.EpisodeName) output.episodeName = T(page.EpisodeName)
        output.chains = built
        return output
    })
}
