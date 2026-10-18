/** Archive module - 档案总览（ArchiveInfo 1001~1006）：只存骨架与条目 id 引用，不内联已有导出。 */

import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import type { ResourceDataArtifact } from "../resource/resourceModule.ts"

/** 近战/远程按 WeaponId 划分：10xxx 为近战，1002；20xxx 为远程，1003（41 已被 Weapon 现状口径排除）。 */
const RANGED_CUTOFF = 20000
/** 敌人分组标签：与 ArchiveTab 1006 的 TabPara 对齐，命中任一即归属该页（可多归属）。 */
const MONSTER_GROUP_TAGS = ["Mon.Gr", "Mon.Sq", "Mon.Jt", "Mon.Jh", "Mon.Hx", "Mon.Boss"] as const

function table(ctx: ModuleContext, name: string): Record<string, any> {
    const value = ctx.dm.getTable(name)
    return value && typeof value === "object" ? (value as Record<string, any>) : {}
}

function toInt(value: unknown): number | undefined {
    if (typeof value === "number" && Number.isInteger(value)) return value
    if (typeof value !== "string" || !/^-?\d+$/.test(value.trim())) return undefined
    return Number(value)
}

/** 图集路径取 T_ 资源名（如 …/T_Tab_Item.T_Tab_Item' → T_Tab_Item），与 CharAccessory 等模块一致。 */
function iconName(value: unknown): string {
    if (typeof value !== "string") return ""
    return value.match(/(T_[^./']+)/)?.[1] ?? ""
}

function sortedIds(ids: Iterable<number>): number[] {
    return [...new Set(ids)].sort((a, b) => a - b)
}

/** 依赖模块产物（{ 文件名: 条目[] }）取条目 id；产物缺失时抛错，与既有模块保持一致。 */
function artifactIds(ctx: ModuleContext, name: string): number[] {
    const artifact = ctx.getArtifact<Record<string, unknown>>(name)
    const items = artifact?.[name]
    if (!Array.isArray(items)) throw new Error(`${name} artifact is required`)
    const ids: number[] = []
    for (const item of items) {
        const id = toInt((item as Record<string, unknown>)?.id)
        if (id !== undefined) ids.push(id)
    }
    return sortedIds(ids)
}

/** 近战/远程划分：id ≥ 20000 为远程，其余为近战。 */
export function splitWeaponIds(ids: number[]): { melee: number[]; ranged: number[] } {
    const melee: number[] = []
    const ranged: number[] = []
    for (const id of sortedIds(ids)) (id >= RANGED_CUTOFF ? ranged : melee).push(id)
    return { melee, ranged }
}

/** 敌人按 GamePlayTags 分组：AllMonster 为全量，各 TabPara 页可多归属，无 6 标签者归 OtherMonster。 */
export function groupMonsterIds(items: Array<{ id: number; tags?: unknown }>): Record<string, number[]> {
    const groups: Record<string, number[]> = { AllMonster: [] }
    for (const tag of MONSTER_GROUP_TAGS) groups[tag] = []
    groups.OtherMonster = []
    for (const item of items) {
        const id = toInt(item?.id)
        if (id === undefined) continue
        const tags = Array.isArray(item?.tags) ? item.tags.map(String) : []
        groups.AllMonster.push(id)
        let grouped = false
        for (const tag of MONSTER_GROUP_TAGS) {
            if (tags.includes(tag)) {
                groups[tag].push(id)
                grouped = true
            }
        }
        if (!grouped) groups.OtherMonster.push(id)
    }
    for (const key of Object.keys(groups)) groups[key] = sortedIds(groups[key])
    return groups
}

export function archiveModule(ctx: ModuleContext): VNodeTree {
    const data = ctx.getArtifact<ResourceDataArtifact>("ResourceData")
    if (!data) throw new Error("ResourceData artifact is required")

    const charIds = artifactIds(ctx, "Char")
    const weaponIds = artifactIds(ctx, "Weapon")
    const seriesIds = artifactIds(ctx, "BookSeriesArchive")
    const monsterArtifact = ctx.getArtifact<Record<string, unknown>>("Monster")
    const monsterItems = monsterArtifact?.Monster
    if (!Array.isArray(monsterItems)) throw new Error("Monster artifact is required")

    const { melee, ranged } = splitWeaponIds(weaponIds)
    const monsterGroups = groupMonsterIds(monsterItems as Array<{ id: number; tags?: unknown }>)

    const normal: number[] = []
    const task: number[] = []
    for (const [key, resource] of data.resourceMap) {
        const type = toInt((resource as Record<string, unknown>)?.ItemArchiveType)
        if (type === 1) normal.push(Number(key))
        else if (type === 2) task.push(Number(key))
    }

    const tabsByArchive = new Map<number, Array<Record<string, VNodeTree>>>()
    for (const tab of Object.values(table(ctx, "ArchiveTab"))) {
        if (!tab || typeof tab !== "object") continue
        const archiveId = toInt((tab as Record<string, unknown>).ArchiveID)
        const tabId = toInt((tab as Record<string, unknown>).TabId)
        if (archiveId === undefined || tabId === undefined) continue
        const record = tab as Record<string, unknown>
        const entry: Record<string, VNodeTree> = {
            tab: tabId,
            name: T(String(record.TabName ?? "")),
            para: String(record.TabPara ?? ""),
        }
        const icon = iconName(record.Icon)
        if (icon) entry.icon = icon
        if (!tabsByArchive.has(archiveId)) tabsByArchive.set(archiveId, [])
        tabsByArchive.get(archiveId)!.push(entry)
    }
    for (const entries of tabsByArchive.values()) entries.sort((a, b) => Number(a.tab) - Number(b.tab))

    const result: Array<Record<string, VNodeTree>> = []
    const infos = Object.values(table(ctx, "ArchiveInfo"))
        .filter((item): item is Record<string, unknown> => !!item && typeof item === "object")
        .sort((a, b) => Number(a.ArchiveType) - Number(b.ArchiveType))
    for (const info of infos) {
        const archiveType = toInt(info.ArchiveType)
        if (archiveType === undefined) continue
        const item: Record<string, VNodeTree> = {
            id: archiveType,
            title: T(String(info.ArchiveTitle ?? "")),
            major: Number(info.MajorType ?? 0),
            step: Number(info.ArchiveStep ?? 0),
            reward: Number(info.RewardId ?? 0),
        }
        const icon = iconName(info.RewardTabIconPath)
        if (icon) item.icon = icon
        switch (archiveType) {
            case 1001:
                item.entries = charIds
                break
            case 1002:
                item.entries = melee
                break
            case 1003:
                item.entries = ranged
                break
            case 1004:
                if (tabsByArchive.get(1004)) item.tabs = tabsByArchive.get(1004)!
                item.normal = sortedIds(normal)
                item.task = sortedIds(task)
                break
            case 1005:
                item.series = seriesIds
                break
            case 1006:
                if (tabsByArchive.get(1006)) item.tabs = tabsByArchive.get(1006)!
                item.groups = monsterGroups as VNodeTree
                break
            default:
                throw new Error(`未知 ArchiveType: ${archiveType}`)
        }
        result.push(item)
    }
    return result
}
