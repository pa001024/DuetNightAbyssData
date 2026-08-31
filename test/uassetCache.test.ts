import { afterEach, describe, expect, test } from "bun:test"
import { mkdtempSync, rmSync } from "node:fs"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { UAssetCache } from "../src/lua/UAssetCache.ts"
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
