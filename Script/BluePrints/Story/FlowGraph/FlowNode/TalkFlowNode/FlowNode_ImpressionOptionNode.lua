local FTalkTriggerComponent = require("BluePrints.Story.Talk.Component.TalkTriggerComponent")
local ETalkNodeFinishType = require("StoryCreator.StoryLogic.StorylineUtils").ETalkNodeFinishType
local M = Class("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.FlowNode_OptionNode")
local FlowLogType = UE.EStoryLogType.TalkFlow

function M:ReceiveBeginPlay()
end

function M:GetLastCheckSuccessId()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  for _, OptionData in pairs(self.Options) do
    if Avatar and Avatar:IsImpressionCheckSuccess(OptionData.DialogueId) then
      return OptionData.DialogueId
    end
  end
end

function M:GetRecordOptionData(OptionDialogueId)
  local Option = DataMgr.Dialogue[OptionDialogueId]
  local OptionType
  if Option.ImprPlusId then
    OptionType = "Plus"
  elseif Option.ImprCheckId then
    OptionType = "Check"
  end
  local OptionData = {
    bImpression = true,
    OptionType = OptionType,
    Options = self:GetConditionOptions(),
    VisitedOptions = self:IsFinalConnected() and self.SelectOptions or {},
    SelectedOption = OptionDialogueId
  }
  return OptionData
end

function M:Skip()
  local DialogueRecordComponent = self:TryGetRecordComponent()
  local LastCheck = self:GetLastCheckSuccessId()
  if LastCheck then
    DialogueRecordComponent:OnOptionRecord(LastCheck, self:GetRecordOptionData(LastCheck))
    self:SelectOption(LastCheck)
  else
    local Message = string.format("当前Option节点不可以跳过, 不应该走过来")
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow印象选项节点出错：Skip", Message)
  end
end

function M:CanSkip()
  return self:GetLastCheckSuccessId() ~= nil and not self.bForbidSkip
end

function M:SelectOption(OptionId, FinishType)
  if FinishType == ETalkNodeFinishType.Fail then
    self:FailSelectOption(OptionId)
  else
    self:FinishSelectOption(OptionId)
  end
end

function M:GetSavedOptions()
  local LastCheckId = self:GetLastCheckSuccessId()
  if LastCheckId then
    return {LastCheckId}
  end
  return {}
end

return M
