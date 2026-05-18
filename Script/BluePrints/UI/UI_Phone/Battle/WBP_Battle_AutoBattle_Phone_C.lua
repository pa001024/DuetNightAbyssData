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
  local Player = self.OwnerPanel and self.OwnerPanel.OwnerPlayer
  if not IsValid(Player) then
    return
  end
  local bCurrentEnabled = Player:IsAutoAttackEnabled()
  Player:SetAutoAttackEnabled(not bCurrentEnabled)
end

function M:OnAutoAttackStateChanged(Player, bEnabled, bIsAutoOff)
  if not IsValid(self) then
    return
  end
  self.IsAutoAttackOn = bEnabled
  if bEnabled then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_HUDToast_AutoMelee"))
  else
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
  end
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnAutoAttackEnabledChanged, self)
end

AssembleComponents(M)
return M
