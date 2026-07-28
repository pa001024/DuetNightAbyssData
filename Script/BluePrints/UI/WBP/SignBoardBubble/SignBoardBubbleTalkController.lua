local M = Class("BluePrints.Common.MVC.Controller")
local SignBoardBubbleTalkModel = require("BluePrints.UI.WBP.SignBoardBubble.SignBoardBubbleTalkModel")
local SignBoardBubbleTalkCommon = require("BluePrints.UI.WBP.SignBoardBubble.SignBoardBubbleTalkCommon")

function M:Init()
  M.Super.Init(self)
  EventManager:AddEvent(EventID.UpdateSignBoardNpc, self, self.OnUpdateSignBoardNpc)
  EventManager:AddEvent(EventID.CloseLoading, self, self.OnCloseLoading)
end

function M:Destory()
  M.Super.Destory(self)
  EventManager:RemoveEvent(EventID.UpdateSignBoardNpc, self)
  local BoardSystem = UBoardBubbleSubsystem.GetSubsystem(GWorld.GameInstance)
  if not BoardSystem then
    return
  end
  BoardSystem:RemoveTimer(self.Timer)
  self.Timer = nil
end

function M:OnCloseLoading()
  SignBoardBubbleTalkModel.bSignBoardNpcLoadComplete = nil
  local Avatar = self:GetAvatar()
  local bIsInBigWorld = Avatar and Avatar:IsInBigWorld()
  local bIsInHomeBase = Avatar and Avatar:CheckSubRegionType(Avatar:GetCurrentRegionId(), CommonConst.SubRegionType.Home)
  if Avatar and bIsInBigWorld and bIsInHomeBase then
    self:StartHomeBase()
  end
end

function M:StopTalkTrigger(RunningTriggerId)
  if RunningTriggerId ~= SignBoardBubbleTalkModel:GetRunningTalkTrigger() then
    return
  end
  local TS = TalkSubsystem()
  SignBoardBubbleTalkModel:SetRunningTalkTrigger(nil)
  if RunningTriggerId and 0 ~= RunningTriggerId then
    TS:ForceInterruptTalkTaskData(function(TalkTaskData)
      return TalkTaskData.TalkTriggerId == SignBoardBubbleTalkModel:GetTalkTriggerId(RunningTriggerId)
    end)
    SignBoardBubbleTalkModel:ResetTalkWaitTime(RunningTriggerId)
  end
end

