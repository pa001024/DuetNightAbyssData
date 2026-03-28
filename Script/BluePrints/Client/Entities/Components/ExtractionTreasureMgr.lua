local Component = {}

function Component:EnterSoloTreasure(EventDungeonId, EventId, BagId, IsStory, IsEasy, Callback)
  local CustomParams = {
    EventDungeonId = EventDungeonId,
    BagId = BagId or 1,
    IsStory = IsStory,
    IsEasy = IsEasy
  }
  if IsStory then
    local tab = DataMgr.TreasureHuntStoryDungeon[EventDungeonId]
    if tab then
      self:EnterEventDungeon(function(errorCode)
        print("*******************ExtractionTreasureMgr:EnterSoloTreasure()**************** errorCode=" .. tostring(errorCode))
        if Callback then
          Callback(errorCode)
        end
      end, tab.DungeonId, 0, EventId, CustomParams)
    end
  else
    local tab = DataMgr.TreasureHuntRepeatDungeon[EventDungeonId]
    if tab then
      local DungeonId = IsEasy and tab.EasyDungeonId or tab.HardDungeonId
      self:EnterEventDungeon(function(errorCode)
        print("*******************ExtractionTreasureMgr:EnterSoloTreasure()**************** errorCode=" .. tostring(errorCode))
        if Callback then
          Callback(errorCode)
        end
      end, DungeonId, 0, EventId, CustomParams)
    end
  end
end

function Component:GM_TestSoloTreasureBox(UnitId, Times)
  print([[


]])
  Times = Times or 1
  for index = 1, Times do
    print(string.format("GM_TestSoloTreasureBox(%d) Once*******************", UnitId))
    local SoloTreasureUtils = require("Utils.SoloTreasureUtils")
    local list = SoloTreasureUtils:GetExtractionTreasureMechanismItemList(UnitId)
    for i = 1, #list do
      local ItemID = list[i]
      print("***GM_TestSoloTreasureBox ItemId=", ItemID)
    end
  end
  print([[


]])
end

function Component:GM_TestSoloTreasureMechanismAndItem(DungeonId)
  local ServerDomStaticCreator = require("Datas.ServerDomLevel_data.ServerDomStaticCreator")
  if nil == ServerDomStaticCreator[DungeonId] then
    return
  end
  local StaticMechanismIds = {}
  local CreatorDatas = ServerDomStaticCreator[DungeonId]
  for Id, Creator in pairs(CreatorDatas) do
    if Creator and Creator.AutoActive == true and Creator.UnitId and Creator.UnitType and Creator.UnitType == "Mechanism" then
      table.insert(StaticMechanismIds, Creator.UnitId)
    end
  end
  local RandomMechanismIds = {}
  local RandomRuleIds = {}
  local ServerDomRandomCreator = require("Datas.ServerDomLevel_data.ServerDomRandomCreator")
  local ServerRandomCreator = require("BluePrints.DungeonObject.DungeonComponent.ServerRandomCreator")
  ServerRandomCreator.DungeonId = DungeonId
  local SDRC = ServerDomRandomCreator[DungeonId]
  for RandomRuleId, ActorList in pairs(SDRC) do
    if ActorList and "table" == type(ActorList) then
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
  print("RandomRuleIds.length = " .. #RandomRuleIds)
  for i, RandomRuleId in pairs(RandomRuleIds) do
    print("RandomRuleId = " .. RandomRuleId)
    local RandomRuleInfo = ServerRandomCreator:GetRandomCreatorRuleInfo(RandomRuleId)
    if not RandomRuleInfo then
      print("not RandomRuleInfo ")
    else
      local ActorList = ServerRandomCreator:GetRandomCreatorActorList(RandomRuleId)
      if not ActorList or 0 == #ActorList then
        print("not ActorList or #ActorList == 0")
      else
        local SelectedPoints = ServerRandomCreator:SelectRandomPoints(RandomRuleId, RandomRuleInfo, ActorList)
        print("RandomRuleIds.length = " .. #SelectedPoints)
        for ActorIndex, RandomTableId in pairs(SelectedPoints) do
          local UnitInfo = RandomRuleInfo.RandomInfos[RandomTableId]
          if not UnitInfo or not UnitInfo.UnitId then
            print("not UnitInfo or not UnitInfo.UnitId")
          else
            local Unit
            if RandomRuleInfo.UnitType == "Mechanism" then
              table.insert(RandomMechanismIds, UnitInfo.UnitId)
              print(" table.insert(RandomMechanismIds), " .. UnitInfo.UnitId)
            end
          end
        end
      end
    end
  end
  
  local function GenTreasureItemFunc(UnitId, uniqueid, str)
    local SoloTreasureUtils = require("Utils.SoloTreasureUtils")
    if DataMgr.ExtractionTreasureMechanism[UnitId] == nil then
      return
    end
    local list = SoloTreasureUtils:GetExtractionTreasureMechanismItemList(UnitId)
    for i = 1, #list do
      local ItemID = list[i]
      print(string.format("***GM_TestSoloTreasureMechanismAndItem %s UniqueId=%d UnitId=%d ItemId=%d", str, uniqueid, UnitId, ItemID))
    end
  end
  
  local UniqueId = 1
  for i = 1, #StaticMechanismIds do
    GenTreasureItemFunc(StaticMechanismIds[i], UniqueId, "StaticMechanism")
    UniqueId = UniqueId + 1
  end
  for i = 1, #RandomMechanismIds do
    GenTreasureItemFunc(RandomMechanismIds[i], UniqueId, "RandomMechanism")
    UniqueId = UniqueId + 1
  end
end

return Component
