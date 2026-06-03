require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")

function M:Construct()
  self.BGColorTable = {
    [1] = self.Color_BG_01,
    [2] = self.Color_BG_02,
    [3] = self.Color_BG_03,
    [4] = self.Color_BG_04,
    [5] = self.Color_BG_05
  }
  self.TextColorTable = {
    [1] = self.Color_Text_01,
    [2] = self.Color_Text_02,
    [3] = self.Color_Text_03,
    [4] = self.Color_Text_04,
    [5] = self.Color_Text_05
  }
  self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
  self.Btn_Dismiss.MenuAnchor.OnMenuOpenChanged:Add(self, self.OnDismissMenuOpenChanged)
  self.Button_Funtion:BindEventOnClicked(self, self.OnChatBtnClick)
  self.Button_Funtion:BindForbidStateExecuteEvent(self, self.OnChatBtnClick)
  self.Key_Function:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonBottom)
  self.Key_Function:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.HasPlayHover = false
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:RefreshOpInfoByInputDevice()
end

function M:Destruct()
  self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
  self.Btn_Dismiss.MenuAnchor.OnMenuOpenChanged:Remove(self, self.OnDismissMenuOpenChanged)
  self.Button_Funtion:UnBindEventOnClicked(self, self.OnClickBtnFucntion)
end

function M:OnClickBtnFucntion()
  local TargetUid = tonumber(self.Info.Uid)
  if not TargetUid then
    DebugPrint("GuildMemberItem OnClickBtnFucntion: 需要 Uid 参数")
    return
  end
  if self.ParentWidget then
    self.ParentWidget.ChatOpenFromMember = true
  end
  ChatController:OpenView(nil)
  ChatController:SelectGuildMemberToChat(TargetUid, self.Info)
end

function M:OnClickForbidBtnFucntion()
  if self.SelfChatOpen then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_PrivateChatNotEnabled"))
  else
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("GuildPrivateChatClose"))
  end
end

function M:OnChatBtnClick()
  self.NeedHandleChatBtnClick = true
  self:RefreshChatStatus()
end

function M:HandleChatBtnClick()
  if self.NeedHandleChatBtnClick then
    self.NeedHandleChatBtnClick = false
    if self.Button_Funtion:IsBtnForbidden() then
      self:OnClickForbidBtnFucntion()
    else
      self:OnClickBtnFucntion()
    end
  end
end

function M:OnListItemObjectSet(Content)
  self.Main:SetRenderOpacity(0)
  self.Content = Content
  Content.SelfWidget = self
  self.ParentWidget = Content.Parent
  local Info = Content.Info
  self.Info = Info
  self:PlayAnimation(self.In)
  if Content.IsEmpty then
    self.WS_Type:SetActiveWidgetIndex(1)
    return
  end
  self.WS_Type:SetActiveWidgetIndex(0)
  self.Text_Name:SetText(Info.Nickname)
  self.Text_Name_Myself:SetText(Info.Nickname)
  self.Head_Friend:SetHeadIconById(Info.HeadIconId)
  self.Head_Friend:SetHeadFrame(Info.HeadFrameId)
  self.Num_Level:SetText(tostring(Info.Level))
  if Info.Title == nil or 0 == Info.Title then
    Info.Title = 1
  end
  local GuildTitleData = DataMgr.GuildTitle[Info.Title]
  if GuildTitleData then
    local TitleName = GuildTitleData.TitleName or ""
    self.Text_Role:SetText(GText(TitleName))
    self.Text_Role:SetColorAndOpacity(self.TextColorTable[Info.Title])
    self.BG_Role:SetColorAndOpacity(self.BGColorTable[Info.Title])
  end
  self.Text_Activity:SetText(tostring(Info.GuildActivityLevel))
  self:SetJoinTime(Info.JoinTime)
  self:SetOnlineState(Info.IsOnline, Info.IsInDungeon, Info.LastLogoutTime)
  if Info.IsSelf then
    self.HB_Button:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Mask_Myself:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WS_Name:SetActiveWidgetIndex(1)
  else
    self.HB_Button:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Mask_Myself:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Name:SetActiveWidgetIndex(0)
  end
  self:RefreshChatStatus()
  self:SetDismissState(Info.Title, Info.LastLogin)
  self.Head_Friend:SetHoldUp(true)
  self.Head_Friend:SetupAnchor(self.Head_Anchor, self.Head_Friend, Info, true)
  self.Head_Friend:BindOnClickEvent(function()
    self:GetCardGuildInfo(Info.GuildId, Info.Uid)
  end)
  GuildController:UnRegisterEvent(self)
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if not self.Info then
      return
    end
    local Info = (...)
    if EventId == GuildCommon.EventID.OnGetGuildInfo and self.WaitGuildId == Info.GuildId then
      self.WaitGuildId = nil
      self:OnGetGuildFullInfo(Info)
    end
  end)
