require("UnLua")
local M = Class("BluePrints/Item/BP_CombatItemBase_C")
local ACTION_EVENT_CONFIG = {
  Avoid = {
    EventId = EventID.OnAvoidPressed,
    NeedField = "NeedAvoidEvent"
  },
  BulletJump = {
    EventId = EventID.OnBulletJumpStarted,
    NeedField = "NeedBulletJumpEvent"
  },
  Jump = {
    EventId = EventID.OnJumpPressed,
    NeedField = "NeedJumpEvent"
  },
  Slide = {
    EventId = EventID.OnSlidePressed,
    NeedField = "NeedSlideEvent"
  },
  Fire = {
    EventId = EventID.OnFirePressed,
    NeedField = "NeedFireEvent"
  },
  Skill1 = {
    EventId = EventID.OnSkill1Pressed,
    NeedField = "NeedSkill1Event"
  },
  Skill2 = {
    EventId = EventID.OnSkill2Pressed,
    NeedField = "NeedSkill2Event"
  },
  Skill3 = {
    EventId = EventID.OnSkill3Pressed,
    NeedField = "NeedSkill3Event"
  },
  ChargeBullet = {
    EventId = EventID.OnChargeBulletPressed,
    NeedField = "NeedChargeBulletEvent"
  },
  Interactive = {
    EventId = EventID.OnInteractivePressed,
    NeedField = "NeedInteractiveEvent"
  }
}

function M:_GetTouchConfig()
  return {
    bAddScore = self.bTouchAddScore == true,
    ScoreValue = tonumber(self.TouchScoreValue) or 0,
    bAddBuff = true == self.bTouchAddBuff,
    BuffId = tonumber(self.TouchBuffId) or 0,
    BuffLastTime = tonumber(self.TouchBuffLastTime) or -1,
    BuffNum = tonumber(self.TouchBuffNum) or 1
  }
end

function M:_GetKeyConfig()
  return {
    bAddScore = self.bKeyAddScore == true,
    ScoreValue = tonumber(self.KeyScoreValue) or 0,
    bAddBuff = true == self.bKeyAddBuff,
    BuffId = tonumber(self.KeyBuffId) or 0,
    BuffLastTime = tonumber(self.KeyBuffLastTime) or -1,
    BuffNum = tonumber(self.KeyBuffNum) or 1
  }
end

function M:ReceiveBeginPlay()
  self._PlayersInBox = {}
  self._DoneTouchScore = false
  self._DoneTouchBuff = false
  self._DoneKey = false
  self._Locked = false
  if self.Box then
    self.Box.OnComponentBeginOverlap:Add(self, self.OnBoxBeginOverlap)
    self.Box.OnComponentEndOverlap:Add(self, self.OnBoxEndOverlap)
  else
    print(_G.ErrorTag, "[MountTouchRing] 找不到碰撞盒组件 self.Box，请检查蓝图组件名")
  end
  self._ActionEventCfg = self:_GetActionEventConfig()
  if self._ActionEventCfg then
    EventManager:RemoveEvent(self._ActionEventCfg.EventId, self)
    EventManager:AddEvent(self._ActionEventCfg.EventId, self, self.OnPlayerActionTriggered)
  elseif self:_GetTriggerActionName() then
    print(_G.ErrorTag, "[MountTouchRing] 未识别的 TriggerActionName:", self:_GetTriggerActionName())
  end
  DebugPrint("MountTouchRing:ReceiveBeginPlay")
end

function M:ReceiveEndPlay(Reason)
  if self._ActionEventCfg then
    EventManager:RemoveEvent(self._ActionEventCfg.EventId, self)
  end
  for Player, _ in pairs(self._PlayersInBox or {}) do
    self:_SetPlayerActionEventEnabled(Player, false)
  end
end

function M:_GetTriggerActionName()
  local ActionName = self.TriggerActionName or self.TriggerKey
  if ActionName and "" ~= ActionName then
    return ActionName
  end
  return nil
