require("UnLua")
local WBP_VideoPlayer_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_VideoPlayer_C:Initialize(Initializer)
  self.Super.Initialize(self, Initializer)
  rawset(self, "PauseOnFirstFrameTimer", nil)
  rawset(self, "PauseOnFirstFrameTick", 0)
  rawset(self, "bShouldPauseOnFirstFrame", false)
end

function WBP_VideoPlayer_C:Construct()
  WBP_VideoPlayer_C.Super.Construct(self)
  self.IsInit = true
  self:HideVideoSurfaceForLoading()
end

function WBP_VideoPlayer_C:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.IsFullScreen, self.NeedAudio = ...
  if self.IsFullScreen == nil then
    self.IsFullScreen = true
  end
  if self.NeedAudio == nil then
    self.NeedAudio = true
  end
  self:SetIsNeedAudio(self.NeedAudio)
end

function WBP_VideoPlayer_C:SetIsNeedAudio(bIsNeedAudio)
  if bIsNeedAudio then
    self:CreateAudioActor()
  else
  end
end

function WBP_VideoPlayer_C:Skip()
  self:Stop()
end

function WBP_VideoPlayer_C:BindEventToMediaPlayEnd(Obj, Event)
  if not Obj or not Event then
    return
  end
  self.Obj = Obj
  self.Event = Event
end

function WBP_VideoPlayer_C:OnMediaPlayEnd()
  if self.Obj and self.Event then
    self.Event(self.Obj)
  end
  if self.IsFullScreen then
    self:Stop()
  else
    self:FireCallback()
  end
end

function WBP_VideoPlayer_C:FireCallback()
  AudioManager(self):StopSound(self, "VideoPlayerSound")
  if self.OnPlayEnd:IsBound() then
    DebugPrint("CY@ OnMediaPlayEnd Broadcast")
    self.OnPlayEnd:Broadcast(self)
  end
end

function WBP_VideoPlayer_C:Stop()
  self:FireCallback()
  self:Close()
end

function WBP_VideoPlayer_C:ShowVideoSurface()
  if self.Image_Video then
    self.Image_Video:SetRenderOpacity(1)
    self.Image_Video:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Image_Mask then
    self.Image_Mask:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function WBP_VideoPlayer_C:HideVideoSurfaceForLoading()
  if self.Image_Video then
    self.Image_Video:SetRenderOpacity(0)
    self.Image_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Image_Mask then
    self.Image_Mask:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function WBP_VideoPlayer_C:ClearVideoSurface()
  if self.MediaPlayer then
    self.MediaPlayer:Close()
  end
  if self.MediaPlayer_VideoTexture then
    pcall(function()
      self.MediaPlayer_VideoTexture:SetMediaPlayer(nil)
    end)
  end
  if self.Image_Video then
    self.Image_Video:SetRenderOpacity(0)
    self.Image_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Image_Mask then
    self.Image_Mask:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function WBP_VideoPlayer_C:IsPlaying()
  return self.MediaPlayer and self.MediaPlayer:IsPlaying()
end

function WBP_VideoPlayer_C:Pause()
  if not self.MediaPlayer then
    return
  end
  if self.MediaPlayer:IsPlaying() then
    self.MediaPlayer:Pause()
  end
end

function WBP_VideoPlayer_C:Play()
  if not self.MediaPlayer then
    return
  end
  self:DropPendingPauseOnFirstFrame()
  self:HideVideoSurfaceForLoading()
  if self.MediaPlayer:IsPreparing() then
    return false
  end
  self.MediaPlayer_VideoTexture:SetMediaPlayer(self.MediaPlayer)
  if self.MediaPlayer:IsReady() then
    self.MediaPlayer:Play()
  elseif self.MediaPlayer:CanPlayUrl(self.Url) then
    self.MediaPlayer:OpenUrl(self.Url)
    self.MediaPlayer:Play()
  else
    print(_G.LogTag, "Error: Failed to open url:" .. self.Url)
    self:ClearVideoSurface()
    return false
  end
  return true
end

function WBP_VideoPlayer_C:SetUrl(Url)
  self.Url = Url
end

function WBP_VideoPlayer_C:SetUrlByMediaSource(MediaSource)
  if MediaSource then
    self.Url = MediaSource:GetUrl()
  end
end

function WBP_VideoPlayer_C:HideSkipButton(IsHidden)
  if IsHidden then
    self.Button_Skip:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Button_Skip:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function WBP_VideoPlayer_C:SetLooping(Looping)
  self.bLooping = Looping
  if self.MediaPlayer then
    return self.MediaPlayer:SetLooping(Looping)
  end
  return false
end

function WBP_VideoPlayer_C:PlaySoundOnMediaPlayStart(SoundPath)
  if not SoundPath then
    return
  end
  self.SoundPath = SoundPath
end

function WBP_VideoPlayer_C:DropPendingPauseOnFirstFrame()
  rawset(self, "PauseOnFirstFrameTick", (rawget(self, "PauseOnFirstFrameTick") or 0) + 1)
  local Timer = rawget(self, "PauseOnFirstFrameTimer")
  if Timer and self.RemoveTimer then
    self:RemoveTimer(Timer)
  end
  rawset(self, "PauseOnFirstFrameTimer", nil)
end

function WBP_VideoPlayer_C:CancelPauseOnFirstFrame()
  self:DropPendingPauseOnFirstFrame()
  rawset(self, "bShouldPauseOnFirstFrame", false)
end

function WBP_VideoPlayer_C:OnMediaPlayStart()
  self:ShowVideoSurface()
  if self.Image_Mask then
    self.Image_Mask:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if rawget(self, "bShouldPauseOnFirstFrame") then
    rawset(self, "bShouldPauseOnFirstFrame", false)
    local Tick = (rawget(self, "PauseOnFirstFrameTick") or 0) + 1
    rawset(self, "PauseOnFirstFrameTick", Tick)
    local Timer = self:AddTimer(0.1, function()
      if rawget(self, "PauseOnFirstFrameTick") ~= Tick then
        return
      end
      rawset(self, "PauseOnFirstFrameTimer", nil)
      if self.MediaPlayer then
        self.MediaPlayer:Rewind()
        self:Pause()
      end
    end)
    rawset(self, "PauseOnFirstFrameTimer", Timer)
  elseif self.SoundPath then
    AudioManager(self):PlayUISound(self, self.SoundPath, "VideoPlayerSound", nil)
  end
end

function WBP_VideoPlayer_C:PauseOnFirstFrame()
  self:DropPendingPauseOnFirstFrame()
  rawset(self, "bShouldPauseOnFirstFrame", true)
  local bPlayed = self:Play()
  if true ~= bPlayed then
    rawset(self, "bShouldPauseOnFirstFrame", false)
  end
  return bPlayed
end

function WBP_VideoPlayer_C:Close()
  self:CancelPauseOnFirstFrame()
  self.Super.Close(self)
  if self.MediaPlayer then
    self.MediaPlayer:Close()
  end
end

function WBP_VideoPlayer_C:Destruct()
  self:CancelPauseOnFirstFrame()
  if self.MediaPlayer then
    self.MediaPlayer:Close()
  end
  rawset(self, "PauseOnFirstFrameTimer", nil)
  self.Super.Destruct(self)
end

return WBP_VideoPlayer_C
