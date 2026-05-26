require("UnLua")
local M = Class("Blueprints.UI.BP_UIState_C")

local function OpenRewardItemMenu(Widget)
  if IsValid(Widget) and Widget.OpenItemMenu then
    Widget:OpenItemMenu()
  end
end

function M:Construct()
end

function M:Init(Content)
  self:OnListItemObjectSet(Content)
end

function M:OnListItemObjectSet(Content)
  self.Content = nil
  self.Owner = nil
  self.Type = nil
  self.ItemId = nil
  self.IsEmpty = false
  self.bHoverPlaying = false
  self.CanReceive = false
  self.RewardsGot = false
  self.HasGoto = false
  self:SetVisibility(UIConst.VisibilityOp.Visible)
  self:SetIsEnabled(true)
  self.WS_Type:SetActiveWidgetIndex(0)
  if self.List_Item_L then
    self.List_Item_L:ClearListItems()
    self.List_Item_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.List_Item_R then
    self.List_Item_R:ClearListItems()
    self.List_Item_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Text_Num then
    self.Text_Num:SetText("")
    self.Text_Num:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if not (Content and Content.ConfigData) or Content.IsEmpty then
    self.IsEmpty = true
    self:SetIsEnabled(false)
    self.WS_Type:SetActiveWidgetIndex(1)
    return
  end
  Content.SelfWidget = self
  local ConfigData = Content.ConfigData
  if not ConfigData.ItemId then
    return
  end
  self.Content = Content
  self.Owner = Content.Owner
  self.Type = ConfigData.Type
  self.ItemId = ConfigData.ItemId
  self.CanReceive = ConfigData.CanReceive or false
  self.RewardsGot = ConfigData.RewardsGot or false
  self.HasGoto = ConfigData.HasGoto or false
  self.Text_Content:SetText(GText(ConfigData.Hint or ""))
  if ConfigData.NotShowNum then
    self.Text_Num:SetVisibility(ESlateVisibility.Collapsed)
  elseif ConfigData.Num then
    self.Text_Num:SetText(tostring(ConfigData.Num))
    self.Text_Num:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Text_Num:SetText("")
    self.Text_Num:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Text_Progress:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if ConfigData.TextProgress then
    self.Text_Progress:SetText(ConfigData.TextProgress)
    self.Text_Progress:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.RewardsGot and ConfigData.HideProgressAfterGot then
    self.Text_Progress:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.RewardsGot then
    self.WS_State:SetActiveWidgetIndex(1)
    self:PlayAnimation(self.Forbidden)
  elseif self.CanReceive then
    self.WS_State:SetActiveWidgetIndex(0)
  elseif self.HasGoto then
    self.WS_State:SetActiveWidgetIndex(3)
    if self.Btn_Goto and ConfigData.GotoButtonText then
      self.Btn_Goto:SetText(GText(ConfigData.GotoButtonText))
    end
  else
    self.WS_State:SetActiveWidgetIndex(2)
    if self.Text_Ing and ConfigData.NotreachText then
      self.Text_Ing:SetText(GText(ConfigData.NotreachText))
    end
  end
  if self.Btn_Reward then
    if self.Btn_Reward.ForbidBtn then
      self.Btn_Reward:ForbidBtn(self.RewardsGot or not self.CanReceive)
    end
    self.Btn_Reward:SetText(GText(ConfigData.ReceiveButtonText) or GText("UI_Archive_CollectionClaim"))
    self.Btn_Reward:UnBindEventOnClickedByObj(self)
    if ConfigData.ReceiveCallBack then
      self.Btn_Reward:BindEventOnClicked(self, function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_normal", nil, nil)
        ConfigData.ReceiveCallBack(self, Content)
      end)
    end
  end
  if self.Btn_Goto then
    self.Btn_Goto:UnBindEventOnClickedByObj(self)
    if ConfigData.GotoCallBack then
      self.Btn_Goto:BindEventOnClicked(self, function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
        ConfigData.GotoCallBack(self, Content)
      end)
    end
  end
  self:InitRewards(ConfigData)
  if not self.RewardsGot then
    self:PlayAnimation(self.Normal)
  end
  self:RefreshGamepadHint(false)
end

