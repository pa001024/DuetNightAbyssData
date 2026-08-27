local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local Achv = Class("Achv", CustomTypes.CustomAttr)
Achv.__Props__ = {
  AchvId = prop.prop("Int", "client save"),
  FinishedTargets = prop.prop("Int2IntDict", "client save"),
  IsBonus = prop.prop("Bool", "client save", false),
  Time = prop.prop("Int", "client save"),
  UniqueRecords = prop.prop("StrList", "client save"),
  ProgressIndex = prop.prop("Int", "client save", 0),
  TargetId = prop.getter("Data", "TargetId"),
  NoRepeatField = prop.getter("Data", "NoRepeatField"),
  TargetNeedCount = prop.getter("Data", "TargetProgress"),
  AchvRewardId = prop.getter("Data", "AchievementReward"),
  BeforeAchvs = prop.getter("Data", "AchievementRequire"),
  AchievementName = prop.getter("Data", "AchievementName"),
  AchievementDescribe = prop.getter("Data", "AchievementDescribe"),
  TargetProgressRenew = prop.getter("Data", "TargetProgressRenew"),
  CurrentValue = prop.prop("Int", "client save"),
  CompletionValue = prop.getter("Data", "CompletionValue")
}

function Achv:Init(AchvId)
  if not AchvId then
    return
  end
  self.AchvId = AchvId
end

function Achv:Data()
  return DataMgr.Achievement[self.AchvId]
end

function Achv:GetCount()
  local result = 0
  for _, Tid in ipairs(self.TargetId) do
    result = result + (self.FinishedTargets[Tid] or 0)
  end
  return result
end

function Achv:IsIndividual()
  local individualRule = false
  for _, Tid in ipairs(self.TargetId) do
    if DataMgr.Target[Tid] and DataMgr.Target[Tid].IndividualRule then
      individualRule = true
      break
    end
  end
  return self.CompletionValue and individualRule
end

function Achv:GetProgressIndex()
  local OldIndex = self.ProgressIndex
  local Count = self:GetCount()
  if self:IsFinished() then
    local index = 0
    if self.TargetProgressRenew then
      index = #self.TargetProgressRenew
    end
    if self.ProgressIndex ~= index + 1 then
      self.ProgressIndex = index + 1
    end
    return OldIndex, self.ProgressIndex, self.TargetNeedCount
  end
  local CurrentCount = 0
  if not self.TargetProgressRenew then
    return OldIndex, OldIndex, CurrentCount
  end
  for index, value in ipairs(self.TargetProgressRenew) do
    if value <= Count and index > self.ProgressIndex then
      self.ProgressIndex = index
      CurrentCount = value
    end
  end
  return OldIndex, self.ProgressIndex, CurrentCount
end

function Achv:IsFinished()
  return self:GetCount() >= self.TargetNeedCount or not self:CanRecvReward()
end

function Achv:OnTargetFinish(Target, UniqueAttr, FinishedCount)
  local TargetId = Target.TargetId
  local rule = Target.IndividualRule
  if self.CompletionValue and rule then
    if "greater" == rule and self.CurrentValue >= self.CompletionValue then
      self.FinishedTargets[TargetId] = 1
    elseif "less" == rule and self.CurrentValue <= self.CompletionValue then
      self.FinishedTargets[TargetId] = 1
    end
    self.FinishedTargets = self.FinishedTargets
    if self:IsFinished() then
      self.Time = math.ceil(TimeUtils.NowTime())
      return true
    end
    return false
  end
  if self.NoRepeatField then
    if not UniqueAttr then
      return false
    end
    UniqueAttr = tostring(UniqueAttr)
    if self.UniqueRecords:HasValue(UniqueAttr) then
      return false
    end
    FinishedCount = 1
    self.UniqueRecords:Append(UniqueAttr)
    self.UniqueRecords = self.UniqueRecords
  end
  for _, Tid in ipairs(self.TargetId) do
    if Tid == TargetId then
      self.FinishedTargets:SetDefault(Tid, 0)
      self.FinishedTargets[Tid] = self.FinishedTargets[Tid] + FinishedCount
      self.FinishedTargets = self.FinishedTargets
      if self:IsFinished() then
        self.Time = math.ceil(TimeUtils.NowTime())
        return true
      end
      return false
    end
  end
  return false
end

function Achv:UpdateCurrentValue(value)
  if type(value) ~= "number" or value <= 0 then
    return
  end
  self.CurrentValue = value
end

function Achv:CanRecvReward()
  return not self.IsBonus
end

function Achv:Reset()
  self.FinishedTargets = {}
  self.IsBonus = false
  self.Time = 0
  self.UniqueRecords:Clear()
  self.ProgressIndex = 0
  self.CurrentValue = 0
end

FormatProperties(Achv)
local _TransitiveRequires = {}
local _ReverseTransitive = {}
local _LockCache = setmetatable({}, {__mode = "k"})
local AchvDict = Class("AchvDict", CustomTypes.CustomDict)
AchvDict.KeyType = BaseTypes.Int
AchvDict.ValueType = Achv

function AchvDict:NewAchv(AchvId)
  local achv = Achv(AchvId)
  return achv
end

function AchvDict:GetAchv(AchvId)
  local achv = self[AchvId]
  if not achv then
    achv = self:NewAchv(AchvId)
    self[AchvId] = achv
    local cache = _LockCache[self]
    if cache then
      cache._IsFinishedCache[AchvId] = false
    end
  end
  return achv
end

