require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr"
})

function M:InitGuildStructUI()
  self.GameUI = nil
  self.ComponentEdit = nil
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildManager = GameMode:GetGuildConstructManager()
  self.GameUI = UIManager(self):LoadUINew("GuildConstructionMain")
  self:LoadScene()
end

function M:LoadScene()
end

function M:CancelSelect()
  if self.GuildManager and self.GuildManager.CancelExecuteOperation then
    self.GuildManager:CancelExecuteOperation()
  end
end

function M:OnCancelSelect()
  self.GameUI:OnCancelSelect()
end

function M:ActorStateToLayoutInstance(InActorState)
  local LayoutInstance = {}
  if not InActorState then
    return nil
  end
  if -1 == InActorState.UnitId or not DataMgr.GuildItem[InActorState.UnitId] then
    return nil
  end
  local Name = DataMgr.GuildItem[InActorState.UnitId].Name
  LayoutInstance.InstanceId = tostring(Name) .. "_" .. tostring(UE4.UKismetGuidLibrary.Conv_GuidToString(InActorState.Id))
  LayoutInstance.ComponentId = InActorState.UnitId
  LayoutInstance.Position = {}
  LayoutInstance.Position.X = InActorState.LocalLocation.X
  LayoutInstance.Position.Y = InActorState.LocalLocation.Y
  LayoutInstance.Position.Z = InActorState.LocalLocation.Z
  LayoutInstance.Rotation = {}
  LayoutInstance.Rotation.X = InActorState.LocalRotation.Roll
  LayoutInstance.Rotation.Y = InActorState.LocalRotation.Pitch
  LayoutInstance.Rotation.Z = InActorState.LocalRotation.Yaw
  LayoutInstance.Scale = {}
  LayoutInstance.Scale.X = InActorState.LocalScale.X
  LayoutInstance.Scale.Y = InActorState.LocalScale.Y
  LayoutInstance.Scale.Z = InActorState.LocalScale.Z
  LayoutInstance.Height = InActorState.LocalHeight
  local ParentState, bOk = self.GuildManager:GetActorState(InActorState.ParentId)
  local RawParentId, ParentName
  if bOk then
    RawParentId = UE4.UKismetGuidLibrary.Conv_GuidToString(ParentState.Id) or nil
    if DataMgr.GuildItem[ParentState.UnitId] then
      ParentName = DataMgr.GuildItem[ParentState.UnitId].Name
    end
  end
  LayoutInstance.ParentId = tostring(ParentName) .. "_" .. tostring(RawParentId)
  local Str = self:TableToString(LayoutInstance)
  Str = "LayoutInstance = " .. Str
  DebugPrint(Str)
  return LayoutInstance
end

function M:GenerateLayoutInstanceList()
  local ActorStates = UE4.UGuildConstructFunctionLibrary.GetActorStates(self.GuildManager)
  local LayoutInstance
  local LayoutInstanceList = {}
  for _, ActorState in pairs(ActorStates) do
    LayoutInstance = self:ActorStateToLayoutInstance(ActorState)
    table.insert(LayoutInstanceList, LayoutInstance)
  end
  return LayoutInstanceList
end

function M:TableToString(Object)
  local Result = ""
  if not Object or type(Object) ~= "table" and type(Object) ~= "userdata" then
    return tostring(Object)
  end
  Result = "{ "
  for Key, Value in pairs(Object) do
    local KeyString = self:TableToString(Key)
    local ValueString = self:TableToString(Value)
    local KeyValue = KeyString .. " = " .. ValueString .. ", \n"
    Result = Result .. KeyValue
  end
  Result = Result .. " }"
  return Result
end

return M
