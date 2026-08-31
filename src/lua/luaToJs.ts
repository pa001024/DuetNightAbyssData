/**
 * Lua table → JS 递归转换（读回工具）。
 *
 * 对齐 python step1_convert.py 的 convert_lua_data 启发式：
 * - 连续整数键 1..n 的表 → JS 数组
 * - 否则 → JS 对象（数字键字符串化，JS 属性访问 obj[110101] 与 obj["110101"] 等价，
 *   与老处理器 str(id) 访问对齐）
 *
 * 注意：不做 step1 的"奖励表豁免"（含 Id/Type/Count 字段的表不转数组）。
 * 新架构直接读原始表，保持原始形状更忠实；必要时对比时再按需对齐。
 */

import type { LuaState } from "fengari"
import { lauxlib, lua, to_jsstring } from "fengari"

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

    // 先把值移入 registry，再递归读取；否则父表迭代栈会和嵌套表同时增长，深故事数据会撑爆 Fengari 栈。
    const entries: Array<{ key: number | string; ref: number }> = []
    let isArray = true
    lua.lua_pushnil(L)
    while (lua.lua_next(L, abs) !== 0) {
        const t = lua.lua_type(L, -2)
        const k = keyToJs(L, -2)
        if (!(t === LUA_TNUMBER && Number.isInteger(k) && (k as number) >= 1)) {
            isArray = false
        }
        lua.lua_pushvalue(L, -1)
        const ref = lauxlib.luaL_ref(L, lua.LUA_REGISTRYINDEX)
        entries.push({ key: k, ref })
        lua.lua_pop(L, 1)
    }

    const hasContinuousIntegerKeys =
        isArray && n > 0 && entries.length === n && entries.every(({ key }) => Number.isInteger(key) && (key as number) >= 1 && (key as number) <= n)
    if (hasContinuousIntegerKeys) {
        const arr: LuaValue[] = new Array(n)
        for (let i = 1; i <= n; i++) {
            const entry = entries.find(item => item.key === i)!
            lua.lua_rawgeti(L, lua.LUA_REGISTRYINDEX, entry.ref)
            arr[i - 1] = valueToJs(L, -1, depth + 1)
            lua.lua_pop(L, 1)
            lauxlib.luaL_unref(L, lua.LUA_REGISTRYINDEX, entry.ref)
        }
        return arr
    }

    const obj: { [k: string]: LuaValue } = {}
    for (const entry of entries) {
        lua.lua_rawgeti(L, lua.LUA_REGISTRYINDEX, entry.ref)
        obj[String(entry.key)] = valueToJs(L, -1, depth + 1)
        lua.lua_pop(L, 1)
        lauxlib.luaL_unref(L, lua.LUA_REGISTRYINDEX, entry.ref)
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
