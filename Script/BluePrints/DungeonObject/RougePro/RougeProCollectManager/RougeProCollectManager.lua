local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougeProCollectManager = DungeonClass.Class()

function RougeProCollectManager:OnRoundFinish()
  for k, v in pairs(self.RougeProCollectTimerList or {}) do
    self:RemoveTimer(v)
  end
  self.RougeProCollectTimerList = {}
  local tabRoom = DataMgr.RougePro_Room[self.RoomList[self.Round]]
  if tabRoom and tabRoom.CollectionList then
    self:SceneObjManagerStaticCreatorDestroy(tabRoom.CollectionList)
  end
end

function RougeProCollectManager:OnChangeRound()
  local tabRoom = DataMgr.RougePro_Room[self.RoomList[self.Round]]
  if tabRoom and tabRoom.CollectionList then
    for i = 1, #tabRoom.CollectionList do
      self:RougeProSpawnNewCollect(tabRoom.CollectionList[i])
    end
  end
end

function RougeProCollectManager:RougeProSpawnNewCollect(StaticCreatorId)
  local CollectObj = RougeProSceneObjAttr()
  CollectObj:SetRougeProCollectStaticCreatorId(StaticCreatorId)
  self:SceneObjManagerStaticCreatorActive({StaticCreatorId}, CollectObj)
end

function RougeProCollectManager:RougePro_Collect(EventInfo)
  print("RougeProCollectManager:RougePro_Collect EventInfo =" .. CommonUtils.TableToString3(EventInfo))
  local UniqueId = EventInfo.UniqueId
  local AvatarEid = EventInfo.PlayerEid
  local Mechanism = self:GetMechanism(UniqueId)
  if nil == Mechanism then
    return
  end
  local CollectObj = self:GetMechanismSceneObjAttr(UniqueId)
  if nil == CollectObj then
    return
  end
  local StaticCreatorId = CollectObj:GetRougeProCollectStaticCreatorId()
  if nil == StaticCreatorId then
    return
  end
  if CollectObj:IsAlive() == false then
    return
  end
  CollectObj:SetAlive(false)
  local tabMechanism = DataMgr.Mechanism[Mechanism.UnitId]
  if tabMechanism and tabMechanism.RewardId then
    self:ForEachPlayer(function(Player)
      self:TriggerRewardEvent(Mechanism.UnitId, CommonConst.RewardReason.Chest, {
        Avatar = Player:GetAvatarEid()
      }, function(FilterRewards, OtherParams)
      end)
    end)
  end
  if tabMechanism and tabMechanism.UnitParams then
    self:ForEachPlayer(function(Player)
      for RewardName, RewardValue in pairs(tabMechanism.UnitParams) do
        if "Token" == RewardName then
          Player:AddToken(RewardValue)
        end
        if "Ore" == RewardName then
          Player:AddOre(RewardValue)
        end
        if "Timber" == RewardName then
          Player:AddTimber(RewardValue)
        end
      end
    end)
  end
  self:SceneObjManagerStaticCreatorDestroy({StaticCreatorId})
  self:NotifyGameModeMechanismState(EventInfo)
  local CollectRegionRefreshCD = DataMgr.RougeProSeason[self.SeasonId] and DataMgr.RougeProSeason[self.SeasonId].CollectRegionRefreshCD
  if CollectRegionRefreshCD then
    local Timer = self:AddTimer(CollectRegionRefreshCD, function()
      self:RougeProSpawnNewCollect(StaticCreatorId)
    end)
    self.RougeProCollectTimerList[StaticCreatorId] = Timer
  end
end

return RougeProCollectManager
