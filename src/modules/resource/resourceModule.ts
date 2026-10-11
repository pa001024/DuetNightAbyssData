/** Resource module - resource metadata and map source coordinates. */

import { existsSync, readdirSync } from "node:fs"
import { join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import type { HardBossDataArtifact } from "../hardBoss/hardBossModule.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
import { getExportsRoot } from "../../lua/UAssetServer.ts"

type Row = Record<string, any>
export type ResourceSourceItem = { srId: number; rewardId?: number; unitId?: number; pos: number[][] }
export type ResourcePosition = { pos?: number[]; treasurePos?: number[] }
export interface ResourceDataArtifact {
    output: VNodeTree[]
    resourceMap: Map<number, Row>
    sources: Map<number, ResourceSourceItem[]>
    placements: Map<number, ResourceSourceItem[]>
    positions: Map<number, ResourcePosition>
}
type ResourcePair = [number, number | undefined]

function rows(table: unknown): Row[] {
    if (!table || typeof table !== "object" || Array.isArray(table)) return []
    return Object.values(table).filter((value): value is Row => !!value && typeof value === "object" && !Array.isArray(value))
}

function toInt(value: unknown): number | undefined {
    if (typeof value === "number" && Number.isInteger(value)) return value
    if (typeof value !== "string" || !/^-?\d+$/.test(value.trim())) return undefined
    return Number(value)
}

function normalizeList(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return value === undefined || value === null ? [] : [value]
    const entries = Object.entries(value as Record<string, unknown>)
        .map(([key, item]) => [Number(key), item] as const)
        .filter(([key]) => Number.isInteger(key) && key > 0)
        .sort(([a], [b]) => a - b)
    if (entries.length === 0) return []
    const result: unknown[] = []
    for (const [index, item] of entries) result[index - 1] = item
    return result
}

/**
 * 奖励可传递资源：直连 Resource、嵌套 Reward（如 4021002→4021001）、终端 Drop（如 4021001→Drop 40101→4020001）。
 * 奖励嵌套可能成环，用 visited 截断并按顶层 RewardId 记忆化。
 * 返回 direct（本层直连 Resource）与 all（direct + 嵌套传递）：嵌套传递只对采集类机关展开
 * （宝箱/任务包的嵌套内容不计入地图拾取点位，见 buildLinkMaps）。
 */
export function createRewardResolver(
    rewardTable: Record<string, unknown> | undefined,
    dropToResource: Map<number, number[]>,
    resourceMap: Map<number, Row>
): (rewardId: number) => { direct: Set<number>; all: Set<number> } {
    const memo = new Map<number, { direct: Set<number>; all: Set<number> }>()
    const resolve = (rewardId: number, seen: Set<number>): { direct: Set<number>; all: Set<number> } => {
        const cached = memo.get(rewardId)
        if (cached) return cached
        const direct = new Set<number>()
        const all = new Set<number>()
        memo.set(rewardId, { direct, all })
        if (seen.has(rewardId)) return { direct, all }
        seen.add(rewardId)
        const reward = rewardTable?.[rewardId] as Row | undefined
        if (reward && typeof reward === "object") {
            const ids = normalizeList(reward.Id)
            const types = normalizeList(reward.Type)
            for (let i = 0; i < types.length; i++) {
                if (types[i] !== "Resource" && types[i] !== "Reward" && types[i] !== "Drop") continue
                const id = toInt(ids[i])
                if (id === undefined) continue
                if (types[i] === "Resource") {
                    if (resourceMap.has(id)) {
                        direct.add(id)
                        all.add(id)
                    }
                } else if (types[i] === "Reward") {
                    for (const resourceId of resolve(id, seen).all) all.add(resourceId)
                } else {
                    for (const resourceId of dropToResource.get(id) ?? []) all.add(resourceId)
                }
            }
        }
        seen.delete(rewardId)
        return { direct, all }
    }
    return (rewardId: number) => resolve(rewardId, new Set<number>())
}

/** 资源是否为野外采集物：AccessKey 含 Text_Collecting_*（如坚果/矿石）；打怪掉落只有 Dungeon/Shop/Text_Monster。 */
function hasCollectingKey(resourceMap: Map<number, Row>, resourceId: number): boolean {
    return normalizeAccessKeys((resourceMap.get(resourceId) as Row | undefined)?.AccessKey).some(key =>
        key.startsWith("Text_Collecting")
    )
}

/** 资源 AccessKey 去重保序（数组或单值）。 */
export function normalizeAccessKeys(value: unknown): string[] {
    const list = Array.isArray(value) ? value : value === undefined || value === null ? [] : [value]
    const result: string[] = []
    for (const key of list) {
        if (typeof key !== "string" || !key || result.includes(key)) continue
        result.push(key)
    }
    return result
}

/** AccessKey→AccessText（如 Text_Collecting_Prologue01→Access_Collecting_Prologue01），供多语言渲染。 */
export function buildAccessTexts(dm: ModuleContext["dm"]): Map<string, string> {
    const result = new Map<string, string>()
    for (const row of rows(dm.getTable("Access"))) {
        if (typeof row.AccessKey !== "string" || typeof row.AccessText !== "string") continue
        if (!result.has(row.AccessKey)) result.set(row.AccessKey, row.AccessText)
    }
    // MAIN_UI_FORGE02（铸造（可铸造：%s））的 %s 须运行时填充，静态导出无法补值，降级为基础标签 MAIN_UI_FORGE（铸造）。
    for (const [key, text] of result) {
        if (text === "MAIN_UI_FORGE02") result.set(key, "MAIN_UI_FORGE")
    }
    return result
}

/**
 * AccessKey→AccessRule（如 Shop_Main→Return）。Return 项须运行时展开子项（在售商店/掉落委托）或跳转
 * 系统界面，静态导出无法渲染，随获取途径文本一并隐藏；无规则与 InterfaceJump 项为直接展示文本。
 */
export function buildAccessRules(dm: ModuleContext["dm"]): Map<string, string> {
    const result = new Map<string, string>()
    for (const row of rows(dm.getTable("Access"))) {
        if (typeof row.AccessKey !== "string" || typeof row.AccessRule !== "string") continue
        if (!result.has(row.AccessKey)) result.set(row.AccessKey, row.AccessRule)
    }
    return result
}

/** 去掉 Return 规则项（需动态展开，静态不可见），保序；keep 命中的 key 直接保留（如已验证的 HardBoss）。 */
export function visibleAccessKeys(keys: string[], rules: Map<string, string>, keep?: (key: string) => boolean): string[] {
    return keys.filter(key => (keep?.(key) ?? false) || rules.get(key) !== "Return")
}

export function buildLinkMaps(dm: ModuleContext["dm"], resourceMap: Map<number, Row>) {
    const drops = rows(dm.getTable("Drop"))
    const rarelyToDrop = new Map<number, number[]>()
    const dropToResource = new Map<number, number[]>()
    for (const drop of drops) {
        const dropId = toInt(drop.DropId)
        if (dropId === undefined) continue
        const rarelyId = toInt(drop.RarelyId)
        if (rarelyId !== undefined) addUnique(rarelyToDrop, rarelyId, dropId)
        if (drop.UseEffectType === "GetResource") {
            const resourceId = toInt(drop.UseParam)
            if (resourceId !== undefined && resourceMap.has(resourceId)) addUnique(dropToResource, dropId, resourceId)
        }
    }

    const resolveReward = createRewardResolver(
        dm.getTable("Reward") as Record<string, unknown> | undefined,
        dropToResource,
        resourceMap
    )

    const mechanismToResource = new Map<number, ResourcePair[]>()
    const pushPair = (unitId: number, resourceId: number, rewardId: number): void => {
        const list = mechanismToResource.get(unitId) ?? []
        if (!list.some(pair => pair[0] === resourceId && pair[1] === rewardId)) list.push([resourceId, rewardId])
        mechanismToResource.set(unitId, list)
    }
    for (const mechanism of rows(dm.getTable("Mechanism"))) {
        const unitId = toInt(mechanism.UnitId)
        if (unitId === undefined) continue
        // 嵌套/稀有传递只给野外采集物：资源 AccessKey 含 Text_Collecting_* 才计入地图拾取点位；
        // 打怪掉落（如甲壳，AccessKey 只有 Dungeon/Shop/Text_Monster）不因宝箱战利品表含其材料而列为拾取。直连保持不变。
        const rewardId = toInt(mechanism.RewardId)
        if (rewardId !== undefined) {
            const resolved = resolveReward(rewardId)
            for (const resourceId of resolved.all) {
                if (!resolved.direct.has(resourceId) && !hasCollectingKey(resourceMap, resourceId)) continue
                pushPair(unitId, resourceId, rewardId)
            }
        }
        // 稀有掉落（如矿石 1008→4020004）：仅 RareProb > 0 建模，0 表示不掉落（如 1009）。
        const params = mechanism.UnitParams
        const rareProb = params && typeof params === "object" ? Number((params as Row).RareProb) : NaN
        const rareRewardId = params && typeof params === "object" ? toInt((params as Row).RareRewardId) : undefined
        if (rareRewardId !== undefined && Number.isFinite(rareProb) && rareProb > 0)
            for (const resourceId of resolveReward(rareRewardId).all) {
                if (!hasCollectingKey(resourceMap, resourceId)) continue
                pushPair(unitId, resourceId, rareRewardId)
            }
    }

    const randomRuleToResource = new Map<number, ResourcePair[]>()
    for (const [key, creator] of Object.entries((dm.getTable("RandomCreator") as Record<string, unknown>) ?? {})) {
        if (!creator || typeof creator !== "object" || (creator as Row).UnitType !== "Mechanism") continue
        const ruleId = toInt(key)
        if (ruleId === undefined) continue
        for (const unitInfo of normalizeList((creator as Row).RandomInfos)) {
            if (!unitInfo || typeof unitInfo !== "object") continue
            const unitId = toInt((unitInfo as Row).UnitId)
            if (unitId === undefined) continue
            for (const pair of mechanismToResource.get(unitId) ?? []) {
                const list = randomRuleToResource.get(ruleId) ?? []
                if (!list.some(existing => existing[0] === pair[0] && existing[1] === pair[1])) list.push(pair)
                randomRuleToResource.set(ruleId, list)
            }
        }
    }
    return { rarelyToDrop, dropToResource, mechanismToResource, randomRuleToResource }
}

function addUnique(map: Map<number, number[]>, key: number, value: number): void {
    const values = map.get(key) ?? []
    if (!values.includes(value)) values.push(value)
    map.set(key, values)
}

function buildDesignLevelUnits(dm: ModuleContext["dm"]): { unitIds: Map<number, number>; creatorTypes: Map<number, string> } {
    const unitIds = new Map<number, number>()
    const creatorTypes = new Map<number, string>()
    const dir = join(dm.scriptDataRoot, "Script", "Datas", "DesignLevel_data")
    if (!existsSync(dir)) return { unitIds, creatorTypes }
    for (const file of readdirSync(dir)) {
        if (!file.endsWith(".lua")) continue
        const data = dm.getTable(`DesignLevel_data/${file.slice(0, -4)}`)
        collectCreatorIds(data, unitIds, creatorTypes)
    }
    return { unitIds, creatorTypes }
}

function collectExploreUnitIds(value: unknown, result: Set<number>): void {
    if (Array.isArray(value)) {
        for (const item of value) collectExploreUnitIds(item, result)
        return
    }
    if (!value || typeof value !== "object") return
    const row = value as Row
    const unitId = toInt(row.UnitId)
    if (unitId !== undefined) result.add(unitId)
    for (const item of Object.values(row)) collectExploreUnitIds(item, result)
}

function buildBookPlacements(dm: ModuleContext["dm"], links: ReturnType<typeof buildLinkMaps>): Map<number, ResourceSourceItem[]> {
    const placements = new Map<number, ResourceSourceItem[]>()
    const levelToSubRegion = new Map<string, number>()
    for (const subRegion of rows(dm.getTable("SubRegion"))) {
        const level = typeof subRegion.SubRegionLevel === "string" ? subRegion.SubRegionLevel : undefined
        const subRegionId = toInt(subRegion.SubRegionId)
        if (level && subRegionId !== undefined) levelToSubRegion.set(level, subRegionId)
    }

    const dir = join(dm.scriptDataRoot, "Script", "Datas", "DesignLevel_data")
    if (!existsSync(dir)) return placements
    for (const file of readdirSync(dir)) {
        if (!file.endsWith(".lua")) continue
        const level = file.slice(0, -4)
        const subRegionId = levelToSubRegion.get(level)
        if (subRegionId === undefined) continue
        const data = dm.getTable(`DesignLevel_data/${level}`) as Row
        const unitIds = new Set<number>()
        collectExploreUnitIds(data.Explore, unitIds)
        for (const unitId of unitIds) {
            for (const resourceId of links.dropToResource.get(unitId) ?? []) appendSource(placements, resourceId, subRegionId, [])
            for (const [resourceId, rewardId] of links.mechanismToResource.get(unitId) ?? [])
                appendSource(placements, resourceId, subRegionId, [], rewardId, unitId)
        }
    }
    return placements
}

function collectCreatorIds(value: unknown, result: Map<number, number>, types?: Map<number, string>): void {
    if (Array.isArray(value)) {
        for (const item of value) collectCreatorIds(item, result, types)
        return
    }
    if (!value || typeof value !== "object") return
    const row = value as Row
    const creatorId = toInt(row.CreatorId)
    const unitId = toInt(row.UnitId)
    if (creatorId !== undefined && unitId !== undefined && !result.has(creatorId)) result.set(creatorId, unitId)
    const unitType = typeof row.UnitType === "string" ? row.UnitType : undefined
    if (creatorId !== undefined && unitType !== undefined && types && !types.has(creatorId)) types.set(creatorId, unitType)
    for (const item of Object.values(row)) collectCreatorIds(item, result, types)
}

function normalizeLevelKey(filePath: string): string | undefined {
    const stem =
        filePath
            .split(/[\\/]/)
            .pop()
            ?.replace(/\.[^.]+$/, "") ?? ""
    if (stem.endsWith("_Design")) return stem.slice(0, -7).toLowerCase()
    if (stem.endsWith("_BuiltData")) return stem.slice(0, -9).toLowerCase()
    if (stem.includes("_Art_")) return stem.split("_Art_", 1)[0].toLowerCase()
    if (stem.endsWith("_Art")) return stem.slice(0, -4).toLowerCase()
    return stem ? stem.toLowerCase() : undefined
}

export function collectDesignFiles(mapsRoot: string, level: string): string[] {
    const result: string[] = []
    const stack = [mapsRoot]
    while (stack.length > 0) {
        const current = stack.pop()!
        let entries: Array<{ name: string; isDirectory(): boolean; isFile(): boolean }>
        try {
            entries = readdirSync(current, { withFileTypes: true, encoding: "utf8" }) as unknown as Array<{
                name: string
                isDirectory(): boolean
                isFile(): boolean
            }>
        } catch {
            continue
        }
        for (const entry of entries) {
            const path = join(current, entry.name)
            if (entry.isDirectory()) {
                if (entry.name === "Design_Data") {
                    let files: Array<{ name: string; isDirectory(): boolean; isFile(): boolean }>
                    try {
                        files = readdirSync(path, { withFileTypes: true, encoding: "utf8" }) as unknown as Array<{
                            name: string
                            isDirectory(): boolean
                            isFile(): boolean
                        }>
                    } catch {
                        continue
                    }
                    for (const file of files) {
                        if (
                            !file.isFile() ||
                            !/\.(?:umap|uasset)$/i.test(file.name) ||
                            (!file.name.endsWith("_Design.umap") && !file.name.endsWith("_Design.uasset"))
                        )
                            continue
                        const assetPath = join(path, file.name)
                        if (normalizeLevelKey(assetPath) === level) result.push(assetPath)
                    }
                } else stack.push(path)
            }
        }
    }
    return result.sort((a, b) => a.length - b.length || a.localeCompare(b))
}

export function iterNodes(data: unknown): Row[] {
    if (Array.isArray(data)) return data.filter((item): item is Row => !!item && typeof item === "object" && !Array.isArray(item))
    if (!data || typeof data !== "object") return []
    const result: Row[] = []
    for (const value of Object.values(data as Row)) {
        if (Array.isArray(value))
            result.push(...value.filter((item): item is Row => !!item && typeof item === "object" && !Array.isArray(item)))
        else if (value && typeof value === "object")
            result.push(
                ...Object.values(value as Row).filter((item): item is Row => !!item && typeof item === "object" && !Array.isArray(item))
            )
    }
    return result
}

function refParts(value: unknown): [string | undefined, string | undefined] {
    if (typeof value !== "string" || !value) return [undefined, undefined]
    let raw = value.replace(/^'+|'+$/g, "")
    const colon = raw.indexOf(":")
    if (colon >= 0) raw = raw.slice(colon + 1)
    const parts = raw.split(".")
    if (parts.length >= 2) return [parts[parts.length - 2], parts[parts.length - 1]]
    return [undefined, parts[0]]
}

/** 按 Outer 全名/短名与 ObjectPath 建立节点索引，供引用解析使用 */
export function buildObjectMaps(nodes: Row[]) {
    const byOuter = new Map<string, Row>()
    const byName = new Map<string, Row[]>()
    const byPath = new Map<string, Row>()
    for (const node of nodes) {
        const name = typeof node.Name === "string" ? node.Name : undefined
        if (name) byName.set(name, [...(byName.get(name) ?? []), node])
        const outerValue = node.Outer && typeof node.Outer === "object" ? node.Outer.ObjectName : node.Outer
        const outer = typeof outerValue === "string" ? outerValue : undefined
        const [, outerShort] = refParts(outer)
        if (outer && name) byOuter.set(`${outer}\u0000${name}`, node)
        if (outerShort && name) byOuter.set(`${outerShort}\u0000${name}`, node)
        if (typeof node.ObjectPath === "string") byPath.set(node.ObjectPath, node)
    }
    return { byOuter, byName, byPath }
}

function toVec3(value: unknown): number[] | undefined {
    if (!value || typeof value !== "object") return undefined
    const row = value as Row
    const x = Number(row.X)
    const y = Number(row.Y)
    const z = row.Z === undefined ? 0 : Number(row.Z)
    return Number.isFinite(x) && Number.isFinite(y) && Number.isFinite(z) ? [x, y, z] : undefined
}

export function roundEven(value: number): number {
    const sign = value < 0 ? -1 : 1
    const absolute = Math.abs(value)
    const floor = Math.floor(absolute)
    const fraction = absolute - floor
    if (fraction < 0.5) return sign * floor
    if (fraction > 0.5) return sign * (floor + 1)
    return sign * (floor % 2 === 0 ? floor : floor + 1)
}

function resolveRef(ref: unknown, maps: ReturnType<typeof buildObjectMaps>): Row | undefined {
    if (!ref || typeof ref !== "object") return undefined
    const row = ref as Row
    if (typeof row.ObjectPath === "string") {
        const found = maps.byPath.get(row.ObjectPath)
        if (found) return found
    }
    const [outer, short] = refParts(row.ObjectName)
    if (outer && short) {
        const found = maps.byOuter.get(`${outer}\u0000${short}`)
        if (found) return found
    }
    const candidates = short ? (maps.byName.get(short) ?? []) : []
    return candidates.length === 1 ? candidates[0] : undefined
}

function refLocation(ref: unknown, maps: ReturnType<typeof buildObjectMaps>, seen = new Set<Row>()): number[] | undefined {
    const obj = resolveRef(ref, maps)
    if (!obj || seen.has(obj)) return undefined
    seen.add(obj)
    const props = obj.Properties && typeof obj.Properties === "object" ? (obj.Properties as Row) : {}
    let local = toVec3(props.RelativeLocation) ?? toVec3(props.Location)
    const transform = props.RelativeTransform
    if (transform && typeof transform === "object") local = toVec3((transform as Row).Translation) ?? local
    if (local) {
        return local
    }
    for (const key of ["RootComponent", "DefaultSceneRoot", "AttachParent", "Sphere", "SceneComponent", "CollisionComponent"]) {
        const location = refLocation(props[key], maps, seen)
        if (location) return location
    }
    return undefined
}

function accumulatedRefLocation(ref: unknown, maps: ReturnType<typeof buildObjectMaps>, seen = new Set<Row>()): number[] | undefined {
    const obj = resolveRef(ref, maps)
    if (!obj || seen.has(obj)) return undefined
    seen.add(obj)
    const props = obj.Properties && typeof obj.Properties === "object" ? (obj.Properties as Row) : {}
    let local = toVec3(props.RelativeLocation) ?? toVec3(props.Location)
    const transform = props.RelativeTransform
    if (transform && typeof transform === "object") local = toVec3((transform as Row).Translation) ?? local
    if (local) {
        const parent = accumulatedRefLocation(props.AttachParent, maps, seen)
        if (parent) return local.map((value, index) => value + parent[index])
        const outer = objectLocation(resolveRef(obj.Outer, maps) ?? {}, maps, true)
        return outer ?? local
    }
    return accumulatedRefLocation(props.AttachParent, maps, seen)
}

function objectLocation(obj: Row, maps: ReturnType<typeof buildObjectMaps>, rootFirst: boolean): number[] | undefined {
    const props = obj.Properties && typeof obj.Properties === "object" ? (obj.Properties as Row) : {}
    const direct = () => {
        const location = toVec3(props.RelativeLocation) ?? toVec3(props.Location)
        if (location) return location
        const transform = props.RelativeTransform
        return transform && typeof transform === "object" ? toVec3((transform as Row).Translation) : undefined
    }
    const related = () => {
        for (const key of ["RootComponent", "DefaultSceneRoot", "AttachParent", "Sphere", "SceneComponent", "CollisionComponent"]) {
            const location = refLocation(props[key], maps)
            if (location) return location
        }
        return undefined
    }
    return rootFirst ? (related() ?? direct()) : (direct() ?? related())
}

/** UE 旋转作用于向量（FRotationMatrix 约定，Roll→Pitch→Yaw，左手系） */
function rotateVector(vector: number[], rotation: Row): number[] {
    const toRad = Math.PI / 180
    const pitch = (Number(rotation.Pitch) || 0) * toRad
    const yaw = (Number(rotation.Yaw) || 0) * toRad
    const roll = (Number(rotation.Roll) || 0) * toRad
    const cp = Math.cos(pitch)
    const sp = Math.sin(pitch)
    const cy = Math.cos(yaw)
    const sy = Math.sin(yaw)
    const cr = Math.cos(roll)
    const sr = Math.sin(roll)
    const [x, y, z] = vector
    return [
        x * cp * cy + y * (sr * sp * cy - cr * sy) + z * -(cr * sp * cy + sr * sy),
        x * cp * sy + y * (sr * sp * sy + cr * cy) + z * (cy * sr - cr * sp * sy),
        x * sp + y * -sr * cp + z * cr * cp,
    ]
}

/** 直连 actor 根组件的子组件世界坐标：根位置 + 根旋转作用于组件局部偏移；非直连返回 undefined */
function rootChildLocation(node: Row, key: string, maps: ReturnType<typeof buildObjectMaps>): number[] | undefined {
    const props = node.Properties && typeof node.Properties === "object" ? (node.Properties as Row) : {}
    const root = resolveRef(props.RootComponent, maps) ?? resolveRef(props.DefaultSceneRoot, maps)
    const rootProps = root?.Properties && typeof root.Properties === "object" ? (root.Properties as Row) : {}
    const rootLocation = toVec3(rootProps.RelativeLocation) ?? toVec3(rootProps.Location)
    if (!rootLocation) return undefined
    const child = resolveRef(props[key], maps)
    if (!child) return undefined
    const childProps = child.Properties && typeof child.Properties === "object" ? (child.Properties as Row) : {}
    if (childProps.AttachParent && resolveRef(childProps.AttachParent, maps) !== root) return undefined
    const local = toVec3(childProps.RelativeLocation) ?? toVec3(childProps.Location)
    if (!local) return [...rootLocation]
    const moved = rotateVector(
        local,
        rootProps.RelativeRotation && typeof rootProps.RelativeRotation === "object" ? rootProps.RelativeRotation : {}
    )
    return moved.map((value, index) => value + rootLocation[index])
}

/** 取节点的世界坐标：探索点用资源创建组件，其余用节点自身或其场景组件 */
export function extractPosition(node: Row, maps: ReturnType<typeof buildObjectMaps>): number[] | undefined {
    const props = node.Properties && typeof node.Properties === "object" ? (node.Properties as Row) : {}
    if (node.Type === "BP_StaticCreatorComponent_C" && node.Name === "FinishMechanism") {
        const location = refLocation(props.AttachParent, maps)
        if (location) return location
    }
    if (node.Type === "Explore_Treasure_C" || node.Type === "Explore_Drop_C") {
        // 探索点 actor 的根组件只是分组锚点，资源落点由 Drop 创建组件给出；组件直连根组件，
        // 根带旋转时局部偏移必须按旋转合成，否则会落到锚点附近（与宝箱坐标重合）
        const drop = rootChildLocation(node, "Drop", maps) ?? accumulatedRefLocation(props.Drop, maps)
        if (drop) return drop
        return objectLocation(node, maps, true)
    }
    return objectLocation(node, maps, false)
}

export function resourcePairs(
    props: Row,
    resourceMap: Map<number, Row>,
    links: ReturnType<typeof buildLinkMaps>,
    unitIds: Map<number, number>,
    creatorTypes?: Map<number, string>
): ResourcePair[] {
    const result: ResourcePair[] = []
    const add = (resourceId: number | undefined, rewardId: number | undefined) => {
        if (resourceId !== undefined && resourceMap.has(resourceId) && !result.some(pair => pair[0] === resourceId && pair[1] === rewardId))
            result.push([resourceId, rewardId])
    }
    add(toInt(props.ResourceId), undefined)
    // Drop.DropId 与 Mechanism.UnitId 数值段重叠（如 90007 既是 GetResource 31005001 的掉落，也是
    // HardBossOpenMechanism 的机关），必须按生成单位声明的 UnitType 分流，否则机关/怪物位置会被误记为资源 source。
    // 生效类型取节点自带 UnitType，缺失时（如模板默认组件）回退到 DesignLevel_data 创角记录；两者都缺失的节点
    // （Explore actor 等）保持原行为。
    const unitId = toInt(props.UnitId)
    const staticCreatorId = toInt(props.StaticCreatorId)
    const assetType = typeof props.UnitType === "string" ? props.UnitType : undefined
    const unitType = assetType ?? (staticCreatorId === undefined ? undefined : creatorTypes?.get(staticCreatorId))
    const allowDrop = unitType === undefined || unitType === "Drop"
    const allowMechanism = unitType === undefined || unitType === "Mechanism"
    const resolvedUnit = unitId ?? (staticCreatorId === undefined ? undefined : unitIds.get(staticCreatorId))
    if (allowDrop) {
        for (const resourceId of links.dropToResource.get(resolvedUnit ?? -1) ?? []) add(resourceId, undefined)
        const rarelyId = toInt(props.RarelyId)
        if ((unitId !== undefined || staticCreatorId !== undefined) && rarelyId !== undefined) {
            for (const dropId of links.rarelyToDrop.get(rarelyId) ?? []) {
                for (const resourceId of links.dropToResource.get(dropId) ?? []) add(resourceId, undefined)
            }
        }
    }
    if (allowMechanism) {
        for (const [resourceId, rewardId] of links.mechanismToResource.get(resolvedUnit ?? -1) ?? []) add(resourceId, rewardId)
    }
    return result
}

function appendSource(
    sources: Map<number, ResourceSourceItem[]>,
    resourceId: number,
    srId: number,
    pos: number[],
    rewardId?: number,
    unitId?: number
): void {
    if (srId === 210101) return
    const list = sources.get(resourceId) ?? []
    let item = list.find(source => source.srId === srId && source.rewardId === rewardId && source.unitId === unitId)
    if (!item) {
        item = { srId, ...(rewardId === undefined ? {} : { rewardId }), ...(unitId === undefined ? {} : { unitId }), pos: [] }
        list.push(item)
        sources.set(resourceId, list)
    }
    const normalized = [roundEven(pos[0]), roundEven(pos[1])]
    if (!item.pos.some(existing => existing[0] === normalized[0] && existing[1] === normalized[1])) item.pos.push(normalized)
}

function collectAssetSources(
    data: unknown[],
    srId: number,
    resourceMap: Map<number, Row>,
    links: ReturnType<typeof buildLinkMaps>,
    unitIds: Map<number, number>,
    sources: Map<number, ResourceSourceItem[]>,
    positions: Map<number, ResourcePosition>,
    creatorTypes?: Map<number, string>
): void {
    const nodes = iterNodes(data)
    const maps = buildObjectMaps(nodes)
    for (const node of nodes) {
        if (node.Type !== "Explore_Drop_C" && node.Type !== "Explore_Treasure_C") continue
        const props = node.Properties && typeof node.Properties === "object" ? (node.Properties as Row) : {}
        const resourceId = toInt(props.ResourceId)
        if (resourceId === undefined) continue
        const current = positions.get(resourceId) ?? {}
        if (!current.pos) {
            const position = extractPosition(node, maps)
            if (position) current.pos = [roundEven(position[0]), roundEven(position[1])]
        }
        if (node.Type === "Explore_Treasure_C" && !current.treasurePos) {
            const position = rootChildLocation(node, "Chest", maps) ?? accumulatedRefLocation(props.Chest, maps)
            if (position) current.treasurePos = [roundEven(position[0]), roundEven(position[1])]
        }
        if (current.pos || current.treasurePos) positions.set(resourceId, current)
    }
    const treasureNames = new Set(
        nodes
            .filter(node => node.Type === "Explore_Treasure_C")
            .map(node => node.Name)
            .filter((name): name is string => typeof name === "string")
    )
    const candidates: Array<{ node: Row; pairs: ResourcePair[]; unit?: number; creator?: number }> = []
    const unitBased = new Set<number>()
    for (const node of nodes) {
        const props = node.Properties && typeof node.Properties === "object" ? (node.Properties as Row) : {}
        if (node.Type === "BP_StaticCreatorComponent_C" && node.Name === "Drop") {
            const outer = node.Outer && typeof node.Outer === "object" ? node.Outer.ObjectName : node.Outer
            const [, short] = refParts(outer)
            if ((short && treasureNames.has(short)) || (typeof outer === "string" && outer.includes("Explore_Treasure_C'"))) continue
            if (short?.startsWith("Explore_Drop") || (typeof outer === "string" && outer.includes("Explore_Drop_C'"))) continue
        }
        const pairs = resourcePairs(props, resourceMap, links, unitIds, creatorTypes)
        if (pairs.length === 0) continue
        const unit = toInt(props.UnitId)
        const creator = toInt(props.StaticCreatorId)
        if (unit !== undefined || creator !== undefined) for (const [resourceId] of pairs) unitBased.add(resourceId)
        candidates.push({ node, pairs, unit, creator })
    }
    for (const candidate of candidates) {
        const onlyPair = candidate.pairs.length === 1 && candidate.pairs[0][1] === undefined
        if (
            candidate.unit === undefined &&
            candidate.creator === undefined &&
            onlyPair &&
            unitBased.has(candidate.pairs[0][0]) &&
            candidate.node.Type !== "Explore_Treasure_C"
        )
            continue
        const position = extractPosition(candidate.node, maps)
        if (!position) continue
        for (const [resourceId, rewardId] of candidate.pairs) {
            appendSource(sources, resourceId, srId, position, rewardId)
        }
    }
}

function collectRandomPoints(data: unknown[], maps: ReturnType<typeof buildObjectMaps>): Map<number, number[][]> {
    const result = new Map<number, number[][]>()
    let rootLocation: number[] | undefined
    for (const node of iterNodes(data)) {
        if (node.Type !== "BP_RandomActorDataManager_C") continue
        const props = node.Properties && typeof node.Properties === "object" ? (node.Properties as Row) : {}
        rootLocation = refLocation(props.DefaultSceneRoot, maps)
        const infos = normalizeList(props.RandomActorInfos)
        for (const info of infos) {
            if (!info || typeof info !== "object") continue
            const ruleId = toInt((info as Row).Key)
            const params = normalizeList(
                (info as Row).Value && typeof (info as Row).Value === "object" ? ((info as Row).Value as Row).Params : undefined
            )
            if (ruleId === undefined) continue
            const points = result.get(ruleId) ?? []
            for (const param of params) {
                if (!param || typeof param !== "object") continue
                let location = toVec3((param as Row).ActorLoc)
                if (!location) continue
                if (rootLocation) location = location.map((value, index) => value + rootLocation![index])
                const point = [roundEven(location[0]), roundEven(location[1]), roundEven(location[2])]
                if (!points.some(existing => existing[0] === point[0] && existing[1] === point[1] && existing[2] === point[2]))
                    points.push(point)
            }
            result.set(ruleId, points)
        }
    }
    return result
}

function sortSources(items: ResourceSourceItem[]): ResourceSourceItem[] {
    return [...items].sort((a, b) => {
        const aReward = a.rewardId === undefined
        const bReward = b.rewardId === undefined
        if (aReward !== bReward) return aReward ? 1 : -1
        return (
            a.srId - b.srId ||
            (a.rewardId ?? 0) - (b.rewardId ?? 0) ||
            (a.pos[0]?.[0] ?? 0) - (b.pos[0]?.[0] ?? 0) ||
            (a.pos[0]?.[1] ?? 0) - (b.pos[0]?.[1] ?? 0)
        )
    })
}

async function buildSources(
    ctx: ModuleContext,
    resourceMap: Map<number, Row>,
    links: ReturnType<typeof buildLinkMaps>,
    unitIds: Map<number, number>,
    creatorTypes: Map<number, string>
): Promise<{
    sources: Map<number, ResourceSourceItem[]>
    placements: Map<number, ResourceSourceItem[]>
    positions: Map<number, ResourcePosition>
}> {
    const sources = new Map<number, ResourceSourceItem[]>()
    const placements = buildBookPlacements(ctx.dm, links)
    const positions = new Map<number, ResourcePosition>()
    const exportsRoot = getExportsRoot()
    const mapsRoot = exportsRoot ? join(exportsRoot, "EM", "Content", "Maps", "Levels") : undefined
    if (!mapsRoot || !existsSync(mapsRoot)) return { sources, placements, positions }
    const subRegions = rows(ctx.dm.getTable("SubRegion"))
    const levels: Array<[string, number]> = []
    const seen = new Set<string>()
    for (const subRegion of subRegions) {
        const level = typeof subRegion.SubRegionLevel === "string" ? subRegion.SubRegionLevel.toLowerCase() : ""
        const srId = toInt(subRegion.SubRegionId)
        if (level && srId !== undefined && !seen.has(level)) {
            seen.add(level)
            levels.push([level, srId])
        }
    }
    const reader = new AssetReader(ctx.dm.root)
    try {
        for (const [level, srId] of levels) {
            for (const assetPath of collectDesignFiles(mapsRoot, level)) {
                const data = await reader.readFModelAsset(assetPath)
                if (!data) continue
                collectAssetSources(data, srId, resourceMap, links, unitIds, sources, positions, creatorTypes)
                const nodes = iterNodes(data)
                const maps = buildObjectMaps(nodes)
                const randomPoints = collectRandomPoints(nodes, maps)
                for (const [ruleId, points] of randomPoints) {
                    for (const [resourceId, rewardId] of links.randomRuleToResource.get(ruleId) ?? []) {
                        for (const point of points) appendSource(sources, resourceId, srId, point, rewardId)
                    }
                }
            }
        }
    } finally {
        await reader.close()
    }
    return { sources, placements, positions }
}

export async function resourceDataModule(ctx: ModuleContext): Promise<ResourceDataArtifact> {
    const resourceTable = ctx.dm.getTable("Resource") as Record<string, unknown> | undefined
    const resourceMap = new Map<number, Row>()
    for (const resource of rows(resourceTable)) {
        const id = toInt(resource.ResourceId)
        if (id !== undefined) resourceMap.set(id, resource)
    }
    const links = buildLinkMaps(ctx.dm, resourceMap)
    const { unitIds, creatorTypes } = buildDesignLevelUnits(ctx.dm)
    const accessTexts = buildAccessTexts(ctx.dm)
    const accessRules = buildAccessRules(ctx.dm)
    // 梦魇残声（HardBoss key）按末段难度奖励实际引用判定展示（用户口径），数据来自 HardBossData artifact。
    const hardboss = ctx.getArtifact<HardBossDataArtifact>("HardBossData")
    const hardbossResources = new Set<number>()
    if (hardboss) {
        const resolveReward = createRewardResolver(
            ctx.dm.getTable("Reward") as Record<string, unknown> | undefined,
            links.dropToResource,
            resourceMap
        )
        for (const rewardId of hardboss.lastRewards()) {
            for (const resourceId of resolveReward(rewardId).all) hardbossResources.add(resourceId)
        }
    }
    const { sources, placements, positions } = await buildSources(ctx, resourceMap, links, unitIds, creatorTypes)
    const result: VNodeTree[] = []
    for (const resource of [...resourceMap.values()].sort((a, b) => Number(a.ResourceId) - Number(b.ResourceId))) {
        const resourceId = toInt(resource.ResourceId)
        if (resourceId === undefined) continue
        const iconPath = String(resource.Icon ?? "")
        const marker = iconPath.lastIndexOf("T_")
        const iconPart = marker >= 0 ? iconPath.slice(marker) : ""
        const item: Record<string, VNodeTree> = {
            id: resourceId,
            name: T(resource.ResourceName),
            icon: iconPart ? iconPart.split(".", 1)[0].replace(/["']+$/, "") : "",
            rarity: resource.Rarity ?? 1,
        }
        if (resource.DetailDes) item.desc = T(resource.DetailDes)
        if (resource.IpDes) item.desc2 = T(resource.IpDes)
        // 游戏内来源文本（AccessKey→AccessText，多语言渲染为字符串数组便于查看）
        // Return 规则项（商店/委托等，须运行时展开）静态不可见，只保留直接展示项；
        // HardBoss 例外：末段难度奖励实际引用则展示梦魇残声。
        const accessKeys = visibleAccessKeys(normalizeAccessKeys(resource.AccessKey), accessRules, key =>
            key === "HardBoss" ? hardbossResources.has(resourceId) : false
        )
        if (accessKeys.length > 0) item.access = accessKeys.map(key => T(accessTexts.get(key) ?? key))
        if (resource.UseEffectType === "RandomSelectPack") {
            const pack = toInt(resource.UseParam)
            if (pack !== undefined) item.pack = pack
        }
        if (typeof resource.UseEffectType === "string" && resource.UseEffectType.startsWith("Select")) {
            const select = toInt(resource.UseParam)
            if (select !== undefined) item.select = select
        }
        const source = sources.get(resourceId)
        if (source && source.length > 0)
            item.source = sortSources(source).map(({ srId, rewardId, pos }) => ({
                srId,
                ...(rewardId === undefined ? {} : { rewardId }),
                pos,
            }))
        result.push(item)
    }
    return { output: result, resourceMap, sources, placements, positions }
}

export function resourceModule(ctx: ModuleContext): VNodeTree {
    const data = ctx.getArtifact<ResourceDataArtifact>("ResourceData")
    if (!data) throw new Error("ResourceData artifact is required")
    return data.output
}
