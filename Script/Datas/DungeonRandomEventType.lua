local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("DungeonRandomEventType", {
  Butcher = {
    Des = "DynQuest_FortHuishou_Title",
    EventID = "Butcher",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_Lizhan.T_Dungeon_Event_Lizhan",
    Remark = "Butcher"
  },
  Chest = {
    Des = "UI_DUNGEON_TYPE_CHEST",
    EventID = "Chest",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_Chest.T_Dungeon_Event_Chest",
    Remark = "Chest"
  },
  NpcDefence = {
    Des = "UI_DUNGEON_TYPE_NPCDEFENCE",
    EventID = "NpcDefence",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_NpcDefence.T_Dungeon_Event_NpcDefence",
    Remark = "NpcDefence"
  },
  Pet = {
    Des = "DynQuest_IcelakePet_Title",
    EventID = "Pet",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_Pet.T_Dungeon_Event_Pet",
    Remark = "Pet"
  },
  Surprise = {
    Des = "UI_DUNGEON_TYPE_SURPRISEBOX",
    EventID = "Surprise",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_SurpriseBox.T_Dungeon_Event_SurpriseBox",
    Remark = "Surprise"
  },
  Treasure = {
    Des = "DynQuest_DaJie_Title",
    EventID = "Treasure",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_Dajie.T_Dungeon_Event_Dajie",
    Remark = "Treasure"
  }
})
