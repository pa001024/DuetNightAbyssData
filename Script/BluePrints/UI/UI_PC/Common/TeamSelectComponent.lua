require("UnLua")
local Component = {}
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local SquadPresetUtils = require("Utils.SquadPresetUtils")
local UIUtils = require("Utils.UIUtils")
Component.ESlotName = SquadPresetUtils.ESlotName
Component.SlotNameOrder = SquadPresetUtils.SlotNameOrder
Component.SlotName2Type = SquadPresetUtils.SlotName2Type
Component.SlotType2DataType = SquadPresetUtils.SlotType2DataType
Component.GetCharConflictKey = SquadPresetUtils.GetCharConflictKey
Component.IsTryoutCmpFunc = SquadPresetUtils.IsTryoutCmpFunc

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
  self.bListEmpty = false
  self.SelectedContent = nil
  self.DungeonIndex = 1
  self:InitSelectiveList()
  self:BindSlotEvents()
  self:BindListEvents()
end

function Component:BindSlotEvents()
  SquadPresetUtils.BindSquadSlotEvents(self)
end

function Component:BindListEvents()
  SquadPresetUtils.BindSquadListEvents(self)
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
    self:ChangeEmptyTextBySlotType(CurSlotType)
    if "Weapon" == CurSlotType then
      self.Tab_Primary:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.IsTabPrimaryVisible = true
      local WeaponType = "Melee"
      if self.Slots[self.CurSlotName] and self.Slots[self.CurSlotName].WeaponType then
        WeaponType = self.Slots[self.CurSlotName].WeaponType
      end
      self:PhantomWeaponTypeChanged(WeaponType, false, true)
      if self.UpdateListSelect then
        self:UpdateListSelect(self.CurSlotName)
      end
      return
    else
      self.Tab_Primary:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.IsTabPrimaryVisible = false
    end
    self.CurSlotType = CurSlotType
    self:ReInitListItems()
  end
  if self.UpdateListSelect then
    self:UpdateListSelect(self.CurSlotName)
  end
end

function Component:ChangeEmptyTextBySlotType(SlotType)
  if "Char" == SlotType then
    self.Text_Empty:SetText(GText("UI_Armory_Char_Empty"))
  elseif "Pet" == SlotType then
    self.Text_Empty:SetText(GText("UI_Armory_Pet_Empty"))
  elseif "Weapon" == SlotType or "Melee" == SlotType or "Ranged" == SlotType then
    self.Text_Empty:SetText(GText("UI_Armory_Weapon_Empty"))
  end
end

function Component:InitSelectiveList()
  SquadPresetUtils.InitSelectiveListMetadata(self)
end

function Component:InitWidget()
  self.Uuid2SlotMap = {}
  self.CurSlotType = ""
  self.CurSlotName = Component.ESlotName.Null
  self.CurWeaponType = self.CurWeaponType or "Melee"
  self.bListEmpty = false
  self.SelectedContent = nil
  self:CharMain_InitWidget()
  self:PetMain_InitWidget()
  self:WeaponMain_InitWidget()
end

function Component:ReInitListItems()
  SquadPresetUtils.ReInitLineupSelectiveList(self)
end

function Component:CharMain_Init()
  if not self.CharItemContentsMap then
    self:CharMain_CreateItemContents()
  end
  self:CharMain_InitListView()
end

function Component:CharMain_InitWidget()
  self.CharItemContentsMap = nil
  self.CharItemContentsArray = nil
  self.CurrentCharUuid = nil
  self.BP_CharItemContents:Clear()
  self.CharMain_CurContent = nil
end

