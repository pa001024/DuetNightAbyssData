local RougeProGlobalConst = require("BluePrints.DungeonObject.RougePro.RougeProGlobalConst")
local MaxRound = 3
local RougeProSceneGamePlay = DungeonClass.Class()
RougeProSceneGamePlay.__Component__ = {
  "BluePrints.DungeonObject.RougePro.RougeProDungeonGamePlayContext",
  "BluePrints.DungeonObject.RougePro.MonsterSpecialSpawn.RougeProMonsterSpecialSpawnManager",
  "BluePrints.DungeonObject.RougePro.RougeProEventManager.RougeProEventManager",
  "BluePrints.DungeonObject.RougePro.RougeProCollectManager.RougeProCollectManager",
  "BluePrints.DungeonObject.RougePro.RougeProRewardDropBoxManager.RougeProRewardDropBoxManager",
  "BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjManager"
}

function RougeProSceneGamePlay:BeginPlay()
  self:InitReplicatedProperties(self, "RoomList", {}, "OnRep_RoomList")
  self:InitReplicatedProperties(self, "Round", 0, "OnRep_Round")
  self:InitReplicatedProperties(self, "TotalDeadNum", 0, "OnRep_TotalDeadNum")
  self:InitReplicatedProperties(self, "TotalScore", 0, "OnRep_TotalScore")
  self.RoomList = self:GenerateRandomRoomList(MaxRound)
  self.Round = 1
end

function RougeProSceneGamePlay:OnNotifyServerDungeonEvent_OnInit()
  print("RougeProSceneGamePlay:OnNotifyServerDungeonEvent_OnInit")
  self:InitCommonInfo()
  self:ChangeRound(1)
end

function RougeProSceneGamePlay:GetRougeProRoomId()
  if self.Round > 0 and self.Round <= #self.RoomList then
    return self.RoomList[self.Round]
  end
  return -1
end

function RougeProSceneGamePlay:ChangeRound(NewRound)
  print(string.format("RougeProSceneGamePlay:ChangeRound(%d)", NewRound))
  self:OnRoundFinish()
  self.Round = NewRound
  if 1 == self.Round then
    self:RealChangeRound()
  else
    self.__WaitGameModeNotifyChangeRound = true
  end
end

function RougeProSceneGamePlay:OnNotifyServerDungeonEvent_ChangeRound()
  if self.__WaitGameModeNotifyChangeRound then
    self.__WaitGameModeNotifyChangeRound = false
    self:RealChangeRound()
  end
end

function RougeProSceneGamePlay:RealChangeRound()
  self:InitRoundInfo()
  self:OnChangeRound()
  self:DispatchRougeProEffectEvent("OnChangeRound")
end

function RougeProSceneGamePlay:OnRoundEnd(RoundEndReason)
  local NewRound = self.Round + 1
  local IsLastRound = self.CurRoundInfo.IsLastRound
  print("RougeProSceneGamePlay:OnRoundEnd self.Round", self.Round, "IsLastRound", IsLastRound, "RoundEndReason", RoundEndReason)
  if "MainTimerEnd" == RoundEndReason then
    if IsLastRound then
      self:FinishGame(false, "MainTimerEnd")
    else
      self:ChangeRound(NewRound)
    end
  else
    if "BossDead" == RoundEndReason then
      if IsLastRound then
        self:StartRewardStage()
      else
        self:AddTimer(self.CommonInfo.AutoNextRoundTime, function()
          self:ChangeRound(NewRound)
        end)
      end
    else
    end
  end
end

function RougeProSceneGamePlay:FinishGame(IsWin, GameEndReason)
  self:OnRoundFinish()
  print("RougeProSceneGamePlay:FinishGame")
  local TotalScore = self.TotalScore
  local TotalPlayerDeadNum = 0
  for AvatarEid, Player in self:PlayerIterator() do
    TotalPlayerDeadNum = TotalPlayerDeadNum + Player:GetPlayerDeadNum()
  end
  local DeadCostScore = 0
  local DeadNumLimit = DataMgr.RougeProSeason[self.SeasonId] and DataMgr.RougeProSeason[self.SeasonId].DeadDeductScoreDeadTimes
  local DeadDeductScore = DataMgr.RougeProSeason[self.SeasonId] and DataMgr.RougeProSeason[self.SeasonId].DeadDeductScore
  if DeadDeductScore and DeadNumLimit then
    DeadCostScore = TotalScore * math.min(TotalPlayerDeadNum, DeadNumLimit) * DeadDeductScore
  end
  print(string.format("RougrProGame Total Game Dead=%s, CostScore=%s", tostring(TotalPlayerDeadNum), tostring(DeadCostScore)))
  TotalScore = math.max(0, TotalScore - DeadCostScore)
  TotalScore = TotalScore + TotalScore * self:GetRougeProEffect("EndPointsExtraRate")
  print(string.format("RougrProGame Finish. TotalScore = %s", tostring(TotalScore)))
  self:TryDungeonFinish(IsWin, GameEndReason)
