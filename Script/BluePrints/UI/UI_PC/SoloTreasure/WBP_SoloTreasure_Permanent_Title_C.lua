require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local PermanentSoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.PermanentSoloTreasureDataModel")
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local ActivityTimeTimerKey = "SoloTreasure_Permanent_Title_ActivityTime"

function M:SetInfo(Info)
  self:RemoveTimer(ActivityTimeTimerKey)
  self.Text_Title:SetText(GText(Info.MainTitle))
  if self.Group_Time then
    self.Group_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:StopAllAnimations()
  if self.In then
    self:PlayAnimation(self.In)
  end
end

function M:Init(SeasonId)
  self:RemoveTimer(ActivityTimeTimerKey)
  self.SeasonId = SeasonId
  if self.Text_Title then
    self.Text_Title:SetText(GText("UI_Play_TreasureHunt_Title"))
  end
  if not self.Activity_Time then
    return
  end
  local Remaining, IsPlayable = PermanentSoloTreasureDataModel:GetSeasonTimeInfo(SeasonId)
  if not (IsPlayable and Remaining) or Remaining <= 0 then
    if self.Activity_Time.Text_TimeDesc then
      self.Activity_Time.Text_TimeDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if self.Activity_Time.Text_TimeTitle then
      self.Activity_Time.Text_TimeTitle:SetText(GText("UI_Play_TreasureHunt_NotInTime"))
    end
    return
  end
  if self.Activity_Time.Text_TimeDesc then
    self.Activity_Time.Text_TimeDesc:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self.ActivityEndTime = TimeUtils.NowTime() + Remaining
  self:UpdateActivityTime()
  self:AddTimer(1, self.UpdateActivityTime, true, 0, ActivityTimeTimerKey)
end

function M:UpdateActivityTime()
  if not self.Activity_Time then
    return
  end
  if TimeUtils.NowTime() >= self.ActivityEndTime then
    self:RemoveTimer(ActivityTimeTimerKey)
    self:Init(self.SeasonId)
    return
  end
  local RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(self.ActivityEndTime)
  self.Activity_Time:SetCountdownTextOnly(RemainTimeDict, GText("UI_Play_TreasureHunt_TimeRemain"))
end

function M:Destruct()
  self:RemoveTimer(ActivityTimeTimerKey)
end

AssembleComponents(M)
return M
