/**
 * LuaDataManager — 混合分层架构的数据与计算核心。
 *
 * 单一 fengari state 常驻（懒初始化），承担两件事：
 *
 * 1. **数据加载**：`DataMgr.<name>` 懒加载 `Script/Datas/<name>.lua`（数据驻留 Lua，
 *    键类型完全保留，数字键 `Skill[110101]` 直接可访问）。TS 侧需要结构化遍历时，
 *    通过 `getTable(name)` 一次性读回为 JS（带内存缓存）。
 *
 * 2. **数值计算**：游戏自带的 SkillUtils（`Utils/SkillUtils.lua` 精简版）在 VM 内运行，
 *    `calcSkillDesc(desc, level)` 等封装直接调用，返回计算后的串（含 GText 哨兵）。
 *    这是 Python ast_parser / SkillGrow 查找的替代，正确性由游戏引擎保证。
 *
 * 语言无关：GText 桩返回哨兵串，Lua 层不感知语言；多语言渲染在 TS 侧 vnode 层完成。
 */

import { existsSync, readFileSync } from "node:fs"
import { join } from "node:path"
import type { LuaState } from "fengari"
import { lauxlib, lua, lualib, to_jsstring, to_luastring } from "fengari"
import { type LuaValue, luaValueToJs } from "./luaToJs.ts"
import { GT_RE, installBaseStubs, installUtils, registerDatasPreload } from "./stubs.ts"

const PROJECT_ROOT = join(import.meta.dir, "..", "..")

/** 计算串里出现的文本 key 哨兵正则 */
export { GT_PREFIX, GT_RE, GT_SUFFIX, sentinelOf } from "./stubs.ts"

export class LuaDataManager {
    private L: LuaState | null = null
    /** 已加载的 Datas 表名集合（= package.loaded 里已缓存的） */
    private loadedTables = new Set<string>()
    /** TS 侧读回缓存：name → JS 值 */
    private jsCache = new Map<string, LuaValue>()
    /** 记录按项读取的空结果，避免对不存在的 ID 重复访问 Lua 表。 */
    private missingItems = new Set<string>()
    /** 已完整物化到 JS 的表名（与 Lua VM 内 loadedTables 分开统计）。 */
    private materializedTables = new Set<string>()
    /** 计算封装引用 */
    private skillUtilsReady = false
    /** calcSkillDesc memo 缓存：`${level}\x00${desc}` → 结果串 */
    private calcDescCache = new Map<string, string>()

    /** 项目根（Script/Datas、Utils 所在） */
    constructor(public root: string = PROJECT_ROOT) {}

    /** 获取（惰性创建）state，并安装全部环境 */
    private ensureState(): LuaState {
        if (this.L) return this.L
        const L = lauxlib.luaL_newstate()
        lualib.luaL_openlibs(L)

        // 仅注册常见热表的 loader；文件内容在真正 require/访问时才读取。
        const datasNames = [
            "Skill",
            "SkillGrow",
            "SkillEffects",
            "SkillNode",
            "SkillCreature",
            "SkillLevelUp",
            "Char",
            "BattleChar",
            "Weapon",
            "BattleWeapon",
            "Mod",
            "AttrConfig",
            "Attribute",
            "CombatTerm",
            "Resource",
            "Positioning",
            "DamageTag",
            "CharBreak",
            "LevelUp",
            "CharacterDataTarget",
            "CharacterData",
            "CharVoice",
            "Access",
            "Condition",
            "ImpressionCheck",
            "ImpressionPlus",
            "DataConst",
            "Const",
        ]
        for (const name of datasNames) registerDatasPreload(L, this.root, name)
        installBaseStubs(L, (LL: LuaState, key: string) => {
            this.loadDatasIntoState(LL, key)
        })

        // 注册 Utils / CommonConst 的 preload
        installUtils(L, this.root)

        this.L = L
        return L
    }

