import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { putIfPresent, type Row, rows, sequence, table } from "../shared/dataHelpers.ts"

export function abyssDungeonModule(ctx: ModuleContext): VNodeTree {
    const seasons = rows(ctx, "AbyssSeason")
    const seasonLists = table(ctx, "AbyssSeasonList")
    const rewardLists = table(ctx, "AbyssRewardList")
    const result: Row[] = []
    for (const item of rows(ctx, "AbyssDungeon")) {
        const id = Number(item.AbyssDungeonId)
        const did = Number(item.DungeonId)
        if (!id || !did) continue
        const out: Row = { id, did, b: item.AbyssBuffID ?? [], m: item.DungeonMonsters ?? [] }
        const level = rows(ctx, "AbyssLevel").find(v =>
            Object.entries(v).some(([key, value]) => key.startsWith("AbyssDungeon") && Number(value) === id)
        )
        const monsterBuff: Row = {}
        const buffTable = table(ctx, "AbyssBuff")
        for (const buffId of sequence(item.MonsterBuff?.BuffList)) {
            const buff = buffTable[String(buffId)]
            for (const attr of sequence(buff?.AddAttrs)) {
                if (!attr || typeof attr !== "object") continue
                const name = String((attr as Row).AttrName ?? "")
                const value = Number((attr as Row).Value ?? 0)
                if (name && value) monsterBuff[name] = (monsterBuff[name] ?? 0) + value
            }
        }
        if (Object.keys(monsterBuff).length) out.mb = monsterBuff
        if (level?.AttributeType1) {
            const names: Record<string, string> = { Dark: "暗", Light: "光", Water: "水", Fire: "火", Thunder: "雷", Wind: "风" }
            for (const attr of String(level.AttributeType1)
                .split(",")
                .map(v => v.trim())
                .filter(Boolean))
                monsterBuff[names[attr] ?? attr] = 4
            if (Object.keys(monsterBuff).length) out.mb = monsterBuff
        }
        const season = seasons.find(v => sequence(v.AbyssLevelId).map(Number).includes(Number(level?.LevelId)))
        if (season) {
            putIfPresent(out, "sid", season.AbyssSeasonId)
            putIfPresent(out, "st", season.AbyssStartTime)
            putIfPresent(out, "et", season.AbyssEndTime)
            const list = seasonLists[String(season.AbyssSeasonId)]
            if (list) putIfPresent(out, "sn", T(list.AbyssSeasonName ?? ""))
            const rewards = sequence(season.AbyssRewardList)
                .map(rewardId => rewardLists[String(rewardId)])
                .filter(Boolean)
                .map(reward => ({ lv: reward.Level ?? 0, r: reward.Reward ?? 0, w: reward.WalnutOrResourceReward ? 1 : 0 }))
            if (rewards.length && season.AbyssType !== 2) out.arl = rewards
        }
        result.push(out)
    }
    return result
}
