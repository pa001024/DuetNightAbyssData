require("UnLua")
local M = Class("BluePrints.Item.MiniGame.BP_OpenUIMechanism_C")
local OUTER_RING, INNER_RING = 1, 2
local SUCCESS_NONE, SUCCESS_MAIN, SUCCESS_EXTRA = 0, 1, 2

local function NormalizeRingType(Value)
  if Value == INNER_RING then
    return INNER_RING
  end
  return OUTER_RING
end

local function NormalizeDirection(Value)
  if -1 == Value then
    return -1
  end
  return 1
end

local function NormalizeAngleIndex(Value)
  return ((tonumber(Value) or 0) % 6 + 6) % 6
end

local function BuildEmptyConfig()
  return {
    KeyList = {},
    KeyMap = {},
    ClueList = {},
    SuccessCombos = {},
    EnableCrack = false
  }
end

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self.UIName = "DoubleCompass"
  self:ResetDoubleCompassRuntime()
end

function M:OpenUI(PlayerEid, NextStateId)
  self.DoubleCompassPlayerEid = PlayerEid
  self:ResetDoubleCompassRuntime()
  self.ExtraInfo = self:GetDoubleCompassOpenInfo()
  M.Super.OpenUI(self, PlayerEid, NextStateId)
end

function M:CloseMechanism(PlayerId, IsSuccess)
  self.DoubleCompassUI = nil
  M.Super.CloseMechanism(self, PlayerId, IsSuccess)
end

function M:ForceCloseMechanism(PlayerEid)
  self.bDoubleCompassInputLocked = true
  if self.CurrentUI then
    self.CurrentUI:Close()
  end
  self:FinishDoubleCompass(PlayerEid, false)
end

function M:ResetDoubleCompassRuntime()
  self.DoubleCompassSelectedRing = OUTER_RING
  self.DoubleCompassOuterAngleIndex = 0
  self.DoubleCompassInnerAngleIndex = 0
  self.DoubleCompassOuterKeyId = 0
  self.DoubleCompassInnerKeyId = 0
  self.DoubleCompassSelectedKeyId = 0
  self.DoubleCompassPendingRing = OUTER_RING
  self.DoubleCompassPendingKeyId = 0
  self.DoubleCompassSuccessType = SUCCESS_NONE
  self.DoubleCompassLastTipType = "None"
  self.bDoubleCompassInputLocked = false
  self.bDoubleCompassInsertPlaying = false
  self.bDoubleCompassMainSuccess = false
  self.bDoubleCompassExtraSuccess = false
  self.bIsSuccess = false
  self.DoubleCompassConfig = BuildEmptyConfig()
  self:RefreshDoubleCompassBlueprintState()
end

function M:GetDoubleCompassOpenInfo()
  return {
    UseActor = self,
    ViewState = self:GetDoubleCompassViewState()
  }
end

function M:GetDoubleCompassViewState()
  return {
    SelectedRing = self.DoubleCompassSelectedRing,
    OuterAngleIndex = self.DoubleCompassOuterAngleIndex,
    InnerAngleIndex = self.DoubleCompassInnerAngleIndex,
    OuterKeyId = self.DoubleCompassOuterKeyId,
    InnerKeyId = self.DoubleCompassInnerKeyId,
    SelectedKeyId = self.DoubleCompassSelectedKeyId,
    PendingRing = self.DoubleCompassPendingRing,
    PendingKeyId = self.DoubleCompassPendingKeyId,
    SuccessType = self.DoubleCompassSuccessType,
    LastTipType = self.DoubleCompassLastTipType,
    bInputLocked = self.bDoubleCompassInputLocked,
    bInsertPlaying = self.bDoubleCompassInsertPlaying,
    bCanRotateOuter = 0 ~= self.DoubleCompassOuterKeyId and not self.bDoubleCompassInputLocked,
    bCanRotateInner = 0 ~= self.DoubleCompassInnerKeyId and not self.bDoubleCompassInputLocked,
    bCanConfirmKey = self:CanConfirmSelectedKey(),
    bCanCrack = self:CanDoubleCompassCrack(),
    KeyList = self.DoubleCompassConfig and self.DoubleCompassConfig.KeyList or nil,
    ClueList = self.DoubleCompassConfig and self.DoubleCompassConfig.ClueList or nil
  }
end

