require("UnLua")
local json = require("rapidjson")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildPermissionUtils = require("BluePrints.UI.WBP.Guild.Common.GuildPermissionUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
  self.ApproveApplicationKey = "ApproveApplication"
  self.Text_More:SetText(GText("UI_MoreOptions"))
  self.Text_Info:SetText(GText("UI_MemberInfo"))
  self.Text_Activity:SetText(GText("UI_WeeklyActivity"))
  self.Text_JoinTime:SetText(GText("UI_JoinDuration"))
  self.Text_Status:SetText(GText("UI_OnlineStatus"))
  self.Btn_Apply:SetText(GText("UI_ApplicationList"))
  self.Btn_Apply:SetNewIcon("/Game/UI/Texture/Static/Atlas/Guild/T_Guild_IconApplyList.T_Guild_IconApplyList")
  self.Btn_Recruit:SetText(GText("UI_RecruitMembers"))
  self.Btn_Recruit:SetNewIcon("/Game/UI/Texture/Static/Atlas/Guild/T_Guild_IconRecruitMember.T_Guild_IconRecruitMember")
  self:InitRecruitCoolDown()
  self.CurrentFocusIndex = 0
  self.Btn_More:BindEventOnClicked(self, self.OnClickBtnMore)
  self.Btn_More.MenuAnchor:SetPlacement(EMenuPlacement.MenuPlacement_MenuLeft)
  self.Btn_More.MenuAnchor.OnGetMenuContentEvent:Bind(self, self.OnGetBtnMoreMenuContent)
  self.Btn_More.MenuAnchor.OnMenuOpenChanged:Add(self, self.OnBtnMoreMenuOpenChanged)
  self.PressCallback = {
    Inst = self,
    Func = self.OnClickCheckBoxOnline
  }
  self.CheckBox_Online:BindEventOnClicked(self.PressCallback)
  self.Btn_Apply:BindEventOnClicked(self, self.OnClickBtnApply)
  self.Btn_Recruit:BindEventOnClicked(self, self.OnClickBtnRecruit)
  self.Btn_Recruit:BindForbidStateExecuteEvent(self, self.OnClickForbidRecruit)
  self.List_Member.OnListViewScrolled:Add(self, self.OnListViewScrolled)
  self.GuildModel = GuildController:GetModel()
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnQueryGuildMemberInfo then
      local MemberInfos = (...)
      self:OnReceiveMemberInfo(MemberInfos)
    elseif EventId == GuildCommon.EventID.OnGuildLeave then
      self:QuitGuildCallback()
    elseif EventId == GuildCommon.EventID.OnGuildKickMember or EventId == GuildCommon.EventID.OnGuildSetTitle or EventId == GuildCommon.EventID.OnGuildMessageMarkDirty then
      self.NeedUpdate = true
    elseif EventId == GuildCommon.EventID.OnGetGuildInfo and self.NeedUpdate then
      self:InitMemberInfos()
      self.NeedUpdate = false
    end
  end)
  ChatController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == ChatCommon.EventID.RefreshGuildMemberChatStatus then
      self:RefreshGuildMemberChatStatus()
    elseif EventId == ChatCommon.EventID.CloseMainView and self.ChatOpenFromMember then
      self.ChatOpenFromMember = false
      self:FocusToMemberList(true)
    end
  end)
  ReddotManager.AddListenerEx("GuildNewRequest", self, self.RefreshReddot)
  self:InitGamepadView()
  self:RefreshOpInfoByInputDevice()
end

function M:Init()
  self.SortArray = {
    "UI_Guild_OnlineTime",
    "UI_Guild_Level",
    "UI_Guild_RoleActivity"
  }
  self.SortByIndex = 1
  self.SortType = CommonConst.DESC
  self.Sort:Init(self, self.SortArray, CommonConst.DESC, {
    SortBy = self.SortByIndex,
    OnListOpened = function()
      self.IsSortListOpen = true
    end,
    OnListClosed = function()
      self.IsSortListOpen = false
    end,
    OnGetBackFocusWidget = function()
      self:InitBaseBottomKeyInfo()
      return self.List_Member
    end
  })
  self.Sort:BindEventOnSelectionsChanged(self, self.OnSelectionsChanged)
  self.Sort:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
  self.IsMoreOpen = false
  self:InitMemberInfos()
  GuildController:SendGetGuildInfo()
