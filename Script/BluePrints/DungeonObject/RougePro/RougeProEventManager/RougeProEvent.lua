local RougeProGlobalConst = require("BluePrints.DungeonObject.RougePro.RougeProGlobalConst")
local RougeProEvent = DungeonClass.Class()
RougeProEvent.__Class__ = "RougeProEvent"
RougeProEvent.__Component__ = {
  "BluePrints.DungeonObject.Replication.ReplicatedPropertySupport",
  "BluePrints.DungeonObject.RougePro.GameModeRougeProComponents.GameModeRougeProEvent"
}

function RougeProEvent:__Init__(DungeonObject, EventId)
  self.DungeonObject = DungeonObject
  self:InitReplicatedProperties(self)
  self:InitReplicatedProperties(self, "EventId", EventId, "OnRep_EventId")
  self:InitReplicatedProperties(self, "EventState", RougeProGlobalConst.RougeProEventState.Invalid, "OnRep_EventState")
  self:InitReplicatedProperties(self, "StartTime", os.time(), "OnRep_StartTime")
  self:InitReplicatedProperties(self, "OccupationProcess", 0, "OnRep_OccupationProcess")
  self:InitReplicatedProperties(self, "SurvivalProProcess", 0, "OnRep_SurvivalProProcess")
  self:InitReplicatedProperties(self, "ExterminateProcess", 0, "OnRep_ExterminateProcess")
  self:InitReplicatedProperties(self, "DefenceRound", 0, "OnRep_DefenceRound")
  self:InitReplicatedProperties(self, "KillMonsterNum", 0, "OnRep_KillMonsterNum")
  self:InitReplicatedProperties(self, "IsCowEvent", false, "OnRep_IsCowEvent")
  self.HadActive = false
  self.ListenTimerMap = {}
  self.CowEventInfo = nil
end

function RougeProEvent:OnRep_EventId()
  print(string.format("RougeProEvent: OnRep_EventId=%s", tostring(self.EventId)))
end

function RougeProEvent:OnRep_EventState()
  print(string.format("RougeProEvent: OnRep_EventState=%s", tostring(self.EventState)))
end

function RougeProEvent:OnRep_StartTime()
  print(string.format("RougeProEvent: OnRep_StartTime=%s", tostring(self.StartTime)))
end

function RougeProEvent:OnRep_OccupationProcess()
  print(string.format("OnRep_OccupationProcess self.OccupationProcess = %s", tostring(self.OccupationProcess)))
end

function RougeProEvent:OnRep_SurvivalProProcess()
  print(string.format("OnRep_SurvivalProProcess self.SurvivalProProcess = %s", tostring(self.SurvivalProProcess)))
end

function RougeProEvent:OnRep_ExterminateProcess()
  print(string.format("OnRep_ExterminateProcess self.ExterminateProcess = %s", tostring(self.ExterminateProcess)))
end

function RougeProEvent:OnRep_DefenceRound()
  print(string.format("OnRep_DefenceRound self.DefenceRound = %s", tostring(self.DefenceRound)))
end

function RougeProEvent:OnRep_KillMonsterNum()
  print(string.format("OnRep_KillMonsterNum self.KillMonsterNum = %s", tostring(self.KillMonsterNum)))
end

function RougeProEvent:OnRep_IsCowEvent()
  print(string.format("OnRep_KillMonsterNum self.IsCowEvent = %s", tostring(self.IsCowEvent)))
end

function RougeProEvent:BeginPlay()
end

function RougeProEvent:EndPlay()
end

function RougeProEvent:SetEventState(State)
  print(string.format("RougeProEvent:ChangeEventState. EventId(%s) OldState=%s, NewState=%s", tostring(self.EventId), tostring(self.EventState), tostring(State)))
  self.EventState = State
end

function RougeProEvent:IsEventState(State)
  return self.EventState == State
end

function RougeProEvent:AddOccupation(value)
  self.OccupationProcess = self.OccupationProcess + value
  print(string.format("RougeProEvent EventId=%s AddOccupation=%s NewOccupation=%s", tostring(self.EventId), tostring(value), tostring(self.OccupationProcess)))
  return self.OccupationProcess
end

function RougeProEvent:AddSurvivalPro(value)
  self.SurvivalProProcess = math.max(self.SurvivalProProcess + value, 0)
  return self.SurvivalProProcess
end

function RougeProEvent:AddExterminate(value)
  self.ExterminateProcess = self.ExterminateProcess + value
  print(string.format("RougeProEvent EventId=%s AddExterminate=%s NewExterminate=%s", tostring(self.EventId), tostring(value), tostring(self.ExterminateProcess)))
  return self.ExterminateProcess
end

function RougeProEvent:InitDefence()
  self.DefenceRound = 0
  self.DefenceCoreMechanismUniqueId = {}
  self.DefenceNextRoundTimer = nil
end

function RougeProEvent:RegisterLoopTimer(Name, DelayTime, LoopTime, CallBack)
  local Owner = self.DungeonObject
  self:UnRegisterTimer(Owner, Name)
  local Handle = Owner:AddLoopTimer(DelayTime, LoopTime, CallBack, Name)
  self.ListenTimerMap[Name] = Handle or Name
  print(string.format("RougeProEvent(%s) RegisterLoopTimer(%s)", tostring(self.EventId), tostring(Name)))
  return Handle
end

function RougeProEvent:RegisterTimer(Name, DeltaTime, CallBack)
  local Owner = self.DungeonObject
  self:UnRegisterTimer(Owner, Name)
  local Handle = Owner:AddTimer(DeltaTime, CallBack)
  self.ListenTimerMap[Name] = Handle
  print(string.format("RougeProEvent(%s) RegisterTimer(%s)", tostring(self.EventId), tostring(Name)))
  return Handle
end

function RougeProEvent:UnRegisterTimer(Name)
  local Owner = self.DungeonObject
  local Handle = self.ListenTimerMap[Name]
  if Handle then
    Owner:RemoveTimer(Handle)
    self.ListenTimerMap[Name] = nil
  end
  print(string.format("RougeProEvent(%s) UnRegisterTimer(%s)", tostring(self.EventId), tostring(Name)))
end

function RougeProEvent:RougeProEventClose()
  local Owner = self.DungeonObject
  for Name, Handle in pairs(self.ListenTimerMap) do
    Owner:RemoveTimer(Handle)
    print(string.format("RougeProEvent(%s) RougeProEventClose Clear TimerName=%s", tostring(self.EventId), tostring(Name)))
  end
  self.ListenTimerMap = {}
end

DungeonClass.AssembleComponents(RougeProEvent)
return RougeProEvent
