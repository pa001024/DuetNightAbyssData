local M = {}

local function CopyDialogueData(DialogueData, Duration)
  local PlaybackData = {}
  for Key, Value in pairs(DialogueData) do
    PlaybackData[Key] = Value
  end
  PlaybackData.Duration = Duration
  return PlaybackData
end

function M:CreateNode(Flow, FlowOwner, Params)
  local DialogueData = Params and Params.DialogueData
  if not DialogueData then
    return
  end
  local UINode = Flow:CreateNode(UEFNode_Delegate)
  UINode.DebugLog = string.format("PlayGuideUINode: %s", tostring(DialogueData.DialogueId))
  local bNodeFinished = false
  local bUIPlaying = false
  local PlayGeneration = 0
  local PlayStartTime = 0
  local InitialDuration = DialogueData.Duration
  local RemainingDuration = InitialDuration
  
  local function FinishNode(Node)
    if bNodeFinished then
      return
    end
    bNodeFinished = true
    bUIPlaying = false
    Node:Finish({
      Node.FinishPin
    })
  end
  
  local function PlayGuideUI(Node)
    local GuideUI = FlowOwner.UI
    if not IsValid(GuideUI) or not GuideUI.PlayDialogue then
      FinishNode(Node)
      return
    end
    PlayGeneration = PlayGeneration + 1
    local CurrentGeneration = PlayGeneration
    bUIPlaying = true
    PlayStartTime = UE4.UGameplayStatics.GetTimeSeconds(GWorld.GameInstance)
    local PlaybackData = CopyDialogueData(DialogueData, RemainingDuration)
    GuideUI:PlayDialogue(FlowOwner, PlaybackData, FlowOwner.TalkTaskData, function()
      if bNodeFinished or CurrentGeneration ~= PlayGeneration then
        return
      end
      FinishNode(Node)
    end)
  end
  
  UINode.OnStart:Add(UINode, function(Node)
    if bNodeFinished then
      return
    end
    RemainingDuration = InitialDuration
    PlayGuideUI(Node)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:CompletedDialogue(DialogueData.DialogueId)
    end
  end)
  UINode.OnPause:Add(UINode, function(Node)
    if bNodeFinished or not bUIPlaying then
      return
    end
    local GuideUI = FlowOwner.UI
    if IsValid(GuideUI) and GuideUI.OnPaused then
      GuideUI:OnPaused()
    end
    local CurrentTime = UE4.UGameplayStatics.GetTimeSeconds(GWorld.GameInstance)
    local Elapsed = math.max(CurrentTime - PlayStartTime, 0)
    RemainingDuration = math.max(RemainingDuration - Elapsed, 0)
    PlayGeneration = PlayGeneration + 1
    bUIPlaying = false
  end)
  UINode.OnResume:Add(UINode, function(Node)
    if bNodeFinished or bUIPlaying then
      return
    end
    local GuideUI = FlowOwner.UI
    if IsValid(GuideUI) and GuideUI.OnPauseResumed then
      GuideUI:OnPauseResumed()
    end
    PlayGuideUI(Node)
  end)
  UINode.OnFinish:Add(UINode, function()
    bNodeFinished = true
    bUIPlaying = false
  end)
  return UINode
end

return M
