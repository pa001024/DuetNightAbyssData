/**
 * storysummary LLM 客户端 —— OpenAI 兼容的 chat/completions 单次调用。
 * baseUrl 形如 https://api.deepseek.com/v1（DeepSeek）或 https://api.openai.com/v1（OpenAI），
 * 端点按 `${baseUrl}/chat/completions` 拼接。
 */

export interface ClientOptions {
    apiKey: string
    baseUrl: string
    model: string
    timeoutMs: number
}

export type GenerateResult = { ok: true; summary: string } | { ok: false; error: string }

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
        max_tokens: 1024,
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
            return { ok: true, summary }
        },
    }
}
