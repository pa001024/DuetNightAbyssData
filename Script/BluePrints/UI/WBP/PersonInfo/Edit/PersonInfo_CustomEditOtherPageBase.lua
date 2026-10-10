require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Initialize(Initializer)
  self.EditRootController = nil
  self.ExpandedSectionName = nil
  self.LastGamepadFocusCenterY = nil
  self.PendingExpandSectionName = nil
  self.bPendingFocusListAfterExpand = false
  self.bSuppressGamepadFocusFollowScroll = false
end

function M:InitOtherPage(EditRootController)
  self:ApplyOtherPageContext(EditRootController)
  self:_InitSectionPanels()
  if self.SetIsLimitNavigationInside then
    self:SetIsLimitNavigationInside(true)
  end
end

function M:ApplyOtherPageContext(EditRootController)
  self.EditRootController = EditRootController
end

function M:SyncStickerSelectionToWorking()
  if self.EditModel_Stickers and self.EditModel_Stickers.SyncSelectionToWorkingSticker then
    self.EditModel_Stickers:SyncSelectionToWorkingSticker()
  end
end

function M:RefreshStickerSelectionVisual()
  if self.EditModel_Stickers and self.EditModel_Stickers.RefreshCurrentSelectionVisual then
    self.EditModel_Stickers:RefreshCurrentSelectionVisual()
  end
end

function M:SyncStickerSelectionToId(StickerId)
  if self.EditModel_Stickers and self.EditModel_Stickers.SyncSelectionToStickerId then
    self.EditModel_Stickers:SyncSelectionToStickerId(StickerId)
  end
end

function M:RefreshView()
  if self.EditModel_Filters and self.EditModel_Filters.RefreshView then
    self.EditModel_Filters:RefreshView()
  end
  if self.EditModel_Stickers and self.EditModel_Stickers.RefreshView then
    self.EditModel_Stickers:RefreshView()
  end
end

function M:OnEnterOtherTab()
  if self.EditModel_Filters and self.EditModel_Filters.SyncSelectionFromWorkingFilter then
    self.EditModel_Filters:SyncSelectionFromWorkingFilter()
  end
  self:_SetExpandedSection("Filter")
end

function M:FocusGamepadDefaultOtherItem()
  if self.ExpandedSectionName == "Sticker" and self.EditModel_Stickers and self.EditModel_Stickers.FocusGamepadSelectedStickerItem and self.EditModel_Stickers:FocusGamepadSelectedStickerItem() then
    return
  end
  if self.ExpandedSectionName ~= "Filter" then
    self:_SetExpandedSection("Filter")
  end
  if self.EditModel_Filters and self.EditModel_Filters.SyncSelectionFromWorkingFilter then
    self.EditModel_Filters:SyncSelectionFromWorkingFilter()
  end
  if self.EditModel_Filters and self.EditModel_Filters.FocusGamepadSelectedFilterItem and self.EditModel_Filters:FocusGamepadSelectedFilterItem() then
    return
  end
  self:SetFocus()
end

function M:PlayChangeListAnimation()
  if not self.Change_List then
    return
  end
  self:StopAnimation(self.Change_List)
  self:PlayAnimation(self.Change_List)
end

function M:RequestToggleSection(SectionName, bFocusListAfterExpand)
  if "Filter" ~= SectionName and "Sticker" ~= SectionName then
    return
  end
  if self.ExpandedSectionName == SectionName then
    self:_SetExpandedSection(nil, false)
    return
  end
  self:_SetExpandedSection(SectionName, true == bFocusListAfterExpand)
end

function M:OnSectionListCollapsed(CollapsedSectionName)
  if not IsValid(self) then
    return
  end
  local PendingSection = self.PendingExpandSectionName
  if not PendingSection then
    return
  end
  if CollapsedSectionName == PendingSection then
    return
  end
  local bFocusList = self.bPendingFocusListAfterExpand == true
  self.PendingExpandSectionName = nil
  self.bPendingFocusListAfterExpand = false
  self.ExpandedSectionName = PendingSection
  if "Filter" == PendingSection then
    if self.EditModel_Filters and self.EditModel_Filters.SetListExpanded then
      self.EditModel_Filters:SetListExpanded(true)
    end
  elseif "Sticker" == PendingSection and self.EditModel_Stickers and self.EditModel_Stickers.SetListExpanded then
    self.EditModel_Stickers:SetListExpanded(true)
  end
  if bFocusList then
    self:_FocusExpandedSectionList(PendingSection)
  end
