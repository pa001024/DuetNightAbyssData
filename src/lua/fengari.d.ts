/**
 * fengari 最小类型声明（fengari 无官方 .d.ts）。
 * 仅覆盖本项目用到的 API 面；其余按需要扩展。
 */

declare module "fengari" {
    /** Lua 字符串在 fengari 里是 Uint8Array */
    export type luastring = Uint8Array
    /** 不透明的 Lua state 句柄 */
    export interface LuaState {
        [key: string]: any
    }

    export const lua: {
        // 类型常量
        readonly LUA_TNONE: number
        readonly LUA_TNIL: number
        readonly LUA_TBOOLEAN: number
        readonly LUA_TLIGHTUSERDATA: number
        readonly LUA_TNUMBER: number
        readonly LUA_TSTRING: number
        readonly LUA_TTABLE: number
        readonly LUA_TFUNCTION: number
        readonly LUA_TUSERDATA: number
        readonly LUA_TTHREAD: number
        // 返回码
        readonly LUA_OK: number
        readonly LUA_ERRRUN: number
        readonly LUA_ERRSYNTAX: number
        readonly LUA_ERRMEM: number
        readonly LUA_ERRERR: number

        lua_gettop(L: LuaState): number
        lua_settop(L: LuaState, idx: number): void
        lua_pop(L: LuaState, n: number): void
        lua_absindex(L: LuaState, idx: number): number
        lua_pushvalue(L: LuaState, idx: number): void
        lua_type(L: LuaState, idx: number): number
        lua_typename(L: LuaState, t: number): luastring
        lua_toboolean(L: LuaState, idx: number): boolean
        lua_tonumber(L: LuaState, idx: number): number
        lua_tostring(L: LuaState, idx: number): luastring | null
        lua_tolstring(L: LuaState, idx: number, len?: null): luastring | null
        lua_rawlen(L: LuaState, idx: number): number

        lua_pushnil(L: LuaState): void
        lua_pushnumber(L: LuaState, n: number): void
        lua_pushinteger(L: LuaState, n: number): void
        lua_pushlstring(L: LuaState, s: luastring, len?: number): void
        lua_pushstring(L: LuaState, s: luastring): void
        lua_pushboolean(L: LuaState, b: boolean): void
        lua_pushcfunction(L: LuaState, fn: (L: LuaState) => number): void
        lua_pushlightuserdata(L: LuaState, p: unknown): void

        lua_createtable(L: LuaState, narr?: number, nrec?: number): void
        lua_newtable(L: LuaState): void
        lua_getglobal(L: LuaState, name: string): void
        lua_setglobal(L: LuaState, name: string): void
        lua_getfield(L: LuaState, idx: number, k: string): void
        lua_setfield(L: LuaState, idx: number, k: string): void
        lua_gettable(L: LuaState, idx: number): void
        lua_settable(L: LuaState, idx: number): void
        lua_rawget(L: LuaState, idx: number): void
        lua_rawset(L: LuaState, idx: number): void
        lua_rawgeti(L: LuaState, idx: number, n: number): void
        lua_rawseti(L: LuaState, idx: number, n: number): void
        lua_geti(L: LuaState, idx: number, n: number): void
        lua_seti(L: LuaState, idx: number, n: number): void

        lua_setmetatable(L: LuaState, idx: number): void
        lua_getmetatable(L: LuaState, idx: number): void

        lua_next(L: LuaState, idx: number): number
        lua_remove(L: LuaState, idx: number): void
        lua_insert(L: LuaState, idx: number): void
        lua_replace(L: LuaState, idx: number): void
        lua_pcall(L: LuaState, nargs: number, nresults: number, errfunc: number): number
        lua_close(L: LuaState): void
    }

    export const lauxlib: {
        luaL_newstate(): LuaState
        luaL_openlibs(L: LuaState): void
        luaL_loadstring(L: LuaState, s: luastring): number
        luaL_loadbuffer(L: LuaState, s: luastring, size?: number, name?: string): number
        luaL_dostring(L: LuaState, s: luastring): number
        luaL_error(L: LuaState, fmt: string, ...args: any[]): number
        luaL_tolstring(L: LuaState, idx: number, len?: null): luastring | null
    }

    export const lualib: {
        luaL_openlibs(L: LuaState): void
    }

    export function to_luastring(str: string, encoding?: "utf-8"): luastring
    export function to_jsstring(buf: luastring): string
}
