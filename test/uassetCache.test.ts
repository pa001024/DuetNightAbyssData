import { afterEach, describe, expect, test } from "bun:test"
import { existsSync, mkdtempSync, rmSync, utimesSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join, resolve } from "node:path"
import {
    clearUAssetCache,
    closeUAssetCache,
    fingerprintKey,
    getUAssetCache,
    loadDotenv,
    resolveUAssetCachePath,
    statFingerprint,
    type UAssetFingerprint,
    type UAssetFingerprintFile,
    UAssetCache,
} from "../src/lua/UAssetCache.ts"
import { UAssetServer, packagePathFor } from "../src/lua/UAssetServer.ts"

let tempDir: string | undefined

afterEach(() => {
    if (tempDir) rmSync(tempDir, { recursive: true, force: true })
    tempDir = undefined
})

function createCache(): UAssetCache {
    tempDir = mkdtempSync(join(tmpdir(), "uasset-cache-"))
    return new UAssetCache(join(tempDir, "cache.duckdb"))
}

describe("UAssetCache", () => {
    test("未命中时加载并持久化，后续请求直接命中 DuckDB", async () => {
        const cache = createCache()
        let loadCount = 0
        const load = async () => {
            loadCount++
            return [{ Type: "World", Properties: { ResourceId: 1 } }]
        }

        expect(await cache.getOrLoad("asset-key", load)).toEqual([{ Type: "World", Properties: { ResourceId: 1 } }])
        expect(await cache.getOrLoad("asset-key", load)).toEqual([{ Type: "World", Properties: { ResourceId: 1 } }])
        expect(loadCount).toBe(1)
        await cache.close()

        const reopened = new UAssetCache(join(tempDir!, "cache.duckdb"))
        expect(await reopened.getOrLoad("asset-key", load)).toEqual([{ Type: "World", Properties: { ResourceId: 1 } }])
        expect(loadCount).toBe(1)
        await reopened.close()
    })

    test("clear 使下一次请求重新加载", async () => {
        const cache = createCache()
        let loadCount = 0
        const load = async () => [{ version: ++loadCount }]

        expect(await cache.getOrLoad("asset-key", load)).toEqual([{ version: 1 }])
        await cache.clear()
        expect(await cache.getOrLoad("asset-key", load)).toEqual([{ version: 2 }])
        await cache.close()
    })

    test("解析失败不会写入缓存", async () => {
        const cache = createCache()
        let loadCount = 0
        const load = async () => {
            loadCount++
            return null
        }

        expect(await cache.getOrLoad("asset-key", load)).toBeNull()
        expect(await cache.getOrLoad("asset-key", load)).toBeNull()
        expect(loadCount).toBe(2)
        await cache.close()
    })

    test("缓存命中时不启动 UAssetCLI server", async () => {
        const cache = createCache()
        const assetPath = "D:/assets/Test.uasset"
        const exportsRoot = "D:/assets"
        const packagePath = packagePathFor(assetPath, exportsRoot)
        const key = JSON.stringify([assetPath, packagePath, "EM/Content"])
        const data = [{ Type: "AnimMontage", Properties: {} }]
        await cache.set(key, data)

        const server = new UAssetServer("D:/does-not-exist/UAssetCLI.exe", "EM/Content", cache)
        expect(await server.fmodel(assetPath, exportsRoot)).toEqual(data)
        await cache.close()
    })
})

