local M = Class("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.FlowNode_TalkNodeBase")
local PureDriver = require("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.Dialogue.DialogueDriver_Pure")
local SequenceDriver = require("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.Dialogue.DialogueDriver_Sequence")
local FlowLogType = UE.EStoryLogType.TalkFlow

function M:ReceiveBeginPlay()
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
  self.__driver = nil
  local TalkTask = self:TryGetTalkTask()
  local TalkTaskData = TalkTask and TalkTask.TalkTaskData
  local BaseType = TalkTaskData and TalkTaskData.BasicTalkType
  local bCanUseSeq = "FixSimple" == BaseType or "Cinematic" == BaseType
  if bCanUseSeq and IsValid(self:GetSequenceByGender()) then
    self.__driver = SequenceDriver.New(self)
    if not self.__driver:Start() then
      self.__driver = nil
    end
  end
  if not self.__driver then
    self.__driver = PureDriver.New(self)
    self.__driver:Start()
  end
end

function M:Skip()
  if not self.__driver or not self.__driver.Skip then
    return
  end
  return self.__driver:Skip()
end

function M:CanSkip()
  if not self.__driver or not self.__driver.CanSkip then
    return true
  end
  return self.__driver:CanSkip()
end

function M:Pause()
  if not self.__driver or not self.__driver.Pause then
    return
  end
  return self.__driver:Pause()
end

function M:Resume()
  if not self.__driver or not self.__driver.Resume then
    return
  end
  return self.__driver:Resume()
end

function M:K2_Cleanup()
  if not self.__driver or not self.__driver.Cleanup then
    return
  end
  local Driver = self.__driver
  self.__driver = nil
  return Driver:Cleanup()
end

return M
