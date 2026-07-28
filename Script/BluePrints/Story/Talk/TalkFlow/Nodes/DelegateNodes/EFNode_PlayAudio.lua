local M = {}

function M:GetTalkAudioComp(FlowOwner)
  if not FlowOwner then
    return nil
  end
  if not FlowOwner.TalkAudioComp and type(FlowOwner.CreateTalkAudioComponent) == "function" then
    FlowOwner:CreateTalkAudioComponent()
  end
  return FlowOwner.TalkAudioComp
end

function M:CreateNode(Flow, FlowOwner, Params)
  local VoiceName = Params and Params.VoiceName
  local TalkAudioComp = self:GetTalkAudioComp(FlowOwner)
  local bAudioCleared = false
  
  local function ClearAudioComp()
    if bAudioCleared then
      return
    end
    bAudioCleared = true
    if TalkAudioComp then
      TalkAudioComp:Clear()
    end
  end
  
  local PlayAudioNode = Flow:CreateNode(UEFNode_Delegate)
  PlayAudioNode.DebugLog = string.format("PlayAudioNode VoiceName: %s", tostring(VoiceName))
  local bNodeFinished = false
  PlayAudioNode.OnStart:Add(PlayAudioNode, function(Node)
    local function FinishNode()
      if bNodeFinished then
        return
      end
      bNodeFinished = true
      if Node.CurrentState == EExecutionFlowNodeState.Paused then
        return
      end
      Node:Finish({
        Node.FinishPin
      })
    end
    
    if not TalkAudioComp then
      FinishNode()
      return
    end
    local SrcActor = Params and Params.SrcActor
    local ExtraInfo = Params and Params.ExtraInfo
    local bIsAttachActor = Params and Params.bIsAttachActor or false
    local SoundHandle = Params and Params.SoundHandle
    local OverrideAttachActor = Params and Params.OverrideAttachActor
    TalkAudioComp:PlayAudio(VoiceName, SrcActor, FinishNode, ExtraInfo, bIsAttachActor, SoundHandle, OverrideAttachActor, false, false)
  end)
  PlayAudioNode.OnSkip:Add(PlayAudioNode, function(Node)
    ClearAudioComp()
    Node:Finish({
      Node.FinishPin
    })
  end)
  PlayAudioNode.OnFinish:Add(PlayAudioNode, function(Node)
    bNodeFinished = true
    ClearAudioComp()
  end)
  PlayAudioNode.OnPause:Add(PlayAudioNode, function(Node)
    if TalkAudioComp then
      TalkAudioComp:OnPaused()
    end
  end)
  PlayAudioNode.OnResume:Add(PlayAudioNode, function(Node)
    if bNodeFinished then
      local TalkContext = GWorld.GameInstance:GetTalkContext()
      local TimerManager = TalkContext and TalkContext.TalkTimerManager
      if TimerManager then
        TimerManager:ClearTimer(Node)
        TimerManager:AddTimer(Node, 0.02, nil, nil, nil, function()
          if Node.CurrentState ~= EExecutionFlowNodeState.Paused then
            Node:Finish({
              Node.FinishPin
            })
          end
        end)
      end
      return
    end
    if TalkAudioComp then
      TalkAudioComp:OnPauseResumed()
    end
  end)
  return PlayAudioNode
end

return M
