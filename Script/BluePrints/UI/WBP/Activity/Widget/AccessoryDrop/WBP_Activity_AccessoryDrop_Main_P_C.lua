require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:BindInputMethodChangedDelegate()
end

function M:Destruct()
  self:UnBindInputMethodChangedDelegate()
  self:PlayAnimation(self.Out)
  self:RemoveTimer("UpdateTime")
  AudioManager(self):SetEventSoundParam(self, "fengrao02_entrance_loop", {ToEnd = 1})
  AudioManager(self):StopSound(self, "fengrao02_entrance_loop")
end

function M:RefreshUI()
  self:InitUI(self.ActivityConfigData, self.PageConfigData, self.ParentTabId, self.ParentWidget, true)
end

function M:InitUI(ActivityConfigData, PageConfigData, ParentTabId, ParentWidget, IsRefresh)
  self.ActivityConfigData = ActivityConfigData
  self.EventId = ActivityConfigData.EventId
  self.CurActivityId = ActivityConfigData.EventId
  self.ParentTabId = ParentTabId
  self.ParentWidget = ParentWidget
  self.PageConfigData = PageConfigData
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    local RedDotName = DataMgr.EventMain[self.EventId].ReddotNode
    ReddotManager.DecreaseLeafNodeCount(RedDotName, 1, {
      CacheKey = "Red",
      EventId = self.EventId
    })
    return 0
  end
  self.AccessDropConfig = self:GetAccessDropConfig()
  local AccessoryDrop = Avatar.AccessoryDrops[self.EventId]
  local nextAddDropBoxNumTime = math.floor(TimeUtils.NextDailyRefreshTime())
  self.GachaNum.Text_Num:SetText(GText(tostring(AccessoryDrop.CurDropBoxNum)))
  self.GachaNum.Text_Total:SetText(GText(tostring(self.AccessDropConfig.BoxMaximum)))
  if AccessoryDrop.CurDropBoxNum == self.AccessDropConfig.BoxMaximum then
    self.GachaNum.Max.Text_Max:SetText(GText(tostring("Event_FreeAppearance_tips03")))
    self.GachaNum.Max:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.GachaNum.Text_x:SetColorAndOpacity(self.GachaNum.Color_Max)
    self.GachaNum.Text_Num:SetColorAndOpacity(self.GachaNum.Color_Max)
    if nextAddDropBoxNumTime > ActivityConfigData.EventEndTime then
      self.Tips.Text_Tips01:SetText("")
      self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.Tips.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips08"))
      self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Text_Tips01:SetText("")
      self.Tips.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips05"))
      self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
  else
    self.GachaNum.Max:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.GachaNum.Text_x:SetColorAndOpacity(self.GachaNum.Color_Normal)
    self.GachaNum.Text_Num:SetColorAndOpacity(self.GachaNum.Color_Normal)
    if 0 ~= AccessoryDrop.CurDropBoxNum then
      if nextAddDropBoxNumTime > ActivityConfigData.EventEndTime then
        self.Tips.Text_Tips01:SetText("")
        self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Tips.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips08"))
        self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      else
        self.Tips.Text_Tips01:SetText("")
        self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Tips.Time:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Tips.Text_Tips02:SetText(string.format(GText("Event_FreeAppearance_tips04"), self.AccessDropConfig.BoxPerDay))
        self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      end
    elseif nextAddDropBoxNumTime > ActivityConfigData.EventEndTime then
      self.Tips.Text_Tips01:SetText("")
      self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.Tips.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips08"))
      self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Time:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips07"))
      self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    self:UpdateTime()
  end
  self.Btn_Open:InitView(self.AccessDropConfig, AccessoryDrop, IsRefresh)
  self.Btn_Open.Icon_Coin.ItemDetails_MenuAnchor:SetLastFocusWidget(self.ParentWidget.CurFocusWidgetItem)
  self.Coin:InitView(self.AccessDropConfig, AccessoryDrop, IsRefresh)
  self.Btn_Shop:InitView(self.AccessDropConfig, AccessoryDrop, IsRefresh)
  if self:IsShowCoin() then
    self.Coin:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Coin:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if not IsRefresh then
    self.Btn_Open:SetOpenFunc({
      Func = self.OpenBox,
      Obj = self
    })
    self:PlayAnimation(self.In)
    self.BG:PlayAnimationIn()
    self:AddTimer(1.0, self.UpdateTime, true, 0, "UpdateTime", true)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/fengrao02_entrance_loop", "fengrao02_entrance_loop", nil)
end

function M:UpdateTime()
  local AccessoryDrop = GWorld:GetAvatar().AccessoryDrops[self.EventId]
  local nextAddDropBoxNumTime = math.floor(TimeUtils.NextDailyRefreshTime())
  self.nextAddDropBoxNumTime = nextAddDropBoxNumTime
  local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(nextAddDropBoxNumTime, TimeUtils.NowTime())
  self.Tips.Time:SetTimeText("", RemainTimeDict)
  self.Btn_Shop:UpdateTime()
