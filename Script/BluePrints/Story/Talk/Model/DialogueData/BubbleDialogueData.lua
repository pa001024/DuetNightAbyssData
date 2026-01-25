local BaseDialogueData_C = require("BluePrints.Story.Talk.Model.DialogueData.BaseDialogueData")
local BubbleDialogueData_C = {}

function BubbleDialogueData_C.New(TalkTask, DialogueId)
  local DialogueData = DataMgr.Dialogue[DialogueId]
  if not DialogueData then
    local Message = "DialogueId在Dialogue表中不存在" .. [[

DialogueId:]] .. DialogueId
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Talk, "BubbleDialogueData创建失败：DialogueId不存在", Message)
    return
  end
  local Obj = BaseDialogueData_C.New(TalkTask, DialogueId)
  Obj.CameraInfo = DialogueData.Camera
  Obj.FinalCameraInfo = DialogueData.FinalCamera
  Obj.ToFinalCameraBlendTime = DialogueData.ToFinalCameraBlendTime or 0
  Obj.CameraTransform = DialogueData.CameraTransform
  Obj.CameraBlendTime = DialogueData.BlendTime or 0
  Obj.DialogueGraphPath = DialogueData.GraphPath
  Obj.AnimPath = DialogueData.AnimPath
  Obj.GuidemanConfigId = DialogueData.GuidemanConfigId
  Obj.GuidemanExpressionId = DialogueData.GuidemanFacialId
  Obj.GuidemanActionId = DialogueData.GuidemanActionId
  Obj.bIsBlack = 1 == DialogueData.IsBlack and true or false
  return Obj
end

return BubbleDialogueData_C
