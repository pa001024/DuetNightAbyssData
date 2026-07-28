local SoloTreasureUtils = require("Utils.SoloTreasureUtils")
local SoloTreasureBag = require("BluePrints.DungeonObject.SoloTreasure.SoloTreasureBag")
local ServerDomStaticCreator = require("Datas.ServerDomLevel_data.ServerDomStaticCreator")
local ServerDomRandomCreator = require("Datas.ServerDomLevel_data.ServerDomRandomCreator")
local TimeUtils = require("src.utils.TimeUtils")
local SoloTreasureItem = DungeonClass.Class()
SoloTreasureItem.UniqueId = -1
SoloTreasureItem.Id = -1
SoloTreasureItem.BagIndex = -1
SoloTreasureItem.SubBagIndex = -1
SoloTreasureItem.Pos = -1
SoloTreasureItem.Rotate = false

function SoloTreasureItem:UpdateBagPos(Item)
  self.BagIndex = Item.BagIndex
  self.SubBagIndex = Item.SubBagIndex
  self.Pos = Item.Pos
  self.Rotate = Item.Rotate
end

local SoloTreasureInfo = DungeonClass.Class()

function SoloTreasureInfo:CleanupSoloTreasureInfo()
  self.PlayerBagList = {}
  self.MechanismBagList = {}
  self.DestbinBag = {}
  self.AllItemHashMap = {}
  self.KillMonsterScore = 0
  self.ItemUniqueIdInc = 0
  self.DungeonId = -1
  self.TicketId = -1
  self.BeginTimeStamp = TimeUtils.NowTime()
  self.AllMechanismStaticIdList = {}
end

function SoloTreasureInfo:SoloTreasureInfoNewPlayerBag()
  print(string.format("SoloTreasureInfo:SoloTreasureInfoNewPlayerBag(%d)", self.BagId))
  local tab = DataMgr.ExtractionTreasureBag[self.BagId]
  if nil == tab then
    return
  end
  local ShapeList = tab.Shape
  for i = 1, #ShapeList do
    local Shape = ShapeList[i]
    local NewBag = SoloTreasureBag()
    if NewBag then
      NewBag:Init(Shape[1], Shape[2])
      table.insert(self.PlayerBagList, NewBag)
    end
  end
  self:NotifyGameModeDungeonEvent("SoloTreasureInfoNewPlayerBag", self.BagId)
end

function SoloTreasureInfo:IsSoloTreasureMechanism(UnitId)
  return DataMgr.ExtractionTreasureMechanism[UnitId] ~= nil or nil ~= DataMgr.ExtractionTreasureTribute[UnitId] or nil ~= DataMgr.ExtractionTreasureGuard[UnitId] or nil ~= DataMgr.ExtractionTreasureTicket[UnitId] or nil ~= DataMgr.ExtractionTreasureRewardRoom[UnitId]
end

