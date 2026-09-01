import { existsSync } from "node:fs"
import { dirname, join } from "node:path"
import type { ModuleContext } from "../../core/Graph.ts"
import { T, type VNodeTree } from "../../i18n/vnode.ts"
import { AssetReader } from "../../lua/AssetReader.ts"
import { getExportsRoot } from "../../lua/UAssetServer.ts"

type Row = Record<string, any>
type Maps = ReturnType<typeof buildObjectMaps>

function rows(value: unknown): Row[] {
    if (!value || typeof value !== "object") return []
    const values = Array.isArray(value) ? value : Object.values(value)
    return values.filter((item): item is Row => !!item && typeof item === "object" && !Array.isArray(item))
}

function toInt(value: unknown): number | undefined {
    if (typeof value === "number" && Number.isInteger(value)) return value
    if (typeof value !== "string" || !/^-?\d+$/.test(value.trim())) return undefined
    return Number(value)
}

function list(value: unknown): unknown[] {
    if (Array.isArray(value)) return value
    if (!value || typeof value !== "object") return []
    return Object.entries(value as Row)
        .map(([key, item]) => [Number(key), item] as const)
        .filter(([key]) => Number.isInteger(key) && key > 0)
        .sort(([a], [b]) => a - b)
        .map(([, item]) => item)
}

function roundEven(value: number): number {
    const sign = value < 0 ? -1 : 1
    const absolute = Math.abs(value)
    const floor = Math.floor(absolute)
    const fraction = absolute - floor
    if (fraction < 0.5) return sign * floor
    if (fraction > 0.5) return sign * (floor + 1)
    return sign * (floor % 2 === 0 ? floor : floor + 1)
}

function vector3(value: unknown): number[] | undefined {
    if (Array.isArray(value) && value.length >= 2) {
        const result = [Number(value[0]), Number(value[1]), Number(value[2] ?? 0)]
        return result.every(Number.isFinite) ? result : undefined
    }
    if (!value || typeof value !== "object") return undefined
    const row = value as Row
    const result = [Number(row.X), Number(row.Y), Number(row.Z ?? 0)]
    return result.every(Number.isFinite) ? result : undefined
}

function vec2(value: unknown): number[] | undefined {
    const point = vector3(value)
    return point ? [roundEven(point[0]), roundEven(point[1])] : undefined
}

function refParts(value: unknown): [string | undefined, string | undefined] {
    if (typeof value !== "string" || !value) return [undefined, undefined]
    let raw = value.replace(/^'+|'+$/g, "")
    const colon = raw.indexOf(":")
    if (colon >= 0) raw = raw.slice(colon + 1)
    const parts = raw.split(".")
    return parts.length >= 2 ? [parts.at(-2), parts.at(-1)] : [undefined, parts[0]]
}

function buildObjectMaps(nodes: Row[]) {
    const byOuter = new Map<string, Row>()
    const byName = new Map<string, Row[]>()
    const byPath = new Map<string, Row>()
    for (const node of nodes) {
        const name = typeof node.Name === "string" ? node.Name : undefined
        if (name) byName.set(name, [...(byName.get(name) ?? []), node])
        const outerValue = node.Outer && typeof node.Outer === "object" ? node.Outer.ObjectName : node.Outer
        const outer = typeof outerValue === "string" ? outerValue : undefined
        const [, outerShort] = refParts(outer)
        if (outer && name) byOuter.set(`${outer}\0${name}`, node)
        if (outerShort && name) byOuter.set(`${outerShort}\0${name}`, node)
        if (typeof node.ObjectPath === "string") byPath.set(node.ObjectPath, node)
    }
    return { byOuter, byName, byPath }
}

function resolveRef(ref: unknown, maps: Maps): Row | undefined {
    if (!ref || typeof ref !== "object") return undefined
    const row = ref as Row
    if (typeof row.ObjectPath === "string") {
        const found = maps.byPath.get(row.ObjectPath)
        if (found) return found
    }
    const [outer, name] = refParts(row.ObjectName)
    if (!name) return undefined
    if (outer) {
        const found = maps.byOuter.get(`${outer}\0${name}`)
        if (found) return found
    }
    return maps.byName.get(name)?.[0]
}

