require("UnLua")
local Component = {}
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local UIUtils = require("Utils.UIUtils")
Component.ESlotName = {
  Char = 1,
  MeleeWeapon = 2,
  RangedWeapon = 3,
  Phantom1 = 4,
  PhantomWeapon1 = 5,
  Phantom2 = 6,
  PhantomWeapon2 = 7,
  Pet = 8,
  Null = 0
}
Component.SlotName2Type = {
  [Component.ESlotName.Char] = "Char",
  [Component.ESlotName.Pet] = "Pet",
  [Component.ESlotName.RangedWeapon] = "Ranged",
  [Component.ESlotName.MeleeWeapon] = "Melee",
  [Component.ESlotName.Phantom1] = "Char",
  [Component.ESlotName.PhantomWeapon1] = "Weapon",
  [Component.ESlotName.Phantom2] = "Char",
  [Component.ESlotName.PhantomWeapon2] = "Weapon"
}
Component.SlotType2DataType = {
  Char = "Char",
  Pet = "Pet",
  Weapon = "Weapon",
  Ranged = "Weapon",
  Melee = "Weapon"
}
local NullUUid = CommonConst.AbyssTeamNoChar
local NullUnitId = CommonConst.AbyssTeamNoPet

function Component:InitTeamSelect(Slots, List_Select, Sort, EMListView_Filter, ItemDetailWidget, Pos_Tip, TrialData)
  self.Slots = Slots or {}
  self.List_Select = List_Select
  self.Sort = Sort
  self.EMListView_Filter = EMListView_Filter
  self.ItemDetailWidget = ItemDetailWidget
  self.Pos_Tip = Pos_Tip
  self.TrialData = TrialData or {}
  if not self.TrialData.ShowOwned then
    self.TrialData.ShowOwned = {
      Chars = true,
      Weapons = true,
      Pets = true
    }
  else
    self.TrialData.ShowOwned.Chars = self.TrialData.ShowOwned.Chars ~= false
    self.TrialData.ShowOwned.Weapons = self.TrialData.ShowOwned.Weapons ~= false
    self.TrialData.ShowOwned.Pets = self.TrialData.ShowOwned.Pets ~= false
  end
  self.CurSlotName = Component.ESlotName.Null
  self.CurSlotType = ""
  self.CurWeaponType = "Melee"
  self.Uuid2SlotMap = {}
  self.Saved = true
  self.bListEmpty = false
  self.SelectedContent = nil
  self:InitSelectiveList()
  self:BindSlotEvents()
  self:BindListEvents()
  self.CurDungeonPanel = {
    DungeonIndex = 1,
    UpdateSlot = function(_, SlotName, Content)
      local SlotWidget = self.Slots[SlotName]
      if SlotWidget and SlotWidget.Update then
        SlotWidget:Update(Content)
      end
    end,
    GetCurrentUuid = function(_, SlotName)
      local SlotWidget = self.Slots[SlotName]
      if SlotWidget then
        return SlotWidget.Uuid
      end
      return nil
    end,
    GetWeaponType = function(_, SlotName)
      local SlotWidget = self.Slots[SlotName]
      if SlotWidget then
        return SlotWidget.WeaponType or "Melee"
      end
      return "Melee"
    end,
    ClearSlot = function(_, SlotName)
      local SlotWidget = self.Slots[SlotName]
      if SlotWidget and SlotWidget.Clear then
        SlotWidget:Clear()
      end
    end
  }
end

function Component:BindSlotEvents()
  for SlotName, SlotWidget in pairs(self.Slots) do
    if SlotWidget then
      SlotWidget:Init(SlotName, self)
      local Btn
      if SlotWidget.Btn_Click then
        Btn = SlotWidget.Btn_Click
      elseif SlotWidget.Item and SlotWidget.Item.Btn_Click then
        Btn = SlotWidget.Item.Btn_Click
      elseif SlotWidget.Button then
        Btn = SlotWidget.Button
      end
      if Btn and Btn.OnClicked then
        Btn.OnClicked:Add(self, function()
          self:OnSlotClicked(SlotName)
        end)
      end
    end
  end
end

function Component:BindListEvents()
  if self.List_Select then
    if self.List_Select.BP_OnItemClicked then
      self.List_Select.BP_OnItemClicked:Clear()
      self.List_Select.BP_OnItemClicked:Add(self, self.OnListItemClicked)
    end
    if self.List_Select.BP_OnItemIsHoveredChanged then
      self.List_Select.BP_OnItemIsHoveredChanged:Add(self, self.OnItemIsHoverChanged)
    end
    if self.List_Select.BP_OnEntryInitialized then
      self.List_Select.BP_OnEntryInitialized:Add(self, self.OnListItemInited)
    end
  end
  if self.Sort then
    if self.Sort.BindEventOnSelectionsChanged then
      self.Sort:BindEventOnSelectionsChanged(self, self.OnSortListSelectionsChanged)
    end
    if self.Sort.BindEventOnSortTypeChanged then
      self.Sort:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
    end
  end
  if self.EMListView_Filter then
    if self.EMListView_Filter.BP_OnItemClicked then
      self.EMListView_Filter.BP_OnItemClicked:Clear()
      self.EMListView_Filter.BP_OnItemClicked:Add(self, self.OnFilterListItemClicked)
    end
    if self.EMListView_Filter.BP_OnEntryInitialized then
      self.EMListView_Filter.BP_OnEntryInitialized:Add(self, self.OnFilterListItemInited)
    end
  end
end

function Component:OnSlotClicked(SlotName)
  if not self:IsListAllowRefresh() then
    return
  end
  local PreSlotName = self.CurSlotName
  self.CurSlotName = SlotName
  local CurSlotType = Component.SlotName2Type[SlotName]
  if self.CurSlotName ~= PreSlotName then
    if PreSlotName ~= Component.ESlotName.Null and self.Slots[PreSlotName] and self.Slots[PreSlotName].SetIsChecked then
      self.Slots[PreSlotName]:SetIsChecked(false)
    end
    if self.Slots[self.CurSlotName] and self.Slots[self.CurSlotName].SetIsChecked then
      self.Slots[self.CurSlotName]:SetIsChecked(true)
    end
    if "Weapon" == CurSlotType then
      if self.Tab_Primary then
        self.Tab_Primary:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      end
      local WeaponType = "Melee"
      if self.Slots[self.CurSlotName] and self.Slots[self.CurSlotName].WeaponType then
        WeaponType = self.Slots[self.CurSlotName].WeaponType
      end
      self:PhantomWeaponTypeChanged(WeaponType, false, true)
      return
    elseif self.Tab_Primary then
      self.Tab_Primary:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.CurSlotType = CurSlotType
    self:ReInitListItems()
  end
