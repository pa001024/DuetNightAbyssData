require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendCommon = require("BluePrints.UI.WBP.Friend.FriendCommon")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local ChatModel = ChatController:GetModel()
local FriendModel = FriendController:GetModel()
local OffSetOfScroll = 75
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
  M.Super.Construct(self)
  self.bBtnDragPressed = false
  self.bBtnTabPressed = false
  self.CurrSelectPlayer = nil
  self._SubTabVisualState = {}
  self.MinWidth = self.Group_Panel.MinDesiredWidth
  self.MinHeight = self.Group_Panel.MinDesiredHeight
  self.Text_NewMassageDesc:SetText(GText("UI_Chat_BackToBottom"))
  self.Btn_Empty.OnClicked:Add(self, self.BtnEmptyOnClicked)
  self.Btn_Face:BindEventOnPressed(self, self.BtnfaceOnPressed)
  self.Btn_Face:BindEventOnReleased(self, self.BtnFaceOnReleased)
  self.Btn_NewMessage.OnClicked:Add(self, self.BtnNewMsgOnClicked)
  self.Btn_QuickReply:BindEventOnPressed(self, self.BtnQuickReplyOnPressed)
  self.Btn_QuickReply:BindEventOnReleased(self, self.BtnQuickReplyOnReleased)
  self.Btn_Sent:SetText("")
  self.List_Dialog:DisableScroll(true)
  self.List_Dialog.BP_OnEntryGenerated:Add(self, function(self, Widget)
    if not self._DialogItemCounter then
      self._DialogItemCounter = 0
    end
    if not self._TotalHeight then
      self._TotalHeight = 0
    end
    Widget.Content.ScrollOffset = self._TotalHeight
    self._TotalHeight = self._TotalHeight + Widget:GetDesiredSize().Y
    self._DialogItemCounter = self._DialogItemCounter + 1
    if self._DialogItemCounter >= self.List_Dialog:GetListItems():Num() then
      if Widget.Content.Data.MsgType == ChatCommon.MsgType.Self or not self.bDialogListRefreshed then
        self.Group_NewMessage:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:_AutoScrollToEnd()
      end
      if Widget.Content.Data.MsgType ~= ChatCommon.MsgType.Self then
        self:_ReduceOverflowMessage()
      end
      self.MaxScrollOffset = self.SB_Dialog:GetScrollOffsetOfEnd()
      self.SB_Dialog:SetAlwaysShowScrollbar(self.CurInputDeviceType == ECommonInputType.Gamepad and self.MaxScrollOffset > 0)
      if self.bDialogListRefreshed then
        local NewMsgCount = ChatModel:GetChannelUnreadCount()
        local Visibility = NewMsgCount > 0 and "SelfHitTestInvisible" or "Collapsed"
        if self.SB_Dialog:GetScrollOffset() + OffSetOfScroll >= self.MaxScrollOffset then
          Visibility = "Collapsed"
          ChatController:SendChatNewMsgRead()
        end
        if Widget.Content.Data.MsgType == ChatCommon.MsgType.Self then
          Visibility = "Collapsed"
        end
        self.Group_NewMessage:SetVisibility(UIConst.VisibilityOp[Visibility])
      end
      self:UpdateUIStyleInPlatform()
      self.bDialogListRefreshed = true
    end
  end)
  self.SB_Dialog.OnUserScrolled:Add(self, function(self, CurrScrollOffset)
    if CurrScrollOffset >= self.SB_Dialog:GetScrollOffsetOfEnd() then
      self:BtnNewMsgOnClicked(true)
    elseif CurrScrollOffset + OffSetOfScroll < self.MaxScrollOffset then
      self.Group_NewMessage:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end)
  self.PanelAnchor.OnGetMenuContentEvent:Bind(self, self.OnCreatePanel)
  self.PanelAnchor.OnMenuOpenChanged:Add(self, self.OnMenuOpenChanged)
  self.PanelAnchor_Face.OnGetMenuContentEvent:Bind(self, self.OnCreatePanel)
  self.PanelAnchor_Face.OnMenuOpenChanged:Add(self, self.OnMenuOpenChanged)
  self.CurrExtraPanel = nil
  self.CurrExtraPanelName = ""
  self.MaxScrollOffset = 0
  self:InitChatChannelUI()
  self:_InitDMSubTab()
  self:_InitGuildPermissionSwitch()
end

function M:_InitDMSubTab()
  if self.SubTab_Friend and self.SubTab_Friend.Btn_Click then
    self.SubTab_Friend.Text_Channel:SetText(GText("ChatFriendTab_1"))
    self.SubTab_Friend.Btn_Click.OnHovered:Add(self, self.OnSubTabHovered_Friend)
    self.SubTab_Friend.Btn_Click.OnUnhovered:Add(self, self.OnSubTabUnhovered_Friend)
    self.SubTab_Friend.Btn_Click.OnPressed:Add(self, self.OnSubTabPressed_Friend)
    self.SubTab_Friend.Btn_Click.OnReleased:Add(self, self.OnSubTabReleased_Friend)
    self.SubTab_Friend.Btn_Click.OnClicked:Add(self, self.OnSubTabClicked_Friend)
  end
  if self.SubTab_Guild and self.SubTab_Guild.Btn_Click then
    self.SubTab_Guild.Text_Channel:SetText(GText("UI_DirectMessage"))
    self.SubTab_Guild.Btn_Click.OnHovered:Add(self, self.OnSubTabHovered_Guild)
    self.SubTab_Guild.Btn_Click.OnUnhovered:Add(self, self.OnSubTabUnhovered_Guild)
    self.SubTab_Guild.Btn_Click.OnPressed:Add(self, self.OnSubTabPressed_Guild)
    self.SubTab_Guild.Btn_Click.OnReleased:Add(self, self.OnSubTabReleased_Guild)
    self.SubTab_Guild.Btn_Click.OnClicked:Add(self, self.OnSubTabClicked_Guild)
  end
  if self.Btn_Empty_02 then
    self.Btn_Empty_02.OnClicked:Add(self, self._OnBtnEmpty02Clicked)
  end
  self:_BindSubTabReddot(self.SubTab_Friend, ChatModel:GetPrivateChatParentName(ChatCommon.SubTabType.Friend))
  self:_BindSubTabReddot(self.SubTab_Guild, ChatModel:GetPrivateChatParentName(ChatCommon.SubTabType.Guild))
end

function M:_SetSubTabReddotNum(SubTab, Count)
  if not SubTab then
    return
  end
  local ReddotWidget = SubTab.Reddot or SubTab.Reddot_Num
  if not ReddotWidget then
    return
  end
  local RedNum = tonumber(Count) or 0
  local Display = RedNum > 0 and (RedNum >= ChatCommon.ReddotMaxCount and ChatCommon.ReddotMaxCount .. "+" or RedNum) or 0
  if RedNum > 0 then
    ReddotWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if ReddotWidget.SetNum then
      ReddotWidget:SetNum(Display)
    end
  else
    ReddotWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:_OnBtnEmpty02Clicked()
  local SubTab = ChatModel:GetCurrentSubTab()
  if SubTab == ChatCommon.SubTabType.Guild then
    local View = GuildController:OpenGuildJoinView()
    if not View then
      ChatController:ShowToast(GText("UI_GuildSystemLocked"))
    end
  else
    local View = FriendController:OpenView(self, FriendCommon.FriendTabType.AddFriend)
    if not IsValid(View) then
      ChatController:ShowToast(GText("UI_Chat_CannotOpenFriend"))
    end
  end
  self:Close()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
end

function M:_BindSubTabReddot(SubTab, NodeName)
  if not SubTab then
    return
  end
  if not ReddotManager.GetTreeNode(NodeName) then
    return
  end
  ReddotManager.AddListener(NodeName, SubTab, function(Self, Count)
    self:_SetSubTabReddotNum(Self, Count)
  end)
  self:_SetSubTabReddotNum(SubTab, ReddotManager.GetTreeNode(NodeName):GetNodeCount())
end

function M:_UnbindSubTabReddot(SubTab, NodeName)
  if not SubTab then
    return
  end
  if not ReddotManager.GetTreeNode(NodeName) then
    return
  end
  ReddotManager.RemoveListener(NodeName, SubTab)
end

function M:UpdateText_ChatChannel()
  if ChatModel:IsInRegionOnlineChannelType() then
    self.Text_ChatChannel:SetText(string.format(GText(DataMgr.RegionOnline[ChatModel:GetRegionId()].RegionChannelName) .. "(%d)", ChatModel:GetChannelIndex(ChatModel:GetCurrentChannel())))
  else
    self.Text_ChatChannel:SetText(string.format(GText("WorldChannelWithParam"), ChatModel:GetChannelIndex(ChatModel:GetCurrentChannel())))
  end
end

function M:InitChatChannelUI()
  self:UpdateText_ChatChannel()
  self.Text_ChannelSign01:SetText(GText("Process"))
  self.Text_ChannelSign02:SetText(GText("Busy"))
  self.Text_ChannelSign03:SetText(GText("Full"))
  self.Btn_ChangeChannel:BindEventOnPressed(self, self.BtnChangeChannelOnPressed)
  self.Button_ChangeChannel.OnClicked:Clear()
  self.Button_ChangeChannel.OnClicked:Add(self, self.BtnChangeChannelOnPressed)
  ChatController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == ChatCommon.EventID.RecvChannelPlayerNum or EventId == ChatCommon.EventID.EnterChatChannel or EventId == ChatCommon.EventID.RecvAllChatChannel then
      self:HandleChannelPlayerNum()
    elseif EventId == ChatCommon.EventID.GuildChannelSnapshotRefreshed then
      local ChannelType = (...)
      if self.CurrChannel == (ChannelType or ChatCommon.ChannelDef.InGuild) then
        if self.CurrChannel == ChatCommon.ChannelDef.InGuild then
          self:OnTabSelected_InGuild()
        else
          self:_SetUpChatMsgList()
        end
      end
    end
  end)
  EventManager:AddEvent(EventID.OnSelectChannelSuccess, self, self.OnSelectChannelSuccess)
