import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { type Row, rows, table } from "../shared/dataHelpers.ts"
import { storylineNodes } from "../storyline/storyline.ts"

export function dispatchModule(ctx: ModuleContext): VNodeTree {
    const ui = table(ctx, "DispatchUI")
    const dyn = table(ctx, "DynQuest")
    const grouped = new Map<string, Row>()
    for (const item of rows(ctx, "Dispatch")) {
        const id = Number(item.DispatchId)
        if (!id) continue
        const key = String(item.DispatchCondition ?? "")
        let group = grouped.get(key)
        if (!group) {
            const u = ui[String(id)] ?? {}
            const d = dyn[String(id)] ?? {}
            group = {
                id: item.DispatchCondition,
                name: T(u.DispatchName ?? d.DynName ?? ""),
                desc: T(u.DispatchDes ?? ""),
                regionId: item.RegionId,
                subRegionId: u.DispatchSubRegionId,
                cd: item.DispatchCD,
                person: item.DispatchPerson,
                type: item.DispatchType,
                rarity: item.Rarity,
                ttk: item.Ttk,
                weight: item.Weight,
                pos: u.UIPos,
                levels: [],
            }
            grouped.set(key, group)
        }
        if (!(group.nodes as Row[] | undefined)?.length) {
            const storyPath = dyn[String(id)]?.StoryPath
            const nodes = storyPath ? storylineNodes(ctx, storyPath, { pruneSequentialNodeNext: false }) : []
            if (nodes.length) group.nodes = nodes
        }
        ;(group.levels as Row[]).push({ id, reward: item.RewardId ?? [], demand: item.DispatchDemand, level: item.PlayerLevel ?? [] })
    }
    return [...grouped.values()].sort((a, b) => (a.id === 4330 ? -1 : b.id === 4330 ? 1 : Number(a.id) - Number(b.id)))
}
