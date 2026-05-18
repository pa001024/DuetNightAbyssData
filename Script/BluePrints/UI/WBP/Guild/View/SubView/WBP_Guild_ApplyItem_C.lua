require("UnLua")
local UIUtils = require("Utils.UIUtils")
local TimeUtils = require("Utils.TimeUtils")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local TeamController = require("BluePrints.UI.WBP.Team.TeamController")
local TeamModel = TeamController:GetModel()
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
  M.Super.Construct(self)
  self.Button_Yes:BindEventOnReleased(self, self.OnBtnYesOrNoRelease, true)
  self.Button_No:BindEventOnReleased(self, self.OnBtnYesOrNoRelease, false)
  self.Key_No:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.Key_Yes:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.Head_Friend:BindOnClickEvent(function()
    self.Head_Anchor:Open(true)
  end)
  self.Head_Anchor.OnGetUserMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
  self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  if UGameInputModeSubsystem and UGameInputModeSubsystem.GetGameInputModeSubsystem and PlayerController then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:OnAnchorGetUserMenuContent()
  local function InitShowRecordBtn(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_ShowRecord")
    
    function Content.Callback()
      if TeamModel:IsYourself(AvatarInfo.Uid) then
        PersonInfoController:OpenView()
      else
        TeamController:GetAvatar():CheckOtherPlayerPersonallInfo(AvatarInfo.Uid, nil, AvatarInfo)
      end
      self.Head_Anchor:Close()
      if self.Owner and self.Owner.OnCloseBtnClicked then
        self.Owner:OnCloseBtnClicked()
      end
    end
  end
  
  if not self._PersonData then
    return nil
  end
  return ChatController:OpenPlayerBtnList(self, self._PersonData, {InitShowRecordBtn})
end

function M:HeadMenuOpenChanged(bOpen)
  self.bMenuOpen = bOpen
  if bOpen then
    self.Parent:EnterFocusMode()
    self.Parent:HideAllGamepadShortcut()
    return
  else
    self.Parent:ShowAllGamepadShortcut()
    self.Parent:LeaveFocusMode()
    self:SetFocus()
  end
  self.Head_Friend:PlayNormal()
end

function M:ResetUI()
  self.HB_Loca:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.HB_Button_Request:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.HB_Button:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Head_Friend:SetHoldUp(false)
  self.Title:ClearChildren()
  self.Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnListItemObjectSet(Content)
  self:ResetUI()
  Content.UI = self
  self.Owner = Content.Owner
  self.Parent = Content.Parent
  self:SetRenderOpacity(1)
  self:OnListItemObjectSet_GuildRequest(Content)
  self.Text_Remark:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Split:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Split_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:_SetHeadFromMemberInfo(info)
  local h = info.HeadIconId or info.HeadId or 0
  local f = info.HeadFrameId or 0
  self.Head_Friend:SetHeadIconById(h)
  self.Head_Friend:SetHeadFrame(f)
  self.Head_Friend:SetHoldUp(true)
end

function M:OnListItemObjectSet_GuildRequest(Content)
  self.RequestData = Content.Data
  local uid = Content.ApplicantUid
  if nil == uid and self.RequestData then
    uid = self.RequestData.Uid
  end
  uid = tonumber(uid) or uid
  self._Uid = uid
  local m = Content.MemberInfo
  if m then
    self._PersonData = m
    self.Text_Name:SetText(m.Nickname or tostring(uid or ""))
    self.Nickname = m.Nickname
    if self.Num_Level then
      self.Num_Level:SetText(tostring(m.Level or 0))
    end
    self:_SetHeadFromMemberInfo(m)
    if self.Title and UIUtils.SetTitle then
      UIUtils.SetTitle(self.Title, m)
    end
  else
    self._PersonData = {
      Uid = uid,
      Nickname = tostring(uid or ""),
      Level = 0,
      HeadIconId = 0,
      HeadFrameId = 0
    }
    self.Text_Name:SetText(tostring(uid or ""))
    if self.Num_Level then
      self.Num_Level:SetText("0")
    end
  end
  if self.Text_Intro and self.RequestData and self.RequestData.ApplyTime then
    local t = self.RequestData.ApplyTime
    if t and t > 0 then
      local expireH = 24
      expireH = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.GuildListExpireH and tonumber(DataMgr.GlobalConstant.GuildListExpireH.ConstantValue) or expireH
      local remaining = t + expireH * 3600 - TimeUtils.NowTime()
      local coarse = UIUtils.FormatRemainDurationCoarseLoc(remaining)
      if "" == coarse then
        self.Text_Intro:SetText("")
      else
        self.Text_Intro:SetText(string.format(GText("UI_GuildApplyExpired"), coarse))
      end
    else
      self.Text_Intro:SetText("")
    end
  end
  if self.Icon_Message then
    self.Icon_Message:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.HB_Button_Request then
    self.HB_Button_Request:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:OnBtnYesOrNoRelease(bYes)
  if not self._Uid then
    return
  end
  if bYes then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("GuildAcceptApplication"), self.Nickname))
    GuildController:SendGuildAgreeJoinRequest({
      self._Uid
    })
  else
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("GuildRejectApplication"), self.Nickname))
    GuildController:SendGuildRejectJoinRequest({
      self._Uid
    })
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice ~= ECommonInputType.Gamepad then
    self:SelectMessage(false)
    return
  end
end

function M:Destruct()
  if self.Button_Yes and self.Button_Yes.UnBindEventOnReleased then
    self.Button_Yes:UnBindEventOnReleased(self, self.OnBtnYesOrNoRelease)
  end
  if self.Button_No and self.Button_No.UnBindEventOnReleased then
    self.Button_No:UnBindEventOnReleased(self, self.OnBtnYesOrNoRelease)
  end
  if self.Head_Anchor and self.Head_Anchor.OnGetUserMenuContentEvent then
    self.Head_Anchor.OnGetUserMenuContentEvent:Unbind()
  end
  self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  M.Super.Destruct(self)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return UIUtils.Handle
  end
  self:SelectMessage(true)
  self.Parent:LeaveFocusMode()
  return UIUtils.Handle
end

function M:OnFocusLost(InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  self:SelectMessage(false)
end

function M:SelectMessage(bSelect)
  local Visibility = bSelect and "SelfHitTestInvisible" or "Collapsed"
  self.No_GamePad:SetVisibility(UIConst.VisibilityOp[Visibility])
  self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp[Visibility])
  if bSelect then
    self:PlayAnimation(self.GamePad_Hover)
  else
    self:PlayAnimation(self.GamePad_Normal)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self.bMenuOpen then
    return UIUtils.Unhandled
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:OnBtnYesOrNoRelease(true)
    return UIUtils.Handled
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:OnBtnYesOrNoRelease(false)
    return UIUtils.Handled
  elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
    self.Head_Anchor:Open(true)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M
