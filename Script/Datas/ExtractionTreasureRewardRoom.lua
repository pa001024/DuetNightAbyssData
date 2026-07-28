local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExtractionTreasureRewardRoom", {
  [131070] = {
    KeyID = {100130, 199130},
    MechanismID = 131070,
    MechanismName = "1号秘宝房间大门"
  },
  [131082] = {
    KeyID = {100131, 199131},
    MechanismID = 131082,
    MechanismName = "2号秘宝房间大门"
  },
  [131083] = {
    KeyID = {100132, 199132},
    MechanismID = 131083,
    MechanismName = "3号秘宝房间大门"
  }
})
