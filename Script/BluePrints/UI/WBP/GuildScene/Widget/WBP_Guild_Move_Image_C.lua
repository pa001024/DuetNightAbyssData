require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  DebugPrint("chenxiaokang test")
  self.ParentTest.bIsDragActor = true
  DebugPrint("chenxiaokang test2")
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:RefreshData()
  self.bIsDragging = false
end

function M:InitParent(ParentTest)
  self.ParentTest = ParentTest
  DebugPrint("chenxiaokang init Parent", ParentTest)
end

return M
