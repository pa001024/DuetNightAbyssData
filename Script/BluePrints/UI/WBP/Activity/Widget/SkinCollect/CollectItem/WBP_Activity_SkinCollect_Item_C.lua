require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
M.StateAnimNameMap = {
  HasGot = {
    "HasGot",
    "Got",
    "Claimed",
    "Received"
  },
  CanGet = {
    "Available",
    "Claimable",
    "CanClaim"
  },
  Locked = {
    "Not_Done",
    "Locked",
    "Disable",
    "Default"
  }
}
M.MouseAnimNameMap = {
  Normal = {"Normal"},
  Hover = {"Hover"},
  UnHover = {"UnHover", "Unhover"},
  Press = {"Press"},
  Click = {"Click"}
}

local function PlayFirstExistingAnimation(widget, animNames)
  if not widget or not animNames then
    return false
  end
  for _, animName in ipairs(animNames) do
    local animObj = widget[animName]
    if animObj and widget.PlayAnimation then
      widget:PlayAnimation(animObj)
      return true
    end
  end
  return false
end

local function SafeBindClick(Widget, Obj, Func)
  if not (Widget and Obj) or not Func then
    return
  end
  if Widget.UnBindEventOnClicked and Widget.BindEventOnClicked then
    Widget:UnBindEventOnClicked(Obj, Func)
    Widget:BindEventOnClicked(Obj, Func)
    return
  end
  if Widget.OnClicked then
    Widget.OnClicked:Remove(Obj, Func)
    Widget.OnClicked:Add(Obj, Func)
    return
  end
  if Widget.Button_Area and Widget.Button_Area.OnClicked then
    Widget.Button_Area.OnClicked:Remove(Obj, Func)
    Widget.Button_Area.OnClicked:Add(Obj, Func)
  end
end

local function SafeUnBindClick(Widget, Obj, Func)
  if not (Widget and Obj) or not Func then
    return
  end
  if Widget.UnBindEventOnClicked then
    Widget:UnBindEventOnClicked(Obj, Func)
    return
  end
  if Widget.OnClicked then
    Widget.OnClicked:Remove(Obj, Func)
    return
  end
  if Widget.Button_Area and Widget.Button_Area.OnClicked then
    Widget.Button_Area.OnClicked:Remove(Obj, Func)
  end
end

local function SafeBindDelegate(Delegate, Obj, Func)
  if not (Delegate and Obj) or not Func then
    return
  end
  Delegate:Remove(Obj, Func)
  Delegate:Add(Obj, Func)
end

local function SafeUnBindDelegate(Delegate, Obj, Func)
  if not (Delegate and Obj) or not Func then
    return
  end
  Delegate:Remove(Obj, Func)
end

