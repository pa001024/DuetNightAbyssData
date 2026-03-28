local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = {}

function M:Init(Params)
  EventManager:AddEvent(EventID.OnCharGradeLevelUp, self, self.OnCharGradeLevelUp)
  EventManager:AddEvent(EventID.OnWeaponBreakLevelUp, self, self.OnWeaponBreakLevelUp)
end

function M:OnCharGradeLevelUp(Ret, CharUuid, CurrentGradeLevel)
  if not self.CurrentCharInfo or self.CurrentCharInfo.Uuid ~= CharUuid then
    return
  end
  local Avatar = self:GetAvatar()
  local Char = Avatar.Chars[CharUuid]
  if Char then
    local function OnCharGradeLevelUpInternal(Character)
      if nil == Character or nil == Character.CharacterFashion then
        return
      end
      Character.CharacterFashion:GradeUpEmissive(Char.GradeLevel)
      if Character.InfoForInit then
        Character.InfoForInit.GradeLevel = Char.GradeLevel
      end
    end
    
    OnCharGradeLevelUpInternal(self.ArmoryPlayer)
    OnCharGradeLevelUpInternal(self:GetReflectionActor(self.ArmoryPlayer))
  end
end

function M:ChangeCharAppearance(AppearanceInfo)
  if not self.ArmoryPlayer or not self.ArmoryPlayer.CharacterFashion then
    return
  end
  self.CurrentAppearanceInfo = AppearanceInfo
  self.bPlaySameMontage = true
  
  local function ChangeCharAppearanceInternal(Character)
    if nil == Character then
      return
    end
    if Character.CurrentCompositeMesh then
      Character.CurrentCompositeMesh = nil
    end
    local ModelComp = Character:GetCharModelComponent()
    if ModelComp then
      ModelComp:LoadCurrentModel()
    end
    Character.CharacterFashion:InitAppearanceSuit(AppearanceInfo)
    if Character.PlayerAnimInstance then
      Character.PlayerAnimInstance:SetKawiiLayerState(EKawaiiLayerState.EKLS_Armory)
    end
  end
  
  ChangeCharAppearanceInternal(self.ArmoryPlayer)
  local ReflectionActor = self:GetReflectionActor(self.ArmoryPlayer)
  ChangeCharAppearanceInternal(ReflectionActor)
  if ReflectionActor then
    self:UpdatePlayerReflectionTrans()
  end
end

function M:ChangeCharHair(HariId)
  if not self.ArmoryPlayer then
    return
  end
  self.CurrentAppearanceInfo.HariId = HariId
  
  local function ChangeCharHairInternal(Character)
    local CharacterFashion = Character and Character.CharacterFashion
    if not CharacterFashion then
      return
    end
    CharacterFashion:ChangeCharHair(HariId)
  end
  
  ChangeCharHairInternal(self.ArmoryPlayer)
  ChangeCharHairInternal(self:GetReflectionActor(self.ArmoryPlayer))
  self:ChangeCharAccessory(self.CurrentAppearanceInfo.AccessorySuit[CommonConst.NewCharAccessoryTypes.Hat], "Hat")
  self:ChangeCharSkinColor(self.CurrentAppearanceInfo.Colors)
  self:ChangeCharHairColor(self.CurrentAppearanceInfo.HairColors)
end

function M:ChangeCharHairColor(Colors)
  self.CurrentAppearanceInfo.HairColors = Colors
  
  local function ChangeCharHairColorInternal(Character)
    local CharacterFashion = Character and Character.CharacterFashion
    if not CharacterFashion then
      return
    end
    CharacterFashion:InitHairColors(Colors)
  end
  
  ChangeCharHairColorInternal(self.ArmoryPlayer)
  ChangeCharHairColorInternal(self:GetReflectionActor(self.ArmoryPlayer))
end