end

function Component:InitSelectiveList()
  self.OrderByDisplayNames = {
    "UI_LEVEL_SELECT",
    "UI_RARITY_NAME"
  }
  self.OrderByAttrNames = {
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }
  self.PetOrderByAttrNames = {
    "BreakNum",
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }
  self.CharFilterTags, self.CharFilterNames = UIUtils.GetAllElementTypes()
  self.CharFilterIcons = {}
  for key, Tag in pairs(self.CharFilterTags) do
    local IconName = "Armory_" .. Tag
    table.insert(self.CharFilterIcons, "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
  end
  self.MeleeFilterTags, self.MeleeFilterNames, self.RangedFilterTags, self.RangedFilterNames = UIUtils.GetAllWeaponTags()
  self.MeleeFilterIcons = {}
  for _, Tag in ipairs(self.MeleeFilterTags) do
    local Data = DataMgr.WeaponTag[Tag]
    table.insert(self.MeleeFilterIcons, Data and Data.Icon)
  end
  self.RangedFilterIcons = {}
  for _, Tag in ipairs(self.RangedFilterTags) do
    local Data = DataMgr.WeaponTag[Tag]
    table.insert(self.RangedFilterIcons, Data and Data.Icon)
  end
end

function Component:InitWidget()
  self.Uuid2SlotMap = {}
  self.CurSlotType = ""
  self.CurSlotName = Component.ESlotName.Null
  self.CurWeaponType = self.CurWeaponType or "Melee"
  self.Saved = true
  self.bListEmpty = false
  self.SelectedContent = nil
  self:CharMain_InitWidget()
  self:PetMain_InitWidget()
  self:WeaponMain_InitWidget()
end

function Component:ReInitListItems()
  if not self.Slots[self.CurSlotName] then
    return
  end
  local SlotWidget = self.Slots[self.CurSlotName]
  local Uuid
  if SlotWidget.Uuid then
    Uuid = SlotWidget.Uuid
  end
  if self.CurSlotType == "Weapon" then
    self["Current" .. self.CurWeaponType .. "Uuid"] = Uuid
  else
    self["Current" .. self.CurSlotType .. "Uuid"] = Uuid
  end
  local FuncName
  if self.CurSlotType == "Weapon" then
    FuncName = self.CurWeaponType .. "Main_Init"
  else
    FuncName = self.CurSlotType .. "Main_Init"
  end
  self:CallFunctionByName(FuncName)
  if self.ItemDetailWidget then
    self:InitItemDetailWidget()
  end
  self:FillSelectiveList()
end

function Component:CharMain_Init()
  if not self.CharItemContentsMap then
    self:CharMain_CreateItemContents()
  end
  self:SetContentIsChosen(self.CharMain_CurContent, false)
  self:CharMain_InitListView()
end

function Component:CharMain_InitWidget()
  self.CharItemContentsMap = nil
  self.CharItemContentsArray = nil
  self.CurrentCharUuid = nil
  self.CharMain_CurContent = nil
end

function Component:CharMain_CreateItemContents()
  local Avatar = GWorld:GetAvatar()
  self.CharItemContentsMap = {}
  self.CharItemContentsArray = {}
  local Obj
  if self.TrialData.ShowOwned.Chars then
    for Uuid, Char in pairs(Avatar.Chars) do
      Obj = self:NewItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char)
      self.CharItemContentsMap[Uuid] = Obj
      table.insert(self.CharItemContentsArray, Obj)
    end
  end
  if self.TrialData and self.TrialData.TrialChars then
    for _, RuleId in ipairs(self.TrialData.TrialChars) do
      if RuleId and DataMgr.CharTemplate[RuleId] then
        Obj = self:NewTrialCharContent(RuleId)
        if Obj then
          local TrialUuid = "TrialChar_" .. RuleId
          self.CharItemContentsMap[TrialUuid] = Obj
          table.insert(self.CharItemContentsArray, Obj)
        end
      end
    end
  end
end

function Component:CharMain_InitListView()
  self:CharMain_InitContentState()
  self:CharMain_SortItemContents()
end

function Component:CharMain_InitContentState()
  if self.CharMain_CurContent then
    self.CharMain_CurContent = nil
  end
  if self.CurrentCharUuid then
    self.CharMain_CurContent = self.CharItemContentsMap[self.CurrentCharUuid]
    if self.CharMain_CurContent then
      self.CharMain_CurContent.IsSelected = true
    end
  end
end

function Component:CharMain_SortItemContents()
  ArmoryUtils:SortItemContents(self.CharItemContentsArray, {
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }, CommonConst.DESC, self.CharMain_CurContent)
end

function Component:CharMain_OnListItemClicked(Content)
  if self.CharMain_CurContent == Content then
    self.CharMain_CurContent = nil
    return
  end
  self.CurrentCharUuid = Content.Uuid
  if self.CurSlotType == "Char" then
    self:CharMain_SelectListItem(Content)
  end
end

function Component:CharMain_SelectListItem(Content)
  if Content then
    Content.TeamIdx = self.CurDungeonPanel.DungeonIndex
  end
  self:SetContentIsChosen(self.CharMain_CurContent, false)
  self:SetContentIsChosen(Content, true)
  self.CharMain_CurContent = Content
  if self.CurDungeonPanel then
    self.CurDungeonPanel:UpdateSlot(self.CurSlotName, Content)
  end
end

function Component:PetMain_Init()
  if not self.PetItemContentsArray then
    self:PetMain_CreateItemContents()
  end
  self:SetContentIsChosen(self.PetMain_CurContent, false)
  self:PetMain_InitListView()
end

function Component:PetMain_InitWidget()
  self.PetItemContentsMap = nil
  self.PetItemContentsArray = nil
  self.CurrentPetUuid = nil
  self.PetMain_CurContent = nil
