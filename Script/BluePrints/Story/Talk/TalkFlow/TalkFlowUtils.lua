local FEFNode_PlayAudio = require("BluePrints.Story.Talk.TalkFlow.Nodes.DelegateNodes.EFNode_PlayAudio")
local FEFNode_WaitForSeconds = require("BluePrints.Story.Talk.TalkFlow.Nodes.DelegateNodes.EFNode_WaitForSeconds")
local FEFNode_TypingText = require("BluePrints.Story.Talk.TalkFlow.Nodes.DelegateNodes.EFNode_TypingText")
local BaseDialogueData_C = require("BluePrints.Story.Talk.Model.DialogueData.BaseDialogueData")
local BubbleDialogueData_C = require("BluePrints.Story.Talk.Model.DialogueData.BubbleDialogueData")
local GuideDialogueData_C = require("BluePrints.Story.Talk.Model.DialogueData.GuideDialogueData")
local RougeLikeDialogueData_C = require("BluePrints.Story.Talk.Model.DialogueData.RougeLikeDialogueData")
local SimpleDialogueData_C = require("BluePrints.Story.Talk.Model.DialogueData").SimpleDialogueData_C
local CinematicDialogueData_C = require("BluePrints.Story.Talk.Model.DialogueData").CinematicDialogueData_C
local FlowStructures = require("BluePrints.Story.Talk.TalkFlow.FlowStructures")
local ExecutionFlowUtils = require("BluePrints.Story.ExecutionFlow.ExecutionFlowUtils")
local DialogueDataTypeMap = {
  Base = BaseDialogueData_C,
  Bubble = BubbleDialogueData_C,
  Guide = GuideDialogueData_C,
  RougeLike = RougeLikeDialogueData_C,
  Simple = SimpleDialogueData_C,
  Cinematic = CinematicDialogueData_C
}
local M = {}

function M:Link(FromNode, ToNode)
  if not (FromNode and ToNode and FromNode.FinishPin) or not ToNode.StartPin then
    DebugPrint("TalkFlowUtils@Link Failed", FromNode, ToNode)
    return false
  end
  FromNode.FinishPin:LinkTo(ToNode.StartPin)
  return true
end

function M:LinkChain(NodeChain)
  if not NodeChain or #NodeChain < 2 then
    DebugPrint("TalkFlowUtils@LinkChain Failed: NodeChain Invalid", NodeChain and #NodeChain or 0)
    return false
  end
  for i = 1, #NodeChain - 1 do
    local FromNode = NodeChain[i]
    local ToNode = NodeChain[i + 1]
    if not (FromNode and ToNode and FromNode.FinishPin) or not ToNode.StartPin then
      DebugPrint("TalkFlowUtils@LinkChain Failed", i, FromNode, ToNode)
      return false
    end
  end
  for i = 1, #NodeChain - 1 do
    local FromNode = NodeChain[i]
    local ToNode = NodeChain[i + 1]
    FromNode.FinishPin:LinkTo(ToNode.StartPin)
  end
  return true
end

function M:GetTalkSubsystem()
  return USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UTalkSubsystem)
end

function M:BuildContext(DialogueId, FlowType, FlowOwner, DialogueDataType)
  local RawDialogueData = DataMgr.Dialogue[DialogueId]
  local DialogueData = RawDialogueData
  if DialogueDataType then
    local DialogueDataDecorator_C = DialogueDataTypeMap[DialogueDataType]
    if DialogueDataDecorator_C and type(DialogueDataDecorator_C.New) == "function" then
      local DecoratedDialogueData = DialogueDataDecorator_C.New(FlowOwner, DialogueId)
      if DecoratedDialogueData then
        DialogueData = DecoratedDialogueData
      end
    end
  end
  local TalkTaskData = FlowOwner and FlowOwner.TalkTaskData
  local UI = FlowOwner and FlowOwner.UI
  return {
    DialogueId = DialogueId,
    DialogueData = DialogueData,
    RawDialogueData = RawDialogueData,
    TalkTaskData = TalkTaskData,
    FlowOwner = FlowOwner,
    FlowType = FlowType,
    UI = UI
  }
end

