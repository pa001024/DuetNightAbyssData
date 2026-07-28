require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local FIRST_OPEN_LAYOUT_PLAN_03_KEY = "FirstOpenLayoutPlan03"

local function GetLayoutSelectedIndexByPlanIndex(PlanIndex)
  local Avatar = GWorld and GWorld:GetAvatar()
  if not (Avatar and PlanIndex) or not Avatar.GetLayoutEntryIndexByPlanIndex then
    return nil
  end
  return Avatar:GetLayoutEntryIndexByPlanIndex(PlanIndex)
end

function M:Construct()
  self.Btn_Area.OnPressed:Add(self, self.OnPressLayout)
  self.Btn_Area.OnReleased:Add(self, self.OnReleasedLayout)
  self.Btn_Area.OnUnhovered:Add(self, self.OnOnUnhoveredLayout)
  self.Btn_Area.OnClicked:Add(self, self.OnClickedLayout)
  self.Btn_CustomLayout.Button_Area.OnClicked:Add(self, self.OnClickedCustomLayout)
  self.Btn_CustomLayout.Button_Area.OnPressed:Add(self, self.OnPressedCustomLayout)
  self.LayoutState = UIConst.ButtonState.None
  self:PlayAnimation(self.Normal)
  EventManager:AddEvent(EventID.OnSwitchMobileHUDLayout, self, self.OnSwitchMobileHUDLayout)
  ReddotManager.AddListener("Setting_Control_LayOutBtn", self, self.RefreshReddot)
end

function M:Destruct()
  self:PlayAnimation(self.Normal)
  self.Btn_Area.OnPressed:Clear()
  self.Btn_Area.OnReleased:Clear()
  self.Btn_Area.OnUnhovered:Clear()
  self.Btn_Area.OnClicked:Clear()
  EventManager:RemoveEvent(EventID.OnSwitchMobileHUDLayout, self)
  ReddotManager.RemoveListener("Setting_Control_LayOutBtn", self)
end

function M:OnClickedCustomLayout()
  local CustomHUDSettingTrailUI = UIManager(self):GetUI("CustomHUDSettingTrailUI")
  if CustomHUDSettingTrailUI then
    local CurEditPlan = CustomHUDSettingTrailUI:GetCurEditPlan()
    local WidgetPlanData = CustomHUDSettingTrailUI:GetWidgetPlanData()
    if CurEditPlan == self.PlanIndex then
      UIManager(self):LoadUINew("CustomHUDSetting", self.PlanIndex, WidgetPlanData, true)
      return
    end
  end
  UIManager(self):LoadUINew("CustomHUDSetting", self.LayoutIndex)
end

function M:OnPressedCustomLayout()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
end

function M:RefreshReddot()
  local RedDot = ReddotManager.GetTreeNode("Setting_Control_LayOutBtn")
  if 1 == self.Index then
    RedDot = ReddotManager.GetTreeNode("Setting_Control_TrailBtn")
  end
  if RedDot and RedDot.Count > 0 then
    self.Btn_CustomLayout:SetReddot(true)
  else
    self.Btn_CustomLayout:SetReddot(false)
  end
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

function M:InitLayoutPlan(PlanIndex, LayoutIndex, IsSelected)
  self.PlanIndex = PlanIndex
  self.LayoutIndex = LayoutIndex
  local bIsSelected = IsSelected
  if nil == bIsSelected then
    bIsSelected = self.Index == GetLayoutSelectedIndexByPlanIndex(self.PlanIndex)
  end
  if bIsSelected then
    self.LayoutState = UIConst.ButtonState.Click
    self:PlayAnimation(self.Click)
  else
    self.LayoutState = UIConst.ButtonState.None
    self:PlayAnimation(self.Normal)
  end
  local IsFirstShow = EMCache:Get(FIRST_OPEN_LAYOUT_PLAN_03_KEY, true)
  local LayoutSelectedIndex = GetLayoutSelectedIndexByPlanIndex(PlanIndex)
  if not IsFirstShow and 3 == self.Index and (1 == LayoutSelectedIndex or 2 == LayoutSelectedIndex) then
    self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:OnSwitchMobileHUDLayout(PlanIndex)
  self.PlanIndex = PlanIndex
  if GetLayoutSelectedIndexByPlanIndex(PlanIndex) == self.Index then
    self.LayoutIndex = PlanIndex
  end
end

return M
