require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Activity.PC.Coop.WBP_Activity_Coop_RankingPageView"
}
local OpenSoundEventPath = "event:/ui/armory/open"
local OpenSoundKey = "CoopRankOpenSound"

function M:Construct()
  M.Super.Construct(self)
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, OpenSoundEventPath, OpenSoundKey, nil)
end

function M:Destruct()
  M.Super.Destruct(self)
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  AudioManager(self):SetEventSoundParam(self, OpenSoundKey, {ToEnd = 1})
  self:PlayAnimation(self.Out)
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:AddTimer(0.2, function()
    self:Close()
  end)
end

AssembleComponents(M)
return M
