require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
end

function M:Destruct()
  self.Btn_Click.OnClicked:Clear()
end

function M:Init(Params)
  self.Params = Params
  self.CallbackObj = Params.CallbackObj
  self.CallbackFunc = Params.CallbackFunc
  if Params.Text then
    self.Text_Button:SetText(GText(Params.Text))
  end
  if Params.GamepadKey then
    self.Key_GamePad:CreateGamepadKey(Params.GamepadKey)
  end
end

function M:OnBtnClicked()
  if self.CallbackObj and self.CallbackFunc then
    self.CallbackFunc(self.CallbackObj)
  end
end

function M:SetReddotVisible(Value)
  local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
  local Collapsed = UIConst.VisibilityOp.Collapsed
  self.Reddot:SetVisibility(Value and Visible or Collapsed)
end

function M:SetGamePadKeyVisible(Value)
  local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
  local Collapsed = UIConst.VisibilityOp.Collapsed
  self.Key_GamePad:SetVisibility(Value and Visible or Collapsed)
end

return M
