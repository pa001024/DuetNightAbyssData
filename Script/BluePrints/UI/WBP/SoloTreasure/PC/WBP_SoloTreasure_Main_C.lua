require("UnLua")
local WBP_SoloTreasure_Hud_P_C = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.Common.TimerMgr"
})

function WBP_SoloTreasure_Hud_P_C:Destruct()
  self:ClearListenEvent()
  EventManager:RemoveEvent(EventID.UpdateGamePoints, self)
end

function WBP_SoloTreasure_Hud_P_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self.DungeonId = (...)
  self:InitData(self.DungeonId)
  self:InitText()
  self:InitCountDown()
  self:InitBtn()
  self:OpenTips("TaskStart")
  self:InitListenEvent()
  EventManager:AddEvent(EventID.UpdateGamePoints, self, self.UpdateGamePoints)
  self:PlayAnimation(self.In)
end

function WBP_SoloTreasure_Hud_P_C:InitData(DungeonId)
  self.GamePoints = 0
end

function WBP_SoloTreasure_Hud_P_C:InitText()
  self.Text_AllNum:SetText("0")
end

function WBP_SoloTreasure_Hud_P_C:SetDungeonPoints(Points)
  if Points and type(Points) == "number" then
    self.GamePoints = self.GamePoints + Points
  end
end

function WBP_SoloTreasure_Hud_P_C:UpdateGamePoints(Points)
  self:SetDungeonPoints(Points)
end

function WBP_SoloTreasure_Hud_P_C:OpenTips(TipType)
  self.Overlay_Time:SetVisibility(ESlateVisibility.Collapsed)
  self.OverlayTips:ClearChildren()
  self.Tips = self:CreateWidgetNew("SoloTreasureRemainTimeTip")
  self.OverlayTips:AddChild(self.Tips)
  local Parmas = {}
  Parmas.TipType = TipType
  Parmas.Owner = self
  Parmas.TimerHandleName = self.CurTimerHandle
  
  function Parmas.Callback()
    self.Overlay_Time:SetVisibility(ESlateVisibility.Visible)
    self:PlayAnimation(self.In)
  end
  
  self.Tips:InitWidget(Parmas)
end

function WBP_SoloTreasure_Hud_P_C:InitCountDown(TimerHandleName)
  self.Switch_TimeType:SetActiveWidgetIndex(0)
  self.CurTimerHandle = TimerHandleName
  self.IsRed = false
  self:AddTimer(0.1, self.UpdateCountDownUI, true, 0, "CountDown", true)
end

function WBP_SoloTreasure_Hud_P_C:UpdateCountDownUI()
  local DisplayRemainTime = 300
  if DisplayRemainTime < 0 then
    DisplayRemainTime = 0
  elseif DisplayRemainTime < 60 then
    if not self.IsRed then
      self.Switch_TimeType:SetActiveWidgetIndex(1)
      self:OpenTips("TimeWarning")
      self.IsRed = true
    end
  elseif DisplayRemainTime < 10 then
    self:PlayAnimation(self.Time_Warning)
  end
  self.Text_TimeTop:SetText(self:GetTimeStr_Cpp(DisplayRemainTime))
end

function WBP_SoloTreasure_Hud_P_C:InitBtn()
  self.Btn_Esc:LoadImage(11)
end

function WBP_SoloTreasure_Hud_P_C:InitListenEvent()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function WBP_SoloTreasure_Hud_P_C:ClearListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function WBP_SoloTreasure_Hud_P_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  local IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
  self:UpdateUIByDevice()
end

function WBP_SoloTreasure_Hud_P_C:UpdateUIByDevice()
end

return WBP_SoloTreasure_Hud_P_C
