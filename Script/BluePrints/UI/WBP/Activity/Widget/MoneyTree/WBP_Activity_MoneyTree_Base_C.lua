require("UnLua")
local MoneyTreeMgr = require("BluePrints.UI.WBP.Activity.Widget.MoneyTree.MoneyTreeMgr")
local M = Class("BluePrints.UI.BP_UIState_C")
local TXT = {
  ClaimFirst = "MoneyTree_ClaimFirst",
  MutexBySingle = "MoneyTree_MutexBySingle",
  TimeNotEnough = "MoneyTree_TimeNotEnough",
  AllUnlocked = "MoneyTree_AllUnlockedToast",
  AutoRange = "MoneyTree_AutoRange",
  NotOpen = "MoneyTree_NotOpen",
  AlreadyClaimed = "MoneyTree_AlreadyClaimed",
  AlreadyDoubled = "MoneyTree_AlreadyDoubled",
  BonusDouble = "MoneyTree_Double"
}
local COUNTDOWN_TIMER_KEY = "MoneyTreeCountDown"
local REWARD_PREVIEW_POPUP_ID = 100435
local SOUND_EVENT = {
  Entry = "event:/ui/activity/yidefujiao_entrance_oneshot",
  PayButton = "event:/ui/activity/wenmingboyi_gift_btn_click",
  ClaimButton = "event:/ui/activity/wenmingboyi_challenge_btn_click",
  Punch = "event:/ui/activity/yidefujiao_punch",
  PunchTriple = "event:/ui/activity/yidefujiao_punch_triple"
}

local function Toast(self, TextKey)
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(TextKey))
end

function M:OnLoaded(...)
  self:InitComTab()
  self:SetupChildren()
  self.bIsFocusable = true
  self:FocusSelfForKeyboard()
  self:RegisterInputModeListener()
  MoneyTreeMgr.RefreshFromServer(function(_)
    self:RefreshAll()
    self:PlayEntryEffects()
  end)
  MoneyTreeMgr.AddListener(self, self.OnStateChanged, self.OnPaySuccess)
end

function M:PlayEntryEffects()
  AudioManager(self):PlayUISound(self, SOUND_EVENT.Entry, nil, nil)
  if self.In then
    self:PlayAnimation(self.In)
  end
  if self.BG_MoneyTree and self.BG_MoneyTree.In then
    self.BG_MoneyTree:PlayAnimation(self.BG_MoneyTree.In)
  end
  if self.Btn_Get and self.Btn_Get.PlayEntryAnim then
    self.Btn_Get:PlayEntryAnim()
  end
end

function M:FocusSelfForKeyboard()
  if UIUtils.IsGamepadInput() then
    return
  end
  self:AddTimer(0.05, function()
    if not IsValid(self) then
      return
    end
    self:SetFocus()
  end, false)
end

function M:InitComTab()
  if not self.Com_Tab then
    return
  end
  local EventId = MoneyTreeMgr.GetActiveEventId()
  local EventInfo = EventId and DataMgr.EventMain and DataMgr.EventMain[EventId]
  self.Com_Tab:Init({
    TitleName = EventInfo and EventInfo.EventName and GText(EventInfo.EventName) or "",
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    BackCallback = self.CloseSelf,
    OwnerPanel = self
  })
  self:LoadTimeWidget()
end

function M:LoadTimeWidget()
  local ComTab = self.Com_Tab
  if not ComTab or not ComTab.Pos_Common then
    return
  end
  ComTab.Pos_Common:ClearChildren()
  ComTab.Pos_Common:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.TimeWidget = UIManager(self):_CreateWidgetNew("ActivityMoneyTreeTime")
  if not IsValid(self.TimeWidget) then
    return
  end
  ComTab.Pos_Common:AddChild(self.TimeWidget)
  self:RefreshLeftTime()
  self:AddTimer(1.0, self.RefreshLeftTime, true, nil, COUNTDOWN_TIMER_KEY, true)
end

function M:RefreshLeftTime()
  if not IsValid(self.TimeWidget) or not IsValid(self.TimeWidget.Com_Time) then
    return
  end
  local TimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(MoneyTreeMgr.GetEndTime())
  self.TimeWidget.Com_Time:SetTimeText(GText("UI_GameEvent_EventTimeRemain"), TimeDict)
  if 0 == TimeCount then
    self:RemoveTimer(COUNTDOWN_TIMER_KEY)
  end
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  self:RefreshAll()
end

