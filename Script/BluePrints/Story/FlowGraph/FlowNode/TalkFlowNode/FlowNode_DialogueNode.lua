local M = Class("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.FlowNode_TalkNodeBase")
local FlowLogType = UE.EStoryLogType.TalkFlow
local PIN_IN = "In"
local PIN_OUT = "Out"

function M:ReceiveBeginPlay()
end

local function BuildChain(self, Body, SentenceClass)
  if not IsValid(Body) then
    return false
  end
  local DialogueTables = self.DialogueData:ToTable()
  if not DialogueTables or 0 == #DialogueTables then
    return false
  end
  local StartNode = Body:CreateRuntimeNode(UE4.UFlowNode_Start)
  if not StartNode then
    return false
  end
  local PinNameMap = self.DialoguePinName:ToTable()
  local Prev = StartNode
  for Index, DialogueData in ipairs(DialogueTables) do
    local Sentence = Body:CreateRuntimeNode(SentenceClass)
    if not Sentence then
      return false
    end
    Sentence.DialogueId = DialogueData.DialogueId
    local PinName = PinNameMap[DialogueData.DialogueId]
    if PinName then
      Sentence.NormalPinName = PinName
    end
    if Index == #DialogueTables then
      Sentence.bTailSentence = true
    end
    if not Body:ConnectRuntimeNodes(Prev, PIN_OUT, Sentence, PIN_IN) then
      return false
    end
    Prev = Sentence
  end
  local FinishNode = Body:CreateRuntimeNode(UE4.UFlowNode_Finish)
  if not FinishNode then
    return false
  end
  if not Body:ConnectRuntimeNodes(Prev, PIN_OUT, FinishNode, PIN_IN) then
    return false
  end
  return true
end

function M:GenerateSentenceBody(PureBody, SeqBody)
  if not BuildChain(self, PureBody, UE4.UFlowNode_TalkSentence_Pure) then
    return false
  end
  if SeqBody and not BuildChain(self, SeqBody, UE4.UFlowNode_TalkSentence_Sequence) then
    return false
  end
  return true
end

function M:SelectSentenceBody(PureBody, SeqBody)
  if not SeqBody then
    return PureBody
  end
  local TalkTask = self:TryGetTalkTask()
  local TalkTaskData = TalkTask and TalkTask.TalkTaskData
  local BaseType = TalkTaskData and TalkTaskData.BasicTalkType
  local bCanUseSeq = "FixSimple" == BaseType or "Cinematic" == BaseType
  if bCanUseSeq and IsValid(self:GetSequenceByGender()) then
    return SeqBody
  end
  return PureBody
end

function M:Start()
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  if not DialogueFlowGraphComponent then
    local Message = string.format("当前Dialogue节点，注册的Task不存在 DialogueFlowGraphComponent，请注册")
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:DialogueFlowGraphComponent无效", Message)
    return
  end
  local DialogueRecordComponent = self:TryGetRecordComponent()
  if not DialogueRecordComponent then
    local Message = string.format("当前Dialogue节点，注册的Task不存在 DialogueRecordComponent，请注册")
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:DialogueRecordComponent无效", Message)
    return
  end
  local Instance = self:GetSentenceFlowInstance()
  if not IsValid(Instance) then
    local Message = string.format("句流体实例无效（bSentenceBodyValid=%s）", tostring(self.bSentenceBodyValid))
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:句流体实例无效", Message)
    self:ExecuteSelfOut("End")
    return
  end
  local ctx = {
    TalkTask = self:TryGetTalkTask(),
    TalkNode = self,
    SkipTarget = self:GetFlowAsset().RestartDialogueId
  }
  if not Instance:InitializeLua(ctx) then
    self:ExecuteSelfOut("End")
    return
  end
  if not self._OnSentenceNodeStarted then
    function self._OnSentenceNodeStarted(_, Node)
      self:OnSentenceNodeStarted(Node)
    end
  end
  Instance.OnNodeStarted:Add(self, self._OnSentenceNodeStarted)
  local FlowSubsystem = self:GetFlowSubsystem()
  if FlowSubsystem then
    FlowSubsystem:StartFlow(Instance)
  end
end

function M:OnSentenceNodeStarted(Node)
  if Node and Node.DialogueId and 0 ~= Node.DialogueId then
    self:TriggerNormalOutput(Node.DialogueId)
  end
end

function M:Skip()
  local Instance = self:GetSentenceFlowInstance()
  if not IsValid(Instance) then
    return
  end
  local RuntimeProxy = self.RuntimeProxy
  local bSequence = IsValid(RuntimeProxy)
  if bSequence then
    RuntimeProxy:EnterSkip()
  end
  local RootAsset = self:GetFlowAsset()
  RootAsset:CloseTalkActorsOptimization()
  Instance:SkipFlow()
  if bSequence then
    RuntimeProxy:ClearSkip()
  end
end

function M:CanSkip()
  return true
end

function M:Pause()
  local Instance = self:GetSentenceFlowInstance()
  if IsValid(Instance) then
    Instance:PauseFlow()
  end
end

function M:Resume()
  local Instance = self:GetSentenceFlowInstance()
  if IsValid(Instance) then
    Instance:ResumeFlow()
  end
end

return M
