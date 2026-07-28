local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PermanentTreasureHunt", {
  [150] = {
    Season = 150,
    SeasonAvailableDate = LocalTimeProxy(1788771600),
    SeasonBackpackId = {
      11,
      12,
      13,
      14,
      15,
      16
    },
    SeasonCurrency = 6000006,
    SeasonDungeonId = {
      10302701,
      10302702,
      10302703,
      10302704
    },
    SeasonEndDate = LocalTimeProxy(1788814800),
    SeasonEventId = 103027,
    SeasonLimitTaskId = {1030270, 1030271},
    SeasonShop = 119,
    SeasonStartDate = LocalTimeProxy(1785117600),
    SeasonTicket = 6000007,
    SeasonTicketShopId = 10012126
  }
})
