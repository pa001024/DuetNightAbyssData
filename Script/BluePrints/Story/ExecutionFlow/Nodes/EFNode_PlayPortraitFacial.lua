local M = {}
local FNpcDataManager = require("BluePrints.Managers.NpcDataManager")
local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
  local FacialId = tostring(Params.FacialId)
  local PlayPortraitFacialNode = Flow:CreateNode(UEFNode_Delegate)
  PlayPortraitFacialNode.DebugLog = string.format("PlayPortraitFacial FacialId: %s", FacialId)
  PlayPortraitFacialNode.OnStart:Add(PlayPortraitFacialNode, function(Node)
    local PortraitComp = TalkTask and IsValid(TalkTask.UI) and TalkTask.UI.PortraitComp
    if PortraitComp then
      local DialogueData = DataMgr.Dialogue[Flow.DialogueId]
      local SpeakNpcId = DialogueData and DialogueData.SpeakNpcId
      local bSpeakerExists = nil ~= DialogueData and (nil ~= SpeakNpcId or not string.isempty(DialogueData.SpeakNpcName))
      local PortraitFacialRow
      if 0 ~= SpeakNpcId then
        PortraitFacialRow = FNpcDataManager:GetPortraitFacialRow(SpeakNpcId, FacialId)
      end
      PortraitComp:SetFacial(bSpeakerExists, PortraitFacialRow)
    else
      local Message = string.format("PlayPortraitFacial start failed: PortraitComp Invalid, FacialId: %s, DialogueId: %d", FacialId, Flow.DialogueId)
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "PlayPortraitFacial脚本执行出错: 头像表情控件无效", Message)
    end
    Node:Finish({
      Node.FinishPin
    })
  end)
  PlayPortraitFacialNode.OnSkip:Add(PlayPortraitFacialNode, function(Node)
    Node:Finish({
      Node.FinishPin
    })
  end)
  return PlayPortraitFacialNode
end

return M
