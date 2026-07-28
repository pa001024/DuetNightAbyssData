local HitResult = FHitResult()
local BattleEventName = require("BluePrints/Combat/BattleEvents/BattleEventName")
local M = {}
local PlayerActorRefs = {}
local PlayerReflectionRefs = {}

function M:Init(Params)
  self.PlayerMontageTimerKeys = {}
  self.PlayerFXTimerKeys = {}
  self.PlayerActorHideTags = {}
end

local function MakeUncalculatedTrans(self)
  return UE4.UKismetMathLibrary.MakeTransform(self.UncalculatedTrans.Translation, self.UncalculatedTrans.Rotation:ToRotator(), FVector(1, 1, 1))
end

local function CalculatePlayerTrans(self, Params)
  local TargetTrans = MakeUncalculatedTrans(self)
  if self.bPreviewSceneLoaded then
    TargetTrans.Translation.Z = TargetTrans.Translation.Z + self.ArmoryPlayer.CapsuleComponent:GetScaledCapsuleHalfHeight() + 2.4
    self.ArmoryPlayer:K2_SetActorRotation(FRotator(0, 90, 0), false, HitResult, false)
  else
    local OriRealPlayerHalfHeight
    local BattleCharData = DataMgr.BattleChar[Params.PreRoleId]
    if BattleCharData and BattleCharData.CapsuleInfo then
      OriRealPlayerHalfHeight = BattleCharData.CapsuleInfo.OriHalfHeight
    end
    OriRealPlayerHalfHeight = OriRealPlayerHalfHeight or Params.PrePlayerCapsuleHalfHeight
    local CapsuleHalfHeightDif = self.ArmoryPlayer.CapsuleComponent:GetScaledCapsuleHalfHeight() - OriRealPlayerHalfHeight
    TargetTrans.Translation.Z = TargetTrans.Translation.Z + CapsuleHalfHeightDif
  end
  self.ArmoryPlayer:K2_SetActorLocation(TargetTrans.Translation, false, HitResult, false)
  self.PlayerOriginalRootTrans = self.ArmoryPlayer.Mesh:K2_GetComponentToWorld()
  self.ArmoryHelper.OriginalRootTrans = self.PlayerOriginalRootTrans
  return TargetTrans
end

local function SetPlayerLocationInternal(PlayerCharacter, Loc)
  if nil == PlayerCharacter then
    return
  end
  PlayerCharacter:K2_SetActorLocation(Loc, false, HitResult, false)
end

function M:SetPlayerLocation(Loc)
  SetPlayerLocationInternal(self:GetPlayerActor(), Loc)
  SetPlayerLocationInternal(self:GetReflectionActor(self:GetPlayerActor()), Loc)
end

local function SetPlayerRotationInternal(PlayerCharacter, Rot)
  if nil == PlayerCharacter then
    return
  end
  PlayerCharacter:K2_SetActorRotation(Rot, false, HitResult, false)
end

function M:SetPlayerRotation(Rot)
  SetPlayerRotationInternal(self:GetPlayerActor(), Rot)
  SetPlayerRotationInternal(self:GetReflectionActor(self:GetPlayerActor()), Rot)
end

function M:OnOpened()
  if self.IsPreviewMode or self.IsSecondary then
    return
  end
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  PlayerCharacter:SetCharacterTag("Interactive")
  PlayerCharacter:SetHoldCrouch(false)
  PlayerCharacter:ResetJumpState_Cpp()
  PlayerCharacter:ResetCapSize()
  PlayerCharacter.PlayerAnimInstance:Montage_Stop(0)
  PlayerCharacter.PlayerAnimInstance:ForceToIdle()
  PlayerCharacter:RemoveClearInputCache()
  PlayerCharacter:GetMovementComponent().bForceStop = true
  PlayerCharacter:LaunchCharacter(FVector(0, 0, 0), true, true)
  local Avatar = GWorld:GetAvatar()
  Avatar:ResetNeedRefreshPlayer()
  if PlayerCharacter.CurrentMasterBan or Avatar.CurrentMasterBan then
    PlayerCharacter:ChangeBackToHero()
  end
  self:SavePlayerInfo()
