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
  },
  [13] = {
    RaidBuffDes = "Raid_Buff_13",
    RaidBuffID = 13,
    RaidBuffParameter = {
      [1] = "$#GlobalPassiveData[30103].Vars.Divider1*100$%",
      [2] = "$#GlobalPassiveData[30103].Vars.Penetration1*100$%",
      [3] = "$(#GlobalPassiveData[30103].Vars.MaxRange)/(#GlobalPassiveData[30103].Vars.Divider1)*(#GlobalPassiveData[30103].Vars.Penetration1)*100$%",
      [4] = "$#GlobalPassiveData[30103].Vars.Divider2*100$%",
      [5] = "$#GlobalPassiveData[30103].Vars.Penetration2*100$%",
      [6] = "$(#GlobalPassiveData[30103].Vars.MaxSustain)/(#GlobalPassiveData[30103].Vars.Divider2)*(#GlobalPassiveData[30103].Vars.Penetration2)*100$%"
    }
  },
  [14] = {
    RaidBuffDes = "Raid_Buff_14",
    RaidBuffID = 14,
    RaidBuffParameter = {
      [1] = "$#GlobalPassiveData[30104].Vars.Divider*100$%",
      [2] = "$#GlobalPassiveData[30104].Vars.Penetration*100$%",
      [3] = "$(#GlobalPassiveData[30104].Vars.MaxStrong)/(#GlobalPassiveData[30104].Vars.Divider)*(#GlobalPassiveData[30104].Vars.Penetration)*100$%",
      [5] = "$#GlobalPassiveData[30103].Vars.Penetration2*100$%",
      [6] = "$(#GlobalPassiveData[30103].Vars.MaxSustain)/(#GlobalPassiveData[30103].Vars.Divider2)*(#GlobalPassiveData[30103].Vars.Penetration2)*100$%"
    }
  },
  [15] = {
    RaidBuffDes = "Raid_Buff_15",
    RaidBuffID = 15,
    RaidBuffParameter = {
      [1] = "$#GlobalPassiveData[30105].Vars.Divider*100$%",
      [2] = "$#GlobalPassiveData[30105].Vars.Penetration*100$%",
      [3] = "$(#GlobalPassiveData[30105].Vars.MaxSkillInten-1)/(#GlobalPassiveData[30105].Vars.Divider)*(#GlobalPassiveData[30105].Vars.Penetration)*100$%",
      [5] = "$#GlobalPassiveData[30103].Vars.Penetration2*100$%",
      [6] = "$(#GlobalPassiveData[30103].Vars.MaxSustain)/(#GlobalPassiveData[30103].Vars.Divider2)*(#GlobalPassiveData[30103].Vars.Penetration2)*100$%"
    }
  },
  [16] = {
    RaidBuffDes = "Raid_Buff_16",
    RaidBuffID = 16,
    RaidBuffParameter = {
      [1] = "$#GlobalPassiveData[30106].Vars.Divider*100$%",
      [2] = "$#GlobalPassiveData[30106].Vars.Penetration*100$%",
      [3] = "$(#GlobalPassiveData[30106].Vars.MaxHyper-1)/(#GlobalPassiveData[30106].Vars.Divider)*(#GlobalPassiveData[30106].Vars.Penetration)*100$%",
      [4] = "$#Buff[3010016].AddAttrs[1].Value*100$%",
      [5] = "$#GlobalPassiveData[30106].Vars.LastTime$",
      [6] = "$#Buff[3010016].MaxLayer$"
    }
  },
  [17] = {
    RaidBuffDes = "Raid_Buff_17",
    RaidBuffID = 17,
    RaidBuffParameter = {
      [1] = "$#GlobalPassiveData[30107].Vars.BaseValue$",
      [2] = "$#GlobalPassiveData[30107].Vars.Divider$",
      [3] = "$#GlobalPassiveData[30107].Vars.Penetration*100$%",
      [4] = "$#GlobalPassiveData[30107].Vars.MaxRate*100$%",
      [5] = "$#Buff[3010017].AddAttrs[1].Value*100$%",
      [6] = "$#GlobalPassiveData[30107].Vars.LastTime$"
    }
  },
  [1001] = {
    RaidBuffDes = "HardBossEvent_Buff_1",
    RaidBuffID = 1001,
    RaidBuffParameter = {
      [1] = "$#PassiveEffect[6000023].Vars.ExecutedDamagedRateEachLayer*100$%",
      [2] = "$#PassiveEffect[6000023].Vars.TNMaxRateEachLayer*100$%",
      [3] = "$#PassiveEffect[6000023].Vars.DamageRateEachLayer*100$%"
    }
  },
  [1002] = {
    RaidBuffDes = "HardBossEvent_Buff_2",
    RaidBuffID = 1002,
    RaidBuffParameter = {
      [1] = "$#PassiveEffect[6000024].Vars.DamagedRateSkill*100$%",
      [2] = "$#PassiveEffect[6000024].Vars.DefRateEachLayer*100$%",
      [3] = "$#PassiveEffect[6000024].Vars.DefUpLayerLimit$",
      [4] = "$#PassiveEffect[6000024].Vars.DamageRateEachLayer*100$%",
      [5] = "$#PassiveEffect[6000024].Vars.DamageUpLayerLimit$"
    }
  }
})