function M:CreateBaseFlow(DialogueId, OnFinished)
  local TalkSubsystem = self:GetTalkSubsystem()
  if nil == TalkSubsystem then
    DebugPrint("TalkFlowUtils@CreateBaseFlow: talk subsystem is nil")
    return nil
  end
  local Flow = TalkSubsystem:CreateDialogueFlow(DialogueId)
  if not Flow then
    DebugPrint("TalkFlowUtils@CreateBaseFlow: create dialogue flow failed", DialogueId)
    return nil
  end
  Flow.DialogueId = DialogueId
  Flow.OnFinish:Add(TalkSubsystem, function()
    TalkSubsystem:DestroyDialogueFlow(DialogueId)
    if OnFinished then
      OnFinished()
    end
  end)
  Flow.OnStop:Add(TalkSubsystem, function()
    TalkSubsystem:DestroyDialogueFlow(DialogueId)
    if OnFinished then
      OnFinished()
    end
  end)
  local StartNode = Flow.StartNode
  local FinishNode = Flow.FinishNode
  local ParallelNode = Flow:CreateNode(UEFNode_Parallel)
  local WaitAllNode = Flow:CreateNode(UEFNode_WaitAll)
  self:LinkChain({
    StartNode,
    ParallelNode,
    WaitAllNode,
    FinishNode
  })
  return Flow, ParallelNode, WaitAllNode
end

function M:GetTokenRoot(Context, RootName)
  if "Dialogue" == RootName then
    return Context and Context.DialogueData
  elseif "RawDialogue" == RootName then
    return Context and Context.RawDialogueData
  elseif "DialogueId" == RootName then
    return Context and Context.DialogueId
  elseif "Owner" == RootName then
    return Context and Context.FlowOwner
  elseif "TalkTaskData" == RootName then
    return Context and Context.TalkTaskData
  elseif "FlowType" == RootName then
    return Context and Context.FlowType
  elseif "UI" == RootName then
    return Context and Context.UI
  end
end

local TokenRootNames = {
  Dialogue = 1,
  RawDialogue = 1,
  DialogueId = 1,
  Owner = 1,
  TalkTaskData = 1,
  FlowType = 1,
  UI = 1
}

function M:IsTokenRootName(RootName)
  return nil ~= TokenRootNames[RootName]
end

function M:ResolvePathValue(RootValue, Path)
  local Result = RootValue
  for Key in string.gmatch(Path or "", "[^%.]+") do
    if nil == Result then
      return nil
    end
    Result = Result[Key]
  end
  return Result
end

function M:ResolveToken(Context, Value)
  if type(Value) ~= "string" then
    return Value
  end
  local TokenPath = string.match(Value, "^%$(.+)$")
  if not TokenPath then
    return Value
  end
  local RootName, SubPath = string.match(TokenPath, "^([^%.]+)%.(.+)$")
  RootName = RootName or TokenPath
  if not self:IsTokenRootName(RootName) then
    return Value
  end
  local RootValue = self:GetTokenRoot(Context, RootName)
  if nil == RootValue then
    return nil
  end
  if not SubPath then
    return RootValue
  end
  return self:ResolvePathValue(RootValue, SubPath)
end

function M:ResolveSingleParam(Context, Value)
  if type(Value) == "table" then
    return self:ResolveTableParam(Context, Value)
  end
  if type(Value) ~= "string" then
    return Value
  end
  local IsValidArg = string.match(Value, "^%$IsValid%((.+)%)$")
  if IsValidArg then
    return IsValid(self:ResolveToken(Context, IsValidArg))
  end
  return self:ResolveToken(Context, Value)
end

function M:ResolveTableParam(Context, Params)
  if type(Params) ~= "table" then
    return Params
  end
  local Result = {}
  for K, V in pairs(Params) do
    Result[K] = self:ResolveSingleParam(Context, V)
  end
  return Result
end

function M:CreateOperationNode(FunctionName, Flow, Context, Params)
  local bNeedResolve = "PARA" ~= FunctionName and "SEQ" ~= FunctionName
  local FinalParams = bNeedResolve and self:ResolveTableParam(Context, Params) or Params
  local Creator = self[FunctionName]
  if type(Creator) == "function" then
    return Creator(self, Flow, Context, FinalParams)
  end
  local Owner = Context and Context.FlowOwner
  if not Owner then
    DebugPrint("TalkFlowUtils@CreateOperationNode: owner is nil", FunctionName)
    return
  end
  local FactoryName = "Create" .. tostring(FunctionName) .. "Node"
  local Factory = Owner[FactoryName]
  if type(Factory) ~= "function" then
    DebugPrint("TalkFlowUtils@CreateOperationNode: creator not found", FunctionName, FactoryName)
    return
  end
  local Node = Factory(Owner, Flow, FinalParams)
  if not Node then
    DebugPrint("TalkFlowUtils@CreateOperationNode: owner factory create failed", FunctionName, FactoryName)
    return
  end
  return Node.StartPin, Node.FinishPin