function refLocation(ref: unknown, maps: Maps): number[] | undefined {
    const node = resolveRef(ref, maps)
    if (!node) return undefined
    const props = node.Properties ?? {}
    return vector3(props.RelativeLocation) ?? vector3(props.Location) ?? vector3(props.RelativeTransform?.Translation)
}

function objectLocation(node: Row, maps: Maps): number[] | undefined {
    const props = node.Properties ?? {}
    const direct = vector3(props.RelativeLocation) ?? vector3(props.Location) ?? vector3(props.RelativeTransform?.Translation)
    if (direct) return direct
    for (const key of ["RootComponent", "DefaultSceneRoot", "Sphere", "SceneComponent", "CollisionComponent"]) {
        const location = refLocation(props[key], maps)
        if (location) return location
    }
    for (const ref of list(props.BlueprintCreatedComponents)) {
        const location = refLocation(ref, maps)
        if (location) return location
    }
    return undefined
}

function anchorFor(nodes: Row[], subRegionId: number): number[] | undefined {
    const actor = nodes.find(node => toInt(node.Properties?.SubRegionId) === subRegionId && typeof node.Name === "string")
    if (!actor) return undefined
    const root = nodes.find(node => {
        if (node.Type !== "SceneComponent" || node.Name !== "DefaultSceneRoot") return false
        const outer = typeof node.Outer === "object" ? node.Outer?.ObjectName : node.Outer
        return refParts(outer)[1] === actor.Name
    })
    return vec2(root?.Properties?.RelativeLocation)
}

function rangeFor(nodes: Row[], subRegionId: number): VNodeTree | undefined {
    const maps = buildObjectMaps(nodes)
    const anchor = anchorFor(nodes, subRegionId)
    for (const node of nodes) {
        if (node.Type !== "BP_LevelVolume_C") continue
        let box = resolveRef(node.Properties?.Box0, maps)
        if (!box) {
            box = maps.byName.get("Box0")?.find(candidate => {
                const outer = typeof candidate.Outer === "object" ? candidate.Outer?.ObjectName : candidate.Outer
                return refParts(outer)[1] === node.Name
            })
        }
        const extent = vec2(box?.Properties?.BoxExtent)
        if (!extent) continue
        const center = vec2(box?.Properties?.RelativeLocation) ?? [0, 0]
        return { center, extent, ...(anchor ? { anchor } : {}) }
    }
    return anchor ? { center: anchor, extent: [0, 0] } : undefined
}

function actorPoints(nodes: Row[]): Map<string, number[][]> {
    const result = new Map<string, number[][]>()
    const seen = new Map<string, Set<string>>()
    const maps = buildObjectMaps(nodes)
    const manager = nodes.find(node => node.Type === "BP_RandomActorDataManager_C")
    const root = refLocation(manager?.Properties?.DefaultSceneRoot, maps)
    for (const node of nodes) {
        for (const info of list(node.Properties?.RandomActorInfos)) {
            if (!info || typeof info !== "object") continue
            const ruleId = String((info as Row).Key)
            if (!ruleId || ruleId === "undefined") continue
            const points = result.get(ruleId) ?? []
            const pointSet = seen.get(ruleId) ?? new Set<string>()
            for (const param of list((info as Row).Value?.Params)) {
                if (!param || typeof param !== "object") continue
                const location = vector3((param as Row).ActorLoc)
                if (!location) continue
                const point = location.map((value, index) => roundEven(value + (root?.[index] ?? 0)))
                const key = point.join(",")
                if (pointSet.has(key)) continue
                pointSet.add(key)
                points.push(point)
            }
            result.set(ruleId, points)
            seen.set(ruleId, pointSet)
        }
    }
    return result
}

function randomRuleIds(data: Row, points: Map<string, number[][]>): Array<string | number> {
    const result: Array<string | number> = []
    const seen = new Set<string>()
    const add = (value: unknown) => {
        if (value === undefined || value === null || value === "") return
        const key = String(value)
        if (seen.has(key)) return
        seen.add(key)
        result.push(toInt(value) ?? key)
    }
    const rules = data.RandomRule
    if (rules && typeof rules === "object") {
        for (const [key, value] of Object.entries(rules as Row))
            add(value && typeof value === "object" ? ((value as Row).RandomRuleId ?? key) : key)
    }
    for (const key of points.keys()) add(key)
    return result
}

