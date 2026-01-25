require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
  self.EventId = ActivityConfigData.EventId
  self:UpdatePage()
end

function M:UpdatePage()
  self.IsShow = self:IsPrerequisiteSatisfied()
  if self.IsShow then
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local Rate = math.floor((DataMgr.ModDropConstant.EventBonus.ConstantValue or 0) / 100)
  local DropTotalTimes = DataMgr.ModDropConstant.DailyModDungeonAmount.ConstantValue or 0
  local EliteRushTotalTimes = DataMgr.ModDropConstant.DailyFreeTicketAmount.ConstantValue or 0
  local RemainDropTimes = DropTotalTimes - (Avatar.DoubleModDrop[self.EventId] and Avatar.DoubleModDrop[self.EventId].DropTimes or 0)
  local RemainEliteRushTimes = EliteRushTotalTimes - (Avatar.DoubleModDrop[self.EventId] and Avatar.DoubleModDrop[self.EventId].EliteRushTimes or 0)
  local Text_DoubleModDrop, Text_EliteRush
  if 0 == RemainDropTimes then
    Text_DoubleModDrop = GText("UI_Event_ModDrop_DropRemain") .. "<Warning>" .. RemainDropTimes .. "</>" .. "/" .. DropTotalTimes
  else
    Text_DoubleModDrop = GText("UI_Event_ModDrop_DropRemain") .. RemainDropTimes .. "/" .. DropTotalTimes
  end
  if 0 == RemainEliteRushTimes then
    Text_EliteRush = GText("UI_Event_ModDrop_ChallengeRemain") .. "<Warning>" .. RemainEliteRushTimes .. "</>" .. "/" .. EliteRushTotalTimes
  else
    Text_EliteRush = GText("UI_Event_ModDrop_ChallengeRemain") .. RemainEliteRushTimes .. "/" .. EliteRushTotalTimes
  end
  self.Text_ModUpTitle:SetText(GText("UI_Event_ModDrop_Title2_1"))
  self.Text_NewModView:SetText(GText("UI_Event_ModDrop_Title2_2"))
  self.Text_DoubleModTitle:SetText(GText("UI_Event_ModDrop_ChallengeName"))
  self.Text_ModUpTodayTimes:SetText(Text_DoubleModDrop)
  self.Text_NewModTodayTimes:SetText(Text_EliteRush)
  self.Text_TimesTips:SetText(GText("UI_Event_ModDrop_Reset"))
  self.Text_ModUpNum:SetText("+" .. Rate .. "%")
end

function M:IsPrerequisiteSatisfied()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local DoubleModEventInfo = DataMgr.EventMain[self.EventId]
  if not DoubleModEventInfo then
    ScreenPrint("EventMain表中找不到m魔之楔活动相关信息！读取的EventId:" .. self.EventId)
    return false
  end
  local PrerequisiteQuestId = {}
  if DoubleModEventInfo.PretextTasks1 then
    table.insert(PrerequisiteQuestId, DoubleModEventInfo.PretextTasks1)
  end
  for _, QuestId in pairs(DoubleModEventInfo.PretextTasks2 or {}) do
    table.insert(PrerequisiteQuestId, QuestId)
  end
  for _, QuestId in pairs(PrerequisiteQuestId) do
    local QuestChain = Avatar.QuestChains[QuestId]
    if not QuestChain then
      ScreenPrint("魔之楔 配置了一个不存在的任务链Id！请策划检查！Id:" .. QuestId)
      return false
    end
    if not QuestChain:IsFinish() then
      return false
    end
  end
  return true
end

return M
