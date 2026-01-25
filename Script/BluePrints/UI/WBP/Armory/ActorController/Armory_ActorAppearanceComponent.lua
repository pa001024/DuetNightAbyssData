local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = {}

function M:Init(Params)
  EventManager:AddEvent(EventID.OnCharGradeLevelUp, self, self.OnCharGradeLevelUp)
  EventManager:AddEvent(EventID.OnWeaponBreakLevelUp, self, self.OnWeaponBreakLevelUp)
end

function M:OnCharGradeLevelUp(Ret, CharUuid, CurrentGradeLevel)
  if self.CurrentCharInfo and self.CurrentCharInfo.Uuid == CharUuid then
    local Avatar = self:GetAvatar()
    local Char = Avatar.Chars[CharUuid]
    if Char and self.ArmoryPlayer and self.ArmoryPlayer.CharacterFashion then
      self.ArmoryPlayer.CharacterFashion:GradeUpEmissive(Char.GradeLevel)
      if self.ArmoryPlayer.InfoForInit then
        self.ArmoryPlayer.InfoForInit.GradeLevel = Char.GradeLevel
      end
    end
  end
end

function M:ChangeCharAppearance(AppearanceInfo)
  if not self.ArmoryPlayer or not self.ArmoryPlayer.CharacterFashion then
    return
  end
  self.CurrentAppearanceInfo = AppearanceInfo
  self.ArmoryPlayer.CharacterFashion:InitAppearanceSuit(AppearanceInfo)
end

function M:GetSkinPartMeshInfo(SkinId)
  if not SkinId then
    return
  end
  for AccessoryId, value in pairs(DataMgr.CharPartMesh) do
    if value.PartName == "PartMesh" then
      local SkinIds = value.Skin or {}
      for _, Id in pairs(SkinIds) do
        if Id == SkinId then
          return AccessoryId, value.AccessoryType
        end
      end
    end
  end
end

function M:ChangeCharSkin(SkinId)
  if not self.ArmoryPlayer then
    return
  end
  self.CurrentAppearanceInfo.SkinId = SkinId
  self.ArmoryPlayer:ChangeSkinModel(SkinId)
  if self.ArmoryPlayer.PlayerAnimInstance then
    self.ArmoryPlayer.PlayerAnimInstance:SetKawiiLayerState(EKawaiiLayerState.EKLS_Armory)
  end
end

function M:ShowPartMesh(IsShowPartMesh)
  if not self.ArmoryPlayer then
    return
  end
  if self.ArmoryPlayer.PartsMesh then
    self.CurrentAppearanceInfo.IsShowPartMesh = IsShowPartMesh
    self.ArmoryPlayer.PartsMesh:SetVisibility(IsShowPartMesh, IsShowPartMesh)
  end
end

function M:ChangeCharSkinColor(Colors)
  if not self.ArmoryPlayer or not self.ArmoryPlayer.CharacterFashion then
    return
  end
  self.CurrentAppearanceInfo.Colors = Colors
  self.ArmoryPlayer.CharacterFashion:InitSkinColors(Colors)
end

function M:ChangeCharPartColor(PartIdx, Color, Fresnel)
  local CharacterFashion = self.ArmoryPlayer and self.ArmoryPlayer.CharacterFashion
  if not CharacterFashion then
    return
  end
  CharacterFashion:ChangePartColor(PartIdx, Color, Fresnel)
end

function M:ChangeCharAccessory(AccessoryId, AccessoryType)
  if not self.ArmoryPlayer then
    return
  end
  self.ArmoryPlayer.CharacterFashion:ChangeAccessory(AccessoryId, AccessoryType)
end

local ShowFXAccessoryPrefix = "ShowFXAccessory_"
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_Dead] = function(self, Player, AccessoryId, AccessoryType)
  local Data = DataMgr.CharAccessory[AccessoryId]
  local CreatureKey = AccessoryType
  self:DestoryCreature(CreatureKey)
  local CreatureId = Data and Data.CreatureId or 14001
  Player:AsyncCreateEffectCreatureWithCallBack(CreatureId, FTransform(FRotator(0, 0, 180), FVector(0, 0, 0), FVector(1)), true, "Root", {
    Execute = function(_, Creature)
      self:DestoryCreature(CreatureKey)
      Creature:SetActorHiddenInGame(false)
      self.Creatures[CreatureKey] = Creature
    end
  })
end
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_Footprint] = function(self, Player, AccessoryId, AccessoryType)
  local Data = DataMgr.CharAccessory[AccessoryId]
  local FXId = Data and Data.VisualEffectId
  if not FXId then
    return
  end
  local Loc = Player:K2_GetActorLocation()
  Loc.Z = Loc.Z - Player.CapsuleComponent:GetScaledCapsuleHalfHeight() - 2.4
  self.PlayerFXTimerKeys.PlayFootprintFXLoop = true
  Player.FXComponent:PlayEffectByIDParams(FXId, {
    bTickEvenWhenPaused = true,
    UseAbsoluteLocation = true,
    Location = {
      Loc.X,
      Loc.Y,
      Loc.Z
    }
  })
  self.ViewUI:AddTimer(1, function()
    Player.FXComponent:PlayEffectByIDParams(FXId, {
      bTickEvenWhenPaused = true,
      UseAbsoluteLocation = true,
      Location = {
        Loc.X,
        Loc.Y,
        Loc.Z
      }
    })
  end, true, 0, "PlayFootprintFXLoop", true)
