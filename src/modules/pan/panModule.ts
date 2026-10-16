/** Pan module - 魔灵潘神：足迹追踪机制点位、对话与奖励。
 *
 * 数据链（均以真实样本核实）：
 * - 对话：Explore/A_PanTalk_*.story → TalkTrigger（TalkId 720000~720077）
 *   → TalkNode.FirstDialogueId 72xxx01 → Dialogue.chain。
 * - 奖励：潘神 ExploreGroup 经 ExploreGroupReward 指向 Reward 3011
 *  （= Resource 211×1 + Resource 3006×1）；TalkTrigger 720034/720037 亦自带
 *   RewardId = 3011。输出只写 rewardId，不内联展开。
 * - 点位：DesignLevel_data 各关卡 Explore 下含 PanMechanism（UnitId 70701~70706、
 *   70795~70803）的 group；精确 x,y 与 Resource 同管线（SubRegionLevel→srId +
 *   UAsset Design 文件节点坐标，CreatorId/ExploreGroupId 精确归属）。
 *
 * 点位↔对话：UAsset Design 中 Explore_Pan_Common_C 根 actor 的 ExploreGroupId 与 TalkTriggerID
 * 同节点，TalkTriggerID → TalkTrigger.StoryLinePath → 故事内 BranchTriggerNode 的对应分支出口
 * → 该分支可达的 TalkNode（FirstDialogueId）。
 *
 * 条目按 Region 聚合，对话挂在各 group 上；点位对齐 Resource 的 source 规则：按 srId 聚合坐标，不暴露内部机关 UnitId/CreatorId。
 */

import { existsSync, readdirSync } from "node:fs"
import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
import { getExportsRoot } from "../../lua/UAssetServer.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"
import { buildObjectMaps, collectDesignFiles, extractPosition, iterNodes, roundEven } from "../resource/resourceModule.ts"
import { type Row, table } from "../shared/dataHelpers.ts"

export const PAN_NAME_KEY = "UI_Npc_Name_Pan_Common"
/** 潘神统一奖励：TalkTrigger 720034/720037 与全部潘神 ExploreGroup 均指向该 id。 */
export const PAN_REWARD_ID = 3011
/** PanMechanism 的 UnitId 全集（Mechanism 表 UnitRealType = "PanMechanism"）。 */
export const PAN_UNITS = new Set([70701, 70702, 70703, 70704, 70705, 70706, 70795, 70796, 70797, 70798, 70799, 70800, 70801, 70802, 70803])

export interface PanGroup {
    id: number
    level: string
    units: number[]
    rewardId: number
    /** 组内潘神机关 CreatorId（升序，首点判定用，不输出）。 */
    creators: number[]
}

/** 组内候选点：creator 为 UAsset 节点解析出的 CreatorId（未知则排最后）；type 为节点类型（赝品判定用，不输出）。 */
export interface PanCandidate {
    creator: number | undefined
    pos: number[]
    type?: string
}

/**
 * 组件局部坐标赝品阈值：BP_StaticCreatorComponent_C 的 RelativeLocation 是相对父 actor
 * 的局部偏移，父变换不可达时即落为原点附近值。经 QuestGuidePointLocData 指引点交叉
 * 验证（Prologue/Sew/Chezhan/Icelake/Longsha/Lxzs 共 20+ 组），落在此矩形内的组件点
 * 均为赝品，真实点（含指引表精确命中的）皆在此范围外。
 */
const LOCAL_JUNK_X = 6000
const LOCAL_JUNK_Y = 4000

function isLocalJunk(cand: PanCandidate): boolean {
    return (cand.type ?? "").includes("Component") && Math.abs(cand.pos[0]) < LOCAL_JUNK_X && Math.abs(cand.pos[1]) < LOCAL_JUNK_Y
}

/** 首点：先丢弃组件局部赝品，再取 CreatorId 最小者（配置表顺序即调查先后），未知 Creator 排最后。 */
export function firstPoint(cands: PanCandidate[]): number[] | undefined {
    const usable = cands.filter(cand => !isLocalJunk(cand))
    const ordered = [...usable].sort((a, b) => (a.creator ?? Number.POSITIVE_INFINITY) - (b.creator ?? Number.POSITIVE_INFINITY))
    return ordered[0]?.pos
}

function toInt(value: unknown): number | undefined {
    if (typeof value === "number" && Number.isInteger(value)) return value
    if (typeof value !== "string" || !/^-?\d+$/.test(value.trim())) return undefined
    return Number(value)
}

function normList(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    return Object.entries(value as Row)
        .sort(([a], [b]) => Number(a) - Number(b))
        .map(([, item]) => item)
}

