/**
 * scriptSnapshot — CLI -v 历史版本数据快照。
 *
 * 仓库 git 历史中的游戏 Lua 数据版本用两种方式标记：
 * - tag 名：v1.1、v1.2
 * - master 主线 commit subject 即版本号：v1.3.125.1 … v1.6.4.1
 *
 * 解析规则（resolveScriptVersion）：
 * - token 可直接命中 git ref/commit（如 v1.2、eb0af1e4）→ 直接用该 commit；
 * - 其余按版本号处理：可带可选的 v 前缀，只传部分段（如 1.6）时匹配同前缀里
 *   最新（最靠近 HEAD）的版本，如 1.6 → v1.6.4.1；传全段则精确命中。
 *
 * snapshotScriptData 用 `git archive` 只物化该 commit 的 Script/（含 Datas/Utils/
 * CommonConst.lua 等全部 Lua 数据与引擎），缓存于 .cache/script-snapshots/。
 * 不触碰代码、uasset 解包与 out/ 等当前工作区内容；仓库根不再保留任何 Lua 文件。
 */
import { spawnSync } from "node:child_process"
import { existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs"
import { join } from "node:path"

/** commit subject / tag 名的版本号形态：可选 v 前缀 + 至少两段数字（如 1.2、v1.6.4.1） */
const VERSION_LABEL_RE = /^[vV]?(\d+(?:\.\d+)+)$/
/** -v 入参：可选 v 前缀 + 一段以上数字（如 1、1.6、v1.6.4.1） */
const VERSION_TOKEN_RE = /^[vV]?(\d+(?:\.\d+)*)$/
/** commit 哈希/前缀形态 */
const HEX_RE = /^[0-9a-fA-F]{4,40}$/

export interface ScriptVersion {
    /** 归一化版本号（去掉 v 前缀），如 "1.6.4.1" */
    version: string
    /** 完整 commit sha */
    commit: string
    /** 是否来自 tag 名（v1.1/v1.2） */
    isTag: boolean
    /** 来源标记：tag 名或 commit subject，用于展示 */
    label: string
}

interface GitResult {
    ok: boolean
    stdout: string
    stderr: string
}

function runGit(repoRoot: string, args: string[]): GitResult {
    const r = spawnSync("git", ["-C", repoRoot, ...args], { encoding: "utf8", maxBuffer: 64 * 1024 * 1024 })
    return {
        ok: r.status === 0,
        stdout: (r.stdout ?? "").toString(),
        stderr: (r.stderr ?? "").toString(),
    }
}

/** 规范化版本号输入："v1.6.4.1" → [1,6,4,1]；非法返回 null */
export function versionSegments(token: string): number[] | null {
    const m = token.trim().match(VERSION_TOKEN_RE)
    if (!m) return null
    return m[1].split(".").map(Number)
}

/**
 * 纯匹配：在候选版本里按段前缀选出"最新"。候选需已按最新→最旧排序。
 * 返回命中下标；无命中返回 -1。
 */
export function selectVersion(candidates: ScriptVersion[], segments: number[]): number {
    for (let i = 0; i < candidates.length; i++) {
        const parts = candidates[i].version.split(".").map(Number)
        if (parts.length < segments.length) continue
        let match = true
        for (let j = 0; j < segments.length; j++) {
            if (parts[j] !== segments[j]) {
                match = false
                break
            }
        }
        if (match) return i
    }
    return -1
}

/**
 * 列出仓库历史中全部版本标记（最新在前）：
 * master 主线（HEAD）上 subject 为版本号的 commit + 版本形态的 tag。
 */
export function listScriptVersions(repoRoot: string): ScriptVersion[] {
    // HEAD 祖先按拓扑序（子在前 = 新在前）
    const log = runGit(repoRoot, ["log", "HEAD", "--topo-order", "--pretty=format:%H%x1f%s"])
    if (!log.ok) {
        throw new Error(`无法读取 git 历史（${repoRoot} 不是 git 仓库？）: ${log.stderr.trim() || log.stdout.trim()}`)
    }
    const posByCommit = new Map<string, number>()
    const subjectByCommit = new Map<string, string>()
    let pos = 0
    for (const line of log.stdout.split("\n")) {
        if (!line) continue
        const sep = line.indexOf("\x1f")
        if (sep < 0) continue
        const hash = line.slice(0, sep)
        const subject = line.slice(sep + 1)
        posByCommit.set(hash, pos++)
        subjectByCommit.set(hash, subject)
    }

    const entries: Array<{ sv: ScriptVersion; pos: number }> = []
    // HEAD 祖先上 subject 为版本号的 commit
    for (const [hash, subject] of subjectByCommit) {
        const m = subject.match(VERSION_LABEL_RE)
        if (!m) continue
        entries.push({
            sv: { version: m[1], commit: hash, isTag: false, label: subject },
            pos: posByCommit.get(hash) ?? Number.POSITIVE_INFINITY,
        })
    }

    // 版本形态的 tag（v1.1/v1.2 等；peel 到 commit）
    const tags = runGit(repoRoot, ["for-each-ref", "refs/tags", "--format=%(refname:short)%00%(objectname)%00%(*objectname)"])
    if (tags.ok) {
        for (const line of tags.stdout.split("\n")) {
            if (!line) continue
            const [name, obj, peeled] = line.split("\0")
            const m = name.match(VERSION_LABEL_RE)
            if (!m) continue
            const target = (peeled || obj).trim()
            const verify = runGit(repoRoot, ["rev-parse", "--verify", "--quiet", `${target}^{commit}`])
            if (!verify.ok) continue
            const commit = verify.stdout.trim()
            if (entries.some(e => e.sv.commit === commit && !e.sv.isTag)) continue
            if (entries.some(e => e.sv.commit === commit && e.sv.isTag && e.sv.version === m[1])) continue
            entries.push({
                sv: { version: m[1], commit, isTag: true, label: name },
                pos: posByCommit.get(commit) ?? Number.POSITIVE_INFINITY,
            })
        }
    }

    entries.sort((a, b) => a.pos - b.pos)
    return entries.map(e => e.sv)
}

/**
 * 解析 -v 入参到具体 commit。
 * token 支持：commit 哈希/前缀、tag 名（v1.2）、版本号（1.6 / v1.6.4.1，可部分前缀，取最新）。
 * 无法解析时抛错并列出可用版本。
 */
export function resolveScriptVersion(repoRoot: string, token: string): ScriptVersion {
    const raw = token.trim()
    if (!raw) throw new Error("-v 需要一个版本号（如 1.6、v1.2、1.6.4.1）或 commit 哈希")

    // 1) 直接按 git ref/hash 解析（tag 名、commit 哈希、分支名…）
    if (HEX_RE.test(raw) || !VERSION_TOKEN_RE.test(raw)) {
        const direct = runGit(repoRoot, ["rev-parse", "--verify", "--quiet", `${raw}^{commit}`])
        if (direct.ok) {
            const commit = direct.stdout.trim()
            const known = listScriptVersions(repoRoot).find(v => v.commit === commit)
            return known ?? { version: raw, commit, isTag: false, label: raw }
        }
        if (HEX_RE.test(raw)) throw new Error(`找不到 commit: ${raw}`)
    }

    // 2) 版本号前缀匹配（v1.2 / 1.6 / 1.6.4.1 …），取最新
    const segs = versionSegments(raw)
    if (segs) {
        const candidates = listScriptVersions(repoRoot)
        const idx = selectVersion(candidates, segs)
        if (idx >= 0) return candidates[idx]
        throw new Error(
            `找不到版本 ${raw}。可用版本（最新在前）：${
                candidates.length
                    ? `\n  ${candidates
                          .slice(0, 80)
                          .map(v => (v.isTag ? `${v.label} (tag)` : v.label))
                          .join("\n  ")}`
                    : "（历史中没有任何版本号标记）"
            }`
        )
    }

    throw new Error(`无法识别的版本参数: ${raw}（支持 v1.2 / 1.6 / 1.6.4.1 / commit 哈希）`)
}

/**
 * 物化指定版本 commit 的 Lua 数据层（Script/ 目录）到快照目录。
 * 目录按版本缓存（.cache/script-snapshots/<version>-<hash12>/），命中直接复用。
 * 返回快照目录（作为 LuaDataManager 的数据根）。
 */
export function snapshotScriptData(repoRoot: string, version: ScriptVersion): string {
    const cacheRoot = join(repoRoot, ".cache", "script-snapshots")
    const dir = join(cacheRoot, `${version.version}-${version.commit.slice(0, 12)}`)
    const marker = join(dir, ".snapshot-commit")

    if (existsSync(marker)) {
        try {
            if (readFileSync(marker, "utf8").trim() === version.commit) return dir
        } catch {
            /* 标记损坏则重新物化 */
        }
    }

    rmSync(dir, { recursive: true, force: true })
    mkdirSync(dir, { recursive: true })
    const tar = join(dir, "snapshot.tar")
    const archive = runGit(repoRoot, ["archive", "--format=tar", "-o", tar, version.commit, "Script"])
    if (!archive.ok) {
        rmSync(dir, { recursive: true, force: true })
        throw new Error(`git archive 失败（${version.label}）: ${archive.stderr.trim() || archive.stdout.trim()}`)
    }
    const extract = spawnSync("tar", ["-xf", "snapshot.tar"], { cwd: dir, encoding: "utf8" })
    rmSync(tar, { force: true })
    if (extract.status !== 0) {
        rmSync(dir, { recursive: true, force: true })
        throw new Error(`解包版本快照失败（${version.label}）: ${(extract.stderr ?? "").toString().trim()}`)
    }
    if (!existsSync(join(dir, "Script"))) {
        rmSync(dir, { recursive: true, force: true })
        throw new Error(`版本 ${version.label} 的 tree 中没有 Script/，无法作为数据层解析`)
    }
    writeFileSync(marker, version.commit, "utf8")
    return dir
}
