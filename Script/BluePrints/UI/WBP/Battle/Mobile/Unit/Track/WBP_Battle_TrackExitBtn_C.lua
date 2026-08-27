require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.WBP.Battle.Mobile.Unit.Track.TrackBtnCommonComponent"
}

function M:Construct()
  self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
end

function M:IsLeaveForbidden()
  local Mech = self:GetCurrentSlideMech()
  if not Mech then
    return true
  end
  return not Mech.CanExit
end

function M:IsForbidden()
  if not self:IsOnRail() then
    self.bForbiddenCached = nil
    return false
  end
  if self.bForbiddenCached == nil then
    self.bForbiddenCached = self:IsLeaveForbidden()
  end
  return self.bForbiddenCached
end

function M:OnBtnPressed()
  if self:IsForbidden() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Track_Toast04"), 1.5)
    return
  end
  self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
  if self:IsForbidden() then
    return
  end
  self:PlayAnimation(self.Click)
  self.OwnerPlayer:TryLeaveSlideMech()
end

AssembleComponents(M)
return M