/**
 * 收集含潘神机关的 Explore group。
 * 只收 ExploreGroupReward = 3011 的组（数据驱动排除：皓京组给 3014、
 * Sew02 的 6 个单足迹组无奖励条目）。
 */
export function collectPanGroups(ctx: ModuleContext): { groups: PanGroup[]; creatorToGroup: Map<number, number> } {
    const rewards = table(ctx, "ExploreGroupReward")
    const groups: PanGroup[] = []
    const creatorToGroup = new Map<number, number>()
    const dir = join(ctx.dm.scriptDataRoot, "Script", "Datas", "DesignLevel_data")
    for (const file of readdirSync(dir)) {
        if (!file.endsWith(".lua")) continue
        const level = file.slice(0, -4)
        const data = ctx.dm.getTable(`DesignLevel_data/${level}`) as Row | undefined
        const explore = data && typeof data.Explore === "object" ? (data.Explore as Row) : undefined
        if (!explore) continue
        for (const [groupKey, groupValue] of Object.entries(explore)) {
            const groupId = toInt(groupKey)
            if (groupId === undefined || !groupValue || typeof groupValue !== "object") continue
            const units = new Set<number>()
            const creators = new Set<number>()
            for (const creator of Object.values(groupValue as Row)) {
                if (!creator || typeof creator !== "object") continue
                const unitId = toInt((creator as Row).UnitId)
                if (unitId !== undefined && PAN_UNITS.has(unitId)) {
                    units.add(unitId)
                    const creatorId = toInt((creator as Row).CreatorId)
                    if (creatorId !== undefined) {
                        creators.add(creatorId)
                        if (!creatorToGroup.has(creatorId)) creatorToGroup.set(creatorId, groupId)
                    }
                }
            }
            if (units.size === 0) continue
            const rewardId = toInt((rewards[String(groupId)] as Row | undefined)?.RewardId)
            if (rewardId !== PAN_REWARD_ID) continue
            groups.push({
                id: groupId,
                level,
                units: [...units].sort((a, b) => a - b),
                rewardId,
                creators: [...creators].sort((a, b) => a - b),
            })
        }
    }
    groups.sort((a, b) => a.id - b.id)
    return { groups, creatorToGroup }
}

/** 关卡名（小写）→srId；缺失直接抛错，不静默丢点位。 */
export function levelSrMap(ctx: ModuleContext): Map<string, number> {
    const result = new Map<string, number>()
    for (const [level, info] of levelRegionMap(ctx)) result.set(level, info.srId)
    return result
}

/**
 * 关卡名（小写）→{srId, regionId}：以快照自身的 SubRegion 表为准（Region/SubRegion 表各版本自带，
 * 老快照同样适用），不依赖代码里只覆盖当前版本的静态关卡表。
 */
export function levelRegionMap(ctx: ModuleContext): Map<string, { srId: number; regionId: number }> {
    const result = new Map<string, { srId: number; regionId: number }>()
    for (const sub of Object.values(table(ctx, "SubRegion"))) {
        if (!sub || typeof sub !== "object") continue
        const row = sub as Row
        if (typeof row.SubRegionLevel !== "string") continue
        const srId = toInt(row.SubRegionId)
        const regionId = toInt(row.RegionId)
        const level = row.SubRegionLevel.toLowerCase()
        if (srId !== undefined && regionId !== undefined && !result.has(level)) result.set(level, { srId, regionId })
    }
    return result
}

/** 断言 Reward 3011 存在且包含 Resource 3006（只读校验，不改变输出形态）。 */
export function assertPanReward(ctx: ModuleContext): void {
    const reward = (table(ctx, "Reward")[String(PAN_REWARD_ID)] ?? table(ctx, "Reward")[PAN_REWARD_ID]) as Row | undefined
    if (!reward) throw new Error(`Pan 奖励缺失：Reward ${PAN_REWARD_ID} 不存在`)
    const ids = normList(reward.Id).map(toInt)
    const types = normList(reward.Type)
    const hit = ids.some((id, index) => id === 3006 && types[index] === "Resource")
    if (!hit) throw new Error(`Pan 奖励异常：Reward ${PAN_REWARD_ID} 不含 Resource 3006`)
}

