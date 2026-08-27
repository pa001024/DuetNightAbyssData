require("UnLua")
local M = Class("BluePrints.Item.MiniGame.BP_MiniGame_C")
local HammerHitResult = {
  Perfect = "Perfect",
  Normal = "Normal",
  Fail = "Fail"
}
local HammerMoveState = {
  WaitingInput = 1,
  Rising = 2,
  Falling = 3,
  Finished = 4,
  Finishing = 5
}
local HammerTimerKey = "HammerMiniGameMarker"
local HammerFemaleRoleId = 11402
local HammerMaleRoleId = 11302

local function GetParam(Table, Key, DefaultValue)
  if Table and nil ~= Table[Key] then
    return Table[Key]
  end
  return DefaultValue
end

local function LogHammerConfigError(Message)
  if DebugPrint and ErrorTag then
    DebugPrint(ErrorTag, "[BP_HammerMiniGame_C] " .. Message)
  elseif LogError then
    LogError(_G.LogTag, "[BP_HammerMiniGame_C] " .. Message)
  else
    print(_G.LogTag, "[BP_HammerMiniGame_C][Error] " .. Message)
  end
end

local function Clamp(Value, MinValue, MaxValue)
  return math.max(MinValue, math.min(Value, MaxValue))
end

local function GetHammerConstant(Name, DefaultValue)
  local Config = DataMgr.HammerConstant[Name]
  return Config and Config.ConstantValue or DefaultValue
end

