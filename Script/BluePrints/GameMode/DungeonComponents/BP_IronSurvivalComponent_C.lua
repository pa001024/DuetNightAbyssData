local M = Class({
  "BluePrints.GameMode.DungeonComponents.BP_DungeonVoteComponent_C"
})

function M:InitIronSurvivalComponent()
  self.GameMode = self:GetOwner()
  self:InitVoteComponent()
end

function M:InitIronSurvivalBaseInfo()
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
  DebugPrint("IronSurvivalComponent:AddSurvivalValueServerDungeon", Value)
  self.GameMode:NotifyServerDungeonEvent("AddSurvivalValueGameMode", Value)
end

function M:OnServerUpdateSurvivalMiniValue(CurSurvivalMiniValue)
  print("IronSurvivalComponent:OnServerUpdateSurvivalMiniValue", CurSurvivalMiniValue)
  self.GameMode.EMGameState:SetSurvivalMiniValue(CurSurvivalMiniValue)
end

return M
