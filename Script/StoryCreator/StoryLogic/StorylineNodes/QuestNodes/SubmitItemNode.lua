local SubmitItemNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")

function SubmitItemNode:Init()
  self.AssociatedObjectType = "Npc"
  self.AssociatedObjectId = 0
  self.InteractionId = 0
  self.bGuideUIEnable = false
  self.GuideType = "P"
  self.GuidePointName = ""
  self.SubmitId = 0
end

function SubmitItemNode:Execute(Callback)
  local Avatar = GWorld:GetAvatar()
  local SpecialQuestId = self:GetPayload("SpecialQuestId")
  if SpecialQuestId and 0 ~= SpecialQuestId then
    if Avatar and Avatar:GetIsSpecialQuestSubmitComplete(SpecialQuestId, self.SubmitId) then
      Callback()
      return
    end
  elseif Avatar and Avatar:GetIsSubmitComplete(self.Context.QuestChainId, self.SubmitId) then
    Callback()
    return
  end
  self.Callback = Callback
  if self.AssociatedObjectType == "Npc" then
    self:BindNpcInteraction()
  elseif self.AssociatedObjectType == "Drop" then
    self:BindDropInteraction()
  end
  self:AddGuide()
end

function SubmitItemNode:BindNpcInteraction()
  local NpcIdWithGender = self.AssociatedObjectId
  NpcIdWithGender = NpcIdWithGender and URuntimeCommonFunctionLibrary.GetNPCIdByGender(GWorld.GameInstance, NpcIdWithGender)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Npc = GameState.NpcCharacterMap:FindRef(NpcIdWithGender)
  if IsValid(Npc) then
    self:MountSubmitComponentToActor(Npc, function()
      self.Callback()
    end)
  end
  self.NpcIdWithGender = NpcIdWithGender
end

function SubmitItemNode:BindDropInteraction()
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local DropActor
  local StaticCreator = GameState:GetStaticCreatorInfo(self.AssociatedObjectId)
  if StaticCreator then
    local ChildDrop = StaticCreator:GetChildEids():ToTable()
    if #ChildDrop > 0 then
      local Eid = ChildDrop[1]
      DropActor = GameState.CombatItemMap:FindRef(Eid)
    end
  end
  if IsValid(DropActor) then
    self:MountSubmitComponentToActor(DropActor, function()
      self.Callback()
    end)
  end
end

function SubmitItemNode:MountSubmitComponentToActor(Actor, Callback)
  if not IsValid(Actor) then
    return
  end
  if Actor.SubmitItemInteractiveComponent then
    if Actor.SubmitItemInteractiveComponent.InitSubmitComp then
      Actor.SubmitItemInteractiveComponent:InitSubmitComp(self.SubmitId, false)
    end
    return
  end
  UResourceLibrary.LoadClassAsync(Actor, "/Game/BluePrints/Story/Interactive/InteractiveComponent/BP_SubmitItemInteractiveComponent", {
    Actor,
    function(_, ClassObject)
      if not IsValid(Actor) then
        return
      end
      local Component
      if Actor.AddInteractiveComponent then
        Component = Actor:AddInteractiveComponent(ClassObject)
      else
        Component = NewObject(ClassObject, Actor)
        Component:K2_AttachToComponent(Actor.RootComponent, "", EAttachmentRule.SnapToTarget, EAttachmentRule.SnapToTarget, EAttachmentRule.SnapToTarget, true)
        URuntimeCommonFunctionLibrary.RegisterComponent(Component)
        if Actor.InteractiveComponents then
          Actor.InteractiveComponents:Add(Component)
        end
      end
      if IsValid(Component) then
        Component:InitCommonUIConfirmID(self.InteractionId)
        Component:InitSubmitComp(self.SubmitId, false)
        Component:BindSuccessCallback(Callback)
        Actor.SubmitItemInteractiveComponent = Component
      end
    end
  })
end

function SubmitItemNode:Clear()
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if self.NpcIdWithGender then
    local Npc = GameState.NpcCharacterMap:FindRef(self.NpcIdWithGender)
    if IsValid(Npc) and Npc.SubmitItemInteractiveComponent then
      Npc.SubmitItemInteractiveComponent:K2_DestroyComponent(Npc)
      Npc.SubmitItemInteractiveComponent = nil
    end
  elseif self.AssociatedObjectType == "Drop" then
    local DropActor
    local StaticCreator = GameState:GetStaticCreatorInfo(self.AssociatedObjectId)
    if StaticCreator then
      local ChildDrop = StaticCreator:GetChildEids():ToTable()
      if #ChildDrop > 0 then
        local Eid = ChildDrop[1]
        DropActor = GameState.CombatItemMap:FindRef(Eid)
      end
    end
    if IsValid(DropActor) and DropActor.SubmitItemInteractiveComponent then
      DropActor.SubmitItemInteractiveComponent:K2_DestroyComponent(DropActor)
      DropActor.SubmitItemInteractiveComponent = nil
    end
  end
  self:ClearGuide()
end

function SubmitItemNode:AddGuide()
  if self.bGuideUIEnable then
    MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
  end
end

function SubmitItemNode:ClearGuide()
  if self.bGuideUIEnable then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
end

return SubmitItemNode
