local AppearanceUtils = require("BluePrints.UI.WBP.Appearance.AppearanceUtils")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = {}
local FocusStates = {
  List = "ExpandList",
  SpecialBtns = "SpecialBtns",
  Plan = "Plan"
}

function M:Construct()
  self.Btn_Selective:BindEventOnClicked(self, self.OnBtnSelectiveClicked)
  self.Selective_Listing.BP_OnAddedToFocusPath:Clear()
  self.Selective_Listing.BP_OnAddedToFocusPath:Add(self, self.OnExpandListAddedToFocusPath)
  self.Selective_Listing.BP_OnRemovedFromFocusPath:Clear()
  self.Selective_Listing.BP_OnRemovedFromFocusPath:Add(self, self.OnExpandListRemovedFromFocusPath)
  self.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    },
    Desc = GText("UI_CTL_ExpandList")
  })
end

function M:ResetMainTabStyle(IsListExpanded)
  if IsListExpanded then
    local TitleName = ""
    local Content = self.MainModel:GetCurrentTabSelectedContent()
    local RoleName = Content and Content.UnitName or ""
    if self.IsPreviewMode then
      TitleName = GText("UI_Preview_Switch") .. "/"
    end
    self.TitleName = TitleName .. RoleName
    self.Parent:UpdateMainTabs({})
    self.Parent.Com_Tab:UpdateTopTitle(self.TitleName)
    if not self.Parent.IsPC then
      self.Parent.Com_Tab.Panel_Tab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  else
    local TabConfig = self.MainModel:GetMainTabConfig()
    TabConfig.ForceHideTabs = #TabConfig.Tabs <= 1
    self.Parent.Com_Tab:Init(self.MainModel:GetMainTabConfig(), true)
    local CurMainTabIdx = self.MainModel:GetCurrentMainTabIdx()
    if CurMainTabIdx then
      self.Parent.Com_Tab:BindEventOnTabSelected(nil, nil)
      self.Parent.Com_Tab:SelectTab(CurMainTabIdx)
      self.Parent.Com_Tab:BindEventOnTabSelected(self.Parent, self.Parent.OnMainTabSelected)
    end
  end
end

function M:CreateFilterInfo()
end

function M:CreateFilters(InTags, InTexts, InIcons, ExcelWeaponTags)
  local Filters = {}
  for i, value in ipairs(InTags) do
    table.insert(Filters, {
      Tag = value,
      Text = InTexts[i],
      Icon = InIcons[i],
      bShowRecommend = ExcelWeaponTags and CommonUtils.HasValue(ExcelWeaponTags, value)
    })
  end
  return Filters
end

function M:OnBtnSelectiveClicked()
  if self.AssociatedList then
    self:ExpandList(not self.IsListExpanded)
  end
end

function M:SetCurSortType(SortType)
  local MainTabName = self.MainModel:GetCurrentMainTabName()
  rawset(self, MainTabName .. "SortType", SortType)
end

function M:GetCurSortType()
  local MainTabName = self.MainModel:GetCurrentMainTabName()
  return rawget(self, MainTabName .. "SortType")
end

function M:SetCurSortIdx(SortIdx)
  local MainTabName = self.MainModel:GetCurrentMainTabName()
  rawset(self, MainTabName .. "SortIdx", SortIdx)
end

function M:GetCurSortIdx()
  local MainTabName = self.MainModel:GetCurrentMainTabName()
  return rawget(self, MainTabName .. "SortIdx")
end

