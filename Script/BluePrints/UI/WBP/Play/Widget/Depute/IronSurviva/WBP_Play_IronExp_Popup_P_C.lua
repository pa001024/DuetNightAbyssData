require("UnLua")
local ItemUtils = require("Utils.ItemUtils")
local M = Class("BluePrints.UI.BP_UIState_C")
local GPAD_STATE_LIST = 1
local GPAD_STATE_SORT = 2
local GPAD_STATE_REWARD = 3
local GPAD_STATE_REWARD_INNER = 4

function M:Construct()
  M.Super.Construct(self)
  self:AddInputMethodChangedListen()
  self.Btn_Cancel:BindEventOnClicked(self, self.OnBtnCancelClicked)
  self.Btn_Start:BindEventOnClicked(self, self.OnBtnStartClicked)
  self.Btn_Cancel.AudioEventPath = "event:/ui/common/click_btn_cancel"
  self.Btn_Start.AudioEventPath = "event:/ui/common/click_btn_confirm"
  self.Btn_Cancel:SetText(GText("AFDayEvent_Photo_Cancel"))
  self.Btn_Start:SetText(GText("DUNGEONSINGLE"))
  self.Btn_Cancel:SetPCImg("Escape")
  self.Btn_Start:SetPCImg("SpaceBar")
  self.Btn_Cancel:SetDefaultGamePadImg("B")
  self.Btn_Start:SetDefaultGamePadImg("A")
  self.Btn_Start:ForbidBtn(true)
  self.SelectedTicketId = nil
  self.SelectedTicketLevel = 0
  self.SelectedTicketUid = nil
  self.AllTicketContents = {}
  self.GPadFocusState = GPAD_STATE_LIST
  self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
    local content = NewObject(UIUtils.GetCommonItemContentClass())
    content.ItemType = "EmptyGrid"
    content.StuffType = "EmptyGrid"
    content.ParentWidget = self
    return content
  end)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Sift:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Sift:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Sift:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Com_Sort:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:OnLoaded(Params)
  if not Params then
    return
  end
  self:SetFocus()
  self.DungeonId = Params.DungeonId
  self.StartCallback = Params.StartCallback
  self.ParentWidget = Params.ParentWidget
  local IronDungeonData = DataMgr.IronSurvivalDungeon[self.DungeonId]
  if not IronDungeonData then
    return
  end
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/shenjingluopanel_show", "IronExpShow", nil)
  self.Text_ListTitle:SetText(GText("UI_IronSurvival_ExpeditionReward"))
  self.Text_DetailTitle:SetText(GText("UI_IronSurvival_SelectExpeditionProof"))
  self.Text_DetailTitleTips:SetText(GText("UI_IronSurvival_UpgradeExpeditionProof"))
  self:InitRoundData(IronDungeonData)
  self:InitRewardList()
  self:InitCertificateList()
  self:InitSort()
  self:InitSift()
  self:AddTimer(0.016, function()
    self:RefreshCertificateList()
  end, false, 0, nil, true)
  self:RefreshBySelectedTicket()
  if IsValid(self.Com_MidKeyTips) then
    self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if UIUtils.IsGamepadInput() then
    self:GamepadFocusListFirst()
  end
end

function M:InitRoundData(IronDungeonData)
  local RewardView = IronDungeonData.IronRoundsRewardView or {}
  local keys = {}
  for roundKey in pairs(RewardView) do
    table.insert(keys, roundKey)
  end
  table.sort(keys)
  self.RoundKeyOrder = keys
  self.RoundLevelDisplay = {}
  for _, roundKey in ipairs(keys) do
    self.RoundLevelDisplay[roundKey] = "Lv." .. roundKey
  end
end

function M:InitRewardList()
  self.List_Reward:ClearListItems()
  self.RewardContents = {}
end

