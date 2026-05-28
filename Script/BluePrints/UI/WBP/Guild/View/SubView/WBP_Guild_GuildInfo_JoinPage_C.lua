require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Destruct()
  self.Head_Anchor_President.OnMenuOpenChanged:Remove(self, self.PresidentHeadMenuOpenChanged)
  self.Head_Anchor_Vice.OnMenuOpenChanged:Remove(self, self.ViceHeadMenuOpenChanged)
  GuildController:UnRegisterEvent(self)
end

function M:Construct()
  self.Btn_Report:BindEventOnClicked(self, self.Report)
  self.Btn_Copy.OnClicked:Add(self, self.Copy)
  self.Btn_Territory:SetGamePadImg("Y")
  self.Btn_Territory:SetText(GText("UI_VisitGuild"))
  self.Btn_Territory:ForbidBtn(true)
  self.Btn_Territory:BindForbidStateExecuteEvent(self, self.Territory)
  self.Btn_Apply:SetText(GText("UI_ApplyToJoinGuild"))
  self.Btn_Apply:BindEventOnClicked(self, self.ApplyJoinGuild)
  self.Text_President:SetText(GText("GuildMaster"))
  self.Text_Vice:SetText(GText("ViceGuildMaster"))
  self:PlayAnimation(self.In)
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    local Info = (...)
    if EventId == GuildCommon.EventID.OnGetGuildInfo and self.GuildData and self.GuildData.GuildId == Info.GuildId then
      self:OnGetGuildFullInfo(Info)
    end
  end)
  self.Controller_Report:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "Menu",
        ClickCallback = self.ReportLongClick,
        Owner = self
      }
    },
    bLongPress = true
  })
  self.Controller_Head:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RS"}
    },
    bLongPress = false
  })
  self.Controller_Copy:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    },
    bLongPress = false
  })
  self.Controller_Copy:SetVisibility(UIConst.VisibilityOp.Visable)
  self.Head_President:SetNavigationRuleExplicit(EUINavigation.Right, self.Head_Vice)
  self.Head_Vice:SetNavigationRuleExplicit(EUINavigation.Left, self.Head_President)
  self.Head_President:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Head_President:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Head_President:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Head_Vice:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Head_Vice:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Head_Vice:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self:RefreshDeviceUI()
end

function M:SetData(GuildData, NotFullInfo, MainView)
  self.MainView = MainView
  if not GuildData then
    self.WS_Tyype:SetActiveWidgetIndex(1)
    self.Text_Empty:SetText(GText("UI_NoGuildSelected"))
    self.GuildData = nil
    return
  end
  self.WS_Tyype:SetActiveWidgetIndex(0)
  self.GuildData = GuildData
  if not NotFullInfo then
    GuildController:SendGetGuildInfo(GuildData.GuildId)
  end
  self:PlayAnimation(self.Refresh)
  self.Logo:Init(GuildData.LogoInfo)
  self.Text_Name:SetText(GText(GuildData.Name))
  self.Text_Lv:SetText(GText("UI_LEVEL_NAME"))
  self.Text_Level:SetText(GText(tostring(GuildData.Level)))
  self.Text_IDDesc:SetText(GText("UI_GuildID"))
  self.Text_ID:SetText(GText(tostring(GuildData.GuildId)))
  self.Text_NumDesc:SetText(GText("UI_GuildMemberCount"))
  self.Text_NowNum:SetText(GText(tostring(GuildData.MemberCount)))
  local GuildLevelConfig = DataMgr.GuildLevel[GuildData.Level]
  self.Text_TotalNum:SetText(GText(tostring(GuildLevelConfig.GuildMembersNum)))
  self.Text_ActivityDesc:SetText(GText("UI_GuildActivity"))
  self.Text_Activity:SetText(GText(tostring(GuildData.ActivityLevel)))
  local SelfGuildId = GuildController:GetAvatar().GuildId
  self.IsSelfGuild = GuildData.GuildId == SelfGuildId
  if self.IsSelfGuild then
    self.Btn_Territory:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Apply:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Btn_Territory:SetVisibility(UIConst.VisibilityOp.Visable)
    if SelfGuildId and 0 ~= SelfGuildId then
      self.Btn_Apply:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Btn_Apply:SetVisibility(UIConst.VisibilityOp.Visable)
    end
  end
