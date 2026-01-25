require("UnLua")
local FileNamePart = "RpcCache"
local FileDir = UE4.UKismetSystemLibrary.GetProjectContentDirectory() .. "Script/Test/" .. FileNamePart .. "/"
local MiscUtils = require("Utils.MiscUtils")
local SerializeOnlineRpc = {}
SerializeOnlineRpc.RPC_Cache = {}
SerializeOnlineRpc.call_counter = 0
SerializeOnlineRpc.IsStartRpcCache = false
local log_file = "rpc_log.lua"
local is_initialized = false

function SerializeOnlineRpc.StartRpcCache()
  SerializeOnlineRpc.IsStartRpcCache = true
end

function SerializeOnlineRpc.CloseRpcCache()
  SerializeOnlineRpc.IsStartRpcCache = false
end

function SerializeOnlineRpc.GetStartRpcCacheState()
  return SerializeOnlineRpc.IsStartRpcCache
end

function SerializeOnlineRpc.InitRPCLogger()
  if not is_initialized then
    SerializeOnlineRpc.RPC_Cache = {}
    SerializeOnlineRpc.call_counter = 0
    is_initialized = true
    DebugPrint("RPC Logger initialized")
  end
end

local function serialize_table(t, depth)
  if depth > 3 then
    return "{...}"
  end
  local result = "{"
  local count = 0
  for i, v in ipairs(t) do
    if count > 0 then
      result = result .. ", "
    end
    local value_type = type(v)
    if "string" == value_type then
      result = result .. string.format("%q", v)
    elseif "number" == value_type or "boolean" == value_type then
      result = result .. tostring(v)
    elseif "table" == value_type then
      result = result .. serialize_table(v, depth + 1)
    else
      result = result .. string.format("%q", tostring(v) .. " (" .. value_type .. ")")
    end
    count = count + 1
    if count >= 10 then
      result = result .. ", ..."
      break
    end
  end
  for k, v in pairs(t) do
    if type(k) ~= "number" or k > #t or k < 1 then
      if count > 0 then
        result = result .. ", "
      end
      local key_type = type(k)
      local value_type = type(v)
      if "string" == key_type then
        result = result .. k .. " = "
      elseif "number" == key_type then
        result = result .. "[" .. k .. "] = "
      else
        result = result .. "[" .. string.format("%q", tostring(k) .. " (" .. key_type .. ")") .. "] = "
      end
      if "string" == value_type then
        result = result .. string.format("%q", v)
      elseif "number" == value_type or "boolean" == value_type then
        result = result .. tostring(v)
      elseif "table" == value_type then
        result = result .. serialize_table(v, depth + 1)
      else
        result = result .. string.format("%q", tostring(v) .. " (" .. value_type .. ")")
      end
      count = count + 1
      if count >= 20 then
        result = result .. ", ..."
        break
      end
    end
  end
  result = result .. "}"
  return result
end

local function serialize_params(...)
  local params = {
    ...
  }
  local serialized = {}
  for i, param in ipairs(params) do
    local param_type = type(param)
    if "string" == param_type then
      serialized[i] = string.format("%q", param)
    elseif "number" == param_type or "boolean" == param_type then
      serialized[i] = tostring(param)
    elseif "table" == param_type then
      serialized[i] = serialize_table(param, 1)
    else
      serialized[i] = string.format("%q", tostring(param) .. " (" .. param_type .. ")")
    end
  end
  return serialized
end

function SerializeOnlineRpc.log_rpc_call(func_name, ...)
  if not is_initialized then
    SerializeOnlineRpc.InitRPCLogger()
  end
  if type(func_name) ~= "string" then
    func_name = tostring(func_name)
  end
  SerializeOnlineRpc.call_counter = SerializeOnlineRpc.call_counter + 1
  local entry = {
    func_name = func_name,
    Params = serialize_params(...)
  }
  SerializeOnlineRpc.RPC_Cache[SerializeOnlineRpc.call_counter] = entry
  DebugPrint(string.format("RPC call logged: %s (total: %d)", func_name, SerializeOnlineRpc.call_counter))
end

function SerializeOnlineRpc.SaveRPCCalls()
  if not is_initialized or 0 == SerializeOnlineRpc.call_counter then
    DebugPrint("No RPC calls to save")
    return false
  end
  if not UE4.UBlueprintFileUtilsBPLibrary.DirectoryExists(FileDir) then
    DebugPrint("创建本地缓存明文目录: " .. FileDir)
    UE4.UBlueprintFileUtilsBPLibrary.MakeDirectory(FileDir)
  end
  local file_path = FileDir .. log_file
  local file = io.open(file_path, "w")
  if file then
    file:write("-- RPC调用记录文件（只读）\n")
    file:write("-- 自动生成，请勿手动编辑\n\n")
    file:write("local RPC_Cache = {\n")
    for i, call in ipairs(SerializeOnlineRpc.RPC_Cache) do
      file:write(string.format("\t[%d] = {\n", i))
      file:write(string.format("\t\tfunc_name = %q,\n", call.func_name))
      file:write("\t\tParams = {")
      for j, param in ipairs(call.Params) do
        if j > 1 then
          file:write(", ")
        end
        file:write(param)
      end
      file:write("}\n")
      file:write("\t},\n")
    end
    file:write([[
}

]])
    file:write("return RPC_Cache\n")
    file:close()
    DebugPrint(string.format("RPC calls saved to %s (%d calls)", file_path, SerializeOnlineRpc.call_counter))
    return true
  else
    DebugPrint("Error: Could not open file for writing: " .. file_path)
    return false
  end
end

function SerializeOnlineRpc.ClearRPCCache()
  SerializeOnlineRpc.RPC_Cache = {}
  SerializeOnlineRpc.call_counter = 0
  DebugPrint("RPC cache cleared")
end

function SerializeOnlineRpc.GetRPCCallCount()
  return SerializeOnlineRpc.call_counter
end

SerializeOnlineRpc.InitRPCLogger()
return SerializeOnlineRpc