function Component:CharMain_CreateItemContents()
  local Avatar = GWorld:GetAvatar()
  self.CharItemContentsMap = {}
  self.CharItemContentsArray = {}
  self.BP_CharItemContents:Clear()
  local Obj
  if self.TrialData.ShowOwned.Chars then
    local MainPlayerCharId = AvatarUtils:GetMainPlayerCharacterAttributeCharId(Avatar)
    for Uuid, Char in pairs(Avatar.Chars) do
      local CharId = Char.CharId
      local bSkipAltProtagonist = MainPlayerCharId and -1 ~= MainPlayerCharId and AvatarUtils:IsCharacterAttributeSwitchSameGroup(MainPlayerCharId, CharId) and MainPlayerCharId ~= CharId
      if not bSkipAltProtagonist then
        Obj = self:NewItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char)
        self.CharItemContentsMap[Uuid] = Obj
        self.BP_CharItemContents:Add(Obj)
        table.insert(self.CharItemContentsArray, Obj)
      end
    end
  end
  if self.TrialData and self.TrialData.TrialChars then
    for _, RuleId in ipairs(self.TrialData.TrialChars) do
      if RuleId and DataMgr.CharTemplate[RuleId] then
        Obj = self:NewTrialCharContent(RuleId)
        if Obj then
          self.CharItemContentsMap[RuleId] = Obj
          self.BP_CharItemContents:Add(Obj)
          table.insert(self.CharItemContentsArray, Obj)
        end
      end
    end
  end
end

function Component:CharMain_InitListView()
  self:CharMain_InitContentState()
  self:CharMain_SortItemContents()
  self:UpdateCharConflict()
end

function Component:CharMain_InitContentState()
  if self.CurrentCharUuid and self.CharItemContentsMap then
    local CurContent = self.CharItemContentsMap[self.CurrentCharUuid]
    if CurContent then
      CurContent.IsSelected = true
    end
  end
end

function Component:CharMain_SortItemContents()
  local CurContent
  if self.CurrentCharUuid and self.CharItemContentsMap then
    CurContent = self.CharItemContentsMap[self.CurrentCharUuid]
  end
  ArmoryUtils:SortItemContents(self.CharItemContentsArray, {
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }, CommonConst.DESC, CurContent, Component.IsTryoutCmpFunc)
end

function Component:CharMain_OnListItemClicked(Content)
  if self.CurSlotType == "Char" then
    self.CurrentCharUuid = Content.Uuid
  end
end

function Component:PetMain_Init()
  if not self.PetItemContentsArray then
    self:PetMain_CreateItemContents()
  end
  self:PetMain_InitListView()
end

function Component:PetMain_InitWidget()
  self.PetItemContentsMap = nil
  self.PetItemContentsArray = nil
  self.CurrentPetUuid = nil
  self.BP_PetItemContents:Clear()
  self.PetMain_CurContent = nil
end

function Component:PetMain_CreateItemContents()
  local Avatar = GWorld:GetAvatar()
  self.PetItemContentsMap = {}
  self.PetItemContentsArray = {}
  self.BP_PetItemContents:Clear()
  local Obj
  if self.TrialData.ShowOwned.Pets then
    for UniqueId, Pet in pairs(Avatar.Pets) do
      if self:CheckPetType(Pet.PetId) then
        Obj = self:NewPetItemContent(Pet)
        self.PetItemContentsMap[UniqueId] = Obj
        self.BP_PetItemContents:Add(Obj)
        table.insert(self.PetItemContentsArray, Obj)
      end
    end
  end
  if self.TrialData and self.TrialData.TrialPets then
    for _, PetId in ipairs(self.TrialData.TrialPets) do
      if PetId and DataMgr.Pet[PetId] then
        Obj = self:NewTrialPetContent(PetId)
        if Obj then
          self.PetItemContentsMap[PetId] = Obj
          self.BP_PetItemContents:Add(Obj)
          table.insert(self.PetItemContentsArray, Obj)
        end
      end
    end
  end
end

function Component:CheckPetType(PetId)
  return SquadPresetUtils.CheckPetType(PetId)
end

function Component:PetMain_InitListView()
  local CurContent
  if self.CurrentPetUuid and self.PetItemContentsMap then
    CurContent = self.PetItemContentsMap[self.CurrentPetUuid]
    if CurContent then
      CurContent.IsSelected = true
    end
  end
  ArmoryUtils:SortItemContents(self.PetItemContentsArray, {
    "BreakNum",
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }, CommonConst.DESC, CurContent, Component.IsTryoutCmpFunc)
end

function Component:PetMain_OnListItemClicked(Content)
  if self.CurSlotType == "Pet" then
    self.CurrentPetUuid = Content.Uuid
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
    self["BP_" .. Tag .. "ItemContents"]:Clear()
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
  self:SwitchContentsArray()
  self:WeaponMain_InitListView()
end

