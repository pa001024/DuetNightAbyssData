local RougeProGlobalConst = require("BluePrints.DungeonObject.RougePro.RougeProGlobalConst")
local GameModeRougeProGame = DungeonClass.Class()
GameModeRougeProGame.__Component__ = {
  "BluePrints.DungeonObject.RougePro.GameModeRougeProComponents.GameModeRougeProEventManager",
  "BluePrints.DungeonObject.RougePro.GameModeRougeProComponents.GameModeRougeProChestManager"
}

function GameModeRougeProGame:BeginPlay()
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnStartProfessionSelect()
  print("GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnStartProfessionSelect")
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnStartContractSelect()
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnCreateRougeProEventRewardDropBox(MechanismUid)
  local RewardDropBox = self:GetReplicatedActorByNetGuid(self.RewardDropBoxList[MechanismUid]._NetGuid)
  print(string.format("OnCreateRougeProEventRewardDropBox RewardDropBoxUid= " .. RewardDropBox.UniqueId .. ", OwnerAvatarEids=" .. CommonUtils.TableToStr(RewardDropBox.OwnerAvatarEids)))
  self:OnRougeProChestCreated(RewardDropBox)
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnRougeProEventStateChange(EventId, State)
  print(string.format("GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnRougeProEventCreate EventId(%s) State(%s) ", tostring(EventId), tostring(State)))
  if State == RougeProGlobalConst.RougeProEventState.Init then
    self:OnRougeProEventCreate(EventId)
  end
  if State == RougeProGlobalConst.RougeProEventState.Active then
  end
  if State == RougeProGlobalConst.RougeProEventState.Suspend then
  end
  if State == RougeProGlobalConst.RougeProEventState.Complete then
    self:OnRougeProEventComplete(EventId)
  end
  if State == RougeProGlobalConst.RougeProEventState.Destroy then
    self:OnRougeProEventDestroy(EventId)
  end
end

function GameModeRougeProGame:OnRep_Contract()
  print("GameModeRougeProGame:OnRep_Contract")
end

function GameModeRougeProGame:OnRep_RoomList()
  self.CProperty.RoomList = self.RoomList
end

function GameModeRougeProGame:OnRep_Round()
  self.CProperty.Round = self.Round
  if GWorld.RougelikeLevelLoader then
    GWorld.RougelikeLevelLoader:TryRougeLikeEnterRoom(self.Round)
  end
  if self.GameMode then
    if self.GameMode.TacMapManager then
      self.GameMode.TacMapManager:Destroy()
    end
    self.GameMode:InitTacMapManager()
    if GWorld:IsDedicatedServer(self.GameMode) then
      self.GameMode:NotifyServerDungeonEvent("ChangeRound")
    end
  end
end

function GameModeRougeProGame:OnRep_EventList()
  print("GameModeRougeProGame:OnRep_EventList self=" .. tostring(self))
  self.CProperty.EventList = UE4.TArray(UE4.FRougeProEvent)
  for _, ReplicatedActor in pairs(self.EventList) do
    local RougeProEvent = self:GetReplicatedActorByNetGuid(ReplicatedActor._NetGuid)
    local UERougeProEvent = UE4.FRougeProEvent()
    UERougeProEvent.EventId = RougeProEvent.EventId
    UERougeProEvent.EventState = RougeProEvent.EventState
    UERougeProEvent.StartTime = RougeProEvent.StartTime
    self.CProperty.EventList:Add(UERougeProEvent)
    print("GameModeRougeProGame:OnRep_EventList Add EventId = " .. RougeProEvent.EventId)
  end
end

function GameModeRougeProGame:BuildRougeProPlayerBrief(AvatarEid, Player)
  local FRougeProPlayerBrief = UE4.FRougeProPlayerBrief()
  FRougeProPlayerBrief.AvatarEidStr = CommonUtils.ObjId2Str(AvatarEid) or ""
  FRougeProPlayerBrief.RougeProProfession = Player.RougeProProfession or -1
  FRougeProPlayerBrief.Token = math.floor(Player.Token or 0)
  FRougeProPlayerBrief.PlayerDeadNum = Player.PlayerDeadNum or 0
  local TreasureIdList = UE4.TArray(0)
  for i = 1, #(Player.RougeProTreasureList or {}) do
    local TreasureRef = Player.RougeProTreasureList[i]
    local Treasure = self:GetReplicatedActorByNetGuid(TreasureRef._NetGuid) or TreasureRef
    local TreasureId = Treasure and Treasure.TreasureId
    if TreasureId then
      TreasureIdList:Add(TreasureId)
    end
  end
  FRougeProPlayerBrief.RougeProTreasureList = TreasureIdList
  return FRougeProPlayerBrief
end