describe("UAssetCache kinded", () => {
    const fingerprint = (overrides: Partial<UAssetFingerprint> = {}): UAssetFingerprint => ({
        parserVersion: 1,
        files: [{ suffix: "uasset", mtimeMs: 1000, size: 64 }],
        ...overrides,
    })
    const withFile = (fileOverrides: Partial<UAssetFingerprintFile>, overrides: Partial<UAssetFingerprint> = {}): UAssetFingerprint =>
        fingerprint({ ...overrides, files: [{ suffix: "uasset", mtimeMs: 1000, size: 64, ...fileOverrides }] })

    test("同 kind/key/指纹命中，对象 payload 原样返回并跨实例持久化", async () => {
        const cache = createCache()
        let loadCount = 0
        const load = async () => ({ schemaVersion: 1, functions: [], load: ++loadCount })

        expect(await cache.getOrLoadKinded("bytecode", "asset-key", fingerprint(), load)).toEqual({
            schemaVersion: 1,
            functions: [],
            load: 1,
        })
        expect(await cache.getOrLoadKinded("bytecode", "asset-key", fingerprint(), load)).toEqual({
            schemaVersion: 1,
            functions: [],
            load: 1,
        })
        expect(loadCount).toBe(1)
        await cache.close()

        const reopened = new UAssetCache(join(tempDir!, "cache.duckdb"))
        expect(await reopened.getOrLoadKinded("bytecode", "asset-key", fingerprint(), load)).toEqual({
            schemaVersion: 1,
            functions: [],
            load: 1,
        })
        expect(loadCount).toBe(1)
        await reopened.close()
    })

    test("parserVersion、mtimeMs、size 任一变化都视为未命中", async () => {
        const cache = createCache()
        let loadCount = 0
        const load = async () => ({ load: ++loadCount })

        expect(await cache.getOrLoadKinded("bytecode", "asset-key", fingerprint(), load)).toEqual({ load: 1 })
        expect(await cache.getOrLoadKinded("bytecode", "asset-key", fingerprint({ parserVersion: 2 }), load)).toEqual({ load: 2 })
        expect(await cache.getOrLoadKinded("bytecode", "asset-key", withFile({ mtimeMs: 1001 }), load)).toEqual({ load: 3 })
        expect(await cache.getOrLoadKinded("bytecode", "asset-key", withFile({ size: 65 }), load)).toEqual({ load: 4 })
        expect(loadCount).toBe(4)
        await cache.close()
    })

    test("sidecar（.uexp/.ubulk）变化或缺失同样导致未命中", async () => {
        const cache = createCache()
        const base = fingerprint()
        const withUexp = fingerprint({
            files: [
                { suffix: "uasset", mtimeMs: 1000, size: 64 },
                { suffix: "uexp", mtimeMs: 2000, size: 512 },
            ],
        })
        const changedUexp = fingerprint({
            files: [
                { suffix: "uasset", mtimeMs: 1000, size: 64 },
                { suffix: "uexp", mtimeMs: 2001, size: 512 },
            ],
        })
        const withUbulk = fingerprint({
            files: [
                { suffix: "uasset", mtimeMs: 1000, size: 64 },
                { suffix: "uexp", mtimeMs: 2000, size: 512 },
                { suffix: "ubulk", mtimeMs: 3000, size: 4096 },
            ],
        })
        await cache.setKinded("bytecode", "asset-key", withUexp, { version: 1 })
        expect(await cache.getKinded("bytecode", "asset-key", withUexp)).toEqual({ version: 1 })
        expect(await cache.getKinded("bytecode", "asset-key", base)).toBeUndefined()
        expect(await cache.getKinded("bytecode", "asset-key", changedUexp)).toBeUndefined()
        expect(await cache.getKinded("bytecode", "asset-key", withUbulk)).toBeUndefined()
        await cache.close()
    })

    test("payload 可以是数组", async () => {
        const cache = createCache()
        await cache.setKinded("other", "array-key", fingerprint(), [{ Type: "AnimMontage" }])
        expect(await cache.getKinded("other", "array-key", fingerprint())).toEqual([{ Type: "AnimMontage" }])
        expect(await cache.getKinded("other", "array-key", withFile({ size: 1 }))).toBeUndefined()
        await cache.close()
    })

    test("不同 kind 的同一 key 不串用", async () => {
        const cache = createCache()
        await cache.setKinded("bytecode", "shared-key", fingerprint(), { kind: "bytecode" })
        await cache.setKinded("other", "shared-key", fingerprint(), { kind: "other" })
        expect(await cache.getKinded("bytecode", "shared-key", fingerprint())).toEqual({ kind: "bytecode" })
        expect(await cache.getKinded("other", "shared-key", fingerprint())).toEqual({ kind: "other" })
        await cache.close()
    })

    test("旧 fmodel 表保持路径命中语义（不校验指纹）", async () => {
        const cache = createCache()
        await cache.set(JSON.stringify(["D:/assets/A.uasset", "EM/Content/A", "EM/Content"]), [{ Type: "World" }])
        let loadCount = 0
        const load = async () => {
            loadCount++
            return [{ Type: "Reloaded" }]
        }
        expect(await cache.getOrLoad(JSON.stringify(["D:/assets/A.uasset", "EM/Content/A", "EM/Content"]), load)).toEqual([
            { Type: "World" },
        ])
        expect(loadCount).toBe(0)
        await cache.close()
    })

    test("kinded 与旧表互不影响，clear 清空两者", async () => {
        const cache = createCache()
        await cache.set("legacy-key", [{ legacy: true }])
        await cache.setKinded("bytecode", "kind-key", fingerprint(), { kinded: true })

        expect(await cache.get("kind-key")).toBeUndefined()
        expect(await cache.getKinded("bytecode", "legacy-key", fingerprint())).toBeUndefined()

        await cache.clear()
        expect(await cache.get("legacy-key")).toBeUndefined()
        expect(await cache.getKinded("bytecode", "kind-key", fingerprint())).toBeUndefined()
        await cache.close()
    })

    test("解析失败（load 返回 null）不写入 kinded 缓存", async () => {
        const cache = createCache()
        let loadCount = 0
        const load = async () => {
            loadCount++
            return null
        }
        expect(await cache.getOrLoadKinded("bytecode", "asset-key", fingerprint(), load)).toBeNull()
        expect(await cache.getOrLoadKinded("bytecode", "asset-key", fingerprint(), load)).toBeNull()
        expect(loadCount).toBe(2)
        await cache.close()
    })
})

