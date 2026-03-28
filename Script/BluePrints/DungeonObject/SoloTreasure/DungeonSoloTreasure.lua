local TimeUtils = require("src.utils.TimeUtils")
local DungeonSoloTreasure = {}

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_yxdtest()
  self:ActiveStaticCreator({2710005, 2710006})
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_OnInit()
  print("ljl@DungeonSoloTreasure OnInit DungeonId", self.DungeonId)
  self.CurStage = "Normal"
  local SoloTreasureInfo = DataMgr.SoloTreasure[self.DungeonId]
  if not SoloTreasureInfo then
    return
  end
  self.GameTotalTime = SoloTreasureInfo.GameTotalTime
  self.TurnRainyTime = SoloTreasureInfo.TurnRainyTime
  self.RainyRandomId = SoloTreasureInfo.RainyRandomId or {}
  print("ljl@ DungeonSoloTreasure OnInit GameTotalTime", self.GameTotalTime, "TurnRainyTime", self.TurnRainyTime)
  self:InitTableDrivenServerEventComponent("SoloTreasure")
  self:SoloTreasureGameStart()
end

function DungeonSoloTreasure:SoloTreasureGameStart()
  local BeginTimeStamp = TimeUtils.NowTime()
  self:SetSoloTreasureTimeStamp(BeginTimeStamp)
  self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnSetGameStartTime", BeginTimeStamp)
  print("DungeonSoloTreasure:SoloTreasureGameStart", BeginTimeStamp)
  self:RemoveTimer("RemainGameTime")
  self:AddLoopTimer(0.01, 0.1, function()
    self.GameTIme = TimeUtils.NowTime() - BeginTimeStamp
    self.GameTIme = math.min(self.GameTIme, self.GameTotalTime)
    if self.GameTIme == self.GameTotalTime then
      self:RemoveTimer("RemainGameTime")
      self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnTimeOver")
    end
  end, "RemainGameTime")
  self:AddTimer(self.TurnRainyTime, function()
    print("ljl@DungeonSoloTreasure OnTurnRainy")
    self.CurStage = "Rainy"
    self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnTurnRainy")
    self:ActiveRandomCreator(self.RainyRandomId)
  end)
end

function DungeonSoloTreasure:EndPlay()
  self:RemoveTimer("RemainGameTime")
end

function DungeonSoloTreasure:CheckAllowedFinish(IsWin, GameEndReason)
  return true
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_DefenceGameBegin(MechanismStaticId, UniqueId, DefenceGamePlayId)
  if self.InDefenceGame then
    return
  end
  local DefenceGameInfo = DataMgr.SoloTreasureGamePlay[DefenceGamePlayId]
  if not DefenceGameInfo then
    return
  end
  self.InDefenceGame = true
  self.DefenceContainerInfos = {}
  for _, ContainerId in pairs(DefenceGameInfo.Container or {}) do
    self.DefenceContainerInfos[ContainerId] = {IsAlive = true}
  end
  self.DefenceGamePlayId = DefenceGamePlayId
  self.DefenceGameContainerCount = #DefenceGameInfo.Container
  self.DefenceGameDeadContainerCount = 0
  self.DefenceGameMonsterSpawnId = DefenceGameInfo.MonsterSpawn
  self.DefenceGameTotalTime = DefenceGameInfo.CountDown
  self.DefenceGameTimerHandle = self:AddTimer(self.DefenceGameTotalTime, function()
    self:DefenceGameEnd(true)
  end)
  print("ljl@DungeonSoloTreasure DefenceGameBegin MonsterSpawnId", self.DefenceGameMonsterSpawnId, "StaticCreatorId", MechanismStaticId, "UniqueId", UniqueId)
  self:ServerTriggerCreateMonsterSpawn({
    self.DefenceGameMonsterSpawnId
  }, false)
end

function DungeonSoloTreasure:DefenceGameEnd(IsWin)
  if not self.InDefenceGame then
    return
  end
  self.InDefenceGame = false
  print("ljl@DungeonSoloTreasure DefenceGameEnd, IsWin: " .. tostring(IsWin))
  self:NotifyGameModeDungeonEvent("DungeonComponentFun", "DefenceGameEnd", IsWin)
  local DefenceGameInfo = DataMgr.SoloTreasureGamePlay[self.DefenceGamePlayId]
  if DefenceGameInfo and IsWin then
    self:SetSoloTreasureKillMonsterScore(self:GetSoloTreasureKillMonsterScore() + DefenceGameInfo.TaskGains)
  end
  self:ServerTriggerDestroyAll({
    self.DefenceGameMonsterSpawnId
  }, false)
  if IsWin then
    for _, Container in pairs(self.DefenceContainerInfos) do
      Container.CanOpen = Container.IsAlive and true
    end
  end
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_SpecialContainerDead(ContainerStaticId)
  if not self.InDefenceGame then
    return
  end
  if not self.DefenceContainerInfos[ContainerStaticId] then
    return
  end
  if not self.DefenceContainerInfos[ContainerStaticId].IsAlive then
    return
  end
  self.DefenceContainerInfos[ContainerStaticId].IsAlive = false
  self.DefenceGameDeadContainerCount = self.DefenceGameDeadContainerCount + 1
  print("ljl@DungeonSoloTreasure SpecialContainerDead, ContainerStaticId: ", ContainerStaticId, "CurCount: ", self.DefenceGameDeadContainerCount, "TotalCount: ", self.DefenceGameContainerCount)
  if self.DefenceGameDeadContainerCount >= self.DefenceGameContainerCount then
    self:RemoveTimer(self.DefenceGameTimerHandle)
    self:DefenceGameEnd(false)
  end
