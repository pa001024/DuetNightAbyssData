local TeamController = require("BluePrints.UI.WBP.Team.TeamController")
local TeamCommon = require("BluePrints.UI.WBP.Team.TeamCommon")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local TeamHallCommon = require("BluePrints.UI.WBP.TeamHall.TeamHallCommon")
local TeamHallController = require("BluePrints.UI.WBP.TeamHall.TeamHallController")
local UIUtils = require("Utils.UIUtils")
local GText = _ENV.GText
local M = {}
M._components = {
  "BluePrints.UI.WBP.Team.View.WBP_Team_Board_RecruitCompoment",
  "BluePrints.UI.WBP.Team.View.WBP_Team_Board_InviteCompoment"
}

local function IsTeamHallSourceTraceEnabled()
  return TeamHallCommon.DebugFlags and TeamHallCommon.DebugFlags.EnableSourceTraceScreenPrint
end

local function ScreenPrintTeamHallSource(Message)
  if not IsTeamHallSourceTraceEnabled() or not ScreenPrint then
    return
  end
  ScreenPrint("[TeamHallSrc] " .. tostring(Message))
end

function M:Construct()
  self:StaticInit()
  self:DynamicInit()
  ChatController:UnRegisterEvent(self)
  ChatController:RegisterEvent(self, function(Inst, EventId, ...)
    if EventId == ChatCommon.EventID.CloseMainView and UIUtils.IsGamepadInput() then
      Inst:RemoveTimer(Inst.ChatCloseRestoreFocusTimerKey)
      Inst:TryRestoreTeamBoardFocusAfterChatClose()
    end
  end)
  if self.In then
    self:PlayAnimation(self.In)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "TeamBoard", nil)
end

function M:Destruct()
  if self.bRecruitEmptyContentBound and self.List_Team and self.List_Team.OnCreateEmptyContent then
    self.List_Team.OnCreateEmptyContent:Unbind()
    self.bRecruitEmptyContentBound = nil
  end
  self.Btn_Recruit:UnBindEventOnClicked(self, self.OnClickRecruitButton)
  if self.Btn_Cancel then
    self.Btn_Cancel:UnBindEventOnClicked(self, self.OnClickCancelButton)
  end
  self.Btn_Refresh:UnBindEventOnClicked(self, self.OnClickRefreshButton)
  if self.RecruitListEntriesAnimTimerKey then
    TeamHallController:StopTimer(self.RecruitListEntriesAnimTimerKey)
  end
  if self.InviteListEntriesAnimTimerKey then
    TeamHallController:StopTimer(self.InviteListEntriesAnimTimerKey)
  end
  self:RemoveTimer(self.InitialRecruitFocusTimerKey)
  self:RemoveTimer(self.InitialInviteFocusTimerKey)
  self:RemoveTimer(self.ChatCloseRestoreFocusTimerKey)
  TeamHallController:UnRegisterEvent(self)
  TeamController:UnRegisterEvent(self)
  ChatController:UnRegisterEvent(self)
end

function M:StaticInit()
  self:InitTab()
  self.Text_CheckBox:SetText(GText("UI_TeamShowOnlyNotFullTeams"))
  self.Btn_Cancel.Text_Button:SetText(GText("UI_TeamCancelRecruit"))
end

function M:DynamicInit()
  self.ConfigName = self.ConfigName or "TeamHall"
  self.RecruitListEntriesAnimTimerKey = "TeamHallRecruitEntriesAnim:" .. tostring(self)
  self.InviteListEntriesAnimTimerKey = "TeamHallInviteEntriesAnim:" .. tostring(self)
  self.InitialRecruitFocusTimerKey = "TeamHallInitialRecruitFocus:" .. tostring(self)
  self.InitialInviteFocusTimerKey = "TeamHallInitialInviteFocus:" .. tostring(self)
  self.ChatCloseRestoreFocusTimerKey = "TeamHallChatCloseRestoreFocus:" .. tostring(self)
  self.MineItem.TeamBoardOwner = self
  self.MineItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:InitTeamHeadUI()
  self:InitRecruitAction()