end

function Component:PetMain_CreateItemContents()
  local Avatar = GWorld:GetAvatar()
  self.PetItemContentsMap = {}
  self.PetItemContentsArray = {}
  local Obj
  if self.TrialData.ShowOwned.Pets then
    for UniqueId, Pet in pairs(Avatar.Pets) do
      if self:CheckPetType(Pet.PetId) then
        Obj = self:NewPetItemContent(Pet)
        self.PetItemContentsMap[UniqueId] = Obj
        table.insert(self.PetItemContentsArray, Obj)
      end
    end
  end
  if self.TrialData and self.TrialData.TrialPets then
    for _, PetId in ipairs(self.TrialData.TrialPets) do
      if PetId and DataMgr.Pet[PetId] then
        Obj = self:NewTrialPetContent(PetId)
        if Obj then
          local TrialUniqueId = "TrialPet_" .. PetId
          self.PetItemContentsMap[TrialUniqueId] = Obj
          table.insert(self.PetItemContentsArray, Obj)
        end
      end
    end
  end
end

function Component:CheckPetType(PetId)
  return 1 == DataMgr.Pet[PetId].PetType
end

function Component:PetMain_InitListView()
  if self.PetMain_CurContent then
    self.PetMain_CurContent = nil
  end
  if self.CurrentPetUuid then
    self.PetMain_CurContent = self.PetItemContentsMap[self.CurrentPetUuid]
    if self.PetMain_CurContent then
      self.PetMain_CurContent.IsSelected = true
    end
  end
  ArmoryUtils:SortItemContents(self.PetItemContentsArray, {
    "BreakNum",
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }, CommonConst.DESC, self.PetMain_CurContent)
end

function Component:PetMain_OnListItemClicked(Content)
  if self.PetMain_CurContent == Content then
    self.PetMain_CurContent = nil
    return
  end
  self.CurrentPetUuid = Content.Uuid
  if self.CurSlotType == "Pet" then
    self:PetMain_SelectListItem(Content)
  end
end

function Component:PetMain_SelectListItem(Content)
  if Content then
    Content.TeamIdx = self.CurDungeonPanel.DungeonIndex
  end
  self:SetContentIsChosen(self.PetMain_CurContent, false)
  self:SetContentIsChosen(Content, true)
  self.PetMain_CurContent = Content
  if self.CurDungeonPanel then
    self.CurDungeonPanel:UpdateSlot(self.CurSlotName, Content)
  end
end

function Component:WeaponMain_InitWidget()
  self.WeaponItemContentsMap = nil
  self.WeaponItemContentsArray = nil
  self.CurrentWeaponUuidName = nil
  self.CurContentName = nil
  local WeaponTags = {
    CommonConst.ArmoryTag.Melee,
    CommonConst.ArmoryTag.Ranged
  }
  for _, Tag in pairs(WeaponTags) do
    self[Tag .. "ItemContentsMap"] = nil
    self[Tag .. "ItemContentsArray"] = nil
    self[Tag .. "Main_CurContent"] = nil
    self["Current" .. Tag .. "Uuid"] = nil
  end
end

function Component:MeleeMain_Init()
  self.WeaponTag = CommonConst.ArmoryTag.Melee
  self:WeaponMain_Init()
end

function Component:RangedMain_Init()
  self.WeaponTag = CommonConst.ArmoryTag.Ranged
  self:WeaponMain_Init()
end

function Component:WeaponMain_Init()
  self.CurrentWeaponUuidName = "Current" .. self.WeaponTag .. "Uuid"
  if not self[self.WeaponTag .. "ItemContentsMap"] then
    self:WeaponMain_CreateItemContents()
  end
  if self.CurContentName then
    self:SetContentIsChosen(self[self.CurContentName], false)
  end
  self:SwitchContentsArray()
  self:WeaponMain_InitListView()
end

function Component:WeaponMain_CreateItemContents()
  local Avatar = GWorld:GetAvatar()
  self[self.WeaponTag .. "ItemContentsMap"] = {}
  self[self.WeaponTag .. "ItemContentsArray"] = {}
  local ItemContentsMap = self[self.WeaponTag .. "ItemContentsMap"]
  local ItemContentsArray = self[self.WeaponTag .. "ItemContentsArray"]
  local Obj
  if self.TrialData.ShowOwned.Weapons then
    for Uuid, Weapon in pairs(Avatar.Weapons) do
      if Weapon:HasTag(self.WeaponTag) then
        Obj = self:NewItemContent(Weapon, CommonConst.ArmoryType.Weapon, self.WeaponTag)
        table.insert(ItemContentsArray, Obj)
        ItemContentsMap[Uuid] = Obj
      end
    end
  end
  local TrialWeaponsKey
  if self.WeaponTag == CommonConst.ArmoryTag.Melee then
    TrialWeaponsKey = "TrialMeleeWeapons"
  elseif self.WeaponTag == CommonConst.ArmoryTag.Ranged then
    TrialWeaponsKey = "TrialRangedWeapons"
  end
  if TrialWeaponsKey and self.TrialData and self.TrialData[TrialWeaponsKey] then
    for _, RuleId in ipairs(self.TrialData[TrialWeaponsKey]) do
      if RuleId and DataMgr.WeaponTemplate[RuleId] then
        Obj = self:NewTrialWeaponContent(RuleId, self.WeaponTag)
        if Obj then
          local TrialUuid = "TrialWeapon_" .. RuleId
          table.insert(ItemContentsArray, Obj)
          ItemContentsMap[TrialUuid] = Obj
        end
      end
    end
  end
end

function Component:SwitchContentsArray()
  self.WeaponItemContentsMap = self[self.WeaponTag .. "ItemContentsMap"]
  self.WeaponItemContentsArray = self[self.WeaponTag .. "ItemContentsArray"]
end

function Component:WeaponMain_InitListView()
  self:WeaponMain_InitContentState()
  ArmoryUtils:SortItemContents(self.WeaponItemContentsArray, {
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }, CommonConst.DESC, self[self.CurContentName])
end

