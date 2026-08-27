local SetMechanismFollowNpcNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")

function SetMechanismFollowNpcNode:Init()
  self.MechanismId = 0
  self.FollowComponentId = 0
  self.bSpawn = true
  self.bRevertOnFail = true
  self.bWasNpcSpawned = false
end

function SetMechanismFollowNpcNode:Execute()
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not IsValid(GameMode) then
    DebugPrint("SetMechanismFollowNpcNode: GameMode invalid")
    return
  end
  local MechanismId = tonumber(self.MechanismId)
  local FollowComponentId = tonumber(self.FollowComponentId)
  if not MechanismId or MechanismId <= 0 then
    DebugPrint("SetMechanismFollowNpcNode: invalid MechanismId", self.MechanismId)
    return
  end
  if not FollowComponentId or FollowComponentId <= 0 then
    DebugPrint("SetMechanismFollowNpcNode: invalid FollowComponentId", self.FollowComponentId)
    return
  end
  if self.bRevertOnFail then
    local Mechanism = GameMode.EMGameState:GetMechanismActorById(MechanismId)
    local Comp = GameMode:FindNpcFollowComponent(Mechanism, FollowComponentId)
    self.bWasNpcSpawned = IsValid(Comp) and IsValid(Comp.FollowNpc)
  end
  DebugPrint("SetMechanismFollowNpcNode: MechanismId =", MechanismId, "FollowComponentId =", FollowComponentId, "bSpawn =", self.bSpawn)
  GameMode:SetMechanismFollowNpc(MechanismId, FollowComponentId, self.bSpawn == true)
end

function SetMechanismFollowNpcNode:OnQuestlineFail()
  if not self.bRevertOnFail then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not IsValid(GameMode) then
    return
  end
  local MechanismId = tonumber(self.MechanismId)
  local FollowComponentId = tonumber(self.FollowComponentId)
  if not MechanismId or not FollowComponentId then
    return
  end
  GameMode:SetMechanismFollowNpc(MechanismId, FollowComponentId, self.bWasNpcSpawned)
end

return SetMechanismFollowNpcNode