    /**
     * DataMgr.__index 的实际 loader：动态加载任意 Script/Datas/<key>.lua，
     * 结果缓存到 package.loaded["Datas.<key>"]（后续 require 命中，避免重复解析大表）。
     * 文件不存在/执行失败 → 栈顶压 nil。
     */
    private loadDatasIntoState(L: LuaState, key: string): void {
        // 1. 命中缓存
        const loadedName = `Datas.${key}`
        lua.lua_getglobal(L, "package")
        lua.lua_getfield(L, -1, "loaded")
        lua.lua_getfield(L, -1, loadedName)
        const cachedType = lua.lua_type(L, -1)
        if (cachedType === lua.LUA_TTABLE) {
            // 栈: [package, loaded, cachedValue]
            lua.lua_remove(L, -2) // [package, cachedValue]
            lua.lua_remove(L, -2) // [cachedValue]
            return
        }
        lua.lua_pop(L, 3) // 弹出 package/loaded/nil

        // 2. 读文件执行
        const file = join(this.root, "Script", "Datas", `${key}.lua`)
        if (!existsSync(file)) {
            lua.lua_pushnil(L)
            return
        }
        const code = readFileSync(file, "utf8")
        if (lauxlib.luaL_loadstring(L, to_luastring(code)) !== 0) {
            lua.lua_pop(L, 1)
            lua.lua_pushnil(L)
            return
        }
        if (lua.lua_pcall(L, 0, 1, 0) !== 0) {
            lua.lua_pop(L, 1)
            lua.lua_pushnil(L)
            return
        }
        // 栈: [result]
        // 3. 写入 package.loaded["Datas.<key>"] = result
        lua.lua_pushvalue(L, -1) // [result, result]
        lua.lua_getglobal(L, "package")
        lua.lua_getfield(L, -1, "loaded")
        lua.lua_pushvalue(L, -3) // [result, result, package, loaded, result]
        lua.lua_setfield(L, -2, loadedName)
        // 清理：弹出 loaded/package/result(副本)，保留原始 result
        lua.lua_pop(L, 3) // [result]
        this.loadedTables.add(key)
    }

    /**
     * 显式预加载某张表（走 require，命中 package.loaded 缓存）。
     * 供模块在 build 时主动触发，避免懒加载在每次 SkillUtils 访问时重复执行。
     */
    preloadTable(name: string): void {
        const L = this.ensureState()
        lua.lua_getglobal(L, "require")
        lua.lua_pushstring(L, to_luastring(`Datas.${name}`))
        if (lua.lua_pcall(L, 1, 1, 0) === 0) {
            this.loadedTables.add(name)
        }
        lua.lua_pop(L, 1)
    }

    /**
     * 获取某张表为 JS 值（TS 侧结构化遍历/数据解释用）。
     * 只读取 Lua 源（懒加载），失败返回 undefined。带缓存。
     */
    getTable(name: string): LuaValue | undefined {
        const cached = this.jsCache.get(name)
        if (cached !== undefined) return cached

        const L = this.ensureState()
        // 读取 DataMgr[name]
        lua.lua_getglobal(L, "DataMgr")
        lua.lua_pushstring(L, to_luastring(name))
        lua.lua_gettable(L, -2)
        const isTable = lua.lua_type(L, -1) === lua.LUA_TTABLE
        let result: LuaValue | undefined
        if (isTable) {
            result = luaValueToJs(L, -1) as LuaValue
            this.loadedTables.add(name)
        } else {
            result = undefined
        }
        lua.lua_pop(L, 2) // value + DataMgr

        if (result !== undefined) {
            this.jsCache.set(name, result)
            this.materializedTables.add(name)
        }
        return result
    }

