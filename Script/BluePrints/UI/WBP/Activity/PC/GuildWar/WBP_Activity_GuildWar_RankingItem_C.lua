require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendModel = FriendController:GetModel()
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
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

function M:Construct()
  self.RankIconTexture = {}
  for Index, Path in ipairs(RankIconPath) do
    local Texture = LoadObject(RankIconPath[Index])
    table.insert(self.RankIconTexture, Texture)
  end
  self.RankPatternTexture = {}
  for Index, Path in ipairs(RankPatternPath) do
    local Texture = LoadObject(RankPatternPath[Index])
    table.insert(self.RankPatternTexture, Texture)
  end
  self.Head_Player:BindOnClickEvent(function()
    self.Head_Anchor:Open(true)
    if self.ParentWidget then
      self.ParentWidget:OnListRankItemClicked(self.Content)
    end
  end)
  self.Head_Anchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
  self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
  self:SetNavigationRuleBase(UE4.EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Right, EUINavigationRule.Stop)
end

function M:Destruct()
  self.Head_Anchor.OnGetMenuContentEvent:Unbind()
  self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
end

function M:OnListItemObjectSet(Content)
  Content.SelfWidget = self
  self.Content = Content
  self.RankInfo = Content.RankInfo
  self.SelfAvatar = Content.SelfAvatar
  self.ParentWidget = self.Content.ParentWidget
  if not Content.Empty then
    self.WS_Type:SetActiveWidget(self.Normal_Type)
    self:InitPlayerRank()
    self:InitPlayerInfo()
    self:InitPlayerPoint()
    self:InitPlayerSquad()
    if self.ParentWidget.LastClickedItem == Content then
      self:PlayAnimation(self.Click)
    else
      self:PlayAnimation(self.Normal)
    end
  else
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
  self.Content.SelfWidget = nil
  self:PlayAnimation(self.Normal)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.ParentWidget then
    self.ParentWidget:OnListRankItemClicked(self.Content)
  end
end

function M:HandleNavigationUp()
  if not self.RankInfo or not self.RankInfo.RankNum then
    return
  end
  local CurIndex = self.RankInfo.RankNum - 1
  local MinIndex = 0
  if CurIndex > MinIndex then
    self.ParentWidget.List_Ranking:NavigateToIndex(CurIndex - 1)
  end
end

function M:HandleNavigationDown()
  if not self.RankInfo or not self.RankInfo.RankNum then
    return
  end
  local CurIndex = self.RankInfo.RankNum - 1
  local MaxIndex = self.ParentWidget.ValidItemNum - 1
  if CurIndex < MaxIndex then
    self.ParentWidget.List_Ranking:NavigateToIndex(CurIndex + 1)
  end
end

function M:InitPlayerRank()
  local BanState = self.RankInfo.BanState
  if BanState and 1 == BanState then
    self.Text_Ranking:SetText(GText("RaidDungeon_Rank_Ban"))
    self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Image_RankPattern:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local RankNum = self.RankInfo.RankNum
  if not RankNum then
    return
  end
  if RankNum >= 1 and RankNum <= 3 then
    self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Image_RankPattern:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Image_RankIcon:SetBrushFromTexture(self.RankIconTexture[RankNum])
    self.Image_RankPattern:SetBrushFromTexture(self.RankPatternTexture[RankNum])
  else
    self.Image_RankIcon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Image_RankPattern:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if RankNum > 0 then
    self.Text_Ranking:SetText(RankNum)
  else
    self.Text_Ranking:SetText(GText("RaidDungeon_Rank_Empty"))
  end
end

function M:InitPlayerInfo()
  if not self.RankInfo then
    return
  end
  if self.RankInfo.HeadIconId then
    self.Head_Player:SetHeadIconById(self.RankInfo.HeadIconId)
  end
  if self.RankInfo.HeadFrameId then
    self.Head_Player:SetHeadFrame(self.RankInfo.HeadFrameId)
  end
  self.Text_Level:SetText(tostring(self.RankInfo.Level))
  self.Text_Name:SetText(GText(self.RankInfo.Nickname or ""))
  local IsNilFrame = self.RankInfo.TitleBefore == nil and nil == self.RankInfo.TitleAfter
  local IsEmptyFrame = self.RankInfo.TitleBefore < 0 and self.RankInfo.TitleAfter < 0
  if IsNilFrame or IsEmptyFrame then
    self.WS_Title:SetActiveWidgetIndex(1)
    return
  end
  self.WS_Title:SetActiveWidgetIndex(0)
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

function M:InitPlayerPoint()
  local Score = self.RankInfo.Score
  if Score then
    self.Text_Score:SetText(Score)
  else
    self.Text_Score:SetText("--")
  end
end

function M:InitPlayerSquad()
  local RoleInfo = self.Content.RoleInfo
  local PetInfo = self.Content.PetInfo
  for Index = 1, 4 do
    local CharSlotWidget = self["Slot_0" .. Index]
    local Info, IconPath
    if Index <= 3 then
      Info = RoleInfo and RoleInfo[Index]
      local Char = Info and DataMgr.Char[Info.id]
      IconPath = Char and Char.Icon
    else
      Info = PetInfo
      local Pet = Info and DataMgr.Pet[Info.id]
      IconPath = Pet and Pet.GachaIcon
    end
    if Info and IconPath then
      local ImageIcon = LoadObject(IconPath)
      local ImgMaterial = CharSlotWidget.Img_Avatar:GetDynamicMaterial()
      if ImageIcon and ImgMaterial then
        ImgMaterial:SetTextureParameterValue("IconMap", ImageIcon)
      end
      CharSlotWidget.Text_Level:SetText(Info.level)
      CharSlotWidget.Switch_Type:SetActiveWidget(CharSlotWidget.Img_Avatar)
    else
      CharSlotWidget.Switch_Type:SetActiveWidget(CharSlotWidget.Empty)
      CharSlotWidget.Panel_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:OnAnchorGetUserMenuContent()
  local function AddFriend(Content, AvatarInfo)
    if not FriendModel:GetFriendDict()[AvatarInfo.Uid] then
      Content.Text = GText("UI_Friend_AddFriend")
      
      function Content.Callback()
        FriendController:OpenAddFriendDialog(self, AvatarInfo)
        self.Head_Anchor:Close()
      end
    end
  end
  
  local function InitShowRecordBtn(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_ShowRecord")
    
    function Content.Callback()
      if AvatarInfo.Uid == self.SelfAvatar.Uid then
        PersonInfoController:OpenView()
      else
        GWorld:GetAvatar():CheckOtherPlayerPersonallInfo(AvatarInfo.Uid)
      end
      self.Head_Anchor:Close()
    end
  end
  
  local Switch = {AddFriend, InitShowRecordBtn}
  if self.RankInfo.Uid == self.SelfAvatar.Uid or FriendModel:GetFriendDict()[self.RankInfo.Uid] then
    Switch = {InitShowRecordBtn}
  end
  return ChatController:OpenPlayerBtnList(self, self.RankInfo, Switch)
end

function M:HeadMenuOpenChanged(bOpen)
  self.ParentWidget:UpdateTapBottomKeyInfo(bOpen)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Bottom" == InKeyName then
      self.Head_Anchor:Open(true)
      IsEventHandled = true
    elseif "Gamepad_FaceButton_Right" == InKeyName and self.Head_Anchor:IsOpen() then
      self.Head_Anchor:Close()
      self:SetFocus()
      IsEventHandled = true
    end
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  else
    return UWidgetBlueprintLibrary.UnHandled()
  end
end

return M
