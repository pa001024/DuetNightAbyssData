/**
 * UAssetServer — UAssetCLI server 客户端（TS 版）。
 *
 * 启动一次 UAssetCLI.exe server，通过 stdio JSON 行协议请求：
 * - `fmodel` / `fmodel_dir`：按 FModel Output/Exports 数组格式导出 uasset（内存 JSON）
 * - `bytecode`：类型化 Blueprint 字节码（opcode / 语句偏移 / 基本块 / 事件入口 / CDO 变量）
 *
 * 传输约定：
 * - 请求按 FIFO 串行发送，每个请求带自增 `id`，CLI 原样回传；收到不匹配的 id 视为协议错误。
 * - 单个请求有超时（默认 120s，可用 `DNA_UASSET_TIMEOUT_MS` 或构造参数覆盖）；
 *   超时/进程退出会杀掉子进程并在下一次请求时重启，不会永久挂起。
 *
 * 解包目录解析顺序：
 *   1. 环境变量 DNA_UNPACK_DIR
 *   2. 仓库根 .env 的 DNA_UNPACK_DIR
 *   3. 仓库同级 ../dna-unpack
 */
import { type ChildProcess, spawn } from "node:child_process"
import { existsSync } from "node:fs"
import { basename, join } from "node:path"
import {
    closeUAssetCache as closeCache,
    fingerprintKey,
    getUAssetCache,
    loadDotenv,
    statFingerprint,
    type UAssetCache,
    type UAssetFingerprint,
} from "./UAssetCache.ts"

// import.meta.dir 在 bun 下是 src/lua 的绝对路径（Windows 无前导盘符问题）
const PROJECT_ROOT = join(import.meta.dir, "..", "..")
const DEFAULT_REQUEST_TIMEOUT_MS = 120_000

/** bytecode 输出的结构版本；与 tools/UAssetCLI Program.cs 的 schemaVersion 同步递增。 */
export const UASSET_BYTECODE_PARSER_VERSION = 1
/** 泛型缓存表的 kind。 */
export const UASSET_BYTECODE_CACHE_KIND = "bytecode"

export interface UAssetBytecodeProperty {
    name: string
    type: string
    out?: boolean
    return?: boolean
    struct?: string
    objectClass?: string
    enum?: string
    innerType?: string
}

export interface UAssetBytecodeEvent {
    name: string
    target: string
    entryOffset: number | null
    flags: string[]
}

export interface UAssetBytecodeVariable {
    name: string
    type: string
    struct?: string
    innerType?: string
    enum?: string
    default: unknown
}

/** 表达式节点：op 为 EExprToken 名（如 EX_Let）；其余字段随 opcode 而定。 */
export interface UAssetBytecodeExpression {
    op: string
    offset?: number
    [key: string]: unknown
}

export interface UAssetBytecodeSuccessor {
    kind: string
    from?: number
    targetOffset?: number
    block: number | null
}

export interface UAssetBytecodeBlock {
    index: number
    startOffset: number
    endOffset: number
    statements: number[]
    successors: UAssetBytecodeSuccessor[]
}

export interface UAssetBytecodeFunction {
    name: string
    flags?: string[]
    params?: UAssetBytecodeProperty[]
    locals?: UAssetBytecodeProperty[]
    codeSize?: number
    body?: UAssetBytecodeExpression[]
    blocks?: UAssetBytecodeBlock[]
    /** 单个函数解析失败时的诊断信息；此时不包含 body/blocks。 */
    error?: string
}

export interface UAssetBytecodeClassInfo {
    name: string | null
    super: string | null
    interfaces: Array<{ name: string; implementedByBlueprint: boolean }>
}

export interface UAssetBytecodeDocument {
    schemaVersion: number
    asset: string
    class: UAssetBytecodeClassInfo
    events: UAssetBytecodeEvent[]
    variables: UAssetBytecodeVariable[]
    components: unknown[]
    functions: UAssetBytecodeFunction[]
}

export interface UAssetServerOptions {
    /** 单个请求超时（毫秒）。默认 DNA_UASSET_TIMEOUT_MS 或 120000。 */
    timeoutMs?: number
    /** 启动命令（含参数）；默认 [exe, "server"]。用于测试桩或嵌入其他 CLI 实现。 */
    command?: string[]
}

/** 缓存命中/加载计数（进程级，用于导出覆盖率与性能报告）。 */
export interface UAssetServerStats {
    fmodelHits: number
    fmodelLoads: number
    bytecodeHits: number
    bytecodeLoads: number
}

