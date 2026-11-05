import { mkdirSync, readFileSync, statSync } from "node:fs"
import { dirname, extname, join, resolve } from "node:path"
import { type DuckDBConnection, DuckDBInstance } from "@duckdb/node-api"

const PROJECT_ROOT = join(import.meta.dir, "..", "..")
const DEFAULT_CACHE_PATH = join(PROJECT_ROOT, ".cache", "uasset.duckdb")

/** 资产包及其 sidecar：`.uasset` 只存头/导入表，ScriptBytecode 与属性值在 `.uexp`，大块数据在 `.ubulk`。 */
const SIDECAR_SUFFIXES = ["uexp", "ubulk"] as const

/**
 * 读 .env（不覆盖已存在的环境变量）。
 * `envPath` 仅供测试注入；生产路径固定为仓库根 `.env`。
 */
export function loadDotenv(envPath = join(PROJECT_ROOT, ".env")): void {
    try {
        const text = readFileSync(envPath, "utf8")
        for (const line of text.split(/\r?\n/)) {
            const l = line.trim()
            if (!l || l.startsWith("#") || !l.includes("=")) continue
            const [k, ...rest] = l.split("=")
            const key = k.trim()
            const value = rest
                .join("=")
                .trim()
                .replace(/^["']|["']$/g, "")
            if (key && !process.env[key]) process.env[key] = value
        }
    } catch {
        /* 无 .env 时忽略 */
    }
}

export interface UAssetFingerprintFile {
    /** 文件后缀（不含点），如 `uasset` / `uexp` / `ubulk`。 */
    suffix: string
    mtimeMs: number
    size: number
}

/** 源文件指纹：主资产 + sidecar 的任一 mtime/size 变化都视为缓存失效。 */
export interface UAssetFingerprint {
    parserVersion: number
    files: UAssetFingerprintFile[]
}

/**
 * 读取资产指纹。除传入的 `.uasset` 外，还纳入同目录同名 `.uexp` / `.ubulk`：
 * ScriptBytecode 在 `.uexp` 中，只 stat 主文件会让 sidecar 变更永久命中旧缓存。
 * 主文件不存在抛错；sidecar 不存在视为缺省（新增/删除 sidecar 同样改变指纹）。
 */
export function statFingerprint(filePath: string, parserVersion: number): UAssetFingerprint {
    const suffix = extname(filePath).replace(/^\./, "").toLowerCase() || "uasset"
    const base = suffix ? filePath.slice(0, filePath.length - suffix.length - 1) : filePath
    const files: UAssetFingerprintFile[] = []
    for (const current of [suffix, ...SIDECAR_SUFFIXES]) {
        try {
            const stat = statSync(`${base}.${current}`)
            if (stat.isFile()) files.push({ suffix: current, mtimeMs: stat.mtimeMs, size: stat.size })
        } catch (error) {
            if (current === suffix) throw error
            if ((error as NodeJS.ErrnoException).code !== "ENOENT") throw error
        }
    }
    return { parserVersion, files }
}

/** 指纹的规范字符串（文件顺序固定），用于缓存 key 与行内校验。 */
export function fingerprintKey(fingerprint: UAssetFingerprint): string {
    return JSON.stringify([fingerprint.parserVersion, fingerprint.files.map(file => [file.suffix, file.mtimeMs, file.size])])
}

/**
 * 缓存路径：DNA_UASSET_CACHE 覆盖（相对路径按 cwd 解析），否则仓库 .cache/uasset.duckdb。
 * 读取前先加载 .env：`bun warmup` 在模块构建前就会解析缓存路径。
 */
export function resolveUAssetCachePath(): string {
    loadDotenv()
    const override = process.env.DNA_UASSET_CACHE?.trim()
    return override ? resolve(override) : DEFAULT_CACHE_PATH
}

/**
 * 持久化 UAssetCLI 响应；只保存成功解析的资产。
 *
 * 两类缓存相互独立：
 * - `uasset_fmodel_cache`：旧表，key 为调用方给的路径键，不校验指纹（保持历史命中语义）。
 * - `uasset_kind_cache`：按 kind 区分的泛型表，key 与行内同时记录完整指纹
 *   （parserVersion + 主资产/sidecar 的 mtime/size），指纹不匹配即未命中；
 *   payload 可为任意 JSON（对象或数组）。
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
                        "source_mtime_ms double not null, source_size bigint not null, source_fingerprint varchar not null, " +
                        "payload varchar not null, updated_at timestamp default current_timestamp)"
                )
                // 兼容上一次实现创建的旧表：补列后旧行为 NULL，读取时按未命中处理
                await connection.run("alter table uasset_kind_cache add column if not exists source_fingerprint varchar")
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
     * 按 kind 读取。cache_key 已含指纹，行内再校验完整指纹字符串
     * （parserVersion + `.uasset`/`.uexp`/`.ubulk` 的 mtime/size）：
     * 不一致或旧行（NULL）一律视为未命中。
     */
    async getKinded(kind: string, cacheKey: string, fingerprint: UAssetFingerprint): Promise<unknown | undefined> {
        const connection = await this.connect()
        const result = await connection.runAndReadAll(
            "select payload, source_fingerprint from uasset_kind_cache where cache_key = $1 and kind = $2",
            [cacheKey, kind]
        )
        const rows = result.getRows()
        if (rows.length === 0) return undefined
        const row = rows[0]!
        if (String(row[1]) !== fingerprintKey(fingerprint)) return undefined
        return JSON.parse(String(row[0]))
    }

    async setKinded(kind: string, cacheKey: string, fingerprint: UAssetFingerprint, payload: unknown): Promise<void> {
        const connection = await this.connect()
        // source_mtime_ms/source_size 仅作诊断汇总：取各文件最大 mtime、size 之和；
        // 命中判定以 source_fingerprint 为准。
        const mtimeMs = fingerprint.files.length > 0 ? Math.max(...fingerprint.files.map(file => file.mtimeMs)) : 0
        const size = fingerprint.files.reduce((sum, file) => sum + file.size, 0)
        await connection.run(
            "insert or replace into uasset_kind_cache " +
                "(cache_key, kind, parser_version, source_mtime_ms, source_size, source_fingerprint, payload, updated_at) " +
                "values ($1, $2, $3::integer, $4::double, $5::bigint, $6, $7, current_timestamp)",
            [cacheKey, kind, fingerprint.parserVersion, mtimeMs, size, fingerprintKey(fingerprint), JSON.stringify(payload)]
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