end

function M:OnSelectChannelSuccess(ChannelType, SelectIndex)
  if ChatModel:IsInRegionOnlineChannelType() then
    self.Text_ChatChannel:SetText(string.format(GText(DataMgr.RegionOnline[ChatModel:GetRegionId()].RegionChannelName) .. "(%d)", SelectIndex))
  else
    self.Text_ChatChannel:SetText(string.format(GText("WorldChannelWithParam"), SelectIndex))
  end
end

function M:HandleChannelPlayerNum(Channel_type, Channel_list)
  self.WS_ChannelSign:SetVisibility(UIConst.VisibilityOp.Visible)
  local Type = ChatModel:GetChannelState(ChatModel:GetChannelIndex(ChatModel:GetCurrentChannel()))
  if 1 == Type then
    self.WS_ChannelSign:SetActiveWidgetIndex(0)
  elseif 2 == Type then
    self.WS_ChannelSign:SetActiveWidgetIndex(1)
  else
    self.WS_ChannelSign:SetActiveWidgetIndex(2)
  end
  self:UpdateText_ChatChannel()
end

function M:BtnChangeChannelOnPressed()
  ChatController:OpenChatChannelUI(self, self.CurrChannel)
end

function M:_Stop_SetUpChatMsgListTimer()
  if self:IsExistTimer(self._SetUpChatMsgListTimer) then
    self:RemoveTimer(self._SetUpChatMsgListTimer)
    self.SB_Dialog:DisableDrag(false)
    self.SB_Dialog:SetRenderOpacity(1)
  end
end

function M:_CreateSetUpChatMsgListContext()
  return {
    Channel = self.CurrChannel,
    SubTab = ChatModel:GetCurrentSubTab(),
    FriendUid = ChatModel:GetCurrentFriendUid()
  }
end

function M:_IsSetUpChatMsgListContextCurrent(Context)
  if not Context then
    return true
  end
  return Context.Channel == self.CurrChannel and Context.SubTab == ChatModel:GetCurrentSubTab() and Context.FriendUid == ChatModel:GetCurrentFriendUid()
end

function M:_SetUpChatMsgList()
  self:_Stop_SetUpChatMsgListTimer()
  self.bDialogListRefreshed = false
  self._TotalHeight = 0
  self._DialogItemCounter = 0
  self.List_Dialog:ClearListItems()
  self.WS_Dialoglist:SetActiveWidgetIndex(0)
  local MsgList = ChatModel:GetCurrentMsgViewList()
  self._SetUpChatMsgListIndex = 0
  self.SB_Dialog:ScrollToStart()
  self.SB_Dialog:DisableDrag(true)
  self.SB_Dialog:SetRenderOpacity(0)
  local Context = self:_CreateSetUpChatMsgListContext()
  local _, TimerKey = self:AddTimer(0.01, self._SetUpChatMsgListTimerCallback, true, 0, nil, true, MsgList, Context)
  self._SetUpChatMsgListTimer = TimerKey
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    self._ChatItemList = {}
  end
end

function M:OpenDisturbWindows()
  local Parms = {
    RightCallbackFunction = function()
      EventManager:FireEvent(EventID.ComfirmDisturbClick)
    end,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = self.FreshTabDisturbIcon,
    RightGamepadImg = "X",
    AutoFocus = true
  }
  UIManager(self):ShowCommonPopupUI(100193, Parms, self)
end

function M:BtnEmptyOnClicked()
  if self.CurrChannel == ChatCommon.ChannelDef.InTeam then
    self:HandleGoToTeamType()
  elseif self.CurrChannel == ChatCommon.ChannelDef.Friend then
    local View = FriendController:OpenView(self, FriendCommon.FriendTabType.AddFriend)
    if not IsValid(View) then
      ChatController:ShowToast(GText("UI_Chat_CannotOpenFriend"))
    end
    self:Close()
  elseif self.CurrChannel == ChatCommon.ChannelDef.InGuild then
    GuildController:OpenView(self, "GuildMain")
    self:Close()
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
end

function M:BtnNewMsgOnClicked(bMuteSound)
  self:_AutoScrollToEnd()
  self.Group_NewMessage:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if not bMuteSound then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
  end
end

function M:BtnfaceOnPressed()
  local ChatEmoji = DataMgr.WidgetUI.ChatEmoji.UIName
  if self.CurrExtraPanelName ~= ChatEmoji then
    self.CurrExtraPanelName = ChatEmoji
  else
    self.CurrExtraPanelName = ""
  end
end

function M:BtnFaceOnReleased()
  local ChatEmoji = DataMgr.WidgetUI.ChatEmoji.UIName
  if self.CurrExtraPanelName == ChatEmoji then
    self.PanelAnchor_Face:Open(true)
  elseif self.IsOpenMenu then
    self.PanelAnchor_Face:Close()
  end
end

function M:BtnQuickReplyOnPressed()
  local ChatQuickMsg = DataMgr.WidgetUI.ChatQuickMsg.UIName
  if self.CurrExtraPanelName ~= ChatQuickMsg then
    self.CurrExtraPanelName = ChatQuickMsg
  else
    self.CurrExtraPanelName = ""
  end
end

function M:BtnQuickReplyOnReleased()
  local ChatQuickMsg = DataMgr.WidgetUI.ChatQuickMsg.UIName
  if self.CurrExtraPanelName == ChatQuickMsg then
    self.PanelAnchor:Open(true)
  elseif self.IsOpenMenu then
    self.PanelAnchor:Close()
  end
end

function M:BtnSendOnClicked(bSkipCheck)
  self.Com_Input:FocusInputField()
  if self.CurrChannel == ChatCommon.ChannelDef.Friend and not ChatModel:GetCurrentFriendUid() then
    ChatController:ShowToast(GText("UI_Chat_SelectAFriend"))
    return
  end
  if ChatModel:IsForbidChat() then
    ChatController:OpenForbidChatDialog()
    return
  end
  if ChatController:IsSendCDTimerExist(self.CurrChannel) then
    ChatController:ShowToast(GText("UI_Chat_SendTooFast"))
    return
  end
  if self.Com_Input:GetText() == "" then
    self.Com_Input:ShowTips(GText("UI_Chat_NotEmptyText"), 2)
    return
  end
  if not self.Btn_Sent:IsChatBtnForbidden() then
    AudioManager(self):PlayUISound(self, "event:/ui/common/team_click_send_msg", nil, nil)
    self.Btn_Sent:SetForbidden()
  else
    return
  end
  if bSkipCheck then
    self:_SendChatMsg(self.Com_Input:GetText())
    return
  end
  ChatController:CheckTextValid(self.Com_Input:GetText(), function(bValid, MsgText)
    if not bValid then
      self.Btn_Sent:SetNormal()
      return
    end
    self:_SendChatMsg(MsgText)
  end, function(bWarning, TipText)
    self.Com_Input:ShowTips(TipText, bWarning and 2 or 1, bWarning and 1.5 or 0)
  end)
  if self.PanelAnchor:IsOpen() then
    self.PanelAnchor:Close()
  end
  if self.PanelAnchor_Face:IsOpen() then
    self.PanelAnchor_Face:Close()
  end
end

function M:InitUIInfo(Name, bInUIMode, EventList, ...)
  M.Super.InitUIInfo(self, Name, bInUIMode, EventList, ...)
  local bBattle = (...)
  if type(bBattle) == "table" then
    self.bBattle = bBattle.bBattle
    self.bInDungeonSettlement = bBattle.bInDungeonSettlement
  else
    self.bBattle = bBattle
  end
  self.OriginBlurStrength = self.BackgroundBlur_50.BlurStrength
  local BlurStrength = self.bBattle and 0 or self.OriginBlurStrength
  self.BackgroundBlur_50:SetBlurStrength(BlurStrength)
  ChatController:OnMainOpen(self.bBattle)
  AudioManager(self):PauseObjectAllEvent(self, false)
  AudioManager(self):PlayUISound(self, "event:/ui/common/team_msg_panel_open", "ChatMainPC", nil)
  self:_SetUpBtnSentState()
end

function M:_SendChatMsg(MsgText)
  if self.CurrChannel == ChatCommon.ChannelDef.TeamUp then
    ChatController:SendChatToWorld(self.CurrChannel, MsgText)
  elseif self.CurrChannel == ChatCommon.ChannelDef.Public then
    ChatController:SendChatToWorld(self.CurrChannel, MsgText)
  elseif self.CurrChannel == ChatCommon.ChannelDef.Region then
    ChatController:SendChatToWorld(self.CurrChannel, MsgText)
  elseif self.CurrChannel == ChatCommon.ChannelDef.InGuild then
    ChatController:SendChatToGuild(MsgText)
  elseif self.CurrChannel == ChatCommon.ChannelDef.InTeam then
    ChatController:SendChatToTeam(MsgText)
  elseif self.CurrChannel == ChatCommon.ChannelDef.Friend then
    local ReceiverUid = ChatModel:GetCurrentFriendUid()
    if ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Guild then
      ChatController:SendChatToGuildMember(ReceiverUid, MsgText)
    else
      ChatController:SendChatToPlayer(ReceiverUid, MsgText)
    end
  elseif self.CurrChannel == ChatCommon.ChannelDef.SettlementOnline then
    ChatController:SendChatToSettlementOnline(MsgText)
  end
end

function M:OnCreatePanel()
  self.CurrExtraPanel = self:CreateWidgetNew(self.CurrExtraPanelName)
  return self.CurrExtraPanel
end

function M:OnMenuOpenChanged(bOpen)
  if self.RefreshUIWithMenuChanged then
    self:RefreshUIWithMenuChanged(bOpen)
  end
  if bOpen then
    self.CurrExtraPanel:Open(self, self.CurrExtraPanelName)
  else
    self.CurrExtraPanel:Close()
  end
