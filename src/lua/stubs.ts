/**
 * Lua 全局环境桩（stubs）。
 *
 * 在 fengari 单例 state 里安装游戏所需的全局符号，使 Script/Datas/*.lua 与
 * Script/Utils（游戏真实引擎，根 Utils/ 将被删除）能在 VM 中执行：
 *
 * - ReadOnly: 数据文件 `return ReadOnly(name, tbl)` 直接返回 tbl
 * - GText / CText: 返回"哨兵串"（见下），数值计算串里文本 key 被哨兵包裹，
 *   TS 侧按哨兵拆分 → vnode 片段（数值段 + T(key)），语言无关
 * - DataMgr: 懒加载代理（__index 时加载 Script/Datas/{key}.lua），
 *   实际 loader 由 LuaDataManager 提供（需文件读取与缓存）
 * - GWorld / UE4 / Battle / CommonConst / CommonUtils: Script/Utils 运行时引用的全局
 * - CommonConst / Utils.X: package.preload 注册 Script/Utils 完整版
 * - UE4 / LoadClass 等: 数据文件偶发引用的运行时符号 → 哑桩
 */

import type { LuaState } from "fengari"
import { lauxlib, lua, to_jsstring, to_luastring } from "fengari"

/** GText/CText 哨兵：文本 key 在计算串里被 \x01GT{KEY}\x01 包裹 */
export const GT_PREFIX = "\x01GT{"
export const GT_SUFFIX = "}\x01"
export const GT_RE = /\x01GT\{([^}]*)\}\x01/g

export function sentinelOf(key: string): string {
    return `\x01GT{${key}}\x01`
}

/**
 * 安装基础的全局桩。
 * DataMgr 的 __index loader 由参数提供（LuaDataManager 需要文件系统与缓存）。
 */
export function installBaseStubs(L: LuaState, dataMgrIndexLoader: (L: LuaState, key: string) => void): void {
    lauxlib.luaL_dostring(
        L,
        to_luastring(`
ReadOnly = function(name, data) return data end
GText = function(k) return "\\1GT{" .. tostring(k) .. "}\\1" end
CText = function(k) return "\\1GT{" .. tostring(k) .. "}\\1" end
GWorld = { GameInstance = nil }
UE4 = { URuntimeCommonFunctionLibrary = { IsDistribution = function() return false end } }
Battle = function() return nil end
LoadClass = function() return {} end
IsValid = function(obj) return obj ~= nil end
DebugPrint = function() end
Const = {}
    `)
    )

    // DataMgr 懒加载代理：__index 时调用外部 loader
    lua.lua_newtable(L) // DataMgr
    lua.lua_newtable(L) // metatable
    lua.lua_pushcfunction(L, (LL: LuaState) => {
        const keyBuf = lua.lua_tostring(LL, 2)
        const key = keyBuf ? to_jsstring(keyBuf) : ""
        dataMgrIndexLoader(LL, key)
        return 1
    })
    lua.lua_setfield(L, -2, "__index")
    lua.lua_setmetatable(L, -2)
    lua.lua_setglobal(L, "DataMgr")

    // DataMgr 分片查询函数（TextMap_TextMapContent 等分区懒加载表依赖）
    // 对齐 DataMgr.lua 的 BinarySearch / QueryTable / GetPartitionData。
    // Partition 表结构：{{MinKey, MaxKey, Loader=function}, ...}，BinarySearch 找到分片后
    // 调用 Loader() 返回该分片表，再从中取 key。
    lauxlib.luaL_dostring(
        L,
        to_luastring(`
DataMgr.BinarySearch = function(Key, DataIndexTable)
  for _, Entry in ipairs(DataIndexTable or {}) do
    if Entry and Key >= Entry.MinKey and Key <= Entry.MaxKey then
      local Loader = Entry.Loader
      if type(Loader) == "function" then
        return Loader(), Entry.MinKey, Entry.MaxKey
      end
      return Loader, Entry.MinKey, Entry.MaxKey
    end
  end
  return nil
end
DataMgr.QueryTable = function(Key, FileName, Data)
  local PartitionData = DataMgr.BinarySearch(Key, Data)
  if not PartitionData or not PartitionData[Key] then
    return nil
  end
  return PartitionData[Key]
end
DataMgr.GetPartitionData = function(Key, Data)
  local PartitionData = DataMgr.BinarySearch(Key, Data)
  if not PartitionData or not PartitionData[Key] then
    return nil
  end
  return PartitionData
end
-- 用 Lua 的 pairs()（触发 __pairs 元方法）把分区懒加载表整个物化为普通表，供 JS 读回。
-- fengari 的 lua_next 不触发 __pairs，TextMap_TextMapContent 等分区懒加载表需要这个。
-- 直接接受表名（避免 JS 侧栈操作），返回物化后的普通表。
__materialize = function(name)
  local t = DataMgr[name]
  if type(t) ~= "table" then return nil end
  local m = {}
  for k, v in pairs(t) do
    m[k] = v
  end
  return m
end
    `)
    )
}

/**
 * 注册 package.preload[name] = loader（loader 执行文件并返回模块值）。
 * 文件不存在则不注册。
 */
