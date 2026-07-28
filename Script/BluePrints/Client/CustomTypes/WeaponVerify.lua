local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local WeaponVerifyLevelInfo = Class("WeaponVerifyLevelInfo", CustomTypes.CustomAttr)
WeaponVerifyLevelInfo.__Props__ = {
  CharUuid = prop.prop("ObjId", "client save"),
  MeleeWeaponUuid = prop.prop("ObjId", "client save"),
  RangedWeaponUuid = prop.prop("ObjId", "client save"),
  PetUniqueId = prop.prop("Int", "client save", 0),
  AffixId = prop.prop("Int", "client save", 0),
  FinishStar = prop.prop("Int", "client save", 0)
}

function WeaponVerifyLevelInfo:Init(CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId, FinishStar)
  self.CharUuid = CharUuid
  self.MeleeWeaponUuid = MeleeWeaponUuid
  self.RangedWeaponUuid = RangedWeaponUuid
  self.PetUniqueId = PetUniqueId or 0
  self.AffixId = AffixId or 0
  self.FinishStar = FinishStar or 0
end

function WeaponVerifyLevelInfo:SetFinishStar(FinishStar)
  self.FinishStar = FinishStar or 0
end

FormatProperties(WeaponVerifyLevelInfo)
local WeaponVerifyLevelInfoDict = Class("WeaponVerifyLevelInfoDict", CustomTypes.CustomDict)
WeaponVerifyLevelInfoDict.KeyType = BaseTypes.Int
WeaponVerifyLevelInfoDict.ValueType = WeaponVerifyLevelInfo
local WeaponVerify = Class("WeaponVerify", CustomTypes.CustomAttr)
WeaponVerify.__Props__ = {
  WeaponVerifyEventId = prop.prop("Int", "client save"),
  StarRewardsGot = prop.prop("Int2IntDict", "client save"),
  LevelInfo = prop.prop("WeaponVerifyLevelInfoDict", "client save"),
  TmpLevelInfo = prop.prop("WeaponVerifyLevelInfoDict", "client save")
}

function WeaponVerify:Init(WeaponVerifyEventId)
  self.WeaponVerifyEventId = WeaponVerifyEventId
end

function WeaponVerify:GetLevelInfo(DungeonId)
  return self.LevelInfo[DungeonId]
end

function WeaponVerify:GetNewLevelInfo(DungeonId)
  if not self.LevelInfo[DungeonId] then
    self.LevelInfo[DungeonId] = WeaponVerifyLevelInfo()
  end
  return self.LevelInfo[DungeonId]
end

function WeaponVerify:SetLevelInfo(DungeonId, LevelInfo)
  self.LevelInfo[DungeonId] = LevelInfo
end

function WeaponVerify:ResetLevelInfo(DungeonId, TmpLevelInfo)
  self.LevelInfo[DungeonId] = WeaponVerifyLevelInfo(TmpLevelInfo.CharUuid, TmpLevelInfo.MeleeWeaponUuid, TmpLevelInfo.RangedWeaponUuid, TmpLevelInfo.PetUniqueId, TmpLevelInfo.AffixId, TmpLevelInfo.FinishStar)
end

function WeaponVerify:GetTmpLevelInfo(DungeonId)
  return self.TmpLevelInfo[DungeonId]
end

function WeaponVerify:GetNewTmpLevelInfo(DungeonId)
  if not self.TmpLevelInfo[DungeonId] then
    self.TmpLevelInfo[DungeonId] = WeaponVerifyLevelInfo()
  end
  return self.TmpLevelInfo[DungeonId]
end

function WeaponVerify:SetTmpLevelInfo(DungeonId, LevelInfo)
  self.TmpLevelInfo[DungeonId] = LevelInfo
end

function WeaponVerify:RemoveLevelInfo(DungeonId)
  self.LevelInfo:RemoveValue(DungeonId)
end

function WeaponVerify:RemoveTmpLevelInfo(DungeonId)
  self.TmpLevelInfo:RemoveValue(DungeonId)
end

function WeaponVerify:SetTmpLevelInfoByUuid(DungeonId, CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId)
  self.TmpLevelInfo[DungeonId] = WeaponVerifyLevelInfo(CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId)
  return self.TmpLevelInfo[DungeonId]
end

function WeaponVerify:SetLevelInfoByUuid(DungeonId, CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId)
  self.LevelInfo[DungeonId] = WeaponVerifyLevelInfo(CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId)
  return self.LevelInfo[DungeonId]
end

function WeaponVerify:GetFinishStar(DungeonId)
  local LevelInfo = self:GetLevelInfo(DungeonId)
  return LevelInfo and LevelInfo.FinishStar or 0
end

function WeaponVerify:SetFinishStar(DungeonId, FinishStar)
  local LevelInfo = self:GetNewLevelInfo(DungeonId)
  LevelInfo:SetFinishStar(FinishStar)
end

function WeaponVerify:SetTmpFinishStar(DungeonId, FinishStar)
  local LevelInfo = self:GetNewTmpLevelInfo(DungeonId)
  LevelInfo:SetFinishStar(FinishStar)
end

function WeaponVerify:GetTotalStars()
  local TotalStars = 0
  for _, LevelInfo in pairs(self.LevelInfo) do
    TotalStars = TotalStars + (LevelInfo.FinishStar or 0)
  end
  return TotalStars
end

function WeaponVerify:IsStarRewardGot(RewardKey)
  return 1 == self.StarRewardsGot[RewardKey]
end

function WeaponVerify:SetStarRewardGot(RewardKey)
  self.StarRewardsGot[RewardKey] = 1
end

FormatProperties(WeaponVerify)
local WeaponVerifyDict = Class("WeaponVerifyDict", CustomTypes.CustomDict)
WeaponVerifyDict.KeyType = BaseTypes.Int
WeaponVerifyDict.ValueType = WeaponVerify

function WeaponVerifyDict:GetNewWeaponVerify(WeaponVerifyEventId)
  if not self[WeaponVerifyEventId] then
    self[WeaponVerifyEventId] = self:NewWeaponVerify(WeaponVerifyEventId)
  end
  return self[WeaponVerifyEventId]
end

function WeaponVerifyDict:GetWeaponVerify(WeaponVerifyEventId)
  return self[WeaponVerifyEventId]
end

function WeaponVerifyDict:SetWeaponVerify(WeaponVerifyEventId, WeaponVerify)
  self[WeaponVerifyEventId] = WeaponVerify
end

function WeaponVerifyDict:NewWeaponVerify(WeaponVerifyEventId)
  return WeaponVerify(WeaponVerifyEventId)
end

return {
  WeaponVerifyLevelInfo = WeaponVerifyLevelInfo,
  WeaponVerifyLevelInfoDict = WeaponVerifyLevelInfoDict,
  WeaponVerify = WeaponVerify,
  WeaponVerifyDict = WeaponVerifyDict
}
