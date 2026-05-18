require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(ListItemObject)
  self.Content = ListItemObject
  if not ListItemObject then
    return
  end
  if self.Text_Permission and ListItemObject.LocKey then
    self.Text_Permission:SetText(GText(ListItemObject.LocKey))
  end
  if ListItemObject.Dialog and ListItemObject.Dialog.RefreshPermissionRow then
    ListItemObject.Dialog:RefreshPermissionRow(self)
  end
  if 0 == ListItemObject.Index % 2 then
    self.WS_BG:SetActiveWidgetIndex(1)
  else
    self.WS_BG:SetActiveWidgetIndex(0)
  end
end

function M:GetCheckBoxes()
  return {
    self.CheckBox_01,
    self.CheckBox_02,
    self.CheckBox_03,
    self.CheckBox_04,
    self.CheckBox_05
  }
end

return M
