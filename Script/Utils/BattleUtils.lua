local BattleDumpUtils = require("BluePrints.Client.BattleDumpUtils")
local BattleUtils = {}

function BattleUtils.GetExtraCreateInfo(UnitType, UnitId, RoleId)
  local ExtraCreateInfo = {}
  if "Phantom" == UnitType then
    local PhantomInfo = DataMgr.Phantom[RoleId]
    if PhantomInfo then
      ExtraCreateInfo.IsHostage = PhantomInfo.IsHostage
      ExtraCreateInfo.IsNPCPhantom = PhantomInfo.IsNPCPhantom
      ExtraCreateInfo.BTIndex = 1
    end
    return ExtraCreateInfo
  end
  return ExtraCreateInfo
end

function BattleUtils.GetQuestRoleCreateInfo(UnitType, QuestRoleId)
  local AvatarInfo, RoleId
  if "Phantom" == UnitType then
    local QuestRoleTable = DataMgr.QuestRoleInfo[QuestRoleId]
    if not QuestRoleTable then
      local Title = "静态刷新点参数错误"
      local Message = string.format("静态刷新点填写的QuestRoleId: %s ，在QuestRoleInfo中不存在对应角色 ，请检查配置", tostring(QuestRoleId))
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, Title, Message)
      return AvatarInfo, RoleId
    end
    local PhantomId = QuestRoleTable.PhantomId
    if not PhantomId then
      local Title = "静态刷新点参数错误"
      local Message = string.format("静态刷新点填写了QuestRoleId: %s ，但QuestRoleInfo中对应的角色未填写魅影Id ，请检查配置", tostring(QuestRoleId))
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, Title, Message)
      local CharRuleId = QuestRoleTable.CharTemplateRuleId
      if CharRuleId and DataMgr.CharTemplate[CharRuleId] then
        PhantomId = DataMgr.CharTemplate[CharRuleId].CharId
      end
    end
    RoleId = PhantomId
    local Avatar = GWorld:GetAvatar()
    if nil == Avatar then
      return AvatarInfo, RoleId
    end
    AvatarInfo = BattleDumpUtils:GetBattleInfoByQuestRoleId(QuestRoleId, Avatar)
  end
  return AvatarInfo, RoleId
end

function BattleUtils.GetCharacterAttributeSwitchConfig(CharId)
  if not CharId then
    return nil
  end
  return DataMgr.CharacterAttributeSwitch and DataMgr.CharacterAttributeSwitch[CharId] or nil
end

function BattleUtils.GetCharacterAttributeSwitchGroupId(CharId)
  local SwitchConfig = BattleUtils.GetCharacterAttributeSwitchConfig(CharId)
  return SwitchConfig and SwitchConfig.CharGroupId or nil
end

function BattleUtils.GetCurrentCharacterAttributeCharId(DefaultCharId)
  local SwitchConfig = BattleUtils.GetCharacterAttributeSwitchConfig(DefaultCharId)
  if not SwitchConfig then
    return DefaultCharId
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.CharacterAttributeSwitch then
    return DefaultCharId
  end
  return Avatar.CharacterAttributeSwitch[SwitchConfig.CharGroupId] or DefaultCharId
end

function BattleUtils.ResolveCharacterAttributeSwitchPhantomData(ResourceData)
  local ReplaceList = ResourceData and ResourceData.PhantomItemReplace
  if not ReplaceList then
    return ResourceData
  end
  local DefaultCharId = ResourceData.UseParam
  local CurrentCharId = BattleUtils.GetCurrentCharacterAttributeCharId(DefaultCharId)
  if not CurrentCharId or CurrentCharId == DefaultCharId then
    return ResourceData
  end
  for _, Mapping in ipairs(ReplaceList) do
    for ResId, TargetCharId in pairs(Mapping) do
      if TargetCharId == CurrentCharId then
        return DataMgr.Resource[ResId] or ResourceData
      end
    end
  end
  return ResourceData
end

function BattleUtils.GetCharacterAttributeSwitchVisiblePhantomData(ResourceData)
  if not ResourceData or ResourceData.ResourceSType ~= "PhantomItem" then
    return ResourceData
  end
  local GroupId = BattleUtils.GetCharacterAttributeSwitchGroupId(ResourceData.UseParam)
  if not GroupId then
    return ResourceData
  end
  local CurrentCharId = BattleUtils.GetCurrentCharacterAttributeCharId(ResourceData.UseParam)
  local DisplayData = BattleUtils.ResolveCharacterAttributeSwitchPhantomData(ResourceData)
  if DisplayData and DisplayData.UseParam == CurrentCharId then
    return DisplayData
  end
  return nil
end

function BattleUtils.ShouldHideCharacterAttributeSwitchPhantom(ResourceData)
  return BattleUtils.GetCharacterAttributeSwitchVisiblePhantomData(ResourceData) == nil
end

return BattleUtils
