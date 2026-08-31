/**
 * UAssetServer — UAssetCLI server 客户端（TS 版，对齐 python uasset_client.py）。
 *
 * 启动一次 UAssetCLI.exe server，通过 stdio JSON 行协议请求：
 * - `fmodel` / `fmodel_dir`：按 FModel Output/Exports 数组格式导出 uasset（内存 JSON）
 *
 * 用于把 assets（动画 Montage 等）的数据源从"FModel 预导出 JSON"迁移为
 * "直接解析 .uasset"，实现零 fmodel json 依赖。
 *
 * 解包目录解析顺序（对齐 python）：
 *   1. 环境变量 DNA_UNPACK_DIR
 *   2. 仓库根 .env 的 DNA_UNPACK_DIR
 *   3. 仓库同级 ../dna-unpack
 */
import { type ChildProcess, spawn } from "node:child_process"
import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"

// import.meta.dir 在 bun 下是 src/lua 的绝对路径（Windows 无前导盘符问题）
const PROJECT_ROOT = join(import.meta.dir, "..", "..")

/** 读 .env（不覆盖已存在的环境变量） */
function loadDotenv(): void {
    try {
        const text = readFileSync(join(PROJECT_ROOT, ".env"), "utf8")
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

/** uasset 绝对路径 → FModel 包路径（相对 Exports 根、正斜杠、去 .uasset） */
export function packagePathFor(uassetFile: string, exportsRoot: string): string {
    try {
        const rel = uassetFile.replace(/\\/g, "/").split(`${exportsRoot.replace(/\\/g, "/")}/`)[1]
        if (rel) return rel.replace(/\.uasset$/i, "")
    } catch {
        /* fall through */
    }
    return uassetFile.replace(/\\/g, "/").replace(/\.uasset$/i, "")
}

export class UAssetServer {
    private proc: ChildProcess | null = null
    private buffer = ""

    constructor(
        private exe: string = getUassetExe() ?? "",
        private mount = "EM/Content"
    ) {
        if (!exe || !existsSync(exe)) throw new Error(`找不到 UAssetCLI.exe（tools/UAssetCLI/UAssetCLI.exe）: ${exe}`)
    }

    start(): void {
        this.proc = spawn(this.exe, ["server"], {
            stdio: ["pipe", "pipe", "pipe"],
            windowsHide: true,
        })
        this.proc.stderr?.on("data", () => {
            /* 忽略 stderr（调试时可打开） */
        })
    }

    /** 发送一行 JSON 命令，读一行 JSON 响应（按行缓冲解析） */
    private requestRaw(cmd: Record<string, unknown>): Promise<Record<string, unknown>> {
        if (!this.proc || this.proc.exitCode !== null) {
            return Promise.reject(new Error("UAssetCLI server 未运行"))
        }
        const proc = this.proc
        const writeOk = proc.stdin?.write(`${JSON.stringify(cmd)}\n`)
        if (!writeOk) return Promise.reject(new Error("UAssetCLI stdin 写入失败"))

        return new Promise((resolve, reject) => {
            const onData = (chunk: Buffer) => {
                this.buffer += chunk.toString("utf8")
                const nl = this.buffer.indexOf("\n")
                if (nl >= 0) {
                    const line = this.buffer.slice(0, nl).trim()
                    this.buffer = this.buffer.slice(nl + 1)
                    proc.stdout?.off("data", onData)
                    if (!line) {
                        reject(new Error("UAssetCLI 返回空行"))
                        return
                    }
                    try {
                        resolve(JSON.parse(line))
                    } catch (e) {
                        reject(e)
                    }
                }
            }
            proc.stdout?.on("data", onData)
        })
    }

    /** 带重试的请求（对齐 python _request_with_retry：瞬时失败指数退避） */
    private async request(cmd: Record<string, unknown>, retries = 4): Promise<Record<string, unknown>> {
        for (let attempt = 0; attempt < retries; attempt++) {
            try {
                const resp = await this.requestRaw(cmd)
                if (resp.ok) return resp
                if (attempt >= retries - 1) return resp
            } catch {
                if (attempt >= retries - 1) throw new Error(`UAssetCLI 请求失败: ${cmd.cmd}`)
            }
            await sleep(50 * 2 ** attempt)
        }
        return { ok: false, error: "unknown" }
    }

    /** fmodel：导出单个 uasset 为 FModel 数组格式；失败返回 null */
    async fmodel(uassetFile: string, exportsRoot: string, mount?: string): Promise<unknown[] | null> {
        const resp = await this.request({
            cmd: "fmodel",
            path: uassetFile,
            package: packagePathFor(uassetFile, exportsRoot),
            mount: mount ?? this.mount,
        })
        if (!resp.ok) return null
        const result = resp.result
        return Array.isArray(result) ? result : null
    }

    async close(): Promise<void> {
        if (!this.proc) return
        try {
            await this.request({ cmd: "shutdown" }, 1)
        } catch {
            /* ignore */
        }
        try {
            this.proc.stdin?.end()
        } catch {
            /* ignore */
        }
        try {
            this.proc.kill()
        } catch {
            /* ignore */
        }
        this.proc = null
    }
}

function sleep(ms: number): Promise<void> {
    return new Promise(r => setTimeout(r, ms))
}

/** 单例（懒建，复用进程） */
let _server: UAssetServer | null = null
export async function getUAssetServer(): Promise<UAssetServer | null> {
    if (!getUassetExe()) return null
    if (!_server) {
        _server = new UAssetServer()
        _server.start()
    }
    return _server
}

export async function closeUAssetServer(): Promise<void> {
    if (_server) {
        await _server.close()
        _server = null
    }
}
