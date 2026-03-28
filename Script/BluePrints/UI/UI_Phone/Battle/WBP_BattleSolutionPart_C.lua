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
  if self.Index == nil then
    self.Index = Params.Index
  end
  for i = 1, 3 do
    if 0 == self.Index % 2 then
      self["NewEMWidgetBlueprint_" .. i]:InitUI(i * 2, i * 2 == self.Index, self)
    else
      self["NewEMWidgetBlueprint_" .. i]:InitUI(i * 2 - 1, i * 2 - 1 == self.Index, self)
    end
  end
end

return M
