require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

local function GetCurrentReputationID()
  local SceneId = WorldTravelSubsystem():GetCurrentSceneId()
  local MainMap = UIManager():GetUIObj("LevelMapMain")
  if MainMap and MainMap.RealWildMap then
    SceneId = MainMap.RealWildMap.RegionID
  end
  return SceneId
end

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
end

function M:OnBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click", "", nil)
  local DimensionPanel = UIManager(self):LoadUINew("RegionMapImpression")
  DimensionPanel:Init(GetCurrentReputationID(), self)
end

return M