end

function M:ScrollGamepadFocusedWidgetIntoView(Widget, bForceScroll)
  if not Widget or not IsValid(Widget) then
    return
  end
  if not bForceScroll and self.bSuppressGamepadFocusFollowScroll then
    return
  end
  local ScrollDetail = self:_GetDetailScrollBox()
  if not ScrollDetail or not ScrollDetail.ScrollWidgetIntoView then
    return
  end
  if not bForceScroll and not self:_ShouldFollowFocusByHalfView(ScrollDetail, Widget) then
    return
  end
  if bForceScroll then
    self.LastGamepadFocusCenterY = nil
    if Widget.ForceLayoutPrepass then
      Widget:ForceLayoutPrepass()
    end
    if ScrollDetail.ForceLayoutPrepass then
      ScrollDetail:ForceLayoutPrepass()
    end
    ScrollDetail:ScrollWidgetIntoView(Widget, false, UE4.EDescendantScrollDestination.Center)
    return
  end
  ScrollDetail:ScrollWidgetIntoView(Widget, true, UE4.EDescendantScrollDestination.Center)
end

function M:Destruct()
  self.EditRootController = nil
  self.ExpandedSectionName = nil
  self.LastGamepadFocusCenterY = nil
  self.PendingExpandSectionName = nil
  self.bPendingFocusListAfterExpand = nil
  self.bSuppressGamepadFocusFollowScroll = nil
end

function M:_InitSectionPanels()
  if self.EditModel_Filters and self.EditModel_Filters.InitFilterPanel then
    self.EditModel_Filters:InitFilterPanel(self.EditRootController, self)
  end
  if self.EditModel_Stickers and self.EditModel_Stickers.InitStickerPanel then
    self.EditModel_Stickers:InitStickerPanel(self.EditRootController, self)
  end
  self:RefreshView()
  self:_SetExpandedSection(nil, false)
end

function M:_SetExpandedSection(SectionName, bFocusListAfterExpand)
  bFocusListAfterExpand = true == bFocusListAfterExpand
  local PrevSection = self.ExpandedSectionName
  self.PendingExpandSectionName = nil
  self.bPendingFocusListAfterExpand = false
  if nil == SectionName then
    self.ExpandedSectionName = nil
    if self.EditModel_Filters and self.EditModel_Filters.SetListExpanded then
      self.EditModel_Filters:SetListExpanded(false)
    end
    if self.EditModel_Stickers and self.EditModel_Stickers.SetListExpanded then
      self.EditModel_Stickers:SetListExpanded(false)
    end
    return
  end
  if PrevSection == SectionName then
    self.ExpandedSectionName = SectionName
    if "Filter" == SectionName then
      if self.EditModel_Filters and self.EditModel_Filters.SetListExpanded then
        self.EditModel_Filters:SetListExpanded(true)
      end
      if self.EditModel_Stickers and self.EditModel_Stickers.SetListExpanded then
        self.EditModel_Stickers:SetListExpanded(false)
      end
    else
      if self.EditModel_Stickers and self.EditModel_Stickers.SetListExpanded then
        self.EditModel_Stickers:SetListExpanded(true)
      end
      if self.EditModel_Filters and self.EditModel_Filters.SetListExpanded then
        self.EditModel_Filters:SetListExpanded(false)
      end
    end
    if bFocusListAfterExpand then
      self:_FocusExpandedSectionList(SectionName)
    end
    return
  end
  if nil ~= PrevSection then
    self.ExpandedSectionName = nil
    self.PendingExpandSectionName = SectionName
    self.bPendingFocusListAfterExpand = bFocusListAfterExpand
    if "Filter" == PrevSection then
      if self.EditModel_Filters and self.EditModel_Filters.SetListExpanded then
        self.EditModel_Filters:SetListExpanded(false)
      end
    elseif self.EditModel_Stickers and self.EditModel_Stickers.SetListExpanded then
      self.EditModel_Stickers:SetListExpanded(false)
    end
    return
  end
  self.ExpandedSectionName = SectionName
  if self.EditModel_Filters and self.EditModel_Filters.SetListExpanded then
    self.EditModel_Filters:SetListExpanded("Filter" == SectionName)
  end
  if self.EditModel_Stickers and self.EditModel_Stickers.SetListExpanded then
    self.EditModel_Stickers:SetListExpanded("Sticker" == SectionName)
  end
  if bFocusListAfterExpand then
    self:_FocusExpandedSectionList(SectionName)
  end
