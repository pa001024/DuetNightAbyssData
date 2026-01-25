require("UnLua")
local M = Class("BluePrints.Item.BP_CombatItemBase_C")

function M:CommonInitInfo(Info)
  self.SenderId = Info.NameParams:Find("Sender") or ""
  self.ResourceId = Info.IntParams:Find("ResourceId")
  print(_G.LogTag, "LXZ RegionOnlineMechanismBase CommonInitInfo", self.ResourceId)
  if -1 == self.ResourceId then
    self.ResourceId = 41014
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.Eid == CommonUtils.Str2ObjId(self.SenderId) then
    self.CanOpen = false
  else
    self.CanOpen = true
  end
  self.OpenState = false
  M.Super.CommonInitInfo(self, Info)
  self.InteractiveComponents = self:K2_GetComponentsByClass(UChestInteractiveComponent:StaticClass())
  self.InteractiveComponentList = {}
  for i, v in pairs(self.InteractiveComponents) do
    v:InitInteractiveComponent(self.Data.InteractiveId)
    v.InteractiveIdx = i
    self.InteractiveComponentList[i] = v
  end
  self.PlayerAndSeat = {}
end

function M:RegisterToGameState()
  M.Super.RegisterToGameState(self)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if nil == GameState then
    print(_G.LogTag, "Error, GameState is nil")
    return
  end
  GameState:RegisterMechanismRegionOnline(self.SenderId, self)
end

function M:OpenMechanism(Player, InteractiveCompId, OwnerPlayer)
  Player:SetMechanismEid(self.Eid, true)
  self:SetPlayerLoc(Player.Eid, InteractiveCompId, OwnerPlayer)
end

function M:SetPlayerLoc(PlayerActorEid, InteractiveCompId, OwnerPlayer)
  local Player = Battle(self):GetEntity(PlayerActorEid)
  Player:AddForbidTag("Battle")
  local InteractiveComp = self.InteractiveComponentList[InteractiveCompId]
  InteractiveComp.bCanUsed = false
  local RealZ = InteractiveComp:K2_GetComponentLocation().Z + Player.CapsuleComponent.CapsuleHalfHeight + Player:GetFloorInfo().FloorDist
  local Loc = FVector(InteractiveComp:K2_GetComponentLocation().X, InteractiveComp:K2_GetComponentLocation().Y, RealZ)
  local Rot = InteractiveComp:K2_GetComponentRotation()
  self.PlayerAndSeat[PlayerActorEid] = InteractiveComp
  local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
  print(_G.LogTag, "LXZ HandleOnChangeRegionOnlineItemState333", Player:GetName(), self.ResourceId)
  Player:DisableInput(Controller)
  Player:SetCharacterTag("Seating")
  if OwnerPlayer then
    Player:K2_SetActorTransform(OwnerPlayer:GetTransform() - OwnerPlayer.CapsuleComponent:GetScaledCapsuleHalfHeight())
  end
  self.PlayerMeshTrans = Player.Mesh:GetRelativeTransform()
  Player.Mesh:K2_SetWorldTransform(InteractiveComp:K2_GetComponentToWorld(), false, nil, false)
  Player.OnInteractiveDelegate:Add(InteractiveComp, InteractiveComp.EndInteractive)
  Player:GetMovementComponent():SetMovementMode(1)
  Player.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_WorldStatic, ECollisionResponse.ECR_OverLap)
  Player.CharSpringArmComponent.bArmCollision = false
  Player.CharSpringArmComponent.CameraProbeSize = 2
  self:SetSittingParam(Player, InteractiveComp)
  self:PlayAnim(Player.Eid, 0, self.Eid, InteractiveComp)
  print(_G.LogTag, "LXZ HandleOnChangeRegionOnlineItemState444", Player:GetName())
  Player:EnableInput(Controller)
end

function M:SetSittingParam(Player, Point)
  Player:SetCollisionType("CapsuleComponent", "MonsterPawn", ECollisionResponse.ECR_OverLap, false)
  Player:SetCollisionType("CapsuleComponent", "Pawn", ECollisionResponse.ECR_OverLap, false)
end

function M:CloseMechanism(Player)
  if not IsValid(Player) then
    return
  end
  Player:SetMechanismEid(0)
  if not self.PlayerAndSeat[Player.Eid] then
    return
  end
  local InteractiveCompId = self.PlayerAndSeat[Player.Eid].InteractiveIdx
  local InteractiveComp = self.InteractiveComponentList[InteractiveCompId]
  InteractiveComp.bCanUsed = true
  Player.OnInteractiveDelegate:Remove(InteractiveComp, InteractiveComp.EndInteractive)
  Player:GetMovementComponent().bAllowPhysicsRotationDuringAnimRootMotion = true
  Player.CharSpringArmComponent.bArmCollision = true
  Player.CharSpringArmComponent.CameraProbeSize = 12
  Player.Mesh:K2_SetRelativeTransform(self.PlayerMeshTrans, false, nil, false)
  self:SetLeavingParam(Player, InteractiveComp)
  self:PlayAnim(Player.Eid, 2, self.Eid, InteractiveComp)
  self.PlayerAndSeat[Player.Eid] = nil
end

function M:SetLeavingParam(Player, Point)
  Player:SetCollisionType("CapsuleComponent", "MonsterPawn", ECollisionResponse.ECR_Block, false)
  Player:SetCollisionType("CapsuleComponent", "Pawn", ECollisionResponse.ECR_Block, false)
  local UpDiff = self:SeatGetUpDiff(Player.Mesh, Point, Player.OriginHalfHeight, false)
  local RootMotionDis = 30
  local BattleCharTag = ""
  if Player:IsNPC() == false then
    BattleCharTag = DataMgr.BattleChar[Player.CurrentRoleId].BattleCharTag[1]
  end
  if "Girl" == BattleCharTag then
    RootMotionDis = 30
  elseif "Man" == BattleCharTag then
    RootMotionDis = 20
  elseif "Woman" == BattleCharTag then
    RootMotionDis = 30
  else
    RootMotionDis = 20
  end
  Player:GetMovementComponent().RootMotionZScale = UpDiff / RootMotionDis
end

function M:PlayAnim(PlayerId, InteractiveState, MechanismEid, InteractiveComp)
  local Player = Battle(self):GetEntity(PlayerId)
  if 0 == InteractiveState then
    local MontageName = DataMgr.Resource[self.ResourceId].InteractiveAnim or "Gesture_Car_Interactive_Montage"
    InteractiveComp:OnStartInteractive(Battle(self):GetEntity(PlayerId), MontageName, MechanismEid, "Gesture")
  end
  if 1 == InteractiveState then
  end
  if 2 == InteractiveState then
    InteractiveComp:OnEndInteractive(Battle(self):GetEntity(PlayerId), InteractiveComp.MontageName, MechanismEid)
    Player:StopMontage()
  end
end

function M:GetCanOpen()
end

function M:ReceiveEndPlay(EndPlayReason)
  M.Super.ReceiveEndPlay(self, EndPlayReason)
  for PlayerEid, Comp in pairs(self.PlayerAndSeat) do
    local Player = Battle(self):GetEntity(PlayerEid)
    if IsValid(Player) then
      Comp:ForceEndInteractive(Player)
      Player.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_WorldStatic, ECollisionResponse.ECR_Block)
    end
  end
  if self.SenderId then
    local GameState = UGameplayStatics.GetGameState(self)
    GameState.RegionOnlineMechanismMap:Remove(self.SenderId)
  end
end

return M
