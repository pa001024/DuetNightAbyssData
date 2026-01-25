require("UnLua")
local BP_SabotageComponent_C = Class({
  "BluePrints.Common.TimerMgr"
})

function BP_SabotageComponent_C:InitSabotageComponent()
  self.GameMode = self:GetOwner()
  self.SabotageMonsterGuide = {}
  self.DeathSabotageMonsterGuide = {}
  self.GuideOrder = {}
  self.RewardLevel = 0
  if not DataMgr.Sabotage[self.GameMode.DungeonId] then
    GameState(self):ShowDungeonError("SabotageComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  if not self.GameMode.TacMapManager then
    GameState(self):ShowDungeonError("SabotageComponent 初始化失败！没有配置TacMapManager! DungeonIdId: ", self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.SabotagePoints = self.GameMode.TacMapManager:GenerateSabotagePoints()
end

function BP_SabotageComponent_C:InitSabotageBaseInfo()
  self.GameMode.EMGameState:StartGameTime()
  local SabotageData = DataMgr.Sabotage[self.GameMode.DungeonId]
  if not SabotageData then
    GameState(self):ShowDungeonError("SabotageComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self:InitSabotageCreators(SabotageData)
  self:InitEmergencyMonster(SabotageData)
  self.IsSabotageTargetActive = false
end

function BP_SabotageComponent_C:InitSabotageCreators(SabotageData)
  local NeedResetLocIds = {}
  local SabotageMon = SabotageData.SabotageMon or {}
  for _, sometable in pairs(SabotageMon) do
    NeedResetLocIds[sometable.SabotageStaticId] = true
  end
  local SabotageArray = TArray(0)
  for _, Data in pairs(self.SabotagePoints) do
    local SabotageCreator = self.GameMode.EMGameState.StaticCreatorMap:Find(Data.Id)
    if SabotageCreator then
      local IsResetLoc = NeedResetLocIds[Data.Id]
      DebugPrint("SabotageComponent 准备激活 静态点Id:", SabotageCreator.UnitId, " tacmap传来的位置", Data.Loc, "是否需要移动位置: ", IsResetLoc)
      if IsResetLoc then
        SabotageCreator:K2_SetActorLocation(Data.Loc, false, nil, false)
      end
      SabotageArray:Add(SabotageCreator.StaticCreatorId)
    else
      GameState(self):ShowDungeonError("SabotageComponent:找不到对应的静态点! Id: " .. Data.Id, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.FindObject)
    end
  end
  self.GameMode:TriggerActiveStaticCreator(SabotageArray, "SabotageMonsterGuide")
end

function BP_SabotageComponent_C:InitEmergencyMonster(SabotageData)
  local TreasureMonsterDealy = math.random(SabotageData.TreasureMonsterSpawnDelayMin, SabotageData.TreasureMonsterSpawnDelayMax)
  self:AddTimer(TreasureMonsterDealy, function()
    DebugPrint("SabotageComponent 刷EmergencyMonster")
    self:TryCreateEmergencyMonster("Treasure")
    if self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
      self.GameMode:TriggerSpawnPet()
    end
  end)
end

function BP_SabotageComponent_C:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType)
  if "SabotageMonsterGuide" == EventName then
    DebugPrint("SabotageComponent SabotageMonsterGuide Eid", Eid, "UnitId", UnitId)
    self.SabotageMonsterGuide[Eid] = UnitId
  end
end

function BP_SabotageComponent_C:ShowSabotageMonsterGuide(DeathEid)
  DebugPrint("SabotageComponent ShowSabotageMonsterGuide", DeathEid)
  self.DeathSabotageMonsterGuide[DeathEid] = DeathEid
  for Eid, UnitId in pairs(self.SabotageMonsterGuide) do
    if not self.DeathSabotageMonsterGuide[Eid] then
      local Monster = Battle(self):GetEntity(Eid)
      if IsValid(Monster) and not Monster:IsDead() and Monster.StopAddGuideTimer then
        Monster:StopAddGuideTimer()
      end
      DebugPrint("破坏玩法添加了精英怪指引点，怪物Eid: " .. Eid)
      self:OnMonsterGuideAdded(Eid)
      self.GameMode.EMGameState:AddGuideEid(Eid)
    end
  end
end

function BP_SabotageComponent_C:OnMonsterGuideAdded(Eid)
  if self.SabotageMonsterGuide[Eid] == nil then
    return
  end
  if self:IsGuideOrderContains(Eid) then
    return
  end
  DebugPrint("SabotageComponent: OnMonsterGuideAdded Eid", Eid)
  table.insert(self.GuideOrder, Eid)
end

function BP_SabotageComponent_C:IsGuideOrderContains(value)
  for _, v in pairs(self.GuideOrder) do
    if v == value then
      return true
    end
  end
  return false
end

function BP_SabotageComponent_C:ClearSabotageMonsterGuide()
  for i, j in pairs(self.SabotageMonsterGuide) do
    DebugPrint("破坏玩法删除了精英怪指引点，怪物Eid: " .. i)
    self.GameMode.EMGameState:RemoveGuideEid(i)
    self.GameMode.EMGameState:AddBanGuideEid(i)
    local Monster = Battle(self):GetEntity(i)
    if IsValid(Monster) and Monster.StopAddGuideTimer then
      Monster:StopAddGuideTimer()
    end
  end
end

function BP_SabotageComponent_C:SabotageTargetActive()
  self.GameMode:TriggerGameModeEvent("OnSabotageTargetActive")
  self:ClearSabotageMonsterGuide()
  self.IsSabotageTargetActive = true
  local SabotageCountDownTime = DataMgr.Sabotage[self.GameMode.DungeonId].SabotageCountDownTime or -1
  if -1 == SabotageCountDownTime then
    self.NoCountDown = true
    return
  end
  self.GameMode.EMGameState:SetSabotageCountDownTime(SabotageCountDownTime)
  self.CountDownEnable = true
  self:AddTimer(1, self.CountDown, true, 0, "SabotageCountDownTimer")
end

function BP_SabotageComponent_C:CountDown()
  self:AddCountDownTime(-1)
  if self:GetCountDownTime() <= 0 then
    self.CountDownEnable = false
    self:RemoveTimer("SabotageCountDownTimer")
    self.GameMode:TriggerDungeonFailed()
  end
end

function BP_SabotageComponent_C:TriggerSabotageExitMechanismOverlap()
  if not self.NoCountDown then
    if not self.CountDownEnable then
      return
    end
    self.CountDownEnable = false
    self:RemoveTimer("SabotageCountDownTimer")
  end
  if self.NoCountDown then
    self.RewardLevel = 1
  else
    local DungeonDataReward = DataMgr.Dungeon[self.GameMode.DungeonId].DungeonReward
    local SabotageDataReward = DataMgr.Sabotage[self.GameMode.DungeonId].SabotageRewardRemainTimes
    if not (DungeonDataReward and SabotageDataReward) or #DungeonDataReward < #SabotageDataReward then
      GameState(self):ShowDungeonError("SabotageComponent 破坏玩法奖励发放数据不存在  Or 剩余时间数组长度大于奖励轮次数组长度", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
      return
    end
    for k, v in pairs(SabotageDataReward) do
      if v <= self:GetCountDownTime() then
        self.RewardLevel = self.RewardLevel + 1
      end
    end
    if self.RewardLevel == #SabotageDataReward then
      self.GameMode:TriggerDungeonAchieve("TriggerHighestReward", -1)
    end
  end
end

function BP_SabotageComponent_C:AddCountDownTime(Value)
  self.GameMode.EMGameState:SetSabotageCountDownTime(math.max(0, self.GameMode.EMGameState.SabotageCountDownTime + Value))
  if IsStandAlone(self) then
    self.GameMode.EMGameState:OnRep_SabotageCountDownTime()
  end
end

function BP_SabotageComponent_C:GetCountDownTime()
  return self.GameMode.EMGameState.SabotageCountDownTime
end

function BP_SabotageComponent_C:TryCreateEmergencyMonster(MonsterType)
  if self.GameMode:GetNeedCreateEmergencyMonster(MonsterType) == false or self.IsSabotageTargetActive then
    return
  end
  self.GameMode:TryCreateEmergencyMonster(MonsterType)
end

function BP_SabotageComponent_C:InitTreasureMonsterEecapeLoc(TreasureMonster)
  local mechanimArray = self.GameMode.EMGameState.MechanismMap:FindRef("SabotageTarget")
  local monLoc = TreasureMonster.CurrentLocation
  if mechanimArray then
    local targetLoc, targetDis
    for _, mechanism in pairs(mechanimArray.Array:ToTable()) do
      local dis = UKismetMathLibrary.Vector_Distance(monLoc, mechanism:K2_GetActorLocation())
      if not targetDis or targetDis > dis then
        targetLoc = mechanism:K2_GetActorLocation()
        targetDis = dis
      end
    end
    for Eid, UnitId in pairs(self.SabotageMonsterGuide) do
      if not self.DeathSabotageMonsterGuide[Eid] then
        local Monster = Battle(self):GetEntity(Eid)
        if IsValid(Monster) and not Monster:IsDead() then
          local tempLoc = Monster:K2_GetActorLocation()
          local dis = UKismetMathLibrary.Vector_Distance(monLoc, tempLoc)
          if not targetDis or targetDis > dis then
            targetLoc = tempLoc
            targetDis = dis
          end
        end
      end
    end
    if targetLoc then
      TreasureMonster:SetTreasureMonsterTarget(targetLoc)
    end
  end
end

return BP_SabotageComponent_C
