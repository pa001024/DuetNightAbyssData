require("UnLua")
local UIUtils = require("Utils.UIUtils")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local GuildPermissionUtils = require("BluePrints.UI.WBP.Guild.Common.GuildPermissionUtils")
local FriendCommon = require("BluePrints.UI.WBP.Friend.FriendCommon")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase",
  "BluePrints.UI.WBP.Friend.View.Base.WBP_Friend_ListBase"
})

function M:Construct()
  M.Super.Construct(self)
  self.MyListView = self.List
  self._MemberInfoByUid = {}
  self._PersonalInfoQuerying = {}
  if self.Switcher_Content and self.Switcher_Content.SetActiveWidgetIndex then
    self.Switcher_Content:SetActiveWidgetIndex(0)
  end
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGuildGetJoinRequests then
      self:_OnJoinRequestsDataChanged()
    elseif EventId == GuildCommon.EventID.OnGuildAgreeJoinRequest or EventId == GuildCommon.EventID.OnGuildRejectJoinRequest or EventId == GuildCommon.EventID.OnNotifyGuildRecvNewJoinRequest then
      self:_OnJoinRequestsListMutated()
    end
  end)
  AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", "GuildRequestDialog", nil)
  self:AddInputMethodChangedListen()
  self:AddTimer(0.2, function()
    if (self.ListDatas == nil or 0 == #self.ListDatas) and self.GameInputModeSubsystem then
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    end
    self:SetFocus()
  end, false, 0, nil, true)
  self:SetTextMap()
  if self.CheckBox_1 and self.CheckBox_1.BindEventOnClicked then
    self.CheckBox_1:BindEventOnClicked({
      Inst = self,
      Func = self.OnGuildApprovalManualClicked
    })
    self.CheckBox_2:BindEventOnClicked({
      Inst = self,
      Func = self.OnGuildApprovalAutoClicked
    })
    self.CheckBox_1:HideGamepadBackground(true)
    self.CheckBox_2:HideGamepadBackground(true)
  end
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RS"}
    }
  })
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetTextMap()
  self.Text_Empty:SetText(GText("UI_NoGuildApply"))
  self.CheckBox_1.Text_Hint:SetText(GText("UI_ManualApproval"))
  self.CheckBox_2.Text_Hint:SetText(GText("UI_AutoApproval"))
end