function SoloTreasureInfo:OnCreateMechanism(MechanismUniqueId)
  local mechanism = self:GetMechanism(MechanismUniqueId)
  if nil == mechanism then
    print(string.format("SoloTreasureInfo:self:GetMechanism(MechanismUniqueId(%s)) == nil", MechanismUniqueId))
    return
  end
  if self:IsSoloTreasureMechanism(mechanism.UnitId) == false then
    return
  end
  print(string.format("SoloTreasureInfo:OnCreateMechanism(%s) UnitId(%s)", MechanismUniqueId, mechanism.UnitId))
  mechanism.OpenTimeStamp = -1
  mechanism.IsUsed = false
  mechanism.IsUnlock = true
  local tabExtractionTreasureMechanism = DataMgr.ExtractionTreasureMechanism[mechanism.UnitId]
  if tabExtractionTreasureMechanism then
    local NewBag = SoloTreasureBag()
    NewBag:Init(tabExtractionTreasureMechanism.Shape[1], tabExtractionTreasureMechanism.Shape[2])
    self.MechanismBagList[mechanism.UniqueId] = NewBag
  end
  local tabExtractionTreasureTribute = DataMgr.ExtractionTreasureTribute[mechanism.UnitId]
  if tabExtractionTreasureTribute then
    local NewBag = SoloTreasureBag()
    NewBag:Init(tabExtractionTreasureTribute.Shape[1], tabExtractionTreasureTribute.Shape[2])
    self.MechanismBagList[mechanism.UniqueId] = NewBag
  end
  local tabExtractionTreasureGuard = DataMgr.ExtractionTreasureGuard[mechanism.UnitId]
  if tabExtractionTreasureGuard then
    local _tabExtractionTreasureMechanism = DataMgr.ExtractionTreasureMechanism[tabExtractionTreasureGuard.MechanismItemBox]
    if _tabExtractionTreasureMechanism then
      local NewBag = SoloTreasureBag()
      NewBag:Init(_tabExtractionTreasureMechanism.Shape[1], _tabExtractionTreasureMechanism.Shape[2])
      self.MechanismBagList[mechanism.UniqueId] = NewBag
    end
  end
  local tabExtractionTreasureTicket = DataMgr.ExtractionTreasureTicket[mechanism.UnitId]
  if tabExtractionTreasureTicket then
    mechanism.TicketInfo = {}
    mechanism.TicketInfo.RenewalTimes = 0
    mechanism.TicketInfo.TicketList = SoloTreasureUtils:RandomTicketList()
  end
  if DataMgr.ExtractionTreasureTribute[mechanism.UnitId] or DataMgr.ExtractionTreasureTicket[mechanism.UnitId] then
    mechanism.IsUnlock = false
  end
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", mechanism)
end

function SoloTreasureInfo:SoloTreasureInfoOpenItemBoxMechanism(uid)
  local mechanism = self:GetMechanism(uid)
  if nil == mechanism then
    return false
  end
  local RewardItemBoxId = -1
  if DataMgr.ExtractionTreasureMechanism[mechanism.UnitId] then
    RewardItemBoxId = mechanism.UnitId
  end
  if DataMgr.ExtractionTreasureGuard[mechanism.UnitId] then
    RewardItemBoxId = DataMgr.ExtractionTreasureGuard[mechanism.UnitId].MechanismItemBox
  end
  print(string.format("SoloTreasureInfoOpenItemBoxMechanism UniqueId=%s UnitId=%s RewardItemBoxId=%s", tostring(uid), tostring(mechanism.UnitId), tostring(RewardItemBoxId)))
  if -1 == RewardItemBoxId then
    return false
  end
  if mechanism.OpenTimeStamp > 0 then
    print(string.format("SoloTreasureInfoOpenItemBoxMechanism(%s) mechanism.OpenTimeStamp(%s) > 0", tostring(uid), tostring(mechanism.OpenTimeStamp)))
    return false
  end
  mechanism.OpenTimeStamp = os.time()
  local itemlist = {}
  local ItemIdList = SoloTreasureUtils:GetExtractionTreasureMechanismItemList(RewardItemBoxId, self.EventId)
  print("ItemIdList = " .. CommonUtils.TableToString3(ItemIdList))
  for i = 1, #ItemIdList do
    local item = self:SoloTreasureInfoNewMechanismItem(uid, ItemIdList[i])
    if item then
      table.insert(itemlist, item)
    end
  end
  print(string.format("SoloTreasureInfo:SoloTreasureInfoOpenItemBoxMechanism(%s, %s) CreateNewMechanismItem=%s", tostring(uid), tostring(mechanism.UnitId), CommonUtils.TableToString3(itemlist)))
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", itemlist, true)
  return true
end

