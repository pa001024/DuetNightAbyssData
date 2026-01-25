require("UnLua")
local BP_ExterminateBaseComponent_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent"
})

function BP_ExterminateBaseComponent_C:InitExterminateBaseComponent()
  self.GameMode = self:GetOwner()
  self.NowGuideEids = {}
  self.HasGuideUpdateRequest = {}
  self.Success = false
  self.ExterminateInfo = self:GetDataMgrInfo()
  if not self.ExterminateInfo then
    GameState(self):ShowDungeonError("ExterminateBaseComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.TargetNum = self.ExterminateInfo.TargetNum or 80
  self.NormalRange = self.ExterminateInfo.NormalRange
  self.NormalSpawnRule = self.ExterminateInfo.NormalSpawnRule
  self.NormalSpawnOnlyRelation = self.ExterminateInfo.NormalSpawnOnlyRelation
  self.IsNormalNumActive = self:ResetNormalNum()
  self.EliteRange = self.ExterminateInfo.EliteRange
  self.EliteSpawnRule = self.ExterminateInfo.EliteSpawnRule
  self.EliteSpawnOnlyRelation = self.ExterminateInfo.EliteSpawnOnlyRelation
  self.IsEliteNumActive = self:ResetEliteNum()
  self.PetSpawnRange = self.ExterminateInfo.PetSpawnRange
  if self.PetSpawnRange then
    if 1 == #self.PetSpawnRange then
      self.PetSpawnNum = self.PetSpawnRange[1]
    else
      self.PetSpawnNum = math.random(self.PetSpawnRange[1], self.PetSpawnRange[2])
    end
  end
  self.GameMode.EMGameState:SetExterminateTotalNum(self.TargetNum)
end

function BP_ExterminateBaseComponent_C:GetDataMgrInfo()
  return
end

function BP_ExterminateBaseComponent_C:OnEliteNumClear()
end

function BP_ExterminateBaseComponent_C:ResetNormalNum()
  if self.NormalRange == nil then
    return false
  end
  if nil == self.NormalSpawnRule then
    return false
  end
  if nil == self.NormalSpawnOnlyRelation then
    return false
  end
  if 1 == #self.NormalRange then
    self.NormalNum = self.NormalRange[1]
  else
    self.NormalNum = math.random(self.NormalRange[1], self.NormalRange[2])
  end
  DebugPrint("ExterminateBaseComponent: New NormalNum:", self.NormalNum)
  return true
end

function BP_ExterminateBaseComponent_C:ResetEliteNum()
  if self.EliteRange == nil then
    return false
  end
  if nil == self.EliteSpawnRule then
    return false
  end
  if nil == self.EliteSpawnOnlyRelation then
    return false
  end
  if 1 == #self.EliteRange then
    self.EliteNum = self.EliteRange[1]
  else
    self.EliteNum = math.random(self.EliteRange[1], self.EliteRange[2])
  end
  DebugPrint("ExterminateBaseComponent: New EliteNum:", self.EliteNum)
  return true
end

function BP_ExterminateBaseComponent_C:InitGuideUpdateTimerLogic()
  self.GuideTimerHandle_DetectFault = "Handle_DetectFault"
  self.GuideTimerInterval_AutoUpdate = DataMgr.GlobalConstant.ExterminateGuideInterval.ConstantValue or 10
  self:AddGuideTimer_DetectFault()
  for i = 0, self.GameMode:GetPlayerNum() - 1 do
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, i)
    if IsValid(Player) then
      self.HasGuideUpdateRequest[Player.Eid] = false
      self:AddGuideTimer_AutoUpdate(Player.Eid)
    end
  end
end

function BP_ExterminateBaseComponent_C:OnPlayerEnter(PlayerEid)
  DebugPrint("zwk  中途有玩家加入 Eid： ", PlayerEid)
  self:AddGuideTimer_AutoUpdate(PlayerEid)
end

function BP_ExterminateBaseComponent_C:AddGuideTimer_AutoUpdate(PlayerEid)
  self:AddTimer(self.GuideTimerInterval_AutoUpdate, self.OnTimerEnd_AutoUpdate, true, 0, "Handle_AutoUpdate_" .. PlayerEid, nil, PlayerEid)