function M:RefreshSizeBoxBottomByGuildTitle()
  local g = GuildController:GetModel():GetCurrGuild()
  local Avatar = GWorld:GetAvatar()
  local selfUid = Avatar and Avatar.Uid
  local member = g and selfUid and g.GetMemberByUid and g:GetMemberByUid(selfUid)
  local titleId = member and member.Title
  local bShow = titleId == GuildPermissionUtils.TitlePresident or titleId == GuildPermissionUtils.TitleVicePresident
  self.SizeBox_Bottom:SetVisibility(bShow and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshApprovalCheckBoxesFromGuild()
  if not self.CheckBox_1 or not self.CheckBox_1.SetIsCheckedWithoutCallback then
    return
  end
  local g = GuildController:GetModel():GetCurrGuild()
  local bAuto = g and g.AutoAgreeJoinRequest == true
  self.CheckBox_1:SetIsCheckedWithoutCallback(not bAuto, false)
  self.CheckBox_2:SetIsCheckedWithoutCallback(bAuto, false)
end

function M:OnGuildApprovalManualClicked(bChecked)
  if bChecked then
    self.CheckBox_2:SetIsCheckedWithoutCallback(false, false)
    local g = GuildController:GetModel():GetCurrGuild()
    if not g or g.AutoAgreeJoinRequest ~= false then
      GuildController:SendGuildSetAutoAgreeJoinRequest(false)
    end
  else
    self.CheckBox_1:SetIsCheckedWithoutCallback(true, false)
  end
end

function M:OnGuildApprovalAutoClicked(bChecked)
  if bChecked then
    self.CheckBox_1:SetIsCheckedWithoutCallback(false, false)
    local g = GuildController:GetModel():GetCurrGuild()
    if not g or g.AutoAgreeJoinRequest ~= true then
      GuildController:SendGuildSetAutoAgreeJoinRequest(true)
    end
  else
    self.CheckBox_2:SetIsCheckedWithoutCallback(true, false)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Gamepad then
    self:SetFocus()
    self:RefreshNavigationRule()
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.IsFocusedCheckBox1 = false
    self.IsFocusMode = false
  end
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.Owner = Owner
  self.Params = Params or {}
  self.IsRejectAll = false
  self.FuncIdx = 1
  self.SortType = CommonConst.DESC
  self._MemberInfoByUid = {}
  self._PersonalInfoQuerying = {}
  self.ParentWidget = Params.Parent
  self:CollapseButtonBar()
  if Params and Params.ButtonBarName then
    local Filters = {
      "UI_Friend_RequestTime"
    }
    self.Owner:GetButtonBar().WBP_Com_Sort:Init(self.Owner, Filters, self.SortType, {
      OnGetBackFocusWidget = function()
        return self.MyListView
      end
    })
    self.Owner:GetButtonBar().WBP_Com_Sort:BindEventOnSelectionsChanged(self, self.OnFilterChanged)
    self.Owner:GetButtonBar().WBP_Com_Sort:BindEventOnSortTypeChanged(self, self.OnFilterChanged)
    self.Owner:GetButtonBar().Btn_Yes:SetText(GText("UI_Friend_AcceptAll"))
    self.Owner:GetButtonBar().Btn_Quit:SetText(GText("UI_Friend_RejectAll"))
    self.Owner:GetButtonBar().Btn_Yes:BindEventOnClicked(self, self.OnBtnYesOrNoRelease, true)
    self.Owner:GetButtonBar().Btn_Quit:BindEventOnClicked(self, self.OnBtnYesOrNoRelease, false)
    self.Owner:GetButtonBar():SetVisibility(UIConst.VisibilityOp.Visible)
    self.Owner:GetButtonBar().Btn_Yes:SetGamePadImg("Right")
    self.Owner:GetButtonBar().Btn_Quit:SetGamePadImg("Left")
  else
    self:CollapseButtonBar()
  end
  self.MyListView:SetVisibility(UIConst.VisibilityOp.Visible)
  GuildController:SendGuildGetJoinRequests()
  self.CheckBtnIndex = self:ShowGamepadShortcutBtn({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    },
    Desc = GText("UI_Tips_Ensure")
  })
  self.PlayerInfoBtnIndex = self:ShowGamepadShortcutBtn({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.SpecialLeft
      }
    },
    Desc = GText("UI_Controller_CheckPlayer")
  })
  self:ShowPlayerInfoBtn(false)
  self:ShowCheckBtn(false)
  self:RefreshSizeBoxBottomByGuildTitle()
  self:RefreshApprovalCheckBoxesFromGuild()
  self:SetFocus()
end

function M:InitGamepadView()
  self.Owner.Spacer_VBNode_Botton:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitKeyboardView()
  self.Owner.Spacer_VBNode_Botton:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:_OnJoinRequestsDataChanged()
  self:_FetchApplyListDisplayThenRefresh()
end

function M:_OnJoinRequestsListMutated()
  self:_FetchApplyListDisplayThenRefresh()
end

function M:_FetchApplyListDisplayThenRefresh()
  local uids = self:_CollectRequestUids()
  self._MemberInfoByUid = self._MemberInfoByUid or {}
  if 0 == #uids then
    self._MemberInfoByUid = {}
    self:RefreshList(false)
    return
  end
  local keep = {}
  for _, u in ipairs(uids) do
    local k = tonumber(u) or u
    keep[k], keep[u] = true, true
  end
  for k in pairs(self._MemberInfoByUid) do
    if not keep[k] then
      self._MemberInfoByUid[k] = nil
    end
  end
  for _, uid in ipairs(uids) do
    local k = tonumber(uid) or uid
    if not self._MemberInfoByUid[k] then
      self._MemberInfoByUid[k] = {Uid = k}
    end
  end
  self:RefreshList(false)
  self:_RequestPersonalInfoForApplyApplicants()
end

function M:_MemberInfoNeedsNickname(info)
  if not info then
    return true
  end
  local n = info.Nickname
  return nil == n or "" == n
end

