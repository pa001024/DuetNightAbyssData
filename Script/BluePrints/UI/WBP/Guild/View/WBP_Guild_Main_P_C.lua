require("UnLua")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.KeyInputComponent"
}

function M:Initialize(Initializer)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self:PlayAnimation(self.In)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if self.IsInGuild then
    if 1 == self.Tab.CurrentTab then
      IsHandled = self.GuildInfoPage:OnContentKeyDown(MyGeometry, InKeyEvent)
    elseif 2 == self.Tab.CurrentTab and self.GuildMember then
      IsHandled = self.GuildMember:OnContentKeyDown(MyGeometry, InKeyEvent)
    end
  elseif 1 == self.Tab.CurrentTab then
    IsHandled = self.GuildJoin:OnContentKeyDown(MyGeometry, InKeyEvent)
  else
    IsHandled = self.GuildCreate:OnContentKeyDown(MyGeometry, InKeyEvent)
  end
  if not IsHandled then
    if UIUtils.IsGamepadInput() then
      IsHandled = self:Handle_KeyDownOnGamePad(InKeyName, MyGeometry, InKeyEvent)
    elseif "Q" == InKeyName then
      self.Tab:TabToLeft()
      IsHandled = true
    elseif "E" == InKeyName then
      self.Tab:TabToRight()
      IsHandled = true
    elseif "Escape" == InKeyName then
      if UIManager():GetUIObj("CommonDialog") then
        UIManager():GetUIObj("CommonDialog"):OnClose()
      else
        self:Close()
      end
      IsHandled = true
    end
  end
  if IsHandled then
    return UIUtils.Handled
  else
    return UIUtils.Unhandled
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UIUtils.IsGamepadInput() then
    IsHandled = self:Handle_KeyUpOnGamePad(InKeyName, MyGeometry, InKeyEvent)
  end
  if not IsHandled and not self.IsInGuild then
    if 1 == self.Tab.CurrentTab then
      IsHandled = self.GuildJoin:OnContentKeyUp(MyGeometry, InKeyEvent)
    else
      IsHandled = self.GuildCreate:OnContentKeyUp(MyGeometry, InKeyEvent)
    end
  end
  if IsHandled then
    return UIUtils.Handled
  else
    local ParentHandled = M.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
    if ParentHandled == UIUtils.Handled then
      return ParentHandled
    end
    return UIUtils.Unhandled
  end
end

function M:Handle_KeyUpOnGamePad(InKeyName, MyGeometry, InKeyEvent)
  local IsHandled = false
  if "Gamepad_Special_Right" == InKeyName and self:IsSpecialRightDualPressEnabled() then
    local Reply, bHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
    if not bHandled then
      self.Tab:OnReportGamePadTipReleased()
    end
    IsHandled = true
  end
  return IsHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName, MyGeometry, InKeyEvent)
  local IsHandled = false
  if "Gamepad_LeftShoulder" == InKeyName then
    self.Tab:TabToLeft()
    IsHandled = true
  elseif "Gamepad_RightShoulder" == InKeyName then
    self.Tab:TabToRight()
    IsHandled = true
  elseif "Gamepad_Special_Right" == InKeyName then
    if self:IsSpecialRightDualPressEnabled() then
      local LongPressAnimationTime = math.max(self:GetSpecialRightLongPressDuration() - Const.ShortPressThreshold, 0)
      self.Tab:OnReportGamePadTipPressed(true, 0, LongPressAnimationTime)
      self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
      IsHandled = true
    else
      self.Tab:OnInfoClick()
      IsHandled = true
    end
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    self:Close()
    IsHandled = true
  end
  return IsHandled
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local IsHandled = false
  if 2 == self.Tab.CurrentTab and self.IsInGuild then
    if self.GuildMember then
      IsHandled = self.GuildMember:OnContentFocusReceived(MyGeometry, InFocusEvent)
      return IsHandled
    end
  elseif 1 == self.Tab.CurrentTab and self.IsInGuild and self.GuildInfoPage then
    IsHandled = self.GuildInfoPage:OnContentFocusReceived(MyGeometry, InFocusEvent)
    return IsHandled
  end
  return self.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

