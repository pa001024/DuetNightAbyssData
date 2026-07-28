require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local GuildBossUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossUtils")
local AUTO_CONTINUE_TIMER = "GuildBossAutoContinueCountDown"
local EXIT_TIMER = "GuildBossExitCountDown"
local ETrialCalculationType = {Damage = 1, Hit = 2}

function M:Initialize(Initializer)
end

function M:Construct()
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
  self:BindToAnimationStarted(self.In, {
    self,
    self.OnInAnimationStarted
  })
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
end

function M:OnLoaded(...)
  self:InitDeviceInfo()
  self:InitListenEvent()
  local LogicServerInfo = (...)
  self.IsWin, self.DungeonId, self.Rewards, self.DungeonRewards, self.PlayerTime, self.GameTime, self.ClientRes = table.unpack(LogicServerInfo)
  if self.ClientRes == nil or nil == self.ClientRes.GuildBoss then
    DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded ClientRes or GuildBoss is nil")
    return
  end
  self.Score = self.ClientRes.GuildBoss.Point or 0
  self.bIsNewRecord = self.ClientRes.GuildBoss.IsNewRecord
  if nil == self.bIsNewRecord then
    DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded ClientRes.GuildBoss.IsNewRecord is nil")
  end
  local GuildBossServerInfo = self.ClientRes.GuildBoss.ClientMeta
  if nil == GuildBossServerInfo then
    DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded GuildBossServerInfo is nil")
    return
  end
  self.CombatData = GuildBossServerInfo.CombatData
  DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded CombatData: ")
  DebugPrintTable(self.CombatData, 3)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded Avatar is nil")
    return
  end
  local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
  if nil == DungeonId then
    DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded DungeonId is nil")
    return
  end
  self.DungeonId = DungeonId
  local AvatarGuildBossData = GuildModel:GetAvatarGuildBossData()
  if not AvatarGuildBossData then
    DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded AvatarGuildBossData is nil")
    return
  end
  local CandidateTargetGuildId = GuildModel:GetCurrentGuildRegionTargetGuildId()
  self.TargetGuildId = GuildModel:ResolveGuildBossDisplayGuildId(CandidateTargetGuildId)
  local SelfGuildId = Avatar and tonumber(Avatar.GuildId) or 0
  self.IsAssist = self.TargetGuildId > 0 and self.TargetGuildId ~= SelfGuildId
  DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded IsAssist", self.IsAssist, "TargetGuildId", self.TargetGuildId)
  self.bIsWeekMaxScore = self.bIsNewRecord
  local AutoProgress = Avatar.Dungeons[DungeonId] and Avatar.Dungeons[DungeonId].AutoProgress or 0
  self.bIsAutoRound = AutoProgress > 0
  DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded bIsAutoRound", self.bIsAutoRound)
  local IsAssist = self.IsAssist
  local UsedTimes = IsAssist and (AvatarGuildBossData:GetAssistUsed() or 0) or AvatarGuildBossData:GetChallengeUsed() or 0
  DebugPrint("yly WBP_Guild_Boss_Settlement_C OnLoaded UsedTimes", UsedTimes)
  local TotalTimes = 0
  if IsAssist then
    TotalTimes = DataMgr.GlobalConstant.GuildBossHelpEnterNum and tonumber(DataMgr.GlobalConstant.GuildBossHelpEnterNum.ConstantValue) or 10
  else
    TotalTimes = DataMgr.GlobalConstant.GuildBossEnterNum and tonumber(DataMgr.GlobalConstant.GuildBossEnterNum.ConstantValue) or 10
  end
  self.TotalChallengeTimes = TotalTimes
  self.RemainingChallengeTimes = math.max(0, TotalTimes - UsedTimes)
  self.AutoRoundCountDownTime = DataMgr.GlobalConstant.GuildBossSettleAutoAgainTime and tonumber(DataMgr.GlobalConstant.GuildBossSettleAutoAgainTime.ConstantValue) or 100
  self.AutoExitCountDownTime = DataMgr.GlobalConstant.GuildBossSettleExitTime and tonumber(DataMgr.GlobalConstant.GuildBossSettleExitTime.ConstantValue) or 100
  if self.IsAssist then
    self:RefreshAssistGuildBossData(function()
      if not self:InitGuildBossContextFromData(self.AssistGuildBossData) then
        return
      end
      self:FinishOnLoadedInit()
    end)
  else
    GuildModel:GetGuildBossDataByGuildId(self.TargetGuildId, function(GuildBossData)
      if not self:InitGuildBossContextFromData(GuildBossData) then
        return
      end
      self:FinishOnLoadedInit()
    end)
  end