    /** 在同一 Fengari state 中执行一个 Script 下的 Lua 文件并读取其返回值。 */
    loadScriptFile(relativePath: string): LuaValue | undefined {
        const file = join(this.root, relativePath)
        if (!existsSync(file)) return undefined
        const L = this.ensureState()
        const code = readFileSync(file, "utf8")
        if (lauxlib.luaL_loadstring(L, to_luastring(code)) !== 0) {
            lua.lua_pop(L, 1)
            return undefined
        }
        if (lua.lua_pcall(L, 0, 1, 0) !== 0) {
            lua.lua_pop(L, 1)
            return undefined
        }
        const result = lua.lua_type(L, -1) === lua.LUA_TNIL ? undefined : (luaValueToJs(L, -1) as LuaValue)
        lua.lua_pop(L, 1)
        return result
    }

    /** 读取剧情 Lua，并只投影 QuestStory/PartyTopic 所需字段，避免大型节点元数据递归物化。 */
    loadStoryFile(relativePath: string): LuaValue | undefined {
        const file = join(this.root, relativePath)
        if (!existsSync(file)) return undefined
        const L = this.ensureState()
        if (lauxlib.luaL_dostring(L, to_luastring(`
            __project_story = function(value)
                local function props(value)
                    local out = {}
                    local fields = {"FirstDialogueId", "FlowAssetPath", "GuidePointName", "StoryGuidePointName", "UnitBPPath", "UnitName", "QuestId", "QuestDescription", "QuestDeatil", "SubRegionId", "QuestionIds", "AnswerIds", "SpecialConfigId"}
                    for _, field in ipairs(fields) do if value and value[field] ~= nil then out[field] = value[field] end end
                    return out
                end
                local function edge(value)
                    if type(value) ~= "table" then return nil end
                    return {startQuest = value.startQuest, startPort = value.startPort, endQuest = value.endQuest, endPort = value.endPort, startStory = value.startStory, endStory = value.endStory}
                end
                local function nodes(value)
                    local out = {}
                    for key, node in pairs(value or {}) do
                        if type(node) == "table" then
                            local copy = {key = node.key or key, type = node.type, name = node.name, propsData = props(node.propsData)}
                            if type(node.questNodeData) == "table" then
                                local q = {lineData = {}, nodeData = {}}
                                for _, item in pairs(node.questNodeData.lineData or {}) do local e = edge(item); if e then q.lineData[#q.lineData + 1] = e end end
                                for childKey, child in pairs(node.questNodeData.nodeData or {}) do
                                    if type(child) == "table" then q.nodeData[childKey] = {key = child.key or childKey, type = child.type, name = child.name, propsData = props(child.propsData)} end
                                end
                                copy.questNodeData = q
                            end
                            out[key] = copy
                        end
                    end
                    return out
                end
                return {storyName = value and value.storyName or "", storyDescription = value and value.storyDescription or "", storyNodeData = nodes(value and value.storyNodeData), lineData = value and value.lineData or {}}
            end
        `)) !== 0) {
            lua.lua_settop(L, 0)
            return undefined
        }
        const code = readFileSync(file, "utf8")
        if (lauxlib.luaL_loadstring(L, to_luastring(code)) !== 0 || lua.lua_pcall(L, 0, 1, 0) !== 0) {
            lua.lua_settop(L, 0)
            return undefined
        }
        const valueIndex = lua.lua_gettop(L)
        lua.lua_getglobal(L, "__project_story")
        lua.lua_pushvalue(L, valueIndex)
        if (lua.lua_pcall(L, 1, 1, 0) !== 0) {
            lua.lua_settop(L, 0)
            return undefined
        }
        const result = lua.lua_type(L, -1) === lua.LUA_TNIL ? undefined : (luaValueToJs(L, -1) as LuaValue)
        lua.lua_settop(L, 0)
        return result
    }

