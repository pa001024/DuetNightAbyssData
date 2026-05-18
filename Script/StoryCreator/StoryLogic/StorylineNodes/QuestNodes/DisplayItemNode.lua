local DisplayItemNode = Class("StoryCreator.StoryLogic.StorylineNodes.QuestNodes.SubmitItemNode")
local LogType = UE.EStoryLogType.Quest

function DisplayItemNode:Init()
  self.AssociatedObjectType = "Npc"
  self.AssociatedObjectId = 0
  self.InteractionId = 0
  self.bGuideUIEnable = false
  self.GuideType = "P"
  self.GuidePointName = ""
  self.SubmitId = 0
  self.bDifferential = false
  self.DisplayResults = {}
end

function DisplayItemNode:Execute(Callback)
  if self.AssociatedObjectType == "Npc" then
    self:BindNpcInteraction()
  elseif self.AssociatedObjectType == "Drop" then
    self:BindDropInteraction()
  end
  self:AddGuide()
end

function DisplayItemNode:OnDisplayComplete(ItemIdx)
  local OutPortName = self:CalcOutPortName(ItemIdx)
  if not OutPortName then
    return
  end
  self:Finish(OutPortName)
end

function DisplayItemNode:CalcOutPortName(ItemIdx)
  local OutPortName
  local ItemIdx = tonumber(ItemIdx)
  if not self.bDifferential then
    OutPortName = "Out"
  elseif ItemIdx then
    if ItemIdx > #self.DisplayResults then
      local Message = string.format("引脚不存在，引脚序号：%d", ItemIdx)
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, LogType, "展示物品失败/引脚不存在", Message)
    else
      OutPortName = "Display_" .. ItemIdx
    end
  else
    local Message = string.format("引脚不存在，引脚序号为空")
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, LogType, "展示物品失败/引脚不存在", Message)
  end
  return OutPortName
end

function DisplayItemNode:BindNpcInteraction()
  local NpcIdWithGender = self.AssociatedObjectId
  NpcIdWithGender = NpcIdWithGender and URuntimeCommonFunctionLibrary.GetNPCIdByGender(GWorld.GameInstance, NpcIdWithGender)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Npc = GameState.NpcCharacterMap:FindRef(NpcIdWithGender)
  if IsValid(Npc) then
    self:MountSubmitComponentToActor(Npc, function(ItemIdx)
      self:OnDisplayComplete(ItemIdx)
    end)
  end
  self.NpcIdWithGender = NpcIdWithGender
end

function DisplayItemNode:BindDropInteraction()
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
    self:MountSubmitComponentToActor(DropActor, function(ItemIdx)
      self:OnDisplayComplete(ItemIdx)
    end)
  end
end

function DisplayItemNode:MountSubmitComponentToActor(Actor, Callback)
  if not IsValid(Actor) then
    return
  end
  if Actor.SubmitItemInteractiveComponent then
    if Actor.SubmitItemInteractiveComponent.InitSubmitComp then
      Actor.SubmitItemInteractiveComponent:InitCommonUIConfirmID(self.InteractionId)
      Actor.SubmitItemInteractiveComponent:InitSubmitComp(self.SubmitId, true, self.bDifferential)
      Actor.SubmitItemInteractiveComponent:BindSuccessCallback(Callback)
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
        Component:InitSubmitComp(self.SubmitId, true, self.bDifferential)
        Component:BindSuccessCallback(Callback)
        Actor.SubmitItemInteractiveComponent = Component
      end
    end
  })
end

function DisplayItemNode:Clear()
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

function DisplayItemNode:AddGuide()
  if self.bGuideUIEnable then
    MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
  end
end

function DisplayItemNode:ClearGuide()
  if self.bGuideUIEnable then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
end

return DisplayItemNode
