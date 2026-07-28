require("UnLua")
local UIUtils = require("Utils.UIUtils")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local CommonUtils = require("Utils.CommonUtils")
local AvatarUtils = require("BluePrints.Client.AvatarUtils")
local WeaponVerifyUIModel = {}
WeaponVerifyUIModel.SlotType = {
  Char = 1,
  Melee = 2,
  Ranged = 3,
  Pet = 4,
  Affix = 5
}
WeaponVerifyUIModel.SlotState = {
  Empty = 1,
  Filled = 2,
  Missing = 3
}
WeaponVerifyUIModel._EditSelect = nil

function WeaponVerifyUIModel.GetAvatar()
  return GWorld and GWorld:GetAvatar() or nil
end

function WeaponVerifyUIModel.GetSaveData(EventId)
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  if not Avatar or not Avatar.WeaponVerifys then
    return nil
  end
  return Avatar.WeaponVerifys:GetWeaponVerify(EventId)
end

function WeaponVerifyUIModel.GetLevelSaveInfo(EventId, DungeonId)
  local SaveData = WeaponVerifyUIModel.GetSaveData(EventId)
  return SaveData and SaveData:GetLevelInfo(DungeonId) or nil
end

function WeaponVerifyUIModel.GetTmpLevelInfo(EventId, DungeonId)
  local SaveData = WeaponVerifyUIModel.GetSaveData(EventId)
  return SaveData and SaveData:GetTmpLevelInfo(DungeonId) or nil
end

function WeaponVerifyUIModel.IsLevelFinished(EventId, DungeonId)
  return WeaponVerifyUIModel.GetLevelStar(EventId, DungeonId) > 0
end

function WeaponVerifyUIModel.GetDefaultEventId()
  local Tbl = DataMgr.WeaponVerifyEventLevel
  if Tbl then
    for _, Cfg in pairs(Tbl) do
      if Cfg.EventId then
        return Cfg.EventId
      end
    end
  end
  return nil
end

function WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return DataMgr.WeaponVerifyEventLevel and DataMgr.WeaponVerifyEventLevel[DungeonId] or nil
end

function WeaponVerifyUIModel.GetLevelList(EventId, GroupId)
  local List = {}
  local Tbl = DataMgr.WeaponVerifyEventLevel
  if Tbl then
    for _, Cfg in pairs(Tbl) do
      if Cfg.EventId == EventId and (not GroupId or Cfg.GroupId == GroupId) then
        table.insert(List, Cfg)
      end
    end
  end
  table.sort(List, function(a, b)
    return a.EventLevelId < b.EventLevelId
  end)
  return List
end

function WeaponVerifyUIModel.GetGroupList(EventId)
  if DataMgr.WeaponVerifyEventGroup then
    local List = {}
    for _, Cfg in pairs(DataMgr.WeaponVerifyEventGroup) do
      if not Cfg.EventId or Cfg.EventId == EventId then
        table.insert(List, Cfg)
      end
    end
    table.sort(List, function(a, b)
      return a.GroupId < b.GroupId
    end)
    return List
  end
  local Seen, GroupIds = {}, {}
  for _, Cfg in pairs(WeaponVerifyUIModel.GetLevelList(EventId)) do
    if Cfg.GroupId and not Seen[Cfg.GroupId] then
      Seen[Cfg.GroupId] = true
      table.insert(GroupIds, {
        GroupId = Cfg.GroupId,
        EventId = EventId
      })
    end
  end
  table.sort(GroupIds, function(a, b)
    return a.GroupId < b.GroupId
  end)
  return GroupIds
end

function WeaponVerifyUIModel.GetLevelName(DungeonId)
  local Cfg = WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return Cfg and GText(Cfg.LevelName) or ""
end

function WeaponVerifyUIModel.GetLevelNumber(DungeonId)
  local Cfg = WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return Cfg and GText(Cfg.LevelNumber) or ""
end

function WeaponVerifyUIModel.GetLevelDesc(DungeonId)
  local Cfg = WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return Cfg and GText(Cfg.LevelDes) or ""
end

