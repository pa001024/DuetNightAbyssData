/**
 * storysummary 持久化状态 —— 记录每链已生成的总结与内容指纹，实现“每次只生成缺失/变更部分”。
 *
 * manifest 文件位于 .cache/storysummary/state.json（.cache 已在 .gitignore），
 * 键为链 id 的字符串形式。写入采用临时文件 + rename 原子替换，避免中断留下半截 JSON。
 */
import { mkdirSync, readFileSync, renameSync, writeFileSync } from "node:fs"
import { dirname } from "node:path"

export interface SummaryRecord {
    summary: string
    /** 生成时所依据的剧情内容指纹（chain digest sha256） */
    fingerprint: string
    updatedAt: string
}

export type StoryState = Record<string, SummaryRecord>

export function loadState(file: string): StoryState {
    let raw: string
    try {
        raw = readFileSync(file, "utf8")
    } catch (error) {
        if ((error as NodeJS.ErrnoException).code === "ENOENT") return {}
        throw error
    }
    const parsed = JSON.parse(raw) as unknown
    if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
        throw new Error(`storysummary manifest 格式非法: ${file}`)
    }
    return parsed as StoryState
}

export function saveState(file: string, state: StoryState): void {
    mkdirSync(dirname(file), { recursive: true })
    const tmp = `${file}.tmp`
    writeFileSync(tmp, `${JSON.stringify(state, null, 2)}\n`, "utf8")
    renameSync(tmp, file)
}

/** 从已提交的 cn 输出回灌状态（仅当 manifest 尚不存在）：把现有总结视为最新，避免全新检出时全量重生成。 */
export function seedStateFromOutput(state: StoryState, output: StoryState): void {
    for (const [key, record] of Object.entries(output)) {
        if (!state[key] && record?.summary) state[key] = { ...record, updatedAt: record.updatedAt || new Date().toISOString() }
    }
}

/**
 * 判定待生成集合：缺失、指纹变化（剧情内容更新过）或 force。
 * 返回升序链 id。
 */
export function pendingChainIds(digests: ReadonlyMap<number, { fingerprint: string }>, state: StoryState, force: boolean): number[] {
    const pending: number[] = []
    for (const [idKey, digest] of digests) {
        const record = state[String(idKey)]
        if (force || !record || record.fingerprint !== digest.fingerprint) pending.push(Number(idKey))
    }
    return pending.sort((a, b) => a - b)
}
