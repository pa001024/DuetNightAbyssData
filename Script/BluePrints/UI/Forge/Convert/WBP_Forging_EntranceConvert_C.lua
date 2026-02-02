require("UnLua")
local WBP_Forging_EntranceConvert_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Forging_EntranceConvert_C:Init(Object, ClickCallback)
  local GameInputMdoeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if IsValid(GameInputMdoeSubsystem) then
    GameInputMdoeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
  end
  self.Text_Convert:SetText(GText("UI_Convert"))
  self.Btn_Click.OnPressed:Add(self, function()
    AudioManager(self):PlayFMODSound(self, nil, "event:/ui/common/click_btn_large")
  end)
  self.Btn_Click.OnClicked:Add(Object, ClickCallback)
end

return WBP_Forging_EntranceConvert_C
