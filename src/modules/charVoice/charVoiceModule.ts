/** CharVoice module — 扁平化角色语音条目。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { seq, T, type VNodeTree } from "../../i18n/vnode.ts"

export function charVoiceModule(ctx: ModuleContext): VNodeTree {
    const table = (ctx.dm.getTable("CharVoice") as Record<string, any>) || {}
    const items: VNodeTree[] = []
    for (const charVoices of Object.values(table)) {
        if (!charVoices || typeof charVoices !== "object") continue
        for (const voice of Object.values(charVoices as Record<string, any>)) {
            if (!voice || typeof voice !== "object" || !voice.VoiceId || !voice.CharId) continue
            const descriptions = Array.isArray(voice.VoiceDes) ? voice.VoiceDes : typeof voice.VoiceDes === "string" ? [voice.VoiceDes] : []
            const texts = Array.isArray(voice.VoiceText) ? voice.VoiceText : []
            const textKey = texts[0]
            items.push({
                id: voice.VoiceId,
                charId: voice.CharId,
                name: seq(descriptions.filter(Boolean).map((key: string) => T(key))),
                res: typeof textKey === "string" ? textKey.replace(/^voice_ch_/, "") : "",
                text: T(typeof textKey === "string" ? textKey : ""),
            })
        }
    }
    items.sort((a, b) => Number((a as Record<string, unknown>).id ?? 0) - Number((b as Record<string, unknown>).id ?? 0))
    return items
}
