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
 * 条目按 Region 聚合（对话是故事级数据，无法逐 group 硬挂载）；点位对齐 Resource 的
 * source 规则：按 srId 聚合坐标，不暴露内部机关 UnitId/CreatorId。
 */

import { existsSync, readdirSync } from "node:fs"
import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
import { getExportsRoot } from "../../lua/UAssetServer.ts"
import type { DialogueService } from "../dialogue/dialogueModule.ts"
import { npcStoryDialogues } from "../npc/npcModule.ts"
import { buildObjectMaps, collectDesignFiles, extractPosition, iterNodes, roundEven } from "../resource/resourceModule.ts"
import { type Row, table } from "../shared/dataHelpers.ts"

export const PAN_NAME_KEY = "UI_Npc_Name_Pan_Common"
/** 潘神统一奖励：TalkTrigger 720034/720037 与全部潘神 ExploreGroup 均指向该 id。 */
export const PAN_REWARD_ID = 3011
/** PanMechanism 的 UnitId 全集（Mechanism 表 UnitRealType = "PanMechanism"）。 */
export const PAN_UNITS = new Set([70701, 70702, 70703, 70704, 70705, 70706, 70795, 70796, 70797, 70798, 70799, 70800, 70801, 70802, 70803])

export interface PanRegionDef {
    /** 规范 RegionId（Region 表主键，条目 id）。 */
    id: number
    story: string
    levels: string[]
}

/**
 * Region→故事/关卡归属（核实依据）：
 * Prologue/Sew/Chezhan/Icelake/KuangKeng 按关卡名精确匹配故事内节点名
 * （序章/下水道/火车站区域/冰湖区域）；Secr 属 Region 1011（冰湖城东区）故归 Icelake；
 * EX01 归 Longsha（Region 1021 RegionType = "EX"，RegionMapImage 系 EXChapter01）；
 * FT（童话镇区域）归 Thc_Lxzs（排除法 + TalkTrigger 14 = Lxzs 系 group 14 精确吻合）。
 * 车站故事跨 1060（BHCZ）/1063（CZDX），FT 跨 1070/1071/1072，故按 Region 拆条，
 * 同故事的 dialogues 在条目间复用（对话是故事级数据）。
 * 注：TalkTrigger 声明 "A_PanTalk_KuangKeng.story"，磁盘实为 "A_PanTalk_Kuangkeng.lua"，
 * 此处使用磁盘真实名以保证大小写敏感文件系统可加载。
 */
export const PAN_REGIONS: PanRegionDef[] = [
    { id: 1001, story: "Explore/A_PanTalk_Prologue.story", levels: ["Prologue_Village", "Prologue_Balcony"] },
    { id: 1017, story: "Explore/A_PanTalk_Sew.story", levels: ["Chapter01_Sew01", "Chapter01_Sew02", "Chapter01_Sew03"] },
    { id: 1060, story: "Explore/A_PanTalk_Chezhan.story", levels: ["Haiboliya_Chezhan_BHCZ"] },
    { id: 1063, story: "Explore/A_PanTalk_Chezhan.story", levels: ["Haiboliya_Chezhan_CZDX"] },
    {
        id: 1011,
        story: "Explore/A_PanTalk_Icelake.story",
        levels: ["Chapter01_IcelakeCity", "Chapter01_Icelake", "Chapter01_Secr"],
    },
    {
        id: 1013,
        story: "Explore/A_PanTalk_Kuangkeng.story",
        levels: ["Chapter01_Kuangkeng_Part_01", "Chapter01_Kuangkeng_Part_04"],
    },
    { id: 1021, story: "Explore/A_PanTalk_EX01.story", levels: ["Haiboliya_Longsha01", "Haiboliya_Longsha02"] },
    { id: 1070, story: "Explore/A_PanTalk_FT.story", levels: ["Haiboliya_Thc_Lxzs01"] },
    { id: 1071, story: "Explore/A_PanTalk_FT.story", levels: ["Haiboliya_Thc_Lxzs02"] },
    { id: 1072, story: "Explore/A_PanTalk_FT.story", levels: ["Haiboliya_Thc_Lxzx"] },
]

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

