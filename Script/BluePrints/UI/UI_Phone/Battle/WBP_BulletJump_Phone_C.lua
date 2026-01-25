require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self.Btn_BulletJump.OnPressed:Add(self, self.OnBtnPressed)
  self.Btn_BulletJump.OnReleased:Add(self, self.OnBtnReleased)
end

function M:OnBtnPressed()
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
end

function M:OnBtnReleased()
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  self.OwnerPanel:TryToStopTargetCommand("BulletJump")
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
end

function M:ActiveBulletJump()
  self:SetRenderOpacity(1)
end

function M:InActiveBulletJump()
  self:SetRenderOpacity(0.5)
end

function M:UpdateButtonInTimer()
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
    return
  end
  if self.OwnerPlayer:CheckBulletJumpConditionForUI() then
    self:SetRenderOpacity(1)
  else
    self:SetRenderOpacity(0.5)
  end
end

AssembleComponents(M)
return M