end

function M:RefreshUIInfo()
  self:InitMemberInfos()
end

function M:InitRecruitCoolDown()
  self.RecruitCoolDownTotalTime = DataMgr.GlobalConstant.GuildRecruitmentMessageCD.ConstantValue
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    self:UpdateRecruitBtn(false)
    return
  end
  local LastSendTime = Avatar.GuildRecruitLastSendTime or 0
  self.RecruitCoolDownTime = self.RecruitCoolDownTotalTime - (TimeUtils.NowTime() - LastSendTime)
  self:RecruitCoolDown()
  if self.RecruitCoolDownTime > 0 then
    self:AddTimer(1, self.RecruitCoolDown, true, 0, "RecruitCoolDownTimer", true)
  end
end

function M:OnListViewScrolled()
  for _, Content in pairs(self.List_Member:GetListItems()) do
    if Content.SelfWidget then
      Content.SelfWidget:CloseDismissBubble()
    end
  end
end

function M:RecruitCoolDown()
  if self.RecruitCoolDownTime <= 0 then
    self:UpdateRecruitBtn(false)
    self:RemoveTimer("RecruitCoolDownTimer")
  else
    self:UpdateRecruitBtn(true)
    self.RecruitCoolDownTime = self.RecruitCoolDownTime - 1
  end
end

function M:UpdateRecruitBtn(IsForbid)
  if IsForbid then
    if not self.Btn_Recruit:IsBtnForbidden() then
      self.Btn_Recruit:ForbidBtn(true)
    end
    self.Btn_Recruit:SetText(GText("UI_RecruitMembers") .. "(" .. tostring(self.RecruitCoolDownTime) .. "s)")
  else
    if self.Btn_Recruit:IsBtnForbidden() then
      self.Btn_Recruit:ForbidBtn(false)
    end
    self.Btn_Recruit:SetText(GText("UI_RecruitMembers"))
  end
end

function M:RefreshWhenGetGuildInfo()
  local GuildFullInfo = self.GuildModel:GetCurrGuild()
  if not GuildFullInfo then
    return
  end
  local MemberCount = 0
  for i, Member in pairs(GuildFullInfo.Members or {}) do
    MemberCount = MemberCount + 1
  end
  if MemberCount ~= self.MemberCount then
    self:InitMemberInfos()
  end
end

