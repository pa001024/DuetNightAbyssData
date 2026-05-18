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

function Component:InitSquadBuildWidget(Slots, List_Select, Sort, EMListView_Filter, Pos_Tip, Tab_Primary, Empty, Text_Empty, Type_Range, Type_Melee, Owner, Panel_FilterTab)
  self.Slots = Slots or {}
  self.List_Select = List_Select
  self.Sort = Sort
  self.EMListView_Filter = EMListView_Filter
  self.Panel_FilterTab = Panel_FilterTab
  self.Pos_Tip = Pos_Tip
  self.Tab_Primary = Tab_Primary
  self.Text_Empty = Text_Empty
  self.Empty = Empty
  self.CurSlotName = Component.ESlotName.Null
  self.CurSlotType = ""
  self.CurWeaponType = "Melee"
  self.Type_Range = Type_Range
  self.Type_Melee = Type_Melee
  self.TypeTabs = {
    [self.SlotName2Type[self.ESlotName.RangedWeapon]] = self.Type_Range,
    [self.SlotName2Type[self.ESlotName.MeleeWeapon]] = self.Type_Melee
  }
  self.Type_Range:Init(self.SlotName2Type[self.ESlotName.RangedWeapon], self)
  self.Type_Melee:Init(self.SlotName2Type[self.ESlotName.MeleeWeapon], self)
  self.Uuid2SlotMap = {}
  self.bListEmpty = false
  self.SelectedContent = nil
  self.DungeonIndex = 1
  self:InitSelectiveList()
  self:BindSlotEvents()
  self:BindListEvents()
  self.Owner = Owner
end

function Component:InitSquadBuildData(TrialData)
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
end

function Component:BindSlotEvents()
  SquadPresetUtils.BindSquadSlotEvents(self)
end

function Component:BindListEvents()
  SquadPresetUtils.BindSquadListEvents(self)
end

function Component:OnSlotClicked(SlotName, bIsInit)
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
  if self.UpdateListSelect and not bIsInit then
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

function Component:CharMain_Init(NeedInit)
  if NeedInit then
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
      if not bSkipAltProtagonist and self:CheckInLimitList(CharId, self.LimitData and self.LimitData.LimitCharacters) then
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

function Component:PetMain_Init(NeedInit)
  if NeedInit then
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
      if self:CheckPetType(Pet.PetId) and self:CheckInLimitList(Pet.PetId, self.LimitData and self.LimitData.LimitPets) then
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

function Component:MeleeMain_Init(NeedInit)
  self.WeaponTag = CommonConst.ArmoryTag.Melee
  self:WeaponMain_Init(NeedInit)
end

function Component:RangedMain_Init(NeedInit)
  self.WeaponTag = CommonConst.ArmoryTag.Ranged
  self:WeaponMain_Init(NeedInit)
end

function Component:WeaponMain_Init(NeedInit)
  self.CurrentWeaponUuidName = "Current" .. self.WeaponTag .. "Uuid"
  if NeedInit then
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
        local WeaponId = Weapon.WeaponId
        local LimitList
        if self.WeaponTag == CommonConst.ArmoryTag.Melee then
          LimitList = self.LimitData and self.LimitData.LimitMeleeWeapons
        elseif self.WeaponTag == CommonConst.ArmoryTag.Ranged then
          LimitList = self.LimitData and self.LimitData.LimitRangedWeapons
        end
        if self:CheckInLimitList(WeaponId, LimitList) then
          Obj = self:NewItemContent(Weapon, CommonConst.ArmoryType.Weapon, self.WeaponTag)
          self["BP_" .. self.WeaponTag .. "ItemContents"]:Add(Obj)
          table.insert(ItemContentsArray, Obj)
          ItemContentsMap[Uuid] = Obj
        end
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
      FilterContentObj_All.Owner = self
      self.EMListView_Filter:AddItem(FilterContentObj_All)
      self.FilterContentObj_All = FilterContentObj_All
      for Index, FilterTag in ipairs(Filters) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        for key, value in pairs(FilterTag) do
          Obj[key] = value
        end
        Obj.Index = Index
        Obj.Owner = self
        self.EMListView_Filter:AddItem(Obj)
      end
      self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.Visible)
    else
      self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.Collapsed)
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
  if self.LastSelectedListItemContent and self.LastSelectedListItemContent.SelfWidget then
    self.LastSelectedListItemContent.SelfWidget:SetSelected(false)
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
  SquadPresetUtils.PhantomWeaponTypeChanged(self, Type, IsPlaySound, bSlotChanged, "SquadBuildComponent")