end

function M:TryRestoreTeamBoardFocusAfterChatClose()
  local ChatView = ChatController:GetView(self)
  if IsValid(ChatView) and not ChatView.IsMarkToRemove then
    self:AddTimer(0.01, function()
      if IsValid(self) then
        self:TryRestoreTeamBoardFocusAfterChatClose()
      end
    end, false, 0, self.ChatCloseRestoreFocusTimerKey)
    return
  end
  if UIUtils.IsGamepadInput() then
    self:RestoreTeamBoardInitialFocusByGamepad()
  end
end

function M:PlayBoardListEntriesAnim(ListView, TimerKey)
  TeamHallController:StopTimer(TimerKey)
  ListView:SetRenderOpacity(0)
  TeamHallController:AddTimer(0.01, function()
    if not IsValid(self) or not IsValid(ListView) then
      return
    end
    ListView:SetRenderOpacity(1)
    ListView:ScrollToTop()
    ListView:RequestPlayEntriesAnim()
  end, false, 0, TimerKey)
end

function M:InitTab()
  local TabConfigData = {
    TitleName = GText("UI_teamLobby"),
    LeftKey = "Q",
    RightKey = "E",
    StyleName = "TextImage",
    DynamicNode = {
      "Back",
      "Chat",
      "Team",
      "BottomKey"
    },
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    Tabs = {
      {
        Text = GText("UI_TeamRecruit"),
        TabId = 1,
        IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Chat/T_ChatChannel_Recruit.T_ChatChannel_Recruit'"
      },
      {
        Text = GText("UI_TeamInvite"),
        TabId = 2,
        IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Chat/T_ChatChannel_Invite.T_ChatChannel_Invite'"
      }
    },
    OwnerPanel = self,
    BackCallback = self.OnReturnKeyDown
  }
  self.Com_Tab:Init(TabConfigData)
  self.Com_Tab:BindEventOnTabSelected(self, self.OnTabSelected)
  self.Com_TabSub:Init({
    LeftKey = "A",
    RightKey = "D",
    LeftGamePadKey = "LeftTriggerThreshold",
    RightGamePadKey = "RightTriggerThreshold",
    Tabs = {},
    SoundFunc = function(Receiver)
      AudioManager(Receiver):PlayUISound(Receiver, "event:/ui/common/click_level_03", nil, nil)
    end
  })
  self.Com_TabSub:BindEventOnTabSelected(self, self.OnSubTabSelected)
  self.Com_Tab:SelectTab(1)
end