end

function M:InitGuildBossContextFromData(GuildBossData)
  if not GuildBossData then
    DebugPrint("yly WBP_Guild_Boss_Settlement_C InitGuildBossContextFromData GuildBossData is nil")
    return false
  end
  self.GuildBossData = GuildBossData
  self.CurBossId = GuildBossData:GetCurrentBossId()
  DebugPrint("yly WBP_Guild_Boss_Settlement_C InitGuildBossContextFromData CurBossId", self.CurBossId)
  self.TrialList = GuildBossData:GetTrialList()
  DebugPrint("yly WBP_Guild_Boss_Settlement_C InitGuildBossContextFromData TrialList: ")
  DebugPrintTable(self.TrialList, 3)
  return true
end

function M:RefreshAssistGuildBossData(Callback)
  if not self.IsAssist or not self.TargetGuildId then
    DebugPrint("yly WBP_Guild_Boss_Settlement_C IsAssist But TargetGuildId is nil!")
    if Callback then
      Callback()
    end
    return
  end
  GuildModel:GetGuildBossDataByGuildId(self.TargetGuildId, function(GuildBossData, GuildInfo)
    self.AssistGuildBossData = GuildBossData
    self.AssistGuildInfo = GuildInfo
    if Callback then
      Callback()
    end
  end)
end

function M:FinishOnLoadedInit()
  self:InitUIContent()
  self:PlayAnimation(self.In)
end

function M:OnInAnimationStarted()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/association_boss_challenge_level_finish", nil, nil)
end

function M:GetBossState(BossId)
  if self.IsAssist then
    return GuildBossUtils.GetAssistGuildBossStateByBossId(self.AssistGuildBossData, self.AssistGuildInfo, BossId)
  end
  return GuildBossUtils.GetBossStateByBossId(BossId)
end

function M:Destruct()
  self:StopAllCountDownTimers()
  self.Btn_Exit:UnBindEventOnClickedByObj(self)
  self.Btn_Continue:UnBindEventOnClickedByObj(self)
end

function M:InitUIContent()
  self.Text_Title:SetText(GText("UI_GuildBoss_End"))
  self.Text_Title_1:SetText(GText("UI_GuildBoss_End"))
  self.Text_TotalScore:SetText(GText("UI_GuildBoss_EarnedPoints"))
  self.Num_Score:SetText(Utils.FormatNumber(self.Score, false))
  self.Text_NewRecord:SetText(GText("UI_GuildBoss_NewRecord"))
  if self.bIsWeekMaxScore then
    self.Panel_NewRecord:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Panel_NewRecord:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Btn_Exit:SetText(GText("FeinaEvent_Exit_Title"))
  self.Btn_Exit:SetDefaultGamePadImg("B")
  self.Btn_Exit:BindEventOnClicked(self, self.OnExitBtnClicked)
  local ContinueText = GText("UI_GuildBoss_ContinueChallenge") .. "(" .. self.RemainingChallengeTimes .. "/" .. self.TotalChallengeTimes .. ")"
  self.Btn_Continue:SetText(ContinueText)
  self.Btn_Continue:SetDefaultGamePadImg("X")
  if self.RemainingChallengeTimes <= 0 then
    self.Btn_Continue:SetRenderOpacity(0.5)
  else
    self.Btn_Continue:SetRenderOpacity(1.0)
  end
  self.Btn_Continue:BindEventOnClicked(self, self.OnContinueBtnClicked)
  if self.bIsAutoRound and self.RemainingChallengeTimes > 0 then
    self.autoContinueTimeLeft = self.AutoRoundCountDownTime
    self:RefreshAutoContinueText()
    self.Panel_Auto:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:StartAutoContinueCountDown()
  else
    self.exitTimeLeft = self.AutoExitCountDownTime
    self:RefreshExitTimeText()
    self.Panel_Auto:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Hint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:StartExitCountDown()
  end
  self:InitTrialDataUI()
end

