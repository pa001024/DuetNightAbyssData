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
  return self.OwnerPlayer and self.OwnerPlayer.InSlideMechJump
end

function M:OnBtnPressed()
  if self:IsOnRail() then
    if self:IsForbidden() then
      return
    end
    self:PlayAnimation(self.Press)
    local WasInSlideMechJump = self.OwnerPlayer.InSlideMechJump
    self.OwnerPlayer:JumpInSlideMech()
    if not WasInSlideMechJump and self.OwnerPlayer.InSlideMechJump and self.OwnerPlayer.NeedJumpEvent then
      EventManager:FireEvent(EventID.OnJumpPressed)
    end
    return
  end
  if self.OwnerPanel and self.OwnerPanel.IsFolded then
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.Jump) then
    return
  end
  self:PlayAnimation(self.Press)
  self.OwnerPanel:TryToPlayTargetCommand("Jump")
end

function M:OnBtnReleased()
  if self:IsOnRail() then
    self:PlayAnimation(self.Click)
    return
  end
  if self.OwnerPanel and self.OwnerPanel.IsFolded then
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.Jump) then
    return
  end
  if not self.OwnerPanel then
    return
  end
  self:PlayAnimation(self.Click)
  self.OwnerPanel:TryToStopTargetCommand("Jump")
end

AssembleComponents(M)
return M
