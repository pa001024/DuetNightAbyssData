local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("IronTicket", {
  [1001] = {
    AccessKey = {"Forging"},
    DetailDes = "UI_IronTicket_Survival_DetailDes",
    FunctionDes = "UI_IronTicket_Survival_FunctionDes",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_Coin_Zaie.T_Resource_Coin_Zaie",
    Level = 100,
    Name = "UI_IronTicket_Survival_Name",
    Rarity = 5,
    TicketId = 1001
  },
  [1002] = {
    DetailDes = "UI_IronTicket_Survival_DetailDes",
    FunctionDes = "UI_IronTicket_Survival_FunctionDes",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_Coin_Zaie.T_Resource_Coin_Zaie",
    Level = 90,
    Name = "UI_IronTicket_Survival_Name",
    Rarity = 3,
    TicketId = 1002
  }
})
