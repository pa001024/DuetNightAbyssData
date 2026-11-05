/**
 * 测试用 UAssetCLI server 桩：只实现 stdio JSON 行协议与 `bytecode`/`shutdown`。
 *
 * 参数：
 *   --fixture <json 文件>   bytecode result 的模板（asset 字段会被请求文件名覆盖）
 *   --log <文件>            每收到一个请求追加一行 JSON（含 id）
 *   --delay <ms>            bytecode 请求的延迟
 *   --delay-path <子串>     只对包含该子串的请求路径延迟（缺省全部延迟）
 *   --wrong-id              响应回传错误的 id（模拟协议错配）
 *   --fail                  返回 {"ok":false,...}
 */
import { appendFileSync, readFileSync } from "node:fs"
import { basename } from "node:path"
import { createInterface } from "node:readline"

const args = process.argv.slice(2)
function arg(name: string, fallback = ""): string {
    const index = args.indexOf(name)
    return index >= 0 ? (args[index + 1] ?? fallback) : fallback
}

const fixturePath = arg("--fixture")
const logPath = arg("--log")
const delayMs = Number(arg("--delay", "0"))
const delayPath = arg("--delay-path")
const wrongId = args.includes("--wrong-id")
const fail = args.includes("--fail")
const fixture = fixturePath ? (JSON.parse(readFileSync(fixturePath, "utf8")) as Record<string, unknown>) : {}

function respond(response: Record<string, unknown>): void {
    process.stdout.write(`${JSON.stringify(response)}\n`)
}
function sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
}

const lines = createInterface({ input: process.stdin })
for await (const line of lines) {
    if (!line.trim()) continue
    const request = JSON.parse(line) as { cmd?: string; id?: number; path?: string }
    if (logPath) appendFileSync(logPath, `${JSON.stringify({ cmd: request.cmd, id: request.id, path: request.path })}\n`)
    const id = wrongId ? Number(request.id) + 1000 : request.id
    if (request.cmd === "shutdown") {
        respond({ ok: true, closed: true, id: request.id })
        break
    }
    if (request.cmd === "bytecode") {
        if (delayMs > 0 && (!delayPath || (request.path ?? "").includes(delayPath))) await sleep(delayMs)
        if (fail) {
            respond({ ok: false, error: "stub failure", id })
            continue
        }
        respond({
            ok: true,
            id,
            result: { ...fixture, asset: request.path ? basename(request.path).replace(/\.uasset$/i, "") : fixture.asset },
        })
        continue
    }
    respond({ ok: false, error: `stub: unsupported command ${String(request.cmd)}`, id })
}
process.exit(0)