function SoloTreasureInfo:SoloTreasureInfoMoveItem(uid, TargetBagIndex, TargetSubBagIndex, Pos, IsRotate)
  local Item = self.AllItemHashMap[uid]
  if nil == Item then
    print("SoloTreasureInfoMoveItem Item == nil")
    return {}
  end
  local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
  if nil == tabExtractionTreasure then
    print("SoloTreasureInfoMoveItem tabExtractionTreasure == nil")
    return {}
  end
  local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
  if Item.Rotate then
    sizeX, sizeY = sizeY, sizeX
  end
  if IsRotate then
    sizeX, sizeY = sizeY, sizeX
  end
  local SourceBagIndex = Item.BagIndex
  local SourceSubIndex = Item.SubBagIndex
  local SourcePos = Item.Pos
  local conflict_list = {uid}
  if self:CanPlacementItem2Bag(uid, TargetBagIndex, TargetSubBagIndex, sizeX, sizeY, Pos, conflict_list) == false then
    print(string.format("CanPlacementItem2Bag(uid(%s), TargetBagIndex(%s), TargetSubBagIndex(%s), sizeX(%s), sizeY(%s), Pos(%s)) == false", tostring(uid), tostring(TargetBagIndex), tostring(TargetSubBagIndex), tostring(sizeX), tostring(sizeY), tostring(Pos)))
    return {}
  end
  print(string.format("SoloTreasureInfoMoveItem(%s) conflictlist = ", uid), CommonUtils.TableToString3(conflict_list))
  for i = 1, #conflict_list do
    if false == self:PopItemFromBag(conflict_list[i]) then
      print("SoloTreasureInfoMoveItem self:PopItemFromBag(conflict_list[i] == false")
      return {}
    end
  end
  local NewPos = self:PlacementItem2Bag(uid, TargetBagIndex, TargetSubBagIndex, sizeX, sizeY, Pos)
  if -1 == NewPos then
    print("SoloTreasureInfoMoveItemNewPos == -1")
    return {}
  end
  Item.BagIndex = TargetBagIndex
  Item.SubBagIndex = TargetSubBagIndex
  Item.Pos = NewPos
  if IsRotate then
    Item.Rotate = not Item.Rotate
  end
  for i = 2, #conflict_list do
    self:PushBackItem2Bag(conflict_list[i], SourceBagIndex, SourceSubIndex, SourcePos)
  end
  for i = 1, #conflict_list do
    local uid = conflict_list[i]
    local item = self.AllItemHashMap[uid]
    print(string.format("conflict_list[%d] item = ", i) .. CommonUtils.TableToString3(item))
  end
  return conflict_list
end

function SoloTreasureInfo:CanPlacementItem2Bag(uid, BagIndex, SubBagIndex, SizeX, SizeY, Pos, ConflictList)
  if -1 == BagIndex then
    return true
  elseif 0 == BagIndex then
    return self.PlayerBagList[SubBagIndex] and self.PlayerBagList[SubBagIndex]:CanPlacementItem(uid, SizeX, SizeY, Pos, ConflictList)
  else
    return self.MechanismBagList[BagIndex] and self.MechanismBagList[BagIndex]:CanPlacementItem(uid, SizeX, SizeY, Pos, ConflictList)
  end
end

function SoloTreasureInfo:PlacementItem2Bag(uid, BagIndex, SubBagIndex, SizeX, SizeY, Pos)
  if -1 == BagIndex then
    return self:MoveItem2DestbinBag(uid)
  elseif 0 == BagIndex and self.PlayerBagList[SubBagIndex] then
    return self.PlayerBagList[SubBagIndex]:PlacementItem(uid, SizeX, SizeY, Pos)
  elseif self.MechanismBagList[BagIndex] then
    return self.MechanismBagList[BagIndex]:PlacementItem(uid, SizeX, SizeY, Pos)
  end
  return -1
end

function SoloTreasureInfo:PushBackItem2Bag(uid, BagIndex, SubBagIndex, Pos)
  local Item = self.AllItemHashMap[uid]
  if nil == Item then
    return
  end
  local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
  if nil == tabExtractionTreasure then
    return
  end
  Item.BagIndex = BagIndex
  Item.SubBagIndex = SubBagIndex
  Item.Pos = Pos
  local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
  if Item.Rotate then
    sizeX, sizeY = sizeY, sizeX
  end
  if -1 == BagIndex then
    Item.Pos = self:MoveItem2DestbinBag(uid)
  elseif 0 == BagIndex and self.PlayerBagList[SubBagIndex] then
    Item.Pos = self.PlayerBagList[SubBagIndex]:PushItem(uid, sizeX, sizeY, Pos)
  elseif self.MechanismBagList[BagIndex] then
    Item.Pos = self.MechanismBagList[BagIndex]:PushItem(uid, sizeX, sizeY, Pos)
  end
  if -1 == Item.Pos then
    Item.BagIndex = -1
    Item.SubBagIndex = -1
    Item.Pos = self:MoveItem2DestbinBag(uid)
  end
