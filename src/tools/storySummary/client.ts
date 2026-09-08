/**
 * storysummary LLM 客户端 —— OpenAI 兼容的 chat/completions 单次调用。
 * baseUrl 形如 https://api.deepseek.com/v1（DeepSeek）或 https://api.openai.com/v1（OpenAI），
 * 端点按 `${baseUrl}/chat/completions` 拼接。
 * 除基础健壮性检查（空响应/过短）外，还对“人称”做硬校验：总结必须固定第二人称“你”，
 * 正文（含引号内）不得出现“我/我们/主角/玩家”等词，违规视为生成失败，交由重试。
 */

export interface ClientOptions {
    apiKey: string
    baseUrl: string
    model: string
    timeoutMs: number
}

export type GenerateResult = { ok: true; summary: string } | { ok: false; error: string }

/** 人称违禁词（“我”同时覆盖“我们”）；总结正文禁止出现，包括引号内的台词引用 */
const FORBIDDEN_PERSON_WORDS = ["我", "主角", "玩家"] as const

/** 返回命中的首个违禁词；未命中返回 undefined。暴露给测试做断言。 */
export function findPersonViolation(text: string): string | undefined {
    return FORBIDDEN_PERSON_WORDS.find(word => text.includes(word))
}

/** 组装 chat 请求体（暴露给测试做断言） */
export function chatRequestBody(prompt: string): Record<string, unknown> {
    return {
        messages: [
            {
                role: "system",
                content:
                    "你是游戏剧情档案编辑，擅长把任务链的原始对白与目标整理成连贯、准确、面向普通读者的中文剧情总结。你只依据给定材料写作，绝不虚构。",
            },
            { role: "user", content: prompt },
        ],
        temperature: 0.6,
        // DeepSeek 系列模型会先产出 reasoning 再写正文；上限太小时思考占满预算会致 content 为空
        // （finish_reason=length）。个别链思考可达数千 token，给足预算让“思考 + ≤200字正文”都能放下。
        max_tokens: 8192,
    }
}

function extractSummary(content: string): string {
    let value = content.trim()
    // 容忍模型把总结包成 JSON/代码块
    const jsonBlock = value.match(/```(?:json)?\s*([\s\S]*?)```/)
    if (jsonBlock) value = jsonBlock[1].trim()
    if (value.startsWith("{")) {
        try {
            const parsed = JSON.parse(value) as Record<string, unknown>
            const summary = typeof parsed.summary === "string" ? parsed.summary : typeof parsed.text === "string" ? parsed.text : ""
            if (summary.trim()) return summary.trim()
        } catch {
            // 非合法 JSON，按纯文本处理
        }
    }
    return value
}

export interface ChatClient {
    /** 发送一次请求并返回总结文本 */
    summarize(prompt: string): Promise<GenerateResult>
}

export function createChatClient(options: ClientOptions): ChatClient {
    return {
        async summarize(prompt: string): Promise<GenerateResult> {
            const body = { ...chatRequestBody(prompt), model: options.model }
            let response: Response
            try {
                response = await fetch(`${options.baseUrl.replace(/\/+$/, "")}/chat/completions`, {
                    method: "POST",
                    headers: {
                        "content-type": "application/json",
                        authorization: `Bearer ${options.apiKey}`,
                    },
                    body: JSON.stringify(body),
                    signal: AbortSignal.timeout(options.timeoutMs),
                })
            } catch (error) {
                return { ok: false, error: `请求失败: ${error instanceof Error ? error.message : String(error)}` }
            }
            if (!response.ok) {
                const detail = await response.text().catch(() => "")
                return { ok: false, error: `HTTP ${response.status} ${response.statusText}${detail ? `: ${detail.slice(0, 300)}` : ""}` }
            }
            let payload: Record<string, any>
            try {
                payload = (await response.json()) as Record<string, any>
            } catch (error) {
                return { ok: false, error: `响应不是合法 JSON: ${error instanceof Error ? error.message : String(error)}` }
            }
            const content: unknown = payload?.choices?.[0]?.message?.content
            if (typeof content !== "string" || !content.trim()) {
                return { ok: false, error: "模型返回空内容" }
            }
            const summary = extractSummary(content)
            if (summary.length < 20) return { ok: false, error: "模型输出过短，判定为生成失败" }
            const violation = findPersonViolation(summary)
            if (violation) {
                return { ok: false, error: `人称违规：正文出现“${violation}”（须固定第二人称“你”，禁止 我/我们/主角/玩家，含引号内）` }
            }
            return { ok: true, summary }
        },
    }
}
