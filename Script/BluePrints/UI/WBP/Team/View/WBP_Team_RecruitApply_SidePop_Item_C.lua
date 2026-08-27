require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local TeamHallCommon = require("BluePrints.UI.WBP.TeamHall.TeamHallCommon")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")

function M:Construct()
  self.Button_Yes.Button_Area.OnClicked:Add(self, self.SendTeamAgreeInvite)
  self.Button_No.Button_Area.OnClicked:Add(self, self.SendTeamRefuseInvite)
  self.HB_Button_Request:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Uid = nil
  self.Head_Friend:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Head_Friend:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Head_Friend:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Head_Friend:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    local Info = (...)
    if EventId == GuildCommon.EventID.OnGetGuildInfo then
      self.GuildInfo = Info
      self.Head_Friend:HeadIconSetupAnchor(self.Head_Anchor, self.OtherPlayerInfo, self.GuildInfo, true, true)
    end
  end)
  self.Key_Yes:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.Key_No:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
end

function M:SetGoGamepadIconVisible(bVisible)
  if bVisible and UIUtils.IsGamepadInput() then
    self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
    self.No_GamePad:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.No_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:Destruct()
  GuildController:UnRegisterEvent(self)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDeviceType = CurInputDevice
  self.IsGamepadInput = self.CurInputDeviceType == ECommonInputType.Gamepad
  if self.IsGamepadInput then
    self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.No_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Yes_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.No_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SelectItem()
  self.Head_Friend:SetFocus(true)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self:PlayAnimation(self.Hover)
  self:SetGoGamepadIconVisible(true)
  self.ParentWidget.SelectApply = self.Uid
  self.ParentWidget.State = 1
  return UIUtils.Handled
end

function M:OnFocusLost(InFocusEvent)
  self:PlayAnimation(self.Unhover)
  self:SetGoGamepadIconVisible(false)
  return UIUtils.Handled
end

function M:HandleItem(IsArgee)
  if IsArgee then
    self:SendTeamAgreeInvite()
  else
    self:SendTeamRefuseInvite()
  end
end

function M:OnMouseButtonDown(MyGeometry, InKeyEvent)
  return UE4.UWidgetBlueprintLibrary.CaptureMouse(UE4.UWidgetBlueprintLibrary.Handled(), self)
end

function M:OnMouseButtonUp(MyGeometry, InKeyEvent)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  local bIsGamepad = GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad
  if 1 == self.ParentWidget.State and bIsGamepad then
    self:SendTeamAgreeInvite()
  end
  return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(UE4.UWidgetBlueprintLibrary.Handled(), self)
end

function M:SendTeamAgreeInvite()
  local function CallBack(ret)
    DebugPrint("SendTeamAgreeInvite:" .. ret)
    
    if not ret then
      return
    end
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("ApplyTeamApplication"))
  end
  
  GWorld:GetAvatar():ApprovalTeamRequest(CallBack, self.Uid, true)
end

function M:SendTeamRefuseInvite()
  local function CallBack(ret)
    DebugPrint("SendTeamAgreeInvite:" .. ret)
    
    if not ret then
      return
    end
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("RejectTeamApplication"))
  end
  
  GWorld:GetAvatar():ApprovalTeamRequest(CallBack, self.Uid, false)
end

function M:OnListItemObjectSet(Content)
  self.ParentWidget = Content.ParentWidget
  self.Head_Anchor.OnMenuOpenChanged:Add(self, self.FriendHeadMenuOpenChanged)
  self.Uid = Content.Uid
  if self.Text_Name and Content.Nickname then
    self.Text_Name:SetText(Content.Nickname)
  end
  if self.Num_Level and Content.Level then
    self.Num_Level:SetText(tostring(Content.Level))
  end
  if self.Head_Friend then
    self.Head_Friend:SetHeadIconById(Content.HeadIconId)
    self.Head_Friend:SetHeadFrame(Content.HeadFrameId)
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(TeamHallCommon.ReddotName.TeamRequest)
  if CacheDetail and CacheDetail[Content.Uid] then
    self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  
  local function SetInfo(OtherPlayerInfo)
    if self.Head_Friend then
      self.OtherPlayerInfo = OtherPlayerInfo
      if 0 ~= OtherPlayerInfo.GuildId then
        GuildController:SendGetGuildInfo(OtherPlayerInfo.GuildId)
      else
        self.Head_Friend:HeadIconSetupAnchor(self.Head_Anchor, self.OtherPlayerInfo, nil, true, true)
      end
    end
  end
  
  GWorld:GetAvatar():GetOtherAvatarInfo(SetInfo, self.Uid)
end

function M:FriendHeadMenuOpenChanged(bIsOpen)
  self.HeadOpen = bIsOpen
  self.ParentWidget:OnGamePadFaceButtonBottom(bIsOpen)
end

function M:OnAnchorGetUserMenuContent()
end

return M
