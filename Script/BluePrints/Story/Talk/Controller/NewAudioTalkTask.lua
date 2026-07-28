local TalkAudioComp_C = require("BluePrints.Story.Talk.Controller.TalkAudioComp")
local M = Class("BluePrints.Story.Talk.Controller.TalkTaskBase")

function M:Start(TalkTaskData, NodeFinished_Callback)
  M.Super.Start(self, TalkTaskData, NodeFinished_Callback)
  self.TalkTaskData = TalkTaskData
  self.NodeFinished_Callback = NodeFinished_Callback
  self.bCleared = false
  self.TalkAudioComp = TalkAudioComp_C.New()
  AudioManager(GWorld.GameInstance):AddAuANotifyForbidTag(self.UnitKey)
  if not self.TalkTaskData.FirstDialogueId or not DataMgr.Dialogue[self.TalkTaskData.FirstDialogueId] then
    self:EndDialogue()
    return
  end
  self:StartTalkFlow()
end

function M:EndDialogue()
  if self.bCleared then
    return
  end
  self:Clear()
  self:TryFireEndingCallback()
end

function M:Clear()
  if self.bCleared then
    return
  end
  self.bCleared = true
  M.Super.Clear(self)
  AudioManager(GWorld.GameInstance):RemoveAuANotifyForbidTag(self.UnitKey)
  self:ClearAudio()
end

function M:OnInterrupted()
  self:StopTalkFlow()
  self:Clear()
end

function M:OnPaused()
  self:PauseTalkFlow()
end

function M:OnPauseResumed()
  self:ResumeTalkFlow()
end

return M
