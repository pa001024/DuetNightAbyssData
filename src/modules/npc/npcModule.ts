import type { ModuleContext } from "../../core/Graph.ts"
import type { VNodeTree } from "../../i18n/vnode.ts"
import { type Row, sequence, table } from "../shared/dataHelpers.ts"
import { storylineNodes } from "../storyline/storyline.ts"

export function npcModule(ctx: ModuleContext): VNodeTree {
    const triggers = table(ctx, "TalkTrigger")
    const camps = table(ctx, "CharCamp")
    const guidePoints = new Map<string, Row>()
    for (const point of ctx.dm.loadScriptTableRows("Script/BluePrints/UI/TaskPanel/QuestGuidePointLocData.lua", [
        "X",
        "Y",
        "SubRegionId",
    ])) {
        if (typeof point.__key === "string") guidePoints.set(point.__key, point)
    }
    return Object.values(table(ctx, "Npc"))
        .filter((value): value is Row => !!value && typeof value === "object" && !Array.isArray(value))
        .map(item => {
            const campName = camps[String(item.Camp)]?.CampName
            const output: Row = { id: item.UnitId }
            if (item.UnitName) output.name = { __t: "t", key: item.UnitName }
            if (campName) output.camp = { __t: "t", key: campName }
            else if (item.Camp) output.camp = item.Camp
            if (item.CharId) output.charId = item.CharId
            if (item.NpcType) output.type = item.NpcType
            const path = typeof item.UnitBPPath === "string" ? item.UnitBPPath : ""
            const base = path.replaceAll("\\", "/").split("/").at(-1)?.split(".")[0] ?? ""
            const token = base.replace(/^BP_(?:NPC_)?/, "")
            const exactEntry = guidePoints.get(`EntrySeatPoint_${token}`)
            const npcCandidates = [...guidePoints.keys()].filter(key => key.startsWith(`Npc_${token}_`))
            const point =
                exactEntry && npcCandidates.length === 0
                    ? exactEntry
                    : npcCandidates.length === 1
                      ? guidePoints.get(npcCandidates[0])
                      : undefined
            if (point && Number(point.SubRegionId) > 0 && Number.isFinite(Number(point.X)) && Number.isFinite(Number(point.Y))) {
                output.srId = Number(point.SubRegionId)
                output.pos = [Math.round(Number(point.X)), Math.round(Number(point.Y))]
            }
            if (item.MailHead) output.icon = (String(item.MailHead).split(/[./]/).at(-1)?.replaceAll("'", "") ?? "").replace(/^T_Head_/, "")
            const talks: Row[] = []
            for (const triggerId of sequence(item.RelatedTalks)) {
                const trigger = triggers[String(triggerId)]
                if (!trigger?.StoryLinePath) continue
                for (const node of storylineNodes(ctx, trigger.StoryLinePath))
                    for (const entry of sequence((node as Row).dialogues)) talks.push(entry as Row)
            }
            if (talks.length) {
                const seen = new Set<string>()
                output.talks = talks.filter(talk => {
                    const key = String(talk.id)
                    if (seen.has(key)) return false
                    seen.add(key)
                    return true
                })
            }
            return output
        })
}
