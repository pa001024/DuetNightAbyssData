require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Init(ResourceId)
  self.Text_Desc:SetText(GText("UI_IronSurvival_DirectionalRareDrop"))
  local ResourceInfo = DataMgr.Resource[ResourceId]
  if not ResourceInfo then
    return
  end
  self.Text_Name:SetText(GText(ResourceInfo.ResourceName))
  local Content = {}
  Content.Id = ResourceId
  Content.Type = "Resource"
  Content.Rarity = ResourceInfo.Rarity
  Content.Icon = ResourceInfo.Icon
  Content.NotInteractive = true
  self.Com_Item:Init(Content)
end

return M
