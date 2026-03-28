local HotUpdateUtils = {}
local EMLuaConst = require("EMLuaConst")
local SettingUtils = require("Utils.SettingUtils")
local EMCache = require("EMCache.EMCache")
local _NecessoryPatchSigns = {}

function HotUpdateUtils.NormalizeNecessoryPatchSigns(IncomingSigns)
  if not IncomingSigns then
    return {}
  end
  local Signs = IncomingSigns
  if type(Signs) ~= "table" then
    if Signs.ToTable then
      Signs = Signs:ToTable()
    else
      return {}
    end
  end
  local Result = {}
  local Existing = {}
  for _, Sign in pairs(Signs) do
    if Sign and "" ~= Sign and not Existing[Sign] then
      table.insert(Result, Sign)
      Existing[Sign] = true
    end
  end
  return Result
end

function HotUpdateUtils.MergeNecessoryPatchSigns(IncomingSigns)
  if not EMLuaConst.bEnableOptionalPatch then
    _NecessoryPatchSigns = {}
    return
  end
  IncomingSigns = HotUpdateUtils.NormalizeNecessoryPatchSigns(IncomingSigns)
  if 0 == #IncomingSigns then
    return
  end
  local Existing = {}
  for _, v in ipairs(_NecessoryPatchSigns) do
    Existing[v] = true
  end
  for _, v in ipairs(IncomingSigns) do
    if v and not Existing[v] then
      table.insert(_NecessoryPatchSigns, v)
      Existing[v] = true
    end
  end
end

function HotUpdateUtils.GetNecessoryPatchSigns()
  if not EMLuaConst.bEnableOptionalPatch then
    _NecessoryPatchSigns = {}
  end
  return _NecessoryPatchSigns
end

function HotUpdateUtils.TryAutoDownloadNextNecessoryPatch(WorldContextObject)
  local bHasWifi = UHotUpdateFunctionLibrary.HasActiveWiFiConnection()
  if not bHasWifi and not EMCache:Get("AllowDataDownload") then
    return
  end
  if HotUpdateUtils.bDisableAutoDownload then
    return
  end
  local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(WorldContextObject, UHotUpdateSubsystem)
  if not HotUpdateSubsystem or HotUpdateSubsystem:IsCommonGameUpdating() or HotUpdateSubsystem:HasDownloadTask() then
    return
  end
  if not SettingUtils.GetEMCache("AutoBackground", nil, true) then
    return
  end
  local NecessoryPatchSigns = HotUpdateUtils.GetNecessoryPatchSigns()
  local UsePatchSigns = {}
  for _, PatchId in ipairs(NecessoryPatchSigns) do
    table.insert(UsePatchSigns, PatchId)
  end
  if not NecessoryPatchSigns or 0 == #NecessoryPatchSigns then
    for PatchId, PatchData in pairs(DataMgr.PatchResource) do
      if PatchData and PatchData.SortPriority then
        table.insert(UsePatchSigns, PatchId)
      end
    end
  end
  local BestSign
  local BestPriority = math.huge
  for _, PatchId in ipairs(UsePatchSigns) do
    if not HotUpdateSubsystem:IsAllPatchOptionalSignsDownloaded({PatchId}) and not HotUpdateSubsystem:IsPatchOptionSignPaused2(PatchId) then
      local PatchData = DataMgr.PatchResource[PatchId]
      local Priority = PatchData and PatchData.SortPriority or 1.0E308
      if BestPriority > Priority then
        BestPriority = Priority
        BestSign = PatchId
      end
    end
  end
  if BestSign then
    HotUpdateSubsystem:TryStartUpdate(BestSign, {BestSign}, true)
  end
end

function HotUpdateUtils.IsCurrentNecessoryPatchSign(PatchSign)
  local NecessoryPatchSigns = HotUpdateUtils.GetNecessoryPatchSigns()
  if not NecessoryPatchSigns or 0 == #NecessoryPatchSigns then
    return false
  end
  local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UHotUpdateSubsystem)
  if not HotUpdateSubsystem then
    return false
  end
  local BestSign
  local BestPriority = math.huge
  for _, PatchId in ipairs(NecessoryPatchSigns) do
    if not HotUpdateSubsystem:IsAllPatchOptionalSignsDownloaded({PatchId}) then
      local PatchData = DataMgr.PatchResource[PatchId]
      local Priority = PatchData and PatchData.SortPriority or 1.0E308
      if BestPriority > Priority then
        BestPriority = Priority
        BestSign = PatchId
      end
    end
  end
  return BestSign == PatchSign
end

function HotUpdateUtils.ClearNecessoryPatchSigns()
  _NecessoryPatchSigns = {}
end

HotUpdateUtils.bDisableAutoDownload = false
return HotUpdateUtils
