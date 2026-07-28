require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local GuildBaseInfo = require("BluePrints.UI.WBP.Guild.Common.GuildBaseInfo")
local FriendModel = FriendController:GetModel()
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local RankIconPath = {
  "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/GuildWar/T_Activity_GuildWar_PatternRanking_1.T_Activity_GuildWar_PatternRanking_1'",
  "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/GuildWar/T_Activity_GuildWar_PatternRanking_2.T_Activity_GuildWar_PatternRanking_2'",
  "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/GuildWar/T_Activity_GuildWar_PatternRanking_3.T_Activity_GuildWar_PatternRanking_3'"
}
local RankPatternPath = {
  "Texture2D'/Game/UI/Texture/Static/Image/Activity/GuildWar/T_Activity_GuideWar_PatternRanking_L_1.T_Activity_GuideWar_PatternRanking_L_1'",
  "Texture2D'/Game/UI/Texture/Static/Image/Activity/GuildWar/T_Activity_GuideWar_PatternRanking_L_2.T_Activity_GuideWar_PatternRanking_L_2'",
  "Texture2D'/Game/UI/Texture/Static/Image/Activity/GuildWar/T_Activity_GuideWar_PatternRanking_L_3.T_Activity_GuideWar_PatternRanking_L_3'"
}

local function CanOpenGuildMenuDirectly(RankInfo)
  if type(RankInfo) ~= "table" then
    return true
  end
  local GuildSimpleInfo = "table" == type(RankInfo.GuildSimpleInfo) and RankInfo.GuildSimpleInfo or nil
  if GuildSimpleInfo then
    return true
  end
  if RankInfo.GuildName ~= nil and RankInfo.GuildName ~= "" then
    return true
  end
  if nil ~= RankInfo.GuildLogoInfo or nil ~= RankInfo.GuildLogo then
    return true
  end
  local GuildId = tonumber(RankInfo.GuildId or RankInfo.GuildID or 0) or 0
  return GuildId <= 0
end

function M:Construct()
  self.RankIconTexture = {}
  for _, Path in ipairs(RankIconPath) do
    local Texture = LoadObject(Path)
    table.insert(self.RankIconTexture, Texture)
  end
  self.RankPatternTexture = {}
  for _, Path in ipairs(RankPatternPath) do
    local Texture = LoadObject(Path)
    table.insert(self.RankPatternTexture, Texture)
  end
  if self.Head_Player and self.Head_Player.BindOnClickEvent then
    self.Head_Player:BindOnClickEvent(function()
      self:OpenHeadAnchorMenu()
      if self.ParentWidget then
        self.ParentWidget:OnListRankItemClicked(self.Content)
      end
    end)
  end
  if self.Head_Anchor then
    self.Head_Anchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
    self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
  end
  self:SetNavigationRuleBase(UE4.EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Right, EUINavigationRule.Stop)
end

function M:Destruct()
  if self.Head_Anchor then
    self.Head_Anchor.OnGetMenuContentEvent:Unbind()
    self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
  end
end

function M:OnListItemObjectSet(Content)
  Content.SelfWidget = self
  self.Content = Content
  self.RankInfo = Content.RankInfo
  self.SelfAvatar = Content.SelfAvatar
  self.ParentWidget = Content.ParentWidget
  if not Content.Empty then
    if self.WS_Type and self.Normal_Type then
      self.WS_Type:SetActiveWidget(self.Normal_Type)
    end
    self:InitPlayerRank()
    self:InitPlayerInfo()
    self:InitPlayerPoint()
    Content.IsSelected = self.ParentWidget and self.ParentWidget.LastClickedItem == Content or false
    if Content.IsSelected then
      self:PlayAnimation(self.Click)
    else
      self:PlayAnimation(self.Normal)
    end
  elseif self.WS_Type and self.Empty_Type then
    self.WS_Type:SetActiveWidget(self.Empty_Type)
  end
  self:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    self.HandleNavigationUp
  })
  self:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    self.HandleNavigationDown
  })
end

function M:BP_OnEntryReleased()
  if self.Head_Anchor and self.Head_Anchor:IsOpen() then
    self.Head_Anchor:Close()
  end
  if self.Content then
    self.Content.SelfWidget = nil
  end
  self:PlayAnimation(self.Normal)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.ParentWidget and self.ParentWidget.IsGamePad then
    self.ParentWidget:OnListRankItemClicked(self.Content, true)
  end
  return UIUtils.Handled
