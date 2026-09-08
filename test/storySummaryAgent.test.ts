import { afterAll, beforeAll, describe, expect, test } from "bun:test"
import { existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs"
import { join } from "node:path"
import { runStorySummary } from "../src/tools/storySummary/agent.ts"
import { findPersonViolation } from "../src/tools/storySummary/client.ts"
import { buildChainDigest, buildPrompt, collectChainDigests, loadCnContext, truncateText } from "../src/tools/storySummary/context.ts"
import { buildOutputObject } from "../src/tools/storySummary/output.ts"
import { pendingChainIds, loadState } from "../src/tools/storySummary/state.ts"

const projectRoot = join(import.meta.dir, "..")
const tmpRoot = join(projectRoot, ".tmp", "storysummary-test")

const cnDir = join(tmpRoot, "cn")
const manifestFile = join(tmpRoot, "state.json")
const outputFile = join(cnDir, "storySummary.json")

function writeJson(file: string, value: unknown): void {
    writeFileSync(file, `${JSON.stringify(value, null, 2)}\n`, "utf8")
}

function readJson(file: string): Record<string, unknown> {
    return JSON.parse(readFileSync(file, "utf8")) as Record<string, unknown>
}

type FakeResult = { ok: true; summary: string } | { ok: false; error: string }

/** 修改链 100101 的 quest 10010101 第一条对白，模拟剧情内容变化 */
function setFirstDialogue(stories: Record<string, unknown>[], content: string): void {
    const quests = stories[0].quests as Record<string, unknown>[]
    const quest = quests[1] as { nodes?: unknown[] }
    const node = quest.nodes?.[0] as { dialogues?: unknown[] }
    const dialogues = node.dialogues as Record<string, unknown>[]
    dialogues[0].content = content
}

/** 剧情链元数据：100101 有对白；200201 无对白链（story 无对白）；300301 只在 story 里出现 */
function chainsFixture(): Record<string, unknown>[] {
    return [
        {
            id: 100101,
            name: "逃离净界岛",
            chapterName: "夜航篇",
            chapterNumber: "序章",
            quests: [{ id: 10010101 }, { id: 10010102 }, { id: 10010103 }, { id: 10010104 }],
        },
        { id: 200201, name: "无对白链", quests: [{ id: 20020101 }] },
    ]
}

function storiesFixture(): Record<string, unknown>[] {
    return [
        {
            id: 100101,
            quests: [
                // story 内任务乱序，最终顺序应跟随 QuestChain 的 quests 数组
                {
                    id: 10010103,
                    name: "第三个任务",
                    nodes: [
                        {
                            type: "TalkNode",
                            dialogues: [{ id: 5, content: "第三个任务的对话。", npc: 100003 }],
                        },
                    ],
                },
                {
                    id: 10010101,
                    name: "起始",
                    nodes: [
                        {
                            type: "TalkNode",
                            dialogues: [{ id: 1, content: "第一句对白。", npc: 100001 }, { id: 2, content: "", voice: "v" }],
                        },
                    ],
                },
                {
                    id: 10010102,
                    name: "抉择",
                    nodes: [
                        {
                            type: "TalkNode",
                            dialogues: [{ id: 3, content: "提问。", options: [{ content: "选项甲" }, { content: "选项乙" }] }],
                        },
                    ],
                },
                // 无 TalkNode 的任务不产出对白行
                { id: 10010104, name: "跑图", nodes: [{ type: "PlayOrStopBGMNode", name: "bgm" }] },
            ],
        },
        // 200201 存在但没有对白（BGM 任务）→ 不应进入 digest
        { id: 200201, quests: [{ id: 20020101, nodes: [{ type: "PlayOrStopBGMNode" }] }] },
        // 300301 无链元数据但有对白 → 仍应进入 digest（名称回退）
        { id: 300301, quests: [{ id: 30030101, nodes: [{ type: "TalkNode", dialogues: [{ id: 9, content: "无名链对白。" }] }] }] },
    ]
}

function writeFixtures(stories: Record<string, unknown>[] = storiesFixture()): void {
    mkdirSync(cnDir, { recursive: true })
    writeJson(join(cnDir, "QuestChain.json"), chainsFixture())
    writeJson(join(cnDir, "QuestStory.json"), stories)
}

function digestsOf(): ReturnType<typeof collectChainDigests> {
    return collectChainDigests(loadCnContext(cnDir))
}

function resetGeneratedState(): void {
    rmSync(manifestFile, { force: true })
    rmSync(outputFile, { force: true })
}

beforeAll(() => {
    rmSync(tmpRoot, { recursive: true, force: true })
    mkdirSync(tmpRoot, { recursive: true })
})

afterAll(() => {
    rmSync(tmpRoot, { recursive: true, force: true })
})

describe("context", () => {
    test("只保留含对白的链，任务顺序跟随 QuestChain，选项展开", () => {
        writeFixtures()
        const digests = digestsOf()
        expect([...digests.keys()].sort((a, b) => a - b)).toEqual([100101, 300301])
        const chain = digests.get(100101)!
        expect(chain.quests.map(q => q.questId)).toEqual([10010101, 10010102, 10010103])
        expect(chain.dialogueLines).toBe(5) // 起点 1 + 提问 1 + 选项 2 + 第三个任务 1
        expect(chain.text).toContain("【剧情链 100101】逃离净界岛")
        expect(chain.text).toContain("[npc 100001] 第一句对白。")
        expect(chain.text).toContain("- 选项甲")
        // 任务顺序跟随 QuestChain（story 里 10010103 排最前，输出仍按链顺序）
        const idx1 = chain.text.indexOf("【任务 10010101】")
        const idx2 = chain.text.indexOf("【任务 10010102】")
        const idx3 = chain.text.indexOf("【任务 10010103】")
        expect(idx1).toBeGreaterThanOrEqual(0)
        expect(idx1).toBeLessThan(idx2)
        expect(idx2).toBeLessThan(idx3)
        expect(chain.text).not.toContain("200201")
    })

    test("无元数据链名称回退，指纹随内容变化且稳定", () => {
        writeFixtures()
        const first = digestsOf().get(100101)!
        const orphan = buildChainDigest(undefined, storiesFixture().at(-1) as Record<string, unknown>)
        expect(orphan.meta).toEqual({})
        expect(orphan.dialogueLines).toBe(1)
        const mutated = structuredClone(storiesFixture())
        setFirstDialogue(mutated, "内容变了。")
        writeFixtures(mutated)
        const changed = digestsOf().get(100101)!
        expect(changed.fingerprint).not.toBe(first.fingerprint)
        // 内容未变时指纹稳定
        writeFixtures()
        expect(digestsOf().get(100101)!.fingerprint).toBe(first.fingerprint)
    })

    test("超长文本保留首尾截断", () => {
        const text = "a".repeat(100)
        const truncated = truncateText(text, 40)
        expect(truncated.length).toBeGreaterThan(40)
        expect(truncated.length).toBeLessThan(100)
        expect(truncated.startsWith("a".repeat(24))).toBe(true)
        expect(truncated.endsWith("a".repeat(16))).toBe(true)
        expect(truncateText("短文本", 40)).toBe("短文本")
    })

    test("提示词固定第二人称：含人称约束，禁止“我/我们/主角/玩家”且不直接引用对白", () => {
        writeFixtures()
        const prompt = buildPrompt(digestsOf().get(100101)!, 60_000)
        expect(prompt).toContain("人称与引用：全文用第二人称“你”指代玩家角色")
        expect(prompt).toContain("正文禁止出现“我”“我们”“主角”“玩家”")
        expect(prompt).toContain("不得直接引用对白原话")
    })
})

describe("state 与 output", () => {
    test("pending 判定：缺失、指纹变化、force", () => {
        const digests = new Map<number, { fingerprint: string }>([
            [1, { fingerprint: "a" }],
            [2, { fingerprint: "b" }],
        ])
        const ledger = { "1": { fingerprint: "a", updatedAt: "" } }
        expect(pendingChainIds(digests, ledger, false)).toEqual([2])
        expect(pendingChainIds(digests, { "1": { fingerprint: "old", updatedAt: "" } }, false)).toEqual([1, 2])
        expect(pendingChainIds(digests, ledger, true)).toEqual([1, 2])
    })

    test("loadState 迁移：丢弃旧账本里的 summary 正文（final 才是唯一权威）", () => {
        const legacy = {
            "1": { summary: "旧正文", fingerprint: "a", updatedAt: "" },
            "2": { fingerprint: "b", updatedAt: "" },
            "3": "不是对象",
        }
        writeJson(manifestFile, legacy)
        const ledger = loadState(manifestFile)
        expect(ledger["1"]).toEqual({ fingerprint: "a", updatedAt: "" })
        expect(ledger["2"]).toEqual({ fingerprint: "b", updatedAt: "" })
        expect(ledger["3"]).toBeUndefined()
        expect("summary" in ledger["1"]!).toBe(false)
    })

    test("输出对象只含既有总结的链且按 id 升序", () => {
        const summaries = { "1": "s1", "3": "s3" }
        expect(buildOutputObject(summaries, new Set([1, 2, 3]))).toEqual({ "1": "s1", "3": "s3" })
        expect(buildOutputObject({ "1": "" }, new Set([1]))).toEqual({})
    })
})

describe("agent 编排", () => {
    function fakeGenerate(calls: string[], failFor?: (prompt: string) => boolean) {
        return async (prompt: string): Promise<FakeResult> => {
            calls.push(prompt)
            if (failFor?.(prompt)) return { ok: false, error: "注入失败" }
            const head = prompt.split("\n")[0]
            return { ok: true, summary: `这是针对「${head}」生成的剧情总结文本，长度满足要求。` }
        }
    }

    function options(overrides: Partial<Parameters<typeof runStorySummary>[0]> = {}) {
        return { cnDir, manifestFile, outputFile, dryRun: false, force: false, concurrency: 1, ...overrides }
    }

    test("dry-run：不调用生成、不写状态与输出", async () => {
        writeFixtures()
        resetGeneratedState()
        const calls: string[] = []
        const stats = await runStorySummary(options({ dryRun: true, generate: fakeGenerate(calls) }))
        expect(stats.pending).toBe(2)
        expect(stats.generated).toBe(0)
        expect(calls).toEqual([])
        expect(existsSync(manifestFile)).toBe(false)
        expect(existsSync(outputFile)).toBe(false)
    })

    test("单步模式（limit 1）：每次只生成 1 条并落盘，逐次推进到完成", async () => {
        writeFixtures()
        resetGeneratedState()
        const calls: string[] = []
        const generate = fakeGenerate(calls)

        // 第一步：只生成 100101（pending 升序取前 1），状态与输出即时落盘
        const first = await runStorySummary(options({ limit: 1, generate }))
        expect(first.eligible).toBe(2)
        expect(first.pending).toBe(1)
        expect(first.generated).toBe(1)
        expect(first.failed).toBe(0)
        expect(calls).toHaveLength(1)
        expect(calls[0]).toContain("【剧情链 100101】")
        expect(readJson(manifestFile)["100101"]).toBeTruthy()
        expect(Object.keys(readJson(outputFile))).toEqual(["100101"])

        // 第二步：继续单步，只生成 300301
        const second = await runStorySummary(options({ limit: 1, generate }))
        expect(second.generated).toBe(1)
        expect(calls).toHaveLength(2)
        expect(calls[1]).toContain("【剧情链 300301】")
        expect(Object.keys(readJson(outputFile))).toEqual(["100101", "300301"])

        // 第三步：无剩余，limit 不触发任何调用
        const third = await runStorySummary(options({ limit: 1, generate }))
        expect(third.pending).toBe(0)
        expect(third.generated).toBe(0)
        expect(calls).toHaveLength(2)
    })

    test("limit 限量不改变 stats.pending 语义，limit 大于待生成数时等同全量", async () => {
        writeFixtures()
        resetGeneratedState()
        const calls: string[] = []
        const generate = fakeGenerate(calls)
        const stats = await runStorySummary(options({ limit: 5, generate }))
        expect(stats.pending).toBe(2)
        expect(stats.generated).toBe(2)
        expect(calls).toHaveLength(2)
    })

    test("dry-run 与单步模式组合：只预览前 1 条，仍不触网不写盘", async () => {
        writeFixtures()
        resetGeneratedState()
        const calls: string[] = []
        const stats = await runStorySummary(options({ dryRun: true, limit: 1, generate: fakeGenerate(calls) }))
        expect(stats.pending).toBe(1)
        expect(stats.generated).toBe(0)
        expect(calls).toEqual([])
        expect(existsSync(manifestFile)).toBe(false)
        expect(existsSync(outputFile)).toBe(false)
    })

    test("真实运行生成缺失项；再次运行无变更时零调用", async () => {
        writeFixtures()
        resetGeneratedState()
        const calls: string[] = []
        const generate = fakeGenerate(calls)
        const first = await runStorySummary(options({ generate }))
        expect(first.eligible).toBe(2)
        expect(first.generated).toBe(2)
        expect(first.failed).toBe(0)
        expect(calls).toHaveLength(2)
        expect(readJson(manifestFile)).toBeTruthy()
        const output = readJson(outputFile)
        expect(Object.keys(output)).toEqual(["100101", "300301"])

        const second = await runStorySummary(options({ generate }))
        expect(second.pending).toBe(0)
        expect(second.generated).toBe(0)
        expect(calls).toHaveLength(2) // 无新增调用
    })

    test("剧情内容变化只重生成对应链", async () => {
        writeFixtures()
        resetGeneratedState()
        const calls: string[] = []
        const generate = fakeGenerate(calls)
        await runStorySummary(options({ generate }))
        expect(calls).toHaveLength(2)

        const mutated = structuredClone(storiesFixture())
        setFirstDialogue(mutated, "第一句对白（已改动）。")
        writeFixtures(mutated)
        await runStorySummary(options({ generate }))
        expect(calls).toHaveLength(3) // 只新增一次
        expect(calls.at(-1)).toContain("【剧情链 100101】")
        expect(calls.at(-1)).not.toContain("【剧情链 300301】")
    })

    test("final 是唯一权威：删除某条后重跑会重新生成，不静默从账本恢复", async () => {
        writeFixtures()
        resetGeneratedState()
        const calls: string[] = []
        const generate = fakeGenerate(calls)
        await runStorySummary(options({ generate }))
        expect(calls).toHaveLength(2)
        expect(Object.keys(readJson(outputFile))).toEqual(["100101", "300301"])

        // 模拟用户从 final 输出删除 300301 这条总结
        const before = readJson(outputFile) as Record<string, string>
        writeJson(outputFile, { "100101": before["100101"] })

        const second = await runStorySummary(options({ generate }))
        expect(second.pending).toBe(1)
        expect(second.generated).toBe(1)
        expect(second.failed).toBe(0)
        // 关键：删除必须触发一次新的生成调用（而非从缓存里原样捞回）
        expect(calls).toHaveLength(3)
        expect(calls.at(-1)).toContain("【剧情链 300301】")
        // 未删除的 100101 不被重生成，正文原样保留
        expect(readJson(outputFile)["100101"]).toBe(before["100101"])
        expect(Object.keys(readJson(outputFile))).toEqual(["100101", "300301"])
        // 账本只记指纹，不保存总结正文
        const ledger = readJson(manifestFile) as Record<string, { summary?: string }>
        expect(ledger["100101"]).not.toHaveProperty("summary")
        expect(ledger["300301"]).not.toHaveProperty("summary")
    })

    test("final 删除 + 单步模式：--limit 1 只重生成被删的那一条", async () => {
        writeFixtures()
        resetGeneratedState()
        const calls: string[] = []
        const generate = fakeGenerate(calls)
        await runStorySummary(options({ generate }))
        const before = readJson(outputFile) as Record<string, string>

        // 删除 100101 后单步：下一次只重生成 100101，300301 不受影响
        writeJson(outputFile, { "300301": before["300301"] })
        const step = await runStorySummary(options({ limit: 1, generate }))
        expect(step.pending).toBe(1)
        expect(step.generated).toBe(1)
        expect(calls.at(-1)).toContain("【剧情链 100101】")
        expect(readJson(outputFile)["300301"]).toBe(before["300301"])
        expect(Object.keys(readJson(outputFile))).toEqual(["100101", "300301"])

        // 再次单步：无剩余，不触网
        const done = await runStorySummary(options({ limit: 1, generate }))
        expect(done.pending).toBe(0)
        expect(done.generated).toBe(0)
    })

    test("失败链留待下次重试，其余正常落盘", async () => {
        writeFixtures()
        resetGeneratedState()
        const calls: string[] = []
        const fail300301 = (prompt: string) => prompt.includes("【剧情链 300301】")
        const first = await runStorySummary(options({ generate: fakeGenerate(calls, fail300301) }))
        expect(first.generated).toBe(1)
        expect(first.failed).toBe(1)
        expect(first.failedIds).toEqual([300301])
        // 换一个不再失败的生成器重跑：300301 在账本中仍缺失，只补它
        const second = await runStorySummary(options({ generate: fakeGenerate(calls) }))
        expect(second.generated).toBe(1)
        expect(second.failed).toBe(0)
        expect(readJson(manifestFile)["300301"]).toBeTruthy()
        const output = readJson(outputFile)
        expect(Object.keys(output)).toEqual(["100101", "300301"])
    })

    test("无 manifest 时从已提交输出回灌，不再调用 API", async () => {
        writeFixtures()
        rmSync(manifestFile, { force: true })
        writeJson(outputFile, { "100101": "旧总结一。", "300301": "旧总结二。" })
        const calls: string[] = []
        const stats = await runStorySummary(options({ generate: fakeGenerate(calls, () => true) }))
        expect(stats.pending).toBe(0)
        expect(calls).toEqual([])
        expect(existsSync(manifestFile)).toBe(true)
        const output = readJson(outputFile)
        expect(output["100101"]).toBe("旧总结一。")
    })

    test("待生成且无 API key 且无注入生成时直接报错（不触网）", async () => {
        writeFixtures()
        resetGeneratedState()
        let error: unknown
        try {
            await runStorySummary(options({ apiKey: "" }))
        } catch (caught) {
            error = caught
        }
        expect(String(error)).toContain("API key")
    })
})

describe("client 人称硬校验", () => {
    test("命中违禁词：我（含我们）、主角、玩家；干净文本不误伤", () => {
        expect(findPersonViolation("你和贝蕾妮卡必须逃离这座岛。")).toBeUndefined()
        expect(findPersonViolation("这里曾是“我们”的家。")).toBe("我")
        expect(findPersonViolation("她告诉你这里有飞艇。")).toBeUndefined()
        expect(findPersonViolation("主角前往山顶遗迹。")).toBe("主角")
        expect(findPersonViolation("玩家角色在梦中惊醒。")).toBe("玩家")
    })
})
