local T = {}
T.RT_1 = {
  [1] = 1,
  [2] = 2,
  [3] = 3,
  [4] = 4,
  [5] = 5,
  [6] = 6
}
T.RT_2 = {}
T.RT_3 = {
  Id2Score = T.RT_2,
  Rarity2Score = T.RT_1
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Appearance2Score", {
  CharAccessory = T.RT_3,
  Hair = T.RT_3,
  Mount = T.RT_3,
  Resource = {
    Id2Score = {
      [41042] = 1
    },
    Rarity2Score = T.RT_1
  },
  Skin = {
    Id2Score = {
      [1601] = 0,
      [160101] = 0
    },
    Rarity2Score = T.RT_1
  },
  WeaponAccessory = T.RT_3,
  WeaponSkin = T.RT_3
})
