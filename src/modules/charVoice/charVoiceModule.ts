/**
 * CharVoice module — 扁平化角色语音条目。
 *
 * 主体来自 CharVoice 表；少数角色（主角，如 CharId 2201 WeitaF、1601 主角-光）不进该表，
 * 但其战斗语音（TextMap 键 voice_ch_char_<token>_vo_* 与语音资产）完整存在，
 * 这里按标准战斗语音集补齐。数据源一旦出现该 CharId 组即自动停用补全，避免重复。
 *
 * 偶遇语音（vo_companio_NN_*）额外输出可选的 companioCharId，即触发该段对话的另一个角色
 * CharId；由语音的 UnlockDialogue 定位闲谈剧情，见 buildCompanioIndex。
 */
import { join } from "node:path"
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

/** 偶遇语音补全：扫描的编号上限（描述键 VoiceDes041~050 覆盖"他人偶遇·其一~其十"）。 */
const COMPANIO_SCAN_COUNT = 10
/** 同一编号的多句语音后缀（vo_companio_NN、_NN_1、_NN_2）。 */
const COMPANIO_SCAN_SUFFIXES = ["", "_1", "_2"] as const

/** 偶遇语音后缀："char_Heitao_vo_companio_02_1" => "02"。 */
function companioSerial(res: string): string | undefined {
    return res.match(/_vo_companio_(\d+)/)?.[1]
}

/** 偶遇语音的编号与句序："char_Heitao_vo_companio_02_1" => [2, 1]；无句序时 part 为 0。 */
function companioOrder(res: string): { serial: number; part: number } | undefined {
    const matched = res.match(/_vo_companio_(\d+)(?:_(\d+))?$/)
    if (!matched) return undefined
    return { serial: Number(matched[1]), part: matched[2] ? Number(matched[2]) : 0 }
}

/**
 * 递归取 story 投影里的 FirstDialogueId（出现顺序即对话顺序）。
 * loadStoryFile 已把节点 propsData 投影为普通表，这里只做字段收集。
 */
function collectFirstDialogueIds(value: unknown, out: number[] = []): number[] {
    if (Array.isArray(value)) {
        for (const item of value) collectFirstDialogueIds(item, out)
        return out
    }
    if (!value || typeof value !== "object") return out
    const record = value as Record<string, any>
    if (typeof record.FirstDialogueId === "number") out.push(record.FirstDialogueId)
    for (const nested of Object.values(record)) if (nested && typeof nested === "object") collectFirstDialogueIds(nested, out)
    return out
}

/**
 * 构建「偶遇语音 → 触发的另一个角色 CharId」索引：对话段号 -> (自身 unit -> 对手 CharId)。
 *
 * 偶遇语音的 UnlockDialogue 就是该段闲谈剧情首个对话的 DialogueId，剧情由 NpcGossipTrigger 的
 * 成对组合经 TalkTrigger.StoryLinePath 指向；同一剧情的后续台词与之同段（…01、…02），按段号归组。
 * 语音后缀里的 companio_NN 编号存在空缺（如卡米没有 companio_01），不能当序号用。
 */
