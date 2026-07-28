require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local FIRST_OPEN_LAYOUT_PLAN_03_KEY = "FirstOpenLayoutPlan03"

local function GetLayoutRecordPlanIndex(LayoutEntryIndex)
  local Avatar = GWorld and GWorld:GetAvatar()
  if not Avatar or not LayoutEntryIndex then
    return LayoutEntryIndex
  end
  if Avatar.GetLayoutRecordPlanIndex then
    return Avatar:GetLayoutRecordPlanIndex(LayoutEntryIndex) or LayoutEntryIndex
  end
  return LayoutEntryIndex
end

function M:Construct()
  self.CurSelectIndex = nil
  self.IsClosing = false
  self.LayoutWidgets = {
    self.Layout_01,
    self.Layout_02
  }
  self.Btn_Confirm.Button_Area:SetVisibility(ESlateVisibility.Collapsed)
  self.Btn_Confirm:PlayAnimation(self.Btn_Confirm.Forbidden)
  self.Btn_Confirm.Button_Area.OnClicked:Add(self, self.OnClickConfirm)
  self.Layout_01.Btn_Area.OnClicked:Add(self, self.OnClickLayout1)
  self.Layout_02.Btn_Area.OnClicked:Add(self, self.OnClickLayout2)
  self.Text_Title:SetText(GText("UI_SelectLayoutPopup_Tittle04"))
  self.Text_Desc:SetText(GText("UI_SelectLayoutPopup_Tip"))
  self.Layout_01.Text_Plan:SetText(GText("UI_SelectLayoutPopup_Tittle01"))
  self.Layout_01.Text_PlanDesc:SetText(GText("UI_SelectLayoutPopup_Content01"))
  self.Layout_02.Text_Plan:SetText(GText("UI_SelectLayoutPopup_Tittle02"))
  self.Layout_02.Text_PlanDesc:SetText(GText("UI_SelectLayoutPopup_Content02"))
  self.Layout_01.New:SetVisibility(ESlateVisibility.Collapsed)
  self.Layout_02.New:SetVisibility(ESlateVisibility.Collapsed)
  if self.Layout_03 then
    table.insert(self.LayoutWidgets, self.Layout_03)
    self.Layout_03.Btn_Area.OnClicked:Add(self, self.OnClickLayout3)
    self.Layout_03.Text_Plan:SetText(GText("UI_SelectLayoutPopup_Tittle03"))
    self.Layout_03.Text_PlanDesc:SetText(GText("UI_SelectLayoutPopup_Content03"))
    self.Layout_03.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  self.Btn_Confirm.Text_Button:SetText(GText("UI_SelectLayoutPopup_Button"))
  AudioManager(self):PlayUISound(self, "event:/ui/common/complete_trial_level_panel_show", "LayoutPlan", nil)
end

function M:OnLoaded(...)
end

function M:OnClickConfirm()
  local Avatar = GWorld:GetAvatar()
  EMCache:Set("FirstOpenLayoutPlan", true, true)
  EMCache:Set(FIRST_OPEN_LAYOUT_PLAN_03_KEY, true, true)
  EMCache:SaveUser()
  if Avatar then
    Avatar:SwitchMobileHudPlan(self.CurSelectIndex)
    Avatar:RecordLayoutIndexToMappedPlan(self.CurSelectIndex)
    local RedDot = ReddotManager.GetTreeNode("Setting_Layout")
    if RedDot and RedDot.Count > 0 then
      ReddotManager.ClearLeafNodeCount("Setting_Layout")
    end
  end
  self:CloseSelf()
  self.IsClosing = true
  EventManager:FireEvent(EventID.OnSwitchMobileHUDLayout, self.CurSelectIndex)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
end

function M:SelectLayout(LayoutEntryIndex, LayoutWidget)
  for _, Widget in ipairs(self.LayoutWidgets) do
    if Widget ~= LayoutWidget and Widget.LayoutState == UIConst.ButtonState.Click then
      Widget:PlayAnimation(Widget.Normal)
      Widget.LayoutState = UIConst.ButtonState.None
    end
  end
  if not self.CurSelectIndex then
    self.Btn_Confirm:PlayAnimation(self.Btn_Confirm.Normal)
  end
  self.CurSelectIndex = GetLayoutRecordPlanIndex(LayoutEntryIndex)
  self.Btn_Confirm.Button_Area:SetVisibility(ESlateVisibility.Visible)
end

function M:OnClickLayout1()
  self:SelectLayout(1, self.Layout_01)
end

function M:OnClickLayout2()
  self:SelectLayout(2, self.Layout_02)
  self.Layout_02.New:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OnClickLayout3()
  self:SelectLayout(3, self.Layout_03)
  self.Layout_03.New:SetVisibility(ESlateVisibility.Collapsed)
end

function M:CloseSelf()
  if self.IsClosing then
    return
  end
  self:PlayAnimation(self.Out)
  AudioManager(self):SetEventSoundParam(self, "LayoutPlan", {ToEnd = 1})
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Out then
    self:Close()
  end
end

return M