function M:_RequestPersonalInfoForApplyApplicants()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.GetOtherPlayerPersonallInfo then
    return
  end
  self._PersonalInfoQuerying = self._PersonalInfoQuerying or {}
  local dialog = self
  for _, uid in ipairs(self:_CollectRequestUids()) do
    local k = tonumber(uid) or uid
    local info = dialog._MemberInfoByUid[k]
    if dialog:_MemberInfoNeedsNickname(info) and not dialog._PersonalInfoQuerying[k] then
      dialog._PersonalInfoQuerying[k] = true
      Avatar:GetOtherPlayerPersonallInfo(k, {
        Func = function(PlayerInfo)
          if dialog._PersonalInfoQuerying then
            dialog._PersonalInfoQuerying[k] = nil
          end
          if not IsValid(dialog) or type(PlayerInfo) ~= "table" then
            return
          end
          local m = dialog._MemberInfoByUid[k] or {Uid = k}
          m.Uid = k
          m.Nickname = PlayerInfo.Nickname or m.Nickname
          m.Level = PlayerInfo.Level or m.Level
          m.HeadIconId = PlayerInfo.HeadIconId or m.HeadIconId
          m.HeadFrameId = PlayerInfo.HeadFrameId or m.HeadFrameId
          dialog._MemberInfoByUid[k] = m
          if tostring(uid) ~= tostring(k) then
            dialog._MemberInfoByUid[uid] = m
          end
          dialog:RefreshList(false)
        end
      })
    end
  end
end

function M:_MergeDisplayInfo(fromReq, fromCache)
  if not fromReq and not fromCache then
    return nil
  end
  local a = fromReq or {}
  local b = fromCache or {}
  local nick = a.Nickname and a.Nickname ~= "" and a.Nickname or b.Nickname
  local level = a.Level ~= nil and 0 ~= a.Level and a.Level or b.Level
  local head = nil ~= a.HeadIconId and 0 ~= a.HeadIconId and a.HeadIconId or b.HeadIconId
  local frame = nil ~= a.HeadFrameId and 0 ~= a.HeadFrameId and a.HeadFrameId or b.HeadFrameId
  return {
    Uid = a.Uid or b.Uid,
    Nickname = nick,
    Level = level,
    HeadIconId = head,
    HeadFrameId = frame,
    IsOnline = nil ~= a.IsOnline and a.IsOnline or b.IsOnline,
    LastLoginTime = a.LastLoginTime or b.LastLoginTime,
    LastLogoutTime = a.LastLogoutTime or b.LastLogoutTime
  }
end

function M:_MemberInfoFromJoinRequest(req, applicantUid)
  if not req then
    return nil
  end
  return {
    Uid = applicantUid or req.Uid,
    Nickname = req.Nickname,
    Level = req.Level,
    HeadIconId = req.HeadIconId,
    HeadFrameId = req.HeadFrameId,
    IsOnline = req.IsOnline,
    LastLoginTime = req.LastLoginTime,
    LastLogoutTime = req.LastLogoutTime
  }
end

function M:_CollectRequestUids()
  local uids = {}
  local tbl = GuildController:GetModel():GetReqLookTable()
  if not tbl or not tbl.OrderedReqList then
    return uids
  end
  for _, req in ipairs(tbl.OrderedReqList) do
    if req and req.Uid then
      table.insert(uids, req.Uid)
    end
  end
  return uids
end

function M:_GetAllRequestUids()
  return self:_CollectRequestUids()
end

function M:OnBtnYesOrNoRelease(bYes)
  local uids = self:_GetAllRequestUids()
  if 0 == #uids then
    return
  end
  if bYes then
    GuildController:SendGuildAgreeJoinRequest(uids)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("GuildAcceptAllApplication"))
  else
    GuildController:SendGuildRejectJoinRequest(uids)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("GuildRejectAllApplication"))
  end
end

function M:OnFilterChanged()
  if self.Owner and self.Owner.GetButtonBar then
    local bar = self.Owner:GetButtonBar()
    if bar and bar.WBP_Com_Sort and bar.WBP_Com_Sort.GetSortInfos then
      self.FuncIdx, self.SortType = bar.WBP_Com_Sort:GetSortInfos()
    end
  end
  self:RefreshList()
end