end

function Component:EquipItemToSlot(Content, ModIndex, NeedShowModIndexInfo)
  if not Content or not Content.Uuid then
    return
  end
  local CurSlotWidget = self.Slots[self.CurSlotName]
  if not CurSlotWidget then
    return
  end
  if Content.bConflict then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_OnlyOneChar"))
    return
  end
  if ModIndex then
    Content.ModSuitIndex = ModIndex
  end
  if nil ~= NeedShowModIndexInfo then
    Content.NeedShowModIndexInfo = NeedShowModIndexInfo
  else
    Content.NeedShowModIndexInfo = nil ~= ModIndex
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
  if Content.IsChosen then
    local OtherSlotInfo = self.Uuid2SlotMap[Content.Uuid]
    if OtherSlotInfo and self.Slots[OtherSlotInfo.SlotName] then
      if CurContent == Content then
        return
      end
      local OtherSlotWidget = self.Slots[OtherSlotInfo.SlotName]
      if CurContent then
        self:SetContentIsChosen(CurContent, false)
      end
      if CurContent then
        self:UpdateSlot(OtherSlotInfo.SlotName, CurContent)
        self:HandleHyperWeaponConflictAfterEquip(OtherSlotInfo.SlotName, CurContent)
        self:SetContentIsChosen(CurContent, true)
      else
        self:ClearSlot(OtherSlotInfo.SlotName)
      end
      self:UpdateSlot(self.CurSlotName, Content)
      self:SetContentIsChosen(Content, true)
      self:UpdateCurrentUuid(Type, Content.Uuid)
      self:HandleHyperWeaponConflictAfterEquip(self.CurSlotName, Content)
      if "Char" == Type then
        self:UpdateCharConflict()
      end
      self:PopChangeRoleToastByType(Content, self.CurSlotName)
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

function Component:OnListItemClicked(Content)
  if not Content or not Content.Uuid then
    return
  end
  self:PlaySelectSound(Content.bInGear, Content.Type)
  if self.LastSelectedListItemContent and self.LastSelectedListItemContent ~= Content and self.LastSelectedListItemContent.SelfWidget then
    self.LastSelectedListItemContent.SelfWidget:SetSelected(false)
  end
  if Content.SelfWidget then
    Content.SelfWidget:SetSelected(true)
  end
  self.LastSelectedListItemContent = Content
  if not self.IsUseGamePad and self.ItemDetailWidget then
    self:ShowItemDetails(not self:IsChar(), Content)
  end
  local IsPhantomSlot = self.CurSlotName == Component.ESlotName.Phantom1 or self.CurSlotName == Component.ESlotName.PhantomWeapon1 or self.CurSlotName == Component.ESlotName.Phantom2 or self.CurSlotName == Component.ESlotName.PhantomWeapon2
  if Content.IsTryout then
    self:EquipItemToSlot(Content, nil)
    self:PlayEquipSound(Content.Type)
    self:CloseTips()
    return
  end
  if IsPhantomSlot then
    self:EquipItemToSlot(Content, 1, false)
    self:PlayEquipSound(Content.Type)
    return
  end
  self:OpenTips(Content)
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
      if Content.IsChosen then
        IsConflict = false
      end
      Content.bConflict = IsConflict
      if Content.SelfWidget then
        Content.SelfWidget:SetItemConflict(IsConflict)
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
  Content.IsChosen = IsChosen
  if not IsChosen then
    Content.WeaponMiniPhantomIconCharId = nil
    Content.bInGear = false
  elseif not Content.WeaponMiniPhantomIconCharId then
    Content.bInGear = true
  end
  if Content.SelfWidget then
    Content.SelfWidget:SetInGear(Content.bInGear)
    Content.SelfWidget:SetWeaponMiniPhantomIcon(Content.WeaponMiniPhantomIconCharId)
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
  end
