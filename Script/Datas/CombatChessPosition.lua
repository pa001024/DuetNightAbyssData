local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CombatChessPosition", {
  [1] = {
    PositionIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_RoleType_02.T_Armory_RoleType_02'",
    PositionId = 1
  },
  [2] = {
    PositionIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_RoleType_04.T_Armory_RoleType_04'",
    PositionId = 2
  },
  [3] = {
    PositionIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_RoleType_06.T_Armory_RoleType_06'",
    PositionId = 3
  },
  [4] = {
    PositionIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_RoleType_09.T_Armory_RoleType_09'",
    PositionId = 4
  },
  [999] = {
    PositionIcon = "Texture2D'/Game/UI/Texture/Static/Atlas/Common/T_Com_IconDropItem.T_Com_IconDropItem'",
    PositionId = 999
  }
})
