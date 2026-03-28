local HyperWeaponUtils = {}

function HyperWeaponUtils.IsHyperWeapon(WeaponId)
  local WeaponInfo = DataMgr.Weapon[WeaponId]
  if not WeaponInfo then
    return false
  end
  local WeaponSubType = WeaponInfo.WeaponSubType
  return WeaponSubType == CommonConst.WeaponSubType.Hyper
end

function HyperWeaponUtils.IsHyperWeaponSkillActivated(HyperWeaponUid, HyperWeaponSkillId)
  local Avatar = GWorld:GetAvatar()
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

return HyperWeaponUtils