function M:SetupChildren()
  if self.Btn_Get then
    self.Btn_Get:SetClickCallback(self, self.OnClickClaim)
  end
  if self.Btn_Reward_S then
    self.Btn_Reward_S:SetClickCallback(self, self.OnClickSingleDouble)
  end
  if self.Btn_Reward then
    self.Btn_Reward:SetClickCallback(self, self.OnClickAllUnlock)
  end
  if self.Btn_RewardPre then
    self.Btn_RewardPre:SetClickCallback(self, self.OnClickRewardPreview)
  end
end

function M:OnClickClaim()
  if self.bClaiming then
    return
  end
  if not MoneyTreeMgr.CanClaim() then
    return
  end
  AudioManager(self):PlayUISound(self, SOUND_EVENT.ClaimButton, nil, nil)
  self.bClaiming = true
  MoneyTreeMgr.Claim(function(ErrCode, RewardCount, DoubleReward, ResourceId)
    if not IsValid(self) then
      return
    end
    self.bClaiming = false
    if not self:CheckRpc(ErrCode) then
      return
    end
    local bIsSpecial = (DoubleReward or 0) > 0
    local Duration = self:PlayClaimEffect(bIsSpecial)
    self:RefreshAll()
    local TotalReward = (RewardCount or 0) + (DoubleReward or 0)
    self:AddTimer(Duration, function()
      if IsValid(self) then
        self:ShowGetReward(TotalReward, ResourceId, bIsSpecial)
      end
    end, false)
  end)
end

function M:OnClickSingleDouble()
  if not MoneyTreeMgr.CanSingleDouble() then
    local State = MoneyTreeMgr.GetState()
    if not State.Claimed then
      Toast(self, TXT.ClaimFirst)
    elseif State.AllUnlocked then
      Toast(self, TXT.AutoRange)
    end
    return
  end
  AudioManager(self):PlayUISound(self, SOUND_EVENT.PayButton, nil, nil)
  UIManager(self):ShowCommonPopupUI(100420, {
    RightCallbackFunction = function()
      self:DoSingleDouble()
    end
  }, self)
end

function M:DoSingleDouble()
  MoneyTreeMgr.SingleDouble(function(ErrCode)
    if not IsValid(self) then
      return
    end
    self:CheckRpc(ErrCode)
  end)
end

function M:OnClickAllUnlock()
  local State = MoneyTreeMgr.GetState()
  if State.AllUnlocked then
    Toast(self, TXT.AllUnlocked)
    return
  end
  if State.SingleUsed then
    Toast(self, TXT.MutexBySingle)
    return
  end
  if MoneyTreeMgr.IsAllUnlockTimeBlocked() then
    Toast(self, TXT.TimeNotEnough)
    return
  end
  if not MoneyTreeMgr.CanAllUnlock() then
    return
  end
  AudioManager(self):PlayUISound(self, SOUND_EVENT.PayButton, nil, nil)
  UIManager(self):ShowCommonPopupUI(100421, {
    RightCallbackFunction = function()
      self:DoAllUnlock()
    end,
    HideItemTips = not MoneyTreeMgr.ShouldWarnPrice()
  }, self)
end

function M:DoAllUnlock()
  if not MoneyTreeMgr.CanAllUnlock() then
    return
  end
  MoneyTreeMgr.AllUnlock(function(ErrCode)
    if not IsValid(self) then
      return
    end
    self:CheckRpc(ErrCode)
  end)
end

function M:OnClickRewardPreview()
  UIManager(self):ShowCommonPopupUI(REWARD_PREVIEW_POPUP_ID, {}, self)
end

function M:OnStateChanged()
  self:RefreshAll()
end

function M:OnPaySuccess(PayType, ExtraReward, ResourceId)
  if (ExtraReward or 0) > 0 then
    self:ShowGetReward(ExtraReward, ResourceId, true)
  end
  self:RefreshAll()
end