local function SetKeyWidgetAVisible(keyWidget, isVisible)
  if not keyWidget then
    return
  end
  if keyWidget.CreateGamepadKey and not keyWidget.SkinCollectAKeyInitialized then
    keyWidget:CreateGamepadKey("A")
    keyWidget.SkinCollectAKeyInitialized = true
  end
  if keyWidget.SetVisibility then
    keyWidget:SetVisibility(isVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

local function CancelComItemAsyncTask(comItem, taskName)
  if not comItem or not taskName then
    return
  end
  if ForceStopAsyncTask then
    ForceStopAsyncTask(comItem, taskName)
  end
  if comItem.ComItemAsyncTasks then
    comItem.ComItemAsyncTasks[taskName] = nil
  end
end

local function ResetComItemStateWidgets(comItem)
  if not comItem then
    return
  end
  CancelComItemAsyncTask(comItem, "SetIsGotTask")
  CancelComItemAsyncTask(comItem, "SetIsCanGetTack")
  if comItem.RemoveWidgetFromNode then
    if comItem.IsGotWidget and IsValid(comItem.IsGotWidget) then
      comItem:RemoveWidgetFromNode(comItem.IsGotWidget, true)
    end
    if comItem.CanGetWidget and IsValid(comItem.CanGetWidget) then
      comItem:RemoveWidgetFromNode(comItem.CanGetWidget, true)
    end
  end
end

function M:ResetEntryReuseState()
  self:RemoveTimer("SkinCollectItemUnHover")
  self.bClaimableMode = false
  self.bComItemFocusMode = false
  self.bListFocusGamepadHintVisible = false
  self.bIsItemTipsOpened = false
  self.LastOpenedComItem = nil
  local prevHighlight = self.bHighlight
  self.bHighlight = false
  for _, sub in ipairs({
    self.First,
    self.Single,
    self.Double
  }) do
    if sub then
      local btnGet = sub.Btn_Get
      if btnGet then
        self:UnBindGetButtonMouseEvents(btnGet)
        btnGet:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      if sub.Img_Got then
        sub.Img_Got:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      if sub.Img_Claimable then
        sub.Img_Claimable:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      if sub.Reddot then
        sub.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      SetKeyWidgetAVisible(sub.Key_GamePad, false)
      SetKeyWidgetAVisible(sub.Key_A, false)
      SetKeyWidgetAVisible(sub.Com_KeyImg, false)
      SetKeyWidgetAVisible(sub.Key_Confirm, false)
      ResetComItemStateWidgets(sub.Com_Item)
      ResetComItemStateWidgets(sub.Com_Item01)
      ResetComItemStateWidgets(sub.Com_Item02)
      if sub.StopAllAnimations then
        sub:StopAllAnimations()
      end
    end
  end
  self.bHighlight = prevHighlight
end

function M:OnListItemObjectSet(Content)
  self:ResetEntryReuseState()
  if not Content then
    return
  end
  self.Content = Content
  self.Content.SelfWidget = self
  self.bIsFocusable = true
  self.ItemIndex = Content.Index or 0
  self.TargetScore = Content.TargetScore or 0
  self.RewardIds = Content.RewardIds
  self.bHighlight = true == Content.bHighlight
  self.ParentWidget = Content.ParentWidget
  self.IsUnlocked = self.ParentWidget and true == self.ParentWidget.IsUnlocked
  self.UIName = self.ParentWidget and self.ParentWidget.UIName or "ActivitySkinCollect"
  self:RefreshWidgetSwitcher(Content.Index, Content.RewardIds)
  self:RefreshProgressBarSwitcher(Content.Index, Content.PrevRewardIds)
  self:RefreshProgressBar(Content.CurrentScore, Content.PrevTargetScore, Content.TargetScore)
  self:RefreshNumText(Content.TargetScore)
  self:RefreshState(Content.bHasGot, Content.bCanGet)
  self:RefreshComItems(Content.RewardIds, Content.bHasGot, Content.bCanGet)
  if Content.bPlayUnlockAnim then
    Content.bPlayUnlockAnim = false
    self:PlayUnlockAnim(Content.bCanGet)
  end
  self:UpdateInnerNavigation()
  self:SetListFocusGamepadHintVisible(false)
end

function M:BP_OnEntryReleased()
  if self.Content then
    self.Content.SelfWidget = nil
  end
  self:ResetEntryReuseState()
  self.Content = nil
  self.ParentWidget = nil
  self.LastOpenedComItem = nil
  self.bIsFocusable = false
  self.ItemIndex = 0
  self.TargetScore = 0
  self.RewardIds = nil
  self.bHighlight = false
  self.IsUnlocked = false
end

function M:BuildRewardContents(rewardIds)
  local rewardContents = {}
  if not rewardIds then
    return rewardContents
  end
  if type(rewardIds) == "number" then
    rewardIds = {rewardIds}
  end
  for _, rewardId in ipairs(rewardIds) do
    local rewardInfo = DataMgr.Reward and DataMgr.Reward[rewardId]
    if rewardInfo then
      local ids = rewardInfo.Id or {}
      local counts = rewardInfo.Count or {}
      local types = rewardInfo.Type or {}
      for i = 1, #ids do
        local itemId = ids[i]
        local itemType = types[i]
        local itemCount = counts[i]
        table.insert(rewardContents, {
          Id = itemId,
          ItemType = itemType,
          Count = RewardUtils and RewardUtils.GetCount and RewardUtils:GetCount(itemCount) or itemCount,
          Rarity = ItemUtils.GetItemRarity(itemId, itemType),
          Icon = ItemUtils.GetItemIconPath(itemId, itemType)
        })
      end
    else
      Utils.ScreenPrint("[WBP_Activity_SkinCollect_Item_C] BuildRewardContents failed to get rewardInfo for rewardId: " .. tostring(rewardId))
    end
  end
  return rewardContents
end

function M:RefreshWidgetSwitcher(index, rewardIds)
  if not self.WS_Item then
    return
  end
  local rewardContents = self:BuildRewardContents(rewardIds)
  if 1 == index then
    self.WS_Item:SetActiveWidgetIndex(0)
  elseif #rewardContents >= 2 then
    self.WS_Item:SetActiveWidgetIndex(2)
  else
    self.WS_Item:SetActiveWidgetIndex(1)
  end
end

function M:IsDoubleNodeByRewardIds(rewardIds)
  if not rewardIds then
    return false
  end
  local rewardContents = self:BuildRewardContents(rewardIds)
  return #rewardContents >= 2
end

function M:RefreshProgressBarSwitcher(index, prevRewardIds)
  local sub = self:GetActiveSubWidget()
  if not sub or not sub.WS_ProgressBar then
    return
  end
  if 1 == index then
    sub.WS_ProgressBar:SetActiveWidgetIndex(0)
    return
  end
  local prevIsDouble = self:IsDoubleNodeByRewardIds(prevRewardIds)
  sub.WS_ProgressBar:SetActiveWidgetIndex(prevIsDouble and 1 or 0)
end

function M:RefreshProgressBar(currentScore, prevTargetScore, targetScore)
  local percent = 0
  local range = (targetScore or 0) - (prevTargetScore or 0)
  if range > 0 then
    percent = math.min(math.max(((currentScore or 0) - (prevTargetScore or 0)) / range, 0), 1)
  elseif currentScore and targetScore and targetScore <= currentScore then
    percent = 1
  end
  local sub = self:GetActiveSubWidget()
  if sub and sub.ProgressBar then
    sub.ProgressBar:SetPercent(percent)
  end
  if sub and sub.ProgressBar_Double then
    sub.ProgressBar_Double:SetPercent(percent)
  end
end

function M:RefreshNumText(targetScore)
  local sub = self:GetActiveSubWidget()
  if sub and sub.Text_Num then
    sub.Text_Num:SetText(tostring(targetScore or 0))
  end
end

function M:RefreshState(bHasGot, bCanGet)
  self.bClaimableMode = not bHasGot and true == bCanGet
  local sub = self:GetActiveSubWidget()
  if not sub then
    return
  end
  if sub.Img_Got then
    sub.Img_Got:SetVisibility(bHasGot and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if sub.Img_Claimable then
    sub.Img_Claimable:SetVisibility(not bHasGot and bCanGet and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  self:RefreshGetButton()
  self:RefreshReddot(sub, bHasGot, bCanGet)
  self:PlaySubWidgetStateAnim(sub, bHasGot, bCanGet)
end

function M:ShouldUseGamepadGetButtonForDetail()
  if self.bClaimableMode then
    return false
  end
  if self.bListFocusGamepadHintVisible ~= true then
    return false
  end
  if true == self.bComItemFocusMode then
    return false
  end
  if self:GetCurrentFocusedComItem() ~= nil then
    return false
  end
  if not (UIUtils and UIUtils.IsGamepadInput) or not UIUtils.IsGamepadInput() then
    return false
  end
  return self:HasMultipleComItems() and true or false
end

function M:RefreshGetButton()
  local activeSub = self:GetActiveSubWidget()
  local bCanClaim = self.bClaimableMode == true
  local subWidgets = {
    self.First,
    self.Single,
    self.Double
  }
  for _, sub in ipairs(subWidgets) do
    local btnGet = sub and sub.Btn_Get
    if btnGet then
      self:UnBindGetButtonMouseEvents(btnGet)
      local bUseGamepadDetail = sub == activeSub and self:ShouldUseGamepadGetButtonForDetail()
      local bEnableClick = sub == activeSub and (bCanClaim or bUseGamepadDetail)
      local visibility = UIConst.VisibilityOp.HitTestInvisible
      if sub == activeSub and self:ShouldUseSingleComItemFocusTarget() then
        visibility = UIConst.VisibilityOp.Collapsed
      elseif bEnableClick then
        visibility = UIConst.VisibilityOp.Visible
      end
      btnGet:SetVisibility(visibility)
      if bEnableClick then
        SafeBindClick(btnGet, self, self.OnGetButtonClicked)
      end
      if bCanClaim and sub == activeSub then
        self:BindGetButtonMouseEvents(btnGet)
      end
    end
  end
end

function M:BindGetButtonMouseEvents(btnGet)
  if not btnGet then
    return
  end
  SafeBindDelegate(btnGet.OnHovered, self, self.OnGetButtonHovered)
  SafeBindDelegate(btnGet.OnUnhovered, self, self.OnGetButtonUnhovered)
  SafeBindDelegate(btnGet.OnPressed, self, self.OnGetButtonPressed)
  SafeBindDelegate(btnGet.OnReleased, self, self.OnGetButtonReleased)
end

function M:UnBindGetButtonMouseEvents(btnGet)
  if not btnGet then
    return
  end
  SafeUnBindClick(btnGet, self, self.OnGetButtonClicked)
  SafeUnBindDelegate(btnGet.OnHovered, self, self.OnGetButtonHovered)
  SafeUnBindDelegate(btnGet.OnUnhovered, self, self.OnGetButtonUnhovered)
  SafeUnBindDelegate(btnGet.OnPressed, self, self.OnGetButtonPressed)
  SafeUnBindDelegate(btnGet.OnReleased, self, self.OnGetButtonReleased)
end

function M:PlayCurrentSubWidgetMouseAnimForce(stateName)
  local sub = self:GetActiveSubWidget()
  if not sub or not sub.PlayAnimation then
    return false
  end
  if sub.StopAllAnimations then
    sub:StopAllAnimations()
  end
  local animNames = self.MouseAnimNameMap[stateName] or {}
  for _, animName in ipairs(animNames) do
    local animObj = sub[animName]
    if animObj then
      sub:PlayAnimation(animObj)
      return true
    end
  end
  return false
end

function M:PlayCurrentSubWidgetMouseAnim(stateName)
  if not self.bClaimableMode then
    return false
  end
  return self:PlayCurrentSubWidgetMouseAnimForce(stateName)
end

function M:RefreshReddot(sub, bHasGot, bCanGet)
  if not sub or not sub.Reddot then
    return
  end
  local bShowReddot = not bHasGot and true == bCanGet
  sub.Reddot:SetVisibility(bShowReddot and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshComItems(rewardIds, bHasGot, bCanGet)
  if not rewardIds then
    return
  end
  local rewardContents = self:BuildRewardContents(rewardIds)
  if 0 == #rewardContents then
    return
  end
  local sub = self:GetActiveSubWidget()
  if not sub then
    return
  end
  local activeIndex = self.WS_Item and self.WS_Item:GetActiveWidgetIndex() or 0
  if 2 == activeIndex then
    self:FillComItem(sub.Com_Item01, rewardContents[1], bHasGot, bCanGet)
    self:FillComItem(sub.Com_Item02, rewardContents[2], bHasGot, bCanGet)
  else
    self:FillComItem(sub.Com_Item, rewardContents[1], bHasGot, bCanGet)
  end
end

function M:FillComItem(comItem, rewardContent, bHasGot, bCanGet)
  if not comItem or not rewardContent then
    Utils.ScreenPrint("[WBP_Activity_SkinCollect_Item_C] FillComItem missing comItem or rewardContent")
    return
  end
  local isGot = true == bHasGot
  local isCanGet = not isGot and true == bCanGet
  local isUnlocked = true == self.IsUnlocked
  local RewardObject = {}
  RewardObject.ParentWidget = self.ParentWidget or self
  RewardObject.Id = rewardContent.Id
  RewardObject.ItemType = rewardContent.ItemType
  RewardObject.Rarity = rewardContent.Rarity or 1
  RewardObject.Icon = rewardContent.Icon
  RewardObject.Count = rewardContent.Count
  local bClaimableMode = true == self.bClaimableMode
  RewardObject.IsShowDetails = not bClaimableMode
  RewardObject.bHasGot = isGot
  RewardObject.bCanGet = isCanGet
  RewardObject.HandleMouseDown = not bClaimableMode
  RewardObject.NotInteractive = bClaimableMode
  RewardObject.bIsResetFocus = self:ShouldUseSingleComItemFocusTarget()
  RewardObject.bDisableCommonClick = true
  RewardObject.OnMenuOpenChangedEvents = {
    Obj = self,
    Callback = self.OnRewardMenuOpenChanged
  }
  if isUnlocked then
    RewardObject.LockType = nil
  else
    RewardObject.LockType = 1
  end
  comItem:InitData(RewardObject)
  comItem:InitCompView()
end

function M:OnGetButtonClicked()
  if not self.Content or not self.ParentWidget then
    return
  end
  if not self.Content.bHasGot and self.Content.bCanGet and self.ParentWidget.TryClaimRewardByIndex then
    self:PlayCurrentSubWidgetMouseAnim("Click")
    self.ParentWidget:TryClaimRewardByIndex(self.Content.Index)
    return
  end
  if self:ShouldUseGamepadGetButtonForDetail() then
    self:OpenRewardTips()
  end
end

function M:OnGetButtonHovered()
  self:PlayCurrentSubWidgetMouseAnim("Hover")
end

function M:OnGetButtonUnhovered()
  local hasUnhoverAnim = self:PlayCurrentSubWidgetMouseAnim("UnHover")
  if not hasUnhoverAnim then
    self:PlayCurrentSubWidgetMouseAnim("Normal")
  end
end

function M:OnGetButtonPressed()
  self:PlayCurrentSubWidgetMouseAnim("Press")
end

function M:OnGetButtonReleased()
  self:PlayCurrentSubWidgetMouseAnim("Normal")
end

function M:OnRewardMenuOpenChanged(bIsOpen, content)
  self.bIsItemTipsOpened = true == bIsOpen
  if self.ParentWidget and self.ParentWidget.OnRewardTipsOpenChanged then
    self.ParentWidget:OnRewardTipsOpenChanged(bIsOpen, self)
  end
  local canShow = self.ParentWidget and self.ParentWidget.IsInListFocus and not self.bIsItemTipsOpened
  self:SetListFocusGamepadHintVisible(true == canShow)
  if not self.bIsItemTipsOpened then
    local focusTarget
    if self:HasMultipleComItems() then
      focusTarget = self.LastOpenedComItem or self:GetCurrentFocusedComItem()
    end
    focusTarget = focusTarget or self:BP_GetDesiredFocusTarget()
    if focusTarget and IsValid(focusTarget) and focusTarget.SetFocus then
      focusTarget:SetFocus()
    end
  end
end

function M:GetActiveComItems()
  local sub = self:GetActiveSubWidget()
  if not sub then
    return {}
  end
  local activeIndex = self.WS_Item and self.WS_Item:GetActiveWidgetIndex() or 0
  if 2 == activeIndex then
    return {
      sub.Com_Item01,
      sub.Com_Item02
    }
  end
  return {
    sub.Com_Item
  }
end

function M:HasMultipleComItems()
  local comItems = self:GetActiveComItems()
  return comItems[1] and comItems[2]
end

function M:ShouldUseSingleComItemFocusTarget()
  if self.bClaimableMode then
    return false
  end
  local comItems = self:GetActiveComItems()
  return comItems[1] and not comItems[2]
end

function M:GetCurrentFocusedComItem()
  local comItems = self:GetActiveComItems()
  for _, comItem in ipairs(comItems) do
    if comItem and IsValid(comItem) then
      if comItem.HasAnyUserFocus and comItem:HasAnyUserFocus() then
        return comItem
      end
      if comItem.HasFocusedDescendants and comItem:HasFocusedDescendants() then
        return comItem
      end
    end
  end
  return nil
end

function M:BP_GetDesiredFocusTarget()
  local subWidget = self:GetActiveSubWidget()
  if not subWidget then
    return self
  end
  local btnGet = subWidget.Btn_Get
  if self.bClaimableMode and btnGet and IsValid(btnGet) then
    return btnGet
  end
  if self:ShouldUseSingleComItemFocusTarget() then
    local comItems = self:GetActiveComItems()
    local firstItem = comItems[1]
    if firstItem and IsValid(firstItem) then
      return firstItem
    end
  end
  if btnGet and IsValid(btnGet) then
    return btnGet
  end
  return self
end

function M:UpdateInnerNavigation()
  local sub = self:GetActiveSubWidget()
  local btnGet = sub and sub.Btn_Get or nil
  local comItems = self:GetActiveComItems()
  local firstItem = comItems[1]
  local secondItem = comItems[2]
  local useSingleComItemFocusTarget = self:ShouldUseSingleComItemFocusTarget()
  if firstItem then
    if secondItem and IsValid(secondItem) then
      firstItem:SetNavigationRuleExplicit(EUINavigation.Right, secondItem)
    else
      firstItem:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    end
    firstItem:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    firstItem:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    firstItem:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    if useSingleComItemFocusTarget then
      firstItem:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Escape)
      firstItem:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Escape)
    end
  end
  if secondItem then
    if firstItem and IsValid(firstItem) then
      secondItem:SetNavigationRuleExplicit(EUINavigation.Left, firstItem)
    else
      secondItem:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    end
    secondItem:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    secondItem:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    secondItem:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  end
  if btnGet and IsValid(btnGet) then
    btnGet:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Escape)
    btnGet:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Escape)
    btnGet:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    btnGet:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  end
  if self and self.SetNavigationRuleBase then
    self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  end
