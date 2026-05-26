require("UnLua")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local M = Class({})

local function FillSelfRankWidgetFallback(SelfWidget, RankInfo)
  if not SelfWidget or not RankInfo then
    return
  end
  if SelfWidget.WS_Type and SelfWidget.Normal_Type then
    SelfWidget.WS_Type:SetActiveWidget(SelfWidget.Normal_Type)
  end
  if SelfWidget.Text_Ranking then
    if RankInfo.RankNum and RankInfo.RankNum > 0 then
      SelfWidget.Text_Ranking:SetText(RankInfo.RankNum)
    else
      SelfWidget.Text_Ranking:SetText(GText("RaidDungeon_Rank_Empty"))
    end
  end
  if SelfWidget.Text_Level then
    SelfWidget.Text_Level:SetText(tostring(RankInfo.Level or ""))
  end
  if SelfWidget.Text_Name then
    SelfWidget.Text_Name:SetText(GText(RankInfo.Nickname or ""))
  end
  if SelfWidget.Text_Score then
    SelfWidget.Text_Score:SetText(RankInfo.Score or 0)
  end
  if SelfWidget.Head_Player then
    if RankInfo.HeadIconId then
      SelfWidget.Head_Player:SetHeadIconById(RankInfo.HeadIconId)
    end
    if RankInfo.HeadFrameId then
      SelfWidget.Head_Player:SetHeadFrame(RankInfo.HeadFrameId)
    end
  end
  local IsNilFrame = RankInfo.TitleBefore == nil and nil == RankInfo.TitleAfter
  local IsEmptyFrame = RankInfo.TitleBefore and RankInfo.TitleBefore < 0 and RankInfo.TitleAfter and RankInfo.TitleAfter < 0
  if SelfWidget.WS_Title then
    if IsNilFrame or IsEmptyFrame then
      SelfWidget.WS_Title:SetActiveWidgetIndex(1)
    else
      SelfWidget.WS_Title:SetActiveWidgetIndex(0)
    end
  end
  if not IsNilFrame and not IsEmptyFrame and SelfWidget.Overlay_Title then
    local TitleFrame = RankInfo.TitleFrame
    if not TitleFrame or TitleFrame < 0 then
      TitleFrame = 10001
    end
    SelfWidget.Overlay_Title:ClearChildren()
    local TitleFrameWidget = UIManager(SelfWidget):LoadTitleFrameWidget(TitleFrame)
    if TitleFrameWidget then
      SelfWidget.Overlay_Title:AddChildToOverlay(TitleFrameWidget)
      TitleFrameWidget:SetTitleContent(RankInfo.TitleBefore, RankInfo.TitleAfter)
    end
  end
end

local function NormalizeRankData(...)
  local ArgList = {
    ...
  }
  local SelfRankInfo = {}
  local TopNInfo = {}
  if type(ArgList[1]) == "table" and ArgList[1].TopNInfo then
    SelfRankInfo = ArgList[1].SelfRankInfo or {}
    TopNInfo = ArgList[1].TopNInfo or {}
  elseif type(ArgList[1]) == "table" and type(ArgList[2]) == "table" then
    SelfRankInfo = ArgList[1]
    TopNInfo = ArgList[2]
  elseif type(ArgList[1]) == "table" then
    TopNInfo = ArgList[1]
  end
  return SelfRankInfo, TopNInfo
end

