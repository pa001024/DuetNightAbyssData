local UIUtils = require("Utils.UIUtils")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendModel = FriendController:GetModel()
local FriendCommon = require("BluePrints.UI.WBP.Friend.FriendCommon")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local GuildModel = GuildController:GetModel()
local M = {}
M.InviteSubTabId = {Friend = 1, Guild = 2}

function M:Construct()
  self.Text_Empty_1:SetText(GText("UI_Friend_NoAnyFriend"))
  FriendController:RegisterEvent(self, function(Inst, EventId, Uid)
    if EventId ~= FriendCommon.EventId.UpdateOneFriend and EventId ~= FriendCommon.EventId.RefreshFriend or 2 ~= Inst.CurMainTabIndex or Inst.CurSubTabId ~= M.InviteSubTabId.Friend then
      return
    end
    Inst:RefreshInviteFriendList()
  end)
end

function M:GetInviteSubTabInfoList()
  return {
    {
      Text = GText("UI_TeamFriends"),
      TabId = M.InviteSubTabId.Friend
    },
    {
      Text = GText("UI_TeamGuild"),
      TabId = M.InviteSubTabId.Guild
    }
  }
end

function M:RefreshInviteSubTab()
  self:EnsureGuildEventRegistered()
  self:EnsureOnlineCheckBoxBound()
  self:EnsureInviteFriendEmptyStateBound()
  self.bFilterOnline = false
  if self.CheckBox_Online then
    self.CheckBox_Online:SetCheckedState(ECheckBoxState.Unchecked)
  end
  self.InviteGuildMembers = nil
  self.bWaitingInviteGuildInfo = nil
  local AllSubTabInfo = self:GetInviteSubTabInfoList()
  self.Com_TabSub:UpdateTabs(AllSubTabInfo)
  self.Com_TabSub:SelectTab(1)
end

function M:EnsureInviteFriendEmptyStateBound()
  if self.bInviteFriendEmptyStateBound then
    return
  end
  if not self.Button_Area then
    return
  end
  self.bInviteFriendEmptyStateBound = true
  if self.Text_Add and self.Text_Add.SetText then
    self.Text_Add:SetText(GText("UI_Friend_GoToAdd"))
  end
  self.Button_Area.OnClicked:Add(self, self.OnClickInviteAddFriend)
end

function M:OnClickInviteAddFriend()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click", "AddFriend", nil)
  FriendController:OpenView(self, FriendCommon.FriendTabType.AddFriend)
end

function M:EnsureOnlineCheckBoxBound()
  if self.bOnlineCheckBoxBound then
    return
  end
  self.bOnlineCheckBoxBound = true
  if self.CheckBox_Online then
    self.CheckBox_Online.OnCheckStateChanged:Add(self, self.OnOnlineCheckBoxChange)
  end
end

function M:OnOnlineCheckBoxChange(bChecked)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  self.bFilterOnline = bChecked
  if 2 ~= self.CurMainTabIndex then
    return
  end
  if self.CurSubTabId == M.InviteSubTabId.Friend then
    self:RefreshInviteFriendList()
  elseif self.CurSubTabId == M.InviteSubTabId.Guild then
    if self.InviteGuildMembers then
      self:_RenderInviteGuildList()
    else
      self:RefreshInviteGuildList()
    end
  end
end

function M:OnSubTabSelected(TabWidget, TabData)
  if 2 ~= self.CurMainTabIndex then
    return
  end
  local TabId = self:_ResolveInviteSubTabId(TabWidget, TabData)
  self.CurSubTabId = TabId
  self:_RefreshInviteHeaderText()
  if TabId == M.InviteSubTabId.Friend then
    self:SetInviteMemberHeaderVisible(true)
    self:RefreshInviteFriendList()
    if not self.bInviteFriendInfoRequested then
      self.bInviteFriendInfoRequested = true
      FriendController:SendRequest(FriendCommon.EventId.RefreshFriend)
    end
    return
  end
  if TabId == M.InviteSubTabId.Guild then
    self:SetInviteMemberHeaderVisible(true)
    if self.InviteGuildMembers then
      self:_RenderInviteGuildList()
    else
      self:RefreshInviteGuildList()
    end
    return
  end
