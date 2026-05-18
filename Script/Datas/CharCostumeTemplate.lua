local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CharCostumeTemplate", {
  [110201] = {CharCostumeId = 110201, SkinId = 110201},
  [150401] = {CharCostumeId = 150401, SkinId = 150401},
  [210101] = {CharCostumeId = 210101, SkinId = 210102},
  [210102] = {CharCostumeId = 210102, SkinId = 210101},
  [240101] = {CharCostumeId = 240101, SkinId = 240101},
  [410201] = {CharCostumeId = 410201, SkinId = 410201},
  [510101] = {CharCostumeId = 510101, SkinId = 510101},
  [530100] = {
    BackAccessory = 40001,
    CharCostumeId = 530100,
    ColorId = {
      1001,
      1001,
      1001,
      1001
    },
    FaceAccessory = 20001,
    HeadAccessory = 10001,
    SkinId = 210102,
    WaistAccessory = 30001
  },
  [530101] = {CharCostumeId = 530101, SkinId = 530101}
})
