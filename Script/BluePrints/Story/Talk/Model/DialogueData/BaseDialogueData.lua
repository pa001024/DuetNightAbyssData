local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local BaseDialogueData_C = {}

function BaseDialogueData_C.New(TalkTask, DialogueId)
  local Obj = {}
  local DialogueData = DataMgr.Dialogue[DialogueId]
  if not DialogueData then
    local Message = "DialogueId在Dialogue表中不存在" .. [[

DialogueId:]] .. DialogueId
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Talk, "BaseDialogueData创建失败：DialogueId不存在", Message)
    return
  end
  local TalkContext = GWorld.GameInstance:GetTalkContext()
  Obj.Scripts = DialogueData.Scripts
  Obj.DialogueId = DialogueId
  Obj.TalkActorData = TalkContext:GetTalkActorData(TalkTask, DialogueData.SpeakNpcId)
  Obj.TalkActorName = GText(DialogueData.SpeakNpcName)
  Obj.TalkActorId = DialogueData.SpeakNpcId
  Obj.Content = TalkUtils:DialogueIdToContent(DialogueId) or " "
  Obj.bHasTalkActionData = (DialogueData.TalkActionId or DialogueData.TurnTo) and true or false
  Obj.AudioGUID = DialogueData.GUID
  Obj.VoiceName = DialogueData.VoiceName
  Obj.DisableMouth = DialogueData.DisableMouth
  Obj.Duration = DialogueData.Duration or 1
  Obj.LookAtType = DialogueData.DefaultLookAt
  Obj.DialoguePanelType = DialogueData.DialoguePanelType
  Obj.HeadIconType = DialogueData.HeadIconType
  Obj.GuideFacialId = DialogueData.GuideFacialId
  Obj.CameraBlendCurve = DialogueData.CameraBlendCurve
  return Obj
end

return BaseDialogueData_C