function M:UpdateTeamBoardBottomKeyInfo(FocusState)
  if "Menu" == FocusState then
    self.Com_Tab:SetBottomKeyInfoVisible(false)
    return
  end
  local BottomKeyInfo = {
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  if "Head" == FocusState then
    table.insert(BottomKeyInfo, 1, {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
        }
      },
      Desc = GText("UI_ViewPlayerInformation")
    })
  elseif "InviteItem" == FocusState then
    table.insert(BottomKeyInfo, 1, {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.SpecialLeft,
          Owner = self
        }
      },
      Desc = GText("UI_ViewPlayerInformation")
    })
  end
  self.Com_Tab:SetBottomKeyInfoVisible(true)
  self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function M:InitRecruitAction()
  self.Btn_Recruit:UnBindEventOnClicked(self, self.OnClickRecruitButton)
  self.Btn_Recruit:BindEventOnClicked(self, self.OnClickRecruitButton)
  if not self.bRecruitBtnSoundOverrided then
    self.bRecruitBtnSoundOverrided = true
    self.Btn_Recruit:TryOverrideSoundFunc(function()
      AudioManager(self):PlayUISound(self, "event:/ui/activity/confirm_click", nil, nil)
    end)
  end
  if not self.bRecruitForbidBinded then
    self.Btn_Recruit:BindForbidStateExecuteEvent(self, self.OnRecruitForbidClick)
    self.bRecruitForbidBinded = true
  end
  if self.Btn_Cancel then
    self.Btn_Cancel:UnBindEventOnClicked(self, self.OnClickCancelButton)
    self.Btn_Cancel:BindEventOnClicked(self, self.OnClickCancelButton)
  end
  self.Btn_Refresh:UnBindEventOnClicked(self, self.OnClickRefreshButton)
  self.Btn_Refresh:BindEventOnClicked(self, self.OnClickRefreshButton)
  self.Btn_Refresh:SetText(GText("UI_TeamRefresh"))
  if self.Text_Title and self.Text_Title.SetText then
    self.Text_Title:SetText(GText("UI_TeamRecruitTag"))
  end
  TeamHallController:UnRegisterEvent(self)
  TeamHallController:RegisterEvent(self, self.OnTeamHallEvent)
  TeamController:UnRegisterEvent(self)
  TeamController:RegisterEvent(self, self.OnTeamEvent)
  self:RefreshRecruitButtonState()
  self:RefreshRefreshButtonState()
  self:RefreshMyRecruitmentDetail()
  if self.SyncRecruitTimerByState then
    self:SyncRecruitTimerByState()
  end
end

function M:OnTeamEvent(EventId)
  if EventId ~= TeamCommon.EventId.TeamOnInit and EventId ~= TeamCommon.EventId.TeamOnAddPlayer and EventId ~= TeamCommon.EventId.TeamOnDelPlayer and EventId ~= TeamCommon.EventId.TeamOnMemberChange and EventId ~= TeamCommon.EventId.TeamOnChangeLeader and EventId ~= TeamCommon.EventId.TeamLeave then
    return
  end
  self:RefreshRecruitButtonState()
  self:RefreshMyRecruitmentDetail()
  if self.SyncRecruitTimerByState then
    self:SyncRecruitTimerByState()
  end
  if EventId == TeamCommon.EventId.TeamOnInit then
    TeamHallController:RequestRecruitmentList(function()
      if IsValid(self) and 1 == self.CurMainTabIndex then
        self:RefreshRecruitList()
      end
    end, nil, "TeamOnInit")
  end
end

function M:OnTabSelected(TabWidget)
  if self.CurMainTabIndex and self.CurMainTabIndex ~= TabWidget.Idx then
    if 1 == TabWidget.Idx then
      self.bNeedInitialInviteFocus = false
      self.bInitialInviteFocusDeferred = false
      self.bInviteInitialFocusCanFallbackToRoot = false
      self:RemoveTimer(self.InitialInviteFocusTimerKey)
    elseif 2 == TabWidget.Idx then
      self.bNeedInitialRecruitFocus = false
      self.bInitialRecruitFocusDeferred = false
      self:RemoveTimer(self.InitialRecruitFocusTimerKey)
    end
  end
  self.CurMainTabIndex = TabWidget.Idx
  self:SwitchContentPanel()
  self:InitSubTab()
  self:RefreshMyRecruitmentDetail()
  if UIUtils.IsGamepadInput() then
    if 1 == self.CurMainTabIndex then
      self:RefreshRecruitShortcutWidgetVisibility(true)
    elseif 2 == self.CurMainTabIndex then
      self:RefreshInviteShortcutWidgetVisibility(true)
    end
  end
end

function M:SwitchContentPanel()
  if not self.WS_Content then
    return
  end
  self.WS_Content:SetActiveWidgetIndex(self.CurMainTabIndex - 1)
end

function M:InitSubTab()
  if 1 == self.CurMainTabIndex then
    self:RefreshRecruitSubTab()
    return
  end
  if 2 == self.CurMainTabIndex then
    self:RefreshInviteSubTab()
    return
  end
  self.Com_TabSub:UpdateTabs({})
