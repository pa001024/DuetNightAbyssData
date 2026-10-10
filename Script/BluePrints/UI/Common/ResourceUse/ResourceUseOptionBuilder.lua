require("UnLua")
local CommonConst = require("CommonConst")
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")
local ResourceUseOptionBuilder = {}

local function BuildSelectWeapon(Host, ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig = {}, DataMgr.OptReward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    DebugPrint("GenerateDataWith_SelectWeapon Avatar is nil, Not Connect to Server")
    return ResultData
  end
  if OptionalItemsDataConfig then
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Weapons) do
        if StuffServerData.WeaponId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
          if nil == RewardObject.GradeLevel or StuffServerData.GradeLevel > RewardObject.GradeLevel then
            RewardObject.GradeLevel = StuffServerData.GradeLevel
            RewardObject.IsMaxGradeLevel = DataMgr.WeaponCardLevel[value].CardLevelMax == StuffServerData.GradeLevel
          end
        end
      end
      local WeaponConfigData = DataMgr.Weapon[value]
      local BattleWeaponInfo, AttributeIcon = DataMgr.BattleWeapon[value]
      if BattleWeaponInfo then
        for _, Tag in pairs(BattleWeaponInfo.WeaponTag) do
          local TagInfo = DataMgr.WeaponTag[Tag]
          if TagInfo and TagInfo.WeaponTagfilter and TagInfo.Icon then
            AttributeIcon = TagInfo.Icon
            break
          end
        end
      end
      RewardObject.ResourceId = ResourceId
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffIcon = WeaponConfigData.Icon
      RewardObject.StuffName = GText(WeaponConfigData.WeaponName)
      RewardObject.StuffType = BagCommon.OptionalItemType.Weapon
      RewardObject.Rarity = WeaponConfigData.WeaponRarity or 1
      RewardObject.AttrIcon = AttributeIcon
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = Host
      table.insert(ResultData, RewardObject)
    end
  end
  return ResultData, GText("UI_SHOP_SUBTAB_NAME_WEAPON")
end

local function BuildSelectCharacter(Host, ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig = {}, DataMgr.OptReward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return ResultData
  end
  if OptionalItemsDataConfig then
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Chars or {}) do
        if StuffServerData.CharId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
          if nil == RewardObject.GradeLevel or StuffServerData.GradeLevel > RewardObject.GradeLevel then
            RewardObject.GradeLevel = StuffServerData.GradeLevel
          end
          local CharPieceId = DataMgr.Char[value].CharPieceId
          RewardObject.Count = Avatar:GetResourceNum(CharPieceId)
        end
      end
      local CharacterConfigData = DataMgr.Char[value]
      local BattleCharInfo, AttributeIcon = DataMgr.BattleChar[value]
      if BattleCharInfo then
        local Attribute = BattleCharInfo.Attribute
        AttributeIcon = DataMgr.Attribute[Attribute] and DataMgr.Attribute[Attribute].Icon
      end
      RewardObject.ResourceId = ResourceId
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffIcon = CharacterConfigData.Icon
      RewardObject.StuffName = GText(CharacterConfigData.CharName)
      RewardObject.StuffType = BagCommon.OptionalItemType.Avatar
      RewardObject.Rarity = CharacterConfigData.CharRarity
      RewardObject.AttrIcon = AttributeIcon
      RewardObject.Attribute = BattleCharInfo and BattleCharInfo.Attribute
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = Host
      table.insert(ResultData, RewardObject)
    end
  end
  return ResultData, GText("UI_Armory_Char")
end

local function BuildSelectPet(Host, ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig = {}, DataMgr.OptReward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return ResultData
  end
  if OptionalItemsDataConfig then
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Pets or {}) do
        if StuffServerData.PetId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
          if nil == RewardObject.GradeLevel or StuffServerData.BreakNum > RewardObject.GradeLevel then
            RewardObject.GradeLevel = StuffServerData.BreakNum
          end
        end
      end
      local PetConfigData = DataMgr.Pet[value]
      RewardObject.ResourceId = ResourceId
      RewardObject.Premium = PetConfigData.Premium
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffIcon = PetConfigData.Icon
      RewardObject.StuffName = GText(PetConfigData.Name)
      RewardObject.StuffType = BagCommon.OptionalItemType.Pet
      RewardObject.Rarity = PetConfigData.Rarity or 1
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = Host
      table.insert(ResultData, RewardObject)
    end
  end
  return ResultData, GText("MAIN_UI_PET")
end

local function BuildSelectResource(Host, ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig, OptCount = {}, DataMgr.OptReward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return ResultData
  end
  if OptionalItemsDataConfig then
    OptCount = Avatar.Resources[ResourceId].Count
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Resources or {}) do
        if StuffServerData.ResourceId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
        end
      end
      local ResourceConfigData = DataMgr.Resource[value]
      RewardObject.ResourceId = ResourceId
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffCount = Avatar.Resources[value] and Avatar.Resources[value].Count or 0
      RewardObject.StuffIcon = ResourceConfigData.Icon
      RewardObject.StuffName = GText(ResourceConfigData.ResourceName)
      RewardObject.StuffType = "SelectResource"
      RewardObject.Rarity = ResourceConfigData.Rarity or 1
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = Host
      RewardObject.Count = OptionalItemsDataConfig.Count[index]
      RewardObject.OptCount = OptCount
      table.insert(ResultData, RewardObject)
    end
  end
  return ResultData, GText("UI_Consumable_Effect_ResourcePack"), OptCount
end

local function BuildResourcePack(Host, ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig, OptCount = {}, DataMgr.Reward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return ResultData
  end
  if OptionalItemsDataConfig then
    OptCount = Avatar.Resources[ResourceId].Count
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Resources or {}) do
        if StuffServerData.ResourceId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
        end
      end
      local ResourceConfigData = DataMgr.Resource[value]
      RewardObject.ResourceId = ResourceId
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffIcon = ResourceConfigData.Icon
      RewardObject.StuffName = GText(ResourceConfigData.ResourceName)
      RewardObject.StuffType = "ResourcePack"
      RewardObject.Rarity = ResourceConfigData.Rarity or 1
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = Host
      RewardObject.Count = OptionalItemsDataConfig.Count[index][1] or 1
      RewardObject.OptCount = OptCount
      table.insert(ResultData, RewardObject)
    end
  end
  local ResourcePackText = GText("UI_Consumable_Effect_ResourcePack")
  return ResultData, ResourcePackText
end

local Builders = {
  [CommonConst.ResUseEffectType.SelectWeapon] = BuildSelectWeapon,
  [CommonConst.ResUseEffectType.SelectCharacter] = BuildSelectCharacter,
  [CommonConst.ResUseEffectType.SelectPet] = BuildSelectPet,
  [CommonConst.ResUseEffectType.SelectResource] = BuildSelectResource,
  [CommonConst.ResUseEffectType.ResourcePack] = BuildResourcePack
}

function ResourceUseOptionBuilder.Build(Host, UseEffectType, ResourceId, UseParam)
  local Builder = Builders[UseEffectType]
  if not Builder then
    return {}, ""
  end
  return Builder(Host, ResourceId, UseParam)
end

return ResourceUseOptionBuilder
