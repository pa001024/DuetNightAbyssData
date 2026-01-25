require("UnLua")
local M = {}
M._components = {
  "BluePrints.UI.WBP.DayAndNight.DayAndNightAnimationCompoment"
}
local DayTextMap = {
  [1] = "UI_SetTime_Button_Today",
  [2] = "UI_SetTime_Button_Tomorrow",
  [3] = "UI_SetTime_Button_TheDayAfterTomorrow"
}
local DayTargetAngleMap = {
  310,
  330,
  350
}

local function ScreenPrint(str)
  return DebugPrint("yklua " .. str)
end

function M:Initialize(Initializer)
  self.CurrentHour = 0
  self.IsWidgetInDay = true
  self.SelectedDay = 1
  self.SelectedHour = 1
  self.DayUIDragSpeed = 100
  self.HourUIWheelSpeed = 15
  self.HourUIDragSpeed = 100
  self.DayUIWheelSpeed = 20
  self.SmoothBaseSpeed = 8.0
  self.SmoothWheelSpeed = 15.0
  self.CurrentDayAngle = 310
  self.CurrentHourAngle = 0
  self.bIsSmoothingDay = false
  self.bIsSmoothingHour = false
  self.TargetDayAngle = 310
  self.TargetHourAngle = 0
  self.AllDayWidgets = {}
  self.AllHourWidgets = {}
  self.ReallyCurrentHourAngle = 0
end

function M:Construct()
  if not self.DayStart then
    self.DayStart = 6
  end
  if not self.DayEnd then
    self.DayEnd = 18
  end
  ScreenPrint("DayAndNightPageBaseView:Construct")
  self.Btn_Save.Button_Area.OnClicked:Add(self, self.OnClickChangeTime)
  self.Btn_Save:SetText(GText("UI_SetTime_Button_SetTime"))
  self.Text_TimeTitle:SetText(GText("UI_SetTime_CurrentTime"))
  self.Slider_Day:BindScroolEvent(self, self.OnScrollDay, self.DayUIWheelSpeed)
  self.Slider_Day:BindDragEvent(self, self.OnDragDay, self.DayUIDragSpeed)
  self.Slider_Day:BindDragEndEvent(self, self.OnDragEndDay)
  self.Slider_Time:BindScroolEvent(self, self.OnScrollHour, self.HourUIWheelSpeed)
  self.Slider_Time:BindDragEvent(self, self.OnDragHour, self.HourUIDragSpeed)
  self.Slider_Time:BindDragEndEvent(self, self.OnDragEndHour)
end

function M:OnLoaded()
  self:InitBaseView()
  self:PlayInAnimation()
  AudioManager(self):PlayUISound(self, "event:/ui/common/time_panel_open", "DayAndNightPage", nil)
end

function M:InitBaseView()
  self.DynamicEntryBox_Day:Reset()
  for i = 1, 3 do
    local DayWidget = self.DynamicEntryBox_Day:BP_CreateEntry()
    self:InitDayWidget(DayWidget, i)
  end
  self.DynamicEntryBox_Time:Reset()
  for i = 1, 24 do
    local HourWidget = self.DynamicEntryBox_Time:BP_CreateEntry()
    self:InitHourWidget(HourWidget, i)
  end
  self:InitTime()
end

function M:GetEnvironmentManager()
  if self.EnvironmentManager and IsValid(self.EnvironmentManager) then
    return self.EnvironmentManager
  else
    self.EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(self, UE4.AEnvironmentManager:StaticClass())
    return self.EnvironmentManager
  end
end

function M:GetExactTimeOfDay()
  local EnvironmentManager = self:GetEnvironmentManager()
  local HalfHourSeconds = DataMgr.GlobalConstant.TODUnitTime.ConstantValue / 2
  local RemainHalfHourTime = EnvironmentManager:GetRemainTODHalfHourTime()
  if HalfHourSeconds and RemainHalfHourTime then
    self.ExactHour = EnvironmentManager:GetTimeOfDay() + (HalfHourSeconds - RemainHalfHourTime) / (HalfHourSeconds * 2)
    ScreenPrint("GetExactTimeOfDay:" .. self.ExactHour)
    return self.ExactHour
  else
    ScreenPrint("GetExactTimeOfDay:Error")
    return EnvironmentManager:GetTimeOfDay()
  end
end