function Component:WeaponMain_InitContentState()
  self.CurContentName = self.WeaponTag .. "Main_CurContent"
  if self[self.CurContentName] then
    self[self.CurContentName] = nil
  end
  if self[self.CurrentWeaponUuidName] then
    self[self.CurContentName] = self.WeaponItemContentsMap[self[self.CurrentWeaponUuidName]]
    if self[self.CurContentName] then
      self[self.CurContentName].IsSelected = true
    end
  end
end

function Component:WeaponMain_OnListItemClicked(Content)
  if self[self.CurContentName] == Content then
    self[self.CurContentName] = nil
    return
  end
  self[self.CurrentWeaponUuidName] = Content.Uuid
  if self.CurSlotType == self.WeaponTag then
    self:WeaponMain_SelectListItem(Content)
  end
end

function Component:WeaponMain_SelectListItem(Content)
  if Content then
    Content.TeamIdx = self.CurDungeonPanel.DungeonIndex
    if self.CurSlotName == Component.ESlotName.PhantomWeapon1 or self.CurSlotName == Component.ESlotName.PhantomWeapon2 then
      local PhantomUuid = self.CurDungeonPanel:GetCurrentUuid(self.CurSlotName - 1)
      if PhantomUuid and self.CharItemContentsMap and self.CharItemContentsMap[PhantomUuid] then
        Content.TeamCharId = self.CharItemContentsMap[PhantomUuid].UnitId
      end
    else
      Content.TeamCharId = nil
    end
  end
  self:SetContentIsChosen(self[self.CurContentName], false)
  self:SetContentIsChosen(Content, true)
  self[self.CurContentName] = Content
  if self.CurDungeonPanel then
    self.CurDungeonPanel:UpdateSlot(self.CurSlotName, Content)
  end
end

function Component:FillSelectiveList()
  if not self.List_Select then
    return
  end
  local Filters, FilterTags, FilterNames, FilterIcons
  if self.CurSlotType == "Weapon" then
    FilterTags = self[self.CurWeaponType .. "FilterTags"]
    FilterNames = self[self.CurWeaponType .. "FilterNames"]
    FilterIcons = self[self.CurWeaponType .. "FilterIcons"]
  else
    FilterTags = self[self.CurSlotType .. "FilterTags"]
    FilterNames = self[self.CurSlotType .. "FilterNames"]
    FilterIcons = self[self.CurSlotType .. "FilterIcons"]
  end
  if FilterTags then
    Filters = self:CreateFilters(FilterTags, FilterNames, FilterIcons)
  end
  if self.EMListView_Filter then
    self.EMListView_Filter:ClearListItems()
    if Filters and #Filters > 0 then
      local FilterContentObj_All = NewObject(UIUtils.GetCommonItemContentClass())
      FilterContentObj_All.IsSelected = true
      FilterContentObj_All.Index = 0
      FilterContentObj_All.Icon = "/Game/UI/Texture/Static/Atlas/Armory/T_Armory_Select.T_Armory_Select"
      self.EMListView_Filter:AddItem(FilterContentObj_All)
      self.FilterContentObj_All = FilterContentObj_All
      for Index, FilterTag in ipairs(Filters) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        for key, value in pairs(FilterTag) do
          Obj[key] = value
        end
        Obj.Index = Index
        self.EMListView_Filter:AddItem(Obj)
      end
    end
  end
  if self.Sort then
    self.Sort:Init(self, self.OrderByDisplayNames, CommonConst.DESC)
  end
  self.FilteredContents = {}
  self.SelectedFilterContents = {}
  local ItemContentsArray
  if self.CurSlotType == "Weapon" then
    ItemContentsArray = self[self.CurWeaponType .. "ItemContentsArray"]
  else
    ItemContentsArray = self[self.CurSlotType .. "ItemContentsArray"]
  end
  if ItemContentsArray then
    for index, value in ipairs(ItemContentsArray) do
      if value then
        table.insert(self.FilteredContents, value)
      end
    end
  end
  self:FillListView()
end

function Component:FillListView()
  if not self.List_Select then
    return
  end
  self.List_Select:ClearListItems()
  for _, Content in ipairs(self.FilteredContents) do
    if Content then
      self.List_Select:AddItem(Content)
    end
  end
  local bListEmpty = #self.FilteredContents <= 0
  self.bListEmpty = bListEmpty
  if self.Empty then
    if bListEmpty then
      self.List_Select:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.List_Select:SetVisibility(UIConst.VisibilityOp.Visible)
      self:AddTimer(0.01, function()
        local ItemUIs = self.List_Select:GetDisplayedEntryWidgets()
        local XCount, YCount = UIUtils.GetTileViewContentMaxCount(self.List_Select, "XY")
        local ItemLen = ItemUIs:Length()
        local RestCount = XCount * YCount - ItemLen
        if RestCount <= 0 then
          RestCount = XCount - #self.FilteredContents % XCount
        end
        self:FillEmptyItems(RestCount)
        self.List_Select:RegenerateAllEntries()
        self.List_Select:ScrollToTop()
      end, false, 0, "DelayAddEmptyItem", true)
    end
  end
  self:OnListInited(bListEmpty)
end

function Component:FillEmptyItems(Count)
  if not self.List_Select then
    return
  end
  for i = 1, Count do
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyContent.IsEmpty = true
    self.List_Select:AddItem(EmptyContent)
  end
end

function Component:CreateFilters(InTags, InTexts, InIcons)
  local Filters = {}
  for i, _ in ipairs(InTags) do
    table.insert(Filters, {
      Tag = InTags[i],
      Text = InTexts[i],
      Icon = InIcons[i]
    })
  end
  return Filters
end

function Component:PhantomWeaponTypeChanged(Type, IsPlaySound, bSlotChanged)
  if "Ranged" ~= Type and "Melee" ~= Type then
    DebugPrint("TeamSelectComponent:PhantomWeaponTypeChanged:传入武器类型无效,", Type)
    return
  end
  if not bSlotChanged and not self:IsListAllowRefresh() then
    return
  end
  if self.CurWeaponType then
    if not bSlotChanged and Type == self.CurWeaponType then
      return
    end
    if self.TypeTabs and self.TypeTabs[self.CurWeaponType] then
      self.TypeTabs[self.CurWeaponType]:SetIsChecked(false)
    end
  end
  if self.TypeTabs and self.TypeTabs[Type] then
    self.TypeTabs[Type]:SetIsChecked(true, IsPlaySound)
  end
  self.CurWeaponType = Type
  self.CurSlotType = self.CurWeaponType
  self:ReInitListItems()
  if bSlotChanged and self.DelaySetFocusTarget then
    self:DelaySetFocusTarget(bSlotChanged)
  end
