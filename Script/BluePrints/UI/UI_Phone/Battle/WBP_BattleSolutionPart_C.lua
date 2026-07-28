require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Construct()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.Index = Avatar:GetCurrentMobileHudPlanIndex()
end

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  if self.Index == nil and Params then
    self.Index = Params.Index
  end
  local Avatar = GWorld and GWorld:GetAvatar()
  local LayoutPlanList
  if Avatar and self.Index and Avatar.GetLayoutEntryIndexByPlanIndex and Avatar.GetLayoutPlanListByEntry then
    local LayoutEntryIndex = Avatar:GetLayoutEntryIndexByPlanIndex(self.Index)
    if LayoutEntryIndex then
      LayoutPlanList = Avatar:GetLayoutPlanListByEntry(LayoutEntryIndex)
    end
  end
  if not LayoutPlanList then
    LayoutPlanList = {}
    local IsEven = self.Index and 0 == self.Index % 2
    for i = 1, 3 do
      LayoutPlanList[i] = IsEven and i * 2 or i * 2 - 1
    end
  end
  for i = 1, 3 do
    local Widget = self["NewEMWidgetBlueprint_" .. i]
    local PlanIndex = LayoutPlanList[i]
    if Widget and PlanIndex then
      Widget:InitUI(PlanIndex, PlanIndex == self.Index, self)
    end
  end
end

return M