    /** 读取返回表的浅层记录，适合大型平面索引文件，避免递归物化整张表。 */
    loadScriptTableRows(relativePath: string, fields: string[]): Array<Record<string, string | number | boolean | null>> {
        const file = join(this.root, relativePath)
        if (!existsSync(file)) return []
        const L = this.ensureState()
        const code = readFileSync(file, "utf8")
        if (lauxlib.luaL_loadstring(L, to_luastring(code)) !== 0 || lua.lua_pcall(L, 0, 1, 0) !== 0) {
            lua.lua_settop(L, 0)
            return []
        }
        if (lua.lua_type(L, -1) !== lua.LUA_TTABLE) {
            lua.lua_pop(L, 1)
            return []
        }
        const result: Array<Record<string, string | number | boolean | null>> = []
        const root = lua.lua_absindex(L, -1)
        lua.lua_pushnil(L)
        while (lua.lua_next(L, root) !== 0) {
            if (lua.lua_type(L, -1) === lua.LUA_TTABLE) {
                const item: Record<string, string | number | boolean | null> = {}
                for (const field of fields) {
                    lua.lua_getfield(L, -1, field)
                    const type = lua.lua_type(L, -1)
                    if (type === lua.LUA_TSTRING) item[field] = to_jsstring(lua.lua_tostring(L, -1)!)
                    else if (type === lua.LUA_TNUMBER) item[field] = lua.lua_tonumber(L, -1)
                    else if (type === lua.LUA_TBOOLEAN) item[field] = lua.lua_toboolean(L, -1)
                    else if (type === lua.LUA_TNIL) item[field] = null
                    lua.lua_pop(L, 1)
                }
                const keyType = lua.lua_type(L, -2)
                const key = keyType === lua.LUA_TSTRING ? to_jsstring(lua.lua_tostring(L, -2)!) : String(lua.lua_tonumber(L, -2))
                item.__key = key
                result.push(item)
            }
            lua.lua_pop(L, 1)
        }
        lua.lua_pop(L, 1)
        return result
    }

    /**
     * 读取单个 Lua 表项并转换为 JS。
     * 与 getTable 不同，这里只物化指定 key 的子树，适合 Skill/SkillNode/SkillEffects
     * 这类大表的按引用访问。结果按表名+key 缓存，避免同一项重复跨 VM 转换。
     */
    getTableItem(name: string, key: number | string): LuaValue | undefined {
        const cacheKey = `${name}\x00${String(key)}`
        const cached = this.jsCache.get(cacheKey)
        if (cached !== undefined) return cached
        if (this.missingItems.has(cacheKey)) return undefined

        const L = this.ensureState()
        lua.lua_getglobal(L, "DataMgr")
        lua.lua_pushstring(L, to_luastring(name))
        lua.lua_gettable(L, -2)
        if (lua.lua_type(L, -1) !== lua.LUA_TTABLE) {
            lua.lua_pop(L, 2)
            this.missingItems.add(cacheKey)
            return undefined
        }

        const numericKey = typeof key === "number" || /^-?\d+(?:\.\d+)?$/.test(String(key))
        if (numericKey) lua.lua_pushnumber(L, Number(key))
        else lua.lua_pushstring(L, to_luastring(String(key)))
        lua.lua_gettable(L, -2)
        if (lua.lua_type(L, -1) === lua.LUA_TNIL && numericKey) {
            lua.lua_pop(L, 1)
            lua.lua_pushstring(L, to_luastring(String(key)))
            lua.lua_gettable(L, -2)
        }

        const type = lua.lua_type(L, -1)
        const result = type === lua.LUA_TNIL ? undefined : (luaValueToJs(L, -1) as LuaValue)
        lua.lua_pop(L, 3) // value + table + DataMgr
        if (result !== undefined) this.jsCache.set(cacheKey, result)
        else this.missingItems.add(cacheKey)
        return result
    }

