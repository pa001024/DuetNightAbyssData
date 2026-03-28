local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local TimeUtils = require("Utils.TimeUtils")
local ClientDungeonSoloTreasure = {}

function ClientDungeonSoloTreasure:ClearMechanismCache()
  self.MechanismInfoMap = {}
end

function ClientDungeonSoloTreasure:GetCachedMechanismInfo(UniqueId)
  return self.MechanismInfoMap and self.MechanismInfoMap[UniqueId]
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_SoloTreasureInfoNewPlayerBag(BagId)
  print(string.format("OnNotifyGameModeDungeonEvent_SoloTreasureInfoNewPlayerBag(%d)", BagId))
  InventoryController:Destory()
  local InitParams = {BagId = BagId, bServerInit = true}
  InventoryController:Init(InitParams)
  self.AllItemList = {}
end

function ClientDungeonSoloTreasure:GetTreasureDatasById(TreasureId)
  print(string.format("ClientDungeonSoloTreasure:GetTreasureDatasById(%d)", TreasureId))
  local TreasureDatas = InventoryController:GetTreasureDatasById(TreasureId)
  return TreasureDatas
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnSoloTreasureSyncMechanism(Mechanism)
  if Mechanism and Mechanism.UniqueId then
    self.MechanismInfoMap = self.MechanismInfoMap or {}
    self.MechanismInfoMap[Mechanism.UniqueId] = Mechanism
  end
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnSoloTreasureSyncItemList(SyncItemList, IsNew)
  if not SyncItemList or not next(SyncItemList) then
    print("OnNotifyGameModeDungeonEvent_OnSoloTreasureSyncItemList SyncItemList is empty 服务器校验不通过！")
    return
  end
  for _, ItemData in pairs(SyncItemList) do
    self.AllItemList[ItemData.UniqueId] = ItemData
  end
  if IsNew then
    for _, ItemData in pairs(SyncItemList) do
      InventoryController:UpdateTreasureItemDataServerNew(ItemData)
    end
    return
  end
  local bSuccess = SyncItemList and next(SyncItemList)
  InventoryController:UpdateTreasureItemDataServer(bSuccess)
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnSoloTreasureDeleteItemList(DeleteItemList)
  for _, UniqueId in pairs(DeleteItemList) do
    InventoryController:DeleteTreasureItemDataServer(self.AllItemList[UniqueId])
    self.AllItemList[UniqueId] = nil
  end
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnGetSoloTreasureInfo(info)
  self.KillMonsterScore = info.KillMonsterScore
  self.TreasureScore = info.TreasureScore
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnUpdateKillMonsterScore(KillMonsterScore)
  print("OnNotifyGameModeDungeonEvent_OnUpdateKillMonsterScore " .. tostring(KillMonsterScore))
  self.KillMonsterScore = self.KillMonsterScore or 0
  local AddKillMonsterScore = KillMonsterScore - self.KillMonsterScore
  self.KillMonsterScore = KillMonsterScore
  EventManager:FireEvent(EventID.OnUpdateGameScore, AddKillMonsterScore, KillMonsterScore)
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnUpdateTreasureScore(TreasureScore)
  print("OnNotifyGameModeDungeonEvent_OnUpdateTreasureScore " .. tostring(TreasureScore))
  self.TreasureScore = self.TreasureScore or 0
  local AddTreasureScore = TreasureScore - self.TreasureScore or 0
  self.TreasureScore = TreasureScore
  EventManager:FireEvent(EventID.OnUpdateBagTreasureScore, AddTreasureScore)
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_OnSoloTreasureDeal(info)
  self.KillMonsterScore = info.KillMonsterScore
  self.TreasureScore = info.TreasureScore
  self.Ticket = info.Ticket
  self.DungeonId = info.DungeonId
  self.BeginTimeStamp = info.BeginTimeStamp
  if self.BeginTimeStamp == nil then
    print("OnNotifyGameModeDungeonEvent_OnSoloTreasureDeal BeginTimeStamp gets nil.")
    return
  end
  local EndTimeStamp = TimeUtils.NowTime()
  print("ClientDungeonSoloTreasure OnSoloTreasureDeal EndTimeStamp = ", EndTimeStamp, "BeginTimeStamp = ", self.BeginTimeStamp)
  self.EvacuationTime = EndTimeStamp - self.BeginTimeStamp
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_SoloTreasureTribute(uid)
  print("OnNotifyGameModeDungeonEvent_SoloTreasureTribute mechanismuid = :" .. tostring(uid))
  InventoryController:OnSoloTreasureTribute()
  EventManager:FireEvent(EventID.OnSoloTreasureTribute, uid)
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_SoloTreasureTicketSelect(uid, TicketId)
  print(string.format("OnNotifyGameModeDungeonEvent_SoloTreasureTicketSelect uid(%s) TicketId(%d)", uid, TicketId))
  self.SoloTreasureTicketId = TicketId
  EventManager:FireEvent(EventID.OnSoloTreasureGetTicket, TicketId)
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_SoloTreasureRandomTicket(uid, TicketList)
  print("OnNotifyGameModeDungeonEvent_SoloTreasureRandomTicket uid = " .. tostring(uid))
  EventManager:FireEvent(EventID.OnSoloTreasureRefreshTickets, TicketList)
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_UnlockMechanism(uid)
end

function ClientDungeonSoloTreasure:OnNotifyGameModeDungeonEvent_RewardRoomOpen(uid)
end

return ClientDungeonSoloTreasure
