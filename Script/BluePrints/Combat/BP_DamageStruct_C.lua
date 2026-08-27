require("UnLua")
local MiscUtils = require("Utils.MiscUtils")
local table_concat = table.concat
local BP_DamageStruct_C = Class({
  "BluePrints.Combat.Components.SkillLevelInterface"
})

function BP_DamageStruct_C:GetExtraEffectDamageTypes()
  local OutTypes = UE.TArray(FString)
  for DamageType, DamageRate in pairs(self.DamageValues) do
    if DamageRate.ExtraEffect then
      OutTypes:Add(DamageType)
    end
  end
  return OutTypes
end

function BP_DamageStruct_C:GetDamageTags()
  local OutDamageTags = UE.TArray(FString)
  if self.DamageTag then
    for _, v in pairs(self.DamageTag) do
      OutDamageTags:Add(v)
    end
  end
  return OutDamageTags
end

return BP_DamageStruct_C
