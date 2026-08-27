require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")

local function GetKeyName(InKeyEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  return UE4.UFormulaFunctionLibrary.Key_GetFName(Key), Key
end

local function IsLeftMouseButtonEvent(MouseEvent)
  return MouseEvent and UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent) == UE4.EKeys.LeftMouseButton
end

local function InitInlineGamepadKey(Widget, KeyPath)
  if not Widget then
    return
  end
  if Widget.CreateGamepadKey then
    Widget:CreateGamepadKey(KeyPath)
  elseif Widget.CreateCommonKey then
    Widget:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = KeyPath}
      }
    })
  end
  Widget:SetVisibility(ESlateVisibility.Collapsed)
end

local function SetInlineKeyVisible(Widget, bVisible)
  if Widget then
    Widget:SetVisibility(bVisible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
end

local function SetItemHover(ItemContent, bHover)
  local Widget = ItemContent and ItemContent.SelfWidget
  if not IsValid(Widget) or not Widget.Item then
    return
  end
  Widget.Item:StopAllAnimations()
  Widget.Item:PlayAnimation(bHover and Widget.Item.Hover or Widget.Item.Normal)
end

function M:Construct()
  self.bOuterMousePressed = false
  InitInlineGamepadKey(self.Key_ItemRewards, UIConst.GamePadImgKey.LeftThumb)
  InitInlineGamepadKey(self.Key_RewardDetails, UIConst.GamePadImgKey.FaceButtonTop)
  self.List_Item.BP_OnItemSelectionChanged:Remove(self, self.OnCollectItemSelectionChanged)
  self.List_Item.BP_OnItemSelectionChanged:Add(self, self.OnCollectItemSelectionChanged)
  self.List_Item.BP_OnItemClicked:Remove(self, self.OnCollectItemClicked)
  self.List_Item.BP_OnItemClicked:Add(self, self.OnCollectItemClicked)
  self.List_Item:SetControlScrollbarInside(true)
  self.List_Item:SetScrollbarVisibility(ESlateVisibility.Collapsed)
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
end

function M:Destruct()
  if IsValid(self.List_Item) then
    self.List_Item.BP_OnItemSelectionChanged:Remove(self, self.OnCollectItemSelectionChanged)
    self.List_Item.BP_OnItemClicked:Remove(self, self.OnCollectItemClicked)
  end
  self:ReleaseContent()
end

function M:ReleaseContent()
  self:ReleaseOuterMousePress(false)
  local Content = self.Content
  if Content and Content.Entry == self then
    Content.Entry = nil
  end
  if Content and Content.RewardContent and Content.RewardContent.SelfWidget == self.Item_Reward then
    Content.RewardContent.SelfWidget = nil
  end
  if IsValid(self.List_Item) then
    self.List_Item:ClearListItems()
  end
  self.Content = nil
  self.Owner = nil
  self.FocusedItemContent = nil
  self.LastTipsItemContent = nil
end

function M:BP_OnEntryReleased()
  self:ReleaseContent()
end

function M:OnListItemObjectSet(Content)
  if self.Content and self.Content ~= Content then
    self:ReleaseContent()
  end
  self.Content = Content
  self.Owner = Content.Owner
  Content.Entry = self
  local bIsEmpty = Content.Empty == true or not Content.ItemIds or #Content.ItemIds <= 0
  self.WS_Type:SetActiveWidgetIndex(bIsEmpty and 1 or 0)
  if bIsEmpty then
    return
  end
  self.List_Item:SetVisibility(ESlateVisibility.Visible)
  self:InitCollectItems(Content)
  self:InitRewardItem(Content)
  self:RefreshOwnerState()
end

function M:CreateCommonItemContent(ItemType, ItemId, Count)
  local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
  ItemContent.Id = ItemId
  ItemContent.ItemType = ItemType
  ItemContent.Icon = ItemUtils.GetItemIconPath(ItemId, ItemType)
  ItemContent.Rarity = ItemUtils.GetItemRarity(ItemId, ItemType)
  ItemContent.Count = Count
  ItemContent.ParentWidget = self
  ItemContent.IsShowDetails = true
  ItemContent.bDisableCommonClick = true
  ItemContent.bNoJumpPreview = true
  ItemContent.MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
  return ItemContent
end

function M:InitCollectItems(CategoryContent)
  self.List_Item:ClearListItems()
  CategoryContent.CollectItemContents = {}
  for Index, ItemId in ipairs(CategoryContent.ItemIds) do
    local bOwned = CategoryContent.ItemOwnedStates[Index] == true
    local ItemContent = self:CreateCommonItemContent(CategoryContent.ItemType, ItemId)
    ItemContent.Index = Index
    ItemContent.CategoryContent = CategoryContent
    ItemContent.bOwned = bOwned
    ItemContent.bShadow = not bOwned
    ItemContent.bHasGot2 = bOwned
    ItemContent.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnCollectItemMenuOpenChanged
    }
    ItemContent.OnAddedToFocusPathEvent = {
      Obj = self,
      Callback = self.OnCollectItemAddedToFocusPath,
      Params = ItemContent
    }
    table.insert(CategoryContent.CollectItemContents, ItemContent)
    self.List_Item:AddItem(ItemContent)
  end
