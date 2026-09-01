import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { putIfPresent, type Row, rows, sequence, table } from "../shared/dataHelpers.ts"

export function abyssDungeonModule(ctx: ModuleContext): VNodeTree {
    const seasons = rows(ctx, "AbyssSeason")
    const seasonLists = table(ctx, "AbyssSeasonList")
    const rewardLists = table(ctx, "AbyssRewardList")
    const buffTable = table(ctx, "Buff")
    const elementNames: Record<string, string> = {
        DarkDamagedRate: "暗",
        LightDamagedRate: "光",
        WaterDamagedRate: "水",
        FireDamagedRate: "火",
        ThunderDamagedRate: "雷",
        WindDamagedRate: "风",
    }
    const attributeNames: Record<string, string> = { Dark: "暗", Light: "光", Water: "水", Fire: "火", Thunder: "雷", Wind: "风" }
    const result: Row[] = []
    for (const item of rows(ctx, "AbyssDungeon")) {
        const id = Number(item.AbyssDungeonId)
        const did = Number(item.DungeonId)
        if (!id || !did) continue
        const out: Row = { id, did, b: item.AbyssBuffID ?? [], m: item.DungeonMonsters ?? [] }
        const level = rows(ctx, "AbyssLevel").find(v => Number(v.AbyssDungeon1) === id || Number(v.AbyssDungeon2) === id)
        const monsterBuff: Row = {}
        for (const buffId of sequence(item.MonsterBuff?.BuffList)) {
            const buff = buffTable[String(buffId)]
            for (const attr of sequence(buff?.AddAttrs)) {
                if (!attr || typeof attr !== "object") continue
                const rawName = String((attr as Row).AttrName ?? "")
                const name = elementNames[rawName] ?? rawName
                const value = Number((attr as Row).Value ?? 0)
                if (name && value) monsterBuff[name] = (monsterBuff[name] ?? 0) + value
            }
        }
        if (Object.keys(monsterBuff).length) out.mb = monsterBuff
        if (level?.AttributeType1) {
            for (const attr of String(level.AttributeType1)
                .split(",")
                .map(v => v.trim())
                .filter(Boolean))
                if (!monsterBuff[attributeNames[attr] ?? attr]) monsterBuff[attributeNames[attr] ?? attr] = 4
            if (Object.keys(monsterBuff).length) out.mb = monsterBuff
        }
        const season = seasons.find(v => sequence(v.AbyssLevelId).map(Number).includes(Number(level?.LevelId)))
        const seasonList = season ? seasonLists[String(season.AbyssSeasonId)] : undefined
        if (season && seasonList) {
            putIfPresent(out, "sid", season.AbyssSeasonId)
            putIfPresent(out, "st", season.AbyssStartTime)
            putIfPresent(out, "et", season.AbyssEndTime)
            const rewards = sequence(season.AbyssRewardList)
                .map(rewardId => rewardLists[String(rewardId)])
                .filter(Boolean)
                .map(reward => {
                    const value: Row = { lv: reward.Level ?? 0, r: reward.Reward ?? 0 }
                    if (reward.RewardAddOn !== undefined && reward.RewardAddOn !== null) value.a = reward.RewardAddOn
                    if (reward.WalnutReward) value.w = 1
                    return value
                })
            if (rewards.length) out.arl = rewards
            const rewardTitle = String(season.AbyssRewardListTitle ?? "")
            if (rewardTitle && ctx.textmap.has(rewardTitle)) out.art = T(rewardTitle)
            const seasonName = String(seasonList.AbyssSeasonName ?? "")
            if (seasonName && ctx.textmap.has(seasonName)) out.sn = T(seasonName)
            putIfPresent(out, "cid", seasonList.CharId)
        }
        result.push(out)
    }
    return result
}
