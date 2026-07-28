require("UnLua")
require("DataMgr")
local LuaConst = require("EMLuaConst")
local BP_NpcTalkInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")
local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local DailyTalkController = require("BluePrints.UI.WBP.DailyTalk.DailyTalkController")
local StoryInteractiveController = require("BluePrints.UI.WBP.StoryInteractive.StoryInteractiveController")
local StoryInterActiveModel = require("BluePrints.UI.WBP.StoryInteractive.StoryInteractiveModel")
local ETalkInteractiveState = {
  None = "None",
  InteractiveTalk = "InteractiveTalk",
  BubbleTalk = "BubbleTalk"
}

function BP_NpcTalkInteractiveComponent_C:ReceiveBeginPlay()
  self.InteractiveTag = "Interactive"
  self.Super.ReceiveBeginPlay(self)
  self.Owner = self:GetOwner()
  self.EmptyUI = nil
  self.PlayerActor = nil
  self.TalkTriggerId = nil
  self.BubbleTalkTriggerId = 0
  self.bIsInit = false
  self.bIsEnd = false
  self.bIsHeadWidgetDisplayed = false
  self.bIsNameDisplayed = false
  self.bIsBubbleDisplayed = false
  self.bIsInvitateBubbleDisplayed = false
  self.bAllowShowName = true
  self.bNeedCheckNpcMap = true
  self.TalkState = ETalkInteractiveState.None
  self.NPCLookAtDistance = 200
  self.NPCLookAtAngle = 45
  self.NPCLookAtTarget = nil
  if self.Owner.bIsEmptyNpc then
    self:DisableNameDisplay()
  end
end

function BP_NpcTalkInteractiveComponent_C:InitDailyTalk()
  DailyTalkController:RegisterDailyTalkNpc(self.UnitId, self)
end

function BP_NpcTalkInteractiveComponent_C:DeInitDailyTalk()
  DailyTalkController:RegisterDailyTalkNpc(self.UnitId, nil)
end

function BP_NpcTalkInteractiveComponent_C:ReceiveEndPlay()
  DebugPrint("BP_NpcTalkInteractiveComponent_C:ReceiveEndPlay", self.Owner and self.Owner:GetName())
  self.bIsEnd = true
  if self:IsInInteractive() then
    self:TryExitInterativeTalkState()
  end
  self:DeInitDailyTalk()
end

function BP_NpcTalkInteractiveComponent_C:DisableNameDisplay()
  self.bAllowShowName = false
end

function BP_NpcTalkInteractiveComponent_C:Init()
  self.bIsInit = true
  self.UnitType = self.Owner.UnitType
  self.UnitId = self.Owner.UnitId
  if DailyTalkController:GetModel():CheckHasDailyTalkReward(self.UnitId) then
    self:InitDailyTalk()
  end
end

function BP_NpcTalkInteractiveComponent_C:GetDisplayName()
  return StoryInterActiveModel:GetInteractiveName(self.UnitId)
end

function BP_NpcTalkInteractiveComponent_C:RefreshInteractiveName()
  local InteractiveName = self:GetDisplayName() or ""
  if self.InteractiveName == InteractiveName then
    return
  end
  self:SetInteractiveName(InteractiveName)
  self:UpdateInteractiveUIState()
end

function BP_NpcTalkInteractiveComponent_C:RefreshDisplayName(PlayerActor, bForce)
  local bDisplayNameRes = self:IsCanDisplayName(PlayerActor)
  self:UpdateDisplayName(PlayerActor, bDisplayNameRes, bForce)
end

function BP_NpcTalkInteractiveComponent_C:TriggerEnter(PlayerActor)
  if self.bIsInit == false then
    return
  end
  self.Overridden.TriggerEnter(self, PlayerActor)
end

function BP_NpcTalkInteractiveComponent_C:TriggerTick(PlayerActor)
  if self.bIsInit == false then
    self.Overridden.TriggerTick(self, PlayerActor)
    return
  end
  local GameInstance = GWorld.GameInstance
  local TalkContext = GameInstance:GetTalkContext()
  local NpcData = self:GetNpcCharData(self.UnitType, self.UnitId)
  self:RefreshInteractiveName()
  if NpcData and NpcData.RelatedBubble then
    self.BubbleTalkTriggerId = TalkContext:GetValidTalkTriggerId(NpcData.RelatedBubble)
  else
    self.BubbleTalkTriggerId = nil
  end
  self.Overridden.TriggerTick(self, PlayerActor)
  if self.Owner then
    self:RefreshDisplayName(PlayerActor)
    self:UpdateState(PlayerActor)
    if self.Owner.bNPCDefaultLookAt then
      local IsInLookAtRange = self.DistanceCheck(self.Owner, PlayerActor, self.NPCLookAtDistance) and self.AngleCheck(self.Owner, PlayerActor, self.NPCLookAtAngle)
      self:EnableLookAt(PlayerActor, IsInLookAtRange)
    end
  end
  if self:IsCanInteractTrigger(PlayerActor) then
    self:BeginInteractTrigger()
  else
    self:EndInteractTrigger()
  end