function GameModeRougeProGame:BuildRougeProGetTreasureNotify(AvatarEid, Player)
  local Notify = UE4.FRougeProGetTreasureNotify()
  Notify.AvatarEidStr = CommonUtils.ObjId2Str(AvatarEid) or ""
  local TreasureList = Player.RougeProTreasureList or {}
  local LastTreasureRef = TreasureList[#TreasureList]
  if not LastTreasureRef then
    return Notify
  end
  local Treasure = self:GetReplicatedActorByNetGuid(LastTreasureRef._NetGuid) or LastTreasureRef
  Notify.TreasureId = Treasure and Treasure.TreasureId or 0
  return Notify
end

function GameModeRougeProGame:SyncRougeProPlayerBrief(DirtyPlayer)
  if not self.CProperty or not self.CProperty.SetPlayerBriefList then
    print("GameModeRougeProGame:SyncRougeProPlayerBrief but not self.CProperty or not self.CProperty.SetPlayerBriefList ")
    return
  end
  local PlayerBriefList = UE4.TArray(UE4.FRougeProPlayerBrief)
  for AvatarEidKey, ReplicatedActor in pairs(self.Players or {}) do
    local Player = self:GetReplicatedActorByNetGuid(ReplicatedActor._NetGuid)
    if Player then
      local AvatarEid = Player.GetAvatarEid and Player:GetAvatarEid() or AvatarEidKey
      PlayerBriefList:Add(self:BuildRougeProPlayerBrief(AvatarEid, Player))
    end
  end
  self.CProperty:SetPlayerBriefList(PlayerBriefList)
  print("GameModeRougeProGame:SyncRougeProPlayerBrief size= " .. self.CProperty.PlayerBriefList:Num())
end

function GameModeRougeProGame:SyncRougeProGetTreasureNotify(DirtyPlayer)
  if not self.CProperty or not self.CProperty.SetGetTreasureNotify then
    print("GameModeRougeProGame:SyncRougeProGetTreasureNotify but not self.CProperty or not self.CProperty.SetGetTreasureNotify")
    return
  end
  print("JLY GameModeRougeProGame:SyncRougeProGetTreasureNotify DirtyPlayer = " .. tostring(DirtyPlayer))
  local AvatarEid = DirtyPlayer:GetAvatarEid()
  self.CProperty:SetGetTreasureNotify(self:BuildRougeProGetTreasureNotify(AvatarEid, DirtyPlayer))
end

function GameModeRougeProGame:OnRep_Players()
  print("GameModeRougeProGame:OnRep_Players self.Players = " .. CommonUtils.TableToString3(self.Players))
  self:SyncRougeProPlayerBrief()
end

function GameModeRougeProGame:OnRep_RewardDropBoxList()
  print("GameModeRougeProGame:OnRep_RewardDropBoxList self.RewardDropBoxList = " .. CommonUtils.TableToString3(self.RewardDropBoxList))
end

function GameModeRougeProGame:OnRep_TotalDeadNum()
  print("GameModeRougeProGame:OnRep_TotalDeadNum self.TotalDeadNum = " .. CommonUtils.TableToString3(self.TotalDeadNum))
end

function GameModeRougeProGame:OnRep_TotalToken()
  print("GameModeRougeProGame:OnRep_TotalToken self.TotalToken = " .. tostring(self.TotalToken))
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_AddGameModeLevel(AddLevel)
  print("GameModeRougeProGame:OnNotifyGameModeDungeonEvent_AddGameModeLevel AddLevel " .. tostring(AddLevel))
  self.GameMode:SetGameModeLevel(self.GameMode.EMGameState.GameModeLevel + AddLevel)
end

function GameModeRougeProGame:GetPrivateEnableAndLevelName()
  return true, tostring(self.GameMode:GetLevelLoader().CurrentRoomId)
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_RougeProAddBuff(BuffId, AvatarEid)
  print(string.format("OnNotifyGameModeDungeonEvent_RougeProAddBuff BuffId=%s AvatarEid=%s", tostring(BuffId), tostring(AvatarEid)))
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_RougeProRemoveBuff(BuffId, AvatarEid)
  print(string.format("OnNotifyGameModeDungeonEvent_RougeProRemoveBuff BuffId=%s AvatarEid=%s", tostring(BuffId), tostring(AvatarEid)))
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_RougeProAddMod(ModId, AvatarEid)
  print(string.format("OnNotifyGameModeDungeonEvent_RougeProAddMod ModId=%s AvatarEid=%s", tostring(ModId), tostring(AvatarEid)))
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_RougeProRemoveMod(ModId, AvatarEid)
  print(string.format("OnNotifyGameModeDungeonEvent_RougeProRemoveMod ModId=%s AvatarEid=%s", tostring(ModId), tostring(AvatarEid)))
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnRoundBossCreated()
  local RoomId = self.RoomList[self.Round]
  local RoomInfo = DataMgr.RougePro_Room[RoomId]
  if not RoomInfo then
    return
  end
  local BossDeliveryPointId = RoomInfo.BossDeliveryPointId
  local BossDeliveryDis = RoomInfo.BossDeliveryDis
  local PrivateEnable, CurLevelName = self:GetPrivateEnableAndLevelName()
  self.GameMode:ActiveDungeonDeliveryPoint(BossDeliveryPointId, PrivateEnable, CurLevelName, BossDeliveryDis)
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnRoundBossDead()
  self.GameMode:DeactiveDungeonDeliveryPoint()
end

DungeonClass.AssembleComponents(GameModeRougeProGame)
return GameModeRougeProGame