end

function Component:PlayEquipSound(Type)
  AudioManager(self):PlayUISound(self, EquipSoundPaths[Type] or EquipSoundPaths.Default, nil, nil)
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

function Component:CheckInLimitList(Id, LimitList)
  if not (self.LimitData and LimitList) or 0 == #LimitList then
    return true
  end
  for _, LimitId in ipairs(LimitList) do
    if LimitId == Id then
      return true
    end
  end
  return false
end

function Component:NewItemContent(Target, Type, Tag)
  return SquadPresetUtils.NewItemContent(Target, Type, Tag)
end

function Component:NewPetItemContent(Target)
  return SquadPresetUtils.NewPetItemContent(Target)
end

function Component:NewTrialCharContent(RuleId)
  return SquadPresetUtils.NewTrialCharContent(RuleId, GText("UI_Wuyousheng_ArmoryTrial"))
end

function Component:NewTrialWeaponContent(RuleId, WeaponTag)
  return SquadPresetUtils.NewTrialWeaponContent(RuleId, WeaponTag, GText("UI_Wuyousheng_ArmoryTrial"))
end

function Component:NewTrialPetContent(PetId)
  return SquadPresetUtils.NewTrialPetContent(PetId, GText("UI_Wuyousheng_ArmoryTrial"))
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
  self:UpdateSquadModels()
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
  end
  Content.IsChosen = true
  if SlotName == Component.ESlotName.PhantomWeapon1 or SlotName == Component.ESlotName.PhantomWeapon2 then
    local PhantomSlotName = SlotName == Component.ESlotName.PhantomWeapon1 and Component.ESlotName.Phantom1 or Component.ESlotName.Phantom2
    local PhantomSlotWidget = self.Slots[PhantomSlotName]
    local PhantomCharId
    if PhantomSlotWidget and PhantomSlotWidget.Content and not PhantomSlotWidget.IsEmpty then
      PhantomCharId = PhantomSlotWidget.Content.CharId
    end
    if Content then
      Content.WeaponMiniPhantomIconCharId = PhantomCharId
      Content.bInGear = false
    end
  elseif Content then
    Content.WeaponMiniPhantomIconCharId = nil
    Content.bInGear = true
  end
  local SlotType = Component.SlotName2Type[SlotName]
  if "Char" == SlotType then
    self:UpdateSquadModels()
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
      self:UpdateSquadModels()
    end
  end
end

function Component:OpenTips(Content)
  self.CurClickItemInfo = Content
  self.Pos_Tips:ClearChildren()
  self.SquadItemTip = self:CreateWidgetNew("ComSquadItemTips")
  self.Pos_Tips:AddChild(self.SquadItemTip)
  self.IsTipsOpen = true
  self.Panel_Tips:SetVisibility(ESlateVisibility.Visible)
  self:PlayAnimation(self.Tips_In)
  self.SquadItemTip:SetVisibility(ESlateVisibility.Visible)
  local Params = {
    ItemInfo = self.CurClickItemInfo,
    Owner = self,
    MakeSureCallback = self.MakeSureCallback,
    GoToArmory = self.GoToArmory
  }
  self.SquadItemTip:InitWidget(Params)
  self:SetCurFocusArea("Tip")
  self:ChangeFocusMode(7)
end

