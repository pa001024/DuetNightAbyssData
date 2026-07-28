local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExtractionTreasureType", {
  [1] = {
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_SoloTreasure_Mahjong.T_Tab_SoloTreasure_Mahjong'",
    Name = "UI_ExtreactionTreasure_Type_1",
    TreasureRarity = 1
  },
  [2] = {
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_SoloTreasure_Accessory.T_Tab_SoloTreasure_Accessory'",
    Name = "UI_ExtreactionTreasure_Type_2",
    TreasureRarity = 2
  },
  [3] = {
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_SoloTreasure_DailyNecessity.T_Tab_SoloTreasure_DailyNecessity'",
    Name = "UI_ExtreactionTreasure_Type_3",
    TreasureRarity = 3
  },
  [4] = {
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_SoloTreasure_Cruio.T_Tab_SoloTreasure_Cruio'",
    Name = "UI_ExtreactionTreasure_Type_4",
    TreasureRarity = 4
  },
  [5] = {
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_SoloTreasure_Key.T_Tab_SoloTreasure_Key'",
    Name = "UI_ExtreactionTreasure_Type_5",
    TreasureRarity = 5
  }
})