end

function RougeProSceneGamePlay:StartRewardStage()
  self:AddSyncTimer("RewardStage", self.CommonInfo.RewardStageTime, nil, function()
    self:OnRewardStageEnd()
  end)
  print("@ljl 奖励关刷怪 RuleId:", self.CommonInfo.RewardMonsterSpawnRule)
  self:TriggerRougeProMonsterSpecialSpawn(self.CommonInfo.RewardMonsterSpawnRule)
end

function RougeProSceneGamePlay:OnRewardStageEnd()
  print("@ljl 奖励关结束！！！")
  self:StopRougeProMonsterSpecialSpawn(self.CommonInfo.RewardMonsterSpawnRule)
  self:AddSyncTimer("RewardCollect", self.CommonInfo.RewardCollectTime, nil, function()
    self:FinishGame(true, "RewardStageEnd")
  end)
end

function RougeProSceneGamePlay:MechanismStateChange(EventInfo)
  print(string.format("RougeProSceneGamePlay:MechanismStateChange EventInfo=%s", CommonUtils.TableToString3(EventInfo)))
  local Mechanism = self:GetMechanism(EventInfo.UniqueId)
  if nil == Mechanism then
    return
  end
  local SceneObjAttr = self:GetMechanismSceneObjAttr(EventInfo.UniqueId)
  if nil == SceneObjAttr then
    return
  end
  if SceneObjAttr:GetRougeProCollectStaticCreatorId() then
    self:RougePro_Collect(EventInfo)
  elseif SceneObjAttr:GetEventId() then
    self:RougePro_EventMechanismStateChange(EventInfo)
  elseif SceneObjAttr:GetRewardDropBoxInfo() then
    self:RougePro_OpenRougeProRewardDropBox(EventInfo)
  end
  self:NotifyGameModeMechanismState(EventInfo)
end

function RougeProSceneGamePlay:DungeonMonsterDead(MonsterInfo)
  local Attr = self:GetMonsterSceneObjAttr(MonsterInfo.UniqueId)
  if nil == Attr or Attr:IsAlive() == false then
    return
  end
  Attr:SetAlive(false)
  self:RougePro_DungeonMonsterDead(MonsterInfo)
end

function RougeProSceneGamePlay:MechanismDead(Info)
  local MechanismUniqueId = Info.UniqueId
  local Attr = self:GetMechanismSceneObjAttr(MechanismUniqueId)
  if nil == Attr or Attr:IsAlive() == false then
    return
  end
  Attr:SetAlive(false)
  self:RougePro_MechanismDead(MechanismUniqueId)
end

function RougeProSceneGamePlay:OnNotifyServerDungeonEvent_PlayerDead(AvatarEid)
  print(string.format("OnNotifyServerDungeonEvent_PlayerDead AvatarEid = %s", tostring(AvatarEid)))
  local Player = self:GetPlayer(AvatarEid)
  if nil == Player then
    print("OnNotifyServerDungeonEvent_PlayerDead Error. Player == nil")
    return
  end
  self.TotalDeadNum = self.TotalDeadNum + 1
end

function RougeProSceneGamePlay:OnNotifyServerDungeonEvent_PlayerReborn(AvatarEid)
  print(string.format("OnNotifyServerDungeonEvent_PlayerReborn AvatarEid = %s", tostring(AvatarEid)))
  local Player = self:GetPlayer(AvatarEid)
  if nil == Player then
    print("OnNotifyServerDungeonEvent_PlayerReborn Error. Player == nil")
    return
  end
  local IsFree = false
  if Player.RebornFree >= 1 then
    Player.RebornFree = Player.RebornFree - 1
    IsFree = true
  elseif Player:DispatchRougeProEffectEvent("OnPlayerReborn") then
    IsFree = true
  end
  self:NotifyGameModeDungeonEvent("PlayerReborn", AvatarEid)
  if not IsFree then
    Player.PlayerDeadNum = Player.PlayerDeadNum + 1
  end
end

function RougeProSceneGamePlay:AddTotalScore(AddValue)
  self.TotalScore = self.TotalScore + AddValue
end

DungeonClass.AssembleComponents(RougeProSceneGamePlay)
return RougeProSceneGamePlay
