local HotFix = {}

function HotFix.ShowUpValue(show_function)
  DebugPrint("---------ShowUpValue Start---------")
  local i = 1
  while true do
    local name, upvalue = debug.getupvalue(show_function, i)
    DebugPrint("upvalue", name, i, upvalue)
    if nil == name or "" == name then
      break
    end
    i = i + 1
  end
  DebugPrint("---------ShowUpValue End---------")
end

function HotFix.HotFixFunction(old_function, new_function)
  DebugPrint("HotFixFunction", old_function, new_function)
  local i = 1
  while true do
    local name, new_upvalue = debug.getupvalue(new_function, i)
    if nil == name or "" == name then
      break
    end
    DebugPrint("setupvalue,name:", name, ",i:", i, ",old_function:", old_function, ",new_upvalue:", new_upvalue)
    debug.setupvalue(old_function, i, new_upvalue)
    i = i + 1
  end
  debug.replace_function(old_function, new_function)
end

function HotFix.HotFixReference(module, name, new_value)
  local ref_tables = module.ref_tables
  if not ref_tables then
    return
  end
  for _, ref_table in ipairs(ref_tables) do
    ref_table[name] = new_value
  end
end

HotFix.NewValues = {}

function HotFix.HotFix(module, name, new_value)
  table.insert(HotFix.NewValues, new_value)
  local old_value = module[name]
  if old_value == new_value then
    return true
  end
  if nil == old_value or nil == new_value then
    module[name] = new_value
    if type(old_value) == "function" or type(new_value) == "function" then
      HotFix.HotFixReference(module, name, new_value)
    end
  elseif type(old_value) ~= "function" then
    module[name] = new_value
  elseif type(new_value) ~= "function" then
    module[name] = new_value
  else
    local ok, ret = pcall(HotFix.HotFixFunction, old_value, new_value)
    if not ok then
      ScreenPrint("HotFix执行失败!name:[" .. tostring(name) .. "],ret:" .. tostring(ret))
      HotFix.Success = false
      return false
    end
  end
  return true
end

function HotFix.ExecHotFix(Index, ScriptData)
  local LocalFunctionPrefixStr = [[
		HotFixModule.Success = true
		HotFix(_G, "Get_G", function(...)
			return _G
		end)
		HotFix(DataMgr, "ReadOnly_NewIndex", function(t, k, v)
			local mt = getmetatable(t)
			if type(v) == 'table' then
				v = DataMgr.ReadOnly('Hotfix', v)
			end
			rawset(mt.__index, k, v)
		end)
		local data_module_names = {}
		HotFixModule.data_module_table = {}
		local mt = getmetatable(DataMgr)
		local old_index = mt.__index
		mt.__index = function(t, key)
			table.insert(data_module_names, key)
			HotFixModule.data_module_table[key] = 1
	        return require("Datas."..key)
	    end
	    setmetatable(DataMgr, mt)
	]]
  local LocalFunctionsuffixStr = [[
		mt.__index = old_index
	    setmetatable(DataMgr, mt)
	    if data_module_names then
	    	GWorld.GameInstance:ReloadDataTablesByModuleName(data_module_names)
	    end
		return HotFixModule.Success
	]]
  local ExecStr = "return function(HotFixModule, HotFix)\n" .. LocalFunctionPrefixStr .. ScriptData .. "\n" .. LocalFunctionsuffixStr .. [[

end]]
  local ok, HotFixExecFunction = pcall(_G.load, ExecStr)
  if not ok then
    ScreenPrint("HotFix执行失败1,请检查HotFix代码编写是否正确:[" .. tostring(ExecStr) .. "]" .. tostring(HotFixExecFunction))
    return
  end
  local ok, HotFixFunction = pcall(HotFixExecFunction)
  if not ok then
    ScreenPrint("HotFix执行失败2,请检查HotFix代码编写是否正确:[" .. tostring(ExecStr) .. "]" .. tostring(HotFixFunction))
    return
  end
  if not HotFixFunction(HotFix, HotFix.HotFix) then
    return
  end
  print(LogTag, "HotFix执行成功:[" .. tostring(ExecStr) .. "]")
end

return HotFix