function M:InitMemberInfos()
  local GuildFullInfo = self.GuildModel:GetCurrGuild()
  if not GuildFullInfo then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local SelfUid = Avatar.Uid
  self.MemberCount = 0
  self.MemberOnline = 0
  self.CanApproveApplication = false
  local GuildMemberMaxCount = 0
  local GuildLevel = GuildFullInfo.Level or 0
  local GuildLevelData = DataMgr.GuildLevel[GuildLevel]
  if GuildLevelData then
    GuildMemberMaxCount = GuildLevelData.GuildMembersNum or 0
  end
  DebugPrint("InitMemberInfos GuildLevel: ", GuildLevel, "GuildMemberMaxCount: ", GuildMemberMaxCount)
  local MemberUids = {}
  for i, Member in pairs(GuildFullInfo.Members or {}) do
    table.insert(MemberUids, Member.Uid)
    self.MemberCount = self.MemberCount + 1
    local Info = {}
    Info.Uid = Member.Uid or 0
    Info.Title = Member.Title or 1
    if 5 == Member.Title then
      Info.IsMaster = true
    end
    if Member.Uid == SelfUid then
      self.SelfGuildInfo = Info
      self.CanApproveApplication = GuildPermissionUtils.GetEffectivePermission(GuildFullInfo.ClosedPermission, Info.Title, self.ApproveApplicationKey)
    end
    DebugPrint("InitMemberInfos Member.Uid: ", Member.Uid, "Title: ", Member.Title)
  end
  GuildController:SendQueryGuildMemberInfo(MemberUids)
  self.Text_MemberNum:SetText(tostring(self.MemberCount))
  self.Text_TotalNum:SetText(tostring(GuildMemberMaxCount))
  self.Text_Online:SetText(string.format(GText("UI_OnlineMembers"), tostring(self.MemberOnline)))
  if self.CanApproveApplication then
    self.Btn_Apply:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Btn_Apply:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnReceiveMemberInfo(MemberInfos)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local SelfUid = Avatar.Uid
  self.SelfGuildInfo = nil
  self.GuildMemberInfo = {}
  self.MemberCount = 0
  self.MemberOnline = 0
  local GuildId = self.GuildModel:GetCurrGuild().GuildId
  for i, Member in pairs(MemberInfos or {}) do
    local Info = {}
    self.MemberCount = self.MemberCount + 1
    Info.Uid = Member.Uid or 0
    Info.Title = Member.Title or 1
    if 5 == Member.Title then
      Info.IsMaster = true
    end
    Info.GuildActivityLevel = Member.GuildActivityLevel or 0
    Info.LastLogin = Member.LastLogin or 0
    if Member.Uid == SelfUid then
      Info.IsSelf = true
      self.SelfGuildInfo = Info
    end
    Info.HeadIconId = Member.HeadIconId or 10001
    Info.HeadFrameId = Member.HeadFrameId or -1
    Info.Level = Member.Level or 0
    Info.Nickname = Member.Nickname or ""
    Info.IsOnline = Member.IsOnline
    if Member.AvatarStatus then
      Info.IsInDungeon = Avatar:IsInDungeon(Member.AvatarStatus)
      Info.IsInSpecialQuest = Avatar:IsInSpecialQuest(Info.AvatarStatus)
    end
    Info.LastLogoutTime = Member.LastLogoutTime or 0
    Info.LastLoginTime = Member.LastLoginTime or 0
    Info.JoinTime = Member.JoinTime or 0
    Info.GuildId = GuildId
    table.insert(self.GuildMemberInfo, Info)
    if Info.IsOnline then
      self.MemberOnline = self.MemberOnline + 1
    end
    DebugPrint("OnReceiveMemberInfo Uid: ", Member.Uid, "Title: ", Member.Title, "LastLogin: ", Member.LastLogin, "GuildActivityLevel: ", Member.GuildActivityLevel, "HeadFrameId: ", Member.HeadFrameId, "Level: ", Member.Level, "Nickname: ", Member.Nickname, "IsOnline: ", Member.IsOnline, "IsInDungeon: ", Member.IsInDungeon, "IsInSpecialQuest: ", Member.IsInSpecialQuest, "HeadIconId: ", Member.HeadIconId, "LastLogoutTime: ", Member.LastLogoutTime, "LastLoginTime: ", Member.LastLoginTime, "JoinTime: ", Member.JoinTime)
  end
  self:SortGuildMemberInfo()
  self:InitMemberList(self:CanForceFocus())
  self.Text_MemberNum:SetText(tostring(self.MemberCount))
  self.Text_Online:SetText(string.format(GText("UI_OnlineMembers"), tostring(self.MemberOnline)))
end