end

function Component:OnListItemClicked(Content)
  if not Content or not Content.Uuid then
    return
  end
  if self.Saved and self.OnSavedStateChanged then
    self.OnSavedStateChanged(self, false)
  end
  self.Saved = false
  if not self.UsingGamepad and self.ItemDetailWidget then
    self:ShowItemDetails(not self:IsChar(), Content)
  end
  local CurSlotWidget = self.Slots[self.CurSlotName]
  if not CurSlotWidget then
    return
  end
  if Content.TeamIdx then
    local CurrentUuid = CurSlotWidget.Uuid
    if Content.Uuid == CurrentUuid then
      if CurSlotWidget.Clear then
        CurSlotWidget:Clear()
      end
      self:SetContentIsChosen(Content, false)
      if not self.UsingGamepad then
        self:SetContentIsSelected(Content, true)
      end
      return
    else
      local OtherSlotInfo = self.Uuid2SlotMap[Content.Uuid]
      local Type = Component.SlotName2Type[self.CurSlotName]
      if "Weapon" == Type then
        Type = CurSlotWidget.WeaponType or "Melee"
      end
      local CurrentUuid = CurSlotWidget.Uuid
      if CurrentUuid and self[Type .. "ItemContentsMap"] then
        local CurContent = self[Type .. "ItemContentsMap"][CurrentUuid]
        local ContentTeamIdx = Content.TeamIdx
        local ContentTeamCharId = Content.TeamCharId
        local CurContentTeamIdx = CurContent and CurContent.TeamIdx
        local CurContentTeamCharId = CurContent and CurContent.TeamCharId
        if CurSlotWidget.Update then
          CurSlotWidget:Update(Content)
        end
        if OtherSlotInfo and self.Slots[OtherSlotInfo.SlotName] then
          local OtherSlotWidget = self.Slots[OtherSlotInfo.SlotName]
          if OtherSlotWidget.Update then
            OtherSlotWidget:Update(CurContent)
          end
        end
        local FuncName
        if "Melee" == self.CurSlotType or self.CurSlotType == "Ranged" then
          FuncName = "WeaponMain_OnListItemClicked"
        else
          FuncName = self.CurSlotType .. "Main_OnListItemClicked"
        end
        if self[FuncName] then
          self[FuncName](self, Content)
        end
        if ContentTeamIdx then
          Content.TeamIdx = ContentTeamIdx
        end
        if CurContent and CurContentTeamIdx then
          CurContent.TeamIdx = CurContentTeamIdx
          CurContent.TeamCharId = CurContentTeamCharId
        end
        if CurContent and CurContent.SelfWidget then
          local PreIndex = Content.TeamIdx
          local PreChar = Content.TeamCharId
          CurContent.TeamIdx = PreIndex
          CurContent.TeamCharId = PreChar
          if CurContent.SelfWidget.SetTeamIcon then
            CurContent.SelfWidget:SetTeamIcon(PreIndex, PreChar)
          end
        end
        if self.List_Select then
          self.List_Select:RegenerateAllEntries()
        end
        if self.SlotName2TextMap then
          UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText(Content.UnitName) .. GText("Abyss_Party_Replaced") .. "<Highlight>" .. self.SlotName2TextMap[self.CurSlotName] .. "</>")
        end
        return
      end
    end
  end
  local FuncName
  if "Melee" == self.CurSlotType or self.CurSlotType == "Ranged" then
    FuncName = "WeaponMain_OnListItemClicked"
  else
    FuncName = self.CurSlotType .. "Main_OnListItemClicked"
  end
  self:CallFunctionByName(FuncName, Content)
end

function Component:SetContentIsChosen(Content, IsChosen)
  if not Content then
    return
  end
  if Content.SelfWidget then
    self:SetContentIsSelected(Content, IsChosen)
    if Content.SelfWidget.SetTeamIcon then
      Content.SelfWidget:SetTeamIcon(IsChosen and Content.TeamIdx, Content.TeamCharId)
    end
    self:PlaySelectSound(IsChosen, Content.Type)
  elseif not IsChosen then
    Content.TeamIdx = nil
    Content.TeamCharId = nil
  end
end

function Component:SetContentIsSelected(Content, IsSelected)
  if not Content then
    return
  end
  Content.IsSelect = IsSelected
  if Content.SelfWidget and Content.SelfWidget.SetSelected then
    Content.SelfWidget:SetSelected(IsSelected)
  end
  if IsSelected then
    self:SetContentIsSelected(self.SelectedContent, false)
    self.SelectedContent = Content
  elseif self.SelectedContent == Content then
    self.SelectedContent = nil
  end
end

local SelectSoundPaths = {
  Char = "event:/ui/armory/click_select_role",
  Weapon = "event:/ui/armory/click_select_weapon",
  Pet = "event:/ui/common/click_select_pet",
  Default = "event:/ui/common/click_mid"
}
local EquipSoundPaths = {
  Char = "event:/ui/common/role_replace",
  Weapon = "event:/ui/common/weapon_replace",
  Pet = "event:/ui/common/role_replace"
}

function Component:PlaySelectSound(IsSelected, Type)
  if not IsSelected then
    AudioManager(self):PlayUISound(self, SelectSoundPaths.Default, nil, nil)
  else
    AudioManager(self):PlayUISound(self, SelectSoundPaths[Type] or SelectSoundPaths.Default, nil, nil)
    AudioManager(self):PlayUISound(self, EquipSoundPaths[Type] or EquipSoundPaths.Default, nil, nil)
  end
end

function Component:SortItemContents(InOutContentArray, SortByIdx, SortType)
  local FirstContent = self[self.CurSlotType .. "Main_CurContent"] or self[self.CurSlotType .. "Main_CmpContent"]
  local OrderByAttrNames
  if self.CurSlotType == "Pet" then
    OrderByAttrNames = self.PetOrderByAttrNames
    if 2 == SortByIdx then
      SortByIdx = 3
    end
  else
    OrderByAttrNames = self.OrderByAttrNames
  end
  local SortByAttrNames = {
    OrderByAttrNames[SortByIdx]
  }
  for index, value in ipairs(OrderByAttrNames) do
    if index ~= SortByIdx then
      table.insert(SortByAttrNames, value)
    end
  end
  ArmoryUtils:SortItemContents(InOutContentArray, SortByAttrNames, SortType, FirstContent)