end

function DungeonSoloTreasure:DungeonMonsterDead(MonsterInfo)
  local UnitId = MonsterInfo.UnitId
  if not UnitId then
    return
  end
  local MonsterData = DataMgr.Monster[UnitId]
  if not MonsterData or not MonsterData.GamePlayTags then
    return
  end
  if 2 ~= MonsterInfo.DeathReason then
    print("DungeonSoloTreasure:DungeonMonsterDead Error: Monster", MonsterInfo.UnitId, MonsterInfo.UniqueId, "DeathReason is not Damage is", MonsterInfo.DeathReason, "return.")
    return
  end
  if MonsterInfo.IsFallTrigger == true then
    print("DungeonSoloTreasure:DungeonMonsterDead Error: Monster", MonsterInfo.UnitId, MonsterInfo.UniqueId, "IsFallTrigger=true return.")
    return
  end
  if true == MonsterInfo.bCreateByUnitButNoSummon then
    print("DungeonSoloTreasure:DungeonMonsterDead Error: Monster", MonsterInfo.UnitId, MonsterInfo.UniqueId, "bCreateByUnitButNoSummon=true return.")
    return
  end
  for i, GamePlayTag in pairs(MonsterData.GamePlayTags) do
    if DataMgr.SoloTreasureDrop[GamePlayTag] then
      local DropData = DataMgr.SoloTreasureDrop[GamePlayTag]
      if not DropData then
        return
      end
      local KillScore = DropData.KillScore or 0
      print("DungeonSoloTreasure:DungeonMonsterDead, UnitId: " .. UnitId .. "  KillScore: " .. KillScore)
      if DropData.KillScore and DropData.KillScore > 0 then
        print(string.format("DungeonSoloTreasure:DungeonMonsterDead, AddSoloTreasure Score(%d)", DropData.KillScore))
        self:SetSoloTreasureKillMonsterScore(self:GetSoloTreasureKillMonsterScore() + DropData.KillScore)
      end
      if DropData.DropMechanismId and DropData.DropMechanismId > 0 and math.random() <= DropData.BoxDropRate then
        print(string.format("DungeonSoloTreasure:DungeonMonsterDead, NewMechanism UnitId(%d)", DropData.DropMechanismId))
        local ExtraParams = {bDropMechanism = true}
        local MechanismInfo = self:CreateMechanism(DropData.DropMechanismId, ExtraParams)
        if MechanismInfo then
          local DropMechanismInfo = {
            UnitId = MechanismInfo.UnitId,
            UniqueId = MechanismInfo.UniqueId,
            Transform = MonsterInfo.Transform,
            DropReason = "MonsterDrop",
            MonsterUnitId = MonsterInfo.UnitId
          }
          self:NotifyGameModeDungeonEvent("ServerCreateDropMechanism", DropMechanismInfo)
        end
      end
    end
  end
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_GetSoloTreasureInfo()
  self:NotifyGameModeDungeonEvent("OnGetSoloTreasureInfo", self:GetSoloTreasureInfo())
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_OpenSoloTreasureMechanism(uid)
  local Mechanism = self:GetMechanism(uid)
  if nil == Mechanism then
    return
  end
  if DataMgr.ExtractionTreasureGuard[Mechanism.UnitId] then
    local ContainerStaticId = self:GetMechanismStaticIdByUniqueId(uid)
    if nil == self.DefenceContainerInfos or -1 == ContainerStaticId or nil == self.DefenceContainerInfos[ContainerStaticId] or not self.DefenceContainerInfos[ContainerStaticId].CanOpen then
      return
    end
  end
  local ret = self:SoloTreasureInfoOpenItemBoxMechanism(uid)
  if not ret then
    return
  end
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_MoveTreasureItem(uid, TargetBagIndex, TargetSubBagIndex, Pos, IsRotate)
  local item_list = {}
  local uid_list = self:SoloTreasureInfoMoveItem(uid, TargetBagIndex, TargetSubBagIndex, Pos, IsRotate)
  for i = 1, #uid_list do
    table.insert(item_list, self:GetSoloTreasureItem(uid_list[i]))
  end
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", item_list, false)
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_UpdateTreasureItemList(UpdateList)
  local CopyList = {}
  for i = 1, #UpdateList do
    local ItemCopy = self:GetSoloTreasureItem(UpdateList[i].UniqueId)
    if nil == ItemCopy or ItemCopy.Id ~= UpdateList[i].Id then
      self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", {}, false)
      return
    end
    table.insert(CopyList, ItemCopy)
  end
  
  local function RemoveTreasureListFromBag(ItemList)
    for i = 1, #ItemList do
      local Item = ItemList[i]
      if -1 == Item.BagIndex then
        self:RemoveItemFromDestbinBag(Item.UniqueId)
      else
        local Bag
        if 0 == Item.BagIndex then
          Bag = self.PlayerBagList[Item.SubBagIndex]
        else
          Bag = self.MechanismBagList[Item.BagIndex]
        end
        if nil == Bag or Bag:RemoveItem(Item.UniqueId) == false then
          print(string.format("DungeonSoloTreasure:OnNotifyServerDungeonEvent_UpdateTreasureItemList RemoveTreasureListFromBag error. Bag == nil or Bag:RemoveItem(%s) == false", tostring(Item.UniqueId)))
          return false
        end
      end
    end
    return true
  end
  
  local function AddTreasureListFromBag(ItemList)
    for i = 1, #ItemList do
      local Item = ItemList[i]
      if -1 == Item.BagIndex then
        self:MoveItem2DestbinBag(Item.UniqueId)
      else
        local tabExtractionTreasure = DataMgr.ExtractionTreasure[Item.Id]
        local sizeX, sizeY = tabExtractionTreasure.Shape[1], tabExtractionTreasure.Shape[2]
        if Item.Rotate then
          sizeX, sizeY = sizeY, sizeX
        end
        local Bag
        if 0 == Item.BagIndex then
          Bag = self.PlayerBagList[Item.SubBagIndex]
        else
          Bag = self.MechanismBagList[Item.BagIndex]
        end
        if nil == Bag or Bag:MoveItem(Item.UniqueId, sizeX, sizeY, Item.Pos) == false then
          print(string.format("DungeonSoloTreasure:OnNotifyServerDungeonEvent_UpdateTreasureItemList RemoveTreasureListFromBag error. Bag == nil or Bag:MoveItem(%s, %s, %s, %s) == false", tostring(Item.UniqueId), tostring(sizeX), tostring(sizeY), tostring(Item.Pos)))
          return false
        end
      end
    end
    return true
  end
  
  local function RevertFunc()
    RemoveTreasureListFromBag(CopyList)
    RemoveTreasureListFromBag(UpdateList)
    AddTreasureListFromBag(CopyList)
    self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", {}, false)
  end
  
  if false == RemoveTreasureListFromBag(CopyList) then
    RevertFunc()
    return
  end
  if false == AddTreasureListFromBag(UpdateList) then
    RevertFunc()
    return
  end
  for i = 1, #UpdateList do
    self.AllItemHashMap[UpdateList[i].UniqueId]:UpdateBagPos(UpdateList[i])
  end
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncItemList", UpdateList, false)
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_SoloTreasureTribute(uid)
  local Mechanism = self:GetMechanism(uid)
  if nil == Mechanism or Mechanism.IsUnlock == false or Mechanism.IsUsed == true then
    return
  end
  local ret = self:SoloTreasureInfo_Tribute(Mechanism)
  if not ret then
    return
  end
  self:NotifyGameModeDungeonEvent("SoloTreasureTribute", uid)
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_SoloTreasureTicketSelect(uid, TicketId)
  local Mechanism = self:GetMechanism(uid)
  if nil == Mechanism or Mechanism.IsUnlock == false then
    return
  end
  local ret = self:SoloTreasureInfo_TicketSelect(Mechanism, TicketId)
  if not ret then
    return
  end
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
  self:NotifyGameModeDungeonEvent("SoloTreasureTicketSelect", uid, TicketId)
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_SoloTreasureRandomTicket(uid)
  local Mechanism = self:GetMechanism(uid)
  if nil == Mechanism or Mechanism.IsUnlock == false or Mechanism.IsUsed == true then
    return
  end
  if nil == Mechanism.TicketInfo then
    return
  end
  local ret = self:SoloTreasureInfo_RandomTicket(Mechanism)
  if not ret then
    return
  end
  self:NotifyGameModeDungeonEvent("OnSoloTreasureSyncMechanism", Mechanism)
  self:NotifyGameModeDungeonEvent("SoloTreasureRandomTicket", uid, Mechanism.TicketInfo.TicketList)
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_UnlockMechanism(uid)
  local Mechanism = self:GetMechanism(uid)
  if nil == Mechanism or Mechanism.IsUnlock then
    return
  end
  local ret = self:UnlockMechanism(Mechanism)
  if not ret then
    return
  end
  self:NotifyGameModeDungeonEvent("UnlockMechanism", uid)
end

function DungeonSoloTreasure:OnNotifyServerDungeonEvent_RewardRoomOpen(uid)
  local Mechanism = self:GetMechanism(uid)
  if nil == Mechanism or Mechanism.IsUnlock == false or Mechanism.IsUsed == true then
    return ErrorCode.RET_FAIL
  end
  local ret = self:SoloTreasureInfo_RewardRoomOpen(Mechanism)
  if not ret then
    return ErrorCode.RET_FAIL
  end
  self:NotifyGameModeDungeonEvent("RewardRoomOpen", uid)
  return ErrorCode.RET_SUCCESS
end

return DungeonSoloTreasure