function WeaponVerifyUIModel.GetLevelType(DungeonId)
  local Cfg = WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return Cfg and Cfg.LevelType or 1
end

function WeaponVerifyUIModel.GetRecommendLevel(DungeonId)
  local Cfg = WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return Cfg and Cfg.RecomendLevel or 0
end

function WeaponVerifyUIModel.GetGlobalBuffIds(DungeonId)
  local Cfg = WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return Cfg and Cfg.GlobalBuff or {}
end

function WeaponVerifyUIModel.GetLevelBuffIds(DungeonId)
  local Cfg = WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return Cfg and Cfg.LevelBuff or {}
end

function WeaponVerifyUIModel.GetBuffDesc(BuffId)
  local EventBuff = DataMgr.WeaponVerifyEventBuff and DataMgr.WeaponVerifyEventBuff[BuffId]
  if EventBuff then
    return GText(EventBuff.Desc)
  end
  return nil
end

function WeaponVerifyUIModel.GetAffixGroup(DungeonId)
  local Cfg = WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return Cfg and Cfg.AffixGroup or {}
end

function WeaponVerifyUIModel.GetGroupAffixIds(GroupId)
  local Cfg = DataMgr.WeaponVerifyEventGroup and DataMgr.WeaponVerifyEventGroup[GroupId]
  return Cfg and Cfg.AffixGroup or {}
end

function WeaponVerifyUIModel.GetAffixCfg(AffixId)
  return DataMgr.WeaponVerifyEntry and DataMgr.WeaponVerifyEntry[AffixId] or nil
end

function WeaponVerifyUIModel.GetMonsterDungeonInfo(DungeonId)
  local VerifyCfg = DataMgr.WeaponVerify and DataMgr.WeaponVerify[DungeonId]
  local DungeonMonsters = VerifyCfg and VerifyCfg.DungeonMonsters
  if not DungeonMonsters or #DungeonMonsters <= 0 then
    return nil
  end
  return {
    DungeonMonsters = DungeonMonsters,
    MonsterBuff = VerifyCfg.MonsterBuff
  }
end

function WeaponVerifyUIModel.GetStarTimes(DungeonId)
  local Cfg = WeaponVerifyUIModel.GetLevelCfg(DungeonId)
  return Cfg and Cfg.LevelGoalRequiredTime or {}
end

function WeaponVerifyUIModel.GetMaxStar(DungeonId)
  return #WeaponVerifyUIModel.GetStarTimes(DungeonId)
end

function WeaponVerifyUIModel.CalcStarByRemainTime(DungeonId, RemainTime)
  local Star = 0
  for _, Cond in ipairs(WeaponVerifyUIModel.GetStarTimes(DungeonId)) do
    if -1 == Cond or RemainTime and RemainTime >= Cond then
      Star = Star + 1
    end
  end
  return Star
end

function WeaponVerifyUIModel.GetLevelStar(EventId, DungeonId)
  local SaveData = WeaponVerifyUIModel.GetSaveData(EventId)
  return SaveData and SaveData:GetFinishStar(DungeonId) or 0
end

function WeaponVerifyUIModel.GetTotalStars(EventId)
  local SaveData = WeaponVerifyUIModel.GetSaveData(EventId)
  return SaveData and SaveData:GetTotalStars() or 0
end

function WeaponVerifyUIModel.GetActivityMaxStar(EventId)
  local Total = 0
  for _, Cfg in ipairs(WeaponVerifyUIModel.GetLevelList(EventId)) do
    Total = Total + WeaponVerifyUIModel.GetMaxStar(Cfg.EventLevelId)
  end
  return Total
end

function WeaponVerifyUIModel.IsGroupFinished(EventId, GroupId)
  local LevelList = WeaponVerifyUIModel.GetLevelList(EventId, GroupId)
  if 0 == #LevelList then
    return false
  end
  for _, Cfg in ipairs(LevelList) do
    if not WeaponVerifyUIModel.IsLevelFinished(EventId, Cfg.EventLevelId) then
      return false
    end
  end
  return true
end

function WeaponVerifyUIModel.IsGroupUnlocked(_, _)
  return true
