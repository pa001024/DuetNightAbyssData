local CommonConst = require("CommonConst")
local Component = {}

function Component:PrepareToBattleSingleDungeon(DungeonId, AvatarBattleInfo, CustomPreInitInfo)
  self.logger.debug("PrepareToBattle", DungeonId)
  self.AvatarBattleInfo = AvatarBattleInfo
  GWorld.GameInstance:PreInitGameMode(CustomPreInitInfo)
  WorldTravelSubsystem():ChangeDungeonByDungeonId(DungeonId, CommonConst.DungeonNetMode.Standalone)
end

function Component:PrepareToBattleMultiDungeon(DungeonId, AvatarBattleInfo)
  self.AvatarBattleInfo = AvatarBattleInfo
  WorldTravelSubsystem():ChangeDungeonByDungeonId(DungeonId, CommonConst.DungeonNetMode.ListenServer)
end

function Component:PrepareToBattleRegion(RegionId, StartIndex, EnterRegionType, DungeonNetMode, ForLogin, AvatarBattleInfo)
  print(_G.LogTag, "ZJT_ PrepareToBattleRegion ", self.CurrentRegionId, RegionId, EnterRegionType, self.StartIndex)
  self.AvatarBattleInfo = AvatarBattleInfo
  local MainReginonId = DataMgr.SubRegion[RegionId].RegionId
  local bDisconnectRecoverCheck = self:DisconnectRecoverCheck()
  DebugPrint("ZJT_ PrepareToBattleRegion ", bDisconnectRecoverCheck, type(MainReginonId), MainReginonId, DataMgr.Region[MainReginonId])
  if not bDisconnectRecoverCheck then
    return
  end
  if not DataMgr.Region[MainReginonId] then
    return
  end
  self.CurrentRegionId = RegionId
  self.StartIndex = tonumber(StartIndex)
  self.EnterRegionType = EnterRegionType
  self:ClearCacheByPrepareRegion()
  local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
  if SubSystem then
    SubSystem:SetRegionInitState(ERegionInitState.RegionDataReceived)
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if GameMode and GameMode.PrepareLevelDelivery then
    GameMode:PrepareLevelDelivery(RegionId, StartIndex)
  end
  WorldTravelSubsystem():ChangeRegionByRegionId(MainReginonId, ForLogin)
end

function Component:ClearCacheByPrepareRegion()
  self.IsInRegion = false
  self.IsEnterLevelReady = false
  self.IsOpenPlayerPositionSync = false
  self:RemovePlayerInfoHandle()
  local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
  SubSystem:InitCacheByPrepareRegion()
end

function Component:PrepareToBattleRougeLike(DungeonId, AvatarBattleInfo, GameInfo, PlayerSlice, RougeLikeManagerInfo)
  print(_G.LogTag, "PrepareToBattleRougeLike", DungeonId)
  self.RougeLikeManagerInfo = RougeLikeManagerInfo
  self:RecoverSingleDungeon(AvatarBattleInfo, GameInfo, PlayerSlice, DungeonId)
  PrintTable(self.RougeLikeManagerInfo, 5)
  WorldTravelSubsystem():ChangeDungeonByDungeonId(DungeonId, CommonConst.DungeonNetMode.Standalone)
end

function Component:ExitBattle(IsWin, bInterrupt)
  self:RequestLeaveBattle(IsWin, bInterrupt)
end

function Component:BattleFinish(IsWin, bInterrupt)
  if GWorld:IsListenServer() then
    self:LSBattleFinish(IsWin, bInterrupt)
    return
  end
  local GameInstance = GWorld.GameInstance
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
  local PlayerTime = Player.PlayerState:GetPlayerEndTime()
  local GameMode = UE4.UGameplayStatics.GetGameMode(GameInstance)
  local GameTime = GameMode.EMGameState:GetGameEndTime()
  local TotalDamage = math.floor(Player:GetFinalDamage())
  local CombatStatistics = PlayerController:GetCombatStatistics()
  local MaxEid = GameMode:GetBattleEid()
  local CustomInfo = GameMode:TriggerDungeonComponentFun("CustomFinishInfo", nil, IsWin) or {}
  GameMode:FlushRewards()
  self:CallServerMethod("FinishDungeon", IsWin, TotalDamage, PlayerTime, GameTime, MaxEid, CombatStatistics, CustomInfo)
end

function Component:RequestLeaveBattle(IsWin, bInterrupt)
  self.logger.debug(string.format("Client RequestLeaveBattle"))
  
  local function callback(ret)
    if not ErrorCode:Check(ret) then
      return
    end
    if GWorld:IsStandAlone() or GWorld:IsListenServer() then
      local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
      if self:IsInRougeLike() then
        print(_G.LogTag, "Avatar RequestLeaveBattle RougeLike", IsWin)
        GameMode:FinishRougeLike(IsWin)
        return
      end
      if GameMode.EMGameState.GameModeType == "Training" then
        GameMode:TriggerDungeonWin()
        return
      end
      print(_G.LogTag, "Avatar RequestLeaveBattle NormalDungeon", IsWin)
      if IsWin then
        GameMode:TriggerDungeonWin()
      else
        GameMode:TriggerDungeonFailed()
      end
    end
  end
  
  self:CallServer("RequestLeaveBattle", callback)
end

function Component:OnRequestToMatch(Ret)
  print(_G.LogTag, "OnRequestToMatch", Ret)
  EventManager:FireEvent(EventID.OnRequestToMatch, Ret)
end

function Component:OnMatchFailed(Reason)
  self.logger.info("Match Failed", Reason)
  if not self:IsInBigWorld() then
    self:ExitDungeon()
    TeamController:RecvDsServerDie()
  end
  EventManager:FireEvent(EventID.TeamMatchCancel, Reason)
end

return Component