end

function BP_ExterminateBaseComponent_C:OnTimerEnd_AutoUpdate(PlayerEid)
  DebugPrint("ExterminateBaseComponent: 自动更新RemoveGuideEid 被Remove的指引点Eid: " .. tostring(self.NowGuideEids[PlayerEid]) .. "  Player Eid: " .. tostring(PlayerEid))
  self:TryUpdateGuidePoint(PlayerEid)
end

function BP_ExterminateBaseComponent_C:AddGuideTimer_LimitCalls(PlayerEid)
  self:AddTimer(1, self.OnTimerEnd_LimitCalls, false, 0, "Handle_LimitCalls_" .. PlayerEid, nil, PlayerEid)
end

function BP_ExterminateBaseComponent_C:OnTimerEnd_LimitCalls(PlayerEid)
  if self.HasGuideUpdateRequest[PlayerEid] then
    DebugPrint("ExterminateBaseComponent: 补充调用更新指引 PlayerEid: " .. PlayerEid)
    self:UpdateNearestMonsterGuide(PlayerEid)
    self.HasGuideUpdateRequest[PlayerEid] = false
  end
end

function BP_ExterminateBaseComponent_C:AddGuideTimer_DetectFault()
  self:AddTimer(2, self.OnTimerEnd_DetectFault, true, 0, self.GuideTimerHandle_DetectFault)
end

function BP_ExterminateBaseComponent_C:OnTimerEnd_DetectFault()
  for i = 0, self.GameMode:GetPlayerNum() - 1 do
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, i)
    if IsValid(Player) and self:CheckGuideLogicHasFault(Player) then
      DebugPrint("ExterminateBaseComponent: 检测到玩家Eid: " .. Player.Eid .. " 不存在指引点，准备添加")
      self:TryUpdateGuidePoint(Player.Eid)
    end
  end
end

function BP_ExterminateBaseComponent_C:CheckGuideLogicHasFault(Player)
  if not IsValid(Player) then
    return true
  end
  if self.NowGuideEids[Player.Eid] == nil then
    return true
  end
  if not self.GameMode.EMGameState:ContainsGuideEid(self.NowGuideEids[Player.Eid], Player.Eid) then
    return true
  end
  return false
end

function BP_ExterminateBaseComponent_C:TryUpdateGuidePoint(PlayerEid)
  if self:IsExistTimer("Handle_LimitCalls_" .. PlayerEid) then
    DebugPrint("ExterminateBaseComponent: 此次调用更新指引频率过高，已暂缓调用 PlayerEid: " .. PlayerEid)
    self.HasGuideUpdateRequest[PlayerEid] = true
  else
    self:UpdateNearestMonsterGuide(PlayerEid)
    self:AddGuideTimer_LimitCalls(PlayerEid)
  end
end

function BP_ExterminateBaseComponent_C:OnUnitDeadEvent(MonsterC)
  if self.Success then
    return
  end
  if not IsValid(MonsterC) then
    return
  end
  if not MonsterC:IsRealMonster() then
    return
  end
  self:AddExterminateKilledNum(1)
  self:CheckTargetNum()
  if MonsterC:IsEliteMonster() then
    return
  end
  for PlayerEid, GuideEid in pairs(self.NowGuideEids) do
    if MonsterC.Eid == GuideEid then
      DebugPrint("ExterminateBaseComponent: 怪物死亡RemoveGuideEid 被Remove的指引点Eid: " .. GuideEid .. "  Player Eid: " .. PlayerEid)
      self:TryUpdateGuidePoint(PlayerEid)
      self:AddGuideTimer_AutoUpdate(PlayerEid)
      DebugPrint("ExterminateBaseComponent: OnUnitDeadEvent", MonsterC:GetName(), MonsterC.Eid, PlayerEid)
    end
  end
end

function BP_ExterminateBaseComponent_C:AddExterminateKilledNum(Num)
  self.GameMode.EMGameState:SetExterminateKilledNum(self.GameMode.EMGameState.ExterminateKilledNum + Num)
  if IsStandAlone(self) then
    self.GameMode.EMGameState:OnRep_ExterminateKilledNum()
  end
