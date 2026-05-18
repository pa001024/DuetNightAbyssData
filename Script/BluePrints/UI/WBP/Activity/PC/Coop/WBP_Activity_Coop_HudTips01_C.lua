require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.Common.TimerMgr"
})

function M:Initialize(Initializer)
end

function M:Construct()
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
end

function M:OnLoaded(...)
  local Params = (...)
  local CurRound = Params.CurRound or 1
  self:UnbindAllFromAnimationFinished(self.In)
  self:BindToAnimationFinished(self.In, {
    self,
    function()
      self:CloseSelf()
    end
  })
  self:PlayAnimation(self.In)
  self.TextNum:SetText(tostring(CurRound))
  self.TextTips:SetText(GText("UI_AsyncCombat_StageNumber"))
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_level_toast_stage_change", nil, nil)
end

function M:Destruct()
  if self:IsExistTimer("CoopStartRoundTip") then
    self:RemoveTimer("CoopStartRoundTip")
  end
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
  self:Close()
end

return M
