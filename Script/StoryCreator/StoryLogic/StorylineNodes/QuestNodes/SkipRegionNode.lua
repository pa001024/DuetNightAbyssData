local SkipRegionNode = Class("StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode")

function SkipRegionNode:Init()
  self.Callback = nil
end

function SkipRegionNode:Start(Context)
  self.Context = Context
  self:Delivery()
end

function SkipRegionNode:Delivery()
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  local Avatar = GWorld:GetAvatar()
  if not GameMode or not Avatar then
    return
  end
  
  local function Callback()
    self:FinishAction()
    Avatar:RemoveSubRegionSkipCallback(self.Id, self, self.Callback)
  end
  
  self.Callback = Callback
  Avatar:AddRegionSkipCallback(self.Id, self, self.Callback)
  local bIsFromMap
  local bShouldReturnAndDownloadPatch = true
  local Res = GameMode:HandleLevelDeliver(self.ModeType, self.Id, self.StartIndex, self.IsWhite, self:GetPayload("bIsInvitation"), bIsFromMap, bShouldReturnAndDownloadPatch)
  DebugPrint("ZJT_ AddRegionSkipCallBack SkipRegionNode ", self.Id, Res, self.ModeType, self.StartIndex)
  if DataMgr.SubRegion[self.Id] and DataMgr.SubRegion[self.Id].RegionId ~= DataMgr.SubRegion[Avatar.CurrentRegionId].RegionId then
    local Params = {}
    Params.BlackScreenHandle = "HandleLevelDeliverBlackCurtain"
    GWorld.GameInstance:GetGameUIManager():ShowCommonBlackScreen(Params)
    self.BlackScreenHandle = GWorld.GameInstance:AddTimer(30, function()
      GWorld.GameInstance:GetGameUIManager():HideCommonBlackScreen("HandleLevelDeliverBlackCurtain")
    end)
  end
  local WCSubsystem = GameMode:GetWCSubSystem()
  if not WCSubsystem then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameMode, 0)
  if not Player then
    return
  end
  local MovementComponent = Player:GetMovementComponent()
  if MovementComponent then
    MovementComponent.bIsAsyncTraveling = false
  end
end

function SkipRegionNode:FinishAction()
  self:Finish()
end

function SkipRegionNode:Clear()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:RemoveSubRegionSkipCallback(self.Id, self, self.Callback)
  if self.BlackScreenHandle then
    GWorld.GameInstance:RemoveTimer(self.BlackScreenHandle)
    self.BlackScreenHandle = nil
  end
end

return SkipRegionNode