function M:InitTime()
  local EnvironmentManager = self:GetEnvironmentManager()
  self.CurrentHour = EnvironmentManager.TimeOfDay
  DebugPrint("yklua CurrentWorlfHour:" .. self.CurrentHour)
  local hours = math.floor(self.CurrentHour + 0.5)
  local ExactTime = self:GetExactTimeOfDay()
  local formattedTime = self:GetTextFormHour(ExactTime)
  ScreenPrint("ExactTime:" .. ExactTime)
  local NextHour = math.ceil(ExactTime)
  local NextHour = 0 == NextHour and 24 or NextHour
  self.ReallyCurrentHourAngle = self:GetAngleByHour(NextHour)
  ScreenPrint("ExactTime:" .. NextHour)
  self:SetHourAngle(self.ReallyCurrentHourAngle)
  self:SetDayAngle(self.CurrentDayAngle)
  self.Text_TimeNow:SetText(formattedTime)
  self.IsWidgetInDay = self:IsInDay()
  self:FreshSelectedDay()
end

function M:GetTextFormHour(Hour)
  local hours = math.floor(Hour)
  local minutes = math.floor((Hour - hours) * 60)
  if 0 == hours and 0 == Hour - hours then
    hours = 24
  end
  local formattedTime = string.format("%d:%02d", hours, minutes)
  return formattedTime
end

function M:InitDayWidget(DayWidget, Index)
  DayWidget.Index = Index
  local RealIndex = 3 - Index + 1
  DayWidget.RealIndex = RealIndex
  local bInDay = self:IsInDay()
  DayWidget.Text_Select:SetText(GText(DayTextMap[RealIndex]))
  DayWidget.Text_Normal:SetText(GText(DayTextMap[RealIndex]))
  DayWidget.Night = not bInDay
  DayWidget:SetDayAndNight(bInDay)
  self.AllDayWidgets[RealIndex] = DayWidget
end

function M:InitHourWidget(HourWidget, Index)
  local Hour = 25 - Index + 1
  if Hour > 24 then
    Hour = Hour - 24
  end
  local bInDay = self:IsInDay()
  HourWidget.Index = Index
  HourWidget.Hour = Hour
  HourWidget:Init(Index, Hour, bInDay)
  HourWidget:SetDayAndNight(bInDay)
  self.AllHourWidgets[Hour] = HourWidget
end

function M:WillCrossDay(rawAngle)
  if rawAngle >= 352.5 and self.CurrentHourAngle < 352.5 and rawAngle - self.CurrentHourAngle < 180 then
    return self.SelectedDay < 3
  elseif rawAngle <= 352.5 and self.CurrentHourAngle > 352.5 and self.CurrentHourAngle - rawAngle < 180 then
    return self.SelectedDay > 1
  end
  return false
end

function M:ClampHourAngle(angle)
  if self:WillCrossDay(angle) then
    return angle
  end
  if 1 == self.SelectedDay then
    if angle < self.ReallyCurrentHourAngle then
      ScreenPrint("Forbidden1, ClampHourAngle: " .. self.ReallyCurrentHourAngle .. "→" .. 352.5)
      return self.ReallyCurrentHourAngle
    end
  elseif 3 == self.SelectedDay and not self.IsCrossing then
    ScreenPrint("Forbidden3, self.CurrentHourAngle: " .. self.CurrentHourAngle .. "→angle" .. angle)
    if angle > 350 and self.CurrentHourAngle <= 350 then
      ScreenPrint("Forbidden2, ClampHourAngle: " .. self.CurrentHourAngle .. "Target: " .. angle .. " " .. "→" .. 352.5)
      return 350
    end
  end
  return angle
end

