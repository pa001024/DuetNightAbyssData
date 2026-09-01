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
  local NumericKey = tonumber(Key)
  if NumericKey == nil then return nil end
  for _, Entry in ipairs(DataIndexTable or {}) do
    if Entry and NumericKey >= Entry.MinKey and NumericKey <= Entry.MaxKey then
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
  local NumericKey = tonumber(Key)
  if not PartitionData or not NumericKey or not PartitionData[NumericKey] then
    return nil
  end
  return PartitionData[NumericKey]
end
DataMgr.GetPartitionData = function(Key, Data)
  local PartitionData = DataMgr.BinarySearch(Key, Data)
  local NumericKey = tonumber(Key)
  if not PartitionData or not NumericKey or not PartitionData[NumericKey] then
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
-- 按需读取一组顶层键。返回值只包含请求的子树，避免调用方为了批量
-- 读取而把 Skill/SkillNode 等大表整体物化到 JS。
__get_table_items = function(name, keys)
  local root = DataMgr[name]
  if type(root) ~= "table" then return {} end
  local out = {}
  for _, key in ipairs(keys or {}) do
    local value = root[key]
    if value == nil and type(key) == "string" then
      local numericKey = tonumber(key)
      if numericKey ~= nil then value = root[numericKey] end
    end
    if value == nil then value = root[tostring(key)] end
    if value ~= nil then out[key] = value end
  end
  return out
end
__dialogue_cache = {}
__get_dialogue_items = function(names, keys)
  local out = {}
  for _, name in ipairs(names or {}) do
    local root = __dialogue_cache[name]
    if not root then
      local source = DataMgr[name]
      root = {}
      if type(source) == "table" then
        for key, value in pairs(source) do root[key] = value end
      end
      __dialogue_cache[name] = root
    end
    local rows = {}
    if root then
      for _, key in ipairs(keys or {}) do
        local value = root[key]
        if value == nil and type(key) == "string" then
          local numericKey = tonumber(key)
          if numericKey ~= nil then value = root[numericKey] end
        end
        if value == nil then value = root[tostring(key)] end
        if value ~= nil then rows[key] = value end
      end
    end
    out[name] = rows
  end
  return out
