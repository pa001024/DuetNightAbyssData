require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
end

function M:OnBtnPressed()
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.Slide) then
    return
  end
  self:PlayAnimation(self.Press)
  self.OwnerPanel:TryToPlayTargetCommand("Slide")
end

function M:OnBtnReleased()
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.Slide) then
    return
  end
  self:PlayAnimation(self.Click)
  self.OwnerPanel:TryToStopTargetCommand("Slide")
end

AssembleComponents(M)
return M