function M:Construct()
  self.GuildModel = GuildController:GetModel()
  self.CurrGuildInfo = self.GuildModel:GetCurrGuild()
  self:InitTabInfo()
  self:InitEntrance()
  if self.Key_Controller then
    self.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      }
    })
  end
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:RefreshOpInfoByInputDevice()
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGuildGetList then
      self:BlockAllUIInput(false)
      self:OnGetGuildList()
    elseif EventId == GuildCommon.EventID.OnGuildJoinNotify then
      self.WaitGuildInfo = true
    elseif EventId == GuildCommon.EventID.OnCreateGuild then
      self.WaitGuildInfo = true
    elseif EventId == GuildCommon.EventID.OnGetGuildInfo then
      if self.WaitGuildInfo then
        self.WaitGuildInfo = false
        self:SwitchToInGuild(...)
      end
    elseif EventId == GuildCommon.EventID.OnGuildLeave then
      self:SwitchToNotInGuild()
    elseif EventId == GuildCommon.EventID.OnGuildKickNotify then
      self:BeKickedOut()
    end
  end)
  if self.IsInGuild then
    self:ShowInfo()
  else
    local IsRefresh = GuildController:SendGuildGetList()
    if IsRefresh then
      self.AllGuildList = {}
      self:ShowInfo()
      self:BlockAllUIInput(true, "SP_DisplayOnly")
    else
      self:OnGetGuildList()
    end
  end
end

function M:InitTabInfo()
  self.IsInGuild = self.GuildModel:IsInGuild()
  self.CurrGuildInfo = self.GuildModel:GetCurrGuild()
  self.Anchor:ClearChildren()
  self.GuildJoin = nil
  self.GuildCreate = nil
  self.GuildInfoPage = nil
  self.GuildMember = nil
  local AllTabInfo = {}
  if self.IsInGuild then
    table.insert(AllTabInfo, {
      Text = GText("UI_GuildDetails"),
      TabId = 1,
      IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Guild_Info.T_Tab_Guild_Info'"
    })
    table.insert(AllTabInfo, {
      Text = GText("UI_GuildMembers"),
      TabId = 2,
      IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Guild_Member.T_Tab_Guild_Member'"
    })
  else
    table.insert(AllTabInfo, {
      Text = GText("UI_JoinGuild"),
      TabId = 1,
      IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Guild_Join.T_Tab_Guild_Join'"
    })
    table.insert(AllTabInfo, {
      Text = GText("UI_CreateGuild"),
      TabId = 2,
      IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Guild_Create.T_Tab_Guild_Create'"
    })
  end
  local GuildReportPopupParams
  if self.IsInGuild and self.CurrGuildInfo then
    GuildReportPopupParams = {
      IsGuildReport = true,
      GuildName = self.CurrGuildInfo.Name,
      GuildId = self.CurrGuildInfo.GuildId,
      bHideDialogItem = true,
      DialogItemIndex = 3,
      bShouldPlayAnim = false
    }
  end
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnPressESC,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.OnPressESC,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  self.DefaultBottomKeyInfo = BottomKeyInfo
  if self.IsInGuild then
  end
  local TabConfigData = {
    TitleName = GText("MAIN_UI_GUILD"),
    LeftKey = "Q",
    RightKey = "E",
    StyleName = "TextImage",
    Tabs = AllTabInfo,
    DynamicNode = {
      "Back",
      "Tip",
      "BottomKey",
      "Report"
    },
    PopupInfoId = self.IsInGuild and 100361 or nil,
    ReportPopupInfoId = GuildReportPopupParams and ChatCommon.AccuseDialog or nil,
    ReportPopupParams = GuildReportPopupParams,
    InfoCallback = "NotShow",
    BackCallback = self.Close,
    BottomKeyInfo = BottomKeyInfo,
    OwnerPanel = self
  }
  self.Tab:Init(TabConfigData)
  self.Tab:BindEventOnTabSelected(self, self.OnTabItemSelected)
  self:RefreshSpecialRightKeyEvents()
  if self.IsInGuild then
    ReddotManager.AddListenerEx("GuildTaskHub", self, self.RefreshGuildWeekActivityReddot)
    ReddotManager.AddListenerEx("GuildNewRequest", self, self.RefreshGuildNewRequestReddot)
  else
    ReddotManager.RemoveListener("GuildTaskHub", self)
    ReddotManager.RemoveListener("GuildNewRequest", self)
    self.Tab:ShowTabRedDot(1, false, false)
    self.Tab:ShowTabRedDot(2, false, false)
  end