end

function M:_FocusExpandedSectionList(SectionName)
  if "Filter" == SectionName then
    if self.EditModel_Filters and self.EditModel_Filters.FocusGamepadSelectedFilterItem then
      self.EditModel_Filters:FocusGamepadSelectedFilterItem(true)
    end
    return
  end
  if "Sticker" == SectionName and self.EditModel_Stickers and self.EditModel_Stickers.FocusGamepadSelectedStickerItem then
    self.EditModel_Stickers:FocusGamepadSelectedStickerItem(true)
  end
end

function M:_GetDetailScrollBox()
  if self.Scroll_Detail and self.Scroll_Detail.ScrollWidgetIntoView then
    return self.Scroll_Detail
  end
  local FiltersPanel = self.EditModel_Filters
  if not FiltersPanel or not FiltersPanel.GetParent then
    return nil
  end
  local DetailVerticalBox = FiltersPanel:GetParent()
  if not DetailVerticalBox or not DetailVerticalBox.GetParent then
    return nil
  end
  local ScrollDetail = DetailVerticalBox:GetParent()
  if ScrollDetail and ScrollDetail.ScrollWidgetIntoView then
    return ScrollDetail
  end
  return nil
end

function M:_ShouldFollowFocusByHalfView(ScrollDetail, Widget)
  if not ScrollDetail.GetCachedGeometry or not Widget.GetCachedGeometry then
    return true
  end
  local ScrollGeo = ScrollDetail:GetCachedGeometry()
  local WidgetGeo = Widget:GetCachedGeometry()
  local ScrollSize = UE4.USlateBlueprintLibrary.GetLocalSize(ScrollGeo)
  local WidgetSize = UE4.USlateBlueprintLibrary.GetLocalSize(WidgetGeo)
  if not (ScrollSize and WidgetSize) or (ScrollSize.Y or 0) <= 0 then
    return true
  end
  local WidgetTopAbs = UE4.USlateBlueprintLibrary.LocalToAbsolute(WidgetGeo, UE4.FVector2D(0, 0))
  local WidgetBottomAbs = UE4.USlateBlueprintLibrary.LocalToAbsolute(WidgetGeo, WidgetSize)
  local WidgetTopInScroll = UE4.USlateBlueprintLibrary.AbsoluteToLocal(ScrollGeo, WidgetTopAbs)
  local WidgetBottomInScroll = UE4.USlateBlueprintLibrary.AbsoluteToLocal(ScrollGeo, WidgetBottomAbs)
  local WidgetCenterY = (WidgetTopInScroll.Y + WidgetBottomInScroll.Y) * 0.5
  local MidY = ScrollSize.Y * 0.5
  local bOutOfView = WidgetTopInScroll.Y < 0 or WidgetBottomInScroll.Y > ScrollSize.Y
  local bPastHalf = false
  local PrevCenterY = self.LastGamepadFocusCenterY
  if nil == PrevCenterY then
    bPastHalf = WidgetCenterY > MidY
  elseif WidgetCenterY > PrevCenterY then
    bPastHalf = WidgetCenterY > MidY
  elseif WidgetCenterY < PrevCenterY then
    bPastHalf = WidgetCenterY < MidY
  end
  self.LastGamepadFocusCenterY = WidgetCenterY
  return bOutOfView or bPastHalf
end

return M
