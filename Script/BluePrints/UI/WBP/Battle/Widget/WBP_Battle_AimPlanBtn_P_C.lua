require("UnLua")
local UIUtils = require("Utils.UIUtils")
local AimPlanData = require("BluePrints.UI.WBP.Battle.WBP_Battle_AimPlan_P_Data")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bIsFocusable = true
  self.bIsDealWithVirtualAccept = true
end

local function BuildKeyInfo(Row, CurrentKeyMap, ActionKeyMappings)
  local Key = Row.ActionName and CurrentKeyMap and CurrentKeyMap[Row.ActionName]
  if not Key and Row.ActionName and ActionKeyMappings then
    Key = ActionKeyMappings[Row.ActionName]
  end
  return {
    {
      Type = "Text",
      Text = Key or ""
    }
  }
end

function M:Init(Parent, PlanIndex, CurrentKeyMap)
  local PlanData = AimPlanData.Plans[PlanIndex]
  if not PlanData then
    return
  end
  self.Parent = Parent
  self.PlanIndex = PlanIndex
  self.Text_Plan:SetText(GText(PlanData.TitleKey))
  if self.Text_PlanDesc then
    self.Text_PlanDesc:SetText(PlanData.DescKey and GText(PlanData.DescKey) or "")
  end
  if self.New then
    self.New:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.List_Key:ClearListItems()
  for _, Row in ipairs(PlanData.KeyRows) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.TagKey = Row.TagKey
    Content.KeyTextKey = Row.KeyTextKey
    Content.KeyInfoList = BuildKeyInfo(Row, CurrentKeyMap, PlanData.ActionKeyMappings)
    self.List_Key:AddItem(Content)
  end
  self.List_Key:RequestRefresh()
end

function M:OnAddedToFocusPath()
  if self.Parent and UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.Parent:SelectPlan(self.PlanIndex, self)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self.Parent and self.Parent.OnPlanCardKeyDown then
    return self.Parent:OnPlanCardKeyDown(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  if self.Parent and self.Parent.OnPlanCardKeyUp then
    return self.Parent:OnPlanCardKeyUp(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled
end

function M:OnRemovedFromFocusPath()
  if self.Parent and self.Parent.CancelGamepadConfirmLongPress then
    self.Parent:CancelGamepadConfirmLongPress()
  end
end

return M
