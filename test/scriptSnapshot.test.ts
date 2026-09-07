/**
 * scriptSnapshot 测试：
 * - 纯函数：版本号段解析 / 前缀匹配（不依赖 git）
 * - 真实仓库：git 历史中 tag(1.2)+commit subject(1.6.4.1) 的解析（依赖本仓库历史）
 * - 快照冒烟：仅在 .cache 已有快照时验证复用路径（避免默认物化数百 MB 数据）
 */
import { afterAll, describe, expect, test } from "bun:test"
import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"
import { LuaDataManager } from "../src/lua/LuaDataManager.ts"
import { listScriptVersions, resolveScriptVersion, selectVersion, snapshotScriptData, versionSegments } from "../src/lua/scriptSnapshot.ts"

const REPO_ROOT = join(import.meta.dir, "..")

function candidatesNewestFirst(): Parameters<typeof selectVersion>[0] {
    return [
        { version: "1.6.4.1", commit: "a", isTag: false, label: "v1.6.4.1" },
        { version: "1.6.3.1", commit: "b", isTag: false, label: "v1.6.3.1" },
        { version: "1.5.190.1", commit: "c", isTag: false, label: "v1.5.190.1" },
        { version: "1.5.183.1", commit: "d", isTag: false, label: "v1.5.183.1" },
        { version: "1.4.164.1", commit: "e", isTag: false, label: "v1.4.164.1" },
        { version: "1.2", commit: "f", isTag: true, label: "v1.2" },
        { version: "1.1", commit: "g", isTag: true, label: "v1.1" },
    ]
}

describe("versionSegments", () => {
    test("解析 v 前缀与纯数字", () => {
        expect(versionSegments("1.6.4.1")).toEqual([1, 6, 4, 1])
        expect(versionSegments("v1.2")).toEqual([1, 2])
        expect(versionSegments("V1.2")).toEqual([1, 2])
        expect(versionSegments("1")).toEqual([1])
    })
    test("非法输入返回 null", () => {
        expect(versionSegments("abc")).toBeNull()
        expect(versionSegments("1.2-beta")).toBeNull()
        expect(versionSegments("")).toBeNull()
    })
})

describe("selectVersion", () => {
    const cands = candidatesNewestFirst()
    test("精确版本命中", () => {
        expect(selectVersion(cands, [1, 2])).toBe(5)
    })
    test("前缀匹配命中最新", () => {
        expect(selectVersion(cands, [1, 6])).toBe(0) // 1.6.4.1
        expect(selectVersion(cands, [1, 6, 4])).toBe(0) // 1.6.4.1
        expect(selectVersion(cands, [1, 5])).toBe(2) // 1.5.190.1
        expect(selectVersion(cands, [1])).toBe(0) // 整体最新
    })
    test("段前缀不做字符串前缀匹配（1.4.16 不命中 1.4.164.1）", () => {
        expect(selectVersion(cands, [1, 4, 16])).toBe(-1) // [1,4,164] 不以 [1,4,16] 开头
        expect(selectVersion(cands, [1, 7])).toBe(-1)
        expect(selectVersion(cands, [2])).toBe(-1)
    })
})

describe("listScriptVersions / resolveScriptVersion（真实仓库）", () => {
    test("列表包含 tag v1.2 与主线 commit subject v1.6.4.1，且按最新在前", () => {
        const all = listScriptVersions(REPO_ROOT)
        expect(all.length).toBeGreaterThan(0)
        const first = all[0]
        expect(first.version).toBe("1.6.4.1")
        expect(all.some(v => v.version === "1.2" && v.isTag)).toBe(true)
        expect(all.some(v => v.version === "1.6.4.1" && !v.isTag)).toBe(true)
    })
    test("-v 1.2 / v1.2 → tag v1.2", () => {
        const byPlain = resolveScriptVersion(REPO_ROOT, "1.2")
        expect(byPlain.version).toBe("1.2")
        expect(byPlain.isTag).toBe(true)
        const byV = resolveScriptVersion(REPO_ROOT, "v1.2")
        expect(byV.commit).toBe(byPlain.commit)
    })
    test("-v 1.6（前缀）→ 最新 1.6.x（当前 v1.6.4.1）", () => {
        const resolved = resolveScriptVersion(REPO_ROOT, "1.6")
        expect(resolved.version).toBe("1.6.4.1")
        expect(resolved.label).toBe("v1.6.4.1")
    })
    test("-v 1.6.4.1（精确）与 commit 哈希等价", () => {
        const byVer = resolveScriptVersion(REPO_ROOT, "1.6.4.1")
        expect(byVer.version).toBe("1.6.4.1")
        const byHash = resolveScriptVersion(REPO_ROOT, byVer.commit.slice(0, 12))
        expect(byHash.commit).toBe(byVer.commit)
    })
    test("找不到的版本抛错", () => {
        expect(() => resolveScriptVersion(REPO_ROOT, "9.9.9")).toThrow(/找不到版本/)
    })
})

describe("snapshotScriptData", () => {
    afterAll(() => {
        // 快照是持久缓存（.cache/script-snapshots），不清理；跑冒烟前已由 CLI -v 预热
    })
    test("已缓存时复用（不重新物化）", () => {
        const resolved = resolveScriptVersion(REPO_ROOT, "1.2")
        const cacheDir = join(REPO_ROOT, ".cache", "script-snapshots", `${resolved.version}-${resolved.commit.slice(0, 12)}`)
        const marker = join(cacheDir, ".snapshot-commit")
        if (!existsSync(marker)) {
            // 首次运行不强制物化数百 MB 数据：由 CLI -v 冒烟覆盖
            return
        }
        const dir = snapshotScriptData(REPO_ROOT, resolved)
        expect(dir).toBe(cacheDir)
        expect(readFileSync(marker, "utf8").trim()).toBe(resolved.commit)
        // 快照可作为 Lua 数据根直接解析（独立实例，避免污染测试单例）
        const dm = new LuaDataManager()
        dm.setDataRoot(dir)
        const skill = dm.getTable("Skill") as Record<string, unknown> | undefined
        expect(skill).toBeDefined()
    })
})
