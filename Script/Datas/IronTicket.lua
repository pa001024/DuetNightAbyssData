local T = {}
T.RT_1 = {"Forging"}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("IronTicket", {
  [1001] = {
    AccessKey = T.RT_1,
    BreakDown = {
      [15039] = 100
    },
    BreakDownLevelLimit = 100,
    DetailDes = "RESOURCE_DESC_IRONTICKET",
    FunctionDes = "RESOURCE_FUNCTION_IRONTICKET",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_Coin_Zaie.T_Resource_Coin_Zaie",
    Level = 100,
    MaxDetailDes = "RESOURCE_DESC_MAXTICKET",
    MaxFunctionDes = "RESOURCE_FUNCTION_MAXTICKET",
    MaxIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_Zaie_01.T_Resource_Zaie_01'",
    MaxLevel = 240,
    MaxName = "RESOURCE_NAME_MAXTICKET_Survival",
    Name = "RESOURCE_NAME_IRONTICKET_Survival",
    Rarity = 5,
    TicketId = 1001
  },
  [1002] = {
    AccessKey = T.RT_1,
    BreakDown = {
      [15040] = 100
    },
    BreakDownLevelLimit = 100,
    DetailDes = "RESOURCE_DESC_IRONTICKET",
    FunctionDes = "RESOURCE_FUNCTION_IRONTICKET",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_Coin_Zaie01",
    Level = 100,
    MaxDetailDes = "RESOURCE_DESC_MAXTICKET",
    MaxFunctionDes = "RESOURCE_FUNCTION_MAXTICKET",
    MaxIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_Zaie_03",
    MaxLevel = 240,
    MaxName = "RESOURCE_NAME_MAXTICKET_Defence",
    Name = "RESOURCE_NAME_IRONTICKET_Defence",
    Rarity = 5,
    TicketId = 1002
  }
})