    /**
     * 按需读取多个顶层键，只把请求的子树转换为 JS。
     * 返回 Map 的 key 使用调用方传入的字符串形式，适合一次读取角色/武器的技能列表。
     */
    getTableItems(name: string, keys: Array<number | string>): Map<string, LuaValue> {
        const result = new Map<string, LuaValue>()
        const pending: Array<number | string> = []
        const pendingCacheKeys = new Set<string>()
        for (const key of keys) {
            const normalized = String(key)
            const cacheKey = `${name}\x00${normalized}`
            const cached = this.jsCache.get(cacheKey)
            if (cached !== undefined) {
                result.set(normalized, cached)
                continue
            }
            if (this.missingItems.has(cacheKey) || pendingCacheKeys.has(cacheKey)) continue
            pending.push(key)
            pendingCacheKeys.add(cacheKey)
        }
        if (pending.length === 0) return result

        const L = this.ensureState()
        lua.lua_getglobal(L, "__get_table_items")
        lua.lua_pushstring(L, to_luastring(name))
        this.pushJsValue(L, pending)
        if (lua.lua_pcall(L, 2, 1, 0) !== 0) {
            lua.lua_pop(L, 1)
            return result
        }
        const values = luaValueToJs(L, -1)
        lua.lua_pop(L, 1)
        if (!values || typeof values !== "object" || Array.isArray(values)) return result

        const rows = values as Record<string, LuaValue>
        for (const key of pending) {
            const normalized = String(key)
            const cacheKey = `${name}\x00${normalized}`
            const value = rows[normalized]
            if (value === undefined) {
                this.missingItems.add(cacheKey)
                continue
            }
            this.jsCache.set(cacheKey, value)
            result.set(normalized, value)
        }
        return result
    }

    /** 在 Lua VM 内按嵌套字段反向查找顶层键，只返回匹配键，不物化整张表。 */
    findTableKeysByPath(name: string, path: Array<number | string>, expected: unknown): Array<number | string> {
        const L = this.ensureState()
        lua.lua_getglobal(L, "__find_keys_by_path")
        lua.lua_pushstring(L, to_luastring(name))
        this.pushJsValue(L, path)
        this.pushJsValue(L, expected)
        if (lua.lua_pcall(L, 3, 1, 0) !== 0) {
            const message = to_jsstring(lua.lua_tostring(L, -1)!)
            lua.lua_pop(L, 1)
            throw new Error(`按路径查询 Lua 表失败: ${message}`)
        }
        const result = luaValueToJs(L, -1)
        lua.lua_pop(L, 1)
        if (!Array.isArray(result)) return []
        return result.filter((value): value is number | string => typeof value === "number" || typeof value === "string")
    }

    /** 在含 TaskEffects 的表中按任务字段筛选顶层键，避免把整张效果表读回 JS。 */
    findTableKeysByTaskField(name: string, field: string, expected: unknown): Array<number | string> {
        const L = this.ensureState()
        lua.lua_getglobal(L, "__find_keys_by_task_field")
        lua.lua_pushstring(L, to_luastring(name))
        lua.lua_pushstring(L, to_luastring(field))
        this.pushJsValue(L, expected)
        if (lua.lua_pcall(L, 3, 1, 0) !== 0) {
            const message = to_jsstring(lua.lua_tostring(L, -1)!)
            lua.lua_pop(L, 1)
            throw new Error(`按任务字段查询 Lua 表失败: ${message}`)
        }
        const result = luaValueToJs(L, -1)
        lua.lua_pop(L, 1)
        if (!Array.isArray(result)) return []
        return result.filter((value): value is number | string => typeof value === "number" || typeof value === "string")
    }

    /** 在 Lua VM 内构建召唤物伤害 effect 索引，只把 ID 数组返回到 TS。 */
    findSummonEffectIds(): number[] {
        const L = this.ensureState()
        lua.lua_getglobal(L, "__find_summon_effect_ids")
        if (lua.lua_pcall(L, 0, 1, 0) !== 0) {
            const message = to_jsstring(lua.lua_tostring(L, -1)!)
            lua.lua_pop(L, 1)
            throw new Error(`查询召唤物效果索引失败: ${message}`)
        }
        const result = luaValueToJs(L, -1)
        lua.lua_pop(L, 1)
        if (!Array.isArray(result)) return []
        return result.filter((value): value is number => typeof value === "number" && Number.isInteger(value))
    }

    /** 已加载的 Datas 表名（供调试/统计） */
    get loadedTableNames(): string[] {
        return [...this.loadedTables]
    }