end

function M:_GetActionEventConfig()
  local ActionName = self:_GetTriggerActionName()
  if not ActionName then
    return nil
  end
  return ACTION_EVENT_CONFIG[ActionName]
end

function M:_SetPlayerActionEventEnabled(Player, bEnabled)
  local Cfg = self._ActionEventCfg
  if not Cfg or not IsValid(Player) then
    return
  end
  Player[Cfg.NeedField] = true == bEnabled
end

function M:_IsLocalPlayer(OtherActor)
  if not (OtherActor and OtherActor.IsPlayer) or not OtherActor:IsPlayer() then
    return false
  end
  local LocalPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  return OtherActor == LocalPlayer
end

function M:OnBoxBeginOverlap(Component, OtherActor)
  if self._Locked or not self:_IsLocalPlayer(OtherActor) then
    return
  end
  self._PlayersInBox[OtherActor] = true
  self:_SetPlayerActionEventEnabled(OtherActor, true)
  local Cfg = self:_GetTouchConfig()
  if not self._DoneTouchScore and Cfg.bAddScore and 0 ~= Cfg.ScoreValue and self:_DoAddScore(Cfg.ScoreValue) then
    self._DoneTouchScore = true
    self:_OnTriggered("TouchScore")
  end
  if not self._DoneTouchBuff and Cfg.bAddBuff and 0 ~= Cfg.BuffId and self:_DoAddBuff(OtherActor, Cfg) then
    self._DoneTouchBuff = true
    self:_OnTriggered("TouchBuff")
  end
end

function M:OnBoxEndOverlap(Component, OtherActor)
  if not self:_IsLocalPlayer(OtherActor) then
    return
  end
  self._PlayersInBox[OtherActor] = nil
  self:_SetPlayerActionEventEnabled(OtherActor, false)
  if self._DoneTouchScore or self._DoneTouchBuff or self._DoneKey then
    self._Locked = true
  end
end

function M:_IsAnyPlayerInBox()
  for Player, _ in pairs(self._PlayersInBox or {}) do
    if IsValid(Player) then
      return Player
    end
  end
  return nil
end

function M:OnPlayerActionTriggered()
  if self._Locked or self._DoneKey then
    return
  end
  local Player = self:_IsAnyPlayerInBox()
  if not Player then
    return
  end
  local Cfg = self:_GetKeyConfig()
  local DidSomething = false
  if Cfg.bAddScore and 0 ~= Cfg.ScoreValue and self:_DoAddScore(Cfg.ScoreValue) then
    DidSomething = true
  end
  if Cfg.bAddBuff and 0 ~= Cfg.BuffId and self:_DoAddBuff(Player, Cfg) then
    DidSomething = true
  end
  if DidSomething then
    self._DoneKey = true
    self:_OnTriggered("Action")
  end
end

function M:_DoAddScore(Value)
  local ExploreGroup = self:_GetExploreGroup()
  if ExploreGroup and ExploreGroup.AddScore then
    ExploreGroup:AddScore(Value)
    return true
  end
  return false
end

function M:_DoAddBuff(Player, Cfg)
  if not IsValid(Player) then
    return false
  end
  Battle(self):AddBuffToTarget(Player, Player, Cfg.BuffId, Cfg.BuffLastTime, 0, nil, Cfg.BuffNum)
  return true
end

function M:_OnTriggered(Source)
  if self.OnMountTouchRingTriggered then
    self:OnMountTouchRingTriggered(Source)
  end
end

function M:_GetExploreGroup()
  if not self.RarelyId or 0 == self.RarelyId then
    print(_G.ErrorTag, "[MountTouchRing] 机关没有 RarelyId，无法定位探索组")
    return nil
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState then
    return nil
  end
  return GameState.ExploreGroupMap:FindRef(self.RarelyId)
end

return M
