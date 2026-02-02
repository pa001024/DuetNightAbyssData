local T = {}
T.RT_1 = {
  [1] = "$#GlobalPassiveData[30101].Vars.Divider*100$%",
  [2] = "$#GlobalPassiveData[30101].Vars.Penetration*100$%",
  [3] = "$(#GlobalPassiveData[30101].Vars.MaxSkillInten-1)/(#GlobalPassiveData[30101].Vars.Divider)*(#GlobalPassiveData[30101].Vars.Penetration)*100$%"
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaidBuff", {
  [1] = {
    RaidBuffDes = "Raid_Buff_11",
    RaidBuffID = 1,
    RaidBuffParameter = T.RT_1
  },
  [2] = {
    RaidBuffDes = "Raid_Buff_11",
    RaidBuffID = 2,
    RaidBuffParameter = T.RT_1
  },
  [3] = {
    RaidBuffDes = "Raid_Buff_11",
    RaidBuffID = 3,
    RaidBuffParameter = T.RT_1
  },
  [12] = {
    RaidBuffDes = "Raid_Buff_12",
    RaidBuffID = 12,
    RaidBuffParameter = {
      [1] = "$#GlobalPassiveData[30102].Vars.Divider*100$%",
      [2] = "$#GlobalPassiveData[30102].Vars.Penetration*100$%",
      [3] = "$(#GlobalPassiveData[30102].Vars.MaxSkillInten-1)/(#GlobalPassiveData[30102].Vars.Divider)*(#GlobalPassiveData[30102].Vars.Penetration)*100$%"
    }
  }
})
