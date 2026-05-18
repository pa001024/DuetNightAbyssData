local LibraryPath = "/Game/Asset/Effect/Blueprint/PostProcess/PostProcessFunctionLibrary.PostProcessFunctionLibrary"
local DialogueLine_Sequence = require("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.Dialogue.DialogueLine_Sequence")
local SequenceDriver = {}
SequenceDriver.__index = SequenceDriver

function SequenceDriver.New(Node)
  local Obj = setmetatable({}, SequenceDriver)
  Obj.Node = Node
  Obj.DialogueTables = nil
  Obj.DialogueSettingsTable = nil
  Obj.Lines = nil
  Obj.FirstLine = nil
  Obj.ActiveLine = nil
  return Obj
end

function SequenceDriver:BuildLines()
  local Node = self.Node
  self.DialogueSettingsTable = Node.DialogueSetting:ToTable()
  self.DialogueTables = Node.DialogueData:ToTable()
  local Lines = {}
  for _, DialogueData in ipairs(self.DialogueTables) do
    local DialogueId = DialogueData and DialogueData.DialogueId
    local Setting = DialogueId and self.DialogueSettingsTable[DialogueId] or nil
    table.insert(Lines, DialogueLine_Sequence.New(self, DialogueData, Setting))
  end
  for i = 1, #Lines do
    Lines[i].Next = Lines[i + 1]
  end
  self.Lines = Lines
  self.FirstLine = Lines[1]
end

function SequenceDriver:Start()
  if not self:TryStartSequence() then
    DebugPrint("WXT__DialogueDriver_Sequence:Start", "TryStartSequence failed")
    return false
  end
  self:BuildLines()
  DebugPrint("WXT__DialogueDriver_Sequence:Start", "LineCount", self.Lines and #self.Lines or -1, "First", self.FirstLine and self.FirstLine.DialogueId)
  self:ActivateLine(self.FirstLine)
  local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(PlayerController)
  return true
end

function SequenceDriver:BindSequenceActors()
  local Node = self.Node
  local DialogueAssets = Node:GetFlowAsset()
  local LevelSequenceActor = DialogueAssets.LevelSequenceActor
  local TalkContext = GWorld.GameInstance:GetTalkContext()
  local TalkTask = Node:TryGetTalkTask()
  local BindNpcs = TalkTask.TalkTaskData.TalkActors
  local LevelSequence = Node:GetSequenceByGender()
  for _, NpcData in pairs(BindNpcs) do
    local UnitId = NpcData.TalkActorId
    local TalkActorData = TalkContext:GetTalkActorData(TalkTask, UnitId)
    if TalkActorData and TalkActorData.TalkActor then
      local NpcIdTag = tostring(NpcData.OriginTalkActorId or UnitId)
      DialogueAssets:TryCacheNpcTransform(TalkActorData.TalkActor)
      if UTalkFunctionLibrary.IsSequenceOwnTag(LevelSequence, NpcIdTag) then
        LevelSequenceActor:AddBindingByTag(NpcIdTag, TalkActorData.TalkActor, false)
      end
    end
  end
  local UPostProcessFunctionLibrary = LoadClass(LibraryPath)
  if UPostProcessFunctionLibrary and UPostProcessFunctionLibrary.MobileCloseLights then
    UPostProcessFunctionLibrary.MobileCloseLights(LevelSequenceActor)
  end
end

function SequenceDriver:TryStartSequence()
  local Node = self.Node
  local LevelSequence = Node:GetSequenceByGender()
  if not IsValid(LevelSequence) then
    DebugPrint("WXT__DialogueDriver_Sequence:TryStartSequence", "LevelSequence invalid")
    return false
  end
  Node:PlaySequence()
  if not IsValid(Node.SequencePlayer) or not IsValid(Node.RuntimeProxy) then
    DebugPrint("WXT__DialogueDriver_Sequence:TryStartSequence", "SequencePlayer/RuntimeProxy invalid")
    return false
  end
  self:BindSequenceActors()
  Node.RuntimeProxy:SetUpLua(Node:TryGetTalkTask())
  return true
end

function SequenceDriver:ActivateLine(Line)
  local PrevDialogueId = self.ActiveLine and self.ActiveLine.DialogueId
  if self.ActiveLine and self.ActiveLine.CleanupForTransition then
    self.ActiveLine:CleanupForTransition(Line)
  end
  self.ActiveLine = Line
  if not Line then
    DebugPrint("WXT__DialogueDriver_Sequence:ActivateLine", "Finish")
    self.Node:FinishDialogue()
    return
  end
  if not Line:BindDelegates() then
    DebugPrint("WXT__DialogueDriver_Sequence:ActivateLine", "BindDelegates failed", Line.DialogueId)
    self.Node:FinishDialogue()
    return
  end
  if Line:Enter(PrevDialogueId) ~= true then
    return self:OnLineFinished(Line, "enter_fail")
  end
end

function SequenceDriver:ScheduleNextLine(CurrentLine, Reason)
  return CurrentLine and CurrentLine.Next or nil
end

function SequenceDriver:OnLineFinished(CurrentLine, Reason)
  local NextLine = self:ScheduleNextLine(CurrentLine, Reason)
  DebugPrint("WXT__DialogueDriver_Sequence:OnLineFinished", CurrentLine and CurrentLine.DialogueId, Reason, "Next", NextLine and NextLine.DialogueId)
  return self:ActivateLine(NextLine)
end

function SequenceDriver:Skip()
  local Node = self.Node
  if Node.RuntimeProxy then
    Node.RuntimeProxy:EnterSkip()
  end
  local FlowAsset = Node:GetFlowAsset()
  FlowAsset:CloseTalkActorsOptimization()
  local StopDialogueId
  if FlowAsset and FlowAsset.bIsInRestartDialogueSkip then
    StopDialogueId = FlowAsset.RestartDialogueId
  end
  local Line = self.ActiveLine
  DebugPrint("WXT__DialogueDriver_Sequence:Skip", "Start", Line and Line.DialogueId, "Stop", StopDialogueId)
  while Line and (not StopDialogueId or Line.DialogueId ~= StopDialogueId) do
    Line:SkipCurrent()
    Line = self.ActiveLine
  end
  DebugPrint("WXT__DialogueDriver_Sequence:Skip", "End", self.ActiveLine and self.ActiveLine.DialogueId)
  if Node.RuntimeProxy then
    Node.RuntimeProxy:ClearSkip()
  end
end

function SequenceDriver:CanSkip()
  if self.ActiveLine and self.ActiveLine.CanSkip then
    return self.ActiveLine:CanSkip()
  end
  return true
end

function SequenceDriver:Pause()
  if self.ActiveLine and self.ActiveLine.Pause then
    return self.ActiveLine:Pause()
  end
end

function SequenceDriver:Resume()
  if self.ActiveLine and self.ActiveLine.Resume then
    return self.ActiveLine:Resume()
  end
end

function SequenceDriver:Cleanup()
  if self.ActiveLine and self.ActiveLine.Cleanup then
    self.ActiveLine:Cleanup()
  end
  self.ActiveLine = nil
end

return SequenceDriver
