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
  self.bAllPassed = self.RoomSettleInfo.bAllPassed
  self.CurRound = self.RoomSettleInfo.CurRound
  self.TotalRound = #DataMgr.AsyncCombat[self.RoomSettleInfo.RoomConfId].BossUnitID
  self.CurRoundBossLifeRemain = self.RoomSettleInfo.BossRemainHp
  self.CurRoundBossTotalHp = self.RoomSettleInfo.BossTotalHp
  self.CurDevote = (self.RoomSettleInfo.Damage or 0) / self.RoomSettleInfo.RoomTotalHp * 10000
  self.bRoomOwner = self.RoomSettleInfo.bRoomOwner
  self.bMVP = self.RoomSettleInfo.bMvp
  self.MVPDevote = (self.RoomSettleInfo.MvpDamage or 0) / self.RoomSettleInfo.RoomTotalHp * 10000
  self.BaseRewardNeedDevote = DataMgr.AsyncCombatEventConstant.AsyncCombat_BaseContributionRequire.ConstantValue
  self:InitUIContent()
  if self.bAllPassed then
    self:PlayAnimation(self.In)
  else
    self:PlayAnimation(self.Fail_In)
  end
end

function M:OnInAnimationStarted()
  DebugPrint("yly WBP_Activity_Coop_Settlement_P_C OnInAnimationStarted")
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/lianmeiyanyi_level_success", nil, nil)
end

function M:OnFailInAnimationStarted()
  DebugPrint("yly WBP_Activity_Coop_Settlement_P_C OnFailInAnimationStarted")
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
  local CurStageText = string.format(GText("UI_AsyncCombat_SettleCurrentStages"), self.CurRound)
  local TotalStageText = string.format(GText("UI_AsyncCombat_SettleTotalStages"), self.TotalRound)
  self.TextLevel:SetText(CurStageText .. "/" .. TotalStageText)
  self.VerticalBox_0:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.TextNow:SetText(GText("UI_AsyncCombat_CurrentContribution"))
  local text = self:FormatPercent(self.CurDevote)
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
  self.TextFail:SetText(GText("UI_AsyncCombat_ContributionNotEnough"))
  self.BtnExit.TextCreate:SetText(GText("UI_AsyncCombat_LeaveStage"))
  self.BtnExit.Btn.OnClicked:Add(self, self.ExitCoopSettlement)
  self.BtnExit.Btn.AudioEventPath = "event:/ui/activity/lianmeiyanyi_btn_common_click"
  self:InitExitCountDown()
  self:InitRewardsUI()
end

function M:ExitCoopSettlement()
  DebugPrint("yly WBP_Activity_Coop_Settlement_P_C ExitCoopSettlement")
  if self._IsExitingCoopSettlement then
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

function M:InitRewardsUI()
  local bMVPorRoomOwner = self.bMVP or self.bRoomOwner
  local bSatisfyBaseDevote = self.CurDevote >= self.BaseRewardNeedDevote
  if self.bAllPassed and not bMVPorRoomOwner and not bSatisfyBaseDevote then
    self.Progress_Node_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.TextFail:SetVisibility(UIConst.VisibilityOp.Visible)
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
        local DeltaPercentText = self:FormatPercent(DeltaDevote)
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
        local DeltaPercentText = self:FormatPercent(DeltaDevote)
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
        local DeltaPercentText = self:FormatPercent(DeltaDevote)
        self.Reward01.TextDone:SetText(GText("UI_AsyncCombat_MetRequirement"))
        self.Reward02.TextDone:SetText(string.format(GText("UI_AsyncCombat_NeedMoreContribution"), DeltaPercentText))
        self.Reward02:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Image_722:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Reward01:PlayAnimation(self.Reward01.Done)
        self.Reward02:PlayAnimation(self.Reward02.Lock)
      else
        local DeltaDevote = self.BaseRewardNeedDevote - self.CurDevote
        local DeltaPercentText = self:FormatPercent(DeltaDevote)
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

function M:FormatPercent(Percent)
  local percent = (Percent or 0) / 100
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
  if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
    self.BtnExit.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.BtnExit.WBP_Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
        }
      }
    })
    self:AddTimer(0.1, function()
      self.BtnExit.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end)
  end
end

function M:Handle_OnGamePadDown(InKeyName)
  if "Gamepad_FaceButton_Right" == InKeyName then
    if self.BtnExit:IsVisible() then
      self.BtnExit.Btn.OnClicked:Broadcast()
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
