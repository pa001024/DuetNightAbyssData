require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Activity.PC.CameraGame.WBP_Activity_CameraGame_Base_C"
})

function M:Initialize(Initializer)
  rawset(self, "TabConfigData", {
    DynamicNode = {
      "Back",
      "Tip",
      "BottomKey"
    },
    TitleName = GText("姣姣摄影展（未配）"),
    StyleName = "TextImage",
    OwnerPanel = self,
    BackCallback = self.CloseSelf
  })
end

function M:Construct()
  self.Super.Construct(self)
end

function M:Destruct()
  self.Super:Destruct(self)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName or "Gamepad_FaceButton_Right" == InKeyName then
    self:CloseSelf()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
