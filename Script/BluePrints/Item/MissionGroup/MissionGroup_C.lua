require("UnLua")
local M = Class("BluePrints.Common.TimerMgr")

function M:GetMissionState()
  if not self.QuestID or 0 == self.QuestID then
    return "NotStart"
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return "NotStart"
  end
  if Avatar:IsQuestFinished(self.QuestID) or Avatar:IsQuestAssumeFinished(self.QuestID) then
    return "Complete"
  end
  if Avatar:IsQuestDoing(self.QuestID) then
    return "Doing"
  end
  return "NotStart"
end

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  self._LastMissionState = self:GetMissionState()
  self:RegisterGameModeEvents()
  EventManager:AddEvent(EventID.OnUpdateQuestChain, self, self.OnUpdateQuestChainHandler)
  EventManager:AddEvent(EventID.OnCompleteQuestChain, self, self.OnCompleteQuestChainHandler)
  EventManager:AddEvent(EventID.OnMissionGroupStart, self, self.OnReceiveMissionStart)
  EventManager:AddEvent(EventID.OnQuestRestart, self, self.OnReceiveMissionStart)
  EventManager:AddEvent(EventID.OnMechanismEnterState, self, self.OnMechanismEnterStateHandler)
  self:AddTimer(0.01, function()
    if not IsValid(self) then
      return
    end
    if self._LastMissionState == "NotStart" then
      self:TriggerOnMissionNotStart()
    elseif self._LastMissionState == "Doing" then
      self:TriggerOnMissionStart()
    elseif self._LastMissionState == "Complete" then
      self:TriggerOnMissionComplete()
    end
  end, false, 0, "MissionGroupInitialQuestStateCheck", false)
end

function M:ReceiveEndPlay(Reason)
  self:UnRegisterGameModeEvents()
  EventManager:RemoveEvent(EventID.OnUpdateQuestChain, self)
  EventManager:RemoveEvent(EventID.OnCompleteQuestChain, self)
  EventManager:RemoveEvent(EventID.OnMechanismEnterState, self)
  self:CleanDelayActions()
  self:CleanTimer()
  self.Overridden.ReceiveEndPlay(self, Reason)
end

function M:OnUpdateQuestChainHandler(QuestChainId)
  DebugPrint("zwkkjj OnUpdateQuestChainHandler", QuestChainId)
  if not self.QuestID or 0 == self.QuestID then
    return
  end
  local NewState = self:GetMissionState()
  if NewState == self._LastMissionState then
    return
  end
  self._LastMissionState = NewState
  if "Doing" == NewState then
    self:TriggerOnMissionStart()
  elseif "Complete" == NewState then
    self:TriggerOnMissionComplete()
  elseif "NotStart" == NewState then
    self:TriggerOnMissionNotStart()
  end
end

function M:OnCompleteQuestChainHandler(QuestChainId, QuestId)
  DebugPrint("zwkkjj OnCompleteQuestChainHandler", QuestChainId, QuestId)
  if not self.QuestID or 0 == self.QuestID then
    return
  end
  if QuestId ~= self.QuestID then
    return
  end
  if self._LastMissionState == "Complete" then
    return
  end
  self._LastMissionState = "Complete"
  self:TriggerOnMissionComplete()
end

function M:OnReceiveMissionStart(QuestId)
  DebugPrint("zwkkjj OnReceiveMissionStart", QuestId)
  if not QuestId or QuestId ~= self.QuestID then
    return
  end
  local NewState = self:GetMissionState()
  if "Doing" == NewState then
    self:TriggerOnMissionStart()
  end
end

function M:RegisterGameModeEvents()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not IsValid(GameMode) then
    GameMode = GWorld.GameInstance:GetCurrentGameMode()
  end
  if not IsValid(GameMode) then
    return
  end
  if GameMode.OnCustomEventDelegates then
    GameMode.OnCustomEventDelegates:Add(self, self.OnCustomEventHandler)
  end
end

function M:UnRegisterGameModeEvents()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not IsValid(GameMode) then
    GameMode = GWorld.GameInstance:GetCurrentGameMode()
  end
  if not IsValid(GameMode) then
    return
  end
  if GameMode.OnCustomEventDelegates then
    GameMode.OnCustomEventDelegates:Remove(self, self.OnCustomEventHandler)
  end
end

function M:OnCustomEventHandler(EventName, Channel)
  self:TriggerOnCustomEvent(EventName, Channel)
end

function M:OnMechanismEnterStateHandler(MechanismId, StateId)
  if not MechanismId or 0 == MechanismId then
    return
  end
  local StaticCreator = self.StaticCreatorMap and self.StaticCreatorMap:FindRef(MechanismId)
  local ManualMechanism = self.ManualMechanismMap and self.ManualMechanismMap:FindRef(MechanismId)
  if not StaticCreator and not ManualMechanism then
    return
  end
  self:OnMissionMechanismStateChange(MechanismId, StateId, 0)
  if ManualMechanism then
    self:OnManualMechanismStateChange(MechanismId, StateId)
  end
end

function M:ActiveGuideIcon_Lua(Eid)
  local Entity = Battle(self):GetEntity(Eid)
  if Entity and Entity.ActiveGuide then
    Entity:ActiveGuide("Add")
  end
end

function M:DeactiveGuideIcon_Lua(Eid)
  local Entity = Battle(self):GetEntity(Eid)
  if Entity and Entity.DeactiveGuide then
    Entity:DeactiveGuide()
  end
end

function M:SetPlayerToTransform(Transform)
  if not Transform then
    return
  end
  if Transform.Translation and 0 == Transform.Translation.x and 0 == Transform.Translation.y and 0 == Transform.Translation.z then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not Player then
    return
  end
  Player:K2_SetActorTransform(Transform, false, nil, false)
  if Player.EnableCheckOverlapPush then
    Player:EnableCheckOverlapPush({})
  end
  if Player.StartCameraFade then
    Player:StartCameraFade()
  end
  local Controller = Player:GetController()
  if Controller then
    Controller:SetControlRotation(Player:K2_GetActorRotation())
  end
  if Player.Landed then
    Player:Landed()
  end
end

return M