function Component:CloseTips()
  if self.Pos_Tips:GetChildAt(0) then
    self.IsTipsOpen = false
    self.Panel_Tips:SetVisibility(ESlateVisibility.Collapsed)
    self:PlayAnimation(self.Tips_Out)
    self.SquadItemTip:CloseWidget()
    self.Pos_Tips:ClearChildren()
  end
end

function Component:SetCurFocusArea(CurFocusArea)
  self.CurGamepadArea = CurFocusArea
  DebugPrint("jly   SetCurFocusArea", self.CurGamepadArea)
end

function Component:MakeSureCallback(ModIndex)
  if not self.CurClickItemInfo then
    self:CloseTips(true)
    return
  end
  self:EquipItemToSlot(self.CurClickItemInfo, ModIndex, true)
  self:CloseTips(true)
end

function Component:GoToArmory()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  local bInSkillAndSafeToCancel = Player:CharacterInTag("Skill") and Player:IsSafeToCancelSkill()
  if Player:CanEnterInteractive() and (Player:CharacterInTag("Interactive") or Player:CharacterInTag("Idle") or bInSkillAndSafeToCancel) and Player.PlayerAnimInstance and (Player.PlayerAnimInstance.IdletagName == "0" or Player.PlayerAnimInstance.IdletagName == "EmoIdle") and (not self.IsFromDungeonPage or not UIManager(self):GetArmoryUIObj()) then
    if bInSkillAndSafeToCancel then
      Player:StopSkill(UE.ESkillStopReason.ArmoryCancel)
    end
  else
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Toast_Armory_Forbid"))
    return
  end
  local Params = {}
  if self.CurClickItemInfo then
    Params = {
      bNoEndCamera = true,
      bHideSquadBuildBtn = true,
      bHideBoxBtn = true,
      bHideDeployBtn = true,
      OnCloseDelegate = {
        self,
        function()
          self:OnArmoryDetailClosed()
        end
      }
    }
  else
    Params = {
      bNoEndCamera = true,
      bHideSquadBuildBtn = true,
      bHideBoxBtn = true,
      bHideDeployBtn = true,
      MainTabName = ArmoryUtils.ArmoryMainTabNames.BattleWheel,
      BattleWheelIndex = self.Roulette.Id
    }
  end
  if self.CurSlotType == "Char" then
    Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Char
    Params.CharUuids = {
      self.CurClickItemInfo.Uuid
    }
    Params.bHideMeleeTab = true
    Params.bHideRangedTab = true
    Params.bHideWeaponTab = true
    Params.bHidePetTab = true
    Params.bHideBattleWheel = true
    Params.bHideUltraTab = true
  elseif self.CurSlotType == "Melee" then
    Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Melee
    Params.WeaponUuids = {
      self.CurClickItemInfo.Uuid
    }
    Params.bHideCharTab = true
    Params.bHideRangedTab = true
    Params.bHideWeaponTab = true
    Params.bHidePetTab = true
    Params.bHideBattleWheel = true
    Params.bHideUltraTab = true
  elseif self.CurSlotType == "Ranged" then
    Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Ranged
    Params.WeaponUuids = {
      self.CurClickItemInfo.Uuid
    }
    Params.bHideMeleeTab = true
    Params.bHideCharTab = true
    Params.bHideWeaponTab = true
    Params.bHidePetTab = true
    Params.bHideBattleWheel = true
    Params.bHideUltraTab = true
  elseif self.CurSlotType == "Pet" then
    Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.Pet
    Params.PetUniqueIds = {
      self.CurClickItemInfo.Uuid
    }
    Params.bHideCharTab = true
    Params.bHideMeleeTab = true
    Params.bHideRangedTab = true
    Params.bHideWeaponTab = true
    Params.bHideBattleWheel = true
    Params.bHideUltraTab = true
  else
    Params.MainTabName = ArmoryUtils.ArmoryMainTabNames.BattleWheel
    Params.bHideCharTab = true
    Params.bHideMeleeTab = true
    Params.bHideRangedTab = true
    Params.bHideWeaponTab = true
    Params.bHidePetTab = true
    Params.bHideUltraTab = true
  end
  self:CloseTips()
  UIManager(self):LoadUINew("ArmoryDetail", Params)