function Component:WeaponMain_CreateItemContents()
  local Avatar = GWorld:GetAvatar()
  self[self.WeaponTag .. "ItemContentsMap"] = {}
  self[self.WeaponTag .. "ItemContentsArray"] = {}
  local ItemContentsMap = self[self.WeaponTag .. "ItemContentsMap"]
  local ItemContentsArray = self[self.WeaponTag .. "ItemContentsArray"]
  self["BP_" .. self.WeaponTag .. "ItemContents"]:Clear()
  local Obj
  if self.TrialData.ShowOwned.Weapons then
    for Uuid, Weapon in pairs(Avatar.Weapons) do
      if Weapon:HasTag(self.WeaponTag) then
        Obj = self:NewItemContent(Weapon, CommonConst.ArmoryType.Weapon, self.WeaponTag)
        self["BP_" .. self.WeaponTag .. "ItemContents"]:Add(Obj)
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
          self["BP_" .. self.WeaponTag .. "ItemContents"]:Add(Obj)
          table.insert(ItemContentsArray, Obj)
          ItemContentsMap[RuleId] = Obj
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
  local CurContent
  if self[self.CurrentWeaponUuidName] and self.WeaponItemContentsMap then
    CurContent = self.WeaponItemContentsMap[self[self.CurrentWeaponUuidName]]
  end
  ArmoryUtils:SortItemContents(self.WeaponItemContentsArray, {
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }, CommonConst.DESC, CurContent, Component.IsTryoutCmpFunc)
end

function Component:WeaponMain_InitContentState()
  self.CurContentName = self.WeaponTag .. "Main_CurContent"
  if self[self.CurrentWeaponUuidName] and self.WeaponItemContentsMap then
    local CurContent = self.WeaponItemContentsMap[self[self.CurrentWeaponUuidName]]
    if CurContent then
      CurContent.IsSelected = true
    end
  end
end

function Component:WeaponMain_OnListItemClicked(Content)
  if self.CurSlotType == self.WeaponTag then
    self[self.CurrentWeaponUuidName] = Content.Uuid
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
    Filters = SquadPresetUtils.CreateFilters(FilterTags, FilterNames, FilterIcons)
  end
  if self.EMListView_Filter then
    self.EMListView_Filter:ClearListItems()
    if Filters and #Filters > 0 then
      local FilterContentObj_All = NewObject(UIUtils.GetCommonItemContentClass())
      FilterContentObj_All.IsSelected = true
      FilterContentObj_All.Index = 0
      FilterContentObj_All.Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Wuyousheng_All.T_Tab_Wuyousheng_All"
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
      table.insert(self.FilteredContents, value)
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
    self.List_Select:AddItem(Content)
  end
  self.List_Select:RequestFillEmptyContent()
  local bListEmpty = #self.FilteredContents <= 0
  self.bListEmpty = bListEmpty
  if self.Empty then
    if bListEmpty then
      self.List_Select:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.List_Select:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  end
  self:OnListInited(bListEmpty)
end

function Component:PhantomWeaponTypeChanged(Type, IsPlaySound, bSlotChanged)
  SquadPresetUtils.PhantomWeaponTypeChanged(self, Type, IsPlaySound, bSlotChanged, "TeamSelectComponent")
end