/** 请求超时：不重试，直接向上抛出。 */
export class UAssetTimeoutError extends Error {
    constructor(message: string) {
        super(message)
        this.name = "UAssetTimeoutError"
    }
}

export function getUnpackDir(): string | null {
    loadDotenv()
    const raw = process.env.DNA_UNPACK_DIR?.trim() ?? ""
    if (raw) {
        try {
            if (existsSync(raw)) return raw
        } catch {
            /* ignore */
        }
    }
    const sibling = join(PROJECT_ROOT, "..", "dna-unpack")
    try {
        if (existsSync(sibling)) return sibling
    } catch {
        /* ignore */
    }
    return null
}

export function getExportsRoot(): string | null {
    const unpack = getUnpackDir()
    if (!unpack) return null
    const exports = join(unpack, "Fmodel", "Output", "Exports")
    try {
        return existsSync(exports) ? exports : null
    } catch {
        return null
    }
}

export function getUassetExe(): string | null {
    const exe = join(PROJECT_ROOT, "tools", "UAssetCLI", "UAssetCLI.exe")
    try {
        return existsSync(exe) ? exe : null
    } catch {
        return null
    }
}

/** 资产绝对路径 → FModel 包路径（相对 Exports 根、正斜杠、去 .uasset/.umap） */
export function packagePathFor(uassetFile: string, exportsRoot: string): string {
    try {
        const rel = uassetFile.replace(/\\/g, "/").split(`${exportsRoot.replace(/\\/g, "/")}/`)[1]
        if (rel) return rel.replace(/\.(?:uasset|umap)$/i, "")
    } catch {
        /* fall through */
    }
    return uassetFile.replace(/\\/g, "/").replace(/\.(?:uasset|umap)$/i, "")
}

function resolveTimeoutMs(options: UAssetServerOptions): number {
    if (options.timeoutMs !== undefined) {
        if (!Number.isFinite(options.timeoutMs) || options.timeoutMs <= 0)
            throw new Error(`UAssetServer timeoutMs 必须是正数: ${options.timeoutMs}`)
        return options.timeoutMs
    }
    loadDotenv()
    const raw = process.env.DNA_UASSET_TIMEOUT_MS?.trim()
    if (!raw) return DEFAULT_REQUEST_TIMEOUT_MS
    const value = Number(raw)
    if (!Number.isFinite(value) || value <= 0) throw new Error(`DNA_UASSET_TIMEOUT_MS 必须是正数: ${raw}`)
    return value
}

interface PendingRequest {
    id: number
    resolve: (response: Record<string, unknown>) => void
    reject: (error: Error) => void
    timer: ReturnType<typeof setTimeout>
}

export class UAssetServer {
    private proc: ChildProcess | null = null
    private buffer = ""
    private lastStderr = ""
    private pending: PendingRequest | null = null
    private nextRequestId = 1
    /** 请求串行化：上一个请求结束（成功或失败）后才发送下一个。 */
    private chain: Promise<unknown> = Promise.resolve()
    private closing: Promise<void> | null = null
    /** close() 后实例不可再启动进程；陈旧持有者不能借旧引用重新 spawn。 */
    private closed = false
    private readonly timeoutMs: number
    private readonly cache: UAssetCache
    private readonly command: string[] | null
    readonly stats: UAssetServerStats = { fmodelHits: 0, fmodelLoads: 0, bytecodeHits: 0, bytecodeLoads: 0 }

    constructor(
        private exe: string = getUassetExe() ?? "",
        private mount = "EM/Content",
        cache: UAssetCache = getUAssetCache(),
        options: UAssetServerOptions = {}
    ) {
        this.cache = cache
        this.timeoutMs = resolveTimeoutMs(options)
        this.command = options.command ?? null
    }

    start(): void {
        // 进程只在缓存未命中、真正需要解析资产时启动。
    }

