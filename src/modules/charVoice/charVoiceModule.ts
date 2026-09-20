/**
 * CharVoice module — 扁平化角色语音条目。
 *
 * 主体来自 CharVoice 表；少数角色（主角，如 CharId 2201 WeitaF、1601 主角-光）不进该表，
 * 但其战斗语音（TextMap 键 voice_ch_char_<token>_vo_* 与语音资产）完整存在，
 * 这里按标准战斗语音集补齐。数据源一旦出现该 CharId 组即自动停用补全，避免重复。
 *
 * 偶遇语音（vo_companio_NN_*）额外输出可选的 companioCharId，即触发该段对话的另一个角色
 * CharId；编号 NN 的换算规则见 buildCompanioIndex。
 */
import type { ModuleContext } from "../../core/Graph.ts"
import { seq, T, type VNodeTree } from "../../i18n/vnode.ts"

/** 标准战斗语音后缀（顺序与既有 CharVoice 战斗条目的惯用排列一致）。 */
const COMBAT_VOICE_SUFFIXES = [
    "vo_appear",
    "vo_lvup",
    "vo_battlestart",
    "vo_battleidle",
    "vo_skill01_r01",
    "vo_skill01_r02",
    "vo_skill02_r01",
    "vo_skill02_r02",
    "vo_skill02_r03",
    "vo_die_r01",
    "vo_die_r02",
    "vo_revive",
    "vo_victory",
    "vo_fail",
] as const

/**
 * 需要按库存补齐语音的角色（数据源 CharVoice 组缺失时生效）。
 * voiceName 是语音键前缀 token（voice_ch_char_<voiceName>_vo_*），
 * 主角的 token 带属性后缀（如主角-光为 NvzhuLight），可能不同于角色图标/GUIPathVariable。
 */
const VOICE_SUPPLEMENTS: ReadonlyArray<{ charId: number; voiceName: string }> = [
    { charId: 2201, voiceName: "WeitaF" },
    { charId: 1601, voiceName: "NvzhuLight" },
]

/** 偶遇语音后缀："char_Heitao_vo_companio_02_1" => "02"。 */
function companioSerial(res: string): string | undefined {
    return res.match(/_vo_companio_(\d+)/)?.[1]
}

/**
 * 构建「偶遇语音 → 触发的另一个角色 CharId」索引：unit -> (companio 编号 -> CharId)。
 *
 * 编号规则：NpcGossipTriggerConvert.NpcTrigger[unitId] 列出该 unit 参与的闲谈 TalkId；
 * 只取 unit 位于 NpcGossipTrigger[talkId].NpcCombination 首位（该角色为主动方）的成对闲谈，
 * 按 TalkId 升序依次编号为 01、02…，NN 即语音后缀 companio_NN；对手 unit 经 Npc 表换 CharId。
 * 主动方为对手的闲谈属于对手的编号序列，不计入本 unit。
 */
function buildCompanioIndex(ctx: ModuleContext): Map<number, Map<string, number>> {
    const triggerTable = (ctx.dm.getTable("NpcGossipTrigger") ?? {}) as Record<string, any>
    const convert = (ctx.dm.getTable("NpcGossipTriggerConvert") ?? {}) as Record<string, any>
    const npcTrigger = (convert.NpcTrigger ?? {}) as Record<string, Record<string, number>>

    const unitPairs = new Map<number, Map<string, number>>()
    const otherUnits = new Set<number>()
    for (const [unitKey, talkIds] of Object.entries(npcTrigger)) {
        const unit = Number(unitKey)
        const pairs = new Map<string, number>()
        let serial = 0
        for (const talkId of Object.values(talkIds ?? {}).sort((a, b) => a - b)) {
            const combination = triggerTable[String(talkId)]?.NpcCombination
            if (!Array.isArray(combination) || combination.length < 2) continue
            if (Number(combination[0]) !== unit) continue
            const other = Number(combination[1])
            serial += 1
            pairs.set(String(serial).padStart(2, "0"), other)
            otherUnits.add(other)
        }
        if (pairs.size > 0) unitPairs.set(unit, pairs)
    }

    const npcById = ctx.dm.getTableItems("Npc", [...otherUnits])
    const result = new Map<number, Map<string, number>>()
    let unresolved = 0
    for (const [unit, pairs] of unitPairs) {
        const resolved = new Map<string, number>()
        for (const [serial, otherUnit] of pairs) {
            const charId = (npcById.get(String(otherUnit)) as Record<string, unknown> | undefined)?.CharId
            if (typeof charId === "number") resolved.set(serial, charId)
            else unresolved += 1
        }
        if (resolved.size > 0) result.set(unit, resolved)
    }
    if (unresolved > 0) ctx.log(`CharVoice: ${unresolved} 个偶遇组合缺 Npc.CharId，对应语音不输出 companioCharId`)
    return result
}

