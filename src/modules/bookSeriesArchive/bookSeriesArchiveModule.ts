import type { ModuleContext } from "../../core/Graph.ts"
import { T, TUnlessEqual, type VNodeTree } from "../../i18n/vnode.ts"
import type { ResourceDataArtifact, ResourceSourceItem } from "../resource/resourceModule.ts"
import { iconName, rows, table } from "../shared/dataHelpers.ts"

type Row = Record<string, any>

function toInt(value: unknown): number | undefined {
    if (typeof value === "number" && Number.isInteger(value)) return value
    if (typeof value !== "string" || !/^-?\d+$/.test(value.trim())) return undefined
    return Number(value)
}

function numberList(value: unknown): number[] {
    const values = Array.isArray(value) ? value : value && typeof value === "object" ? Object.values(value) : []
    return values.map(toInt).filter((item): item is number => item !== undefined)
}

function independentMapPositions(ctx: ModuleContext): Map<number, number[]> {
    const independentSubRegions = new Set(
        rows(ctx, "SubRegion")
            .filter(item => item.NotShowInRegionMap)
            .map(item => toInt(item.SubRegionId))
            .filter((id): id is number => id !== undefined)
    )
    const teleportPoints = new Map<number, Row>()
    for (const point of rows(ctx, "TeleportPoint")) {
        const id = toInt(point.Id)
        if (id !== undefined) teleportPoints.set(id, point)
    }

    const result = new Map<number, number[]>()
    for (const point of rows(ctx, "RegionPoint")) {
        const teleportPoint = teleportPoints.get(toInt(point.TelepointId) ?? -1)
        if (!teleportPoint || !Array.isArray(teleportPoint.MechanismPos) || teleportPoint.MechanismPos.length < 2) continue
        const pos = teleportPoint.MechanismPos.slice(0, 2).map(Number)
        if (!pos.every(Number.isFinite)) continue
        for (const subRegionId of numberList(point.TargetSubRegion)) {
            if (independentSubRegions.has(subRegionId)) result.set(subRegionId, pos)
        }
    }
    return result
}

function resourceEntry(
    resourceId: number,
    resource: Row,
    series: Row,
    placement: ResourceSourceItem | undefined,
    mechanismTypes: Map<number, string>,
    positions: ResourceDataArtifact["positions"],
    independentPositions: Map<number, number[]>
): Record<string, VNodeTree> {
    const item: Record<string, VNodeTree> = {
        id: resourceId,
        type:
            placement?.unitId === undefined
                ? placement
                    ? "Drop"
                    : resource.ResourceSType || resource.Type
                : mechanismTypes.get(placement.unitId)!,
    }
    if (resource.ResourceName) item.name = TUnlessEqual(resource.ResourceName, series.BookSeriesName)
    if (resource.DetailDes) item.desc = TUnlessEqual(resource.DetailDes, series.DetailDes)
    if (resource.IpDes) item.text = T(resource.IpDes)
    if (placement) {
        if (placement.unitId !== undefined) item.mId = placement.unitId
        item.srId = placement.srId
        const position = positions.get(resourceId)
        const pos = independentPositions.get(placement.srId) ?? position?.pos
        if (pos) item.pos = pos
        if (position?.treasurePos) item.treasurePos = position.treasurePos
    }
    return item
}

export function bookSeriesArchiveModule(ctx: ModuleContext): VNodeTree {
    const data = ctx.getArtifact<ResourceDataArtifact>("ResourceData")
    if (!data) throw new Error("ResourceData artifact is required")

    const seriesResources = table(ctx, "BookSeriesId2ResourceId")
    const mechanismTypes = new Map<number, string>()
    for (const mechanism of rows(ctx, "Mechanism")) {
        const unitId = toInt(mechanism.UnitId)
        if (unitId !== undefined && typeof mechanism.UnitRealType === "string") mechanismTypes.set(unitId, mechanism.UnitRealType)
    }
    const independentPositions = independentMapPositions(ctx)

    return rows(ctx, "BookSeriesArchive")
        .map(series => {
            const seriesId = toInt(series.BookSeriesId)
            if (seriesId === undefined) throw new Error("BookSeriesArchive row is missing BookSeriesId")
            const resourceIds = numberList(seriesResources[String(seriesId)])
            const res = resourceIds.flatMap(resourceId => {
                const resource = data.resourceMap.get(resourceId)
                if (!resource) throw new Error(`BookSeriesArchive references unknown resource ${resourceId}`)
                const placements = data.placements.get(resourceId)
                if (!placements?.length)
                    return [resourceEntry(resourceId, resource, series, undefined, mechanismTypes, data.positions, independentPositions)]
                return placements.map(placement => {
                    if (placement.unitId !== undefined && !mechanismTypes.has(placement.unitId))
                        throw new Error(`BookSeriesArchive references unknown mechanism ${placement.unitId}`)
                    return resourceEntry(resourceId, resource, series, placement, mechanismTypes, data.positions, independentPositions)
                })
            })
            res.sort(
                (a, b) =>
                    Number(a.id) - Number(b.id) ||
                    String(a.type).localeCompare(String(b.type)) ||
                    Number(a.mId ?? 0) - Number(b.mId ?? 0) ||
                    Number(a.srId ?? 0) - Number(b.srId ?? 0)
            )
            const firstResource = resourceIds.length > 0 ? data.resourceMap.get(resourceIds[0]) : undefined
            return {
                id: seriesId,
                name: T(series.BookSeriesName),
                desc: T(series.DetailDes),
                ...(firstResource?.Icon ? { icon: iconName(firstResource.Icon) } : {}),
                res,
            }
        })
        .sort((a, b) => a.id - b.id)
}