end

function Component:OnArmoryDetailClosed()
  local CharSlotEnums = {
    Component.ESlotName.Char,
    Component.ESlotName.Phantom1,
    Component.ESlotName.Phantom2
  }
  local Snapshot = {}
  for _, EName in ipairs(CharSlotEnums) do
    local Sw = self.Slots and self.Slots[EName]
    if Sw and not Sw.IsEmpty and Sw.Content then
      local C = Sw.Content
      Snapshot[EName] = {
        Uuid = C.Uuid,
        IsTryout = C.IsTryout,
        ModSuitIndex = C.ModSuitIndex
      }
    end
  end
  self:CharMain_Init(true)
  for _, EName in ipairs(CharSlotEnums) do
    local Snap = Snapshot[EName]
    if Snap then
      local NewContent = self.CharItemContentsMap and self.CharItemContentsMap[Snap.Uuid]
      if NewContent then
        if Snap.ModSuitIndex then
          NewContent.ModSuitIndex = Snap.ModSuitIndex
        end
        self:UpdateSlot(EName, NewContent)
        self:SetContentIsChosen(NewContent, true)
      else
        self:ClearSlot(EName)
      end
    end
  end
  self:UpdateCharConflict()
  self:UpdateSquadModels()
end

function Component:GetWeaponTypeList(WeaponIdList)
  return SquadPresetUtils.GetWeaponTypeList(WeaponIdList)
end

function Component:UpdateSquadModels()
  if not self.Owner or not self.Owner.ActorController then
    return
  end
  local ActorController = self.Owner.ActorController
  if not ActorController.ChangeCharModel then
    return
  end
  local CharSlotWidget = self.Slots[Component.ESlotName.Char]
  if CharSlotWidget and CharSlotWidget.Content and CharSlotWidget.Content.Uuid then
    local Content = CharSlotWidget.Content
    local Avatar = GWorld:GetAvatar()
    local Char = Avatar and Avatar.Chars[Content.Uuid]
    local CharId = Char and Char.CharId or Content.CharId
    if CharId then
      local ProtagonistInfo = {
        CharId = CharId,
        Uuid = Content.Uuid
      }
      ActorController:ChangeCharModel(ProtagonistInfo, false, false, false, true)
      if Content.IsTryout then
        ActorController:ChangeCharAppearance({})
      end
      self.Owner.ActorController:HidePlayerActor("SuqadRole", false)
      self.Owner.ActorController:FixedCameraTransTimeOnce(0)
      self.Owner.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, nil)
    end
  else
    self.Owner.ActorController:HidePlayerActor("SuqadRole", true)
  end
end

function Component:GetCurrentSquad()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  local Squad = {}
  local ENameToSlotName = {}
  for SlotName, EName in pairs(self.ESlotName) do
    if type(EName) == "number" then
      ENameToSlotName[EName] = SlotName
    end
  end
  if self.Slots then
    for EName, Slot in pairs(self.Slots) do
      if not Slot or Slot.IsEmpty then
      else
        local SlotName = ENameToSlotName[EName]
        if not SlotName then
        else
          local SlotInfo = {}
          local IsTryout = Slot.IsTryout or false
          if IsTryout then
            SlotInfo.Id = Slot.UnitId
            SlotInfo.bTrial = true
          else
            if not Slot.Uuid then
              goto lbl_72
            end
            SlotInfo.Id = Slot.Uuid
            SlotInfo.bTrial = false
            if Slot.Content and Slot.Content.ModSuitIndex then
              SlotInfo.ModIndex = Slot.Content.ModSuitIndex
            end
          end
          Squad[SlotName] = SlotInfo
        end
      end
      ::lbl_72::
    end
  end
  return Squad
