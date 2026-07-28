require("UnLua")
local View = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function View:InitView()
  if self.TextShare then
    self.TextShare:SetText(GText("UI_AutoChess_BattleShare"))
  end
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self.Controller_KeyShare:CreateGamepadKey(UIConst.GamePadImgKey.DPadLeft)
  self:RefreshOpInfoByInputDevice()
end

function View:BindEvents(OnBtnShareClickedCallback)
  self.Button_Area.OnClicked:Clear()
  self.Button_Area.OnClicked:Add(self, OnBtnShareClickedCallback)
end

function View:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self.Controller_KeyShare:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Controller_KeyShare:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return View
