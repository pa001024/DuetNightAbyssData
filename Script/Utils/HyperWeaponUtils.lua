local SkillUtils = require("Utils.SkillUtils")
local HyperWeaponUtils = {}
HyperWeaponUtils.ActiveState = {
  Locked = 1,
  UnlockedInactive = 2,
  UnlockedActivatable = 3,
  Activated = 4
}

function HyperWeaponUtils.IsHyperWeapon(WeaponId)
  local WeaponInfo = DataMgr.Weapon[WeaponId]
  if not WeaponInfo then
    return false
  end
  local WeaponSubType = WeaponInfo.WeaponSubType
  return WeaponSubType == CommonConst.WeaponSubType.Hyper
end

function HyperWeaponUtils.IsHyperWeaponSkillActivated(WeaponId, HyperWeaponSkillId)
  if Const and Const.bEditorUnlockAllHyperWeaponSkills then
    return true
  end
  local Avatar = GWorld and GWorld:GetAvatar()
  local GameState = UE4 and UE4.UGameplayStatics.GetGameState(GWorld and GWorld.GameInstance)
  local HyperWeapon = HyperWeaponUtils.GetCurHyperWeapon(WeaponId)
  if GameState and GameState:IsInDungeon() and not HyperWeapon then
    local PC = UE4 and UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    local PS = PC and PC.PlayerState
    if not PS or not PS.HyperWeaponSkillIds then
      return false
    end
    local SkillEntries = PS.HyperWeaponSkillIds:ToTable()
    for _, Entry in ipairs(SkillEntries or {}) do
      if Entry.SkillId == HyperWeaponSkillId then
        return true
      end
    end
    return false
  else
    if not HyperWeapon then
      return false
    end
    local TargetHyperWeaponSkillInfo = DataMgr.HyperWeaponSkillTree[HyperWeaponSkillId]
    if not TargetHyperWeaponSkillInfo or TargetHyperWeaponSkillInfo.WeaponId ~= HyperWeapon.WeaponId then
      return false
    end
    local TargetCardLevel = TargetHyperWeaponSkillInfo.WeaponCardLevel
    if not TargetCardLevel then
      return false
    end
    local HyperTalent = HyperWeapon and HyperWeapon.HyperTalent or -1
    if -1 == HyperTalent then
      return false
    end
    local TargetLevelTalentInfo = HyperTalent[TargetCardLevel]
    if not TargetLevelTalentInfo or not TargetLevelTalentInfo[HyperWeaponSkillId] then
      return false
    end
    return true
  end
end

function HyperWeaponUtils.IsHyperWeaponSkillActivatedByUid(HyperWeaponUid, HyperWeaponSkillId)
  if Const and Const.bEditorUnlockAllHyperWeaponSkills then
    return true
  end
  local Avatar = GWorld and GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local ServerWeapon = Avatar and Avatar.Weapons[HyperWeaponUid]
  if not (ServerWeapon and ServerWeapon.WeaponId) or not HyperWeaponUtils.IsHyperWeapon(ServerWeapon.WeaponId) then
    return false
  end
  local TargetHyperWeaponSkillInfo = DataMgr.HyperWeaponSkillTree[HyperWeaponSkillId]
  if not TargetHyperWeaponSkillInfo or TargetHyperWeaponSkillInfo.WeaponId ~= ServerWeapon.WeaponId then
    return false
  end
  local TargetCardLevel = TargetHyperWeaponSkillInfo.WeaponCardLevel
  if not TargetCardLevel then
    return false
  end
  local HyperTalent = ServerWeapon and ServerWeapon.HyperTalent or -1
  if -1 == HyperTalent then
    return false
  end
  local TargetLevelTalentInfo = HyperTalent[TargetCardLevel]
  if not TargetLevelTalentInfo or not TargetLevelTalentInfo[HyperWeaponSkillId] then
    return false
  end
  return true
end

function HyperWeaponUtils.GetCurHyperWeapon(WeaponId)
  local Avatar = GWorld and GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  local HyperWeapon
  for _, Weapon in pairs(Avatar.Weapons or {}) do
    if Weapon.WeaponId == WeaponId then
      HyperWeapon = Weapon
    end
  end
  if not (HyperWeapon and HyperWeapon.WeaponId) or not HyperWeaponUtils.IsHyperWeapon(HyperWeapon.WeaponId) then
    return nil
  end
  return HyperWeapon
end

function HyperWeaponUtils.GetHyperWeaponCurTalentCount(Avatar, WeaponUuid)
  if not Avatar then
    return 0
  end
  local WeaponInfo = Avatar.Weapons[WeaponUuid]
  if not WeaponInfo or not WeaponInfo.HyperTalent then
    return 0
  end
  local TalentCount = 0
  for _, TalentArray in pairs(WeaponInfo.HyperTalent) do
    for _, _ in pairs(TalentArray) do
      TalentCount = TalentCount + 1
    end
  end
  return TalentCount
end

