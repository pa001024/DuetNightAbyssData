local M = {}

function M:CreateNode(Flow, FlowOwner, Params)
  local DelaySeconds = Params and Params.Delay or 0
  local GroupTag = Params and Params.GroupTag
  local TalkContext = GWorld.GameInstance:GetTalkContext()
  local TimerManager = TalkContext and TalkContext.TalkTimerManager
  local DelayNode = Flow:CreateNode(UEFNode_Delegate)
  DelayNode.DebugLog = string.format("WaitForSecondsNode Delay: %.3f", DelaySeconds)
  DelayNode.OnStart:Add(DelayNode, function(Node)
    local bNodeFinished = false
    
    local function FinishNode()
      if bNodeFinished then
        return
      end
      bNodeFinished = true
      Node:Finish({
        Node.FinishPin
      })
    end
    
    if DelaySeconds <= 0 then
      FinishNode()
      return
    end
    if not TimerManager then
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
  return DelayNode
end

return M
