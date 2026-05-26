local DedicatedServerBase = DungeonClass.Class()

function DedicatedServerBase:BeginPlay()
  print("DedicatedServerBase BeginPlay")
  self.DungeonTimer = {}
  self.CallbackId = 0
  self.CallbackFunc = {}
  self.CallbackCounter = {}
end

local function PackCallback(self, Callback)
  self.CallbackId = self.CallbackId + 1
  self.CallbackFunc[self.CallbackId] = Callback
  return self.CallbackId
end

function DedicatedServerBase:EndPlay()
  local function RemoveAllTimer()
    for k, _ in pairs(self.DungeonTimer) do
      self:RemoveTimer(k)
    end
  end
  
  RemoveAllTimer()
  self.DungeonTimer = {}
end

function DedicatedServerBase:AddTimer(DeltaTime, Callback)
  local Timer, Key = self.GameInstance:AddTimer(DeltaTime, Callback, nil, nil, nil, true)
  self.DungeonTimer[Key] = Timer
  return Key
end

function DedicatedServerBase:AddLoopTimer(DelayTime, LoopTime, Callback, Handle)
  local Timer, Key = self.GameInstance:AddTimer(LoopTime, Callback, true, DelayTime, Handle, true)
  self.DungeonTimer[Key] = Timer
  return Key
end

function DedicatedServerBase:RemoveTimer(Handle)
  self.GameInstance:RemoveTimer(Handle)
  self.DungeonTimer[Handle] = nil
end

function DedicatedServerBase:GetTimerRemainTime(Handle)
  return self.GameInstance:GetTimerRemainingTime(Handle)
end

function DedicatedServerBase:NotifyGameModeDungeonEvent(EventName, ...)
  self.DSEntity:NotifyGameModeDungeonEvent(EventName, ...)
end

function DedicatedServerBase:NotifyServerAvatar(FuncName, AvatarEid, ...)
  local DungeonEvent = "DungeonEvent_" .. FuncName
  self.DSEntity:SendAvatar(AvatarEid, DungeonEvent, ...)
end

function DedicatedServerBase:MulticastServerAvatar(FuncName, ...)
  local DungeonEvent = "DungeonEvent_" .. FuncName
  self.DSEntity:ServerMulticast(DungeonEvent, ...)
end

function DedicatedServerBase:CallServerAvatarWithCallback(FuncName, AvatarEid, Callback, ...)
  local CallbackId = PackCallback(self, Callback)
  self.DSEntity:SendAvatar(AvatarEid, FuncName, CallbackId, ...)
  return CallbackId
end

function DedicatedServerBase:OnResponseDungeonCallback(CallbackId, ...)
  local Callback = self.CallbackFunc[CallbackId]
  local Counter = self.CallbackCounter[CallbackId]
  if Counter then
    self.CallbackCounter[CallbackId] = Counter - 1
    if 1 == Counter then
      self.CallbackCounter[CallbackId] = nil
    end
  end
  if not self.CallbackCounter[CallbackId] then
    self.CallbackFunc[CallbackId] = nil
  end
  if Callback then
    Callback(...)
  end
end

function DedicatedServerBase:Log(...)
  ServerPrint("DungeonLog", ...)
end

function DedicatedServerBase:Replicated(ReplicatedType, ...)
  self.DSEntity:ReplicatedDungeonObject(ReplicatedType, ...)
end

function DedicatedServerBase:TriggerRewardEvent(UnitId, Reason, ExtraInfo, Callback)
  local AvatarEid = ExtraInfo.Avatar
  local CallbackId
  if -1 ~= AvatarEid then
    ExtraInfo.bAuthority = true
    CallbackId = self:CallServerAvatarWithCallback("ServerTriggerRewardEvent", AvatarEid, Callback, UnitId, Reason, ExtraInfo)
  else
    CallbackId = PackCallback(self, Callback)
  end
  ExtraInfo.bAuthority = false
  self.DSEntity:ServerConditionalMulticast({
    [AvatarEid] = false
  }, "ServerTriggerRewardEvent", CallbackId, UnitId, Reason, ExtraInfo)
  self.CallbackCounter[CallbackId] = CommonUtils.Size(self.DSEntity.AvatarInfos)
end

return DedicatedServerBase
