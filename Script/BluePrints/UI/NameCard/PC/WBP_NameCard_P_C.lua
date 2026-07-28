require("UnLua")
local M = Class("BluePrints.UI.NameCard.WBP_NameCard_Base")

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if self.CurrentWidget and self.CurrentWidget.HandleKeyDown then
    IsEventHandled = self.CurrentWidget:HandleKeyDown(MyGeometry, InKeyEvent)
  end
  if not IsEventHandled then
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
      if self.Com_Tab and self.Com_Tab.Handle_KeyEventOnGamePad then
        IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
      end
    elseif "Escape" == InKeyName then
      IsEventHandled = true
      self:OnClickBack()
    elseif "Q" == InKeyName then
      IsEventHandled = true
      if self.Com_Tab and self.Com_Tab.TabToLeft then
        self.Com_Tab:TabToLeft()
      end
    elseif "E" == InKeyName then
      IsEventHandled = true
      if self.Com_Tab and self.Com_Tab.TabToRight then
        self.Com_Tab:TabToRight()
      end
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

return M
