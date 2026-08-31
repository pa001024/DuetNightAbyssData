/** CharDataTarget module - 角色档案目标。 */
import type { ModuleContext } from "../../core/Graph.ts"
import { seq, T, type VNodeTree } from "../../i18n/vnode.ts"

export function charDataTargetModule(ctx: ModuleContext): VNodeTree {
    const table = ctx.dm.getTable("CharacterDataTarget")
    if (!table || typeof table !== "object") return []
    const result: VNodeTree[] = []
    for (const charTargets of Object.values(table as Record<string, any>)) {
        if (!charTargets || typeof charTargets !== "object") continue
        for (const target of Object.values(charTargets as Record<string, any>)) {
            if (!target || typeof target !== "object") continue
            const id = Number(target.CharDataTarget ?? 0)
            const charId = Number(target.CharId ?? 0)
            if (!id || !charId) continue
            const keys = Array.isArray(target.CharDataName)
                ? target.CharDataName.filter(Boolean)
                : target.CharDataName
                  ? [target.CharDataName]
                  : []
            const name = seq(keys.map((key: string) => T(key)))
            result.push({ id, charId, name, unlock: T(target.CharDataTargetDescribe ?? ""), text: T(target.CharText ?? "") })
        }
    }
    result.sort((a, b) => Number((a as any).id) - Number((b as any).id))
    return result
}