    private ensureProcess(): ChildProcess {
        if (this.closed) throw new Error("UAssetServer 已关闭，不能继续启动 UAssetCLI 进程")
        if (this.proc && this.proc.exitCode === null && !this.proc.killed) return this.proc
        if (!this.command && (!this.exe || !existsSync(this.exe)))
            throw new Error(`找不到 UAssetCLI.exe（tools/UAssetCLI/UAssetCLI.exe）: ${this.exe}`)
        const [file, ...args] = this.command ?? [this.exe, "server"]
        const proc = spawn(file, args, {
            stdio: ["pipe", "pipe", "pipe"],
            windowsHide: true,
        })
        this.buffer = ""
        this.lastStderr = ""
        // 按字符流解码，避免多字节字符恰好跨 chunk 时被拆成 U+FFFD
        proc.stdout?.setEncoding("utf8")
        proc.stderr?.setEncoding("utf8")
        proc.stdout?.on("data", (chunk: string) => this.onStdout(proc, chunk))
        proc.stderr?.on("data", (chunk: string) => {
            this.lastStderr = (this.lastStderr + chunk).slice(-4000)
        })
        proc.on("exit", (code, signal) => this.onProcessExit(proc, code, signal))
        proc.on("error", error => this.onProcessError(proc, error))
        this.proc = proc
        return proc
    }

    private onStdout(proc: ChildProcess, chunk: string): void {
        if (this.proc !== proc) return
        this.buffer += chunk
        let newline = this.buffer.indexOf("\n")
        while (newline >= 0) {
            const line = this.buffer.slice(0, newline).trim()
            this.buffer = this.buffer.slice(newline + 1)
            if (line) this.dispatchResponse(line)
            newline = this.buffer.indexOf("\n")
        }
    }

    private dispatchResponse(line: string): void {
        let response: Record<string, unknown>
        try {
            const parsed: unknown = JSON.parse(line)
            if (parsed === null || typeof parsed !== "object" || Array.isArray(parsed)) {
                this.failPending(new Error(`UAssetCLI 返回了非对象响应: ${truncate(line)}`))
                return
            }
            response = parsed as Record<string, unknown>
        } catch {
            this.failPending(new Error(`UAssetCLI 返回了非 JSON 响应: ${truncate(line)}`))
            return
        }
        const pending = this.pending
        if (!pending) return
        // 必须显式回传同一 id：缺失/不匹配都视为协议错误，避免并发下错配
        if (response.id !== pending.id) {
            this.failPending(new Error(`UAssetCLI 响应 id 不匹配: 期望 ${pending.id}，实际 ${String(response.id)}`))
            return
        }
        this.pending = null
        clearTimeout(pending.timer)
        pending.resolve(response)
    }

    private onProcessExit(proc: ChildProcess, code: number | null, signal: NodeJS.Signals | null): void {
        if (this.proc !== proc) return
        this.proc = null
        this.buffer = ""
        this.failPending(new Error(`UAssetCLI 进程退出（code=${String(code)}, signal=${String(signal)}）${this.stderrSuffix()}`))
    }

    private onProcessError(proc: ChildProcess, error: Error): void {
        if (this.proc !== proc) return
        this.proc = null
        this.buffer = ""
        this.failPending(new Error(`UAssetCLI 进程错误: ${error.message}`))
    }

    private stderrSuffix(): string {
        const text = this.lastStderr.trim()
        return text ? `；stderr: ${truncate(text)}` : ""
    }

    private failPending(error: Error): void {
        const pending = this.pending
        if (!pending) return
        this.pending = null
        clearTimeout(pending.timer)
        pending.reject(error)
    }

    private killProcess(): void {
        const proc = this.proc
        this.proc = null
        this.buffer = ""
        if (!proc) return
        try {
            proc.stdin?.end()
        } catch {
            /* ignore */
        }
        try {
            proc.kill()
        } catch {
            /* ignore */
        }
    }

    /** 串行发送一个请求；失败不会阻塞后续请求。 */
    private request(cmd: Record<string, unknown>, timeoutMs = this.timeoutMs): Promise<Record<string, unknown>> {
        const run = () => this.requestOnce(cmd, timeoutMs)
        const result = this.chain.then(run, run)
        this.chain = result.then(
            () => undefined,
            () => undefined
        )
        return result
    }