function buildCompanioIndex(ctx: ModuleContext): Map<number, Map<number, number>> {
    const triggerTable = (ctx.dm.getTable("NpcGossipTrigger") ?? {}) as Record<string, any>
    const talkTrigger = (ctx.dm.getTable("TalkTrigger") ?? {}) as Record<string, any>

    /** 段号 -> 成对闲谈的 unit 组合 */
    const pairsBySegment = new Map<number, number[]>()
    let conflicting = 0
    for (const [talkId, entry] of Object.entries(triggerTable)) {
        const combination = (entry as any)?.NpcCombination
        if (!Array.isArray(combination) || combination.length < 2) continue
        const storyPath = String(talkTrigger[talkId]?.StoryLinePath ?? "")
        if (!storyPath) continue
        const story = ctx.dm.loadStoryFile(join("Script", "StoryCreator", "StoryFiles", storyPath.replace(/\.story$/, ".lua")))
        for (const dialogueId of collectFirstDialogueIds(story)) {
            const segment = Math.floor(dialogueId / 100) * 100
            if (pairsBySegment.has(segment)) {
                conflicting += 1
                continue
            }
            pairsBySegment.set(segment, combination.map(Number))
        }
    }
    if (conflicting > 0) ctx.log(`CharVoice: ${conflicting} 个偶遇闲谈的对话段号与其他闲谈重复，仅取首个组合`)

    const units = new Set<number>()
    for (const pair of pairsBySegment.values()) for (const unit of pair) units.add(unit)
    const npcById = ctx.dm.getTableItems("Npc", [...units])

    const result = new Map<number, Map<number, number>>()
    let unresolved = 0
    for (const [segment, pair] of pairsBySegment) {
        const byUnit = new Map<number, number>()
        for (const unit of pair) {
            const other = pair.find(candidate => candidate !== unit)
            const charId = other === undefined ? undefined : (npcById.get(String(other)) as Record<string, unknown> | undefined)?.CharId
            if (typeof charId === "number") byUnit.set(unit, charId)
            else unresolved += 1
        }
        if (byUnit.size > 0) result.set(segment, byUnit)
    }
    if (unresolved > 0) ctx.log(`CharVoice: ${unresolved} 个偶遇闲谈的对手 unit 缺 Npc.CharId`)
    return result
}

/**
 * 补齐 CharVoice 表缺配、但台词与语音都存在的偶遇语音（如 voice_ch_char_Xibi_vo_companio_02）。
 *
 * 名称沿用同角色约定：VoiceDes001 + VoiceDes0(40+编号)；描述键不存在时跳过该编号。
 * 这些语音在数据源里没有 UnlockDialogue，也没有对应的成对闲谈，故不带 companioCharId。
 *
 * VoiceId 按编号顺序插进同角色偶遇语音之间：数据源为缺配编号预留了空位（如溪比 01=10387、
 * 04=10390，补全的 02/03 即 10388/10389）；空隙不足时退到该角色最大 VoiceId 之后。
 */
function supplementCompanioVoices(
    ctx: ModuleContext,
    tokensByChar: Map<number, string>,
    knownKeys: Set<string>,
    existing: Map<number, Array<{ serial: number; part: number; id: number }>>,
    usedIds: Set<number>
): VNodeTree[] {
    const byOrder = (a: { serial: number; part: number }, b: { serial: number; part: number }) => a.serial - b.serial || a.part - b.part
    const items: VNodeTree[] = []

    for (const [charId, token] of [...tokensByChar].sort((a, b) => a[0] - b[0])) {
        const known = (existing.get(charId) ?? []).slice().sort(byOrder)
        const missing: Array<{ serial: number; part: number; key: string; description: string }> = []
        for (let serial = 1; serial <= COMPANIO_SCAN_COUNT; serial++) {
            const description = `VoiceDes0${40 + serial}`
            if (!ctx.textmap.has(description)) continue
            for (const [index, suffix] of COMPANIO_SCAN_SUFFIXES.entries()) {
                const key = `voice_ch_char_${token}_vo_companio_${String(serial).padStart(2, "0")}${suffix}`
                if (knownKeys.has(key) || !ctx.textmap.has(key)) continue
                if (ctx.dm.getTableItem("Talk_SoundEditor", key) === undefined) continue
                missing.push({ serial, part: index, key, description })
            }
        }
        const tail = Math.max(0, ...known.map(entry => entry.id))
        for (const entry of missing.sort(byOrder)) {
            const previous = known.filter(candidate => byOrder(candidate, entry) < 0).pop()
            const next = known.find(candidate => byOrder(candidate, entry) > 0)
            let voiceId = previous ? previous.id + 1 : (next?.id ?? tail) - 1
            if (next && voiceId >= next.id) voiceId = Math.max(tail, next.id)
            while (usedIds.has(voiceId)) voiceId += 1
            usedIds.add(voiceId)
            known.push({ serial: entry.serial, part: entry.part, id: voiceId })
            known.sort(byOrder)
            items.push({
                id: voiceId,
                charId,
                // 数据源未配置，属流水线补全，供下游决定是否展示
                hide: true,
                name: seq([T("VoiceDes001"), T(entry.description)]),
                res: entry.key.replace(/^voice_ch_/, ""),
                text: T(entry.key),
            })
        }
    }
    return items
}