function M:InitCertificateList()
  self.AllTicketData = {}
  self.AllTicketContents = {}
  self.SelectedTicketId = nil
  self.SelectedTicketLevel = 0
  self.SelectedTicketUid = nil
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.IronSurvivalTicket then
    self:ShowNotOwnedState()
    return
  end
  local hasAny = false
  local firstOwnedId
  local firstOwnedLevel = 0
  local firstOwnedUid
  for _, ticket in pairs(Avatar.IronSurvivalTicket) do
    local ticketId = ticket.TicketId
    local level = ticket.Level
    if not ticketId or not level then
    else
      local ironTicketInfo = DataMgr.IronTicket[ticketId]
      if ironTicketInfo then
        hasAny = true
        table.insert(self.AllTicketData, {
          TicketId = ticketId,
          Level = tonumber(level) or ironTicketInfo.Level,
          Uid = ticket.Uid,
          Rarity = ironTicketInfo.Rarity or 1,
          Icon = ItemUtils.GetItemIconPath(ticketId, "IronTicket")
        })
      end
    end
  end
  table.sort(self.AllTicketData, function(a, b)
    return a.Level > b.Level
  end)
  if hasAny then
    firstOwnedId = self.AllTicketData[1].TicketId
    firstOwnedLevel = self.AllTicketData[1].Level
    firstOwnedUid = self.AllTicketData[1].Uid
  end
  if not hasAny then
    self:ShowNotOwnedState()
  else
    self.SelectedTicketId = firstOwnedId
    self.SelectedTicketLevel = firstOwnedLevel
    self.SelectedTicketUid = firstOwnedUid
    self.Btn_Start:ForbidBtn(false)
  end
  if self.List_Item.BP_OnItemSelectionChanged then
    self.List_Item.BP_OnItemSelectionChanged:Remove(self, self.OnListItemSelectionChanged)
    self.List_Item.BP_OnItemSelectionChanged:Add(self, self.OnListItemSelectionChanged)
  end
end

function M:OnListItemSelectionChanged(SelectItem, bIsSelect)
  if not bIsSelect then
    return
  end
  if not UIUtils.IsGamepadInput() then
    return
  end
  if not SelectItem or not SelectItem.TicketId then
    return
  end
  self:OnTicketSelected(SelectItem.TicketId, SelectItem.Level, SelectItem.Uid)
end

function M:InitSort()
  self.SortType = CommonConst.DESC
  self.Com_Sort:Init(self, {
    "UI_LEVEL_SELECT"
  }, CommonConst.DESC, {
    OnGetBackFocusWidget = function()
      self:GamepadFocusListFirst()
      return self.List_Item
    end
  })
end

function M:OnSortTypeChanged(sortType)
  self.SortType = sortType
  self:SortTicketContents()
  self:RefreshCertificateList()
end

function M:SortTicketContents()
  table.sort(self.AllTicketData, function(a, b)
    if self.SortType == CommonConst.ASC then
      return a.Level < b.Level
    else
      return a.Level > b.Level
    end
  end)
end

