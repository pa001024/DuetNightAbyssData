require("Unlua")
local BP_GuardMech_C = Class({
  "BluePrints/Item/DefenceCore/BP_DefenceBase_C"
})

function BP_GuardMech_C:AuthorityInitInfo(Info)
  BP_GuardMech_C.Super.AuthorityInitInfo(self, Info)
  self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuideOrderIndex = self.GameMode:TriggerDungeonComponentFun("RegisterGuideOrder", self.CreatorId)
  self.bGuardSuccess = false
  self.InteractiveType = Const.PressInteractive
end

function BP_GuardMech_C:CommonInitInfo(Info)
  BP_GuardMech_C.Super.CommonInitInfo(self, Info)
  self.MaxTime = self.UnitParams.MaxTime
  self.ReduceTime = self.UnitParams.ReduceTime
  self.CurHP = self:GetAttr("Hp")
  self.MaxHP = self:GetAttr("MaxHp")
  self.RepairSpeed = DataMgr.ExtractionTreasureGuard[self.UnitId].RepairSpeed
  self.RecoverHp = self.RepairSpeed * self.MaxHP
  self.bCanShowBloodBar = false
  self.IsInInteractive = false
  self.bKillSelf = false
end

function BP_GuardMech_C:ClientInitInfo(Info)
  BP_GuardMech_C.Super.ClientInitInfo(self, Info)
  if self.Data.BloodUIParmas then
  end
end

function BP_GuardMech_C:ReceiveTick(DeltaSeconds)
  self.Overridden.ReceiveTick(self, DeltaSeconds)
  self:ShowOrHideBloodBar(self.bCanShowBloodBar)
  local Hp = self:GetAttr("Hp")
  local MaxHp = self:GetAttr("MaxHp")
end

function BP_GuardMech_C:ShowOrHideBloodBar(bShow)
  if bShow then
    self:ShowOrHideBillboard(true)
  else
    self:ShowOrHideBillboard(false)
  end
end

function BP_GuardMech_C:OnActiveStateChange()
  BP_GuardMech_C.Super.OnActiveStateChange(self)
  if self.IsActive then
    EventManager:AddEvent(EventID.OnPlayerOutGuardBounds, self, self.OnPlayerOutGuardBounds)
  end
end

function BP_GuardMech_C:OnActorReady(Info)
  BP_GuardMech_C.Super.OnActorReady(self, Info)
end

function BP_GuardMech_C:RecoverSavedData(DataTable)
  BP_GuardMech_C.Super.RecoverSavedData(self, DataTable)
end

function BP_GuardMech_C:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  if 1310674 == NowStateId then
    if self.IsInInteractive then
      self:CloseMechanism(self.NowPlayerEid)
    end
    self.bGuardSuccess = true
    self.bCanShowBloodBar = false
    self.InteractiveType = Const.ClickInteractive
    if self.ChestInteractiveComponent then
      self.ChestInteractiveComponent:InitInteractiveComponent(118020)
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.DefBaseMap:Remove(self.Eid)
    GameState.HatredCombatProp:Remove(self.Eid)
    EventManager:RemoveEvent(EventID.OnPlayerOutGuardBounds, self)
  elseif 1310672 == NowStateId then
    self.bCanShowBloodBar = true
  elseif 1310675 == NowStateId then
    self:RemoveGuideABC()
    if not self.ServerUniqueId then
      return
    end
    if not self.GameMode then
      self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
    end
    if not self.GameMode then
      return
    end
    self.GameMode:NotifyServerDungeonEvent("OpenSoloTreasureMechanism", self.ServerUniqueId)
    UIManager(self):LoadUINew("SoloTreasureBag", self.ServerUniqueId, function()
      DebugPrint("lgc@ SoloTreasureBag AsyncLoaded self.ServerUniqueId =", self.ServerUniqueId)
    end, "Async")
  elseif 1310676 == NowStateId then
    self:RemoveGuideABC()
    EventManager:RemoveEvent(EventID.OnPlayerOutGuardBounds, self)
  elseif 1310677 == NowStateId then
    local PlayerActor
    if self.NowPlayerEid then
      PlayerActor = Battle(self):GetEntity(self.NowPlayerEid)
    else
      PlayerActor = UGameplayStatics.GetPlayerCharacter(self, 0)
    end
    if self.ChestInteractiveComponent then
      self.ChestInteractiveComponent:EndPressInteractive(PlayerActor)
    end
    self.InteractiveType = Const.ClickInteractive
  end
end