end

function SoloTreasureInfo:PopItemFromBag(uid)
  local Item = self.AllItemHashMap[uid]
  if nil == Item then
    return false
  end
  if -1 == Item.BagIndex then
    self:RemoveItemFromDestbinBag(uid)
    return true
  end
  local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
  if nil == tabExtractionTreasure then
    return false
  end
  local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
  if Item.Rotate then
    sizeX, sizeY = sizeY, sizeX
  end
  local pos = Item.Pos
  if 0 == Item.BagIndex then
    return self.PlayerBagList[Item.SubBagIndex] and self.PlayerBagList[Item.SubBagIndex]:PopItem(uid)
  else
    return self.MechanismBagList[Item.BagIndex] and self.MechanismBagList[Item.BagIndex]:PopItem(uid)
  end
  return false
end

function SoloTreasureInfo:MoveItem2DestbinBag(uid)
  local NewPos = #self.DestbinBag + 1
  for i = 1, #self.DestbinBag do
    if -1 == self.DestbinBag[i] then
      NewPos = i
      break
    end
  end
  self.DestbinBag[NewPos] = uid
  return NewPos
end

function SoloTreasureInfo:RemoveItemFromDestbinBag(uid)
  for i = 1, #self.DestbinBag do
    if self.DestbinBag[i] == uid then
      self.DestbinBag[i] = -1
      return true
    end
  end
  return false
end

function SoloTreasureInfo:SoloTreasureInfoNewMechanismItem(MechanismUniqueId, ItemId)
  local tabExtractionTreasure = DataMgr.ExtractionTreasure[ItemId]
  if nil == tabExtractionTreasure then
    return nil
  end
  local MechanismBag = self.MechanismBagList[MechanismUniqueId]
  if nil == MechanismBag then
    return nil
  end
  local sizeX = tabExtractionTreasure.Shape[1]
  local sizeY = tabExtractionTreasure.Shape[2]
  local uid = self:GenSoloTreasureItemUniqueId()
  local Pos = MechanismBag:PushItem(uid, sizeX, sizeY)
  if -1 == Pos then
    return nil
  end
  local _SoloTreasureItem = SoloTreasureItem()
  _SoloTreasureItem.UniqueId = uid
  _SoloTreasureItem.Id = ItemId
  _SoloTreasureItem.BagIndex = MechanismUniqueId
  _SoloTreasureItem.SubBagIndex = 0
  _SoloTreasureItem.Pos = Pos
  _SoloTreasureItem.Rotate = false
  self.AllItemHashMap[uid] = _SoloTreasureItem
  return _SoloTreasureItem
end

function SoloTreasureInfo:SoloTreasureInfoDestoryItem(ItemUniqueId)
  local Item = self.AllItemHashMap[ItemUniqueId]
  if nil == Item then
    return false
  end
  local Bag
  if 0 == Item.BagIndex then
    Bag = self.PlayerBagList[Item.SubBagIndex]
  else
    Bag = self.MechanismBagList[Item.BagIndex]
  end
  if nil == Bag then
    return false
  end
  local ItemId = Item.Id
  local IsRotate = Item.Rotate
  local tabExtractionTreasure = DataMgr.ExtractionTreasure[ItemId]
  if nil == tabExtractionTreasure then
    return false
  end
  local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
  if IsRotate then
    sizeX, sizeY = sizeY, sizeX
  end
  local ret = Bag:PopItem(ItemUniqueId, sizeX, sizeY)
  if ret then
    self.AllItemHashMap[ItemUniqueId] = nil
  end
  return ret
end

function SoloTreasureInfo:GenSoloTreasureItemUniqueId()
  self.ItemUniqueIdInc = self.ItemUniqueIdInc + 1
  return self.ItemUniqueIdInc