end

function M:OnSubTabSelected(TabWidget)
  self.CurSubTabId = TabWidget.TabId or TabWidget.Idx
end

function M:InitTeamHeadUI()
  local AttachWidget = self:GetTeamHeadAttachWidget()
  if not AttachWidget then
    return
  end
  if not self.TeamHeadUI then
    self.TeamHeadUI = TeamController:OpenHeadUI(AttachWidget)
  end
end

function M:GetTeamHeadAttachWidget()
  local IsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
  local AttachWidget = IsMobile and self.Com_Tab.Panel_Team or self.Com_Tab.Group_Team
  if AttachWidget then
    AttachWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  return AttachWidget
end

function M:OpenInviteFriendTab()
  if self.Com_Tab and self.Com_Tab.SelectTab then
    self.Com_Tab:SelectTab(2)
  end
  if self.Com_TabSub and self.Com_TabSub.SelectTab then
    self.Com_TabSub:SelectTab(1)
  end
end

function M:OnTeamHallEvent(EventId, RecruitmentId)
  if EventId == TeamHallCommon.EventId.HallDataChanged then
    self:RefreshMyRecruitmentDetail()
    return
  end
  if EventId == TeamHallCommon.EventId.RecruitmentExpired then
    if 1 == self.CurMainTabIndex then
      self:RemoveExpiredRecruitmentItem(RecruitmentId)
    end
    return
  end
  if EventId == TeamHallCommon.EventId.RecruitmentListRefreshStateChanged then
    self:RefreshRefreshButtonState()
    return
  end
  if EventId == TeamHallCommon.EventId.RecruitmentPublishCooldownStateChanged then
    self:RefreshRecruitButtonState()
    return
  end
  if EventId == TeamHallCommon.EventId.RequestFailed then
    if 1 == self.CurMainTabIndex then
      self:RefreshRecruitList()
    end
    return
  end
  if EventId == TeamHallCommon.EventId.RecruitmentStateChanged then
    self:RefreshRecruitButtonState()
    self:RefreshMyRecruitmentDetail()
    if 1 == self.CurMainTabIndex then
      self:RefreshRecruitList()
    end
    if self.SyncRecruitTimerByState then
      self:SyncRecruitTimerByState()
    end
    return
  end
end

function M:RefreshRecruitButtonState()
  local HallModel = TeamHallController:GetModel()
  if HallModel:IsRecruiting() then
    self.SizeBox_2:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.SizeBox_2:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local bIsRecruiting = HallModel:IsRecruiting() or HallModel:IsTeamInRecruiting()
  if bIsRecruiting then
    self.Btn_Recruit:ForbidBtn(false)
    if self.WS_Recruit then
      self.WS_Recruit:SetActiveWidgetIndex(1)
    end
    if self.Btn_Cancel then
      self.Btn_Cancel:ForbidBtn(false)
    end
    return
  end
  if self.WS_Recruit then
    self.WS_Recruit:SetActiveWidgetIndex(0)
  end
  self.Btn_Recruit:SetText(GText("UI_TeamInitiateRecruit"))
  self.Btn_Recruit:ForbidBtn(TeamHallController:IsRecruitmentPublishCoolingDown())
end

function M:RefreshMyRecruitmentDetail()
  if not self.MineItem then
    return
  end
  local HallModel = TeamHallController:GetModel()
  local RecruitmentData
  if HallModel:IsRecruiting() or HallModel:IsTeamInRecruiting() then
    RecruitmentData = self:GetMyRecruitmentDetailData()
  end
  if RecruitmentData and (1 ~= self.CurMainTabIndex or not HallModel:IsRecruitmentMatchFilter(RecruitmentData)) then
    RecruitmentData = nil
  end
  self.MineItem:InitRecruitmentDetail(RecruitmentData)
end