end

function WeaponVerifyUIModel.GetLockedMap(EventId, ExcludeDungeonId)
  local SaveData = WeaponVerifyUIModel.GetSaveData(EventId)
  local Locked = {
    [WeaponVerifyUIModel.SlotType.Char] = {},
    [WeaponVerifyUIModel.SlotType.Melee] = {},
    [WeaponVerifyUIModel.SlotType.Ranged] = {},
    [WeaponVerifyUIModel.SlotType.Pet] = {},
    [WeaponVerifyUIModel.SlotType.Affix] = {}
  }
  if not SaveData or not SaveData.LevelInfo then
    return Locked
  end
  local ST = WeaponVerifyUIModel.SlotType
  for DungeonId, Info in pairs(SaveData.LevelInfo) do
    if DungeonId ~= ExcludeDungeonId and (Info.FinishStar or 0) > 0 then
      if Info.CharUuid then
        Locked[ST.Char][Info.CharUuid] = DungeonId
      end
      if Info.MeleeWeaponUuid then
        Locked[ST.Melee][Info.MeleeWeaponUuid] = DungeonId
      end
      if Info.RangedWeaponUuid then
        Locked[ST.Ranged][Info.RangedWeaponUuid] = DungeonId
      end
      if Info.PetUniqueId and 0 ~= Info.PetUniqueId then
        Locked[ST.Pet][Info.PetUniqueId] = DungeonId
      end
      if Info.AffixId and 0 ~= Info.AffixId then
        Locked[ST.Affix][Info.AffixId] = DungeonId
      end
    end
  end
  return Locked
end

function WeaponVerifyUIModel.GetLockedDungeonBySlot(EventId, SlotType, Value, ExcludeDungeonId)
  if not Value or 0 == Value then
    return nil
  end
  local Locked = WeaponVerifyUIModel.GetLockedMap(EventId, ExcludeDungeonId)
  local Map = Locked[SlotType]
  local LockLevel = Map and Map[Value]
  if SlotType == WeaponVerifyUIModel.SlotType.Char and not LockLevel then
    local Avatar = WeaponVerifyUIModel.GetAvatar()
    local Char = Avatar and Avatar.Chars[Value]
    if Char and DataMgr.CharacterAttributeSwitch[Char.CharId] then
      for Uuid, DungeonId in pairs(Map) do
        local SlotChar = Avatar.Chars[Uuid]
        if AvatarUtils:IsCharacterAttributeSwitchSameGroup(Char.CharId, SlotChar.CharId) then
          LockLevel = DungeonId
          break
        end
      end
    end
  end
  if LockLevel and LockLevel ~= ExcludeDungeonId then
    return LockLevel
  end
  return nil
end

function WeaponVerifyUIModel.InitEditSelect(EventId, DungeonId)
  local Info = WeaponVerifyUIModel.GetLevelSaveInfo(EventId, DungeonId)
  WeaponVerifyUIModel._EditSelect = {
    EventId = EventId,
    DungeonId = DungeonId,
    CharUuid = Info and Info.CharUuid or nil,
    MeleeWeaponUuid = Info and Info.MeleeWeaponUuid or nil,
    RangedWeaponUuid = Info and Info.RangedWeaponUuid or nil,
    PetUniqueId = Info and Info.PetUniqueId or 0,
    AffixId = Info and Info.AffixId or 0
  }
  return WeaponVerifyUIModel._EditSelect
end

function WeaponVerifyUIModel.GetEditSelect()
  return WeaponVerifyUIModel._EditSelect
end

function WeaponVerifyUIModel.SetEditSelect(SlotType, Value)
  local Sel = WeaponVerifyUIModel._EditSelect
  if not Sel then
    return
  end
  local ST = WeaponVerifyUIModel.SlotType
  if SlotType == ST.Char then
    Sel.CharUuid = Value
  elseif SlotType == ST.Melee then
    Sel.MeleeWeaponUuid = Value
  elseif SlotType == ST.Ranged then
    Sel.RangedWeaponUuid = Value
  elseif SlotType == ST.Pet then
    Sel.PetUniqueId = Value or 0
  elseif SlotType == ST.Affix then
    Sel.AffixId = Value or 0
  end
