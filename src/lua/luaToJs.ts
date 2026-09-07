/**
 * Lua table → JS 递归转换（读回工具）。
 *
 * 对齐旧版 Lua 转换的 convert_lua_data 启发式：
 * - 连续整数键 1..n 的表 → JS 数组
 * - 否则 → JS 对象（数字键字符串化，JS 属性访问 obj[110101] 与 obj["110101"] 等价，
 *   与老处理器 str(id) 访问对齐）
 *
 * 注意：不做旧 Lua 转换的"奖励表豁免"（含 Id/Type/Count 字段的表不转数组）。
 * 新架构直接读原始表，保持原始形状更忠实；必要时对比时再按需对齐。
 */

import type { LuaState } from "fengari"
import { lua, to_jsstring } from "fengari"

const LUA_TNIL = lua.LUA_TNIL
const LUA_TNUMBER = lua.LUA_TNUMBER
const LUA_TSTRING = lua.LUA_TSTRING
const LUA_TBOOLEAN = lua.LUA_TBOOLEAN
const LUA_TTABLE = lua.LUA_TTABLE
const LUA_TFUNCTION = lua.LUA_TFUNCTION

const MAX_DEPTH = 60

/** 单个值的类型 */
export type LuaValue = null | boolean | number | string | LuaValue[] | { [k: string]: LuaValue }

function keyToJs(L: LuaState, idx: number): number | string {
    const t = lua.lua_type(L, idx)
    if (t === LUA_TNUMBER) return lua.lua_tonumber(L, idx)
    if (t === LUA_TSTRING) {
        const s = lua.lua_tostring(L, idx)
        return s ? to_jsstring(s) : ""
    }
    return `[lua-type-${t}]`
}

function valueToJs(L: LuaState, idx: number, depth: number): LuaValue {
    const t = lua.lua_type(L, idx)
    switch (t) {
        case LUA_TNIL:
            return null
        case LUA_TBOOLEAN:
            return lua.lua_toboolean(L, idx)
        case LUA_TNUMBER:
            return lua.lua_tonumber(L, idx)
        case LUA_TSTRING: {
            const s = lua.lua_tostring(L, idx)
            return s ? to_jsstring(s) : ""
        }
        case LUA_TTABLE:
            return tableToJs(L, idx, depth)
        case LUA_TFUNCTION:
            return "<fn>"
        default:
            return null
    }
}

function tableToJs(L: LuaState, idx: number, depth: number): LuaValue {
    if (depth > MAX_DEPTH) return "[deep]"
    const abs = lua.lua_absindex(L, idx)
    const n = lua.lua_rawlen(L, abs)

    // 第一遍：统计键，判断是否数组（1..n 连续整数键且数量==n）
    const keys: Array<number | string> = []
    let isArray = true
    lua.lua_pushnil(L)
    while (lua.lua_next(L, abs) !== 0) {
        const t = lua.lua_type(L, -2)
        const k = keyToJs(L, -2)
        if (!(t === LUA_TNUMBER && Number.isInteger(k) && (k as number) >= 1)) {
            isArray = false
        }
        keys.push(k)
        lua.lua_pop(L, 1)
    }

    const hasContinuousIntegerKeys =
        isArray && n > 0 && keys.length === n && keys.every(key => Number.isInteger(key) && (key as number) >= 1 && (key as number) <= n)
    if (hasContinuousIntegerKeys) {
        const arr: LuaValue[] = new Array(n)
        for (let i = 1; i <= n; i++) {
            lua.lua_rawgeti(L, abs, i)
            arr[i - 1] = valueToJs(L, -1, depth + 1)
            lua.lua_pop(L, 1)
        }
        return arr
    }

    const obj: { [k: string]: LuaValue } = {}
    lua.lua_pushnil(L)
    while (lua.lua_next(L, abs) !== 0) {
        obj[String(keyToJs(L, -2))] = valueToJs(L, -1, depth + 1)
        lua.lua_pop(L, 1)
    }
    return obj
}

/**
 * 把栈顶的 Lua 值（表）递归转换为 JS。
 * 不会改动栈深度（转换后弹出）。
 */
export function luaValueToJs(L: LuaState, idx: number): LuaValue {
    const abs = lua.lua_absindex(L, idx)
    const result = valueToJs(L, abs, 0)
    return result
}
