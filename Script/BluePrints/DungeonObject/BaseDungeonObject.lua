local BaseDungeonObject = DungeonClass.Class()
local DungeonObjectConst = require("BluePrints.DungeonObject.DungeonObjectConst")
BaseDungeonObject.__Name__ = "BaseDungeonObject"
BaseDungeonObject.__Component__ = {
  "BluePrints.DungeonObject.DungeonObjectRPC"
}

function BaseDungeonObject:Init(Env)
  if not Env then
    return
  end
  if type(Env) ~= "table" then
    return
  end
  for k, v in pairs(Env) do
    rawset(self, k, v)
  end
end

function BaseDungeonObject:InitExtra(Info)
end

function BaseDungeonObject:BeginPlay()
end

function BaseDungeonObject:EndPlay()
end

function BaseDungeonObject:AddTimer(DeltaTime, Callback)
end

function BaseDungeonObject:AddLoopTimer(DelayTime, LoopTime, Callback, Handle)
end

function BaseDungeonObject:RemoveTimer(Handle)
end

function BaseDungeonObject:GetTimerRemainTime(Handle)
end

function BaseDungeonObject:NotifyServerAvatar(EventName, AvatarEid, ...)
end

function BaseDungeonObject:MulticastServerAvatar(EventName, ...)
end

function BaseDungeonObject:CallServerAvatarWithCallback(EventName, AvatarEid, Callback, ...)
end

function BaseDungeonObject:Log(...)
end

function BaseDungeonObject:Replicated(PropName, Value, OnRepFunc)
end

function BaseDungeonObject:TriggerRewardEvent(UnitId, Reason, ExtraInfo, Callback)
end

function BaseDungeonObject:DungeonFinish(IsWin, Eid)
  local CustomInfoFunc = self.CustomFinishInfo
  local CustomInfo = CustomInfoFunc and CustomInfoFunc(self, Eid, IsWin) or {}
  self:NotifyServerAvatar("DungeonFinish", Eid, IsWin, CustomInfo)
end

DungeonClass.AssembleComponents(BaseDungeonObject)
return BaseDungeonObject
