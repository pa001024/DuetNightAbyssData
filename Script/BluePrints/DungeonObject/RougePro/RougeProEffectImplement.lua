local OverLayRulesConst = {NoOverlay = 0, OverlayBySource = 1}
local EffectImplement = DungeonClass.Class()

function EffectImplement:BeginPlay()
  self:InitRougeProEffect()
end

function EffectImplement:PostOnInit()
  self:InitRougeProEffect()
end

function EffectImplement:InitRougeProEffect()
  self.bRandomChoice = {}
  self.BlockEffect = {}
end

function EffectImplement:ApplyRougeProEffect(Source, EffectId)
  local EffectInfo = DataMgr.RougeProEffect[EffectId]
  local bNotRecordInBuffList = EffectInfo.bNotRecordInBuffList or true
  if bNotRecordInBuffList then
    self:RealEffect(EffectInfo)
    return
  end
  if not self.BuffList[EffectId] then
    self.BuffList[EffectId] = {Source}
    self:RealEffect(EffectInfo)
  else
    local OverlayRules = EffectInfo.OverlayRules or 0
    if OverlayRules == OverLayRulesConst.NoOverlay then
      return
    elseif OverlayRules == OverLayRulesConst.OverlayBySource then
      if CommonUtils.HasValue(self.BuffList[EffectId], Source) then
        return
      else
        table.insert(self.BuffList[EffectId], Source)
        self:RealEffect(EffectInfo)
      end
    end
  end
end

function EffectImplement:RealEffect(EffectInfo)
  if self.BlockEffect[EffectInfo.Id] then
    return
  end
  local Name = EffectInfo.Name
  local EffectFunc = "RougeProEffect_" .. Name
  local Func = self[EffectFunc]
  if Func then
    Func(self, EffectInfo.Id, EffectInfo.Param)
  else
    print("ApplyRougeProEffect but cannot find EffectFunc", Name)
  end
end

function EffectImplement:RemoveEffect(EffectId)
  local EffectInfo = DataMgr.RougeProEffect[EffectId]
  local EffectFunc = "RougeProRemoveEffect" .. EffectInfo.Name
  local Func = self[EffectFunc]
  if Func then
    Func(self, EffectInfo.Id, EffectInfo.Param)
  end
end

function EffectImplement:RougeProEffect_RandomChoice(Id, Param)
  self.bRandomChoice[Id] = true
end

function EffectImplement:RougeProRemoveEffect_RandomChoice(Id, Param)
  self.bRandomChoice[Id] = nil
end

function EffectImplement:RougeProEffect_BlockEffect(Id, Param)
  local EffectList = Param[1]
  for i = 1, #EffectList do
    local EffectId = EffectList[i]
    self:RemoveEffect(EffectId)
    if not self.BlockEffect[EffectId] then
      self.BlockEffect[EffectId] = {}
    end
    self.BlockEffect[EffectId][Id] = true
  end
end

function EffectImplement:RougeProRemoveEffect_BlockEffect(Id, Param)
  local EffectList = Param[1]
  for i = 1, #EffectList do
    local EffectId = EffectList[i]
    local BlockInfo = self.BlockEffect[EffectId]
    if BlockInfo then
      BlockInfo[Id] = nil
      if not next(BlockInfo) then
        self.BlockEffect[EffectId] = nil
        local Buffs = self.BuffList[EffectId]
        if Buffs then
          self.BuffList[EffectId] = nil
          for i = 1, #Buffs do
            self:ApplyRougeProEffect(Buffs[i], EffectId)
          end
        end
      end
    end
  end
end

return EffectImplement