end

function M:FocusFirstRewardComItem()
  local comItems = self:GetActiveComItems()
  local firstItem = comItems[1]
  if firstItem and IsValid(firstItem) and firstItem.SetFocus then
    firstItem:SetFocus()
    self.bComItemFocusMode = true
    self:RefreshGetButton()
    return true
  end
  return false
end

function M:FocusRewardItemSelf()
  if self.SetFocus then
    self:SetFocus()
    self.bComItemFocusMode = false
    self:RefreshGetButton()
    return true
  end
  return false
end

function M:IsRewardComItemFocused()
  if self:ShouldUseSingleComItemFocusTarget() then
    return false
  end
  return self.bComItemFocusMode == true or self:GetCurrentFocusedComItem() ~= nil
end

function M:MoveRewardComItemFocus(direction)
  local comItems = self:GetActiveComItems()
  if #comItems <= 1 then
    return false
  end
  local currentComItem = self:GetCurrentFocusedComItem()
  local targetComItem
  if direction and direction > 0 then
    targetComItem = currentComItem == comItems[1] and comItems[2] or nil
  elseif direction and direction < 0 then
    targetComItem = currentComItem == comItems[2] and comItems[1] or nil
  end
  if targetComItem and IsValid(targetComItem) and targetComItem.SetFocus then
    targetComItem:SetFocus()
    return true
  end
  return false