end

function M:RefreshSpecialRightKeyEvents()
  if type(self.ClearAllKeyEvents) ~= "function" then
    return
  end
  self:ClearAllKeyEvents()
  if not self:IsSpecialRightDualPressEnabled() then
    return
  end
  self:AddKeyClickEvent(UIConst.GamePadKey.SpecialRight, self.OnSpecialRightShortPress)
  self:AddLongPressEvent(UIConst.GamePadKey.SpecialRight, self:GetSpecialRightLongPressDuration(), nil, self.OnSpecialRightLongPressCancel, self.OnSpecialRightLongPressEnd)
end

function M:IsSpecialRightDualPressEnabled()
  return self.IsInGuild and self.Tab ~= nil and type(self.Tab.IsReportGamePadTipAvailable) == "function" and self.Tab:IsReportGamePadTipAvailable()
end

function M:GetSpecialRightLongPressDuration()
  if self.Tab ~= nil and type(self.Tab.GetReportGamePadTipLongPressDuration) == "function" then
    return self.Tab:GetReportGamePadTipLongPressDuration()
  end
  return 1
end

function M:ResetSpecialRightInputState()
  local KeyName = UIConst.GamePadKey.SpecialRight
  if self.IsKeyDown then
    self.IsKeyDown[KeyName] = false
  end
  if self.IsLongPressing then
    self.IsLongPressing[KeyName] = false
  end
  if type(self.RemoveTimer) == "function" then
    self:RemoveTimer(KeyName .. "_LongPress")
    self:RemoveTimer(KeyName .. "_LongPressEnd")
  end
end

function M:OnSpecialRightShortPress()
  if self.Tab ~= nil and type(self.Tab.OnReportGamePadTipReleased) == "function" then
    self.Tab:OnReportGamePadTipReleased()
  end
  if self.Tab ~= nil and "function" == type(self.Tab.OnInfoClick) then
    self.Tab:OnInfoClick()
    return UIUtils.Handled, true
  end
end

function M:OnSpecialRightLongPressCancel()
  if self.Tab ~= nil and type(self.Tab.OnReportGamePadTipReleased) == "function" then
    self.Tab:OnReportGamePadTipReleased()
  end
end

function M:OnSpecialRightLongPressEnd()
  self:OnSpecialRightLongPressCancel()
  self:ResetSpecialRightInputState()
  if self.Tab ~= nil and type(self.Tab.OnReportClick) == "function" then
    self.Tab:OnReportClick()
  end
end

function M:OnGetGuildList()
  self.AllGuildList = GuildController:GetModel():GetGuildList() or {}
  self:ShowInfo()
end

function M:ShowInfo()
  self.Tab:SelectTab(1)
end

function M:OnTabItemSelected(TabWidget, Tab)
  if self.IsInGuild then
    self:OnTabItemSelected_InGuild(TabWidget, Tab)
  else
    self:OnTabItemSelected_NotInGuild(TabWidget, Tab)
  end
end

