require("UnLua")
local ItemUtils = require("Utils.ItemUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  if self.List_Item then
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
      local emptyContent = NewObject(UIUtils.GetCommonItemContentClass())
      emptyContent.IsEmpty = true
      return emptyContent
    end)
  end
  self:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    self.HandleNavigationUp
  })
  self:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    self.HandleNavigationDown
  })
end

function M:SupportsKeyboardFocus()
  return true
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() and self.Content and not self.Content.IsEmptyState then
    local parent = self.Content.ParentWidget
    if parent and parent.OnRewardEntryFocused then
      parent:OnRewardEntryFocused(self)
    end
  end
  return UIUtils.Handled
end

function M:Destruct()
  if self.List_Item then
    self.List_Item.OnCreateEmptyContent:Unbind()
  end
end

function M:BP_OnEntryReleased()
  if self.Content then
    self.Content.SelfWidget = nil
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Lock_Normal)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  if not Content then
    return
  end
  Content.SelfWidget = self
  if Content.IsEmptyState then
    self:StopAllAnimations()
    if self.WS_Item then
      self.WS_Item:SetActiveWidgetIndex(1)
    end
    self.Text_Max:SetText(GText("UI_IronSurvival_AdditionalRewardMax"))
    self.PrevUnlocked = false
    return
  end
  if self.WS_Item then
    self.WS_Item:SetActiveWidgetIndex(0)
  end
  self.Text_EnableLv:SetText(Content.LvText or "")
  if self.List_Item then
    self.List_Item:ClearListItems()
    local rewardViewIds = Content.RewardViewIds or {}
    local merged = {}
    local mergedOrder = {}
    for _, viewId in ipairs(rewardViewIds) do
      local rewardList = RewardUtils:GetRewardViewInfoById(viewId) or {}
      for _, itemData in ipairs(rewardList) do
        local id = itemData.Id
        if merged[id] then
          local qty = itemData.Quantity and itemData.Quantity[1] or 0
          merged[id].Count = (merged[id].Count or 0) + qty
        else
          local itemContent = NewObject(UIUtils.GetCommonItemContentClass())
          itemContent.Id = id
          itemContent.Icon = ItemUtils.GetItemIconPath(id, itemData.Type)
          itemContent.ItemType = itemData.Type
          itemContent.Rarity = itemData.Rarity or 1
          itemContent.IsShowDetails = true
          itemContent.UIName = "StyleOfPlay"
          itemContent.ParentWidget = Content.ParentWidget
          itemContent.Count = itemData.Quantity and itemData.Quantity[1] or 0
          merged[id] = itemContent
          mergedOrder[#mergedOrder + 1] = itemContent
        end
      end
    end
    for _, itemContent in ipairs(mergedOrder) do
      if 0 == itemContent.Count then
        itemContent.Count = nil
      end
      self.List_Item:AddItem(itemContent)
    end
    self.List_Item:RequestFillEmptyContent()
    self.List_Item:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_Item:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.List_Item:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.List_Item:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    local parent = Content.ParentWidget
    if parent and parent.IsBlockingRewardInner then
      self.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      self.List_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
  self.PrevUnlocked = Content.IsUnlocked or false
  local shouldPlayUnlock = Content.IsUnlocked and Content.PlayUnlockAnim
  Content.PlayUnlockAnim = false
  self:StopAllAnimations()
  if shouldPlayUnlock then
    local parent = Content.ParentWidget
    if parent and parent.RemoveTimer then
      parent:RemoveTimer("UnlockAnim")
    end
    self:ApplyLockState(true, true)
  else
    self:ApplyLockState(Content.IsUnlocked or false, false)
  end
end

function M:HandleNavigationUp()
  return self:HandleRewardNavigation(-1)
end

function M:HandleNavigationDown()
  return self:HandleRewardNavigation(1)
end

function M:HandleRewardNavigation(offset)
  if not self.Content or self.Content.IsEmptyState then
    return self
  end
  local parent = self.Content.ParentWidget
  if not parent or not parent.FocusRewardEntryByIndex then
    return self
  end
  local index = self.Content.RewardListIndex
  if nil == index then
    return self
  end
  return parent:FocusRewardEntryByIndex(index + offset) or self
end

function M:ApplyLockState(isUnlocked, playTransition)
  if isUnlocked then
    self.Text_Title:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Title:SetText(GText("UI_IronSurvival_AdditionalReward"))
    if playTransition then
      self:PlayAnimation(self.UnLock)
      if self.Up_Glow then
        self:PlayAnimation(self.Up_Glow)
      end
      AudioManager(self):PlayUISound(self, "event:/ui/common/shenjingluopan_unlock_gift", nil, nil)
    else
      self:PlayAnimation(self.UnLock_Normal)
    end
  else
    self.Text_Title:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Title:SetText(GText("UI_IronSurvival_AdditionalRewardMore"))
    if playTransition then
      self:PlayAnimation(self.Lock)
    else
      self:PlayAnimation(self.Lock_Normal)
    end
  end
end

function M:OnAddedToFocusPath(InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self:PlayAnimation(self.Normal)
  end
end

function M:RefreshUnlockState(selectedTicketLevel, forceTransition)
  if not self.Content then
    return
  end
  local roundKey = self.Content.RoundKey or 0
  local isUnlocked = selectedTicketLevel >= roundKey
  local playTransition = forceTransition or self.PrevUnlocked ~= isUnlocked
  self.PrevUnlocked = isUnlocked
  self:ApplyLockState(isUnlocked, playTransition)
end

return M