function M:RefreshCertificateList()
  if not self.AllTicketData or 0 == #self.AllTicketData then
    self:ShowNotOwnedState()
    return
  end
  local itemsToAdd = {}
  for _, data in ipairs(self.AllTicketData) do
    table.insert(itemsToAdd, data)
  end
  itemsToAdd = self:FilterTicketsBySift(itemsToAdd)
  self.AllTicketContents = {}
  self.List_Item:ClearListItems()
  if 0 == #itemsToAdd then
    self.SelectedTicketUid = nil
    self.SelectedTicketId = nil
    self.SelectedTicketLevel = 0
    self.Btn_Start:ForbidBtn(true)
    self:RefreshBySelectedTicket()
    self.List_Item:RequestFillEmptyContent()
    return
  end
  if self.SelectedTicketUid then
    local stillInRange = false
    for _, data in ipairs(itemsToAdd) do
      if data.Uid == self.SelectedTicketUid then
        stillInRange = true
        break
      end
    end
    if not stillInRange then
      self.SelectedTicketUid = nil
      self.SelectedTicketId = nil
      self.SelectedTicketLevel = 0
      self.Btn_Start:ForbidBtn(true)
      self:RefreshBySelectedTicket()
    end
  end
  self:RemoveTimer("StaggerList")
  local cols = 1
  local listSize = UIManager(self):GetWidgetRenderSize(self.List_Item)
  local entryW = self.List_Item:GetEntryWidth()
  if listSize and listSize.X > 0 and entryW and entryW > 0 then
    cols = math.max(1, math.floor(listSize.X / entryW))
  end
  local idx = 0
  local total = #itemsToAdd
  self:AddTimer(0.05, function()
    for _ = 1, cols do
      idx = idx + 1
      local data = itemsToAdd[idx]
      if not data then
        break
      end
      local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
      ItemContent.Id = data.TicketId
      ItemContent.StuffId = data.TicketId
      ItemContent.ItemType = "IronTicket"
      ItemContent.StuffType = "IronTicket"
      ItemContent.Rarity = data.Rarity
      ItemContent.Icon = data.Icon
      ItemContent.UIName = "StyleOfPlay"
      ItemContent.ParentWidget = self
      ItemContent.bShowNotHaveStyle = false
      ItemContent.Level = data.Level
      ItemContent.TicketId = data.TicketId
      ItemContent.Uid = data.Uid
      ItemContent.IsSelect = data.Uid == self.SelectedTicketUid
      
      function ItemContent.ClickCallback(ParentWidget, Content)
        ParentWidget:OnTicketSelected(Content.TicketId, Content.Level, Content.Uid)
        if UIUtils.IsGamepadInput() then
          ParentWidget:OnBtnStartClicked()
        end
      end
      
      table.insert(self.AllTicketContents, ItemContent)
      self.List_Item:AddItem(ItemContent)
      if 1 == idx and not self.SelectedTicketUid then
        self:OnTicketSelected(data.TicketId, data.Level, data.Uid)
      end
    end
    if idx >= total then
      self:RemoveTimer("StaggerList")
      self.List_Item:RequestFillEmptyContent()
      if UIUtils.IsGamepadInput() and self.GPadFocusState == GPAD_STATE_LIST then
        self.List_Item:NavigateToIndex(0)
        self.List_Item:SetFocus()
      end
    end
  end, true, 0, "StaggerList")
end

function M:InitSift()
  if not self.Sift then
    return
  end
  local selectionDatas = {}
  local selectionText = {}
  for i, roundKey in ipairs(self.RoundKeyOrder) do
    local nextKey = self.RoundKeyOrder[i + 1]
    local idx = #selectionDatas + 1
    selectionDatas[idx] = tostring(roundKey)
    if nextKey then
      selectionText[idx] = "Lv." .. roundKey .. "~" .. nextKey
    else
      selectionText[idx] = "Lv." .. roundKey
    end
  end
  local itemDatas = {
    {
      HasSelectAll = true,
      Id = 1,
      SelectionDatas = selectionDatas,
      SelectionField = {"Level"},
      SelectionText = selectionText,
      Title = "UI_LEVEL_SELECT"
    }
  }
  self.Sift:SetGamepadKeyVisibility(UIConst.VisibilityOp.Collapsed)
  self.Sift:SetItemDatas(itemDatas)
  self.Sift:BindEventOnSelectionsChanged(self, self.OnSiftSelectionsChanged)
  self.SiftFilterRanges = {}
end

function M:OnSiftSelectionsChanged(selectedItems, itemDatas)
  self.SiftFilterRanges = {}
  if selectedItems and next(selectedItems) then
    local dimSelections = selectedItems[1]
    local dimData = itemDatas and itemDatas[1]
    if dimSelections and dimData then
      for _, valueIdx in pairs(dimSelections) do
        local roundKey = tonumber(dimData.SelectionDatas[valueIdx])
        if roundKey then
          table.insert(self.SiftFilterRanges, roundKey)
        end
      end
    end
  end
  self:RefreshCertificateList()