function M:BuildRuntimeRecruitmentDetailData(SourceRecruitmentData)
  local LocalRecruitmentInfo = TeamHallController:GetModel():GetLocalRecruitmentInfo()
  local BaseRecruitmentData = SourceRecruitmentData or LocalRecruitmentInfo
  if not BaseRecruitmentData then
    return nil
  end
  local RecruitmentData = {}
  for Key, Value in pairs(BaseRecruitmentData) do
    RecruitmentData[Key] = Value
  end
  if not SourceRecruitmentData then
    local SecondTypeConfig = DataMgr and DataMgr.TeamSecondType and DataMgr.TeamSecondType[RecruitmentData.SecondType]
    local DungeonLevelOptions = SecondTypeConfig and SecondTypeConfig.DungeonLevel
    local DungeonLevelIndex = tonumber(RecruitmentData.DungeonLevel)
    if DungeonLevelIndex and DungeonLevelIndex > 0 and type(DungeonLevelOptions) == "table" then
      RecruitmentData.DungeonLevel = DungeonLevelOptions[DungeonLevelIndex] or RecruitmentData.DungeonLevel
    end
  end
  if SourceRecruitmentData then
    RecruitmentData.RecruitStartTime = RecruitmentData.RecruitStartTime or TeamHallController:GetTeamHallRecruitmentStartTime()
  end
  RecruitmentData.Members = {}
  local TeamModel = TeamController:GetModel()
  local TeamData = TeamModel:GetTeam()
  if TeamData and TeamData.Members and #TeamData.Members > 0 then
    local LeaderUid = TeamModel:GetTeamLeaderId()
    local LeaderIndex
    for Index, MemberInfo in ipairs(TeamData.Members) do
      RecruitmentData.Members[Index] = {
        Uid = MemberInfo.Uid,
        HeadIconId = MemberInfo.HeadIconId,
        HeadFrameId = MemberInfo.HeadFrameId,
        HeadState = MemberInfo.HeadState
      }
      if MemberInfo.Uid == LeaderUid then
        LeaderIndex = Index
      end
    end
    if LeaderIndex and 1 ~= LeaderIndex then
      RecruitmentData.Members[1], RecruitmentData.Members[LeaderIndex] = RecruitmentData.Members[LeaderIndex], RecruitmentData.Members[1]
    end
    return RecruitmentData
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.Uid then
    RecruitmentData.Members[1] = {
      Uid = Avatar.Uid,
      HeadIconId = Avatar.HeadIconId,
      HeadFrameId = Avatar.HeadFrameId
    }
  end
  return RecruitmentData
end

function M:IsRecruitmentDetailDataComplete(RecruitmentData)
  return type(RecruitmentData) == "table" and (tonumber(RecruitmentData.FirstType) or 0) > 0 and (tonumber(RecruitmentData.SecondType) or 0) > 0
end