function M:OnTabItemSelected_InGuild(TabWidget, Tab)
  if 1 == Tab.TabId then
    if not self.GuildInfoPage then
      local GuildInfoPage = self:CreateWidgetNew("GuildInfoPage")
      local Slot = self.Anchor:AddChildToOverlay(GuildInfoPage)
      Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
      self.GuildInfoPage = GuildInfoPage
      self.GuildInfoPage.ParentWidget = self
      self.GuildInfoPage:InitView(self.CurrGuildInfo)
    else
      self.GuildInfoPage:SetVisibility(UIConst.VisibilityOp.Visible)
      self.GuildInfoPage:RefreshUIInfo()
    end
    self.GuildInfoPage:PlayInAnim()
    if self.GuildMember then
      self.GuildMember:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.WBox_Entrance:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if self.Tab.HB_RC then
      self.Tab.HB_RC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  else
    if not self.GuildMember then
      local GuildMember = self:CreateWidgetNew("GuildMember")
      local Slot = self.Anchor:AddChildToOverlay(GuildMember)
      Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
      self.GuildMember = GuildMember
      GuildMember.ParentWidget = self
      GuildMember:Init()
    else
      self.GuildMember:SetVisibility(UIConst.VisibilityOp.Visible)
      self.GuildMember:RefreshUIInfo()
    end
    self.GuildMember:PlayInAnim()
    if self.GuildInfoPage then
      self.GuildInfoPage:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.WBox_Entrance:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.Tab.HB_RC then
      self.Tab.HB_RC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  self:RefreshOpInfoByInputDevice()
end

function M:OnTabItemSelected_NotInGuild(TabWidget, Tab)
  self.AllGuildList = GuildController:GetModel():GetGuildList()
  if 1 == Tab.TabId then
    if not self.GuildJoin then
      local GuildJoin = self:CreateWidgetNew("GuildJoin")
      local Slot = self.Anchor:AddChildToOverlay(GuildJoin)
      Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
      GuildJoin.ParentWidget = self
      self.GuildJoin = GuildJoin
      self.GuildJoin:PlayAnimation(self.GuildJoin.In)
      AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "GuildJoinToEnd", nil)
    end
    self.GuildJoin:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.GuildJoin:SetData(self.AllGuildList)
    self.GuildJoin:SetListFocus()
    if self.GuildCreate then
      self.GuildCreate:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  else
    if not self.GuildCreate then
      local GuildCreate = self:CreateWidgetNew("GuildCreate")
      local Slot = self.Anchor:AddChildToOverlay(GuildCreate)
      Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
      GuildCreate.ParentWidget = self
      self.GuildCreate = GuildCreate
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/association_flag_in", nil, nil)
    self.GuildCreate:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.GuildCreate:SetData()
    self.GuildCreate:SetDefaultFocus()
    if self.GuildJoin then
      self.GuildJoin:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:HideNotInGuild()
  if self.GuildCreate then
    self.GuildCreate:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.GuildJoin then
    self.GuildJoin:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:HideInGuild()
  if self.GuildInfoPage then
    self.GuildInfoPage:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.GuildMember then
    self.GuildMember:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitEntrance()
  if self.IsInGuild then
    local Content_Shop = {
      Text = GText("UI_GuildShop"),
      OnBtnClick = function()
        AudioManager(self):PlayUISound(self, "event:/ui/activity/type_btn_click", nil, nil)
        local GuildShopId = DataMgr.GlobalConstant.GuildShopInterFaceJumpID and DataMgr.GlobalConstant.GuildShopInterFaceJumpID.ConstantValue or 102
        self:AddTimer(0.01, function()
          PageJumpUtils:JumpToTargetPageByJumpId(GuildShopId)
        end)
      end,
      Owner = self
    }
    self.Entrance_Shop:InitData(Content_Shop)
    local Content_Visit = {
      Text = GText("UI_VisitGuild"),
      OnBtnClick = function()
        AudioManager(self):PlayUISound(self, "event:/ui/activity/type_btn_click", nil, nil)
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildSystemNotAvailable"))
      end,
      Owner = self
    }
    self.Entrance_Visit:InitData(Content_Visit)
    self.Entrance_Visit:SetLocked(true)
    self.WBox_Entrance:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:Close()
  local OutCount = 0
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  
  local function CloseFunc()
    OutCount = OutCount - 1
    if 0 == OutCount then
      self:BlockAllUIInput(false)
      M.Super.Close(self)
    end
  end
  
  self:BindToAnimationFinished(self.Out, function()
    CloseFunc()
  end)
  OutCount = OutCount + 1
  self:PlayAnimation(self.Out)
  if self.GuildJoin and 1 == self.Tab.CurrentTab then
    OutCount = OutCount + 1
    self.GuildJoin:BindToAnimationFinished(self.GuildJoin.Out, function()
      CloseFunc()
      AudioManager(self):SetEventSoundParam(self, "GuildJoinToEnd", {ToEnd = 1})
      AudioManager(self):StopSound(self, "GuildJoinToEnd")
    end)
    self.GuildJoin:PlayAnimation(self.GuildJoin.Out)
  end
  if self.GuildCreate and 2 == self.Tab.CurrentTab then
    OutCount = OutCount + 1
    self.GuildCreate:BindToAnimationFinished(self.GuildCreate.Out, function()
      CloseFunc()
    end)
    self.GuildCreate:PlayAnimation(self.GuildCreate.Out)
  end
  if self.GuildInfoPage and 1 == self.Tab.CurrentTab then
    OutCount = OutCount + 1
    self.GuildInfoPage:BindToAnimationFinished(self.GuildInfoPage.Out, function()
      CloseFunc()
    end)
    self.GuildInfoPage:PlayAnimation(self.GuildInfoPage.Out)
  end
  if self.GuildMember and 2 == self.Tab.CurrentTab then
    OutCount = OutCount + 1
    self.GuildMember:BindToAnimationFinished(self.GuildMember.Out, function()
      CloseFunc()
    end)
    self.GuildMember:PlayAnimation(self.GuildMember.Out)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
  self:InitSubWidgetView(CurInputDevice, CurGamepadName)
