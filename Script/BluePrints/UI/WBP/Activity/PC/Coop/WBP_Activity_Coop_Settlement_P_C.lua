require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.Common.TimerMgr"
})

function M:Initialize(Initializer)
end

function M:Construct()
  self:BindToAnimationStarted(self.In, {
    self,
    self.OnInAnimationStarted
  })
  self:BindToAnimationStarted(self.Fail_In, {
    self,
    self.OnFailInAnimationStarted
  })
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
end

function M:OnLoaded(...)
  self:InitDeviceInfo()
  self:InitListenEvent()
  local LogicServerInfo = (...)
  PrintTable(LogicServerInfo, 5, "yly LogicServerInfo ")
  self.IsWin, self.DungeonId, self.Rewards, self.DungeonRewards, self.PlayerTime, self.GameTime, self.ClientRes = table.unpack(LogicServerInfo)
  self.RoomSettleInfo = self.ClientRes.RoomSettleInfo
  if not self.RoomSettleInfo then
    DebugPrint("yly WBP_Activity_Coop_Settlement_P_C OnLoaded: self.RoomSettleInfo is nil")
    return
  end
  self.bEventEnd = self.RoomSettleInfo.bEventEnd
  if self.bEventEnd then
    DebugPrint("yly WBP_Activity_Coop_Settlement_P_C OnLoaded: self.bEventEnd is true")
    self:ShowEventEndUI()
    return
  end
  self.bExtraRoom = self.RoomSettleInfo.bSingleMode or false
  self.SingleModeDamage = self.RoomSettleInfo.SingleModeDamage or 0
  self.RoomUniId = self.RoomSettleInfo.RoomUniId
  if self.RoomUniId == nil then
    DebugPrint("yly WBP_Activity_Coop_Settlement_P_C OnLoaded: self.RoomUniId is nil. Try to get from GameMode and RoomState.")
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local PreInitInfo = GameMode and GameMode.PreInitInfo
    local RoomState = GWorld.GameInstance and GWorld.GameInstance[CommonConst.DungeonSyncMsg.AsyncCombatRoomStateUpdate]
    self.RoomUniId = PreInitInfo and PreInitInfo.RoomUniId or RoomState and RoomState.RoomUniId or nil
    if self.RoomUniId == nil then
      DebugPrint("yly WBP_Activity_Coop_Settlement_P_C OnLoaded: self.RoomUniId is nil")
      return
    end
  end
  self.bExtraRoomPass = self.RoomSettleInfo.bSingleModePass
  self.bAllPassed = self.RoomSettleInfo.bAllPassed
  if self.bExtraRoom then
    self.bAllPassed = self.bExtraRoomPass or false
  end
  self.CurRound = self.RoomSettleInfo.CurRound
  self.TotalRound = #DataMgr.AsyncCombat[self.RoomSettleInfo.RoomConfId].BossUnitID
  self.CurRoundBossLifeRemain = self.RoomSettleInfo.BossRemainHp
  self.CurRoundBossTotalHp = self.RoomSettleInfo.BossTotalHp
  self.CurDevote = ((self.RoomSettleInfo.Damage or 0) + self.SingleModeDamage) / self.RoomSettleInfo.RoomTotalHp * 10000
  self.bRoomOwner = self.RoomSettleInfo.bRoomOwner
  self.bMVP = self.RoomSettleInfo.bMvp
  self.MVPDevote = (self.RoomSettleInfo.MvpDamage or 0) / self.RoomSettleInfo.RoomTotalHp * 10000
  self.BaseRewardNeedDevote = DataMgr.AsyncCombatEventConstant.AsyncCombat_BaseContributionRequire.ConstantValue
  if self.bExtraRoom and self.bExtraRoomPass then
    ReddotManager.IncreaseLeafNodeCount("AsyncCombatReward", 1, {CacheKey = "Red"})
    ReddotManager.DecreaseLeafNodeCount("AsyncCombatStoppageNew", 1, {
      CacheKey = "New",
      Type = "StoppageRoom",
      RoomIds = {
        self.RoomUniId
      }
    })
  end
  self:InitUIContent()
  if self.bAllPassed then
    self:PlayAnimation(self.In)
  else
    self:PlayAnimation(self.Fail_In)
  end
end

function M:OnInAnimationStarted()
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/lianmeiyanyi_level_success", nil, nil)
end

function M:OnFailInAnimationStarted()
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/lianmeiyanyi_level_finish", nil, nil)
end