function M:CheckRpc(ErrCode)
  if ErrorCode:Check(ErrCode) then
    return true
  end
  local ErrTextMap = {
    [ErrorCode.RET_MONEY_TREE_NOT_OPEN] = TXT.NotOpen,
    [ErrorCode.RET_MONEY_TREE_ALREADY_CLAIMED] = TXT.AlreadyClaimed,
    [ErrorCode.RET_MONEY_TREE_CLAIM_FIRST] = TXT.ClaimFirst,
    [ErrorCode.RET_MONEY_TREE_ALREADY_DOUBLED] = TXT.AlreadyDoubled,
    [ErrorCode.RET_MONEY_TREE_ALL_UNLOCKED] = TXT.AutoRange,
    [ErrorCode.RET_MONEY_TREE_SINGLE_USED] = TXT.MutexBySingle,
    [ErrorCode.RET_MONEY_TREE_ALL_UNLOCKED_ALREADY] = TXT.AllUnlocked,
    [ErrorCode.RET_MONEY_TREE_NO_REMAINING_DAY] = TXT.TimeNotEnough
  }
  local TextKey = ErrTextMap[ErrCode]
  if TextKey then
    Toast(self, TextKey)
  end
  return false
end

function M:RefreshAll()
  if self.Btn_Get then
    self.Btn_Get:Refresh()
  end
  if self.Btn_Reward_S then
    self.Btn_Reward_S:Refresh()
  end
  if self.Btn_Reward then
    self.Btn_Reward:Refresh()
  end
  if self.Btn_RewardPre then
    self.Btn_RewardPre:Refresh()
  end
  if self.Bubble then
    self.Bubble:Refresh()
  end
end

function M:PlayClaimEffect(bIsSpecial)
  local BGWidget = self.BG_MoneyTree
  if not BGWidget then
    return 0
  end
  local Anim = bIsSpecial and BGWidget.Special_Obtain or BGWidget.Normal_Obtain
  if not Anim then
    return 0
  end
  local SoundEvent = bIsSpecial and SOUND_EVENT.PunchTriple or SOUND_EVENT.Punch
  AudioManager(self):PlayUISound(self, SoundEvent, nil, nil)
  BGWidget:PlayAnimation(Anim)
  return Anim:GetEndTime() or 0
end

function M:ShowGetReward(Amount, ResourceId, bDoubled)
  if not Amount or Amount <= 0 then
    return
  end
  local ResId = ResourceId and ResourceId > 0 and ResourceId or 100
  local Params = {
    Resources = {
      [ResId] = Amount
    }
  }
  if bDoubled then
    Params.BonusInfo = {
      [ResId] = {
        BonusType = 1,
        ExtraBonusText = GText(TXT.BonusDouble)
      }
    }
  end
  UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Params, false, nil, self)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:HandleGamePadKey(InKeyName)
  elseif "Escape" == InKeyName then
    if not UIManager(self):GetUIObj("CommonDialog") then
      IsEventHandled = true
      self:CloseSelf()
    end
  else
    IsEventHandled = self.Com_Tab and self.Com_Tab:Handle_KeyEventOnPC(InKeyName) or false
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:HandleGamePadKey(InKeyName)
  if UIManager(self):GetUIObj("CommonDialog") then
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:OnClickClaim()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:OnClickSingleDouble()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnClickAllUnlock()
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
    self:OnClickRewardPreview()
    return true
  end
  return self.Com_Tab and self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName) or false
end

function M:RegisterInputModeListener()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.InputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.InputModeSubsystem) then
    self.InputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function M:OnInputMethodChanged(CurInputType, CurGamepadName)
  self:RefreshAll()
  self:FocusSelfForKeyboard()
end

function M:CloseSelf()
  EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
  EventManager:FireEvent(EventID.OnReturnToActivityEntry)
  if self.Out then
    self:BindToAnimationFinished(self.Out, {
      self,
      function()
        self:Close()
      end
    })
    self:PlayAnimation(self.Out)
  else
    self:Close()
  end
end

function M:OnDestroyed()
  MoneyTreeMgr.RemoveListener(self)
  if IsValid(self.InputModeSubsystem) then
    self.InputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
    self.InputModeSubsystem = nil
  end
  self:RemoveTimer(COUNTDOWN_TIMER_KEY)
  if IsValid(self.TimeWidget) then
    self.TimeWidget:RemoveFromParent()
    self.TimeWidget = nil
  end
  M.Super.OnDestroyed(self)
end

return M