/** UAsset Design 文件中潘神节点坐标，按 ExploreGroupId 精确归属（CreatorId 兜底，UnitId 按关卡内匹配）。 */
export async function collectPanPositions(
    ctx: ModuleContext,
    groups: PanGroup[],
    creatorToGroup: Map<number, number>
): Promise<{ positions: Map<number, PanCandidate[]>; talkTriggers: Map<number, number[]> }> {
    const result = new Map<number, PanCandidate[]>()
    // Pan 根 actor（Explore_Pan_*_C）同时带 ExploreGroupId 与对话触发器属性，即点位↔对话的精确对应。
    // 属性名随蓝图而异（TalkTriggerID / Talk Trigger ID / Start·Finish Talk Trigger Id），按出现顺序收集。
    const talkTriggers = new Map<number, number[]>()
    const append = (groupId: number, creator: number | undefined, pos: number[], type: string): void => {
        const point = [roundEven(pos[0]), roundEven(pos[1])]
        const list = result.get(groupId) ?? []
        if (!list.some(existing => existing.creator === creator && existing.pos[0] === point[0] && existing.pos[1] === point[1]))
            list.push({ creator, pos: point, type })
        result.set(groupId, list)
    }
    const exportsRoot = getExportsRoot()
    const mapsRoot = exportsRoot ? join(exportsRoot, "EM", "Content", "Maps", "Levels") : undefined
    if (!mapsRoot || !existsSync(mapsRoot)) return { positions: result, talkTriggers }
    const byId = new Map(groups.map(group => [group.id, group] as const))
    const levels = [...new Set(groups.map(group => group.level))]
    const reader = new AssetReader(ctx.dm.root)
    try {
        for (const level of levels) {
            const levelGroups = groups.filter(group => group.level === level)
            for (const assetPath of collectDesignFiles(mapsRoot, level.toLowerCase())) {
                const data = await reader.readFModelAsset(assetPath)
                if (!data) continue
                const nodes = iterNodes(data)
                const maps = buildObjectMaps(nodes)
                for (const node of nodes) {
                    const props = node.Properties && typeof node.Properties === "object" ? (node.Properties as Row) : undefined
                    if (!props) continue
                    // StaticCreatorId 精确到机关；ExploreGroupId 精确到组（机关未知）；UnitId 按关卡内匹配兜底。
                    const staticId = toInt(props.StaticCreatorId)
                    const groupId = toInt(props.ExploreGroupId)
                    let targets: Array<{ group: PanGroup; creator: number | undefined }> = []
                    if (staticId !== undefined) {
                        const mapped = creatorToGroup.get(staticId)
                        const group = mapped === undefined ? undefined : byId.get(mapped)
                        if (!group || group.level !== level) continue
                        targets = [{ group, creator: staticId }]
                    } else if (groupId !== undefined) {
                        const group = byId.get(groupId)
                        if (!group || group.level !== level) continue
                        const ids = Object.entries(props)
                            .filter(([name]) => name.replaceAll(" ", "").toLowerCase().includes("talktrigger"))
                            .map(([, value]) => toInt(value))
                            .filter((id): id is number => id !== undefined)
                        if (ids.length > 0) talkTriggers.set(group.id, [...new Set([...(talkTriggers.get(group.id) ?? []), ...ids])])
                        targets = [{ group, creator: undefined }]
                    } else {
                        const unitId = toInt(props.UnitId)
                        if (unitId === undefined || !PAN_UNITS.has(unitId)) continue
                        targets = levelGroups.filter(group => group.units.includes(unitId)).map(group => ({ group, creator: undefined }))
                        if (targets.length === 0) continue
                    }
                    const position = extractPosition(node, maps)
                    if (!position) continue
                    for (const { group, creator } of targets) append(group.id, creator, position, String(node.Type ?? ""))
                }
            }
        }
    } finally {
        await reader.close()
    }
    return { positions: result, talkTriggers }
}

/** 经 TalkTrigger 表取触发器所属故事；缺失或不在潘神故事内返回 undefined。 */
function storyOfTrigger(ctx: ModuleContext, triggerId: number): string | undefined {
    const path = (table(ctx, "TalkTrigger")[String(triggerId)] as Row | undefined)?.StoryLinePath
    return typeof path === "string" && path ? path : undefined
}

/**
 * 故事内 BranchTriggerNode：Branches[i] 为 TalkTriggerId，对应出口端口 Branch_{i+1}；
 * 沿连线先序收集该出口可达的全部 TalkNode 的对话链（含 QuestSuccess/Fail 之后的追加节点）。
 */