end

function M:FilterTicketsBySift(tickets)
  if not self.SiftFilterRanges or 0 == #self.SiftFilterRanges then
    return tickets
  end
  local result = {}
  for _, ticket in ipairs(tickets) do
    for _, roundKey in ipairs(self.SiftFilterRanges) do
      local nextKey
      for i, rk in ipairs(self.RoundKeyOrder) do
        if tonumber(rk) == roundKey then
          nextKey = tonumber(self.RoundKeyOrder[i + 1])
          break
        end
      end
      local inRange = nextKey and roundKey <= ticket.Level and nextKey > ticket.Level or not nextKey and roundKey <= ticket.Level
      if inRange then
        table.insert(result, ticket)
        break
      end
    end
  end
  return result
end

function M:OnTicketSelected(ticketId, ticketLevel, uid)
  local isSame = self.SelectedTicketUid == uid
  self.SelectedTicketId = ticketId
  self.SelectedTicketLevel = ticketLevel
  self.SelectedTicketUid = uid
  self.Btn_Start:ForbidBtn(false)
  for _, content in ipairs(self.AllTicketContents) do
    local shouldSelect = content.Uid == uid
    if content.IsSelect ~= shouldSelect then
      content.IsSelect = shouldSelect
      if content.SelfWidget then
        content.SelfWidget:SetSelected(shouldSelect)
      end
    end
  end
  if not isSame then
    self:RefreshBySelectedTicket(true)
  end
end

function M:RefreshBySelectedTicket(playChangeAnim)
  local selectedLevel = self.SelectedTicketLevel or 0
  local unlockCount = 0
  for _, roundKey in ipairs(self.RoundKeyOrder) do
    if roundKey <= selectedLevel then
      unlockCount = unlockCount + 1
    end
  end
  local bottomRoundKey = unlockCount > 0 and self.RoundKeyOrder[unlockCount] or nil
  local playUnlockAnim = bottomRoundKey ~= self.PrevBottomRoundKey
  self.PrevBottomRoundKey = bottomRoundKey
  self:RefreshRewardListByTicket(selectedLevel, playUnlockAnim, playChangeAnim)
end

