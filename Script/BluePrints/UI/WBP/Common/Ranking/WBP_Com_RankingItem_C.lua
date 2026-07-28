require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local PageJumpUtils = require("Utils.PageJumpUtils")
local BottomKeyState = ComRankingUtils.BottomKeyState
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local FriendModel = FriendController:GetModel()

function M:Construct()
  self.RankIconTextures = {}
  for _, Path in ipairs(ComRankingUtils.RankIconPath) do
    table.insert(self.RankIconTextures, LoadObject(Path))
  end
  self.RankPatternTextures = {}
  for _, Path in ipairs(ComRankingUtils.RankPatternPath) do
    table.insert(self.RankPatternTextures, LoadObject(Path))
  end
  self.Head_Player:BindOnClickEvent(function()
    self.Head_Anchor:Open(true)
    self:OnButtonClicked()
  end)
  self.Head_Anchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
  self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
  self.Btn_Aera.OnClicked:Add(self, self.OnButtonClicked)
  self.Btn_Aera.OnHovered:Add(self, self.OnButonHovered)
  self.Btn_Aera.OnUnhovered:Add(self, self.OnButonUnhovered)
  self.Btn_Aera.OnPressed:Add(self, self.OnButonPressed)
  self:SetNavigationRuleBase(UE4.EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Right, EUINavigationRule.Stop)
end

function M:Destruct()
  self.Head_Anchor.OnGetMenuContentEvent:Unbind()
  self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
  self.Btn_Aera.OnClicked:Clear()
  self.Btn_Aera.OnHovered:Clear()
  self.Btn_Aera.OnUnhovered:Clear()
  self.Btn_Aera.OnPressed:Clear()
end

function M:BP_OnEntryReleased()
  if self.Head_Anchor and self.Head_Anchor:IsOpen() then
    self.Head_Anchor:Close()
  end
  if self.Content then
    self.Content.SelfWidget = nil
  end
  self:StopAllAnimations()
end

function M:OnListItemObjectSet(Content)
  Content.SelfWidget = self
  self.Content = Content
  self.bHeadMenuOpen = false
  self.RankInfo = Content.RankInfo
  self.SelfAvatar = Content.SelfAvatar
  self.ParentWidget = self.Content.ParentWidget
  self.CallbackObj = Content.CallbackObj
  self.ClickCallback = Content.ClickCallback
  self.MenuOpenCallback = Content.OnHeadMenuOpenChanged
  self:InitContents()
  self:InitAnimation()
  self:InitNavigation()
end

function M:InitContents()
  if self.Content.Empty then
    self.WS_Type:SetActiveWidget(self.Empty_Type)
    return
  end
  if 0 == self.Content.ItemType then
    self:InitType01Content()
  else
    self:InitType02Content()
  end
  self.WS_Type:SetActiveWidget(self.Normal_Type)
end

function M:InitAnimation()
  local LastClickedItem = self.ParentWidget and self.ParentWidget.LastClickedItem
  if LastClickedItem == self.Content then
    self:PlaySelectedAnimation()
  else
    self:PlayNormalAnimation()
  end
end

function M:InitType01Content()
  self:InitPlayerRank()
  self:InitPlayerInfo()
  self:InitType01Column03()
  self:InitType01Column04()
end

function M:InitType02Content()
  self:InitPlayerRank()
  self:InitPlayerInfo()
  self:InitType02Column03()
  self:InitType02Column04()
end

function M:InitPlayerRank()
  if not self.RankInfo then
    return
  end
  local RankNumText = self.RankInfo.RankNumText
  if RankNumText then
    self.Text_Ranking:SetText(GText(RankNumText))
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
    local IconTexture = self.RankIconTextures[RankNum] or LoadObject(ComRankingUtils.RankIconPath[RankNum])
    self.Image_RankIcon:SetBrushFromTexture(IconTexture)
    local PatternTexture = self.RankPatternTextures[RankNum] or LoadObject(ComRankingUtils.RankPatternPath[RankNum])
    self.Image_RankPattern:SetBrushFromTexture(PatternTexture)
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
  local HeadIconId = self.RankInfo.HeadIconId or 10001
  self.Head_Player:SetHeadIconById(HeadIconId)
  if self.RankInfo.HeadFrameId then
    self.Head_Player:SetHeadFrame(self.RankInfo.HeadFrameId)
  end
  self.Text_Level:SetText(tostring(self.RankInfo.Level))
  self.Text_Name:SetText(GText(self.RankInfo.Nickname or ""))
  local IsNilFrame = self.RankInfo.TitleBefore == nil and nil == self.RankInfo.TitleAfter
  local IsEmptyFrame = self.RankInfo.TitleBefore and self.RankInfo.TitleBefore < 0 and self.RankInfo.TitleAfter and self.RankInfo.TitleAfter < 0
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

function M:InitType01Column03()
  local Colum03Text = self.Content and self.Content.Colum03Text
  if nil == Colum03Text or "" == Colum03Text then
    self.Text_Score:SetText("--")
    return
  end
  if type(Colum03Text) == "number" then
    self.Text_Score:SetText(tostring(Colum03Text))
    return
  end
  local DisplayText = GText(Colum03Text)
  if nil == DisplayText or "" == DisplayText then
    DisplayText = tostring(Colum03Text)
  elseif type(DisplayText) == "number" then
    DisplayText = tostring(DisplayText)
  end
  self.Text_Score:SetText(DisplayText)
