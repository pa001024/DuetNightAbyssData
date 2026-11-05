import { mkdirSync, statSync } from "node:fs"
import { dirname, join, resolve } from "node:path"
import { type DuckDBConnection, DuckDBInstance } from "@duckdb/node-api"

const PROJECT_ROOT = join(import.meta.dir, "..", "..")
const DEFAULT_CACHE_PATH = join(PROJECT_ROOT, ".cache", "uasset.duckdb")

/** 源文件指纹：任一字段变化都视为缓存失效。 */
export interface UAssetFingerprint {
    parserVersion: number
    mtimeMs: number
    size: number
}

/**
 * 读取资产指纹。mtime/size 来自 stat，parserVersion 由调用方（解析器版本）给出；
 * 未命中或资产被修改时由调用方重新解析并写回缓存。
 */
export function statFingerprint(filePath: string, parserVersion: number): UAssetFingerprint {
    const stat = statSync(filePath)
    return { parserVersion, mtimeMs: stat.mtimeMs, size: stat.size }
}

/** 缓存路径：DNA_UASSET_CACHE 覆盖（相对路径按 cwd 解析），否则仓库 .cache/uasset.duckdb。 */
export function resolveUAssetCachePath(): string {
    const override = process.env.DNA_UASSET_CACHE?.trim()
    return override ? resolve(override) : DEFAULT_CACHE_PATH
}

/**
 * 持久化 UAssetCLI 响应；只保存成功解析的资产。
 *
 * 两类缓存相互独立：
 * - `uasset_fmodel_cache`：旧表，key 为调用方给的路径键，不校验指纹（保持历史命中语义）。
 * - `uasset_kind_cache`：按 kind 区分的泛型表，key 与行内同时记录 parserVersion/mtime/size，
 *   指纹不匹配即未命中；payload 可为任意 JSON（对象或数组）。
 */
export class UAssetCache {
    private instance: DuckDBInstance | null = null
    private connection: DuckDBConnection | null = null
    private ready: Promise<DuckDBConnection> | null = null

    constructor(private readonly path = resolveUAssetCachePath()) {}

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
                await connection.run(
                    "create table if not exists uasset_kind_cache (" +
                        "cache_key varchar not null, kind varchar not null, primary key (cache_key, kind), parser_version integer not null, " +
                        "source_mtime_ms double not null, source_size bigint not null, payload varchar not null, " +
                        "updated_at timestamp default current_timestamp)"
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

    /**
     * 按 kind 读取。cache_key 已含指纹，行内指纹再校验一次：
     * 列值与本次指纹不一致即视为未命中（避免手工/旧键误命中）。
     */
    async getKinded(kind: string, cacheKey: string, fingerprint: UAssetFingerprint): Promise<unknown | undefined> {
        const connection = await this.connect()
        const result = await connection.runAndReadAll(
            "select payload, parser_version, source_mtime_ms, source_size from uasset_kind_cache where cache_key = $1 and kind = $2",
            [cacheKey, kind]
        )
        const rows = result.getRows()
        if (rows.length === 0) return undefined
        const row = rows[0]!
        const parserVersion = Number(row[1])
        const mtimeMs = Number(row[2])
        const size = Number(row[3])
        if (parserVersion !== fingerprint.parserVersion || mtimeMs !== fingerprint.mtimeMs || size !== fingerprint.size) {
            return undefined
        }
        return JSON.parse(String(row[0]))
    }

    async setKinded(kind: string, cacheKey: string, fingerprint: UAssetFingerprint, payload: unknown): Promise<void> {
        const connection = await this.connect()
        await connection.run(
            "insert or replace into uasset_kind_cache " +
                "(cache_key, kind, parser_version, source_mtime_ms, source_size, payload, updated_at) " +
                "values ($1, $2, $3::integer, $4::double, $5::bigint, $6, current_timestamp)",
            [cacheKey, kind, fingerprint.parserVersion, fingerprint.mtimeMs, fingerprint.size, JSON.stringify(payload)]
        )
    }

    async getOrLoadKinded(
        kind: string,
        cacheKey: string,
        fingerprint: UAssetFingerprint,
        load: () => Promise<unknown | null>
    ): Promise<unknown | null> {
        const cached = await this.getKinded(kind, cacheKey, fingerprint)
        if (cached !== undefined) return cached
        const data = await load()
        if (data !== null) await this.setKinded(kind, cacheKey, fingerprint, data)
        return data
    }

    /** 清空全部缓存 kind（warmup 语义）。 */
    async clear(): Promise<void> {
        const connection = await this.connect()
        await connection.run("delete from uasset_fmodel_cache")
        await connection.run("delete from uasset_kind_cache")
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
