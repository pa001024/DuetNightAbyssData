local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local M = {}

function M:CreateNode(Flow, FlowOwner, Params)
  local DialogueData = Params and Params.DialogueData
  local NameWidget = Params and Params.NameWidget
  local TypingWidget = Params and Params.TypingWidget
  local NpcName = DialogueData and DialogueData.SpeakNpcName
  NpcName = NpcName or TalkUtils:GetTalkActorName("Npc", DialogueData.SpeakNpcId) or ""
  NpcName = GText(NpcName)
  local Content = DialogueData and TalkUtils:DialogueIdToContent(DialogueData.DialogueId) or ""
  Content = GText(Content)
  local TypingNode = Flow:CreateNode(UEFNode_Delegate)
  TypingNode.DebugLog = string.format("TypingTextNode: %s", tostring(NpcName))
  
  local function OnFinishCleanUp()
    if IsValid(TypingWidget) and TypingWidget.UnBindEventOnFinished then
      TypingWidget:UnBindEventOnFinished()
    end
  end
  
  TypingNode.OnStart:Add(TypingNode, function(Node)
    local bNodeFinished = false
    
    local function FinishNode()
      if bNodeFinished then
        return
      end
      bNodeFinished = true
      OnFinishCleanUp()
      Node:Finish({
        Node.FinishPin
      })
    end
    
    if not (IsValid(NameWidget) and IsValid(TypingWidget)) or "" == Content then
      FinishNode()
      return
    end
    NameWidget:SetText(NpcName)
    TypingWidget:SetTypingSpeed(0.05)
    TypingWidget:UnBindEventOnFinished()
    TypingWidget:BindEventOnFinished(Node, function(_, FinishOrPageEnd)
      if FinishOrPageEnd then
        FinishNode()
        return
      end
      TypingWidget:NextPage()
    end)
    TypingWidget:Typing(Content)
  end)
  TypingNode.OnSkip:Add(TypingNode, function(Node)
    if IsValid(TypingWidget) then
      if not TypingWidget:ToFinish() then
        TypingWidget.bPrepareToFinish = true
      end
      return
    end
    OnFinishCleanUp()
    Node:Finish({
      Node.FinishPin
    })
  end)
  TypingNode.OnFinish:Add(TypingNode, function()
    OnFinishCleanUp()
  end)
  TypingNode.OnPause:Add(TypingNode, function()
    if IsValid(TypingWidget) then
      TypingWidget:Pause(true)
    end
  end)
  TypingNode.OnResume:Add(TypingNode, function()
    if IsValid(TypingWidget) then
      TypingWidget:Pause(false)
    end
  end)
  return TypingNode
end

return M
