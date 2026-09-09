/**
 * CharVoice module — 扁平化角色语音条目。
 *
 * 主体来自 CharVoice 表；少数角色（主角，如 CharId 2201 WeitaF、1601 主角-光）不进该表，
 * 但其战斗语音（TextMap 键 voice_ch_char_<token>_vo_* 与语音资产）完整存在，
 * 这里按标准战斗语音集补齐。数据源一旦出现该 CharId 组即自动停用补全，避免重复。
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

export function charVoiceModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("CharVoice") as Record<string, any>) || {}
    const items: VNodeTree[] = []
    const charIdsWithVoice = new Set<number>()
    /** 战斗语音后缀 → 非皮肤 VoiceDes 键（全角色同后缀共用同一模板）。 */
    const baseDescBySuffix = new Map<string, string[]>()

    const append = (voice: Record<string, any>): void => {
        const voiceId = voice.VoiceId
        const charId = voice.CharId
        if (!voiceId || !charId) return
        charIdsWithVoice.add(Number(charId))
        const descriptions = Array.isArray(voice.VoiceDes) ? voice.VoiceDes : typeof voice.VoiceDes === "string" ? [voice.VoiceDes] : []
        const texts = Array.isArray(voice.VoiceText) ? voice.VoiceText : []
        const textKey = texts[0]
        items.push({
            id: voiceId,
            charId,
            name: seq(descriptions.filter(Boolean).map((key: string) => T(key))),
            res: typeof textKey === "string" ? textKey.replace(/^voice_ch_/, "") : "",
            text: T(typeof textKey === "string" ? textKey : ""),
        })
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

    items.sort((a, b) => Number((a as Record<string, unknown>).id ?? 0) - Number((b as Record<string, unknown>).id ?? 0))
    return items
}