function M:ExpandList(bExpand)
  self.IsListExpanded = bExpand
  if self.IsListExpanded then
    self:CreateFilterInfo()
    local MainTabName = self.MainModel:GetCurrentMainTabName()
    self.Filters = self:CreateFilters(self[MainTabName .. "FilterTags"], self[MainTabName .. "FilterNames"], self[MainTabName .. "FilterIcons"], self.ExcelWeaponTags)
    local OrderByDisplayNames = self[MainTabName .. "OrderByDisplayNames"]
    self.Selective_Listing:Init(self, {
      Filters = self.Filters,
      OrderByDisplayNames = OrderByDisplayNames,
      SortIdx = self:GetCurSortIdx() or 1,
      SortType = self:GetCurSortType() or CommonConst.DESC,
      ItemContents = self.MainModel:GetCurrentTabAllContents()
    })
    self.Selective_Listing:BindEvents(self, {
      OnListItemClicked = self.OnExpandListItemClicked,
      OnListItemSelectionChanged = self.OnExpandListItemSelectionChanged,
      OnEntryInitialized = self.OnExpandListEntryInitialized,
      SortFuncion = self.ExpandList_SortItemContents,
      FilterFunction = self.FilterItemContents
    })
    self:ResetMainTabStyle(self.IsListExpanded)
    if self.WidgetToHideWhenExpandList then
      for key, value in pairs(self.WidgetToHideWhenExpandList) do
        value:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    end
    self.ParentTryClose = self.Parent.TryClose
    self.BeforeExpandList_InitKeySetting = self.InitKeySetting
    self.InitKeySetting = self.ExpandList_InitKeySetting
    if self.Parent.RemoveTabChangeKeyEvent then
      self.Parent:RemoveTabChangeKeyEvent()
    end
    self.BeforeExpandList_OnListItemAddedToFocusPath = self.OnListItemAddedToFocusPath
    self.BeforeExpandList_GetDesiredFocusTarget = self.GetDesiredFocusTarget
    self.GetDesiredFocusTarget = self.ExpandList_GetDesiredFocusTarget
    
    function self.OnListItemAddedToFocusPath()
    end
    
    function self.Parent.TryClose()
      self:ExpandList(false)
    end
    
    if MainTabName == AppearanceUtils.AppearanceMainTabNames.Char then
      self.Selective_Listing:SetEmptyStateText(GText("UI_Armory_Char_Empty"))
    elseif MainTabName == AppearanceUtils.AppearanceMainTabNames.Melee or MainTabName == AppearanceUtils.AppearanceMainTabNames.Ranged then
      self.Selective_Listing:SetEmptyStateText(GText("UI_Armory_Weapon_Empty"))
    else
      self.Selective_Listing:SetEmptyStateText("")
    end
    self.Selective_Listing:PlayInAnim()
    self.Selective_Listing:SetFocusToList()
  else
    self.Selective_Listing:PlayOutAnim()
    self:ResetMainTabStyle(self.IsListExpanded)
    if self.WidgetToHideWhenExpandList then
      for key, value in pairs(self.WidgetToHideWhenExpandList) do
        value:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      end
    end
    self.GetDesiredFocusTarget = self.BeforeExpandList_GetDesiredFocusTarget
    self.OnListItemAddedToFocusPath = self.BeforeExpandList_OnListItemAddedToFocusPath
    self.InitKeySetting = self.BeforeExpandList_InitKeySetting
    self.Parent.TryClose = self.ParentTryClose
    if self.Parent.AddTabChangeKeyEvent then
      self.Parent:AddTabChangeKeyEvent()
    end
    self:SetFocus()
  end
end

function M:OnExpandListItemClicked(Content)
  if not self.IsListExpanded then
    return
  end
  if not Content.Uuid then
    return
  end
  self:OnListItemClicked(Content)
end

function M:OnListItemClicked(Content)
  if Content == self.MainModel:GetSelectedCharContent() then
    return
  end
  if not self.IsListExpanded then
    return
  end
  self:ResetMainTabStyle(self.IsListExpanded)
end

function M:OnExpandListItemSelectionChanged(Content, IsSelected)
  if not UIUtils.IsGamepadInput() or not IsSelected then
    return
  end
  self:OnExpandListItemClicked(Content)
end

function M:ExpandList_SortItemContents(InOutContentArray, SortIdx, SortType)
  self:SetCurSortIdx(SortIdx)
  self:SetCurSortType(SortType)
  local MainTabName = self.MainModel:GetCurrentMainTabName()
  local FirtContent = self.MainModel:GetCurrentTabSelectedContent()
  local SortAttrNames
  local Func = self[MainTabName .. "_GetSortAttrNames"]
  if Func then
    SortAttrNames = Func(self, SortIdx)
  else
    SortAttrNames = self:Common_GetSortAttrNames(SortIdx)
  end
  ArmoryUtils:SortItemContents(InOutContentArray, SortAttrNames, SortType, FirtContent, function(a, b)
    if a.IsOwned or b.IsOwned then
      return ArmoryUtils.IsOwnedCmpFunc(a, b)
    end
    if a.Unlockable ~= b.Unlockable then
      if a.Unlockable then
        return true
      else
        return false
      end
    end
  end)