end

function SoloTreasureInfo:SoloTreasureInfo_RewardRoomOpen(Mechanism)
  local tabExtractionTreasureRewardRoom = DataMgr.ExtractionTreasureRewardRoom[Mechanism.UnitId]
  if nil == tabExtractionTreasureRewardRoom then
    return false
  end
  local KeyId = tabExtractionTreasureRewardRoom.KeyID
  local ItemUniqueId = -1
  for uid, Item in pairs(self.AllItemHashMap) do
    if 0 == Item.BagIndex and CommonUtils.HasValue(KeyId, Item.Id) then
      ItemUniqueId = Item.UniqueId
      break
    end
  end
  if -1 == ItemUniqueId then
    return false
  end
  if self:SoloTreasureInfoDestoryItem(ItemUniqueId) == false then
    return false
  end
  self:NotifyGameModeDungeonEvent("OnSoloTreasureDeleteItemList", {ItemUniqueId})
  Mechanism.IsUsed = true
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
  return true
end

function SoloTreasureInfo:SoloTreasureInfo_Tribute(Mechanism)
  local MechanismUniqueId = Mechanism.UniqueId
  local tabSoloTreasure = DataMgr.SoloTreasure[self.DungeonId]
  if nil == tabSoloTreasure or nil == tabSoloTreasure.GamePlayId then
    return
  end
  local tabExtractionMechanism = DataMgr.ExtractionTreasureTribute[Mechanism.UnitId]
  if nil == tabExtractionMechanism then
    print("SoloTreasureInfo_Tribute  tabExtractionMechanism = " .. tostring(tabExtractionMechanism))
    return
  end
  local MechanismBag = self.MechanismBagList[MechanismUniqueId]
  if nil == MechanismBag then
    print("SoloTreasureInfo_Tribute  MechanismBag = " .. tostring(MechanismBag))
    return
  end
  local tabSoloTreasureGamePlay
  for i = 1, #tabSoloTreasure.GamePlayId do
    local GamePlayId = tabSoloTreasure.GamePlayId[i]
    local _tabSoloTreasureGamePlay = DataMgr.SoloTreasureGamePlay[GamePlayId]
    if _tabSoloTreasureGamePlay and _tabSoloTreasureGamePlay.Container and SoloTreasureUtils:IsUnitIdInStaticContainerList(self.DungeonId, _tabSoloTreasureGamePlay.Container, Mechanism.UnitId) then
      tabSoloTreasureGamePlay = _tabSoloTreasureGamePlay
      break
    end
  end
  if nil == tabSoloTreasureGamePlay then
    print("SoloTreasureInfo_Tribute  tabSoloTreasureGamePlay = " .. tostring(tabSoloTreasureGamePlay))
    return
  end
  local TributeItemList = {}
  local TotalScore = 0
  for uid, Item in pairs(self.AllItemHashMap) do
    if Item.BagIndex == MechanismUniqueId then
      table.insert(TributeItemList, uid)
      local tab = DataMgr.ExtractionTreasure[Item.Id]
      if tab then
        TotalScore = TotalScore + tab.TreasureValue
      end
    end
  end
  local MonsterSpawnId = -1
  if TotalScore <= 0 then
    MonsterSpawnId = -1
  elseif TotalScore < tabSoloTreasureGamePlay.Gear1 then
    MonsterSpawnId = tabSoloTreasureGamePlay.Monster1
  elseif TotalScore < tabSoloTreasureGamePlay.Gear2 then
    MonsterSpawnId = tabSoloTreasureGamePlay.Monster2
  elseif TotalScore < tabSoloTreasureGamePlay.Gear3 then
    MonsterSpawnId = tabSoloTreasureGamePlay.Monster3
  else
    MonsterSpawnId = tabSoloTreasureGamePlay.Monster4
  end
  if -1 == MonsterSpawnId then
    print("SoloTreasureInfo_Tribute  MonsterSpawnId = " .. tostring(MonsterSpawnId))
    return
  end
  for i = 1, #TributeItemList do
    if self:SoloTreasureInfoDestoryItem(TributeItemList[i]) == false then
      print(string.format("SoloTreasureInfo_Tribute self:SoloTreasureInfoDestoryItem(ItemUniqueId(%s)) == false"), TributeItemList[i])
      return
    end
  end
  print("SoloTreasureInfo_Tribute  TributeItemList = ", TributeItemList)
  self:NotifyGameModeDungeonEvent("OnSoloTreasureDeleteItemList", TributeItemList)
  Mechanism.IsUsed = true
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
  self:ServerTriggerCreateMonsterSpawn({MonsterSpawnId}, false)
  return true
