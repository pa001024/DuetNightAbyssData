local SoloTreasureUtils = {}
local SDRC = require("Datas.ServerDomLevel_data.ServerDomRandomCreator")
local SDSC = require("Datas.ServerDomLevel_data.ServerDomStaticCreator")
local AvatarUtils = require("BluePrints.Client.AvatarUtils")

function SoloTreasureUtils:GenerateStaticPointsList(DungeonId)
  if not DungeonId then
    return {}
  end
  local DungeonData = SDSC[DungeonId]
  if not DungeonData then
    return {}
  end
  local StaticPointsList = {}
  for StaticCreatorId, _ in pairs(DungeonData) do
    table.insert(StaticPointsList, StaticCreatorId)
  end
  return StaticPointsList
end

function SoloTreasureUtils:GenerateRandomPointsList(DungeonId)
  if not DungeonId then
    return {}
  end
  local DungeonRandomCreatorData = SDRC[DungeonId]
  if not DungeonRandomCreatorData then
    return {}
  end
  local RandomPointsMap = {}
  for RandomRuleId, ActorList in pairs(DungeonRandomCreatorData) do
    if 0 ~= RandomRuleId then
      local ActorCount = #ActorList
      if ActorCount > 0 then
        local RandomRuleInfo = DataMgr.RandomCreator[RandomRuleId]
        if RandomRuleInfo then
          local ActivateCount = math.min(RandomRuleInfo.Count or ActorCount, ActorCount)
          local AllIndices = {}
          for i = 1, ActorCount do
            table.insert(AllIndices, i)
          end
          for i = ActorCount, 2, -1 do
            local j = math.random(1, i)
            AllIndices[i], AllIndices[j] = AllIndices[j], AllIndices[i]
          end
          local SelectedIndices = {}
          for i = 1, ActivateCount do
            table.insert(SelectedIndices, AllIndices[i])
          end
          table.sort(SelectedIndices)
          local ProportionList = {}
          local PointResults = {}
          for _, ActorIndex in ipairs(SelectedIndices) do
            local bSuccess, ClientRes = AvatarUtils:HandleActiveRandomCreator(RandomRuleId, ActivateCount, ProportionList)
            if bSuccess then
              PointResults[ActorIndex] = ClientRes.CurrentTableId
            end
          end
          RandomPointsMap[RandomRuleId] = PointResults
        end
      end
    end
  end
  return RandomPointsMap
end

function SoloTreasureUtils:RandomTicketList()
  local list = {}
  
  local function IsExistTicket(list, ticketId)
    for i = 1, #list do
      if list[i] == ticketId then
        return true
      end
    end
    return false
  end
  
  for i = 1, 3 do
    local LotteryId = -1
    local Quality = -1
    local TotalWeight = 0
    for _, tab in pairs(DataMgr.ExtractionLotteryWeight) do
      TotalWeight = TotalWeight + tab.Weight * 10000
    end
    local randomWeight = math.random(0, TotalWeight)
    for _, tab in pairs(DataMgr.ExtractionLotteryWeight) do
      randomWeight = randomWeight - tab.Weight * 10000
      if randomWeight <= 0 then
        Quality = tab.Quality
        break
      end
    end
    local MaxIndex = 0
    for _, tab in pairs(DataMgr.ExtractionLottery) do
      if tab.Quality == Quality and IsExistTicket(list, tab.LotteryId) == false then
        MaxIndex = MaxIndex + 1
      end
    end
    MaxIndex = math.random(0, MaxIndex)
    for _, tab in pairs(DataMgr.ExtractionLottery) do
      if tab.Quality == Quality and IsExistTicket(list, tab.LotteryId) == false then
        MaxIndex = MaxIndex - 1
        if MaxIndex <= 0 then
          LotteryId = tab.LotteryId
          break
        end
      end
    end
    print(string.format("RandomTicket LotteryId = %d", LotteryId))
    if -1 ~= LotteryId then
      table.insert(list, LotteryId)
    end
  end
  return list
end

