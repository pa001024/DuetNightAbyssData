require("UnLua")
local M = Class("BluePrints.UI.WBP.Armory.WBP_Armory_Mastery_Detail_Base_C")

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName or "Gamepad_FaceButton_Right" == InKeyName then
    self:OnCloseBtnClicked()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
