local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
local bGateClosed = bDistribution and not bEnableShippingLog

local function EmptyFunction()
end

local AIDeBugLogTable = {}

local function AIDeBugSortKeys(Data)
  local Keys = {}
  for Key in pairs(Data) do
    table.insert(Keys, Key)
  end
  table.sort(Keys, function(Left, Right)
    return tostring(Left) < tostring(Right)
  end)
  return Keys
end

local function AIDeBugValueToString(Value, Depth, Visited)
  if type(Value) ~= "table" then
    return tostring(Value)
  end
  if Visited[Value] then
    return "<cycle>"
  end
  if Depth <= 0 then
    return tostring(Value)
  end
  Visited[Value] = true
  local Count = #Value
  local Parts = {}
  if Count > 0 then
    for Index = 1, Count do
      table.insert(Parts, AIDeBugValueToString(Value[Index], Depth - 1, Visited))
    end
    Visited[Value] = nil
    return "[" .. table.concat(Parts, ",") .. "]"
  end
  for _, Key in ipairs(AIDeBugSortKeys(Value)) do
    table.insert(Parts, tostring(Key) .. "=" .. AIDeBugValueToString(Value[Key], Depth - 1, Visited))
  end
  Visited[Value] = nil
  return "{" .. table.concat(Parts, " | ") .. "}"
end

local function AIDeBugAppendMessagePart(Parts, Part)
  if type(Part) ~= "table" then
    table.insert(Parts, tostring(Part))
    return
  end
  for _, Key in ipairs(AIDeBugSortKeys(Part)) do
    table.insert(Parts, tostring(Key) .. "=" .. AIDeBugValueToString(Part[Key], 4, {}))
  end
end

local function AIDeBugBuildMessage(...)
  local Packed = table.pack(...)
  local Parts = {}
  for Index = 1, Packed.n do
    AIDeBugAppendMessagePart(Parts, Packed[Index])
  end
  return table.concat(Parts, " | ")
end

function AIDeBugLogTable.IsEnabled()
  return UE4.UEMLuaConst.GetAIDebugLog() == true
end

function AIDeBugLogTable.Log(ModulePrefix, Stage, ...)
  if not AIDeBugLogTable.IsEnabled() then
    return
  end
  local Frame = UE4.UKismetSystemLibrary.GetFrameCount()
  print(string.format("[%s][Frame=%s][%s] %s", tostring(ModulePrefix), tostring(Frame), tostring(Stage), AIDeBugBuildMessage(...)))
end

function AIDeBugLogTable.Abort(ModulePrefix, InterruptedStage, Reason, ...)
  local Content = "Stage=" .. tostring(InterruptedStage) .. " | Reason=" .. tostring(Reason)
  local Extra = AIDeBugBuildMessage(...)
  if "" ~= Extra then
    Content = Content .. " | " .. Extra
  end
  AIDeBugLogTable.Log(ModulePrefix, "ABORT", Content)
end

function AIDeBugLogTable.Done(ModulePrefix, ...)
  AIDeBugLogTable.Log(ModulePrefix, "DONE", ...)
end

_G.AIDeBugLog = bGateClosed and {
  IsEnabled = function()
    return false
  end,
  Log = EmptyFunction,
  Abort = EmptyFunction,
  Done = EmptyFunction
} or AIDeBugLogTable
local AIProbeTable = {}

function AIProbeTable.Log(ModulePrefix, Stage, ...)
  local Frame = UE4.UKismetSystemLibrary.GetFrameCount()
  print(string.format("[%s][Frame=%s][%s] %s", tostring(ModulePrefix), tostring(Frame), tostring(Stage), AIDeBugBuildMessage(...)))
end

function AIProbeTable.Abort(ModulePrefix, InterruptedStage, Reason, ...)
  local Content = "Stage=" .. tostring(InterruptedStage) .. " | Reason=" .. tostring(Reason)
  local Extra = AIDeBugBuildMessage(...)
  if "" ~= Extra then
    Content = Content .. " | " .. Extra
  end
  AIProbeTable.Log(ModulePrefix, "ABORT", Content)
end

function AIProbeTable.Done(ModulePrefix, ...)
  AIProbeTable.Log(ModulePrefix, "DONE", ...)
end

_G.AIProbe = bGateClosed and {
  Log = EmptyFunction,
  Abort = EmptyFunction,
  Done = EmptyFunction
} or AIProbeTable
return {}