function M:OnDoubleCompassSelectRing(InRingType)
  if self:IsDoubleCompassInputLocked() then
    return false
  end
  self.DoubleCompassSelectedRing = NormalizeRingType(InRingType)
  self:CallDoubleCompassBlueprintEvent("BP_SetSelectedRing", self.DoubleCompassSelectedRing)
  self:NotifyDoubleCompassUIState()
  return true
end

function M:OnDoubleCompassRotate(InDirection)
  if self:IsDoubleCompassInputLocked() then
    return false
  end
  local CurrentRingType = NormalizeRingType(self.DoubleCompassSelectedRing)
  if 0 == self:GetRingKeyId(CurrentRingType) then
    self:SetDoubleCompassTip("NeedKeyBeforeRotate")
    self:CallDoubleCompassBlueprintEvent("BP_PlayError")
    return false
  end
  local RealDirection = NormalizeDirection(InDirection)
  local NextAngleIndex = NormalizeAngleIndex(self:GetRingAngleIndex(CurrentRingType) + RealDirection)
  self:SetRingAngleIndex(CurrentRingType, NextAngleIndex)
  self:CallDoubleCompassBlueprintEvent("BP_PlayRotateRing", CurrentRingType, RealDirection)
  self:CallDoubleCompassBlueprintEvent("BP_SetRingIndex", CurrentRingType, NextAngleIndex)
  self:NotifyDoubleCompassUIState()
  return self:CheckDoubleCompassResult()
end

function M:OnDoubleCompassOpenKeyPanel()
  if self:IsDoubleCompassInputLocked() then
    return false
  end
  self:NotifyDoubleCompassUIState()
  return true
end

function M:OnDoubleCompassSelectKey(KeyId)
  if self:IsDoubleCompassInputLocked() then
    return false
  end
  self.DoubleCompassSelectedKeyId = tonumber(KeyId) or 0
  self:NotifyDoubleCompassUIState()
  return true
end

function M:OnDoubleCompassConfirmKey()
  if self:IsDoubleCompassInputLocked() then
    return false
  end
  local KeyId = tonumber(self.DoubleCompassSelectedKeyId) or 0
  if 0 == KeyId or not self:GetKeyConfig(KeyId) then
    self:SetDoubleCompassTip("KeyInvalid")
    self:CallDoubleCompassBlueprintEvent("BP_PlayError")
    return false
  end
  if self:IsKeyUsedByOtherRing(KeyId, self.DoubleCompassSelectedRing) then
    self:SetDoubleCompassTip("KeyUsed")
    self:CallDoubleCompassBlueprintEvent("BP_PlayError")
    return false
  end
  return self:StartDoubleCompassInsertAttempt(self.DoubleCompassSelectedRing, KeyId)
end

function M:OnDoubleCompassRemoveKey()
  if self:IsDoubleCompassInputLocked() then
    return false
  end
  local CurrentRingType = NormalizeRingType(self.DoubleCompassSelectedRing)
  self:SetRingKeyId(CurrentRingType, 0)
  self:CallDoubleCompassBlueprintEvent("BP_PlayRemoveKey", CurrentRingType)
  self:CallDoubleCompassBlueprintEvent("BP_SetInsertedKey", CurrentRingType, 0)
  self:NotifyDoubleCompassUIState()
  return true
end

function M:OnDoubleCompassCancel()
  local PlayerEid = self.DoubleCompassPlayerEid or 0
  self:FinishDoubleCompass(PlayerEid, false)
  return true
end

function M:OnDoubleCompassCrack()
  if self:IsDoubleCompassInputLocked() or not self:CanDoubleCompassCrack() then
    return false
  end
  return self:HandleDoubleCompassSuccess(SUCCESS_MAIN)
end

function M:OnDoubleCompassEndPresentationFinished()
  local PlayerEid = self.DoubleCompassPlayerEid or 0
  self:FinishDoubleCompass(PlayerEid, self.DoubleCompassSuccessType ~= SUCCESS_NONE)
end

function M:OnDoubleCompassInsertPresentationFinished()
  if not self.bDoubleCompassInsertPlaying then
    return false
  end
  return self:FinishDoubleCompassInsertAttempt()
end

function M:IsDoubleCompassInputLocked()
  if self.bDoubleCompassInputLocked then
    self:SetDoubleCompassTip("InputLocked")
    return true
  end
  return false
end

function M:CanDoubleCompassCrack()
  return self.DoubleCompassConfig and self.DoubleCompassConfig.EnableCrack == true
end