function M:InitTrialDataUI()
  if not self.CombatData then
    DebugPrint("yly WBP_Guild_Boss_Settlement_C InitTrialDataUI CombatData is nil")
    return
  end
  self.TrialWidgets = {
    [1] = self.TrialProgress_1,
    [2] = self.TrialProgress_2,
    [3] = self.TrialProgress_3
  }
  for Idx = 1, 3 do
    local TrialWidget = self.TrialWidgets[Idx]
    local TrialId = self.TrialList[Idx]
    local GuildBuffId = DataMgr.GuildBossInfo[self.CurBossId].GuildWarBuff[Idx]
    local GuildBuffIconPath = GuildBossUtils.GetTrialIconPath(Idx)
    self:SetImage(GuildBuffIconPath, TrialWidget.Image_Icon)
    local GuildBuffVXIconPath = GuildBossUtils.GetTrialVXIconPath(Idx)
    if TrialWidget.VX_Icon then
      self:SetImage(GuildBuffVXIconPath, TrialWidget.VX_Icon)
    end
    local GuildBuffName = DataMgr.GuildWarBuff[GuildBuffId].BuffName
    local TrialCalType = ETrialCalculationType.Damage
    if DataMgr.GuildWarTest[TrialId].CalulationRule.Rate ~= nil then
      TrialCalType = ETrialCalculationType.Damage
    elseif nil ~= DataMgr.GuildWarTest[TrialId].CalulationRule.Hit then
      TrialCalType = ETrialCalculationType.Hit
    else
      DebugPrint("yly WBP_Guild_Boss_Settlement_C InitTrialDataUI TrialId", TrialId, "CalulationRule is nil")
    end
    local DescText = DataMgr.GuildWarTest[TrialId].TestKeyWord
    TrialWidget.Text_Desc:SetText(GText(DescText))
    if TrialCalType == ETrialCalculationType.Damage then
      TrialWidget.Text_Hit:SetVisibility(UIConst.VisibilityOp.Collapsed)
    elseif TrialCalType == ETrialCalculationType.Hit then
      TrialWidget.Text_Hit:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      TrialWidget.Text_Hit:SetText(GText("GuildBoss_HitCount"))
    end
    if TrialId then
      local TrialData = self.CombatData[TrialId]
      if TrialData then
        if TrialCalType == ETrialCalculationType.Damage then
          TrialWidget.Text_Num:SetText(Utils.FormatNumber(TrialData.MatchDamage, false))
        elseif TrialCalType == ETrialCalculationType.Hit then
          TrialWidget.Text_Num:SetText(Utils.FormatNumber(TrialData.MatchHit, false))
        end
        if nil ~= TrialWidget.bFinished then
          TrialWidget.bFinished = TrialData.Broken
        end
      else
        TrialWidget.Text_Num:SetText(0)
      end
    end
  end
end

function M:RefreshAutoContinueText()
  self.Text_AutoTime:SetText(string.format(GText("UI_GuildBoss_AutoContinueAfter"), self.autoContinueTimeLeft))
end

function M:RefreshExitTimeText()
  self.Text_ExitTime:SetText(string.format(GText("UI_Text_ExitTime"), self.exitTimeLeft))
end

function M:StartAutoContinueCountDown()
  self:AddTimer(1, function()
    self.autoContinueTimeLeft = self.autoContinueTimeLeft - 1
    if self.autoContinueTimeLeft <= 0 then
      self.autoContinueTimeLeft = 0
      if self:IsExistTimer(AUTO_CONTINUE_TIMER) then
        self:RemoveTimer(AUTO_CONTINUE_TIMER)
      end
      self:CheckContinueGuildBossSettlement()
    end
    self:RefreshAutoContinueText()
  end, true, 0, AUTO_CONTINUE_TIMER, false)
end

function M:StartExitCountDown()
  self:AddTimer(1, function()
    self.exitTimeLeft = self.exitTimeLeft - 1
    if self.exitTimeLeft <= 0 then
      self.exitTimeLeft = 0
      if self:IsExistTimer(EXIT_TIMER) then
        self:RemoveTimer(EXIT_TIMER)
      end
      self:ExitGuildBossSettlement()
    end
    self:RefreshExitTimeText()
  end, true, 0, EXIT_TIMER, false)
end

function M:StopAllCountDownTimers()
  if self:IsExistTimer(AUTO_CONTINUE_TIMER) then
    self:RemoveTimer(AUTO_CONTINUE_TIMER)
  end
  if self:IsExistTimer(EXIT_TIMER) then
    self:RemoveTimer(EXIT_TIMER)
  end
end

function M:OnExitBtnClicked()
  self:ExitGuildBossSettlement()
end