end

function WeaponVerifyUIModel.GetCurrentCharacterValue(SlotType, Value)
  if SlotType == WeaponVerifyUIModel.SlotType.Char then
    local Avatar = WeaponVerifyUIModel.GetAvatar()
    local SlotChar = Avatar and Avatar.Chars[Value]
    if SlotChar and DataMgr.CharacterAttributeSwitch[SlotChar.CharId] then
      local MainPlayerCharId = AvatarUtils:GetMainPlayerCharacterAttributeCharId(Avatar)
      if not MainPlayerCharId or MainPlayerCharId == SlotChar.CharId then
        return Value
      end
      for _, Char in pairs(Avatar.Chars or {}) do
        if MainPlayerCharId == Char.CharId then
          return Char.Uuid
        end
      end
    end
  end
  return Value
end

function WeaponVerifyUIModel.GetEditSelectValue(SlotType)
  local Sel = WeaponVerifyUIModel._EditSelect
  if not Sel then
    return nil
  end
  local ST = WeaponVerifyUIModel.SlotType
  if SlotType == ST.Char then
    return WeaponVerifyUIModel.GetCurrentCharacterValue(SlotType, Sel.CharUuid)
  end
  if SlotType == ST.Melee then
    return Sel.MeleeWeaponUuid
  elseif SlotType == ST.Ranged then
    return Sel.RangedWeaponUuid
  elseif SlotType == ST.Pet then
    return Sel.PetUniqueId
  elseif SlotType == ST.Affix then
    return Sel.AffixId
  end
end

local function BuildShortIconPath(Dir, Prefix, ShortName)
  if not ShortName or "" == ShortName then
    return nil
  end
  local ReplaceKey = string.gsub(ShortName, " ", "_")
  return string.format("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/%s/%s%s.%s%s'", Dir, Prefix, ReplaceKey, Prefix, ReplaceKey)
end

function WeaponVerifyUIModel.GetSlotIconPath(SlotType, Value)
  if not Value or 0 == Value then
    return nil
  end
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  local ST = WeaponVerifyUIModel.SlotType
  if SlotType == ST.Char then
    local Char = Avatar.Chars[Value]
    local CharCfg = Char and DataMgr.Char[Char.CharId]
    return CharCfg and BuildShortIconPath("Avatar", "T_Head_", CharCfg.GUIPathVariable) or nil
  elseif SlotType == ST.Melee or SlotType == ST.Ranged then
    local Weapon = Avatar.Weapons[Value]
    local WeaponCfg = Weapon and DataMgr.Weapon[Weapon.WeaponId]
    if not WeaponCfg or not WeaponCfg.GUIPathVariableName then
      return nil
    end
    return BuildShortIconPath("Weapon", "T_Head_", (WeaponCfg.GUIPathVariableType or "") .. "_" .. WeaponCfg.GUIPathVariableName)
  elseif SlotType == ST.Pet then
    local Pet = Avatar.Pets[Value]
    local PetCfg = Pet and DataMgr.Pet[Pet.PetId]
    return PetCfg and PetCfg.Icon and "Texture2D'" .. PetCfg.Icon .. "'" or nil
  elseif SlotType == ST.Affix then
    local Cfg = WeaponVerifyUIModel.GetAffixCfg(Value)
    return Cfg and (Cfg.IconPath or Cfg.Icon) or nil
  end
  return nil
end

local function FillSelectMeta(Content, EventId, DungeonId, SlotType)
  local Value = Content.UniqueId
  Content.SlotType = SlotType
  Content.IconPath = WeaponVerifyUIModel.GetSlotIconPath(SlotType, Value) or Content.Icon
  local bSelected = WeaponVerifyUIModel.GetEditSelectValue(SlotType) == Value
  local bOccupied = WeaponVerifyUIModel.GetLockedDungeonBySlot(EventId, SlotType, Value, DungeonId) ~= nil
  Content.bInGear = not bOccupied and WeaponVerifyUIModel.GetLockedDungeonBySlot(EventId, SlotType, Value, nil)
  Content.bSelectTag = bSelected
  Content.bOccupied = bOccupied
  Content.bShowNotHaveStyle = false
  Content.SortOwned = 1
  Content.SortSelected = bSelected and 1 or 0
  Content.SortUnlocked = bOccupied and 0 or 1
  Content.SortLevel = Content.Level or 0
  Content.SortId = Value
  return Content
