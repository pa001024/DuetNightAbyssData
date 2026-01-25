require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Text_Title01:SetText(GText("TheaterOnline_Game_Name"))
  self.Text_Title02:SetText(GText("TheaterOnline_Game_Interactor"))
  self:AddTimer(1, self.CountDown, true, -1, "TheaterTaskEntryBtnCountDown")
  local Avatar = GWorld:GetAvatar()
  Avatar:TheaterDonationGet(function(ErrCode, Ret)
    DebugPrint("TheaterDonationGet", ErrorCode:Name(ErrCode))
    if Ret then
      local tempString = string.format("<Default>%d</>/3", Ret.CurStep)
      self.Text_Stage:SetText(string.format(GText("UI_Theater_Donate_Step"), tempString))
      if 3 == Ret.CurStep and Ret.IsFinished == true then
        self.Panel_Finish:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Title02:SetText(GText("UI_Theater_Donate_Finish"))
      else
        self.Panel_Finish:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
    end
  end)
end

function M:Destruct()
  self:RemoveTimer("TheaterTaskEntryBtnCountDown")
end

function M:CountDown()
  local RemainingSeconds, CompletedActivities = self:GetNextActivityInfo()
  if nil == RemainingSeconds then
    self.Text_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Time_Right:SetText(GText("UI_Theater_Started"))
    self.Text_Time_Right:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Text_Time:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local Minutes = math.floor(RemainingSeconds / 60)
    local Seconds = RemainingSeconds % 60
    local TimeStr = string.format("%02d:%02d", Minutes, Seconds)
    local StartTextTemplate = GText("UI_Theater_Start")
    local StartPercentSIndex = string.find(StartTextTemplate, "%%s")
    if StartPercentSIndex then
      local TimeRightText = string.sub(StartTextTemplate, StartPercentSIndex + 2)
      self.Text_Time:SetText(TimeStr)
      if TimeRightText and "" ~= TimeRightText then
        self.Text_Time_Right:SetText(TimeRightText)
        self.Text_Time_Right:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      else
        self.Text_Time_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
    else
      self.Text_Time:SetText(string.format(StartTextTemplate, TimeStr))
      self.Text_Time_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  if nil == CompletedActivities then
    local CurrentTime = os.time()
    local CurrentDate = os.date("*t", CurrentTime)
    local MinutesSinceMidnight = CurrentDate.hour * 60 + CurrentDate.min
    CompletedActivities = math.floor(MinutesSinceMidnight / 30)
  end
  local RoundTextTemplate = GText("UI_Theater_Round")
  local RoundValue = CompletedActivities .. "/" .. 48
  local PercentSIndex = string.find(RoundTextTemplate, "%%s")
  if PercentSIndex then
    local LeftText = string.sub(RoundTextTemplate, 1, PercentSIndex - 1)
    local RightText = string.sub(RoundTextTemplate, PercentSIndex + 2)
    if LeftText and "" ~= LeftText then
      self.Text_Num_Left:SetText(LeftText)
      self.Text_Num_Left:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      self.Text_Num_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Text_Num:SetText(RoundValue)
    if RightText and "" ~= RightText then
      self.Text_Num_Right:SetText(RightText)
      self.Text_Num_Right:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      self.Text_Num_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  else
    self.Text_Num:SetText(string.format(RoundTextTemplate, RoundValue))
    self.Text_Num_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Num_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:GetNextActivityInfo()
  local GameTotalTime = 380
  local Step12Time = DataMgr.TheaterConstant.Step12.ConstantValue
  if Step12Time then
    GameTotalTime = Step12Time
  end
  local CurrentTime = os.time()
  local CurrentDate = os.date("*t", CurrentTime)
  local MinutesSinceMidnight = CurrentDate.hour * 60 + CurrentDate.min
  local CompletedActivities = math.floor(MinutesSinceMidnight / 30)
  local CurrentActivityStartMinutes = CompletedActivities * 30
  local CurrentSecondsSinceMidnight = MinutesSinceMidnight * 60 + CurrentDate.sec
  local CurrentActivityStartSeconds = CurrentActivityStartMinutes * 60
  local CurrentActivityEndSeconds = CurrentActivityStartSeconds + GameTotalTime
  if CurrentSecondsSinceMidnight >= CurrentActivityStartSeconds and CurrentSecondsSinceMidnight < CurrentActivityEndSeconds then
    return nil, nil
  end
  local NextActivityMinutes = (CompletedActivities + 1) * 30
  local RemainingMinutes = NextActivityMinutes - MinutesSinceMidnight
  if 0 == RemainingMinutes then
    RemainingMinutes = 30
  end
  local RemainingSeconds = RemainingMinutes * 60 - CurrentDate.sec
  if RemainingSeconds < 0 then
    RemainingSeconds = 0
  end
  return RemainingSeconds, CompletedActivities
end

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
  self.EventId = ActivityConfigData.EventId
end

return M