function M:CheckHourCrossing(rawAngle)
  ScreenPrint("TryCheckHourCrossing: " .. self.CurrentHourAngle .. "→" .. rawAngle)
  if rawAngle >= 352.5 and self.CurrentHourAngle < 352.5 and rawAngle - self.CurrentHourAngle < 180 or self.CurrentHourAngle < 352.5 and self.CurrentHourAngle - rawAngle > 180 then
    if self.SelectedDay < 3 then
      self:ChageSelectDay(self.SelectedDay + 1)
      self:SmoothUpdate(true, self:GetAngleByDayIndex(self.SelectedDay))
      ScreenPrint("前进---------------ReallkyCheckHourCrossing: " .. self.CurrentHourAngle .. "→" .. rawAngle)
      self.IsCrossing = true
      self:AddTimer(0.1, function()
        ScreenPrint("Closssss")
        self.IsCrossing = false
      end, false, 0, "CrossingTimer")
      return true
    end
  elseif (rawAngle <= 352.5 and self.CurrentHourAngle > 352.5 and self.CurrentHourAngle - rawAngle < 180 or rawAngle < 352.5 and rawAngle - self.CurrentHourAngle > 180) and self.SelectedDay > 1 then
    self:ChageSelectDay(self.SelectedDay - 1)
    self:SmoothUpdate(true, self:GetAngleByDayIndex(self.SelectedDay))
    ScreenPrint("后退-------------------ReallkyCheckHourCrossing: " .. self.CurrentHourAngle .. "→" .. rawAngle .. "  " .. self.CurrentHourAngle - rawAngle)
    self.IsCrossing = true
    self:AddTimer(0.1, function()
      ScreenPrint("Closssss")
      self.IsCrossing = false
    end, false, 0, "CrossingTimer")
    return true
  end
  return false
end

function M:UpdateHourAngleLimit()
  ScreenPrint("UpdateHourAngleLimit: " .. self.SelectedDay .. "→" .. self.ReallyCurrentHourAngle)
  if 1 == self.SelectedDay then
    if self.CurrentHourAngle < self.ReallyCurrentHourAngle then
      self:SmoothUpdate(false, self.ReallyCurrentHourAngle)
    end
  elseif 3 == self.SelectedDay and self.CurrentHourAngle > 360 then
    self:SmoothUpdate(false, 360)
  end
end

function M:OnDragDay(Delta)
  local newAngle = self.CurrentDayAngle + Delta
  newAngle = self:luaClamp(newAngle, 310, 350)
  self:SetDayAngle(newAngle)
  self.bIsSmoothingDay = false
  ScreenPrint("OnDragDay: 实时角度→" .. newAngle)
end

function M:SetDayAngle(Angle)
  self.CurrentDayAngle = Angle
  local FRadialBoxSetting = FRadialBoxSettings()
  FRadialBoxSetting.StartingAngle = Angle
  FRadialBoxSetting.SectorCentralAngle = 60
  self.DynamicEntryBox_Day:SetRadialSettings(FRadialBoxSetting)
  self:OnDayAngleChange(Angle)
end

function M:FreshSelectedDay()
  for i, v in pairs(self.AllDayWidgets) do
    local IsSelected = i == self.SelectedDay
    v.Switch_Text:SetActiveWidgetIndex(IsSelected and 1 or 0)
  end
end

function M:OnDayAngleChange(Angle)
  if nil == Angle then
    Angle = self.CurrentDayAngle
  end
  local newSelectedDay = self:GetDayIndexByAngle(Angle)
  ScreenPrint("OnDayAngleChange: " .. Angle .. "Now  " .. self.SelectedDay .. "->>New  " .. newSelectedDay)
  if newSelectedDay ~= self.SelectedDay and not self.IsCrossing then
    ScreenPrint("OnDayAngleChange:  ReallyChangeDay" .. newSelectedDay)
    AudioManager(self):PlayUISound(self, "event:/ui/common/time_day_scroll", "DayAndNightPageDayChange", nil)
    self:ChageSelectDay(newSelectedDay)
  end
end

function M:ChageSelectDay(newSelectedDay)
  self.SelectedDay = newSelectedDay
  self:FreshSelectedDay()
  self:OnHourAngleChange()
  self:UpdateHourAngleLimit()
end

function M:GetDayIndexByAngle(Angle)
  local RelativeAngle = Angle - 310
  RelativeAngle = self:luaClamp(RelativeAngle, 0, 40)
  local targetIdx = math.floor((RelativeAngle + 10) / 20) + 1
  targetIdx = self:luaClamp(targetIdx, 1, 3)
  return targetIdx
end

function M:GetAngleByDayIndex(Index)
  return DayTargetAngleMap[Index] or 310
end

function M:OnScrollDay(Delta)
  local tempTarget = self.CurrentDayAngle + Delta
  tempTarget = self:luaClamp(tempTarget, 310, 350)
  local targetIdx = self:GetDayIndexByAngle(tempTarget)
  local preciseAngle = self:GetAngleByDayIndex(targetIdx)
  self:SmoothUpdate(true, preciseAngle)
  ScreenPrint(string.format("OnScrollDay: 平滑角度→%d°，第%d天", math.floor(self.CurrentDayAngle), targetIdx))