end

function Component:FilterItemContents(InContentArray, FilterIdxes)
  local SlotType = self.CurSlotType
  local DataType = Component.SlotType2DataType[SlotType]
  local FilteredItems = {}
  local FilterFunc, FilterTags
  if "Weapon" == SlotType then
    FilterTags = self[self.CurWeaponType .. "FilterTags"]
  else
    FilterTags = self[SlotType .. "FilterTags"]
  end
  if "Char" == DataType then
    function FilterFunc(FilterTag, Content)
      local Data = DataMgr.BattleChar[Content.UnitId]
      
      return FilterTag == Data.Attribute
    end
  elseif "Weapon" == DataType then
    local Avatar = GWorld:GetAvatar()
    
    function FilterFunc(FilterTag, Content)
      local Weapon = Avatar.Weapons[Content.Uuid]
      return Weapon and Weapon:HasTag(FilterTag)
    end
  elseif "Pet" == DataType then
    function FilterFunc()
      return true
    end
  end
  if FilterFunc and FilterTags then
    local AddedContents = {}
    for _, Content in ipairs(InContentArray) do
      if Content then
        local ContentKey = Content.Uuid or tostring(Content)
        if not AddedContents[ContentKey] then
          for _, Idx in ipairs(FilterIdxes) do
            if FilterTags[Idx] and FilterFunc(FilterTags[Idx], Content) then
              table.insert(FilteredItems, Content)
              AddedContents[ContentKey] = true
              break
            end
          end
        end
      end
    end
  end
  return FilteredItems
end

function Component:OnItemIsHoverChanged(ItemContent, bHovered)
  if not ItemContent or not ItemContent.Uuid then
    return
  end
  if self.UsingGamepad then
    self:ShowItemDetails(bHovered and ItemContent.Type ~= "Char", ItemContent)
  end
end

function Component:OnSortListSelectionsChanged()
  if not self.Sort then
    return
  end
  local SortByIdx, SortType = self.Sort:GetSortInfos()
  if self.SortItemContents then
    self:SortItemContents(self.FilteredContents, SortByIdx, SortType)
    self:FillListView()
  end
end

function Component:OnSortTypeChanged()
  if not self.Sort then
    return
  end
  local SortByIdx, SortType = self.Sort:GetSortInfos()
  if self.SortItemContents then
    self:SortItemContents(self.FilteredContents, SortByIdx, SortType)
    self:FillListView()
  end
end

function Component:OnFilterListItemClicked(Content)
  if not Content then
    return
  end
  if Content.IsSelected then
    return
  end
  if self.SelectedFilterContents then
    for Tag, Value in pairs(self.SelectedFilterContents) do
      if Value ~= Content then
        self:SetFilterContentIsSelected(Value, false)
        self.SelectedFilterContents[Tag] = nil
      end
    end
  end
  if self.FilterContentObj_All and self.FilterContentObj_All ~= Content then
    self:SetFilterContentIsSelected(self.FilterContentObj_All, false)
  end
  self:SetFilterContentIsSelected(Content, true)
  self.FilterIdxes = {}
  local FilterTags
  if self.CurSlotType == "Weapon" then
    FilterTags = self[self.CurWeaponType .. "FilterTags"]
  else
    FilterTags = self[self.CurSlotType .. "FilterTags"]
  end
  if 0 == Content.Index then
    if FilterTags then
      for i = 1, #FilterTags do
        table.insert(self.FilterIdxes, i)
      end
    end
  else
    table.insert(self.FilterIdxes, Content.Index)
  end
  if self.FilterItemContents then
    local ItemContentsArray
    if self.CurSlotType == "Weapon" then
      ItemContentsArray = self[self.CurWeaponType .. "ItemContentsArray"]
    else
      ItemContentsArray = self[self.CurSlotType .. "ItemContentsArray"]
    end
    if ItemContentsArray then
      self.FilteredContents = self:FilterItemContents(ItemContentsArray, self.FilterIdxes) or {}
    end
  end
  if self.SortItemContents then
    local SortByIdx, SortType = self.Sort:GetSortInfos()
    self:SortItemContents(self.FilteredContents, SortByIdx, SortType)
  end
  self:FillListView()
end

function Component:SetFilterContentIsSelected(Content, IsSelected)
  if not Content then
    return
  end
  Content.IsSelected = IsSelected
  if Content.SelfWidget and Content.SelfWidget.SetIsSelected then
    Content.SelfWidget:SetIsSelected(IsSelected)
  elseif Content.UI and Content.UI.SetIsSelected then
    Content.UI:SetIsSelected(IsSelected)
  end
  local Key = Content.Tag or Content.Index
  if Key then
    self.SelectedFilterContents = self.SelectedFilterContents or {}
    if IsSelected then
      self.SelectedFilterContents[Key] = Content
    else
      self.SelectedFilterContents[Key] = nil
    end
  end
end

function Component:OnListItemInited(Content, EntryUI)
  if Content and EntryUI then
    Content.SelfWidget = EntryUI
    if Content.TeamIdx then
      self:SetContentIsChosen(Content, true)
    end
  end
end

function Component:OnFilterListItemInited(Content, EntryUI)
  if Content and EntryUI then
    Content.UI = EntryUI
    if Content.IsSelected and EntryUI.SetIsSelected then
      EntryUI:SetIsSelected(true)
    end
  end
end

function Component:OnListInited(bListEmpty)
  self.bListEmpty = bListEmpty
  if self.bItemDetailsShowed then
    self:ShowItemDetails(false)
  end
  self:SetContentIsSelected(self.SelectedContent, false)
  self:UpdateTeamIcons()
end