end

function M:OpenComItemTips(comItem)
  if not comItem or not comItem.OpenItemMenu then
    return false
  end
  local menuAnchor = comItem.Item and comItem.Item.ItemDetails_MenuAnchor
  local lastFocusWidget = self:HasMultipleComItems() and comItem or self:BP_GetDesiredFocusTarget()
  if menuAnchor and menuAnchor.SetLastFocusWidget then
    menuAnchor:SetLastFocusWidget(lastFocusWidget)
  end
  self.LastOpenedComItem = comItem
  comItem:OpenItemMenu()
  return true
end

function M:OpenFocusedRewardTips()
  return self:OpenComItemTips(self:GetCurrentFocusedComItem())
end

function M:OpenRewardTips()
  if self:HasMultipleComItems() then
    if not self:GetCurrentFocusedComItem() then
      return self:FocusFirstRewardComItem()
    end
    return self:OpenFocusedRewardTips()
  end
  local comItems = self:GetActiveComItems()
  for _, comItem in ipairs(comItems) do
    if self:OpenComItemTips(comItem) then
      return true
    end
  end
  return false
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  if not self.bClaimableMode then
    return
  end
  self:PlayCurrentSubWidgetMouseAnimForce("Hover")
end

function M:OnMouseLeave(MouseEvent)
  if not self.bClaimableMode then
    return
  end
  local played = self:PlayCurrentSubWidgetMouseAnimForce("UnHover")
  if not played then
    self:PlayCurrentSubWidgetMouseAnimForce("Normal")
  end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if not self.bClaimableMode then
    return
  end
  self:PlayCurrentSubWidgetMouseAnimForce("Press")
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if not self.bClaimableMode then
    return
  end
  self:PlayCurrentSubWidgetMouseAnimForce("Normal")
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.ParentWidget and self.ParentWidget.OnRewardItemFocused then
    self.ParentWidget:OnRewardItemFocused(self.ItemIndex, self)
  end
  if not self.bClaimableMode then
    return
  end
  self:PlayCurrentSubWidgetMouseAnimForce("Hover")
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self.bComItemFocusMode = false
  self.bListFocusGamepadHintVisible = false
  self:RefreshGetButton()
  self:RemoveTimer("SkinCollectItemUnHover")
  local itemIndex = self.ItemIndex
  local content = self.Content
  if not self.bClaimableMode then
    return
  end
  local played = self:PlayCurrentSubWidgetMouseAnimForce("UnHover")
  local sub = self:GetActiveSubWidget()
  local bHasGot = self.Content and self.Content.bHasGot
  local bCanGet = self.Content and self.Content.bCanGet
  if sub then
    if played then
      self:AddTimer(0.15, function()
        if itemIndex ~= self.ItemIndex then
          return
        end
        if content ~= self.Content then
          return
        end
        if sub and IsValid(sub) then
          self:PlaySubWidgetStateAnim(sub, bHasGot, bCanGet)
        end
      end, false, 0, "SkinCollectItemUnHover", true)
    else
      self:PlayCurrentSubWidgetMouseAnimForce("Normal")
      self:PlaySubWidgetStateAnim(sub, bHasGot, bCanGet)
    end
  end
