local UIUtils = require("Utils.UIUtils")
local CharModel = require("BluePrints.Common.MVC.Model.CharModel")
local M = {}
M.ESlotName = {
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
M.SlotNameOrder = {
  "Char",
  "MeleeWeapon",
  "RangedWeapon",
  "Phantom1",
  "PhantomWeapon1",
  "Phantom2",
  "PhantomWeapon2",
  "Pet"
}
M.SlotName2Type = {
  [M.ESlotName.Char] = "Char",
  [M.ESlotName.Pet] = "Pet",
  [M.ESlotName.RangedWeapon] = "Ranged",
  [M.ESlotName.MeleeWeapon] = "Melee",
  [M.ESlotName.Phantom1] = "Char",
  [M.ESlotName.PhantomWeapon1] = "Weapon",
  [M.ESlotName.Phantom2] = "Char",
  [M.ESlotName.PhantomWeapon2] = "Weapon"
}
M.SlotType2DataType = {
  Char = "Char",
  Pet = "Pet",
  Weapon = "Weapon",
  Ranged = "Weapon",
  Melee = "Weapon"
}

function M.GetCharConflictKey(CharId)
  if not CharId then
    return nil
  end
  local SwitchRow = DataMgr.CharacterAttributeSwitch and DataMgr.CharacterAttributeSwitch[CharId]
  if SwitchRow and SwitchRow.CharGroupId ~= nil then
    return "ProtagonistAttr_" .. tostring(SwitchRow.CharGroupId)
  end
  return "CharId_" .. tostring(CharId)
end

function M.BuildEquippedCharConflictKeyToSlot(slots, slotName2Type)
  local map = {}
  for slotName, slotWidget in pairs(slots) do
    if slotWidget and slotWidget.Content then
      local slotType = slotName2Type[slotName]
      if "Char" == slotType then
        local content = slotWidget.Content
        if content and content.CharId then
          map[M.GetCharConflictKey(content.CharId)] = slotName
        end
      end
    end
  end
  return map
end

function M.IsTryoutCmpFunc(a, b)
  if a.IsTryout ~= b.IsTryout then
    if a.IsTryout then
      return true
    end
    return false
  end
  return nil
end

function M.TableContains(tbl, value)
  if type(tbl) ~= "table" then
    return tbl == value
  end
  for _, v in pairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

function M.GetWeaponTypeList(weaponIdList)
  local meleeList = {}
  local rangedList = {}
  if not weaponIdList then
    return meleeList, rangedList
  end
  for _, weaponId in pairs(weaponIdList) do
    local weaponData = DataMgr.BattleWeapon[weaponId]
    local templateWeaponData = DataMgr.WeaponTemplate[weaponId]
    local weaponType
    if weaponData then
      weaponType = weaponData.WeaponTag
    elseif templateWeaponData then
      weaponData = DataMgr.BattleWeapon[templateWeaponData.WeaponId]
      if weaponData then
        weaponType = weaponData.WeaponTag
      end
    end
    if weaponType then
      if M.TableContains(weaponType, "Melee") then
        meleeList[#meleeList + 1] = weaponId
      end
      if M.TableContains(weaponType, "Ranged") then
        rangedList[#rangedList + 1] = weaponId
      end
    end
  end
  return meleeList, rangedList
end

function M.CheckPetType(petId)
  return 1 == DataMgr.Pet[petId].PetType
end

function M.CreateFilters(inTags, inTexts, inIcons)
  local filters = {}
  for i, _ in ipairs(inTags) do
    table.insert(filters, {
      Tag = inTags[i],
      Text = inTexts[i],
      Icon = inIcons[i]
    })
  end
  return filters
end

function M.FilterItemContents(curSlotType, curWeaponType, filterTags, slotType2DataType, inContentArray, filterIdxes)
  local dataType = slotType2DataType[curSlotType]
  local filteredItems = {}
  local filterFunc
  if "Char" == dataType then
    function filterFunc(filterTag, content)
      return filterTag == content.Attribute
    end
  elseif "Weapon" == dataType then
    local avatar = GWorld:GetAvatar()
    
    function filterFunc(filterTag, content)
      if content.IsTryout then
        local weaponInfo = DataMgr.BattleWeapon[content.WeaponId]
        if weaponInfo then
          for _, tag in ipairs(weaponInfo.WeaponTag) do
            if tag == filterTag then
              return true
            end
          end
        end
        return false
      end
      local weapon = avatar.Weapons[content.Uuid]
      return weapon and weapon:HasTag(filterTag)
    end
  elseif "Pet" == dataType then
    function filterFunc()
      return true
    end
  end
  if filterFunc and filterTags then
    for _, content in ipairs(inContentArray) do
      if content then
        for _, idx in ipairs(filterIdxes) do
          if filterTags[idx] and filterFunc(filterTags[idx], content) then
            table.insert(filteredItems, content)
            break
          end
        end
      end
    end
  end
  return filteredItems
end

function M.InitSelectiveListMetadata(page)
  page.OrderByDisplayNames = {
    "UI_LEVEL_SELECT"
  }
  page.OrderByAttrNames = {
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }
  page.PetOrderByAttrNames = {
    "BreakNum",
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }
  page.CharFilterTags, page.CharFilterNames = UIUtils.GetAllElementTypes()
  page.CharFilterIcons = {}
  for _, tag in ipairs(page.CharFilterTags) do
    local iconName = "Armory_" .. tag
    table.insert(page.CharFilterIcons, "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. iconName .. ".T_" .. iconName)
  end
  page.MeleeFilterTags, page.MeleeFilterNames, page.RangedFilterTags, page.RangedFilterNames = UIUtils.GetAllWeaponTags()
  page.MeleeFilterIcons = {}
  for _, tag in ipairs(page.MeleeFilterTags) do
    local data = DataMgr.WeaponTag[tag]
    table.insert(page.MeleeFilterIcons, data and data.Icon)
  end
  page.RangedFilterIcons = {}
  for _, tag in ipairs(page.RangedFilterTags) do
    local data = DataMgr.WeaponTag[tag]
    table.insert(page.RangedFilterIcons, data and data.Icon)
  end
end

function M.BindSquadSlotEvents(lineupPage)
  local slots = lineupPage.Slots
  local E = M.ESlotName
  for slotName, slotWidget in pairs(slots) do
    if slotWidget then
      slotWidget:Init(slotName, lineupPage)
      if slotName == E.Phantom1 then
        slotWidget.WeaponSlot = slots[E.PhantomWeapon1]
      elseif slotName == E.Phantom2 then
        slotWidget.WeaponSlot = slots[E.PhantomWeapon2]
      elseif slotName == E.PhantomWeapon1 or slotName == E.PhantomWeapon2 then
        local phantomSlotName = slotName == E.PhantomWeapon1 and E.Phantom1 or E.Phantom2
        local phantomSlot = slots[phantomSlotName]
        if phantomSlot and phantomSlot.IsEmpty then
          slotWidget:SetForbidden(true)
        end
      end
    end
  end
end

function M.BindSquadListEvents(lineupPage)
  if lineupPage.List_Select then
    if lineupPage.List_Select.BP_OnItemClicked then
      lineupPage.List_Select.BP_OnItemClicked:Clear()
      lineupPage.List_Select.BP_OnItemClicked:Add(lineupPage, lineupPage.OnListItemClicked)
    end
    if lineupPage.List_Select.BP_OnItemIsHoveredChanged then
      lineupPage.List_Select.BP_OnItemIsHoveredChanged:Add(lineupPage, lineupPage.OnItemIsHoverChanged)
    end
  end
  if lineupPage.Sort then
    if lineupPage.Sort.BindEventOnSelectionsChanged then
      lineupPage.Sort:BindEventOnSelectionsChanged(lineupPage, lineupPage.OnSortListSelectionsChanged)
    end
    if lineupPage.Sort.BindEventOnSortTypeChanged then
      lineupPage.Sort:BindEventOnSortTypeChanged(lineupPage, lineupPage.OnSortTypeChanged)
    end
  end
  if lineupPage.EMListView_Filter then
    if lineupPage.EMListView_Filter.BP_OnItemClicked then
      lineupPage.EMListView_Filter.BP_OnItemClicked:Clear()
      lineupPage.EMListView_Filter.BP_OnItemClicked:Add(lineupPage, lineupPage.OnFilterListItemClicked)
    end
    if lineupPage.EMListView_Filter.BP_OnEntryInitialized then
      lineupPage.EMListView_Filter.BP_OnEntryInitialized:Add(lineupPage, lineupPage.OnFilterListItemInited)
    end
  end
end

function M.ReInitLineupSelectiveList(page)
  if not page.Slots[page.CurSlotName] then
    return
  end
  local slotWidget = page.Slots[page.CurSlotName]
  local uuid = slotWidget.Uuid
  if page.CurSlotType == "Weapon" then
    page["Current" .. page.CurWeaponType .. "Uuid"] = uuid
  else
    page["Current" .. page.CurSlotType .. "Uuid"] = uuid
  end
  local funcName
  if page.CurSlotType == "Weapon" then
    funcName = page.CurWeaponType .. "Main_Init"
  else
    funcName = page.CurSlotType .. "Main_Init"
  end
  M.CallFunctionByName(page, funcName)
  if page.ItemDetailWidget then
    page:InitItemDetailWidget()
  end
  page:FillSelectiveList()
end

function M.PhantomWeaponTypeChanged(page, typ, isPlaySound, bSlotChanged, logPrefix)
  if "Ranged" ~= typ and "Melee" ~= typ then
    DebugPrint((logPrefix or "SquadPresetUtils") .. ":PhantomWeaponTypeChanged:传入武器类型无效,", typ)
    return
  end
  if not bSlotChanged and not page:IsListAllowRefresh() then
    return
  end
  if page.CurWeaponType then
    if not bSlotChanged and typ == page.CurWeaponType then
      return
    end
    if page.TypeTabs and page.TypeTabs[page.CurWeaponType] then
      page.TypeTabs[page.CurWeaponType]:SetIsChecked(false)
    end
  end
  if page.TypeTabs and page.TypeTabs[typ] then
    page.TypeTabs[typ]:SetIsChecked(true, isPlaySound)
  end
  page.CurWeaponType = typ
  page.CurSlotType = page.CurWeaponType
  page:ReInitListItems()
end

function M.OnSortListOrTypeChanged(page)
  if not page.Sort then
    return
  end
  local sortByIdx, sortType = page.Sort:GetSortInfos()
  if page.SortItemContents then
    page:SortItemContents(page.FilteredContents, sortByIdx, sortType)
    page:FillListView()
  end
end

function M.CallFunctionByName(target, functionName, ...)
  local fn = target[functionName]
  if fn then
    return fn(target, ...)
  end
end

function M.UpdateCurrentUuidOnPage(page, typ, uuid)
  if "Char" == typ then
    page.CurrentCharUuid = uuid
  elseif "Pet" == typ then
    page.CurrentPetUuid = uuid
  elseif "Melee" == typ or "Ranged" == typ then
    page["Current" .. typ .. "Uuid"] = uuid
  end
end

function M.GetTeamTableFromSlots(slots)
  local nullChar = CommonConst.AbyssTeamNoChar
  local nullPet = CommonConst.AbyssTeamNoPet
  local E = M.ESlotName
  local teamTable = {
    Char = nullChar,
    MeleeWeapon = nullChar,
    RangedWeapon = nullChar,
    Phantom1 = nullChar,
    PhantomWeapon1 = nullChar,
    Phantom2 = nullChar,
    PhantomWeapon2 = nullChar,
    Pet = nullPet
  }
  for slotName, slotWidget in pairs(slots) do
    if slotName ~= E.Null and slotWidget then
      local u = slotWidget.Uuid
      if u then
        teamTable[slotName] = u
      end
    end
  end
  return teamTable
end

function M.UpdateTeamIconsForPage(page)
  if not page or not page.Slots then
    return
  end
  for slotName, slotWidget in pairs(page.Slots) do
    if slotWidget and slotWidget.Uuid and not slotWidget.IsEmpty then
      local typ = M.SlotName2Type[slotName]
      local isPhantomWeapon = false
      if "Weapon" == typ then
        typ = slotWidget.WeaponType or "Melee"
        if typ ~= page.CurSlotType then
        else
          isPhantomWeapon = true
          elseif typ ~= page.CurSlotType then
            goto lbl_55
          end
          local mapKey = typ .. "ItemContentsMap"
          if page[mapKey] then
            local content = page[mapKey][slotWidget.Uuid]
            if content and isPhantomWeapon then
              local phantomSlotName = slotName - 1
              local phantomSlotWidget = page.Slots[phantomSlotName]
            end
          end
        end
    end
    ::lbl_55::
  end
end

function M.NewItemContent(target, typ, tag)
  local obj = NewObject(UIUtils.GetCommonItemContentClass())
  obj.Uuid = target.Uuid
  obj.Type = typ
  obj.Tag = tag
  obj.UnitId = target[typ .. "Id"]
  obj.CharId = obj.UnitId
  obj.UnitName = target[typ .. "Name"]
  obj.Rarity = target[typ .. "Rarity"]
  obj.Icon = target:Data().Icon
  obj.GachaIcon = target:Data().GachaIcon
  obj.Level = target.Level
  obj.GradeLevel = target.GradeLevel
  obj.IsTryout = false
  obj.bIsHoverState = true
  obj.ConfirmDesc = "UI_CTL_Add/Remove"
  obj.Attribute = DataMgr["Battle" .. typ][obj.UnitId].Attribute
  local element = DataMgr["Battle" .. typ][obj.UnitId].Attribute
  if element then
    local iconName = "Armory_" .. element
    obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. iconName .. ".T_" .. iconName
  end
  obj.SortPriority = target:Data().SortPriority or 0
  return obj
end

function M.NewPetItemContent(target)
  local obj = NewObject(UIUtils.GetCommonItemContentClass())
  obj.Uuid = target.UniqueId
  obj.Type = CommonConst.ArmoryType.Pet
  obj.Tag = CommonConst.ArmoryType.Pet
  obj.UnitId = target.PetId
  local data = DataMgr.Pet[obj.UnitId]
  obj.UnitName = data.Name
  obj.Rarity = data.Rarity
  obj.Icon = data.Icon
  obj.Level = target.Level
  obj.BreakNum = target.BreakNum
  obj.IsTryout = false
  obj.bIsHoverState = true
  obj.ConfirmDesc = "UI_CTL_Add/Remove"
  obj.SortPriority = data.SortPriority or 0
  return obj
end

function M.NewTrialCharContent(ruleId, tryoutListLabelText)
  if not ruleId or not DataMgr.CharTemplate[ruleId] then
    return nil
  end
  local template = DataMgr.CharTemplate[ruleId]
  local charId = template.CharId
  if not charId then
    return nil
  end
  local charData = DataMgr.Char[charId]
  if not charData then
    return nil
  end
  local battleCharData = DataMgr.BattleChar[charId]
  if not battleCharData then
    return nil
  end
  local obj = NewObject(UIUtils.GetCommonItemContentClass())
  obj.Uuid = ruleId
  obj.Type = CommonConst.ArmoryType.Char
  obj.Tag = CommonConst.ArmoryTag.Char
  obj.UnitId = ruleId
  obj.CharId = charId
  obj.UnitName = charData.CharName or battleCharData.CharName
  obj.Rarity = charData.CharRarity or battleCharData.Rarity
  obj.Icon = charData.Icon
  obj.GachaIcon = charData.GachaIcon
  obj.Level = template.CharLevel or 1
  obj.GradeLevel = 0
  obj.IsTryout = true
  if nil ~= tryoutListLabelText then
    obj.SquadBuildTryOutText = tryoutListLabelText
  end
  obj.bIsHoverState = true
  obj.ConfirmDesc = "UI_CTL_Add/Remove"
  obj.Attribute = battleCharData.Attribute
  local element = battleCharData.Attribute
  if element then
    local iconName = "Armory_" .. element
    obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. iconName .. ".T_" .. iconName
  end
  obj.SortPriority = charData.SortPriority or 0
  return obj
end

function M.NewTrialWeaponContent(ruleId, weaponTag, tryoutListLabelText)
  if not ruleId or not DataMgr.WeaponTemplate[ruleId] then
    return nil
  end
  local template = DataMgr.WeaponTemplate[ruleId]
  local weaponId = template.WeaponId
  if not weaponId then
    return nil
  end
  local weaponData = DataMgr.Weapon[weaponId]
  if not weaponData then
    return nil
  end
  local battleWeaponData = DataMgr.BattleWeapon[weaponId]
  if not battleWeaponData then
    return nil
  end
  local obj = NewObject(UIUtils.GetCommonItemContentClass())
  obj.Uuid = ruleId
  obj.Type = CommonConst.ArmoryType.Weapon
  obj.Tag = weaponTag
  obj.UnitId = ruleId
  obj.UnitName = weaponData.WeaponName or battleWeaponData.Name
  obj.Rarity = weaponData.WeaponRarity or battleWeaponData.Rarity
  obj.Icon = weaponData.Icon
  obj.GachaIcon = weaponData.GachaIcon
  obj.Level = template.WeaponLevel or 1
  obj.GradeLevel = 0
  obj.WeaponId = weaponId
  obj.IsTryout = true
  if nil ~= tryoutListLabelText then
    obj.SquadBuildTryOutText = tryoutListLabelText
  end
  obj.bIsHoverState = true
  obj.ConfirmDesc = "UI_CTL_Add/Remove"
  obj.ItemId = weaponId
  local element = battleWeaponData.Attribute
  if element then
    local iconName = "Armory_" .. element
    obj.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. iconName .. ".T_" .. iconName
  end
  obj.SortPriority = weaponData.SortPriority or 0
  return obj
end

function M.NewTrialPetContent(petId, tryoutListLabelText)
  if not petId or not DataMgr.Pet[petId] then
    return nil
  end
  local petData = DataMgr.Pet[petId]
  local obj = NewObject(UIUtils.GetCommonItemContentClass())
  obj.Uuid = petId
  obj.Type = CommonConst.ArmoryType.Pet
  obj.Tag = CommonConst.ArmoryType.Pet
  obj.UnitId = petId
  obj.UnitName = petData.Name
  obj.Rarity = petData.Rarity
  obj.Icon = petData.Icon
  obj.Level = 1
  obj.BreakNum = 0
  obj.IsTryout = true
  if nil ~= tryoutListLabelText then
    obj.SquadBuildTryOutText = tryoutListLabelText
  end
  obj.bIsHoverState = true
  obj.ConfirmDesc = "UI_CTL_Add/Remove"
  obj.SortPriority = petData.SortPriority or 0
  return obj
end

function M.FixMainPlayerInProps(Avatar, Props)
  local MainPlayerCharId = AvatarUtils:GetMainPlayerCharacterAttributeCharId(Avatar)
  if not MainPlayerCharId or -1 == MainPlayerCharId then
    return nil
  end
  if not Props then
    return nil
  end
  local MainPlayerUuid = CharModel:GetUuidByCharId(MainPlayerCharId)
  if not MainPlayerUuid then
    return nil
  end
  local CharSlotNames = {
    "Char",
    "Phantom1",
    "Phantom2"
  }
  for _, SlotName in ipairs(CharSlotNames) do
    local Uuid = Props[SlotName] and Props[SlotName].Id
    if Uuid and "" ~= Uuid then
      local Char = Avatar.Chars[Uuid]
      local CharId = Char and Char.CharId
      if CharId and CharId ~= MainPlayerCharId and AvatarUtils:IsCharacterAttributeSwitchSameGroup(MainPlayerCharId, CharId) then
        Props[SlotName].Id = MainPlayerUuid
      end
    end
  end
end

return M