end

local function FillUnownedMeta(Content, SlotType, UnitId)
  Content.SlotType = SlotType
  Content.bShowNotHaveStyle = true
  Content.bSelectTag = false
  Content.bOccupied = false
  Content.LockType = 2
  Content.SortOwned = 0
  Content.SortSelected = 0
  Content.SortUnlocked = 1
  Content.SortLevel = 0
  Content.SortId = UnitId or 0
  return Content
end

local function GetAttrIcon(TypeName, UnitId)
  local Tbl = TypeName and DataMgr["Battle" .. TypeName]
  local Cfg = Tbl and Tbl[UnitId]
  local Element = Cfg and Cfg.Attribute
  if not Element then
    return nil
  end
  local IconName = "Armory_" .. Element
  return "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
end

local function IsWeaponMatchSlot(Weapon, SlotType)
  if not Weapon or not Weapon.WeaponId then
    return false
  end
  local WeaponCfg = DataMgr.BattleWeapon and DataMgr.BattleWeapon[Weapon.WeaponId]
  local Tags = WeaponCfg and WeaponCfg.WeaponTag or {}
  local ST = WeaponVerifyUIModel.SlotType
  for _, Tag in pairs(Tags) do
    if SlotType == ST.Melee and ("Melee" == Tag or Tag == CommonConst.WeaponType.MeleeWeapon) then
      return true
    end
    if SlotType == ST.Ranged and ("Ranged" == Tag or Tag == CommonConst.WeaponType.RangedWeapon) then
      return true
    end
  end
  return false
end

local function AddWeaponContents(List, Weapons, EventId, DungeonId, SlotType, SlotTag)
  local OwnedIds = {}
  for _, Weapon in pairs(Weapons or {}) do
    if IsWeaponMatchSlot(Weapon, SlotType) then
      OwnedIds[Weapon.WeaponId] = true
      local Content = ArmoryUtils:NewCommonItemContent(Weapon, "Weapon")
      Content.UnitId = Weapon.WeaponId
      Content.UniqueId = Weapon.Uuid
      Content.Type = SlotTag
      Content.Tag = SlotTag
      Content.Level = Weapon.Level
      Content.AttrIcon = GetAttrIcon("Weapon", Weapon.WeaponId)
      table.insert(List, FillSelectMeta(Content, EventId, DungeonId, SlotType))
    end
  end
  return OwnedIds
end

local function MergeMap(Target, Source)
  for Key, Value in pairs(Source or {}) do
    Target[Key] = Value
  end
end

local function AddUnownedWeaponContents(List, OwnedIds, SlotType, SlotTag)
  for WeaponId, Cfg in pairs(DataMgr.Weapon or {}) do
    if not OwnedIds[WeaponId] and not Cfg.IsNotOpen and CommonUtils.IsCurrentVersionRelease(CommonConst.DataType.Weapon, WeaponId) and IsWeaponMatchSlot({WeaponId = WeaponId}, SlotType) then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.UnitId = WeaponId
      Content.Type = SlotTag
      Content.Tag = SlotTag
      Content.ItemType = "Weapon"
      Content.UnitName = Cfg.WeaponName and GText(Cfg.WeaponName) or ""
      Content.Rarity = Cfg.WeaponRarity or 0
      Content.Icon = Cfg.Icon or Cfg.GachaIcon
      if Cfg.GUIPathVariableName then
        Content.IconPath = BuildShortIconPath("Weapon", "T_Head_", (Cfg.GUIPathVariableType or "") .. "_" .. Cfg.GUIPathVariableName)
      end
      Content.IconPath = Content.IconPath or Content.Icon
      Content.Icon = Content.Icon or Content.IconPath
      Content.AttrIcon = GetAttrIcon("Weapon", WeaponId)
      Content.bHideItemLevel = true
      table.insert(List, FillUnownedMeta(Content, SlotType, WeaponId))
    end
  end