function M:RefreshRewardListByTicket(selectedLevel, playUnlockAnim, playChangeAnim)
  self.List_Reward:ClearListItems()
  self.RewardContents = {}
  self.FocusedRewardEntry = nil
  self.IsBlockingRewardInner = false
  local totalTiers = #self.RoundKeyOrder
  if 0 == totalTiers then
    return
  end
  local IronDungeonData = DataMgr.IronSurvivalDungeon[self.DungeonId]
  local RewardView = IronDungeonData and IronDungeonData.IronRoundsRewardView or {}
  local unlockCount = 0
  for _, roundKey in ipairs(self.RoundKeyOrder) do
    if roundKey <= selectedLevel then
      unlockCount = unlockCount + 1
    end
  end
  local bottomRoundKey = unlockCount > 0 and self.RoundKeyOrder[unlockCount] or nil
  self.RewardEmptyStateCount = 0
  if unlockCount > 0 then
    local lockedCount = totalTiers - unlockCount
    local maxDisplayRows = math.min(totalTiers, 4)
    local emptyCount = math.max(0, maxDisplayRows - lockedCount - 1)
    self.RewardEmptyStateCount = emptyCount
    for _ = 1, emptyCount do
      local emptyContent = NewObject(UIUtils.GetCommonItemContentClass())
      emptyContent.IsEmptyState = true
      emptyContent.ParentWidget = self
      emptyContent.RewardListIndex = self.List_Reward:GetNumItems()
      self.List_Reward:AddItem(emptyContent)
    end
  end
  local sortedDesc = {}
  for _, rk in ipairs(self.RoundKeyOrder) do
    table.insert(sortedDesc, rk)
  end
  table.sort(sortedDesc, function(a, b)
    return b < a
  end)
  
  local function buildRewardViewIds(targetKey)
    local ids = {}
    for _, rk in ipairs(self.RoundKeyOrder) do
      if rk <= targetKey and RewardView[rk] then
        table.insert(ids, RewardView[rk])
      end
    end
    return ids
  end
  
  for _, roundKey in ipairs(sortedDesc) do
    if roundKey > (bottomRoundKey or 0) then
      local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
      ItemContent.LvText = self.RoundLevelDisplay[roundKey] or "Lv." .. roundKey
      ItemContent.RewardViewId = RewardView[roundKey]
      ItemContent.RewardViewIds = buildRewardViewIds(roundKey)
      ItemContent.RoundKey = roundKey
      ItemContent.IsUnlocked = false
      ItemContent.PlayUnlockAnim = false
      ItemContent.IsEmptyState = false
      ItemContent.ParentWidget = self
      ItemContent.RewardListIndex = self.List_Reward:GetNumItems()
      table.insert(self.RewardContents, ItemContent)
      self.List_Reward:AddItem(ItemContent)
    end
  end
  if bottomRoundKey then
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    ItemContent.LvText = self.RoundLevelDisplay[bottomRoundKey] or "Lv." .. bottomRoundKey
    ItemContent.RewardViewId = RewardView[bottomRoundKey]
    ItemContent.RewardViewIds = buildRewardViewIds(bottomRoundKey)
    ItemContent.RoundKey = bottomRoundKey
    ItemContent.IsUnlocked = true
    ItemContent.PlayUnlockAnim = playUnlockAnim
    ItemContent.IsEmptyState = false
    ItemContent.ParentWidget = self
    ItemContent.RewardListIndex = self.List_Reward:GetNumItems()
    table.insert(self.RewardContents, ItemContent)
    self.List_Reward:AddItem(ItemContent)
  end
  self:RemoveTimer("UnlockAnim")
  local unlockDelay = 0.05
  if playChangeAnim and self.Change then
    self:StopAnimation(self.Change)
    self:PlayAnimation(self.Change)
  end
  if playUnlockAnim then
    self:AddTimer(unlockDelay, function()
      self:TriggerUnlockAnimation()
    end, false, 0, "UnlockAnim", true)
  end
  self:AddTimer(0.016, function()
    self.List_Reward:ScrollToBottom()
  end, false, 0, nil, true)
end

function M:TriggerUnlockAnimation()
  local numItems = self.List_Reward:GetNumItems()
  if numItems <= 0 then
    return
  end
  local entry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, numItems - 1)
  if not (entry and entry.Content) or not entry.Content.IsUnlocked then
    return
  end
  entry:PlayAnimation(entry.UnLock)
  if entry.Up_Glow then
    entry:PlayAnimation(entry.Up_Glow)
  end
end

function M:ShowNotOwnedState()
  self.SelectedTicketLevel = 0
  self.Btn_Start:ForbidBtn(true)
  self.List_Item:ClearListItems()
  local IronDungeonData = DataMgr.IronSurvivalDungeon[self.DungeonId]
  local firstTicketId
  if IronDungeonData and IronDungeonData.IronTicketId then
    firstTicketId = IronDungeonData.IronTicketId[1]
  end
  if firstTicketId and DataMgr.IronTicket[firstTicketId] then
    local ironTicketInfo = DataMgr.IronTicket[firstTicketId]
    local lockedContent = NewObject(UIUtils.GetCommonItemContentClass())
    lockedContent.Id = firstTicketId
    lockedContent.StuffId = firstTicketId
    lockedContent.ItemType = "IronTicket"
    lockedContent.StuffType = "IronTicket"
    lockedContent.Rarity = ironTicketInfo.Rarity or 1
    lockedContent.Icon = ItemUtils.GetItemIconPath(firstTicketId, "IronTicket")
    lockedContent.UIName = "StyleOfPlay"
    lockedContent.ParentWidget = self
    lockedContent.bShowNotHaveStyle = true
    lockedContent.JumpReturnCallBack = {
      CallBackObj = self,
      CallBack = function()
        self:Close()
      end
    }
    
    function lockedContent.ClickCallback(_, Content)
      local selfWidget = Content.SelfWidget
      if not selfWidget then
        return
      end
      selfWidget:OpenItemMenu()
    end
    
    self.List_Item:AddItem(lockedContent)
  end
  self.List_Item:RequestFillEmptyContent()
  self:RefreshBySelectedTicket()