export function preloadFile(L: LuaState, root: string, name: string, relPath: string, extraSetup?: string): boolean {
    const full = joinPath(root, relPath)
    if (!existsSyncSafe(full)) return false
    const code = readFileSafe(full)
    const setup = extraSetup ?? ""

    lua.lua_getglobal(L, "package")
    lua.lua_getfield(L, -1, "preload")
    lua.lua_pushcfunction(L, (LL: LuaState) => {
        if (setup) {
            if (lauxlib.luaL_dostring(LL, to_luastring(setup)) !== 0) {
                lua.lua_pop(LL, 1)
                return lauxlib.luaL_error(LL, `preload setup fail: ${name}`)
            }
        }
        if (lauxlib.luaL_loadstring(LL, to_luastring(code)) !== 0) {
            lua.lua_pop(LL, 1)
            return lauxlib.luaL_error(LL, `preload load fail: ${name}`)
        }
        if (lua.lua_pcall(LL, 0, 1, 0) !== 0) {
            lua.lua_pop(LL, 1)
            return lauxlib.luaL_error(LL, `preload run fail: ${name}`)
        }
        return 1 // 模块表
    })
    lua.lua_setfield(L, -2, name)
    lua.lua_pop(L, 2)
    return true
}

/** 注册 Datas.<name> 的 preload（数据文件，执行后返回其 return 值；失败返回 nil 不抛错） */
export function registerDatasPreload(L: LuaState, root: string, name: string): void {
    const file = joinPath(root, "Script", "Datas", `${name}.lua`)
    if (!existsSyncSafe(file)) return
    const code = readFileSafe(file)
    lua.lua_getglobal(L, "package")
    lua.lua_getfield(L, -1, "preload")
    lua.lua_pushcfunction(L, (LL: LuaState) => {
        if (lauxlib.luaL_loadstring(LL, to_luastring(code)) !== 0) {
            lua.lua_pop(LL, 1) // 错误信息
            lua.lua_pushnil(LL)
            return 1
        }
        if (lua.lua_pcall(LL, 0, 1, 0) !== 0) {
            lua.lua_pop(LL, 1) // 错误信息
            lua.lua_pushnil(LL)
            return 1
        }
        return 1 // return ReadOnly(...) 的表
    })
    lua.lua_setfield(L, -2, `Datas.${name}`)
    lua.lua_pop(L, 2)
}

/**
 * 注册 Script/Utils 完整版 + CommonConst 的 preload，并设置全局。
 *
 * Script/Utils 的依赖链与全局引用（根 Utils/ 将被删除，故用完整版）：
 * - CommonUtils 顶层 require("Utils.SerializeUtils")
 * - SkillUtils  顶层 require("Utils.StringUtils")；运行时引用全局 CommonUtils / GText /
 *   GWorld / UE4 / CommonConst
 * - ItemUtils   顶层 require("Utils.TimeUtils")；TimeUtils 顶层 require("CommonConst")
 * - SkillUtils.CalcSkillDesc 用全局 CommonConst.SystemLanguage 判断法语空格
 * 所以：CommonConst 既要 preload（供 require）也要设为全局（供直接引用）；
 * CommonUtils 设为全局（SkillUtils 直接引用）。
 */
export function installUtils(L: LuaState, root: string): void {
    // 依赖链先注册（按加载顺序）
    preloadFile(L, root, "Utils.SerializeUtils", "Script/Utils/SerializeUtils.lua")
    preloadFile(L, root, "Utils.StringUtils", "Script/Utils/StringUtils.lua")
    preloadFile(L, root, "CommonConst", "CommonConst.lua")
    preloadFile(L, root, "Utils.TimeUtils", "Script/Utils/TimeUtils.lua")
    preloadFile(L, root, "Utils.CommonUtils", "Script/Utils/CommonUtils.lua")
    preloadFile(L, root, "Utils.SkillUtils", "Script/Utils/SkillUtils.lua")
    preloadFile(L, root, "Utils.ItemUtils", "Script/Utils/ItemUtils.lua")
    preloadFile(L, root, "Utils.TalkUtils", "Script/Utils/TalkUtils.lua")
    preloadFile(L, root, "Utils.TableUtils", "Script/Utils/TableUtils.lua")
    preloadFile(L, root, "Utils.TextUtils", "Script/Utils/TextUtils.lua")
    preloadFile(L, root, "Utils.ArmoryUtils", "Script/Utils/ArmoryUtils.lua")

    // CommonConst 设为全局（Script/Utils 直接引用全局 CommonConst.SystemLanguage）
    lua.lua_getglobal(L, "require")
    lua.lua_pushstring(L, to_luastring("CommonConst"))
    if (lua.lua_pcall(L, 1, 1, 0) === 0) lua.lua_setglobal(L, "CommonConst")
    else lua.lua_pop(L, 1)

    // CommonUtils 设为全局（SkillUtils 直接引用全局 CommonUtils）
    lua.lua_getglobal(L, "require")
    lua.lua_pushstring(L, to_luastring("Utils.CommonUtils"))
    if (lua.lua_pcall(L, 1, 1, 0) === 0) lua.lua_setglobal(L, "CommonUtils")
    else lua.lua_pop(L, 1)

    const expose = (globalName: string, moduleName: string) => {
        lua.lua_getglobal(L, "require")
        lua.lua_pushstring(L, to_luastring(moduleName))
        if (lua.lua_pcall(L, 1, 1, 0) === 0) lua.lua_setglobal(L, globalName)
        else lua.lua_pop(L, 1)
    }
    expose("__SkillUtils", "Utils.SkillUtils")
    expose("__CommonUtils", "Utils.CommonUtils")
}

// ---- 小工具（避免在纯 TS 里重复 node:path/node:fs 导入逻辑）----
import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"

function joinPath(root: string, ...rest: string[]): string {
    return join(root, ...rest)
}
function existsSyncSafe(p: string): boolean {
    try {
        return existsSync(p)
    } catch {
        return false
    }
}
function readFileSafe(p: string): string {
    return readFileSync(p, "utf8")
}