end

function M:GetListFocusTargetWidget()
  return self:BP_GetDesiredFocusTarget()
end

function M:SetListFocusGamepadHintVisible(isVisible)
  local shouldShow = true == isVisible and UIUtils and UIUtils.IsGamepadInput and UIUtils.IsGamepadInput()
  if self.bIsItemTipsOpened then
    shouldShow = false
  end
  self.bListFocusGamepadHintVisible = true == shouldShow
  self:RefreshGetButton()
  local subWidget = self:GetActiveSubWidget()
  if not subWidget then
    return
  end
  if subWidget.Btn_Get then
    if subWidget.Btn_Get.SetDefaultGamePadImg then
      subWidget.Btn_Get:SetDefaultGamePadImg("A")
    end
    if subWidget.Btn_Get.SetGamePadIconVisible then
      subWidget.Btn_Get:SetGamePadIconVisible(shouldShow)
    end
  end
  SetKeyWidgetAVisible(subWidget.Key_GamePad, shouldShow)
  SetKeyWidgetAVisible(subWidget.Key_A, shouldShow)
  SetKeyWidgetAVisible(subWidget.Com_KeyImg, shouldShow)
  SetKeyWidgetAVisible(subWidget.Key_Confirm, shouldShow)
end

function M:PlaySubWidgetStateAnim(subWidget, bHasGot, bCanGet)
  if not subWidget or not subWidget.PlayAnimation then
    return
  end
  local stateName = bHasGot and "HasGot" or bCanGet and "CanGet" or "Locked"
  local animNames = self.StateAnimNameMap[stateName] or {}
  if subWidget.StopAllAnimations then
    subWidget:StopAllAnimations()
  end
  PlayFirstExistingAnimation(subWidget, animNames)
  if self.bHighlight then
    if subWidget.High then
      subWidget:PlayAnimation(subWidget.High)
    end
  elseif subWidget.Low then
    subWidget:PlayAnimation(subWidget.Low)
  end
end

function M:PlayUnlockAnim(bCanGet)
  local subWidget = self:GetActiveSubWidget()
  if not subWidget or not subWidget.PlayAnimation then
    return
  end
  local animName = bCanGet and "UnLock_Available" or "UnLock_Not_Done"
  local animObj = subWidget[animName]
  if not animObj then
    Utils.ScreenPrint(string.format("[WBP_Activity_SkinCollect_Item_C] Unlock anim not found, animName='%s'", animName))
    return
  end
  if subWidget.StopAllAnimations then
    subWidget:StopAllAnimations()
  end
  subWidget:PlayAnimation(animObj)
end

function M:GetActiveSubWidget()
  if not self.WS_Item then
    return nil
  end
  local idx = self.WS_Item:GetActiveWidgetIndex()
  if 0 == idx then
    return self.First
  elseif 1 == idx then
    return self.Single
  elseif 2 == idx then
    return self.Double
  end
  return nil
end

return M