function Component:ShowItemDetails(bShow, Content)
  if not self.ItemDetailWidget then
    return
  end
  if bShow then
    if self.bListEmpty then
      return
    end
    if Content and Content.Type == "Char" then
      return
    end
    if self.ItemDetailsContent ~= Content then
      self.ItemDetailWidget:RefreshItemInfo(Content, true)
    end
    self.ItemDetailWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.ItemDetailWidget:StopAnimation(self.ItemDetailWidget.Out)
    self.ItemDetailWidget:PlayAnimation(self.ItemDetailWidget.In)
    self.bItemDetailsShowed = true
  else
    self.bItemDetailsShowed = false
    self.ItemDetailWidget:StopAnimation(self.ItemDetailWidget.In)
    self.ItemDetailWidget:PlayAnimation(self.ItemDetailWidget.Out)
  end
  self.ItemDetailsContent = Content
end

function Component:InitItemDetailWidget()
  if not self.ItemDetailWidget then
    return
  end
  self.ItemDetailWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.ItemDetailWidget.Key_Confirm then
    self.ItemDetailWidget.Key_Confirm:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Add")
    })
    self.ItemDetailWidget.Key_Confirm:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.ItemDetailWidget.Key_Back then
    self.ItemDetailWidget.Key_Back:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self.ItemDetailWidget.bIsFocusable = false
  self.bItemDetailsShowed = false
  self.ItemDetailsContent = nil
end

function Component:AttachTipsWidget(Widget)
  if self.Pos_Tip then
    self.Pos_Tip:AddChild(Widget)
  end
end

function Component:NewItemContent(Target, Type, Tag)
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.Uuid = Target.Uuid
  Obj.Type = Type
  Obj.Tag = Tag
  Obj.UnitId = Target[Type .. "Id"]
  Obj.UnitName = Target[Type .. "Name"]
  Obj.Rarity = Target[Type .. "Rarity"]
  Obj.Icon = Target:Data().Icon
  Obj.GachaIcon = Target:Data().GachaIcon
  Obj.Level = Target.Level
  Obj.GradeLevel = Target.GradeLevel
  Obj.AnimNameWithCreate = "In_OnlyOpacity"
  Obj.IsTryout = false
  local Element = DataMgr["Battle" .. Type][Obj.UnitId].Attribute
  if Element then
    local IconName = "Armory_" .. Element
    Obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
  end
  Obj.SortPriority = Target:Data().SortPriority or 0
  Obj.OnMouseButtonUpEvents = {
    Obj = self,
    Callback = function()
      self:OnListItemClicked(Obj)
    end
  }
  return Obj
end

function Component:NewPetItemContent(Target)
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.Uuid = Target.UniqueId
  Obj.Type = CommonConst.ArmoryType.Pet
  Obj.Tag = CommonConst.ArmoryType.Pet
  Obj.UnitId = Target.PetId
  local Data = DataMgr.Pet[Obj.UnitId]
  Obj.UnitName = Data.Name
  Obj.Rarity = Data.Rarity
  Obj.Icon = Data.Icon
  Obj.Level = Target.Level
  Obj.BreakNum = Target.BreakNum
  Obj.IsTryout = false
  Obj.SortPriority = Data.SortPriority or 0
  Obj.OnMouseButtonUpEvents = {
    Obj = self,
    Callback = function()
      self:OnListItemClicked(Obj)
    end
  }
  return Obj
end

function Component:NewTrialCharContent(RuleId)
  if not RuleId or not DataMgr.CharTemplate[RuleId] then
    return nil
  end
  local Template = DataMgr.CharTemplate[RuleId]
  local CharId = Template.CharId
  if not CharId then
    return nil
  end
  local CharData = DataMgr.Char[CharId]
  if not CharData then
    return nil
  end
  local BattleCharData = DataMgr.BattleChar[CharId]
  if not BattleCharData then
    return nil
  end
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.Uuid = "TrialChar_" .. RuleId
  Obj.Type = CommonConst.ArmoryType.Char
  Obj.Tag = CommonConst.ArmoryTag.Char
  Obj.UnitId = CharId
  Obj.UnitName = CharData.CharName or BattleCharData.CharName
  Obj.Rarity = CharData.CharRarity or BattleCharData.Rarity
  Obj.Icon = CharData.Icon
  Obj.GachaIcon = CharData.GachaIcon
  Obj.Level = Template.CharLevel or 1
  Obj.GradeLevel = 0
  Obj.AnimNameWithCreate = "In_OnlyOpacity"
  Obj.IsTrial = true
  Obj.IsTryout = true
  local Element = BattleCharData.Attribute
  if Element then
    local IconName = "Armory_" .. Element
    Obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
  end
  Obj.SortPriority = CharData.SortPriority or 0
  Obj.OnMouseButtonUpEvents = {
    Obj = self,
    Callback = function()
      self:OnListItemClicked(Obj)
    end
  }
  return Obj
end

function Component:NewTrialWeaponContent(RuleId, WeaponTag)
  if not RuleId or not DataMgr.WeaponTemplate[RuleId] then
    return nil
  end
  local Template = DataMgr.WeaponTemplate[RuleId]
  local WeaponId = Template.WeaponId
  if not WeaponId then
    return nil
  end
  local WeaponData = DataMgr.Weapon[WeaponId]
  if not WeaponData then
    return nil
  end
  local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
  if not BattleWeaponData then
    return nil
  end
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.Uuid = "TrialWeapon_" .. RuleId
  Obj.Type = CommonConst.ArmoryType.Weapon
  Obj.Tag = WeaponTag
  Obj.UnitId = WeaponId
  Obj.UnitName = WeaponData.WeaponName or BattleWeaponData.Name
  Obj.Rarity = WeaponData.WeaponRarity or BattleWeaponData.Rarity
  Obj.Icon = WeaponData.Icon
  Obj.GachaIcon = WeaponData.GachaIcon
  Obj.Level = Template.WeaponLevel or 1
  Obj.GradeLevel = 0
  Obj.AnimNameWithCreate = "In_OnlyOpacity"
  Obj.IsTrial = true
  Obj.IsTryout = true
  local Element = BattleWeaponData.Attribute
  if Element then
    local IconName = "Armory_" .. Element
    Obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
  end
  Obj.SortPriority = WeaponData.SortPriority or 0
  Obj.OnMouseButtonUpEvents = {
    Obj = self,
    Callback = function()
      self:OnListItemClicked(Obj)
    end
  }
  return Obj