function M:OnLoaded(...)
  self.SelfRankInfo, self.TopNInfo = NormalizeRankData(...)
  self.IsGamePad = false
  self:InitPreviewScene()
  self:InitRankInfoTopN(self.TopNInfo)
  self:InitRankInfoSelf(self.SelfRankInfo)
  self:InitView()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:Construct()
  self.Avatar = GWorld:GetAvatar()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(self.GameInputModeSubsystem) then
    local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
    self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(CurInputDevice, self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:Destruct()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local WasGamePad = self.IsGamePad
  self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
  if WasGamePad ~= self.IsGamePad then
    self:ClearRankItemVisualState()
  end
  if self:IsRankItemSelectable() and self.IsGamePad then
    if self.List_Ranking and not UIUtils.HasAnyFocus(self) then
      self.List_Ranking:SetFocus()
    end
    if self.List_Ranking and UIUtils.HasAnyFocus(self) then
      if self.LastClickedItem and self.LastClickedItem.RankInfo then
        self.List_Ranking:NavigateToIndex(self.LastClickedItem.RankInfo.RankNum - 1)
      elseif self.ValidItemNum and self.ValidItemNum > 0 then
        self.List_Ranking:NavigateToIndex(0)
      end
    end
  end
end

function M:IsRankItemSelectable()
  return self.IsGamePad == true
end

function M:ClearRankItemVisualState()
  if self.List_Ranking then
    local ItemWidgets = self.List_Ranking.GetDisplayedEntryWidgets and self.List_Ranking:GetDisplayedEntryWidgets() or nil
    if ItemWidgets then
      for _, ItemWidget in pairs(ItemWidgets) do
        if ItemWidget and ItemWidget ~= self.Ranking_Myself then
          if ItemWidget.Click then
            ItemWidget:StopAnimation(ItemWidget.Click)
          end
          if ItemWidget.Hover then
            ItemWidget:StopAnimation(ItemWidget.Hover)
          end
          if ItemWidget.UnHover then
            ItemWidget:StopAnimation(ItemWidget.UnHover)
          end
          if ItemWidget.Press then
            ItemWidget:StopAnimation(ItemWidget.Press)
          end
          if ItemWidget.Normal then
            ItemWidget:PlayAnimation(ItemWidget.Normal)
          end
        end
      end
    end
  end
  if self.Ranking_Myself then
    if self.Ranking_Myself.Click then
      self.Ranking_Myself:StopAnimation(self.Ranking_Myself.Click)
    end
    if self.Ranking_Myself.Hover then
      self.Ranking_Myself:StopAnimation(self.Ranking_Myself.Hover)
    end
    if self.Ranking_Myself.UnHover then
      self.Ranking_Myself:StopAnimation(self.Ranking_Myself.UnHover)
    end
    if self.Ranking_Myself.Press then
      self.Ranking_Myself:StopAnimation(self.Ranking_Myself.Press)
    end
    if self.Ranking_Myself.Normal then
      self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Normal)
    end
  end
  if not self.IsGamePad then
    self.LastClickedItem = nil
  end
end

function M:InitView()
  if self.Text_Title then
    self.Text_Title:SetText(GText("UI_AppearanceScore_ScoreRank"))
  end
  if self.Text_Ranking then
    self.Text_Ranking:SetText(GText("UI_AppearanceScore_Rank"))
  end
  if self.Text_Name then
    self.Text_Name:SetText(GText("UI_AppearanceScore_Nickname"))
  end
  if self.Text_Score then
    self.Text_Score:SetText(GText("UI_AppearanceScore_Score"))
  end
  if self.Text_Rule then
    self.Text_Rule:SetText(GText("UI_AppearanceScore_Rule"))
  end
  if self.Text_Tip then
    self.Text_Tip:SetText(GText("UI_AppearanceScore_Rule"))
  end
  self:InitCommonTab()
end

function M:InitPreviewScene()
  if not self.Avatar then
    return
  end
  local CharModel = self.Avatar.Chars and self.Avatar.Chars[self.Avatar.CurrentChar]
  if not CharModel then
    return
  end
  self.ActorController = ActorController:New({
    ViewUI = self,
    IsPreviewMode = true,
    Char = CharModel,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
  })
  self.ActorController:OnOpened()
  local WeaponModel = self.Avatar.Weapons and self.Avatar.Weapons[self.Avatar.MeleeWeapon]
  if WeaponModel then
    self.ActorController:ChangeWeaponModel(WeaponModel)
    local Tag = WeaponModel:IsMelee() and "Melee" or "Ranged"
    self.ActorController:SetMontageAndCamera("Weapon", Tag)
  end
end

function M:InitRankInfoTopN(TopNInfo)
  if not TopNInfo or not next(TopNInfo) then
    if self.WS_Type then
      if self.Com_Empty then
        self.WS_Type:SetActiveWidget(self.Com_Empty)
      else
        self.WS_Type:SetActiveWidgetIndex(1)
      end
    end
    if self.Text_Empty then
      self.Text_Empty:SetText(GText("RaidDungeon_Rank_Empty"))
    end
    if self.List_Ranking then
      self.List_Ranking:ClearListItems()
    end
    return
  end
  if self.WS_Type and self.List_Ranking then
    self.WS_Type:SetActiveWidget(self.List_Ranking)
  end
  self.List_Ranking:ClearListItems()
  local RankCount = 0
  for _, RankInfo in pairs(TopNInfo) do
    RankCount = RankCount + 1
    local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
    ItemObj.RankInfo = RankInfo
    ItemObj.RankInfo.RankNum = RankCount
    ItemObj.ParentWidget = self
    ItemObj.SelfAvatar = self.Avatar
    self.List_Ranking:AddItem(ItemObj)
    if self.Avatar and RankInfo.Uid == self.Avatar.Uid then
      self.SelfRankInfo.Rank = RankCount
    end
  end
  self.ValidItemNum = RankCount
  self.List_Ranking:NavigateToIndex(0)
  self.List_Ranking:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.List_Ranking.BP_OnItemClicked:Clear()
  self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
  self.List_Ranking.BP_OnItemClicked:Add(self, self.OnListRankItemClicked)
  self.List_Ranking.BP_OnItemIsHoveredChanged:Add(self, self.OnListRankItemIsHoveredChanged)
