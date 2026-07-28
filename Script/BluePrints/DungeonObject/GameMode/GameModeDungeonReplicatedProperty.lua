local NetGuidMap = {}
local OnRepFuncLayer = {}
local ReplicatedClassRegistry = require("BluePrints.DungeonObject.Replication.ReplicatedClassRegistry")
local ClassRegistry = {}
local GameModeDungeonReplicatedProperty = {}

local function InitLocalAttr()
  NetGuidMap = {}
  OnRepFuncLayer = {}
  ClassRegistry = {}
end

function GameModeDungeonReplicatedProperty:Init(Env)
  if not Env.NetGuid then
    return
  end
  InitLocalAttr()
  self:InitClassRegistry()
  local NetGuid = Env.NetGuid
  NetGuidMap[NetGuid] = self
end

function GameModeDungeonReplicatedProperty:InitClassRegistry()
  self:RegisterReplicatedClass(ReplicatedClassRegistry)
end

function GameModeDungeonReplicatedProperty:RegisterReplicatedClass(ClassTable)
  for k, v in pairs(ClassTable) do
    ClassRegistry[k] = v
  end
end

function GameModeDungeonReplicatedProperty:BeginPlay()
end

function GameModeDungeonReplicatedProperty:EndPlay()
end

function GameModeDungeonReplicatedProperty:InitReplicatedProperties()
end

function GameModeDungeonReplicatedProperty:ReplicatedProperty(NetGuid, PropName, Value, OnRepFunc)
  local Inc = NetGuidMap[NetGuid]
  assert(Inc, string.format("ReplicatedProperty with not exist Actor: %d", NetGuid))
  local RepLayer = OnRepFuncLayer[NetGuid] or {}
  if OnRepFunc then
    RepLayer[PropName] = OnRepFunc
    OnRepFuncLayer[NetGuid] = RepLayer
  end
  if type(Value) == "table" then
    local NetGuid = Value._NetGuid
    if NetGuid then
      Inc[PropName] = NetGuidMap[NetGuid]
    else
      local Class = Value.__Class__
      if Class then
        do
          local ClassInfo = ClassRegistry[Class]
          local ValueInc = ClassInfo(self)
          if ValueInc.BeginPlay then
            ValueInc:BeginPlay()
          end
          for k, v in pairs(Value) do
            ValueInc[k] = v
          end
          Inc[PropName] = ValueInc
        end
      else
        Inc[PropName] = Value
      end
    end
  else
    Inc[PropName] = Value
  end
  local CurOnRepFunc = RepLayer[PropName]
  if not CurOnRepFunc then
    return
  end
  local Func = Inc[CurOnRepFunc]
  if not Func then
    return
  end
  Func(Inc)
end

function GameModeDungeonReplicatedProperty:ReplicatedActor(Class, NetGuid, Props, _OnRepFuncLayer)
  assert(not NetGuidMap[NetGuid], string.format("ReplicatedActor with exist Actor: %d", NetGuid))
  local ClassInfo = ClassRegistry[Class]
  local Inc = ClassInfo(self)
  if Inc.BeginPlay then
    Inc:BeginPlay()
  end
  NetGuidMap[NetGuid] = Inc
  OnRepFuncLayer[NetGuid] = _OnRepFuncLayer
  for k, v in pairs(Props) do
    self:ReplicatedProperty(NetGuid, k, v)
  end
end

function GameModeDungeonReplicatedProperty:ReplicatedDeleteActor(NetGuid)
  local Inc = NetGuidMap[NetGuid]
  if not Inc then
    return
  end
  if Inc.EndPlay then
    Inc:EndPlay()
  end
  NetGuidMap[NetGuid] = nil
  OnRepFuncLayer[NetGuid] = nil
end

function GameModeDungeonReplicatedProperty:OnRepTestRep()
  print("ReplicatedDungeonObject", "OnRepTestRep", self.TestRep, self.TestClass)
  if self.TestClass then
    print("ReplicatedDungeonObject TestClass", self.TestClass.A, self.TestClass.D)
    if self.TestClass.TestClass2 then
      print("ReplicatedDungeonObject TestClass2", self.TestClass.TestClass2.C)
    end
  end
end

function GameModeDungeonReplicatedProperty:GetReplicatedActorByNetGuid(NetGuid)
  return NetGuidMap[NetGuid]
end

return GameModeDungeonReplicatedProperty
