require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.UI_PC.Common.SubWidgetManagerComponent"
}

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  EventManager:FireEvent(EventID.RefreshWuyoushengLevelReddot)
  self.EventId, self.DungeonId = ...
  self.EventId = math.floor(tonumber(self.EventId) or 0)
  self:InitSubWidgetManager(self.Anchor, nil)
  self:OpenSubUI({
    Idx = "ActivityWuyoushengLevelChoose"
  }, true)
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

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if "Escape" == InKeyName then
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
  EventManager:FireEvent(EventID.OnReturnToActivityEntry)
  EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
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

AssembleComponents(M)
return M
