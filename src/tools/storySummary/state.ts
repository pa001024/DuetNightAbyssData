/**
 * storysummary 指纹账本 —— 记录每条已生成总结的链在生成时对应的剧情内容指纹与时间。
 *
 * 已生成总结的唯一权威是 final/i18n/cn/storySummary.json：总结正文只存于 final，不存于此。
 * 账本只是本地可丢弃的增量书签（.cache，gitignored），用于判断剧情内容是否变化、避免无谓重生成：
 * - 账本缺失时可按 final 回补（把 final 中已有的链视为已按当前内容生成）；
 * - final 中删除的条目会被对账清除，下次运行视为未生成、重新生成，绝不从账本复活正文。
 *
 * manifest 键为链 id 的字符串形式。写入采用临时文件 + rename 原子替换，避免中断留下半截 JSON。
 */
import { mkdirSync, readFileSync, renameSync, writeFileSync } from "node:fs"
import { dirname } from "node:path"

export interface LedgerRecord {
    /** 生成总结时所依据的剧情内容指纹（chain digest sha256） */
    fingerprint: string
    updatedAt: string
}

export type StoryLedger = Record<string, LedgerRecord>

export function loadState(file: string): StoryLedger {
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
    // 兼容旧格式：只保留指纹与时间，丢弃曾存的总结正文（final 才是正文唯一权威）
    const result: StoryLedger = {}
    for (const [key, record] of Object.entries(parsed as Record<string, unknown>)) {
        if (record && typeof record === "object" && !Array.isArray(record) && typeof (record as LedgerRecord).fingerprint === "string") {
            result[key] = {
                fingerprint: (record as LedgerRecord).fingerprint,
                updatedAt: typeof (record as LedgerRecord).updatedAt === "string" ? (record as LedgerRecord).updatedAt : "",
            }
        }
    }
    return result
}

export function saveState(file: string, state: StoryLedger): void {
    mkdirSync(dirname(file), { recursive: true })
    const tmp = `${file}.tmp`
    writeFileSync(tmp, `${JSON.stringify(state, null, 2)}\n`, "utf8")
    renameSync(tmp, file)
}

/**
 * 判定待生成集合：账本中缺失（含 final 中刚被删除、对账已清除的链）、指纹变化（剧情内容更新过）
 * 或 force。返回升序链 id。
 */
export function pendingChainIds(digests: ReadonlyMap<number, { fingerprint: string }>, state: StoryLedger, force: boolean): number[] {
    const pending: number[] = []
    for (const [idKey, digest] of digests) {
        const record = state[String(idKey)]
        if (force || !record || record.fingerprint !== digest.fingerprint) pending.push(Number(idKey))
    }
    return pending.sort((a, b) => a - b)
}