end

function M:InitGamepadView()
  if 1 == self.Tab.CurrentTab and self.IsInGuild then
    if self.Key_Controller then
      self.Key_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  elseif self.Key_Controller then
    self.Key_Controller:SetVisibility(ESlateVisibility.Collapsed)
  end
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem then
    GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
end

function M:InitKeyboardView()
  if self.Key_Controller then
    self.Key_Controller:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:InitSubWidgetView(CurInputDevice, CurGamepadName)
  if self.IsInGuild then
    if 1 == self.Tab.CurrentTab then
      if self.GuildInfoPage then
        self.GuildInfoPage:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
      end
    elseif 2 == self.Tab.CurrentTab and self.GuildMember then
      local NeedFocus = self:HasFocusedDescendants() or self:HasAnyUserFocus()
      self.GuildMember:UpdateUIType(CurInputDevice, CurGamepadName, NeedFocus)
    end
  else
    self:UpdateComTab()
    if CurInputDevice == UE4.ECommonInputType.Gamepad then
      if self.GuildJoin and self.GuildJoin:GetVisibility() == UIConst.VisibilityOp.SelfHitTestInvisible then
        self.GuildJoin:SetListFocus()
        self.GuildJoin:UpdateGamePadIcon(CurInputDevice, CurGamepadName)
      else
        if self.GuildCreate and self.GuildCreate:GetVisibility() == UIConst.VisibilityOp.SelfHitTestInvisible then
          self.GuildCreate:SetDefaultFocus()
        else
        end
      end
    end
    if self.GuildJoin then
      self.GuildJoin.GuildInfo:RefreshDeviceUI()
      self.GuildJoin:UpdateGamePadIcon(CurInputDevice, CurGamepadName)
      self:SetGuildJoinGamePadIconVisible(true)
    end
  end
