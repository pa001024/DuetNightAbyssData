require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
  "BluePrints.UI.WBP.Battle.Mobile.Unit.Track.TrackBtnCommonComponent"
}

function M:Construct()
  self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
end

function M:IsForbidden()
  if not self:IsOnRail() then
    return false
  end
  return self.OwnerPlayer and self.OwnerPlayer.InSlideMechSlide
end

function M:OnBtnPressed()
  if self:IsOnRail() then
    if self:IsForbidden() then
      return
    end
    self:PlayAnimation(self.Press)
    self.OwnerPlayer:SetHoldCrouch_Client(true)
    local WasInSlideMechSlide = self.OwnerPlayer.InSlideMechSlide
    self.OwnerPlayer:SlideInSlideMech()
    if not WasInSlideMechSlide and self.OwnerPlayer.InSlideMechSlide and self.OwnerPlayer.NeedSlideEvent then
      EventManager:FireEvent(EventID.OnSlidePressed)
    end
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.Slide) then
    return
  end
  self:PlayAnimation(self.Press)
  self.OwnerPanel:TryToPlayTargetCommand("Slide")
end

function M:OnBtnReleased()
  if self:IsOnRail() then
    self:PlayAnimation(self.Click)
    self.OwnerPlayer:ResetAttackProperty("Slide")
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.Slide) then
    return
  end
  if not self.OwnerPanel then
    return
  end
  self:PlayAnimation(self.Click)
  self.OwnerPanel:TryToStopTargetCommand("Slide")
end

AssembleComponents(M)
return M
