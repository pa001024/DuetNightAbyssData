require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Camera.Widget.Parameter.Camera_Parameter_Widget_Base"
})

function M:SetTitle(Text)
  self.Text:SetText(Text)
end

function M:Init(Content)
  M.Super.Init(self, Content)
  rawset(self, "_OnCheckedChanged", Content.OnCheckedChanged)
  self.CheckBox:SetChecked(Content.IsChecked, false)
  self.CheckBox:AddEventOnCheckStateChanged(self, self.OnCheckedChanged)
end

function M:OnCheckedChanged(IsChecked)
  if self._OnCheckedChanged then
    self._OnCheckedChanged(self.Owner, IsChecked, self.Content)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonDown then
    return self:OnConfirmKeyDown()
  end
  return UIUtils.Unhandled, false
end

function M:OnConfirmKeyDown()
  self.Content.IsChecked = not self.Content.IsChecked
  self.CheckBox:SetChecked(self.Content.IsChecked, true)
  return UIUtils.Handled, true
end

return M