function M:ShowEventEndUI()
  self.Ws_Text_Progress:SetActiveWidgetIndex(0)
  self.TextProgressDone:SetText(GText("UI_AsyncCombat_ChallengeEnd2"))
  self.VX_WordGlow6:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.TextEnd:SetText(GText("UI_AsyncCombat_ChallengeEnd2"))
  self.TextLevel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.VerticalBox_0:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.TextFail:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.TextWait:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.BtnExit.TextCreate:SetText(GText("UI_AsyncCombat_LeaveStage"))
  self.BtnExit.Btn.OnClicked:Add(self, self.ExitCoopSettlement)
  self.BtnExit.Btn.AudioEventPath = "event:/ui/activity/lianmeiyanyi_btn_common_click"
  self.BtnAgainPanel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:InitExitCountDown()
  self:PlayAnimation(self.Fail_In)
end

function M:InitUIContent()
  if self.bAllPassed then
    self.Ws_Text_Progress:SetActiveWidgetIndex(0)
    self.TextProgressDone:SetText(GText("UI_AsyncCombat_ChallengeEnd2"))
    self.VX_WordGlow6:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Ws_Text_Progress:SetActiveWidgetIndex(1)
    local ProgressRemainPercent = math.ceil(self.CurRoundBossLifeRemain * 100 / self.CurRoundBossTotalHp)
    self.TextProgressNum:SetText(string.format(GText("UI_AsyncCombat_BossRemainHP"), ProgressRemainPercent))
    self.VX_WordGlow6:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.TextEnd:SetText(GText("UI_AsyncCombat_ChallengeEnd2"))
  self.TextLevel:SetVisibility(UIConst.VisibilityOp.Visible)
  if self.bExtraRoom then
    self.TextLevel:SetText(GText("UI_AsyncCombat_CombatRoom"))
  else
    local CurStageText = string.format(GText("UI_AsyncCombat_SettleCurrentStages"), self.CurRound)
    local TotalStageText = string.format(GText("UI_AsyncCombat_SettleTotalStages"), self.TotalRound)
    self.TextLevel:SetText(CurStageText .. "/" .. TotalStageText)
  end
  self.VerticalBox_0:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.TextNow:SetText(GText("UI_AsyncCombat_CurrentContribution"))
  local text = self:FormatPercent(self.CurDevote, "floor")
  self.TextNum:SetText(text)
  self.Tag01.TextTag:SetText(GText("UI_AsyncCombat_MVP"))
  self.Tag02.TextTag:SetText(GText("UI_AsyncCombat_Host"))
  if self.bRoomOwner then
    self.Ws_Tag:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Ws_Tag:SetActiveWidgetIndex(1)
  elseif self.bMVP then
    self.Ws_Tag:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Ws_Tag:SetActiveWidgetIndex(0)
  else
    self.Ws_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.TextFail:SetVisibility(UIConst.VisibilityOp.Visible)
  self.TextFail:SetText(GText("UI_AsyncCombat_ContributionNotMetRePerform"))
  self.BtnExit.TextCreate:SetText(GText("UI_AsyncCombat_LeaveStage"))
  self.BtnExit.Btn.OnClicked:Add(self, self.ExitCoopSettlement)
  self.BtnExit.Btn.AudioEventPath = "event:/ui/activity/lianmeiyanyi_btn_common_click"
  self.BtnAgain.TextCreate:SetText(GText("UI_AsyncCombat_RePerform"))
  if self:ShouldBtnAgainEnabled() then
    self.BtnAgainPanel:SetVisibility(UIConst.VisibilityOp.Visible)
    self.BtnAgain.Btn.OnClicked:Add(self, self.PlayAgain)
    self.BtnAgain.Btn.AudioEventPath = "event:/ui/activity/lianmeiyanyi_btn_common_click"
  else
    self.BtnAgainPanel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:InitExitCountDown()
  self:InitRewardsUI()
end