function M:TraceInvalidMyRecruitmentDetail(Reason, RecruitmentData, Source)
  local HallModel = TeamHallController:GetModel()
  local HallData = HallModel and HallModel:GetHallData() or nil
  local RecruitmentList = HallData and HallData:GetRecruitmentList() or nil
  local LocalRecruitmentInfo = HallModel and HallModel:GetLocalRecruitmentInfo() or nil
  local Avatar = GWorld:GetAvatar()
  local TeamHallId = Avatar and Avatar.TeamHallId or 0
  local FirstType = RecruitmentData and RecruitmentData.FirstType or nil
  local SecondType = RecruitmentData and RecruitmentData.SecondType or nil
  local MemberCount = RecruitmentData and RecruitmentData.Members and #RecruitmentData.Members or 0
  local Message = string.format("MineDetailSkip reason=%s source=%s first=%s second=%s members=%s recruiting=%s teamRecruiting=%s local=%s hallCount=%s teamHallId=%s", tostring(Reason), tostring(Source or "unknown"), tostring(FirstType), tostring(SecondType), tostring(MemberCount), tostring(HallModel and HallModel:IsRecruiting() or false), tostring(HallModel and HallModel:IsTeamInRecruiting() or false), tostring(nil ~= LocalRecruitmentInfo), tostring(RecruitmentList and #RecruitmentList or 0), tostring(TeamHallId or 0))
  if self.LastInvalidMineRecruitmentTrace ~= Message then
    self.LastInvalidMineRecruitmentTrace = Message
    ScreenPrintTeamHallSource(Message)
  end
end

function M:GetMyRecruitmentDetailData()
  local HallModel = TeamHallController:GetModel()
  local Avatar = GWorld:GetAvatar()
  local HallData = HallModel:GetHallData()
  local RecruitmentList = HallData and HallData:GetRecruitmentList() or nil
  if Avatar and RecruitmentList then
    for _, RecruitmentData in ipairs(RecruitmentList) do
      local MemberList = RecruitmentData.Members or {}
      for _, MemberData in ipairs(MemberList) do
        if MemberData.Uid == Avatar.Uid then
          local RuntimeRecruitmentData = self:BuildRuntimeRecruitmentDetailData(RecruitmentData)
          if self:IsRecruitmentDetailDataComplete(RuntimeRecruitmentData) then
            self.LastInvalidMineRecruitmentTrace = nil
            return RuntimeRecruitmentData
          end
          self:TraceInvalidMyRecruitmentDetail("hall_match_incomplete", RuntimeRecruitmentData, "hall")
          return nil
        end
      end
    end
  end
  local RuntimeRecruitmentData = self:BuildRuntimeRecruitmentDetailData()
  if self:IsRecruitmentDetailDataComplete(RuntimeRecruitmentData) then
    self.LastInvalidMineRecruitmentTrace = nil
    return RuntimeRecruitmentData
  end
  self:TraceInvalidMyRecruitmentDetail(HallModel:IsTeamInRecruiting() and "missing_full_data_in_team_recruiting" or "missing_full_data", RuntimeRecruitmentData, "local")
  return nil
end

function M:RefreshRefreshButtonState()
  local bCanManualRefresh = TeamHallController:CanManualRefreshRecruitmentList()
  local bForbid = not bCanManualRefresh
  self.Btn_Refresh:ForbidBtn(bForbid)
  if not bForbid and self.Btn_Refresh.PlayButtonUnForbidAnim then
    self.Btn_Refresh:PlayButtonUnForbidAnim()
  end
end

function M:OnClickRecruitButton()
  if TeamHallController:IsRecruitmentPublishCoolingDown() then
    TeamHallController:ShowRecruitmentPublishCooldownTip()
    return
  end
  if not self:CanOperateRecruitment(true) then
    return
  end
  self.RecruitPopupFocusKey = nil
  if UIUtils.IsGamepadInput() and nil ~= self.CurrentFocusKey and self.Sift:HasFocusedDescendants() then
    self.RecruitPopupFocusKey = self.CurrentFocusKey
  end
  TeamHallController:OpenRecruit(self, {
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = self.OnRecruitPopupClosed
  })
end

function M:OnRecruitPopupClosed()
  local FocusKey = self.RecruitPopupFocusKey
  self.RecruitPopupFocusKey = nil
  if not self.GameInputModeSubsystem then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  if nil ~= FocusKey and UIUtils.IsGamepadInput() then
    self:RestoreRecruitPopupFocusByGamepad(FocusKey)
  end
end

function M:OnRecruitForbidClick()
  if not TeamHallController:ShowRecruitmentPublishCooldownTip() then
    self:RefreshRecruitButtonState()
  end
end

function M:OnClickCancelButton()
  self:ShowCancelRecruitConfirm()
end

function M:OnClickRefreshButton()
  if not TeamHallController:CanManualRefreshRecruitmentList() then
    self:RefreshRefreshButtonState()
    return
  end
  self:TryRefreshCurrentRecruitList()
end

function M:ShowCancelRecruitConfirm()
  if not self:CanOperateRecruitment(false) then
    return
  end
  UIManager(self):ShowCommonPopupUI(TeamCommon.CancelRecruitConfirmDialog, {
    RightCallbackFunction = function()
      if not self:CanOperateRecruitment(false) then
        return
      end
      TeamHallController:CancelRecruitment(function()
        self:RefreshRecruitButtonState()
        self:RefreshMyRecruitmentDetail()
        if 1 == self.CurMainTabIndex then
          self:RefreshRecruitList()
        end
        if self.SyncRecruitTimerByState then
          self:SyncRecruitTimerByState()
        end
      end)
    end,
    ShortText = GText("UI_TeamConfirmCancelRecruit")
  }, self)
end

function M:CanOperateRecruitment(bPublish)
  local Avatar = GWorld:GetAvatar()
  local TeamModel = TeamController:GetModel()
  local TeamData = TeamModel:GetTeam()
  if not (Avatar and TeamData and TeamData.Members) or #TeamData.Members <= 1 then
    return true
  end
  local LeaderUid = TeamModel:GetTeamLeaderId()
  if not LeaderUid or LeaderUid == Avatar.Uid then
    return true
  end
  TeamController:ShowToast(GText(bPublish and "UI_TeamOnlyLeaderCanRecruit" or "UI_TeamCanCancelRecruit"))
  return false
end

function M:TryRefreshCurrentRecruitList()
  local FirstTypeId = self:GetRecruitFirstTypeId()
  local HallModel = TeamHallController:GetModel()
  local Filters = FirstTypeId and HallModel:BuildRecruitmentRequestFilters(FirstTypeId) or {}
  if 1 == self.CurMainTabIndex and FirstTypeId then
    self.CurSubTabId = FirstTypeId
    self:SearchTeamByTab(FirstTypeId, "ManualRefreshButton")
    return
  end
  TeamHallController:RequestRecruitmentList(nil, Filters, "ManualRefreshButton")
end

function M:GetRecruitFirstTypeId()
  if self.CurSubTabId then
    return self.CurSubTabId
  end
  local RecruitSubTabInfoList = TeamHallController:GetModel():GetRecruitSubTabInfoList()
  local DefaultSubTabInfo = RecruitSubTabInfoList and RecruitSubTabInfoList[1]
  return DefaultSubTabInfo and DefaultSubTabInfo.TabId or nil
end

function M:OnReturnKeyDown()
  self:PlayBoardOutAndClose()
end

function M:PlayBoardOutAndClose()
  if self.bBoardClosing then
    return
  end
  if not self.Out then
    self.IsBeginToClose = true
    self:RealClose()
    return
  end
  self.bBoardClosing = true
  AudioManager(self):SetEventSoundParam(self, "TeamBoard", {ToEnd = 1})
  self:BindToAnimationFinished(self.Out, {
    self,
    function(Inst)
      Inst.bBoardClosing = false
      Inst.IsBeginToClose = true
      Inst:RealClose()
    end
  })
  self:PlayAnimation(self.Out)
end

function M:Close()
  if self.bBoardClosing then
    return
  end
  self:PlayBoardOutAndClose()
end

function M:OnTeamBoardKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName, MyGeometry, InKeyEvent)
  elseif "Escape" == InKeyName then
    self:OnReturnKeyDown()
    IsEventHandled = true
  elseif "Q" == InKeyName or "E" == InKeyName then
    if self.Com_Tab and self.Com_Tab.Handle_KeyEventOnPC then
      IsEventHandled = self.Com_Tab:Handle_KeyEventOnPC(InKeyName)
    end
  elseif ("A" == InKeyName or "D" == InKeyName) and self.Com_TabSub and self.Com_TabSub.Handle_KeyEventOnPC then
    IsEventHandled = self.Com_TabSub:Handle_KeyEventOnPC(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

AssembleComponents(M)
return M
