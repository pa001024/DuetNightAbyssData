local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SoloTreasureDrop", {
  ["Mon.SoloTreasure.AContainer"] = {
    BoxDropRate = 0.03,
    DropMechanismId = 131076,
    MonsterTag = "Mon.SoloTreasure.AContainer"
  },
  ["Mon.SoloTreasure.APoint"] = {
    KillScore = 400,
    MonsterTag = "Mon.SoloTreasure.APoint"
  },
  ["Mon.SoloTreasure.BContainer"] = {
    BoxDropRate = 0.03,
    DropMechanismId = 131061,
    MonsterTag = "Mon.SoloTreasure.BContainer"
  },
  ["Mon.SoloTreasure.BPoint"] = {
    KillScore = 200,
    MonsterTag = "Mon.SoloTreasure.BPoint"
  },
  ["Mon.SoloTreasure.CContainer"] = {
    BoxDropRate = 0.3,
    DropMechanismId = 131079,
    MonsterTag = "Mon.SoloTreasure.CContainer"
  },
  ["Mon.SoloTreasure.CPoint"] = {
    KillScore = 3000,
    MonsterTag = "Mon.SoloTreasure.CPoint"
  },
  ["Mon.SoloTreasure.DContainer"] = {
    BoxDropRate = 0.3,
    DropMechanismId = 131064,
    MonsterTag = "Mon.SoloTreasure.DContainer"
  },
  ["Mon.SoloTreasure.DPoint"] = {
    KillScore = 1500,
    MonsterTag = "Mon.SoloTreasure.DPoint"
  },
  ["Mon.SoloTreasure.EContainer"] = {
    BoxDropRate = 1,
    DropMechanismId = 131080,
    MonsterTag = "Mon.SoloTreasure.EContainer"
  },
  ["Mon.SoloTreasure.EPoint"] = {
    KillScore = 10000,
    MonsterTag = "Mon.SoloTreasure.EPoint"
  },
  ["Mon.SoloTreasure.FContainer"] = {
    BoxDropRate = 1,
    DropMechanismId = 131065,
    MonsterTag = "Mon.SoloTreasure.FContainer"
  },
  ["Mon.SoloTreasure.FPoint"] = {
    KillScore = 5000,
    MonsterTag = "Mon.SoloTreasure.FPoint"
  }
})