function Component:OnListItemClicked(Content)
  if not Content or not Content.Uuid then
    return
  end
  if Content.UI then
    Content.UI:OnItemClick()
  end
  if not self.IsUseGamePad and self.ItemDetailWidget then
    self:ShowItemDetails(not self:IsChar(), Content)
  end
  local CurSlotWidget = self.Slots[self.CurSlotName]
  if not CurSlotWidget then
    return
  end
  if Content.IsConflict then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_OnlyOneChar"))
    return
  end
  local Type = Component.SlotName2Type[self.CurSlotName]
  local CurContent = CurSlotWidget.Content
  if "Weapon" == Type then
    if CurContent and CurContent.Tag then
      Type = CurContent.Tag
    else
      Type = CurSlotWidget.WeaponType or "Melee"
    end
  end
  if Content.bSelectTag and CurContent and Content.Uuid == CurContent.Uuid then
    self:ClearSlot(self.CurSlotName)
    self:SetContentIsChosen(Content, false)
    self:UpdateCurrentUuid(Type, nil)
    if "Char" == Type then
      self:UpdateCharConflict()
    end
    if self.OnLeftItemContentChanged then
      self:OnLeftItemContentChanged()
    end
    return
  end
  if Content.bSelectTag then
    local OtherSlotInfo = self.Uuid2SlotMap[Content.Uuid]
    if OtherSlotInfo and self.Slots[OtherSlotInfo.SlotName] then
      local OtherSlotWidget = self.Slots[OtherSlotInfo.SlotName]
      if CurContent then
        self:SetContentIsChosen(CurContent, false)
      end
      if OtherSlotWidget then
        self:SetContentIsChosen(Content, false)
      end
      if CurContent then
        self:UpdateSlot(OtherSlotInfo.SlotName, CurContent)
        self:HandleHyperWeaponConflictAfterEquip(OtherSlotInfo.SlotName, CurContent)
        self:SetContentIsChosen(CurContent, true)
      else
        self:ClearSlot(OtherSlotInfo.SlotName)
        local OtherSlotType = Component.SlotName2Type[OtherSlotInfo.SlotName]
        self:UpdateCurrentUuid(OtherSlotType, nil)
        if "Char" == OtherSlotType then
          self:UpdateCharConflict()
        end
        if self.OnLeftItemContentChanged then
          self:OnLeftItemContentChanged()
        end
      end
      self:UpdateSlot(self.CurSlotName, Content)
      self:SetContentIsChosen(Content, true)
      self:UpdateCurrentUuid(Type, Content.Uuid)
      self:HandleHyperWeaponConflictAfterEquip(self.CurSlotName, Content)
      if "Char" == Type then
        self:UpdateCharConflict()
      end
      if self.OnLeftItemContentChanged then
        self:OnLeftItemContentChanged()
      end
      return
    end
  end
  if CurContent then
    self:SetContentIsChosen(CurContent, false)
  end
  self:UpdateSlot(self.CurSlotName, Content)
  self:SetContentIsChosen(Content, true)
  self:UpdateCurrentUuid(Type, Content.Uuid)
  self:HandleHyperWeaponConflictAfterEquip(self.CurSlotName, Content)
  if "Char" == Type then
    self:UpdateCharConflict()
  end
  if self.OnLeftItemContentChanged then
    self:OnLeftItemContentChanged()
  end
end

function Component:UpdateCharConflict()
  if not self.CharItemContentsArray then
    return
  end
  local EquippedConflictKeyToSlot = SquadPresetUtils.BuildEquippedCharConflictKeyToSlot(self.Slots, Component.SlotName2Type)
  local CurSlotName = self.CurSlotName or Component.ESlotName.Null
  for _, Content in ipairs(self.CharItemContentsArray) do
    if Content and Content.CharId then
      local IsConflict = false
      local Key = SquadPresetUtils.GetCharConflictKey(Content.CharId)
      local EquippedSlotName = EquippedConflictKeyToSlot[Key]
      if EquippedSlotName and EquippedSlotName ~= CurSlotName then
        IsConflict = true
      end
      if Content.bSelectTag then
        IsConflict = false
      end
      Content.IsConflict = IsConflict
      if Content.UI and Content.UI.SetConflict then
        Content.UI:SetConflict()
      end
    end
  end
end

function Component:UpdateCurrentUuid(Type, Uuid)
  SquadPresetUtils.UpdateCurrentUuidOnPage(self, Type, Uuid)
end

function Component:GetWeaponIdByContent(Content)
  if not Content or Content.Type ~= CommonConst.ArmoryType.Weapon then
    return nil
  end
  if Content.IsTryout then
    return Content.WeaponId
  end
  return Content.UnitId
end

function Component:IsHyperWeaponContent(Content)
  local WeaponId = self:GetWeaponIdByContent(Content)
  if not WeaponId then
    return false
  end
  return HyperWeaponUtils.IsHyperWeapon(WeaponId)
end

function Component:GetHyperWeaponConflictSlotName(SlotName)
  if SlotName == Component.ESlotName.MeleeWeapon then
    return Component.ESlotName.RangedWeapon
  end
  if SlotName == Component.ESlotName.RangedWeapon then
    return Component.ESlotName.MeleeWeapon
  end
  return nil
end

