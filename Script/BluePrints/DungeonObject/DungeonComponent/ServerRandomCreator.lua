local AvatarUtils = require("BluePrints.Client.AvatarUtils")
local ServerDomRandomCreator = require("Datas.ServerDomLevel_data.ServerDomRandomCreator")
local ServerRandomCreator = DungeonClass.Class()
ServerRandomCreator.__Name__ = "ServerRandomCreator"
ServerRandomCreator.__Component__ = {}

function ServerRandomCreator:ActiveRandomCreator(RandomRuleIds)
  local Infos = {}
  for i, RandomRuleId in pairs(RandomRuleIds) do
    local RandomRuleInfo = self:GetRandomCreatorRuleInfo(RandomRuleId)
    if not RandomRuleInfo then
    else
      local ActorList = self:GetRandomCreatorActorList(RandomRuleId)
      if not ActorList or 0 == #ActorList then
      else
        local SelectedPoints = self:SelectRandomPoints(RandomRuleId, RandomRuleInfo, ActorList)
        for ActorIndex, RandomTableId in pairs(SelectedPoints) do
          local UnitInfo = RandomRuleInfo.RandomInfos[RandomTableId]
          if not UnitInfo or not UnitInfo.UnitId then
          else
            local Unit
            local FunName = "Create" .. RandomRuleInfo.UnitType
            if self[FunName] then
              Unit = self[FunName](self, UnitInfo.UnitId, "RandomCreator")
            end
            if not Unit then
            else
              local Info = {}
              Info.UnitId = Unit.UnitId
              Info.RandomRuleId = RandomRuleId
              Info.RandomPointIndex = ActorIndex
              Info.RandomTableId = RandomTableId
              Info.UniqueId = Unit.UniqueId
              Info.UnitType = RandomRuleInfo.UnitType
              Unit.RandomRuleId = RandomRuleId
              Unit.RandomPointIndex = ActorIndex
              Unit.RandomTableId = RandomTableId
              table.insert(Infos, Info)
            end
          end
        end
      end
    end
  end
  self:NotifyGameModeActiveRandomCreator(Infos)
end

function ServerRandomCreator:SelectRandomPoints(RandomRuleId, RandomRuleInfo, ActorList)
  local ActorCount = #ActorList
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
    if bSuccess and ClientRes then
      PointResults[ActorIndex] = ClientRes.CurrentTableId
    end
  end
  return PointResults
end

function ServerRandomCreator:NotifyGameModeActiveRandomCreator(Infos)
  self:NotifyGameModeDungeonEvent("ServerActiveRandomCreator", Infos)
end

function ServerRandomCreator:GetRandomCreatorRuleInfo(RandomRuleId)
  if not DataMgr.RandomCreator[RandomRuleId] then
    return nil
  end
  local RandomRuleInfo = DataMgr.RandomCreator[RandomRuleId]
  if RandomRuleInfo.UnitType and RandomRuleInfo.RandomInfos then
    return RandomRuleInfo
  end
  return nil
end

function ServerRandomCreator:GetRandomCreatorActorList(RandomRuleId)
  local DungeonId = self.DungeonId
  if not ServerDomRandomCreator[DungeonId] then
    return nil
  end
  if not ServerDomRandomCreator[DungeonId][RandomRuleId] then
    return nil
  end
  return ServerDomRandomCreator[DungeonId][RandomRuleId]
end

function ServerRandomCreator:GetAutoActiveRandomCreatorInfo()
  local DungeonId = self.DungeonId
  local RandomRuleIds = {}
  if not ServerDomRandomCreator[DungeonId] then
    return RandomRuleIds
  end
  local SDRC = ServerDomRandomCreator[DungeonId]
  for RandomRuleId, ActorList in pairs(SDRC) do
    if ActorList and type(ActorList) == "table" then
      local bHasAutoActive = false
      for _, ActorData in ipairs(ActorList) do
        if ActorData and ActorData.AutoActive == true then
          bHasAutoActive = true
          break
        end
      end
      if bHasAutoActive then
        table.insert(RandomRuleIds, RandomRuleId)
      end
    end
  end
  return RandomRuleIds
end

function ServerRandomCreator:ServerInitAutoActiveRandomCreator()
  local RandomRuleIds = self:GetAutoActiveRandomCreatorInfo()
  self:ActiveRandomCreator(RandomRuleIds)
end

function ServerRandomCreator:OnNotifyServerDungeonEvent_ServerTriggerActiveRandomCreator(RandomRuleIds)
  print("OnNotifyServerDungeonEvent_ServerTriggerActiveRandomCreator", RandomRuleIds)
  self:ActiveRandomCreator(RandomRuleIds)
end

DungeonClass.AssembleComponents(ServerRandomCreator)
return ServerRandomCreator