function M:ChangeCharHairPartColor(PartIdx, Color, Fresnel)
  local function ChangeCharHairPartColorInternal(Character)
    local CharacterFashion = Character and Character.CharacterFashion
    
    if not CharacterFashion then
      return
    end
    CharacterFashion:ChangeHairPartColor(PartIdx, Color, Fresnel)
  end
  
  ChangeCharHairPartColorInternal(self.ArmoryPlayer)
  ChangeCharHairPartColorInternal(self:GetReflectionActor(self.ArmoryPlayer))
end

function M:ChangeCharSkinColor(Colors)
  self.CurrentAppearanceInfo.Colors = Colors
  
  local function ChangeCharSkinColorInternal(PlayerCharacter)
    local CharacterFashion = PlayerCharacter and PlayerCharacter.CharacterFashion
    if not CharacterFashion then
      return
    end
    PlayerCharacter.CharacterFashion:RefreshUncoloredSkinColors(Colors)
  end
  
  ChangeCharSkinColorInternal(self.ArmoryPlayer)
  ChangeCharSkinColorInternal(self:GetReflectionActor(self.ArmoryPlayer))
end

function M:ChangeCharPartColor(PartIdx, Color, Fresnel)
  local function ChangeCharPartColorInternal(PlayerCharacter)
    local CharacterFashion = PlayerCharacter and PlayerCharacter.CharacterFashion
    
    if not CharacterFashion then
      return
    end
    CharacterFashion:ChangePartColor(PartIdx, Color, Fresnel)
  end
  
  ChangeCharPartColorInternal(self.ArmoryPlayer)
  ChangeCharPartColorInternal(self:GetReflectionActor(self.ArmoryPlayer))
end

function M:ChangeCharAccessory(AccessoryId, AccessoryType, CustomParams)
  if not self.ArmoryPlayer then
    return
  end
  self.CurrentAppearanceInfo.AccessorySuit[CommonConst.NewCharAccessoryTypes[AccessoryType]] = AccessoryId
  
  local function ChangeCharAccessoryInternal(PlayerCharacter)
    if not PlayerCharacter then
      return
    end
    PlayerCharacter.CharacterFashion:ChangeAccessory(AccessoryId, AccessoryType, CustomParams)
  end
  
  ChangeCharAccessoryInternal(self.ArmoryPlayer)
  ChangeCharAccessoryInternal(self:GetReflectionActor(self.ArmoryPlayer))
  self:ChangeCharSkinColor(self.CurrentAppearanceInfo.Colors)
  self:ChangeCharHairColor(self.CurrentAppearanceInfo.HairColors)
end

local ShowFXAccessoryPrefix = "ShowFXAccessory_"
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_Dead] = function(self, Player, AccessoryId, AccessoryType)
  Player = Player or self:GetPlayerActor()
  local Data = DataMgr.CharAccessory[AccessoryId]
  local CreatureKey = AccessoryType
  self:DestroyCreature(CreatureKey)
  local CreatureId = Data and Data.CreatureId or 14001
  Player:AsyncCreateEffectCreatureWithCallBack(CreatureId, FTransform(FRotator(0, 0, 180), FVector(0, 0, 0), FVector(1)), true, "Root", {
    self.ViewUI,
    function(_, Creature)
      self:DestroyCreature(CreatureKey)
      Creature:SetActorHiddenInGame(false)
      self.Creatures[CreatureKey] = Creature
    end
  })
