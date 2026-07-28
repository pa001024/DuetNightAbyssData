local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
  M.Super.Init(self)
end

function M:Destory()
  M.Super.Destory(self)
end

function M:IsValid()
  return self:GetAvatar() ~= nil
end

function M:IsStorylineComplete(TalkTriggerId)
  if not self:IsValid() then
    return false
  end
  return self:IsStorylineSuccess(TalkTriggerId) or self:IsStorylineFailure(TalkTriggerId)
end

function M:IsStorylineUnComplete(TalkTriggerId)
  if not self:IsValid() then
    return false
  end
  return not self:IsStorylineComplete(TalkTriggerId)
end

function M:IsStorylineSuccess(TalkTriggerId)
  if not self:IsValid() then
    return false
  end
  return self:GetAvatar().ImpressionTalkTriggers[TalkTriggerId] == CommonConst.ImpressionCheckType.Success
end

function M:IsStorylineFailure(TalkTriggerId)
  if not self:IsValid() then
    return false
  end
  return self:GetAvatar().ImpressionTalkTriggers[TalkTriggerId] == CommonConst.ImpressionCheckType.Failed
end

function M:IsImpressionCheckSuccess(DialogueId)
  if not self:IsValid() then
    return false
  end
  return self:GetAvatar().ImpressionDialogues[DialogueId] == CommonConst.ImpressionCheckType.Success
end

function M:IsImpressionCheckFailure(DialogueId)
  if not self:IsValid() then
    return false
  end
  return self:GetAvatar().ImpressionDialogues[DialogueId] == CommonConst.ImpressionCheckType.Failed
end

function M:CanImpressionCheck(ImpressionAreaId)
  local Ret = {
    ResourceCount = 0,
    Cost = 0,
    bCanCheck = false
  }
  if not self:IsValid() then
    return Ret
  end
  local ImpressionResourceInfo = DataMgr.ImpressionResource[ImpressionAreaId]
  if not ImpressionResourceInfo then
    return Ret
  end
  Ret.ResourceCount = self:GetAvatar():GetResourceNum(ImpressionResourceInfo.ResourceId)
  Ret.Cost = ImpressionResourceInfo.Count
  Ret.bCanCheck = Ret.ResourceCount >= Ret.Cost
  return Ret
end

function M:GetSuccRate(PlayerValue, CheckValue)
  local SuccRate = 100 - CheckValue + PlayerValue
  if SuccRate > 100 then
    SuccRate = 100
  elseif SuccRate < 0 then
    SuccRate = 0
  end
  return SuccRate
end

function M:GetDifficultyInfo(SuccRate)
  SuccRate = SuccRate / 100
  local ImpressionDifficulty = DataMgr.ImpressionDifficulty
  local Easy = ImpressionDifficulty.Easy
  local Middle = ImpressionDifficulty.Middle
  local Hard = ImpressionDifficulty.Hard
  local Impossible = ImpressionDifficulty.Impossible
  local DifficultyInfo = Easy
  if SuccRate < Hard.DifficultyMinValue then
    DifficultyInfo = Impossible
  elseif SuccRate < Middle.DifficultyMinValue then
    DifficultyInfo = Hard
  elseif SuccRate < Easy.DifficultyMinValue then
    DifficultyInfo = Middle
  end
  return DifficultyInfo
end

function M:GetImpressionCheckInfo(CheckId)
  local ImpressionCheck = DataMgr.ImpressionCheck[CheckId]
  if not ImpressionCheck then
    return nil
  end
  local CheckInfo = {
    CheckRegionId = ImpressionCheck.RegionId
  }
  for _, Type in pairs(CommonConst.ImpressionType) do
    if ImpressionCheck[Type .. "Check"] > 0 then
      CheckInfo.CheckType = Type
    end
  end
  return CheckInfo
end

function M:GetImpressionAreaIdFromRegionId(TargetRegionId)
  if not TargetRegionId then
    if not self:IsValid() then
      return nil
    end
    TargetRegionId = self:GetAvatar():GetSubRegionId2RegionId()
  end
  local ImpressionRegions = DataMgr.ImpressionRegion
  for ImpressionRegionId, RegionInfo in pairs(ImpressionRegions) do
    local Regions = RegionInfo.RegionId
    for _, RegionId in pairs(Regions) do
      if TargetRegionId == RegionId then
        return ImpressionRegionId
      end
    end
  end
  Utils.ScreenPrint("未找到印象区域ID，请检查 RegionId 是否在 ImpressionRegion 表中, SubRegionId:" .. TargetRegionId)
  return TargetRegionId
end

function M:GetRegionImpression(ImpressionAreaId)
  if not self:IsValid() then
    return nil
  end
  return self:GetAvatar().Impressions:GetImpression(ImpressionAreaId)
end

function M:CheckDialogueOptionType(OptionIds)
  if not OptionIds then
    return nil
  end
  local DialougeType
  for _, OptionId in ipairs(OptionIds) do
    local DialogueData = DataMgr.Dialogue[OptionId]
    local Type = "dialogue"
    if DialogueData.ImprCheckId then
      Type = "check"
    end
    if DialogueData.ImprPlusId then
      Type = "plus"
    end
    if nil ~= DialougeType and Type ~= DialougeType then
      local DialogueIdsStr = OptionIds and table.concat(OptionIds, ", ") or ""
      local Message = "Dialogue 各选项之间类型不同\nDialogueIds: " .. DialogueIdsStr
      local Title = "印象系统错误：选项类型不同"
      UStoryLogUtils.PrintToFeiShu(self, UE4.EStoryLogType.Impression, Title, Message)
      DebugPrint("Dialogue 各选项之间类型不同\nDialogueIds:", DialogueIdsStr)
      return nil
    end
    DialougeType = Type
  end
  return DialougeType
end

return M