end

function M:ApplyEmoji(EmojiData)
  local EmojiText = string.format("[%s|%s]", EmojiData.GroupId, EmojiData.Id)
  local EmojiTextShow = string.format("[%s]", EmojiData.Id)
  local Text = self.Com_Input:GetText()
  if EmojiData.GroupId == ChatCommon.EmojiGroupId then
    self.Com_Input:InsertText(EmojiTextShow)
  else
    self.Com_Input:SetText(EmojiText)
    self:BtnSendOnClicked(true)
    self.Com_Input:SetText(Text)
    self.PanelAnchor_Face:Close()
  end
end

function M:ApplyQuickMsg(QuickMsgText)
  local Text = self.Com_Input:GetText()
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    self.Com_Input:SetText(QuickMsgText)
    self:BtnSendOnClicked(true)
    self.Com_Input:SetText(Text)
    self.PanelAnchor:Close()
  else
    self.Com_Input:SetText(Text .. QuickMsgText)
    self.PanelAnchor:Close()
  end
end

function M:OnExtraPanelClose()
  self.Com_Input:FocusInputField()
  if self.CurrExtraPanelName == self.CurrExtraPanel.ViewName then
    self.CurrExtraPanelName = ""
  end
  self.CurrExtraPanel = nil
  self:TryToDefaultFocusWidget()
end

function M:OnTabSelected_TeamUp(TabWidget, TabItemInfo)
  self:_SetUpPublicChannelLayout()
  if self:HandleEnterChatChannel(ErrorCode.RET_SUCCESS, ChatCommon.ChannelDef.TeamUp) then
    self:_SetUpBtnSentState()
    self.Group_Channel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnTabSelected_Friend(TabWidget, TabItemInfo)
  self:_SetUpDMChannelLayout(ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Guild)
  FriendController:SendRequest(FriendCommon.EventId.RefreshFriend)
end

function M:_SetDMSubTabVisible(bVisible)
  local Visibility = bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if self.Group_TabChannel then
    self.Group_TabChannel:SetVisibility(Visibility)
  end
end

function M:_SetListTitleVisible(bVisible)
  if self.Group_ListTitle then
    local Visibility = bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
    self.Group_ListTitle:SetVisibility(Visibility)
  end
end

function M:_SetUpDMChannelLayout(bKeepBottomState)
  self:_SetDMSubTabVisible(true)
  self:_SetListTitleVisible(false)
  self.Group_ChatEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_ChatNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Group_PlayerList:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Text_DialogEmptyText:SetText(self:_GetCurrentDialogEmptyText())
  self.WS_Dialoglist:SetActiveWidgetIndex(1)
  self.Text_PlayerListTitle:SetText(GText("UI_Friend_MyFriend"))
  self.Text_Permission:SetText(GText("UI_AllowPrivateChat"))
  self.List_Player:ClearListItems()
  self.Btn_Sent:SetForbidden()
  if not bKeepBottomState then
    self._GuildPrivateInitSelectedUid = nil
    self.Group_BottomNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Group_BottomEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Group_Channel:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:_SetUpPublicChannelLayout()
  self:_SetDMSubTabVisible(false)
  self:_SetListTitleVisible(false)
  if self.WS_PlayerList then
    self.WS_PlayerList:SetActiveWidgetIndex(0)
  end
  if self.Group_PlayerList then
    self.Group_PlayerList:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.List_Player then
    self.List_Player:ClearListItems()
  end
  if self.Key_PlayerListTitle then
    self.Key_PlayerListTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.CurrSelectPlayer = nil
  self.SelectedPlayerIndex = nil
  if self.SetFocusStateType and self.FocusStateType == ChatCommon.ChatFocusType.PlayerList then
    self:SetFocusStateType(ChatCommon.ChatFocusType.Default)
  end
end

function M:_SetUpInTeamChannelLayout(bHasTeam)
  self:_SetDMSubTabVisible(false)
  self:_SetListTitleVisible(bHasTeam and self.RefreshTeamMemberListInPC ~= nil)
  if self.WS_PlayerList then
    self.WS_PlayerList:SetActiveWidgetIndex(0)
  end
  self.CurrSelectPlayer = nil
  self.SelectedPlayerIndex = nil
  if bHasTeam and self.RefreshTeamMemberListInPC then
    if self.Group_PlayerList then
      self.Group_PlayerList:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Text_PlayerListTitle then
      self.Text_PlayerListTitle:SetText(GText("UI_Chat_TeammateList"))
    end
    self:RefreshTeamMemberListInPC()
  else
    if self.Group_PlayerList then
      self.Group_PlayerList:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.List_Player then
      self.List_Player:ClearListItems()
    end
    if self.Key_PlayerListTitle then
      self.Key_PlayerListTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  if self.SetFocusStateType and self.FocusStateType == ChatCommon.ChatFocusType.PlayerList then
    self:SetFocusStateType(ChatCommon.ChatFocusType.Default)
  end
end

function M:OnTabSelected_Public(TabWidget, TabItemInfo)
  self:_SetUpPublicChannelLayout()
  if self:HandleEnterChatChannel(ErrorCode.RET_SUCCESS, ChatCommon.ChannelDef.Public) then
    self:_SetUpBtnSentState()
    self.Group_Channel:SetVisibility(UIConst.VisibilityOp.Visible)
    self:UpdateText_ChatChannel()
    self.WS_ChannelSign:SetVisibility(UIConst.VisibilityOp.Collapsed)
    ChatController:SendQueryChatChannelBusyInfo()
  end
end

function M:OnTabSelected_Region(TabWidget, TabItemInfo)
  self:_SetUpPublicChannelLayout()
  if self:HandleEnterChatChannel(ErrorCode.RET_SUCCESS, ChatCommon.ChannelDef.Region) then
    self:_SetUpBtnSentState()
    self:UpdateText_ChatChannel()
    if ChatModel:IsInRegionOnline() then
      self.Group_Channel:SetVisibility(UIConst.VisibilityOp.Visible)
      self.WS_ChannelSign:SetVisibility(UIConst.VisibilityOp.Collapsed)
      ChatController:SendQueryChatChannelBusyInfo()
    end
  end
end

function M:OnTabSelected_SettlementOnline(TabWidget, TabItemInfo)
  self:_SetUpPublicChannelLayout()
  if self:HandleEnterChatChannel(ErrorCode.RET_SUCCESS, ChatCommon.ChannelDef.SettlementOnline) then
    self:_SetUpBtnSentState()
    self:_SetUpChatMsgList()
    self.Group_Channel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

local TODO_GUILD_SKIP_INGUILD_CHECK = false

function M:OnTabSelected_InGuild(TabWidget, TabItemInfo)
  self:_SetUpPublicChannelLayout()
  local Avatar = GWorld:GetAvatar()
  local UIUnlockRuleId = DataMgr.UIUnlockRule.OpenGuild.UIUnlockRuleId
  local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
  local bInGuild = GuildModel:IsInGuild()
  if not TODO_GUILD_SKIP_INGUILD_CHECK and not bUnlocked then
    self:_SetUpFullEmpty(GText("UI_GuildSystemLocked"))
  elseif not TODO_GUILD_SKIP_INGUILD_CHECK and not bInGuild then
    self:_SetUpFullEmpty(GText("UI_NotInGuild"))
  else
    self.Group_BottomNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Group_BottomEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
    ChatController:SendRequestEnterChatChannel()
    self:_SetUpBtnSentState()
    self:_SetUpChatMsgList()
  end
  self.Group_Channel:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnTabSelected_InTeam(TabWidget, TabItemInfo)
  local TeamData = TeamController:GetModel():GetTeam()
  local TeamNumber = nil == TeamData and 0 or #TeamData.Members
  self:_SetUpInTeamChannelLayout(TeamNumber > 0)
  if 0 == TeamNumber then
    self:_SetUpFullEmpty(GText("UI_Chat_NoTeam"), GText("UI_Chat_GotoTeamUp"))
  else
    self.Group_BottomNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Group_BottomEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
    ChatController:SendRequestEnterChatChannel()
    self:_SetUpBtnSentState()
    self:_SetUpChatMsgList()
    self:_SetUpMsgCache()
  end
  self.Group_Channel:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:AddReddotListen()
  for ChannelName, ChannelType in pairs(ChatCommon.ChannelDef) do
    self:_AddReddotListenInner(ChannelName, ChannelType)
  end
  self._bAddedReddotListen = true
end

function M:_AddReddotListenInner(ChannelName, ChannelType)
end

function M:RemoveReddotListen()
  if not self._bAddedReddotListen then
    return
  end
  for ChannelName, ChannelType in pairs(ChatCommon.ChannelDef) do
    local NodeName = ChatCommon.ReddotNamePre .. ChannelName
    if not ReddotManager.GetTreeNode(NodeName) then
      return
    end
    ReddotManager.RemoveListener(NodeName, self)
  end
end

function M:SetUpNewTipIndex(NewTipIndex)
  self._NewTipIndex = NewTipIndex
end

function M:_SetUpBtnSentState()
  if ChatController:IsSendCDTimerExist(self.CurrChannel) then
    self.Btn_Sent:SetForbidden()
    self:HandleSendCDTimerUpdate(ChatModel:GetChannelCDReaminTime(self.CurrChannel))
  end
  if self.Com_Input:GetText() ~= "" then
    self.Btn_Sent:SetNormal()
  else
    self.Btn_Sent:SetForbidden()
  end
end

function M:_HandleChatSendFailed()
  self.Com_Input:SetText("")
  self:_SetUpBtnSentState()
end

function M:_RestoreDMInputArea()
  self.Group_BottomEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_BottomNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:_RestoreGuildPrivateInputArea()
  if self.CurrChannel ~= ChatCommon.ChannelDef.Friend then
    return
  end
  if ChatModel:GetCurrentSubTab() ~= ChatCommon.SubTabType.Guild then
    return
  end
  self:_RestoreDMInputArea()
  self:_SetUpBtnSentState()
