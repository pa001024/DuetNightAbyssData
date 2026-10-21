require("Unlua")
require("Const")
local M = Class()

function M:DebugPrintRegisteredNum()
  DebugPrint("[MonsterCreateOverlapCheck] RegisteredNum = " .. tostring(self:GetRegisteredNum()))
end

function M:IsOverlappingOtherRealMonster(Monster)
  if nil == Monster or not UE4.UKismetSystemLibrary.IsValid(Monster) then
    return false
  end
  local Capsule = Monster.CapsuleComponent
  if nil == Capsule then
    return false
  end
  local QueryRadius = Capsule:GetScaledCapsuleRadius() * 2
  local QueryHalfHeight = Capsule:GetScaledCapsuleHalfHeight() + 60
  local ObjectTypes = TArray(EObjectTypeQuery)
  ObjectTypes:Add(EObjectTypeQuery.MonsterPawn)
  local ActorsToIgnore = TArray(AActor)
  ActorsToIgnore:Add(Monster)
  local OutActors = TArray(AActor)
  local bHit = UE4.UKismetSystemLibrary.CapsuleOverlapActors(Monster, Capsule:K2_GetComponentLocation(), QueryRadius, QueryHalfHeight, ObjectTypes, UE4.AMonsterCharacter, ActorsToIgnore, OutActors)
  if not bHit then
    return false
  end
  for _, Other in pairs(OutActors) do
    if Other ~= Monster and UE4.UKismetSystemLibrary.IsValid(Other) and Other.IsMonster and Other:IsMonster() and Other.IsDead and not Other:IsDead() and Other.IsRealMonster and Other:IsRealMonster() ~= false then
      return true
    end
  end
  return false
end

return M