export function charVoiceModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("CharVoice") as Record<string, any>) || {}
    const companioIndex = buildCompanioIndex(ctx)
    const items: VNodeTree[] = []
    const charIdsWithVoice = new Set<number>()
    /** 战斗语音后缀 → 非皮肤 VoiceDes 键（全角色同后缀共用同一模板）。 */
    const baseDescBySuffix = new Map<string, string[]>()
    /** 偶遇语音条数与其中解析到同伴角色的条数，用于提示数据源缺口。 */
    let companioTotal = 0
    let companioResolved = 0

    const append = (voice: Record<string, any>): void => {
        const voiceId = voice.VoiceId
        const charId = voice.CharId
        if (!voiceId || !charId) return
        charIdsWithVoice.add(Number(charId))
        const descriptions = Array.isArray(voice.VoiceDes) ? voice.VoiceDes : typeof voice.VoiceDes === "string" ? [voice.VoiceDes] : []
        const texts = Array.isArray(voice.VoiceText) ? voice.VoiceText : []
        const textKey = texts[0]
        const res = typeof textKey === "string" ? textKey.replace(/^voice_ch_/, "") : ""
        const entry: Record<string, VNodeTree> = {
            id: voiceId,
            charId,
            name: seq(descriptions.filter(Boolean).map((key: string) => T(key))),
            res,
            text: T(typeof textKey === "string" ? textKey : ""),
        }
        const serial = companioSerial(res)
        if (serial) {
            companioTotal += 1
            const companioCharId = companioIndex.get(Number(voice.UnitId))?.get(serial)
            if (companioCharId !== undefined) {
                entry.companioCharId = companioCharId
                companioResolved += 1
            }
        }
        items.push(entry)
        // 收集非皮肤战斗条目的 VoiceDes 模板（皮肤条目描述带 VoiceDes_Skin 前缀，不参与）
        const suffix = typeof textKey === "string" ? textKey.match(/_(vo_[A-Za-z0-9_]+)$/)?.[1] : undefined
        const plainDes = descriptions.filter((key: string) => !String(key).startsWith("VoiceDes_Skin"))
        if (suffix && plainDes.length > 0 && !baseDescBySuffix.has(suffix)) {
            baseDescBySuffix.set(suffix, plainDes.map(String))
        }
    }

    for (const charVoices of Object.values(table)) {
        if (!charVoices || typeof charVoices !== "object") continue
        for (const voice of Object.values(charVoices as Record<string, any>)) {
            if (!voice || typeof voice !== "object") continue
            append(voice)
        }
    }

    for (const supplement of VOICE_SUPPLEMENTS) {
        if (charIdsWithVoice.has(supplement.charId)) continue
        COMBAT_VOICE_SUFFIXES.forEach((suffix, index) => {
            const textKey = `voice_ch_char_${supplement.voiceName}_${suffix}`
            if (!ctx.textmap.has(textKey)) return
            const descriptions = baseDescBySuffix.get(suffix) ?? []
            items.push({
                // VoiceId 沿用同族数字段（如 2101 组 21010001…），避免与既有条目冲突
                id: supplement.charId * 10000 + index + 1,
                charId: supplement.charId,
                name: seq(descriptions.filter(Boolean).map((key: string) => T(key))),
                res: textKey.replace(/^voice_ch_/, ""),
                text: T(textKey),
            })
        })
    }

    if (companioTotal > companioResolved) {
        ctx.log(`CharVoice: ${companioTotal - companioResolved}/${companioTotal} 条偶遇语音缺对应闲谈组合，未输出 companioCharId`)
    }

    items.sort((a, b) => Number((a as Record<string, unknown>).id ?? 0) - Number((b as Record<string, unknown>).id ?? 0))
    return items
}
