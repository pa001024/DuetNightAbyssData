local M = {}

local function GetActiveGuideData(OwnerPlayer)
  if not OwnerPlayer then
    return nil, false, false
  end
  local BuffManager = OwnerPlayer.BuffManager
  if not BuffManager or not BuffManager.Buffs then
    return nil, false, false
  end
  local UltraBuffData
  local AttackToFire = false
  local FireToAttack = false
  for _, Buff in pairs(BuffManager.Buffs) do
    if IsValid(Buff) then
      local BuffData = DataMgr.Buff[Buff.BuffId]
      if BuffData then
        local ReplaceActions = BuffData.ReplaceActions
        AttackToFire = AttackToFire or ReplaceActions and ReplaceActions.Attack == "Fire" or false
        FireToAttack = FireToAttack or ReplaceActions and "Attack" == ReplaceActions.Fire or false
        if not UltraBuffData and BuffData.UseSummonWeapon then
          UltraBuffData = BuffData
        end
      end
    end
  end
  return UltraBuffData, AttackToFire, FireToAttack
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
  local BuffData = GetActiveGuideData(OwnerPlayer)
  if not BuffData then
    return false
  end
  return BuffData.ReplaceMobileAttackButtonIcon == true
end

function M:ShouldReplaceSecondaryAttackButtonByReplaceActions(OwnerPlayer)
  local BuffData, AttackToFire = GetActiveGuideData(OwnerPlayer)
  if not BuffData then
    return false
  end
  return AttackToFire
end

function M:IsUltimateActive(OwnerPlayer)
  return nil ~= GetActiveGuideData(OwnerPlayer)
end

function M:GetUltimateAttackGuideState(OwnerPlayer)
  local MainAttackType = self:GetUltimateMainAttackType(OwnerPlayer)
  local UltraBuffData, ReplaceActions_AttackToFire, ReplaceActions_FireToAttack = GetActiveGuideData(OwnerPlayer)
  local ReplaceIcon = UltraBuffData and UltraBuffData.ReplaceMobileAttackButtonIcon == true or false
  local IsActionSwap = nil ~= MainAttackType and ReplaceActions_AttackToFire and ReplaceActions_FireToAttack
  local IsType1 = "Ranged" == MainAttackType and ReplaceActions_AttackToFire and not IsActionSwap
  local IsType2 = nil ~= MainAttackType and not IsType1 and not IsActionSwap
  return {
    MainAttackType = MainAttackType,
    ReplaceMobileAttackButtonIcon = ReplaceIcon,
    ReplaceActions_AttackToFire = ReplaceActions_AttackToFire,
    ReplaceActions_FireToAttack = ReplaceActions_FireToAttack,
    IsActionSwap = IsActionSwap,
    IsType1 = IsType1,
    IsType2 = IsType2,
    IsUltimateActive = nil ~= UltraBuffData
  }
end

return M
