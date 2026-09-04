import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"
import { enhanceDynamicStory } from "../dynQuest/dynQuestModule.ts"
import { type Row, rows, table } from "../shared/dataHelpers.ts"
import { storylineNodes } from "../storyline/storyline.ts"

export async function dispatchModule(ctx: ModuleContext): Promise<VNodeTree> {
    const ui = table(ctx, "DispatchUI")
    const dyn = table(ctx, "DynQuest")
    const grouped = new Map<string, Row>()
    const items = rows(ctx, "Dispatch")
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    if (!dialogue) throw new Error("Dispatch 需要 Dialogue 依赖")
    await dialogue.prepareStoryFlows(items.map(item => dyn[String(item.DispatchId)]?.StoryPath))
    for (const item of items) {
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
            }
            grouped.set(key, group)
        }
        if (!(group.nodes as Row[] | undefined)?.length) {
            const storyPath = dyn[String(id)]?.StoryPath
            const nodes = storyPath
                ? storylineNodes(ctx, storyPath, {
                      pruneSequentialNodeNext: false,
                      questStartThenKeyOrder: true,
                      includeSelfNodeNext: true,
                  })
                : []
            if (nodes.length) {
                const starts = enhanceDynamicStory(ctx, storyPath, nodes, dyn[String(id)]?.DynImpression, false)
                group.nodes = nodes
                if (starts.length > 1) group.startIds = starts
            }
        }
        const level = { id, reward: item.RewardId ?? [], demand: item.DispatchDemand, level: item.PlayerLevel ?? [] }
        if (Array.isArray(group.levels)) group.levels.push(level)
        else group.levels = [level]
    }
    return [...grouped.values()].sort((a, b) => (a.id === 4330 ? -1 : b.id === 4330 ? 1 : Number(a.id) - Number(b.id)))
}