end
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_Footprint] = function(self, Player, AccessoryId, AccessoryType)
  Player = Player or self:GetPlayerActor()
  local Data = DataMgr.CharAccessory[AccessoryId]
  local FXId = Data and Data.VisualEffectId
  if not FXId then
    return
  end
  local Loc = Player:K2_GetActorLocation()
  Loc.Z = Loc.Z - Player.CapsuleComponent:GetScaledCapsuleHalfHeight() - 2.4
  self.PlayerFXTimerKeys.PlayFootprintFXLoop = true
  
  local function PlayEffect(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter.FXComponent:PlayEffectByIDParams(FXId, {
      bTickEvenWhenPaused = true,
      UseAbsoluteLocation = true,
      Location = {
        Loc.X,
        Loc.Y,
        Loc.Z
      }
    })
  end
  
  PlayEffect(Player)
  PlayEffect(self:GetReflectionActor(Player))
  self.ArmoryHelper:AddTimer(1, function()
    PlayEffect(Player)
    PlayEffect(self:GetReflectionActor(Player))
  end, true, 0, "PlayFootprintFXLoop", true)
end
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_Teleport] = function(self, Player, AccessoryId, AccessoryType)
  Player = Player or self:GetPlayerActor()
  local PlayerReflection = self:GetReflectionActor(Player)
  local Data = DataMgr.CharAccessory[AccessoryId]
  local MontagePath = Data and Data.Montage or "Teleport_01_Montage"
  
  local function PlayTeleport(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter:PlayActionMontage("Interactive/MechInteractive", MontagePath, {}, false, true, false)
    PlayerCharacter.PlayerAnimInstance:Montage_JumpToSection("End")
  end
  
  local function PauseMontage(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter.PlayerAnimInstance:Montage_Pause()
  end
  
  Player:PlayActionMontage("Interactive/MechInteractive", MontagePath, {
    OnNotifyBegin = function()
      PauseMontage(Player)
      PauseMontage(PlayerReflection)
      self:HidePlayerActor(self.UIName, true)
      self.PlayerMontageTimerKeys.PlayTeleportMontage = true
      self.TeleportMontagePaused = true
      self.ArmoryHelper:AddTimer(1, function()
        PlayTeleport(Player)
        PlayTeleport(PlayerReflection)
        Player:PlayActionMontage("Interactive/MechInteractive", MontagePath, {}, false, true, false)
        Player.PlayerAnimInstance:Montage_JumpToSection("End")
        self:HidePlayerActor(self.UIName, false)
        self.TeleportMontagePaused = false
      end, false, 0.0, "PlayTeleportMontage", true)
    end,
    OnInterrupted = function()
      self:HidePlayerActor(self.UIName, false)
    end
  }, false, true, true)
  if PlayerReflection then
    PlayerReflection:PlayActionMontage("Interactive/MechInteractive", MontagePath, {}, false, false, true, true)
  end
end
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_PlungingATK] = function(self, Player, AccessoryId, AccessoryType)
  self:ChangeCharAccessory(AccessoryId, AccessoryType)
  local Avatar = GWorld:GetAvatar()
  local WeaponData = Avatar.Weapons[Avatar.MeleeWeapon]
  local PlayerActor = Player or self:GetPlayerActor()
  self:ChangePlayerWeapon(WeaponData, PlayerActor)
  
  local function PlayFallAttack(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter:SetArmoryTag(Const.ArmoryWeaponIdleTags.Armory_FallAttack)
  end
  
  PlayFallAttack(PlayerActor)
  PlayFallAttack(self:GetReflectionActor(PlayerActor))
end
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_HelixLeap] = function(self, Player, AccessoryId, AccessoryType)
  self:ChangeCharAccessory(AccessoryId, AccessoryType)
  
  local function PlayBullutJump(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter:SetArmoryTag(Const.ArmoryIdleTags.Armory_BullutJump)
  end
  
  PlayBullutJump(self:GetPlayerActor())
  PlayBullutJump(self:GetReflectionActor(self:GetPlayerActor()))
end
local MVPLocation = FVector(200000, 200000, 200000)

local function PlaySequenceByAccessoryId(self, Params)
  local Player = Params.Player
  local AccessoryId = Params.AccessoryId
  local Data = DataMgr.CharAccessory[AccessoryId]
  if not Data then
    return false
  end
  local MVPPath = Data.MVPKey
  local MontagePath = Data.Montage
  self.BeforeSequenceLocation = Player:K2_GetActorLocation()
  Player:K2_SetActorLocation(MVPLocation, false, nil, false)
  self.BeforeSequenceRotation = Player:K2_GetActorRotation()
  if Params.ActorRotation then
    Player:K2_SetActorRotation(Params.ActorRotation, false, nil, true)
  end
  Player:PlayDungeonSettlementMVPMontage(MontagePath)
  if Player.MVPSequenceActor then
    local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
    if SequencePlayer then
      SequencePlayer:Stop()
    end
  end
  Player:PlayDungeonSettlementMVPSequence(MVPPath)
  if Player.MVPSequenceActor then
    local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
    if SequencePlayer then
      SequencePlayer:PlayLooping()
      if SequencePlayer.OnLoop then
        SequencePlayer.OnLoop:Clear()
        SequencePlayer.OnLoop:Add(self.ViewUI, function()
          Player:PlayDungeonSettlementMVPMontage(MontagePath)
        end)
      end
    end
  end
  return true
end

local function PlaySequenceByPath(self, Params)
  local Player = Params.Player
  if not IsValid(Player) then
    return false
  end
  Player:PlayActionMontage("Interactive", Params.MontagePath, {})
  Player:SetCharacterTag("LevelFinish")
  Player:PlayMVPSequence(Params.SequencePath, FTransform(FRotator(0, -90, 0):ToQuat(), Const.ZeroVector, Const.OneVector))
  if Player.MVPSequenceActor then
    local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
    if SequencePlayer then
      SequencePlayer:PlayLooping()
    end
  end
  if Params.ActorRotation then
    Player:K2_SetActorRotation(Params.ActorRotation, false, nil, true)
  end
  return true
end

local function PlaySequenceInternal(self, Params)
  UIManager(self.ViewUI):ShowCommonBlackScreen({OutAnimationPlayTime = 1, IsPlayOutWhenLoaded = true})
  self.SequenceInfo = Params
  self.IsPlayingSequence = true
  local IsPlayed = false
  if Params.AccessoryId then
    IsPlayed = PlaySequenceByAccessoryId(self, Params)
  elseif Params.SequencePath then
    IsPlayed = PlaySequenceByPath(self, Params)
  end
  if not IsPlayed then
    self.IsPlayingSequence = false
    return
  end
  self:HidePlayerActor("ActorController_ChangeViewTarget", false)
  self.ArmoryHelper:AddTimer(0.03, function()
    self:SetGamePauseIfNeed(false)
  end, false, 0, "DelayUnpauseGame", true)
  return IsPlayed
end

function M:SetGamePauseIfNeed(bPause)
  if self.SequenceActorController or self.SequenceInfo then
    local Avatar = GWorld:GetAvatar()
    if not (Avatar and Avatar.CurrentOnlineType) or -1 == Avatar.CurrentOnlineType then
      if bPause then
        if self.LastUIPauseGameMap then
          for key, value in pairs(self.LastUIPauseGameMap) do
            self.ViewUI:UISetGamePaused(key, bPause)
          end
          self.LastUIPauseGameMap = nil
        end
      else
        local UIPauseGameMap = UIManager(self.ViewUI).UIPauseGameMap
        self.LastUIPauseGameMap = {}
        for key, value in pairs(UIPauseGameMap) do
          self.LastUIPauseGameMap[key] = value
          self.ViewUI:UISetGamePaused(key, bPause)
        end
      end
    end
  end
end

function M:PlaySequence(Params)
  if self.SequenceActorController then
    local PlayerActor = self.SequenceActorController:GetPlayerActor()
    if PlayerActor then
      Params.Player = PlayerActor
      local IsPlayed = PlaySequenceInternal(self.SequenceActorController, Params)
      if IsPlayed then
        self.SequenceActorController:CancelRefreshEnvironment()
        self.SequenceActorController:CancelUpdateSceneLighting()
        self:CancelRefreshEnvironment()
        self:CancelUpdateSceneLighting()
      end
    end
  end
end

function M:ReplaySequence()
  if self.SequenceActorController then
    self.SequenceActorController:ReplaySequence()
  elseif self.LastSequenceInfo then
    self:PlaySequence(self.LastSequenceInfo)
  end
end

local function StopSequenceInternal(self, KeepVar)
  self.ArmoryHelper:RemoveTimer("DelayUnpauseGame")
  local Player = self.SequenceInfo.Player
  self.LastSequenceInfo = self.SequenceInfo
  self.SequenceInfo = nil
  self.IsPlayingSequence = false
  Player:StopMontage()
  Player:StopMVPSequence()
  if self.BeforeSequenceLocation then
    Player:K2_SetActorLocation(self.BeforeSequenceLocation, false, nil, false)
    self.BeforeSequenceLocation = nil
  end
  if self.BeforeSequenceRotation then
    Player:K2_SetActorRotation(self.BeforeSequenceRotation, false, nil, true)
    self.BeforeSequenceRotation = nil
  end
  if Player and IsValid(Player.MVPSequenceActor) then
    Player.MVPSequenceActor:K2_DestroyActor()
  end
  self:SetGamePauseIfNeed(true)
end

function M:StopSequence()
  if self.SequenceActorController and self.SequenceActorController.SequenceInfo then
    StopSequenceInternal(self.SequenceActorController)
  end
end

function M:ClearLastSequenceInfo()
  if self.SequenceActorController then
    self.SequenceActorController:ClearLastSequenceInfo()
  end
  self.LastSequenceInfo = nil
end

local function PauseSequenceInternal(self)
  self.ArmoryHelper:RemoveTimer("DelayUnpauseGame")
  local Player = self.SequenceInfo.Player
  if Player and Player.MVPSequenceActor then
    local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
    if SequencePlayer then
      SequencePlayer:Pause()
    end
  end
end

function M:PauseSequence()
  if self.SequenceActorController and self.SequenceActorController.SequenceInfo then
    PauseSequenceInternal(self.SequenceActorController)
  end
end

local function IsMVPSequencePausedInternal(self)
  local Player = self.SequenceInfo.Player
  if Player and Player.MVPSequenceActor then
    local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
    if SequencePlayer then
      return SequencePlayer:IsPaused()
    end
  end
end

local function IsSequencePausedInternal(self)
  return IsMVPSequencePausedInternal(self)
end

function M:IsSequencePaused()
  if self.SequenceActorController and self.SequenceActorController.SequenceInfo then
    return IsSequencePausedInternal(self.SequenceActorController)
  end
end

function M:HasLastSequenceInfo()
  if self.SequenceActorController then
    return self.SequenceActorController:HasLastSequenceInfo()
  end
  return self.LastSequenceInfo
end

function M:TryCreateSequenceActorController()
  if not self.SequenceActorController then
    local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
    self.SequenceActorController = ActorController:New({
      ViewUI = self.ViewUI,
      IsPreviewMode = true,
      bEnableReflection = false,
      EPreviewSceneType = self.EPreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon,
      SkyBoxIndex = self.SkyBoxIndex,
      Char = self.CurrentCharInfo,
      AfterEndViewTarget = {
        Func = self.AfterSequenceActorControllerEndViewTarget,
        Obj = self
      }
    })
    self.SequenceActorController:OnOpened()
  end
end

function M:AfterSequenceActorControllerEndViewTarget()
  local TopStackUI = UIManager(self.ViewUI):GetWidgetObjInTopStack()
  if TopStackUI ~= self.ViewUI and not self:IsSequencePaused() then
    self:StopSequence()
  end
end

function M:TryDestroySequenceActorController()
  if self.SequenceActorController then
    self:StopSequence()
    self.SequenceActorController:OnDestruct()
    self.SequenceActorController = nil
    self:ViewTarget()
  end
end

M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.MVP] = function(self, Player, AccessoryId, AccessoryType)
  self:StopSequence()
  self:PlaySequence({
    AccessoryId = AccessoryId,
    ActorRotation = Const.ZeroRotator
  })
end

function M:ShowPlayerFXAccessory(AccessoryId, AccessoryType)
  if not AccessoryType then
    return
  end
  local Player = self:GetPlayerActor()
  if not Player then
    return
  end
  local FuncName = ShowFXAccessoryPrefix .. AccessoryType
  if self[FuncName] then
    self[FuncName](self, Player, AccessoryId, AccessoryType)
  end
end

function M:SetCharAccessoryOffset(AccessoryId, AccessoryType, Scale, Location, Rotation)
  if not self.ArmoryPlayer then
    return
  end
  local Trans
  if Rotation then
    Trans = FTransform(Rotation:ToQuat(), Const.ZeroVector, Const.OneVector)
  else
    Trans = FTransform(Const.ZeroRotator:ToQuat(), Const.ZeroVector, Const.OneVector)
  end
  if Location then
    Trans.Translation = Location
  end
  if Scale then
    Trans.Scale3D = Scale
  end
  local OriginTrans = self.ArmoryPlayer.CharacterFashion:GetAccessoryOriginOffset(AccessoryId)
  Trans = Trans * OriginTrans
  
  local function SetCharAccessoryOffsetInternal(PlayerCharacter)
    if nil == PlayerCharacter then
      return
    end
    PlayerCharacter:SetAccessoryTransform(AccessoryId, AccessoryType, Trans)
  end
  
  SetCharAccessoryOffsetInternal(self:GetPlayerActor())
  SetCharAccessoryOffsetInternal(self:GetReflectionActor(self:GetPlayerActor()))
end

function M:StartPlayerPartHighLight(LastColor, PartIdx, HighLightColor, Curve)
  local CharacterFashion = self.ArmoryPlayer and self.ArmoryPlayer.CharacterFashion
  local FunctionName = "SetCharTintColor" .. PartIdx
  local Func = CharacterFashion[FunctionName]
  local _TickFrequency = 0.033
  local _, MaxTime = Curve:GetTimeRange()
  local PassedTime = 0
  local Alpha
  if Func then
    self.ArmoryHelper:AddTimer(_TickFrequency, function()
      PassedTime = PassedTime + _TickFrequency
      if PassedTime >= MaxTime then
        self:StopPlayerPartHighLight(PartIdx)
        self:ChangeCharPartColor(PartIdx, LastColor)
        return
      end
      Alpha = Curve:GetFloatValue(PassedTime)
      self:ChangeCharPartColor(PartIdx, UKismetMathLibrary.LinearColorLerp(HighLightColor, LastColor, Alpha))
    end, true, 0.0, FunctionName, true)
  end
end

function M:StopPlayerPartHighLight(PartIdx)
  local FunctionName = "SetCharTintColor" .. PartIdx
  self.ArmoryHelper:RemoveTimer(FunctionName)
end

function M:ChangeWeaponAccessory(AccessoryId, AccessoryType)
  local function _ChangeWeaponAccessory(...)
    local function Func(WeaponActor)
      if nil == WeaponActor then
        return
      end
      WeaponActor:ChangeAccessory(AccessoryId, AccessoryType)
    end
    
    local WeaponActor = self:GetWeaponActor()
    if not WeaponActor then
      return
    end
    self.CurrentWeaponAppearanceInfo.AccessorySuit[CommonConst.WeaponAccessoryTypeIndex[AccessoryType]] = AccessoryId
    Func(WeaponActor)
    Func(self:GetReflectionActor(WeaponActor))
  end
  
  self:DoSomethingWithWeapon("ChangeWeaponAccessory", _ChangeWeaponAccessory)
end

function M:ChangePlayerWeaponAccessory(AccessoryId, AccessoryType)
  local function _ChangePlayerWeaponAccessory(...)
    local function Func(WeaponActor)
      if nil == WeaponActor then
        return
      end
      WeaponActor:ChangeAccessory(AccessoryId, AccessoryType)
    end
    
    local WeaponActor = self:GetWeaponActor()
    if not WeaponActor then
      return
    end
    self.CurrentWeaponAppearanceInfo.AccessoryId = AccessoryId
    Func(WeaponActor)
    Func(self:GetReflectionActor(WeaponActor))
  end
  
  self:DoSomethingWithWeapon("ChangePlayerWeaponAccessory", _ChangePlayerWeaponAccessory)
end

function M:ChangeWeaponColor(ColorInfo)
  local function _ChangeWeaponColor(...)
    local function Func(WeaponActor)
      if nil == WeaponActor then
        return
      end
      WeaponActor:InitWeaponBreakMI()
      WeaponActor:InitWeaponColor(ColorInfo)
    end
    
    local WeaponActor = self:GetWeaponActor()
    if not WeaponActor then
      return
    end
    self.CurrentWeaponAppearanceInfo.Colors = ColorInfo
    Func(WeaponActor)
    Func(self:GetReflectionActor(WeaponActor))
  end
  
  self:DoSomethingWithWeapon("ChangeWeaponColor", _ChangeWeaponColor)
end

function M:ChangeWeaponPartColor(PartIdx, Color)
  local function _ChangeWeaponPartColor()
    local function Func(WeaponActor)
      if nil == WeaponActor then
        return
      end
      WeaponActor:InitWeaponBreakMI()
      local FunctionName = "SetWPTintColor" .. PartIdx
      local Func = WeaponActor[FunctionName]
      if Func then
        Func(WeaponActor, Color)
      end
      if WeaponActor.ChildWeapon then
        Func = WeaponActor.ChildWeapon[FunctionName]
        if Func then
          Func(WeaponActor.ChildWeapon, Color)
        end
      end
    end
    
    local WeaponActor = self:GetWeaponActor()
    if not WeaponActor then
      return
    end
    Func(WeaponActor)
    Func(self:GetReflectionActor(WeaponActor))
  end
  
  self:DoSomethingWithWeapon("ChangeWeaponPartColor", _ChangeWeaponPartColor)
end

function M:ChangeWeaponSkin(SkinId)
  local function _ChangeWeaponSkin()
    local function Func(WeaponActor)
      if nil == WeaponActor then
        return
      end
      self.CurrentWeaponAppearanceInfo.SkinId = SkinId
      if SkinId == self.CurrentWeaponInfo.WeaponId then
        WeaponActor:InitWeaponSkin()
      else
        WeaponActor:InitWeaponSkin(SkinId)
      end
      WeaponActor:OnWeaponReady()
    end
    
    local WeaponActor = self:GetWeaponActor()
    Func(WeaponActor)
    Func(self:GetReflectionActor(WeaponActor))
  end
  
  self:DoSomethingWithWeapon("ChangeWeaponSkin", _ChangeWeaponSkin)
end

function M:ChangePlayerWeaponSkin(SkinId)
  local function _ChangePlayerWeaponSkin()
    local WeaponActor = self:GetPlayerWeaponActor()
    
    if WeaponActor then
      self.CurrentWeaponAppearanceInfo.SkinId = SkinId
      if SkinId == self.CurrentWeaponInfo.WeaponId then
        WeaponActor:InitWeaponSkin()
      else
        WeaponActor:InitWeaponSkin(SkinId)
      end
      WeaponActor:OnWeaponReady()
    end
  end
  
  self:DoSomethingWithWeapon("ChangePlayerWeaponSkin", _ChangePlayerWeaponSkin)
end

function M:ChangeWeaponAppearance(AppearanceInfo)
  local function _ChangeWeaponAppearance()
    self.CurrentWeaponAppearanceInfo = AppearanceInfo
    
    local function Func(WeaponActor)
      if nil == WeaponActor then
        return
      end
      WeaponActor:InitWeaponAppearance(AppearanceInfo)
      WeaponActor:OnWeaponReady()
    end
    
    local WeaponActor = self:GetWeaponActor()
    Func(WeaponActor)
    Func(self:GetReflectionActor(WeaponActor))
  end
  
  self:DoSomethingWithWeapon("ChangeWeaponAppearance", _ChangeWeaponAppearance)
end

function M:StartWeaponPartHighLight(LastColor, PartIdx, HighLightColor, Curve)
  local function _StartWeaponPartHighLight()
    local UsingWeapon = not self.ArmoryWeapon and self.ArmoryPlayer and self.ArmoryPlayer.UsingWeapon
    
    local FunctionName = "SetWPTintColor" .. PartIdx
    local Func = UsingWeapon[FunctionName]
    local _TickFrequency = 0.033
    local _, MaxTime = Curve:GetTimeRange()
    local PassedTime = 0
    local Alpha
    if Func then
      self.ArmoryHelper:AddTimer(_TickFrequency, function()
        PassedTime = PassedTime + _TickFrequency
        if PassedTime >= MaxTime then
          self:StopWeaponPartHighLight(PartIdx)
          self:ChangeWeaponPartColor(PartIdx, LastColor)
          return
        end
        Alpha = Curve:GetFloatValue(PassedTime)
        self:ChangeWeaponPartColor(PartIdx, UKismetMathLibrary.LinearColorLerp(HighLightColor, LastColor, Alpha))
      end, true, 0.0, FunctionName, true)
    end
  end
  
  self:DoSomethingWithWeapon("StartWeaponPartHighLight", _StartWeaponPartHighLight)
end

function M:StopWeaponPartHighLight(PartIdx)
  local FunctionName = "SetWPTintColor" .. PartIdx
  self.ArmoryHelper:RemoveTimer(FunctionName)
end

function M:OnWeaponBreakLevelUp(Ret, WeaponUuid, EnhanceLevel)
  if Ret ~= ErrorCode.RET_SUCCESS then
    return
  end
  if not self.CurrentWeaponInfo or WeaponUuid ~= self.CurrentWeaponInfo.Uuid then
    return
  end
  self:SetWeaponActorEnhanceLevel(EnhanceLevel)
end

function M:SetWeaponActorEnhanceLevel(EnhanceLevel)
  if not self:GetWeaponActor() then
    return
  end
  local ColorInfo = self.CurrentWeaponInfo:DumpColors()
  
  local function SetWeaponActorEnhanceLevelInternal(WeaponActor)
    if nil == WeaponActor then
      return
    end
    WeaponActor:SetAttr("EnhanceLevel", EnhanceLevel)
    WeaponActor:InitWeaponBreakMI()
    WeaponActor:InitWeaponColor(ColorInfo)
  end
  
  local Actor = self:GetWeaponActor()
  SetWeaponActorEnhanceLevelInternal(Actor)
  SetWeaponActorEnhanceLevelInternal(self:GetReflectionActor(Actor))
end

function M:SkinWeaponVFX(ColorData)
  local ArmoryPlayer = self.ArmoryPlayer
  self.SkinWeaponVFXHandle = ArmoryPlayer.FXComponent:PlayEffectByIDParams(306, {bTickEvenWhenPaused = true, NotAttached = true})
  local Color = FLinearColor(ColorData.R, ColorData.G, ColorData.B)
  self.SkinWeaponVFXHandle:SetVariableLinearColor("Color", Color)
end

function M:StopSkinWeaponVFX()
  if self.SkinWeaponVFXHandle and self.SkinWeaponVFXHandle:IsValid() then
    local name = self.SkinWeaponVFXHandle:GetName()
    self.SkinWeaponVFXHandle:Deactivate()
    self.SkinWeaponVFXHandle = nil
  end
end

function M:ChangeSkinWeaponVFXColor(ColorData)
  if self.SkinWeaponVFXHandle and self.SkinWeaponVFXHandle:IsValid() then
    local Color = FLinearColor(ColorData.R, ColorData.G, ColorData.B)
    self.SkinWeaponVFXHandle:SetVariableLinearColor("Color", Color)
  end
end

function M:Component_OnDestruct()
  EventManager:RemoveEvent(EventID.OnCharGradeLevelUp, self)
  EventManager:RemoveEvent(EventID.OnWeaponBreakLevelUp, self)
end

function M:Component_DestroyActors()
  self:TryDestroySequenceActorController()
end

return M