end

function M:HandleNavigationUp()
  if not (self.RankInfo and self.RankInfo.RankNum and self.ParentWidget) or not self.ParentWidget.List_Ranking then
    return nil
  end
  local CurIndex = self.RankInfo.RankNum - 1
  if CurIndex > 0 then
    self.ParentWidget.List_Ranking:NavigateToIndex(CurIndex - 1)
    return UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.ParentWidget.List_Ranking, CurIndex - 1)
  end
  return self
end

function M:HandleNavigationDown()
  if not (self.RankInfo and self.RankInfo.RankNum and self.ParentWidget) or not self.ParentWidget.List_Ranking then
    return nil
  end
  local CurIndex = self.RankInfo.RankNum - 1
  local MaxIndex = self.ParentWidget.ValidItemNum - 1
  if CurIndex < MaxIndex then
    self.ParentWidget.List_Ranking:NavigateToIndex(CurIndex + 1)
    return UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.ParentWidget.List_Ranking, CurIndex + 1)
  end
  return self
end

function M:InitPlayerRank()
  local BanState = self.RankInfo and self.RankInfo.BanState
  if BanState and 0 ~= BanState then
    if self.Text_Ranking then
      self.Text_Ranking:SetText(GText("RaidDungeon_Rank_Ban"))
    end
    if self.Image_RankIcon then
      self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Image_RankPattern then
      self.Image_RankPattern:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    return
  end
  local RankNum = self.RankInfo and self.RankInfo.RankNum
  if not RankNum then
    return
  end
  if RankNum >= 1 and RankNum <= 3 then
    if self.Image_RankIcon then
      self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Visible)
      self.Image_RankIcon:SetBrushFromTexture(self.RankIconTexture[RankNum])
    end
    if self.Image_RankPattern then
      self.Image_RankPattern:SetVisibility(UIConst.VisibilityOp.Visible)
      self.Image_RankPattern:SetBrushFromTexture(self.RankPatternTexture[RankNum])
    end
  else
    if self.Image_RankIcon then
      self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Image_RankPattern then
      self.Image_RankPattern:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  if self.Text_Ranking then
    if RankNum > 0 then
      self.Text_Ranking:SetText(RankNum)
    else
      self.Text_Ranking:SetText(GText("RaidDungeon_Rank_Empty"))
    end
  end
end

function M:InitPlayerInfo()
  if not self.RankInfo then
    return
  end
  if self.Head_Player then
    if self.RankInfo.HeadIconId then
      self.Head_Player:SetHeadIconById(self.RankInfo.HeadIconId)
    end
    if self.RankInfo.HeadFrameId then
      self.Head_Player:SetHeadFrame(self.RankInfo.HeadFrameId)
    end
  end
  if self.Text_Level then
    self.Text_Level:SetText(tostring(self.RankInfo.Level or ""))
  end
  if self.Text_Name then
    self.Text_Name:SetText(GText(self.RankInfo.Nickname or ""))
  end
  local IsNilFrame = self.RankInfo.TitleBefore == nil and nil == self.RankInfo.TitleAfter
  local IsEmptyFrame = self.RankInfo.TitleBefore and self.RankInfo.TitleBefore < 0 and self.RankInfo.TitleAfter and self.RankInfo.TitleAfter < 0
  if IsNilFrame or IsEmptyFrame then
    if self.WS_Title then
      self.WS_Title:SetActiveWidgetIndex(1)
    end
    return
  end
  if self.WS_Title then
    self.WS_Title:SetActiveWidgetIndex(0)
  end
  if self.Overlay_Title then
    local TitleFrame = self.RankInfo.TitleFrame
    if not TitleFrame or TitleFrame < 0 then
      TitleFrame = 10001
    end
    self.Overlay_Title:ClearChildren()
    local TitleFrameWidget = UIManager(self):LoadTitleFrameWidget(TitleFrame)
    if TitleFrameWidget then
      self.Overlay_Title:AddChildToOverlay(TitleFrameWidget)
      TitleFrameWidget:SetTitleContent(self.RankInfo.TitleBefore, self.RankInfo.TitleAfter)
    end
  end
end

