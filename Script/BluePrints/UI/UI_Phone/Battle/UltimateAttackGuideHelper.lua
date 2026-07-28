local M = {}

local function GetActiveUltraBuffData(OwnerPlayer)
  if not OwnerPlayer then
    return nil
  end
  local BuffManager = OwnerPlayer.BuffManager
  if not BuffManager or not BuffManager.Buffs then
    return nil
  end
  for _, Buff in pairs(BuffManager.Buffs) do
    if IsValid(Buff) then
      local BuffData = DataMgr.Buff[Buff.BuffId]
      if BuffData and BuffData.UseSummonWeapon then
        return BuffData
      end
    end
  end
  return nil
end

function M:GetUltimateMainAttackType(OwnerPlayer)
  if not OwnerPlayer then
    return nil
  end
  local Weapon = OwnerPlayer:GetCurrentWeapon()
  if not Weapon then
    return nil
  end
  local Tags = Weapon:GetWeaponTags()
  if not Tags or not Tags:Contains("Ultra") then
    return nil
  end
  if Tags:Contains("Ranged") then
    return "Ranged"
  end
  if Tags:Contains("Melee") then
    return "Melee"
  end
  return nil
end

function M:ShouldReplaceMobileAttackButtonIcon(OwnerPlayer)
  local BuffData = GetActiveUltraBuffData(OwnerPlayer)
  if not BuffData then
    return false
  end
  return BuffData.ReplaceMobileAttackButtonIcon == true
end

function M:ShouldReplaceSecondaryAttackButtonByReplaceActions(OwnerPlayer)
  local BuffData = GetActiveUltraBuffData(OwnerPlayer)
  if not BuffData then
    return false
  end
  local ReplaceActions = BuffData.ReplaceActions
  if not ReplaceActions then
    return false
  end
  return ReplaceActions.Attack == "Fire"
end

function M:IsUltimateActive(OwnerPlayer)
  return nil ~= GetActiveUltraBuffData(OwnerPlayer)
end

function M:GetUltimateAttackGuideState(OwnerPlayer)
  local MainAttackType = self:GetUltimateMainAttackType(OwnerPlayer)
  local ReplaceIcon = self:ShouldReplaceMobileAttackButtonIcon(OwnerPlayer)
  local ReplaceActions_AttackToFire = self:ShouldReplaceSecondaryAttackButtonByReplaceActions(OwnerPlayer)
  local IsType1 = "Ranged" == MainAttackType and ReplaceActions_AttackToFire
  local IsType2 = nil ~= MainAttackType and not IsType1
  return {
    MainAttackType = MainAttackType,
    ReplaceMobileAttackButtonIcon = ReplaceIcon,
    ReplaceActions_AttackToFire = ReplaceActions_AttackToFire,
    IsType1 = IsType1,
    IsType2 = IsType2
  }
end

return M
