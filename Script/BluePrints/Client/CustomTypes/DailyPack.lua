local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local DailyPack = Class("DailyPack", CustomTypes.CustomAttr)
DailyPack.__Props__ = {
  DailyPackId = prop.prop("Int", "client save"),
  LoginDays = prop.prop("Int", "client save", 0),
  ExpiredTime = prop.prop("Int", "client save", 0),
  Count = prop.prop("Int", "client save", 0),
  State = prop.prop("Int", "client save", 0),
  RewardGot = prop.prop("Int2IntDict", "client save"),
  LastRefreshTime = prop.prop("Int", "client save"),
  RewardRecord = prop.prop("Int2IntListDict", "save", {}),
  RewardPeriod = prop.getter("Data", "RewardPeriod"),
  RewardMailId = prop.getter("Data", "RewardMailId"),
  Reward = prop.getter("Data", "Reward"),
  LoginRequire = prop.getter("Data", "LoginRequire"),
  BuyReward = prop.getter("Data", "BuyReward")
}

function DailyPack:Init(DailyPackId)
  self.DailyPackId = DailyPackId
  self.LoginDays = 1
end

function DailyPack:Data()
  return DataMgr.DailyPack[self.DailyPackId]
end

function DailyPack:Active()
  local NowTime = TimeUtils.NowTime()
  local PeriodTime = TimeUtils.GetDaySec(self.RewardPeriod)
  if 1 == self.State and NowTime < self.ExpiredTime then
    self.ExpiredTime = self.ExpiredTime + self.RewardPeriod * CommonConst.DayTime
  else
    self.ExpiredTime = TimeUtils.NextDailyRefreshTime(NowTime) + (self.RewardPeriod - 1) * CommonConst.DayTime
    self:Reset()
  end
  self.State = 1
  self.Count = self.Count + 1
  self.LastRefreshTime = NowTime
end

function DailyPack:Reset()
  self.RewardGot = {}
  self.Count = 0
  self.LoginDays = 1
end

function DailyPack:UnActive()
  self.Count = 0
  self.State = 0
  self.LoginDays = 1
end

function DailyPack:IsActive()
  return 1 == self.State and self.ExpiredTime > TimeUtils.NowTime()
end

function DailyPack:LoginAdd()
  self.LoginDays = self.LoginDays + 1
  self.LastRefreshTime = TimeUtils.NowTime()
end

function DailyPack:LoginFinish()
  self.Count = self.Count - 1
  self.LoginDays = 0
  self.RewardGot = {}
end

function DailyPack:GetLoginRewardIdx()
  if not self:IsActive() then
    return
  end
  if not self.LoginRequire then
    return
  end
  local RewardIdx
  for k, v in ipairs(self.LoginRequire) do
    if self.LoginDays == v then
      RewardIdx = k
      break
    end
  end
  if not RewardIdx then
    return
  end
  if 1 == self.RewardGot[RewardIdx] then
    return
  end
  return RewardIdx
end

function DailyPack:HandleLogin()
  local Last5Clock = TimeUtils.TimestampLastClock(5)
  if Last5Clock < self.LastRefreshTime then
    return
  end
  self:LoginAdd()
  local RewardIdx = self:GetLoginRewardIdx()
  return RewardIdx
end

function DailyPack:CheckDailyPackFinish(RewardIdx)
  if RewardIdx >= #self.Reward then
    self:LoginFinish()
    if self.Count <= 0 then
      self:UnActive()
    end
    return true
  end
  return false
end

function DailyPack:GetRewardByRewardIdx(RewardIdx)
  return self.Reward[RewardIdx]
end

function DailyPack:SetRewardGot(RewardIdx)
  self.RewardGot[RewardIdx] = 1
end

function DailyPack:GetRewardMailId()
  return self.RewardMailId
end

function DailyPack:SetRewardRecord(RewardId, NowTime)
  local Idx = CommonUtils.Size(self.RewardRecord) + 1
  self.RewardRecord[Idx] = {
    self.LoginDays,
    RewardId,
    NowTime
  }
end

FormatProperties(DailyPack)
local DailyPackDict = Class("DailyPackDict", CustomTypes.CustomDict)
DailyPackDict.KeyType = BaseTypes.Int
DailyPackDict.ValueType = DailyPack

function DailyPackDict:GetDailyPack(DailyPackId)
  return self[DailyPackId]
end

function DailyPackDict:GetNewDailyPack(DailyPackId)
  if not self[DailyPackId] then
    self[DailyPackId] = self:NewDailyPack(DailyPackId)
  end
  return self[DailyPackId]
end

function DailyPackDict:NewDailyPack(DailyPackId)
  return DailyPack(DailyPackId)
end

return {DailyPackDict = DailyPackDict, DailyPack = DailyPack}