end

function M:SavePlayerInfo()
  local Avatar = GWorld:GetAvatar()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  local Hp = Player:GetAttr("Hp")
  local ES = Player:GetAttr("ES")
  local Sp = Player:GetAttr("Sp")
  if Avatar.CurrentMasterBan and Avatar.HeroTempInfo then
    Hp = Avatar.HeroTempInfo.RoleInfo.PlayerHp
    ES = Avatar.HeroTempInfo.RoleInfo.PlayerES
    Sp = Avatar.HeroTempInfo.RoleInfo.PlayerSp
  end
  local MaxHp = Player:GetAttr("MaxHp")
  local HpRate = Hp / MaxHp
  local MaxES = Player:GetAttr("MaxES")
  local ESRate = 1
  if MaxES and 0 ~= MaxES then
    ESRate = ES / MaxES
  end
  local MaxSp = Player:GetAttr("MaxSp")
  local SpRate = 1
  if MaxSp and 0 ~= MaxSp then
    SpRate = Sp / MaxSp
  end
  local BulletRate = 1
  local MagazineBulletRate = 1
  local RangedWeapon = Player.RangedWeapon
  if RangedWeapon then
    local BulletNum = RangedWeapon:GetAttr("BulletNum") or 0
    local MagazineBulletNum = RangedWeapon:GetAttr("MagazineBulletNum") or 0
    if Avatar.CurrentMasterBan and Avatar.HeroTempInfo then
      BulletNum = Avatar.HeroTempInfo.RangedWeapon.BulletNum
      MagazineBulletNum = Avatar.HeroTempInfo.RangedWeapon.MagazineBulletNum
    end
    local BulletMax = RangedWeapon:GetAttr("BulletMax")
    if BulletMax and 0 ~= BulletMax then
      BulletRate = (BulletNum + MagazineBulletNum) / BulletMax
    end
    local MagazineCapacity = RangedWeapon:GetAttr("MagazineCapacity")
    if MagazineCapacity and 0 ~= MagazineCapacity then
      MagazineBulletRate = MagazineBulletNum / MagazineCapacity
    end
  end
  self.PlayerInfo = {
    HpRate = HpRate,
    ESRate = ESRate,
    SpRate = SpRate,
    BulletRate = BulletRate,
    MagazineBulletRate = MagazineBulletRate
  }
end