end

function M:SetOnlineState(IsOnline, IsInDungeon, LastLogoutTime)
  if not LastLogoutTime then
    return
  end
  if not IsOnline then
    local OfflineDayMax = DataMgr.GlobalConstant.FriendOfflineDayMax.ConstantValue
    local Day = math.floor((TimeUtils.NowTime() - LastLogoutTime) / CommonConst.SECOND_IN_DAY)
    if Day < 1 or 0 == LastLogoutTime then
      self.Text_Status:SetText(GText("UI_Friend_OffLineToday"))
    elseif OfflineDayMax >= Day then
      self.Text_Status:SetText(string.format(GText("UI_Friend_OfflineNDay"), Day))
    elseif OfflineDayMax < Day then
      self.Text_Status:SetText(GText("UI_Friend_OfflineOver30Day"))
    end
    self:PlayAnimation(self.OffLine)
  elseif not IsInDungeon then
    self.Text_Status:SetText(GText("UI_Friend_Online"))
    self:PlayAnimation(self.OnLine)
  else
    self.Text_Status:SetText(GText("UI_Chat_InDungeon"))
    self:PlayAnimation(self.OnMission)
  end
end

function M:SetJoinTime(JoinTime)
  if nil == JoinTime then
    self.Text_JoinTime:SetText("")
    return
  end
  local JoinDuration = TimeUtils.NowTime() - JoinTime
  local Day = math.floor(JoinDuration / CommonConst.SECOND_IN_DAY)
  if Day > 0 then
    self.Text_JoinTime:SetText(string.format(GText("UI_Days"), tostring(Day)))
  else
    local Hour = math.floor(JoinDuration / CommonConst.SECOND_IN_HOUR)
    if Hour > 0 then
      self.Text_JoinTime:SetText(string.format(GText("UI_Hours"), tostring(Hour)))
    else
      local Minute = math.floor(JoinDuration / CommonConst.SECOND_IN_MINUTE)
      Minute = math.max(Minute, 0)
      self.Text_JoinTime:SetText(string.format(GText("UI_Branch"), tostring(Minute)))
    end
  end
end

function M:SetDismissState(Title, LastLogin)
  if 5 ~= Title then
    self.Btn_Dismiss:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if not LastLogin then
    self.Btn_Dismiss:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local NeedDissMiss = false
  local Now = TimeUtils.NowTime()
  local DaysSinceLastLogin = math.floor((Now - LastLogin) / CommonConst.SECOND_IN_DAY)
  local WarningDay = DataMgr.GlobalConstant.GuildRecallTime.ConstantValue - DataMgr.GlobalConstant.GuildRecallWarningTime.ConstantValue
  if DaysSinceLastLogin >= WarningDay then
    NeedDissMiss = true
  end
  local CountDownDay = DataMgr.GlobalConstant.GuildRecallTime.ConstantValue - DaysSinceLastLogin
  CountDownDay = math.max(0, CountDownDay)
  if NeedDissMiss then
    self.Btn_Dismiss:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Dismiss:SetCounstDownDay(CountDownDay)
  else
    self.Btn_Dismiss:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshChatStatus()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    self.Button_Funtion:ForbidBtn(true)
    self:HandleChatBtnClick()
    return
  end
  if Avatar.GuildChatOpen then
    Avatar:QueryGuildChatOpen(function(Ret, IsOpen)
      if Ret ~= ErrorCode.RET_SUCCESS then
        self.Button_Funtion:ForbidBtn(true)
        self:HandleChatBtnClick()
        return
      end
      if not IsOpen then
        self.Button_Funtion:ForbidBtn(true)
      else
        self.Button_Funtion:ForbidBtn(false)
      end
      self:HandleChatBtnClick()
    end, self.Info.Uid)
    self.SelfChatOpen = true
  else
    self.Button_Funtion:ForbidBtn(true)
    self.SelfChatOpen = false
    self:HandleChatBtnClick()
  end
end

function M:OnDismissMenuOpenChanged(bOpen)
  self.DismissMenuOpen = bOpen
  if bOpen then
    if self.ParentWidget then
      self.ParentWidget:InitBackBottomKeyInfo()
    end
  else
    self:SetFocus()
    if self.ParentWidget then
      self.ParentWidget:InitBaseBottomKeyInfo()
    end
  end
end

function M:CloseDismissBubble()
  self.Btn_Dismiss:CloseBubble()
end

