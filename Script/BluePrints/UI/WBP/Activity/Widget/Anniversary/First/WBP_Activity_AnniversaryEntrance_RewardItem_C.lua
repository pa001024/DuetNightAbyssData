require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.IsFocusRewardItem = false
  self.IsRewardTipsOpen = false
  self.Btn_Reward:SetText(GText("UI_GameEvent_ClaimReward"))
  self.Btn_Reward:SetGamePadImg("A")
  self.Btn_Reward:BindSingleEventOnClicked(self, self.OnGetRewardBtnClicked)
  self.Text_Ing:SetText(GText("UI_Reward_Received"))
  self.Btn_Jump:SetText(GText("UI_GameEvent_ToBeFinished"))
  self.Btn_Jump:ForbidBtn(true)
  self.Btn_Jump:SetGamepadIconVisibility(false)
  self.Key_Item:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
end

function M:OnListItemObjectSet(Content)
  Content.SelfWidget = self
  self.Content = Content
  self:InitView()
end

function M:InitView()
  self:SetGamepadIconVisibility(false)
  self:UpdateRewardList()
  self:UpdateGetBtn()
  self.Text_Desc:SetText(GText(self.Content.RewardClaimDes))
end

function M:UpdateRewardList()
  self.List_Item_L:ClearListItems()
  self.List_Item_R:ClearListItems()
  local RewardData = DataMgr.Reward[self.Content.RewardId]
  if not RewardData then
    return
  end
  self.Group_ListLeft:SetVisibility(#RewardData.Id > 2 and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
  self.Group_ListRight:SetVisibility(#RewardData.Id > 2 and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.Visible)
  local UsedListItem = #RewardData.Id > 2 and self.List_Item_L or self.List_Item_R
  self.UsedListItem = UsedListItem
  for Index = 1, #RewardData.Id do
    local ResourceData = DataMgr[RewardData.Type[Index]][RewardData.Id[Index]]
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    ItemContent.Id = ResourceData.ResourceId or ResourceData.HeadId or ResourceData.TitleID
    ItemContent.ItemType = RewardData.Type[Index]
    ItemContent.Rarity = ResourceData.Rarity
    ItemContent.Icon = ResourceData.Icon
    ItemContent.Count = RewardData.Count[Index][1]
    ItemContent.bHasGot = self.Content.IsGetReward == true
    ItemContent.IsShowDetails = true
    ItemContent.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnRewardMenuOpenChanged
    }
    UsedListItem:AddItem(ItemContent)
  end
end

function M:UpdateGetBtn()
  local Content = self.Content
  local CanClaim = Content.CanClaim == true
  if CanClaim then
    self:PlayAnimation(self.Receive)
  elseif true == Content.IsGetReward then
    self:PlayAnimation(self.Forbidden)
  else
    self:PlayAnimation(self.Receive_Normal)
  end
end

function M:CanGetReward()
  return self.Content.CanClaim == true
end

function M:OnGetRewardBtnClicked()
  local ParentWidget = self.Content.ParentWidget
  if ParentWidget then
    ParentWidget:OnBtnClick(self.Content.Index)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_normal", nil, nil)
end

function M:SetGamepadIconVisibility(bShow)
  if self.Key_Item then
    self.Key_Item:SetVisibility(bShow and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Hidden)
  end
  if self.Btn_Reward then
    self.Btn_Reward:SetGamePadIconVisible(bShow and self:CanGetReward())
  end
end

function M:OnAddedToFocusPath(InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or self.IsFocusRewardItem then
    return
  end
  self:PlayAnimation(self.Hover)
  self:SetGamepadIconVisibility(true)
  if self.Content and self.Content.ParentWidget then
    self.Content.ParentWidget:OnTaskItemFocused(self)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or self.IsFocusRewardItem then
    return
  end
  self:PlayAnimation(self.UnHover)
  self:SetGamepadIconVisibility(false)
end

function M:BP_OnItemSelectionChanged(bIsSelected)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if bIsSelected then
    self:PlayAnimation(self.Hover)
    if not self.IsFocusRewardItem then
      self:SetGamepadIconVisibility(true)
      if self.Content and self.Content.ParentWidget then
        self.Content.ParentWidget:OnTaskItemFocused(self)
      end
    end
  else
    self:PlayAnimation(self.UnHover)
    self:SetGamepadIconVisibility(false)
  end
end

function M:FocusFirstRewardItem()
  if not self.UsedListItem then
    return false
  end
  local Content = self.UsedListItem:GetItemAt(0)
  if not Content then
    return false
  end
  self.UsedListItem:SetSelectedIndex(0)
  self.UsedListItem:BP_NavigateToItem(Content)
  if Content.SelfWidget then
    Content.SelfWidget:SetFocus()
  else
    self.UsedListItem:SetFocus()
  end
  return true
end

function M:EnterRewardItemViewMode()
  if self.IsFocusRewardItem or not self.UsedListItem then
    return false
  end
  self.IsFocusRewardItem = true
  self.IsRewardTipsOpen = false
  self:SetGamepadIconVisibility(false)
  if self.Content and self.Content.ParentWidget then
    self.Content.ParentWidget:OnEnterRewardItemView(self)
  end
  local bFocused = self:FocusFirstRewardItem()
  if not bFocused then
    self.IsFocusRewardItem = false
    if self.Content and self.Content.ParentWidget then
      self.Content.ParentWidget:OnLeaveRewardItemView(self)
    end
    self:SetGamepadIconVisibility(true)
  end
  return bFocused
end

function M:LeaveRewardItemViewMode()
  if not self.IsFocusRewardItem or self.IsRewardTipsOpen then
    return false
  end
  self.IsFocusRewardItem = false
  if self.Content and self.Content.ParentWidget then
    self.Content.ParentWidget:OnLeaveRewardItemView(self)
  end
  self:SetFocus()
  self:SetGamepadIconVisibility(true)
  return true
end

function M:OnRewardMenuOpenChanged(bIsOpen)
  self.IsRewardTipsOpen = bIsOpen
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or not self.IsFocusRewardItem then
    return
  end
  if self.Content and self.Content.ParentWidget then
    self.Content.ParentWidget:OnRewardTipsOpenChanged(bIsOpen)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bHandled = false
  if InKeyName == UIConst.GamePadKey.LeftThumb and not self.IsFocusRewardItem then
    bHandled = self:EnterRewardItemViewMode()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight and self.IsFocusRewardItem then
    if self.IsRewardTipsOpen then
      return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    bHandled = self:LeaveRewardItemViewMode()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom and not self.IsFocusRewardItem then
    if self:CanGetReward() then
      self:OnGetRewardBtnClicked()
      if self.Btn_Reward.Press then
        self.Btn_Reward:PlayAnimation(self.Btn_Reward.Press)
      end
    end
    bHandled = true
  end
  if bHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M
