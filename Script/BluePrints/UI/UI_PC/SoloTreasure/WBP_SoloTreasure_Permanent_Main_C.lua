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
  local Mode, bIsDifficult, EventDugeonId = ...
  self.Mode = tonumber(Mode) or 1
  self:InitSubWidgetManager(self.Anchor, nil)
  self:OpenSubUI({
    Idx = "SoloTreasurePermanentLevel"
  }, self.Mode, bIsDifficult, EventDugeonId)
  if self.Entrance_Illustrated then
    self.Entrance_Illustrated:Init("Illustrated")
  end
  if self.Entrance_Shop then
    self.Entrance_Shop:Init("Shop")
  end
  if self.Entrance_Reward then
    self.Entrance_Reward:Init("Reward")
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
    if Widget.OnUpdateUIStyleByInputTypeChange then
      Widget:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    end
  end
end

function M:Destruct()
  self.Super.Destruct(self)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if not UIUtils.IsGamepadInput() then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  for _, Widget in pairs(self.SubUI or {}) do
    if Widget.CurFocusState and Widget.FocusState and Widget.CurFocusState == Widget.FocusState.Focus4 and type(Widget.HandleGamepadInput) == "function" then
      local IsHandled = Widget:HandleGamepadInput(MyGeometry, InKeyEvent)
      if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
      end
    end
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UIUtils.IsGamepadInput() then
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
