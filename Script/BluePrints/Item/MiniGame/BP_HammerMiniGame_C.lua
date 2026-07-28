require("UnLua")
local M = Class("BluePrints.Item.MiniGame.BP_MiniGame_C")
local HammerAnimState = {
  Start = 1,
  Idle = 2,
  HitNormal = 3,
  HitPerfect = 4,
  Success = 5,
  Fail = 6,
  End = 7
}
local HammerHitResult = {
  Perfect = "Perfect",
  Normal = "Normal",
  Fail = "Fail"
}
local HammerMoveState = {
  WaitingInput = 1,
  Rising = 2,
  Falling = 3,
  Finished = 4
}
local HammerTimerKey = "HammerMiniGameMarker"

local function GetParam(Table, Key, DefaultValue)
  if Table and nil ~= Table[Key] then
    return Table[Key]
  end
  return DefaultValue
end

local function GetDataTable(TableName)
  if not TableName or "" == TableName then
    return nil
  end
  local CachedTable = rawget(DataMgr, TableName)
  if CachedTable then
    return CachedTable
  end
  local bSuccess, Table = pcall(require, "Datas." .. TableName)
  if not bSuccess then
    return nil
  end
  rawset(DataMgr, TableName, Table)
  return Table
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
  local HammerConstant = GetDataTable("HammerConstant")
  local Config = HammerConstant and HammerConstant[Name]
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

function M:InitHammerParams()
  local Params = self.UnitParams or {}
  self.HammerUIName = GetParam(Params, "UIName", "Hammer")
  self.HammerID = self.Difficulty or 1
  local HammerConfigTable = GetDataTable("HammerID")
  if not HammerConfigTable then
    LogHammerConfigError("读取 HammerID 表失败，请确认已导出 Content/Script/Datas/HammerID.lua")
  end
  local HammerConfig = HammerConfigTable and HammerConfigTable[self.HammerID]
  if HammerConfigTable and not HammerConfig then
    LogHammerConfigError(string.format("HammerID 表内找不到配置，Difficulty:%s", tostring(self.HammerID)))
  end
  self.HammerConfig = HammerConfig
  self.ProgressMax = GetParam(HammerConfig, "PBarTotal", 100)
  self.GrowthAmount = GetParam(HammerConfig, "PBarGrowth", 50)
  self.GrowthAcceleration = GetParam(HammerConfig, "PBarAcc", 100)
  self.NextKeyOffset = GetParam(HammerConfig, "PosNext", 30)
  self.KeyComboID = GetParam(HammerConfig, "KeyComboID", 0)
  self.InitialProgress = GetParam(Params, "InitialProgress", 0)
  self.MarkerUpdateInterval = GetParam(Params, "MarkerUpdateInterval", 0.033)
  self.EnableCrack = GetParam(Params, "EnableCrack", GetParam(HammerConfig, "AutoHack", false))
  self.KeyFrameVisibleRatio = Clamp(GetHammerConstant("Ham_VisPos", 0), 0, 2)
  self.KeyInfoVisibleRatio = Clamp(GetHammerConstant("Ham_VisPos_Key", 0), 0, 2)
  self.PerfectOffsetUp = GetHammerConstant("Ham_PerfPos_Up", 0)
  self.PerfectOffsetDown = GetHammerConstant("Ham_PerfPos_Down", 0)
  self.PerfectGrowthRate = GetHammerConstant("Ham_PerfRate", 1)
  self.ErrorLockTime = GetHammerConstant("Ham_ErrorLockTime", 0)
  self:InitHammerKeyCombos(HammerConfig)
  self.SuccessStateId = GetParam(Params, "SuccessStateId", nil)
  self.FailStateId = GetParam(Params, "FailStateId", nil)
  self.HammerMontageStart = GetParam(Params, "HammerMontageStart", nil)
  self.HammerMontageIdle = GetParam(Params, "HammerMontageIdle", nil)
  self.HammerMontageHitNormal = GetParam(Params, "HammerMontageHitNormal", nil)
  self.HammerMontageHitPerfect = GetParam(Params, "HammerMontageHitPerfect", nil)
  self.HammerMontageSuccess = GetParam(Params, "HammerMontageSuccess", nil)
  self.HammerMontageFail = GetParam(Params, "HammerMontageFail", nil)
  self.HammerMontageEnd = GetParam(Params, "HammerMontageEnd", nil)
end

function M:InitHammerKeyCombos(HammerConfig)
  local ComboTable = GetDataTable("HammerKey")
  if not ComboTable then
    LogHammerConfigError("读取 HammerKey 表失败，请确认已导出 Content/Script/Datas/HammerKey.lua")
  end
  local ComboConfig = ComboTable and ComboTable[self.KeyComboID]
  if ComboTable and not ComboConfig then
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
  self.ComboToleranceTime = GetParam(ComboConfig, "ComboToleranceTime", GetParam(HammerConfig, "ComboToleranceTime", GetHammerConstant("Ham_ComboToleranceTime", 0.15)))
