require("UnLua")
local FriendCommon = require("BluePrints.UI.WBP.Friend.FriendCommon")
local TeamController = require("BluePrints.UI.WBP.Team.TeamController")
local TeamCommon = require("BluePrints.UI.WBP.Team.TeamCommon")
local M = Class({
  "BluePrints.UI.WBP.Friend.View.WBP_Friend_Item_C"
})

function M:Construct()
  M.Super.Construct(self)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self:GetOwningPlayer())
  self:AddInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  TeamController:RegisterEvent(self, function(Inst, EventId, ...)
    local TargetUid = (...)
    if type(TargetUid) == "table" then
      TargetUid = TargetUid.Uid
    end
    if not TargetUid then
      return
    end
    local MyUid = Inst.PersonData and Inst.PersonData.Uid
    if TargetUid ~= MyUid then
      return
    end
    if EventId == TeamCommon.EventId.TeamInvite or EventId == TeamCommon.EventId.TeamOnAddPlayer or EventId == TeamCommon.EventId.TeamOnDelPlayer or EventId == TeamCommon.EventId.TeamLeave then
      Inst:_SetupBtnInvite()
    end
  end)
end

function M:Destruct()
  TeamController:UnRegisterEvent(self)
  M.Super.Destruct(self)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamePad then
    self:FreshGamepadView()
  else
    self:FreshKeyBoardView()
  end
end

function M:FreshGamepadView()
  self.Head_Friend:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  if not self.bGamepadFirstInited then
    self:FirstInitGamePadView()
    self.bGamepadFirstInited = true
  end
  self:SetGamepadIconVisibility(self:HasAnyUserFocus() or self:HasFocusedDescendants())
end

function M:FreshKeyBoardView()
  self.Head_Friend:SetVisibility(UIConst.VisibilityOp.Visible)
  self:SetGamepadIconVisibility(false)
end

function M:FirstInitGamePadView()
  if self.Key_Function then
    self.Key_Function:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      }
    })
  end
end

function M:OnListItemObjectSet(Content)
  Content.Type = Content.Type or FriendCommon.FriendTabType.MyFriend
  M.Super.OnListItemObjectSet(self, Content)
  self:SetGamepadIconVisibility(false)
  self.bAvatarFocus = false
  self:_TrimForInviteBoard()
  if self.IsGamePad then
    self:FreshGamepadView()
  else
    self:FreshKeyBoardView()
  end
end

function M:OnItemSelectionChanged(IsSelected)
  M.Super.OnItemSelectionChanged(self, IsSelected)
  if self.IsGamePad and self.Owner and self.Owner.UpdateTeamBoardBottomKeyInfo then
    self.Owner:UpdateTeamBoardBottomKeyInfo(not (not IsSelected or self.bMenuOpen) and "InviteItem" or "Default")
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.bMenuOpen then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self.bAvatarFocus = false
    end
    return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
  end
  if self.bAvatarFocus then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      self.Head_Friend:BtnAreaOnClicked()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self.bAvatarFocus = false
      self.Head_Friend:PlayNormal()
      self.Head_Friend:SetVisibility(self.IsGamePad and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Visible)
      self:SetFocus()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:OnBtnInviteReleased()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:HeadMenuOpenChanged(bOpen)
  M.Super.HeadMenuOpenChanged(self, bOpen)
  if not bOpen then
    self.bAvatarFocus = false
    self.Head_Friend:SetVisibility(self.IsGamePad and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Visible)
  end
  if self.Owner and self.Owner.UpdateTeamBoardBottomKeyInfo then
    self.Owner:UpdateTeamBoardBottomKeyInfo(bOpen and "Menu" or "InviteItem")
  end
  if self.Owner and self.Owner.OnInvitePlayerMenuOpenChanged then
    self.Owner:OnInvitePlayerMenuOpenChanged(self, bOpen)
  end
end

function M:SetGamepadIconVisibility(bShow)
  M.Super.SetGamepadIconVisibility(self, bShow)
  if bShow and self.Type == FriendCommon.FriendTabType.MyFriend then
    if self.Key_Function then
      self.Key_Function:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if self.Function_GamePad then
      self.Function_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  end
end

function M:_TrimForInviteBoard()
  self.HB_Gift:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.Text_Remark then
    self.Text_Remark:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Function_GamePad then
    self.Function_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M