export function storyTriggerTalks(dialogue: DialogueService, story: string): Map<number, VNodeTree[]> {
    const result = new Map<number, VNodeTree[]>()
    const parents = (dialogue.story(story)?.storyNodeData ?? {}) as Row
    for (const parent of Object.values(parents) as Row[]) {
        const quest = parent?.questNodeData as Row | undefined
        const nodes = quest?.nodeData as Row | undefined
        if (!nodes) continue
        const branch = Object.values(nodes).find(node => (node as Row)?.type === "BranchTriggerNode") as Row | undefined
        if (!branch) continue
        const edges = normList(quest?.lineData) as Row[]
        const triggers = normList((branch.propsData as Row | undefined)?.Branches).map(toInt)
        triggers.forEach((triggerId, index) => {
            if (triggerId === undefined) return
            const talks: VNodeTree[] = []
            const seen = new Set<string>()
            const walk = (key: string): void => {
                if (seen.has(key) || !nodes[key]) return
                seen.add(key)
                const node = nodes[key] as Row
                const firstId = (node.propsData as Row | undefined)?.FirstDialogueId
                if (node.type === "TalkNode" && firstId) talks.push(...(dialogue.chain(firstId) as VNodeTree[]))
                for (const edge of edges) if (edge.startQuest === key) walk(String(edge.endQuest))
            }
            for (const edge of edges)
                if (edge.startQuest === branch.key && edge.startPort === `Branch_${index + 1}`) walk(String(edge.endQuest))
            result.set(triggerId, talks)
        })
    }
    return result
}

export async function panModule(ctx: ModuleContext): Promise<VNodeTree> {
    const { groups, creatorToGroup } = collectPanGroups(ctx)
    if (groups.length === 0) return []
    const regionByLevel = levelRegionMap(ctx)
    // 鲁棒导出：归属以快照自身的 SubRegion 表为准；未覆盖的关卡（如已被删除的老关卡）只 warn 跳过，
    // 保证任何版本快照都能导完，不因单个关卡的数据形态差异中断整包。
    const usable = groups.filter(group => {
        if (!regionByLevel.has(group.level.toLowerCase())) {
            ctx.log(`[warn] Pan 跳过 SubRegion 未覆盖的关卡：${group.level}（group ${group.id}）`)
            return false
        }
        return true
    })
    if (usable.length === 0) return []
    assertPanReward(ctx)
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    if (!dialogue) throw new Error("Pan 需要 Dialogue 依赖")
    const { positions, talkTriggers } = await collectPanPositions(ctx, usable, creatorToGroup)
    const storyTalks = new Map<string, Map<number, VNodeTree[]>>()
    // 仅外语有文本的过场节点（chain 打 __langs 标记、无中文 Content，如潘神出场/退场演出
    // 配的 {空格} 占位）会在中文渲染时被整节点 OMIT，导致跨语言成员/顺序不一致。
    // Pan 统一按中文成员输出：中文补了文本的节点会自动保留，无需改动。
    const dialoguesOf = (groupId: number): VNodeTree[] => {
        const triggerIds = talkTriggers.get(groupId)
        if (!triggerIds) {
            ctx.log(`[warn] Pan group ${groupId} 无对话触发器，对话为空`)
            return []
        }
        const talks: VNodeTree[] = []
        for (const triggerId of triggerIds) {
            const story = storyOfTrigger(ctx, triggerId)
            if (!story) {
                ctx.log(`[warn] Pan group ${groupId} 的 TalkTrigger ${triggerId} 无故事路径`)
                continue
            }
            if (!storyTalks.has(story)) storyTalks.set(story, storyTriggerTalks(dialogue, story))
            const branch = storyTalks.get(story)!.get(triggerId)
            if (!branch) ctx.log(`[warn] Pan group ${groupId} 的 TalkTrigger ${triggerId} 不在故事 ${story} 的分支内`)
            else talks.push(...branch)
        }
        const seen = new Set<string>()
        return (talks as Row[]).filter(talk => {
            if (Array.isArray(talk.__langs) && !talk.__langs.includes("cn")) return false
            const key = String(talk.id)
            if (seen.has(key)) return false
            seen.add(key)
            return true
        })
    }
    // 条目按快照实际出现的 Region 动态生成（升序）；无组数据的 Region 不输出。
    const presentIds = [...new Set(usable.map(group => regionByLevel.get(group.level.toLowerCase())!.regionId))].sort((a, b) => a - b)
    return presentIds.map(id => ({
        id,
        name: T(PAN_NAME_KEY),
        rewardId: PAN_REWARD_ID,
        // 同一魔灵（一次奖励领取 = 一个 group）只出首点；对话按 group 自身的 TalkTriggerID 精确挂载。
        groups: usable
            .filter(group => regionByLevel.get(group.level.toLowerCase())?.regionId === id)
            .map(group => ({
                id: group.id,
                srId: regionByLevel.get(group.level.toLowerCase())!.srId,
                pos: firstPoint(positions.get(group.id) ?? []) ?? [],
                dialogues: dialoguesOf(group.id),
            })),
    }))
}