end
__path_indexes = {}
__find_keys_by_path = function(name, path, expected)
  -- 反向查询通常会被多个角色/武器重复调用；索引留在 Lua，避免每次
  -- 都重新遍历 Skill/SkillNode 等大表，也避免把整表物化到 JS。
  local byName = __path_indexes[name]
  if not byName then byName = {}; __path_indexes[name] = byName end
  local pathParts = {}
  for _, segment in ipairs(path or {}) do
    pathParts[#pathParts + 1] = type(segment) .. ":" .. tostring(segment)
  end
  local indexKey = table.concat(pathParts, "|") .. "=>" .. type(expected) .. ":" .. tostring(expected)
  local cached = byName[indexKey]
  if cached then return cached end

  local out = {}
  local root = DataMgr[name]
  if type(root) ~= "table" then
    byName[indexKey] = out
    return out
  end
  for key, value in pairs(root) do
    local current = value
    for _, segment in ipairs(path or {}) do
      if type(current) ~= "table" then current = nil; break end
      current = current[segment]
    end
    if current == expected then out[#out + 1] = key end
  end
  byName[indexKey] = out
  return out
end
__task_field_indexes = {}
__find_keys_by_task_field = function(name, field, expected)
  local function indexKey(value)
    if type(value) == "number" and value == math.floor(value) then
      return tostring(math.floor(value))
    end
    return tostring(value)
  end
  local byName = __task_field_indexes[name]
  if not byName then byName = {}; __task_field_indexes[name] = byName end
  local index = byName[field]
  if not index then
    index = {}
    local root = DataMgr[name]
    if type(root) == "table" then
      for key, value in pairs(root) do
        if type(value) == "table" and type(value.TaskEffects) == "table" then
          for _, task in pairs(value.TaskEffects) do
            if type(task) == "table" and task[field] ~= nil then
              local expectedKey = indexKey(task[field])
              local keys = index[expectedKey]
              if not keys then keys = {}; index[expectedKey] = keys end
              local seen = false
              for _, existing in ipairs(keys) do
                if existing == key then seen = true; break end
              end
              if not seen then keys[#keys + 1] = key end
            end
          end
        end
      end
    end
    byName[field] = index
  end
  return index[indexKey(expected)] or {}
end
__find_summon_effect_ids = function()
  if __summon_effect_ids_cache then return __summon_effect_ids_cache end
  local monsters = DataMgr.Monster or {}
  local mechanisms = DataMgr.MechanismSummon or {}
  local battleChars = DataMgr.BattleChar or {}
  local battleMonsters = DataMgr.BattleMonster or {}
  local creatures = DataMgr.SkillCreature or {}
  local skills = DataMgr.Skill or {}
  local nodes = DataMgr.SkillNode or {}
  local effects = DataMgr.SkillEffects or {}

  local function number(value)
    if type(value) == "number" then return value end
    if type(value) == "string" then return tonumber(value) end
    return nil
  end
  local function integer(value)
    local n = number(value)
    if n and n == math.floor(n) then return n end
    return nil
  end
  local function entry(tableValue, id)
    return tableValue[id] or tableValue[tostring(id)]
  end
  local function addId(set, value)
    local id = integer(value)
    if id then set[id] = true end
  end
  local function contains(tableValue, expected)
    if type(tableValue) ~= "table" then return false end
    for _, value in pairs(tableValue) do
      if value == expected then return true end
    end
    return false
  end
  local function collectValues(set, value)
    if type(value) == "table" then
      for _, child in pairs(value) do collectValues(set, child) end
      return
    end
    local id = integer(value)
    if id and entry(effects, id) then set[id] = true end
  end
  local function unwrapSkill(info)
    if type(info) ~= "table" then return nil end
    local first = info[1] or info[0]
    if type(first) ~= "table" then return nil end
    local nested = first[0] or first[1]
    if type(nested) == "table" then first = nested end
    if first.BeginNodeId == nil then return nil end
    return first
  end
  local function listValue(value)
    if value == nil then return {} end
    if type(value) ~= "table" then return {value} end
  local result = {}
  for _, child in pairs(value) do result[#result + 1] = child end
  return result
end

  local summonIds = {}
  for _, row in pairs(monsters) do
    if type(row) == "table" and (contains(row.GamePlayTags, "Player.Summon") or contains(row.GamePlayTags, "Player.RealSummon") or contains(row.GamePlayTags, "Mon.Summon")) then
      addId(summonIds, row.UnitId)
    end
  end
  for _, row in pairs(mechanisms) do
    if type(row) == "table" then addId(summonIds, row.UnitId) end
  end
  for _, row in pairs(battleChars) do
    if type(row) == "table" then
      for _, id in pairs(listValue(row.SummonId)) do addId(summonIds, id) end
    end
  end

  local effectIds = {}
  for id in pairs(summonIds) do
    local monster = entry(monsters, id) or entry(mechanisms, id)
    if type(monster) == "table" and type(monster.BluePrintParams) == "table" then
      collectValues(effectIds, monster.BluePrintParams.SkillEffectID)
      collectValues(effectIds, monster.BluePrintParams.SkillEffectId)
      collectValues(effectIds, monster.BluePrintParams.Grade6SkillEffectID)
    end
    local creature = entry(creatures, id)
    if type(creature) == "table" and not creature.AttachOwner then collectValues(effectIds, creature.HitEnemy) end
    local battleMonster = entry(battleMonsters, id)
    local queue = listValue(type(battleMonster) == "table" and battleMonster.SkillList or nil)
    local head = 1
    local seenNodes = {}
    while head <= #queue do
      local skillId = integer(queue[head]); head = head + 1
      local skillInfo = unwrapSkill(entry(skills, skillId))
      if skillInfo then
        local nodeId = integer(skillInfo.BeginNodeId)
        while nodeId and nodeId > 0 and not seenNodes[nodeId] do
          seenNodes[nodeId] = true
          local node = entry(nodes, nodeId)
          if type(node) ~= "table" then break end
          collectValues(effectIds, node.SkillNodeEffects)
          for _, branch in pairs(listValue(node.BranchNodeIds)) do
            local branchId = integer(branch)
            if branchId and branchId > 0 and not seenNodes[branchId] then queue[#queue + 1] = branchId end
          end
          nodeId = integer(node.NextNodeId)
        end
      end
    end
  end

  local realSummonIds = {}
  for _, row in pairs(monsters) do
    if type(row) == "table" and contains(row.GamePlayTags, "Player.RealSummon") then
      local id = integer(row.UnitId)
      if id then realSummonIds[id] = true end
    end
  end
  local function walkChain(beginNode)
    local foundEffects, foundUnits = {}, {}
    local queue = {number(beginNode)}
    local head, seen = 1, {}
    while head <= #queue do
      local nodeId = integer(queue[head]); head = head + 1
      if nodeId and nodeId > 0 and not seen[nodeId] then
        seen[nodeId] = true
        local node = entry(nodes, nodeId)
        if type(node) == "table" then
          for _, effectId in pairs(listValue(node.SkillNodeEffects)) do
            local eid = integer(effectId)
            if eid then
              foundEffects[eid] = true
              local effect = entry(effects, eid)
              if type(effect) == "table" then
                for _, task in pairs(listValue(effect.TaskEffects)) do
                  if type(task) == "table" and task.Function == "CreateUnit" then addId(foundUnits, task.UnitId) end
                end
              end
            end
          end
          local nextId = integer(node.NextNodeId)
          if nextId then queue[#queue + 1] = nextId end
          for _, branch in pairs(listValue(node.BranchNodeIds)) do
            local branchId = integer(branch)
            if branchId then queue[#queue + 1] = branchId end
          end
        end
      end
    end
    return foundEffects, foundUnits
  end
  local function ownDamage(effect)
    if effect.SkillEffectSourceFlag == "RootSource" then return true end
    for _, task in pairs(listValue(effect.TaskEffects)) do
      if type(task) == "table" and task.Function == "Damage" and (contains(task.DamageTag, "Weapon") or contains(task.DamageTag, "Melee")) then return true end
    end
    return false
  end
  for _, info in pairs(skills) do
    local skill = unwrapSkill(info)
    if skill then
      local chainEffects, chainUnits = walkChain(skill.BeginNodeId)
      local hasRealSummon = false
      for id in pairs(chainUnits) do if realSummonIds[id] then hasRealSummon = true; break end end
      if hasRealSummon then
        for _, value in pairs(listValue(skill.SkillDescValues)) do
          if type(value) == "string" then
            for effectIdText in string.gmatch(value, "SkillEffects%[(%d+)%]") do
              local effectId = integer(effectIdText)
              local effect = effectId and entry(effects, effectId)
              if effectId and not chainEffects[effectId] and type(effect) == "table" and not ownDamage(effect) then
                for _, task in pairs(listValue(effect.TaskEffects)) do
                  if type(task) == "table" and task.Function == "Damage" then effectIds[effectId] = true; break end
                end
              end
            end
          end
        end
      end
    end
  end

  local out = {}
  for id in pairs(effectIds) do out[#out + 1] = id end
  table.sort(out)
  __summon_effect_ids_cache = out
  return out
end

-- ArmoryUtils 的 Mod 专用成长/描述计算，保留在 Lua VM 内执行。
__calc_mod_attr = function(modId, modLevel, attrIdx, valueType)
  local mod = DataMgr.Mod and DataMgr.Mod[modId]
  local attrs = mod and mod.AddAttrs
  local conf = attrs and attrs[attrIdx]
  if not conf then return 0 end
  local isRate = conf.Rate ~= nil
  local base = isRate and conf.Rate or conf.Value
  if valueType ~= nil then
    local kind = string.lower(tostring(valueType))
    if kind == "rate" then base = conf.Rate; isRate = true end
    if kind == "value" then base = conf.Value; isRate = false end
  end
  if type(base) ~= "number" then
    local source = { GetSkillLevelInfo = function() return { SkillLevel = modLevel } end }
    local proxy = __SkillUtils.GrowProxy("Mod", modId, source, conf)
    return tonumber(proxy[isRate and "Rate" or "Value"]) or 0
  end
  return base + (conf.LevelGrow or 0) * modLevel
end

__calc_mod_desc_value = function(descValue, modId, modLevel)
  local function getModValue(targetId, attrIdx, valueType)
    return __calc_mod_attr(targetId, modLevel, attrIdx, valueType)
  end
  local function getModPolarity(targetId)
    local mod = DataMgr.Mod and DataMgr.Mod[targetId]
    local chars = { [0] = "", [1] = "A", [2] = "D", [3] = "V", [4] = "O" }
    return chars[mod and mod.Polarity] or ""
  end
  if string.find(descValue, "GetModValue") or string.find(descValue, "GetModPolarity") then
    return __SkillUtils.SplitEval(descValue, "$", { GetModValue = getModValue, GetModPolarity = getModPolarity })
  end
  return __SkillUtils.CalcSkillDesc(descValue, modLevel, nil, true)
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
    const setup = extraSetup ?? ""

    lua.lua_getglobal(L, "package")
    lua.lua_getfield(L, -1, "preload")
    lua.lua_pushcfunction(L, (LL: LuaState) => {
        const code = readFileSafe(full)
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
    lua.lua_getglobal(L, "package")
    lua.lua_getfield(L, -1, "preload")
    lua.lua_pushcfunction(L, (LL: LuaState) => {
        const code = readFileSafe(file)
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