end

function M:OnDragEndDay()
  local targetIdx = self:GetDayIndexByAngle(self.CurrentDayAngle)
  local targetAngle = self:GetAngleByDayIndex(targetIdx)
  self:SmoothUpdate(true, targetAngle)
  ScreenPrint(string.format("天列表拖动结束对齐：第%d天→%d°", targetIdx, targetAngle))
end

function M:OnDragHour(Delta)
  local rawAngle = self.CurrentHourAngle + Delta
  if not self.IsCrossing then
    rawAngle = self:ClampHourAngle(rawAngle)
  end
  local newAngle = self:normalizeAngle(rawAngle)
  DebugPrint("66", self.IsCrossing, self.CurrentHourAngle, rawAngle, newAngle)
  self:SetHourAngle(newAngle)
  self.bIsSmoothingHour = false
  ScreenPrint("OnDragHour: 实时角度→" .. newAngle)
end

function M:SetHourAngle(Angle)
  local IsCross = self:CheckHourCrossing(Angle)
  self.CurrentHourAngle = Angle
  local FRadialBoxSetting = FRadialBoxSettings()
  FRadialBoxSetting.StartingAngle = Angle
  FRadialBoxSetting.SectorCentralAngle = 360
  self.DynamicEntryBox_Time:SetRadialSettings(FRadialBoxSetting)
  self:OnHourAngleChange(Angle)
end

function M:OnHourAngleChange(Angle)
  if nil == Angle then
    Angle = self.CurrentHourAngle
  end
  local NowHour = self:GetHourIndexByAngle(Angle)
  if NowHour ~= self.SelectedHour then
    AudioManager(self):PlayUISound(self, "event:/ui/common/time_hour_scroll", "DayAndNightPageHourChange", nil)
  end
  self.SelectedHour = NowHour
  for i = -6, 6 do
    local ActiveWidgetIndex = 0
    local Hour = self.SelectedHour + i
    local bHide, blast
    if 3 == self.SelectedDay and Hour > 24 then
      bHide = true
    else
      bHide = false
    end
    if Hour < 1 then
      Hour = Hour + 24
      blast = true
    elseif Hour > 24 then
      Hour = Hour - 24
    end
    if 0 == self.CurrentHour then
      self.CurrentHour = 24
    end
    local HourWidget = self.AllHourWidgets[Hour]
    if bHide then
      HourWidget:SetVisibility(UIConst.VisibilityOp.Hidden)
    else
      HourWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if i < 0 and 1 == self.SelectedDay and (Hour < self.CurrentHour or blast) or 2 == self.SelectedDay and Hour < self.CurrentHour and i < 0 and blast then
      ActiveWidgetIndex = 0
    elseif 0 == i then
      ActiveWidgetIndex = 1
    else
      ActiveWidgetIndex = 2
    end
    if HourWidget then
      HourWidget.Switch_Text:SetActiveWidgetIndex(ActiveWidgetIndex)
    else
      ScreenPrint("OnHourAngleChange: HourWidget is nil for Hour=" .. Hour)
    end
  end
end

function M:GetHourIndexByAngle(Angle)
  local AnglePerHour = 15
  local NormalizedAngle = Angle % 360
  local targetIdx = math.floor((NormalizedAngle + AnglePerHour / 2) / AnglePerHour) + 1
  if targetIdx > 24 then
    targetIdx = targetIdx - 24
  end
  targetIdx = self:luaClamp(targetIdx, 1, 24)
  return targetIdx
end

function M:GetAngleByHour(Hour)
  return (Hour - 1) * 15
end

function M:OnScrollHour(Delta)
  local rawAngle = self.CurrentHourAngle + Delta
  rawAngle = self:ClampHourAngle(rawAngle)
  local tempTarget = self:normalizeAngle(rawAngle)
  local targetIdx = self:GetHourIndexByAngle(tempTarget)
  local preciseAngle = self:GetAngleByHour(targetIdx)
  self:SmoothUpdate(false, preciseAngle)
  ScreenPrint(string.format("OnScrollHour: 平滑角度→%d°，第%d小时", math.floor(self.CurrentHourAngle), targetIdx))
end

