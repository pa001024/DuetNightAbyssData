require("UnLua")
local UIConst = require("BluePrints.UI.UIConst")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.IsAutoAttackOn = false
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  EventManager:AddEvent(EventID.OnAutoAttackEnabledChanged, self, self.OnAutoAttackStateChanged)
end

function M:OnPressed()
  if self.OwnerLeftBtn and self.OwnerLeftBtn.bPanelOpen then
    return
  end
  local Player = self.OwnerPanel and self.OwnerPanel.OwnerPlayer
  if not IsValid(Player) then
    return
  end
  Player:SetAutoAttackEnabled(not Player:IsAutoAttackEnabled())
end

function M:OnAutoAttackStateChanged(Player, bEnabled, bIsAutoOff)
  if not IsValid(self) then
    return
  end
  self.IsAutoAttackOn = bEnabled
  if bEnabled then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Using)
  else
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
  end
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnAutoAttackEnabledChanged, self)
end

AssembleComponents(M)
return M