function M:SortGuildMemberInfo()
  table.sort(self.GuildMemberInfo, function(a, b)
    local SortKey = self.SortArray[self.SortByIndex]
    if "UI_Guild_OnlineTime" == SortKey then
      if a.IsOnline and not b.IsOnline then
        if self.SortType == CommonConst.DESC then
          return true
        else
          return false
        end
      elseif not a.IsOnline and b.IsOnline then
        if self.SortType == CommonConst.DESC then
          return false
        else
          return true
        end
      end
      if a.LastLogoutTime ~= b.LastLogoutTime then
        if self.SortType == CommonConst.DESC then
          return a.LastLogoutTime > b.LastLogoutTime
        else
          return a.LastLogoutTime < b.LastLogoutTime
        end
      end
    elseif "UI_Guild_Level" == SortKey then
      if a.Level ~= b.Level then
        if self.SortType == CommonConst.DESC then
          return a.Level > b.Level
        else
          return a.Level < b.Level
        end
      end
    elseif "UI_Guild_RoleActivity" == SortKey and a.GuildActivityLevel ~= b.GuildActivityLevel then
      if self.SortType == CommonConst.DESC then
        return a.GuildActivityLevel > b.GuildActivityLevel
      else
        return a.GuildActivityLevel < b.GuildActivityLevel
      end
    end
    if a.Title ~= b.Title then
      return a.Title > b.Title
    end
    if a.Level ~= b.Level then
      return a.Level > b.Level
    end
    return a.Uid < b.Uid
  end)
end

function M:InitMemberList(NeedNavigate)
  self.List_Member:ClearListItems()
  local IsOnline = self.CheckBox_Online:IsChecked()
  for i, MemberInfo in pairs(self.GuildMemberInfo or {}) do
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Parent = self
    Obj.Info = MemberInfo
    Obj.Index = i
    if IsOnline then
      if MemberInfo.IsOnline then
        self.List_Member:AddItem(Obj)
      end
    else
      self.List_Member:AddItem(Obj)
    end
  end
  self.List_Member.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
  self.List_Member:RequestFillEmptyContent()
  if UIUtils.IsGamepadInput() and NeedNavigate then
    self:FocusToMemberList()
  end
end

function M:SetCurrentFocusIndex(Index)
  self.CurrentFocusIndex = Index
end

function M:OnClickMemberPermissions()
  self:OpenGuildPermissionDialog()
  self:OpenMoreMenu(false)
end

function M:OnClickQuitGuild()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local Params = {}
  
  function Params.RightCallbackFunction()
    self:ConfirmQuitGuild()
  end
  
  local CurrentLevel = 0
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    CurrentLevel = Avatar.Level or 0
  end
  if CurrentLevel < DataMgr.GlobalConstant.GuildQuitProtectLevel.ConstantValue then
    Params.Tips = {
      string.format(GText("GuildExitProtectToast"), tostring(DataMgr.GlobalConstant.GuildQuitProtectLevel.ConstantValue), tostring(DataMgr.GlobalConstant.GuildQuitLowLevelCoolDownM.ConstantValue))
    }
  else
    Params.Tips = {
      string.format(GText("UI_RejoinGuildCooldown"), tostring(DataMgr.GlobalConstant.GuildQuitRejoinCoolDownH.ConstantValue))
    }
  end
  Params.AutoFocus = true
  Params.AutoFocusDelayTime = 0.02
  UIManager:ShowCommonPopupUI(100365, Params)
  self:OpenMoreMenu(false)
end

function M:OnClickForbidQuitGuild()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildMasterCannotQuit"))
  self:OpenMoreMenu(false)
end

function M:ConfirmQuitGuild()
  GuildController:SendGuildLeave()
  self.IsDissolve = false
end

function M:QuitGuildCallback()
  if self.IsDissolve then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildDissolvedSuccessfully"))
  else
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_QuitGuildSuccess"))
  end
end

function M:OnClickDissolveGuild()
  local Params = {}
  
  function Params.RightCallbackFunction()
    self:ConfirmDissolveGuild()
  end
  
  UIManager(self):ShowCommonPopupUI(100366, Params)
  self:OpenMoreMenu(false)
end

function M:ConfirmDissolveGuild()
  GuildController:SendGuildLeave()
  self.IsDissolve = true
end

function M:GetZOrder()
  self.ParentWidget:GetZOrder()
end

function M:OnSelectionsChanged(CurSortBy, CurSortType)
  DebugPrint("WBP_Guild_Member_C OnSelectionsChanged", CurSortBy, CurSortType)
  self.SortByIndex = CurSortBy
  self.SortType = CurSortType
  self:SortGuildMemberInfo()
  self:InitMemberList(false)
