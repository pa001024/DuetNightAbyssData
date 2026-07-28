local BP_DungeonObject_C = Class()
local DungeonFactory = require("BluePrints.DungeonObject.DungeonFactory")
local msgpack = require("msgpack_core")

function BP_DungeonObject_C:OnRep_DungeonId()
  local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
  if not DungeonInfo then
    return
  end
  local DungeonType = DungeonInfo.DungeonType
  self.ClientDungeonObject = DungeonFactory.CreateClientDungeon(DungeonType)
  GWorld:SetClientDungeonObject_C(self.ClientDungeonObject)
  GWorld:SetDungeonObjectCProperty(self)
end

function BP_DungeonObject_C:ReceiveBeginPlay()
  self.DungeonObject = GWorld:GetGameModeDungeonObject()
  if self.DungeonObject then
    self.DungeonObject:BindCObject(self)
    if IsStandAlone(self) then
      self:OnRep_DungeonId()
    end
  end
end

function BP_DungeonObject_C:ReceiveEndPlay()
  GWorld:SetClientDungeonObject_C(nil)
  GWorld:SetDungeonObjectCProperty(nil)
end

function BP_DungeonObject_C:OnRep_DungeonObjectTimerHandles()
  local LastTimerHandles = self.LocalTimerHandles or {}
  local NewTimerHandles = self.DungeonObjectTimerHandles:ToTable()
  print("BP_DungeonObject_C:OnRep_DungeonObjectTimerHandles LastTimerHandles", CommonUtils:TableToStr(LastTimerHandles))
  print("BP_DungeonObject_C:OnRep_DungeonObjectTimerHandles NewTimerHandles", CommonUtils:TableToStr(NewTimerHandles))
  local AddTimerHandles = {}
  for _, TimerHandle in pairs(NewTimerHandles) do
    if not CommonUtils.HasValue(LastTimerHandles) then
      table.insert(AddTimerHandles, TimerHandle)
    end
  end
  local RemoveTimerHandles = {}
  for _, TimerHandle in pairs(LastTimerHandles) do
    if not CommonUtils.HasValue(NewTimerHandles) then
      table.insert(RemoveTimerHandles, TimerHandle)
    end
  end
  for _, TimerHandle in pairs(AddTimerHandles) do
    self:DoClientAddTimerEvent(TimerHandle)
  end
  for _, TimerHandle in pairs(RemoveTimerHandles) do
    self:DoClientRemoveTimerEvent(TimerHandle)
  end
  self.LocalTimerHandles = NewTimerHandles
end

function BP_DungeonObject_C:DoClientAddTimerEvent(TimerHandle)
  local FuncName = "OnClientAddTimer_" .. TimerHandle
  print("BP_DungeonObject_C:DoClientAddTimerEvent FuncName", FuncName)
  if not self.ClientDungeonObject[FuncName] then
    print("Warning:: BP_DungeonObject_C:DoClientAddTimerEvent FuncName", FuncName, "未实现")
    return
  end
  try({
    exec = function()
      self.ClientDungeonObject[FuncName](self.ClientDungeonObject)
    end,
    catch = function(err)
      DebugPrint(ErrorTag, "DoClientAddTimerEvent Error! TimerHandle: " .. TimerHandle .. " traceback: ")
      Traceback(ErrorTag, err, false)
    end
  })
end

function BP_DungeonObject_C:DoClientRemoveTimerEvent(TimerHandle)
  local FuncName = "OnClientRemoveTimer_" .. TimerHandle
  print("BP_DungeonObject_C:DoClientRemoveTimerEvent FuncName", FuncName)
  if not self.ClientDungeonObject[FuncName] then
    print("Warning:: BP_DungeonObject_C:DoClientRemoveTimerEvent FuncName", FuncName, "未实现")
    return
  end
  try({
    exec = function()
      self.ClientDungeonObject[FuncName](self.ClientDungeonObject)
    end,
    catch = function(err)
      DebugPrint(ErrorTag, "DoClientAddTimerEvent Error! TimerHandle: " .. TimerHandle .. " traceback: ")
      Traceback(ErrorTag, err, false)
    end
  })
end

function BP_DungeonObject_C:NotifyGameModeDungeonEvent(...)
  local ParamTbl = table.pack(...)
  local MessageStr = msgpack.pack(ParamTbl)
  local Message = FMessage()
  Message:SetBytes(MessageStr, #MessageStr)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player and Player.RPCComponent then
    Player.RPCComponent:SendGameModeDungeonEvent(Message)
  end
end

function BP_DungeonObject_C:MulticastGameModeDungeonEvent(...)
  local ParamTbl = table.pack(...)
  local MessageStr = msgpack.pack(ParamTbl)
  local Message = FMessage()
  Message:SetBytes(MessageStr, #MessageStr)
  self:MulticastSendClientDungeonEvent(Message)
end

function BP_DungeonObject_C:UnicastGameModeDungeonEvent(AvatarEidStr, ...)
  local ParamTbl = table.pack(...)
  local MessageStr = msgpack.pack(ParamTbl)
  local Message = FMessage()
  Message:SetBytes(MessageStr, #MessageStr)
  local PlayerController = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerByAvatarEid(self, AvatarEidStr)
  if not PlayerController then
    return
  end
  local Player = PlayerController:GetMyPawn()
  if Player and Player.RPCComponent then
    Player.RPCComponent:SendClientDungeonEvent(Message)
  end
end

function BP_DungeonObject_C:SendClientDungeonEvent_Client(Message)
  local MessageStr = Message:GetBytes()
  local ParamTbl = msgpack.unpack(MessageStr)
  self.ClientDungeonObject:OnNotifyClientDungeonEvent(table.unpack(ParamTbl, 1, ParamTbl.n))
end

return BP_DungeonObject_C