function Component:HandleHyperWeaponConflictAfterEquip(SlotName, Content)
  if not self:IsHyperWeaponContent(Content) then
    return
  end
  local ConflictSlotName = self:GetHyperWeaponConflictSlotName(SlotName)
  if not ConflictSlotName or not self.Slots then
    return
  end
  local ConflictSlotWidget = self.Slots[ConflictSlotName]
  local ConflictContent = ConflictSlotWidget and ConflictSlotWidget.Content
  if not ConflictContent or ConflictContent == Content or ConflictContent.Uuid == Content.Uuid then
    return
  end
  if not self:IsHyperWeaponContent(ConflictContent) then
    return
  end
  self:SetContentIsChosen(ConflictContent, false)
  self:ClearSlot(ConflictSlotName)
  self:UpdateCurrentUuid(Component.SlotName2Type[ConflictSlotName], nil)
  UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_HyperWeapon_CannotEquipAtSameTime"))
end

function Component:SetContentIsChosen(Content, IsChosen)
  if not Content then
    return
  end
  Content.bSelectTag = IsChosen
  if Content.SelfWidget then
    Content.SelfWidget:SetItemSelect(IsChosen)
    self:PlaySelectSound(IsChosen, Content.Type)
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
  local FirstContent = self:GetCurrentContentForSort()
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
  ArmoryUtils:SortItemContents(InOutContentArray, SortByAttrNames, SortType, FirstContent, Component.IsTryoutCmpFunc)
end

function Component:GetCurrentContentForSort()
  if self.CurSlotType == "Char" then
    if self.CurrentCharUuid and self.CharItemContentsMap then
      return self.CharItemContentsMap[self.CurrentCharUuid]
    end
  elseif self.CurSlotType == "Pet" then
    if self.CurrentPetUuid and self.PetItemContentsMap then
      return self.PetItemContentsMap[self.CurrentPetUuid]
    end
  elseif self.CurSlotType == "Melee" or self.CurSlotType == "Ranged" then
    local CurrentUuidName = "Current" .. self.CurSlotType .. "Uuid"
    if self[CurrentUuidName] and self[self.CurSlotType .. "ItemContentsMap"] then
      return self[self.CurSlotType .. "ItemContentsMap"][self[CurrentUuidName]]
    end
  end
  return nil
end

function Component:FilterItemContents(InContentArray, FilterIdxes)
  local filterTags
  if self.CurSlotType == "Weapon" then
    filterTags = self[self.CurWeaponType .. "FilterTags"]
  else
    filterTags = self[self.CurSlotType .. "FilterTags"]
  end
  return SquadPresetUtils.FilterItemContents(self.CurSlotType, self.CurWeaponType, filterTags, Component.SlotType2DataType, InContentArray, FilterIdxes)
end

function Component:OnItemIsHoverChanged(ItemContent, bHovered)
  if not ItemContent or not ItemContent.Uuid then
    return
  end
  if self.IsUseGamePad then
    self:ShowItemDetails(bHovered and ItemContent.Type ~= "Char", ItemContent)
  end
end

function Component:OnSortListSelectionsChanged()
  SquadPresetUtils.OnSortListOrTypeChanged(self)
end

function Component:OnSortTypeChanged()
  SquadPresetUtils.OnSortListOrTypeChanged(self)
end

function Component:OnFilterListItemClicked(Content)
  if not Content then
    return
  end
  if Content.IsSelected then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
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

function Component:OnFilterListItemInited(Content, EntryUI)
  if Content and EntryUI then
    Content.UI = EntryUI
    if Content.IsSelected then
      EntryUI:SetIsSelected(true)
    end
  end
end

function Component:OnListInited(bListEmpty)
  self.bListEmpty = bListEmpty
  if self.bItemDetailsShowed then
    self:ShowItemDetails(false)
  end
  self:UpdateTeamIcons()
  if self.InitNavigation then
    self:InitNavigation()
  end
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

function Component:AttachTipsWidget(Widget)
  if self.Pos_Tip then
    self.Pos_Tip:AddChild(Widget)
  end
end

function Component:NewItemContent(Target, Type, Tag)
  return SquadPresetUtils.NewItemContent(Target, Type, Tag)
end

function Component:NewPetItemContent(Target)
  return SquadPresetUtils.NewPetItemContent(Target)
