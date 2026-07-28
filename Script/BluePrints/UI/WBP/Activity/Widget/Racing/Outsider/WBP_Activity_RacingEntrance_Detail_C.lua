require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
  self.EventId = ActivityConfigData.EventId
  self:RefreshBaseInfo(ActivityConfigData)
  self:RefreshUIInfo()
  EventManager:AddEvent(RacingActivityConst.EventId.NextDayRefresh, self, self.Update)
  EventManager:AddEvent(RacingActivityConst.EventId.EightThirtyRefresh, self, self.Update)
  EventManager:AddEvent(RacingActivityConst.EventId.EightRefresh, self, self.Update)
end

function M:RefreshBaseInfo(ActivityConfigData)
  self.Text_DetailTitle01:SetText(GText("UI_Event_RaceLottery_InLotteryProgress"))
  self.Text_DetailTitle02:SetText(GText("UI_Event_RaceLottery_CountResultProgress"))
  self.Text_DetailTitle03:SetText(GText("UI_Event_RaceLottery_ShowResultProgress"))
  local RaceLotteryStartTime = self:GetStageTimeStamp(DataMgr.RaceLotteryConstant.RaceLotteryStartTime.ConstantValue)
  local RaceLotteryEndTime = self:GetStageTimeStamp(DataMgr.RaceLotteryConstant.RaceLotteryEndTime.ConstantValue)
  local RaceLotteryResultTime = self:GetStageTimeStamp(DataMgr.RaceLotteryConstant.RaceLotteryResultTime.ConstantValue)
  self.Text_Time01:SetText(string.format("%s-%s", self:FormatTimeToDescriptionText(RaceLotteryStartTime), self:FormatTimeToDescriptionText(RaceLotteryEndTime)))
  self.Text_Time02:SetText(string.format("%s-%s", self:FormatTimeToDescriptionText(RaceLotteryEndTime), self:FormatTimeToDescriptionText(RaceLotteryResultTime)))
  self.Text_Time03:SetText(string.format("%s-%s", self:FormatTimeToDescriptionText(RaceLotteryResultTime), self:FormatTimeToDescriptionText(RaceLotteryStartTime)))
end

function M:Update()
  self:RefreshUIInfo()
end

function M:RefreshUIInfo()
  self.WS_Detail:SetActiveWidgetIndex(math.max(RacingOutsiderModel.CurActivityStage - 1, 0))
  if RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.SelectPlayer then
    self.Image_Line01:SetColorAndOpacity(self.ProgressNormal)
    self.ImagePoint02:SetColorAndOpacity(self.ProgressNormal)
    self.Image_Line02:SetColorAndOpacity(self.ProgressNormal)
    self.ImagePoint03:SetColorAndOpacity(self.ProgressNormal)
    self.Text_DetailTitle01:SetColorAndOpacity(self.TextTitleLight)
    self.Text_DetailTitle02:SetColorAndOpacity(self.TextTitleNormal)
    self.Text_DetailTitle03:SetColorAndOpacity(self.TextTitleNormal)
    self.Text_Time01:SetColorAndOpacity(self.TextTimeLight)
    self.Text_Time02:SetColorAndOpacity(self.TextTimeNormal)
    self.Text_Time03:SetColorAndOpacity(self.TextTimeNormal)
  elseif RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.WaitingResult then
    self.Image_Line01:SetColorAndOpacity(self.ProgressLight)
    self.ImagePoint02:SetColorAndOpacity(self.ProgressLight)
    self.Image_Line02:SetColorAndOpacity(self.ProgressNormal)
    self.ImagePoint03:SetColorAndOpacity(self.ProgressNormal)
    self.Text_DetailTitle01:SetColorAndOpacity(self.TextTitleNormal)
    self.Text_DetailTitle02:SetColorAndOpacity(self.TextTitleLight)
    self.Text_DetailTitle03:SetColorAndOpacity(self.TextTitleNormal)
    self.Text_Time01:SetColorAndOpacity(self.TextTimeNormal)
    self.Text_Time02:SetColorAndOpacity(self.TextTimeLight)
    self.Text_Time03:SetColorAndOpacity(self.TextTimeNormal)
  elseif RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.GetReward then
    self.Image_Line01:SetColorAndOpacity(self.ProgressLight)
    self.ImagePoint02:SetColorAndOpacity(self.ProgressLight)
    self.Image_Line02:SetColorAndOpacity(self.ProgressLight)
    self.ImagePoint03:SetColorAndOpacity(self.ProgressLight)
    self.Text_DetailTitle01:SetColorAndOpacity(self.TextTitleNormal)
    self.Text_DetailTitle02:SetColorAndOpacity(self.TextTitleNormal)
    self.Text_DetailTitle03:SetColorAndOpacity(self.TextTitleLight)
    self.Text_Time01:SetColorAndOpacity(self.TextTimeNormal)
    self.Text_Time02:SetColorAndOpacity(self.TextTimeNormal)
    self.Text_Time03:SetColorAndOpacity(self.TextTimeLight)
  end
  self:PlayAnimation(self.In)
end

function M:Destruct()
  EventManager:RemoveEvent(RacingActivityConst.EventId.NextDayRefresh, self)
  EventManager:RemoveEvent(RacingActivityConst.EventId.EightThirtyRefresh, self)
  EventManager:RemoveEvent(RacingActivityConst.EventId.EightRefresh, self)
end

function M:GetStageTimeStamp(TimeValue)
  local NeedCalcuTime = tonumber(TimeValue)
  local NowTime = TimeUtils.NowTime()
  local TodayBegin = os.date("*t", NowTime)
  TodayBegin.hour = 0
  TodayBegin.min = 0
  TodayBegin.sec = 0
  local ZeroClockTimeStamp = os.time(TodayBegin)
  return ZeroClockTimeStamp + NeedCalcuTime * 24 * 3600
end

function M:FormatTimeToDescriptionText(Timestamp, UserServerTimezone, Joiner)
  Timestamp = Timestamp or TimeUtils.NowTime()
  if type(Timestamp) == "table" and Timestamp.GetTime then
    Timestamp = Timestamp:GetTime()
  end
  Joiner = Joiner or ":"
  if nil == UserServerTimezone then
    UserServerTimezone = false
  end
  if UserServerTimezone then
    Timestamp = os.time(os.date("!*t", Timestamp)) + TimeUtils.GetServerTimeZone() * 3600
  end
  return os.date("%H" .. Joiner .. "%M", Timestamp)
end

return M
