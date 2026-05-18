require("UnLua")
local UIConst = require("BluePrints.UI.UIConst")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.IsAutoShootOn = false
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  EventManager:AddEvent(EventID.OnAutoShootEnabledChanged, self, self.OnAutoShootStateChanged)
end

function M:OnPressed()
  local Player = self.OwnerPanel and self.OwnerPanel.OwnerPlayer
  if not IsValid(Player) then
    return
  end
  local bCurrentEnabled = Player:IsAutoShootEnabled()
  Player:SetAutoShootEnabled(not bCurrentEnabled)
end

function M:OnAutoShootStateChanged(Player, bEnabled, bIsAutoOff)
  if not IsValid(self) then
    return
  end
  self.IsAutoShootOn = bEnabled
  if bEnabled then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_HUDToast_AutoShot"))
  else
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
  end
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnAutoShootEnabledChanged, self)
end

AssembleComponents(M)
return M
