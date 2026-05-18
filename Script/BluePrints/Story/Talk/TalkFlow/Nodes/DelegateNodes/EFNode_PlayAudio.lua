local M = {}

function M:GetTalkAudioComp(TalkTask)
  if TalkTask then
    if not TalkTask.TalkAudioComp then
      TalkTask:CreateTalkAudioComponent()
    end
    return TalkTask.TalkAudioComp
  end
  return nil
end

function M:CreateNode(Flow, TalkTask, Params)
  local VoiceName = Params and Params.VoiceName
  local TalkAudioComp = self:GetTalkAudioComp(TalkTask)
  local bAudioCleared = false
  
  local function ClearAudio()
    if bAudioCleared then
      return
    end
    bAudioCleared = true
    if TalkAudioComp then
      if TalkTask and TalkTask.ClearAudio then
        TalkTask:ClearAudio()
      else
        TalkAudioComp:Clear()
      end
    end
  end
  
  local PlayAudioNode = Flow:CreateNode(UEFNode_Delegate)
  PlayAudioNode.DebugLog = string.format("PlayAudioNode VoiceName: %s", tostring(VoiceName))
  PlayAudioNode.OnStart:Add(PlayAudioNode, function(Node)
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
    ClearAudio()
    Node:Finish({
      Node.FinishPin
    })
  end)
  PlayAudioNode.OnFinish:Add(PlayAudioNode, function(Node)
    ClearAudio()
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