function M:CanConfirmSelectedKey()
  local KeyId = tonumber(self.DoubleCompassSelectedKeyId) or 0
  if 0 == KeyId then
    return false
  end
  return self:GetKeyConfig(KeyId) ~= nil and not self:IsKeyUsedByOtherRing(KeyId, self.DoubleCompassSelectedRing)
end

function M:GetRingAngleIndex(InRingType)
  if NormalizeRingType(InRingType) == INNER_RING then
    return self.DoubleCompassInnerAngleIndex or 0
  end
  return self.DoubleCompassOuterAngleIndex or 0
end

function M:SetRingAngleIndex(InRingType, AngleIndex)
  if NormalizeRingType(InRingType) == INNER_RING then
    self.DoubleCompassInnerAngleIndex = NormalizeAngleIndex(AngleIndex)
    return
  end
  self.DoubleCompassOuterAngleIndex = NormalizeAngleIndex(AngleIndex)
end

function M:GetRingKeyId(InRingType)
  if NormalizeRingType(InRingType) == INNER_RING then
    return self.DoubleCompassInnerKeyId or 0
  end
  return self.DoubleCompassOuterKeyId or 0
end

function M:SetRingKeyId(InRingType, KeyId)
  if NormalizeRingType(InRingType) == INNER_RING then
    self.DoubleCompassInnerKeyId = tonumber(KeyId) or 0
    return
  end
  self.DoubleCompassOuterKeyId = tonumber(KeyId) or 0
end

function M:StartDoubleCompassInsertAttempt(InRingType, KeyId)
  self.DoubleCompassPendingRing = NormalizeRingType(InRingType)
  self.DoubleCompassPendingKeyId = tonumber(KeyId) or 0
  self.bDoubleCompassInputLocked = true
  self.bDoubleCompassInsertPlaying = true
  self:SetDoubleCompassTip("None")
  self:CallDoubleCompassBlueprintEvent("BP_SetInsertedKey", self.DoubleCompassPendingRing, self.DoubleCompassPendingKeyId)
  local bUseBlueprintPresentation = self:CallDoubleCompassBlueprintEvent("BP_PlayInsertKey", self.DoubleCompassPendingRing, self.DoubleCompassPendingKeyId)
  self:NotifyDoubleCompassUIState()
  if not bUseBlueprintPresentation then
    return self:FinishDoubleCompassInsertAttempt()
  end
  return true
end

function M:FinishDoubleCompassInsertAttempt()
  local Ring = NormalizeRingType(self.DoubleCompassPendingRing)
  local KeyId = tonumber(self.DoubleCompassPendingKeyId) or 0
  local bKeyMatched = self:CanKeyUseForRing(KeyId, Ring)
  self.bDoubleCompassInsertPlaying = false
  self.bDoubleCompassInputLocked = false
  if bKeyMatched then
    self:SetRingKeyId(Ring, KeyId)
    self:SetDoubleCompassTip("KeyInserted")
    self:CallDoubleCompassBlueprintEvent("BP_PlayInsertSuccess", Ring, KeyId)
    self:CallDoubleCompassBlueprintEvent("BP_SetInsertedKey", Ring, KeyId)
    self:ClearDoubleCompassPendingInsert()
    self:NotifyDoubleCompassUIState()
    return self:CheckDoubleCompassResult()
  end
  self:SetDoubleCompassTip("KeyNotMatch")
  self:CallDoubleCompassBlueprintEvent("BP_PlayInsertFail", Ring, KeyId)
  self:CallDoubleCompassBlueprintEvent("BP_SetInsertedKey", Ring, 0)
  self:ClearDoubleCompassPendingInsert()
  self:NotifyDoubleCompassUIState()
  return false
end

function M:ClearDoubleCompassPendingInsert()
  self.DoubleCompassPendingRing = self.DoubleCompassSelectedRing
  self.DoubleCompassPendingKeyId = 0
end

function M:GetKeyConfig(KeyId)
  if not self.DoubleCompassConfig or not self.DoubleCompassConfig.KeyMap then
    return nil
  end
  return self.DoubleCompassConfig.KeyMap[KeyId]
end

function M:IsKeyUsedByOtherRing(KeyId, InRingType)
  local CurrentRingType = NormalizeRingType(InRingType)
  return CurrentRingType ~= OUTER_RING and self.DoubleCompassOuterKeyId == KeyId or CurrentRingType ~= INNER_RING and self.DoubleCompassInnerKeyId == KeyId
end

