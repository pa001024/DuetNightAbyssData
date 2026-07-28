require("UnLua")
local Component = Class({
  "BluePrints.Combat.Components.CharacterInitLogic",
  "BluePrints.Combat.Components.EffectSourceInterface",
  "BluePrints.Combat.Components.SkillLevelInterface",
  "BluePrints.Char.CharacterComponent.CharModelComponent"
})

function Component:ServerSetRoleMod(RoleId, ModPassives, OnlySummonInherit)
  self.ModPassives = ModPassives
  if not ModPassives then
    return
  end
  for i = 1, #ModPassives do
    local PassiveInfo = ModPassives[i]
    local PassiveId = PassiveInfo[1]
    local Level = PassiveInfo[2]
    local SummonInherit = PassiveInfo[3]
    if not OnlySummonInherit or SummonInherit then
      local PassiveEffect = self:AddPassiveEffectByRole(RoleId, PassiveId, Level)
      if PassiveEffect then
        PassiveEffect.SummonInherit = SummonInherit
      end
    end
  end
end

function Component:ServerInheritModAttr(ModData)
  for k, Data in pairs(ModData) do
    local ModId = Data.ModId
    local ModLevel = Data.Level
    self:SetAttrByMod(ModId, ModLevel)
  end
end

function Component:BuildInheritedWeaponInfo(Source, WeaponId)
  local WeaponInfo = {WeaponId = WeaponId}
  local WeaponData = DataMgr.BattleWeapon[WeaponId]
  if not (Source and WeaponData) or not WeaponData.WeaponSkillList then
    return WeaponInfo
  end
  local SkillInfos = {}
  for _, SkillId in ipairs(WeaponData.WeaponSkillList) do
    local SrcSkill = Source:GetSkill(SkillId)
    if SrcSkill then
      SkillInfos[SkillId] = {
        Level = SrcSkill.SkillLevel,
        Grade = SrcSkill.SkillGrade
      }
    else
      SkillInfos[SkillId] = {}
    end
  end
  WeaponInfo.SkillInfos = SkillInfos
  return WeaponInfo
end

function Component:CreateUnitServerSetRoleMod(RoleId, Source, OnlySummonInherit)
  local MonsterData = DataMgr.Monster[self.UnitId]
  if not OnlySummonInherit and MonsterData and MonsterData.InheritMod then
    self:ServerInheritModAttr(Source.InfoForInit and Source.InfoForInit.ModData or {})
    self:ServerSetRoleMod(RoleId, Source.ModPassives, false)
  else
    self:ServerSetRoleMod(RoleId, Source.ModPassives, OnlySummonInherit)
  end
  if MonsterData and MonsterData.InheritWeapon then
    if MonsterData.InheritWeapon == "Melee" then
      local SourceWeapon = Source.MeleeWeapon
      if SourceWeapon then
        self:SummonServerSetUpMeleeWeapon(self:BuildInheritedWeaponInfo(Source, SourceWeapon.WeaponId), SourceWeapon)
      end
    elseif MonsterData.InheritWeapon == "Ranged" then
      local SourceWeapon = Source.RangedWeapon
      if SourceWeapon then
        self:SummonServerSetUpRangedWeapon(self:BuildInheritedWeaponInfo(Source, SourceWeapon.WeaponId), SourceWeapon)
      end
    end
  end
  local MaxHp = self:GetAttr("MaxHp")
  if MaxHp <= 0 then
    self:SetAttr("MaxHp", 1)
    self:SetAttr("Hp", 1)
  end
end

return Component
