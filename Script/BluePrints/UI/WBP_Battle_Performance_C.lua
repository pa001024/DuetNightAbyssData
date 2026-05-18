require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

local function ClearInputCacheSafely(Context)
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(Context, 0)
  if PlayerCharacter then
    PlayerCharacter:FlushInputKeyExceptMove()
    PlayerCharacter:FlushPlayerPressedKeys()
  end
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  local FinishEventName = select(1, ...)
  self:BlockAllUIInput(true)
  self:PlayAnimation(self.In)
  self:BindToAnimationFinished(self.In, function()
    self:BlockAllUIInput(false)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and FinishEventName and "" ~= FinishEventName then
      GameMode:PostCustomEvent(FinishEventName)
    end
    if GameMode then
      GameMode:OnBattlePerformanceUIFinished()
    end
    self:Close()
    ClearInputCacheSafely(self)
  end)
end

return M
