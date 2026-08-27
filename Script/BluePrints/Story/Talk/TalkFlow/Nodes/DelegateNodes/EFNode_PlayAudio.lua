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
  local SrcActor = Params and Params.SrcActor
  local ExtraInfo = Params and Params.ExtraInfo
  local SoundHandle = Params and Params.SoundHandle
  local bIsAttachActor = Params and Params.bIsAttachActor or false
  local OverrideAttachActor = Params and Params.OverrideAttachActor
  local bKeepAudioOnSkip = Params and Params.bKeepAudioOnSkip or false
  local TalkAudioComp = self:GetTalkAudioComp(FlowOwner)
  local bAudioCleared = false
  local PlayAudioNode = Flow:CreateNode(UEFNode_Delegate)
  
  local function ClearAudioComp()
    if bAudioCleared then
      return
    end
    bAudioCleared = true
    if TalkAudioComp then
      TalkAudioComp:Clear()
    end
  end
  
  PlayAudioNode.DebugLog = string.format("PlayAudioNode VoiceName: %s, bKeepAudioOnSkip: %s", tostring(VoiceName), bKeepAudioOnSkip and "true" or false)
  local bNodeFinished = false
  local bKeepAudio = false
  PlayAudioNode.OnStart:Add(PlayAudioNode, function(Node)
    local function FinishNode()
      if bNodeFinished then
        return
      end
      bNodeFinished = true
      Node:Finish({
        Node.FinishPin
      })
    end
    
    if not TalkAudioComp then
      FinishNode()
      return
    end
    TalkAudioComp:PlayAudio(VoiceName, SrcActor, FinishNode, ExtraInfo, bIsAttachActor, SoundHandle, OverrideAttachActor, false, false)
  end)
  PlayAudioNode.OnSkip:Add(PlayAudioNode, function(Node)
    if not bKeepAudioOnSkip then
      ClearAudioComp()
    else
      bKeepAudio = true
    end
    Node:Finish({
      Node.FinishPin
    })
  end)
  PlayAudioNode.OnFinish:Add(PlayAudioNode, function(Node)
    bNodeFinished = true
    if not bKeepAudio then
      ClearAudioComp()
    end
  end)
  PlayAudioNode.OnPause:Add(PlayAudioNode, function(Node)
    if TalkAudioComp then
      TalkAudioComp:OnPaused()
    end
  end)
  PlayAudioNode.OnResume:Add(PlayAudioNode, function(Node)
    if TalkAudioComp then
      TalkAudioComp:OnPauseResumed()
    end
  end)
  return PlayAudioNode
end

return M