end

function WeaponVerifyUIModel.GetSelectableItems(EventId, DungeonId, SlotType)
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  local List = {}
  if not Avatar then
    return List
  end
  local ST = WeaponVerifyUIModel.SlotType
  if SlotType == ST.Char then
    local OwnedCharIds = {}
    local MainPlayerCharId = AvatarUtils:GetMainPlayerCharacterAttributeCharId(Avatar)
    for _, Char in pairs(Avatar.Chars or {}) do
      local CharId = Char.CharId
      OwnedCharIds[CharId] = true
      if not MainPlayerCharId or CharId == MainPlayerCharId or not AvatarUtils:IsCharacterAttributeSwitchSameGroup(MainPlayerCharId, CharId) then
        local Content = ArmoryUtils:NewCommonItemContent(Char, "Char")
        Content.UniqueId = Char.Uuid
        Content.UnitId = CharId
        Content.Type = "Char"
        Content.Tag = "Char"
        Content.Level = Char.Level
        Content.AttrIcon = GetAttrIcon("Char", CharId)
        table.insert(List, FillSelectMeta(Content, EventId, DungeonId, SlotType))
      end
    end
    for CharId, Cfg in pairs(DataMgr.Char or {}) do
      if not OwnedCharIds[CharId] and not Cfg.IsNotOpen and not DataMgr.CharacterAttributeSwitch[CharId] and CommonUtils.IsCurrentVersionRelease(CommonConst.DataType.Char, CharId) then
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.UnitId = CharId
        Content.Type = "Char"
        Content.Tag = "Char"
        Content.ItemType = "Char"
        Content.UnitName = Cfg.CharName and GText(Cfg.CharName) or ""
        Content.Rarity = Cfg.CharRarity or 0
        Content.Icon = Cfg.Icon or Cfg.GachaIcon
        Content.IconPath = BuildShortIconPath("Avatar", "T_Head_", Cfg.GUIPathVariable)
        Content.Icon = Content.Icon or Content.IconPath
        Content.AttrIcon = GetAttrIcon("Char", CharId)
        Content.bHideItemLevel = true
        table.insert(List, FillUnownedMeta(Content, SlotType, CharId))
      end
    end
  elseif SlotType == ST.Melee then
    local OwnedIds = AddWeaponContents(List, Avatar.Weapons, EventId, DungeonId, SlotType, "Melee")
    AddUnownedWeaponContents(List, OwnedIds, SlotType, "Melee")
  elseif SlotType == ST.Ranged then
    local OwnedIds = AddWeaponContents(List, Avatar.Weapons, EventId, DungeonId, SlotType, "Ranged")
    AddUnownedWeaponContents(List, OwnedIds, SlotType, "Ranged")
  elseif SlotType == ST.Pet then
    for _, Pet in pairs(Avatar.Pets or {}) do
      if not Pet:IsResourcePet() then
        local Content = ArmoryUtils:NewPetItemContent(Pet)
        table.insert(List, FillSelectMeta(Content, EventId, DungeonId, SlotType))
      end
    end
  elseif SlotType == ST.Affix then
    for _, AffixId in ipairs(WeaponVerifyUIModel.GetAffixGroup(DungeonId)) do
      local Cfg = WeaponVerifyUIModel.GetAffixCfg(AffixId)
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.UnitId = AffixId
      Content.UniqueId = AffixId
      Content.Type = "Affix"
      Content.Tag = "Affix"
      Content.ItemType = "Affix"
      Content.UnitName = Cfg and Cfg.Name and GText(Cfg.Name) or ""
      Content.ItemName = Content.UnitName
      Content.Icon = Cfg and (Cfg.IconPath or Cfg.Icon) or nil
      Content.Rarity = Cfg and Cfg.Rarity or 0
      table.insert(List, FillSelectMeta(Content, EventId, DungeonId, SlotType))
    end
  end
  table.sort(List, function(a, b)
    if SlotType == ST.Affix then
      local ASelected = a.SortSelected or 0
      local BSelected = b.SortSelected or 0
      if ASelected ~= BSelected then
        return ASelected > BSelected
      end
      local AUnlocked = a.SortUnlocked or 0
      local BUnlocked = b.SortUnlocked or 0
      if AUnlocked ~= BUnlocked then
        return AUnlocked > BUnlocked
      end
      return (a.SortId or 0) < (b.SortId or 0)
    end
    if SlotType ~= ST.Pet and a.SortOwned ~= b.SortOwned then
      return a.SortOwned > b.SortOwned
    end
    if a.SortSelected ~= b.SortSelected then
      return a.SortSelected > b.SortSelected
    end
    if a.SortUnlocked ~= b.SortUnlocked then
      return a.SortUnlocked > b.SortUnlocked
    end
    if (a.SortLevel or 0) ~= (b.SortLevel or 0) then
      return (a.SortLevel or 0) > (b.SortLevel or 0)
    end
    return (a.SortId or 0) > (b.SortId or 0)
  end)
  return List
