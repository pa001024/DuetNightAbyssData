local M = {}

function M:IsOnRail()
  if not IsValid(self.OwnerPlayer) then
    return false
  end
  return self.OwnerPlayer.IsInSlideMech == true
end

function M:GetCurrentSlideMech()
  if IsValid(self.OwnerPlayer) and type(self.OwnerPlayer.GetCurrentSlideMech) == "function" then
    return self.OwnerPlayer:GetCurrentSlideMech()
  end
  return nil
end

function M:UpdateForbiddenState()
  if not self:IsOnRail() then
    if self.bIsForbidden then
      self.bIsForbidden = false
      if self.Normal then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
      end
    end
    return
  end
  local bShouldForbid = self:IsForbidden()
  if bShouldForbid ~= self.bIsForbidden then
    self.bIsForbidden = bShouldForbid
    if bShouldForbid then
      if self.Forbidden then
        DebugPrint("cjh @ Play Forbidden Name: ", self)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Forbidden)
      end
    elseif self.Normal then
      DebugPrint("cjh @ Play Normal: ", self)
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    end
  end
end

function M:InitWithTrackHUD(TrackHUD)
  self.TrackHUD = TrackHUD
  self.OwnerPlayer = TrackHUD.OwnerPlayer
end

function M:SetOwnerPlayer(Player)
  self.OwnerPlayer = Player
  self.bForbiddenCached = nil
end

return M
