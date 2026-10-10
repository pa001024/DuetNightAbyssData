require("UnLua")
local BP_MirrorAreaBox_C = Class("BluePrints.Item.BP_CombatItemBase_C")
local MirrorWorldState = CommonConst.MirrorWorldState
local FailReason = CommonConst.MirrorSwitchFailReason
local LEAVE_CHECK_INTERVAL = 0.5

function BP_MirrorAreaBox_C:CommonInitInfo(Info)
  BP_MirrorAreaBox_C.Super.CommonInitInfo(self, Info)
  local MechData = DataMgr.Mechanism[self.UnitId]
  rawset(self, "RealStateId", MechData.FirstStateId)
  for _, StateId in pairs(MechData.StateIdList) do
    if StateId ~= self.RealStateId then
      rawset(self, "MirrorStateId", StateId)
    end
  end
  rawset(self, "LastSwitchTime", -100)
  if not self.MirrorStateId then
    GWorld.logger.error("[MirrorWorld] AreaBox UnitId " .. tostring(self.UnitId) .. " StateIdList 配置错误，需要现实/镜面两个状态")
  end
end

function BP_MirrorAreaBox_C:OnActorReady(Info)
  BP_MirrorAreaBox_C.Super.OnActorReady(self, Info)
  if self.AreaBox then
    self.AreaBox.OnComponentEndOverlap:Add(self, self.OnAreaEndOverlap)
  else
    GWorld.logger.error("[MirrorWorld] " .. self:GetName() .. " 蓝图缺少名为 AreaBox 的 BoxComponent")
  end
end

function BP_MirrorAreaBox_C:IsPointInArea_Lua(Location)
  if not self.AreaBox then
    return false
  end
  return UE4.UKismetMathLibrary.IsPointInBoxWithTransform(Location, self.AreaBox:K2_GetComponentToWorld(), self.AreaBox:GetUnscaledBoxExtent())
end

function BP_MirrorAreaBox_C:IsPlayerInArea_Lua(PlayerActor)
  return IsValid(PlayerActor) and self:IsPointInArea_Lua(PlayerActor:K2_GetActorLocation())
end

function BP_MirrorAreaBox_C:GetAreaBounds()
  local Origin, BoxExtent = UE4.UKismetSystemLibrary.GetComponentBounds(self.AreaBox)
  return Origin, BoxExtent
end

local function IsBoundsLinked(OriginA, ExtentA, OriginB, ExtentB, Tolerance)
  return math.abs(OriginA.X - OriginB.X) <= ExtentA.X + ExtentB.X + Tolerance and math.abs(OriginA.Y - OriginB.Y) <= ExtentA.Y + ExtentB.Y + Tolerance and math.abs(OriginA.Z - OriginB.Z) <= ExtentA.Z + ExtentB.Z + Tolerance
end

function BP_MirrorAreaBox_C:CollectLinkedAreaBoxes()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local AllBoxes = {}
  if GameMode then
    for _, Actor in pairs(GameMode.BPBornRegionActor) do
      if IsValid(Actor) and Actor:IsA(UE4.AMirrorAreaBox) and Actor.AreaBox then
        local Origin, Extent = Actor:GetAreaBounds()
        table.insert(AllBoxes, {
          Box = Actor,
          Origin = Origin,
          Extent = Extent
        })
      end
    end
  end
  local Group, Visited, Pending = {}, {}, {self}
  Visited[self] = true
  while #Pending > 0 do
    local Current = table.remove(Pending)
    table.insert(Group, Current)
    local CurOrigin, CurExtent = Current:GetAreaBounds()
    for _, Entry in ipairs(AllBoxes) do
      if not Visited[Entry.Box] and IsBoundsLinked(CurOrigin, CurExtent, Entry.Origin, Entry.Extent, Current.AreaLinkTolerance) then
        Visited[Entry.Box] = true
        table.insert(Pending, Entry.Box)
      end
    end
  end
  rawset(self, "LinkedGroup", Group)
  return Group
end

function BP_MirrorAreaBox_C:IsPlayerInLinkedGroup(PlayerActor)
  local Group = self.LinkedGroup or self:CollectLinkedAreaBoxes()
  for _, AreaBox in ipairs(Group) do
    if IsValid(AreaBox) and AreaBox:IsPlayerInArea(PlayerActor) then
      return true
    end
  end
  return false
end

function BP_MirrorAreaBox_C:RequestSwitchWorld_Lua(PlayerId)
  if not self.MirrorStateId then
    return FailReason.AreaInvalid
  end
  local Now = UE4.UGameplayStatics.GetTimeSeconds(self)
  if Now - (self.LastSwitchTime or -100) < self.SwitchCooldown then
    return FailReason.Switching
  end
  local bToMirror = self.StateId == self.RealStateId
  for _, AreaBox in ipairs(self:CollectLinkedAreaBoxes()) do
    if IsValid(AreaBox) then
      AreaBox:ApplyWorldSwitch(bToMirror, PlayerId or 0, Now)
    end
  end
  return FailReason.Success