end

function Component:NewTrialCharContent(RuleId)
  return SquadPresetUtils.NewTrialCharContent(RuleId)
end

function Component:NewTrialWeaponContent(RuleId, WeaponTag)
  return SquadPresetUtils.NewTrialWeaponContent(RuleId, WeaponTag)
end

function Component:NewTrialPetContent(PetId)
  return SquadPresetUtils.NewTrialPetContent(PetId)
end

function Component:CallFunctionByName(FunctionName, ...)
  return SquadPresetUtils.CallFunctionByName(self, FunctionName, ...)
end

function Component:GetCurrentContent()
  return self:GetCurrentContentForSort()
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
  return SquadPresetUtils.GetTeamTableFromSlots(self.Slots)
end

function Component:UpdateTeamIcons()
  SquadPresetUtils.UpdateTeamIconsForPage(self)
end

function Component:ClearAllSlots()
  if not self.Slots then
    return
  end
  for SlotName, SlotWidget in pairs(self.Slots) do
    if SlotWidget and SlotWidget.Content then
      self:SetContentIsChosen(SlotWidget.Content, false)
    end
  end
  for SlotName, SlotWidget in pairs(self.Slots) do
    if SlotWidget and SlotWidget.Clear then
      SlotWidget:Clear()
    end
  end
  self.CurrentCharUuid = nil
  self.CurrentPetUuid = nil
  local WeaponTags = {
    CommonConst.ArmoryTag.Melee,
    CommonConst.ArmoryTag.Ranged
  }
  for _, Tag in pairs(WeaponTags) do
    self["Current" .. Tag .. "Uuid"] = nil
  end
  self:UpdateCharConflict()
end

function Component:OnBackgroundClicked()
  if self.bItemDetailsShowed then
    self:ShowItemDetails(false)
  end
end

function Component:UpdateSlot(SlotName, Content)
  local SlotWidget = self.Slots[SlotName]
  if SlotWidget and SlotWidget.Update then
    SlotWidget:Update(Content)
    SlotWidget.Content = Content
    Content.bSelectTag = true
  end
end

function Component:GetCurrentUuid(SlotName)
  local SlotWidget = self.Slots[SlotName]
  if SlotWidget then
    return SlotWidget.Uuid
  end
  return nil
end

function Component:GetWeaponType(SlotName)
  local SlotWidget = self.Slots[SlotName]
  if SlotWidget then
    return SlotWidget.WeaponType or "Melee"
  end
  return "Melee"
end

function Component:ClearSlot(SlotName)
  local SlotWidget = self.Slots[SlotName]
  if SlotWidget and SlotWidget.Clear then
    local SlotType = Component.SlotName2Type[SlotName]
    SlotWidget:Clear()
    if "Char" == SlotType then
      self:UpdateCharConflict()
    end
  end
end

function Component:ShowItemDetails(bShow, Content)
  if bShow then
    if self.bListEmpty then
      return
    end
    if Content.Type == "Char" then
      return
    end
    if self.ItemDetailsContent ~= Content then
      self.ItemDetailsWidget:RefreshItemInfo(Content, true)
    end
    self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.ItemDetailsWidget:StopAnimation(self.ItemDetailsWidget.Out)
    self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.In)
    self.bItemDetailsShowed = true
  elseif self.ItemDetailsWidget then
    self.bItemDetailsShowed = false
    self.ItemDetailsWidget:StopAnimation(self.ItemDetailsWidget.In)
    self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.Out)
  end
  self.ItemDetailsContent = Content
end

function Component:InitItemDetailWidget()
  if self.ItemDetailsWidget then
    self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.ItemDetailsWidget:DestroyObject()
  end
  self.ItemDetailsWidget = UIManager(self):_CreateWidgetNew("ItemDetailsMain")
  self:AttachTipsWidget(self.ItemDetailsWidget)
  self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.ItemDetailsWidget.Key_Confirm:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    },
    Desc = GText("UI_CTL_Add/Remove")
  })
  self.ItemDetailsWidget.Key_Confirm:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.ItemDetailsWidget.Key_Back:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.ItemDetailsWidget.bIsFocusable = false
  self.bItemDetailsShowed = false
  self.ItemDetailsContent = nil
end

return Component
