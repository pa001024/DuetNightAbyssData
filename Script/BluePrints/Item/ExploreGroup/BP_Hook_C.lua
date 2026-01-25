require("UnLua")
local M = Class({
  "BluePrints.Item.BP_CombatItemBase_C"
})

function M:OnActorReady(Info)
  print(_G.LogTag, "LXZ OnActorReady", self:GetName())
  M.Super.OnActorReady(self, Info)
  self.Box.OnComponentBeginOverlap:Add(self, self.BoxBeginOverlap)
  self.Box.OnComponentEndOverlap:Add(self, self.BoxEndOverlap)
  self:SetActorEnableCollision(true)
  self.TargetLoc = self.FXLoc:K2_GetComponentLocation()
  self.FxLocComp = self.FXLoc
  if Info.Creator and 0 ~= Info.Creator.TriggerSphereRadius then
    self.MaxDis = Info.Creator.TriggerSphereRadius
  end
  if 0 ~= self.HookInteractiveComponent.InteractiveDistance then
    self.MinDis = self.HookInteractiveComponent.InteractiveDistance
  end
  self.HookInteractiveComponent:InitCommonUIConfirmID(self.Data.InteractiveId)
  self.DeviceInPc = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
end

function M:OpenMechanism(PlayerId)
  if self:CheckPlayerEid(PlayerId) then
    return
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local PlayerCharacter = Battle(self):GetEntity(PlayerId)
  if GameInstance.ShouldPlayDeliveryEndMontage or GameInstance.ShouldStopHookInDungeonDelivery then
    return
  end
  local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  if not PlayerCharacter:SetCharacterTag("Hook") then
    if MainPlayer == PlayerCharacter then
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      UIManager:ShowUITip(UIConst.Tip_CommonTop, GText("UI_Mechanism_CannotHook"))
    end
    return
  end
  PlayerCharacter.IsInHook = true
  PlayerCharacter:SetMechanismEid(self.Eid)
  self.Overridden.OpenMechanism(self, PlayerId)
  self.HookInteractiveComponent:OnStartInteractive(PlayerCharacter, self.HookInteractiveComponent.MontageName, self.Eid)
  print(_G.LogTag, "LXZ SetPlayer OpenMechanism", PlayerCharacter)
  self:SetPlayer(PlayerCharacter, true)
  self:SetPlayerEid(PlayerId, true)
  local GameState = UGameplayStatics.GetGameState(self)
  if GameState.ValidHook then
    GameState.ValidHook.HookInteractiveComponent:ForceEndInteractive(PlayerCharacter)
  end
  GameState.ValidHook = self
  if MainPlayer.Eid == PlayerId and (IsStandAlone(self) or IsClient(self)) then
    PlayerCharacter:ForbidSkillsInHooking(true)
    PlayerCharacter:DisableBattleWheel()
    PlayerCharacter:AddForbidTag("Battle")
    PlayerCharacter.MoveInput = FVector(0, 0, 0)
    PlayerCharacter.MoveInputCache = FVector(0, 0, 0)
    PlayerCharacter:AddMoveBlock(ESourceTags.Interactive)
  end
  local Rot = UKismetMathLibrary.FindLookAtRotation(PlayerCharacter:K2_GetActorLocation(), self:K2_GetActorLocation())
  Rot.Pitch = 0
  Rot.Roll = 0
  PlayerCharacter:SetCollisionType("CapsuleComponent", "MonsterPawn", ECollisionResponse.ECR_OverLap, false)
  PlayerCharacter:SetCollisionType("CapsuleComponent", "WorldStatic", ECollisionResponse.ECR_OverLap, false)
  PlayerCharacter:K2_SetActorRotation(Rot, false, nil, false)
end

function M:CloseMechanism(PlayerId, IsSuccess)
  print(_G.LogTag, "LXZ Hook CloseMechanism")
  self.Overridden.CloseMechanism(self, PlayerId, IsSuccess)
  local PlayerCharacter = Battle(self):GetEntity(PlayerId)
  if PlayerCharacter then
    PlayerCharacter.IsInHook = false
    PlayerCharacter:SetMechanismEid(0)
    self.HookInteractiveComponent:OnEndInteractive(PlayerCharacter, self.HookInteractiveComponent.MontageName, self.Eid)
  end
  local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self:SetPlayer(PlayerCharacter, false)
  self:SetPlayerEid(PlayerId, false)
  local GameState = UGameplayStatics.GetGameState(self)
  if GameState then
    GameState.LastValidHook = self
    GameState.ValidHook = nil
  end
  if MainPlayer and MainPlayer.Eid == PlayerId and (IsStandAlone(self) or IsClient(self)) then
    PlayerCharacter:ForbidSkillsInHooking(false)
    PlayerCharacter:EnableBattleWheel()
    PlayerCharacter:MinusForbidTag("Battle")
    PlayerCharacter:RemoveMoveBlock(ESourceTags.Interactive)
  end
  if PlayerCharacter then
    PlayerCharacter:SetCollisionType("CapsuleComponent", "MonsterPawn", ECollisionResponse.ECR_Block, false)
    PlayerCharacter:SetCollisionType("CapsuleComponent", "WorldStatic", ECollisionResponse.ECR_Block, false)
  end
end

