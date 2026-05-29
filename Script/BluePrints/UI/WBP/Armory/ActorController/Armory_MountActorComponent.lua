local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = {}

function M:Init(Params)
end

function M:_ResetMountPreviewTransitionState()
  if not self.bWatingForDelayFrame and not self.DisappearFXPlaying and not self.LTweenHandle_PlayDisappearFX then
    return
  end
  self:CancelPendingDelayFramePreview()
  self:HidePlayerActor("ActorController_PlayDisappearFX", false)
  self:HidePlayerAndMount(false)
end

function M:CreateMount(MountId)
  local Player = self:GetPlayerActor()
  if not Player then
    return
  end
  self:_ResetMountPreviewTransitionState()
  local MountConfig = DataMgr.Mount[MountId]
  if not MountConfig.BattleMountId then
    return
  end
  if not Player.OriginalScale3D then
    Player.OriginalScale3D = Player:GetActorScale3D()
  end
  if MountConfig.MountDisplayScale then
    Player:SetActorScale3D(FVector(MountConfig.MountDisplayScale, MountConfig.MountDisplayScale, MountConfig.MountDisplayScale))
  else
    Player:SetActorScale3D(Const.OneVector)
  end
  if not Player.OriginalLocation then
    Player.OriginalLocation = Player:K2_GetActorLocation()
  end
  if MountConfig.MountLocOffset then
    local OffsetX = MountConfig.MountLocOffset[1] and MountConfig.MountLocOffset[1] or 0
    local OffsetY = MountConfig.MountLocOffset[2] and MountConfig.MountLocOffset[2] or 0
    local OffsetZ = MountConfig.MountLocOffset[3] and MountConfig.MountLocOffset[3] or 0
    local Offset = FVector(OffsetX, OffsetY, OffsetZ)
    Player:K2_SetActorLocation(Player.OriginalLocation + Offset, false, nil, false)
  else
    Player:K2_SetActorLocation(Player.OriginalLocation, false, nil, false)
  end
  self.CurRiddingMount = MountId
  Player:EnableBattleMountOnDisplay(MountConfig.BattleMountId)
  self:PlayMountMontageOnDisplay()
  self:HidePlayerActorInternal(self:GetReflectionActor(Player), "ReflectionHideByMount", true)
  self.bEnableReflectionBeforeMount = self.bEnableReflection
  self.bEnableReflection = false
end

function M:RefreshMount()
  if not self.CurRiddingMount then
    return
  end
  local Player = self:GetPlayerActor()
  if not Player then
    return
  end
  local MountConfig = DataMgr.Mount[self.CurRiddingMount]
  Player:EnableBattleMountOnDisplay(MountConfig.BattleMountId)
end

function M:PlayMountMontageOnDisplay()
  if not self.ArmoryPlayer then
    return
  end
  local ArmoryPlayer = self.ArmoryPlayer
  self.DelayFrame = 30
  if self.DelayFrame and self.DelayFrame > 0 then
    self:HidePlayerAndMount(true)
    self:PlayDisappearFX(ArmoryPlayer.FXComponent, function()
      if self.bClosed or self.bDestructed or not self.IsControled then
        self:HidePlayerAndMount(false)
        return
      end
      self:PlayAppearFX(ArmoryPlayer.FXComponent)
      self:HidePlayerAndMount(false)
      self:PlayMountMontage()
      if self.LastDelayCameraTags then
        self:SetArmoryCameraTag(table.unpack(self.LastDelayCameraTags))
      end
    end)
  else
    self:PlayMountMontage()
  end
end

function M:PlayMountMontage()
  local Player = self:GetPlayerActor()
  if not Player or not Player.CurMount then
    return
  end
  local MountId = self.CurRiddingMount
  local MountConfig = MountId and DataMgr.Mount[MountId]
  if not MountConfig then
    MountId = Player.CurMount.UnitId
    MountConfig = DataMgr.Mount[MountId]
  end
  if not MountConfig then
    return
  end
  local MontagePath = MountConfig.AnimPath
  if not MontagePath then
    return
  end
  Player.CurMount:PlayMontageByPath(MontagePath)
end

function M:HidePlayerOnMount(IsHide)
  local Player = self:GetPlayerActor()
  if not Player then
    return
  end
  self:HidePlayerActorOnDisplayMount("ActorController_HidePlayerBeforeMount", IsHide)
end

function M:HidePlayerAndMount(IsHide)
  self:HidePlayerActorOnDisplayMount("ActorController_HidePlayerPlayMount", IsHide)
  local Player = self:GetPlayerActor()
  if Player and Player.CurMount then
    Player.CurMount:SetActorHideTag("ActorController_HidePlayerPlayMount", IsHide)
  end
end