end

function M:_GetGuildPrivateDisabledStateTipFlag(Uid)
  if self.CurrChannel ~= ChatCommon.ChannelDef.Friend then
    return nil
  end
  if ChatModel:GetCurrentSubTab() ~= ChatCommon.SubTabType.Guild then
    return nil
  end
  Uid = Uid or ChatModel:GetCurrentFriendUid()
  if not Uid then
    return nil
  end
  local OwnerUid = ChatController:GetAvatar() and ChatController:GetAvatar().Uid or 0
  if ChatModel:GetGuildPrivateLocalSystemTip(Uid, ChatCommon.GuildPrivateLeftGuildTipFlag, OwnerUid) then
    return ChatCommon.GuildPrivateLeftGuildTipFlag
  end
  if ChatModel:GetGuildPrivateLocalSystemTip(Uid, ChatCommon.GuildPrivateDisabledTipFlag, OwnerUid) then
    return ChatCommon.GuildPrivateDisabledTipFlag
  end
  return nil
end

function M:_IsGuildPrivateInputDisabled(Uid)
  return self:_GetGuildPrivateDisabledStateTipFlag(Uid) ~= nil
end

function M:_GetCurrentDialogEmptyText()
  return GText("UI_Chat_NoChatHistory")
end

function M:_SetGuildPrivateInputDisabledArea()
  self.Group_BottomNormal:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_BottomEmpty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Sent:SetForbidden()
end

function M:_ApplyGuildPrivateInputAreaState(Uid, bQueryRemote)
  if self.CurrChannel ~= ChatCommon.ChannelDef.Friend then
    return false
  end
  if ChatModel:GetCurrentSubTab() ~= ChatCommon.SubTabType.Guild then
    return false
  end
  if not Uid then
    return false
  end
  local bInGuild = GuildModel:IsInCurrGuild(Uid)
  local TipFlag = self:_GetGuildPrivateDisabledStateTipFlag(Uid)
  if not bInGuild then
    self:_SetGuildPrivateInputDisabledArea()
    ChatController:CheckGuildPrivateTargetState(Uid)
    return false
  end
  if TipFlag then
    self:_SetGuildPrivateInputDisabledArea()
    if bQueryRemote or TipFlag == ChatCommon.GuildPrivateLeftGuildTipFlag then
      ChatController:CheckGuildPrivateTargetState(Uid)
    end
    return false
  end
  self:_RestoreGuildPrivateInputArea()
  if bQueryRemote then
    ChatController:CheckGuildPrivateTargetState(Uid)
  end
  return true
end

function M:_HandleGuildPrivateTargetDisabled(Uid, TimeWrap, MsgWrap, bNeedRebuild)
  if self.CurrChannel ~= ChatCommon.ChannelDef.Friend then
    return
  end
  if ChatModel:GetCurrentSubTab() ~= ChatCommon.SubTabType.Guild then
    return
  end
  if ChatModel:GetCurrentFriendUid() ~= Uid then
    return
  end
  self:_SetGuildPrivateInputDisabledArea()
  if bNeedRebuild then
    self:_SetUpChatMsgList()
  else
    if TimeWrap then
      self:_AddNewMsgToListView(TimeWrap)
    end
    if MsgWrap then
      self:_AddNewMsgToListView(MsgWrap)
    end
  end
end

function M:_HandleGuildPrivateTargetLeftGuild(Uid, TimeWrap, MsgWrap, bNeedRebuild)
  self:_HandleGuildPrivateTargetDisabled(Uid, TimeWrap, MsgWrap, bNeedRebuild)
end

function M:_HandleGuildPrivateTargetEnabled(Uid)
  if self.CurrChannel ~= ChatCommon.ChannelDef.Friend then
    return
  end
  if ChatModel:GetCurrentSubTab() ~= ChatCommon.SubTabType.Guild then
    return
  end
  if ChatModel:GetCurrentFriendUid() ~= Uid then
    return
  end
  self:_RestoreGuildPrivateInputArea()
  self:_SetUpChatMsgList()
end

function M:_SetUpMsgCache()
  local MsgCache = ChatModel:GetChannelMsgCache()
  self.Com_Input:SetText(MsgCache)
end

function M:_SetUpChatEmpty(Text, BtnText)
  self.Group_BottomNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Group_BottomEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_PlayerList:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_ChatEmpty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Group_ChatNormal:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_ChatEmpry:SetText(Text)
  local Visibility = BtnText and "Visibility" or "Collapsed"
  self.Panel_Add:SetVisibility(UIConst.VisibilityOp[Visibility])
  if BtnText then
    self.Text_Recruit:SetText(BtnText)
  end
end

function M:_SetUpFullEmpty(Text, BtnText)
  self:_SetUpChatEmpty(Text, BtnText)
  self.Group_BottomNormal:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_BottomEmpty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:Close()
  if self.IsBeginToClose then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "ChatMainPC", {ToEnd = 1})
  if self:IsAnimationPlaying(self.Auto_In) then
    return
  end
  ChatModel:SetChannelMsgCache(self.Com_Input:GetText())
  ChatController:OnMainClose(self.bBattle)
  M.Super.Close(self)
end

function M:_AddNewMsgToListView(MsgWrap)
  if not MsgWrap then
    return
  end
  if 0 == self.List_Dialog:GetNumItems() then
    self.WS_Dialoglist:SetActiveWidgetIndex(0)
  end
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Owner = self
  Content.Data = MsgWrap
  self.List_Dialog:AddItem(Content)
end

function M:OnPlayerListUISelected(Content, bSkipInputAreaState)
  bSkipInputAreaState = bSkipInputAreaState or self._bGuildPrivateListRefreshing
  if self.CurrSelectPlayer and Content ~= self.CurrSelectPlayer then
    self.CurrSelectPlayer.bSelected = false
    if IsValid(self.CurrSelectPlayer.UI) then
      self.CurrSelectPlayer.UI:UnSelect()
    end
  end
  local OldSelectPlayer = self.CurrSelectPlayer
  self.CurrSelectPlayer = Content
  local LastFriendUid = ChatModel:GetCurrentFriendUid()
  local bGuildPrivateTargetDisabled = false
  if self.CurrChannel == ChatCommon.ChannelDef.Friend and ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Guild and Content.Data and Content.Data.Uid then
    local Uid = Content.Data.Uid
    if not GuildModel:IsInCurrGuild(Uid) then
      bGuildPrivateTargetDisabled = true
    else
      bGuildPrivateTargetDisabled = self:_GetGuildPrivateDisabledStateTipFlag(Uid) ~= nil
    end
  end
  if OldSelectPlayer ~= self.CurrSelectPlayer and self.CurrChannel ~= ChatCommon.ChannelDef.InTeam then
    if LastFriendUid then
      ChatModel:SetChannelMsgCache(self.Com_Input:GetText())
    end
    ChatModel:SetCurrentFriendUid(Content.Data.Uid)
    if not bSkipInputAreaState then
      if bGuildPrivateTargetDisabled then
        self:_SetGuildPrivateInputDisabledArea()
      else
        self.Group_BottomEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Group_BottomNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      end
    end
    self:_SetUpChatMsgList()
    self:_SetUpMsgCache()
    if not bSkipInputAreaState and self.CurInputDeviceType ~= ECommonInputType.Gamepad then
      self.Com_Input:FocusInputField()
    end
  end
  if self.CurrChannel == ChatCommon.ChannelDef.Friend and ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Guild and Content.Data and Content.Data.Uid then
    local bInputEnabled = self:_ApplyGuildPrivateInputAreaState(Content.Data.Uid, true)
    if not bInputEnabled and self.CurInputDeviceType ~= ECommonInputType.Gamepad then
      self.Com_Input.Text_Input:BP_SetClearKeyboardFocusOnCommit(false)
    elseif bSkipInputAreaState and self.CurInputDeviceType ~= ECommonInputType.Gamepad then
      self.Com_Input:FocusInputField()
    end
    if self._GuildPrivateInitSelectedUid == Content.Data.Uid then
      self._GuildPrivateInitSelectedUid = nil
    end
  end
  if self.IsOpenHead or self.CurrChannel == ChatCommon.ChannelDef.Friend then
    self:UpdateUIStyleInPlatform()
  end
end

function M:HandleChatMsgRecv(TimeWrap, MsgWrap)
  if self.CurrChannel == ChatCommon.ChannelDef.Friend and not ChatModel:GetCurrentFriendUid() then
    return
  end
  local NewBtnVisible = self.Group_NewMessage:IsVisible()
  AudioManager(self):PlayUISound(self, "event:/ui/common/team_msg_pop", nil, nil)
  self:_AddNewMsgToListView(TimeWrap)
  self:_AddNewMsgToListView(MsgWrap)
  if not NewBtnVisible then
    self:AddTimer(0.01, function()
      self:_AutoScrollToEnd()
    end)
  end
end

function M:HandleChatMsgSent(TimeWrap, MsgWrap)
  ChatController:SetUpSendCDTimer(MsgWrap.Message.ChannelType)
  if not MsgWrap:IsSticker() then
    self.Com_Input:SetText("")
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/team_msg_pop", nil, nil)
  self:_AddNewMsgToListView(TimeWrap)
  self:_AddNewMsgToListView(MsgWrap)
end

function M:_AutoScrollToEnd()
  self.SB_Dialog:EndInertialScrolling()
  self.SB_Dialog:ScrollToEnd()
  ChatController:SendChatNewMsgRead()
  self:_ReduceOverflowMessage()
end

function M:_ReduceOverflowMessage()
  local RemovedMsgs = ChatModel:GetChannelRemovedMsgs()
  for i, Msg in ipairs(RemovedMsgs) do
    local Item = self.List_Dialog:GetItemAt(0)
    if Item then
      self._DialogItemCounter = self._DialogItemCounter - 1
      self.List_Dialog:RemoveItem(Item)
    end
  end
end