end

function Component:NewTrialPetContent(PetId)
  if not PetId or not DataMgr.Pet[PetId] then
    return nil
  end
  local PetData = DataMgr.Pet[PetId]
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.Uuid = "TrialPet_" .. PetId
  Obj.Type = CommonConst.ArmoryType.Pet
  Obj.Tag = CommonConst.ArmoryType.Pet
  Obj.UnitId = PetId
  Obj.UnitName = PetData.Name
  Obj.Rarity = PetData.Rarity
  Obj.Icon = PetData.Icon
  Obj.Level = 1
  Obj.BreakNum = 0
  Obj.AnimNameWithCreate = "In_OnlyOpacity"
  Obj.IsTrial = true
  Obj.IsTryout = true
  Obj.SortPriority = PetData.SortPriority or 0
  Obj.OnMouseButtonUpEvents = {
    Obj = self,
    Callback = function()
      self:OnListItemClicked(Obj)
    end
  }
  return Obj
end

function Component:CallFunctionByName(FunctionName, ...)
  if self[FunctionName] then
    return self[FunctionName](self, ...)
  end
end

function Component:GetCurrentContent()
  return self[self.CurSlotType .. "Main_CurContent"]
end

function Component:IsChar()
  return self.CurSlotType == CommonConst.ArmoryType.Char
end

function Component:IsListAllowRefresh()
  if self.bAllowRefreshList ~= nil then
    return self.bAllowRefreshList
  end
  return true
end

function Component:SetListAllowRefresh(bAllow)
  self.bAllowRefreshList = bAllow
end

function Component:GetTeamTable()
  local TeamTable = {
    Char = NullUUid,
    MeleeWeapon = NullUUid,
    RangedWeapon = NullUUid,
    Phantom1 = NullUUid,
    PhantomWeapon1 = NullUUid,
    Phantom2 = NullUUid,
    PhantomWeapon2 = NullUUid,
    Pet = NullUnitId
  }
  for SlotName, SlotWidget in pairs(self.Slots) do
    if SlotName ~= Component.ESlotName.Null and SlotWidget then
      local Uuid = SlotWidget.Uuid
      if Uuid then
        TeamTable[SlotName] = Uuid
      end
    end
  end
  return TeamTable
end

function Component:UpdateTeamIcons()
  for SlotName, SlotWidget in pairs(self.Slots) do
    if SlotWidget and SlotWidget.Uuid and not SlotWidget.IsEmpty then
      local Type = Component.SlotName2Type[SlotName]
      local IsPhantomWeapon = false
      if "Weapon" == Type then
        Type = SlotWidget.WeaponType or "Melee"
        if Type ~= self.CurSlotType then
        else
          IsPhantomWeapon = true
          elseif Type ~= self.CurSlotType then
            goto lbl_73
          end
          if self[Type .. "ItemContentsMap"] then
            local Content = self[Type .. "ItemContentsMap"][SlotWidget.Uuid]
            if Content then
              Content.TeamIdx = 1
              if IsPhantomWeapon then
                local PhantomSlotName = SlotName - 1
                local PhantomSlotWidget = self.Slots[PhantomSlotName]
                if PhantomSlotWidget and PhantomSlotWidget.Uuid and self.CharItemContentsMap then
                  Content.TeamCharId = self.CharItemContentsMap[PhantomSlotWidget.Uuid].UnitId
                end
              end
              if Content.SelfWidget then
                self:SetContentIsChosen(Content, true)
              end
            end
          end
        end
    end
    ::lbl_73::
  end
end

function Component:RemoveTeamIcons()
  for SlotName, SlotWidget in pairs(self.Slots) do
    if SlotWidget and SlotWidget.Uuid and not SlotWidget.IsEmpty then
      local Type = Component.SlotName2Type[SlotName]
      if "Weapon" == Type then
        Type = SlotWidget.WeaponType or "Melee"
      end
      self[Type .. "Main_CurContent"] = nil
      if self[Type .. "ItemContentsMap"] then
        local Content = self[Type .. "ItemContentsMap"][SlotWidget.Uuid]
        if Content then
          Content.TeamIdx = nil
          self:SetContentIsChosen(Content, false)
        end
      end
    end
  end
end

function Component:UpdateSingleTeamIcon(Uuid, bVisible, Type)
  local Type = Type or self.CurSlotType
  if not self[Type .. "ItemContentsMap"] then
    return
  end
  local Content = self[Type .. "ItemContentsMap"][Uuid]
  if not Content then
    return
  end
  Content.TeamIdx = bVisible and Content.TeamIdx or nil
end

function Component:CheckUnit(UnitId)
  if type(UnitId) == "number" then
    return UnitId ~= NullUnitId
  else
    return UnitId ~= NullUUid
  end
end

function Component:IsTrialItem(Uuid)
  if not Uuid then
    return false
  end
  return string.match(Uuid, "^TrialChar_") ~= nil or nil ~= string.match(Uuid, "^TrialWeapon_") or nil ~= string.match(Uuid, "^TrialPet_")
end

function Component:ClearAllSlots()
  self:RemoveTeamIcons()
  for SlotName, SlotWidget in pairs(self.Slots) do
    if SlotWidget and SlotWidget.Clear then
      SlotWidget:Clear()
    end
  end
  self:SetContentIsSelected(self.SelectedContent, false)
  if self.CharMain_CurContent then
    self.CharMain_CurContent = nil
  end
  if self.PetMain_CurContent then
    self.PetMain_CurContent = nil
  end
  local WeaponTags = {
    CommonConst.ArmoryTag.Melee,
    CommonConst.ArmoryTag.Ranged
  }
  for _, Tag in pairs(WeaponTags) do
    if self[Tag .. "Main_CurContent"] then
      self[Tag .. "Main_CurContent"] = nil
    end
  end
  self.Saved = false
  if self.OnSavedStateChanged then
    self.OnSavedStateChanged(self, false)
  end
end

function Component:SetOnSavedStateChangedCallback(Callback)
  self.OnSavedStateChanged = Callback
end

function Component:OnBackgroundClicked()
  if self.bItemDetailsShowed then
    self:ShowItemDetails(false)
  end
  self:SetContentIsSelected(self.SelectedContent, false)
end

return Component
