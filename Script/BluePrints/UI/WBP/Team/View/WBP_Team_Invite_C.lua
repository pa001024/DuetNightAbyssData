require("UnLua")
local UIUtils = require("Utils.UIUtils")
local InviteQueueManager = require("BluePrints.UI.Common.InviteQueueManager")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  M.Super.Construct(self)
  local RejectTime = DataMgr.GlobalConstant.InviteRejectTime.ConstantValue
  self.Text_Tip:SetText(string.format(GText("UI_Team_Ignore"), RejectTime))
  self.BtnYes_Mobile:BindEventOnClicked(self, self.OnBtnClick, true)
  
  function self.BtnYes_Mobile.SoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/team_btn_small_check", nil, nil)
  end
  
  self.BtnYes_PC:SetBtnNormalCallback(function()
    self:OnBtnClick(true)
  end)
  self.BtnYes_PC:SetText(GText("UI_BTN_AGREE"))
  self.BtnNo_Mobile:BindEventOnClicked(self, self.OnBtnClick, false)
  
  function self.BtnNo_Mobile.SoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel", nil, nil)
  end
  
  self.BtnNo_PC:SetBtnNormalCallback(function()
    self:OnBtnClick(false)
  end)
  self.BtnNo_PC:SetText(GText("UI_BTN_REJECT"))
  self.Bar_CountDown:SetPercent(1)
  EventManager:FireEvent(EventID.OnEnableGuideBookKey, false)
  self.CheckBox_Tip.KeyHolder:ClearChildren()
  local AddStyleKey = UIManager(self):CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyAdd.WBP_Com_KeyAdd_C")
  self.CheckBox_Tip.Com_KeyImg = AddStyleKey
  self.CheckBox_Tip.KeyHolder:AddChild(AddStyleKey)
  self.CheckBox_Tip:BindEventOnClicked({
    Inst = self,
    Func = self.OnCheckBoxChange
  })
  TeamController:SetTeamPopupBarOpen(true)
  InviteQueueManager:RegisterEvent(self, function(self, EventId, ...)
    if "InviteWaiting" == EventId then
      local Percent = (...)
      self.Bar_CountDown:SetPercent(Percent)
      if Percent <= 0 then
        if self.InviteType ~= InviteQueueManager.InviteType.Team then
          InviteQueueManager:FinishCurrentInvite(self.InviteType)
        else
          self:OnBtnClick(false)
        end
      end
    end
  end)
  if TeamController:IsMobile() then
    local InvitePanelSlot = UWidgetLayoutLibrary.SlotAsOverlaySlot(self.Panel_Invite)
    if InvitePanelSlot then
      local Margin = FMargin(0, 0, 0, 0)
      Margin.Top = self.Offset_M
      InvitePanelSlot:SetPadding(Margin)
    end
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
  else
    UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Add(self, self.OnInputDeviceChange)
    self:OnInputDeviceChange()
    self:AddDispatcher(EventID.GameViewportInputKeyReleased, self, function(self, Key)
      if Key.KeyName == "Y" then
        self:OnBtnClick(true)
      elseif Key.KeyName == "N" then
        self:OnBtnClick(false)
      elseif Key.KeyName == UIConst.GamePadKey.LeftShoulder then
        self.bLBPressed = false
      end
    end)
    self:AddDispatcher(EventID.GameViewportInputKeyPressed, self, function(self, Key)
      DebugPrint("OnInputKey_Lua" .. EventID.GameViewportInputKeyPressed, Key)
      if Key.KeyName == UIConst.GamePadKey.SpecialRight then
        self:OnBtnClick(true)
      elseif Key.KeyName == UIConst.GamePadKey.SpecialLeft then
        self:OnBtnClick(false)
      elseif Key.KeyName == UIConst.GamePadKey.DPadLeft then
        if self.bLBPressed then
          self.CheckBox_Tip:SetIsChecked(not self.CheckBox_Tip:IsChecked())
          self.bLBPressed = false
        end
      elseif Key.KeyName == UIConst.GamePadKey.LeftShoulder then
        self.bLBPressed = true
      end
    end)
  end
  self:AddDispatcher(EventID.CloseLoading, self, function()
    DebugPrint(LXYTag, "组队邀请超时，需要自动关闭界面")
    if InviteQueueManager:IsEmpty() then
      self:Close("EventID.CloseLoading timeout autoClose")
    end
  end)
  AudioManager(self):PlayUISound(self, "event:/ui/common/team_invite_bar_show", nil, nil)