end

function M:OnSortTypeChanged(CurSortType, CurSortBy)
  DebugPrint("WBP_Guild_Member_C OnSortTypeChanged", CurSortBy, CurSortType)
  self.SortByIndex = CurSortBy
  self.SortType = CurSortType
  self:SortGuildMemberInfo()
  self:InitMemberList(false)
end

function M:OnClickBtnMore()
  self:OpenMoreMenu(true)
end

function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
  DebugPrint("WBP_Guild_Member_P_C OnContentFocusReceived Child")
  self:FocusToMemberList(true)
  return UIUtils.Handled
end

function M:OpenMoreMenu(bOpen)
  if bOpen then
    self.Btn_More.MenuAnchor:Open(true)
  else
    self.Btn_More.MenuAnchor:Close()
  end
end

function M:OnClickCheckBoxOnline()
  self:InitMemberList(true)
end

function M:OnClickBtnApply()
  if not self.CanApproveApplication then
    return
  end
  self:OpenGuildRequestDialog()
end

function M:OnClickBtnRecruit()
  local Params = {}
  local Data = DataMgr.GlobalConstant.GuildRecruitmentMaxLen or {ConstantValue = 30}
  Params.EditTextConfig = {
    Text = GText("UI_RecruitmentMessage"),
    bNeedCheckStringSensitive = true,
    TextLimit = Data.ConstantValue,
    ResidentTipText = GText("UI_RecruitmentMessageSent"),
    OnCheckStringSensitive = function(_, bSuccess, Text)
      if bSuccess then
        self:SendGuildRecruitInfo(Text)
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RecruitmentMessageSuccess"))
        self.RecruitCoolDownTime = self.RecruitCoolDownTotalTime
        self:RemoveTimer("RecruitCoolDownTimer")
        self:RecruitCoolDown()
        self:AddTimer(1, self.RecruitCoolDown, true, 0, "RecruitCoolDownTimer", true)
      end
    end,
    Events = {
      OnTextChanged = function(_, Text)
        if nil == Text or 0 == #Text then
          self.RecruitDialog:GetButtonBar().Btn_Yes:ForbidBtn(true)
        else
          self.RecruitDialog:GetButtonBar().Btn_Yes:ForbidBtn(false)
        end
      end
    }
  }
  
  function Params.OnCloseCallbackFunction(Obj, Data, Widget)
    self:FocusToMemberList(true)
  end
  
  self.RecruitDialog = UIManager(self):ShowCommonPopupUI(100367, Params)
  self.RecruitDialog:GetButtonBar().Btn_Yes:ForbidBtn(false)
end

function M:OnClickForbidRecruit()
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_ActionTooFrequent"))
end

function M:PlayInAnim()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/common_page_in", nil, nil)
end

function M:PlayOutAnim()
  self:PlayAnimation(self.Out)
end

function M:OpenGuildPermissionDialog()
  UIManager(self):LoadUINew("GuildPermissionDialog")
end

function M:OpenGuildRequestDialog()
  local Params_GuildRequest = {
    Title = GText("UI_ApplicationList"),
    HintText = GText("UI_TRAIN_CLOSE"),
    ButtonBarName = "Dialog_Button_L",
    ShowBKeyClose = true,
    Parent = self
  }
  self.GuildRequest_Dialog = UIManager(self):ShowCommonPopupUI(100368, Params_GuildRequest, self)
end

function M:OnGetBtnMoreMenuContent()
  if not IsValid(self.BtnMoreMenu) then
    self.BtnMoreMenu = UIManager(self):CreateWidget("/Game/UI/WBP/Guild/Widget/WBP_Guild_SelectionTip.WBP_Guild_SelectionTip")
  end
  local ConfigData = {}
  
  function ConfigData.OnClickQuitGuild()
    self:OnClickQuitGuild()
  end
  
  function ConfigData.OnClickDissolveGuild()
    self:OnClickDissolveGuild()
  end
  
  function ConfigData.OnClickMemberPermissions()
    self:OnClickMemberPermissions()
  end
  
  function ConfigData.OnClickForbidQuitGuild()
    self:OnClickForbidQuitGuild()
  end
  
  ConfigData.SelfGuildInfo = self.SelfGuildInfo
  ConfigData.MemberCount = self.MemberCount
  self.BtnMoreMenu:Init(ConfigData)
  return self.BtnMoreMenu