end

function M:UpdateComTab(BottomKeyInfo)
  if not UIUtils.IsMobileInput() then
    self.Tab:UpdateBottomKeyInfo(BottomKeyInfo or self.DefaultBottomKeyInfo)
  end
end

function M:SetGamepadIconVisibility(Visable)
  if Visable then
    self.Key_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Key_Controller:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:SwitchToInGuild(GuildId)
  self:HideNotInGuild()
  self.CurrGuildInfo = self.GuildModel:GetCurrGuild()
  self.IsInGuild = self.GuildModel:IsInGuild()
  self:InitTabInfo()
  self:InitEntrance()
  self:ShowInfo()
end

function M:SwitchToNotInGuild(GuildId)
  self:HideInGuild()
  self.CurrGuildInfo = nil
  self.IsInGuild = false
  self:InitTabInfo()
  self.WBox_Entrance:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:ShowInfo()
end

function M:BeKickedOut()
  self:HideInGuild()
  self.CurrGuildInfo = self.GuildModel:GetCurrGuild()
  self.IsInGuild = self.GuildModel:IsInGuild()
  self:InitTabInfo()
  self.WBox_Entrance:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:ShowInfo()
end

function M:OnPressESC()
  self:Close()
end

function M:RefreshGuildNewRequestReddot(Count)
  if Count > 0 then
    self.Tab:ShowTabRedDot(2, false, true)
  else
    self.Tab:ShowTabRedDot(2, false, false)
  end
end

function M:RefreshGuildWeekActivityReddot(Count)
  if Count > 0 then
    self.Tab:ShowTabRedDot(1, false, true)
  else
    self.Tab:ShowTabRedDot(1, false, false)
  end
end

function M:Destruct()
  GuildController:UnRegisterEvent(self)
  ReddotManager.RemoveListener("GuildTaskHub", self)
  ReddotManager.RemoveListener("GuildNewRequest", self)
  self.Super.Destruct(self)
end

function M:SetTopGamepadIconVisibility(bVisible)
  if not UIUtils.IsGamepadInput() then
    return
  end
  if bVisible then
    self.Tab.Left_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Tab.Right_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local ReportWidget = self.Tab.Pos_Report:GetChildAt(0)
    if ReportWidget then
      ReportWidget.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  else
    self.Tab.Left_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    self.Tab.Right_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    local ReportWidget = self.Tab.Pos_Report:GetChildAt(0)
    if ReportWidget then
      ReportWidget.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:SetBottomGamepadIconVisibility(bVisible)
  if not UIUtils.IsGamepadInput() then
    return
  end
  if bVisible then
    self.Tab.Com_KeyTips.Panel_Key:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Tab.Com_KeyTips.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:SetGuildJoinGamePadIconVisible(IsShow, Top, Bottom)
  if IsShow then
    self.GuildJoin.GuildList:ShowAllGamePadIcon()
    self.GuildJoin.GuildInfo:ShowAllGamePadIcon()
  else
    self.GuildJoin.GuildList:HideAllGamePadIcon()
    self.GuildJoin.GuildInfo:HideAllGamePadIcon()
  end
  if nil == Top then
    self:SetTopGamepadIconVisibility(IsShow)
  else
    self:SetBottomGamepadIconVisibility(Top)
  end
  if nil == Bottom then
    self:SetBottomGamepadIconVisibility(IsShow)
  else
    self:SetBottomGamepadIconVisibility(Bottom)
  end
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if self.GuildCreate and self.GuildCreate:GetVisibility() == UIConst.VisibilityOp.SelfHitTestInvisible then
    self.GuildCreate:UpdateBtnCreate()
    self.GuildCreate:RefreshGuildLogo()
  end
end

AssembleComponents(M)
return M
