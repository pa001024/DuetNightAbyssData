local ConditionTree = {}

function ConditionTree:New(Docker)
  local CT = {}
  setmetatable(CT, {__index = ConditionTree})
  CT.Docker = Docker
  return CT
end

function ConditionTree:Check(Condition)
  if not Condition then
    return true
  end
  if Condition.And then
    return self:And(Condition.And)
  end
  if Condition.Or then
    return self:Or(Condition.Or)
  end
  if Condition.Not then
    return self:Not(Condition.Not)
  end
  for Func, Param in pairs(Condition) do
    if self.Docker[Func] then
      return self.Docker[Func](self.Docker, Param)
    end
  end
  return true
end

function ConditionTree:And(Condition)
  for _, Cond in ipairs(Condition) do
    if not self:Check(Cond) then
      return false
    end
  end
  return true
end

function ConditionTree:Or(Condition)
  for _, Cond in ipairs(Condition) do
    if self:Check(Cond) then
      return true
    end
  end
  return false
end

function ConditionTree:Not(Condition)
  return not self:Check(Condition)
end

local LoadingCondition = {}
local LoadingConditionState = {}

function LoadingCondition:QuestStart(Params)
  local QuestId = Params.QuestId
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return false
  end
  local RtnRes = Avatar:IsQuestDoing(QuestId)
  return RtnRes
end

function LoadingCondition:QuestUnstart(Params)
  local QuestId = Params.QuestId
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return false
  end
  local RtnRes = not Avatar:IsQuestDoing(QuestId) and not Avatar:IsQuestFinished(QuestId)
  return RtnRes
end

function LoadingCondition:QuestFinish(Params)
  local QuestId = Params.QuestId
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return false
  end
  local RtnRes = Avatar:IsQuestFinished(QuestId)
  return RtnRes
end

function LoadingCondition:ActivityRacing(Params)
  return LoadingConditionState.IsActivityRacing
end

local function WeightedRandom(Pool, TotalWeight)
  local Rand = math.random(1, TotalWeight)
  local Accumulated = 0
  for _, Entry in ipairs(Pool) do
    Accumulated = Accumulated + Entry.Weight
    if Rand <= Accumulated then
      return Entry.LoadingData
    end
  end
  return nil
end

local SpecialLoadingRule = {}

function SpecialLoadingRule:SetLoadingConditionState(Key, Value)
  if Key then
    LoadingConditionState[Key] = Value
  end
end

function SpecialLoadingRule:TryEnterActivityRacingLoading()
  self:SetLoadingConditionState("IsActivityRacing", true)
end

function SpecialLoadingRule:TryLeaveActivityRacingLoading(bForce)
  if LoadingConditionState.IsActivityRacing then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not bForce and GameMode and GameMode.TargetSubRegion and GameMode.TargetSpawnPoint then
      return
    end
    self:SetLoadingConditionState("IsActivityRacing", false)
  end
end

function SpecialLoadingRule:CheckRegionCondition(Region, LastRegion, Rule, bIsCrossRegion)
  if not Rule then
    return false
  end
  if Rule.From and (not LastRegion or Rule.From ~= LastRegion.RegionType) then
    return false
  end
  if Rule.To and Rule.To ~= Region.RegionType then
    return false
  end
  if not Rule.SubId and not Rule.SpawnPoint then
    return bIsCrossRegion
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not GameMode then
    return false
  end
  if Rule.SubId and GameMode.TargetSubRegion ~= Rule.SubId then
    return false
  end
  if Rule.SpawnPoint and GameMode.TargetSpawnPoint ~= Rule.SpawnPoint then
    return false
  end
  return true
end

function SpecialLoadingRule:GetCutSceneInfo()
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.IsInCutSceneReview and Avatar:IsInCutSceneReview() then
    return Avatar:GetCutSceneReviewChapterId()
  end
end

function SpecialLoadingRule:GetLoadingBpPath(bIsCrossRegion)
  local LoadingData, SpecialLoadingBp = self:_GetLoadingBpPathExternal(bIsCrossRegion)
  self:TryLeaveActivityRacingLoading(true)
  return LoadingData, SpecialLoadingBp
end

function SpecialLoadingRule:_GetLoadingBpPathExternal(bIsCrossRegion)
  local CutSceneInfo = self:GetCutSceneInfo()
  if CutSceneInfo then
    return CutSceneInfo, "WidgetBlueprint'/Game/UI/WBP/Memory/Widget/WBP_Memory_Loading.WBP_Memory_Loading'"
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode and GWorld.GameInstance.QuestDeliverId and GWorld.GameInstance.QuestDeliverLoadingId and GWorld.GameInstance.QuestDeliverId == GameMode.TargetSubRegion then
    local LoadingData = DataMgr.RegionLoading[GWorld.GameInstance.QuestDeliverLoadingId]
    GWorld.GameInstance.QuestDeliverId = nil
    GWorld.GameInstance.QuestDeliverLoadingId = nil
    if LoadingData then
      return LoadingData, LoadingData.WBPPath
    end
  end
  local SceneId = WorldTravelSubsystem():GetCurrentSceneId()
  local LastSceneId = WorldTravelSubsystem():GetLastSceneId()
  if not DataMgr.Region or not DataMgr.SpecialLoading then
    return
  end
  local Region = DataMgr.Region[SceneId]
  local LastRegion = DataMgr.Region[LastSceneId]
  if not Region then
    return
  end
  for _, Rule in pairs(DataMgr.SpecialLoading) do
    if self:CheckRegionCondition(Region, LastRegion, Rule.Region, bIsCrossRegion) then
      local CT = ConditionTree:New(LoadingCondition)
      if CT:Check(Rule.TriggerCondition) then
        local LoadingData = DataMgr.RegionLoading[Rule.LoadingId]
        if not LoadingData then
          return
        end
        return LoadingData, LoadingData.WBPPath
      end
    end
  end
end

function SpecialLoadingRule:GetRanLoadingData()
  local RanLoadingBGTable = DataMgr.RanLoadingBG
  if not RanLoadingBGTable then
    return nil
  end
  local CurrentVersionConst = DataMgr.GlobalConstant and DataMgr.GlobalConstant.CurrentVersion
  local CurrentVersion = CurrentVersionConst and CurrentVersionConst.ConstantValue
  local NoVersionPool, NoVersionWeight = {}, 0
  local VersionPool, VersionWeight = {}, 0
  for _, v in pairs(RanLoadingBGTable) do
    local RegionLoadingData = DataMgr.RegionLoading[v.LoadingId]
    if RegionLoadingData and RegionLoadingData.WBPPath then
      local w = v.Weight or 0
      if not v.CurrentVersion or v.CurrentVersion == "" then
        table.insert(NoVersionPool, {LoadingData = RegionLoadingData, Weight = w})
        NoVersionWeight = NoVersionWeight + w
      elseif v.CurrentVersion == CurrentVersion then
        table.insert(VersionPool, {LoadingData = RegionLoadingData, Weight = w})
        VersionWeight = VersionWeight + w
      end
    end
  end
  if #NoVersionPool > 0 and NoVersionWeight > 0 then
    return WeightedRandom(NoVersionPool, NoVersionWeight)
  end
  if #VersionPool > 0 and VersionWeight > 0 then
    return WeightedRandom(VersionPool, VersionWeight)
  end
  return nil
end

return SpecialLoadingRule
