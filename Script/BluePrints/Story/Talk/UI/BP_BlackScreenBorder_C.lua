require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bPaused = false
  self.FadeInCallback = nil
  self.FadeOutCallback = nil
  self.bFadeIn = false
  self.bFadeOut = false
  self.FadeTime = 0
  self.PausePosition = nil
  self:SetToTransparent()
end

function M:FadeIn(FadeTime, Callback)
  DebugPrint("BP_BlackScreenBorder_C:StartFadeIn", "BlendInTime:", FadeTime, "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
  self.bPaused = false
  self.FadeTime = FadeTime
  self.FadeInCallback = Callback
  if FadeTime <= 0 then
    self:SetToBlack()
    self:OnFadeInFinished()
  else
    self.bFadeIn = true
    local AnimationTime = self.AlphaChange:GetEndTime()
    self:BindToAnimationFinished(self.AlphaChange, {
      self,
      function()
        self.bFadeIn = false
        self:UnbindAllFromAnimationFinished(self.AlphaChange)
        self:OnFadeInFinished()
      end
    })
    self:StopAllAnimations()
    self:PlayAnimation(self.AlphaChange, 0, 1, EUMGSequencePlayMode.Forward, AnimationTime / FadeTime)
  end
  AudioManager(self):PlayUISound(self, "event:/snapshot/ui/filter_fade_ui", "BlackScreenBorder", nil)
end

function M:FadeOut(FadeTime, Callback)
  DebugPrint("BP_BlackScreenBorder_C:StartFadeOut, BlendOutTime:", FadeTime, "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
  self.bPaused = false
  self.FadeTime = FadeTime
  self.FadeOutCallback = Callback
  if FadeTime <= 0 then
    self:SetToTransparent()
    self:OnFadeOutFinished()
  else
    self.bFadeOut = true
    local AnimationTime = self.AlphaChange:GetEndTime()
    self:BindToAnimationFinished(self.AlphaChange, {
      self,
      function()
        self:UnbindAllFromAnimationFinished(self.AlphaChange)
        self:OnFadeOutFinished()
        self.bFadeOut = false
      end
    })
    self:StopAllAnimations()
    self:PlayAnimation(self.AlphaChange, 0, 1, EUMGSequencePlayMode.Reverse, AnimationTime / FadeTime)
  end
  AudioManager(self):StopSound(self, "BlackScreenBorder")
end

function M:SetToBlack()
  DebugPrint("BP_BlackScreenBorder_C:SetToBlack", "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
  self:StopAllAnimations()
  self:PlayAnimation(self.Black)
end

function M:SetToTransparent()
  DebugPrint("BP_BlackScreenBorder_C:SetToTransparent", "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
  self:StopAllAnimations()
  self:PlayAnimation(self.Transparent)
end

function M:OnFadeInFinished()
  DebugPrint("BP_BlackScreenBorder_C:FadeInFinished", "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
  if self.FadeInCallback then
    local Func = self.FadeInCallback.Func
    local Obj = self.FadeInCallback.Obj
    local Params = self.FadeInCallback.Params
    self.FadeInCallback = nil
    Func(Obj, table.unpack(Params))
  end
end

function M:OnFadeOutFinished()
  DebugPrint("BP_BlackScreenBorder_C:FadeOutFinished", "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
  if self.FadeOutCallback then
    local Func = self.FadeOutCallback.Func
    local Obj = self.FadeOutCallback.Obj
    local Params = self.FadeOutCallback.Params
    self.FadeOutCallback = nil
    Func(Obj, table.unpack(Params))
  end
end

function M:Pause(bPaused)
  DebugPrint("BP_BlackScreenBorder_C:Pause, bPause:", bPaused, "self.bPaused:", self.bPaused, "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
  if true == bPaused and self.bPaused == false then
    if self:IsAnimationPlaying(self.AlphaChange) then
      self.PausePosition = self:PauseAnimation(self.AlphaChange)
    end
  elseif false == bPaused and self.bPaused == true and self.PausePosition then
    local PlayMode
    local PausePosition = self.PausePosition
    local AnimationTime = self.AlphaChange:GetEndTime()
    if true == self.bFadeIn then
      PlayMode = EUMGSequencePlayMode.Forward
    elseif true == self.bFadeOut then
      PlayMode = EUMGSequencePlayMode.Reverse
      PausePosition = AnimationTime - PausePosition
    end
    if nil ~= PlayMode then
      self:PlayAnimation(self.AlphaChange, PausePosition, 1, PlayMode, AnimationTime / self.FadeTime)
    end
  end
  self.bPaused = bPaused
end

return M