function M:OnRefreshListBegin()
  if not self.Switcher_Content or not self.Switcher_Content.SetActiveWidget then
    return
  end
  self.Switcher_Content:SetActiveWidget(1)
  if self.Owner and self.Owner.GetButtonBar then
    self.Owner:GetButtonBar():SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:GetListData()
  self.ListDatas = {}
  local tbl = GuildController:GetModel():GetReqLookTable()
  if not tbl or not tbl.OrderedReqList then
    return
  end
  for _, req in ipairs(tbl.OrderedReqList) do
    if req and req.Uid then
      local ApplicantUid = tonumber(req.Uid) or req.Uid
      table.insert(self.ListDatas, ApplicantUid)
    end
  end
  local sortType = self.SortType
  if sortType ~= CommonConst.ASC and sortType ~= CommonConst.DESC then
    sortType = CommonConst.DESC
  end
  table.sort(self.ListDatas, function(Uid1, Uid2)
    local r1 = tbl:GetReqByUid(Uid1)
    local r2 = tbl:GetReqByUid(Uid2)
    local t1 = r1 and r1.ApplyTime or 0
    local t2 = r2 and r2.ApplyTime or 0
    if t1 == t2 then
      return false
    end
    if sortType == CommonConst.DESC then
      return t1 > t2
    end
    return t1 < t2
  end)
end

function M:SetupListContent(Uid, Content)
  local tbl = GuildController:GetModel():GetReqLookTable()
  if not Uid or not tbl then
    return
  end
  local ApplicantUid = tonumber(Uid) or Uid
  Content.ApplicantUid = ApplicantUid
  local req = tbl:GetReqByUid(ApplicantUid)
  if not req and ApplicantUid ~= Uid then
    req = tbl:GetReqByUid(Uid)
  end
  Content.Data = req
  local base = self:_MemberInfoFromJoinRequest(req, ApplicantUid)
  local cached = not self._MemberInfoByUid or self._MemberInfoByUid[ApplicantUid] or self._MemberInfoByUid[Uid]
  Content.MemberInfo = self:_MergeDisplayInfo(base, cached)
  Content.Owner = self.Owner
  Content.Parent = self
end

function M:OnListEmpty()
  if self.Switcher_Content and self.Switcher_Content.SetActiveWidgetIndex then
    self.Switcher_Content:SetActiveWidgetIndex(1)
  end
  self:CollapseButtonBar()
end

