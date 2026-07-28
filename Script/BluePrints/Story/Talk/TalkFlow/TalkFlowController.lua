local M = {}

function M:New(TalkTask)
  local Obj = setmetatable({}, {__index = M})
  Obj.TalkTask = TalkTask
  return Obj
end

function M:ClearRunner()
  self.TalkFlow = nil
  self.FlowGraphComp = nil
end

function M:GetRunner()
  return self.TalkFlow or self.FlowGraphComp
end

function M:RegisterFlowGraph(FlowGraphComp)
  if self.TalkFlow then
    self.TalkFlow:End()
  end
  self.TalkFlow = nil
  self.FlowGraphComp = FlowGraphComp
end

function M:RegisterFlow(TalkFlow)
  local Runner = self:GetRunner()
  if Runner and Runner.End then
    Runner:End()
  end
  self.FlowGraphComp = nil
  self.TalkFlow = TalkFlow
end

function M:Start()
  local FlowGraphComp = self.FlowGraphComp
  if FlowGraphComp then
    FlowGraphComp:Execute()
    return
  end
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:Start: Runner不存在")
    return
  end
  if Flow:IsStart() and Flow:GetRestartTag() then
    self:SkipToRestartTag()
  else
    Flow:Start()
  end
end

function M:Pause()
  local Runner = self:GetRunner()
  if not Runner then
    DebugPrint("FTalkFlowController:Pause: Runner不存在")
    return
  end
  if Runner.Pause then
    Runner:Pause()
  end
end

function M:Iterate(...)
  local Runner = self:GetRunner()
  if not Runner then
    DebugPrint("FTalkFlowController:Iterate: Runner不存在")
    return
  end
  if Runner.Iterate then
    return Runner:Iterate(...)
  end
end

function M:Resume()
  local Runner = self:GetRunner()
  if not Runner then
    DebugPrint("FTalkFlowController:Resume: Runner不存在")
    return
  end
  if Runner.Resume then
    Runner:Resume()
  end
end

function M:Stop()
  local Runner = self:GetRunner()
  if not Runner then
    DebugPrint("FTalkFlowController:Stop: Runner不存在")
    return
  end
  if Runner.Stop then
    Runner:Stop()
  elseif Runner.End then
    Runner:End()
  end
  self:ClearRunner()
end

function M:GetDialogue()
  local Runner = self:GetRunner()
  if Runner and Runner.GetDialogue then
    return Runner:GetDialogue()
  end
end

function M:GetSavedOptions()
  local Runner = self:GetRunner()
  if Runner and Runner.GetSavedOptions then
    return Runner:GetSavedOptions()
  end
end

function M:GetOptions()
  local Runner = self:GetRunner()
  if Runner and Runner.GetOptions then
    return Runner:GetOptions()
  end
end

function M:IsOptionSelected(OptionId)
  local Runner = self:GetRunner()
  if not Runner then
    return false
  end
  if Runner.IsOptionSelected then
    return Runner:IsOptionSelected(OptionId)
  end
  return false
end

function M:HasFinalDialogue()
  local Runner = self:GetRunner()
  if Runner and Runner.HasFinalDialogue then
    return Runner:HasFinalDialogue()
  end
  return false
end

function M:GetCurrentNodeType()
  local Runner = self:GetRunner()
  if Runner and Runner.GetCurrentNodeType then
    return Runner:GetCurrentNodeType()
  end
end

function M:Skip()
  local Runner = self:GetRunner()
  if not Runner then
    DebugPrint("FTalkFlowController:Skip: Runner不存在")
    return
  end
  if Runner.Skip then
    return Runner:Skip()
  end
end

function M:RequestSkipDialogue()
  local FlowGraphComp = self.FlowGraphComp
  if FlowGraphComp then
    if FlowGraphComp.ForceToDialogueEnd then
      FlowGraphComp:ForceToDialogueEnd()
      return true
    end
    return false
  end
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:RequestSkipDialogue: Flow不存在")
    return false
  end
  return Flow:RequestSkipDialogue()
end

function M:SkipToFinalOrOption()
  local FlowGraphComp = self.FlowGraphComp
  if FlowGraphComp and FlowGraphComp.SkipToFinalOrOption then
    return FlowGraphComp:SkipToFinalOrOption()
  end
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:SkipToFinalOrOption: Flow不存在")
    return
  end
  if Flow:IsEnd() then
    self:Initialize(Flow)
    Flow:Skip()
  end
  while Flow:IsInText() and (Flow:GetCurrentNode().NextDialogueId or Flow:GetCurrentNode().FinalDialogue) do
    Flow:Skip()
  end
end

function M:SkipToEndOrOption()
  local FlowGraphComp = self.FlowGraphComp
  if FlowGraphComp and FlowGraphComp.SkipToEndOrOption then
    return FlowGraphComp:SkipToEndOrOption()
  end
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:SkipToEndOrOption: Flow不存在")
    return
  end
  local LastDialogue
  while Flow:IsInText() do
    Flow:Skip()
  end
  self.TalkTask.UI:ToPageEnd()
  Flow:Start()
end

function M:SkipToEnd()
  local FlowGraphComp = self.FlowGraphComp
  if FlowGraphComp and FlowGraphComp.SkipToEnd then
    return FlowGraphComp:SkipToEnd()
  end
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:SkipToEnd: Flow不存在")
    return
  end
  while not Flow:IsEnd() and Flow:Skip() do
  end
  self.TalkTask.UI:ToPageEnd()
  Flow:Start()
end

function M:SkipToRestartTag()
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:SkipToRestartTag: Flow不存在")
    return
  end
  local RestartTag = Flow:GetRestartTag()
  local CurrentDialogue
  while not Flow:IsEnd() do
    CurrentDialogue = Flow:GetDialogue()
    if not ((not CurrentDialogue or CurrentDialogue.DialogueId ~= RestartTag) and Flow:Skip()) then
      break
    end
  end
  self.TalkTask.UI:ToPageEnd()
  Flow:Start()
end

function M:ForceToDialogueEnd(bSkip)
  local Runner = self:GetRunner()
  if Runner and Runner.ForceToDialogueEnd then
    return Runner:ForceToDialogueEnd(bSkip)
  end
end

return M