end

function M:RefreshMidKeyTips()
  if not IsValid(self.Com_MidKeyTips) then
    return
  end
  if not UIUtils.IsGamepadInput() then
    self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local tips = {}
  if self.GPadFocusState == GPAD_STATE_LIST then
    table.insert(tips, {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "View"}
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
  end
  if #tips > 0 then
    self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Com_MidKeyTips:UpdateKeyInfo(tips)
  else
    self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetAllRewardInnerListsInteractive(interactive)
  self.IsBlockingRewardInner = not interactive
  if not self.RewardContents then
    return
  end
  local vis = interactive and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.HitTestInvisible
  local emptyCount = self.RewardEmptyStateCount or 0
  for i = 1, #self.RewardContents do
    local listIdx = emptyCount + (i - 1)
    local entry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, listIdx)
    if entry and entry.List_Item then
      entry.List_Item:SetVisibility(vis)
    end
  end
end

function M:SetRightSideGamepadHintsVisible(visible)
  if not UIUtils.IsGamepadInput() then
    return
  end
  local vis = visible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  self.Btn_Cancel:SetGamePadVisibility(vis)
  self.Btn_Start:SetGamePadVisibility(vis)
  if self.Com_Sort then
    self.Com_Sort:SetControllerKeyHidden(not visible)
  end
end

function M:GamepadFocusRewardUnlocked()
  if not self.SelectedTicketLevel or self.SelectedTicketLevel <= 0 then
    return
  end
  local numItems = self.List_Reward:GetNumItems()
  if numItems <= 0 then
    return
  end
  local unlockedIndex = numItems - 1
  local unlockedEntry = self:FocusRewardEntryByIndex(unlockedIndex)
  if unlockedEntry then
    self:SetAllRewardInnerListsInteractive(false)
    self.GPadFocusState = GPAD_STATE_REWARD
    self.FocusedRewardEntry = unlockedEntry
    unlockedEntry:SetFocus()
    self:RefreshMidKeyTips()
    self:SetRightSideGamepadHintsVisible(false)
  end
end

function M:GamepadFocusListFirst()
  if self.FocusedRewardEntry and self.FocusedRewardEntry.Normal then
    self.FocusedRewardEntry:PlayAnimation(self.FocusedRewardEntry.Normal)
  end
  self:SetAllRewardInnerListsInteractive(true)
  self.GPadFocusState = GPAD_STATE_LIST
  self.List_Item:SetFocus()
  self:RefreshMidKeyTips()
  self:SetRightSideGamepadHintsVisible(true)
end

function M:OnRewardEntryFocused(entry)
  if self.GPadFocusState == GPAD_STATE_REWARD or self.GPadFocusState == GPAD_STATE_REWARD_INNER then
    self.FocusedRewardEntry = entry
    if entry.Content and self.List_Reward then
      self.List_Reward:BP_ScrollItemIntoView(entry.Content)
    end
  end
end

function M:FocusRewardEntryByIndex(index)
  if not self.List_Reward then
    return nil
  end
  local numItems = self.List_Reward:GetNumItems()
  if not index or index < 0 or index >= numItems then
    return self.FocusedRewardEntry
  end
  local content = self.List_Reward:GetItemAt(index)
  if content and content.IsEmptyState then
    return self.FocusedRewardEntry
  end
  self.List_Reward:NavigateToIndex(index)
  if content then
    self.List_Reward:BP_ScrollItemIntoView(content)
  end
  local entry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, index)
  if entry then
    self.FocusedRewardEntry = entry
    return entry
  end
  return content and content.SelfWidget or self.FocusedRewardEntry
