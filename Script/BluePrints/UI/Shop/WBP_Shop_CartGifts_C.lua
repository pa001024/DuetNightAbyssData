require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.CartItem = nil
  self.ShopItemId = nil
  self.ShopItemData = nil
  self.ActiveItemWidget = nil
  self.bGamepadFocused = false
  self.bIsFocusable = true
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.CartItem = Content and Content.CartItem
  self.bPending = Content and Content.bPending or false
  if not self.CartItem then
    return
  end
  self.ShopItemId = self.CartItem.ShopItemId
  self.ShopItemData = self.ShopItemId and DataMgr.ShopItem[self.ShopItemId]
  if not self.ShopItemData then
    return
  end
  local TargetWidget
  if 1 == self.ShopItemData.Bg then
    self.WS_Type:SetActiveWidgetIndex(0)
    TargetWidget = self.Yellow
  else
    self.WS_Type:SetActiveWidgetIndex(1)
    TargetWidget = self.Purple
  end
  self.ActiveItemWidget = TargetWidget
  if TargetWidget and TargetWidget.InitCartGiftInfo then
    TargetWidget:InitCartGiftInfo(self.CartItem, self.bPending, self.Content)
    if self.Normal then
      self:PlayAnimation(self.Normal)
    end
    self:SetControllerCheckVisible(false)
    if self.bGamepadFocused then
      if self.Hover then
        self:PlayAnimation(self.Hover)
      end
      self:SetControllerCheckVisible(true)
    end
  end
end

function M:SetControllerCheckVisible(bVisible)
  local W = self.ActiveItemWidget
  if W and W.Controller_Check then
    W.Controller_Check:SetVisibility(bVisible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
end

function M:OnAddedToFocusPath(...)
  if UIUtils.UtilsGetCurrentInputType() ~= UE4.ECommonInputType.Gamepad then
    return
  end
  self.bGamepadFocused = true
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(true)
  end
  if self.Content and self.Content.ParentWidget and self.Content.ParentWidget.OnCartEntryFocusChanged then
    self.Content.ParentWidget:OnCartEntryFocusChanged(self, true)
  end
  if self.Hover then
    self:PlayAnimation(self.Hover)
  end
  self:SetControllerCheckVisible(true)
end

function M:OnRemovedFromFocusPath(...)
  self.bGamepadFocused = false
  if self.Content and self.Content.ParentWidget and self.Content.ParentWidget.OnCartEntryFocusChanged then
    self.Content.ParentWidget:OnCartEntryFocusChanged(self, false)
  end
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
  self:SetControllerCheckVisible(false)
end

function M:AdjustCount(Delta)
  local W = self.ActiveItemWidget
  local CartItem = W and W.CartItem or self.CartItem
  if not CartItem then
    return
  end
  if W and W.OnCountChanged then
    W:OnCountChanged(CartItem.Count + Delta)
  end
end

function M:SetCountToLimit(bToMax)
  local W = self.ActiveItemWidget
  if not W or not W.OnCountChanged then
    return
  end
  if bToMax then
    W:OnCountChanged(W:GetMaxCount())
  else
    local MinValue = W.NumInput and W.NumInput.MinValue or 0
    W:OnCountChanged(MinValue)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bIsRepeat = UE4.UKismetInputLibrary.InputEvent_IsRepeat(InKeyEvent)
  if InKeyName == Const.GamepadFaceButtonDown then
    if not bIsRepeat then
      if self.Click then
        self:PlayAnimation(self.Click)
      end
      if self.ActiveItemWidget and self.ActiveItemWidget.OnGamepadConfirm then
        self.ActiveItemWidget:OnGamepadConfirm()
      end
    end
    return UIUtils.Handled
  end
  local W = self.ActiveItemWidget
  local RewardList = W and W.List_Item or nil
  local bFocusInRewardList = nil ~= RewardList and (RewardList:HasAnyUserFocus() or RewardList:HasFocusedDescendants())
  if InKeyName == Const.GamepadLeftTrigger or InKeyName == Const.GamepadRightTrigger then
    if not bIsRepeat then
      self:AdjustCount(InKeyName == Const.GamepadRightTrigger and 1 or -1)
    end
    return UIUtils.Handled
  elseif InKeyName == Const.GamepadDPadLeft or InKeyName == Const.GamepadDPadRight then
    if bFocusInRewardList then
      return UIUtils.Unhandled
    end
    if not bIsRepeat then
      self:SetCountToLimit(InKeyName == Const.GamepadDPadRight)
    end
    return UIUtils.Handled
  elseif InKeyName == Const.GamepadRightThumbstick then
    if not bFocusInRewardList and RewardList then
      RewardList:SetFocus()
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M