end

function M:InitRewardItem(CategoryContent)
  local RewardContent = self:CreateCommonItemContent(CategoryContent.ItemType, CategoryContent.RewardId, CategoryContent.RewardCount)
  RewardContent.HandleMouseDown = true
  RewardContent.OnMouseButtonUpEvents = {
    Obj = self,
    Callback = self.ReleaseOuterMousePress,
    Params = {true}
  }
  RewardContent.CategoryContent = CategoryContent
  RewardContent.bHasGot = CategoryContent.bRewardClaimed
  RewardContent.OnMenuOpenChangedEvents = {
    Obj = self,
    Callback = self.OnRewardMenuOpenChanged
  }
  CategoryContent.RewardContent = RewardContent
  self.Item_Reward:Init(RewardContent)
end

function M:BP_OnItemSelectionChanged(bIsSelected)
  self.bOuterSelected = bIsSelected
  if bIsSelected and self.Owner and self.Content then
    self.Owner:OnCategoryEntryFocused(self.Content)
  end
  self:RefreshOwnerState()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.Owner and self.Owner:IsGamepadMode() and self.Content and not self.Owner:IsTipsState() then
    self.Owner:OnCategoryEntryFocused(self.Content)
  end
  return self.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

function M:OnFocusLost(InFocusEvent)
  self:RefreshOwnerState()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  if self.Owner and not self.Owner:IsGamepadMode() and self.Content then
    self.Owner:OnCategoryEntryFocused(self.Content)
    self.BG:OnCellHovered()
  end
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  if self.bOuterMousePressed and self.BG then
    self.BG:StopAnimation(self.BG.Press)
  end
  self.bOuterMousePressed = false
  if self.Owner and not self.Owner:IsGamepadMode() then
    self.BG:OnCellUnhovered()
  end
end

function M:OnPreviewMouseButtonDown(MyGeometry, MouseEvent)
  if not self.bOuterMousePressed and IsLeftMouseButtonEvent(MouseEvent) and self.Owner and self.Content and not self.Owner:IsGamepadMode() then
    self.bOuterMousePressed = true
    self.BG:OnCellPressed()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if IsLeftMouseButtonEvent(MouseEvent) then
    self:ReleaseOuterMousePress(true)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:ReleaseOuterMousePress(bRestoreHover)
  if not self.bOuterMousePressed then
    return
  end
  self.bOuterMousePressed = false
  if not self.BG then
    return
  end
  local bHovered = bRestoreHover and self:IsHovered()
  self.BG:StopAnimation(self.BG.Press)
  if not bHovered then
    self.BG:StopAnimation(self.BG.Hover)
  end
  self.BG:OnCellReleased()
  if bHovered then
    self.BG:OnCellHovered()
  end
end

function M:SetOuterSelectedStyle(bSelected)
  if not self.BG then
    return
  end
  if bSelected then
    if not self.BG.IsSelected then
      self.BG:StopAnimation(self.BG.Normal)
      self.BG:PlayAnimation(self.BG.Select)
      self.BG.IsSelected = true
    end
  elseif self.BG.IsSelected then
    self.BG:StopAnimation(self.BG.Select)
    self.BG:OnCellUnSelect()
    self.BG:PlayAnimation(self.BG.Normal)
    self.BG.IsSelected = false
  end
end

function M:RefreshOwnerState()
  if not self.Owner or not self.Content then
    SetInlineKeyVisible(self.Key_ItemRewards, false)
    SetInlineKeyVisible(self.Key_RewardDetails, false)
    return
  end
  local bGamepad = self.Owner:IsGamepadMode()
  if bGamepad then
    self:ReleaseOuterMousePress(false)
  end
  local bCurrent = self.Owner:IsCurrentCategory(self.Content)
  local bListState = self.Owner:IsListState()
  local bBrowseCurrent = bCurrent and (self.Owner:IsItemBrowseState() or self.Owner:IsItemTipsState())
  if not bGamepad or bBrowseCurrent then
    self.List_Item:SetVisibility(ESlateVisibility.Visible)
  else
    self.List_Item:SetVisibility(ESlateVisibility.HitTestInvisible)
  end
  self:SetOuterSelectedStyle(bGamepad and bCurrent and bListState)
  local bShowInlineKeys = bGamepad and bCurrent and bListState
  SetInlineKeyVisible(self.Key_ItemRewards, bShowInlineKeys)
  SetInlineKeyVisible(self.Key_RewardDetails, bShowInlineKeys)