end

function WeaponVerifyUIModel.SetSlotSelection(EventId, DungeonId, SlotType, Content)
  if not Content then
    return
  end
  if not WeaponVerifyUIModel._EditSelect or WeaponVerifyUIModel._EditSelect.EventId ~= EventId or WeaponVerifyUIModel._EditSelect.DungeonId ~= DungeonId then
    WeaponVerifyUIModel.InitEditSelect(EventId, DungeonId)
  end
  local Value = Content.UniqueId
  if WeaponVerifyUIModel.GetEditSelectValue(SlotType) == Value then
    Value = nil
  end
  WeaponVerifyUIModel.SetEditSelect(SlotType, Value)
end

function WeaponVerifyUIModel.ClearEditSelect()
  WeaponVerifyUIModel._EditSelect = nil
end

function WeaponVerifyUIModel.IsWeaponMissing(WeaponUuid)
  if not WeaponUuid then
    return false
  end
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  if not Avatar or not Avatar.Weapons then
    return false
  end
  return not Avatar.Weapons[WeaponUuid]
end

function WeaponVerifyUIModel.IsPetMissing(PetUniqueId)
  if not PetUniqueId or 0 == PetUniqueId then
    return false
  end
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  if not Avatar or not Avatar.Pets then
    return false
  end
  return not Avatar.Pets[PetUniqueId]
end

function WeaponVerifyUIModel.GetSlotState(SlotType, Value)
  local SS = WeaponVerifyUIModel.SlotState
  if not Value or 0 == Value then
    return SS.Empty
  end
  local ST = WeaponVerifyUIModel.SlotType
  if SlotType == ST.Melee or SlotType == ST.Ranged then
    return WeaponVerifyUIModel.IsWeaponMissing(Value) and SS.Missing or SS.Filled
  elseif SlotType == ST.Pet then
    return WeaponVerifyUIModel.IsPetMissing(Value) and SS.Missing or SS.Filled
  end
  return SS.Filled
end

function WeaponVerifyUIModel.CheckSquadComplete()
  local Sel = WeaponVerifyUIModel._EditSelect
  local ST = WeaponVerifyUIModel.SlotType
  if not Sel then
    return false, ST.Char
  end
  if not Sel.CharUuid then
    return false, ST.Char
  end
  if not Sel.MeleeWeaponUuid then
    return false, ST.Melee
  end
  if not Sel.RangedWeaponUuid then
    return false, ST.Ranged
  end
  if not Sel.AffixId or 0 == Sel.AffixId then
    return false, ST.Affix
  end
  return true, nil
end

function WeaponVerifyUIModel.IsSquadChanged(EventId, DungeonId, NewSquad)
  local Old = WeaponVerifyUIModel.GetLevelSaveInfo(EventId, DungeonId)
  if not Old or not NewSquad then
    return NewSquad
  end
  return Old.CharUuid ~= NewSquad.CharUuid or Old.MeleeWeaponUuid ~= NewSquad.MeleeWeaponUuid or Old.RangedWeaponUuid ~= NewSquad.RangedWeaponUuid or (Old.PetUniqueId or 0) ~= (NewSquad.PetUniqueId or 0) or (Old.AffixId or 0) ~= (NewSquad.AffixId or 0)
