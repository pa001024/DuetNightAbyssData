local Component = {}
local FacialUtils = require("BluePrints.Story.Talk.View.FacialUtils")

function Component:OnDialogueStarted_PortraitComp(DialogueData)
  self:RefreshPortraitFacial(DialogueData)
end

function Component:OnTalkAudioStateChanged_PortraitComp(AudioState)
  if "Play" == AudioState then
    self.Avatar:StopAllAnimations()
    self.Avatar:PlayAnimation(self.Avatar.Loop, 0, 0)
  elseif "Stop" == AudioState then
    self.Avatar:StopAllAnimations()
    self.Avatar:PlayAnimation(self.Avatar.Normal)
  else
    return
  end
end

function Component:RefreshPortraitFacial(DialogueData)
  if not DialogueData.VoiceName then
    self.Avatar:StopAllAnimations()
    self.Avatar:PlayAnimation(self.Avatar.Normal)
  end
  local Prefix = FacialUtils:GetNpcFacialPrefix(DialogueData.DialogueId, DialogueData.TalkActorId)
  if not Prefix then
    self.Avatar:SetVisibility(ESlateVisibility.Collapsed)
    return
  else
    self.Avatar:SetVisibility(ESlateVisibility.HitTestInvisible)
  end
  local FacialId = DialogueData.Facial2DId or "Idle"
  local EyeName, MouthName = self:GetPortraitIconName(Prefix, FacialId)
  if not EyeName or not MouthName then
    return
  end
  self.Avatar:SetEmotion(EyeName, MouthName)
end

function Component:GetPortraitIconName(Prefix, FacialId)
  if not Prefix or type(Prefix) ~= "string" then
    return
  end
  local FacialData = DataMgr.Facial2D[FacialId]
  if not FacialData then
    local Message = string.format("获取Npc表情Id失败，表情Id无效，反馈策划检查Facial2D表配置，表情Id：%s", FacialId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.NPC, "获取Npc表情Id失败: FacialId无效", Message)
    return
  end
  local EyeFacial, MouthFacial = FacialData.NpcEye, FacialData.NpcMouth
  local EyeName = Prefix .. EyeFacial .. "_Eyes"
  local MouthName = Prefix .. MouthFacial .. "_Mouth"
  return EyeName, MouthName
end

return Component
