require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
  local AbyssSeasonId = PlayerAvatar.CurrentAbyssSeasonId
  local AbyssSeasonConfig = DataMgr.AbyssSeasonList[AbyssSeasonId]
  if AbyssSeasonConfig.CharId then
    self.Text_Title:SetText(GText("Abyss_CharReward_Title"))
    local CharId = AbyssSeasonConfig.CharId
    local CharConfig = DataMgr.Char[CharId]
    self.Text_Name:SetText(GText(CharConfig.CharName))
    local Icon = LoadObject(CharConfig.Icon)
    self.Icon_Head:SetBrushFromTexture(Icon)
  elseif AbyssSeasonConfig.ResourceId then
    self.Text_Title:SetText(GText("Abyss_ReasourceReward_Title"))
    local ResourceId = AbyssSeasonConfig.ResourceId
    local ResourceConfig = DataMgr.Resource[ResourceId]
    self.Text_Name:SetText(GText(ResourceConfig.ResourceName))
    local Icon = LoadObject(ResourceConfig.Icon)
    self.Icon_Head:SetBrushFromTexture(Icon)
  end
end

return M