function mapPointIcon(value: unknown): string {
    if (typeof value !== "string") return ""
    const index = value.lastIndexOf("T_Gp_")
    if (index < 0) return ""
    return value.slice(index).split(".", 1)[0].replace(/'+$/, "")
}

export class SubRegionDataReader {
    private readonly reader: AssetReader
    private readonly exportsRoot: string
    private readonly regionMap: Row
    private readonly regionPoints: Row[]
    private readonly teleportPoints: Row[]
    private readonly randomCreators: Row
    private readonly hardBossNames = new Map<number, string>()
    private readonly assetCache = new Map<string, Row[]>()
    private readonly teleportIndex = new Map<number, Row[]>()

    constructor(private readonly ctx: ModuleContext) {
        const exportsRoot = getExportsRoot()
        if (!exportsRoot) throw new Error("SubRegion export requires DNA_UNPACK_DIR with an FModel Exports directory")
        this.exportsRoot = exportsRoot
        this.reader = new AssetReader(ctx.dm.root)
        this.regionMap = (ctx.dm.getTable("Region") as Row) ?? {}
        this.regionPoints = rows(ctx.dm.getTable("RegionPoint"))
        this.teleportPoints = rows(ctx.dm.getTable("TeleportPoint"))
        this.randomCreators = (ctx.dm.getTable("RandomCreator") as Row) ?? {}
        for (const boss of rows(ctx.dm.getTable("HardBossMain"))) {
            const teleportId = toInt(boss.TeleportId)
            if (teleportId !== undefined && typeof boss.HardBossName === "string") this.hardBossNames.set(teleportId, boss.HardBossName)
        }
        this.buildTeleportIndex()
    }

    async close(): Promise<void> {
        await this.reader.close()
    }

    private buildTeleportIndex(): void {
        for (const point of this.regionPoints) {
            if (toInt(point.TelepointId) === undefined) continue
            const subRegionId = toInt(point.SubRegion) ?? toInt(point.TeleportSubRegion)
            if (subRegionId !== undefined) this.teleportIndex.set(subRegionId, [...(this.teleportIndex.get(subRegionId) ?? []), point])
        }
        for (const point of this.teleportPoints) {
            const subRegionId = toInt(point.TeleportPointSubRegion)
            if (subRegionId !== undefined) this.teleportIndex.set(subRegionId, [...(this.teleportIndex.get(subRegionId) ?? []), point])
        }
    }

    private designAssetPath(level: string, regionId: number): string | undefined {
        const mapFile = this.regionMap[String(regionId)]?.RegionMapFile
        if (typeof mapFile !== "string" || !mapFile.startsWith("/Game/")) return undefined
        const packagePath = mapFile.slice(6).split(".", 1)[0]
        const base = join(this.exportsRoot, "EM", "Content", dirname(packagePath), "Design_Data", `${level}_Design`)
        if (existsSync(`${base}.umap`)) return `${base}.umap`
        if (existsSync(`${base}.uasset`)) return `${base}.uasset`
        return undefined
    }

    private async asset(level: string, regionId: number): Promise<Row[]> {
        const path = this.designAssetPath(level, regionId)
        if (!path) return []
        const cached = this.assetCache.get(path)
        if (cached) return cached
        const data = await this.reader.readFModelAsset(path)
        if (!data) throw new Error(`UAssetCLI could not read sub-region asset: ${path}`)
        const nodes = data.filter((item): item is Row => !!item && typeof item === "object" && !Array.isArray(item))
        this.assetCache.set(path, nodes)
        return nodes
    }

    private derivedPosition(nodes: Row[], subRegionId: number): number[] | undefined {
        const maps = buildObjectMaps(nodes)
        for (const node of nodes) {
            if (toInt(node.Properties?.SubRegionId) !== subRegionId && toInt(node.Properties?.Id) !== subRegionId) continue
            const location = objectLocation(node, maps)
            if (location) return vec2(location)
        }
        const anchor = anchorFor(nodes, subRegionId)
        if (anchor) return anchor

        const points: number[][] = []
        for (const point of this.regionPoints)
            if (toInt(point.SubRegion) === subRegionId) {
                const position = vec2(point.Pos)
                if (position) points.push(position)
            }
        for (const point of this.teleportPoints)
            if (toInt(point.TeleportPointSubRegion) === subRegionId) {
                const position = vec2(point.MechanismPos) ?? vec2(point.Pos)
                if (position) points.push(position)
            }
        if (points.length === 0) {
            for (const node of nodes) {
                if (node.Type !== "BP_NewTargetPoint_C" || typeof node.Name !== "string" || !node.Name.startsWith("TargetPoint_")) continue
                const position = vec2(refLocation(node.Properties?.RootComponent, maps))
                if (position) points.push(position)
            }
        }
        if (points.length === 0) return undefined
        return [
            roundEven(points.reduce((sum, point) => sum + point[0], 0) / points.length),
            roundEven(points.reduce((sum, point) => sum + point[1], 0) / points.length),
        ]
    }

    private randomCreatorsFor(level: string, nodes: Row[]): VNodeTree[] {
        const points = actorPoints(nodes)
        const design = (this.ctx.dm.getTable(`DesignLevel_data/${level}`) as Row) ?? {}
        const result: VNodeTree[] = []
        for (const ruleId of randomRuleIds(design, points)) {
            const creator = this.randomCreators[String(ruleId)]
            if (creator?.UnitType !== "Pet") continue
            const item: Record<string, VNodeTree> = {
                id: toInt(ruleId) ?? String(ruleId),
                info: list(creator.RandomInfos)
                    .filter((info): info is Row => !!info && typeof info === "object")
                    .filter(info => info.UnitId !== undefined)
                    .map(info => ({ id: info.UnitId, w: info.Weight ?? 0 })),
            }
            if (Number.isInteger(creator.Count)) item.count = creator.Count
            const positions = points.get(String(ruleId))
            if (positions?.length) item.pos = positions.map(point => point.slice(0, 2))
            result.push(item)
        }
        return result
    }

    private teleportsFor(subRegionId: number): VNodeTree[] {
        const result: Array<Record<string, VNodeTree> & { __sort: [number, number]; __key: string }> = []
        const seen = new Set<string>()
        for (const point of this.teleportIndex.get(subRegionId) ?? []) {
            const id = toInt(point.Id)
            const pos = vec2(point.Pos) ?? vec2(point.MechanismPos)
            if (id === undefined || !pos) continue
            let icon = mapPointIcon(point.Icon) || mapPointIcon(point.TeleportPointIcon)
            if (!icon) icon = point.Temples !== undefined || point.Parties !== undefined ? "T_Gp_Trans03" : "T_Gp_Trans02"
            const nameKey = point.Name || point.TeleportPointName || (icon === "T_Gp_Boss" ? this.hardBossNames.get(id) : "") || ""
            const sort = toInt(point.TeleportPointPos) ?? toInt(point.teleportPointPos) ?? 0
            const key = `${sort}\0${nameKey}\0${pos[0]}\0${pos[1]}`
            if (seen.has(key)) continue
            seen.add(key)
            result.push({ id, pos, name: T(nameKey), icon, __sort: [sort, id], __key: key })
        }
        result.sort((a, b) => a.__sort[0] - b.__sort[0] || a.__sort[1] - b.__sort[1])
        return result.map(({ __sort: _sort, __key: _key, ...item }) => item)
    }

    async build(item: Row): Promise<Record<string, VNodeTree>> {
        const subRegionId = toInt(item.SubRegionId)!
        const regionId = toInt(item.RegionId)!
        const level = String(item.SubRegionLevel)
        const nodes = await this.asset(level, regionId)
        const position = vec2(item.SubRegionCenter) ?? this.derivedPosition(nodes, subRegionId)
        const range = rangeFor(nodes, subRegionId)
        const rc = this.randomCreatorsFor(level, nodes)
        const tp = this.teleportsFor(subRegionId)
        return {
            id: subRegionId,
            rid: regionId,
            name: T(item.SubRegionName),
            desc: T(item.SubRegionDes),
            map: level,
            ...(position ? { pos: position } : {}),
            ...(range ? { range } : {}),
            ...(rc.length ? { rc } : {}),
            ...(tp.length ? { tp } : {}),
        }
    }
}