    /** 已完整转换到 JS 的表名（按项读取不会出现在此列表）。 */
    get materializedTableNames(): string[] {
        return [...this.materializedTables]
    }

    /**
     * 物化一张"分区懒加载表"（如 TextMap_TextMapContent，用 metatable.__pairs 惰性展开）。
     * 调 Lua 全局 __materialize(name)（内部 pairs() 触发 __pairs 展开全部键值），再读回 JS。
     */
    materializeTable(name: string): LuaValue | undefined {
        const cached = this.jsCache.get(name)
        if (cached !== undefined) return cached

        const L = this.ensureState()
        lua.lua_getglobal(L, "__materialize")
        lua.lua_pushstring(L, to_luastring(name))
        const rc = lua.lua_pcall(L, 1, 1, 0)
        if (rc !== 0) {
            lua.lua_pop(L, 1) // pcall 失败：栈剩 [错误信息]
            return undefined
        }
        // pcall 成功：函数被消费，栈剩 [result]
        const result = luaValueToJs(L, -1) as LuaValue
        lua.lua_pop(L, 1)
        this.jsCache.set(name, result)
        this.materializedTables.add(name)
        this.loadedTables.add(name)
        return result
    }

    // ---------- 计算封装（调用游戏 SkillUtils） ----------

    private ensureSkillUtils(): void {
        if (this.skillUtilsReady) return
        const L = this.ensureState()
        // 确保全局 __SkillUtils 存在
        lua.lua_getglobal(L, "__SkillUtils")
        if (lua.lua_type(L, -1) !== lua.LUA_TTABLE) {
            lua.lua_pop(L, 1)
            // 重新暴露
            lua.lua_getglobal(L, "require")
            lua.lua_pushstring(L, to_luastring("Utils.SkillUtils"))
            if (lua.lua_pcall(L, 1, 1, 0) === 0) lua.lua_setglobal(L, "__SkillUtils")
            else lua.lua_pop(L, 1)
        } else {
            lua.lua_pop(L, 1)
        }
        this.skillUtilsReady = true
    }

    /**
     * 调用 SkillUtils.<fn>(args...)，返回 JS 结果（string/number/boolean/null/JS 对象）。
     * args 支持标量、JS 对象（转 Lua 表）、数组（转 Lua 数组表）。
     * 失败返回 undefined。
     */
    callSkillUtilsTableFn(fn: string, args: Array<unknown>): unknown {
        const L = this.ensureState()
        this.ensureSkillUtils()
        lua.lua_getglobal(L, "__SkillUtils")
        if (lua.lua_type(L, -1) !== lua.LUA_TTABLE) {
            lua.lua_pop(L, 1)
            return undefined
        }
        lua.lua_getfield(L, -1, fn)
        const fnType = lua.lua_type(L, -1)
        if (fnType !== lua.LUA_TFUNCTION) {
            lua.lua_pop(L, 2)
            return undefined
        }
        // 压入参数（支持对象/数组 → Lua 表）
        for (const a of args) this.pushJsValue(L, a)
        const rc = lua.lua_pcall(L, args.length, 1, 0)
        if (rc !== 0) {
            lua.lua_pop(L, 2) // 错误 + 表
            return undefined
        }
        const t = lua.lua_type(L, -1)
        let result: unknown
        switch (t) {
            case lua.LUA_TNUMBER:
                result = lua.lua_tonumber(L, -1)
                break
            case lua.LUA_TSTRING:
                result = to_jsstring(lua.lua_tostring(L, -1)!)
                break
            case lua.LUA_TBOOLEAN:
                result = lua.lua_toboolean(L, -1)
                break
            case lua.LUA_TNIL:
                result = null
                break
            case lua.LUA_TTABLE:
                result = luaValueToJs(L, -1)
                break
            default:
                result = undefined
        }
        lua.lua_pop(L, 2) // result + __SkillUtils 表
        return result
    }

