local M = Class({
  "BluePrints.GameMode.DungeonComponents.BP_DungeonVoteComponent_C",
  "BluePrints.Common.TimerMgr"
})

function M:InitIronSurvivalComponent()
  self.GameMode = self:GetOwner()
  self:InitVoteComponent()
  self.IsPoisonMonsterCache = {}
  self.IsPoisonMonsterCache[0] = false
end

function M:InitIronSurvivalBaseInfo()
  self:AddTimer(self.ExtraFixVitaminValueTickTime, self.CheckPoisonMonster, true)
end

function M:OnSyncGameModeLevel(NewGameModeLevel)
  DebugPrint("IronSurvivalComponent:OnSyncGameModeLevel", NewGameModeLevel)
  self.GameMode:SetGameModeLevel(NewGameModeLevel)
end

function M:OnMiniGameSuccess()
  self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
end

function M:StartRound()
  local function cb()
    local CurLevel = self.GameMode.EMGameState.GameModeLevel
    
    DebugPrint("IronSurvivalComponent:StartRound cb", CurLevel)
    self.GameMode:TriggerGameModeEvent("Event_OnRoundStart", CurLevel)
  end
  
  DebugPrint("IronSurvivalComponent:StartRound")
  self.GameMode:NotifyServerDungeonEventWithCallback(cb, "ServerStartRound")
end

function M:GameModeRoundEnd()
  DebugPrint("IronSurvivalComponent:GameModeRoundEnd")
  self.GameMode:TriggerGameModeEvent("Event_OnRoundEnd")
end

function M:AddSurvivalValueServerDungeon(Value)
end

function M:CheckPoisonMonster()
  if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
    return
  end
  if self.GameMode.EMGameState.SurvivalMiniValue <= 0 then
    return
  end
  local PoisonMonsterNum = self:CountPoisonMonster()
  DebugPrint("IronSurvivalComponent:CheckPoisonMonster", PoisonMonsterNum)
  if PoisonMonsterNum > 0 then
    local Value = PoisonMonsterNum * self.ExtraFixVitaminValue
    self.GameMode:NotifyServerDungeonEvent("AddSurvivalValueGameMode", Value)
  end
end

function M:CountPoisonMonster()
  local Res = 0
  for _, Monster in pairs(self.GameMode.EMGameState.MonsterMap) do
    if self:IsPoisonMonster(Monster) then
      Res = Res + 1
    end
  end
  return Res
end

function M:IsPoisonMonster(Monster)
  if not IsValid(Monster) then
    return false
  end
  local UnitId = Monster.UnitId
  if self.IsPoisonMonsterCache[UnitId] ~= nil then
    return self.IsPoisonMonsterCache[UnitId]
  end
  local IsPoison = Monster:HasAnyTags_Table(Monster, Const.ExtraFixVitamin, false)
  self.IsPoisonMonsterCache[UnitId] = IsPoison
  return IsPoison
end

function M:OnServerUpdateSurvivalMiniValue(CurSurvivalMiniValue)
  print("IronSurvivalComponent:OnServerUpdateSurvivalMiniValue", CurSurvivalMiniValue)
  self.GameMode.EMGameState:SetSurvivalMiniValue(CurSurvivalMiniValue)
end

return M