function M:RecordBubbleDialogue(DialogueId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local DialogueData = DataMgr.Dialogue[DialogueId]
  if not DialogueData then
    return
  end
  if not Avatar:CheckSignBoardNpcTalkValid(DialogueData.SpeakNpcId, DialogueId) then
    return
  end
  Avatar:TriggerRecordSignBoardNpcTalk(DialogueData.SpeakNpcId, DialogueId)
end

function M:StartTalkTrigger(GossipTriggerId)
  local TalkTriggerId = SignBoardBubbleTalkModel:GetTalkTriggerId(GossipTriggerId)
  local Avatar = self:GetAvatar()
  if not TalkTriggerId then
    return
  end
  if not Avatar then
    return
  end
  SignBoardBubbleTalkModel:SetRunningTalkTrigger(GossipTriggerId)
  
  local function OnTriggerFailedOrEnd()
    self:StopTalkTrigger(GossipTriggerId)
  end
  
  local function OnTriggerSucces()
    local GameInstance = GWorld.GameInstance
    local TalkAsyncAction = UE4.UPlayTalkAsyncAction.PlayTalk(GameInstance, TalkTriggerId, nil)
    
    local function OnPlayDialogue(Obj, DialogueId)
      self:RecordBubbleDialogue(DialogueId)
    end
    
    if IsValid(TalkAsyncAction) then
      TalkAsyncAction.OnPlayTalkEnd:Add(GWorld.GameInstance, OnTriggerFailedOrEnd)
      TalkAsyncAction.OnPlayTalkInterrupted:Add(GWorld.GameInstance, OnTriggerFailedOrEnd)
      TalkAsyncAction.OnPlayDialogue:Add(GWorld.GameInstance, OnPlayDialogue)
      local Array = TArray(0)
      for _, NpcId in pairs(SignBoardBubbleTalkModel:GetNpcCombination(GossipTriggerId)) do
        Array:Add(NpcId)
      end
      TalkAsyncAction.RelatedNPCIds = Array
      TalkAsyncAction:Activate()
    end
  end
  
  local NpcId = SignBoardBubbleTalkModel:GetServerCanTriggerNpc(GossipTriggerId)
  Avatar:TriggerAddSignBoardNpcDailyTalk(NpcId, function(bSuccess)
    if bSuccess and GossipTriggerId == SignBoardBubbleTalkModel:GetRunningTalkTrigger() then
      OnTriggerSucces()
    else
      OnTriggerFailedOrEnd()
    end
  end)
end

function M:TickCheck()
  local Avatar = self:GetAvatar()
  local BoardSystem = UBoardBubbleSubsystem.GetSubsystem(GWorld.GameInstance)
  if not BoardSystem then
    return
  end
  if not Avatar then
    BoardSystem:RemoveTimer(self.Timer)
    self.Timer = nil
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if not IsValid(Player) then
    return
  end
  if Player.bHide then
    return
  end
  local CanTriggers = BoardSystem:TickCheck()
  local TriggerMap = {}
  for _, TriggerId in pairs(CanTriggers) do
    TriggerMap[TriggerId] = true
    SignBoardBubbleTalkModel:AddStartWaitTrigger(TriggerId)
  end
  local TriggerQueue = SignBoardBubbleTalkModel:GetWaitTriggerQueue()
  local ToRemove
  for WaitTriggerId, _ in pairs(TriggerQueue) do
    if not TriggerMap[WaitTriggerId] or not Player:CheckCanInteractiveTrigger() then
      ToRemove = ToRemove or {}
      table.insert(ToRemove, WaitTriggerId)
    end
  end
  if ToRemove then
    for index, TriggerId in ipairs(ToRemove) do
      SignBoardBubbleTalkModel:RemoveWaitTrigger(TriggerId)
    end
  end
  local RunningTriggerId = SignBoardBubbleTalkModel:GetRunningTalkTrigger()
  if not SignBoardBubbleTalkModel:CheckTriggerDistance(RunningTriggerId) then
    self:StopTalkTrigger(RunningTriggerId)
  end
  local NewTriggerId = SignBoardBubbleTalkModel:CheckWaitTriggerQueue()
  if NewTriggerId then
    self:StartTalkTrigger(NewTriggerId)
  end
end

function M:StartHomeBase()
  DebugPrint("SignBoardBubbleTalkController:StartHomeBase")
  local BoardSystem = UBoardBubbleSubsystem.GetSubsystem(GWorld.GameInstance)
  if not BoardSystem then
    return
  end
  BoardSystem:RemoveTimer(self.Timer)
  self.Timer = nil
  local Avatar = GWorld:GetAvatar()
  BoardSystem:ClearTickCheckCharacters()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if Avatar then
    for key, value in pairs(Avatar.SignBoardNpc) do
      BoardSystem:AddTickCheckCharacter(value, key, SignBoardBubbleTalkCommon.NpcPoint[key])
    end
  end
  if IsValid(Player) and IsValid(Player.InteractiveTriggerComponent) then
    BoardSystem:SetDefaultDistanceSquared(Player.InteractiveTriggerComponent:GetInteractiveTriggerDistance())
  end
  self.Timer = BoardSystem:AddTimer(0.2, function()
    self:TickCheck()
  end, true, 0, nil, false, UE4.ETickingGroup.TG_EndPhysics)
end

function M:OnUpdateSignBoardNpc()
  self:StopTalkTrigger(SignBoardBubbleTalkModel:GetRunningTalkTrigger())
  SignBoardBubbleTalkModel:ResetTalkData()
  local Avatar = self:GetAvatar()
  if Avatar and Avatar:CheckSubRegionType(Avatar:GetCurrentRegionId(), CommonConst.SubRegionType.Home) then
    self:StartHomeBase()
  end
end

function M:GetModel()
  return SignBoardBubbleTalkModel
end

function M:GetEventName()
  return "SignBoardBubbleTalkModel"
end

return M