function M:InitRewards(ConfigData)
  local Rewards = ConfigData.Rewards
  if self.List_Item_L then
    self.List_Item_L:ClearListItems()
    self.List_Item_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.List_Item_R then
    self.List_Item_R:ClearListItems()
    self.List_Item_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if not Rewards or 0 == #Rewards then
    return
  end
  if ConfigData.LeftAligned then
    self.List_Item_L:SetVisibility(UIConst.VisibilityOp.Visible)
    self.List_Item_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.UsedList = self.List_Item_L
  else
    self.List_Item_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.List_Item_R:SetVisibility(UIConst.VisibilityOp.Visible)
    self.UsedList = self.List_Item_R
  end
  self.UsedList:ClearListItems()
  for _, Reward in ipairs(Rewards) do
    local Item = self:NewItemContent(Reward.ItemType, Reward.ItemId, Reward.Count, Reward.bHasGot)
    if Item then
      self.UsedList:AddItem(Item)
    end
  end
  self.UsedList.OnCreateEmptyContent:Bind(self, function(self)
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyContent.IsEmpty = true
    return EmptyContent
  end)
  self.RewardNavigationBoundLists = self.RewardNavigationBoundLists or {}
  if not self.RewardNavigationBoundLists[self.UsedList] then
    self.UsedList.BP_OnEntryGenerated:Add(self, function(self, Widget)
      if IsValid(Widget) then
        Widget:SetNavigationRuleCustom(UE4.EUINavigation.Left, {
          self,
          self.OnNavigateLeft
        })
        Widget:SetNavigationRuleCustom(UE4.EUINavigation.Right, {
          self,
          self.OnNavigateRight
        })
        Widget:SetNavigationRuleCustom(UE4.EUINavigation.Up, {
          self,
          self.OnNavigateUp
        })
        Widget:SetNavigationRuleCustom(UE4.EUINavigation.Down, {
          self,
          self.OnNavigateDown
        })
      end
    end)
    self.RewardNavigationBoundLists[self.UsedList] = true
  end
  self.UsedList:RequestFillEmptyContent()
end

function M:NewItemContent(ItemType, ItemId, Count, HasGot)
  if not ItemId or 0 == ItemId then
    return NewObject(UIUtils.GetCommonItemContentClass())
  end
  local ItemData = DataMgr[ItemType] and DataMgr[ItemType][ItemId]
  if not ItemData then
    return nil
  end
  local NewObj = NewObject(UIUtils.GetCommonItemContentClass())
  NewObj.ItemType = ItemType:gsub("^%l", string.upper)
  NewObj.Id = ItemId
  NewObj.Rarity = ItemData.Rarity or ItemData.WeaponRarity or 1
  NewObj.Icon = ItemData.Icon
  NewObj.Count = Count or 1
  NewObj.IsShowDetails = true
  NewObj.ParentWidget = self
  NewObj.bHasGot = HasGot or false
  if self.Owner and self.Owner.OnMenuOpenChanged then
    NewObj.OnMenuOpenChangedEvents = {
      Obj = self.Owner,
      Callback = self.Owner.OnMenuOpenChanged
    }
  end
  return NewObj
end

function M:RefreshBtn(IsGot)
  self.RewardsGot = IsGot and true or false
  self.CanReceive = self.Content and self.Content.ConfigData and self.Content.ConfigData.CanReceive or false
  if IsGot then
    self.CanReceive = false
    self.WS_State:SetActiveWidgetIndex(1)
    if self.Btn_Reward and self.Btn_Reward.ForbidBtn then
      self.Btn_Reward:ForbidBtn(true)
    end
    if self.Content and self.Content.ConfigData and self.Content.ConfigData.HideProgressAfterGot then
      self.Text_Progress:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:PlayAnimation(self.Forbidden)
  elseif self.Content and self.Content.ConfigData and self.Content.ConfigData.CanReceive then
    self.WS_State:SetActiveWidgetIndex(0)
    if self.Btn_Reward and self.Btn_Reward.ForbidBtn then
      self.Btn_Reward:ForbidBtn(false)
    end
  else
    if self.Btn_Reward and self.Btn_Reward.ForbidBtn then
      self.Btn_Reward:ForbidBtn(true)
    end
    if self.HasGoto then
      self.WS_State:SetActiveWidgetIndex(3)
    else
      self.WS_State:SetActiveWidgetIndex(2)
    end
  end
end