function M:ExitGuildBossSettlement()
  if self._IsExiting then
    return
  end
  self._IsExiting = true
  self:StopAllCountDownTimers()
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    self._IsExiting = false
    self:BlockAllUIInput(false)
    return
  end
  local ExitDungeonInfo = GWorld.GameInstance:GetExitDungeonData() or {}
  ExitDungeonInfo.Type = "GuildBoss"
  GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
  Avatar:ExitDungeonSettlement()
  EventManager:AddEvent(EventID.OnExitDungeon, self, self.OnExitDungeonFinished)
end

function M:OnExitDungeonFinished()
  EventManager:RemoveEvent(EventID.OnExitDungeon, self)
  self._IsExiting = false
  self:BlockAllUIInput(false)
  self:CloseSelf()
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
  self:Close()
end

function M:IsGuildBossPeriodActive()
  local BossId = self.CurBossId
  if not BossId or 0 == BossId then
    return false
  end
  if self.IsAssist and (not self.AssistGuildBossData or not self.AssistGuildInfo) then
    return false
  end
  local State = self:GetBossState(BossId)
  return "Active" == State
end

function M:CheckContinueGuildBossSettlement()
  if self.RemainingChallengeTimes <= 0 then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("GuildBossNoNum"))
    return
  end
  if not self:IsGuildBossPeriodActive() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildBoss_PeriodEnded_2"))
    return
  end
  self:ContinueGuildBossSettlement()
end

function M:OnContinueBtnClicked()
  self:CheckContinueGuildBossSettlement()
end

function M:ContinueGuildBossSettlement()
  if self._IsContinuing then
    return
  end
  self._IsContinuing = true
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    self._IsContinuing = false
    self:BlockAllUIInput(false)
    return
  end
  Avatar:EnterDungeonAgain(function(Ret)
    self._IsContinuing = false
    self:BlockAllUIInput(false)
    if Ret == ErrorCode.RET_SUCCESS then
      self:StopAllCountDownTimers()
      self:CloseSelf()
    else
      UIManager(self):ShowError(Ret, 1.5, "CommonToastMain")
      DebugPrint("yly WBP_Guild_Boss_Settlement_C ContinueGuildBossSettlement 再次下本失败,错误码:", Ret)
    end
  end)
end

local function _RealSetIcon(self, Texture, Img)
  if Texture then
    Img:SetBrushResourceObject(Texture)
  end
end

function M:SetImage(IconPath, Img)
  local IconObj = LoadObject(IconPath)
  if type(IconObj) == "string" then
    self:LoadTextureAsync(IconObj, function(Texture)
      if not Texture then
        Texture = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
        DebugPrint(ErrorTag, string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s", IconObj))
      end
      _RealSetIcon(self, Texture, Img)
    end, "LoadIcon")
  else
    _RealSetIcon(self, IconObj, Img)
  end
end

function M:LoadTextureAsync(TexturePath, cb, TaskName)
  rawset(self, "LoadResourceID", nil)
  local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, TexturePath, {
    self,
    function(self, Texture, ResourceID)
      if not IsValid(self) or nil ~= ResourceID and rawget(self, "LoadResourceID") ~= ResourceID then
        return
      end
      cb(Texture)
    end
  })
  if Handle then
    rawset(self, "LoadResourceID", Handle.ResourceID)
  end
end

function M:InitDeviceInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  DebugPrint("yly WBP_Guild_Boss_Settlement_C RefreshOpInfoByInputDevice CurGamepadName", CurGamepadName)
  DebugPrint("yly WBP_Guild_Boss_Settlement_C RefreshOpInfoByInputDevice CurInputDevice", CurInputDevice)
  if self.CurInputDeviceType == CurInputDevice then
    DebugPrint("yly 已经显示的是该输入模式，不需要进行刷新")
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  self:UpdateBtnUI()
  self:SetFocus()
end

function M:UpdateBtnUI()
end

function M:Handle_OnGamePadDown(InKeyName)
  if "Gamepad_FaceButton_Left" == InKeyName then
    if self.Btn_Continue:IsVisible() then
      self.Btn_Continue:OnBtnClicked()
      self:OnContinueBtnClicked()
    end
    return true
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if self.Btn_Exit:IsVisible() then
      self.Btn_Exit:OnBtnClicked()
      self:OnExitBtnClicked()
    end
    return true
  end
  return false
end

function M:Handle_OnPCDown(InKeyName)
  if "Escape" == InKeyName then
    return true
  end
  return false
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    DebugPrint("yly Key_IsGamepadKey", InKeyName)
    IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
  else
    DebugPrint("yly Key_IsPC", InKeyName)
    IsEventHandled = self:Handle_OnPCDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

return M
