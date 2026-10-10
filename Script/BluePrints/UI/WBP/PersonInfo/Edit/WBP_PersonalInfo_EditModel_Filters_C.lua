require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local SECTION_NAME = "Filter"
local NONE_FILTER_ENTRY_KEY = "__NONE_FILTER__"
local DEFAULT_FILTER_INTENSITY = 50
local FORBIDDEN_FILTER_INTENSITY = 100
local FILTER_ITEM_IN_STAGGER_INTERVAL = 0.015
local FILTER_ITEM_IN_STAGGER_TIMER_KEY = "FilterItemInStagger"

function M:Initialize(Initializer)
  self.EditRootController = nil
  self.OwnerOtherPage = nil
  self.FilterItemContents = {}
  self.ExpandedFilterId = nil
  self.bListExpanded = false
  self.bIsListOutPlaying = false
  self.IsBindingFinished = false
  self.IsFilterListEntryBound = false
  self.FilterItemInStaggerToken = 0
  self.bWaitingFilterItemIn = false
  self.FilterEntryReadyMap = {}
  self.bPendingForceScrollAfterListIn = false
end

function M:InitFilterPanel(EditRootController, OwnerOtherPage)
  self.EditRootController = EditRootController
  self.OwnerOtherPage = OwnerOtherPage
  self:_BindTitleEvents()
  self:_BindFilterListEntryInitialized()
  self:_ApplyListCollapsedImmediate()
  self:_PlayTitleNormal()
  if self.Text_Title then
    self.Text_Title:SetText(GText("UI_PersonalPage_Filter"))
  end
end

