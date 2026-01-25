local LogManager = {}
local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()

local function EmptyFunction()
end

function LogManager:GenLogger(Id, ModuleName)
  local Logger = {}
  Logger.info = not (not bDistribution or bEnableShippingLog) and EmptyFunction or function(...)
    if Id and ModuleName then
      DebugPrint("[" .. CommonUtils.ObjId2Str(Id) .. " " .. ModuleName .. "]", ...)
    else
      DebugPrint(...)
    end
  end
  Logger.debug = not (not bDistribution or bEnableShippingLog) and EmptyFunction or function(...)
    if Id and ModuleName then
      DebugPrint("[" .. CommonUtils.ObjId2Str(Id) .. " " .. ModuleName .. "]", ...)
    else
      DebugPrint(...)
    end
  end
  Logger.error = not (not bDistribution or bEnableShippingLog) and EmptyFunction or function(...)
    if Id and ModuleName then
      DebugPrint("[" .. CommonUtils.ObjId2Str(Id) .. " " .. ModuleName .. "]", ...)
    else
      DebugPrint(...)
    end
  end
  return Logger
end

function LogManager:GenClientLogger(Id, ModuleName)
  local Logger = {}
  Logger.info = not (not bDistribution or bEnableShippingLog) and EmptyFunction or function(...)
    if Id and ModuleName then
      DebugPrint("[" .. CommonUtils.ObjId2Str(Id) .. " " .. ModuleName .. "]", ...)
    else
      DebugPrint(...)
    end
  end
  Logger.debug = not (not bDistribution or bEnableShippingLog) and EmptyFunction or function(...)
    if Id and ModuleName then
      DebugPrint("[" .. CommonUtils.ObjId2Str(Id) .. " " .. ModuleName .. "]", ...)
    else
      DebugPrint(...)
    end
  end
  Logger.error = not (not bDistribution or bEnableShippingLog) and EmptyFunction or function(...)
    local Function = UE.UFormulaFunctionLibrary.ShowError
    local str
    if Id and ModuleName then
      str = "[" .. CommonUtils.ObjId2Str(Id) .. " " .. ModuleName .. "]" .. tostring(...)
    else
      str = tostring(...)
    end
    Function(GWorld.GameInstance, str)
    Traceback()
  end
  Logger.errorlog = not (not bDistribution or bEnableShippingLog) and EmptyFunction or function(...)
    local Function = UE.UFormulaFunctionLibrary.ShowErrorOnlyLog
    local str
    if Id and ModuleName then
      str = "[" .. CommonUtils.ObjId2Str(Id) .. " " .. ModuleName .. "]" .. tostring(...)
    else
      str = tostring(...)
    end
    Function(str)
  end
  return Logger
end

return LogManager
