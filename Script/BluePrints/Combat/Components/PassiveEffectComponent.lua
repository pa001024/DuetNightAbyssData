local SkillUtils = require("Utils.SkillUtils")
local CommonUtils = require("Utils.CommonUtils")
local Component = {}

function Component:InitPassiveVars(Effect)
  local PassiveEffectId = Effect.PassiveEffectId
  local Data = DataMgr.PassiveEffect[PassiveEffectId]
  local Vars = Data.Vars
  if not Vars then
    return
  end
  local VarNameToGrowVars = {}
  local SkillLevelToGrowVars = {}
  local DefaultGrowVars = SkillUtils.GrowProxy("PassiveEffect", PassiveEffectId, Effect, Vars)
  local LevelInfo = Effect:GetSkillLevelInfo()
  local SkillLevel = LevelInfo.SkillLevel
  SkillLevelToGrowVars[SkillLevel] = DefaultGrowVars
  local VarSkillLevelSource = Data.VarSkillLevelSource
  if VarSkillLevelSource then
    for VarName, SkillId in pairs(VarSkillLevelSource) do
      local Skill = self:GetSkill(SkillId)
      if not Skill then
        Battle(self):ShowBattleError("初始化被动[" .. tostring(Effect.PassiveEffectId) .. "]参数Vars的时候,找不到技能[" .. tostring(SkillId) .. "]")
        Skill = Effect
      end
      local LevelInfo = Skill:GetSkillLevelInfo()
      local SkillLevel = LevelInfo.SkillLevel
      if not SkillLevelToGrowVars[SkillLevel] then
        local GrowVars = SkillUtils.GrowProxy("PassiveEffect", PassiveEffectId, Skill, Vars)
        SkillLevelToGrowVars[SkillLevel] = GrowVars
      end
      VarNameToGrowVars[VarName] = SkillLevelToGrowVars[SkillLevel]
    end
  end
  for _, VarName in pairs(CommonUtils.Keys(Vars)) do
    local GrowVars = DefaultGrowVars
    if VarNameToGrowVars[VarName] then
      GrowVars = VarNameToGrowVars[VarName]
    end
    local Value = GrowVars[VarName]
    Effect[VarName] = Value
  end
end

function Component:RecoveryPassiveEffects()
  for SkillId, Skill in pairs(self.Skills) do
    if Skill.PassiveEffects then
      local Weapon = Skill.Weapon
      for _, PassiveEffectId in pairs(Skill.PassiveEffects) do
        self:AddPassiveEffectBySkill(Skill, PassiveEffectId, Weapon)
      end
    end
  end
  self:ServerSetRoleMod(self.RoleId, self.ModPassives, false)
  if self.Weapons then
    for _, Weapon in pairs(self.Weapons) do
      self:AddWeaponModPassiveEffect(Weapon, Weapon.PassiveEffects)
    end
  end
  if GWorld.RougeLikeManager then
    self:AddPassiveEffectByRouge()
  end
end

function Component:AddPassiveEffectByRouge()
  local RougeLikeManager = GWorld.RougeLikeManager
  for BlessingGroupId, BlessingGroupCount in pairs(RougeLikeManager.BlessingGroup) do
    local GroupPassiveEffects = DataMgr.BlessingGroup[BlessingGroupId].PassiveEffects
    for _, PassiveEffectId in ipairs(GroupPassiveEffects) do
      local PassiveEffectActor = self:AddPassiveEffectByRole(self.CurrentRoleId, PassiveEffectId, 0)
      for i, Threshold in ipairs(DataMgr.BlessingGroup[BlessingGroupId].ActivateNeed) do
        if BlessingGroupCount < Threshold + RougeLikeManager.BlessingGroupDiscount then
          break
        end
        PassiveEffectActor:SetSkillLevel(i)
      end
    end
  end
end

function Component:GetTeammateEvent()
  return BattleEventName.TeammateEvent
end

function Component:GetBattleEventNames()
  local BattleEventNames = {}
  for _, EventName in ipairs(BattleEventName) do
    table.insert(BattleEventNames, EventName)
  end
  return BattleEventNames
end

return Component
