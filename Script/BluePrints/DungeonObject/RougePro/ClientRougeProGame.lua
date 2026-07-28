local ClientRougeProGame = DungeonClass.Class()
ClientRougeProGame.__Component__ = {}

function ClientRougeProGame:BeginPlay()
  print("ClientRougeProGame:BeginPlay")
end

function ClientRougeProGame:OnClientAddTimer_RoundMain()
  print("ljl@ RoundMain Client Begin!!!! ")
  
  local function Cb()
    self.RemainTime = CommonUtils.GetClientTimerStructRemainTime("RoundMain")
    print("ljl@ RoundMain Client Tick RemainTime", self.RemainTime)
  end
  
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  GameState:AddTimer(0.1, Cb, true, 0, "RoundMain", true)
end

function ClientRougeProGame:OnClientRemoveTimer_RoundMain()
  print("ljl@ RoundMain Client End!!!! ")
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  GameState:RemoveTimer("RoundMain")
end

function ClientRougeProGame:OnClientAddTimer_RewardStage()
  print("ljl@ RewardStage Client Begin!!!! ")
  
  local function Cb()
    self.RemainTime = CommonUtils.GetClientTimerStructRemainTime("RewardStage")
    print("ljl@ RewardStage Client Tick RemainTime", self.RemainTime)
  end
  
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  GameState:AddTimer(0.1, Cb, true, 0, "RewardStage", true)
end

function ClientRougeProGame:OnClientRemoveTimer_RewardStage()
  print("ljl@ RewardStage Client End!!!! ")
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  GameState:RemoveTimer("RewardStage")
end

function ClientRougeProGame:GiveUpRewardBox(Uid)
  print("ClientRougeProGame GiveUpRewardBox Uid", Uid)
  self:NotifyGameModeDungeonEvent("ClientGiveUpRewardBox", Uid)
end

DungeonClass.AssembleComponents(ClientRougeProGame)
return ClientRougeProGame
