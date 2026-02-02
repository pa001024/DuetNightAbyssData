require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:PlayBGVideo(ActivityConfigData, PageConfigData)
  self.VideoPlayer:Stop()
  local BgPath = ActivityConfigData.VideoPath
  if ActivityConfigData.BgBGM then
    self.CurrentBgMusic = ActivityConfigData.BgBGM
    AudioManager(self):PlayUISound(self, ActivityConfigData.BgBGM, "BGVideoSound", nil)
  end
  self.VideoPlayer:SetUrlByMediaSource(LoadObject(BgPath))
  self.VideoPlayer:SetLooping(true)
  self.VideoPlayer:Play()
end

function M:Destruct()
  self.VideoPlayer:Stop()
  AudioManager(self):StopSound(self, "BGVideoSound")
  DebugPrint("ayff test stop bg video music")
end

return M