end

function M:InitRankInfoSelf(SelfRankInfo)
  if not self.Ranking_Myself then
    return
  end
  local RankInfo = SelfRankInfo or {}
  if self.Avatar then
    RankInfo.RankNum = RankInfo.Rank and RankInfo.Rank > 0 and RankInfo.Rank or -1
    RankInfo.HeadIconId = RankInfo.HeadIconId or self.Avatar.HeadIconId
    RankInfo.HeadFrameId = RankInfo.HeadFrameId or self.Avatar.HeadFrameId
    RankInfo.Level = RankInfo.Level or self.Avatar.Level
    RankInfo.Nickname = RankInfo.Nickname or self.Avatar.Nickname
    RankInfo.TitleBefore = RankInfo.TitleBefore or self.Avatar.TitleBefore
    RankInfo.TitleAfter = RankInfo.TitleAfter or self.Avatar.TitleAfter
    RankInfo.TitleFrame = RankInfo.TitleFrame or self.Avatar.TitleFrame
  end
  RankInfo.Score = RankInfo.Score or 0
  self.SelfItemData = {RankInfo = RankInfo, ParentWidget = self}
  if type(self.Ranking_Myself.OnListItemObjectSet) == "function" then
    self.Ranking_Myself:OnListItemObjectSet(self.SelfItemData)
  else
    FillSelfRankWidgetFallback(self.Ranking_Myself, RankInfo)
  end
  self.Ranking_Myself:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if self.Ranking_Myself.Button_Myself then
    self.Ranking_Myself.Button_Myself:SetIsEnabled(true)
    self.Ranking_Myself.Button_Myself.OnPressed:Add(self, self.OnMyselfButtonPressed)
    self.Ranking_Myself.Button_Myself.OnClicked:Add(self, self.OnMyselfButtonClicked)
    self.Ranking_Myself.Button_Myself.OnHovered:Add(self, self.OnMyselfButtonHovered)
  end
end

function M:OnMyselfButtonClicked()
  if not self:IsRankItemSelectable() then
    return
  end
  if self.Ranking_Myself and not self.IsGamePad then
    self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Click)
  end
  if not self.SelfItemData or not self.SelfItemData.RankInfo then
    return
  end
  local SelfRankNum = self.SelfItemData.RankInfo.RankNum
  if SelfRankNum and SelfRankNum >= 1 then
    if self.LastClickedItem and self.LastClickedItem.RankInfo.RankNum ~= SelfRankNum then
      local LastItemWidget = self.LastClickedItem and self.LastClickedItem.SelfWidget or nil
      if LastItemWidget then
        LastItemWidget:PlayAnimation(LastItemWidget.Normal)
      end
      self.LastClickedItem = nil
    end
    self.List_Ranking:NavigateToIndex(SelfRankNum - 1)
  end
end

function M:OnMyselfButtonPressed()
  if not self:IsRankItemSelectable() then
    return
  end
  if self.Ranking_Myself then
    self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Press)
  end
end

function M:OnMyselfButtonHovered()
  if not self:IsRankItemSelectable() then
    return
  end
  if self.Ranking_Myself then
    self.Ranking_Myself:StopAnimation(self.Ranking_Myself.UnHover)
    self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Hover)
  end
end

function M:OnListRankItemIsHoveredChanged(Item, IsHovered)
  if self.IsGamePad or Item.IsSelected or Item.Empty then
    return
  end
  local ItemWidget = Item.SelfWidget
  if ItemWidget then
    if ItemWidget.Hover then
      ItemWidget:StopAnimation(ItemWidget.Hover)
    end
    if ItemWidget.UnHover then
      ItemWidget:StopAnimation(ItemWidget.UnHover)
    end
    if ItemWidget.Normal then
      ItemWidget:PlayAnimation(ItemWidget.Normal)
    end
  end
end

function M:OnListRankItemClicked(Item)
  if not self:IsRankItemSelectable() then
    return
  end
  if Item.Empty or self.LastClickedItem == Item then
    return
  end
  local ItemWidget = Item.SelfWidget
  if not ItemWidget then
    return
  end
  ItemWidget:StopAnimation(ItemWidget.Normal)
  ItemWidget:PlayAnimation(ItemWidget.Click)
  if self.LastClickedItem then
    local LastItemWidget = self.LastClickedItem.SelfWidget
    if LastItemWidget then
      LastItemWidget:StopAnimation(LastItemWidget.Click)
      LastItemWidget:PlayAnimation(LastItemWidget.Normal)
    end
  end
  self.LastClickedItem = Item
end

return M