function M:LoadPlayerInfo()
  if not self.PlayerInfo then
    return
  end
  PrintTable({
    LoadPlayerInfo = self.PlayerInfo
  }, 10, "self.PlayerInfo")
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  if nil == Player then
    return
  end
  local Hp = math.floor(math.max(self.PlayerInfo.HpRate * Player:GetAttr("MaxHp"), 1))
  Player:SetAttr("Hp", Hp)
  local MaxES = Player:GetAttr("MaxES")
  if MaxES and 0 ~= MaxES then
    local ES = math.floor(self.PlayerInfo.ESRate * MaxES)
    Player:SetAttr("ES", ES)
  end
  local MaxSp = Player:GetAttr("MaxSp")
  if MaxSp and 0 ~= MaxSp then
    local Sp = math.floor(self.PlayerInfo.SpRate * MaxSp)
    Player:SetAttr("Sp", Sp)
  end
  local RangedWeapon = Player.RangedWeapon
  if RangedWeapon then
    local BulletMax = RangedWeapon:GetAttr("BulletMax")
    local BulletNum
    if BulletMax and 0 ~= BulletMax then
      BulletNum = math.floor(self.PlayerInfo.BulletRate * BulletMax)
    end
    local MagazineCapacity = RangedWeapon:GetAttr("MagazineCapacity")
    if MagazineCapacity and 0 ~= MagazineCapacity then
      local MagazineBulletNum = math.floor(self.PlayerInfo.MagazineBulletRate * MagazineCapacity)
      MagazineBulletNum = math.min(BulletNum, MagazineBulletNum)
      RangedWeapon:SetAttr("MagazineBulletNum", MagazineBulletNum)
      RangedWeapon:K2_GetAttributesSet():OnRep_MagazineBulletNum()
      BulletNum = BulletNum and BulletNum - MagazineBulletNum
    end
    if BulletNum then
      RangedWeapon:SetAttr("BulletNum", BulletNum)
      RangedWeapon:K2_GetAttributesSet():OnRep_BulletNum()
      RangedWeapon:K2_GetAttributesSet():OnRep_MagazineBulletNum()
    end
    if RangedWeapon:GetWeaponMeleeOrRanged() == "Ranged" and 0 == RangedWeapon:GetAttr("MagazineBulletNum") then
      Battle(self.ViewUI):TriggerBattleEvent(BattleEventName.OnMagazineBulletCleared, RangedWeapon:GetOwner())
    end
    Player:UpdateBulletNumUI()
  end
  EventManager:FireEvent(EventID.RefreshMainPlayerBlood)
  EventManager:FireEvent(EventID.UpdateMainPlayerSp, nil, nil, Player)
end

local function ChangeCharModelInternal(self, PlayCharacter, Avatar, CharInfo, Char)
  if not PlayCharacter then
    return
  end
  local CharId
  local AvatarBattleInfo = {}
  local GameMode = UE4.UGameplayStatics.GetGameMode(PlayCharacter)
  if PlayCharacter.CharacterFashion then
    PlayCharacter.CharacterFashion.Type2PartId = {}
  end
  if Char and GameMode then
    CharId = Char.CharId
    AvatarBattleInfo = AvatarUtils:GetDefaultBattleInfo(Avatar, {Char = Char})
    AvatarBattleInfo = {AvatarInfo = AvatarBattleInfo}
    AvatarBattleInfo = GameMode:SimplifyInfoForInit(AvatarBattleInfo)
    AvatarBattleInfo.FromArmory = true
    if AvatarBattleInfo.AvatarInfo then
      AvatarBattleInfo.AvatarInfo.MeleeWeapon = nil
      AvatarBattleInfo.AvatarInfo.RangedWeapon = nil
    end
    PlayCharacter:InitCharacterInfo(AvatarBattleInfo)
  else
    CharId = CharInfo.CharId
    AvatarBattleInfo.FromOtherWorld = true
    AvatarBattleInfo.FromArmory = true
    PlayCharacter:ChangeRole(CharId, AvatarBattleInfo)
  end
  PlayCharacter:ClearWeapon()
  PlayCharacter:SetCharacterTag("Interactive")
  PlayCharacter:KawaiiSwitch(true)
  if PlayCharacter.PlayerAnimInstance then
    PlayCharacter.PlayerAnimInstance:SetKawiiLayerState(EKawaiiLayerState.EKLS_Armory)
  end
  return CharId
end