function M:FocusToRewardItem()
  if not self.UsedList then
    return nil
  end
  self.UsedList:SetVisibility(UIConst.VisibilityOp.Visible)
  local ItemUIs = self.UsedList:GetDisplayedEntryWidgets()
  self.SelectedIndex = 0
  if ItemUIs:Length() > 0 then
    local Target = ItemUIs:GetRef(1)
    if Target then
      self.UsedList:SetSelectedIndex(0)
      self.UsedList:NavigateToIndex(0)
      if self.Owner and self.Owner.NeedOpenMenuWhenResoureFocused then
        self:AddTimer(0.1, function()
          OpenRewardItemMenu(Target)
        end, false, 0, nil, true)
      end
      return Target
    end
  end
  return nil
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    if self.Owner and self.Owner.IsInViewMode then
      self:AddTimer(0.001, function()
        self:FocusToRewardItem()
      end, false, 0, nil, true)
    else
      if self.UsedList then
        self.UsedList:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      end
      self.GameInputModeSubsystem = self.GameInputModeSubsystem or UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
      if IsValid(self.GameInputModeSubsystem) then
        self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
        self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
      end
    end
    if not self.Owner or not self.Owner.IsInViewMode then
      if self.Owner and self.Owner.ShowGamepadViewBtn then
        self.Owner:ShowGamepadViewBtn(true)
      end
      self:RefreshGamepadHint(true)
      self:AddTimer(0.1, function()
        if not self:IsAnimationPlaying(self.In) then
          self:StopAllAnimations()
        end
        if self.Hover then
          self:PlayAnimation(self.Hover)
          self.bHoverPlaying = true
        end
      end, false, 0, "HoverAnimTimer", true)
    end
  end
  return self.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

function M:StopHover(InSwitch)
  if InSwitch or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:RemoveTimer("HoverAnimTimer")
    if self.Hover and self.bHoverPlaying then
      if self:IsAnimationPlaying(self.Hover) then
        self:StopAnimation(self.Hover)
      end
      self:PlayAnimationReverse(self.Hover)
      self.bHoverPlaying = false
    end
    self:RefreshGamepadHint(false)
  end
end

function M:RefreshItems()
  if self.Owner and self.Owner.HasTab then
    self.Owner:Refresh(self.Owner.ConfigData.Datas[self.Type])
  elseif self.Owner then
    self.Owner:Refresh(self.Owner.ConfigData)
  end
end

function M:InitGamepadHint()
  self:RefreshGamepadHint()
end

function M:RefreshGamepadHint(bIsFocused)
  if self.IsEmpty then
    if self.Key_Item then
      self.Key_Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if self.Btn_Reward then
      self.Btn_Reward:SetGamePadIconVisible(false)
    end
    if self.Btn_Goto then
      self.Btn_Goto:SetGamepadIconVisibility(false)
    end
    return
  end
  local bIsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  local bInSelectMode = self.Owner and self.Owner.IsInViewMode
  local bShowHint = bIsGamepad and bIsFocused and not bInSelectMode
  if self.Key_Item then
    if bShowHint then
      self.Key_Item:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "LS"}
        }
      })
      self.Key_Item:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      self.Key_Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  if self.Btn_Reward then
    self.Btn_Reward:SetGamePadIconVisible(bShowHint and self.CanReceive)
  end
  if self.Btn_Goto then
    self.Btn_Goto:SetGamepadIconVisibility(bShowHint and self.HasGoto)
  end
end

function M:OnMenuOpenChanged(bIsOpen, Obj)
  if self.Owner and self.Owner.OnMenuOpenChanged then
    self.Owner:OnMenuOpenChanged(bIsOpen)
  end
end

function M:EnterSelectMode()
  if self.IsEmpty or not self.Owner then
    return
  end
  if self.Owner.IsInViewMode then
    return
  end
  self.Owner.IsInViewMode = true
  self:RefreshGamepadHint(false)
  if self.UsedList then
    self.UsedList:SetVisibility(UIConst.VisibilityOp.Visible)
    local ItemUIs = self.UsedList:GetDisplayedEntryWidgets()
    if ItemUIs:Length() > 0 then
      local Target = ItemUIs:GetRef(1)
      if Target then
        self.UsedList:SetSelectedIndex(0)
        self.UsedList:NavigateToIndex(0)
        Target:SetFocus()
      end
    end
  end
  if self.Owner.ShowGamepadViewSelectModeBtn then
    self.Owner:ShowGamepadViewSelectModeBtn(true)
  end
end

function M:LeaveSelectMode()
  if self.IsEmpty or not self.Owner then
    return
  end
  if not self.Owner.IsInViewMode then
    return
  end
  self.Owner.IsInViewMode = false
  if self.UsedList then
    self.UsedList:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self:RefreshGamepadHint(true)
  self:SetFocus()
  if self.Owner.ShowGamepadViewSelectModeBtn then
    self.Owner:ShowGamepadViewSelectModeBtn(false)
  end
end