function M:ForceCloseMechanism(PlayerId, IsSuccess)
  self.Overridden.ForceCloseMechanism(self, PlayerId, IsSuccess)
  local PlayerCharacter = Battle(self):GetEntity(PlayerId)
  local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self:SetPlayer(PlayerCharacter, false)
  self:SetPlayerEid(PlayerId, false)
  local GameState = UGameplayStatics.GetGameState(self)
  GameState.LastValidHook = self
  GameState.ValidHook = nil
  if PlayerCharacter then
    if MainPlayer and MainPlayer.Eid == PlayerId and (IsStandAlone(self) or IsClient(self)) then
      PlayerCharacter:ForbidSkillsInHooking(false)
      PlayerCharacter:EnableBattleWheel()
      PlayerCharacter:MinusForbidTag("Battle")
    end
    print(_G.LogTag, "LXZ HandleUseGouSuo ForceCloseMechanism")
    PlayerCharacter:SetCharacterTag("Falling")
    PlayerCharacter:SetMechanismEid(0)
  end
end

function M:GetCanOpen()
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.IsInRegionOnline then
    return true
  end
  return self.Players:Length() > 0
end

function M:BoxBeginOverlap(Component, OtherActor)
  local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  if OtherActor ~= MainPlayer then
    return
  end
  self:SetPlayer(OtherActor, true)
end

function M:BoxEndOverlap(Component, OtherActor)
  local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  if OtherActor ~= MainPlayer then
    return
  end
  self:SetPlayer(OtherActor, false)
end

function M:ShowUI()
  self.Overridden.ShowUI(self)
end

function M:CloseUI()
  self.Overridden.CloseUI(self)
end

function M:RefreshUI(Player)
end

function M:OnCharacterEnterLanding(Character, Speed)
  if not Character:IsPlayer() or self:CheckPlayer(Character) then
    return
  end
  self.HookInteractiveComponent:EndInteractive(Character)
end

function M:PlayEndMontage(Character, MontageName)
  Character:PlayActionMontage("Interactive/MechInteractive", MontageName .. "_Montage", {}, false)
end

function M:OnRep_PlayerEid()
end

function M:DisplayInteractiveBtn(PlayerActor)
  local GameState = UGameplayStatics.GetGameState(self)
  if not GameState then
    return
  end
  GameState:AddInteractiveHook(self)
  self:SetBtnDisplay(true)
end

function M:RefreshInteractiveBtn(PlayerActor)
  local GameState = UGameplayStatics.GetGameState(self)
  if not GameState then
    return
  end
  local ValidHook = GameState:GetValidHook(PlayerActor, self.TargetLoc)
  if ValidHook ~= self then
    return
  end
  if not IsValid(self.InteractiveUI) then
    if self.DeviceInPc then
      self.InteractiveUI = UIManager(self):GetUIObj("HookInteractive")
      if not IsValid(self.InteractiveUI) then
        self.InteractiveUI = UIManager(self):LoadUINew("HookInteractive")
        self.InteractiveUI:Init(self)
      end
    else
      local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
      if not (BattleMainUI and BattleMainUI.Char_Skill) or BattleMainUI.Char_Skill.Execute.IsShow then
        BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(0)
        return
      end
      BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(1)
      self.InteractiveUI = BattleMainUI.Char_Skill.HookLock
      self.InteractiveUI:Init(self)
    end
  end
  if IsValid(self.InteractiveUI) then
    if not UIManager(self):GetUIObj("HookInteractive") and self.DeviceInPc then
      self.InteractiveUI = UIManager(self):LoadUINew("HookInteractive")
      self.InteractiveUI:Init(self)
    elseif not self.DeviceInPc then
      local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
      if not (BattleMainUI and BattleMainUI.Char_Skill) or BattleMainUI.Char_Skill.Execute.IsShow then
        BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(0)
        return
      end
      BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(1)
      self.InteractiveUI = BattleMainUI.Char_Skill.HookLock
      self.InteractiveUI:Init(self)
    end
  end
  if IsValid(self.InteractiveUI) and self.InteractiveUI.Hook and self.InteractiveUI.Hook ~= ValidHook then
    self.InteractiveUI.Hook:CloseUI()
    ValidHook:ShowUI()
    self.InteractiveUI:UpdateOwner(self, self.HookInteractiveComponent, PlayerActor)
  elseif IsValid(self.InteractiveUI) and self.InteractiveUI.Hook == nil then
    ValidHook:ShowUI()
    self.InteractiveUI:UpdateOwner(self, self.HookInteractiveComponent, PlayerActor)
  end
  self:RefreshUI(PlayerActor)
end

function M:NotDisplayInteractiveBtn(PlayerActor)
  local GameState = UGameplayStatics.GetGameState(self)
  if not GameState then
    return
  end
  self:SetBtnDisplay(false)
  GameState:RemoveInteractiveHook(self)
  if not IsValid(self.InteractiveUI) or self.InteractiveUI.Hook ~= self then
    return
  end
  self.InteractiveUI:Close(self)
  self.InteractiveUI = nil
  self:CloseUI()
end

function M:OnEMActorDestroy(...)
  if self.Players:Length() > 0 then
    for i, v in pairs(self.Players) do
      self.HookInteractiveComponent:EndInteractive(v)
    end
  end
  M.Super.OnEMActorDestroy(self, ...)
end

function M:ReceiveEndPlay(Reason)
  if self.bDisplayBtn then
    self:NotDisplayInteractiveBtn()
  end
  if self.Players:Length() > 0 then
    for i, v in pairs(self.Players) do
      self.HookInteractiveComponent:EndInteractive(v)
    end
  end
  M.Super.ReceiveEndPlay(self, Reason)
end

return M
