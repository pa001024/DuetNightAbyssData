local M = {}

function M:RegisterFlow(TalkFlow)
  if self.TalkFlow then
    self.TalkFlow:End()
  end
  self.TalkFlow = TalkFlow
end

function M:Start()
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:Start: Flow不存在")
    return
  end
  if Flow:IsStart() and Flow:GetRestartTag() then
    self:SkipToRestartTag()
  else
    Flow:Start()
  end
end

function M:Pause()
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:Pause: Flow不存在")
    return
  end
  Flow:Pause()
end

function M:Resume()
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:Resume: Flow不存在")
    return
  end
  Flow:Resume()
end

function M:Skip()
  local Flow = self.TalkFlow
  if not Flow then
    DebugPrint("FTalkFlowController:Skip: Flow不存在")
    return
  end
  return Flow:Skip()
end

function M:SkipToFinalOrOption()
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
end

return M