end

function BP_ExterminateBaseComponent_C:UpdateNearestMonsterGuide(PlayerEid)
  local Player = Battle(self):GetEntity(PlayerEid)
  if not IsValid(Player) then
    return
  end
  local NowGuideEid = self.NowGuideEids[PlayerEid]
  local MonsterEid = self.GameMode:GetNearestMonsterEid(Player)
  if NowGuideEid == MonsterEid then
    DebugPrint("ExterminateBaseComponent: 指引点未发生变化，无需更新 指引点Eid: " .. MonsterEid .. "  Player Eid: " .. PlayerEid)
    return
  end
  if nil ~= NowGuideEid and NowGuideEid > 0 then
    DebugPrint("ExterminateBaseComponent: 更新指引点，移除旧指引 RemoveGuideEid 被Remove的指引点Eid: " .. NowGuideEid .. "  Player Eid: " .. PlayerEid)
    self.GameMode.EMGameState:RemoveGuideEid(NowGuideEid, PlayerEid)
  end
  if nil ~= MonsterEid and MonsterEid > 0 then
    self.NowGuideEids[PlayerEid] = MonsterEid
    self:AddDelayFrameFunc(function()
      self.GameMode.EMGameState:AddGuideEid(MonsterEid, PlayerEid)
      DebugPrint("ExterminateBaseComponent: 已成功添加指引点 指引点Eid: " .. MonsterEid .. "  Player Eid: " .. PlayerEid)
    end, 2)
  else
    DebugPrint("ExterminateBaseComponent: Error  歼灭玩法当前场上找不到怪物!")
  end
end

function BP_ExterminateBaseComponent_C:ClearGuideUpdateTimerLogic()
  for PlayerEid, GuideEid in ipairs(self.NowGuideEids) do
    DebugPrint("ExterminateBaseComponent: 结束清理RemoveGuideEid 被Remove的指引点Eid: " .. GuideEid .. "  Player Eid: " .. PlayerEid)
    self.GameMode.EMGameState:RemoveGuideEid(GuideEid, PlayerEid)
  end
  self.NowGuideEids = {}
  self:RemoveTimer(self.GuideTimerHandle_DetectFault)
  for i = 0, self.GameMode:GetPlayerNum() - 1 do
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, i)
    if IsValid(Player) then
      self.GameMode.EMGameState:ClearGuideEid(Player.Eid)
      self:RemoveTimer("Handle_AutoUpdate_" .. Player.Eid)
      self:RemoveTimer("Handle_LimitCalls_" .. Player.Eid)
    end
  end
end

function BP_ExterminateBaseComponent_C:CheckTargetNum()
  self.TargetNum = self.TargetNum - 1
  if self.TargetNum <= 0 then
    self.Success = true
    self.GameMode:TriggerGameModeEvent("OnAchieveTarget")
    if self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
      self.GameMode:TriggerSpawnPet()
    end
  end
  if self.IsNormalNumActive then
    self.NormalNum = self.NormalNum - 1
    if 0 == self.NormalNum then
      self.GameMode:TriggerCreateMonsterSpawn(self:RuleToTArray(self.NormalSpawnRule), self.NormalSpawnOnlyRelation)
      self:ResetNormalNum()
    end
  end
  if self.IsEliteNumActive then
    self.EliteNum = self.EliteNum - 1
    if 0 == self.EliteNum then
      self:OnEliteNumClear()
      self.GameMode:TriggerCreateMonsterSpawn(self:RuleToTArray(self.EliteSpawnRule), self.EliteSpawnOnlyRelation)
      self:ResetEliteNum()
    end
  end
  if self.PetSpawnNum then
    self.PetSpawnNum = self.PetSpawnNum - 1
    if 0 == self.PetSpawnNum then
      self.PetSpawnNum = nil
      if self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
        self.GameMode:TriggerSpawnPet()
      end
    end
  end
end

function BP_ExterminateBaseComponent_C:RuleToTArray(Rule)
  local ResTArray = TArray(0)
  if Rule then
    ResTArray:Add(Rule)
  end
  return ResTArray
end

return BP_ExterminateBaseComponent_C