end
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_Teleport] = function(self, Player, AccessoryId, AccessoryType)
  local Data = DataMgr.CharAccessory[AccessoryId]
  local MontagePath = Data and Data.Montage or "Teleport_01_Montage"
  Player:PlayActionMontage("Interactive/MechInteractive", MontagePath, {
    OnNotifyBegin = function()
      Player.PlayerAnimInstance:Montage_Pause()
      self:HidePlayerActor(self.UIName, true)
      self.PlayerMontageTimerKeys.PlayTeleportMontage = true
      self.ViewUI:AddTimer(1, function()
        Player:PlayActionMontage("Interactive/MechInteractive", MontagePath, {}, false, true, false)
        Player.PlayerAnimInstance:Montage_JumpToSection("End")
        self:HidePlayerActor(self.UIName, false)
      end, false, 0.0, "PlayTeleportMontage", true)
    end,
    OnInterrupted = function()
      self:HidePlayerActor(self.UIName, false)
    end
  }, false, true, true)
end
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_PlungingATK] = function(self, Player, AccessoryId, AccessoryType)
  self:ChangeCharAccessory(AccessoryId, AccessoryType)
  local Avatar = GWorld:GetAvatar()
  local WeaponData = Avatar.Weapons[Avatar.MeleeWeapon]
  self:ChangePlayerWeapon(WeaponData, Player)
  Player:SetArmoryTag(Const.ArmoryWeaponIdleTags.Armory_FallAttack)
end
M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_HelixLeap] = function(self, Player, AccessoryId, AccessoryType)
  self:ChangeCharAccessory(AccessoryId, AccessoryType)
  Player:SetArmoryTag(Const.ArmoryIdleTags.Armory_BullutJump)
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

function M:StartPlayerPartHighLight(LastColor, PartIdx, HighLightColor, Curve)
  local CharacterFashion = self.ArmoryPlayer and self.ArmoryPlayer.CharacterFashion
  local FunctionName = "SetCharTintColor" .. PartIdx
  local Func = CharacterFashion[FunctionName]
  local _TickFrequency = 0.033
  local _, MaxTime = Curve:GetTimeRange()
  local PassedTime = 0
  local Alpha
  if Func then
    self.ViewUI:AddTimer(_TickFrequency, function()
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
  self.ViewUI:RemoveTimer(FunctionName)
end

function M:ChangeWeaponAccessory(AccessoryId)
  local function _ChangeWeaponAccessory(...)
    local WeaponActor = self:GetWeaponActor()
    
    if WeaponActor then
      self.CurrentWeaponAppearanceInfo.AccessoryId = AccessoryId
      WeaponActor:ChangeAccessory(AccessoryId)
    end
  end
  
  self:DoSomethingWithWeapon("ChangeWeaponAccessory", _ChangeWeaponAccessory)
end

function M:ChangePlayerWeaponAccessory(AccessoryId)
  local function _ChangePlayerWeaponAccessory(...)
    local WeaponActor = self:GetPlayerWeaponActor()
    
    if WeaponActor then
      self.CurrentWeaponAppearanceInfo.AccessoryId = AccessoryId
      WeaponActor:ChangeAccessory(AccessoryId)
    end
  end
  
  self:DoSomethingWithWeapon("ChangePlayerWeaponAccessory", _ChangePlayerWeaponAccessory)
end

function M:ChangeWeaponColor(ColorInfo)
  local function _ChangeWeaponColor(...)
    local WeaponActor = self:GetWeaponActor()
    
    if WeaponActor then
      self.CurrentWeaponAppearanceInfo.Colors = ColorInfo
      WeaponActor:InitWeaponBreakMI()
      WeaponActor:InitWeaponColor(ColorInfo)
    end
  end
  
  self:DoSomethingWithWeapon("ChangeWeaponColor", _ChangeWeaponColor)
end

function M:ChangeWeaponPartColor(PartIdx, Color)
  local function _ChangeWeaponPartColor()
    local UsingWeapon = self:GetWeaponActor()
    
    if not UsingWeapon then
      return
    end
    UsingWeapon:InitWeaponBreakMI()
    local FunctionName = "SetWPTintColor" .. PartIdx
    local Func = UsingWeapon[FunctionName]
    if Func then
      Func(UsingWeapon, Color)
    end
    if UsingWeapon.ChildWeapon then
      Func = UsingWeapon.ChildWeapon[FunctionName]
      if Func then
        Func(UsingWeapon.ChildWeapon, Color)
      end
    end
  end
  
  self:DoSomethingWithWeapon("ChangeWeaponPartColor", _ChangeWeaponPartColor)
end

function M:ChangeWeaponSkin(SkinId)
  local function _ChangeWeaponSkin()
    local WeaponActor = self:GetWeaponActor()
    
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
    local WeaponActor = self:GetWeaponActor()
    
    if WeaponActor then
      self.CurrentWeaponAppearanceInfo = AppearanceInfo
      WeaponActor:InitWeaponAppearance(AppearanceInfo)
      WeaponActor:OnWeaponReady()
    end
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
      self.ViewUI:AddTimer(_TickFrequency, function()
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
  self.ViewUI:RemoveTimer(FunctionName)
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
  local WeaponActor = self:GetWeaponActor()
  if not WeaponActor then
    return
  end
  WeaponActor:SetAttr("EnhanceLevel", EnhanceLevel)
  WeaponActor:InitWeaponBreakMI()
  local ColorInfo = self.CurrentWeaponInfo:DumpColors()
  WeaponActor:InitWeaponColor(ColorInfo)
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

return M