function M:ChangeCharModel(Info, bIfNoDelay, bNoCharVoice, bForceChange, IsProtagonist)
  self:BeforeViewActorChanged()
  local PlayCharacter = self:GetPlayerActor(true)
  self.ArmoryHelper:SetViewActor(PlayCharacter)
  self:ResetActorRotation()
  self.ViewActorType = self.ViewActorTypes.Player
  self:HidePlayerActor(self.UIName, false)
  self.ArmoryHelper.OriginalRootTrans = self.PlayerOriginalRootTrans
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local Uuid = Info.Uuid
  local Char = Uuid and Avatar.Chars[Uuid]
  local NewCharInfo = Char or Info
  if self.CurrentCharInfo == NewCharInfo and not bForceChange then
    return
  end
  local LastCharId = self.CurrentCharInfo and self.CurrentCharInfo.CharId
  self.CurrentCharInfo = NewCharInfo
  self.CurrentCharFromAvatar = Avatar
  if self.CurrentCharInfo.DumpAppearanceSuit then
    self.CurrentAppearanceInfo = self.CurrentCharInfo:DumpAppearanceSuit(Avatar)
  else
    self.CurrentAppearanceInfo = {}
  end
  local CharId = ChangeCharModelInternal(self, PlayCharacter, Avatar, Info, Char)
  if self.bEnableReflection then
    ChangeCharModelInternal(self, self:GetReflectionActor(PlayCharacter), Avatar, Info, Char)
  end
  self:UpdatePlayerReflectionTrans()
  if IsProtagonist then
    self.IsProtagonist = true
    self.bWaitForNotifyToChangePet = true
  else
    self:ChangePetModel(nil)
    self.IsProtagonist = false
    self.bWaitForNotifyToChangePet = false
  end
  if bIfNoDelay then
    self.DelayFrame = 0
  else
    self.DelayFrame = 30
  end
  self.bPlayRoleChangedSound = not bNoCharVoice
  if LastCharId and LastCharId == CharId then
    self.bPlayRoleChangedSound = false
  end
  self.bPlaySameMontage = true
  self.ArmoryHelper:OnRoleChanged()
  self:StopPlayerSound()
  if self.OnCharModelChanged then
    self.OnCharModelChanged(self.EventObj)
  end
  return true
end

function M:StopPlayerSound()
  local Player = self:GetPlayerActor()
  if Player then
    local _AudioManager = AudioManager(self)
    _AudioManager:StopSound(Player, "ArmoryRoleVoice")
    _AudioManager:StopSound(Player, self.UIName)
    _AudioManager:RemoveCharacterFromEndStopAndLoopPlayRecordMapWhenCharacterEndPlay(Player, 0)
  end
end

function M:ChangeToProtagonist(bIfNoDelay, bNoCharVoice, bForceChange)
  local IsRoleChanged
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.ProtagonistCharInfo = self.ProtagonistCharInfo or {
    CharId = DataMgr.Player2RoleId.Player[Avatar.Sex]
  }
  IsRoleChanged = self:ChangeCharModel(self.ProtagonistCharInfo, bIfNoDelay, bNoCharVoice, bForceChange, true)
  self:ChangeCharAppearance({
    SkinId = self.ProtagonistCharInfo.CharId
  })
  return IsRoleChanged
end

function M:GetPlayerActor(bCreate)
  if self.ArmoryPlayer == nil and bCreate then
    self:CreatePlayerActor()
  end
  return self.ArmoryPlayer
end

function M:DoSomethingWithPlayer()
end