end

function M:OnGetGuildFullInfo(Info)
  self.GuildFullInfo = Info
  self.Text_Intro:SetText(GText(Info.Declaration))
  local President, VicePresident
  for _, Member in pairs(Info.Members) do
    if 5 == Member.Title then
      President = Member
    elseif 4 == Member.Title then
      VicePresident = Member
    end
  end
  self:SetPresidentInfo(President.Uid, self.Head_President, self.Text_President, self.Num_Level_President, self.BindPresident)
  self.Head_President.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  if VicePresident then
    self:SetPresidentInfo(VicePresident.Uid, self.Head_Vice, self.Text_Vice, self.Num_Level_Vice, self.BindVice)
    self.Head_Vice.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self.Panel_Level_1:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Head_President:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Escape)
  else
    self.Head_Vice.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self.Head_Vice:SetHeadFrame(nil)
    self.Panel_Level_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Head_Vice:CleanUpAnchor()
    self.Head_President:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  end
end

function M:BindPresident(PlayerInfo)
  self.Head_President:HeadIconSetupAnchor(self.Head_Anchor_President, PlayerInfo, self.GuildFullInfo)
  self.Head_Anchor_President.OnMenuOpenChanged:Add(self, self.PresidentHeadMenuOpenChanged)
end

function M:PresidentHeadMenuOpenChanged(bIsOpen)
  self.Head_President:SetFocus()
  if self.MainView == "GuildMain" then
    if bIsOpen then
      self.ParentWidget:SetGuildJoinGamePadIconVisible(false)
    else
      self.ParentWidget:SetGuildJoinGamePadIconVisible(false, false, true)
    end
  end
end

function M:BindVice(PlayerInfo)
  self.Head_Vice:HeadIconSetupAnchor(self.Head_Anchor_Vice, PlayerInfo, self.GuildFullInfo)
  self.Head_Anchor_Vice.OnMenuOpenChanged:Add(self, self.ViceHeadMenuOpenChanged)
end

function M:ViceHeadMenuOpenChanged(bIsOpen)
  self.Head_Vice:SetFocus()
  if self.MainView == "GuildMain" then
    if bIsOpen then
      self.ParentWidget:SetGuildJoinGamePadIconVisible(false)
    else
      self.ParentWidget:SetGuildJoinGamePadIconVisible(false, false, true)
    end
  end
end

function M:SetPresidentInfo(OtherUid, HeadIcon, TextName, TextNumLevel, BindFunc)
  local function SetInfo(OtherPlayerInfo)
    if not IsValid(self) then
      return
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if self.MainView == "GuildMain" then
      local GuildMain = UIManager:GetUIObj("GuildMain")
      if not GuildMain then
        return
      end
    elseif self.MainView == "CheckGuildPage" then
      local GuildMain = UIManager:GetUIObj("CheckGuildPage")
      if not GuildMain then
        return
      end
    end
    TextNumLevel:SetText(GText(tostring(OtherPlayerInfo.Level)))
    local HeadFrameConfig = DataMgr.HeadFrame[OtherPlayerInfo.HeadFrameId]
    local FrameIcon = HeadFrameConfig and HeadFrameConfig.FrameID or nil
    HeadIcon:SetHeadFrame(FrameIcon)
    local HeadSculptureConfig = DataMgr.HeadSculpture[OtherPlayerInfo.HeadIconId]
    HeadIcon:SetHeadIconById(HeadSculptureConfig.HeadId)
    local Avatar = GWorld:GetAvatar()
    Avatar:QueryGuildChatOpen(function(Ret, IsOpen)
      if Ret ~= ErrorCode.RET_SUCCESS then
        return
      end
      self.GuildFullInfo.CardGuildChatOpen = IsOpen
    end, OtherPlayerInfo.Uid or OtherPlayerInfo.Uuid)
    BindFunc(self, OtherPlayerInfo)
  end
  
  local FriendData = FriendController:GetModel():GetFriendDict()[OtherUid]
  if FriendData then
    SetInfo(FriendData.Info)
  else
    GWorld:GetAvatar():GetOtherPlayerPersonallInfo(OtherUid, {Func = SetInfo})
  end