function M:OnDragEndHour()
  local targetIdx = self:GetHourIndexByAngle(self.CurrentHourAngle)
  local targetAngle = self:GetAngleByHour(targetIdx)
  self:SmoothUpdate(false, targetAngle)
  ScreenPrint(string.format("小时列表拖动结束对齐：第%d小时→%d°", targetIdx, targetAngle))
end

function M:IsInDay(Hour)
  Hour = Hour or self.CurrentHour
  if 0 == Hour then
    Hour = 24
  end
  return Hour >= self.DayStart and Hour <= self.DayEnd
end

function M:FreshDayNight()
  local OldIsInDay = self.IsWidgetInDay
  if OldIsInDay ~= self:IsInDay() then
    local NewIsInDay = self:IsInDay()
    for i, Widget in pairs(self.AllDayWidgets) do
      Widget:SetDayAndNight(NewIsInDay)
    end
    for i, Widget in pairs(self.AllHourWidgets) do
      Widget:SetDayAndNight(NewIsInDay)
    end
    self.IsWidgetInDay = NewIsInDay
  end
end

function M:OnClickChangeTime()
  local currentHourDisplay = 0 == self.CurrentHour and 24 or math.floor(self.CurrentHour)
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", "DayAndNightPageBtnClick", nil)
  if 1 == self.SelectedDay and self.SelectedHour == currentHourDisplay then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_SetTime_Success"))
    return
  end
  local hourToSet = 24 == self.SelectedHour and 0 or self.SelectedHour
  local EnvironmentManager = self:GetEnvironmentManager()
  EnvironmentManager:SetTimeOfDay(hourToSet, true, ESetTODReason.UISet)
  local CurrentText = self:GetTextFormHour(self.SelectedHour)
  local NowIsInDay = self.IsWidgetInDay
  local NewIsInDay = self:IsInDay(self.SelectedHour)
  local Animation
  local IsCrossDayNight = false
  if NowIsInDay and not NewIsInDay then
    Animation = self.DayToNight
    IsCrossDayNight = true
  elseif not NowIsInDay and NewIsInDay then
    Animation = self.NightToDay
    IsCrossDayNight = true
  elseif NowIsInDay and NewIsInDay then
    Animation = self.DayChange
  elseif not NowIsInDay and not NewIsInDay then
    Animation = self.NightChange
  end
  
  local function FreshFunc()
    self.CurrentHour = hourToSet
    if IsCrossDayNight then
      self:FreshDayNight()
    end
    self.Text_TimeNow:SetText(CurrentText)
    self.ReallyCurrentHourAngle = self:GetAngleByHour(0 == hourToSet and 24 or hourToSet)
    self:OnHourAngleChange()
    self:UpdateHourAngleLimit()
    
    local function EndFunc()
      self:BlockAllUIInput(false)
    end
  end
  
  self:AddTimer(0.1, FreshFunc)
  self.IsWidgetInDay = NewIsInDay
  DebugPrint("DatAndNight PlayingAnimation :" .. Animation:GetName() .. " FromHour:" .. self:GetExactTimeOfDay() .. " ToHour:" .. self.SelectedHour)
  self:UnbindAllFromAnimationFinished(Animation)
  self:BindToAnimationFinished(Animation, {
    self,
    function()
      self:BlockAllUIInput(false)
    end
  })
  if self.SelectedDay > 1 then
    self:SmoothUpdate(true, self:GetAngleByDayIndex(1))
    self.IsCrossing = true
    self:AddTimer(0.5, function()
      self.IsCrossing = false
    end, false, 0, "CrossingTimer")
  end
  self.Text_TimeAfter:SetText(CurrentText)
  self:PlayAnimation(Animation)
  AudioManager(self):PlayUISound(nil, "event:/ui/common/time_panel_time_change", "DayAndNightPageTimeChange", nil)
  self:BlockAllUIInput(true)
  self:StartTimeFlow(self.CurrentHour, hourToSet, 1.0)
end

function M:PlayInAnimation()
  if self:IsInDay() then
    self:PlayAnimation(self.Day_In)
  else
    self:PlayAnimation(self.Night_In)
  end
end

function M:OnReturnKeyDown()
  if EMUIAnimationSubsystem:EMAnimationIsPlaying(self.Out) then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "DayAndNightPage", {ToEnd = 1})
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Out)
end

AssembleComponents(M)
return M