function M:CreatePlayerActor()
  local UIManager = UIManager(self.ViewUI)
  local IsCharActorFistCreated
  self.ArmoryPlayer, IsCharActorFistCreated = UIManager:CreateOrGetArmoryPlayerActor(self.CurrentCharInfo, self:GetAvatar())
  PlayerActorRefs[self] = self.ArmoryPlayer
  self:UpdateAudioListener()
  self:ClearPlayerHideTag(self.ArmoryPlayer)
  local Params = {}
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  Params.PreRoleId = Player.CurrentRoleId
  Params.PrePlayerCapsuleHalfHeight = Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
  if not IsCharActorFistCreated and self.CurrentCharInfo then
    self:ChangeCharModel(self.CurrentCharInfo, true, nil, true)
  end
  self.CurrentAppearanceInfo = self.ArmoryPlayer.InfoForInit and self.ArmoryPlayer.InfoForInit.AppearanceSuit
  
  local function AfterCreated(PlayerActor)
    if not PlayerActor then
      return
    end
    if PlayerActor.MeleeWeapon then
      PlayerActor.MeleeWeapon:SetActorHideTag(self.UIName, true)
    end
    if IsValid(UIManager.ArmoryWeapon) then
      UIManager.ArmoryWeapon:SetActorHideTag(self.UIName, true)
    end
    PlayerActor:KawaiiSwitch(true)
    if PlayerActor.PlayerAnimInstance then
      PlayerActor.PlayerAnimInstance:SetKawiiLayerState(EKawaiiLayerState.EKLS_Armory)
    end
    PlayerActor:SetCharacterTag("Interactive")
    PlayerActor:K2_SetActorTransform(Player:GetTransform(), false, nil, false)
  end
  
  AfterCreated(self.ArmoryPlayer)
  self.ArmoryHelper:SetPlayer(self.ArmoryPlayer)
  self.ArmoryHelper:SetViewActor(self.ArmoryPlayer)
  self.ViewActorType = self.ViewActorTypes.Player
  if not self.bPreviewSceneLoaded then
    local Trans = self.ArmoryHelper:OpenArmoryTransformCheck()
    if Trans then
      self.UncalculatedTrans = Trans
    end
  end
  CalculatePlayerTrans(self, Params)
  if not self.bEnableReflection then
    return
  end
  local PlayerReflection = UIManager:CreateOrGetPlayerReflection(self.CurrentCharInfo, self:GetAvatar())
  if PlayerReflection then
    for key, value in pairs(PlayerReflection.CharPartMeshComponents or {}) do
      value:SetTranslucentSortPriority(-3)
    end
  end
  self:SetReflectionActor(self.ArmoryPlayer, PlayerReflection)
  PlayerReflectionRefs[self] = PlayerReflection
  if not IsCharActorFistCreated and self.CurrentCharInfo then
    self:ChangeCharModel(self.CurrentCharInfo, true, nil, true)
  end
  AfterCreated(PlayerReflection)
  self:UpdatePlayerReflectionTrans()
  self:ClearPlayerHideTag(self:GetReflectionActor(self.ArmoryPlayer))
end

function M:UpdatePlayerReflectionTrans()
  local PlayerReflection = self:GetReflectionActor(self.ArmoryPlayer)
  if nil == PlayerReflection then
    return
  end
  PlayerReflection:K2_SetActorTransform(self.ArmoryPlayer:GetTransform(), false, nil, false)
  local Trans = PlayerReflection.Mesh:K2_GetComponentToWorld()
  if Trans.Scale3D.Z > 0 then
    Trans.Scale3D.Z = -Trans.Scale3D.Z
  end
  PlayerReflection.Mesh:K2_SetWorldTransform(Trans, false, nil, false)
  PlayerReflection.Mesh:SetBoundsScale(10000)
end

function M:ChangeRealPlayerInfo()
  if self.IsPreviewMode or self.IsSecondary then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  if not Player or not Avatar then
    return
  end
  if 0 ~= Avatar.CurrentPet then
    local Pet = Avatar.Pets[Avatar.CurrentPet]
    if Pet then
      Player:ServerSetBattlePet(Pet.PetId, Pet:GetSkillLevel(), false, TArray(0))
    end
  end
  if Player.CurrentMasterBan then
    Player:WithChangeBackToHero()
  end
  if Avatar:GetNeedRefreshPlayer() then
    local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
    local PlayerController = Player:GetController()
    PlayerController:SetAvatarInfo(CommonUtils.ObjId2Str(Avatar.Eid), AvatarInfo)
    Player:ChangeRole(nil, AvatarInfo)
    Player:RecoverBanSkills()
    UE4.UPhantomFunctionLibrary.CancelAllPhantom(Player, EDestroyReason.PhantomChangeRole)
    EventManager:FireEvent(EventID.OnSwitchRole, Avatar.CurrentChar)
  else
  end
end

