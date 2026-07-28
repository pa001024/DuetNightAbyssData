local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaceLotteryConstant", {
  EventId = {Constant = "EventId", ConstantValue = "103025"},
  EventResultJumpId = {
    Constant = "EventResultJumpId",
    ConstantValue = "120"
  },
  EventShopJumpId = {
    Constant = "EventShopJumpId",
    ConstantValue = "115"
  },
  PlayerOutsideBuffNum = {
    Constant = "PlayerOutsideBuffNum",
    ConstantValue = "3"
  },
  RaceInsideBuffInterval = {
    Constant = "RaceInsideBuffInterval",
    ConstantValue = "2.5"
  },
  RaceLotteryAudienceCoefficient = {
    Constant = "RaceLotteryAudienceCoefficient",
    ConstantValue = "10"
  },
  RaceLotteryAudienceRefreshTime = {
    Constant = "RaceLotteryAudienceRefreshTime",
    ConstantValue = "1"
  },
  RaceLotteryChannelBusyMax = {
    Constant = "RaceLotteryChannelBusyMax",
    ConstantValue = "75"
  },
  RaceLotteryChannelBusyMin = {
    Constant = "RaceLotteryChannelBusyMin",
    ConstantValue = "50"
  },
  RaceLotteryChannelFullMax = {
    Constant = "RaceLotteryChannelFullMax",
    ConstantValue = "100"
  },
  RaceLotteryChannelFullMin = {
    Constant = "RaceLotteryChannelFullMin",
    ConstantValue = "80"
  },
  RaceLotteryChannelNormalMax = {
    Constant = "RaceLotteryChannelNormalMax",
    ConstantValue = "20"
  },
  RaceLotteryChannelNormalMin = {
    Constant = "RaceLotteryChannelNormalMin",
    ConstantValue = "10"
  },
  RaceLotteryCurrency = {
    Constant = "RaceLotteryCurrency",
    ConstantValue = "10302501"
  },
  RaceLotteryEndTime = {
    Constant = "RaceLotteryEndTime",
    ConstantValue = "0.8333333333333334"
  },
  RaceLotteryRegionOnlineId = {
    Constant = "RaceLotteryRegionOnlineId",
    ConstantValue = "106001"
  },
  RaceLotteryResultTime = {
    Constant = "RaceLotteryResultTime",
    ConstantValue = "0.8541666666666666"
  },
  RaceLotteryStartTime = {
    Constant = "RaceLotteryStartTime",
    ConstantValue = "0.20833333333333334"
  },
  RaceLotteryStartpointid = {
    Constant = "RaceLotteryStartpointid",
    ConstantValue = "22"
  },
  RaceLotterySubregionid = {
    Constant = "RaceLotterySubregionid",
    ConstantValue = "106001"
  },
  RacePlayerNum = {
    Constant = "RacePlayerNum",
    ConstantValue = "18"
  },
  RaceTimeOutTime = {
    Constant = "RaceTimeOutTime",
    ConstantValue = "30"
  },
  RaceTimeOutTimeBuff = {
    Constant = "RaceTimeOutTimeBuff",
    ConstantValue = "3002"
  },
  RaceTrackLength = {
    Constant = "RaceTrackLength",
    ConstantValue = "100"
  },
  RaceTrackNumSamples_Max = {
    Constant = "RaceTrackNumSamples_Max",
    ConstantValue = "200"
  },
  RaceTrackNumSamples_Min = {
    Constant = "RaceTrackNumSamples_Min",
    ConstantValue = "50"
  },
  RaceTrackRange = {
    Constant = "RaceTrackRange",
    ConstantValue = "1.2"
  },
  RandomRaceId = {
    Constant = "RandomRaceId",
    ConstantValue = "2"
  },
  ShortListedPlayerNum = {
    Constant = "ShortListedPlayerNum",
    ConstantValue = "6"
  }
})
