local M = {}

function M:CreateNode(Flow, FlowOwner, Params)
  local DelaySeconds = Params and Params.Delay or 0
  local Condition = Params and Params.Condition
  local GroupTag = Params and Params.GroupTag
  local TalkContext = GWorld.GameInstance:GetTalkContext()
  local TimerManager = TalkContext and TalkContext.TalkTimerManager
  local DelayNode = Flow:CreateNode(UEFNode_Delegate)
  DelayNode.DebugLog = string.format("ConditionalDelayNode Delay: %.3f", DelaySeconds)
  local bNodeFinished = false
  DelayNode.OnStart:Add(DelayNode, function(Node)
    local function FinishNode()
      if bNodeFinished then
        return
      end
      bNodeFinished = true
      Node:Finish({
        Node.FinishPin
      })
    end
    
    if type(Condition) == "function" and not Condition(FlowOwner) then
      FinishNode()
      return
    end
    if DelaySeconds <= 0 or not TimerManager then
      FinishNode()
      return
    end
    TimerManager:AddTimer(GroupTag, DelaySeconds, nil, nil, nil, FinishNode)
  end)
  DelayNode.OnSkip:Add(DelayNode, function(Node)
    Node:Finish({
      Node.FinishPin
    })
  end)
  DelayNode.OnPause:Add(DelayNode, function()
    if TimerManager then
      TimerManager:PauseTimer(GroupTag)
    end
  end)
  DelayNode.OnResume:Add(DelayNode, function()
    if TimerManager then
      TimerManager:UnPauseTimer(GroupTag)
    end
  end)
  DelayNode.OnFinish:Add(DelayNode, function()
    bNodeFinished = true
  end)
  return DelayNode
end

return M
