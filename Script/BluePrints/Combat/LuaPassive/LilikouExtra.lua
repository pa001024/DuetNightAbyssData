local M = {}

function M:Heal(Character, Damage, Source, Target)
  local SrcEid = Source:GetEid()
  local TgtEid = Target:GetEid()
  if SrcEid == TgtEid then
    return
  end
  local HyperRate = UE4.URuntimeCommonFunctionLibrary.CalcHyperTriggerRateFromSource(Character)
  local BuffValue = HyperRate * self.ShareRate
  UE4.UBattleFunctionLibrary.AddBuffToTarget(Source, Target, 540204, self.LastTime, BuffValue, self, 1)
end

return M