function M:CanKeyUseForRing(KeyId, InRingType)
  local KeyConfig = self:GetKeyConfig(KeyId)
  if not KeyConfig then
    return false
  end
  local CurrentRingType = NormalizeRingType(InRingType)
  if KeyConfig.RingType then
    return NormalizeRingType(KeyConfig.RingType) == CurrentRingType
  end
  if KeyConfig.RingTypes then
    for _, ConfigRingType in pairs(KeyConfig.RingTypes) do
      if NormalizeRingType(ConfigRingType) == CurrentRingType then
        return true
      end
    end
    return false
  end
  return true
end

function M:CheckDoubleCompassResult()
  if not self.DoubleCompassConfig or not self.DoubleCompassConfig.SuccessCombos then
    self:SetDoubleCompassTip("ConfigMissing")
    return false
  end
  for _, Combo in pairs(self.DoubleCompassConfig.SuccessCombos) do
    if self:IsDoubleCompassComboMatched(Combo) then
      return self:HandleDoubleCompassSuccess(Combo.SuccessType or SUCCESS_MAIN)
    end
  end
  return false
end

function M:IsDoubleCompassComboMatched(Combo)
  if not Combo then
    return false
  end
  return NormalizeAngleIndex(Combo.OuterAngleIndex) == self.DoubleCompassOuterAngleIndex and (tonumber(Combo.OuterKeyId) or 0) == self.DoubleCompassOuterKeyId and NormalizeAngleIndex(Combo.InnerAngleIndex) == self.DoubleCompassInnerAngleIndex and (tonumber(Combo.InnerKeyId) or 0) == self.DoubleCompassInnerKeyId
end

function M:HandleDoubleCompassSuccess(InSuccessType)
  if self.DoubleCompassSuccessType ~= SUCCESS_NONE then
    return true
  end
  self.DoubleCompassSuccessType = tonumber(InSuccessType) or SUCCESS_MAIN
  self.bDoubleCompassInputLocked = true
  self.bIsSuccess = true
  self.bDoubleCompassMainSuccess = self.DoubleCompassSuccessType == SUCCESS_MAIN
  self.bDoubleCompassExtraSuccess = self.DoubleCompassSuccessType == SUCCESS_EXTRA
  self:CallDoubleCompassBlueprintEvent("BP_PlayUnlock", self.DoubleCompassSuccessType)
  self:NotifyDoubleCompassUI("ShowDoubleCompassGameEnd", true, self.DoubleCompassSuccessType)
  self:NotifyDoubleCompassUIState()
  return true
end

function M:FinishDoubleCompass(PlayerEid, bSuccess)
  local Player = self:GetDoubleCompassPlayer(PlayerEid)
  if not Player then
    return false
  end
  self.bDoubleCompassInputLocked = true
  if bSuccess then
    self:SyncDoubleCompassResultVariables(Player)
  end
  self:EndInteractive(Player, true == bSuccess)
  return true
end

function M:GetDoubleCompassPlayer(PlayerEid)
  local RealPlayerEid = PlayerEid
  if not RealPlayerEid or 0 == RealPlayerEid then
    RealPlayerEid = self.DoubleCompassPlayerEid
  end
  local BattleInstance = Battle(self)
  if BattleInstance and RealPlayerEid and 0 ~= RealPlayerEid then
    local Player = BattleInstance:GetEntity(RealPlayerEid)
    if IsValid(Player) then
      return Player
    end
  end
  local LocalPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if LocalPlayer and IsValid(LocalPlayer) then
    return LocalPlayer
  end
  return nil
end

function M:SyncDoubleCompassResultVariables(Player)
  self:SetVariableBool("bDoubleCompassMainSuccess", self.bDoubleCompassMainSuccess == true, Player.Eid)
  self:SetVariableBool("bDoubleCompassExtraSuccess", true == self.bDoubleCompassExtraSuccess, Player.Eid)
end

function M:SetDoubleCompassTip(InTipType)
  self.DoubleCompassLastTipType = InTipType or "None"
  self:NotifyDoubleCompassUI("ShowDoubleCompassTip", self.DoubleCompassLastTipType)
  self:NotifyDoubleCompassUIState()
end

function M:NotifyDoubleCompassUIState()
  self:NotifyDoubleCompassUI("RefreshDoubleCompassState", self:GetDoubleCompassViewState())
end

function M:NotifyDoubleCompassUI(FuncName, ...)
  local UI = self.DoubleCompassUI or self.CurrentUI
  if not UI then
    return
  end
  local Func = UI[FuncName]
  if Func then
    Func(UI, ...)
  end