local function NormalizeInputKey(InputKey)
  if nil == InputKey then
    return nil
  end
  return string.upper(tostring(InputKey):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function ParseComboKeys(ComboText)
  local Keys = {}
  local KeySet = {}
  for Key in tostring(ComboText or ""):gmatch("[^,，+%s]+") do
    Key = NormalizeInputKey(Key)
    if Key and "" ~= Key and not KeySet[Key] then
      KeySet[Key] = true
      table.insert(Keys, Key)
    end
  end
  return Keys
end

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self:InitHammerParams()
  self:ResetHammerRuntime()
end

function M:OnActorReady(Info)
  self.bHammerStateRecoveryPending = self:IsHammerPlayingState(self.StateId) or self:IsHammerResultState(self.StateId)
  M.Super.OnActorReady(self, Info)
  if self.OpenState and self.Data and (self.Data.RewardId or 0) > 0 then
    self:EMActorDestroy(EDestroyReason.MechanismDead)
    return
  end
  self:TryRecoverHammerInterruptedState(self.StateId)
end

function M:InitHammerParams()
  local Params = self.UnitParams or {}
  self.HammerUIName = GetParam(Params, "UIName", "Hammer")
  self.HammerID = self.Difficulty or 1
  local HammerConfig = DataMgr.HammerID[self.HammerID]
  if not HammerConfig then
    LogHammerConfigError(string.format("HammerID 表内找不到配置，Difficulty:%s", tostring(self.HammerID)))
  end
  self.HammerConfig = HammerConfig
  self.ProgressMax = GetParam(HammerConfig, "PBarTotal", 100)
  self.GrowthAmount = GetParam(HammerConfig, "PBarGrowth", 50)
  self.GrowthAcceleration = GetParam(HammerConfig, "PBarAcc", 100)
  self.NextKeyOffset = GetParam(HammerConfig, "PosNext", 30)
  self.KeyComboID = GetParam(HammerConfig, "KeyComboID", 0)
  self.bShowHammerComboCount = GetParam(HammerConfig, "NumCount", true)
  self.InitialProgress = GetParam(Params, "InitialProgress", 0)
  self.MarkerUpdateInterval = GetParam(Params, "MarkerUpdateInterval", 0.033)
  self.EnableCrack = GetParam(Params, "EnableCrack", GetParam(HammerConfig, "AutoHack", false))
  self.KeyFrameVisibleRatio = Clamp(GetHammerConstant("Ham_VisPos", 0), 0, 2)
  self.KeyInfoVisibleRatio = Clamp(GetHammerConstant("Ham_VisPos_Key", 0), 0, 2)
  self.PerfectOffsetUp = GetHammerConstant("Ham_PerfPos_Up", 0)
  self.PerfectOffsetDown = GetHammerConstant("Ham_PerfPos_Down", 0)
  self.PerfectGrowthRate = GetHammerConstant("Ham_PerfRate", 1)
  self.ComboGrowthRate = GetHammerConstant("Ham_ComboRate", 1)
  self.ErrorLockTime = GetHammerConstant("Ham_ErrorLockTime", 0)
  self.FinishRushSpeedRate = GetHammerConstant("Ham_FinishRushSpeedRate", 3)
  self:InitHammerKeyCombos(HammerConfig)
  self.SuccessStateId = GetParam(Params, "SuccessStateId", nil)
  self.FailStateId = GetParam(Params, "FailStateId", nil)
  self.HammerCameraBlendTime = GetParam(Params, "HammerCameraBlendTime", GetParam(self, "OpenBlendTime", 0.35))
  self.HammerCameraCloseBlendTime = GetParam(Params, "HammerCameraCloseBlendTime", GetParam(self, "CloseBlendTime", 0.2))
  self.HammerCameraFOV = GetParam(Params, "HammerCameraFOV", nil)
  self:CacheHammerBlueprintCameraTransform()
end

function M:CacheHammerBlueprintCameraTransform()
  if self.Camera and self.Camera.K2_GetComponentToWorld then
    self.HammerBlueprintCameraTransform = self.Camera:K2_GetComponentToWorld()
  end
end

function M:SetPlayerRotation()
  local PlayerActor = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local Player = PlayerActor and PlayerActor:Cast(UE4.LoadClass("Blueprint'/Game/BluePrints/Char/BP_PlayerCharacter.BP_PlayerCharacter_C'"))
  if not Player then
    return
  end
  local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
  if not Controller then
    return
  end
  if not self.Camera then
    self.bUseHammerFixedCamera = false
    LogHammerConfigError("大锤机关蓝图缺少 Camera 组件，无法切换固定机关视角")
    return
  end
  self.CacheControllerPausedParam = Controller.bShouldPerformFullTickWhenPaused
  Controller.bShouldPerformFullTickWhenPaused = true
  if Player.CharSpringArmComponent then
    Player.CharSpringArmComponent:SetTickableWhenPaused(true)
  end
  if not self.HammerBlueprintCameraTransform then
    self:CacheHammerBlueprintCameraTransform()
  end
  if self.HammerBlueprintCameraTransform then
    self.Camera:K2_SetWorldLocationAndRotation(self.HammerBlueprintCameraTransform.Translation, self.HammerBlueprintCameraTransform.Rotation:ToRotator(), false, nil, false)
  end
  self.Camera:SetAspectRatio(Player.CharCameraComponent.AspectRatio)
  self.Camera:SetFieldOfView(self.HammerCameraFOV or Player.CharCameraComponent.FieldOfView)
  Controller:SetViewTargetWithBlend(self, self.HammerCameraBlendTime or 0)
  self.bUseHammerFixedCamera = true
end

function M:ResetPlayerRotation()
  self:CleanupHammerActor()
  if not self.bUseHammerFixedCamera then
    return
  end
  local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local PlayerActor = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local Player = PlayerActor and PlayerActor:Cast(UE4.LoadClass("Blueprint'/Game/BluePrints/Char/BP_PlayerCharacter.BP_PlayerCharacter_C'"))
  if Controller then
    Controller.bShouldPerformFullTickWhenPaused = self.CacheControllerPausedParam
  end
  if Controller and Player then
    local PlayerRot = Player:K2_GetActorRotation().Yaw
    Controller:SetControlRotation(FRotator(0, PlayerRot, 0))
    Controller:SetViewTargetWithBlend(Player, self.HammerCameraCloseBlendTime or 0, EViewTargetBlendFunction.VTBlend_Linear, 0)
  end
  if Player and Player.CharSpringArmComponent then
    Player.CharSpringArmComponent:SetTickableWhenPaused(false)
  end
  self.bUseHammerFixedCamera = false
end

function M:CheckCanCrack()
  return self.EnableCrack == true and M.Super.CheckCanCrack(self)
end

function M:InitHammerKeyCombos(HammerConfig)
  local ComboConfig = DataMgr.HammerKey[self.KeyComboID]
  if not ComboConfig then
    LogHammerConfigError(string.format("HammerKey 表内找不到配置，KeyComboID:%s", tostring(self.KeyComboID)))
  end
  self.HammerKeyCombos = {}
  if ComboConfig then
    local IndexedCombos = {}
    if ComboConfig.Combo then
      for Index, ComboText in ipairs(ComboConfig.Combo) do
        table.insert(IndexedCombos, {
          Index = Index,
          Text = tostring(ComboText),
          Keys = ParseComboKeys(ComboText)
        })
      end
    else
      for FieldName, ComboText in pairs(ComboConfig) do
        local Index = tostring(FieldName):match("^Combo_(%d+)$")
        if Index and ComboText and "" ~= ComboText then
          table.insert(IndexedCombos, {
            Index = tonumber(Index),
            Text = tostring(ComboText),
            Keys = ParseComboKeys(ComboText)
          })
        end
      end
    end
    table.sort(IndexedCombos, function(A, B)
      return A.Index < B.Index
    end)
    self.HammerKeyCombos = IndexedCombos
  end
  if #self.HammerKeyCombos <= 0 then
    self.HammerKeyCombos = {
      {
        Index = 1,
        Text = "A",
        Keys = {"A"}
      }
    }
  end
  self.ComboToleranceTime = GetParam(ComboConfig, "ComboLimit", GetParam(HammerConfig, "ComboLimit", GetHammerConstant("Ham_ComboToleranceTime", 0.15)))
end

function M:ResetHammerRuntime()
  self:StopHammerMarkerTimer()
  self:RemoveTimer("HammerFinishDelay")
  self:RemoveTimer("HammerCrackFinishRush")
  self:RemoveTimer("HammerCloseAfterEndState")
  self.HammerGameStarted = false
  self.HammerGameOver = false
  self.HammerGameSuccess = false
  self.bHammerEndFlowCompleted = false
  self.bHammerEndPresentationStarted = false
  self.bWaitingFinishDelay = false
  self.bHammerResultStateChanged = false
  self.bHammerStateRecoveryPending = false
  self.HammerPendingCloseStateId = nil
  self.HammerMoveState = HammerMoveState.WaitingInput
  self.HammerProgress = self.InitialProgress or 0
  self.HammerMarkerValue = self.HammerProgress
  self.HammerHitCount = 0
  self.HammerPlayerEid = 0
  self.HammerActorPrepared = false
  self.HammerActorRoleChanged = false
  self.HammerActorEid = 0
  self.HammerActorOriginalQuestRoleId = 0
  self.HammerActorOriginalLocation = nil
  self.HammerActorOriginalRotation = nil
  self.HammerActorOriginalMovementMode = nil
  self.HammerActorOriginalCustomMovementMode = nil
  self.HammerElapsedTime = 0
  self.HammerVelocity = 0
  self.CurrentMoveAcceleration = nil
  self.CurrentRoundBasePos = self.HammerProgress
  self.CurrentPeakPos = self.HammerProgress
  self.CurrentKeyTargetPos = self.HammerProgress
  self.CurrentKeyDisplayPos = self.HammerProgress
  self.CurrentInputIndex = 1
  self.NextGrowthRate = 1
  self.InputLockRemainTime = 0
  self.ComboInputStartTime = nil
  self.ComboPressedKeys = {}
  self.bInputEnabled = false
  self.bKeyFrameVisible = false
  self.bKeyInfoVisible = false
  self.bKeyFollowingMarker = false
  self.bHasStartedGrowth = false
  self:RefreshCurrentInputInfo(false)
end

function M:GetHammerNextStateIdByType(StateId, StateType)
  local StateConfig = DataMgr.MechanismState and DataMgr.MechanismState[StateId]
  if not StateConfig or not StateConfig.StateEvent then
    return nil
  end
  for _, EventConfig in pairs(StateConfig.StateEvent) do
    local TypeConfig = EventConfig and EventConfig.TypeNextState
    if TypeConfig and TypeConfig.Type == StateType then
      return EventConfig.NextStateId
    end
  end
  return nil
end

function M:IsHammerPlayingState(StateId)
  return self:GetHammerNextStateIdByType(StateId, "InteractBreak") ~= nil
end

function M:IsHammerResultState(StateId)
  local StateIdList = self.Data and self.Data.StateIdList or {}
  for _, PreviousStateId in pairs(StateIdList) do
    local PreviousStateConfig = DataMgr.MechanismState[PreviousStateId]
    for _, EventConfig in pairs(PreviousStateConfig and PreviousStateConfig.StateEvent or {}) do
      local TypeConfig = EventConfig and EventConfig.TypeNextState
      if EventConfig.NextStateId == StateId and TypeConfig and (TypeConfig.Type == "InteractDone" or TypeConfig.Type == "InteractBreak") then
        return true
      end
    end
  end
  return false
end

function M:TryRecoverHammerInterruptedState(StateId)
  if not self.bHammerStateRecoveryPending or not self:IsHammerResultState(StateId) then
    return
  end
  local NextStateId = self:GetHammerNextStateIdByType(StateId, "Manual")
  if not NextStateId then
    return
  end
  self.bHammerStateRecoveryPending = false
  self:ChangeState("Manual", 0, NextStateId)
end

function M:OnEnterState(StateId)
  self.Overridden.OnEnterState(self, StateId)
  self:TryRecoverHammerInterruptedState(StateId)
  if self.HammerPendingCloseStateId == StateId then
    self.HammerPendingCloseStateId = nil
    local PlayerEid = self.HammerPlayerEid or self.PlayerEid or 0
    local bSuccess = self.HammerGameSuccess
    self:RemoveTimer("HammerCloseAfterEndState")
    self:AddTimer(0.001, function()
      self:CloseMechanism(PlayerEid, bSuccess)
    end, false, 0, "HammerCloseAfterEndState", true)
  end
end

function M:GetHammerManualNextStateId()
  return self:GetHammerNextStateIdByType(self.StateId, "Manual")
end

function M:ChangeHammerResultState(PlayerEid, bSuccess)
  if self.bHammerResultStateChanged then
    return
  end
  self.bHammerResultStateChanged = true
  if bSuccess then
    self:ChangeState("InteractDone", PlayerEid)
  else
    self:ChangeState("InteractBreak", PlayerEid)
  end
end

function M:ChangeHammerEndState(PlayerEid)
  local NextStateId = self:GetHammerManualNextStateId()
  if not NextStateId then
    return false
  end
  self.HammerPendingCloseStateId = NextStateId
  self:ChangeState("Manual", PlayerEid, NextStateId)
  return true
end

function M:GetCurrentCombo()
  local ComboCount = #self.HammerKeyCombos
  if ComboCount <= 0 then
    return nil
  end
  local Index = ((self.CurrentInputIndex or 1) - 1) % ComboCount + 1
  return self.HammerKeyCombos[Index]
end

function M:RefreshCurrentInputInfo(bNotifyUI)
  local Combo = self:GetCurrentCombo()
  self.CurrentInputComboText = Combo and Combo.Text or "A"
  self.CurrentInputKeys = Combo and Combo.Keys or {"A"}
  self.ComboPressedKeys = {}
  self.ComboInputStartTime = nil
  if bNotifyUI and self.bKeyInfoVisible then
    self:CallHammerUI("ShowNextInputHint", self.CurrentInputComboText, self.CurrentKeyDisplayPos)
  end
end

function M:OpenMechanism(PlayerEid)
  if self.OpenState or self.HammerGameStarted then
    return
  end
  self:ResetHammerRuntime()
  self.HammerPlayerEid = PlayerEid
  self.PlayerEid = PlayerEid
  if IsAuthority(self) then
    self:OnMiniGameStartServer(PlayerEid)
  end
end

function M:LoadGameUI(PlayerEid)
  M.Super.LoadGameUI(self, PlayerEid)
  if not self.LoadGame then
    return
  end
  local LocalPlayer = UE4.UGameplayStatics.GetPlayerPawn(self, 0)
  if not LocalPlayer or LocalPlayer.Eid ~= PlayerEid then
    return
  end
  self.HammerPlayerEid = PlayerEid
  self.PlayerEid = PlayerEid
  local Player = self:GetHammerPlayer(PlayerEid)
  if Player then
    self:PrepareHammerActor(Player)
  end
  self:SetPlayerRotation()
end

function M:OnHammerStart(PlayerEid)
  if self.HammerGameOver then
    return
  end
  if PlayerEid and 0 ~= PlayerEid then
    self.HammerPlayerEid = PlayerEid
    self.PlayerEid = PlayerEid
  end
  self.HammerGameStarted = true
  self.Started = true
  self.bInputEnabled = false
  self:CallHammerUI("SetHammerInputEnabled", false)
  self:SetHammerAnimState(self.HammerPlayerEid or self.PlayerEid or 0, 1)
  if self.OnHammerBarRise then
    self:OnHammerBarRise(false, 0)
  end
  self:CallHammerUI("OnHammerBarRise", false, 0)
  self:StartNextGrowth(false)
  self:NotifyHammerUIState()
  self:StartHammerMarkerTimer()
end

function M:OnHammerInput(InputKey)
  if not self.HammerGameStarted or self.HammerGameOver then
    return
  end
  if self.HammerMoveState == HammerMoveState.Finishing then
    return
  end
  if self.InputLockRemainTime > 0 then
    return
  end
  if not self.bInputEnabled then
    self:HandleHammerInputError()
    return
  end
  local NormalizedKey = NormalizeInputKey(InputKey)
  if not NormalizedKey or not self:IsExpectedInputKey(NormalizedKey) then
    self:HandleHammerInputError()
    return
  end
  if self.ComboPressedKeys[NormalizedKey] then
    return
  end
  if not self.ComboInputStartTime then
    self.ComboInputStartTime = self.HammerElapsedTime
  elseif self.HammerElapsedTime - self.ComboInputStartTime > self.ComboToleranceTime then
    self:HandleHammerInputError()
    return
  end
  self.ComboPressedKeys[NormalizedKey] = true
  self:CallHammerUI("UpdateHammerComboInput", NormalizedKey, true)
  if not self:IsCurrentComboComplete() then
    return
  end
  local bPerfect = self.bHasStartedGrowth and self:IsPerfectInputPosition()
  self:HandleHammerHitResult(bPerfect and HammerHitResult.Perfect or HammerHitResult.Normal)
end

function M:IsExpectedInputKey(InputKey)
  for _, ExpectedKey in ipairs(self.CurrentInputKeys or {}) do
    if InputKey == ExpectedKey then
      return true
    end
  end
  return false
end

function M:IsCurrentComboComplete()
  for _, ExpectedKey in ipairs(self.CurrentInputKeys or {}) do
    if not self.ComboPressedKeys[ExpectedKey] then
      return false
    end
  end
  return true
end

function M:IsPerfectInputPosition()
  local PerfectMin = self.CurrentKeyTargetPos - self.PerfectOffsetDown
  local PerfectMax = self.CurrentKeyTargetPos + self.PerfectOffsetUp
  return PerfectMin <= self.HammerMarkerValue and PerfectMax >= self.HammerMarkerValue
end

function M:HasReachedHammerInputArea()
  if self.HammerMoveState ~= HammerMoveState.Falling then
    return false
  end
  local PerfectMax = self.CurrentKeyTargetPos + self.PerfectOffsetUp
  return PerfectMax >= self.HammerMarkerValue
end

function M:TryEnableHammerInput()
  if not (not self.bInputEnabled and self.bKeyInfoVisible) or self.InputLockRemainTime > 0 then
    return
  end
  if not self:HasReachedHammerInputArea() then
    return
  end
  self.bInputEnabled = true
  self:CallHammerUI("SetHammerInputEnabled", true)
end

function M:HandleHammerInputError()
  self.HammerHitCount = 0
  self.ComboPressedKeys = {}
  self.ComboInputStartTime = nil
  self.InputLockRemainTime = math.max(self.ErrorLockTime or 0, 0)
  self:CallHammerUI("ShowHammerHitResult", HammerHitResult.Fail)
  self:CallHammerUI("SetHammerInputLocked", self.InputLockRemainTime > 0, self.InputLockRemainTime)
  if self.InputLockRemainTime <= 0 then
    self:RestoreHammerInputAfterErrorLock()
  end
end

function M:OnHammerCrack(PlayerEid)
  if not self:CheckCanCrack() or self.HammerGameOver then
    return
  end
  if self.HammerMoveState == HammerMoveState.Finishing or self.HammerMoveState == HammerMoveState.Finished then
    return
  end
  if PlayerEid and 0 ~= PlayerEid then
    self.HammerPlayerEid = PlayerEid
    self.PlayerEid = PlayerEid
  end
  if not self.HammerGameStarted then
    self:OnHammerStart(self.HammerPlayerEid or self.PlayerEid or 0)
    self:RemoveTimer("HammerCrackFinishRush")
    self:AddTimer(0.4, function()
      if self.HammerGameStarted and not self.HammerGameOver then
        self:StartHammerFinishRush()
      end
    end, false, 0, "HammerCrackFinishRush", true)
    return
  end
  self:StartHammerFinishRush()
end

function M:OnHammerCancel(PlayerEid)
  if self.HammerGameOver then
    return
  end
  if PlayerEid and 0 ~= PlayerEid then
    self.HammerPlayerEid = PlayerEid
    self.PlayerEid = PlayerEid
  end
  self:StartHammerFailure()
end

function M:StartHammerFailure()
  if self.HammerGameOver or self.bHammerEndPresentationStarted then
    return
  end
  self.bInputEnabled = false
  self:StopHammerMarkerTimer()
  self:CallHammerUI("SetHammerInputEnabled", false)
  local PlayerEid = self.HammerPlayerEid or self.PlayerEid or 0
  self:SetVariableBool("IsGameSuccess", false, PlayerEid)
  self:ApplyHammerResultAnimState(PlayerEid, false)
  self:ChangeHammerResultState(PlayerEid, false)
  self:StartHammerEndPresentation(false)
  if self.EndDelay and self.EndDelay > 0 then
    self.bWaitingFinishDelay = true
    self:RemoveTimer("HammerFinishDelay")
    self:AddTimer(self.EndDelay, function()
      self.bWaitingFinishDelay = false
      self:FinishHammerGame(false)
    end, false, 0, "HammerFinishDelay", true)
    return
  end
  self:FinishHammerGame(false)
end

function M:HandleHammerHitResult(ResultType)
  self.HammerHitCount = self.HammerHitCount + 1
  self.ComboPressedKeys = {}
  self.ComboInputStartTime = nil
  self:CallHammerUI("ShowHammerHitResult", ResultType)
  local bIsPerfect = ResultType == HammerHitResult.Perfect
  local GrowthRate = math.max(self.ComboGrowthRate or 1, 0) ^ math.max(self.HammerHitCount - 1, 0)
  if bIsPerfect then
    GrowthRate = GrowthRate * math.max(self.PerfectGrowthRate or 1, 0)
  end
  local GrowthDistance = math.max((self.GrowthAmount or 0) * GrowthRate, 0)
  local TargetPos = math.min(self.HammerMarkerValue + GrowthDistance, self.ProgressMax)
  local CurPercent = TargetPos / math.max(self.ProgressMax, 1)
  if self.OnHammerBarRise then
    self:OnHammerBarRise(bIsPerfect, CurPercent)
  end
  self:CallHammerUI("OnHammerBarRise", bIsPerfect, CurPercent)
  if self.HammerMarkerValue + GrowthDistance >= self.ProgressMax then
    self:StartHammerFinishRush()
    return
  end
  self.NextGrowthRate = GrowthRate
  self:StartNextGrowth()
end

function M:StartNextGrowth(bAdvanceInput)
  local GrowthRate = self.NextGrowthRate or 1
  self.NextGrowthRate = 1
  self.CurrentRoundBasePos = self.HammerMarkerValue
  local GrowthDistance = math.max((self.GrowthAmount or 0) * GrowthRate, 0)
  local NextKeyDistance = math.max((self.NextKeyOffset or 0) * GrowthRate, 0)
  self.CurrentPeakPos = math.min(self.CurrentRoundBasePos + GrowthDistance, self.ProgressMax)
  self.CurrentKeyTargetPos = math.min(self.CurrentRoundBasePos + NextKeyDistance, self.CurrentPeakPos)
  self.CurrentKeyDisplayPos = self.CurrentKeyTargetPos
  local ActualGrowth = self.CurrentPeakPos - self.CurrentRoundBasePos
  local Acceleration = math.max(self.GrowthAcceleration or 0, 0.001)
  self.CurrentMoveAcceleration = Acceleration
  self.HammerVelocity = math.sqrt(2 * Acceleration * ActualGrowth)
  self.HammerMoveState = HammerMoveState.Rising
  if false ~= bAdvanceInput then
    self.CurrentInputIndex = (self.CurrentInputIndex or 1) + 1
  end
  self.bInputEnabled = false
  self.bKeyFrameVisible = false
  self.bKeyInfoVisible = false
  self.bKeyFollowingMarker = false
  self.bHasStartedGrowth = true
  self:RefreshCurrentInputInfo(false)
  self:UpdateKeyVisibility()
end

function M:StartHammerFinishRush()
  self.HammerGameSuccess = true
  self.bInputEnabled = false
  self.bKeyFrameVisible = false
  self.bKeyInfoVisible = false
  self.bKeyFollowingMarker = false
  self.ComboPressedKeys = {}
  self.ComboInputStartTime = nil
  self:CallHammerUI("SetHammerInputEnabled", false)
  local PlayerEid = self.HammerPlayerEid or self.PlayerEid or 0
  self:SetVariableBool("IsGameSuccess", true, PlayerEid)
  self:ApplyHammerResultAnimState(PlayerEid, true)
  self:ChangeHammerResultState(PlayerEid, true)
  if self.EndDelay and self.EndDelay > 0 then
    self.bWaitingFinishDelay = true
    self:RemoveTimer("HammerFinishDelay")
    self:AddTimer(self.EndDelay, function()
      self.bWaitingFinishDelay = false
      self:FinishHammerGame(true)
    end, false, 0, "HammerFinishDelay", true)
  end
  self.CurrentRoundBasePos = self.HammerMarkerValue
  self.CurrentPeakPos = self.ProgressMax
  self.CurrentKeyTargetPos = self.ProgressMax
  self.CurrentKeyDisplayPos = self.ProgressMax
  local ActualGrowth = math.max(self.ProgressMax - self.HammerMarkerValue, 0)
  if ActualGrowth <= 0 then
    self.HammerMarkerValue = self.ProgressMax
    self.HammerProgress = self.ProgressMax
    self:NotifyHammerUIState()
    if not self.bWaitingFinishDelay then
      self:FinishHammerGame(true)
    end
    return
  end
  local SpeedRate = math.max(self.FinishRushSpeedRate or 1, 0.001)
  local Acceleration = math.max(self.GrowthAcceleration or 0, 0.001) * SpeedRate * SpeedRate
  self.CurrentMoveAcceleration = Acceleration
  self.HammerVelocity = math.sqrt(2 * Acceleration * ActualGrowth)
  self.HammerMoveState = HammerMoveState.Finishing
  self:StartHammerEndPresentation(true)
end

function M:StartHammerMarkerTimer()
  self:StopHammerMarkerTimer()
  self:AddTimer(self.MarkerUpdateInterval, self.UpdateHammerMarker, true, 0, HammerTimerKey, false)
end

function M:StopHammerMarkerTimer()
  self:RemoveTimer(HammerTimerKey)
end

function M:UpdateHammerMarker()
  if not self.HammerGameStarted or self.HammerGameOver then
    self:StopHammerMarkerTimer()
    return
  end
  local DeltaTime = self.MarkerUpdateInterval or 0.033
  self.HammerElapsedTime = self.HammerElapsedTime + DeltaTime
  self:UpdateInputLock(DeltaTime)
  self:UpdateComboTolerance()
  if self.HammerMoveState == HammerMoveState.Rising or self.HammerMoveState == HammerMoveState.Falling or self.HammerMoveState == HammerMoveState.Finishing then
    self:UpdateHammerMovement(DeltaTime)
  end
  self:NotifyHammerUIState()
end

function M:UpdateInputLock(DeltaTime)
  if self.InputLockRemainTime <= 0 then
    return
  end
  self.InputLockRemainTime = math.max(self.InputLockRemainTime - DeltaTime, 0)
  if self.InputLockRemainTime <= 0 then
    self:CallHammerUI("SetHammerInputLocked", false, 0)
    self:TryEnableHammerInput()
    self:RestoreHammerInputAfterErrorLock()
  end
end

function M:RestoreHammerInputAfterErrorLock()
  if self.HammerGameOver or not self.HammerGameStarted then
    return
  end
  if not self.bInputEnabled or not self.bKeyInfoVisible then
    return
  end
  self.ComboPressedKeys = {}
  self.ComboInputStartTime = nil
  self:CallHammerUI("ShowNextInputHint", self.CurrentInputComboText, self.CurrentKeyDisplayPos, true)
  self:CallHammerUI("SetHammerInputEnabled", true)
end

function M:UpdateComboTolerance()
  if not self.ComboInputStartTime or self:IsCurrentComboComplete() then
    return
  end
  if self.HammerElapsedTime - self.ComboInputStartTime > self.ComboToleranceTime then
    self:HandleHammerInputError()
  end
end

function M:UpdateHammerMovement(DeltaTime)
  local Acceleration = math.max(self.CurrentMoveAcceleration or self.GrowthAcceleration or 0, 0.001)
  local NewMarkerValue = self.HammerMarkerValue + self.HammerVelocity * DeltaTime - 0.5 * Acceleration * DeltaTime * DeltaTime
  local NewVelocity = self.HammerVelocity - Acceleration * DeltaTime
  if (self.HammerMoveState == HammerMoveState.Rising or self.HammerMoveState == HammerMoveState.Finishing) and NewVelocity <= 0 then
    self.HammerMarkerValue = self.CurrentPeakPos
    self.HammerVelocity = 0
    self.HammerMoveState = self.HammerMoveState == HammerMoveState.Finishing and HammerMoveState.Finished or HammerMoveState.Falling
  else
    self.HammerMarkerValue = NewMarkerValue
    self.HammerVelocity = NewVelocity
  end
  if self.HammerMarkerValue >= self.ProgressMax then
    self.HammerMarkerValue = self.ProgressMax
    self.HammerProgress = self.ProgressMax
    self:NotifyHammerUIState()
    if not self.bWaitingFinishDelay then
      self:FinishHammerGame(true)
    end
    return
  end
  if self.HammerMoveState == HammerMoveState.Falling then
    self:TryEnableHammerInput()
    if not self.bKeyFollowingMarker and self.HammerMarkerValue <= self.CurrentKeyTargetPos then
      self.bKeyFollowingMarker = true
    end
    if self.bKeyFollowingMarker then
      self.CurrentKeyDisplayPos = self.HammerMarkerValue
      self:CallHammerUI("RefreshHammerKeyPosition", self.CurrentKeyDisplayPos)
    end
    if self.HammerMarkerValue <= self.InitialProgress then
      self.HammerMarkerValue = self.InitialProgress
      self.HammerProgress = self.HammerMarkerValue
      self:StartHammerFailure()
      return
    end
  end
  self.HammerProgress = Clamp(self.HammerMarkerValue, self.InitialProgress, self.ProgressMax)
  self:UpdateKeyVisibility()
end

function M:UpdateKeyVisibility()
  if not self.bKeyFrameVisible and self:HasReachedTrajectoryRatio(self.KeyFrameVisibleRatio) then
    self.bKeyFrameVisible = true
    self:CallHammerUI("ShowHammerKeyFrame", self.CurrentKeyDisplayPos)
  end
  if not self.bKeyInfoVisible and self:HasReachedTrajectoryRatio(self.KeyInfoVisibleRatio) then
    self.bKeyInfoVisible = true
    self:CallHammerUI("ShowNextInputHint", self.CurrentInputComboText, self.CurrentKeyDisplayPos)
    self:CallHammerUI("SetHammerInputEnabled", false)
    self:TryEnableHammerInput()
  end
end

function M:HasReachedTrajectoryRatio(Ratio)
  Ratio = Clamp(Ratio or 0, 0, 2)
  if Ratio <= 1 then
    if self.HammerMoveState == HammerMoveState.Falling then
      return true
    end
    local Threshold = self.CurrentRoundBasePos + (self.CurrentPeakPos - self.CurrentRoundBasePos) * Ratio
    return self.HammerMoveState == HammerMoveState.Rising and Threshold <= self.HammerMarkerValue
  end
  if self.HammerMoveState ~= HammerMoveState.Falling then
    return false
  end
  local Threshold = self.CurrentPeakPos - (self.CurrentPeakPos - self.CurrentKeyTargetPos) * (Ratio - 1)
  return Threshold >= self.HammerMarkerValue
end

function M:NotifyHammerUIState()
  self:CallHammerUI("RefreshHammerProgress", self.HammerProgress or 0, self.HammerMarkerValue or 0)
end

function M:CallHammerUI(FuncName, ...)
  if not self.MiniGameLogic then
    return
  end
  local Func = self.MiniGameLogic[FuncName]
  if Func then
    Func(self.MiniGameLogic, ...)
  end
end

function M:ShowHammerSuccessToast()
  if not IsClient(self) and not IsStandAlone(self) then
    return
  end
  UIManager(self):LoadUINew("ExploreToastSuccess", GText("EventDungeonPass_Title1"))
end

function M:SetHammerAnimState(PlayerEid, HammerState)
  local Player = self:GetHammerPlayer(PlayerEid)
  local AnimInstance = Player and Player.PlayerAnimInstance
  if not AnimInstance and Player and Player.Mesh and Player.Mesh.GetAnimInstance then
    AnimInstance = Player.Mesh:GetAnimInstance()
  end
  if AnimInstance then
    AnimInstance.HammerState = HammerState
  end
end

function M:ApplyHammerResultAnimState(PlayerEid, bSuccess)
  self:SetHammerAnimState(PlayerEid, bSuccess and 2 or 3)
end

function M:StartHammerEndPresentation(bSuccess)
  if self.bHammerEndPresentationStarted then
    return
  end
  self.bHammerEndPresentationStarted = true
  if self.MiniGameLogic and self.MiniGameLogic.ShowHammerGameEnd then
    self.MiniGameLogic:ShowHammerGameEnd(bSuccess)
  elseif self.HammerGameOver then
    self:OnHammerEndPresentationFinished()
  end
end

function M:FinishHammerGame(bSuccess)
  if self.HammerGameOver then
    return
  end
  self.bWaitingFinishDelay = false
  self:RemoveTimer("HammerFinishDelay")
  self.HammerGameOver = true
  self.HammerGameSuccess = bSuccess
  self.HammerGameStarted = false
  self.HammerMoveState = HammerMoveState.Finished
  self.bHammerEndFlowCompleted = false
  self:StopHammerMarkerTimer()
  local PlayerEid = self.HammerPlayerEid or self.PlayerEid or 0
  self:SetVariableBool("IsGameSuccess", bSuccess, PlayerEid)
  self:ApplyHammerResultAnimState(PlayerEid, bSuccess)
  self:ChangeHammerResultState(PlayerEid, bSuccess)
  if self.bHammerEndPresentationStarted then
    if not self.MiniGameLogic or self.MiniGameLogic.bHammerEndPresentationFinished then
      self:OnHammerEndPresentationFinished()
    end
  else
    self:StartHammerEndPresentation(bSuccess)
  end
  if bSuccess then
    self:ShowHammerSuccessToast()
  end
end

function M:OnHammerEndPresentationFinished()
  if not self.HammerGameOver or self.bHammerEndFlowCompleted then
    return
  end
  self.bHammerEndFlowCompleted = true
  local PlayerEid = self.HammerPlayerEid or self.PlayerEid or 0
  if self:ChangeHammerEndState(PlayerEid) then
    return
  end
  self:CloseMechanism(PlayerEid, self.HammerGameSuccess)
end

function M:DestroyHammerUI()
  if not self.MiniGameLogic then
    return
  end
  self.MiniGameLogic.bHammerCloseFromActor = true
  if self.MiniGameLogic.Close then
    self.MiniGameLogic:Close()
  end
  self.MiniGameLogic = nil
end

function M:CloseMechanism(PlayerEid, IsSuccess)
  if not PlayerEid or 0 == PlayerEid then
    PlayerEid = self.HammerPlayerEid
  end
  self:StopHammerMarkerTimer()
  self:RemoveTimer("HammerFinishDelay")
  self:RemoveTimer("HammerCrackFinishRush")
  self:RemoveTimer("HammerCloseAfterEndState")
  self.HammerPendingCloseStateId = nil
  self:DestroyHammerUI()
  self:CleanupHammerActor()
  self.HammerGameStarted = false
  self.Started = false
  M.Super.CloseMechanism(self, PlayerEid, IsSuccess)
end

function M:ForceCloseMechanism(PlayerEid, IsSuccess)
  if not PlayerEid or 0 == PlayerEid then
    PlayerEid = self.HammerPlayerEid
  end
  self:StopHammerMarkerTimer()
  self:RemoveTimer("HammerFinishDelay")
  self:RemoveTimer("HammerCrackFinishRush")
  self:RemoveTimer("HammerCloseAfterEndState")
  self.HammerPendingCloseStateId = nil
  self:DestroyHammerUI()
  self:CleanupHammerActor()
  self.HammerGameStarted = false
  self.Started = false
  M.Super.ForceCloseMechanism(self, PlayerEid, IsSuccess)
end

function M:ReceiveEndPlay(EndReason)
  self.Started = false
  self:StopHammerMarkerTimer()
  self:RemoveTimer("HammerFinishDelay")
  self:RemoveTimer("HammerCrackFinishRush")
  self:RemoveTimer("HammerCloseAfterEndState")
  self.HammerPendingCloseStateId = nil
  self:DestroyHammerUI()
  self:CleanupHammerActor()
  if self.bUseHammerFixedCamera then
    self:ResetPlayerRotation()
  end
  if M.Super.ReceiveEndPlay then
    M.Super.ReceiveEndPlay(self, EndReason)
  end
end

function M:GetHammerPlayer(PlayerEid)
  local BattleInstance = Battle(self)
  return BattleInstance and BattleInstance:GetEntity(PlayerEid) or nil
end

function M:PrepareHammerActor(Player)
  if self.HammerActorPrepared or not Player then
    return
  end
  self.HammerActorPrepared = true
  self.HammerActorEid = Player.Eid or 0
  self:CacheHammerActorState(Player)
  self.HammerActorRoleChanged = self:SwitchHammerRole(Player)
  self:SetHammerPlayerInteractive(Player, true)
  self:SetHammerActorMovementLocked(Player, true)
  self:MoveHammerActorToPoint(Player)
end

function M:CacheHammerActorState(Player)
  self.HammerActorOriginalQuestRoleId = Player.AvatarQuestRoleID or 0
  self.HammerActorOriginalLocation = Player:K2_GetActorLocation()
  self.HammerActorOriginalRotation = Player:K2_GetActorRotation()
  local Movement = Player.CharacterMovement or Player:GetMovementComponent()
  if Movement then
    self.HammerActorOriginalMovementMode = Movement.MovementMode
    self.HammerActorOriginalCustomMovementMode = Movement.CustomMovementMode
  end
end

function M:SetHammerActorMovementLocked(Player, bLocked)
  local Movement = Player and (Player.CharacterMovement or Player:GetMovementComponent())
  if not Movement then
    return
  end
  Movement:StopMovementImmediately()
  if bLocked then
    Movement:SetMovementMode(UE4.EMovementMode.MOVE_None)
  elseif self.HammerActorOriginalMovementMode ~= nil then
    Movement:SetMovementMode(self.HammerActorOriginalMovementMode, self.HammerActorOriginalCustomMovementMode or 0)
  else
    Movement:SetMovementMode(Movement.DefaultLandMovementMode)
  end
end

function M:SwitchHammerRole(Player)
  local RoleId = self:GetHammerRoleInfo(Player)
  if not RoleId then
    return false
  end
  if not Player.ChangeRole then
    LogHammerConfigError("玩家对象缺少 ChangeRole，无法切换大锤表演角色")
    return false
  end
  self:ChangeHammerRole(Player, RoleId)
  return true
end

function M:ChangeHammerRole(Player, RoleId, AvatarInfo)
  local MechanismEid = Player.MechanismEid or 0
  local bCheckMontageInteractive = self.CheckMontageInteractive and self:CheckMontageInteractive() or false
  if Player.SetMechanismEid then
    Player:SetMechanismEid(0, bCheckMontageInteractive)
  end
  Player:ChangeRole(RoleId, AvatarInfo)
  if Player.SetMechanismEid and 0 ~= MechanismEid then
    Player:SetMechanismEid(MechanismEid, bCheckMontageInteractive)
  end
end

function M:GetHammerRoleInfo(Player)
  local PlayerIdentity = self:GetHammerPlayerIdentity()
  local Gender = self:GetHammerGender(PlayerIdentity, Player)
  local RoleId = 1 == Gender and HammerMaleRoleId or HammerFemaleRoleId
  local RoleConfig = DataMgr.BattleChar and DataMgr.BattleChar[RoleId]
  if not RoleConfig then
    LogHammerConfigError(string.format("BattleChar 表内找不到大锤表演角色，SwitchPlayer:%s Gender:%s RoleId:%s", tostring(PlayerIdentity), tostring(Gender), tostring(RoleId)))
    return nil
  end
  return RoleId
end

function M:GetHammerPlayerIdentity()
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar() or nil
  if not Avatar then
    return "EXPlayer"
  end
  local RegionId = Avatar:GetCurrentRegionId()
  local RegionInfo = RegionId and DataMgr.SubRegion and DataMgr.SubRegion[RegionId] or nil
  return RegionInfo and RegionInfo.SwitchPlayer or "EXPlayer"
end

function M:GetHammerGender(PlayerIdentity, Player)
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar() or nil
  if Avatar then
    return "Player" == PlayerIdentity and Avatar.Sex or Avatar.WeitaSex
  end
  local RoleInfo = DataMgr.Player2RoleId and DataMgr.Player2RoleId[PlayerIdentity]
  if RoleInfo and Player and Player.CurrentRoleId then
    for Gender, RoleId in pairs(RoleInfo) do
      if RoleId == Player.CurrentRoleId then
        return Gender
      end
    end
  end
  return 0
end

function M:MoveHammerActorToPoint(Player)
  if not self.PlayerPoint then
    LogHammerConfigError("大锤机关蓝图缺少 PlayerPoint 组件，无法设置玩家固定站位")
    return
  end
  local PlayerLocation = self.PlayerPoint:K2_GetComponentLocation()
  PlayerLocation = UE4.UNavigationFunctionLibrary.GetGroundPos(self, PlayerLocation, 10000)
  if Player.CapsuleComponent then
    PlayerLocation.Z = PlayerLocation.Z + Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
  end
  local MechanismLocation = self:K2_GetActorLocation()
  local LookAtRotation = UE4.UKismetMathLibrary.FindLookAtRotation(PlayerLocation, MechanismLocation)
  local PlayerRotation = FRotator(0, LookAtRotation.Yaw, 0)
  Player:K2_SetActorLocationAndRotation(PlayerLocation, PlayerRotation, false, nil, true)
  local Controller = Player:GetController()
  if Controller then
    Controller:SetControlRotation(PlayerRotation)
  end
end

function M:SetHammerPlayerInteractive(Player, bInteractive)
  if not Player then
    return
  end
  if bInteractive and Player.SetCharacterTag then
    Player:SetCharacterTag("Interactive")
  elseif not bInteractive and Player.SetCharacterTagIdle then
    Player:SetCharacterTagIdle()
  end
end

function M:CleanupHammerActor()
  if not self.HammerActorPrepared then
    return
  end
  local BattleInstance = Battle(self)
  local Player = BattleInstance and BattleInstance:GetEntity(self.HammerActorEid) or nil
  if self.HammerActorRoleChanged and Player and Player.ChangeRole then
    local Controller = Player:GetController()
    local AvatarInfo = Controller and Controller:GetAvatarInfo() or nil
    if 0 ~= self.HammerActorOriginalQuestRoleId then
      AvatarInfo = AvatarUtils:GetBattleInfoByQuestRoleId(self.HammerActorOriginalQuestRoleId, GWorld:GetAvatar())
      if AvatarInfo.RoleInfo then
        AvatarInfo.RoleInfo.AvatarQuestRoleID = self.HammerActorOriginalQuestRoleId
      end
    end
    self:ChangeHammerRole(Player, nil, AvatarInfo)
  end
  if Player then
    if self.HammerActorOriginalLocation and self.HammerActorOriginalRotation then
      Player:K2_SetActorLocationAndRotation(self.HammerActorOriginalLocation, self.HammerActorOriginalRotation, false, nil, true)
    end
    self:SetHammerActorMovementLocked(Player, false)
    self:SetHammerPlayerInteractive(Player, false)
  end
  self.HammerActorPrepared = false
  self.HammerActorRoleChanged = false
  self.HammerActorEid = 0
  self.HammerActorOriginalQuestRoleId = 0
  self.HammerActorOriginalLocation = nil
  self.HammerActorOriginalRotation = nil
  self.HammerActorOriginalMovementMode = nil
  self.HammerActorOriginalCustomMovementMode = nil
end

return M