    /** 把 JS 值压入 Lua 栈（标量直接压；对象/数组转 Lua 表） */
    private pushJsValue(L: LuaState, v: unknown): void {
        if (typeof v === "number") {
            lua.lua_pushnumber(L, v)
        } else if (typeof v === "string") {
            lua.lua_pushstring(L, to_luastring(v))
        } else if (typeof v === "boolean") {
            lua.lua_pushboolean(L, v)
        } else if (v === null || v === undefined) {
            lua.lua_pushnil(L)
        } else if (Array.isArray(v)) {
            lua.lua_newtable(L)
            const idx = lua.lua_gettop(L)
            for (let i = 0; i < v.length; i++) {
                this.pushJsValue(L, v[i])
                lua.lua_rawseti(L, idx, i + 1)
            }
        } else if (typeof v === "object") {
            lua.lua_newtable(L)
            const idx = lua.lua_gettop(L)
            for (const [k, val] of Object.entries(v as Record<string, unknown>)) {
                this.pushJsValue(L, val)
                lua.lua_setfield(L, idx, k)
            }
        } else {
            lua.lua_pushnil(L)
        }
    }

    /**
     * 计算技能描述值：SkillUtils.CalcSkillDesc(desc, level)。
     * 返回计算后的串（可能含 GText 哨兵）。失败返回原 desc。
     * ★ memo 缓存：CalcSkillDesc 内部对每个 $...$ 表达式动态编译（fengari load 很慢），
     *   相同 desc+level 跨模块/跨武器复用，避免重复编译。
     */
    calcSkillDesc(desc: string, level: number): string {
        const key = `${level} ${desc}`
        const cached = this.calcDescCache.get(key)
        if (cached !== undefined) return cached
        const r = this.callSkillUtilsTableFn("CalcSkillDesc", [desc, level])
        const result = typeof r === "string" ? r : desc
        this.calcDescCache.set(key, result)
        return result
    }

    /**
     * 计算技能描述值（数值优先）：SkillUtils.CalcSkillDescValue(desc, level)。
     */
    calcSkillDescValue(desc: string, level: number): string | number | undefined {
        const r = this.callSkillUtilsTableFn("CalcSkillDescValue", [desc, level])
        if (typeof r === "string" || typeof r === "number") return r
        return undefined
    }

    /** ArmoryUtils Mod 被动描述单个占位值（Lua 内处理 GetModValue/Polarity）。 */
    calcModDescValue(desc: string, modId: number, level: number): string {
        const r = this.callGlobalFn("__calc_mod_desc_value", [desc, modId, level])
        return typeof r === "string" ? r : desc
    }

    /** ArmoryUtils.CalcModAttrByLevel（Lua 内执行 SkillUtils.GrowProxy）。 */
    calcModAttr(modId: number, level: number, attrIndex: number, valueType?: string): number {
        const r = this.callGlobalFn("__calc_mod_attr", [modId, level, attrIndex, valueType])
        return typeof r === "number" ? r : 0
    }

    /**
     * 技能名（返回翻译 key，非文本）。在 Lua 侧取单个字段，不触发全表读回。
     * 直接读数据层字段 SkillName（它本身就是 TextMap key）。
     */
    getSkillNameKey(skillId: number): string | undefined {
        const r = this.luaGetField("Skill", String(skillId), [1, 0, "SkillName"])
        return typeof r === "string" ? r : undefined
    }

    /**
     * 技能最大等级：SkillUtils.GetMaxLevel(skillId)
     */
    getSkillMaxLevel(skillId: number): number | undefined {
        const r = this.callSkillUtilsTableFn("GetMaxLevel", [skillId])
        return typeof r === "number" ? r : undefined
    }