end

function M:OnBtnMoreMenuOpenChanged(bIsOpen)
  self.IsMoreMenuOpen = bIsOpen
  if bIsOpen then
    self:InitEnsureBackBottomKeyInfo()
  else
    self:InitBaseBottomKeyInfo()
    local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
    if not CommonDialog then
      self:FocusToMemberList(true)
    end
  end
end

function M:Destruct()
  self.Btn_More:UnBindEventOnClicked(self, self.OnClickBtnMore)
  self.Btn_More.MenuAnchor.OnGetMenuContentEvent:Unbind()
  self.Btn_More.MenuAnchor.OnMenuOpenChanged:Remove(self, self.OnBtnMoreMenuOpenChanged)
  self.CheckBox_Online:UnBindEventOnClicked(self.PressCallback)
  self.Btn_Apply:UnBindEventOnClicked(self, self.OnClickBtnApply)
  self.Btn_Recruit:UnBindEventOnClicked(self, self.OnClickBtnRecruit)
  self.List_Member.OnListViewScrolled:Remove(self, self.OnListViewScrolled)
  GuildController:UnRegisterEvent(self)
  ChatController:UnRegisterEvent(self)
  self:RemoveTimer("RecruitCoolDownTimer")
  ReddotManager.RemoveListener("GuildNewRequest", self)
end

function M:SendGuildRecruitInfo(RecruitMessage)
  local Guild = self.GuildModel:GetCurrGuild()
  if not Guild then
    return
  end
  local GuildId = tonumber(Guild.GuildId) or 0
  if GuildId <= 0 then
    return
  end
  local Level = tonumber(Guild.Level) or 0
  local MemberCount = tonumber(Guild.MemberCount) or 0
  local GuildLevelData = DataMgr.GuildLevel and DataMgr.GuildLevel[Level]
  local MemberLimit = 0
  if GuildLevelData then
    MemberLimit = tonumber(GuildLevelData.GuildMembersNum) or 0
  end
  local Logo = "1,1,1|1,1,1"
  Logo = Guild.LogoInfo and type(Guild.LogoInfo.Pack) == "function" and Guild.LogoInfo:Pack() or Logo
  local Payload = {
    GuildId = GuildId,
    GuildName = Guild.Name or "",
    Level = Level,
    MemberCount = MemberCount,
    MemberLimit = MemberLimit,
    Logo = Logo,
    RecruitMessage = RecruitMessage
  }
  local MsgText = ChatCommon.GuildRecruitHeader .. json.encode(Payload)
  ChatController:SendChatToWorld(CommonConst.ChatChannel.TeamUp, MsgText)
end

function M:RefreshReddot(Count)
  if Count > 0 then
    self.Btn_Apply:SetReddotNumberVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Apply:SetReddotNumber(Count)
  else
    self.Btn_Apply:SetReddotNumberVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshGuildMemberChatStatus()
  for _, Content in pairs(self.List_Member:GetListItems()) do
    if Content.SelfWidget then
      Content.SelfWidget:RefreshChatStatus()
    end
  end
end

function M:InitGamepadView()
  self.Controller_More:CreateGamepadKey(UIConst.GamePadImgKey.RightThumb)
  self.Btn_Apply:SetGamePadImg(UIConst.GamePadImgKey.SpecialRight)
  self.Btn_Recruit:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)
  self.CheckBox_Online:InitGamepadKey(UIConst.GamePadImgKey.FaceButtonLeft)
  self.Sort:SetGamepadKey(UIConst.GamePadImgKey.LeftThumb)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
    return
  end
  self:UpdateUIType(CurInputDevice, CurGamepadName)