end

function BP_NpcTalkInteractiveComponent_C:GetNpcCharData(InType, InUnitId)
  return DataMgr[InType][InUnitId]
end

function BP_NpcTalkInteractiveComponent_C:EnableLookAt(PlayerActor, EnableLookAtState)
  if not self.Owner or not self.Owner.NpcAnimInstance then
    return
  end
  if self.NPCLookAtTarget and false == EnableLookAtState then
    self.Owner.NpcAnimInstance:ResetNormalLookAt()
    self.NPCLookAtTarget = nil
  elseif self.NPCLookAtTarget == nil and true == EnableLookAtState then
    self.Owner.NpcAnimInstance:SetLookAtActor(PlayerActor, "head")
    self.NPCLookAtTarget = PlayerActor
  end
end

function BP_NpcTalkInteractiveComponent_C:TriggerExit(PlayerActor)
  if self.bIsInit == false then
    return
  end
  self.Overridden.TriggerExit(self, PlayerActor)
  self:NotDisplayName(PlayerActor)
  if self.TalkState ~= ETalkInteractiveState.InteractiveTalk then
    self:ExitCurrentState(PlayerActor)
  end
  if not PlayerActor:CheckCanInteractiveTrigger() then
    self:NotDisplayHeadWidget(PlayerActor)
  end
  self:EndInteractTrigger()
end

function BP_NpcTalkInteractiveComponent_C:BtnPressed(PlayerActor)
  if self:IsForbidden() then
    return
  end
  self:SwitchState(ETalkInteractiveState.InteractiveTalk, PlayerActor)
end

function BP_NpcTalkInteractiveComponent_C:IsCanInteractive(PlayerActor)
  local Owner = self.Owner
  local NPCAnimInstance = Owner.NPCAnimInstance
  local bIsRotating = NPCAnimInstance and NPCAnimInstance.IsRotating
  if LuaConst.OpenComputeInteractive then
    return self.bIsInit and not bIsRotating and not self.Owner.bHidden and not PlayerActor:IsSeating() and self:GetDistanceCheckResult() and self.BFaceToACheck(self.Owner, PlayerActor, self.InteractiveFaceAngle) and StoryInterActiveModel:HasAnyInteractive(self.UnitId)
  else
    return self.bIsInit and not bIsRotating and not self.Owner.bHidden and not PlayerActor:IsSeating() and self.DistanceCheck(self.Owner, PlayerActor, self.InteractiveDistance) and self.BFaceToACheck(self.Owner, PlayerActor, self.InteractiveFaceAngle) and StoryInterActiveModel:HasAnyInteractive(self.UnitId)
  end
end

function BP_NpcTalkInteractiveComponent_C:CheckForbiddenBySpecialQuest()
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.InSpecialQuest and StoryInterActiveModel:IsForbidBySpecialQuest(self.UnitId) then
    return true
  end
  return false
end

function BP_NpcTalkInteractiveComponent_C:IsForbidden()
  if self:CheckForbiddenBySpecialQuest() then
    self:SetOverridenFailMsg("QUEST_INSPECIALQUEST_MSG")
    return true
  else
    self:SetOverridenFailMsg()
  end
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if IsValid(PlayerCharacter) then
    return not self:CheckInteractiveSucc(PlayerCharacter.Eid)
  else
    return true
  end
end

function BP_NpcTalkInteractiveComponent_C:OnClicked_Forbidden()
  self:InteractiveFailed()
end

function BP_NpcTalkInteractiveComponent_C:RefreshTalkTriggerId()
  local TalkContext = GWorld.GameInstance:GetTalkContext()
  local NpcData = self:GetNpcCharData(self.UnitType, self.UnitId)
  if NpcData and NpcData.RelatedTalks then
    self.TalkTriggerId = TalkContext:GetValidTalkTriggerId(NpcData.RelatedTalks)
  else
    self.TalkTriggerId = nil
  end
end

function BP_NpcTalkInteractiveComponent_C:GetQuestID()
  return StoryInterActiveModel:GetNowInteractiveQuestChainId(self.UnitId)
end

function BP_NpcTalkInteractiveComponent_C:GetSpecialQuestID()
  return StoryInterActiveModel:GetNowInteractiveSpecialQuestId(self.UnitId)
end