    private requestOnce(cmd: Record<string, unknown>, timeoutMs: number): Promise<Record<string, unknown>> {
        const proc = this.ensureProcess()
        if (this.pending) return Promise.reject(new Error("UAssetCLI 请求重叠（内部串行化失效）"))
        const id = this.nextRequestId++
        return new Promise<Record<string, unknown>>((resolve, reject) => {
            const timer = setTimeout(() => {
                if (this.pending?.id !== id) return
                this.failPending(new UAssetTimeoutError(`UAssetCLI 请求超时（${timeoutMs}ms，cmd=${String(cmd.cmd)}）`))
                this.killProcess()
            }, timeoutMs)
            timer.unref?.()
            this.pending = { id, resolve, reject, timer }
            try {
                proc.stdin?.write(`${JSON.stringify({ ...cmd, id })}\n`, error => {
                    if (error && this.pending?.id === id) this.failPending(new Error(`UAssetCLI stdin 写入失败: ${error.message}`))
                })
            } catch (error) {
                if (this.pending?.id === id) this.failPending(toError(error))
            }
            if (!proc.stdin) this.failPending(new Error("UAssetCLI stdin 不可用"))
        })
    }

    /** 带重试的请求（瞬时失败指数退避）；超时不重试。 */
    private async requestWithRetry(cmd: Record<string, unknown>, retries = 4): Promise<Record<string, unknown>> {
        for (let attempt = 0; attempt < retries; attempt++) {
            try {
                const resp = await this.request(cmd)
                if (resp.ok) return resp
                if (attempt >= retries - 1) return resp
            } catch (error) {
                if (error instanceof UAssetTimeoutError) throw error
                if (!this.command && (!this.exe || !existsSync(this.exe)))
                    throw new Error(`找不到 UAssetCLI.exe（tools/UAssetCLI/UAssetCLI.exe）: ${this.exe}`)
                if (attempt >= retries - 1) throw new Error(`UAssetCLI 请求失败: ${cmd.cmd}`)
            }
            await sleep(50 * 2 ** attempt)
        }
        return { ok: false, error: "unknown" }
    }

    /** fmodel：导出单个 uasset 为 FModel 数组格式；失败返回 null。命中旧表不校验指纹。 */
    async fmodel(uassetFile: string, exportsRoot: string, mount?: string): Promise<unknown[] | null> {
        const resolvedMount = mount ?? this.mount
        const packagePath = packagePathFor(uassetFile, exportsRoot)
        const cacheKey = JSON.stringify([uassetFile.replace(/\\/g, "/"), packagePath, resolvedMount])
        const cached = await this.cache.get(cacheKey)
        if (cached !== undefined) {
            this.stats.fmodelHits++
            return cached
        }
        this.stats.fmodelLoads++
        const resp = await this.requestWithRetry({
            cmd: "fmodel",
            path: uassetFile,
            package: packagePath,
            mount: resolvedMount,
        })
        if (!resp.ok) return null
        const result = resp.result
        if (!Array.isArray(result)) return null
        await this.cache.set(cacheKey, result)
        return result
    }

    /**
     * bytecode：读取类型化 Blueprint 字节码。
     * 缓存 key 含 parserVersion + .uasset/.uexp/.ubulk 的 mtime/size；未命中才 spawn UAssetCLI。
     * 解析失败抛出异常（带 CLI 错误信息），不会写入缓存。
     */
    async bytecode(uassetFile: string): Promise<UAssetBytecodeDocument> {
        const fingerprint = statFingerprint(uassetFile, UASSET_BYTECODE_PARSER_VERSION)
        const cacheKey = bytecodeCacheKey(uassetFile, fingerprint)
        const cached = await this.cache.getKinded(UASSET_BYTECODE_CACHE_KIND, cacheKey, fingerprint)
        if (cached !== undefined) {
            this.stats.bytecodeHits++
            return asBytecodeDocument(cached, cacheKey)
        }

        this.stats.bytecodeLoads++
        const resp = await this.request({ cmd: "bytecode", path: uassetFile })
        if (!resp.ok) throw new Error(`UAssetCLI bytecode 解析失败（${basename(uassetFile)}）: ${String(resp.error ?? "unknown")}`)
        const document = asBytecodeDocument(resp.result, cacheKey)
        await this.cache.setKinded(UASSET_BYTECODE_CACHE_KIND, cacheKey, fingerprint, document)
        return document
    }

    /** 关闭子进程（幂等）。不发请求时不启动进程；关闭后实例不可复用。 */
    async close(): Promise<void> {
        this.closed = true
        if (this.closing) return this.closing
        this.closing = (async () => {
            if (!this.proc) return
            const graceMs = Math.min(this.timeoutMs, 5000)
            // shutdown 排在已排队请求之后；用独立的宽限计时避免挂起请求拖住 close
            const shutdown = this.request({ cmd: "shutdown" }, graceMs).catch(() => undefined)
            await Promise.race([shutdown, sleepUnref(graceMs)])
            this.killProcess()
            this.failPending(new Error("UAssetCLI 已关闭"))
        })()
        try {
            await this.closing
        } finally {
            this.closing = null
        }
    }
}

