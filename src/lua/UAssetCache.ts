import { mkdirSync } from "node:fs"
import { dirname, join } from "node:path"
import { type DuckDBConnection, DuckDBInstance } from "@duckdb/node-api"

const PROJECT_ROOT = join(import.meta.dir, "..", "..")
const DEFAULT_CACHE_PATH = join(PROJECT_ROOT, ".cache", "uasset.duckdb")

/** 持久化 UAssetCLI fmodel 响应；只保存成功解析的资产。 */
export class UAssetCache {
    private instance: DuckDBInstance | null = null
    private connection: DuckDBConnection | null = null
    private ready: Promise<DuckDBConnection> | null = null

    constructor(private readonly path = DEFAULT_CACHE_PATH) {}

    private async connect(): Promise<DuckDBConnection> {
        if (this.connection) return this.connection
        if (!this.ready) {
            this.ready = (async () => {
                mkdirSync(dirname(this.path), { recursive: true })
                this.instance = await DuckDBInstance.create(this.path)
                const connection = await this.instance.connect()
                await connection.run(
                    "create table if not exists uasset_fmodel_cache (cache_key varchar primary key, payload varchar not null, updated_at timestamp default current_timestamp)"
                )
                this.connection = connection
                return connection
            })()
        }
        return this.ready
    }

    async get(cacheKey: string): Promise<unknown[] | undefined> {
        const connection = await this.connect()
        const result = await connection.runAndReadAll("select payload from uasset_fmodel_cache where cache_key = $1", [cacheKey])
        const rows = result.getRows()
        if (rows.length === 0) return undefined
        const payload = rows[0]?.[0]
        const parsed: unknown = JSON.parse(String(payload))
        if (!Array.isArray(parsed)) throw new Error(`UAsset cache payload is not an array: ${cacheKey}`)
        return parsed
    }

    async set(cacheKey: string, data: unknown[]): Promise<void> {
        const connection = await this.connect()
        await connection.run(
            "insert or replace into uasset_fmodel_cache (cache_key, payload, updated_at) values ($1, $2, current_timestamp)",
            [cacheKey, JSON.stringify(data)]
        )
    }

    async getOrLoad(cacheKey: string, load: () => Promise<unknown[] | null>): Promise<unknown[] | null> {
        const cached = await this.get(cacheKey)
        if (cached !== undefined) return cached
        const data = await load()
        if (data !== null) await this.set(cacheKey, data)
        return data
    }

    async clear(): Promise<void> {
        const connection = await this.connect()
        await connection.run("delete from uasset_fmodel_cache")
    }

    async close(): Promise<void> {
        if (this.connection) this.connection.closeSync()
        if (this.instance) this.instance.closeSync()
        this.connection = null
        this.instance = null
        this.ready = null
    }
}

let sharedCache: UAssetCache | null = null

export function getUAssetCache(): UAssetCache {
    if (!sharedCache) sharedCache = new UAssetCache()
    return sharedCache
}

export async function clearUAssetCache(): Promise<void> {
    await getUAssetCache().clear()
}

export async function closeUAssetCache(): Promise<void> {
    if (sharedCache) {
        await sharedCache.close()
        sharedCache = null
    }
}