function AchvDict.GetTransitiveRequires(AchvId)
  local cached = _TransitiveRequires[AchvId]
  if cached then
    return cached
  end
  local result = {}
  local stack = {AchvId}
  local visited = {
    [AchvId] = true
  }
  while #stack > 0 do
    local currentId = table.remove(stack)
    local achvInfo = DataMgr.Achievement[currentId]
    if achvInfo and achvInfo.AchievementRequire then
      for _, preId in ipairs(achvInfo.AchievementRequire) do
        if not visited[preId] then
          visited[preId] = true
          table.insert(result, preId)
          table.insert(stack, preId)
        end
      end
    end
  end
  _TransitiveRequires[AchvId] = result
  for _, preId in ipairs(result) do
    local list = _ReverseTransitive[preId]
    if not list then
      list = {}
      _ReverseTransitive[preId] = list
    end
    local found = false
    for _, depId in ipairs(list) do
      if depId == AchvId then
        found = true
        break
      end
    end
    if not found then
      table.insert(list, AchvId)
    end
  end
  return result
end

function AchvDict:InitLockCache()
  local cache = {}
  _LockCache[self] = cache
  cache._IsLockedCache = {}
  cache._IsFinishedCache = {}
  for achvId, achv in pairs(self) do
    if type(achvId) == "number" and achv and achv.IsFinished then
      cache._IsFinishedCache[achvId] = achv:IsFinished()
    end
  end
  local achievementData = DataMgr and DataMgr.Achievement
  if achievementData then
    for achvId, _ in pairs(achievementData) do
      self:_RefreshLockStatus(achvId)
    end
  end
end

function AchvDict:_RefreshLockStatus(AchvId)
  local cache = _LockCache[self]
  if not cache then
    local deps = AchvDict.GetTransitiveRequires(AchvId)
    for _, preId in ipairs(deps) do
      local preAchv = self[preId]
      if not preAchv or not preAchv:IsFinished() then
        return true
      end
    end
    return false
  end
  local locked = false
  local deps = _TransitiveRequires[AchvId]
  if deps then
    for _, preId in ipairs(deps) do
      local preAchv = self[preId]
      if not preAchv or not preAchv:IsFinished() then
        locked = true
        break
      end
    end
  end
  cache._IsLockedCache[AchvId] = locked
  return locked
end

function AchvDict:UpdateAchvLockState(AchvId)
  local cache = _LockCache[self]
  if not cache then
    return
  end
  local achv = self[AchvId]
  local nowFinished = achv and achv:IsFinished()
  local wasFinished = cache._IsFinishedCache[AchvId]
  if nowFinished == wasFinished then
    return
  end
  cache._IsFinishedCache[AchvId] = nowFinished
  local dependents = _ReverseTransitive[AchvId]
  if not dependents then
    return
  end
  for _, dependentId in ipairs(dependents) do
    cache._IsLockedCache[dependentId] = nil
  end
end

function AchvDict:IsAchvLocked(AchvId)
  local cache = _LockCache[self]
  if cache then
    local cached = cache._IsLockedCache[AchvId]
    if nil ~= cached then
      return cached
    end
    return self:_RefreshLockStatus(AchvId)
  end
  local deps = AchvDict.GetTransitiveRequires(AchvId)
  for _, preId in ipairs(deps) do
    local achievePre = self[preId]
    if not achievePre or not achievePre:IsFinished() then
      return true
    end
  end
  return false
end

function AchvDict:IsAchvCanGetReward(AchvId)
  local Achv = self[AchvId]
  if Achv then
    return Achv:IsFinished() and Achv:CanRecvReward() and not self:IsAchvLocked(AchvId)
  end
  return false
end

local AchvTarget = Class("AchvTarget", CustomTypes.CustomAttr)
AchvTarget.__Props__ = {
  TargetId = prop.prop("Int", "client save cross"),
  Count = prop.prop("Int", "client save"),
  CurrentValue = prop.prop("Int", "client save cross", -1),
  IndividualRule = prop.getter("Data", "IndividualRule")
}

function AchvTarget:Init(TargetId)
  if not TargetId then
    return
  end
  self.TargetId = TargetId
end

function AchvTarget:Data()
  return DataMgr.Target[self.TargetId]
end

function AchvTarget:AddCount(count)
  if type(count) ~= "number" or count <= 0 then
    return false
  end
  if self.IndividualRule then
    if -1 == self.CurrentValue then
      self.CurrentValue = count
      return
    end
    if self.IndividualRule == "greater" and count > self.CurrentValue then
      self.CurrentValue = count
    elseif self.IndividualRule == "less" and count < self.CurrentValue then
      self.CurrentValue = count
    end
  else
    self.Count = self.Count + count
  end
  return true
end

FormatProperties(AchvTarget)
local AchvTargetDict = Class("AchvTargetDict", CustomTypes.CustomDict)
AchvTargetDict.KeyType = BaseTypes.Int
AchvTargetDict.ValueType = AchvTarget

function AchvTargetDict:NewAchvTarget(TargetId)
  return AchvTarget(TargetId)
end

function AchvTargetDict:GetAchvTarget(TargetId)
  local target = self[TargetId]
  if not target then
    target = self:NewAchvTarget(TargetId)
    self[TargetId] = target
  end
  return target
end

local function _BuildGlobalGraphs()
  local achievementData = DataMgr and DataMgr.Achievement
  if not achievementData then
    return
  end
  for achvId, _ in pairs(achievementData) do
    AchvDict.GetTransitiveRequires(achvId)
  end
end

_BuildGlobalGraphs()
return {
  Achv = Achv,
  AchvDict = AchvDict,
  AchvTarget = AchvTarget,
  AchvTargetDict = AchvTargetDict
}
