require("UnLua")
local Const = require("Const")
local BP_NPCFollowComponent_C = Class({
  "BluePrints.Common.TimerMgr"
})

function BP_NPCFollowComponent_C:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  self:InitConfig()
  self.FollowNpc = nil
  self.bNpcSpawning = false
  self.SavedGravityScale = nil
  self.SpawnRetryHandle = nil
  self:SetComponentTickEnabled(false)
  if self.CachedAutoSpawn then
    self:TrySpawnNpc()
  end
end

function BP_NPCFollowComponent_C:ReceiveEndPlay(EndPlayReason)
  self:DestroyNpc()
  if self.SpawnRetryHandle then
    self:RemoveTimer(self.SpawnRetryHandle)
    self.SpawnRetryHandle = nil
  end
  self.Overridden.ReceiveEndPlay(self, EndPlayReason)
end

function BP_NPCFollowComponent_C:ReceiveTick(DeltaSeconds)
  self:SyncNpcTransform()
end

function BP_NPCFollowComponent_C:InitConfig()
  local NpcIdStr = self.NpcId
  if nil == NpcIdStr or "" == NpcIdStr then
    self.CachedNpcId = nil
  else
    self.CachedNpcId = tonumber(NpcIdStr)
  end
  self.CachedAutoSpawn = self.bAutoSpawn == true
  self.CachedDisableNpcMovement = self.bDisableNpcMovement ~= false
  self.CachedSpawnDelay = self.SpawnDelay or 0
  self.CachedShowDebug = true == self.bShowDebug
  local MontagePrePath = self.MontagePrePath
  self.CachedMontagePrePath = MontagePrePath and "" ~= MontagePrePath and MontagePrePath or nil
  local MontageName = self.MontageName
  self.CachedMontageName = MontageName and "" ~= MontageName and MontageName or nil
  local Offset = self.LocationOffset
  if Offset then
    self.CachedLocationOffset = FVector(Offset.X, Offset.Y, Offset.Z)
  else
    self.CachedLocationOffset = FVector(0, 0, 0)
  end
end

function BP_NPCFollowComponent_C:TrySpawnNpc()
  local NpcId = self.CachedNpcId
  if nil == NpcId or NpcId <= 0 then
    return
  end
  if IsValid(self.FollowNpc) or self.bNpcSpawning then
    return
  end
  if not DataMgr.Npc[NpcId] then
    DebugPrint("BP_NPCFollowComponent: invalid NpcId", self.NpcId, NpcId)
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not IsValid(GameState) or GameState.GameModeState < Const.StateRunning then
    if not self.SpawnRetryHandle then
      self.SpawnRetryHandle = self:AddTimer(0.5, function()
        self.SpawnRetryHandle = nil
        self:TrySpawnNpc()
      end, false, 0, "NPCFollowSpawnRetry")
    end
    return
  end
  if self.CachedSpawnDelay > 0 then
    self:AddTimer(self.CachedSpawnDelay, function()
      self:SpawnNpcInternal()
    end, false, 0, "NPCFollowSpawnDelay")
  else
    self:SpawnNpcInternal()
  end
end

function BP_NPCFollowComponent_C:DestroyNpc()
  if IsValid(self.FollowNpc) then
    self.FollowNpc:EMActorDestroy(EDestroyReason.MechanismLifeTime)
  end
  self.FollowNpc = nil
  self.bNpcSpawning = false
  self.SavedGravityScale = nil
  self:SetComponentTickEnabled(false)
end

function BP_NPCFollowComponent_C:RefreshNpcTransform()
  self:SyncNpcTransform()
end

function BP_NPCFollowComponent_C:SpawnNpcInternal()
  local NpcId = self.CachedNpcId
  if nil == NpcId or NpcId <= 0 then
    return
  end
  if IsValid(self.FollowNpc) or self.bNpcSpawning then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not IsValid(GameState) or not IsValid(GameState.EventMgr) then
    return
  end
  local Loc, Rot = self:GetTargetTransform()
  local Owner = self:GetOwner()
  
  local function OnNpcReady(_, Npc)
    self.bNpcSpawning = false
    if not IsValid(self) then
      if IsValid(Npc) then
        Npc:EMActorDestroy(EDestroyReason.MechanismLifeTime)
      end
      return
    end
    if not IsValid(Npc) then
      return
    end
    self:SetupFollowNpc(Npc)
  end
  
  local Context = AEventMgr.CreateUnitContext()
  Context.UnitType = "Npc"
  Context.UnitId = NpcId
  Context.Loc = Loc
  Context.Rotation = Rot
  Context.Creator = Owner
  Context.IntParams:Add("Level", GameState.GameModeLevel or 1)
  Context.OnUnitInitCreateReadyDynamic:Add(self, OnNpcReady)
  self.bNpcSpawning = true
  GameState.EventMgr:CreateUnitNew(Context, false)
end

function BP_NPCFollowComponent_C:SetupFollowNpc(Npc)
  self.FollowNpc = Npc
  self:SyncNpcTransform()
  if self.CachedDisableNpcMovement then
    self:DisableNpcMovement(Npc)
  end
  if self.CachedMontageName and Npc.PlayActionMontage then
    local PrePath = self.CachedMontagePrePath or "Interactive/MechInteractive"
    Npc:PlayActionMontage(PrePath, self.CachedMontageName, {}, false, true, false)
  elseif Npc.PlayDefaultAnimation then
    Npc:PlayDefaultAnimation(self)
  end
  self:SetComponentTickEnabled(true)
end

function BP_NPCFollowComponent_C:DisableNpcMovement(Npc)
  if Npc.SetNpcMovementTickEnable then
    Npc:SetNpcMovementTickEnable(false)
  end
  local MoveComp = Npc:GetMovementComponent()
  if IsValid(MoveComp) then
    MoveComp:StopMovementImmediately()
    self.SavedGravityScale = MoveComp.GravityScale
    MoveComp.GravityScale = 0
    if MoveComp.OnNpcSeatingBegin then
      MoveComp:OnNpcSeatingBegin()
    end
  end
  if Npc.NpcAnimInstance then
    Npc.NpcAnimInstance.EnableDataFootIK = false
  end
end

function BP_NPCFollowComponent_C:GetTargetTransform()
  local CompTransform = self:K2_GetComponentToWorld()
  local Loc = UKismetMathLibrary.TransformLocation(CompTransform, self.CachedLocationOffset)
  local Rot = CompTransform.Rotation:ToRotator()
  return Loc, Rot
end

function BP_NPCFollowComponent_C:SyncNpcTransform()
  local Npc = self.FollowNpc
  if not IsValid(Npc) then
    return
  end
  local Loc, Rot = self:GetTargetTransform()
  Npc:K2_SetActorLocationAndRotation(Loc, Rot, false, nil, true)
  if self.CachedShowDebug then
    UE4.UKismetSystemLibrary.DrawDebugSphere(self, Loc, 20, 12, FLinearColor(0, 1, 0, 1), 0, 1)
  end
end

return BP_NPCFollowComponent_C