end

function M:SEQ(Flow, Context, Operations)
  local StartPin, FinishPin
  for _, Operation in ipairs(Operations or {}) do
    for FunctionName, Params in pairs(Operation) do
      local NodeStartPin, NodeFinishPin = self:CreateOperationNode(FunctionName, Flow, Context, Params)
      if NodeStartPin and NodeFinishPin then
        StartPin = StartPin or NodeStartPin
        if FinishPin then
          FinishPin:LinkTo(NodeStartPin)
        end
        FinishPin = NodeFinishPin
      end
    end
  end
  return StartPin, FinishPin
end

function M:PARA(Flow, Context, Operations)
  local StartPin, FinishPin
  local ParallelNode = Flow:CreateNode(UEFNode_Parallel)
  local WaitAllNode = Flow:CreateNode(UEFNode_WaitAll)
  local bHasValidBranch = false
  for _, Operation in ipairs(Operations or {}) do
    for FunctionName, Params in pairs(Operation) do
      local NodeStartPin, NodeFinishPin = self:CreateOperationNode(FunctionName, Flow, Context, Params)
      if NodeStartPin and NodeFinishPin then
        bHasValidBranch = true
        if not StartPin then
          StartPin = ParallelNode.StartPin
          FinishPin = WaitAllNode.FinishPin
        end
        ParallelNode.FinishPin:LinkTo(NodeStartPin)
        NodeFinishPin:LinkTo(WaitAllNode.StartPin)
      end
    end
  end
  if not bHasValidBranch then
    self:Link(ParallelNode, WaitAllNode)
  end
  return StartPin, FinishPin
end

function M:CreateFlow(DialogueId, FlowType, FlowOwner, OnFinished)
  local StructureData = FlowType and FlowStructures[FlowType] or nil
  local Structure = StructureData
  local DialogueDataType
  if type(StructureData) == "table" and StructureData.Operations then
    Structure = StructureData.Operations
    DialogueDataType = StructureData.DialogueDataType
  end
  local Context = self:BuildContext(DialogueId, FlowType, FlowOwner, DialogueDataType)
  local Flow, ParallelNode, WaitAllNode = self:CreateBaseFlow(DialogueId, OnFinished)
  if not Flow then
    return nil
  end
  if Structure then
    local NodeStartPin, NodeFinishPin = self:PARA(Flow, Context, Structure)
    if NodeStartPin and NodeFinishPin then
      ParallelNode.FinishPin:LinkTo(NodeStartPin)
      NodeFinishPin:LinkTo(WaitAllNode.StartPin)
    end
  else
    DebugPrint("TalkFlowUtils@CreateFlow: FlowStructure Not Found", FlowType, DialogueId)
  end
  return Flow, ParallelNode, WaitAllNode
end

function M:PlayScript(Flow, Context, Params)
  local DialogueScriptTable = DataMgr.DialogueConvert[Context.DialogueId]
  if not DialogueScriptTable or not DialogueScriptTable.Operations then
    return nil
  end
  local NodeStartPin, NodeFinishPin = ExecutionFlowUtils:PARA(Flow, Context.FlowOwner, DialogueScriptTable.Operations)
  return NodeStartPin, NodeFinishPin
end

function M:Delay(Flow, Context, Params)
  local Node = FEFNode_WaitForSeconds:CreateNode(Flow, Context.FlowOwner, Params)
  if not Node then
    return
  end
  return Node.StartPin, Node.FinishPin
end

function M:PlayAudio(Flow, Context, Params)
  local Node = FEFNode_PlayAudio:CreateNode(Flow, Context.FlowOwner, Params)
  if not Node then
    return
  end
  return Node.StartPin, Node.FinishPin
end

function M:TypingText(Flow, Context, Params)
  local Node = FEFNode_TypingText:CreateNode(Flow, Context.FlowOwner, Params)
  if not Node then
    return
  end
  return Node.StartPin, Node.FinishPin
end

return M