function M:CollapseButtonBar()
  local ButtonBar = self.Owner and self.Owner.GetButtonBar and self.Owner:GetButtonBar()
  if ButtonBar then
    ButtonBar:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnRefreshListEnd()
  self:_SetupTitleNum()
  self:_SetupBottom()
  self:RefreshNavigationRule()
  self:ShowPlayerInfoBtn(0 ~= #(self.ListDatas or {}))
  if self.ListDatas and 0 == #self.ListDatas then
    if self.GameInputModeSubsystem then
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    end
  elseif self.GameInputModeSubsystem then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
  if self.MyListView then
    self.MyListView:SetFocus()
  end
end

function M:_SetupBottom()
  if not self.Switcher_Content or not self.Switcher_Content.SetActiveWidgetIndex then
    return
  end
  if not self.ListDatas or 0 == #self.ListDatas then
    return
  end
  self.Switcher_Content:SetActiveWidgetIndex(1)
  if self.Owner and self.Owner.GetButtonBar then
    self.Owner:GetButtonBar():SetVisibility(UIConst.VisibilityOp.Visible)
  end
  self.Switcher_Content:SetActiveWidgetIndex(0)
end

function M:_SetupTitleNum()
  local title = self.Owner and self.Owner.GetTitle and self.Owner:GetTitle()
  if not title or not title.GetTitleSubWidget then
    return
  end
  local w = title:GetTitleSubWidget(0)
  if w and w.SetTextNum then
    w:SetTextNum(#(self.ListDatas or {}), nil)
  end
end

function M:RefreshNavigationRule()
  if not self.MyListView or not self.MyListView.GetDisplayedEntryWidgets then
    return
  end
  if not self.GameInputModeSubsystem then
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if PlayerController and UGameInputModeSubsystem and UGameInputModeSubsystem.GetGameInputModeSubsystem then
      self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    end
  end
  self.MyListView:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.MyListView:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  if not self.ListDatas or 0 == #self.ListDatas then
    if self:HasAnyFocus() and self.GameInputModeSubsystem then
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
      self:SetFocus()
    end
    self.IsMyListEmpty = true
    return
  end
  if self:HasAnyFocus() and self.GameInputModeSubsystem then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    self.MyListView:SetFocus()
  end
  self.IsMyListEmpty = false
end

function M:Close()
  AudioManager(self):SetEventSoundParam(self, "GuildRequestDialog", {ToEnd = 1})
  M.Super.Close(self)
end

function M:Destruct()
  if self.CheckBox_1.UnBindEventOnClicked then
    self.CheckBox_1:UnBindEventOnClicked({
      Inst = self,
      Func = self.OnGuildApprovalManualClicked
    })
    self.CheckBox_2:UnBindEventOnClicked({
      Inst = self,
      Func = self.OnGuildApprovalAutoClicked
    })
  end
  if self.Owner and self.Owner.GetButtonBar then
    local bar = self.Owner:GetButtonBar()
    if bar and bar.Btn_Yes and bar.Btn_Yes.UnBindEventOnClicked then
      bar.Btn_Yes:UnBindEventOnClicked(self, self.OnBtnYesOrNoRelease)
    end
    if bar and bar.Btn_Quit and bar.Btn_Quit.UnBindEventOnClicked then
      bar.Btn_Quit:UnBindEventOnClicked(self, self.OnBtnYesOrNoRelease)
    end
  end
  if not self.IsRejectAll then
    self:CollapseButtonBar()
  end
  GuildController:UnRegisterEvent(self)
  self:ClearListItems()
  self._PersonalInfoQuerying = nil
  self:RemoveInputMethodChangedListen()
  if self.GameInputModeSubsystem then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
  if self.ParentWidget then
    self.ParentWidget:FocusToMemberList(true)
  end
  M.Super.Destruct(self)
end

function M:BP_GetDesiredFocusTarget()
  return self.List
end

function M:ShowPlayerInfoBtn(bShow)
  if ModController and ModController:IsMobile() then
    return
  end
  if bShow then
    self:ShowGamepadShortcut(self.PlayerInfoBtnIndex)
  else
    self:HideGamepadShortcut(self.PlayerInfoBtnIndex)
  end
end

function M:ShowCheckBtn(bShow)
  if ModController and ModController:IsMobile() then
    return
  end
  if bShow then
    self:ShowGamepadShortcut(self.CheckBtnIndex)
  else
    self:HideGamepadShortcut(self.CheckBtnIndex)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local BtnBar = self.Owner:GetButtonBar()
    if "Gamepad_DPad_Left" == InKeyName then
      BtnBar.Btn_Quit:OnBtnClicked()
      self:ShowPlayerInfoBtn(false)
      IsHandled = true
    elseif "Gamepad_DPad_Right" == InKeyName then
      BtnBar.Btn_Yes:OnBtnClicked()
      self:ShowPlayerInfoBtn(false)
      IsHandled = true
    elseif "Gamepad_LeftThumbstick" == InKeyName then
      BtnBar.WBP_Com_Sort:SetFocus()
      self:EnterFocusMode()
      IsHandled = true
    elseif "Gamepad_RightThumbstick" == InKeyName then
      self.CheckBox_1:SetFocus()
      self.IsFocusedCheckBox1 = true
      self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self:EnterFocusMode()
      IsHandled = true
    elseif "Gamepad_FaceButton_Right" == InKeyName and self.IsFocusedCheckBox1 then
      self:SetFocus()
      self.IsFocusedCheckBox1 = false
      self.Key_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      IsHandled = true
    end
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:EnterFocusMode()
  if self.IsFocusMode then
    return
  end
  self.IsFocusMode = true
  self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local BtnBar = self.Owner:GetButtonBar()
  BtnBar.Btn_Quit:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  BtnBar.Btn_Yes:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  BtnBar.WBP_Com_Sort:SetControllerKeyHidden(true)
  self:ShowCheckBtn(true)
  self:ShowPlayerInfoBtn(false)
end

function M:LeaveFocusMode()
  if not self.IsFocusMode then
    return
  end
  self.IsFocusMode = false
  self.Key_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local BtnBar = self.Owner:GetButtonBar()
  BtnBar.Btn_Quit:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  BtnBar.Btn_Yes:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  BtnBar.WBP_Com_Sort:SetControllerKeyHidden(false)
  self:ShowCheckBtn(false)
  self:ShowPlayerInfoBtn(true)
end

return M
