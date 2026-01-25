require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Area.OnPressed:Add(self, self.OnPressLayout)
  self.Btn_Area.OnReleased:Add(self, self.OnReleasedLayout)
  self.Btn_Area.OnUnhovered:Add(self, self.OnOnUnhoveredLayout)
  self.Btn_Area.OnClicked:Add(self, self.OnClickedLayout)
  self.Btn_CustomLayout.Button_Area.OnClicked:Add(self, self.OnClickedCustomLayout)
  self.LayoutState = UIConst.ButtonState.None
  self:PlayAnimation(self.Normal)
end

function M:Destruct()
  self:PlayAnimation(self.Normal)
  self.Btn_Area.OnPressed:Clear()
  self.Btn_Area.OnReleased:Clear()
  self.Btn_Area.OnUnhovered:Clear()
  self.Btn_Area.OnClicked:Clear()
end

function M:OnClickedCustomLayout()
  UIManager(self):LoadUINew("CustomHUDSetting", self.Index)
end

function M:OnPressLayout()
  if self.LayoutState == UIConst.ButtonState.Click then
    return
  end
  self.LayoutState = UIConst.ButtonState.Press
  self:PlayAnimation(self.Press)
end

function M:OnOnUnhoveredLayout()
  if self.LayoutState == UIConst.ButtonState.Click then
    return
  end
  self.LayoutState = UIConst.ButtonState.Unhovered
end

function M:OnReleasedLayout()
  if self.LayoutState == UIConst.ButtonState.Click then
    return
  end
  if self.LayoutState == UIConst.ButtonState.Unhovered then
    self:PlayAnimation(self.Normal)
  end
  self.LayoutState = UIConst.ButtonState.Release
end

function M:OnClickedLayout()
  if self.LayoutState == UIConst.ButtonState.Click then
    return
  end
  self.LayoutState = UIConst.ButtonState.Click
  self:PlayAnimation(self.Click)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
end

function M:InitLayoutPlan(PlanIndex)
  self.PlanIndex = PlanIndex
  if self.Index == self.PlanIndex and self.LayoutState ~= UIConst.ButtonState.Click then
    self.LayoutState = UIConst.ButtonState.Click
    self:PlayAnimation(self.Click)
  elseif self.Index ~= self.PlanIndex and self.LayoutState == UIConst.ButtonState.Click then
    self.LayoutState = UIConst.ButtonState.None
    self:PlayAnimation(self.Normal)
  end
  local IsFirstShow = EMCache:Get("FirstOpenLayoutPlan", true)
  if not IsFirstShow and 1 == PlanIndex and 2 == self.Index then
    self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

return M