function BP_GuardMech_C:OnDamaged(DamageEvent)
  if not IsAuthority(self) then
    return
  end
  BP_GuardMech_C.Super.OnDamaged(self, DamageEvent)
  self.GameMode:TriggerDungeonComponentFun("OnShowToast", Const.DefenceGameToastType.Damaged)
  local MaxHP = self:GetAttr("MaxHp")
  local CurHP = self:GetAttr("Hp")
  self.CurHP = CurHP
  if not self:IsExistTimer("TimerNotifyDamaged") then
    local CurHPPercent = self.CurHP / self.MaxHP
    EventManager:FireEvent(EventID.OnContainerBeAttacked, self.CreatorId, CurHPPercent)
    self:AddTimer(0.5, function()
      DebugPrint("yly     TimerNotifyDamaged")
    end, false, 0, "TimerNotifyDamaged")
  end
end

function BP_GuardMech_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
  BP_GuardMech_C.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
  if self.GameMode then
    self.GameMode:TriggerMechanism(self.CreatorId, 1310676)
  end
  
  local function DelayDestroy()
    self:EMActorDestroy(EDestroyReason.MechanismDead)
  end
  
  self:AddTimer(0.1, DelayDestroy)
  EventManager:FireEvent(EventID.OnContainerDestroyed, self.CreatorId)
end

function BP_GuardMech_C:OnPlayerOutGuardBounds()
  if not self.IsActive then
    DebugPrint("yly BP_GuardMech_C not Activated, can't Destroy.")
    return
  end
  if self.StateId ~= 1310672 then
    DebugPrint("yly BP_GuardMech_C StateId=", self.StateId, "can't Destroy.")
    return
  end
  if self.GameMode then
    self.GameMode:TriggerMechanism(self.CreatorId, 1310676)
  end
  self.bKillSelf = true
  
  local function DelayDestroy()
    self:EMActorDestroy(EDestroyReason.MechanismDead)
  end
  
  self:AddTimer(0.1, DelayDestroy)
  EventManager:FireEvent(EventID.OnContainerDestroyed, self.CreatorId)
end

function BP_GuardMech_C:OnEMActorDestroy(...)
  BP_GuardMech_C.Super.OnEMActorDestroy(self, ...)
end

function BP_GuardMech_C:ActiveOnServer()
  BP_GuardMech_C.Super.ActiveOnServer(self)
end

function BP_GuardMech_C:DeActive()
  BP_GuardMech_C.Super.DeActive(self)
end

function BP_GuardMech_C:GetNeedLongPressTime()
  return self.MaxTime or 0
end

function BP_GuardMech_C:GetLongPressedPercent()
  return self.CurPercent or 0
end

function BP_GuardMech_C:GetReduceTime()
  return self.ReduceTime or 0
end

function BP_GuardMech_C:GetLongPressingText()
  return GText("UI_Extraction_TM_38")
end

function BP_GuardMech_C:OpenMechanism(Eid)
  DebugPrint("yly      BP_GuardMech_C:OpenMechanism")
  local Player = Battle(self):GetEntity(Eid)
  if Player then
    self.ChestInteractiveComponent:OnStartInteractive(Player, self.ChestInteractiveComponent.MontageName, self.Eid)
    self.IsInInteractive = true
    self.NowPlayerEid = Eid
  end
  if not self:IsExistTimer("TimerAddHp") then
    self:AddTimer(1.0, self.TimerAddHp, true, 0, "TimerAddHp")
  end
end

function BP_GuardMech_C:CloseMechanism(Eid, IsSuccess)
  DebugPrint("yly      BP_GuardMech_C:CloseMechanism")
  local Player = Battle(self):GetEntity(Eid)
  if Player then
    Player.OnInteractiveDelegate:Add(self, self.ChangeToNormalState)
    self.ChestInteractiveComponent:OnEndInteractive(Player, self.ChestInteractiveComponent.MontageName, self.Eid)
    self.IsInInteractive = false
  end
  self:RemoveTimer("TimerAddHp")
end

function BP_GuardMech_C:TimerAddHp()
  if self.IsInInteractive then
    self:AddHp(self.RecoverHp)
    self.CurHP = self:GetAttr("Hp")
    local CurHPPercent = self.CurHP / self.MaxHP
    EventManager:FireEvent(EventID.OnContainerBeRepaired, self.CreatorId, CurHPPercent)
  end
end

function BP_GuardMech_C:ChangeToNormalState(Player)
  Player.OnInteractiveDelegate:Remove(self, self.ChangeToNormalState)
  self:ChangeState("InteractBreak", Player.Eid)
end

function BP_GuardMech_C:GetCanOpen(PlayerId)
  if not self.bGuardSuccess and self.CurHP >= self.MaxHP then
    self.CanOpen = false
    return
  end
  if self.CurHP <= 0 then
    self.CanOpen = false
    return
  end
  self.CanOpen = true
end

function BP_GuardMech_C:RemoveGuideABC()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState then
    GameState:RemoveGuideEid(self.Eid)
  end
end

return BP_GuardMech_C