function M:PlayAgain()
  DebugPrint("yly WBP_Activity_Coop_Settlement_P_C PlayAgain")
  if self._IsPlayingAgain or self._IsExitingCoopSettlement then
    return
  end
  local Avatar = GWorld and GWorld:GetAvatar() or nil
  if not Avatar or not Avatar.EnterEventDungeon then
    DebugPrint("yly PlayAgain: Avatar invalid or no EnterEventDungeon")
    return
  end
  if not self.RoomUniId then
    DebugPrint("yly PlayAgain: RoomUniId is nil")
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_ConditionNotMet"))
    return
  end
  local DungeonId = self.DungeonId
  if not DungeonId and self.RoomSettleInfo and self.RoomSettleInfo.RoomConfId then
    local RoomConf = DataMgr.AsyncCombat[self.RoomSettleInfo.RoomConfId]
    DungeonId = RoomConf and RoomConf.DungeonID
  end
  local EventId = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  if not DungeonId or not EventId then
    DebugPrint("yly PlayAgain: DungeonId/EventId invalid.")
    return
  end
  self._IsPlayingAgain = true
  if self.RemoveTimer then
    self:RemoveTimer("CoopSettlementCountDown")
  end
  if self.BlockAllUIInput then
    self:BlockAllUIInput(true)
  end
  local SquadId = 0
  local DungeonInfo = DataMgr.Dungeon and DataMgr.Dungeon[DungeonId]
  local DungeonType = DungeonInfo and DungeonInfo.DungeonType
  if DungeonType and Avatar.DungeonSquad then
    SquadId = Avatar.DungeonSquad[DungeonType] or 0
  end
  DebugPrint("yly PlayAgain: DungeonId=", DungeonId, "DungeonType=", DungeonType, "SquadId=", SquadId)
  Avatar:EnterEventDungeon(function(Ret)
    self._IsPlayingAgain = false
    if self.BlockAllUIInput then
      self:BlockAllUIInput(false)
    end
    if Ret == ErrorCode.RET_SUCCESS then
      self:Close()
      return
    end
    if Ret == ErrorCode.RET_ASYNCCOMBAT_DUNGEON_ROOM_CLOSED then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomEndedRefresh"))
    elseif Ret == ErrorCode.RET_ASYNCCOMBAT_PLAYER_ENTER_DUNGEON_CD then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomCoolDownRetry"))
    else
      UIManager(self):ShowError(Ret, 1.5, "CommonToastMain")
    end
    DebugPrint("yly PlayAgain failed, Ret=", Ret)
    if self.InitExitCountDown then
      self:InitExitCountDown()
    end
  end, DungeonId, SquadId, EventId, {
    RoomUniId = self.RoomUniId,
    EventId = EventId
  })
end

function M:ExitCoopSettlement()
  DebugPrint("yly WBP_Activity_Coop_Settlement_P_C ExitCoopSettlement")
  if self._IsExitingCoopSettlement or self._IsPlayingAgain then
    return
  end
  self._IsExitingCoopSettlement = true
  if self.RemoveTimer then
    self:RemoveTimer("CoopSettlementCountDown")
  end
  if self.BlockAllUIInput then
    self:BlockAllUIInput(true)
  end
  local Avatar = GWorld and GWorld:GetAvatar() or nil
  if not Avatar or not Avatar.ExitDungeonSettlement then
    DebugPrint("WBP_Activity_Coop_Settlement_P_C: Avatar invalid or no ExitDungeonSettlement")
    if self.BlockAllUIInput then
      self:BlockAllUIInput(false)
    end
    self._IsExitingCoopSettlement = false
    return
  end
  Avatar:ExitDungeonSettlement()
  EventManager:AddEvent(EventID.OnExitDungeon, self, self.OnExitDungeonFinished)
end

function M:OnExitDungeonFinished()
  EventManager:RemoveEvent(EventID.OnExitDungeon, self)
  if self.BlockAllUIInput then
    self:BlockAllUIInput(false)
  end
  if self:IsAnimationPlaying(self.Out) or self:IsAnimationPlaying(self.Fail_Out) then
    return
  end
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
  self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
  self:Close()
end

function M:InitExitCountDown()
  self.exitTimeleft = DataMgr.GlobalConstant.CoopSettlementExitTime.ConstantValue
  self.TextTime:SetText(string.format(GText("UI_Text_ExitTime"), self.exitTimeleft))
  self.timer = self:AddTimer(1, self.UpdateCountDownUI, true, 0, "CoopSettlementCountDown", false)
end

function M:UpdateCountDownUI()
  if self.exitTimeleft > 0 then
    self.exitTimeleft = self.exitTimeleft - 1
  else
    self.exitTimeleft = 0
    self:RemoveTimer("CoopSettlementCountDown")
    self:ExitCoopSettlement()
  end
  self.TextTime:SetText(string.format(GText("UI_Text_ExitTime"), self.exitTimeleft))
end