end

function M:FocusCollectItem(ItemContent)
  ItemContent = ItemContent or self.Content and self.Content.CollectItemContents[1]
  if not ItemContent then
    return false
  end
  if self.FocusedItemContent and self.FocusedItemContent ~= ItemContent then
    SetItemHover(self.FocusedItemContent, false)
  end
  self.FocusedItemContent = ItemContent
  local Index = math.max(0, (ItemContent.Index or 1) - 1)
  self.List_Item:BP_SetSelectedItem(ItemContent)
  self.List_Item:NavigateToIndex(Index)
  self:AddTimer(0.01, function()
    if not (IsValid(self) and self.Owner) or not self.Owner:IsItemBrowseState() then
      return
    end
    local Widget = ItemContent.SelfWidget
    if IsValid(Widget) then
      SetItemHover(ItemContent, true)
      Widget:SetFocus()
    end
  end, false, 0, nil, true)
  return true
end

function M:EnterItemBrowse()
  self:RefreshOwnerState()
  self.FocusedItemContent = nil
  return self:FocusCollectItem(self.Content and self.Content.CollectItemContents[1])
end

function M:ExitItemBrowse()
  for _, ItemContent in ipairs(self.Content and self.Content.CollectItemContents or {}) do
    SetItemHover(ItemContent, false)
  end
  self.FocusedItemContent = nil
  self.LastTipsItemContent = nil
  self:RefreshOwnerState()
end

function M:RestoreItemBrowseFocus(ItemContent)
  self:RefreshOwnerState()
  return self:FocusCollectItem(ItemContent or self.LastTipsItemContent or self.FocusedItemContent)
end

function M:OnCollectItemSelectionChanged(ItemContent, bIsSelected)
  if not bIsSelected or not ItemContent then
    return
  end
  if self.FocusedItemContent and self.FocusedItemContent ~= ItemContent then
    SetItemHover(self.FocusedItemContent, false)
  end
  self.FocusedItemContent = ItemContent
  SetItemHover(ItemContent, true)
end

function M:OnCollectItemClicked(ItemContent)
  self:ReleaseOuterMousePress(true)
end

function M:OnCollectItemAddedToFocusPath(ItemContent)
  if not (ItemContent and self.Owner) or not self.Owner:IsItemBrowseState() then
    return
  end
  if self.FocusedItemContent and self.FocusedItemContent ~= ItemContent then
    SetItemHover(self.FocusedItemContent, false)
  end
  self.FocusedItemContent = ItemContent
  SetItemHover(ItemContent, true)
end

function M:OpenFocusedCollectItemTips()
  local ItemContent = not self.FocusedItemContent and self.Content and self.Content.CollectItemContents and self.Content.CollectItemContents[1]
  local Widget = ItemContent and ItemContent.SelfWidget
  if not IsValid(Widget) or not Widget.OpenItemMenu then
    return false
  end
  self.LastTipsItemContent = ItemContent
  Widget:OpenItemMenu()
  return true
end

function M:OpenRewardTips()
  local RewardContent = self.Content and self.Content.RewardContent
  local Widget = RewardContent and RewardContent.SelfWidget
  if not IsValid(Widget) or not Widget.OpenItemMenu then
    return false
  end
  Widget:OpenItemMenu()
  return true
end

function M:OnCollectItemMenuOpenChanged(bIsOpen, ItemContent)
  if self.Owner and self.Content then
    self.Owner:OnCollectItemMenuOpenChanged(self.Content, bIsOpen, ItemContent)
  end
end

function M:OnRewardMenuOpenChanged(bIsOpen)
  if self.Owner and self.Content then
    self.Owner:OnRewardMenuOpenChanged(self.Content, bIsOpen)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if not (self.Owner and self.Owner:IsGamepadMode()) or self.Owner:IsTipsState() then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local KeyName = GetKeyName(InKeyEvent)
  if self.Owner:IsItemBrowseState() and KeyName == UIConst.GamePadKey.FaceButtonBottom then
    self.Owner:OpenFocusedItemTips()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if not self.Owner or not self.Owner:IsGamepadMode() then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local KeyName, Key = GetKeyName(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(Key) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if self.Owner:HandleGamepadKey(KeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M
