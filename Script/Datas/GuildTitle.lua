local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildTitle", {
  [1] = {
    JoBLv = 1,
    TitleName = "GuildMember"
  },
  [2] = {
    ApproveApplication = 1,
    JoBLv = 2,
    LimitCount = 5,
    TitleName = "GuildOfficer"
  },
  [3] = {
    ApproveApplication = 1,
    JoBLv = 3,
    KickMembers = 1,
    LimitCount = 1,
    ModifyDeclaration = 1,
    TitleName = "GuildAdmin"
  },
  [4] = {
    ApproveApplication = 1,
    JoBLv = 4,
    KickMembers = 1,
    LimitCount = 1,
    ModifyDeclaration = 1,
    ModifyNameEmblem = 1,
    TitleName = "ViceGuildMaster"
  },
  [5] = {
    ApproveApplication = 1,
    JoBLv = 5,
    KickMembers = 1,
    LimitCount = 1,
    ModifyDeclaration = 1,
    ModifyNameEmblem = 1,
    TitleName = "GuildMaster"
  }
})
