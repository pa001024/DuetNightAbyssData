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

local SpecialLoadingRule = {}

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

function SpecialLoadingRule:GetLoadingBpPath(bIsCrossRegion)
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

return SpecialLoadingRule