function BP_NpcTalkInteractiveComponent_C:StartInteractive(PlayerActor)
  DebugPrint("BP_NpcTalkInteractiveComponent_C:StartInteractive")
  PlayerActor:AddForbidTag("TalkInteractive")
  PlayerActor:SetCharacterTag("Idle")
  PlayerActor:StopSlide()
  PlayerActor:SetCharacterTag(self.InteractiveTag)
  PlayerActor:SetCanInteractiveTrigger(false, "TalkInteractive")
  self.bIsInInteractive = true
  self.PlayerActor = PlayerActor
  StoryInteractiveController:TryStartInteractive(self.UnitId, self.Owner, PlayerActor, {
    Obj = self,
    Func = self.TryExitInterativeTalkState
  })
end

function BP_NpcTalkInteractiveComponent_C:EndInteractive()
  DebugPrint("BP_NpcTalkInteractiveComponent_C:EndInteractive", self:IsInInteractive())
  TalkUtils:RemovePlayerInvincible()
  if not self:IsInInteractive() then
    return
  end
  self.PlayerActor:MinusForbidTag("TalkInteractive")
  self.PlayerActor:SetCharacterTag("Idle")
  self.PlayerActor:SetCanInteractiveTrigger(true, "TalkInteractive")
  self.bIsInInteractive = false
  self.PlayerActor = nil
end

function BP_NpcTalkInteractiveComponent_C:IsInInteractive()
  return self.bIsInInteractive
end

function BP_NpcTalkInteractiveComponent_C:CheckInteractiveSucc(PlayerEid)
  local ConditionCheck = self.Super.CheckInteractiveSucc(self, PlayerEid)
  local Player = Battle(self):GetEntity(PlayerEid)
  local TagCheck = self:CheckPlayerTag(Player)
  return ConditionCheck and TagCheck
end

function BP_NpcTalkInteractiveComponent_C:UpdateDisplayHeadWidget(PlayerActor, bDisplayHeadWidgetRes)
  if bDisplayHeadWidgetRes then
    self:DisplayHeadWidget(PlayerActor)
  else
    self:NotDisplayHeadWidget(PlayerActor)
  end
end

function BP_NpcTalkInteractiveComponent_C:DisplayHeadWidget(PlayerActor)
  local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
  if HeadUISubsystem then
  end
end

function BP_NpcTalkInteractiveComponent_C:RefreshHeadWidget(PlayerActor)
end

function BP_NpcTalkInteractiveComponent_C:NotDisplayHeadWidget(PlayerActor)
  local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
  if not HeadUISubsystem or false then
  end
end

function BP_NpcTalkInteractiveComponent_C:IsCanDisplayName(PlayerActor)
  return self.bAllowShowName and self.bIsInit and self.DistanceCheck(self.Owner, PlayerActor, self.NameDisplayDistance) and not self.Owner.bHidden
end

function BP_NpcTalkInteractiveComponent_C:UpdateDisplayName(PlayerActor, bDisplayName, bForce)
  if bDisplayName and (self.bIsNameDisplayed == false or bForce) then
    self:DisplayName(PlayerActor)
  elseif false == bDisplayName and (self.bIsNameDisplayed or bForce) then
    self:NotDisplayName(PlayerActor)
  end
end

function BP_NpcTalkInteractiveComponent_C:DisplayName(PlayerActor)
  if self.DisplayInteractiveName == "" then
    return
  end
  self.bIsNameDisplayed = true
  self.Owner:EnableNameWidget(true)
end

function BP_NpcTalkInteractiveComponent_C:NotDisplayName(PlayerActor)
  self.bIsNameDisplayed = false
  self.Owner:EnableNameWidget(false)
end

function BP_NpcTalkInteractiveComponent_C:IsCanDisplayBubble(PlayerActor)
  return self.bIsInit and not self.bIsEnd and self.BubbleTalkTriggerId ~= nil and self.DistanceCheck(self.Owner, PlayerActor, self.BubbleDisplayDistance) and not self.Owner.bHidden
end

function BP_NpcTalkInteractiveComponent_C:DisplayBubble(PlayerActor)
  if self.bIsBubbleDisplayed then
    return
  end
  self.bIsBubbleDisplayed = true
  local GameInstance = GWorld.GameInstance
  local TalkContext = GameInstance:GetTalkContext()
  self.DisplayBubbleTriggerId = self.BubbleTalkTriggerId
  local TalkAsyncAction = UE4.UPlayTalkAsyncAction.PlayTalk(self, self.BubbleTalkTriggerId, nil)
  if IsValid(TalkAsyncAction) then
    TalkAsyncAction.InteractiveActor = self:GetOwner()
    TalkAsyncAction.OnPlayTalkEnd:Add(self, self.NotDisplayBubble)
    TalkAsyncAction.OnPlayTalkInterrupted:Add(self, self.NotDisplayBubble)
    TalkAsyncAction:Activate()
  end
end