function M:ShouldBtnAgainEnabled()
  if self.CurDevote == nil or nil == self.BaseRewardNeedDevote then
    DebugPrint("yly WBP_Activity_Coop_Settlement_P_C ShouldBtnAgainEnabled: self.CurDevote/self.BaseRewardNeedDevote is nil")
    return false
  end
  if not self.bExtraRoom and self.bRoomOwner then
    return false
  end
  local bSatisfyBaseDevote = self.CurDevote >= self.BaseRewardNeedDevote
  return not bSatisfyBaseDevote
end

function M:InitRewardsUI()
  local bSatisfyBaseDevote = self.CurDevote >= self.BaseRewardNeedDevote
  if self.bExtraRoom then
    self.Progress_Node_1:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Reward01.TextReward:SetText(GText("UI_AsyncComcast_BaseContributionReward"))
    self.Reward02:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Image_722:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.TextFail:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.TextWait:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if bSatisfyBaseDevote then
      self.Reward01.TextDone:SetText(GText("UI_AsyncCombat_MetRequirement"))
      self.Reward01:PlayAnimation(self.Reward01.Done)
    else
      local DeltaDevote = self.BaseRewardNeedDevote - self.CurDevote
      local DeltaPercentText = self:FormatPercent(DeltaDevote, "ceil")
      self.Reward01.TextDone:SetText(string.format(GText("UI_AsyncCombat_NeedMoreContribution"), DeltaPercentText))
      self.Reward01:PlayAnimation(self.Reward01.Lock)
    end
    return
  end
  local bMVPorRoomOwner = self.bMVP or self.bRoomOwner
  if self.bAllPassed and not bMVPorRoomOwner and not bSatisfyBaseDevote then
    self.Progress_Node_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.TextFail:SetVisibility(UIConst.VisibilityOp.Visible)
    self.TextWait:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Progress_Node_1:SetVisibility(UIConst.VisibilityOp.Visible)
    self.TextFail:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Reward01.TextReward:SetText(GText("UI_AsyncComcast_BaseContributionReward"))
    if self.bMVP then
      self.Reward01:SetVisibility(UIConst.VisibilityOp.Visible)
      self.Image_722:SetVisibility(UIConst.VisibilityOp.Visible)
      self.Reward02.TextReward:SetText(GText("UI_AsyncCombat_MVPBonus2"))
      self.Reward02:SetVisibility(UIConst.VisibilityOp.Visible)
      if bSatisfyBaseDevote then
        self.Reward01.TextDone:SetText(GText("UI_AsyncCombat_MetRequirement"))
        self.Reward02.TextDone:SetText(GText("UI_AsyncCombat_MetRequirement"))
        self.Reward01:PlayAnimation(self.Reward01.Done)
        self.Reward02:PlayAnimation(self.Reward02.Done)
      else
        local DeltaDevote = self.BaseRewardNeedDevote - self.CurDevote
        local DeltaPercentText = self:FormatPercent(DeltaDevote, "ceil")
        self.Reward01.TextDone:SetText(string.format(GText("UI_AsyncCombat_NeedMoreContribution"), DeltaPercentText))
        self.Reward02.TextDone:SetText(GText("UI_AsyncCombat_MetRequirement"))
        self.Reward01:PlayAnimation(self.Reward01.Lock)
        self.Reward02:PlayAnimation(self.Reward02.Done)
      end
      self.TextWait:SetVisibility(UIConst.VisibilityOp.Visible)
      if self.bAllPassed then
        self.TextWait:SetText(GText("UI_AsyncCombat_ClaimRewardTip"))
      else
        self.TextWait:SetText(GText("UI_AsyncCombat_ClearRewardTip") .. GText("UI_AsyncCombat_MVPRewardCondition"))
      end
    elseif self.bRoomOwner then
      self.Reward01:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Image_722:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Reward02.TextReward:SetText(GText("UI_AsyncComcast_HostReward"))
      self.Reward02:SetVisibility(UIConst.VisibilityOp.Visible)
      if bSatisfyBaseDevote then
        self.Reward01.TextDone:SetText(GText("UI_AsyncCombat_MetRequirement"))
        self.Reward02.TextDone:SetText(GText("UI_AsyncCombat_MetRequirement"))
        self.Reward01:PlayAnimation(self.Reward01.Done)
        self.Reward02:PlayAnimation(self.Reward02.Done)
      else
        local DeltaDevote = self.BaseRewardNeedDevote - self.CurDevote
        local DeltaPercentText = self:FormatPercent(DeltaDevote, "ceil")
        self.Reward01.TextDone:SetText(string.format(GText("UI_AsyncCombat_NeedMoreContribution"), DeltaPercentText))
        self.Reward02.TextDone:SetText(GText("UI_AsyncCombat_MetRequirement"))
        self.Reward02:PlayAnimation(self.Reward02.Done)
      end
      self.TextWait:SetVisibility(UIConst.VisibilityOp.Visible)
      if self.bAllPassed then
        self.TextWait:SetText(GText("UI_AsyncCombat_ClaimRewardTip"))
      else
        self.TextWait:SetText(GText("UI_AsyncCombat_ClearRewardTip"))
      end
    else
      self.Reward01:SetVisibility(UIConst.VisibilityOp.Visible)
      self.Reward02.TextReward:SetText(GText("UI_AsyncCombat_MVPBonus2"))
      if bSatisfyBaseDevote then
        local DeltaDevote = self.MVPDevote - self.CurDevote
        local DeltaPercentText = self:FormatPercent(DeltaDevote, "ceil")
        self.Reward01.TextDone:SetText(GText("UI_AsyncCombat_MetRequirement"))
        self.Reward02.TextDone:SetText(string.format(GText("UI_AsyncCombat_NeedMoreContribution"), DeltaPercentText))
        self.Reward02:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Image_722:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Reward01:PlayAnimation(self.Reward01.Done)
        self.Reward02:PlayAnimation(self.Reward02.Lock)
      else
        local DeltaDevote = self.BaseRewardNeedDevote - self.CurDevote
        local DeltaPercentText = self:FormatPercent(DeltaDevote, "ceil")
        self.Reward01.TextDone:SetText(string.format(GText("UI_AsyncCombat_NeedMoreContribution"), DeltaPercentText))
        self.Reward02:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Image_722:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Reward01:PlayAnimation(self.Reward01.Lock)
        self.Reward02:PlayAnimation(self.Reward02.Lock)
      end
      if self.bAllPassed then
        self.TextWait:SetVisibility(UIConst.VisibilityOp.Visible)
        self.TextWait:SetText(GText("UI_AsyncCombat_ClaimRewardTip"))
      else
        self.TextWait:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    end
  end
