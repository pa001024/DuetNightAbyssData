local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildDetailItem", {
  GuildTitel_1 = {
    Describe = "GuildDescribe_1",
    ItemTitle = "GuildTitel_1"
  },
  GuildTitel_2 = {
    Describe = "GuildDescribe_2",
    ItemTitle = "GuildTitel_2"
  }
})
