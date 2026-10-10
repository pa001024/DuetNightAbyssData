local M = {}

function M:OnCreateSummon(Character, Summon)
  self.Summon = Summon
end

function M:AddUltraBuff()
  local Summon = self.Summon
  if not UE4.UCharacterFunctionLibrary.IsEffectSourceValid(Summon) then
    return
  end
  local Owner = UE4.UCharacterFunctionLibrary.CastToCharacterBase(self.PassiveOwner)
  local Teammates = Owner:GetAllTeammates()
  local Total = Teammates:Num()
  local Count = 0
  for i = 1, Total do
    local Mate = Teammates:Get(i)
    UE4.UBattleFunctionLibrary.RemoveBuffFromTarget(self.PassiveOwner, Mate, 420105, false)
    if Mate:GetAttr("Attribute") == "Thunder" then
      Count = Count + 1
    end
  end
  for i = 1, Total do
    local Mate = Teammates:Get(i)
    UE4.UBattleFunctionLibrary.AddBuffToTarget(Summon, Mate, 420105, self.LastTime, 0, self, Count)
  end
end

return M