end

function Component:DeepEqualTable(t1, t2, visited)
  visited = visited or {}
  if t1 == t2 then
    return true
  end
  local type1 = type(t1)
  local type2 = type(t2)
  if type1 ~= type2 then
    return false
  end
  if "table" ~= type1 then
    return t1 == t2
  end
  local key1 = tostring(t1)
  local key2 = tostring(t2)
  local visitKey = key1 .. "|" .. key2
  if visited[visitKey] then
    return true
  end
  visited[visitKey] = true
  local count1 = 0
  local count2 = 0
  for _ in pairs(t1) do
    count1 = count1 + 1
  end
  for _ in pairs(t2) do
    count2 = count2 + 1
  end
  if count1 ~= count2 then
    return false
  end
  for k, v1 in pairs(t1) do
    local v2 = t2[k]
    if nil == v2 then
      return false
    end
    if type(v1) == "table" and type(v2) == "table" then
      if not self:DeepEqualTable(v1, v2, visited) then
        return false
      end
    elseif v1 ~= v2 then
      return false
    end
  end
  return true
end

function Component:IsSquadEmpty(Squad)
  if not Squad then
    return true
  end
  for _ in pairs(Squad) do
    return false
  end
  return true
end

function Component:IsSquadEqual(Squad1, Squad2)
  if not Squad1 and not Squad2 then
    return true
  end
  if not Squad1 then
    return self:IsSquadEmpty(Squad2)
  end
  if not Squad2 then
    return self:IsSquadEmpty(Squad1)
  end
  return self:DeepEqualTable(Squad1, Squad2)
end

function Component:GetCharName(CharId)
  return DataMgr.Char[CharId] and DataMgr.Char[CharId].CharName
end

function Component:GetWeaponName(WeaponId)
  return DataMgr.Weapon[WeaponId] and DataMgr.Weapon[WeaponId].WeaponName
end

function Component:PopChangeRoleToastByType(Content, SlotName)
  if not Content or not SlotName then
    return
  end
  local SlotType = self.SlotName2Type[SlotName]
  if not SlotType then
    return
  end
  local IsPhantom = SlotName == self.ESlotName.Phantom1 or SlotName == self.ESlotName.Phantom2
  local PhantomNum
  if SlotName == self.ESlotName.Phantom1 then
    PhantomNum = 1
  elseif SlotName == self.ESlotName.Phantom2 then
    PhantomNum = 2
  end
  local IsPhantomWeapon = SlotName == self.ESlotName.PhantomWeapon1 or SlotName == self.ESlotName.PhantomWeapon2
  local PhantomWeaponNum
  if SlotName == self.ESlotName.PhantomWeapon1 then
    PhantomWeaponNum = 1
  elseif SlotName == self.ESlotName.PhantomWeapon2 then
    PhantomWeaponNum = 2
  end
  if SlotName == self.ESlotName.Char then
    local CharName = self:GetCharName(Content.UnitId)
    if CharName then
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchChar_Toast"), GText(CharName)))
    end
  elseif IsPhantom then
    local CharName = self:GetCharName(Content.UnitId)
    if CharName and PhantomNum then
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchSigil_Toast"), GText(CharName), GText("UI_Squad_Sigil" .. PhantomNum)))
    end
  elseif IsPhantomWeapon then
    local WeaponName = self:GetWeaponName(Content.UnitId)
    if WeaponName and PhantomWeaponNum then
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchSigil_Toast"), GText(WeaponName), GText("UI_Squad_Sigil" .. PhantomWeaponNum)))
    end
  elseif SlotName == self.ESlotName.MeleeWeapon or SlotName == self.ESlotName.RangedWeapon then
    local WeaponName = self:GetWeaponName(Content.UnitId)
    if WeaponName then
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Squad_SwitchChar_Toast"), GText(WeaponName)))
    end
  end
end

return Component
