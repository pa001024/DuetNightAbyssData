import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"

type Row = Record<string, any>

function rows(ctx: ModuleContext, name: string): Row[] {
    const table = ctx.dm.getTable(name)
    return table && typeof table === "object" ? (Object.values(table).filter(v => v && typeof v === "object") as Row[]) : []
}

function asset(value: unknown): string {
    return typeof value === "string" ? (value.replace(/\\/g, "/").split("/").pop() ?? "").split(".")[0].replace(/^'/, "") : ""
}

function pick(value: unknown, index: number): unknown {
    if (!Array.isArray(value)) return undefined
    const item = value[index]
    return Array.isArray(item) ? item[0] : item
}

function itemName(ctx: ModuleContext, id: unknown): { name?: VNodeTree; type?: string } {
    const key = String(id)
    const skin = ctx.dm.getTableItem("Skin", key) as Row | undefined
    if (skin?.SkinName) return { name: T(skin.SkinName), type: "Skin" }
    const accessory = ctx.dm.getTableItem("CharAccessory", key) as Row | undefined
    if (accessory?.Name) return { name: T(accessory.Name), type: "CharAccessory" }
    const resource = ctx.dm.getTableItem("Resource", key) as Row | undefined
    if (resource?.ResourceName) return { name: T(resource.ResourceName), type: "Resource" }
    return {}
}

export function skinGachaModule(ctx: ModuleContext): VNodeTree {
    const types = new Map(rows(ctx, "SkinGachaType").map(item => [String(item.GachaType), item]))
    return rows(ctx, "SkinGacha")
        .filter(item => item.GachaId !== undefined && item.GachaId !== "")
        .map(item => {
            const type = types.get(String(item.GachaType))
            return {
                id: item.GachaId,
                name: T(item.GachaName),
                desc: T(item.GachaDes),
                warning: T(item.GachaWarning),
                coreDes: T(item.GachaCoreDes),
                coreDesColor: item.GachaCoreDesColor,
                type: T(type?.GachaTypeName),
                subTabId: type?.SubTabId,
                tabId: item.TabId,
                sequence: item.Sequence,
                gachaTimes: item.GachaTimes,
                displayType: item.GachaDisplayType,
                historyType: item.GachaHistoryType,
                hideCountdown: item.IsHIdeCountdown,
                ...(item.GachaStartTime !== undefined ? { startTime: item.GachaStartTime } : {}),
                ...(item.GachaEndTime !== undefined ? { endTime: item.GachaEndTime } : {}),
                cost: { res: item.GachaCostRes, num10: item.GachaCostNum10, displayRes: item.DisplayCostRes },
                probabilityId: item.ProbabilityId,
                conditionId: item.ConditionId,
                star3ItemId: item.Star3ItemId,
                star4ItemId: item.Star4ItemId,
                star5ItemId: item.Star5ItemId,
            }
        })
}

export function skinGachaTabModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "SkinGachaTab")
        .filter(item => item.TabId !== undefined && item.TabId !== "")
        .map(item => ({
            tabId: item.TabId,
            name: T(item.TabName),
            icon: asset(item.Icon),
            reddotNode: item.ReddotNode,
            sequence: item.Sequence,
            gachaIds: item.GachaId ?? [],
        }))
}

export function skinGachaTypeModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "SkinGachaType")
        .filter(item => item.GachaType)
        .map(item => ({ type: item.GachaType, name: T(item.GachaTypeName), subTabId: item.SubTabId }))
}

export function skinGachaItemModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "SkinGachaItem")
        .filter(item => item.GachaItemId !== undefined && item.GachaItemId !== "")
        .map(item => ({
            id: item.GachaItemId,
            rewards: (Array.isArray(item.Id) ? item.Id : []).map((id: unknown, index: number) => {
                const out: Row = { id }
                const mappedType = ({ 2: "Skin", 4: "CharAccessory", 6: "Resource" } as Row)[String(pick(item.Type, index))]
                if (mappedType) out.t = mappedType
                const resolved = itemName(ctx, id)
                if (resolved.type) out.t = resolved.type
                const probability = pick(item.Probability, index)
                const count = pick(item.Count, index)
                if (probability) out.p = probability
                if (typeof count === "number" && count > 0) out.c = count
                if (resolved.name) out.n = resolved.name
                return out
            }),
        }))
}

export function skinGachaCumulativeModule(ctx: ModuleContext): VNodeTree {
    return rows(ctx, "SkinGachaCumulative")
        .filter(item => item.GachaId !== undefined && item.GachaId !== "")
        .map(item => ({
            gachaId: item.GachaId,
            rewards: (Array.isArray(item.RewardId) ? item.RewardId : []).map((rewardId: unknown, index: number) => {
                const reward = ctx.dm.getTableItem("Reward", rewardId as string | number) as Row | undefined
                const ids = Array.isArray(reward?.Id) ? reward.Id : []
                const types = Array.isArray(reward?.Type) ? reward.Type : []
                const counts = Array.isArray(reward?.Count) ? reward.Count : []
                const items = ids.map((id: unknown, itemIndex: number) => {
                    const resolved = itemName(ctx, id)
                    return {
                        id: id as VNodeTree,
                        t: resolved.type ?? types[itemIndex],
                        c: pick(counts, itemIndex) as VNodeTree,
                        n: resolved.name,
                    } as VNodeTree
                }) as VNodeTree
                return {
                    rewardId: rewardId as VNodeTree,
                    target: item.RewardTarget?.[index] ?? null,
                    ...(reward ? { items, mode: reward.Mode } : {}),
                }
            }) as VNodeTree,
        }))
}
