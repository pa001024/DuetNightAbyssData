/**
 * 表条目访问帮助：兼容数字/字符串键（Skill 等表顶层键是数字）。
 */
export function getEntry2(table: Record<string, any> | undefined, id: number | string): any {
    if (!table) return undefined
    let e = table[String(id)]
    if (e === undefined) e = table[id as number]
    return e
}