end

function M:ResetHammerRuntime()
  self:StopHammerMarkerTimer()
  self.HammerGameStarted = false
  self.HammerGameOver = false
  self.HammerGameSuccess = false
  self.bHammerEndFlowCompleted = false
  self.HammerMoveState = HammerMoveState.WaitingInput
  self.HammerProgress = self.InitialProgress or 0
  self.HammerMarkerValue = self.HammerProgress
  self.HammerHitCount = 0
  self.HammerPlayerEid = 0
  self.HammerElapsedTime = 0
  self.HammerVelocity = 0
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
    self:ClientPlayAnim(PlayerEid, HammerAnimState.Start, self.Eid)
  end
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
  self.bInputEnabled = false
  self:CallHammerUI("SetHammerInputEnabled", false)
  self:StartNextGrowth(false)
  self:NotifyHammerUIState()
  if not self.bGMPreview then
    self:ClientPlayAnim(self.HammerPlayerEid, HammerAnimState.Idle, self.Eid)
  end
  self:StartHammerMarkerTimer()
end

function M:OnHammerInput(InputKey)
  if not self.HammerGameStarted or self.HammerGameOver then
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

function M:HandleHammerInputError()
  self.ComboPressedKeys = {}
  self.ComboInputStartTime = nil
  self.InputLockRemainTime = math.max(self.ErrorLockTime or 0, 0)
  self:CallHammerUI("ShowHammerHitResult", HammerHitResult.Fail)
  self:CallHammerUI("SetHammerInputLocked", self.InputLockRemainTime > 0, self.InputLockRemainTime)
end

function M:OnHammerCrack(PlayerEid)
  if not self.EnableCrack or self.HammerGameOver then
    return
  end
  if PlayerEid and 0 ~= PlayerEid then
    self.HammerPlayerEid = PlayerEid
    self.PlayerEid = PlayerEid
  end
  self:FinishHammerGame(true)
end

function M:OnHammerCancel(PlayerEid)
  if self.HammerGameOver then
    return
  end
  if PlayerEid and 0 ~= PlayerEid then
    self.HammerPlayerEid = PlayerEid
    self.PlayerEid = PlayerEid
  end
  self:FinishHammerGame(false)
end

function M:HandleHammerHitResult(ResultType)
  self.HammerHitCount = self.HammerHitCount + 1
  self.ComboPressedKeys = {}
  self.ComboInputStartTime = nil
  self:CallHammerUI("ShowHammerHitResult", ResultType)
  if ResultType == HammerHitResult.Perfect then
    self.NextGrowthRate = math.max(self.PerfectGrowthRate or 1, 0)
    if not self.bGMPreview then
      self:ClientPlayAnim(self.HammerPlayerEid, HammerAnimState.HitPerfect, self.Eid)
    end
  elseif not self.bGMPreview then
    self:ClientPlayAnim(self.HammerPlayerEid, HammerAnimState.HitNormal, self.Eid)
  end
  self:StartNextGrowth()
end

function M:StartNextGrowth(bAdvanceInput)
  local GrowthRate = self.NextGrowthRate or 1
  self.NextGrowthRate = 1
  self.CurrentRoundBasePos = self.HammerMarkerValue
  local GrowthDistance = math.max((self.GrowthAmount or 0) * GrowthRate, 0)
  self.CurrentPeakPos = math.min(self.CurrentRoundBasePos + GrowthDistance, self.ProgressMax)
  self.CurrentKeyTargetPos = math.min(self.CurrentRoundBasePos + math.max(self.NextKeyOffset or 0, 0), self.CurrentPeakPos)
  self.CurrentKeyDisplayPos = self.CurrentKeyTargetPos
  local ActualGrowth = self.CurrentPeakPos - self.CurrentRoundBasePos
  local Acceleration = math.max(self.GrowthAcceleration or 0, 0.001)
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
  if self.HammerMoveState == HammerMoveState.Rising or self.HammerMoveState == HammerMoveState.Falling then
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
  end
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
  local Acceleration = math.max(self.GrowthAcceleration or 0, 0.001)
  local NewMarkerValue = self.HammerMarkerValue + self.HammerVelocity * DeltaTime - 0.5 * Acceleration * DeltaTime * DeltaTime
  local NewVelocity = self.HammerVelocity - Acceleration * DeltaTime
  if self.HammerMoveState == HammerMoveState.Rising and NewVelocity <= 0 then
    self.HammerMarkerValue = self.CurrentPeakPos
    self.HammerVelocity = 0
    self.HammerMoveState = HammerMoveState.Falling
  else
    self.HammerMarkerValue = NewMarkerValue
    self.HammerVelocity = NewVelocity
  end
  if self.HammerMarkerValue >= self.ProgressMax then
    self.HammerMarkerValue = self.ProgressMax
    self.HammerProgress = self.ProgressMax
    self:NotifyHammerUIState()
    self:FinishHammerGame(true)
    return
  end
  if self.HammerMoveState == HammerMoveState.Falling then
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
      self:FinishHammerGame(false)
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
    self.bInputEnabled = true
    self:CallHammerUI("ShowNextInputHint", self.CurrentInputComboText, self.CurrentKeyDisplayPos)
    self:CallHammerUI("SetHammerInputEnabled", true)
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

