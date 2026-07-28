local RougeProSceneObjAttr = DungeonClass.Class()

function RougeProSceneObjAttr:__Init__()
  self._IsAlive = true
end

function RougeProSceneObjAttr:CopyFrom(OtherAttr)
  if nil == OtherAttr then
    return
  end
  if type(OtherAttr) ~= "table" then
    return
  end
  for k, v in pairs(OtherAttr) do
    if type(k) ~= "string" or string.sub(k, 1, 2) ~= "__" then
      self[k] = v
    end
  end
end

function RougeProSceneObjAttr:IsAlive()
  return self._IsAlive
end

function RougeProSceneObjAttr:SetAlive(IsAlive)
  if self._IsAlive ~= IsAlive then
    self._IsAlive = IsAlive
    if not IsAlive and self.OnDeadFunc then
      self.OnDeadFunc()
    end
  end
end

function RougeProSceneObjAttr:RegisterDeadFunc(func)
  self.OnDeadFunc = func
end

function RougeProSceneObjAttr:SetEventId(EventId)
  self.EventId = EventId
end

function RougeProSceneObjAttr:GetEventId()
  return self.EventId
end

function RougeProSceneObjAttr:SetRewardDropBoxInfo(RewardDropBoxInfo)
  self.RewardDropBoxInfo = RewardDropBoxInfo
end

function RougeProSceneObjAttr:GetRewardDropBoxInfo()
  return self.RewardDropBoxInfo
end

function RougeProSceneObjAttr:SetMonsterSpId(MonsterSpId)
  self.MonsterSpId = MonsterSpId
end

function RougeProSceneObjAttr:GetMonsterSpId()
  return self.MonsterSpId
end

function RougeProSceneObjAttr:SetMonsterSpSpawnId(SpawnId)
  self.MonsterSpSpawnId = SpawnId
end

function RougeProSceneObjAttr:GetMonsterSpSpawnId()
  return self.MonsterSpSpawnId
end

function RougeProSceneObjAttr:SetMonsterSpRoundIndex(Round)
  self.MonsterSpRound = Round
end

function RougeProSceneObjAttr:GetMonsterSpRoundIndex()
  return self.MonsterSpRound
end

function RougeProSceneObjAttr:SetMonsterSpStrongIndex(StrongIndex)
  self.StrongIndex = StrongIndex
end

function RougeProSceneObjAttr:GetMonsterSpStrongIndex()
  return self.StrongIndex
end

function RougeProSceneObjAttr:SetDefenceRound(Round)
  self.DefenceRound = Round
end

function RougeProSceneObjAttr:GetDefenceRound()
  return self.DefenceRound
end

function RougeProSceneObjAttr:SetEffectId(EffectId)
  self.EffectId = EffectId
end

function RougeProSceneObjAttr:GetEffectId(EffectId)
  return self.EffectId
end

function RougeProSceneObjAttr:SetIsCowMechanism(Value)
  self.IsCowMechanism = Value
end

function RougeProSceneObjAttr:GetIsCowMechanism()
  return self.IsCowMechanism
end

function RougeProSceneObjAttr:SetCreateByAvatarEid(AvatarEid)
  self.CreateByAvatarEid = AvatarEid
end

function RougeProSceneObjAttr:GetCreateByAvatarEid()
  return self.CreateByAvatarEid
end

function RougeProSceneObjAttr:SetRougeProCollectStaticCreatorId(RougeProCollectStaticCreatorId)
  self.RougeProCollectStaticCreatorId = RougeProCollectStaticCreatorId
end

function RougeProSceneObjAttr:GetRougeProCollectStaticCreatorId()
  return self.RougeProCollectStaticCreatorId
end

function RougeProSceneObjAttr:SetValue(Key, Value)
  self[Key] = Value
end

function RougeProSceneObjAttr:GetValue(Key)
  return self[Key]
end

return RougeProSceneObjAttr
