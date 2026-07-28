require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:BeforePlayBGVideo()
  self:RemoveTimer("ExchangeToLoopMode")
  self.VideoPlayer:Stop()
  self.LoopVideoPlayer:Stop()
  self.WidgetSwitcher_VideoPlayer:SetActiveWidgetIndex(0)
end

function M:PlayBGVideo(ActivityConfigData, PageConfigData, bSkipBGM)
  self.ActivityConfigData = ActivityConfigData
  self.PageConfigData = PageConfigData
  if not IsValid(self.VideoPlayer) then
    return
  end
  local BgPath = ActivityConfigData and ActivityConfigData.VideoPath
  if not BgPath or "" == BgPath then
    return
  end
  local MediaSource = LoadObject(BgPath)
  if not IsValid(MediaSource) then
    return
  end
  if ActivityConfigData.BgBGM and not bSkipBGM then
    self.CurrentBgMusic = ActivityConfigData.BgBGM
    AudioManager(self):PlayUISound(self, ActivityConfigData.BgBGM, "BGVideoSound", nil)
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.VideoPlayer:SetUrlByMediaSource(MediaSource)
  self.VideoPlayer:Play()
  self.LoopVideoPlayer:SetUrlByMediaSource(MediaSource)
  self.LoopVideoPlayer:SetLooping(true)
  self.LoopVideoPlayer:Play()
  self:RemoveTimer("ExchangeToLoopMode")
  self:AddTimer(0.5, function()
    self.VideoPlayer:Stop()
    self.WidgetSwitcher_VideoPlayer:SetActiveWidgetIndex(1)
  end, false, 0, "ExchangeToLoopMode", true)
end

function M:ReplayBGVideo()
  if not self.ActivityConfigData then
    return
  end
  self:BeforePlayBGVideo()
  self:PlayBGVideo(self.ActivityConfigData, self.PageConfigData, true)
end

function M:PauseBGVideo()
  if self.VideoPlayer and type(self.VideoPlayer.Pause) == "function" then
    self.VideoPlayer:Pause()
  end
  if self.LoopVideoPlayer and "function" == type(self.LoopVideoPlayer.Pause) then
    self.LoopVideoPlayer:Pause()
  end
end

function M:Destruct()
  if self.VideoPlayer and type(self.VideoPlayer.Stop) == "function" then
    self.VideoPlayer:Stop()
  end
  if self.LoopVideoPlayer and "function" == type(self.LoopVideoPlayer.Stop) then
    self.LoopVideoPlayer:Stop()
  end
  AudioManager(self):StopSound(self, "BGVideoSound")
  DebugPrint("ayff test stop bg video music")
end

return M