function M:FinishHammerGame(bSuccess)
  if self.HammerGameOver then
    return
  end
  self.HammerGameOver = true
  self.HammerGameSuccess = bSuccess
  self.HammerGameStarted = false
  self.HammerMoveState = HammerMoveState.Finished
  self.bHammerEndFlowCompleted = false
  self:StopHammerMarkerTimer()
  local PlayerEid = self.HammerPlayerEid or self.PlayerEid or 0
  if not self.bGMPreview then
    self:SetVariableBool("IsGameSuccess", bSuccess, PlayerEid)
    self:ClientPlayAnim(PlayerEid, bSuccess and HammerAnimState.Success or HammerAnimState.Fail, self.Eid)
  end
  if self.MiniGameLogic and self.MiniGameLogic.ShowHammerGameEnd then
    self.MiniGameLogic:ShowHammerGameEnd(bSuccess)
  else
    self:OnHammerEndPresentationFinished()
  end
end

function M:OnHammerEndPresentationFinished()
  if not self.HammerGameOver or self.bHammerEndFlowCompleted then
    return
  end
  self.bHammerEndFlowCompleted = true
  local PlayerEid = self.HammerPlayerEid or self.PlayerEid or 0
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
  self:StopHammerMarkerTimer()
  self:DestroyHammerUI()
  self.HammerGameStarted = false
  if self.bGMPreview then
    self:K2_DestroyActor()
    return
  end
  M.Super.CloseMechanism(self, PlayerEid, IsSuccess)
end

function M:ForceCloseMechanism(PlayerEid, IsSuccess)
  self:StopHammerMarkerTimer()
  self:DestroyHammerUI()
  self.HammerGameStarted = false
  if self.bGMPreview then
    self:K2_DestroyActor()
    return
  end
  M.Super.ForceCloseMechanism(self, PlayerEid, IsSuccess)
end

function M:ReceiveEndPlay(EndReason)
  self:StopHammerMarkerTimer()
  self:DestroyHammerUI()
  if M.Super.ReceiveEndPlay then
    M.Super.ReceiveEndPlay(self, EndReason)
  end
end

function M:PlayAnim(PlayerEid, InteractiveState, MechanismEid)
  local BattleInstance = Battle(self)
  local Player = BattleInstance and BattleInstance:GetEntity(PlayerEid) or nil
  if not Player then
    return
  end
  local MontageName = self:GetHammerMontageName(InteractiveState)
  if not MontageName or "" == MontageName then
    return
  end
  if InteractiveState == HammerAnimState.End then
    if self.ChestInteractiveComponent then
      self.ChestInteractiveComponent:OnEndInteractive(Player, MontageName, MechanismEid)
    end
    return
  end
  local bUseInteractiveStart = InteractiveState == HammerAnimState.Start or InteractiveState == HammerAnimState.Idle
  if self.ChestInteractiveComponent and bUseInteractiveStart then
    self.ChestInteractiveComponent:OnStartInteractive(Player, MontageName, MechanismEid)
    return
  end
  if Player.PlayActionMontage then
    Player:PlayActionMontage("Interactive/MechInteractive", MontageName, {}, false)
  elseif self.ChestInteractiveComponent then
    self.ChestInteractiveComponent:OnStartInteractive(Player, MontageName, MechanismEid)
  end
end

function M:GetHammerMontageName(InteractiveState)
  local DefaultMontageName = self.ChestInteractiveComponent and self.ChestInteractiveComponent.MontageName
  if InteractiveState == HammerAnimState.Start then
    return self.HammerMontageStart or DefaultMontageName
  elseif InteractiveState == HammerAnimState.Idle then
    return self.HammerMontageIdle or self.HammerMontageStart or DefaultMontageName
  elseif InteractiveState == HammerAnimState.HitPerfect then
    return self.HammerMontageHitPerfect or self.HammerMontageHitNormal
  elseif InteractiveState == HammerAnimState.HitNormal then
    return self.HammerMontageHitNormal
  elseif InteractiveState == HammerAnimState.Success then
    return self.HammerMontageSuccess
  elseif InteractiveState == HammerAnimState.Fail then
    return self.HammerMontageFail
  elseif InteractiveState == HammerAnimState.End then
    return self.HammerMontageEnd or self.HammerMontageStart or DefaultMontageName
  end
  return nil
end

return M
