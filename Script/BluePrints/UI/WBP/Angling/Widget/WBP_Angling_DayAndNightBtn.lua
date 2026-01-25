require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:OnOpenDayAndNight()
  print(_G.LogTag, "LXZ OnOpenDayAndNight")
  local Param = {}
  UIManager(self):ShowCommonPopupUI(100270, Param, self)
end

function M:Init()
  self.Btn_DayAndNight:SetText(GText("UI_Fishing_DayAndNight_Title"))
  
  local function func()
    print(_G.LogTag, "LXZ InitBtn_DayAndNight")
    self.Btn_DayAndNight:BindEventOnClicked(self, self.OnOpenDayAndNight)
    self.Btn_DayAndNight:SetGamePadImg("View")
  end
  
  self:AddTimer(0.1, func, false)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshInfoByInputTypeChange)
  self.CurMode = self.GameInputModeSubsystem:GetCurrentInputType()
  self:RefreshInfoByInputTypeChange(self.CurMode)
end

function M:RefreshInfoByInputTypeChange(CurInputDevice, CurGamepadName)
  self.CurMode = CurInputDevice
end

return M