function M:HandleEnterChatChannel(ErrCode, ChannelType)
  if not ChatModel.EnteredChannels[ChannelType] then
    ErrCode = ErrorCode.RET_CHAT_NOT_JOIN_CHANNEL
  end
  if ChannelType ~= self.CurrChannel then
    return
  end
  if ErrCode == ErrorCode.RET_SUCCESS then
    FriendController:SendRequest(FriendCommon.EventId.RefreshFriend)
    return true
  else
    if self.CurrChannel == ChatCommon.ChannelDef.TeamUp then
      self:_SetUpFullEmpty(GText("UI_Chat_InTeamEmpty"))
    elseif self.CurrChannel == ChatCommon.ChannelDef.Public and not UIManager(self):GetUIObj("CommonDialog") then
      self:_SetUpFullEmpty(GText("UI_Chat_PublicEmpty"))
    elseif self.CurrChannel == ChatCommon.ChannelDef.InTeam then
      self:_SetUpFullEmpty(GText("UI_Chat_InTeamEmpty"))
    elseif self.CurrChannel == ChatCommon.ChannelDef.Region and not UIManager(self):GetUIObj("CommonDialog") then
      self:_SetUpFullEmpty(GText("UI_Chat_NotInOnlineRegion"))
    elseif self.CurrChannel == ChatCommon.ChannelDef.SettlementOnline then
      self:_SetUpFullEmpty(GText("UI_Chat_SettlementOnlineEmpty"))
    elseif self.CurrChannel == ChatCommon.ChannelDef.InGuild then
      self:_SetUpFullEmpty(GText("UI_Chat_LeagueEmpty"), GText("UI_Chat_GotoLeague"))
    end
    return false
  end
end

function M:HandleSendCDTimerUpdate(RemainTime)
  if RemainTime <= 0 then
    self.Btn_Sent:SetText("")
    if 0 ~= self.Btn_Sent.WS:GetActiveWidgetIndex() then
      self.Btn_Sent.WS:SetActiveWidgetIndex(0)
      self.Btn_Sent:StopAllAnimations()
      self.Btn_Sent:PlayAnimation(self.Btn_Sent.Forbidden)
    end
    if "" ~= self.Com_Input:GetText() then
      self.Btn_Sent:SetNormal()
    end
  else
    if 1 ~= self.Btn_Sent.WS:GetActiveWidgetIndex() then
      self.Btn_Sent.WS:SetActiveWidgetIndex(1)
    end
    self.Btn_Sent:SetText(string.format(GText("UI_SHOP_REMAINTIME_SECOND"), RemainTime))
  end
end

function M:HandleRefreshFriend(ErrCode)
  if ErrCode ~= ErrorCode.RET_SUCCESS then
    return
  end
  local FriendChannel = ChatCommon.ChannelDef.Friend
  self:_AddReddotListenInner(ChatCommon.ChannelNames[FriendChannel], FriendChannel)
  if self.CurrChannel == ChatCommon.ChannelDef.Friend then
    self:_RefreshSubTab()
  elseif self.CurrChannel == ChatCommon.ChannelDef.TeamUp then
    self:_HandleRefreshFriendInOpenChannel()
  elseif self.CurrChannel == ChatCommon.ChannelDef.Public then
    self:_HandleRefreshFriendInOpenChannel()
  elseif self.CurrChannel == ChatCommon.ChannelDef.Region then
    self:_HandleRefreshFriendInRegionChannel()
  elseif self.CurrChannel == ChatCommon.ChannelDef.InTeam then
    self:_HandleRefreshTeamMateInTeamChannel()
  end
end

function M:_HandleRefreshFriendInRegionChannel()
  if ChatModel:IsInRegionOnline() then
    self:_HandleRefreshFriendInOpenChannel()
    self.Group_Channel:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self:_SetUpFullEmpty(GText("UI_Chat_NotInOnlineRegion"))
  end
end

function M:Destruct()
  ChatController:UnRegisterEvent(self)
  FriendController:UnRegisterEvent(self)
  TeamController:UnRegisterEvent(self)
  self:RemoveReddotListen()
  self:_UnbindSubTabReddot(self.SubTab_Friend, ChatModel:GetPrivateChatParentName(ChatCommon.SubTabType.Friend))
  self:_UnbindSubTabReddot(self.SubTab_Guild, ChatModel:GetPrivateChatParentName(ChatCommon.SubTabType.Guild))
  self:_UnInitDMSubTab()
  self.Btn_Empty.OnClicked:Remove(self, self.BtnEmptyOnClicked)
  self.Btn_NewMessage.OnClicked:Remove(self, self.BtnNewMsgOnClicked)
  self.Btn_Face:UnBindEventOnReleased(self, self.BtnFaceOnReleased)
  self.Btn_Face:UnBindEventOnPressed(self, self.BtnfaceOnPressed)
  self.List_Dialog.BP_OnEntryGenerated:Clear()
  self.PanelAnchor.OnGetMenuContentEvent:Unbind()
  self.PanelAnchor.OnMenuOpenChanged:Remove(self, self.OnMenuOpenChanged)
  self.PanelAnchor_Face.OnGetMenuContentEvent:Unbind()
  self.PanelAnchor_Face.OnMenuOpenChanged:Remove(self, self.OnMenuOpenChanged)
  self.Btn_QuickReply:UnBindEventOnReleased(self, self.BtnQuickReplyOnReleased)
  self.Btn_QuickReply:UnBindEventOnPressed(self, self.BtnQuickReplyOnPressed)
  self.BackgroundBlur_50:SetBlurStrength(self.OriginBlurStrength)
  M.Super.Destruct(self)
end

function M:_UnInitDMSubTab()
  if self.SubTab_Friend and self.SubTab_Friend.Btn_Click then
    self.SubTab_Friend.Btn_Click.OnHovered:Remove(self, self.OnSubTabHovered_Friend)
    self.SubTab_Friend.Btn_Click.OnUnhovered:Remove(self, self.OnSubTabUnhovered_Friend)
    self.SubTab_Friend.Btn_Click.OnPressed:Remove(self, self.OnSubTabPressed_Friend)
    self.SubTab_Friend.Btn_Click.OnReleased:Remove(self, self.OnSubTabReleased_Friend)
    self.SubTab_Friend.Btn_Click.OnClicked:Remove(self, self.OnSubTabClicked_Friend)
    if self.SubTab_Friend.UnHover then
      self.SubTab_Friend:UnbindAllFromAnimationFinished(self.SubTab_Friend.UnHover)
    end
  end
  if self.SubTab_Guild and self.SubTab_Guild.Btn_Click then
    self.SubTab_Guild.Btn_Click.OnHovered:Remove(self, self.OnSubTabHovered_Guild)
    self.SubTab_Guild.Btn_Click.OnUnhovered:Remove(self, self.OnSubTabUnhovered_Guild)
    self.SubTab_Guild.Btn_Click.OnPressed:Remove(self, self.OnSubTabPressed_Guild)
    self.SubTab_Guild.Btn_Click.OnReleased:Remove(self, self.OnSubTabReleased_Guild)
    self.SubTab_Guild.Btn_Click.OnClicked:Remove(self, self.OnSubTabClicked_Guild)
    if self.SubTab_Guild.UnHover then
      self.SubTab_Guild:UnbindAllFromAnimationFinished(self.SubTab_Guild.UnHover)
    end
  end
end

