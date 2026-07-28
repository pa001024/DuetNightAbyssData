local M = Class("BluePrints.Common.MVC.Controller")
local ImpressionModel = require("BluePrints.Story.Talk.Model.ImpressionModel")
local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")

function M:Init()
  M.Super.Init(self)
end

function M:Destory()
  M.Super.Destory(self)
end

function M:GetModel()
  return ImpressionModel
end

function M:GetEventName()
  return "ImpressionController"
end

function M:IsValid()
  return self:GetAvatar() ~= nil
end

function M:TryRequestCheck(DialogueChain, CurrentDialogueId, TalkTriggerId, ImpressionAreaId, ClientDelegate, CheckInfo, UsingGM, bTalkOptions)
  if not self:IsValid() then
    return
  end
  local ret = self:GetModel():CanImpressionCheck(ImpressionAreaId)
  local DiceNum = ret.ResourceCount
  self:GetAvatar():ImpressionCheckByEnumId_New(DialogueChain, CurrentDialogueId, TalkTriggerId, ImpressionAreaId, DiceNum, ClientDelegate, CheckInfo, UsingGM, bTalkOptions)
  return
end

function M:TryRequestPlus(DialogueChain, CurrentDialogueId, ClientDelegate, UsingGM)
  if not self:IsValid() then
    return
  end
  self:GetAvatar():ImpressionAddByEnumId_New(DialogueChain, CurrentDialogueId, ClientDelegate, UsingGM)
  return
end

function M:ShowCommonImpressionReward(Code, Res, CheckData, Rewards, Callback)
  if not (ErrorCode:Check(Code) and Res and Rewards and CheckData) or not CheckData.RewardId then
    if Callback then
      Callback()
    end
    return false
  end
  local RewardData = DataMgr.Reward[CheckData.RewardId]
  local ItemPageUI = UIManager(GWorld.GameInstance):LoadUINew("GetItemPage", RewardData.Type[1], RewardData.Id[1], RewardData.Count[1][1], Rewards)
  if ItemPageUI and ItemPageUI.BindActionOnClosed then
    ItemPageUI:BindActionOnClosed(function()
      if Callback then
        Callback()
      end
    end, self)
  elseif Callback then
    Callback()
  end
  return true
end

function M:SetTalkTriggerComplete(TalkTriggerId)
  local TalkTrigger = DataMgr.TalkTrigger[TalkTriggerId]
  if not TalkTrigger then
    return false
  end
  EventManager:FireEvent(EventID.OnTalkTriggerComplete, TalkTriggerId)
  if TalkTrigger.Type == "Impression" then
    if not self:IsValid() then
      return false
    end
    self:GetAvatar():SetTalkTriggerComplete_New(TalkTriggerId, {
      self,
      function()
        DebugPrint("Log: Impression Talk Finished", TalkTriggerId)
      end
    })
  end
  return true
end

function M:ShowImpressionPlusUI(ImprPlusId, Callback)
  DebugPrint("ShowImpressionPlusUI")
  if not self:IsValid() then
    return
  end
  Callback = Callback or function()
  end
  local PlusInfo = TalkUtils:GetImpressionPlusInfo(ImprPlusId)
  if PlusInfo then
    local ImpressionAreaId = PlusInfo.ImpressionAreaId
    local PlusType = PlusInfo.PlusType
    local PlusValue = PlusInfo.PlusValue
    DebugPrint("ImpressionAreaId,PlusType,PlusValue:,", ImpressionAreaId, PlusType, PlusValue)
    local ImpressionDimensionResultUI = UIManager(GWorld.GameInstance):LoadUINew("ImpressionDimensionResult")
    ImpressionDimensionResultUI:Init(true, ImpressionAreaId, PlusType, PlusValue)
    ImpressionDimensionResultUI:SetOnCloseDelegate({
      self,
      function()
        UIManager(GWorld.GameInstance):UnLoadUINew("ImpressionDimensionResult")
        Callback()
      end
    })
    ImpressionDimensionResultUI:FadeIn()
  else
    Utils.ScreenPrint("显示印象加值UI时，ID " .. tostring(ImprPlusId) .. " 在 ImpressionPlus 表中不存在，请检查")
    Callback()
  end
end

return M
