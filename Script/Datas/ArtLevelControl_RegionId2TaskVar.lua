local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ArtLevelControl_RegionId2TaskVar", {
  [1011] = {
    [1] = "IQ1003",
    [2] = "IQ1002",
    [3] = "IQ100303",
    [4] = "IQ10030498"
  },
  [1017] = {
    [1] = "IQ100304"
  },
  [1019] = {
    [1] = "IQ100306",
    [2] = "IQ10030601",
    [3] = "BH_Thea_Online"
  },
  [1021] = {
    [1] = "IQ110103",
    [2] = "IQ110107",
    [3] = "NPC110108",
    [4] = "LinshiNPC110101",
    [5] = "NengYuanNPC110105",
    [6] = "ShenWenNPC110105",
    [7] = "XimengNPC110105"
  },
  [1041] = {
    [1] = "DaFengBaoXiang200303",
    [2] = "IQ12010307",
    [3] = "IQ12010313",
    [4] = "IQ12010502",
    [5] = "IQ12010513_fu",
    [6] = "IQ120315"
  },
  [1045] = {
    [1] = "Wuyousheng_First_12020122",
    [2] = "Wuyousheng_Escape_12020212",
    [3] = "FengxiangBaoming",
    [4] = "FengxiangXiaochi",
    [5] = "FengxiangBoss",
    [6] = "IQ12030706",
    [7] = "IQ12030706_jlc",
    [8] = "IQ12020517",
    [9] = "ZhiliuA12020414"
  },
  [1051] = {
    [1] = "Qianxing12020208",
    [2] = "Int12020208"
  },
  [1052] = {
    [1] = "IQ12020401"
  },
  [1053] = {
    [1] = "Special_Zhiliu_12020515"
  },
  [1057] = {
    [1] = "AltStart",
    [2] = "IQ12010513"
  },
  [1060] = {
    [1] = "Haiboliya_Chezhan_Online",
    [2] = "IQ10040207",
    [3] = "IQ10030702",
    [4] = "CZIQ10040401",
    [5] = "IQ10040312",
    [6] = "IQ10040510",
    [7] = "IQ10040205",
    [8] = "IQ10040204",
    [9] = "IQ10040310",
    [10] = "IQ10040208",
    [11] = "IQ10040209"
  },
  [1061] = {
    [1] = "IQ10040401",
    [2] = "IQ10040402",
    [3] = "IQ10040403",
    [4] = "IQ10040406",
    [5] = "IQ10040424",
    [6] = "IQ10040506",
    [7] = "IQ10040514",
    [8] = "IQ10040407"
  }
})
