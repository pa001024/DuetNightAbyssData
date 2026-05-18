local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildLevel", {
  [1] = {
    GuildDes = "GuildUpgradeDes_1",
    GuildEXP = 30000,
    GuildLv = 1,
    GuildMembersNum = 25
  },
  [2] = {
    GuildDes = "GuildUpgradeDes_2",
    GuildEXP = 43000,
    GuildLv = 2,
    GuildMembersNum = 30
  },
  [3] = {
    GuildDes = "GuildUpgradeDes_3",
    GuildEXP = 58000,
    GuildLv = 3,
    GuildMembersNum = 35
  },
  [4] = {
    GuildDes = "GuildUpgradeDes_4",
    GuildEXP = 75000,
    GuildLv = 4,
    GuildMembersNum = 40
  },
  [5] = {
    GuildDes = "GuildUpgradeDes_5",
    GuildEXP = 94000,
    GuildLv = 5,
    GuildMembersNum = 45
  },
  [6] = {
    GuildDes = "GuildUpgradeDes_6",
    GuildEXP = 154000,
    GuildLv = 6,
    GuildMembersNum = 50
  }
})
