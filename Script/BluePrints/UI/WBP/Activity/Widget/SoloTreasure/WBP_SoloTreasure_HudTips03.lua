require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Text_Task:SetText(GText("UI_Extreaction_StartRain"))
  self.Text_Task02:SetText(GText("UI_Extreaction_StartRainMonster"))
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self:PlayAnimation(self.In)
  self:BindToAnimationFinished(self.Out, function()
    self:Close()
  end)
  AudioManager(self):PlayUISound(self, "event:/ui/common/toast_warning", nil, nil)
  self:AddTimer(3, function()
    self:PlayAnimation(self.Out)
  end)
end

return M