end

function M:UpdateUIType(CurInputDevice, CurGamepadName, NeedFocus)
  if UIUtils.IsGamepadInput() then
    self:RefreshGamepadView(NeedFocus)
  else
    self:RefreshKeyboardView()
  end
end

function M:RefreshGamepadView(NeedFocus)
  if self.IsSortListOpen then
    self:InitEnsureBackBottomKeyInfo()
  else
    self:InitBaseBottomKeyInfo()
    if NeedFocus then
      self:FocusToMemberList()
    end
    self.Controller_More:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:RefreshKeyboardView()
  self.Controller_More:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UIUtils.IsGamepadInput() then
    IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  end
  return IsHandled
end

function M:FocusToMemberList(UseLastIndex)
  self.List_Member:SetFocus()
  if UseLastIndex then
    local FocusIndex = math.max(0, self.CurrentFocusIndex - 1)
    self.List_Member:NavigateToIndex(FocusIndex)
  else
    self.List_Member:NavigateToIndex(0)
  end
end

function M:CanForceFocus()
  if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
    return false
  end
  return self.IsOnMemberList
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  local IsHandled = false
  if self.IsMoreMenuOpen then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self.Btn_More.MenuAnchor:Close()
      self:FocusToMemberList(true)
    end
    IsHandled = true
    return IsHandled
  end
  if self.OtherGamePadInfoVisibility == false then
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    self.Sort:SetFocus()
    self:InitEnsureBackBottomKeyInfo()
    IsHandled = true
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self.Btn_More:OnBtnClicked()
    IsHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self.CheckBox_Online:OnClicked()
    IsHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self.Btn_Recruit:IsBtnForbidden() then
      self:OnClickForbidRecruit()
    else
      self:OnClickBtnRecruit()
    end
    IsHandled = true
  elseif InKeyName == UIConst.GamePadKey.SpecialRight then
    self.Btn_Apply:OnBtnClicked()
    IsHandled = true
  end
  return IsHandled
end

function M:OnConfirmKeyDown()
  if self.CurrentFocusWidget then
    self.CurrentFocusWidget.Button_Funtion:OnBtnClick()
  end
end

function M:InitBaseBottomKeyInfo()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.ParentWidget then
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.SpecialLeft,
            Owner = self
          }
        },
        Desc = GText("UI_ViewPlayerInformation")
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.ParentWidget:UpdateComTab(BottomKeyInfo)
  end
  self:SetOtherGamePadInfoVisibility(true)
  self.IsOnMemberList = true
end

function M:InitEnsureBackBottomKeyInfo()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.ParentWidget then
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom,
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.ParentWidget:UpdateComTab(BottomKeyInfo)
  end
  self:SetOtherGamePadInfoVisibility(false)
  self.IsOnMemberList = false
end

function M:InitBackBottomKeyInfo()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.ParentWidget then
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.ParentWidget:UpdateComTab(BottomKeyInfo)
  end
  self:SetOtherGamePadInfoVisibility(false)
  self.IsOnMemberList = false
end

function M:InitEmptyBottomKeyInfo()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.ParentWidget then
    local BottomKeyInfo = {}
    self.ParentWidget:UpdateComTab(BottomKeyInfo)
  end
  self:SetOtherGamePadInfoVisibility(false)
  self.IsOnMemberList = false
end

function M:SetOtherGamePadInfoVisibility(bVisible)
  self.OtherGamePadInfoVisibility = bVisible
  if bVisible then
    self.Controller_More:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Apply:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Recruit:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Sort:SetControllerKeyHidden(false)
    self.CheckBox_Online.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.ParentWidget then
      self.ParentWidget:SetTopGamepadIconVisibility(true)
    end
  else
    self.Controller_More:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Apply:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Recruit:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.Sort:SetControllerKeyHidden(true)
    self.CheckBox_Online.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.ParentWidget then
      self.ParentWidget:SetTopGamepadIconVisibility(false)
    end
  end
end

return M
