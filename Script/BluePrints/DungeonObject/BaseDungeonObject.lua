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

function BaseDungeonObject:DungeonFinish(IsWin, Eid)
  local CustomInfoFunc = self.CustomFinishInfo
  local CustomInfo = CustomInfoFunc and CustomInfoFunc(self, Eid, IsWin) or {}
  self:NotifyServerAvatar("DungeonFinish", Eid, IsWin, CustomInfo)
end

DungeonClass.AssembleComponents(BaseDungeonObject)
return BaseDungeonObject