end

function M:InitType01Column04()
  local RoleInfo = self.Content.RoleInfo
  local PetInfo = self.Content.PetInfo
  if not RoleInfo or not PetInfo then
    return
  end
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
      CharSlotWidget.Panel_Level:SetVisibility(UIConst.VisibilityOp.Visible)
    else
      CharSlotWidget.Switch_Type:SetActiveWidget(CharSlotWidget.Empty)
      CharSlotWidget.Panel_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:InitType02Column03()
  local Colum03Text = self.Content and self.Content.Colum03Text
  if nil == Colum03Text or "" == Colum03Text then
    self.Text_Trial:SetText("--")
    return
  end
  if type(Colum03Text) == "number" then
    self.Text_Trial:SetText(tostring(Colum03Text))
    return
  end
  self.Text_Trial:SetText(tostring(Colum03Text))
end

function M:InitType02Column04()
  local Colum04Text = self.Content and self.Content.Colum04Text
  if nil == Colum04Text or "" == Colum04Text then
    self.Text_Blood:SetText("--")
    return
  end
  if type(Colum04Text) == "number" then
    self.Text_Blood:SetText(tostring(Colum04Text))
    return
  end
  self.Text_Blood:SetText(tostring(Colum04Text))
end

function M:OnAnchorGetUserMenuContent()
  if not self.RankInfo then
    return {}
  end
  
  local function AddFriend(Content, AvatarInfo)
    if not FriendModel:GetFriendDict()[AvatarInfo.Uid] then
      Content.Text = GText("UI_Friend_AddFriend")
      
      function Content.Callback()
        if self.Head_Anchor then
          self.Head_Anchor:Close()
        end
        FriendController:OpenAddFriendDialog(self, AvatarInfo)
      end
    end
  end
  
  local function InitShowRecordBtn(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_ShowRecord")
    
    function Content.Callback()
      if self.Head_Anchor then
        self.Head_Anchor:Close()
      end
      PageJumpUtils:CloseFrontDialog()
      if AvatarInfo.Uid == self.SelfAvatar.Uid then
        PersonInfoController:OpenView()
      else
        GWorld:GetAvatar():CheckOtherPlayerPersonallInfo(AvatarInfo.Uid, nil, AvatarInfo)
      end
    end
  end
  
  local Switch = {AddFriend, InitShowRecordBtn}
  if self.RankInfo.Uid == self.SelfAvatar.Uid or FriendModel:GetFriendDict()[self.RankInfo.Uid] then
    Switch = {InitShowRecordBtn}
  end
  self.HeadMenuWidget = ChatController:OpenPlayerBtnList(self, self.RankInfo, Switch)
  return self.HeadMenuWidget
end

function M:InitNavigation()
  self:SetNavigationRuleBase(UE4.EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Right, EUINavigationRule.Stop)
  self:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    self.HandleNavigationUp
  })
  self:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    self.HandleNavigationDown
  })
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

function M:HeadMenuOpenChanged(bOpen)
  self.bHeadMenuOpen = true == bOpen
  if self.CallbackObj and self.MenuOpenCallback then
    self.MenuOpenCallback(self.CallbackObj, bOpen)
  end
  if false == bOpen then
    self.HeadMenuWidget = nil
    self:SetFocus()
  end
end

function M:OpenHeadMenu()
  if not self.RankInfo or self.Content and self.Content.Empty then
    return false
  end
  if not self.Head_Anchor then
    return false
  end
  self.Head_Anchor:Open(true)
  if not self:IsStopProcessEvent() then
    self:OnButtonClicked()
  end
  return true
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.bHeadMenuOpen then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.Head_Anchor then
      self.Head_Anchor:Close()
      self:SetFocus()
      return UE4.UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == UIConst.GamePadKey.SpecialLeft or "Gamepad_Special_Left" == InKeyName then
      if self.HeadMenuWidget and self.HeadMenuWidget.DoBlockAction then
        self.HeadMenuWidget:DoBlockAction()
        return UE4.UWidgetBlueprintLibrary.Handled()
      end
    elseif (InKeyName == UIConst.GamePadKey.SpecialRight or "Gamepad_Special_Right" == InKeyName) and self.HeadMenuWidget and self.HeadMenuWidget.DoReportAction then
      self.HeadMenuWidget:DoReportAction()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if (InKeyName == UIConst.GamePadKey.RightThumb or "Gamepad_RightThumbstick" == InKeyName) and self.ParentWidget and self.ParentWidget.OnGamepadHeaderQaPressed and self.ParentWidget:OnGamepadHeaderQaPressed() then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self:OpenHeadMenu() then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:PlayNormalAnimation()
  self.StopProcess = false
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:PlaySelectedAnimation()
  self.StopProcess = true
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:PlayClickedAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:IsStopProcessEvent()
  return self.StopProcess
end

function M:OnButtonClicked()
  if self:IsStopProcessEvent() then
    return
  end
  if self.ParentWidget and self.ParentWidget.bAutoSelectingRankEntry then
    return
  end
  if self.CallbackObj and self.ClickCallback and type(self.ClickCallback) == "function" then
    self.ClickCallback(self.CallbackObj, self.Content)
  end
end

function M:OnButonHovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnButonUnhovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnButonPressed()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

return M
