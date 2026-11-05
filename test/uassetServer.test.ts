import { afterEach, describe, expect, test } from "bun:test"
import { existsSync, mkdtempSync, readFileSync, rmSync, statSync, utimesSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { UAssetCache } from "../src/lua/UAssetCache.ts"
import {
    bytecodeCacheKey,
    getUassetExe,
    UASSET_BYTECODE_PARSER_VERSION,
    UAssetServer,
    UAssetTimeoutError,
    type UAssetBytecodeDocument,
} from "../src/lua/UAssetServer.ts"

const STUB = join(import.meta.dir, "helpers", "uassetCliStub.ts")
const FIXTURE = join(import.meta.dir, "fixtures", "uassetBytecode.synthetic.json")

let tempDir: string | undefined
let openServers: UAssetServer[] = []
let openCaches: UAssetCache[] = []

afterEach(async () => {
    for (const server of openServers) await server.close().catch(() => undefined)
    for (const cache of openCaches) await cache.close().catch(() => undefined)
    openServers = []
    openCaches = []
    if (tempDir) rmSync(tempDir, { recursive: true, force: true })
    tempDir = undefined
})

function workDir(): string {
    if (!tempDir) tempDir = mkdtempSync(join(tmpdir(), "uasset-server-"))
    return tempDir
}

function createAsset(name: string, content = "uasset"): string {
    const path = join(workDir(), name)
    writeFileSync(path, content)
    return path
}

function createServer(extraArgs: string[] = [], timeoutMs = 5000): UAssetServer {
    const cache = new UAssetCache(join(workDir(), `cache-${openCaches.length}.duckdb`))
    openCaches.push(cache)
    const server = new UAssetServer("unused", "EM/Content", cache, {
        timeoutMs,
        command: [process.execPath, STUB, "--fixture", FIXTURE, ...extraArgs],
    })
    openServers.push(server)
    return server
}

function readLog(path: string): Array<{ cmd: string; id: number; path: string }> {
    try {
        return readFileSync(path, "utf8")
            .split("\n")
            .filter(Boolean)
            .map(line => JSON.parse(line))
    } catch {
        return []
    }
}

describe("UAssetServer bytecode", () => {
    test("返回 fixture 文档并缓存：同指纹不重复启动 CLI", async () => {
        const log = join(workDir(), "requests.log")
        const server = createServer(["--log", log])
        const asset = createAsset("Cached.uasset")

        const first = await server.bytecode(asset)
        expect(first.schemaVersion).toBe(1)
        expect(first.asset).toBe("Cached")
        expect(first.functions[0]?.body?.[0]?.op).toBe("EX_Let")

        const second = await server.bytecode(asset)
        expect(second).toEqual(first)
        expect(readLog(log).filter(entry => entry.cmd === "bytecode")).toHaveLength(1)
    })

    test("mtime 变化使缓存失效并重新解析", async () => {
        const log = join(workDir(), "requests.log")
        const server = createServer(["--log", log])
        const asset = createAsset("Touched.uasset")
        await server.bytecode(asset)

        const future = new Date(Date.now() + 5000)
        utimesSync(asset, future, future)
        await server.bytecode(asset)
        expect(readLog(log).filter(entry => entry.cmd === "bytecode")).toHaveLength(2)
    })

    test("size 变化使缓存失效并重新解析", async () => {
        const log = join(workDir(), "requests.log")
        const server = createServer(["--log", log])
        const asset = createAsset("Grown.uasset", "aaa")
        await server.bytecode(asset)

        writeFileSync(asset, "aaaa")
        await server.bytecode(asset)
        expect(readLog(log).filter(entry => entry.cmd === "bytecode")).toHaveLength(2)
    })

    test("并发 10 个请求与路径一一对应且 id 唯一", async () => {
        const log = join(workDir(), "requests.log")
        const server = createServer(["--log", log])
        const files = Array.from({ length: 10 }, (_, index) => createAsset(`Concurrent${index}.uasset`))

        const documents = await Promise.all(files.map(file => server.bytecode(file)))
        documents.forEach((document, index) => expect(document.asset).toBe(`Concurrent${index}`))

        const requests = readLog(log).filter(entry => entry.cmd === "bytecode")
        expect(requests).toHaveLength(10)
        expect(new Set(requests.map(entry => entry.id)).size).toBe(10)
    })

    test("响应 id 与请求不匹配时显式报错", async () => {
        const server = createServer(["--wrong-id"])
        const asset = createAsset("Mismatch.uasset")
        await expect(server.bytecode(asset)).rejects.toThrow(/id 不匹配/)
    })

    test("超时抛出 UAssetTimeoutError，后续请求重启进程", async () => {
        const server = createServer(["--delay", "600", "--delay-path", "Slow"], 120)
        const slow = createAsset("Slow.uasset")
        const fast = createAsset("Fast.uasset")

        await expect(server.bytecode(slow)).rejects.toBeInstanceOf(UAssetTimeoutError)
        const document = await server.bytecode(fast)
        expect(document.asset).toBe("Fast")
    })

    test("CLI 返回 ok:false 时抛出带错误信息的异常且不写缓存", async () => {
        const log = join(workDir(), "requests.log")
        const server = createServer(["--fail", "--log", log])
        const asset = createAsset("Failing.uasset")

        await expect(server.bytecode(asset)).rejects.toThrow(/stub failure/)
        await expect(server.bytecode(asset)).rejects.toThrow(/stub failure/)
        expect(readLog(log).filter(entry => entry.cmd === "bytecode")).toHaveLength(2)
    })

    test("close 幂等", async () => {
        const server = createServer()
        await server.bytecode(createAsset("Close.uasset"))
        await server.close()
        await server.close()
    })

    test("bytecodeCacheKey 包含 parserVersion、mtime 与 size", () => {
        const fingerprint = { parserVersion: UASSET_BYTECODE_PARSER_VERSION, mtimeMs: 123.5, size: 456 }
        const key = bytecodeCacheKey("D:/unpack/A.uasset", fingerprint)
        expect(JSON.parse(key)).toEqual(["bytecode", "D:/unpack/A.uasset", 1, 123.5, 456])
    })
})

// 文档结构校验对缓存中的 payload 同样生效（防止旧格式/损坏数据被当作有效结果）
describe("UAssetServer bytecode payload validation", () => {
    test("缓存中的非对象 payload 被拒绝", async () => {
        const server = createServer()
        const asset = createAsset("Bad.uasset")
        const stat = statSync(asset)
        const fingerprint = { parserVersion: UASSET_BYTECODE_PARSER_VERSION, mtimeMs: stat.mtimeMs, size: stat.size }
        await openCaches[openCaches.length - 1]!.setKinded(
            "bytecode",
            bytecodeCacheKey(asset, fingerprint),
            fingerprint,
            ["not", "an", "object"]
        )
        await expect(server.bytecode(asset)).rejects.toThrow(/不是对象/)
    })

    test("缺少 schemaVersion/functions 的 payload 被拒绝", async () => {
        const server = createServer()
        const asset = createAsset("BadSchema.uasset")
        const stat = statSync(asset)
        const fingerprint = { parserVersion: UASSET_BYTECODE_PARSER_VERSION, mtimeMs: stat.mtimeMs, size: stat.size }
        await openCaches[openCaches.length - 1]!.setKinded("bytecode", bytecodeCacheKey(asset, fingerprint), fingerprint, {
            asset: "BadSchema",
        })
        await expect(server.bytecode(asset)).rejects.toThrow(/schemaVersion/)
    })
})

// 真实资产集成测试：仅当提供 DNA_UNPACK_DIR 时运行
const unpackDir = process.env.DNA_UNPACK_DIR?.trim()
const integrationAsset = findIntegrationAsset(unpackDir)

function findIntegrationAsset(root: string | undefined): string | null {
    if (!root) return null
    const path = join(
        root,
        "Fmodel",
        "Output",
        "Exports",
        "EM",
        "Content",
        "BluePrints",
        "Combat",
        "PassiveEffect",
        "DesignerBP",
        "Player",
        "BP_Feina.uasset"
    )
    return existsSync(path) ? path : null
}

test.skipIf(!integrationAsset)("真实 BP bytecode：结构自洽且不含绝对路径", async () => {
    const exe = getUassetExe()
    if (!exe) throw new Error("找不到 tools/UAssetCLI/UAssetCLI.exe")
    const cache = new UAssetCache(join(workDir(), "cache-integration.duckdb"))
    openCaches.push(cache)
    const server = new UAssetServer(exe, "EM/Content", cache, { timeoutMs: 60000 })
    openServers.push(server)
    const document: UAssetBytecodeDocument = await server.bytecode(integrationAsset!)
    expect(document.schemaVersion).toBe(1)
    expect(document.functions.length).toBeGreaterThan(0)
    expect(document.class.name).toBeTruthy()
    expect(document.events.length).toBeGreaterThan(0)
    expect(document.variables.length).toBeGreaterThan(0)

    for (const fn of document.functions) {
        expect(fn.error).toBeUndefined()
        const body = fn.body!
        const blocks = fn.blocks!
        let cursor = 0
        body.forEach((statement, index) => {
            expect(statement.offset).toBe(cursor)
            cursor = index + 1 < body.length ? (body[index + 1]!.offset as number) : fn.codeSize!
        })
        expect(cursor).toBe(fn.codeSize!)
        expect(blocks[0]?.startOffset).toBe(0)
        let nextStatement = 0
        for (const block of blocks) {
            expect(block.statements[0]).toBe(nextStatement)
            nextStatement = block.statements[block.statements.length - 1]! + 1
        }
        expect(nextStatement).toBe(body.length)
    }

    expect(JSON.stringify(document)).not.toContain(unpackDir!)
})