function M:HidePlayerActor(Tag, IsHidden, bDontSaveTag)
  local Player = self:GetPlayerActor()
  if not IsValid(Player) then
    return
  end
  if not bDontSaveTag then
    if true == IsHidden then
      self.PlayerActorHideTags[Tag] = true
    else
      self.PlayerActorHideTags[Tag] = nil
    end
  end
  self:HidePlayerActorInternal(Player, Tag, IsHidden)
  self:HidePlayerActorInternal(self:GetReflectionActor(Player), Tag, IsHidden)
end

function M:HidePlayerActorInternal(PlayerCharacter, Tag, IsHidden)
  if nil == PlayerCharacter then
    return
  end
  PlayerCharacter:SetActorHideTag(Tag, IsHidden, false, true)
  PlayerCharacter:HideAllEffectCreature(Tag, IsHidden)
end

function M:ClearPlayerHideTag(PlayerActor)
  if not IsValid(PlayerActor) then
    return
  end
  local Tags = PlayerActor.HideTags:ToTable()
  for key, Tag in pairs(Tags) do
    self:HidePlayerActor(Tag, false)
  end
end

function M:BeforeViewActorChanged()
  if self.ViewActorType == self.ViewActorTypes.Player then
    self:HidePlayerActor(self.UIName, true)
  end
end

function M:AfterViewActorChanged()
  if self.ViewActorType == self.ViewActorTypes.Player and not self.LTweenHandle_PlayDisappearFX then
    self:HidePlayerActor(self.UIName, false)
  end
end