end

function M:GetAccessDropConfig()
  return DataMgr.BoxDrop[self.EventId]
end

function M:IsTheSameDay(timeStampA, timeStampB)
  timeStampA = math.tointeger(timeStampA)
  local dateA = os.date("!*t", timeStampA)
  timeStampB = math.tointeger(timeStampB)
  local dateB = os.date("!*t", timeStampB)
  return dateA.year == dateB.year and dateA.month == dateB.month and dateA.day == dateB.day
end

function M:IsShowCoin()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local EventInfo = DataMgr.EventMain[self.EventId]
  if not EventInfo then
    ScreenPrint("EventMain表中找不到止流活动相关信息！读取的EventId:" .. self.EventId)
    return false
  end
  local PrerequisiteQuestId = {}
  if EventInfo.PretextTasks1 then
    table.insert(PrerequisiteQuestId, EventInfo.PretextTasks1)
  end
  for _, QuestId in pairs(EventInfo.PretextTasks2 or {}) do
    table.insert(PrerequisiteQuestId, QuestId)
  end
  for _, QuestId in pairs(PrerequisiteQuestId) do
    local IsQuestFinished = Avatar:IsQuestFinished(QuestId)
    local IsQuestAssumeFinished = Avatar:IsQuestAssumeFinished(QuestId)
    if not IsQuestFinished and not IsQuestAssumeFinished then
      return false
    end
  end
  return true
end

function M:OpenRewardDetails()
  local PreViewReward, RewardContentList = self.PageConfigData.RewardPreview, {}
  local AllRewardList = RewardUtils:GetRewardViewInfoById(PreViewReward)
  AudioManager(self):PlayUISound(self, "event:/ui/common/tip_show_click", nil, nil)
  local Params = {}
  Params.RewardList = AllRewardList
  
  function Params.CloseBtnCallbackFunction()
  end
  
  Params.AutoFocus = true
  local UI = UIManager(self):ShowCommonPopupUI(100331, Params)
end

function M:OpenBox()
  self.ParentWidget:BlockAllUIInput(true, "SP_DisplayOnly")
  local CallbackInfo = {
    Func = function(_Self, Rewards)
      local RedDotName = DataMgr.EventMain[self.AccessDropConfig.EventId].ReddotNode
      ReddotManager.DecreaseLeafNodeCount(RedDotName, 1, {
        CacheKey = "Red",
        EventId = self.AccessDropConfig.EventId
      })
      self.BG:PlayOpenAnim(Rewards, {
        Func = self.PlayAnimationOpenCallback,
        Obj = self
      }, {
        Func = self.OpenRewardViewCallback,
        Obj = self
      })
      AudioManager(self):PlayUISound(self, "event:/ui/activity/fengrao02_box_open", nil, nil)
    end,
    Obj = self
  }
  self.Bg:PlayAnimation(self.Open)
  GWorld:GetAvatar():OpenAccesorryBox(CallbackInfo)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/fengrao02_click", nil, nil)
end

function M:OpenRewardViewCallback()
  self.ParentWidget:BlockAllUIInput(false)
end

function M:PlayAnimationOpenCallback()
  self:PlayAnimation(self.Change)
  self:RefreshUI()
  local MainActivityView = self.ParentWidget
  local JumpView = MainActivityView.AllCurrentActivityPage[MainActivityView.CurTabId]
  JumpView:RefreshRewardList()
end

function M:HandleKeyDownInBg(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadButtonDown(InKeyName)
  else
    IsEventHandled = false
  end
  return IsEventHandled
end

function M:OnGamePadButtonDown(InKeyName)
  local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self.Btn_Shop:GoToShopClick()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if not self.OnStuffDetailOpen and 0 == self.Btn_Open.WS_Type:GetActiveWidgetIndex() then
      self.Btn_Open:OnClicked()
      IsEventHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.DPadRight then
    IsEventHandled = self:ShowResourceInfo()
  end
  return IsEventHandled
end

function M:OnStuffDetailOpenChanged(IsOpen)
  self.OnStuffDetailOpen = IsOpen
end

function M:ShowResourceInfo()
  if 0 == self.Btn_Open.WS_Type:GetActiveWidgetIndex() then
    return self.Btn_Open:OnResourceClick()
  end
  return false
end

function M:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function M:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function M:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  if NewGameInputType == ECommonInputType.Gamepad then
    if self.ParentWidget.CurFocusWidgetItem then
      self.ParentWidget.CurFocusWidgetItem:SetFocus()
    else
      self.ParentWidget.List_Tab:SetFocus()
    end
  end
end

function M:ReceiveEnterStateSelf(StackAction)
  local Avatar = GWorld:GetAvatar()
  local AccessoryDrop = Avatar.AccessoryDrops[self.EventId]
  self.Coin:InitView(self.AccessDropConfig, AccessoryDrop, true)
end

return M
