local ConditionUtils = require("BluePrints.Common.ConditionUtils")
local RougeProRandom = {}

function RougeProRandom:BeginPlay()
  self.UniqueTreasure = {}
end

function RougeProRandom:GetTreasureByRandomId(Player, RandomId)
  local RandomInfo = DataMgr.RougeProTreasureRandom[RandomId]
  if not RandomInfo then
    return
  end
  local ExcludeTreasure = {}
  for i = 1, #Player.RougeProTreasureList do
    local TreasureId = Player.RougeProTreasureList[i]
    ExcludeTreasure[TreasureId] = true
  end
  local ExcludeGroup = {}
  local DataExcludeGroup = RandomInfo.ExcludeGroup or {}
  for i = 1, #DataExcludeGroup do
    ExcludeGroup[DataExcludeGroup[i]] = true
  end
  local LimitGroup = RandomInfo.LimitGroup
  local Rarity = RandomInfo.TreasureRarity
  local RandomCount = 1
  local RandomType = RandomInfo.RandomType
  
  local function InnerGetTreasureByRandomId()
    if RandomType == CommonConst.RougeLikeAwardType.SpecifyOne then
      return self:SpecifyOneRougeProTreasure(Player, RandomInfo, ExcludeTreasure, ExcludeGroup)
    elseif RandomType == CommonConst.RougeLikeAwardType.ManualRandomThree then
      RandomCount = self:GetRougeProEffect("ChoiceNumber", Player)
    end
    local Result = {}
    local ResultLeft = self:GetRandomTreasureForCount(RandomCount, Result, LimitGroup, Rarity, ExcludeTreasure, ExcludeGroup)
    if ResultLeft <= 0 then
      return Result
    end
    print("GetTreasureByRandomId need more awards, no group limit", ResultLeft)
    ResultLeft = self:GetRandomTreasureForCount(RandomCount, Result, nil, Rarity, ExcludeTreasure, ExcludeGroup)
    if ResultLeft <= 0 then
      return Result
    end
    print("GetTreasureByRandomId need more awards, no limit", ResultLeft)
    ResultLeft = self:GetRandomTreasureForCount(RandomCount, Result, nil, nil, ExcludeTreasure, ExcludeGroup)
    return Result
  end
  
  local Result = InnerGetTreasureByRandomId()
  if RandomType == CommonConst.RougeLikeAwardType.ManualRandomThree and self:GetRougeProEffect("RandomChoice", Player) then
    Result = {
      Result[1]
    }
  end
  return Result
end

function RougeProRandom:GetRandomTreasureForCount(Count, Result, LimitGroup, Rarity, ExcludeTreasure, ExcludeGroup)
  local SuccessCount = 0
  for i = 1, Count do
    local ResultId = self:GetRandomTreasure(LimitGroup, Rarity, ExcludeTreasure, ExcludeGroup)
    Result[#Result + 1] = ResultId
    ExcludeTreasure[ResultId] = true
    SuccessCount = SuccessCount + 1
  end
  return Count - SuccessCount
end

function RougeProRandom:GetRandomTreasure(LimitGroup, Rarity, ExcludeTreasure, ExcludeGroup)
  local TargetOptionalAwardList = {}
  local TargetOptionalAwardWeightMap = {}
  local TargetOptionalWeightSum = 0
  local TreasureMap = DataMgr.RougeProConverts.TreasureMap
  
  local function AddAwardToList(OptionalAwards, GroupId)
    for i = 1, #OptionalAwards do
      local TreasureId = OptionalAwards[i]
      table.insert(TargetOptionalAwardList, TreasureId)
      local AwardWeight = DataMgr.RougeProTreasure[TreasureId].TreasureWeight
      TargetOptionalAwardWeightMap[TreasureId] = AwardWeight
      TargetOptionalWeightSum = TargetOptionalWeightSum + AwardWeight
    end
  end
  
  local function GetTreasureFromGroup(GroupId)
    if not rawget(ExcludeGroup, GroupId) then
      local Group = TreasureMap[GroupId]
      local OptionalAwards = self:GetOptionalTreasureFromGroup(Group, Rarity, ExcludeTreasure)
      AddAwardToList(OptionalAwards, GroupId)
    end
  end
  
  if LimitGroup then
    for i = 1, #LimitGroup do
      local GroupId = LimitGroup[i]
      GetTreasureFromGroup(GroupId)
    end
  else
    for GroupId, _ in pairs(TreasureMap) do
      GetTreasureFromGroup(GroupId)
    end
  end
  if TargetOptionalWeightSum <= 0 then
    return
  end
  local RandomResult = math.random(1, TargetOptionalWeightSum)
  for i = 1, #TargetOptionalAwardList do
    local AwardId = TargetOptionalAwardList[i]
    local Weight = TargetOptionalAwardWeightMap[AwardId]
    if RandomResult > Weight then
      RandomResult = RandomResult - Weight
    else
      return AwardId
    end
  end
end

function RougeProRandom:GetOptionalTreasureFromGroup(Group, Rarity, ExcludeTreasure)
  local Result = {}
  
  local function AddAwardFromGroup(TargetGroup)
    if not TargetGroup then
      return
    end
    for i = 1, #TargetGroup do
      local TreasureId = TargetGroup[i]
      local Condition = DataMgr.RougeProTreasure[TreasureId].InCondition
      if not ExcludeTreasure[TreasureId] and ConditionUtils.CheckCondition(self, Condition) and not self.UniqueTreasure[TreasureId] then
        table.insert(Result, TreasureId)
        self.UniqueTreasure[TreasureId] = true
      end
    end
  end
  
  if Rarity then
    for i = 1, #Rarity do
      local RarityId = Rarity[i]
      local TargetGroup = Group[RarityId]
      AddAwardFromGroup(TargetGroup)
    end
  else
    for _, TargetGroup in pairs(Group) do
      AddAwardFromGroup(TargetGroup)
    end
  end
  return Result
end

function RougeProRandom:SpecifyOneRougeProTreasure(Player, RandomInfo, ExcludeTreasure, ExcludeGroup)
  local SpecifyAwardId = RandomInfo.Designated
  if not SpecifyAwardId then
    return {}
  end
  if ExcludeTreasure[SpecifyAwardId] then
    print("SpecifyOneRougeProTreasure but is in exclude treasure", SpecifyAwardId)
    return {}
  end
  local TreasureInfo = DataMgr.RougeProTreasure[SpecifyAwardId]
  local GroupId = TreasureInfo.TreasureGroup
  if ExcludeGroup[GroupId] then
    print("SpecifyOneRougeProTreasure but group is in exclude group", GroupId)
    return {}
  end
  if not ConditionUtils.CheckCondition(Player, TreasureInfo.InCondition) or self.UniqueTreasure[SpecifyAwardId] then
    print("SpecifyOneRougeProTreasure but condition not satisfied", SpecifyAwardId)
    return {}
  end
  return {SpecifyAwardId}
end

function RougeProRandom:PlayerReceiveRandomTreasure(AvatarEid, RandomId)
  print(string.format("PlayerReceiveRandomTreasure(AvatarEid=%s, RandomId=%s)", tostring(AvatarEid), tostring(RandomId)))
end

return RougeProRandom
