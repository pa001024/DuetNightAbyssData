import { afterEach, describe, expect, test } from "bun:test"
import { mkdtempSync, rmSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join, resolve } from "node:path"
import { type UAssetFingerprint, UAssetCache, resolveUAssetCachePath, statFingerprint } from "../src/lua/UAssetCache.ts"
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
        mtimeMs: 1000,
        size: 64,
        ...overrides,
    })

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
        expect(await cache.getOrLoadKinded("bytecode", "asset-key", fingerprint({ mtimeMs: 1001 }), load)).toEqual({ load: 3 })
        expect(await cache.getOrLoadKinded("bytecode", "asset-key", fingerprint({ size: 65 }), load)).toEqual({ load: 4 })
        expect(loadCount).toBe(4)
        await cache.close()
    })

    test("payload 可以是数组", async () => {
        const cache = createCache()
        await cache.setKinded("other", "array-key", fingerprint(), [{ Type: "AnimMontage" }])
        expect(await cache.getKinded("other", "array-key", fingerprint())).toEqual([{ Type: "AnimMontage" }])
        expect(await cache.getKinded("other", "array-key", fingerprint({ size: 1 }))).toBeUndefined()
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
    test("statFingerprint 读取文件 mtime 与 size", () => {
        tempDir = mkdtempSync(join(tmpdir(), "uasset-cache-"))
        const file = join(tempDir, "Asset.uasset")
        writeFileSync(file, "12345")
        const fingerprint = statFingerprint(file, 7)
        expect(fingerprint.parserVersion).toBe(7)
        expect(fingerprint.size).toBe(5)
        expect(fingerprint.mtimeMs).toBeGreaterThan(0)
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
})