end

function M:SetInviteMemberHeaderVisible(bVisible)
  if self.Panel_Online then
    self.Panel_Online:SetVisibility(bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:_ResolveInviteSubTabId(TabWidget, TabData)
  local ResolvedTabData = TabData
  if not ResolvedTabData and self.Com_TabSub and self.Com_TabSub.Tabs and TabWidget and TabWidget.Idx then
    ResolvedTabData = self.Com_TabSub.Tabs[TabWidget.Idx]
  end
  return ResolvedTabData and ResolvedTabData.TabId or TabWidget and TabWidget.TabId
end

function M:_RefreshInviteHeaderText()
  local IsGuild = self.CurSubTabId == M.InviteSubTabId.Guild
  if self.Text_Friend then
    self.Text_Friend:SetText(GText(IsGuild and "UI_TeamGuildMemberCount" or "UI_Friend_FriendCount"))
  end
  if self.Text_OnlineFriend then
    self.Text_OnlineFriend:SetText(GText(IsGuild and "UI_TeamOnlineMembers" or "UI_Friend_OnlineFriend"))
  end
  if self.Text_Empty_OnLine then
    self.Text_Empty_OnLine:SetText(GText(IsGuild and "UI_NoOnlineGuildMember" or "UI_Friend_NoOnlineFriend"))
  end
end

function M:_UpdateInviteCount(TotalCount, OnlineCount, LimitCount)
  if self.Num_Friend then
    self.Num_Friend:SetText(tostring(TotalCount))
  end
  if self.Num_OnlineFriend then
    self.Num_OnlineFriend:SetText(tostring(OnlineCount))
  end
  if self.Num_Limit and LimitCount then
    self.Num_Limit:SetText(tostring(LimitCount))
  end
end

function M:_SwitchOnlineEmpty(bEmpty)
  if not self.WidgetSwitcher_OnLine then
    return
  end
  self.WidgetSwitcher_OnLine:SetActiveWidgetIndex(bEmpty and 1 or 0)
end

function M:_SwitchInviteFriendEmpty(bEmpty)
  self.WidgetSwitcher_State:SetActiveWidgetIndex(bEmpty and 1 or 0)
end

function M:RefreshInviteFriendList()
  if not self.List_MyFriend then
    return
  end
  if UIUtils.IsGamepadInput() then
    self:PrepareInitialInviteFocusAfterListRefresh()
  end
  self:SetInviteMemberHeaderVisible(true)
  TeamHallController:StopTimer(self.InviteListEntriesAnimTimerKey)
  self.List_MyFriend:SetRenderOpacity(1)
  self.List_MyFriend:ClearListItems()
  local FriendList, FriendOnlineList = FriendModel:GetFriendList()
  local TotalCount = FriendList and #FriendList or 0
  local OnlineCount = FriendOnlineList and #FriendOnlineList or 0
  local LimitCount = DataMgr.GlobalConstant.FriendHoldMax and DataMgr.GlobalConstant.FriendHoldMax.ConstantValue
  self:_UpdateInviteCount(TotalCount, OnlineCount, LimitCount)
  local TargetList = self.bFilterOnline and FriendOnlineList or FriendList
  if not TargetList or #TargetList <= 0 then
    if self.Text_Empty_1 then
      self.Text_Empty_1:SetText(GText("UI_Friend_NoAnyFriend"))
    end
    self:_SwitchInviteFriendEmpty(not self.bFilterOnline)
    self:_SwitchOnlineEmpty(self.bFilterOnline == true)
    self.bInviteFriendEmptyStateActive = not self.bFilterOnline
    self.bInviteInitialFocusCanFallbackToRoot = true
    self:TryFocusInitialInviteByGamepad()
    return
  end
  self:_SwitchInviteFriendEmpty(false)
  self:_SwitchOnlineEmpty(false)
  self.bInviteFriendEmptyStateActive = false
  local FriendDict = FriendModel:GetFriendDict()
  for _, Uid in ipairs(TargetList) do
    local FriendData = FriendDict[Uid]
    if FriendData and FriendData.Info then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Owner = self
      Content.Type = FriendCommon.FriendTabType.MyFriend
      Content.Data = FriendData
      self.List_MyFriend:AddItem(Content)
    end
  end
  self:PlayBoardListEntriesAnim(self.List_MyFriend, self.InviteListEntriesAnimTimerKey)
  self.bInviteInitialFocusCanFallbackToRoot = true
  self:TryFocusInitialInviteByGamepad()
end

function M:RefreshInviteGuildList()
  if not self.List_MyFriend then
    return
  end
  if UIUtils.IsGamepadInput() then
    self:PrepareInitialInviteFocusAfterListRefresh()
  end
  self:SetInviteMemberHeaderVisible(true)
  TeamHallController:StopTimer(self.InviteListEntriesAnimTimerKey)
  self.List_MyFriend:SetRenderOpacity(1)
  self.List_MyFriend:ClearListItems()
  self.bInviteFriendEmptyStateActive = false
  if not GuildModel:IsInGuild() then
    self.InviteGuildMembers = {}
    self.bWaitingInviteGuildInfo = nil
    self:SetInviteMemberHeaderVisible(false)
    self:_UpdateInviteCount(0, 0)
    if self.Text_Empty_OnLine then
      self.Text_Empty_OnLine:SetText(GText("UI_NotInGuild"))
    end
    self:_SwitchInviteFriendEmpty(false)
    self:_SwitchOnlineEmpty(true)
    self.bInviteInitialFocusCanFallbackToRoot = true
    self:TryFocusInitialInviteByGamepad()
    return
  end
  local Guild = GuildModel:GetCurrGuild()
  if not Guild or not Guild.Members then
    self.InviteGuildMembers = nil
    self.bWaitingInviteGuildInfo = true
    self:_SwitchInviteFriendEmpty(false)
    self:_SwitchOnlineEmpty(false)
    GuildController:SendGetGuildInfo()
    return
  end
  self.bWaitingInviteGuildInfo = nil
  local Avatar = GWorld:GetAvatar()
  local SelfUid = Avatar and Avatar.Uid or 0
  local Uids = {}
  self.InviteGuildMembers = {}
  for _, Member in ipairs(Guild.Members) do
    if Member.Uid ~= SelfUid then
      self:_FillGuildMemberStatus(Member, Avatar)
      table.insert(self.InviteGuildMembers, Member)
      table.insert(Uids, Member.Uid)
    end
  end
  self:_RenderInviteGuildList()
  if #Uids <= 0 then
    return
  end
  GuildModel:QueryGuildMemberInfo(function(Ret, MemberInfos)
    if Ret == ErrorCode.RET_SUCCESS then
      self:OnInviteGuildMemberInfo(MemberInfos)
    end
  end, Uids, true)
end

function M:OnInviteGuildMemberInfo(MemberInfos)
  if 2 ~= self.CurMainTabIndex or self.CurSubTabId ~= M.InviteSubTabId.Guild then
    return
  end
  if not self.List_MyFriend then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local SelfUid = Avatar and Avatar.Uid or 0
  self.InviteGuildMembers = {}
  for _, MemberInfo in pairs(MemberInfos or {}) do
    if MemberInfo.Uid ~= SelfUid then
      self:_FillGuildMemberStatus(MemberInfo, Avatar)
      table.insert(self.InviteGuildMembers, MemberInfo)
    end
  end
  self:_RenderInviteGuildList()
end

function M:_RenderInviteGuildList()
  if not self.List_MyFriend then
    return
  end
  if UIUtils.IsGamepadInput() then
    self:PrepareInitialInviteFocusAfterListRefresh()
  end
  self:SetInviteMemberHeaderVisible(true)
  TeamHallController:StopTimer(self.InviteListEntriesAnimTimerKey)
  self.List_MyFriend:SetRenderOpacity(1)
  self.List_MyFriend:ClearListItems()
  if not GuildModel:IsInGuild() then
    self.InviteGuildMembers = {}
    self:SetInviteMemberHeaderVisible(false)
    self:_UpdateInviteCount(0, 0)
    if self.Text_Empty_OnLine then
      self.Text_Empty_OnLine:SetText(GText("UI_NotInGuild"))
    end
    self:_SwitchInviteFriendEmpty(false)
    self:_SwitchOnlineEmpty(true)
    self.bInviteInitialFocusCanFallbackToRoot = true
    self:TryFocusInitialInviteByGamepad()
    return
  end
  local Members = self.InviteGuildMembers or {}
  local TotalCount = #Members
  local OnlineCount = 0
  for _, MemberInfo in ipairs(Members) do
    if MemberInfo.IsOnline then
      OnlineCount = OnlineCount + 1
    end
  end
  local LimitCount
  local Guild = GuildModel:GetCurrGuild()
  if Guild then
    local GuildLevelData = DataMgr.GuildLevel and DataMgr.GuildLevel[Guild.Level or 0]
    LimitCount = GuildLevelData and GuildLevelData.GuildMembersNum or 0
  end
  self:_UpdateInviteCount(TotalCount, OnlineCount, LimitCount)
  local bEmpty = true
  for _, MemberInfo in ipairs(Members) do
    if not self.bFilterOnline or MemberInfo.IsOnline then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Owner = self
      Content.Type = FriendCommon.FriendTabType.MyFriend
      Content.Data = {Info = MemberInfo}
      self.List_MyFriend:AddItem(Content)
      bEmpty = false
    end
  end
  if not bEmpty then
    self:PlayBoardListEntriesAnim(self.List_MyFriend, self.InviteListEntriesAnimTimerKey)
  end
  if bEmpty then
    if self.Text_Empty_OnLine then
      self.Text_Empty_OnLine:SetText(GText(self.bFilterOnline and "UI_NoOnlineGuildMember" or "UI_Friend_NoAnyFriend"))
    end
    self:_SwitchInviteFriendEmpty(false)
    self:_SwitchOnlineEmpty(true)
  else
    self:_SwitchOnlineEmpty(false)
    self:_SwitchInviteFriendEmpty(false)
  end
  self.bInviteFriendEmptyStateActive = false
  self.bInviteInitialFocusCanFallbackToRoot = true
  self:TryFocusInitialInviteByGamepad()
end

function M:_FillGuildMemberStatus(MemberInfo, Avatar)
  MemberInfo.LastLogoutTime = MemberInfo.LastLogoutTime or 0
  if MemberInfo.IsOnline == nil then
    MemberInfo.IsOnline = false
  end
  if nil ~= MemberInfo.IsInDungeon then
    return
  end
  if Avatar and nil ~= MemberInfo.AvatarStatus then
    MemberInfo.IsInDungeon = Avatar:IsInDungeon(MemberInfo.AvatarStatus)
    MemberInfo.IsInSpecialQuest = Avatar:IsInSpecialQuest(MemberInfo.AvatarStatus)
  else
    MemberInfo.IsInDungeon = false
    MemberInfo.IsInSpecialQuest = false
  end
end

function M:EnsureGuildEventRegistered()
  if self.bGuildEventRegistered then
    return
  end
  self.bGuildEventRegistered = true
  GuildController:RegisterEvent(self, function(Inst, EventId, ...)
    if EventId == GuildCommon.EventID.OnGetGuildInfo and Inst.bWaitingInviteGuildInfo and 2 == Inst.CurMainTabIndex and Inst.CurSubTabId == M.InviteSubTabId.Guild then
      Inst.bWaitingInviteGuildInfo = nil
      Inst:RefreshInviteGuildList()
    end
  end)
end

function M:Destruct()
  FriendController:UnRegisterEvent(self)
  if self.bOnlineCheckBoxBound then
    if self.CheckBox_Online then
      self.CheckBox_Online.OnCheckStateChanged:Remove(self, self.OnOnlineCheckBoxChange)
    end
    self.bOnlineCheckBoxBound = nil
  end
  if self.bInviteFriendEmptyStateBound then
    self.Button_Area.OnClicked:Remove(self, self.OnClickInviteAddFriend)
    self.bInviteFriendEmptyStateBound = nil
  end
  self.bInviteFriendEmptyStateActive = nil
  if self.bGuildEventRegistered then
    GuildController:UnRegisterEvent(self)
    self.bGuildEventRegistered = nil
  end
  self.bWaitingInviteGuildInfo = nil
end

function M:TryFocusInitialInviteByGamepad()
end

return M