function M:UpdateSelectedWidget(SelectedIndex)
  if not self.UsedList then
    return nil
  end
  if self.Owner then
    self.Owner.NeedOpenMenuWhenResoureFocused = false
  end
  local CurItem = self.UsedList:GetItemAt(self.SelectedIndex or 0)
  if CurItem and CurItem.SelfWidget and CurItem.SelfWidget.Item and CurItem.SelfWidget.Item.ItemDetails_MenuAnchor then
    local MenuAnchor = CurItem.SelfWidget.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor
    if self.Owner and MenuAnchor then
      self.Owner.NeedOpenMenuWhenResoureFocused = MenuAnchor:IsOpen()
    end
  end
  self.SelectedIndex = SelectedIndex
  self.UsedList:NavigateToIndex(self.SelectedIndex)
  self.UsedList:SetSelectedIndex(self.SelectedIndex)
  local NewFocusItem = self.UsedList:GetItemAt(self.SelectedIndex)
  if NewFocusItem and NewFocusItem.SelfWidget then
    if self.Owner and self.Owner.NeedOpenMenuWhenResoureFocused then
      self:AddTimer(0.01, function()
        OpenRewardItemMenu(NewFocusItem.SelfWidget)
      end, false, 0, nil, true)
    end
    return NewFocusItem.SelfWidget
  end
  return nil
end

function M:OnNavigateLeft()
  if (self.SelectedIndex or 0) - 1 >= 0 then
    return self:UpdateSelectedWidget((self.SelectedIndex or 0) - 1)
  end
  local CurItem = self.UsedList and self.UsedList:GetItemAt(self.SelectedIndex or 0)
  return CurItem and CurItem.SelfWidget or nil
end

function M:OnNavigateRight()
  if not self.UsedList then
    return nil
  end
  local ItemsCount = self.UsedList:GetNumItems()
  if ItemsCount > (self.SelectedIndex or 0) + 1 then
    return self:UpdateSelectedWidget((self.SelectedIndex or 0) + 1)
  end
  local CurItem = self.UsedList:GetItemAt(self.SelectedIndex or 0)
  return CurItem and CurItem.SelfWidget or nil
end

function M:OnNavigateDown()
  local CurItem = self.UsedList and self.UsedList:GetItemAt(self.SelectedIndex or 0)
  if CurItem and CurItem.SelfWidget and CurItem.SelfWidget.Item and CurItem.SelfWidget.Item.ItemDetails_MenuAnchor then
    local MenuAnchor = CurItem.SelfWidget.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor
    if self.Owner then
      self.Owner.NeedOpenMenuWhenResoureFocused = MenuAnchor and MenuAnchor:IsOpen()
    end
    if self.Owner and self.Owner.NeedOpenMenuWhenResoureFocused then
      OpenRewardItemMenu(CurItem.SelfWidget)
    end
  end
  return self.Owner and self.Owner.OnNavigateDown and self.Owner:OnNavigateDown(self.Content) or nil
end

function M:OnNavigateUp()
  local CurItem = self.UsedList and self.UsedList:GetItemAt(self.SelectedIndex or 0)
  if CurItem and CurItem.SelfWidget and CurItem.SelfWidget.Item and CurItem.SelfWidget.Item.ItemDetails_MenuAnchor then
    local MenuAnchor = CurItem.SelfWidget.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor
    if self.Owner then
      self.Owner.NeedOpenMenuWhenResoureFocused = MenuAnchor and MenuAnchor:IsOpen()
    end
    if self.Owner and self.Owner.NeedOpenMenuWhenResoureFocused then
      OpenRewardItemMenu(CurItem.SelfWidget)
    end
  end
  return self.Owner and self.Owner.OnNavigateUp and self.Owner:OnNavigateUp(self.Content) or nil
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self.IsEmpty then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.Owner and self.Owner.IsInViewMode then
      IsEventHandled = true
      self:LeaveSelectMode()
      self:SetFocus()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      IsEventHandled = true
      if 0 == self.WS_State:GetActiveWidgetIndex() and self.Btn_Reward then
        self.Btn_Reward:OnBtnClicked()
      elseif 3 == self.WS_State:GetActiveWidgetIndex() and self.Btn_Goto then
        self.Btn_Goto:OnBtnClicked()
      end
    elseif InKeyName == UIConst.GamePadKey.LeftThumb and self.Owner and not self.Owner.IsInViewMode then
      IsEventHandled = true
      self:EnterSelectMode()
    end
  elseif "SpaceBar" == InKeyName then
    IsEventHandled = true
    if self.Owner and self.Owner.RewardContent_OneClick and self.Owner.RewardContent_OneClick.Btn_OneClick then
      self.Owner.RewardContent_OneClick.Btn_OneClick:OnBtnClicked()
    end
  end
  return IsEventHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self.IsEmpty then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.Owner and not self.Owner.IsInViewMode then
    IsEventHandled = true
    if 0 == self.WS_State:GetActiveWidgetIndex() and self.Btn_Reward then
      self.Btn_Reward:OnBtnClicked()
    elseif 3 == self.WS_State:GetActiveWidgetIndex() and self.Btn_Goto then
      self.Btn_Goto:OnBtnClicked()
    end
  end
  return IsEventHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:Destruct()
  self.Super.Destruct(self)
end

return M
