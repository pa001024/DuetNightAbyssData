local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaceLotteryInsideBuff", {
  [1001] = {
    BuffUnlockDay = 1,
    InsideBuffDes = "InsideBuffDes_1001",
    InsideBuffEffect = 1,
    InsideBuffId = 1001,
    InsideBuffName = "InsideBuffName_1001",
    RandomWeight = 120
  },
  [2001] = {
    BuffEffectPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/GamePlay/NS_Pet_Race_Speed_Puase.NS_Pet_Race_Speed_Puase'",
    BuffUnlockDay = 1,
    InsideBuffDes = "InsideBuffDes_2001",
    InsideBuffEffect = 0,
    InsideBuffId = 2001,
    InsideBuffName = "InsideBuffName_2001",
    RandomWeight = 15
  },
  [2002] = {
    BuffEffectPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/GamePlay/NS_Pet_Race_Speed_Puase.NS_Pet_Race_Speed_Puase'",
    BuffUnlockDay = 2,
    InsideBuffDes = "InsideBuffDes_2002",
    InsideBuffEffect = 0,
    InsideBuffId = 2002,
    InsideBuffName = "InsideBuffName_2002",
    RandomWeight = 15
  },
  [3001] = {
    BuffEffectPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/GamePlay/NS_Pet_Race_Speed_Buff.NS_Pet_Race_Speed_Buff'",
    BuffUnlockDay = 1,
    InsideBuffDes = "InsideBuffDes_3001",
    InsideBuffEffect = 1.2,
    InsideBuffId = 3001,
    InsideBuffName = "InsideBuffName_3001",
    RandomWeight = 40
  },
  [3002] = {
    BuffEffectPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/GamePlay/NS_Pet_Race_Speed_Buff.NS_Pet_Race_Speed_Buff'",
    BuffUnlockDay = 1,
    InsideBuffDes = "InsideBuffDes_3002",
    InsideBuffEffect = 2,
    InsideBuffId = 3002,
    InsideBuffName = "InsideBuffName_3002",
    RandomWeight = 0
  },
  [3003] = {
    BuffEffectPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/GamePlay/NS_Pet_Race_Speed_Buff.NS_Pet_Race_Speed_Buff'",
    BuffUnlockDay = 2,
    InsideBuffDes = "InsideBuffDes_3003",
    InsideBuffEffect = 2,
    InsideBuffId = 3003,
    InsideBuffName = "InsideBuffName_3003",
    RandomWeight = 20
  },
  [4001] = {
    BuffEffectPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/GamePlay/NS_Pet_Race_Speed_Debuff.NS_Pet_Race_Speed_Debuff'",
    BuffUnlockDay = 1,
    InsideBuffDes = "InsideBuffDes_4001",
    InsideBuffEffect = 0.83,
    InsideBuffId = 4001,
    InsideBuffName = "InsideBuffName_4001",
    RandomWeight = 40
  },
  [4002] = {
    BuffEffectPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/GamePlay/NS_Pet_Race_Speed_Debuff.NS_Pet_Race_Speed_Debuff'",
    BuffUnlockDay = 2,
    InsideBuffDes = "InsideBuffDes_4002",
    InsideBuffEffect = 0.5,
    InsideBuffId = 4002,
    InsideBuffName = "InsideBuffName_4002",
    RandomWeight = 20
  },
  [5001] = {
    BuffEffectPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/GamePlay/NS_Pet_Race_Speed_Stun.NS_Pet_Race_Speed_Stun'",
    BuffUnlockDay = 1,
    InsideBuffDes = "InsideBuffDes_5001",
    InsideBuffEffect = -1,
    InsideBuffId = 5001,
    InsideBuffName = "InsideBuffName_5001",
    RandomWeight = 10
  },
  [5002] = {
    BuffEffectPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/GamePlay/NS_Pet_Race_Speed_Stun.NS_Pet_Race_Speed_Stun'",
    BuffUnlockDay = 2,
    InsideBuffDes = "InsideBuffDes_6001",
    InsideBuffEffect = -1,
    InsideBuffId = 5002,
    InsideBuffName = "InsideBuffName_6001",
    RandomWeight = 20
  }
})
