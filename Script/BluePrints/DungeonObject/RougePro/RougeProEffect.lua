local RougeProEffect = DungeonClass.Class()

function RougeProEffect:BeginPlay()
  self.BuffList = {}
end

function RougeProEffect:ActivateRougeProEffects(Source, Effect)
  for i = 1, #Effect do
    self:ActivateRougeProSingleEffect(Source, Effect[i])
  end
end

function RougeProEffect:ActivateRougeProSingleEffect(Source, EffectId)
  local EffectInfo = DataMgr.RougeProEffect[EffectId]
  if not EffectInfo then
    self:Log("ActivateRougeProSingleEffect error, cannot find EffectInfo for EffectId", EffectId)
    return
  end
  local BuffType = EffectInfo.BuffType
  if 1 == BuffType then
    Source:ApplyRougeProEffect(Source, EffectId)
  elseif 2 == BuffType then
    for _, Player in self:PlayerIterator() do
      Player:ApplyRougeProEffect(Source, EffectId)
    end
  elseif 3 == BuffType then
    self:ApplyRougeProEffect(Source, EffectId)
  end
end

function RougeProEffect:GetRougeProEffect(EffectType, Player)
  local func = self["GetRougeProEffect_" .. EffectType]
  if not func then
    return
  end
  return func(self, Player)
end

function RougeProEffect:GetRougeProEffect_RandomChoice(Player)
  return next(self.bRandomChoice) or next(Player.bRandomChoice)
end

return RougeProEffect