end

function M:Report()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowCommonPopupUI(100090, {
    GuildName = self.GuildFullInfo.Name,
    GuildId = self.GuildFullInfo.GuildId,
    IsGuildReport = true,
    bShouldPlayAnim = false,
    bHideDialogItem = true,
    DialogItemIndex = 3
  })
end

function M:Copy()
  UE.UUIFunctionLibrary.ClipboardCopy(self.Text_ID:GetText())
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildIDCopied"))
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:Territory()
  UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_FunctionNotAvailable"))
end

function M:ApplyJoinGuild()
  if not GWorld:GetAvatar():CheckUIUnlocked("OpenGuild") then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_Locked_Des_Guild"))
    return
  end
  GuildController:SendRequestJoinGuild(self.GuildData.GuildId, 2)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/confirm_click", nil, nil)
end

function M:RefreshDeviceUI()
  if UIUtils.IsGamepadInput() and not self.IsHideAllGamePadIcon then
    self.Controller_Report:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Controller_Head:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WS_Controller_Copy:SetActiveWidgetIndex(1)
  else
    self.Controller_Report:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Controller_Head:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Controller_Copy:SetActiveWidgetIndex(0)
  end
end

function M:ReportLongClick()
  self.Controller_Report:OnShortCutReleased()
  self:Report()
  self.ReportLongClickState = true
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self.ReportLongClickState = false
    self.Controller_Report:OnShortCutPressed()
    IsHandled = false
  elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
    self:Copy()
    IsHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self.ParentWidget.IsSelfGuild then
    else
      self:Territory()
      IsHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if self.ParentWidget.IsSelfGuild then
    else
      self:ApplyJoinGuild()
      IsHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self.Head_President:SetFocus()
    if self.MainView == "GuildMain" then
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
              ImgShortPath = "A",
              Owner = self
            }
          },
          Desc = GText("玩家选项")
        },
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
      self.ParentWidget:UpdateComTab(BottomKeyInfo)
      self.ParentWidget:SetGuildJoinGamePadIconVisible(false, nil, true)
      IsHandled = true
    elseif self.MainView == "CheckGuildPage" then
      self:HideAllGamePadIcon()
      IsHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight and (self.Head_President:HasAnyUserFocus() or self.Head_Vice:HasAnyUserFocus()) then
    if self.MainView == "GuildMain" then
      self.ParentWidget.GuildJoin:SetListFocus()
      self.ParentWidget:UpdateComTab()
      self.ParentWidget:SetGuildJoinGamePadIconVisible(true)
      IsHandled = true
    elseif self.MainView == "CheckGuildPage" then
      self:ShowAllGamePadIcon()
      self.ParentWidget:SetFocus()
      IsHandled = true
    end
  end
  return IsHandled
end

function M:OnContentKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self.Controller_Report:OnShortCutReleased()
    IsHandled = self.ReportLongClickState
  end
  return IsHandled
end

function M:HideAllGamePadIcon()
  self.IsHideAllGamePadIcon = true
  self.Btn_Territory:SetGamepadIconVisibility(false)
  self.Btn_Apply:SetGamepadIconVisibility(false)
  self:RefreshDeviceUI()
end

function M:ShowAllGamePadIcon()
  self.IsHideAllGamePadIcon = false
  self.Btn_Territory:SetGamepadIconVisibility(true)
  self.Btn_Apply:SetGamepadIconVisibility(true)
  self:RefreshDeviceUI()
end

function M:JoinSuccessful()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if self.GuildData.AutoAgreeJoinRequest then
    UIManager:ShowUITip(UIConst.Tip_CommonToast, string.format(GText("GuildSuccessJoin"), self.GuildFullInfo.Name))
  else
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_ApplicationAlreadySent"))
  end
end

return M