/** 关卡名→RegionId，未命中返回 undefined（由调用方 fail loud）。 */
export function regionOfLevel(level: string): number | undefined {
    for (const def of PAN_REGIONS) if (def.levels.includes(level)) return def.id
    return undefined
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
    for (const sub of Object.values(table(ctx, "SubRegion"))) {
        if (!sub || typeof sub !== "object") continue
        const row = sub as Row
        if (typeof row.SubRegionLevel !== "string") continue
        const srId = toInt(row.SubRegionId)
        if (srId !== undefined && !result.has(row.SubRegionLevel.toLowerCase())) result.set(row.SubRegionLevel.toLowerCase(), srId)
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
): Promise<Map<number, PanCandidate[]>> {
    const result = new Map<number, PanCandidate[]>()
    const append = (groupId: number, creator: number | undefined, pos: number[], type: string): void => {
        const point = [roundEven(pos[0]), roundEven(pos[1])]
        const list = result.get(groupId) ?? []
        if (!list.some(existing => existing.creator === creator && existing.pos[0] === point[0] && existing.pos[1] === point[1]))
            list.push({ creator, pos: point, type })
        result.set(groupId, list)
    }
    const exportsRoot = getExportsRoot()
    const mapsRoot = exportsRoot ? join(exportsRoot, "EM", "Content", "Maps", "Levels") : undefined
    if (!mapsRoot || !existsSync(mapsRoot)) return result
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
    return result
}

export async function panModule(ctx: ModuleContext): Promise<VNodeTree> {
    const { groups, creatorToGroup } = collectPanGroups(ctx)
    const srByLevel = levelSrMap(ctx)
    for (const group of groups) {
        if (regionOfLevel(group.level) === undefined) throw new Error(`Pan 关卡未归属 Region：${group.level}（group ${group.id}）`)
        if (!srByLevel.has(group.level.toLowerCase())) throw new Error(`Pan 关卡缺少 SubRegion 映射：${group.level}`)
    }
    assertPanReward(ctx)
    const dialogue = ctx.getArtifact<DialogueService>("Dialogue")
    if (!dialogue) throw new Error("Pan 需要 Dialogue 依赖")
    const positions = await collectPanPositions(ctx, groups, creatorToGroup)
    const dialogueCache = new Map<string, VNodeTree[]>()
    const dialoguesOf = (story: string): VNodeTree[] => {
        const cached = dialogueCache.get(story)
        if (cached) return cached
        const seen = new Set<string>()
        // 仅外语有文本的过场节点（chain 打 __langs 标记、无中文 Content，如潘神出场/退场演出
        // 配的 {空格} 占位）会在中文渲染时被整节点 OMIT，导致跨语言成员/顺序不一致。
        // Pan 统一按中文成员输出：中文补了文本的节点会自动保留，无需改动。
        const dialogues = (npcStoryDialogues(dialogue, story) as Row[]).filter(talk => {
            if (Array.isArray(talk.__langs) && !talk.__langs.includes("cn")) return false
            const key = String(talk.id)
            if (seen.has(key)) return false
            seen.add(key)
            return true
        })
        dialogueCache.set(story, dialogues)
        return dialogues
    }
    return PAN_REGIONS.map(def => ({
        id: def.id,
        name: T(PAN_NAME_KEY),
        rewardId: PAN_REWARD_ID,
        dialogues: dialoguesOf(def.story),
        // 同一魔灵（一次奖励领取 = 一个 group）只出首点；对话相同但位置不同的组各自保留，不合并。
        groups: groups
            .filter(group => regionOfLevel(group.level) === def.id)
            .map(group => ({
                id: group.id,
                srId: srByLevel.get(group.level.toLowerCase())!,
                pos: firstPoint(positions.get(group.id) ?? []) ?? [],
            })),
    }))
}
