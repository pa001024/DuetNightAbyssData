require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})
local STATE_LIST = 1
local STATE_ITEM_BROWSE = 2
local STATE_ITEM_TIPS = 3
local STATE_REWARD_TIPS = 4

local function GetKeyName(InKeyEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  return UE4.UFormulaFunctionLibrary.Key_GetFName(Key), Key
end

local function IsHorizontalNavigationKey(KeyName)
  return KeyName == UIConst.GamePadKey.DPadLeft or KeyName == UIConst.GamePadKey.DPadRight or KeyName == UIConst.GamePadKey.LeftStickLeft or KeyName == UIConst.GamePadKey.LeftStickRight
end

local function GetRecordData(Record)
  return Record and (Record.Props or Record)
end

local function MakeRecordTupleKey(Record)
  return table.concat({
    tostring(Record.TimeStamp),
    tostring(Record.Round),
    tostring(Record.PrizeIndex),
    tostring(Record.SelfSelectId)
  }, "\031")
end

function M:Construct()
  self.List_Item.OnCreateEmptyContent:Bind(self, self.CreateEmptyCategoryContent)
  self.List_Item.BP_OnItemSelectionChanged:Remove(self, self.OnCategorySelectionChanged)
  self.List_Item.BP_OnItemSelectionChanged:Add(self, self.OnCategorySelectionChanged)
  self.List_Item.BP_OnItemClicked:Remove(self, self.OnCategoryItemClicked)
  self.List_Item.BP_OnItemClicked:Add(self, self.OnCategoryItemClicked)
  self.List_Item.BP_OnEntryGenerated:Remove(self, self.OnCategoryEntryGenerated)
  self.List_Item.BP_OnEntryGenerated:Add(self, self.OnCategoryEntryGenerated)
  self.List_Item:SetControlScrollbarInside(true)
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
end

function M:Destruct()
  if IsValid(self.List_Item) then
    self.List_Item.OnCreateEmptyContent:Unbind()
    self.List_Item.BP_OnItemSelectionChanged:Remove(self, self.OnCategorySelectionChanged)
    self.List_Item.BP_OnItemClicked:Remove(self, self.OnCategoryItemClicked)
    self.List_Item.BP_OnEntryGenerated:Remove(self, self.OnCategoryEntryGenerated)
    self.List_Item:ClearListItems()
  end
  self.CategoryContents = nil
  self.CurrentCategoryContent = nil
end

function M:CreateEmptyCategoryContent()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Empty = true
  return Content
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  Params = Params or {}
  self.Params = Params
  self.PoolId = tonumber(Params.PoolId or Params.EventId or Params.ActivityId) or Params.PoolId or Params.EventId or Params.ActivityId
  self.State = STATE_LIST
  self.bGamepadMode = UIUtils.IsGamepadInput()
  self.ActionShortcutIndex = nil
  self.Text_Progress:SetText(GText("UI_LimitedPrizePool_CollectProgress"))
  self.Text_Reward:SetText(GText("UI_LimitedPrizePool_CollectReward2"))
  self:BuildCategoryContents()
  self:RefreshCategoryList()
end

function M:BuildClaimedPrizeSet(LimitPrizeData, Round)
  local TupleCounts = {}
  local ClaimedPrizeSet = {}
  for _, Record in ipairs(LimitPrizeData and LimitPrizeData.Record or {}) do
    local RecordData = GetRecordData(Record)
    if RecordData and RecordData.Round == Round then
      local TupleKey = MakeRecordTupleKey(RecordData)
      TupleCounts[TupleKey] = (TupleCounts[TupleKey] or 0) + 1
      if TupleCounts[TupleKey] >= 2 then
        ClaimedPrizeSet[RecordData.PrizeIndex] = true
      end
    end
  end
  return ClaimedPrizeSet
end

function M:IsItemOwned(Avatar, ItemType, ItemId)
  if not (Avatar and ItemType) or not ItemId then
    return false
  end
  local CheckFuncName = "Check" .. ItemType .. "Enough"
  local CheckFunc = Avatar[CheckFuncName]
  if not CheckFunc then
    DebugPrint("LimitedPrizePool collect reward: missing avatar check method", CheckFuncName)
    return false
  end
  local bSuccess, bOwned = pcall(CheckFunc, Avatar, {
    [ItemId] = 1
  })
  if not bSuccess then
    DebugPrint("LimitedPrizePool collect reward: avatar check failed", CheckFuncName, ItemId, bOwned)
    return false
  end
  return true == bOwned
end

function M:BuildCategoryContents()
  self.CategoryContents = {}
  self.CurrentRound = nil
  local PoolData = self.PoolId and DataMgr.LimitedPrizePool[self.PoolId]
  local Avatar = GWorld:GetAvatar()
  local LimitPrizeData = Avatar and self.PoolId and Avatar.LimitPrize and Avatar.LimitPrize[self.PoolId] or {}
  if not (PoolData and PoolData.ExtraItem) or not Avatar then
    return
  end
  local RoundCount = PoolData.LimitedPrizePoolId and #PoolData.LimitedPrizePoolId or 0
  if RoundCount <= 0 then
    return
  end
  local Round = math.min(math.max(LimitPrizeData.Round or 1, 1), RoundCount)
  local RoundId = PoolData.LimitedPrizePoolId[Round]
  local RoundData = RoundId and DataMgr.LimitedPrizeItem[RoundId]
  if not RoundData then
    return
  end
  self.CurrentRound = Round
  local ClaimedPrizeSet = self:BuildClaimedPrizeSet(LimitPrizeData, Round)
  local PrizeIndices = {}
  for RawPrizeIndex in pairs(PoolData.ExtraItem) do
    local PrizeIndex = tonumber(RawPrizeIndex)
    if PrizeIndex then
      table.insert(PrizeIndices, PrizeIndex)
    end
  end
  table.sort(PrizeIndices)
  for _, PrizeIndex in ipairs(PrizeIndices) do
    local ExtraInfo = PoolData.ExtraItem[PrizeIndex] or PoolData.ExtraItem[tostring(PrizeIndex)]
    local ItemTypeIndex = RoundData.Type and RoundData.Type[PrizeIndex]
    local ItemIds = RoundData.Id and RoundData.Id[PrizeIndex]
    local ItemCount = RoundData.Count and RoundData.Count[PrizeIndex]
    local RewardId = ExtraInfo and (ExtraInfo[1] or ExtraInfo.Id or ExtraInfo.ItemId)
    local RewardCount = ExtraInfo and (ExtraInfo[2] or ExtraInfo.Count or ExtraInfo.ItemCount)
    local ItemType = ItemTypeIndex and ItemUtils.GetItemType(ItemTypeIndex)
    if ItemType and ItemIds and #ItemIds > 0 and ItemCount and ItemCount > 0 and RewardId and RewardId > 0 and RewardCount and RewardCount > 0 then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Owner = self
      Content.Index = #self.CategoryContents + 1
      Content.PoolId = self.PoolId
      Content.Round = Round
      Content.PrizeIndex = PrizeIndex
      Content.ItemTypeIndex = ItemTypeIndex
      Content.ItemType = ItemType
      Content.ItemIds = {}
      Content.ItemOwnedStates = {}
      Content.OwnedCount = 0
      for _, ItemId in ipairs(ItemIds) do
        local bOwned = self:IsItemOwned(Avatar, ItemType, ItemId)
        table.insert(Content.ItemIds, ItemId)
        table.insert(Content.ItemOwnedStates, bOwned)
        if bOwned then
          Content.OwnedCount = Content.OwnedCount + 1
        end
      end
      Content.TotalCount = #Content.ItemIds
      Content.RewardId = RewardId
      Content.RewardCount = RewardCount
      Content.bRewardClaimed = true == ClaimedPrizeSet[PrizeIndex]
      table.insert(self.CategoryContents, Content)
    else
      DebugPrint("LimitedPrizePool collect reward: invalid category", self.PoolId, Round, PrizeIndex)
    end
  end
end

function M:RefreshCategoryList()
  self.List_Item:ClearListItems()
  for _, Content in ipairs(self.CategoryContents) do
    self.List_Item:AddItem(Content)
  end
  local bHasCategories = #self.CategoryContents > 0
  if self.Panel_List then
    self.Panel_List:SetVisibility(bHasCategories and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
  if self.Panel_Tip then
    self.Panel_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if not bHasCategories then
    self.CurrentCategoryContent = nil
    return
  end
  self.List_Item:RequestFillEmptyContent()
  self.CurrentCategoryContent = self.CategoryContents[1]
  self.List_Item:BP_SetSelectedItem(self.CurrentCategoryContent)
  self.List_Item:NavigateToIndex(0)
end

function M:OnCategorySelectionChanged(Content, bIsSelected)
  if not (bIsSelected and Content) or Content.Empty then
    return
  end
  self.CurrentCategoryContent = Content
  self:RefreshDisplayedEntries()
end

function M:OnCategoryEntryGenerated(Entry)
  if not IsValid(Entry) then
    return
  end
  if Entry.RefreshOwnerState then
    Entry:RefreshOwnerState()
  end
  if Entry.Content == self.CurrentCategoryContent and self.bGamepadMode and self.State == STATE_LIST then
    self.List_Item:BP_SetSelectedItem(self.CurrentCategoryContent)
  end
end

function M:OnCategoryItemClicked(Content)
  if not Content or Content.Empty then
    return
  end
  local Entry = self:GetCategoryEntry(Content)
  if IsValid(Entry) and Entry.ReleaseOuterMousePress then
    Entry:ReleaseOuterMousePress(true)
  end
end

function M:OnCategoryEntryFocused(Content)
  if not Content or Content.Empty or self:IsTipsState() then
    return
  end
  self.CurrentCategoryContent = Content
  self.List_Item:BP_SetSelectedItem(Content)
  self:RefreshDisplayedEntries()
end

function M:GetCategoryEntry(Content)
  Content = Content or self.CurrentCategoryContent
  if not Content then
    return nil
  end
  if IsValid(Content.Entry) then
    return Content.Entry
  end
  return UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, math.max(0, (Content.Index or 1) - 1))
end

function M:RefreshDisplayedEntries()
  if not IsValid(self.List_Item) then
    return
  end
  local Entries = self.List_Item:GetDisplayedEntryWidgets():ToTable()
  for _, Entry in ipairs(Entries) do
    if IsValid(Entry) and Entry.RefreshOwnerState then
      Entry:RefreshOwnerState()
    end
  end
end

function M:IsGamepadMode()
  return self.bGamepadMode == true
end

function M:IsListState()
  return self.State == STATE_LIST
end

function M:IsItemBrowseState()
  return self.State == STATE_ITEM_BROWSE
end

function M:IsItemTipsState()
  return self.State == STATE_ITEM_TIPS
end

function M:IsRewardTipsState()
  return self.State == STATE_REWARD_TIPS
end

function M:IsTipsState()
  return self:IsItemTipsState() or self:IsRewardTipsState()
end

function M:IsCurrentCategory(Content)
  return Content and Content == self.CurrentCategoryContent
end

function M:SetActionShortcut(KeyPath, Desc)
  if not self.Owner then
    return
  end
  local ShortcutParams = {
    KeyInfoList = {
      {Type = "Img", ImgShortPath = KeyPath}
    },
    Desc = Desc
  }
  if self.ActionShortcutIndex and self.Owner:GetGamepadShortcutByIndex(self.ActionShortcutIndex) then
    self.Owner:InitGamepadShortcut(ShortcutParams, self.ActionShortcutIndex)
  else
    self.ActionShortcutIndex = self:ShowGamepadShortcutBtn(ShortcutParams)
  end
  self:ShowGamepadShortcut(self.ActionShortcutIndex)
end

function M:RefreshBottomShortcuts()
  if not self.Owner then
    return
  end
  if not self.bGamepadMode then
    self:HideAllGamepadShortcut()
    self:ShowGamepadCloseBtn(false)
    self:SetGamepadBtnKeyVisibility(true)
    return
  end
  if self:IsTipsState() then
    self:HideAllGamepadShortcut()
    self:ShowGamepadCloseBtn(false)
    self:SetGamepadBtnKeyVisibility(false)
    return
  end
  self:ShowGamepadCloseBtn(true)
  if self.Owner.GamepadCloseBtnIndex then
    self:ShowGamepadShortcut(self.Owner.GamepadCloseBtnIndex)
  end
  if self:IsItemBrowseState() then
    self:SetActionShortcut(UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_Controller_CheckDetails"))
    self:ChangeCloseShortKeyText(GText("UI_Tips_Close"))
  else
    self:SetActionShortcut(UIConst.GamePadImgKey.LeftThumb, GText("UI_Controller_CheckItems"))
    self:ChangeCloseShortKeyText(GText("UI_Controller_Close"))
  end
  self:SetGamepadBtnKeyVisibility(true)
end

function M:RefreshStateView()
  self:RefreshBottomShortcuts()
  self:RefreshDisplayedEntries()
end

function M:FocusCurrentCategory()
  local Content = self.CurrentCategoryContent or self.CategoryContents[1]
  if not Content then
    return
  end
  self.CurrentCategoryContent = Content
  self.List_Item:BP_SetSelectedItem(Content)
  self.List_Item:NavigateToIndex(math.max(0, (Content.Index or 1) - 1))
  self:AddTimer(0.01, function()
    if not (IsValid(self) and self.bGamepadMode) or self.State ~= STATE_LIST then
      return
    end
    local Entry = self:GetCategoryEntry(Content)
    if IsValid(Entry) then
      Entry:SetFocus()
    elseif IsValid(self.List_Item) then
      self.List_Item:SetFocus()
    end
  end, false, 0, nil, true)
end

function M:HandleDialogFocused()
  if not self.bGamepadMode or not self.CurrentCategoryContent then
    return nil
  end
  return self:GetCategoryEntry(self.CurrentCategoryContent) or self.List_Item
end

function M:EnterItemBrowse(Content)
  if self.State ~= STATE_LIST then
    return false
  end
  Content = Content or self.CurrentCategoryContent
  if not Content then
    return false
  end
  self.CurrentCategoryContent = Content
  self.State = STATE_ITEM_BROWSE
  self:RefreshStateView()
  local Entry = self:GetCategoryEntry(Content)
  if IsValid(Entry) then
    Entry:EnterItemBrowse()
  else
    self.List_Item:NavigateToIndex(math.max(0, (Content.Index or 1) - 1))
    self:AddTimer(0.01, function()
      local CurrentEntry = self:GetCategoryEntry(Content)
      if IsValid(CurrentEntry) and self.State == STATE_ITEM_BROWSE then
        CurrentEntry:EnterItemBrowse()
      end
    end, false, 0, nil, true)
  end
  return true
end

function M:ExitItemBrowse(bRestoreFocus)
  if self.State ~= STATE_ITEM_BROWSE then
    return false
  end
  local Content = self.CurrentCategoryContent
  self.State = STATE_LIST
  local Entry = self:GetCategoryEntry(Content)
  if IsValid(Entry) then
    Entry:ExitItemBrowse()
  end
  self:RefreshStateView()
  if false ~= bRestoreFocus then
    self:FocusCurrentCategory()
  end
  return true
end

function M:OpenFocusedItemTips()
  if self.State ~= STATE_ITEM_BROWSE then
    return false
  end
  local Entry = self:GetCategoryEntry()
  if not IsValid(Entry) then
    return false
  end
  self.State = STATE_ITEM_TIPS
  self:RefreshStateView()
  if not Entry:OpenFocusedCollectItemTips() then
    self.State = STATE_ITEM_BROWSE
    self:RefreshStateView()
    return false
  end
  return true
end

function M:OpenRewardTips()
  if self.State ~= STATE_LIST then
    return false
  end
  local Entry = self:GetCategoryEntry()
  if not IsValid(Entry) then
    return false
  end
  self.State = STATE_REWARD_TIPS
  self:RefreshStateView()
  if not Entry:OpenRewardTips() then
    self.State = STATE_LIST
    self:RefreshStateView()
    return false
  end
  return true
end

function M:OnCollectItemMenuOpenChanged(CategoryContent, bIsOpen, ItemContent)
  if bIsOpen then
    if self.bGamepadMode then
      self.CurrentCategoryContent = CategoryContent
      self.State = STATE_ITEM_TIPS
      self:RefreshStateView()
    end
    return
  end
  if self.State ~= STATE_ITEM_TIPS then
    return
  end
  self.State = self.bGamepadMode and STATE_ITEM_BROWSE or STATE_LIST
  self:RefreshStateView()
  if self.bGamepadMode then
    local Entry = self:GetCategoryEntry(CategoryContent)
    if IsValid(Entry) then
      Entry:RestoreItemBrowseFocus(ItemContent)
    end
  end
end

function M:OnRewardMenuOpenChanged(CategoryContent, bIsOpen)
  if bIsOpen then
    if self.bGamepadMode then
      self.CurrentCategoryContent = CategoryContent
      self.State = STATE_REWARD_TIPS
      self:RefreshStateView()
    end
    return
  end
  if self.State ~= STATE_REWARD_TIPS then
    return
  end
  self.State = STATE_LIST
  self:RefreshStateView()
  if self.bGamepadMode then
    self:FocusCurrentCategory()
  end
end

function M:FindOpenedTipsState()
  for _, CategoryContent in ipairs(self.CategoryContents or {}) do
    if CategoryContent.RewardContent and CategoryContent.RewardContent.IsShowTips then
      return STATE_REWARD_TIPS, CategoryContent
    end
    for _, ItemContent in ipairs(CategoryContent.CollectItemContents or {}) do
      if ItemContent.IsShowTips then
        return STATE_ITEM_TIPS, CategoryContent
      end
    end
  end
  return nil, nil
end

function M:InitGamepadView()
  self.bGamepadMode = true
  local TipsState, CategoryContent = self:FindOpenedTipsState()
  if TipsState then
    self.State = TipsState
    self.CurrentCategoryContent = CategoryContent
  elseif self:IsTipsState() then
    self.State = STATE_LIST
  end
  self:RefreshStateView()
  if self.State == STATE_LIST then
    self:FocusCurrentCategory()
  elseif self.State == STATE_ITEM_BROWSE then
    local Entry = self:GetCategoryEntry()
    if IsValid(Entry) then
      Entry:RestoreItemBrowseFocus()
    end
  end
end

function M:InitKeyboardView()
  if self.State == STATE_ITEM_BROWSE then
    local Entry = self:GetCategoryEntry()
    self.State = STATE_LIST
    if IsValid(Entry) then
      Entry:ExitItemBrowse()
    end
  elseif not self:IsTipsState() then
    self.State = STATE_LIST
  end
  self.bGamepadMode = false
  self:RefreshStateView()
end

function M:HandleGamepadKey(KeyName)
  if self:IsTipsState() then
    return true
  end
  if self.State == STATE_ITEM_BROWSE then
    if KeyName == UIConst.GamePadKey.LeftThumb or KeyName == UIConst.GamePadKey.FaceButtonRight then
      return self:ExitItemBrowse(true)
    elseif KeyName == UIConst.GamePadKey.FaceButtonBottom then
      self:OpenFocusedItemTips()
      return true
    elseif IsHorizontalNavigationKey(KeyName) then
      return false
    end
    return true
  end
  if KeyName == UIConst.GamePadKey.LeftThumb then
    return self:EnterItemBrowse()
  elseif KeyName == UIConst.GamePadKey.FaceButtonTop then
    return self:OpenRewardTips()
  end
  return false
end

function M:OnContentPreviewKeyDown(MyGeometry, InKeyEvent)
  if not self.bGamepadMode or self:IsTipsState() then
    return false
  end
  local KeyName = GetKeyName(InKeyEvent)
  if self.State == STATE_ITEM_BROWSE and KeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:OpenFocusedItemTips()
    return true
  end
  return false
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  if not self.bGamepadMode then
    return false
  end
  local KeyName, Key = GetKeyName(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(Key) then
    return false
  end
  return self:HandleGamepadKey(KeyName)
end

return M