function HyperWeaponUtils.GetHyperWeaponMaxTalentCount(WeaponId)
  if not HyperWeaponUtils.IsHyperWeapon(WeaponId) then
    return 0
  end
  local TalentCount = 0
  for _, Info in pairs(DataMgr.HyperWeaponSkillTree) do
    if Info.WeaponId == WeaponId then
      TalentCount = TalentCount + 1
    end
  end
  return TalentCount
end

function HyperWeaponUtils.GetMaxForgeLevel(WeaponId)
  if not HyperWeaponUtils.IsHyperWeapon(WeaponId) then
    return 0
  end
  local WeaponCardDatas = DataMgr.HyperWeaponCardLevel[WeaponId]
  return WeaponCardDatas and #WeaponCardDatas or 0
end

function HyperWeaponUtils.GetSkillDesc(TalentId)
  local TalentInfo = DataMgr.HyperWeaponSkillTree[TalentId]
  if not TalentInfo then
    return
  end
  local Desc = ""
  if TalentInfo.SkillDescription then
    Desc = GText(TalentInfo.SkillDescription)
    for index, DescValue in pairs(TalentInfo.SkillDescParameter or {}) do
      local Percent = string.match(DescValue, "%%") or ""
      local ValStr = SkillUtils.CalcSkillDescValue(DescValue, 1) .. Percent
      Desc = string.gsub(Desc, "#" .. index, ValStr)
    end
  else
    local WeaponInfo = DataMgr.BattleWeapon[TalentInfo.WeaponId]
    if not WeaponInfo then
      return
    end
    for _, Info in pairs(WeaponInfo.AddAttrs) do
      if Info.HyperWeaponSkillTreeID == TalentId then
        local AttrNameKey = ""
        if Info.Tag and Info.RateZone then
          AttrNameKey = string.format("%s_%s_%s", Info.AttrName, Info.Tag, Info.RateZone)
        elseif Info.Tag then
          AttrNameKey = string.format("%s_%s", Info.AttrName, Info.Tag)
        elseif Info.RateZone then
          AttrNameKey = string.format("%s_%s", Info.AttrName, Info.RateZone)
        else
          AttrNameKey = Info.AttrName
        end
        local Attr = DataMgr.AttrConfig[AttrNameKey]
        local IsRate = Info.Rate ~= nil
        local Value = Info.Rate or Info.Value
        local ValStr = CommonUtils.AttrValueToString(Attr, Value, IsRate)
        Desc = GText(Attr.Name) .. "+" .. ValStr
      end
    end
  end
  return Desc
end

function HyperWeaponUtils.GetTalentState(Avatar, WeaponUuid, TalentId, IsPreviewMode)
  if not Avatar then
    return TalentState.Locked
  end
  local TalentState = HyperWeaponUtils.ActiveState
  local WeaponInfo = Avatar.Weapons[WeaponUuid]
  if not WeaponInfo or not WeaponInfo.HyperTalent then
    return TalentState.Locked
  end
  local TalentStaticData = DataMgr.HyperWeaponSkillTree[TalentId]
  if not TalentStaticData then
    return TalentState.Locked
  end
  local WeaponCardLevel = TalentStaticData.WeaponCardLevel
  if 0 == WeaponCardLevel then
    return TalentState.Activated
  end
  if WeaponCardLevel > WeaponInfo.HyperCardLevel then
    return TalentState.Locked
  end
  local LastCardLevel = WeaponCardLevel - 1
  LastCardLevel = math.clamp(LastCardLevel, 0, WeaponCardLevel)
  local LastServerTalents = WeaponInfo.HyperTalent[LastCardLevel]
  if not LastServerTalents or LastServerTalents:IsEmpty() then
    return TalentState.Locked
  elseif not IsPreviewMode then
    local LastTalentUnlocked = false
    for _, ConditionId in pairs(TalentStaticData.UnlockCondition) do
      if LastServerTalents[ConditionId] then
        LastTalentUnlocked = true
        break
      end
    end
    if not LastTalentUnlocked then
      return TalentState.Locked
    end
  end
  local ServerTalents = WeaponInfo.HyperTalent[WeaponCardLevel]
  if ServerTalents then
    for Id1, Id2 in pairs(ServerTalents) do
      if Id1 == TalentId or Id2 == TalentId then
        return TalentState.Activated
      end
    end
  end
  if IsPreviewMode then
    return TalentState.UnlockedInactive
  end
  local bCanActivateForFree = nil == ServerTalents or ServerTalents:IsEmpty()
  if bCanActivateForFree then
    return TalentState.UnlockedActivatable
  end
  local bHasEnoughResources = true
  for Index, ResourceId in pairs(TalentStaticData.ResourceId or {}) do
    local OwnedCount = Avatar:GetResourceNum(ResourceId)
    local NeedCount = TalentStaticData.ResourceNum[Index]
    if OwnedCount < NeedCount then
      bHasEnoughResources = false
      break
    end
  end
  if bHasEnoughResources then
    return TalentState.UnlockedActivatable
  else
    return TalentState.UnlockedInactive
  end