export function charVoiceModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("CharVoice") as Record<string, any>) || {}
    const companioIndex = buildCompanioIndex(ctx)
    const items: VNodeTree[] = []
    const charIdsWithVoice = new Set<number>()
    /** 战斗语音后缀 → 非皮肤 VoiceDes 键（全角色同后缀共用同一模板）。 */
    const baseDescBySuffix = new Map<string, string[]>()
    /** 角色 → 语音键前缀 token（取自该角色已有条目）。 */
    const tokensByChar = new Map<number, string>()
    /** 数据源已出现的语音键，避免补全时重复。 */
    const knownKeys = new Set<string>()
    /** 角色 → 已有偶遇语音的编号/句序/VoiceId，供补全条目插空编号。 */
    const companioIds = new Map<number, Array<{ serial: number; part: number; id: number }>>()
    /** 已使用的 VoiceId，保证补全条目不与既有条目相撞。 */
    const usedIds = new Set<number>()
    /** 偶遇语音条数与其中解析到同伴角色的条数，用于提示数据源缺口。 */
    let companioTotal = 0
    let companioResolved = 0

    const append = (voice: Record<string, any>): void => {
        const voiceId = voice.VoiceId
        const charId = voice.CharId
        if (!voiceId || !charId) return
        charIdsWithVoice.add(Number(charId))
        usedIds.add(Number(voiceId))
        const descriptions = Array.isArray(voice.VoiceDes) ? voice.VoiceDes : typeof voice.VoiceDes === "string" ? [voice.VoiceDes] : []
        const texts = Array.isArray(voice.VoiceText) ? voice.VoiceText : []
        const textKey = texts[0]
        if (typeof textKey === "string") {
            knownKeys.add(textKey)
            const token = textKey.match(/^voice_ch_char_([A-Za-z0-9_]+?)_vo_/)?.[1]
            if (token) tokensByChar.set(Number(charId), token)
        }
        const res = typeof textKey === "string" ? textKey.replace(/^voice_ch_/, "") : ""
        const entry: Record<string, VNodeTree> = {
            id: voiceId,
            charId,
            name: seq(descriptions.filter(Boolean).map((key: string) => T(key))),
            res,
            text: T(typeof textKey === "string" ? textKey : ""),
        }
        const serial = companioSerial(res)
        const order = companioOrder(res)
        if (order) {
            if (!companioIds.has(Number(charId))) companioIds.set(Number(charId), [])
            companioIds.get(Number(charId))!.push({ ...order, id: Number(voiceId) })
        }
        if (serial) {
            companioTotal += 1
            const segment = Math.floor(Number(voice.UnlockDialogue) / 100) * 100
            const companioCharId = Number.isFinite(segment) ? companioIndex.get(segment)?.get(Number(voice.UnitId)) : undefined
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

    const supplemented = supplementCompanioVoices(ctx, tokensByChar, knownKeys, companioIds, usedIds)
    items.push(...supplemented)
    if (supplemented.length > 0) ctx.log(`CharVoice: 补齐 ${supplemented.length} 条表外偶遇语音（台词与语音均存在）`)

    if (companioTotal > companioResolved) {
        ctx.log(`CharVoice: ${companioTotal - companioResolved}/${companioTotal} 条偶遇语音缺对应闲谈组合，未输出 companioCharId`)
    }

    items.sort((a, b) => Number((a as Record<string, unknown>).id ?? 0) - Number((b as Record<string, unknown>).id ?? 0))
    return items
}
