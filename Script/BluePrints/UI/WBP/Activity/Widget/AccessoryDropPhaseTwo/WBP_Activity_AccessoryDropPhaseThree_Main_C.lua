require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnPressESC()
  self:Close()
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  self:SetDefaultFocus()
end

function M:Construct()
  self:InitView()
  self:SetDefaultFocus()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:Destruct()
  self:RemoveInputMethodChangedListen()
  self:RemoveTimer("UpdateTime")
end

function M:RefreshUI()
  self:InitView(self.ActivityConfigData, self.PageConfigData, true)
end

function M:InitView()
  self.EventId = 10302004
  local ActivityConfigData = DataMgr.EventMain[self.EventId]
  self.ActivityConfigData = ActivityConfigData
  self.CurActivityId = ActivityConfigData.EventId
  self.PageConfigData = DataMgr.EventPortal[self.EventId]
  local IsRefresh = false
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
  self.Btn_Open.Icon_Coin.ItemDetails_MenuAnchor:SetLastFocusWidget(self.Btn_Open)
  self.Btn_Shop:InitView(self.AccessDropConfig, AccessoryDrop, IsRefresh)
  if not IsRefresh then
    self.Btn_Open:SetOpenFunc({
      Func = self.OpenBox,
      Obj = self
    })
    self:PlayAnimation(self.In)
    self.BG:PlayAnimationIn()
    self:AddTimer(1.0, self.UpdateTime, true, 0, "UpdateTime", true)
  end
  self:InitTab()
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

function M:OpenBox()
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  local CallbackInfo = {
    Func = function(_Self, Rewards)
      local RedDotName = DataMgr.EventMain[self.EventId].ReddotNode
      ReddotManager.DecreaseLeafNodeCount(RedDotName, 1, {
        CacheKey = "Red",
        EventId = self.EventId
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
  self:BlockAllUIInput(false)
end

function M:PlayAnimationOpenCallback()
  self:PlayAnimation(self.Change)
  self:RefreshUI()
  self:SetDefaultFocus()
end

function M:ShowResourceInfo()
  if 0 == self.Btn_Open.WS_Type:GetActiveWidgetIndex() then
    return self.Btn_Open:OnResourceClick()
  end
  return false
end

function M:InitTab()
  local TitleName = GText("Event_Title_103020")
  local ResourceId = DataMgr.BoxDrop[self.EventId].BoxCoinId
  local BoxCoin = GWorld:GetAvatar().Resources[ResourceId]
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

function M:AddInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RemoveInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurInputDevice)
  self.Btn_Open:OnInputMethodChanged(CurInputType, CurInputDevice)
  if CurInputType == ECommonInputType.Gamepad then
  else
  end
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.DPadRight then
    IsEventHandled = self:ShowResourceInfo()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop and not self.OnStuffDetailOpen and 0 == self.Btn_Open.WS_Type:GetActiveWidgetIndex() then
    self.Btn_Open:OnClicked()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:SetDefaultFocus()
  self:SetFocus()
end

function M:OnFocusReceived()
  self:SetFocus()
end

return M