function M:_HandleRefreshFriendInPrivateChannel()
  local NowCount, TotalCount = 0, DataMgr.GlobalConstant.FriendHoldMax.ConstantValue
  FriendModel:SortFriends(3, CommonConst.DESC)
  local FriendList = FriendModel:GetFriendList()
  local SelectedPlayerIndex
  for i, Value in ipairs(FriendList) do
    local FriendData = FriendModel:GetFriendDict()[Value]
    SelectedPlayerIndex = SelectedPlayerIndex or i - 1
    NowCount = NowCount + 1
    if ChatModel:GetCurrentFriendUid() == FriendData.Uid then
      SelectedPlayerIndex = i - 1
    end
  end
  self.List_Player:ClearListItems()
  self.Text_PlayerNum:SetText(string.format("%d/%d", NowCount, TotalCount))
  if 0 == NowCount then
    local CurrentPlatform = CommonUtils.GetDeviceTypeByPlatformName(self)
    local ShowEmptyText = "PC" == CurrentPlatform and GText("UI_Friend_NoAnyFriend") or GText("UI_Friend_AddBeforeChat")
    self:_ShowDMPlayerListEmpty(ShowEmptyText, "Friend", self:_GetCurrentDialogEmptyText())
    self:_SetGuildPrivateInputDisabledArea()
    return
  end
  self:_ShowDMPlayerListNormal(self:_GetCurrentDialogEmptyText())
  for i, Value in ipairs(FriendList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Owner = self
    local FriendData = FriendModel:GetFriendDict()[Value]
    Content.Data = FriendData
    if SelectedPlayerIndex + 1 == i then
      Content.bSelected = true
    end
    self.List_Player:AddItem(Content)
  end
  self.SelectedPlayerIndex = SelectedPlayerIndex
  if SelectedPlayerIndex then
    self.List_Player:ScrollIndexIntoView(SelectedPlayerIndex + 1)
  end
  if self.OnDMPlayerListItemsReady then
    self:OnDMPlayerListItemsReady()
  end
  self.Com_Input:SetText("")
end

function M:_HandleRefreshFriendInOpenChannel()
  self:_SetUpPublicChannelLayout()
  self.Group_ChatEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_ChatNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:_SetUpChatMsgList()
  self:_SetUpMsgCache()
end

function M:_UpdateGuildPrivatePlayerItem(Uid)
  if not Uid or not self.List_Player then
    return
  end
  if self.CurrChannel ~= ChatCommon.ChannelDef.Friend then
    return
  end
  if ChatModel:GetCurrentSubTab() ~= ChatCommon.SubTabType.Guild then
    return
  end
  local GuildList = ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
  local RawInfo = GuildList and GuildList[Uid]
  local Info = self:_ResolveGuildPeerInfo(Uid, RawInfo)
  if not Info then
    self:_QueryGuildPeerInfo(Uid)
  end
  local ItemList = self.List_Player:GetListItems()
  local bShouldSelect = ChatModel:GetCurrentFriendUid() == Uid
  for i = 1, ItemList:Num() do
    local Item = ItemList:Get(i)
    if Item and Item.Data and Item.Data.Uid == Uid then
      Item.Data = Item.Data or {}
      Item.Data.Uid = Uid
      Item.Data.Info = Info or Item.Data.Info or {
        Uid = Uid,
        Nickname = tostring(Uid)
      }
      if bShouldSelect and not Item.bSelected then
        Item.bSelected = true
      end
      if IsValid(Item.UI) then
        Item.UI:OnListItemObjectSet(Item)
      end
      self.SelectedPlayerIndex = Item.bSelected and i - 1 or self.SelectedPlayerIndex
      if bShouldSelect then
        self:_ScrollGuildPrivatePlayerItem(i, Item)
        if not IsValid(Item.UI) then
          self._PendingGuildPrivateScrollUid = Uid
          self:_ScheduleGuildPrivatePlayerScrollRetry(Uid, 0)
        end
      end
      return
    end
  end
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Owner = self
  Content.Data = {
    Uid = Uid,
    Info = Info or {
      Uid = Uid,
      Nickname = tostring(Uid)
    }
  }
  Content.IsGuild = true
  local bHadItems = ItemList:Num() > 0
  if not bHadItems then
    ChatModel:SetCurrentFriendUid(Uid)
    bShouldSelect = true
  end
  if bShouldSelect then
    Content.bSelected = true
    self.SelectedPlayerIndex = ItemList:Num()
    self:_ShowDMPlayerListNormal(self:_GetCurrentDialogEmptyText())
  end
  self.List_Player:AddItem(Content)
  if Content.bSelected then
    self.CurrSelectPlayer = Content
    self:_ApplyGuildPrivateInputAreaState(Uid, false)
    self:_ScrollGuildPrivatePlayerItem(self.SelectedPlayerIndex + 1, Content)
    if not IsValid(Content.UI) then
      self._PendingGuildPrivateScrollUid = Uid
      self:_ScheduleGuildPrivatePlayerScrollRetry(Uid, 0)
    end
  end
  if self.OnDMPlayerListItemsReady then
    self:OnDMPlayerListItemsReady()
  end
end

function M:_ScrollGuildPrivatePlayerItem(Index, Item)
  if not (self.List_Player and Index) or not Item then
    return
  end
  if self.List_Player.BP_ScrollItemIntoView then
    self.List_Player:BP_ScrollItemIntoView(Item)
  else
    self.List_Player:ScrollIndexIntoView(Index - 1)
  end
end

function M:_ScheduleGuildPrivatePlayerScrollRetry(Uid, RetryCount)
  if not Uid then
    return
  end
  RetryCount = RetryCount or 0
  if RetryCount >= 3 then
    return
  end
  self:AddDelayFrameFunc(function()
    if not self or not self.List_Player then
      return
    end
    if self._PendingGuildPrivateScrollUid ~= Uid then
      return
    end
    self:_ScrollToGuildPrivatePlayerItem(Uid, false, RetryCount + 1)
  end, 1, "ScrollGuildPrivatePlayerItem")
end

function M:_ScrollToGuildPrivatePlayerItem(Uid, bAllowCreate, RetryCount)
  if not Uid then
    return false
  end
  if ChatModel:GetCurrentSubTab() ~= ChatCommon.SubTabType.Guild then
    return false
  end
  self._PendingGuildPrivateScrollUid = Uid
  ChatModel:SetCurrentFriendUid(Uid)
  if self.CurrChannel ~= ChatCommon.ChannelDef.Friend or not self.List_Player then
    return false
  end
  
  local function FindItem()
    local ItemList = self.List_Player:GetListItems()
    if not ItemList then
      return nil, nil
    end
    for i = 1, ItemList:Num() do
      local Item = ItemList:Get(i)
      if Item and Item.Data and Item.Data.Uid == Uid then
        return i, Item
      end
    end
    return nil, nil
  end
  
  local Index, Item = FindItem()
  if not Item and false ~= bAllowCreate then
    self:_UpdateGuildPrivatePlayerItem(Uid)
    Index, Item = FindItem()
  end
  if not Index or not Item then
    return false
  end
  self.SelectedPlayerIndex = Index - 1
  if not Item.bSelected then
    Item.bSelected = true
  end
  if IsValid(Item.UI) and Item.UI.Select then
    Item.UI:Select(true)
  else
    self:OnPlayerListUISelected(Item, true)
  end
  self:_ScrollGuildPrivatePlayerItem(Index, Item)
  if IsValid(Item.UI) or (RetryCount or 0) >= 3 then
    self._PendingGuildPrivateScrollUid = nil
  else
    self:_ScheduleGuildPrivatePlayerScrollRetry(Uid, RetryCount or 0)
  end
  return true
end

function M:_RefreshSubTab()
  if ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Guild then
    local PendingGuildPrivateScrollUid = self._PendingGuildPrivateScrollUid
    if PendingGuildPrivateScrollUid then
      ChatModel:SetCurrentFriendUid(PendingGuildPrivateScrollUid)
    end
    self:_HandleRefreshGuildInPrivateChannel()
    if PendingGuildPrivateScrollUid then
      self:_ScrollToGuildPrivatePlayerItem(PendingGuildPrivateScrollUid, false)
    end
  else
    self:_HandleRefreshFriendInPrivateChannel()
  end
  self:_RefreshGuildPermissionVisibility()
  if self.UpdateUIStyleInPlatform then
    self:UpdateUIStyleInPlatform()
  end
  self:AddDelayFrameFunc(function()
    self:_SyncSubTabSelectedState(ChatModel:GetCurrentSubTab())
  end, 1, "SyncChatSubTabSelectedState")
end

function M:_InitGuildPermissionSwitch()
  if not self.Group_Permission or not self.SwitchCheckBox_Permission then
    return
  end
  if self._GuildPermissionBound then
    return
  end
  self._GuildPermissionBound = true
  local Avatar = ChatController:GetAvatar()
  local bOpen = Avatar and Avatar.GuildChatOpen
  if nil == bOpen then
    bOpen = true
  end
  self.SwitchCheckBox_Permission:SetChecked(bOpen, false)
  self.SwitchCheckBox_Permission:AddEventOnCheckStateChanged(self, self._OnGuildPermissionToggle)
end

function M:_RefreshGuildPermissionVisibility()
  if not self.Group_Permission then
    return
  end
  local bFriendChannel = self.CurrChannel == ChatCommon.ChannelDef.Friend
  local bGuildSubTab = ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Guild
  local Avatar = ChatController:GetAvatar()
  local UIUnlockRuleId = DataMgr.UIUnlockRule.OpenGuild.UIUnlockRuleId
  local bUnlocked = Avatar and Avatar:CheckUIUnlocked(UIUnlockRuleId)
  local bInGuild = GuildModel:IsInGuild()
  local bShow = bFriendChannel and bGuildSubTab and bUnlocked and bInGuild
  self.Group_Permission:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if bShow and self.SwitchCheckBox_Permission then
    local bOpen = Avatar.GuildChatOpen
    if nil == bOpen then
      bOpen = true
    end
    self.SwitchCheckBox_Permission:SetChecked(bOpen, false)
  end
end

function M:_OnGuildPermissionToggle(bChecked)
  if bChecked then
    ChatController:SetGuildChatPermission(true)
    return
  end
  if ChatModel.SyncGuildUidListWithChatDatas then
    local KeepUid = ChatModel:GetCurrentFriendUid()
    local KeepInfo
    local OldGuildList = ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
    if KeepUid and OldGuildList then
      KeepInfo = OldGuildList[KeepUid]
    end
    ChatModel:SyncGuildUidListWithChatDatas(KeepUid, KeepInfo)
  end
  local GuildList = ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
  local bHasActiveChat = next(GuildList or {}) ~= nil
  if not bHasActiveChat then
    ChatController:SetGuildChatPermission(false)
    return
  end
  local Params = {
    RightCallbackFunction = function()
      ChatController:SetGuildChatPermission(false)
    end,
    LeftCallbackFunction = function()
      if self.SwitchCheckBox_Permission then
        self.SwitchCheckBox_Permission:SetChecked(true, false)
      end
    end
  }
  UIManager(self):ShowCommonPopupUI(ChatCommon.GuildPermissionCloseDialog, Params, self)
end

function M:_SetSubTabSelectedState(SubTabWidget, bSelected)
  if not SubTabWidget then
    return
  end
  local Anim = bSelected and SubTabWidget.Select or SubTabWidget.Normal
  if not Anim then
    return
  end
  local SubTabType = SubTabWidget == self.SubTab_Friend and ChatCommon.SubTabType.Friend or SubTabWidget == self.SubTab_Guild and ChatCommon.SubTabType.Guild
  if SubTabType then
    local State = self._SubTabVisualState[SubTabType]
    if State then
      State.Hovered = false
      State.Pressing = false
    end
  end
  if SubTabWidget.StopAllAnimations then
    SubTabWidget:StopAllAnimations()
  end
  SubTabWidget:PlayAnimation(Anim)
end

function M:_SyncSubTabSelectedState(SubTab)
  self:_SetSubTabSelectedState(self.SubTab_Friend, SubTab == ChatCommon.SubTabType.Friend)
  self:_SetSubTabSelectedState(self.SubTab_Guild, SubTab == ChatCommon.SubTabType.Guild)
end

function M:_GetSubTabWidgetByType(SubTabType)
  if SubTabType == ChatCommon.SubTabType.Friend then
    return self.SubTab_Friend
  elseif SubTabType == ChatCommon.SubTabType.Guild then
    return self.SubTab_Guild
  end
end

function M:_GetSubTabVisualState(SubTabType)
  self._SubTabVisualState = self._SubTabVisualState or {}
  local State = self._SubTabVisualState[SubTabType]
  if not State then
    State = {Hovered = false, Pressing = false}
    self._SubTabVisualState[SubTabType] = State
  end
  return State
end

function M:_IsSubTabSelected(SubTabType)
  return ChatModel:GetCurrentSubTab() == SubTabType
end

function M:_PlaySubTabAnimation(SubTabWidget, Anim)
  if not SubTabWidget or not Anim then
    return
  end
  if SubTabWidget.StopAllAnimations then
    SubTabWidget:StopAllAnimations()
  end
  SubTabWidget:PlayAnimation(Anim)
end

function M:_PlaySubTabUnHover(SubTabType)
  local SubTabWidget = self:_GetSubTabWidgetByType(SubTabType)
  if not SubTabWidget then
    return
  end
  if not SubTabWidget.UnHover then
    self:_PlaySubTabAnimation(SubTabWidget, SubTabWidget.Normal)
    return
  end
  if SubTabWidget.UnHover then
    SubTabWidget:UnbindAllFromAnimationFinished(SubTabWidget.UnHover)
    SubTabWidget:BindToAnimationFinished(SubTabWidget.UnHover, {
      self,
      function()
        local State = self:_GetSubTabVisualState(SubTabType)
        if self:_IsSubTabSelected(SubTabType) or State.Hovered or State.Pressing then
          return
        end
        local CurrentWidget = self:_GetSubTabWidgetByType(SubTabType)
        if CurrentWidget and CurrentWidget.Normal then
          self:_PlaySubTabAnimation(CurrentWidget, CurrentWidget.Normal)
        end
      end
    })
  end
  self:_PlaySubTabAnimation(SubTabWidget, SubTabWidget.UnHover)
end

function M:_OnSubTabHovered(SubTabType)
  if self:_IsSubTabSelected(SubTabType) then
    return
  end
  local State = self:_GetSubTabVisualState(SubTabType)
  State.Hovered = true
  local SubTabWidget = self:_GetSubTabWidgetByType(SubTabType)
  if not SubTabWidget then
    return
  end
  if SubTabWidget.UnHover then
    SubTabWidget:UnbindAllFromAnimationFinished(SubTabWidget.UnHover)
  end
  self:_PlaySubTabAnimation(SubTabWidget, SubTabWidget.Hover)
end

function M:_OnSubTabUnhovered(SubTabType)
  if self:_IsSubTabSelected(SubTabType) then
    return
  end
  local State = self:_GetSubTabVisualState(SubTabType)
  State.Hovered = false
  local SubTabWidget = self:_GetSubTabWidgetByType(SubTabType)
  if not SubTabWidget or State.Pressing then
    return
  end
  self:_PlaySubTabUnHover(SubTabType)
end

function M:_OnSubTabPressed(SubTabType)
  if self:_IsSubTabSelected(SubTabType) then
    return
  end
  local State = self:_GetSubTabVisualState(SubTabType)
  State.Pressing = true
  local SubTabWidget = self:_GetSubTabWidgetByType(SubTabType)
  if not SubTabWidget then
    return
  end
  if SubTabWidget.UnHover then
    SubTabWidget:UnbindAllFromAnimationFinished(SubTabWidget.UnHover)
  end
  self:_PlaySubTabAnimation(SubTabWidget, SubTabWidget.Press)
end

function M:_OnSubTabReleased(SubTabType)
  if self:_IsSubTabSelected(SubTabType) then
    return
  end
  local State = self:_GetSubTabVisualState(SubTabType)
  State.Pressing = false
  local SubTabWidget = self:_GetSubTabWidgetByType(SubTabType)
  if not SubTabWidget then
    return
  end
  if SubTabWidget.UnHover then
    SubTabWidget:UnbindAllFromAnimationFinished(SubTabWidget.UnHover)
  end
  if State.Hovered then
    self:_PlaySubTabAnimation(SubTabWidget, SubTabWidget.Hover)
  else
    self:_PlaySubTabUnHover(SubTabType)
  end
end

function M:_PlaySubTabClick(SubTabType)
  if self:_IsSubTabSelected(SubTabType) then
    return
  end
  local State = self:_GetSubTabVisualState(SubTabType)
  State.Hovered = false
  State.Pressing = false
  local SubTabWidget = self:_GetSubTabWidgetByType(SubTabType)
  if not SubTabWidget or not SubTabWidget.Click then
    return
  end
  if SubTabWidget.UnHover then
    SubTabWidget:UnbindAllFromAnimationFinished(SubTabWidget.UnHover)
  end
  self:_PlaySubTabAnimation(SubTabWidget, SubTabWidget.Click)
end

function M:OnSubTabHovered_Friend()
  self:_OnSubTabHovered(ChatCommon.SubTabType.Friend)
end

function M:OnSubTabUnhovered_Friend()
  self:_OnSubTabUnhovered(ChatCommon.SubTabType.Friend)
end

function M:OnSubTabPressed_Friend()
  self:_OnSubTabPressed(ChatCommon.SubTabType.Friend)
end

function M:OnSubTabReleased_Friend()
  self:_OnSubTabReleased(ChatCommon.SubTabType.Friend)
end

function M:OnSubTabHovered_Guild()
  self:_OnSubTabHovered(ChatCommon.SubTabType.Guild)
end

function M:OnSubTabUnhovered_Guild()
  self:_OnSubTabUnhovered(ChatCommon.SubTabType.Guild)
end

function M:OnSubTabPressed_Guild()
  self:_OnSubTabPressed(ChatCommon.SubTabType.Guild)
end

function M:OnSubTabReleased_Guild()
  self:_OnSubTabReleased(ChatCommon.SubTabType.Guild)
end

function M:OnSubTabClicked_Friend()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "", nil)
  if ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Friend then
    return
  end
  self:_PlaySubTabClick(ChatCommon.SubTabType.Friend)
  ChatModel:SetCurrentSubTab(ChatCommon.SubTabType.Friend)
  ChatModel:SetCurrentFriendUid(nil)
  self.CurrSelectPlayer = nil
  self:_SetUpDMChannelLayout()
  self:_RefreshSubTab()