function M:InitPlayerPoint()
  if self.Text_Score then
    self.Text_Score:SetText(self.RankInfo and self.RankInfo.Score or "--")
  end
end

function M:TryPrepareGuildSimpleInfoBeforeOpen(OpenCallback)
  if type(OpenCallback) ~= "function" then
    return
  end
  if not self.RankInfo or CanOpenGuildMenuDirectly(self.RankInfo) then
    OpenCallback()
    return
  end
  local Avatar = GWorld and GWorld:GetAvatar() or nil
  local GuildId = tonumber(self.RankInfo.GuildId or self.RankInfo.GuildID or 0) or 0
  if not Avatar or GuildId <= 0 then
    OpenCallback()
    return
  end
  local QueryToken = (self._GuildSimpleInfoQueryToken or 0) + 1
  self._GuildSimpleInfoQueryToken = QueryToken
  self._PendingOpenHeadAnchor = true
  Avatar:GetGuildSimpleInfo(function(Ret, ServerGuildSimpleInfo)
    if not IsValid(self) or self._GuildSimpleInfoQueryToken ~= QueryToken then
      return
    end
    self._PendingOpenHeadAnchor = false
    if ErrorCode:Check(Ret) then
      local GuildSimpleInfo = GuildBaseInfo.New(ServerGuildSimpleInfo)
      if GuildSimpleInfo then
        self.RankInfo.GuildSimpleInfo = GuildSimpleInfo
        self.RankInfo.GuildName = GuildSimpleInfo.Name or self.RankInfo.GuildName
        self.RankInfo.GuildLogoInfo = GuildSimpleInfo.LogoInfo or self.RankInfo.GuildLogoInfo
        self.RankInfo.GuildLogo = GuildSimpleInfo.LogoInfo or self.RankInfo.GuildLogo
        self.RankInfo.GuildId = tonumber(GuildSimpleInfo.GuildId or GuildId) or GuildId
      end
    end
    OpenCallback()
  end, GuildId)
end

function M:OpenHeadAnchorMenu()
  if not self.Head_Anchor or self._PendingOpenHeadAnchor then
    return
  end
  self:TryPrepareGuildSimpleInfoBeforeOpen(function()
    if not IsValid(self) or not self.Head_Anchor then
      return
    end
    self.Head_Anchor:Open(true)
  end)
end

function M:OnAnchorGetUserMenuContent()
  if not self.RankInfo then
    return {}
  end
  
  local function AddFriend(Content, AvatarInfo)
    if not FriendModel:GetFriendDict()[AvatarInfo.Uid] then
      Content.Text = GText("UI_Friend_AddFriend")
      
      function Content.Callback()
        FriendController:OpenAddFriendDialog(self, AvatarInfo)
        if self.Head_Anchor then
          self.Head_Anchor:Close()
        end
      end
    end
  end
  
  local function InitShowRecordBtn(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_ShowRecord")
    
    function Content.Callback()
      if AvatarInfo.Uid == self.SelfAvatar.Uid then
        PersonInfoController:OpenView()
      else
        GWorld:GetAvatar():CheckOtherPlayerPersonallInfo(AvatarInfo.Uid, nil, AvatarInfo)
      end
      if self.Head_Anchor then
        self.Head_Anchor:Close()
      end
    end
  end
  
  local Switch = {AddFriend, InitShowRecordBtn}
  if self.RankInfo.Uid == self.SelfAvatar.Uid or FriendModel:GetFriendDict()[self.RankInfo.Uid] then
    Switch = {InitShowRecordBtn}
  end
  return ChatController:OpenPlayerBtnList(self, self.RankInfo, Switch)
end

function M:HeadMenuOpenChanged(bOpen)
  if self.ParentWidget and self.ParentWidget.UpdateTapBottomKeyInfo then
    self.ParentWidget:UpdateTapBottomKeyInfo(bOpen)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Bottom" == InKeyName then
      if self.Head_Anchor and not self._PendingOpenHeadAnchor then
        self:OpenHeadAnchorMenu()
        IsEventHandled = true
      end
    elseif "Gamepad_FaceButton_Right" == InKeyName and self.Head_Anchor and self.Head_Anchor:IsOpen() then
      self.Head_Anchor:Close()
      self:SetFocus()
      IsEventHandled = true
    end
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  end
  return UWidgetBlueprintLibrary.UnHandled()
end

return M
