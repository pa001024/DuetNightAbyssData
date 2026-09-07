/**
 * deepSort — 对齐旧版 Lua 转换输出的键排序。
 *
 * 递归排序 JSON 里的所有对象键：
 * - 数字键排最前，按数值序
 * - 数字字符串次之，按数值序
 * - 其他字符串按字典序
 * - 其他类型按字符串序
 */
export type SortableJson = null | boolean | number | string | SortableJson[] | { [k: string]: SortableJson }

function sortKeyOf(k: string): [number, number | string, string] {
    if (/^-?\d+(\.\d+)?$/.test(k)) {
        return [1, Number(k), k]
    }
    return [2, k, k]
}

export function deepSortJson(data: SortableJson): SortableJson {
    if (data === null || typeof data !== "object") return data
    if (Array.isArray(data)) return data.map(deepSortJson)

    const out: { [k: string]: SortableJson } = {}
    const keys = Object.keys(data).sort((a, b) => {
        const ka = sortKeyOf(a)
        const kb = sortKeyOf(b)
        if (ka[0] !== kb[0]) return ka[0] - kb[0]
        return ka[1] < kb[1] ? -1 : ka[1] > kb[1] ? 1 : 0
    })
    for (const k of keys) out[k] = deepSortJson(data[k])
    return out
}
