require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:SetIsDealWithVirtualAccept(true)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Option = Content.Option
  self.ParentWidget = Content.ParentWidget
  self.Text:SetText(Content.Text)
  self.CheckBox:RemoveEventOnCheckStateChanged(self)
  self.CheckBox:AddEventOnCheckStateChanged(self, self.OnCheckBoxChanged)
  self.CheckBox:SetChecked(self.Option.State, false)
end

function M:OnCheckBoxChanged(bIsChecked)
  self.ParentWidget:OnCheckBoxChanged(self.Option, bIsChecked)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonDown then
    self.CheckBox:OnBtnClicked()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