end

function M:OnSubTabClicked_Guild()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "", nil)
  if ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Guild then
    return
  end
  self:_PlaySubTabClick(ChatCommon.SubTabType.Guild)
  ChatModel:SetCurrentSubTab(ChatCommon.SubTabType.Guild)
  ChatModel:SetCurrentFriendUid(nil)
  self.CurrSelectPlayer = nil
  self:_SetUpDMChannelLayout(true)
  self:_RefreshSubTab()
end

function M:_HandleRefreshGuildInPrivateChannel(Uid, bSkipPeerInfoRefresh)
  if Uid then
    self:_UpdateGuildPrivatePlayerItem(Uid)
    return
  end
  self.List_Player:ClearListItems()
  self.Btn_Sent:SetForbidden()
  local Avatar = GWorld:GetAvatar()
  local UIUnlockRule = DataMgr.UIUnlockRule
  local UIUnlockRuleId = UIUnlockRule.OpenGuild.UIUnlockRuleId
  local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
  if not bUnlocked then
    self:_SetGuildPrivateInputDisabledArea()
    self:_ShowDMPlayerListEmpty(GText("UI_GuildSystemLocked"), nil, GText("UI_GuildSystemLocked"))
    return
  end
  if not GuildModel:IsInGuild() then
    self:_SetGuildPrivateInputDisabledArea()
    self:_ShowDMPlayerListEmpty(GText("UI_NoPrivateChats"), nil, GText("UI_JoinGuildToChat"))
    return
  end
  if ChatModel.SyncGuildUidListWithChatDatas then
    local KeepUid = ChatModel:GetCurrentFriendUid()
    local KeepInfo
    local OldGuildList = ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
    if KeepUid and OldGuildList then
      KeepInfo = OldGuildList[KeepUid]
    end
    ChatModel:SyncGuildUidListWithChatDatas(KeepUid, KeepInfo)
  end
  local GuildList = ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
  local Uids = self:_GetSortedGuildPrivateUids(GuildList)
  if 0 == #Uids then
    local bGuildChatOpen = Avatar.GuildChatOpen ~= false
    local DialogEmptyText = not bGuildChatOpen and GText("UI_PrivateChatNotAllowed") or GText("UI_CanChatWithGuildMembers")
    self:_SetGuildPrivateInputDisabledArea()
    self:_ShowDMPlayerListEmpty(GText("UI_NoPrivateChats"), nil, DialogEmptyText)
    return
  end
  self:_ShowDMPlayerListNormal(self:_GetCurrentDialogEmptyText())
  local PreselectUid = ChatModel:GetCurrentFriendUid()
  if not PreselectUid or not GuildList[PreselectUid] then
    PreselectUid = Uids[1]
  end
  if PreselectUid then
    self:_ApplyGuildPrivateInputAreaState(PreselectUid, false)
  end
  self._GuildPrivateInitSelectedUid = PreselectUid
  local bOldGuildPrivateListRefreshing = self._bGuildPrivateListRefreshing
  self._bGuildPrivateListRefreshing = true
  local SelectedIdx, SelectedUid
  for i, Uid in ipairs(Uids) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Owner = self
    local Info = self:_ResolveGuildPeerInfo(Uid, GuildList[Uid])
    Content.Data = {
      Uid = Uid,
      Info = Info or {
        Uid = Uid,
        Nickname = tostring(Uid)
      }
    }
    Content.IsGuild = true
    if ChatModel:GetCurrentFriendUid() == Uid then
      SelectedIdx = i
      SelectedUid = Uid
      Content.bSelected = true
    end
    self.List_Player:AddItem(Content)
  end
  if not SelectedIdx then
    SelectedIdx = 1
    SelectedUid = Uids[SelectedIdx]
    local FirstItem = self.List_Player:GetListItems():Get(1)
    if FirstItem and IsValid(FirstItem.UI) and FirstItem.UI.Select then
      FirstItem.UI:Select()
    elseif FirstItem then
      FirstItem.bSelected = true
    end
  end
  self._bGuildPrivateListRefreshing = bOldGuildPrivateListRefreshing
  self.SelectedPlayerIndex = SelectedIdx - 1
  self.Com_Input:SetText("")
  if SelectedUid then
    self:_ApplyGuildPrivateInputAreaState(SelectedUid, false)
  end
  self:_ScrollGuildPrivatePlayerItem(SelectedIdx, self.List_Player:GetListItems():Get(SelectedIdx))
  if self.OnDMPlayerListItemsReady then
    self:OnDMPlayerListItemsReady()
  end
  if not bSkipPeerInfoRefresh then
    self:_RefreshGuildPrivatePeerInfos(Uids)
  end
