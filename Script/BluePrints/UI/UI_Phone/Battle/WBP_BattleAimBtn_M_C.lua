require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.LastAppliedPreAimState = false
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnReleased)
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
end

function M:OnPressed()
  if not self.OwnerPanel then
    return
  end
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
  self.OwnerPanel:TryToPlayTargetCommand("PreAim", false)
end

function M:OnReleased()
  if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Press) then
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Press)
  end
end

function M:BindOwnerPlayer(OwnerPlayer)
  if self.OwnerPlayer == OwnerPlayer then
    self:OnPreAimStateChanged(IsValid(OwnerPlayer) and OwnerPlayer.IsInPreAim == true)
    return
  end
  self:UnbindOwnerPlayer()
  if not IsValid(OwnerPlayer) then
    self:OnPreAimStateChanged(false)
    return
  end
  self.OwnerPlayer = OwnerPlayer
  self.OwnerPlayer.OnPreAimStateChanged:Add(self, self.OnPreAimStateChanged)
  self:OnPreAimStateChanged(self.OwnerPlayer.IsInPreAim == true)
end

function M:UnbindOwnerPlayer()
  if IsValid(self.OwnerPlayer) and self.OwnerPlayer.OnPreAimStateChanged then
    self.OwnerPlayer.OnPreAimStateChanged:Remove(self, self.OnPreAimStateChanged)
  end
  self.OwnerPlayer = nil
end

function M:OnPreAimStateChanged(IsInPreAim)
  IsInPreAim = true == IsInPreAim
  if self.LastAppliedPreAimState == IsInPreAim then
    return
  end
  self.LastAppliedPreAimState = IsInPreAim
  if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Press) then
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Press)
  end
  if IsInPreAim then
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Normal) then
      EMUIAnimationSubsystem:EMStopAnimation(self, self.Normal)
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    return
  end
  if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Click) then
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Click)
  end
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
end

function M:Destruct()
  self:UnbindOwnerPlayer()
end

AssembleComponents(M)
return M