end

function WeaponVerifyUIModel.GetRewardList(EventId)
  local List = {}
  local Tbl = DataMgr.WeaponVerifyEventReward
  if Tbl then
    for _, Cfg in pairs(Tbl) do
      if Cfg.EventId == EventId then
        table.insert(List, Cfg)
      end
    end
  end
  table.sort(List, function(a, b)
    return a.RewardId < b.RewardId
  end)
  return List
end

WeaponVerifyUIModel.RewardState = {
  NotReach = 1,
  CanGet = 2,
  Got = 3
}

function WeaponVerifyUIModel.GetRewardState(EventId, RewardCfg)
  local SaveData = WeaponVerifyUIModel.GetSaveData(EventId)
  local RS = WeaponVerifyUIModel.RewardState
  if SaveData and SaveData:IsStarRewardGot(RewardCfg.RewardId) then
    return RS.Got
  end
  local Total = WeaponVerifyUIModel.GetTotalStars(EventId)
  if Total >= (RewardCfg.RequiredStar or 0) then
    return RS.CanGet
  end
  return RS.NotReach
end

function WeaponVerifyUIModel.HasStarRewardCanGet(EventId)
  local RS = WeaponVerifyUIModel.RewardState
  for _, Cfg in ipairs(WeaponVerifyUIModel.GetRewardList(EventId)) do
    if WeaponVerifyUIModel.GetRewardState(EventId, Cfg) == RS.CanGet then
      return true
    end
  end
  return false
end

function WeaponVerifyUIModel.GetStarRewardCanGetCount(EventId)
  local RS = WeaponVerifyUIModel.RewardState
  local Count = 0
  for _, Cfg in ipairs(WeaponVerifyUIModel.GetRewardList(EventId)) do
    if WeaponVerifyUIModel.GetRewardState(EventId, Cfg) == RS.CanGet then
      Count = Count + 1
    end
  end
  return Count
end

WeaponVerifyUIModel.RewardReddotNode = "Acti_WeaponVerifyReward"

function WeaponVerifyUIModel.RefreshStarRewardReddot(EventId)
  if not EventId then
    return
  end
  local NodeName = WeaponVerifyUIModel.RewardReddotNode
  if not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNodeEx(NodeName)
  end
  ReddotManager.ClearLeafNodeCount(NodeName)
  local Count = WeaponVerifyUIModel.GetStarRewardCanGetCount(EventId)
  if Count > 0 then
    ReddotManager.IncreaseLeafNodeCount(NodeName, Count)
  end
end

function WeaponVerifyUIModel.SetSquad(EventId, DungeonId, CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId, CallBack)
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  if Avatar then
    Avatar:WeaponVerifySetSquad(EventId, DungeonId, CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId, CallBack)
  end
end

function WeaponVerifyUIModel.ResetDungeon(EventId, DungeonId, CallBack)
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  if Avatar then
    Avatar:WeaponVerifyResetDungeon(EventId, DungeonId, CallBack)
  end
end

function WeaponVerifyUIModel.EnsureDungeonResult(EventId, DungeonId, bExchange, CallBack)
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  if Avatar then
    Avatar:WeaponVerifyEnsureDungeonResult(EventId, DungeonId, bExchange, CallBack)
  end
end

function WeaponVerifyUIModel.GetStarReward(EventId, RewardId, CallBack)
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  if Avatar then
    Avatar:WeaponVerifyGetStarReward(EventId, RewardId, CallBack)
  end
end

function WeaponVerifyUIModel.GetAllStarReward(EventId, CallBack)
  local Avatar = WeaponVerifyUIModel.GetAvatar()
  if Avatar then
    Avatar:WeaponVerifyGetAllStarReward(EventId, CallBack)
  end
end

return WeaponVerifyUIModel
