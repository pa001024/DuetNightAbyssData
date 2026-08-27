require("UnLua")
local COUNTDOWN_UI_NAME = "FairyTownEveProtectTimeFloat"
local COUNTDOWN_TITLE_TEXT_ID = "UI_STORY_EX02_PROTECT_EVE_01"
local COUNTDOWN_VISIBLE_STATE_ID = 1799131
local COUNTDOWN_TIMER_NAME = "EveProtectCountdownTimer"
local M = Class("BluePrints.Item.BP_CombatItemBase_C")

function M:CloseEveProtectCountdown()
  self:RemoveTimer(COUNTDOWN_TIMER_NAME)
  if IsValid(self.EveProtectCountdownUI) then
    self.EveProtectCountdownUI:Close()
  end
  self.EveProtectCountdownUI = nil
end

function M:OnEnterState(StateId)
  self.Overridden.OnEnterState(self, StateId)
  if not IsClient(self) and not IsStandAlone(self) then
    return
  end
  if StateId ~= COUNTDOWN_VISIBLE_STATE_ID then
    self:CloseEveProtectCountdown()
    return
  end
  local Duration = self.UnitParams.CountdownTime
  if not Duration or Duration <= 0 then
    return
  end
  self.EveProtectCountdownUI = UIManager(self):LoadUINew(COUNTDOWN_UI_NAME, Duration, Duration)
  if not IsValid(self.EveProtectCountdownUI) then
    return
  end
  self.EveProtectCountdownUI:Reset(Duration, Duration, 0)
  self.EveProtectCountdownUI:SetTextFromGameMode(COUNTDOWN_TITLE_TEXT_ID)
  self.EveProtectCountdownUI:UIStateChange_OnTarget()
  self:AddTimer(Duration, self.CloseEveProtectCountdown, false, nil, COUNTDOWN_TIMER_NAME)
end

function M:ReceiveEndPlay(EndReason)
  if IsClient(self) or IsStandAlone(self) then
    self:CloseEveProtectCountdown()
  end
  M.Super.ReceiveEndPlay(self, EndReason)
end

return M