end

function HyperWeaponUtils.GetCardState(Avatar, WeaponUuid, CardLevel, IsPreviewMode)
  if not Avatar then
    return CardState.Locked
  end
  local CardState = HyperWeaponUtils.ActiveState
  local WeaponInfo = Avatar.Weapons[WeaponUuid]
  if not WeaponInfo or not WeaponInfo.HyperTalent then
    return CardState.Locked
  end
  if 0 == CardLevel then
    return CardState.Activated
  end
  local WeaponId = WeaponInfo.WeaponId
  local CardStaticInfo = DataMgr.HyperWeaponCardLevel[WeaponId]
  local CurLevelInfo = CardStaticInfo and CardStaticInfo[CardLevel]
  if not CardStaticInfo or not CurLevelInfo then
    return
  end
  local LastCardLevel = CardLevel - 1
  LastCardLevel = math.clamp(LastCardLevel, 0, CardLevel)
  local HyperCardLevel = WeaponInfo.HyperCardLevel
  if LastCardLevel > HyperCardLevel then
    return CardState.Locked
  end
  if CardLevel > Avatar.WeaponForgeLevel then
    return CardState.Locked
  end
  if not ConditionUtils.CheckCondition(Avatar, CardStaticInfo.UnlockCondition) then
    return CardState.Locked
  end
  if CardLevel <= HyperCardLevel then
    return CardState.Activated
  end
  if IsPreviewMode then
    return CardState.UnlockedInactive
  end
  local bHasEnoughResources = true
  for Index, ResourceId in pairs(CurLevelInfo.ResourceId or {}) do
    local OwnedCount = Avatar:GetResourceNum(ResourceId)
    local NeedCount = CurLevelInfo.ResourceNum[Index]
    if OwnedCount < NeedCount then
      bHasEnoughResources = false
      break
    end
  end
  if bHasEnoughResources then
    return CardState.UnlockedActivatable
  else
    return CardState.UnlockedInactive
  end
end

function HyperWeaponUtils.GetTalentName(TalentId)
  local TalentInfo = DataMgr.HyperWeaponSkillTree[TalentId]
  if not TalentInfo then
    return
  end
  return GText(TalentInfo.WeaponSkillName)
end

function HyperWeaponUtils.GetTalents(WeaponId, CardLevel)
  if not WeaponId or not CardLevel then
    return
  end
  local Talents = {}
  for TalentId, Info in pairs(DataMgr.HyperWeaponSkillTree) do
    if Info.WeaponId == WeaponId and Info.WeaponCardLevel == CardLevel then
      table.insert(Talents, TalentId)
    end
  end
  table.sort(Talents, function(IdA, IdB)
    return IdA < IdB
  end)
  return Talents
end

function HyperWeaponUtils.HasAnyForgeRewards(StartLevel, EndLevel)
  EndLevel = EndLevel or StartLevel
  for Level = StartLevel, EndLevel do
    if HyperWeaponUtils.HasForgeLevelCanGetReward(Level) then
      return true
    end
    if HyperWeaponUtils.HasForgeQuestCanGetReward(Level) then
      return true
    end
  end
  return false
end

function HyperWeaponUtils.HasForgeLevelCanGetReward(ForgeLevel)
  local Avatar = GWorld:GetAvatar()
  local ServerRewerdGot = Avatar.WeaponForgeLevelRewardGot
  if ServerRewerdGot and ServerRewerdGot[ForgeLevel] then
    return false
  end
  local ForgeInfo = DataMgr.ForgeLevel[ForgeLevel]
  if not ForgeInfo then
    return false
  end
  local AllQuestDone = true
  for _, QuestId in pairs(ForgeInfo.ForgeLevelQuestId or {}) do
    local Quest = Avatar.WeaponForgeQuests[QuestId]
    if not Quest or not Quest:IsComplete() then
      AllQuestDone = false
      break
    end
  end
  return AllQuestDone
end

function HyperWeaponUtils.HasForgeQuestCanGetReward(ForgeLevel)
  local ForgeInfo = DataMgr.ForgeLevel[ForgeLevel]
  if not ForgeInfo then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  for _, QuestId in pairs(ForgeInfo.ForgeLevelQuestId or {}) do
    local Quest = Avatar.WeaponForgeQuests[QuestId]
    if Quest and Quest:CanRecvReward() then
      return true
    end
  end
  return false
end

function HyperWeaponUtils.HasOwnedHyperWeapon(WeaponTag)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  for _, Weapon in pairs(Avatar.Weapons) do
    if HyperWeaponUtils.IsHyperWeapon(Weapon.WeaponId) then
      if not WeaponTag then
        return true
      end
      if Weapon:HasTag(WeaponTag) then
        return true
      end
    end
  end
  return false
end

function HyperWeaponUtils.HasOwnedWeapon(WeaponUuid)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local Weapon = Avatar.Weapons[WeaponUuid]
  return nil ~= Weapon
end

return HyperWeaponUtils