function M:CharLvUpOrBreakUp()
  local function CharLvUpOrBreakUpInternal(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter.FXComponent:PlayEffectByIDParams(303, {bTickEvenWhenPaused = true, NotAttached = true})
  end
  
  CharLvUpOrBreakUpInternal(self:GetPlayerActor())
  if self.bEnableReflection then
    CharLvUpOrBreakUpInternal(self:GetReflectionActor(self:GetPlayerActor()))
  end
end

function M:StopPlayerMontage(Params)
  Params = Params or {}
  for key, value in pairs(self.PlayerMontageTimerKeys) do
    self.ArmoryHelper:RemoveTimer(key)
  end
  self.PlayerMontageTimerKeys = {}
  
  local function StopMontage(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter:StopMontage()
  end
  
  StopMontage(self:GetPlayerActor())
  StopMontage(self:GetReflectionActor(self:GetPlayerActor()))
  self:HidePlayerActor("ActorController_FX_Teleport", false)
  if not Params.DontStopSequance then
    self:StopSequence()
  end
  self.CurMontageTag = "None"
end

function M:StopPlayerFX()
  for key, value in pairs(self.PlayerFXTimerKeys) do
    self.ArmoryHelper:RemoveTimer(key)
  end
  self.PlayerFXTimerKeys = {}
end

function M:PlayResourceMotion(ResourceId)
  local function PlayResourceMotionInternal(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter:SetArmoryTag("None")
    if PlayerCharacter.EMAnimInstance and PlayerCharacter.EMAnimInstance.ResetIdleTag then
      PlayerCharacter.EMAnimInstance:ResetIdleTag()
    end
    PlayerCharacter:InvokeResourceBPFunction(ResourceId)
  end
  
  PlayResourceMotionInternal(self:GetPlayerActor())
  if self.bEnableReflection then
    PlayResourceMotionInternal(self:GetReflectionActor(self:GetPlayerActor()))
  end
end

function M:RemovePlayerGestureEffectCreature()
  local function RemovePlayerGestureEffectCreatureInternal(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter:RemoveAllEffectCreature(false)
  end
  
  RemovePlayerGestureEffectCreatureInternal(self:GetPlayerActor())
  RemovePlayerGestureEffectCreatureInternal(self:GetReflectionActor(self:GetPlayerActor()))
end

function M:ClearPlayerGestureHideTags()
  local function ClearPlayerGestureHideTagsInternal(PlayerCharacter, PlayerEffectCreatureHideTags)
    if nil == PlayerCharacter then
      return
    end
    if PlayerCharacter.EffectCreatureHideTags then
      local EffectCreatureHideTags = PlayerCharacter.EffectCreatureHideTags:ToTable()
      for k, v in pairs(EffectCreatureHideTags) do
        if PlayerEffectCreatureHideTags then
          PlayerEffectCreatureHideTags[k] = v
        end
        PlayerCharacter:HideAllEffectCreature(k, false)
      end
    end
  end
  
  self.PlayerEffectCreatureHideTags = {}
  self.ReflectionPlayerEffectCreatureHideTags = {}
  ClearPlayerGestureHideTagsInternal(self:GetPlayerActor(), self.PlayerEffectCreatureHideTags)
  ClearPlayerGestureHideTagsInternal(self:GetReflectionActor(self:GetPlayerActor()), self.ReflectionPlayerEffectCreatureHideTags)
end

function M:RevertPlayerGestureEffectCreature()
  local function RevertPlayerGestureEffectCreatureInternal(PlayerCharacter, PlayerEffectCreatureHideTags)
    if nil == PlayerCharacter then
      return
    end
    if PlayerEffectCreatureHideTags then
      for k, v in pairs(PlayerEffectCreatureHideTags) do
        PlayerCharacter:HideAllEffectCreature(k, v)
      end
    end
  end
  
  RevertPlayerGestureEffectCreatureInternal(self:GetPlayerActor(), self.PlayerEffectCreatureHideTags)
  RevertPlayerGestureEffectCreatureInternal(self:GetReflectionActor(self:GetPlayerActor()), self.ReflectionPlayerEffectCreatureHideTags)
  self.PlayerEffectCreatureHideTags = nil
  self.ReflectionPlayerEffectCreatureHideTags = nil
end

function M:HidePlayerMeleeWeapon()
  local function HidePlayerMeleeWeaponInternal(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    if PlayerCharacter.MeleeWeapon then
      PlayerCharacter.MeleeWeapon:SetActorHideTag(self.UIName, true)
    end
  end
  
  HidePlayerMeleeWeaponInternal(self:GetPlayerActor())
  HidePlayerMeleeWeaponInternal(self:GetReflectionActor(self:GetPlayerActor()))
end

function M:Component_OnClosed()
  self:StopPlayerSound()
  self:HidePlayerActor(self.UIName, true)
end

function M:Component_DestroyActors()
  self.CurrentCharInfo = nil
  for Tag, bIsHidden in pairs(self.PlayerActorHideTags) do
    if bIsHidden then
      self:HidePlayerActor(Tag, false)
    end
  end
  PlayerActorRefs[self] = nil
  PlayerReflectionRefs[self] = nil
  local UIManager = UIManager(self.ViewUI)
  if nil == next(PlayerActorRefs) then
    UIManager.ArmoryPlayer = nil
    if self.ArmoryHelper then
      self.ArmoryHelper.bNeedDestroyPlayerActor = true
    end
  end
  if nil == next(PlayerReflectionRefs) then
    self:DestroyPlayerActor(UIManager.PlayerReflection)
    UIManager.PlayerReflection = nil
  end
  if self.IsPreviewMode or self.IsSecondary then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  if Player then
    Player:SetCharacterTag("Idle")
    if Player.PlayerAnimInstance then
      Player.PlayerAnimInstance:SetKawiiLayerState(EKawaiiLayerState.EKLS_Battle)
    end
  end
  self:LoadPlayerInfo()
end

function M:DestroyPlayerActor(PlayerActor)
  if nil == PlayerActor then
    return
  end
  if PlayerActor.IsPlayer and PlayerActor:IsPlayer() then
    PlayerActor:ServerRemoveBattlePet()
  end
  PlayerActor:EMActorDestroy(EDestroyReason.Armory)
  PlayerActor:K2_DestroyActor()
end

return M
