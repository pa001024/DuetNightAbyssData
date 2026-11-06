import { afterEach, describe, expect, test } from "bun:test"
import { existsSync, mkdtempSync, readFileSync, rmSync, utimesSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { statFingerprint, type UAssetFingerprint, UAssetCache } from "../src/lua/UAssetCache.ts"
import {
    acquireUAssetServer,
    bytecodeCacheKey,
    closeUAssetServer,
    getUAssetServer,
    getUassetExe,
    releaseUAssetServer,
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

    test("仅 .uexp 变化（.uasset 未变）使缓存失效", async () => {
        const log = join(workDir(), "requests.log")
        const server = createServer(["--log", log])
        const asset = createAsset("Sidecar.uasset")
        const uexp = join(workDir(), "Sidecar.uexp")
        writeFileSync(uexp, "bytecode-v1")
        await server.bytecode(asset)
        await server.bytecode(asset)
        expect(readLog(log).filter(entry => entry.cmd === "bytecode")).toHaveLength(1)

        // 只 touch sidecar，模拟同长字节码/CDO 编辑后 .uasset 指纹不变
        const future = new Date(Date.now() + 5000)
        utimesSync(uexp, future, future)
        await server.bytecode(asset)
        expect(readLog(log).filter(entry => entry.cmd === "bytecode")).toHaveLength(2)
    })

    test(".ubulk 变化使缓存失效", async () => {
        const log = join(workDir(), "requests.log")
        const server = createServer(["--log", log])
        const asset = createAsset("Bulk.uasset")
        const ubulk = join(workDir(), "Bulk.ubulk")
        writeFileSync(ubulk, "v1")
        await server.bytecode(asset)

        writeFileSync(ubulk, "v2-longer")
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

    test("响应缺少 id 时显式报错", async () => {
        const server = createServer(["--no-id"])
        const asset = createAsset("NoId.uasset")
        await expect(server.bytecode(asset)).rejects.toThrow(/id 不匹配/)
    })

    test("超时抛出 UAssetTimeoutError，后续请求重启进程", async () => {
        // 超时需短于 Slow 的延迟、长于新进程（bun 桩）冷启动
        const server = createServer(["--delay", "1500", "--delay-path", "Slow"], 700)
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

    test("close 幂等，关闭后的实例不能再启动进程", async () => {
        const server = createServer()
        await server.bytecode(createAsset("Close.uasset"))
        await server.close()
        await server.close()
        await expect(server.bytecode(createAsset("AfterClose.uasset"))).rejects.toThrow(/已关闭/)
    })

    test("bytecodeCacheKey 包含完整指纹（parserVersion + 主资产/sidecar）", () => {
        const fingerprint: UAssetFingerprint = {
            parserVersion: UASSET_BYTECODE_PARSER_VERSION,
            files: [
                { suffix: "uasset", mtimeMs: 123.5, size: 456 },
                { suffix: "uexp", mtimeMs: 789, size: 1024 },
            ],
        }
        const parsed = JSON.parse(bytecodeCacheKey("D:/unpack/A.uasset", fingerprint))
        expect(parsed[0]).toBe("bytecode")
        expect(parsed[1]).toBe("D:/unpack/A.uasset")
        expect(JSON.parse(parsed[2])).toEqual([
            1,
            [
                ["uasset", 123.5, 456],
                ["uexp", 789, 1024],
            ],
        ])
    })

    test("acquire/release：陈旧持有者不影响当前引用或关闭当前实例", async () => {
        await closeUAssetServer({ keepCache: true })
        try {
            const first = await acquireUAssetServer()
            const second = await acquireUAssetServer()
            expect(first).toBe(second)

            const foreignCache = new UAssetCache(join(workDir(), "foreign.duckdb"))
            openCaches.push(foreignCache)
            const foreign = new UAssetServer("unused", "EM/Content", foreignCache, {
                command: [process.execPath, STUB, "--fixture", FIXTURE],
            })
            await releaseUAssetServer(foreign)
            expect(await getUAssetServer()).toBe(first)

            await releaseUAssetServer(first)
            expect(await getUAssetServer()).toBe(first)
            await releaseUAssetServer(second)
            expect(await getUAssetServer()).not.toBe(first)
        } finally {
            await closeUAssetServer({ keepCache: true })
        }
    })
})

// 文档结构校验对缓存中的 payload 同样生效（防止旧格式/损坏数据被当作有效结果）
describe("UAssetServer bytecode payload validation", () => {
    test("缓存中的非对象 payload 被拒绝", async () => {
        const server = createServer()
        const asset = createAsset("Bad.uasset")
        const fingerprint = statFingerprint(asset, UASSET_BYTECODE_PARSER_VERSION)
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
        const fingerprint = statFingerprint(asset, UASSET_BYTECODE_PARSER_VERSION)
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
    // 真实熟化资产：ScriptBytecode 在 .uexp，指纹必须包含 sidecar
    const fingerprint = statFingerprint(integrationAsset!, UASSET_BYTECODE_PARSER_VERSION)
    expect(fingerprint.files.map(file => file.suffix)).toContain("uexp")
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