function M:RefreshView()
  if not self.EditRootController or not self.List_Filters then
    return
  end
  self:_CancelFilterItemInStagger()
  self.FilterItemContents = {}
  self.List_Filters:ClearListItems()
  local NoneContent = self:_BuildNoneFilterItemContent()
  self.FilterItemContents[#self.FilterItemContents + 1] = NoneContent
  self.List_Filters:AddItem(NoneContent)
  local FilterViewList = self.EditRootController:BuildFilterViewList() or {}
  for _, FilterViewData in ipairs(FilterViewList) do
    local Content = self:_BuildFilterItemContent(FilterViewData)
    self.FilterItemContents[#self.FilterItemContents + 1] = Content
    self.List_Filters:AddItem(Content)
  end
  self.ExpandedFilterId = self:_ResolveInitialSelectedFilterId(FilterViewList)
  self:_SyncDisplayedFilterItemExpand(true)
  if self.bListExpanded then
    self:_BeginFilterItemInCollect()
  end
end

function M:RequestToggleFilterItem(FilterId)
  local TargetId = FilterId
  if nil == TargetId then
    TargetId = NONE_FILTER_ENTRY_KEY
  end
  if self.ExpandedFilterId == TargetId then
    return
  end
  self.ExpandedFilterId = TargetId
  local Controller = self.EditRootController
  if Controller and Controller.CommitFilterSwitch then
    if nil == FilterId then
      Controller:CommitFilterSwitch(nil)
    else
      local Intensity = DEFAULT_FILTER_INTENSITY
      if self:_IsIntensityAdjustForbidden(FilterId) then
        Intensity = FORBIDDEN_FILTER_INTENSITY
      end
      Controller:CommitFilterSwitch(FilterId, Intensity)
    end
  end
  self:_SyncDisplayedFilterItemExpand(false)
  if Controller and Controller._RefreshRootCommonActionState then
    Controller:_RefreshRootCommonActionState()
  end
end

function M:GetSelectedFilterIntensity(FilterId)
  if nil == FilterId then
    return DEFAULT_FILTER_INTENSITY
  end
  if self:_IsIntensityAdjustForbidden(FilterId) then
    return FORBIDDEN_FILTER_INTENSITY
  end
  local Controller = self.EditRootController
  local FilterData = Controller and Controller.GetWorkingFilterData and Controller:GetWorkingFilterData() or nil
  if type(FilterData) == "table" then
    local WorkingId = FilterData.FilterId or FilterData.Id
    if WorkingId == FilterId and type(FilterData.Intensity) == "number" then
      return FilterData.Intensity
    end
  end
  return DEFAULT_FILTER_INTENSITY
end

function M:SyncSelectionFromWorkingFilter()
  local FilterViewList
  if self.EditRootController and self.EditRootController.BuildFilterViewList then
    FilterViewList = self.EditRootController:BuildFilterViewList()
  end
  self.ExpandedFilterId = self:_ResolveInitialSelectedFilterId(FilterViewList)
  self:_SyncDisplayedFilterItemExpand(true)
  self:_SyncSelectedFilterIntensityFromWorking()
end

function M:BeginFilterIntensityPreview()
  local Controller = self.EditRootController
  if Controller and Controller.BeginFilterIntensityPreview then
    Controller:BeginFilterIntensityPreview()
  end
end

function M:CommitFilterIntensityPreview()
  local Controller = self.EditRootController
  if Controller and Controller.CommitFilterIntensityPreview then
    Controller:CommitFilterIntensityPreview()
  end
end

function M:PreviewFilterIntensity(FilterId, Intensity)
  local Controller = self.EditRootController
  if Controller and Controller.PreviewFilterIntensity then
    Controller:PreviewFilterIntensity(FilterId, Intensity)
  end
end

function M:IsFilterEntrySelected(Content)
  if not Content or self.ExpandedFilterId == nil then
    return false
  end
  if nil == Content.FilterId then
    return self.ExpandedFilterId == NONE_FILTER_ENTRY_KEY
  end
  return self.ExpandedFilterId == Content.FilterId
end

function M:GetSelectedFilterContent()
  local TargetId = self.ExpandedFilterId
  if nil == TargetId then
    return nil
  end
  for _, Content in ipairs(self.FilterItemContents or {}) do
    if Content then
      if nil == Content.FilterId then
        if TargetId == NONE_FILTER_ENTRY_KEY then
          return Content
        end
      elseif Content.FilterId == TargetId then
        return Content
      end
    end
  end
  return nil
end

function M:FocusGamepadSelectedFilterItem(bForceScroll)
  if not self.List_Filters then
    return false
  end
  local TargetContent = self:GetSelectedFilterContent()
  TargetContent = TargetContent or self.FilterItemContents and self.FilterItemContents[1] or nil
  if not TargetContent then
    return false
  end
  if self.List_Filters.BP_SetSelectedItem then
    self.List_Filters:BP_SetSelectedItem(TargetContent)
  end
  local bListInPlaying = false
  if bForceScroll and self.List_In and self.IsAnimationPlaying then
    bListInPlaying = self:IsAnimationPlaying(self.List_In) == true
  end
  if bListInPlaying then
    self.bPendingForceScrollAfterListIn = true
    return true
  end
  if self.List_Filters.BP_NavigateToItem then
    self.List_Filters:BP_NavigateToItem(TargetContent)
  end
  if self.List_Filters.CancelScrollIntoView then
    self.List_Filters:CancelScrollIntoView()
  end
  local Entry = self:_FindDisplayedFilterEntry(TargetContent)
  local OwnerOtherPage = self.OwnerOtherPage
  if OwnerOtherPage then
    OwnerOtherPage.bSuppressGamepadFocusFollowScroll = true
  end
  local bFocused = Entry and Entry.FocusGamepadTitle and Entry:FocusGamepadTitle()
  if OwnerOtherPage then
    OwnerOtherPage.bSuppressGamepadFocusFollowScroll = false
  end
  if not bFocused then
    return false
  end
  if bForceScroll then
    if self.List_Filters.ForceLayoutPrepass then
      self.List_Filters:ForceLayoutPrepass()
    end
    self:ScrollGamepadFocusedWidgetIntoView(Entry, true)
  else
    self:ScrollGamepadFocusedWidgetIntoView(Entry, false)
  end
  return true
end

function M:ScrollGamepadFocusedWidgetIntoView(Widget, bForceScroll)
  if self.OwnerOtherPage and self.OwnerOtherPage.ScrollGamepadFocusedWidgetIntoView then
    self.OwnerOtherPage:ScrollGamepadFocusedWidgetIntoView(Widget, bForceScroll)
  end
end

function M:_FindDisplayedFilterEntry(TargetContent)
  if not (TargetContent and self.List_Filters) or not self.List_Filters.GetDisplayedEntryWidgets then
    return nil
  end
  local Entries = self.List_Filters:GetDisplayedEntryWidgets()
  if Entries and Entries.ToTable then
    Entries = Entries:ToTable()
  end
  for _, Entry in pairs(Entries or {}) do
    if Entry and Entry.Content == TargetContent then
      return Entry
    end
    if Entry and Entry.Content then
      local EntryFilterId = Entry.Content.FilterId
      local TargetFilterId = TargetContent.FilterId
      if nil == EntryFilterId and nil == TargetFilterId then
        return Entry
      end
      if nil ~= EntryFilterId and EntryFilterId == TargetFilterId then
        return Entry
      end
    end
  end
  return nil
end

function M:SetListExpanded(bExpanded)
  bExpanded = true == bExpanded
  if self.bListExpanded == bExpanded then
    return
  end
  self.bListExpanded = bExpanded
  if bExpanded then
    self:_PlayListIn()
    self:_SyncDisplayedFilterItemExpand(true)
  else
    self.bPendingForceScrollAfterListIn = false
    self:_CancelFilterItemInStagger()
    self:_SyncDisplayedFilterItemExpand(true)
    self:_PlayListOut()
  end
end

function M:IsListExpanded()
  return self.bListExpanded == true
end

function M:Destruct()
  self:_CancelFilterItemInStagger()
  self:_UnbindFilterListEntryInitialized()
  if self.CleanTimer then
    self:CleanTimer()
  end
  if self.List_In then
    self:UnbindAllFromAnimationFinished(self.List_In)
  end
  if self.List_Out then
    self:UnbindAllFromAnimationFinished(self.List_Out)
  end
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
  end
  self.EditRootController = nil
  self.OwnerOtherPage = nil
  self.FilterItemContents = nil
  self.ExpandedFilterId = nil
  self.bListExpanded = nil
  self.bIsListOutPlaying = nil
  self.IsBindingFinished = nil
  self.IsFilterListEntryBound = nil
  self.FilterItemInStaggerToken = nil
  self.bWaitingFilterItemIn = nil
  self.FilterEntryReadyMap = nil
  self.bPendingForceScrollAfterListIn = nil
end

function M:_BindTitleEvents()
  if self.IsBindingFinished or not self.Btn_Click then
    return
  end
  local Btn = self.Btn_Click
  Btn.OnClicked:Clear()
  Btn.OnClicked:Add(self, self.OnTitleClicked)
  Btn.OnHovered:Clear()
  Btn.OnHovered:Add(self, self.OnTitleHovered)
  Btn.OnUnhovered:Clear()
  Btn.OnUnhovered:Add(self, self.OnTitleUnhovered)
  Btn.OnPressed:Clear()
  Btn.OnPressed:Add(self, self.OnTitlePressed)
  self.IsBindingFinished = true
end

function M:_BindFilterListEntryInitialized()
  if not (not self.IsFilterListEntryBound and self.List_Filters) or not self.List_Filters.BP_OnEntryInitialized then
    return
  end
  self.List_Filters.BP_OnEntryInitialized:Remove(self, self.OnFilterEntryInitialized)
  self.List_Filters.BP_OnEntryInitialized:Add(self, self.OnFilterEntryInitialized)
  self.IsFilterListEntryBound = true
end

function M:_UnbindFilterListEntryInitialized()
  if not self.List_Filters or not self.List_Filters.BP_OnEntryInitialized then
    self.IsFilterListEntryBound = false
    return
  end
  self.List_Filters.BP_OnEntryInitialized:Remove(self, self.OnFilterEntryInitialized)
  self.IsFilterListEntryBound = false
end

function M:OnFilterEntryInitialized(Item, Widget)
  if not (self.bWaitingFilterItemIn and self.bListExpanded) or not Widget then
    return
  end
  self:_MarkFilterEntryReady(Item, Widget)
end

function M:OnTitleClicked()
  if UIUtils.IsGamepadInput() then
    if self.bListExpanded then
      if self.OwnerOtherPage and self.OwnerOtherPage.RequestToggleSection then
        self.OwnerOtherPage:RequestToggleSection(SECTION_NAME)
      else
        self:SetListExpanded(false)
      end
      return
    end
    if self.OwnerOtherPage and self.OwnerOtherPage.RequestToggleSection then
      self.OwnerOtherPage:RequestToggleSection(SECTION_NAME, true)
      return
    end
    self:SetListExpanded(true)
    self:FocusGamepadSelectedFilterItem(true)
    return
  end
  if not self.bListExpanded and self.Click then
    self:PlayAnimation(self.Click)
  end
  if self.OwnerOtherPage and self.OwnerOtherPage.RequestToggleSection then
    self.OwnerOtherPage:RequestToggleSection(SECTION_NAME)
  end
end

function M:OnTitleHovered()
  if self.bListExpanded then
    return
  end
  if self.Hover then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnTitleUnhovered()
  if self.bListExpanded then
    return
  end
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:BindToAnimationFinished(self.UnHover, {
      self,
      self._OnTitleUnHoverFinished
    })
    self:PlayAnimation(self.UnHover)
    return
  end
  self:_PlayTitleNormal()
end

function M:OnTitlePressed()
  if self.bListExpanded then
    return
  end
  if self.Press then
    self:PlayAnimation(self.Press)
  end
end

function M:_OnTitleUnHoverFinished()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
  end
  if self.bListExpanded then
    return
  end
  self:_PlayTitleNormal()
end

function M:_PlayTitleNormal()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:StopAnimation(self.UnHover)
  end
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function M:_PlayTitleClickHold()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:StopAnimation(self.UnHover)
  end
  if self.Click then
    self:PlayAnimation(self.Click)
  end
end

function M:_PlayListIn()
  self.bIsListOutPlaying = false
  if self.List_Out then
    self:UnbindAllFromAnimationFinished(self.List_Out)
    self:StopAnimation(self.List_Out)
  end
  self:_PlayTitleClickHold()
  if self.List_Filters then
    self.List_Filters:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if self.List_In then
    self:StopAnimation(self.List_In)
    self:UnbindAllFromAnimationFinished(self.List_In)
    self:BindToAnimationFinished(self.List_In, {
      self,
      self._OnListInFinished
    })
    self:PlayAnimation(self.List_In, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, false)
  end
  self:_BeginFilterItemInCollect()
end

function M:_OnListInFinished()
  if not IsValid(self) then
    return
  end
  if self.List_In then
    self:UnbindAllFromAnimationFinished(self.List_In)
    self:StopAnimation(self.List_In)
  end
  if not self.bPendingForceScrollAfterListIn then
    return
  end
  self.bPendingForceScrollAfterListIn = false
  if not self.bListExpanded then
    return
  end
  self:FocusGamepadSelectedFilterItem(true)
end

function M:_PlayListOut()
  self:_CancelFilterItemInStagger()
  if self.List_In then
    self:UnbindAllFromAnimationFinished(self.List_In)
    self:StopAnimation(self.List_In)
  end
  if not self.List_Out then
    self:_ApplyListCollapsedImmediate()
    self:_PlayTitleNormal()
    self:_NotifyOwnerSectionCollapsed()
    return
  end
  if self.bIsListOutPlaying then
    return
  end
  self.bIsListOutPlaying = true
  self:UnbindAllFromAnimationFinished(self.List_Out)
  self:BindToAnimationFinished(self.List_Out, {
    self,
    self._OnListOutFinished
  })
  self:PlayAnimation(self.List_Out, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, false)
end

function M:_OnListOutFinished()
  if not IsValid(self) then
    return
  end
  self.bIsListOutPlaying = false
  if self.bListExpanded then
    return
  end
  self:_ApplyListCollapsedImmediate()
  self:_PlayTitleNormal()
  self:_NotifyOwnerSectionCollapsed()
end

function M:_NotifyOwnerSectionCollapsed()
  if not IsValid(self) then
    return
  end
  local OwnerOtherPage = self.OwnerOtherPage
  if not OwnerOtherPage or not IsValid(OwnerOtherPage) then
    return
  end
  if OwnerOtherPage.OnSectionListCollapsed then
    OwnerOtherPage:OnSectionListCollapsed(SECTION_NAME)
  end
end

function M:_ApplyListCollapsedImmediate()
  if self.List_Filters then
    self.List_Filters:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:_SyncDisplayedFilterItemExpand(bSilent)
  if not self.List_Filters or not self.List_Filters.GetDisplayedEntryWidgets then
    return
  end
  local Entries = self.List_Filters:GetDisplayedEntryWidgets()
  if Entries and Entries.ToTable then
    Entries = Entries:ToTable()
  end
  if not Entries then
    return
  end
  for _, Entry in pairs(Entries) do
    if Entry then
      local bExpanded = self:IsFilterEntrySelected(Entry.Content)
      if Entry.SetSliderExpanded then
        Entry:SetSliderExpanded(true == bExpanded, true == bSilent)
      end
    end
  end
end

function M:_CancelFilterItemInStagger()
  self.FilterItemInStaggerToken = (self.FilterItemInStaggerToken or 0) + 1
  self.bWaitingFilterItemIn = false
  self.FilterEntryReadyMap = {}
  if self.RemoveTimer then
    self:RemoveTimer(FILTER_ITEM_IN_STAGGER_TIMER_KEY)
  end
end

function M:_BeginFilterItemInCollect()
  if not self.bListExpanded then
    return
  end
  self:_CancelFilterItemInStagger()
  self.bWaitingFilterItemIn = true
  self.FilterEntryReadyMap = {}
  if self.List_Filters and self.List_Filters.GetDisplayedEntryWidgets then
    local DisplayedEntries = self.List_Filters:GetDisplayedEntryWidgets()
    if DisplayedEntries and DisplayedEntries.ToTable then
      DisplayedEntries = DisplayedEntries:ToTable() or {}
    end
    for _, Entry in pairs(DisplayedEntries or {}) do
      if Entry then
        self:_MarkFilterEntryReady(Entry.Content, Entry)
      end
    end
  end
  self:_TryStartFilterItemInStagger()
end

function M:_MarkFilterEntryReady(Item, Widget)
  if not Widget or not IsValid(Widget) then
    return
  end
  local Content = Item or Widget.Content
  local Key = NONE_FILTER_ENTRY_KEY
  if Content and Content.FilterId ~= nil then
    Key = Content.FilterId
  end
  local ReadyMap = self.FilterEntryReadyMap
  if not ReadyMap then
    ReadyMap = {}
    self.FilterEntryReadyMap = ReadyMap
  end
  if ReadyMap[Key] then
    return
  end
  if Widget.PrepareEntryIn then
    Widget:PrepareEntryIn()
  end
  ReadyMap[Key] = Widget
  self:_TryStartFilterItemInStagger()
end

function M:_TryStartFilterItemInStagger()
  if not self.bWaitingFilterItemIn or not self.bListExpanded then
    return
  end
  local ExpectedCount = self:_GetExpectedFilterEntryCount()
  if ExpectedCount <= 0 then
    return
  end
  local ReadyCount = 0
  for _ in pairs(self.FilterEntryReadyMap or {}) do
    ReadyCount = ReadyCount + 1
  end
  if ExpectedCount > ReadyCount then
    return
  end
  self:_StartFilterItemInStagger()
end

function M:_GetExpectedFilterEntryCount()
  if self.List_Filters and self.List_Filters.GetNumItems then
    local NumItems = self.List_Filters:GetNumItems()
    if NumItems and NumItems > 0 then
      return NumItems
    end
  end
  return #(self.FilterItemContents or {})
end

function M:_StartFilterItemInStagger()
  if not self.bListExpanded or not self.AddTimer then
    return
  end
  self.bWaitingFilterItemIn = false
  local ReadyMap = self.FilterEntryReadyMap or {}
  local EntryList = {}
  for _, Content in ipairs(self.FilterItemContents or {}) do
    local Key = NONE_FILTER_ENTRY_KEY
    if Content and Content.FilterId ~= nil then
      Key = Content.FilterId
    end
    local Entry = ReadyMap[Key]
    if Entry and IsValid(Entry) then
      EntryList[#EntryList + 1] = Entry
    end
  end
  if 0 == #EntryList then
    return
  end
  local StaggerToken = self.FilterItemInStaggerToken
  local PlayIndex = 0
  
  local function PlayNextFilterItemIn()
    if not IsValid(self) or self.FilterItemInStaggerToken ~= StaggerToken or not self.bListExpanded then
      return false
    end
    PlayIndex = PlayIndex + 1
    local Entry = EntryList[PlayIndex]
    if Entry and IsValid(Entry) and Entry.PlayEntryIn then
      Entry:PlayEntryIn()
    end
    return PlayIndex < #EntryList
  end
  
  if not PlayNextFilterItemIn() then
    return
  end
  self:AddTimer(FILTER_ITEM_IN_STAGGER_INTERVAL, function()
    if not PlayNextFilterItemIn() then
      self:RemoveTimer(FILTER_ITEM_IN_STAGGER_TIMER_KEY)
    end
  end, true, 0, FILTER_ITEM_IN_STAGGER_TIMER_KEY, true)
end

function M:_BuildNoneFilterItemContent()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.FilterId = nil
  Content.Name = "无"
  Content.Icon = nil
  Content.FilterPath = nil
  Content.FilterData = nil
  Content.IsSelected = false
  Content.OwnerPage = self
  return Content
end

function M:_ResolveInitialSelectedFilterId(FilterViewList)
  local FilterData
  if self.EditRootController and self.EditRootController.GetWorkingFilterData then
    FilterData = self.EditRootController:GetWorkingFilterData()
  end
  local FilterId
  if type(FilterData) == "table" then
    FilterId = FilterData.FilterId or FilterData.Id
  elseif nil ~= FilterData then
    FilterId = FilterData
  end
  if nil == FilterId then
    return NONE_FILTER_ENTRY_KEY
  end
  for _, FilterViewData in ipairs(FilterViewList or {}) do
    if FilterViewData and FilterViewData.FilterId == FilterId then
      return FilterId
    end
  end
  return NONE_FILTER_ENTRY_KEY
end

function M:_SyncSelectedFilterIntensityFromWorking()
  if not self.List_Filters or not self.List_Filters.GetDisplayedEntryWidgets then
    return
  end
  local Entries = self.List_Filters:GetDisplayedEntryWidgets()
  if Entries and Entries.ToTable then
    Entries = Entries:ToTable()
  end
  if not Entries then
    return
  end
  for _, Entry in pairs(Entries) do
    if Entry and self:IsFilterEntrySelected(Entry.Content) and Entry.Content and Entry.Content.FilterId ~= nil then
      local Intensity = self:GetSelectedFilterIntensity(Entry.Content.FilterId)
      if Entry.SetFilterIntensityPresentation then
        Entry:SetFilterIntensityPresentation(Intensity)
      end
    end
  end
end

function M:_IsIntensityAdjustForbidden(FilterId)
  if nil == FilterId then
    return false
  end
  local FilterConfigTable = DataMgr and DataMgr.CustomFilter or nil
  local FilterConfig = FilterConfigTable and FilterConfigTable[FilterId] or nil
  return nil ~= FilterConfig and FilterConfig.ForbidIntensityAdjust == true
end

function M:_BuildFilterItemContent(FilterViewData)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.FilterId = FilterViewData.FilterId
  Content.Name = FilterViewData.Name
  Content.Icon = FilterViewData.Icon
  Content.FilterPath = FilterViewData.FilterPath
  Content.FilterData = FilterViewData
  Content.IsSelected = FilterViewData.IsSelected == true
  Content.ForbidIntensityAdjust = true == FilterViewData.ForbidIntensityAdjust
  Content.OwnerPage = self
  return Content
end

return M