function M:HeadMenuOpenChanged(bOpen)
  self.bHeadMenuOpen = bOpen
  if bOpen then
    if self.ParentWidget then
      self.ParentWidget:InitEmptyBottomKeyInfo()
    end
  else
    self:SetFocus()
    if self.ParentWidget then
      self.ParentWidget:InitBaseBottomKeyInfo()
    end
  end
end

function M:OnAnchorGetUserMenuContent()
  local function Test(Content, AvatarInfo)
    Content.Text = "test"
    
    function Content.Callback()
      DebugPrint("GuildMemberItem OnAnchorGetUserMenuContent: TEST")
    end
  end
  
  local Switch = {Test}
  return ChatController:OpenPlayerBtnList(self, self.Info, Switch)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self.IsFocus = true
  if UIUtils.IsGamepadInput() then
    self:PlayHoverAnimation(true)
    if not self.Info or not self.Info.IsSelf then
      self.Function_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Btn_Dismiss:SetKeyControllerVisibility(true)
    if self.Content and self.Content.Parent then
      self.Content.Parent:SetCurrentFocusIndex(self.Content.Index)
    end
  end
  return UIUtils.Handled
end

function M:OnFocusLost(InFocusEvent)
  self.IsFocus = false
  self:PlayHoverAnimation(false)
  self.Function_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Dismiss:SetKeyControllerVisibility(false)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self:RefreshGamepadView()
  else
    self:RefreshKeyboardView()
  end
end

function M:RefreshGamepadView()
  if self.IsFocus then
    self:PlayHoverAnimation(true)
    self.Function_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:RefreshKeyboardView()
  self:PlayHoverAnimation(false)
  self.Function_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:PlayHoverAnimation(bHover)
  if bHover then
    if not self.HasPlayHover then
      self:PlayAnimation(self.Hover)
      self.HasPlayHover = true
    end
  elseif self.HasPlayHover then
    self:PlayAnimation(self.Unhover)
    self.HasPlayHover = false
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
  local IsHandled = false
  if self.DismissMenuOpen then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:CloseDismissBubble()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self.bHeadMenuOpen then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and (not self.Info or not self.Info.IsSelf) then
    self:OnChatBtnClick()
    IsHandled = true
  elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
    self:GetCardGuildInfo(self.Info.GuildId, self.Info.Uid)
    IsHandled = true
  elseif InKeyName == UIConst.GamePadKey.DPadRight and self.Btn_Dismiss:GetVisibility() ~= ESlateVisibility.Collapsed then
    self.Btn_Dismiss:OnBtnClick()
    IsHandled = true
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:WaitCardGuildInfoCallback()
  if not self.WaitCardGuildInfo then
    return
  end
  self.WaitCardGuildInfo = self.WaitCardGuildInfo - 1
  if 0 == self.WaitCardGuildInfo then
    if self.CardGuildFullInfo then
      self.CardGuildFullInfo.CardGuildChatOpen = self.CardGuildChatOpen
    end
    self.Head_Friend:SetGuildFullInfo(self.CardGuildFullInfo)
    self.Head_Anchor:Open(true)
    self.CardGuildFullInfo = nil
    self.CardGuildChatOpen = nil
    self.WaitCardGuildInfo = nil
  end
end

function M:GetCardGuildInfo(GuildId, Uid)
  self.WaitCardGuildInfo = 2
  self.CardGuildFullInfo = nil
  self.WaitGuildId = nil
  local Avatar = ChatController:GetAvatar()
  self.Content.Parent.IsOpeningHeadAnchor = true
  Avatar:QueryGuildMemberInfo(function(Ret, MemberInfos)
    if Ret ~= ErrorCode.RET_SUCCESS then
      return
    end
    if not IsValid(self) then
      return
    end
    local Info = MemberInfos[Uid]
    if Info.GuildId and 0 ~= Info.GuildId then
      self.WaitGuildId = Info.GuildId
      if Info.GuildId == GuildController:GetAvatar().GuildId then
        self:OnGetGuildFullInfo(GuildController:GetModel():GetCurrGuild())
      else
        GuildController:SendGetGuildInfo(Info.GuildId)
      end
      Avatar:QueryGuildChatOpen(function(Ret, IsOpen)
        if Ret ~= ErrorCode.RET_SUCCESS then
          return
        end
        self.CardGuildChatOpen = IsOpen
        self:WaitCardGuildInfoCallback()
      end, Info.Uid)
    else
      self:WaitCardGuildInfoCallback()
      self:WaitCardGuildInfoCallback()
    end
  end, {Uid})
end

function M:OnGetGuildFullInfo(Info)
  self.CardGuildFullInfo = Info
  self:WaitCardGuildInfoCallback()
end

return M