end

function M:Close(reason)
  DebugPrint("TeamInviteView::Close", reason)
  if not self.IsBeginToClose then
    M.Super.Close(self)
  end
end

function M:OnInputDeviceChange()
  if TeamController:IsGamepad() then
    self.Key_No:CreateSubKeyDesc({
      Type = "Img",
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "View"}
      },
      Desc = GText("UI_BTN_REJECT")
    })
    self.Key_Yes:CreateSubKeyDesc({
      Type = "Img",
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Menu"}
      },
      Desc = GText("UI_BTN_AGREE")
    })
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(2)
    self.CheckBox_Tip.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.CheckBox_Tip.Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LB"},
        {Type = "Img", ImgShortPath = "Left"}
      },
      Type = "Add"
    })
    self.CheckBox_Tip:SetKey("Img", "Left", self.BtnYes_Mobile.SoundFunc)
  elseif not TeamController:IsMobile() then
    self.BtnYes_PC:GetKeyWidget():CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "Y"}
      },
      SoundFunc = self.BtnYes_Mobile.SoundFunc
    })
    self.BtnNo_PC:GetKeyWidget():CreateCommonKey({
      Type = "Img",
      KeyInfoList = {
        {Type = "Text", Text = "N"}
      },
      SoundFunc = self.BtnNo_Mobile.SoundFunc
    })
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
    self.CheckBox_Tip.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnFocusLost(InFocusEvent)
  self:SetFocus()
end

function M:OnCheckBoxChange(bChecked)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:InitUIInfo(Name, bInUIMode, EventList, ...)
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  M.Super.InitUIInfo(self, Name, bInUIMode, EventList)
  self.InviteInfo, self.InviteType = ...
  self.Bar_CountDown:SetPercent(1)
  self.CheckBox_Tip:SetIsChecked(false)
  self.Text_Name:SetText(self.InviteInfo.Nickname)
  self.Text_Level:SetText(self.InviteInfo.Level)
  self.Item_Head:SetHeadIconById(self.InviteInfo.HeadIconId)
  self.Item_Head:SetHeadFrame(self.InviteInfo.HeadFrameId)
  if self.InviteType == InviteQueueManager.InviteType.Friend then
    self.Panel_Tip:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Title:SetText(GText("UI_Friend_FriendRequest"))
    self.Text_Request:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_Request:SetText(self.InviteInfo.Remark)
  elseif self.InviteType == InviteQueueManager.InviteType.Team then
    self.Panel_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Title:SetText(GText("UI_Team_Invitation"))
    self.Text_Request:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif self.InviteType == InviteQueueManager.InviteType.Guild then
    self.Panel_Tip:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Title:SetText(GText("UI_GuildInvitation"))
    self.Text_Request:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if TeamController:IsMobile() then
    self.CheckBox_Tip.KeyHolder:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnBtnClick(bYes)
  if bYes then
    InviteQueueManager:AcceptCurrent()
  else
    local bAutoRefuse = self.CheckBox_Tip:IsChecked()
    InviteQueueManager:RefuseCurrent(bAutoRefuse)
  end
end

function M:FakeClose(Cb)
  self:PlayAnimation(self.Auto_Out)
  self:BindToAnimationFinished(self.Auto_Out, {
    self,
    function()
      self:UnbindAllFromAnimationFinished(self.Auto_Out)
      self:SetVisibility(UIConst.VisibilityOp.Collapsed)
      if Cb then
        Cb()
      end
    end
  })
end

function M:Destruct()
  self.BtnNo_Mobile:UnBindEventOnClicked(self, self.OnBtnClick)
  self.BtnYes_Mobile:UnBindEventOnClicked(self, self.OnBtnClick)
  self.BtnYes_PC:SetBtnNormalCallback(nil)
  self.BtnNo_PC:SetBtnNormalCallback(nil)
  self.CheckBox_Tip:UnBindEventOnClickedByObj(self)
  InviteQueueManager:UnRegisterEvent(self)
  TeamController:SetTeamPopupBarOpen(false)
  if not TeamController:IsMobile() then
    UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Remove(self, self.OnInputDeviceChange)
  end
  EventManager:FireEvent(EventID.OnEnableGuideBookKey, true)
  M.Super.Destruct(self)
end

function M:OnKeyDown(MyGeo, InKeyEvent)
  DebugPrint(LXYTag, "TeamInvite:::OnKeyDown")
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