/** bytecode 缓存键：kind + 路径 + 完整指纹（parserVersion + .uasset/.uexp/.ubulk 的 mtime/size）。 */
export function bytecodeCacheKey(uassetFile: string, fingerprint: UAssetFingerprint): string {
    return JSON.stringify([UASSET_BYTECODE_CACHE_KIND, uassetFile.replace(/\\/g, "/"), fingerprintKey(fingerprint)])
}

function asBytecodeDocument(value: unknown, cacheKey: string): UAssetBytecodeDocument {
    if (value === null || typeof value !== "object" || Array.isArray(value)) {
        throw new Error(`UAssetCLI bytecode 返回的不是对象（cacheKey=${cacheKey}）`)
    }
    const doc = value as UAssetBytecodeDocument
    if (typeof doc.schemaVersion !== "number" || !Array.isArray(doc.functions)) {
        throw new Error(`UAssetCLI bytecode 返回缺少 schemaVersion/functions（cacheKey=${cacheKey}）`)
    }
    if (doc.schemaVersion !== UASSET_BYTECODE_PARSER_VERSION) {
        throw new Error(
            `UAssetCLI bytecode schemaVersion 不匹配: 期望 ${UASSET_BYTECODE_PARSER_VERSION}，实际 ${doc.schemaVersion}（cacheKey=${cacheKey}）`
        )
    }
    return doc
}

function toError(value: unknown): Error {
    return value instanceof Error ? value : new Error(String(value))
}

function truncate(text: string, max = 500): string {
    return text.length > max ? `${text.slice(0, max)}…` : text
}

function sleep(ms: number): Promise<void> {
    return new Promise(r => setTimeout(r, ms))
}

/** 不阻止进程退出的计时器（调用方已有其他句柄保持事件循环）。 */
function sleepUnref(ms: number): Promise<void> {
    return new Promise(resolve => {
        const timer = setTimeout(resolve, ms)
        timer.unref?.()
    })
}

/** 单例（懒建，复用进程） */
let _server: UAssetServer | null = null
/** acquire/release 引用计数：最后一个持有者释放时关闭进程，但保留共享 DuckDB 连接。 */
let _serverRefs = 0

export async function getUAssetServer(): Promise<UAssetServer | null> {
    if (!_server) {
        _server = new UAssetServer()
        _server.start()
    }
    return _server
}

/**
 * 引用一个共享 server。与 `releaseUAssetServer` 成对使用；
 * 调用方（如 AssetReader）用引用计数避免某个模块结束时关闭其他模块仍在用的进程。
 */
export async function acquireUAssetServer(): Promise<UAssetServer | null> {
    const server = await getUAssetServer()
    if (server) _serverRefs++
    return server
}

/**
 * 释放引用。计数归零时关闭 UAssetCLI 进程，但不关闭 DuckDB 缓存：
 * 同一次导出内后续模块继续复用同一个连接，只有 CLI 退出时统一关闭。
 * 先校验身份再减计数：陈旧持有者既不能影响当前引用数，也不能关闭当前进程；
 * 被关闭的实例已标记 closed，无法被旧引用重新 spawn。
 */
export async function releaseUAssetServer(server?: UAssetServer | null): Promise<void> {
    const current = _server
    if (!current) return
    if (server !== undefined && server !== current) return
    if (_serverRefs > 0) _serverRefs--
    if (_serverRefs > 0) return
    _server = null
    await current.close()
}

/**
 * 关闭单例进程。默认同时关闭共享 DuckDB 缓存（历史行为）；
 * `keepCache: true` 只关进程，供多个调用方分批复用同一缓存。
 */
export async function closeUAssetServer(options: { keepCache?: boolean } = {}): Promise<void> {
    _serverRefs = 0
    if (_server) {
        const current = _server
        _server = null
        await current.close()
    }
    if (!options.keepCache) await closeCache()
}

/** 进程级 server 统计（当前单例；未启动时为零值）。 */
export function getUAssetServerStats(): UAssetServerStats {
    return _server ? { ..._server.stats } : { fmodelHits: 0, fmodelLoads: 0, bytecodeHits: 0, bytecodeLoads: 0 }
}

export async function clearUAssetCache(): Promise<void> {
    await getUAssetCache().clear()
}