end

function M:FormatPercent(Percent, RoundMode)
  RoundMode = RoundMode or "round"
  local percent
  if "round" == RoundMode then
    percent = (Percent or 0) / 100
  else
    local scaled = (Percent or 0) / 10
    local roundedScaled
    if "floor" == RoundMode then
      roundedScaled = math.floor(scaled)
    elseif "ceil" == RoundMode then
      roundedScaled = math.ceil(scaled)
    else
      roundedScaled = math.floor(scaled + 0.5)
    end
    percent = roundedScaled / 10
  end
  local text = string.format("%.1f", percent)
  text = text:gsub("%.0$", "")
  if CommonConst.SystemLanguage == CommonConst.SystemLanguages.FR then
    text = CommonUtils.FormatNumInFrench(text)
  end
  return text
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnExitDungeon, self)
  if self.RemoveTimer then
    self:RemoveTimer("CoopSettlementCountDown")
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
  DebugPrint("yly WBP_Activity_Coop_Settlement_P_C RefreshOpInfoByInputDevice CurGamepadName", CurGamepadName)
  DebugPrint("yly WBP_Activity_Coop_Settlement_P_C RefreshOpInfoByInputDevice CurInputDevice", CurInputDevice)
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
  if self.BtnExit == nil or nil == self.BtnExit.WBP_Com_KeyImg then
    return
  end
  if nil == self.BtnAgain or nil == self.BtnAgain.WBP_Com_KeyImg then
    return
  end
  if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
    self.BtnExit.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.BtnAgain.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.BtnExit.WBP_Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
        }
      }
    })
    self.BtnAgain.WBP_Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop
        }
      }
    })
    self:AddTimer(0.1, function()
      self.BtnExit.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.BtnAgain.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end)
  end
end

function M:Handle_OnGamePadDown(InKeyName)
  if "Gamepad_FaceButton_Right" == InKeyName then
    if self.BtnExit:IsVisible() then
      self.BtnExit.Btn.OnClicked:Broadcast()
    end
    return true
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    if self.BtnAgainPanel:IsVisible() and self:ShouldBtnAgainEnabled() then
      self.BtnAgain.Btn.OnClicked:Broadcast()
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
    DebugPrint("yly WBP_Activity_Coop_Settlement_P_C OnKeyDown Key_IsGamepadKey", InKeyName)
    IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
  else
    DebugPrint("yly WBP_Activity_Coop_Settlement_P_C OnKeyDown Key_IsPC", InKeyName)
    IsEventHandled = self:Handle_OnPCDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

return M
