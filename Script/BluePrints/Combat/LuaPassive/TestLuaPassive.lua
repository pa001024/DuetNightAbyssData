local M = {}

local function CharName(Char)
  if Char and Char.IsValid and Char:IsValid() then
    return Char:GetName()
  end
  return "nil"
end

local function SourceName(Source)
  if Source and Source.GetObject then
    local Obj = Source:GetObject()
    if Obj and Obj:IsValid() then
      return Obj:GetName()
    end
  end
  return "nil"
end

function M:Damage(Character, Damage, Source, Target)
  DebugPrint("[TestLuaPassive] PassiveEffectId", self.PassiveEffectId)
  DebugPrint("[TestLuaPassive] Grade1LastTime", self.Grade1LastTime)
  DebugPrint("[TestLuaPassive] SpIncreaseProb", self.SpIncreaseProb)
  DebugPrint("[TestLuaPassive] OwnerSkill", self.OwnerSkill)
  DebugPrint(string.format("[TestLuaPassive] Damage 攻击方=%s 数值(True)=%d 来源=%s 目标=%s", CharName(Character), Damage.TrueValue, SourceName(Source), SourceName(Target)))
end

function M:Damaged(Character, Damage, Source, Target)
  DebugPrint(string.format("[TestLuaPassive] Damaged 受击方=%s 数值(True)=%d 实扣(Raw)=%d 来源=%s 目标=%s", CharName(Character), Damage.TrueValue, Damage.RawValue, SourceName(Source), SourceName(Target)))
  DebugPrint(string.format("[TestLuaPassive]   暴击率=%.2f 触发概率=%.2f", Damage.CritRate, Damage.TriggerProbability))
end

function M:InitDamage(Character, Damage, Source, Target)
  DebugPrint(string.format("[TestLuaPassive] InitDamage 攻击方=%s 基础值=%.1f 最终值=%d", CharName(Character), Damage.BaseValue, Damage.FinalValue))
end

function M:BeforeSkill(Character, Skill)
  local SkillName = Skill and Skill:GetName() or "nil"
  DebugPrint(string.format("[TestLuaPassive] BeforeSkill 角色=%s 技能=%s", CharName(Character), SkillName))
end

function M:BeginPlay()
  DebugPrint(string.format("[TestLuaPassive] 被动初始化 PassiveEffectId=%d", self.PassiveEffectId))
end

return M