function SoloTreasureUtils:GetExtractionTreasureMechanismItemList(UnitId)
  local list = {}
  local tabExtractionTreasureMechanism = DataMgr.ExtractionTreasureMechanism[UnitId]
  local totalItemNum = math.random(tabExtractionTreasureMechanism.ItemNumRange[1], tabExtractionTreasureMechanism.ItemNumRange[2])
  if totalItemNum <= 0 then
    return list
  end
  local ItemLevelList = {}
  for id, tabExtractionTreasure in pairs(DataMgr.ExtractionTreasure) do
    local level = tabExtractionTreasure.TreasureRarity
    if tabExtractionTreasureMechanism.ItemLevelWeight[level] and tabExtractionTreasureMechanism.ItemLevelWeight[level] > 0 then
      ItemLevelList[level] = ItemLevelList[level] or {}
      table.insert(ItemLevelList[level], id)
    end
  end
  local levelWeightList = {}
  if tabExtractionTreasureMechanism.ItemLevelWeight then
    for k, v in pairs(tabExtractionTreasureMechanism.ItemLevelWeight) do
      levelWeightList[k] = v * 10000
    end
  end
  local levelLimitList = {}
  if tabExtractionTreasureMechanism.ItemLevelLimit then
    for k, v in pairs(tabExtractionTreasureMechanism.ItemLevelLimit) do
      levelLimitList[k] = v
    end
  end
  for i = 1, totalItemNum do
    local level = -1
    local totalWeight = 0
    for _level, _weight in pairs(levelWeightList) do
      totalWeight = totalWeight + _weight
    end
    local randomWeight = math.random(1, totalWeight)
    for _level, _weight in pairs(levelWeightList) do
      randomWeight = randomWeight - _weight
      if randomWeight <= 0 then
        level = _level
        break
      end
    end
    if -1 == level then
      break
    end
    if levelLimitList[level] then
      levelLimitList[level] = levelLimitList[level] - 1
    end
    if levelLimitList[level] and levelLimitList[level] <= 0 then
      levelWeightList[level] = nil
    end
    local ThisLevelList = ItemLevelList[level]
    if ThisLevelList then
      local randomIndex = math.random(1, #ThisLevelList)
      table.insert(list, ThisLevelList[randomIndex])
    end
  end
  return list
end

function SoloTreasureUtils:GetTicketEffectTreasureList(AllItemList, TicketId)
  local EffectTreasureList = {}
  local tabExtractionLottery = DataMgr.ExtractionLottery[TicketId]
  if tabExtractionLottery and 1 == tabExtractionLottery.LotteryType then
    for uid, Item in pairs(AllItemList) do
      if self:IsRewardRoomKey(Item.Id) == false then
        local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
        if tabExtractionTreasure and tabExtractionTreasure.TreasureRarity == tabExtractionLottery.Param[1] then
          EffectTreasureList[Item.UniqueId] = tabExtractionLottery.EffectParam
        end
      end
    end
  end
  if tabExtractionLottery and 2 == tabExtractionLottery.LotteryType then
    for uid, Item in pairs(AllItemList) do
      if self:IsRewardRoomKey(Item.Id) == false then
        local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
        if tabExtractionTreasure and tabExtractionTreasure.TreasureType == tabExtractionLottery.Param[1] then
          EffectTreasureList[Item.UniqueId] = tabExtractionLottery.EffectParam
        end
      end
    end
  end
  return EffectTreasureList
end

function SoloTreasureUtils:CalcTotalTreasureScore(AllItemList, TicketId)
  local tabExtractionLottery = DataMgr.ExtractionLottery[TicketId]
  if tabExtractionLottery and 1 == tabExtractionLottery.LotteryType then
    return self:CalcTotalTreasureScore_LotteryType_1(AllItemList, tabExtractionLottery.Param[1], tabExtractionLottery.Param[2], tabExtractionLottery.EffectParam)
  end
  if tabExtractionLottery and 2 == tabExtractionLottery.LotteryType then
    return self:CalcTotalTreasureScore_LotteryType_2(AllItemList, tabExtractionLottery.Param[1], tabExtractionLottery.Param[2], tabExtractionLottery.EffectParam)
  end
  if tabExtractionLottery and 3 == tabExtractionLottery.LotteryType then
    return self:CalcTotalTreasureScore_LotteryType_3(AllItemList, tabExtractionLottery.Param[1], tabExtractionLottery.Param[2], tabExtractionLottery.EffectParam)
  end
  if tabExtractionLottery and 4 == tabExtractionLottery.LotteryType then
    return self:CalcTotalTreasureScore_LotteryType_4(AllItemList, tabExtractionLottery.Param[1], tabExtractionLottery.Param[2], tabExtractionLottery.EffectParam)
  end
  if tabExtractionLottery and 5 == tabExtractionLottery.LotteryType then
    return self:CalcTotalTreasureScore_LotteryType_5(AllItemList, tabExtractionLottery.Param[1], tabExtractionLottery.Param[2], tabExtractionLottery.EffectParam)
  end
  return self:CalcTotalTreasureScore_LotteryType_NULL(AllItemList) + self:CalcTotalTreasureScore_AllRewardRoomKey(AllItemList)
end

function SoloTreasureUtils:IsRewardRoomKey(Id)
  return DataMgr.ExtractionTreasure[Id] and 5 == DataMgr.ExtractionTreasure[Id].TreasureType
end

function SoloTreasureUtils:CalcTotalTreasureScore_AllRewardRoomKey(AllItemList)
  local TotalScore = 0
  for uid, Item in pairs(AllItemList) do
    if 0 == Item.BagIndex and self:IsRewardRoomKey(Item.Id) == true then
      local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
      if tabExtractionTreasure then
        TotalScore = TotalScore + tabExtractionTreasure.TreasureValue
      end
    end
  end
  return TotalScore
end

function SoloTreasureUtils:CalcTotalTreasureScore_LotteryType_NULL(AllItemList)
  local TotalScore = 0
  for uid, Item in pairs(AllItemList) do
    if 0 == Item.BagIndex and self:IsRewardRoomKey(Item.Id) == false then
      local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
      if tabExtractionTreasure then
        TotalScore = TotalScore + tabExtractionTreasure.TreasureValue
      end
    end
  end
  return TotalScore
end

function SoloTreasureUtils:CalcTotalTreasureScore_LotteryType_1(AllItemList, Param1, Param2, EffectParam)
  local TotalScore = 0
  for uid, Item in pairs(AllItemList) do
    if 0 == Item.BagIndex and self:IsRewardRoomKey(Item.Id) == false then
      local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
      if tabExtractionTreasure then
        if tabExtractionTreasure.TreasureRarity == Param1 then
          TotalScore = TotalScore + tabExtractionTreasure.TreasureValue * EffectParam
        else
          TotalScore = TotalScore + tabExtractionTreasure.TreasureValue
        end
      end
    end
  end
  return TotalScore + self:CalcTotalTreasureScore_AllRewardRoomKey(AllItemList)
end

function SoloTreasureUtils:CalcTotalTreasureScore_LotteryType_2(AllItemList, Param1, Param2, EffectParam)
  local TotalScore = 0
  for uid, Item in pairs(AllItemList) do
    if 0 == Item.BagIndex and self:IsRewardRoomKey(Item.Id) == false then
      local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
      if tabExtractionTreasure then
        if tabExtractionTreasure.TreasureType == Param1 then
          TotalScore = TotalScore + tabExtractionTreasure.TreasureValue * EffectParam
        else
          TotalScore = TotalScore + tabExtractionTreasure.TreasureValue
        end
      end
    end
  end
  return TotalScore + self:CalcTotalTreasureScore_AllRewardRoomKey(AllItemList)
end

function SoloTreasureUtils:CalcTotalTreasureScore_LotteryType_3(AllItemList, Param1, Param2, EffectParam)
  local TotalScore = self:CalcTotalTreasureScore_LotteryType_NULL(AllItemList)
  if Param1 <= TotalScore then
    TotalScore = TotalScore * EffectParam
  end
  return TotalScore + self:CalcTotalTreasureScore_AllRewardRoomKey(AllItemList)
end

function SoloTreasureUtils:CalcTotalTreasureScore_LotteryType_4(AllItemList, Param1, Param2, EffectParam)
  local TotalScore = self:CalcTotalTreasureScore_LotteryType_NULL(AllItemList)
  local TargetNum = 0
  for uid, Item in pairs(AllItemList) do
    if 0 == Item.BagIndex then
      local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
      if tabExtractionTreasure and tabExtractionTreasure.TreasureType == Param1 then
        TargetNum = TargetNum + 1
      end
    end
  end
  if Param2 <= TargetNum then
    TotalScore = TotalScore * EffectParam
  end
  return TotalScore + self:CalcTotalTreasureScore_AllRewardRoomKey(AllItemList)
end

function SoloTreasureUtils:CalcTotalTreasureScore_LotteryType_5(AllItemList, Param1, Param2, EffectParam)
  local TotalScore = self:CalcTotalTreasureScore_LotteryType_NULL(AllItemList)
  local TargetNum = 0
  for uid, Item in pairs(AllItemList) do
    if 0 == Item.BagIndex then
      local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
      if tabExtractionTreasure and tabExtractionTreasure.TreasureRarity == Param1 then
        TargetNum = TargetNum + 1
      end
    end
  end
  if Param2 <= TargetNum then
    TotalScore = TotalScore * EffectParam
  end
  return TotalScore + self:CalcTotalTreasureScore_AllRewardRoomKey(AllItemList)
end

function SoloTreasureUtils:GetStaticCreatorInfo(DungeonId, StaticCreatorId)
  if not SDSC[DungeonId] then
    return nil
  end
  if not SDSC[DungeonId][StaticCreatorId] then
    return nil
  end
  local StaticCreatorInfo = SDSC[DungeonId][StaticCreatorId]
  if StaticCreatorInfo.UnitId and StaticCreatorInfo.UnitType then
    return StaticCreatorInfo
  end
end

function SoloTreasureUtils:IsUnitIdInStaticContainerList(DungeonId, StaticCreatorIdList, MechanismUnitId)
  local list = StaticCreatorIdList or {}
  for i = 1, #list do
    local StaticCreatorInfo = self:GetStaticCreatorInfo(DungeonId, list[i])
    if StaticCreatorInfo and StaticCreatorInfo.UnitId == MechanismUnitId then
      return true
    end
  end
  return false
end

return SoloTreasureUtils
