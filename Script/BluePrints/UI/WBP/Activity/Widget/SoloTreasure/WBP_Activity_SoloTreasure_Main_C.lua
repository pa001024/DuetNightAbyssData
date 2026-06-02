require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local UIUtils = require("Utils.UIUtils")
M._components = {
  "BluePrints.UI.UI_PC.Common.SubWidgetManagerComponent"
}

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  EventManager:FireEvent(EventID.RefreshWuyoushengLevelReddot)
  self.EventId, self.Mode, self.bIsDifficult, self.EventDugeonId = ...
  self.EventId = math.floor(tonumber(self.EventId) or 103014)
  self.Mode = tonumber(self.Mode) or 1
  self.EventDugeonId = tonumber(self.EventDugeonId)
  self:InitSubWidgetManager(self.Anchor, nil)
  self:OpenSubUI({
    Idx = "ActivitySoloTreasureLevel"
  }, self.Mode, self.bIsDifficult, self.EventDugeonId)
  if self.RewardText then
    self.RewardText:Init(nil, self.EventId)
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDevice = CurInputDevice
  self.CurGamepadName = CurGamepadName
  if ModController:IsMobile() then
    return
  end
  for _, Widget in pairs(self.SubUI) do
    Widget:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  end
end

function M:Destruct()
  local BattleView = UIManager():GetUIObj("BattleMain")
  if BattleView then
    BattleView:Show("Temp1.4Fix")
  end
  self.Super.Destruct(self)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UIUtils.IsGamepadInput() then
    if "Gamepad_RightThumbstick" == InKeyName then
      IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
      local CurrentSubUI = self:GetCurrentSubUI()
      self.Com_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(CurrentSubUI)
    end
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:OnReturnKeyDown()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnCloseAll()
  self:Close()
end

function M:Close()
  if self.SubUI then
    for _, Widget in pairs(self.SubUI) do
      if Widget ~= self then
        Widget:RemoveFromParent()
      end
    end
  end
  self.Super.Close(self)
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if self.SubUI then
    for _, Widget in pairs(self.SubUI) do
      if type(Widget.ReceiveEnterStateSelf) == "function" then
        Widget:ReceiveEnterStateSelf(StackAction)
      end
    end
  end
end

function M:ReceiveExitState(StackAction)
  M.Super.ReceiveExitState(self, StackAction)
  if self.SubUI then
    for _, Widget in pairs(self.SubUI) do
      if type(Widget.ReceiveExitStateSelf) == "function" then
        Widget:ReceiveExitStateSelf(StackAction)
      end
    end
  end
end

AssembleComponents(M)
return M
