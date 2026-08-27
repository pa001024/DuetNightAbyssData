require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  if self.Btn_Area then
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnClicked:Add(self, self.OnAreaClicked)
  end
  if IsValid(self.Key_GamePad) then
    self.Key_GamePad:CreateGamepadKey(UIConst.GamePadImgKey.LeftTriggerThreshold)
  end
  self:Refresh()
end

function M:SetClickCallback(Obj, Func)
  self._CallbackObj = Obj
  self._CallbackFunc = Func
end

function M:OnAreaClicked()
  if self._CallbackObj and self._CallbackFunc then
    self._CallbackFunc(self._CallbackObj, self)
  end
end

function M:Refresh()
  if IsValid(self.Key_GamePad) then
    self.Key_GamePad:SetVisibility(UIUtils.IsGamepadInput() and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
end

function M:SetButtonVisible(bVisible)
  self:SetVisibility(bVisible and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
end

return M
