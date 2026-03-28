local FlowLogType = UE.EStoryLogType.TalkFlow
local DialogueLine_Pure = require("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.Dialogue.DialogueLine_Pure")
local PureDriver = {}
PureDriver.__index = PureDriver

function PureDriver.New(Node)
  local Obj = setmetatable({}, PureDriver)
  Obj.Node = Node
  Obj.DialogueTables = nil
  Obj.DialogueSettingsTable = nil
  Obj.Lines = nil
  Obj.FirstLine = nil
  Obj.ActiveLine = nil
  return Obj
end

function PureDriver:BuildLines()
  local Node = self.Node
  self.DialogueSettingsTable = Node.DialogueSetting:ToTable()
  self.DialogueTables = Node.DialogueData:ToTable()
  local Lines = {}
  for _, DialogueData in ipairs(self.DialogueTables) do
    local DialogueId = DialogueData and DialogueData.DialogueId
    local Setting = DialogueId and self.DialogueSettingsTable[DialogueId] or nil
    table.insert(Lines, DialogueLine_Pure.New(self, DialogueData, Setting))
  end
  for i = 1, #Lines do
    Lines[i].Next = Lines[i + 1]
  end
  self.Lines = Lines
  self.FirstLine = Lines[1]
end

function PureDriver:Start()
  self:BuildLines()
  DebugPrint("WXT__DialogueDriver_Pure:Start", "LineCount", self.Lines and #self.Lines or -1, "First", self.FirstLine and self.FirstLine.DialogueId)
  self:ActivateLine(self.FirstLine)
end

function PureDriver:ActivateLine(Line)
  self.ActiveLine = Line
  if not Line then
    DebugPrint("WXT__DialogueDriver_Pure:ActivateLine", "Finish")
    self.Node:FinishDialogue()
    return
  end
  return Line:Enter()
end

function PureDriver:ScheduleNextLine(CurrentLine, Reason)
  return CurrentLine and CurrentLine.Next or nil
end

function PureDriver:OnLineFinished(CurrentLine, Reason)
  local NextLine = self:ScheduleNextLine(CurrentLine, Reason)
  DebugPrint("WXT__DialogueDriver_Pure:OnLineFinished", CurrentLine and CurrentLine.DialogueId, Reason, "Next", NextLine and NextLine.DialogueId)
  return self:ActivateLine(NextLine)
end

function PureDriver:Skip()
  local Node = self.Node
  local FlowAsset = Node:GetFlowAsset()
  FlowAsset:CloseTalkActorsOptimization()
  local StopDialogueId
  if FlowAsset and FlowAsset.bIsInRestartDialogueSkip then
    StopDialogueId = FlowAsset.RestartDialogueId
  end
  local Line = self.ActiveLine
  DebugPrint("WXT__DialogueDriver_Pure:Skip", "Start", Line and Line.DialogueId, "Stop", StopDialogueId)
  while Line and (not StopDialogueId or Line.DialogueId ~= StopDialogueId) do
    Line:SkipCurrent()
    Line = self.ActiveLine
  end
  DebugPrint("WXT__DialogueDriver_Pure:Skip", "End", self.ActiveLine and self.ActiveLine.DialogueId)
end

function PureDriver:CanSkip()
  if self.ActiveLine and self.ActiveLine.CanSkip then
    return self.ActiveLine:CanSkip()
  end
  return true
end

function PureDriver:Pause()
  if self.ActiveLine and self.ActiveLine.Pause then
    return self.ActiveLine:Pause()
  end
end

function PureDriver:Resume()
  if self.ActiveLine and self.ActiveLine.Resume then
    return self.ActiveLine:Resume()
  end
end

function PureDriver:Cleanup()
  if self.ActiveLine and self.ActiveLine.Cleanup then
    self.ActiveLine:Cleanup()
  end
  self.ActiveLine = nil
end

return PureDriver
