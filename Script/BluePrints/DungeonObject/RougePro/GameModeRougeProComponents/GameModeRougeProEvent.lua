local GameModeRougeProEvent = DungeonClass.Class()

function GameModeRougeProEvent:Init()
  self.EventInfo = DataMgr.RougePro_Event[self.EventId]
  if not self.EventInfo then
    return false
  end
  self.GameMode = self.DungeonObject.GameMode
  self.GameState = self.GameMode.EMGameState
  self.EventType = self.EventInfo.EventType
  local AreaId = self.EventInfo.Area
  self.AreaInfo = DataMgr.RougePro_EventArea[AreaId]
  assert(self.AreaInfo)
  self.EnterTriggerBoxId = self.AreaInfo.EnterTriggerBox
  self.ExitTriggerBoxId = self.AreaInfo.ExitTriggerBox
  self.PlayerList = {}
  self.IsPlaying = false
  self.EventSubInfo = DataMgr[self.EventType][self.EventInfo.EventSubId]
  local InitSubGameFun = "InitSubGame_" .. self.EventType
  if self[InitSubGameFun] then
    self[InitSubGameFun](self)
  end
  return true
end

function GameModeRougeProEvent:OnComplete()
end

function GameModeRougeProEvent:OnDestroy()
  local InitSubGameFun = "OnDestroy_" .. self.EventType
  if self[InitSubGameFun] then
    self[InitSubGameFun](self)
  end
end

function GameModeRougeProEvent:OnTriggerAOIBase(CreatorId, TriggerBase, EMActorEid, TriggerType)
  print("GameModeRougeProEvent: Event OnTriggerAOIBase", CreatorId, TriggerBase, EMActorEid, TriggerType)
  if CreatorId == self.EnterTriggerBoxId and "BeginOverlap" == TriggerType then
    self:OnPlayerEnterBox(EMActorEid)
  elseif CreatorId == self.ExitTriggerBoxId and "EndOverlap" == TriggerType then
    self:OnPlayerExitBox(EMActorEid)
  end
end

function GameModeRougeProEvent:OnPlayerEnterBox(Eid)
  self.PlayerList[Eid] = true
  if not self.IsPlaying then
    self.IsPlaying = true
    self.DungeonObject:NotifyServerDungeonEvent("EnterTriggerBox", self.EnterTriggerBoxId)
  end
  local SubGameFun = "OnPlayerEnterBox_" .. self.EventType
  if self[SubGameFun] then
    self[SubGameFun](self, Eid)
  end
end

function GameModeRougeProEvent:OnPlayerExitBox(Eid)
  self.PlayerList[Eid] = false
  if not self:HasPlayerInEvent() then
    self.IsPlaying = false
    self.DungeonObject:NotifyServerDungeonEvent("ExitTriggerBox", self.ExitTriggerBoxId)
  end
  local SubGameFun = "OnPlayerExitBox_" .. self.EventType
  if self[SubGameFun] then
    self[SubGameFun](self, Eid)
  end
end

function GameModeRougeProEvent:OnPlayerExitGame(Eid)
  self:OnPlayerExitBox(Eid)
end

function GameModeRougeProEvent:HasPlayerInEvent()
  for PlayerEid, IsIn in pairs(self.PlayerList) do
    if IsIn then
      return true
    end
  end
  return false
end

function GameModeRougeProEvent:OnMiniGameSuccess(MiniGameType, CreatorId)
  local SubGameFun = "OnMiniGameSuccess_" .. self.EventType
  if self[SubGameFun] then
    self[SubGameFun](self, MiniGameType, CreatorId)
  end
end

function GameModeRougeProEvent:OnSceneItemDestroyed(SceneItem, DestroyReason)
  local SubGameFun = "OnSceneItemDestroyed_" .. self.EventType
  if self[SubGameFun] then
    self[SubGameFun](self, SceneItem, DestroyReason)
  end
end

function GameModeRougeProEvent:InitSubGame_RougePro_SurvivalPro()
  if self.EventSubInfo then
    self.DungeonObject:SetExtraFixSurvivalValue(self.EventSubInfo.ExtraFixSurvivalValue)
  end
end

function GameModeRougeProEvent:InitSubGame_RougePro_SabotagePro()
  self.IsMiniGameSuccess = false
end

function GameModeRougeProEvent:OnDestroy_RougePro_SabotagePro()
  for PlayerEid, IsInBox in pairs(self.PlayerList) do
    self:ChangeSabotageTargetGuide(false, PlayerEid)
  end
end

function GameModeRougeProEvent:OnMiniGameSuccess_RougePro_SabotagePro(MiniGameType, CreatorId)
  if not CommonUtils.HasValue(self.AreaInfo.SabotageProStaticPointId, CreatorId) then
    return
  end
  self.IsMiniGameSuccess = true
  for PlayerEid, IsInBox in pairs(self.PlayerList) do
    if IsInBox then
      self:ChangeSabotageTargetGuide(true, PlayerEid)
    end
  end
end

function GameModeRougeProEvent:OnSceneItemDestroyed_RougePro_SabotagePro(SceneItem, DestroyReason)
  if not SceneItem then
    return
  end
  local Eid = SceneItem.Eid
  local TargetEids = self:GetSabotageTargetEids()
  if not CommonUtils.HasValue(TargetEids, Eid) then
    return
  end
  for PlayerEid, IsInBox in pairs(self.PlayerList) do
    if IsInBox then
      self.GameState:RemoveGuideEid(Eid, PlayerEid)
    end
  end
end

function GameModeRougeProEvent:OnPlayerEnterBox_RougePro_SabotagePro(PlayerEid)
  if not self.IsMiniGameSuccess then
    return
  end
  self:ChangeSabotageTargetGuide(true, PlayerEid)
end

function GameModeRougeProEvent:OnPlayerExitBox_RougePro_SabotagePro(PlayerEid)
  self:ChangeSabotageTargetGuide(false, PlayerEid)
end

function GameModeRougeProEvent:ChangeSabotageTargetGuide(IsShow, PlayerEid)
  local TargetEids = self:GetSabotageTargetEids()
  for _, Eid in pairs(TargetEids) do
    if IsShow then
      self.GameState:AddGuideEid(Eid, PlayerEid)
    else
      self.GameState:RemoveGuideEid(Eid, PlayerEid)
    end
  end
end

function GameModeRougeProEvent:GetSabotageTargetEids()
  if self.SabotageTargetEids == nil then
    self.SabotageTargetEids = {}
    for Eid, SceneItem in pairs(self.GameState.CombatItemMap) do
      if not SceneItem then
      else
        local CreatorId = SceneItem.CreatorId
        if not CommonUtils.HasValue(self.AreaInfo.SabotageProStaticPointId, CreatorId) then
        else
          local UnitId = SceneItem.UnitId
          if not DataMgr.Mechanism[UnitId] then
          elseif not DataMgr.Mechanism[UnitId].UnitRealType == "MiniGame" then
          else
            table.insert(self.SabotageTargetEids, Eid)
          end
        end
      end
    end
  end
  return self.SabotageTargetEids
end

function GameModeRougeProEvent:GameModeRougeProEventPrint(...)
  print("[GameModeRougeProEvent] EventId", self.EventId, " EventType:", self.EventType, ...)
end

return GameModeRougeProEvent
