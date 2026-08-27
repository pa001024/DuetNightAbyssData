local Utils = {}
local table_concat = table.concat
local tostring = _ENV.tostring
local type = _ENV.type
local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
local TextUtils = require("Utils.TextUtils")
local MiscUtils = require("Utils.MiscUtils")
Utils.PrintTable = not (not bDistribution or bEnableShippingLog) and MiscUtils.EmptyFunction or function(Targets, deep, Title, PrettyFormat)
  if nil == Targets then
    return
  end
  if "table" ~= type(Targets) then
    print(LogTag, tostring(Targets))
    return
  end
  deep = deep or 1
  local ct = {
    "PrintTable: ",
    tostring(Title),
    tostring(Targets),
    "\n"
  }
  MiscUtils.GetStrTable(ct, Targets, 1, deep, PrettyFormat)
  local ret = table_concat(ct)
  print(LogTag, ret)
  return ret
end
_G.PrintTable = Utils.PrintTable
Utils.Traceback = not (not bDistribution or bEnableShippingLog) and MiscUtils.EmptyFunction or function(logTag, err, bNotPrint)
  local error = debug.traceback()
  if err then
    error = err .. "\n" .. error
  end
  logTag = logTag or LogTag
  if not bNotPrint then
    DebugPrint(logTag, error)
  end
  return error
end
_G.Traceback = Utils.Traceback

function Utils.IsStandAlone(Actor)
  return UNeModeFunctionLibrary.IsStandAlone(Actor)
end

_G.IsStandAlone = Utils.IsStandAlone

function Utils.IsDedicatedServer(Obj)
  if GWorld._IsDedicatedServer ~= nil and not GWorld.IsDev then
    return GWorld._IsDedicatedServer
  end
  return UKismetSystemLibrary.IsDedicatedServer(Obj)
end

_G.IsDedicatedServer = Utils.IsDedicatedServer

function Utils.IsClient(Actor)
  return UNeModeFunctionLibrary.IsClient(Actor)
end

_G.IsClient = Utils.IsClient

function Utils.IsAuthority(actor)
  return 3 == actor:GetLocalRole()
end

_G.IsAuthority = Utils.IsAuthority

function Utils.New(Table)
  if nil == Table then
    return Table
  end
  if "table" ~= type(Table) then
    return Table
  end
  local Obj = {}
  local mt = getmetatable(Table)
  if nil ~= mt then
    setmetatable(Obj, mt)
  end
  for i, v in pairs(Table) do
    if "table" == type(v) then
      Obj[i] = Utils.New(v)
    else
      Obj[i] = v
    end
  end
  return Obj
end

_G.New = Utils.New

function Utils.IsEmptyTable(Table)
  return table.isempty(Table)
end

_G.IsEmptyTable = Utils.IsEmptyTable

function Utils.Split(str, reps)
  local Results = {}
  string.gsub(str, "[^" .. reps .. "]+", function(w)
    table.insert(Results, w)
  end)
  return Results
end

Utils.ScreenPrint = not (not bDistribution or bEnableShippingLog) and MiscUtils.EmptyFunction or function(text)
  GWorld.logger.error(text)
end
_G.ScreenPrint = Utils.ScreenPrint
Utils.GreenPrint = MiscUtils.GreenPrint
_G.GreenPrint = Utils.GreenPrint

function Utils.GText(Text)
  return TextUtils:GetDisplayText(Text)
end

_G.GText = Utils.GText

function Utils.EnText(Text)
  return TextUtils:GetDisplayText(Text, CommonConst.SystemLanguages.EN)
end

_G.EnText = Utils.EnText

function Utils.GDate_YMD(Year, Month, Day, Language)
  Language = Language or CommonConst.SystemLanguage
  if Language == CommonConst.SystemLanguages.CN or Language == CommonConst.SystemLanguages.JP or Language == CommonConst.SystemLanguages.KR then
    return string.format("%02d-%02d-%02d", Year, Month, Day)
  else
    return string.format("%02d-%02d-%02d", Day, Month, Year)
  end
end

_G.GDate_YMD = Utils.GDate_YMD

function Utils.GDate_YMD_Timestamp(Timestamp, Language)
  local Date = os.date("*t", Timestamp)
  return Utils.GDate_YMD(Date.year, Date.month, Date.day, Language)
end

_G.GDate_YMD_Timestamp = Utils.GDate_YMD_Timestamp

function Utils.Split(input, delimiter)
  input = tostring(input)
  delimiter = tostring(delimiter)
  if "" == delimiter then
    return false
  end
  local pos, arr = 0, {}
  for st, sp in function()
    return string.find(input, delimiter, pos, true)
  end, nil, nil, nil do
    table.insert(arr, string.sub(input, pos, st - 1))
    pos = sp + 1
  end
  table.insert(arr, string.sub(input, pos))
  return arr
end

_G.Split = Utils.Split
local UIManager_Var

function Utils.UIManager(context)
  if not Utils.IsValid(UIManager_Var) then
    DebugPrint(WarningTag, "Utils.UIManager 重新获得UIManager")
    context = context or GWorld.GameInstance
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(context)
    UIManager_Var = GameInstance:GetGameUIManager()
    return UIManager_Var
  end
  return UIManager_Var
end

_G.UIManager = Utils.UIManager

function Utils.GameState(context)
  context = context or GWorld.GameInstance
  return UE4.UGameplayStatics.GetGameState(context)
end

_G.GameState = Utils.GameState
Utils.IsValid = MiscUtils.IsValid
_G.IsValid = Utils.IsValid
local AudioManager_Var

function Utils.AudioManager(context)
  if not AudioManager_Var then
    AudioManager_Var = MiscUtils.GetAudioManager_Lua(context)
  end
  return AudioManager_Var
end

_G.AudioManager = Utils.AudioManager

function Utils.HeroUSDKSubsystem(WorldContext)
  WorldContext = WorldContext or GWorld.GameInstance
  return USubsystemBlueprintLibrary.GetGameInstanceSubsystem(WorldContext, UEMHeroUSDKSubsystem)
end

_G.HeroUSDKSubsystem = Utils.HeroUSDKSubsystem

function Utils.WorldTravelSubsystem(WorldContext)
  WorldContext = WorldContext or GWorld.GameInstance
  return USubsystemBlueprintLibrary.GetGameInstanceSubsystem(WorldContext, UWorldTravelSubsystem)
end

_G.WorldTravelSubsystem = Utils.WorldTravelSubsystem

function Utils.TalkSubsystem(WorldContext)
  WorldContext = WorldContext or GWorld.GameInstance
  return USubsystemBlueprintLibrary.GetWorldSubsystem(WorldContext, UTalkSubsystem)
end

_G.TalkSubsystem = Utils.TalkSubsystem
return Utils