end

function M:Common_GetSortAttrNames(SortIdx)
  local MainTabName = self.MainModel:GetCurrentMainTabName()
  local OrderAttrNames = self[MainTabName .. "OrderByAttrNames"]
  local SortAttrNames = {
    OrderAttrNames[SortIdx]
  }
  for index, value in ipairs(OrderAttrNames) do
    if index ~= SortIdx then
      table.insert(SortAttrNames, value)
    end
  end
  return SortAttrNames
end

function M:FilterItemContents(InContentArray, FilterIdxes)
  local TabName = self.MainModel:GetCurrentMainTabName()
  local FilteredItems = {}
  local FilterFunc
  if TabName == AppearanceUtils.AppearanceMainTabNames.Char then
    function FilterFunc(FilterTag, Content)
      local Data = DataMgr.BattleChar[Content.UnitId]
      
      return FilterTag == Data.Attribute
    end
  elseif TabName == AppearanceUtils.AppearanceMainTabNames.Melee or TabName == AppearanceUtils.AppearanceMainTabNames.Ranged then
    function FilterFunc(FilterTag, Content)
      local Data = DataMgr.BattleWeapon[Content.UnitId]
      
      local Tags = Data and Data.WeaponTag
      if not Tags then
        return
      end
      for key, value in pairs(Tags) do
        if value == FilterTag then
          return true
        end
      end
    end
  end
  if FilterFunc then
    for _, Content in ipairs(InContentArray) do
      if FilterIdxes and next(FilterIdxes) then
        for _, Idx in ipairs(FilterIdxes) do
          local Tag = self[TabName .. "FilterTags"][Idx]
          if FilterFunc(Tag, Content) then
            table.insert(FilteredItems, Content)
            break
          end
        end
      else
        table.insert(FilteredItems, Content)
      end
    end
  end
  local bShowSubTile = false
  if FilterIdxes and 1 == #FilterIdxes then
    local Tag = self[TabName .. "FilterTags"][FilterIdxes[1]]
    if self.ExcelWeaponTags and CommonUtils.HasValue(self.ExcelWeaponTags, Tag) then
      bShowSubTile = true
    end
  end
  if bShowSubTile then
    self.Selective_Listing:SetSubTitle(GText("UI_Armory_CharExcelWeapon"))
  else
    self.Selective_Listing:SetSubTitle()
  end
  return FilteredItems
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Gamepad then
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
  else
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
  end
end

function M:InitKeySetting()
  local StateName = self.FSM:Peak().Name
  if self.WidgetSwitcher_MP:IsVisible() and StateName ~= FocusStates.Plan then
    self:AddKeyDownEvent(UIConst.GamePadKey.SpecialLeft, self.OnExpandListKeydown)
  end
end

function M:ExpandList_InitKeySetting()
  self:ClearAllKeyEvents()
  self:AddKeyDownEvent(UIConst.GamePadKey.SpecialLeft, self.OnExpandListKeydown)
  self:AddKeyDownEvent(UIConst.GamePadKey.SpecialRight, self.OnGamePadSpecialRightKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonRight, self.ExpandList_OnBackKeydown)
end

function M:ExpandList_GetDesiredFocusTarget()
  local State = self.FSM:Peak()
  local StateName = State.Name
  if StateName == FocusStates.SpecialBtns then
    return State.Widget
  end
  return self.Selective_Listing
end

function M:ExpandList_OnBackKeydown()
  if self.IsListExpanded then
    if self.FSM:Peak().Name == FocusStates.SpecialBtns and not self.IsExpandListInFocusPath then
      return UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.Selective_Listing), true
    else
      return self:OnExpandListKeydown()
    end
  end
end

function M:OnExpandListAddedToFocusPath()
  self.IsExpandListInFocusPath = true
  self:InitKeySetting()
end

function M:OnExpandListRemovedFromFocusPath()
  self.IsExpandListInFocusPath = false
end

function M:OnExpandListKeydown()
  self:ExpandList(not self.IsListExpanded)
  return UIUtils.Handled, true
end

function M:OnBackgroundClicked()
  if self.IsListExpanded then
    self:ExpandList(false)
  end
end

AssembleComponents(M)
return M