end

function M:RefreshDoubleCompassBlueprintState()
  self:CallDoubleCompassBlueprintEvent("BP_SetSelectedRing", self.DoubleCompassSelectedRing or OUTER_RING)
  self:CallDoubleCompassBlueprintEvent("BP_SetRingIndex", OUTER_RING, self.DoubleCompassOuterAngleIndex or 0)
  self:CallDoubleCompassBlueprintEvent("BP_SetRingIndex", INNER_RING, self.DoubleCompassInnerAngleIndex or 0)
  self:CallDoubleCompassBlueprintEvent("BP_SetInsertedKey", OUTER_RING, self.DoubleCompassOuterKeyId or 0)
  self:CallDoubleCompassBlueprintEvent("BP_SetInsertedKey", INNER_RING, self.DoubleCompassInnerKeyId or 0)
end

function M:CallDoubleCompassBlueprintEvent(FuncName, ...)
  local Func = self[FuncName]
  if Func then
    Func(self, ...)
    return true
  end
  self:ApplyDefaultDoubleCompassPresentation(FuncName, ...)
  return false
end

function M:ApplyDefaultDoubleCompassPresentation(FuncName, ...)
  if "BP_SetRingIndex" == FuncName then
    local InRingType, AngleIndex = ...
    self:SetRingComponentAngle(InRingType, AngleIndex)
    return
  end
  if "BP_SetInsertedKey" == FuncName then
    local InRingType, KeyId = ...
    self:SetRingKeyVisible(InRingType, 0 ~= (tonumber(KeyId) or 0))
    return
  end
  if "BP_PlayInsertKey" == FuncName then
    local InRingType, KeyId = ...
    self:PlayDefaultKeyInsert(InRingType, KeyId)
    return
  end
  if "BP_PlayInsertSuccess" == FuncName then
    return
  end
  if "BP_PlayInsertFail" == FuncName then
    local InRingType = (...)
    self:SetRingKeyVisible(InRingType, false)
    return
  end
  if "BP_PlayRemoveKey" == FuncName then
    local InRingType = (...)
    self:SetRingKeyVisible(InRingType, false)
  end
end

function M:SetRingComponentAngle(InRingType, AngleIndex)
  local Component = self:GetRingComponent(InRingType)
  if not Component or not Component.K2_SetRelativeRotation then
    return
  end
  Component:K2_SetRelativeRotation(FRotator(0, NormalizeAngleIndex(AngleIndex) * 60, 0), false, nil, false)
end

function M:SetRingKeyVisible(InRingType, bVisible)
  local Component = self:GetKeyComponent(InRingType)
  if Component and Component.SetVisibility then
    Component:SetVisibility(true == bVisible, true)
  end
end

function M:PlayDefaultKeyInsert(InRingType, KeyId)
  local Component = self:GetKeyComponent(InRingType)
  if not Component then
    return
  end
  self:SetRingKeyVisible(InRingType, true)
  self:ApplyKeyMaterial(Component, KeyId)
  self:MoveKeyToInsertTarget(InRingType)
end

function M:MoveKeyToInsertTarget(InRingType)
  local Component = self:GetKeyComponent(InRingType)
  local Target = self:GetKeyInsertTarget(InRingType)
  if not (Component and Target) or not Target.K2_GetComponentToWorld then
    return
  end
  local TargetTransform = Target:K2_GetComponentToWorld()
  if Component.K2_SetWorldLocationAndRotation then
    Component:K2_SetWorldLocationAndRotation(TargetTransform.Translation, TargetTransform.Rotation:ToRotator(), false, nil, false)
  elseif Component.K2_SetWorldLocation then
    Component:K2_SetWorldLocation(TargetTransform.Translation, false, nil, false)
  end
end

function M:ApplyKeyMaterial(Component, KeyId)
end

function M:GetRingComponent(InRingType)
  if NormalizeRingType(InRingType) == INNER_RING then
    return self.InnerRing
  end
  return self.OuterRing
end

function M:GetKeyComponent(InRingType)
  if NormalizeRingType(InRingType) == INNER_RING then
    return self.InnerKey
  end
  return self.OuterKey
end

function M:GetKeyInsertTarget(InRingType)
  if NormalizeRingType(InRingType) == INNER_RING then
    return self.InnerKeyInsertTarget
  end
  return self.OuterKeyInsertTarget
end

return M
