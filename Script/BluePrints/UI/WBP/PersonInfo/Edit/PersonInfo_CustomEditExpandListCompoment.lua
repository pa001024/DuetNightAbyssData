require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local UIUtils = require("Utils.UIUtils")
local Component = {}

function Component:Construct()
  self:_InitExpandListConfig()
end

function Component:_InitExpandListConfig()
  if self.bCustomEditExpandListConfigInited then
    return
  end
  self.Arr_OrderBy = {
    "UI_LEVEL_SELECT",
    "UI_RARITY_NAME"
  }
  self.CharacterOrderByDisplayNames = self.Arr_OrderBy
  self.MeleeOrderByDisplayNames = self.Arr_OrderBy
  self.RangedOrderByDisplayNames = self.Arr_OrderBy
  self.ActionOrderByDisplayNames = {
    "UI_RARITY_NAME"
  }
  self.CharacterOrderByAttrNames = {
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }
  self.MeleeOrderByAttrNames = self.CharacterOrderByAttrNames
  self.RangedOrderByAttrNames = self.CharacterOrderByAttrNames
  self.ActionOrderByAttrNames = {"Rarity", "UnitId"}
  self.CharacterFilterTags, self.CharacterFilterNames = UIUtils.GetAllElementTypes()
  self.CharacterFilterIcons = {}
  for _, Tag in ipairs(self.CharacterFilterTags) do
    self.CharacterFilterIcons[#self.CharacterFilterIcons + 1] = string.format("/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_%s.T_Armory_%s", Tag, Tag)
  end
  local MeleeTags, MeleeNames, RangedTags, RangedNames = UIUtils.GetAllWeaponTags()
  self.MeleeFilterTags = MeleeTags
  self.MeleeFilterNames = MeleeNames
  self.MeleeFilterIcons = {}
  for _, Tag in ipairs(self.MeleeFilterTags) do
    self.MeleeFilterIcons[#self.MeleeFilterIcons + 1] = DataMgr.WeaponTag[Tag] and DataMgr.WeaponTag[Tag].Icon or nil
  end
  self.RangedFilterTags = RangedTags
  self.RangedFilterNames = RangedNames
  self.RangedFilterIcons = {}
  for _, Tag in ipairs(self.RangedFilterTags) do
    self.RangedFilterIcons[#self.RangedFilterIcons + 1] = DataMgr.WeaponTag[Tag] and DataMgr.WeaponTag[Tag].Icon or nil
  end
  self.ActionFilterTags = {"Display", "Static"}
  self.ActionFilterNames = {
    "UI_PersonalPage_DynamicAction",
    "UI_PersonalPage_StaticAction"
  }
  self.ActionFilterIcons = {
    "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Personal_Action.T_Tab_Personal_Action",
    "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Personal_StaticAction.T_Tab_Personal_StaticAction"
  }
  self.IsListExpanded = false
  self.bCustomEditExpandListConfigInited = true
end

function Component:CreateFilters(InTags, InTexts, InIcons, ExcelWeaponTags)
  local Filters = {}
  for Index, Tag in ipairs(InTags or {}) do
    Filters[#Filters + 1] = {
      Tag = Tag,
      Text = InTexts and InTexts[Index] or nil,
      Icon = InIcons and InIcons[Index] or nil,
      bShowRecommend = ExcelWeaponTags and CommonUtils.HasValue(ExcelWeaponTags, Tag)
    }
  end
  return Filters
end

function Component:ExpandList(IsListExpanded)
  if not IsListExpanded then
    self.IsListExpanded = false
    return
  end
  self.IsListExpanded = true
  self:_InitExpandListConfig()
  self.CurrentListType = self:_ResolveCurrentListType()
  self.ExcelWeaponTags = nil
  self.CurrentItemContentsArray = self:_BuildExpandListItemContents(self.CurrentListType)
  local TypeConfig = self:_GetExpandListTypeConfig(self.CurrentListType)
  if TypeConfig.FilterTags then
    self.Filters = self:CreateFilters(TypeConfig.FilterTags, TypeConfig.FilterNames, TypeConfig.FilterIcons, self.ExcelWeaponTags)
  else
    self.Filters = nil
  end
  self:BindEvents(self, {
    OnListItemClicked = self.OnExpandListItemClicked,
    SortFuncion = self.SortItemContents,
    FilterFunction = self.FilterItemContents,
    OnListItemSelectionChanged = self.OnExpandListItemSelectionChanged
  })
  self:InitEditListView(self, {
    Filters = self.Filters,
    OrderByDisplayNames = TypeConfig.OrderByDisplayNames,
    SortType = CommonConst.DESC,
    ItemContents = self.CurrentItemContentsArray
  })
end

function Component:OnExpandListItemSelectionChanged(Content, IsSelected)
  if not IsSelected then
    return
  end
  if self.IsGamepadInput then
    self:OnExpandListItemClicked(Content)
  end
end

function Component:OnExpandListItemClicked(Content)
  if not self:_IsValidChooseContent(Content) then
    return
  end
  self:_DispatchExpandListItemClicked(Content)
end

function Component:SortItemContents(InOutContentArray, SortByIdx, SortType)
  local TypeConfig = self:_GetExpandListTypeConfig(self.CurrentListType)
  local OrderByAttrNames = TypeConfig.OrderByAttrNames
  local SortByAttrNames = {
    OrderByAttrNames[SortByIdx]
  }
  for Index, AttrName in ipairs(OrderByAttrNames) do
    if Index ~= SortByIdx then
      SortByAttrNames[#SortByAttrNames + 1] = AttrName
    end
  end
  ArmoryUtils:SortItemContents(InOutContentArray, SortByAttrNames, SortType, nil, self:_BuildSpecialChooseContentCmpFunc())
end

function Component:_BuildSpecialChooseContentCmpFunc()
  local ListType = self.CurrentListType
  return function(A, B)
    local AIsSpecial = false
    local BIsSpecial = false
    if "Melee" == ListType or "Ranged" == ListType then
      AIsSpecial = A and A.IsEmptyWeapon == true
      BIsSpecial = B.IsEmptyWeapon == true
    elseif "Action" == ListType then
      AIsSpecial = A and true == A.IsDefaultAction
      BIsSpecial = B and true == B.IsDefaultAction
    end
    if AIsSpecial ~= BIsSpecial then
      return AIsSpecial
    end
  end
end

function Component:FilterItemContents(InContentArray, FilterIdxes)
  return self:_FilterItemContents(InContentArray, FilterIdxes, self.CurrentListType)
end

function Component:_ResolveCurrentListType()
  if self.ChooseMode == "Character" then
    return "Character"
  end
  if self.ChooseMode == "Weapon" then
    return self.CurrentWeaponSubTab
  end
  if self.ChooseMode == "Action" then
    return "Action"
  end
  return "Character"
end

function Component:_GetExpandListTypeConfig(ListType)
  if "Character" == ListType then
    return {
      FilterTags = self.CharacterFilterTags,
      FilterNames = self.CharacterFilterNames,
      FilterIcons = self.CharacterFilterIcons,
      OrderByDisplayNames = self.CharacterOrderByDisplayNames,
      OrderByAttrNames = self.CharacterOrderByAttrNames
    }
  end
  if "Melee" == ListType then
    return {
      FilterTags = self.MeleeFilterTags,
      FilterNames = self.MeleeFilterNames,
      FilterIcons = self.MeleeFilterIcons,
      OrderByDisplayNames = self.MeleeOrderByDisplayNames,
      OrderByAttrNames = self.MeleeOrderByAttrNames
    }
  end
  if "Ranged" == ListType then
    return {
      FilterTags = self.RangedFilterTags,
      FilterNames = self.RangedFilterNames,
      FilterIcons = self.RangedFilterIcons,
      OrderByDisplayNames = self.RangedOrderByDisplayNames,
      OrderByAttrNames = self.RangedOrderByAttrNames
    }
  end
  if "Action" == ListType then
    return {
      FilterTags = self.ActionFilterTags,
      FilterNames = self.ActionFilterNames,
      FilterIcons = self.ActionFilterIcons,
      OrderByDisplayNames = self.ActionOrderByDisplayNames,
      OrderByAttrNames = self.ActionOrderByAttrNames
    }
  end
  error("Invalid custom edit choose list type: " .. tostring(ListType))
end

function Component:_BuildExpandListItemContents(ListType)
  local ItemContents = self:_BuildCurrentListContents(ListType)
  if "Character" == ListType then
    self:_RefreshCharacterChosenState(ItemContents)
  end
  return ItemContents
end

function Component:_DispatchExpandListItemClicked(Content)
  if self.CurrentListType == "Character" then
    self:CharacterMain_OnListItemClicked(Content)
    return
  end
  if self.CurrentListType == "Melee" or self.CurrentListType == "Ranged" then
    self:WeaponMain_OnListItemClicked(Content)
    return
  end
  if self.CurrentListType == "Action" then
    self:ActionMain_OnListItemClicked(Content)
    return
  end
  error("Invalid custom edit choose list type: " .. tostring(self.CurrentListType))
end

return Component
