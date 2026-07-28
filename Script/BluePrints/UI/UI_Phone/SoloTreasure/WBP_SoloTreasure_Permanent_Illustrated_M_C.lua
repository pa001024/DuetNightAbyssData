require("UnLua")
local SoloTreasurePermanentDataModel = require("BluePrints.UI.UI_PC.SoloTreasure.SoloTreasurePermanentDataModel")
local M = Class({
  "BluePrints.UI.UI_PC.SoloTreasure.WBP_SoloTreasure_Permanent_Illustrated_Base"
})
local ALL_TAB_ICON = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_All.T_Tab_All"

function M:GetDefaultInputType()
  return ECommonInputType.Touch
end

function M:InitTabInfo()
  self.AllTabInfo = {}
  table.insert(self.AllTabInfo, {
    Text = GText("UI_ALL"),
    IconPath = ALL_TAB_ICON,
    TabId = SoloTreasurePermanentDataModel.ALL_TAB_ID
  })
  for Id, ExtractionTreasureType in pairs(DataMgr.ExtractionTreasureType) do
    table.insert(self.AllTabInfo, {
      Text = GText(ExtractionTreasureType.Name),
      IconPath = ExtractionTreasureType.Icon,
      TabId = Id
    })
  end
  self.Tab:Init({
    PlatformName = "Mobile",
    Tabs = self.AllTabInfo,
    DynamicNode = {"Back", "Tip"},
    StyleName = "Image",
    OwnerPanel = self,
    TitleName = GText("UI_Play_TreasureHunt_TreasureArchive"),
    BackCallback = self.OnReturnKeyDown
  })
  self.Tab:BindEventOnTabSelected(self, self.OnTabItemSelected)
  self.Tab:SelectTabById(SoloTreasurePermanentDataModel.ALL_TAB_ID)
end

return M
