require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.ObservationPointState = {
    Normal = UE4.EObservationPointState.Normal,
    TargetedNotCollected = UE4.EObservationPointState.TargetedNotCollected,
    Collected = UE4.EObservationPointState.Collected
  }
  self:BindToAnimationFinished(self.Lock_In, {
    self,
    function()
      self:PlayAnimation(self.Lock_Loop, 0, 0)
    end
  })
  self:BindToAnimationFinished(self.Get_In, {
    self,
    function()
      self:PlayAnimation(self.Get)
    end
  })
  self:BindToAnimationFinished(self.Lock_Out, {
    self,
    function()
      self:PlayAnimation(self.Normal)
    end
  })
end

function M:Destruct()
  self:UnbindAllFromAnimationFinished(self.Lock_In)
  self:UnbindAllFromAnimationFinished(self.Get_In)
  self:UnbindAllFromAnimationFinished(self.Lock_Out)
end

function M:OnStateChanged(OldState, NewState)
  if OldState == NewState then
    return
  end
  if OldState == self.ObservationPointState.Normal then
    if self:IsAnimationPlaying(self.Lock_Out) then
      self:StopAnimation(self.Lock_Out)
    end
    if self:IsAnimationPlaying(self.Normal) then
      self:StopAnimation(self.Normal)
    end
    if NewState == self.ObservationPointState.TargetedNotCollected then
      self:PlayAnimation(self.Lock_In)
    elseif NewState == self.ObservationPointState.Collected then
      self:PlayAnimation(self.Get)
    end
  elseif OldState == self.ObservationPointState.TargetedNotCollected then
    if self:IsAnimationPlaying(self.Lock_In) then
      self:StopAnimation(self.Lock_In)
    end
    if self:IsAnimationPlaying(self.Lock_Loop) then
      self:StopAnimation(self.Lock_Loop)
    end
    if NewState == self.ObservationPointState.Normal then
      self:PlayAnimation(self.Lock_Out)
    elseif NewState == self.ObservationPointState.Collected then
      self:PlayAnimation(self.Get_In)
    end
  elseif OldState == self.ObservationPointState.Collected then
    if self:IsAnimationPlaying(self.Get_In) then
      self:StopAnimation(self.Get_In)
    end
    if self:IsAnimationPlaying(self.Get) then
      self:StopAnimation(self.Get)
    end
    if NewState == self.ObservationPointState.Normal then
      self:PlayAnimation(self.Normal)
    elseif NewState == self.ObservationPointState.TargetedNotCollected then
      self:PlayAnimation(self.Lock_Loop, 0, 0)
    end
  end
end

return M