function M:HidePlayerActorOnDisplayMount(Tag, IsHidden, bDontSaveTag)
  if not IsValid(self.ArmoryPlayer) then
    return
  end
  local bIsMountPreviewTempTag = "ActorController_HidePlayerPlayMount" == Tag or "ActorController_HidePlayerBeforeMount" == Tag
  if not bDontSaveTag and not bIsMountPreviewTempTag then
    if true == IsHidden then
      self.PlayerActorHideTags[Tag] = true
    else
      self.PlayerActorHideTags[Tag] = nil
    end
  end
  self.ArmoryPlayer:SetActorHideTag(Tag, IsHidden, true, false)
  self.ArmoryPlayer:HideAllEffectCreature(Tag, IsHidden)
end

function M:GetArmoryPlayerRotation()
  local Player = self:GetPlayerActor()
  if not Player then
    return
  end
  return Player:K2_GetActorRotation()
end

function M:SetArmoryPlayerRotation(PlayerRot)
  if not PlayerRot then
    return
  end
  local Player = self:GetPlayerActor()
  if not Player then
    return
  end
  return Player:K2_SetActorRotation(PlayerRot, false, nil, false)
end

function M:Component_OnClosed()
  self:HidePlayerAndMount(false)
  self:DestroyMount()
end

function M:DestroyMount()
  local Player = self:GetPlayerActor()
  if not Player then
    return
  end
  self:HidePlayerAndMount(false)
  if self.CurRiddingMount or Player.CurMount then
    Player:DisableBattleMount(true)
  end
  if Player.OriginalLocation then
    Player:K2_SetActorLocation(Player.OriginalLocation, false, nil, false)
    Player.OriginalLocation = nil
  end
  if Player.OriginalScale3D then
    Player:SetActorScale3D(Player.OriginalScale3D)
    Player.OriginalScale3D = nil
  else
    Player:SetActorScale3D(Const.OneVector)
  end
  self.CurRiddingMount = nil
  if nil ~= self.bEnableReflectionBeforeMount then
    self.bEnableReflection = self.bEnableReflectionBeforeMount
  end
  self:HidePlayerActorInternal(self:GetReflectionActor(Player), "ReflectionHideByMount", false)
end

function M:GetMountActor()
  local Player = self:GetPlayerActor()
  if not Player then
    return nil
  end
  return Player.CurMount
end

function M:ChangeMountSkinColor(Colors)
  local MountActor = self:GetMountActor()
  if not MountActor then
    return
  end
  if MountActor.CharacterFashion then
    MountActor.CharacterFashion:InitSkinColors(Colors)
  elseif MountActor.InitMountColors then
    MountActor:InitMountColors(Colors)
  end
end

function M:ChangeMountPartColor(PartIdx, Color, Fresnel)
  local MountActor = self:GetMountActor()
  if not MountActor then
    return
  end
  local CharacterFashion = MountActor.CharacterFashion
  if CharacterFashion and CharacterFashion.ChangePartColor then
    CharacterFashion:ChangePartColor(PartIdx, Color, Fresnel)
  elseif MountActor.ChangeMountPartColor then
    MountActor:ChangeMountPartColor(PartIdx, Color, Fresnel)
  else
    local FunctionName = "SetMountTintColor" .. PartIdx
    local Func = MountActor[FunctionName]
    if Func then
      Func(MountActor, Color)
      if Fresnel then
        local FresnelFunctionName = "SetMountFresnel" .. PartIdx
        local FresnelFunc = MountActor[FresnelFunctionName]
        if FresnelFunc then
          FresnelFunc(MountActor, Fresnel)
        end
      end
    end
  end
end

function M:StartMountPartHighLight(LastColor, PartIdx, HighLightColor, Curve)
  local MountActor = self:GetMountActor()
  if not MountActor then
    return
  end
  local FunctionName = "SetMountTintColor" .. PartIdx
  local Func = MountActor[FunctionName]
  if not Func then
    local CharacterFashion = MountActor.CharacterFashion
    if CharacterFashion then
      Func = CharacterFashion[FunctionName]
    end
  end
  if not Func then
    return
  end
  local _TickFrequency = 0.033
  local _, MaxTime = Curve:GetTimeRange()
  local PassedTime = 0
  local Alpha
  self.ArmoryHelper:AddTimer(_TickFrequency, function()
    PassedTime = PassedTime + _TickFrequency
    if PassedTime >= MaxTime then
      self:StopMountPartHighLight(PartIdx)
      self:ChangeMountPartColor(PartIdx, LastColor)
      return
    end
    Alpha = Curve:GetFloatValue(PassedTime)
    local LerpedColor = UKismetMathLibrary.LinearColorLerp(HighLightColor, LastColor, Alpha)
    self:ChangeMountPartColor(PartIdx, LerpedColor)
  end, true, 0.0, FunctionName, true)
end

function M:StopMountPartHighLight(PartIdx)
  local FunctionName = "SetMountTintColor" .. PartIdx
  self.ArmoryHelper:RemoveTimer(FunctionName)
end

return M
