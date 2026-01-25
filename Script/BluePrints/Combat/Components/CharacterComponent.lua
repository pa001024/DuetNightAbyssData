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

function Component:CreateUnitServerSetRoleMod(RoleId, Source, OnlySummonInherit)
  local MonsterData = DataMgr.Monster[self.UnitId]
  if MonsterData and MonsterData.InheritMod then
    self:ServerInheritModAttr(Source.InfoForInit and Source.InfoForInit.ModData or {})
    self:ServerSetRoleMod(RoleId, Source.ModPassives, false)
  else
    self:ServerSetRoleMod(RoleId, Source.ModPassives, OnlySummonInherit)
  end
  if MonsterData and MonsterData.InheritWeapon then
    if MonsterData.InheritWeapon == "Melee" then
      if Source.InfoForInit and Source.InfoForInit.MeleeWeapon then
        self:SummonServerSetUpMeleeWeapon(Source.InfoForInit.MeleeWeapon)
      elseif Source.CurrentRoleId and DataMgr.BattleChar[Source.CurrentRoleId].WeaponId then
        self:SummonServerSetUpMeleeWeapon({
          WeaponId = DataMgr.BattleChar[Source.CurrentRoleId].WeaponId
        })
      end
    elseif MonsterData.InheritWeapon == "Ranged" then
      if Source.InfoForInit and Source.InfoForInit.RangedWeapon then
        self:SummonServerSetUpRangedWeapon(Source.InfoForInit.RangedWeapon)
      elseif Source.CurrentRoleId and DataMgr.BattleChar[Source.CurrentRoleId].RangedWeapon then
        self:SummonServerSetUpMeleeWeapon({
          WeaponId = DataMgr.BattleChar[Source.CurrentRoleId].RangedWeapon
        })
      end
    end
  end
  local MaxHp = self:GetAttr("MaxHp")
  if MaxHp <= 0 then
    self:SetAttr("MaxHp", 2100000000)
    self:SetAttr("Hp", 2100000000)
  end
end

return Component
