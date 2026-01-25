require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.UI_PC.Common.SubWidgetManagerComponent"
}

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.EventId = (...)
  self:InitSubWidgetManager(self.Anchor, nil)
  self:OpenSubUI({
    Idx = "ActivityWuyoushengLevelChoose"
  }, true)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Top" == InKeyName then
      IsEventHandled = true
      self.Reward:OnBtnClicked()
    elseif "Gamepad_FaceButton_Left" == InKeyName then
      IsEventHandled = true
      self.Store:OnBtnClicked()
    elseif "Gamepad_Special_Left" == InKeyName then
      IsEventHandled = true
      self.Entry:OnBtnClicked()
      self:OpenEntry()
    elseif "Gamepad_FaceButton_Right" == InKeyName then
      IsEventHandled = true
      self:OnReturnKeyDown()
    end
    if not IsEventHandled then
      IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
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

AssembleComponents(M)
return M