end

function M:_GetSortedGuildPrivateUids(GuildList)
  local OnlineUids = {}
  local OfflineUids = {}
  local AddedUids = {}
  
  local function AddUid(Uid)
    if not (Uid and not AddedUids[Uid] and GuildList) or nil == GuildList[Uid] then
      return
    end
    AddedUids[Uid] = true
    local Info = self:_ResolveGuildPeerInfo(Uid, GuildList[Uid])
    if Info and true == Info.IsOnline then
      OnlineUids[#OnlineUids + 1] = Uid
    else
      OfflineUids[#OfflineUids + 1] = Uid
    end
  end
  
  local GuildUidOrder = ChatModel.GetGuildUidOrder and ChatModel:GetGuildUidOrder() or {}
  for _, Uid in ipairs(GuildUidOrder) do
    AddUid(Uid)
  end
  for Uid, _ in pairs(GuildList or {}) do
    AddUid(Uid)
  end
  for _, Uid in ipairs(OfflineUids) do
    OnlineUids[#OnlineUids + 1] = Uid
  end
  return OnlineUids
end

function M:_HandleGuildPrivateInfoChanged(Uid, bWasOnline, bIsOnline)
  if self.CurrChannel ~= ChatCommon.ChannelDef.Friend then
    return
  end
  if ChatModel:GetCurrentSubTab() ~= ChatCommon.SubTabType.Guild then
    return
  end
  if true == bWasOnline ~= (true == bIsOnline) then
    self:_HandleRefreshGuildInPrivateChannel(nil, true)
  else
    self:_UpdateGuildPrivatePlayerItem(Uid)
  end
end

function M:_ResolveGuildPeerInfo(Uid, Raw)
  if type(Raw) == "table" then
    return Raw
  end
  return nil
end

function M:_IsValidGuildMemberQueryInfo(Info)
  if type(Info) ~= "table" then
    return false
  end
  local Nickname = Info.Nickname or Info.Name
  if Nickname and "" ~= Nickname then
    return true
  end
  if Info.Level and Info.Level > 0 then
    return true
  end
  if Info.GuildId and Info.GuildId > 0 then
    return true
  end
  return false
end

function M:_RefreshGuildPrivatePeerInfos(Uids)
  if not Uids or 0 == #Uids then
    return
  end
  local Avatar = ChatController:GetAvatar()
  if not Avatar or not Avatar.QueryGuildMemberInfo then
    for _, Uid in ipairs(Uids) do
      self:_QueryGuildPeerInfo(Uid)
    end
    return
  end
  self._GuildPeerInfoBatchSerial = (self._GuildPeerInfoBatchSerial or 0) + 1
  local BatchSerial = self._GuildPeerInfoBatchSerial
  Avatar:QueryGuildMemberInfo(function(Ret, MemberInfos)
    if not IsValid(self) or BatchSerial ~= self._GuildPeerInfoBatchSerial then
      return
    end
    local FallbackUids = {}
    local ChangedUids = {}
    local bNeedRebuildList = false
    if Ret == ErrorCode.RET_SUCCESS and type(MemberInfos) == "table" then
      for _, Uid in ipairs(Uids) do
        local Info = MemberInfos[Uid] or MemberInfos[tostring(Uid)]
        if self:_IsValidGuildMemberQueryInfo(Info) then
          local GuildList = ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
          local OldInfo = self:_ResolveGuildPeerInfo(Uid, GuildList and GuildList[Uid])
          local bWasOnline = OldInfo and OldInfo.IsOnline == true or false
          if ChatModel:RegisterGuildUid(Uid, Info) then
            local NewGuildList = ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
            local NewInfo = self:_ResolveGuildPeerInfo(Uid, NewGuildList and NewGuildList[Uid])
            local bIsOnline = NewInfo and NewInfo.IsOnline == true or false
            if bWasOnline ~= bIsOnline then
              bNeedRebuildList = true
            else
              ChangedUids[#ChangedUids + 1] = Uid
            end
          end
        else
          FallbackUids[#FallbackUids + 1] = Uid
        end
      end
    else
      FallbackUids = Uids
    end
    if self.CurrChannel == ChatCommon.ChannelDef.Friend and ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Guild then
      if bNeedRebuildList then
        self:_HandleRefreshGuildInPrivateChannel(nil, true)
      else
        for _, Uid in ipairs(ChangedUids) do
          self:_UpdateGuildPrivatePlayerItem(Uid)
        end
      end
    end
    for _, Uid in ipairs(FallbackUids) do
      self:_QueryGuildPeerInfo(Uid)
    end
  end, Uids, true)
end

function M:_QueryGuildPeerInfo(Uid)
  if not Uid then
    return
  end
  self._GuildPeerInfoQuerying = self._GuildPeerInfoQuerying or {}
  if self._GuildPeerInfoQuerying[Uid] then
    return
  end
  local Avatar = ChatController:GetAvatar()
  if not Avatar or not Avatar.GetOtherPlayerPersonallInfo then
    return
  end
  self._GuildPeerInfoQuerying[Uid] = true
  Avatar:GetOtherPlayerPersonallInfo(Uid, {
    Func = function(PlayerInfo)
      if self._GuildPeerInfoQuerying then
        self._GuildPeerInfoQuerying[Uid] = nil
      end
      if not IsValid(self) or type(PlayerInfo) ~= "table" then
        return
      end
      local GuildList = ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
      local OldInfo = self:_ResolveGuildPeerInfo(Uid, GuildList and GuildList[Uid])
      local bWasOnline = OldInfo and OldInfo.IsOnline == true or false
      local bChanged = ChatModel:RegisterGuildUid(Uid, PlayerInfo)
      if self.CurrChannel == ChatCommon.ChannelDef.Friend and ChatModel:GetCurrentSubTab() == ChatCommon.SubTabType.Guild then
        if bChanged then
          local NewGuildList = ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
          local NewInfo = self:_ResolveGuildPeerInfo(Uid, NewGuildList and NewGuildList[Uid])
          local bIsOnline = NewInfo and NewInfo.IsOnline == true or false
          self:_HandleGuildPrivateInfoChanged(Uid, bWasOnline, bIsOnline)
        else
          self:_UpdateGuildPrivatePlayerItem(Uid)
        end
      end
    end
  })
end

function M:_ShowDMPlayerListEmpty(EmptyText, CTAType, DialogEmptyText)
  if self.CurrSelectPlayer and IsValid(self.CurrSelectPlayer.UI) then
    self.CurrSelectPlayer.UI:UnSelect()
  end
  self.CurrSelectPlayer = nil
  self.SelectedPlayerIndex = nil
  if self.WS_PlayerList then
    self.WS_PlayerList:SetActiveWidgetIndex(1)
    if self.Text_ChatTabListEmpty then
      self.Text_ChatTabListEmpty:SetText(EmptyText)
    end
    local Op = ("Guild" == CTAType or "Friend" == CTAType) and "SelfHitTestInvisible" or "Collapsed"
    if self.Panel_Add_02 then
      self.Panel_Add_02:SetVisibility(UIConst.VisibilityOp[Op])
    end
    if self.Btn_Empty_02 then
      self.Btn_Empty_02:SetVisibility("Collapsed" == Op and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.Visible)
    end
    if self.Text_Recruit_02 then
      self.Text_Recruit_02:SetVisibility("Collapsed" == Op and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.HitTestInvisible)
      if "Guild" == CTAType then
        self.Text_Recruit_02:SetText(GText("UI_GoToJoin"))
      elseif "Friend" == CTAType then
        self.Text_Recruit_02:SetText(GText("UI_Friend_GoToAdd"))
      end
    end
  end
  if DialogEmptyText and self.Text_DialogEmptyText then
    self.Text_DialogEmptyText:SetText(DialogEmptyText)
  end
  if self.WS_Dialoglist then
    self.WS_Dialoglist:SetActiveWidgetIndex(1)
  end
  if self.OnDMPlayerListEmptyShown then
    self:OnDMPlayerListEmptyShown()
  end
end

function M:_ShowDMPlayerListNormal(DialogEmptyText)
  if self.WS_PlayerList then
    self.WS_PlayerList:SetActiveWidgetIndex(0)
  end
  if self.Panel_Add_02 then
    self.Panel_Add_02:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Btn_Empty_02 then
    self.Btn_Empty_02:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Group_PlayerList:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if DialogEmptyText and self.Text_DialogEmptyText then
    self.Text_DialogEmptyText:SetText(DialogEmptyText)
  end
end

function M:_HandleRefreshTeamMateInTeamChannel()
  local TeamData = TeamController:GetModel():GetTeam()
  local TeamNumber = nil == TeamData and 0 or #TeamData.Members
  self:_SetUpInTeamChannelLayout(TeamNumber > 0)
  if 0 == TeamNumber then
    self:_SetUpFullEmpty(GText("UI_Chat_NoTeam"), GText("UI_Chat_GotoTeamUp"))
    return
  end
  self.Group_BottomNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Group_BottomEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_ChatEmpty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_ChatNormal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:_SetUpChatMsgList()
  self:_SetUpMsgCache()
end

return M