end

function SoloTreasureInfo:SoloTreasureInfo_TicketSelect(Mechanism, TicketId)
  local tabExtractionTreasureTicket = DataMgr.ExtractionTreasureTicket[Mechanism.UnitId]
  if nil == tabExtractionTreasureTicket then
    return
  end
  if nil == Mechanism.TicketInfo or nil == next(Mechanism.TicketInfo.TicketList) then
    return
  end
  if CommonUtils.HasValue(Mechanism.TicketInfo.TicketList, TicketId) == false then
    print(string.format("SoloTreasureInfo:SoloTreasureInfo_TicketSelect(%d, %d) Error. TicketList = ", Mechanism.UnitId, TicketId) .. CommonUtils.TableToString3(Mechanism.TicketInfo.TicketList))
    return
  end
  self.TicketId = TicketId
  return true
end

function SoloTreasureInfo:SoloTreasureInfo_RandomTicket(Mechanism)
  if Mechanism.TicketInfo == nil then
    return
  end
  local tabExtractionTreasureTicket = DataMgr.ExtractionTreasureTicket[Mechanism.UnitId]
  if nil == tabExtractionTreasureTicket or nil == tabExtractionTreasureTicket.RenewalPoint or nil == next(tabExtractionTreasureTicket.RenewalPoint) then
    return
  end
  local RenewalTimes = Mechanism.TicketInfo.RenewalTimes + 1
  local CostPoint = tabExtractionTreasureTicket.RenewalPoint[RenewalTimes]
  if nil == CostPoint then
    CostPoint = tabExtractionTreasureTicket.RenewalPoint[#tabExtractionTreasureTicket.RenewalPoint]
  end
  if nil == CostPoint then
    return
  end
  if CostPoint > self:GetSoloTreasureKillMonsterScore() then
    return
  end
  local list = SoloTreasureUtils:RandomTicketList()
  if nil == next(list) then
    return
  end
  self:SetSoloTreasureKillMonsterScore(self:GetSoloTreasureKillMonsterScore() - CostPoint)
  print(string.format("SoloTreasureInfo_RandomTicket uid(%s) MechanismId(%d) RenewalTimes(%d) CostPoint(%d)", Mechanism.UniqueId, Mechanism.UnitId, RenewalTimes, CostPoint))
  Mechanism.TicketInfo.RenewalTimes = RenewalTimes
  Mechanism.TicketInfo.TicketList = list
  return true
end

function SoloTreasureInfo:UnlockMechanism(Mechanism)
  local MechanismId = Mechanism.UnitId
  local NeedPoint = 0
  if DataMgr.ExtractionTreasureTribute[MechanismId] then
    NeedPoint = DataMgr.ExtractionTreasureTribute[MechanismId].UnlockPoint
  end
  if DataMgr.ExtractionTreasureTicket[MechanismId] then
    NeedPoint = DataMgr.ExtractionTreasureTicket[MechanismId].UnlockPoint
  end
  if NeedPoint > self:GetSoloTreasureKillMonsterScore() then
    return false
  end
  if NeedPoint > 0 then
    self:SetSoloTreasureKillMonsterScore(self:GetSoloTreasureKillMonsterScore() - NeedPoint)
  end
  Mechanism.IsUnlock = true
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
  return true
end

function SoloTreasureInfo:GetSoloTreasureItem(uid)
  return CommonUtils.Copy(self.AllItemHashMap[uid])
end

function SoloTreasureInfo:GetSoloTreasureInfo()
  return self:GetSoloTreasureDetailInfo()
end

function SoloTreasureInfo:GetSoloTreasureDetailInfo()
  local info = {}
  info.ItemList = {}
  for uid, item in pairs(self.AllItemHashMap) do
    if 0 == item.BagIndex then
      table.insert(info.ItemList, item.Id)
    end
  end
  info.KillMonsterScore = self:GetSoloTreasureKillMonsterScore()
  info.TreasureScore = SoloTreasureUtils:CalcTotalTreasureScore(self.AllItemHashMap, self.TicketId)
  info.Ticket = self.TicketId
  info.DungeonId = self.DungeonId
  info.BeginTimeStamp = self.BeginTimeStamp
  return info
end

function SoloTreasureInfo:SetSoloTreasureTimeStamp(ANSITime)
  self.BeginTimeStamp = ANSITime
end

function SoloTreasureInfo:SetSoloTreasureKillMonsterScore(KillMonsterScore)
  print(string.format("SoloTreasureInfo:SetSoloTreasureKillMonsterScore OldKillMonsterScore(%d) NewKillMonsterScore(%d)", self.KillMonsterScore, KillMonsterScore))
  self.KillMonsterScore = KillMonsterScore
  self:NotifyGameModeDungeonEvent("OnUpdateKillMonsterScore", self.KillMonsterScore)
end

function SoloTreasureInfo:GetSoloTreasureKillMonsterScore()
  return self.KillMonsterScore
end

function SoloTreasureInfo:OnServerActiveStaticCreator(Infos)
  self.AllMechanismStaticIdList = {}
  for i = 1, #Infos do
    if self:IsSoloTreasureMechanism(Infos[i].UnitId) then
      table.insert(self.AllMechanismStaticIdList, Infos[i])
    end
  end
end

function SoloTreasureInfo:GetMechanismStaticIdByUniqueId(UniqueId)
  for i = 1, #self.AllMechanismStaticIdList do
    if self.AllMechanismStaticIdList[i].UniqueId == UniqueId then
      return self.AllMechanismStaticIdList[i].StaticCreatorId
    end
  end
  return -1
end

function SoloTreasureInfo:Init(param)
  self:CleanupSoloTreasureInfo()
  self.DungeonId = param.DungeonId
  self.BagId = param.CustomDungeonParams and param.CustomDungeonParams.BagId or 1
  self.EventId = param.CustomDungeonParams and param.CustomDungeonParams.EventId
end

function SoloTreasureInfo:BeginPlay()
  print("SoloTreasureInfo BeginPlay()")
  self:SoloTreasureInfoNewPlayerBag()
end

function SoloTreasureInfo:EndPlay()
  print("SoloTreasureInfo EndPlay()")
  self:CleanupSoloTreasureInfo()
end

function SoloTreasureInfo:CustomFinishInfo()
  local info = self:GetSoloTreasureInfo()
  self:NotifyGameModeDungeonEvent("OnSoloTreasureDeal", info)
  return info
end

function SoloTreasureInfo:GM_AddSoloTreasure(ItemId)
  local tabExtractionTreasure = DataMgr.ExtractionTreasure[ItemId]
  if nil == tabExtractionTreasure then
    return
  end
  for i = 1, #self.PlayerBagList do
    local bag = self.PlayerBagList[i]
    local sizeX = tabExtractionTreasure.Shape[1]
    local sizeY = tabExtractionTreasure.Shape[2]
    local uid = self:GenSoloTreasureItemUniqueId()
    local Pos = bag:PushItem(uid, sizeX, sizeY)
    if -1 ~= Pos then
      local _SoloTreasureItem = SoloTreasureItem()
      _SoloTreasureItem.UniqueId = uid
      _SoloTreasureItem.Id = ItemId
      _SoloTreasureItem.BagIndex = 0
      _SoloTreasureItem.SubBagIndex = i
      _SoloTreasureItem.Pos = Pos
      _SoloTreasureItem.Rotate = false
      self.AllItemHashMap[uid] = _SoloTreasureItem
      self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", {_SoloTreasureItem}, true)
      return
    end
  end
end

return SoloTreasureInfo