    private callGlobalFn(fn: string, args: Array<unknown>): unknown {
        const L = this.ensureState()
        lua.lua_getglobal(L, fn)
        if (lua.lua_type(L, -1) !== lua.LUA_TFUNCTION) {
            lua.lua_pop(L, 1)
            return undefined
        }
        for (const arg of args) this.pushJsValue(L, arg)
        if (lua.lua_pcall(L, args.length, 1, 0) !== 0) {
            lua.lua_pop(L, 1)
            return undefined
        }
        const t = lua.lua_type(L, -1)
        let result: unknown
        if (t === lua.LUA_TNUMBER) result = lua.lua_tonumber(L, -1)
        else if (t === lua.LUA_TSTRING) result = to_jsstring(lua.lua_tostring(L, -1)!)
        else if (t === lua.LUA_TBOOLEAN) result = lua.lua_toboolean(L, -1)
        else if (t === lua.LUA_TTABLE) result = luaValueToJs(L, -1)
        else result = undefined
        lua.lua_pop(L, 1)
        return result
    }

    // ---------- Lua 侧字段访问（避免全表读回大表） ----------

    /**
     * 在 Lua state 内读取 DataMgr.<name>[key]<path> 的标量字段。
     * path 是依次索引的数组（数字=数组下标，字符串=字段名）。
     * 只返回 number/string/boolean/null，避免把大表带回 JS。
     */
    luaGetField(name: string, key: string, path: Array<number | string>): string | number | boolean | null | undefined {
        const L = this.ensureState()
        lua.lua_getglobal(L, "DataMgr")
        lua.lua_pushstring(L, to_luastring(name))
        lua.lua_gettable(L, -2)
        if (lua.lua_type(L, -1) !== lua.LUA_TTABLE) {
            lua.lua_pop(L, 2)
            return undefined
        }
        // 取 [key]：Skill 等表顶层键是数字，按数字压入；数字访问失败则退回字符串键
        const numKey = /^-?\d+(\.\d+)?$/.test(key) ? Number(key) : null
        if (numKey !== null) {
            lua.lua_pushnumber(L, numKey)
            lua.lua_gettable(L, -2)
        } else {
            lua.lua_pushstring(L, to_luastring(key))
            lua.lua_gettable(L, -2)
        }
        if (lua.lua_type(L, -1) !== lua.LUA_TTABLE && numKey !== null) {
            // 数字键访问失败，退回字符串键
            lua.lua_pop(L, 1)
            lua.lua_pushstring(L, to_luastring(key))
            lua.lua_gettable(L, -2)
        }
        if (lua.lua_type(L, -1) !== lua.LUA_TTABLE) {
            lua.lua_pop(L, 3)
            return undefined
        }
        // 沿 path 下钻
        for (const seg of path) {
            if (typeof seg === "number") {
                lua.lua_geti(L, -1, seg)
            } else {
                lua.lua_getfield(L, -1, seg)
            }
            const t = lua.lua_type(L, -1)
            if (t === lua.LUA_TTABLE) continue // 继续下钻
            const isLast = seg === path[path.length - 1]
            if (!isLast) {
                lua.lua_pop(L, 3)
                return undefined
            }
            let result: string | number | boolean | null | undefined
            if (t === lua.LUA_TNUMBER) result = lua.lua_tonumber(L, -1)
            else if (t === lua.LUA_TSTRING) result = to_jsstring(lua.lua_tostring(L, -1)!)
            else if (t === lua.LUA_TBOOLEAN) result = lua.lua_toboolean(L, -1)
            else if (t === lua.LUA_TNIL) result = null
            else result = undefined
            lua.lua_pop(L, 3) // value + entry + DataMgr
            return result
        }
        lua.lua_pop(L, 3)
        return undefined
    }

    /** 从哨兵串提取第一个文本 key；无哨兵则原样返回 */
    static stripGTSentinel(str: string): string {
        const m = str.match(GT_RE)
        return m ? m[0].replace(GT_RE, "$1") : str
    }
}

/** 单例 */
let _instance: LuaDataManager | null = null
export function getLuaDataManager(root?: string, _fallbackOutDir?: string): LuaDataManager {
    if (!_instance) {
        _instance = new LuaDataManager(root)
    }
    return _instance
}
