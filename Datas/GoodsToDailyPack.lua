local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GoodsToDailyPack", {
  ["com.hero.dna.Pay_DailyCharaShards_fushu"] = 9001,
  ["com.hero.dna.Pay_DailyCharaShards_kezhou"] = 9002
})
