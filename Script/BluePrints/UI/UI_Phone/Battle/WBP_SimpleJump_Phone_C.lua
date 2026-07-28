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
  if self.OwnerPanel and self.OwnerPanel.IsFolded then
    return
  end
  if self.OwnerPlayer:CheckSkillInActive(ESkillName.Jump) then
    return
  end
  self:PlayAnimation(self.Click)
  self.OwnerPanel:TryToStopTargetCommand("Jump")
end

AssembleComponents(M)
return M