end

function BP_MirrorAreaBox_C:ApplyWorldSwitch(bToMirror, PlayerId, NowTime)
  rawset(self, "LastSwitchTime", NowTime)
  local TargetStateId = bToMirror and self.MirrorStateId or self.RealStateId
  if TargetStateId and self.StateId ~= TargetStateId then
    self:ChangeState("Manual", PlayerId, TargetStateId)
  end
end

function BP_MirrorAreaBox_C:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  local NewState = NowStateId == self.MirrorStateId and MirrorWorldState.MirrorWorld or MirrorWorldState.RealWorld
  local OldState = self.MirrorWorldState
  if NewState == OldState then
    return
  end
  self.MirrorWorldState = NewState
  self.OnMirrorWorldStateChange:Broadcast(NewState, OldState)
  for Comp in pairs(self:GetMirrorComponents()) do
    if IsValid(Comp) then
      Comp:HandleMirrorWorldStateChange(NewState, OldState)
    end
  end
  local bMirror = NewState == MirrorWorldState.MirrorWorld
  self:ApplyMirrorPostProcess(bMirror)
  if bMirror then
    self:StartLeaveMonitor()
  else
    self:StopLeaveMonitor()
  end
end

function BP_MirrorAreaBox_C:GetMirrorComponents()
  local Comps = rawget(self, "MirrorComponents")
  if not Comps then
    Comps = {}
    rawset(self, "MirrorComponents", Comps)
  end
  return Comps
end

function BP_MirrorAreaBox_C:RegisterMirrorComponent(Comp)
  self:GetMirrorComponents()[Comp] = true
end

function BP_MirrorAreaBox_C:UnregisterMirrorComponent(Comp)
  self:GetMirrorComponents()[Comp] = nil
end

function BP_MirrorAreaBox_C:StartLeaveMonitor()
  EventManager:AddEvent(EventID.CharDie, self, self.OnCharDie)
  self:AddTimer(LEAVE_CHECK_INTERVAL, self.CheckPlayerStillInArea, true, 0, "MirrorLeaveCheck")
end

function BP_MirrorAreaBox_C:StopLeaveMonitor()
  EventManager:RemoveEvent(EventID.CharDie, self)
  self:RemoveTimer("MirrorLeaveCheck")
end

function BP_MirrorAreaBox_C:GetLocalPlayer()
  return UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
end

function BP_MirrorAreaBox_C:OnAreaEndOverlap(OverlappedComp, OtherActor, OtherComp, OtherBodyIndex)
  if self.MirrorWorldState ~= MirrorWorldState.MirrorWorld then
    return
  end
  local Player = self:GetLocalPlayer()
  if IsValid(Player) and OtherActor == Player and not self:IsPlayerInLinkedGroup(Player) then
    self:ForceBackToRealWorld()
  end
end

function BP_MirrorAreaBox_C:OnCharDie(Eid)
  local Player = self:GetLocalPlayer()
  if IsValid(Player) and Player.Eid == Eid then
    self:ForceBackToRealWorld()
  end
end

function BP_MirrorAreaBox_C:CheckPlayerStillInArea()
  local Player = self:GetLocalPlayer()
  if not IsValid(Player) or not self:IsPlayerInLinkedGroup(Player) then
    self:ForceBackToRealWorld()
  end
end

function BP_MirrorAreaBox_C:ForceBackToRealWorld()
  if self.MirrorWorldState ~= MirrorWorldState.MirrorWorld then
    return
  end
  local Now = UE4.UGameplayStatics.GetTimeSeconds(self)
  for _, AreaBox in ipairs(self.LinkedGroup or self:CollectLinkedAreaBoxes()) do
    if IsValid(AreaBox) then
      AreaBox:ApplyWorldSwitch(false, 0, Now)
    end
  end
end

function BP_MirrorAreaBox_C:ApplyMirrorPostProcess(bEnable)
  local Player = self:GetLocalPlayer()
  local Material = self.MirrorPostProcessMaterial
  if not IsValid(Player) or not Material then
    return
  end
  if bEnable then
    Player:AddBlendableMaterialInst(Material, self.MirrorPostProcessBlendWeight)
  else
    Player:RemoveBlendableMaterial(Material:GetBaseMaterial())
  end
end

function BP_MirrorAreaBox_C:UpdateRegionStateId(NewStateId, bFirstState)
end

function BP_MirrorAreaBox_C:ServerUpdateRegionStateId(NewStateId, CallBack)
  CallBack(0)
end

return BP_MirrorAreaBox_C