end

function M:GamepadFocusRewardInner()
  local focusedEntry = self.FocusedRewardEntry
  if not focusedEntry then
    local numItems = self.List_Reward:GetNumItems()
    if numItems > 0 then
      focusedEntry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, numItems - 1)
    end
  end
  if not focusedEntry or not focusedEntry.List_Item then
    return
  end
  focusedEntry.List_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  focusedEntry.List_Item:SetFocus()
  self.GPadFocusState = GPAD_STATE_REWARD_INNER
  self:RefreshMidKeyTips()
end

function M:GamepadExitRewardInner()
  self.GPadFocusState = GPAD_STATE_REWARD
  if self.FocusedRewardEntry and self.FocusedRewardEntry.List_Item then
    self.FocusedRewardEntry.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  if self.FocusedRewardEntry then
    self.FocusedRewardEntry:SetFocus()
  else
    local numItems = self.List_Reward:GetNumItems()
    if numItems > 0 and self.SelectedTicketLevel and self.SelectedTicketLevel > 0 then
      local unlockedEntry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, numItems - 1)
      if unlockedEntry then
        self.FocusedRewardEntry = unlockedEntry
        unlockedEntry:SetFocus()
      end
    end
  end
  self:RefreshMidKeyTips()
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_LeftThumbstick" == InKeyName then
    if self.GPadFocusState == GPAD_STATE_REWARD then
      self:GamepadFocusRewardInner()
    elseif self.GPadFocusState == GPAD_STATE_REWARD_INNER then
      self:GamepadExitRewardInner()
    else
      self.GPadFocusState = GPAD_STATE_SORT
      self.Com_Sort:SetFocus()
      self:RefreshMidKeyTips()
    end
    IsEventHandled = true
  elseif "Gamepad_Special_Left" == InKeyName then
    self:GamepadFocusRewardUnlocked()
    IsEventHandled = true
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if self.GPadFocusState == GPAD_STATE_REWARD_INNER then
      self:GamepadExitRewardInner()
    elseif self.GPadFocusState ~= GPAD_STATE_LIST then
      self:GamepadFocusListFirst()
    else
      self:OnBtnCancelClicked()
    end
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    self:OnBtnCancelClicked()
    IsEventHandled = true
  elseif "SpaceBar" == InKeyName then
    self:OnBtnStartClicked()
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

function M:OnBtnCancelClicked()
  self:Close()
  if IsValid(self.ParentWidget) and self.ParentWidget.FocusIronExpTitle then
    self.ParentWidget:FocusIronExpTitle()
  end
end

function M:OnBtnStartClicked()
  if not self.SelectedTicketUid then
    return
  end
  if type(self.StartCallback) == "function" then
    self.StartCallback(self.SelectedTicketUid, self.SelectedTicketLevel)
  end
  self:Close()
  if IsValid(self.ParentWidget) and self.ParentWidget.FocusIronExpTitle then
    self.ParentWidget:FocusIronExpTitle()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsGamepad = CurInputDevice == ECommonInputType.Gamepad
  if IsGamepad and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
    self:GamepadFocusListFirst()
  elseif not IsGamepad then
    if IsValid(self.Com_MidKeyTips) then
      self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.FocusedRewardEntry and self.FocusedRewardEntry.Normal then
      self.FocusedRewardEntry:PlayAnimation(self.FocusedRewardEntry.Normal)
    end
    self:SetAllRewardInnerListsInteractive(true)
    self.GPadFocusState = GPAD_STATE_LIST
  end
  self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:Destruct()
  self.Super.Destruct(self)
  AudioManager(self):SetEventSoundParam(self, "IronExpShow", {ToEnd = 1})
  self:RemoveTimer("StaggerList")
  self:RemoveTimer("UnlockAnim")
  if self.Sift then
    self.Sift:Close()
  end
end

return M