describe("缓存指纹与路径", () => {
    test("statFingerprint 纳入 .uasset 与 .uexp/.ubulk sidecar", () => {
        tempDir = mkdtempSync(join(tmpdir(), "uasset-cache-"))
        const file = join(tempDir, "Asset.uasset")
        writeFileSync(file, "12345")
        const withoutSidecars = statFingerprint(file, 7)
        expect(withoutSidecars.parserVersion).toBe(7)
        expect(withoutSidecars.files.map(entry => [entry.suffix, entry.size])).toEqual([["uasset", 5]])
        expect(withoutSidecars.files[0]!.mtimeMs).toBeGreaterThan(0)

        writeFileSync(join(tempDir, "Asset.uexp"), "abcdef")
        writeFileSync(join(tempDir, "Asset.ubulk"), "xyz")
        const withSidecars = statFingerprint(file, 7)
        expect(withSidecars.files.map(entry => [entry.suffix, entry.size])).toEqual([
            ["uasset", 5],
            ["uexp", 6],
            ["ubulk", 3],
        ])
        expect(fingerprintKey(withSidecars)).not.toBe(fingerprintKey(withoutSidecars))
    })

    test("只修改 .uexp 的 mtime 会改变指纹", () => {
        tempDir = mkdtempSync(join(tmpdir(), "uasset-cache-"))
        const file = join(tempDir, "Asset.uasset")
        const uexp = join(tempDir, "Asset.uexp")
        writeFileSync(file, "12345")
        writeFileSync(uexp, "abcdef")
        const before = statFingerprint(file, 7)
        const future = new Date(Date.now() + 5000)
        utimesSync(uexp, future, future)
        const after = statFingerprint(file, 7)
        expect(fingerprintKey(after)).not.toBe(fingerprintKey(before))
        expect(after.files.find(entry => entry.suffix === "uasset")!.mtimeMs).toBe(before.files[0]!.mtimeMs)
    })

    test("DNA_UASSET_CACHE 覆盖缓存路径", () => {
        const previous = process.env.DNA_UASSET_CACHE
        try {
            process.env.DNA_UASSET_CACHE = "./custom/cache.duckdb"
            expect(resolveUAssetCachePath()).toBe(resolve("./custom/cache.duckdb"))
        } finally {
            if (previous === undefined) delete process.env.DNA_UASSET_CACHE
            else process.env.DNA_UASSET_CACHE = previous
        }
    })

    test("仅写在 .env 的 DNA_UASSET_CACHE 也生效", () => {
        tempDir = mkdtempSync(join(tmpdir(), "uasset-cache-"))
        const envPath = join(tempDir, ".env")
        const cachePath = join(tempDir, "env-cache.duckdb")
        writeFileSync(envPath, `DNA_UASSET_CACHE=${cachePath}\n`)
        const previous = process.env.DNA_UASSET_CACHE
        delete process.env.DNA_UASSET_CACHE
        try {
            loadDotenv(envPath)
            expect(resolveUAssetCachePath()).toBe(resolve(cachePath))
        } finally {
            if (previous === undefined) delete process.env.DNA_UASSET_CACHE
            else process.env.DNA_UASSET_CACHE = previous
        }
    })

    test("DNA_UASSET_CACHE 生效且 clearUAssetCache 清空 kinded 缓存（warmup 语义）", async () => {
        tempDir = mkdtempSync(join(tmpdir(), "uasset-cache-"))
        const cachePath = join(tempDir, "warmup-cache.duckdb")
        const previous = process.env.DNA_UASSET_CACHE
        process.env.DNA_UASSET_CACHE = cachePath
        await closeUAssetCache()
        try {
            const fingerprint: UAssetFingerprint = {
                parserVersion: 1,
                files: [{ suffix: "uasset", mtimeMs: 1000, size: 64 }],
            }
            await getUAssetCache().setKinded("bytecode", "warmup-key", fingerprint, { cached: true })
            expect(await getUAssetCache().getKinded("bytecode", "warmup-key", fingerprint)).toEqual({ cached: true })
            expect(existsSync(cachePath)).toBe(true)

            await clearUAssetCache()
            expect(await getUAssetCache().getKinded("bytecode", "warmup-key", fingerprint)).toBeUndefined()
        } finally {
            await closeUAssetCache()
            if (previous === undefined) delete process.env.DNA_UASSET_CACHE
            else process.env.DNA_UASSET_CACHE = previous
        }
    })
})
