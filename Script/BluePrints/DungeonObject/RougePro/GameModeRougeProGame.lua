local GameModeRougeProGame = DungeonClass.Class()
GameModeRougeProGame.__Component__ = {}

function GameModeRougeProGame:BeginPlay()
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnStartProfessionSelect()
  print("GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnStartProfessionSelect")
end

function GameModeRougeProGame:OnNotifyGameModeDungeonEvent_OnStartContractSelect()
end

function GameModeRougeProGame:OnRep_Contract()
  print("OnRep_Contract")
end

DungeonClass.AssembleComponents(GameModeRougeProGame)
return GameModeRougeProGame
