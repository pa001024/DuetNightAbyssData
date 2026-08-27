require("UnLua")
local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")
local DEFAULT_SHOW_SUCCESS_TOAST = true
local TIMER_STARTED_BP_EVENT = "OnShootTargetTimerStarted"
local TIMER_ENDED_BP_EVENT = "OnShootTargetTimerEnded"

function M:_GetShootTargetGameId()
  local UnitParams = self.UnitParams or {}
  return self.SelectedShootTargetGameId or self.ShootTargetGameId or self.ExploreShootingID or UnitParams.ShootTargetGameId or UnitParams.ExploreShootingID
end

function M:SetSelectedShootTargetGameId(GameId)
  if nil == GameId then
    return false
  end
  self.SelectedShootTargetGameId = tonumber(GameId) or GameId
  return true
end

function M:SetShootTargetSourceMechanism(Mechanism, PlayerEid)
  if not Mechanism or not IsValid(Mechanism) then
    return false
  end
  self.ShootTargetSourceMechanism = Mechanism
  self.ShootTargetSourcePlayerEid = tonumber(PlayerEid) or 0
  return true
end

function M:_GetRatingRange()
  local GameId = self:_GetShootTargetGameId()
  local Config = GameId and DataMgr and DataMgr.ExploreShootingID and DataMgr.ExploreShootingID[tonumber(GameId) or GameId]
  return Config and Config.RatingRange
end

function M:_CalculateStarLevel(Score)
  local RatingRange = self:_GetRatingRange()
  if type(RatingRange) ~= "table" or 0 == #RatingRange or -1 == tonumber(RatingRange[1]) then
    return -1
  end
  Score = tonumber(Score) or 0
  local StarLevel = 0
  for i, TargetScore in ipairs(RatingRange) do
    TargetScore = tonumber(TargetScore)
    if not TargetScore or Score < TargetScore then
      break
    end
    StarLevel = i
  end
  return StarLevel
end

function M:GetCompleteStarLevel()
  if self.ShootTargetCompleteStarLevel ~= nil then
    return self.ShootTargetCompleteStarLevel
  end
  return self:_CalculateStarLevel(self.Score)
end

function M:_ShouldShowSuccessToast()
  if self.ShootTargetShowSuccessToast == nil then
    return DEFAULT_SHOW_SUCCESS_TOAST
  end
  return self.ShootTargetShowSuccessToast
end

function M:_BindScoreChangedEvent()
  EventManager:RemoveEvent(EventID.OnShootTargetScoreChanged, self)
  EventManager:AddEvent(EventID.OnShootTargetScoreChanged, self, self.OnShootTargetScoreChanged)
end

function M:_UnbindScoreChangedEvent()
  EventManager:RemoveEvent(EventID.OnShootTargetScoreChanged, self)
end

function M:_TriggerShootTargetBlueprintEvent(EventName, ...)
  local Event = self[EventName]
  if Event then
    Event(self, ...)
  end
end

function M:ReceiveOnExploreGroupActive()
  self.Overridden.ReceiveOnExploreGroupActive(self)
  self:ReceiveOnExploreStarted("", "", 0)
end

function M:ReceiveOnExploreStarted(Title, Des, TotalTargetNum)
  self.Score = 0
  self.CurrentStarLevel = self:_CalculateStarLevel(self.Score)
  self.ShootTargetCompleteStarLevel = nil
  self._ShootTargetCleanedUp = false
  self._ShootTargetTimerEventStarted = false
  self:_BindScoreChangedEvent()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local GameId = self:_GetShootTargetGameId()
  local SessionId, Error = GameMode and GameMode:StartShootTargetGame(GameId, self.ExploreGroupId)
  if not SessionId then
    self.SelectedShootTargetGameId = nil
    self:_UnbindScoreChangedEvent()
    GWorld.logger.error("ExploreGroup_ShootTarget start failed: " .. tostring(Error))
    self:FailLimitExplore()
    return
  end
  self.ShootTargetSessionId = SessionId
  self._ShootTargetTimerEventStarted = true
  self.RemainLimitTime = DataMgr.ExploreShootingID[GameId] and DataMgr.ExploreShootingID[GameId].CountDown or -1
  self:_TriggerShootTargetBlueprintEvent(TIMER_STARTED_BP_EVENT, tonumber(self.RemainLimitTime) or -1)
end

function M:OnShootTargetScoreChanged(NewScore, SessionId)
  if SessionId ~= self.ShootTargetSessionId then
    return
  end
  NewScore = tonumber(NewScore)
  if not NewScore then
    return
  end
  self.Score = NewScore
  self.CurrentStarLevel = self:_CalculateStarLevel(NewScore)
  self:UpdateLimitUI(NewScore)
end

function M:AddShootScore(Add)
  EventManager:FireEvent(EventID.AddShootTargetScore, Add, self.ShootTargetSessionId)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  return GameMode and GameMode:GetShootTargetScore() or self.Score or 0
end

function M:ResetShootTargetRound()
  if not self.ShootTargetSessionId then
    return false
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not GameMode or not GameMode:ResetShootTargetGame(self.ShootTargetSessionId) then
    return false
  end
  self.Score = 0
  self.CurrentStarLevel = self:_CalculateStarLevel(self.Score)
  self.ShootTargetCompleteStarLevel = nil
  self:UpdateLimitUI(0)
  return true
end

function M:ReceiveOnExploreGroupSuccess(bShowToast)
  local StarLevel = self:_CalculateStarLevel(self.Score)
  self.ShootTargetCompleteStarLevel = StarLevel
  M.Super.ReceiveOnExploreGroupSuccess(self, self:_ShouldShowSuccessToast())
  self:_CleanupShootTarget()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    GameMode:TriggerOnShootTargetExploreGroupSettled(self.ExploreGroupId, StarLevel)
  end
end

function M:ReceiveOnExploreGroupComplete()
  if not self._ShootTargetCleanedUp and self.ShootTargetSessionId then
    self:ReceiveOnExploreGroupSuccess(true)
  end
  self.Overridden.ReceiveOnExploreGroupComplete(self)
end

function M:ReceiveOnExploreGroupFailed()
  M.Super.ReceiveOnExploreGroupFailed(self)
  self:_CleanupShootTarget()
end

function M:_CleanupShootTarget()
  if self._ShootTargetCleanedUp then
    return
  end
  self._ShootTargetCleanedUp = true
  if self._ShootTargetTimerEventStarted then
    self._ShootTargetTimerEventStarted = false
    self:_TriggerShootTargetBlueprintEvent(TIMER_ENDED_BP_EVENT)
  end
  self.SelectedShootTargetGameId = nil
  self:_UnbindScoreChangedEvent()
  if self.ShootTargetSessionId then
    EventManager:FireEvent(EventID.EndShootTargetGame, self.ShootTargetSessionId)
    self.ShootTargetSessionId = nil
  else
    EventManager:FireEvent(EventID.InitShootTargetUI, false)
  end
  local SourceMechanism = self.ShootTargetSourceMechanism
  local SourcePlayerEid = self.ShootTargetSourcePlayerEid or 0
  self.ShootTargetSourceMechanism = nil
  self.ShootTargetSourcePlayerEid = nil
  if SourceMechanism and IsValid(SourceMechanism) and SourceMechanism.RestoreShootTargetReadyState then
    SourceMechanism:RestoreShootTargetReadyState(SourcePlayerEid)
  end
end

function M:ReceiveEndPlay(Reason)
  self:_CleanupShootTarget()
  M.Super.ReceiveEndPlay(self, Reason)
end

return M