function BP_NpcTalkInteractiveComponent_C:NotDisplayBubble(PlayerActor)
  if self.bIsBubbleDisplayed == false then
    return
  end
  if self:IsCanDisplayBubble(PlayerActor) then
    return
  end
  self.bIsBubbleDisplayed = false
  local TS = TalkSubsystem()
  if TS then
    TS:ForceInterruptTalkTaskData(function(TalkTaskData)
      return TalkTaskData.TalkTriggerId == self.DisplayBubbleTriggerId
    end)
  end
  self.DisplayBubbleTriggerId = nil
end

function BP_NpcTalkInteractiveComponent_C:IsCanInteractTrigger(PlayerActor)
  if not self.bIsInit or self.Owner.bHidden then
    return false
  end
  local NpcData = self:GetNpcCharData(self.UnitType, self.UnitId)
  if not NpcData then
    return false
  end
  local InteractTriggerData = DataMgr.InteractTrigger[NpcData.InteractTriggerId]
  if not InteractTriggerData then
    return false
  end
  return self.DistanceCheck(self.Owner, PlayerActor, InteractTriggerData.DetectionCM)
end

function BP_NpcTalkInteractiveComponent_C:BeginInteractTrigger()
  if self.bIsInteractTrigger then
    return
  end
  self.bIsInteractTrigger = true
  local NpcData = self:GetNpcCharData(self.UnitType, self.UnitId)
  if not NpcData then
    return
  end
  local InteractTriggerData = DataMgr.InteractTrigger[NpcData.InteractTriggerId]
  if not InteractTriggerData then
    return
  end
  GWorld.StoryMgr:RunStory(InteractTriggerData.StorylineFilePath, nil, nil, function()
    local Avatar = GWorld:GetAvatar()
    if not Avatar:CheckInteractTriggerRewardIsGot(InteractTriggerData.InteractTriggerId) then
      Avatar:GetInteractTriggerReward(InteractTriggerData.InteractTriggerId)
    end
  end)
end

function BP_NpcTalkInteractiveComponent_C:EndInteractTrigger()
  if not self.bIsInteractTrigger then
    return
  end
  if self.TalkState == ETalkInteractiveState.InteractiveTalk then
    return
  end
  self.bIsInteractTrigger = false
  local NpcData = self:GetNpcCharData(self.UnitType, self.UnitId)
  if not NpcData then
    return
  end
  local InteractTriggerData = DataMgr.InteractTrigger[NpcData.InteractTriggerId]
  if not InteractTriggerData then
    return
  end
  GWorld.StoryMgr:StopStoryline(InteractTriggerData.StorylineFilePath)
end

function BP_NpcTalkInteractiveComponent_C:TryExitInterativeTalkState()
  if self.TalkState ~= ETalkInteractiveState.InteractiveTalk then
    return
  end
  self:ExitCurrentState()
end

function BP_NpcTalkInteractiveComponent_C:ExitCurrentState(PlayerActor)
  local TalkState = self.TalkState
  self.TalkState = ETalkInteractiveState.None
  if TalkState == ETalkInteractiveState.BubbleTalk then
    self:NotDisplayBubble(PlayerActor)
  elseif TalkState == ETalkInteractiveState.InteractiveTalk then
    self:EndInteractive()
  end
end

function BP_NpcTalkInteractiveComponent_C:EnterState(State, PlayerActor)
  if self.TalkState == State then
    return
  end
  self.TalkState = State
  if State == ETalkInteractiveState.BubbleTalk then
    self:DisplayBubble(self.PlayerActor)
  elseif State == ETalkInteractiveState.InteractiveTalk then
    self:StartInteractive(PlayerActor)
  end
end

function BP_NpcTalkInteractiveComponent_C:SwitchState(State, PlayerActor)
  self:ExitCurrentState(PlayerActor)
  self:EnterState(State, PlayerActor)
end

function BP_NpcTalkInteractiveComponent_C:CanEnterState(State)
  if State == self.TalkState then
    return false
  end
  local bCanExit = true
  if self.TalkState == ETalkInteractiveState.InteractiveTalk then
    bCanExit = false
  elseif State == ETalkInteractiveState.InteractiveTalk then
    bCanExit = true
  elseif self.TalkState == ETalkInteractiveState.BubbleTalk then
    if self.bIsBubbleDisplayed then
      bCanExit = false
    else
      bCanExit = true
    end
  end
  return bCanExit
end

function BP_NpcTalkInteractiveComponent_C:UpdateState(PlayerActor)
  if self.TalkState == ETalkInteractiveState.BubbleTalk and not self:IsCanDisplayBubble(PlayerActor) then
    self:ExitCurrentState(PlayerActor)
  end
  if self:CanEnterState(ETalkInteractiveState.BubbleTalk) and self:IsCanDisplayBubble(PlayerActor) then
    self:SwitchState(ETalkInteractiveState.BubbleTalk, PlayerActor)
  end
end

return BP_NpcTalkInteractiveComponent_C
