local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaceLotteryBuffMap", {
  [1001] = {
    BannedWhenValueHigherThan = 1.4,
    BuffMap = "+",
    MaxStake = "BuffText_1001",
    PValueEffect = 1.05,
    RandomWeight = 50,
    RumorId = 1001
  },
  [1002] = {
    BannedWhenValueHigherThan = 1.33,
    BuffMap = "+",
    MaxStake = "BuffText_1002",
    PValueEffect = 1.1,
    RandomWeight = 50,
    RumorId = 1002
  },
  [1003] = {
    BannedWhenValueHigherThan = 1.26,
    BuffMap = "+",
    MaxStake = "BuffText_1003",
    PValueEffect = 1.15,
    RandomWeight = 50,
    RumorId = 1003
  },
  [1004] = {
    BannedWhenValueHigherThan = 1.19,
    BuffMap = "++",
    MaxStake = "BuffText_1004",
    PValueEffect = 1.2,
    RandomWeight = 30,
    RumorId = 1004
  },
  [1005] = {
    BannedWhenValueHigherThan = 1.12,
    BuffMap = "++",
    MaxStake = "BuffText_1005",
    PValueEffect = 1.3,
    RandomWeight = 30,
    RumorId = 1005
  },
  [1006] = {
    BannedWhenValueHigherThan = 1.05,
    BuffMap = "+++",
    MaxStake = "BuffText_1006",
    PValueEffect = 2,
    RandomWeight = 10,
    RumorId = 1006
  },
  [2001] = {
    BannedWhenValueLowerThan = 0.6,
    BuffMap = "-",
    MaxStake = "BuffText_2001",
    PValueEffect = 0.95,
    RandomWeight = 50,
    RumorId = 2001
  },
  [2002] = {
    BannedWhenValueLowerThan = 0.67,
    BuffMap = "-",
    MaxStake = "BuffText_2002",
    PValueEffect = 0.91,
    RandomWeight = 50,
    RumorId = 2002
  },
  [2003] = {
    BannedWhenValueLowerThan = 0.74,
    BuffMap = "-",
    MaxStake = "BuffText_2003",
    PValueEffect = 0.87,
    RandomWeight = 50,
    RumorId = 2003
  },
  [2004] = {
    BannedWhenValueLowerThan = 0.81,
    BuffMap = "--",
    MaxStake = "BuffText_2004",
    PValueEffect = 0.83,
    RandomWeight = 30,
    RumorId = 2004
  },
  [2005] = {
    BannedWhenValueLowerThan = 0.88,
    BuffMap = "--",
    MaxStake = "BuffText_2005",
    PValueEffect = 0.77,
    RandomWeight = 30,
    RumorId = 2005
  },
  [2006] = {
    BannedWhenValueLowerThan = 0.95,
    BuffMap = "---",
    MaxStake = "BuffText_2006",
    PValueEffect = 0.5,
    RandomWeight = 10,
    RumorId = 2006
  }
})
