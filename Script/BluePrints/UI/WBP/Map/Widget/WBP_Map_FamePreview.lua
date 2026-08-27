require("UnLua")
local PageJumpUtils = require("Utils.PageJumpUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  print(string.format("[Yoko.Guo] WBP_Map_FamePreview.lua LINE=%d Construct", debug.getinfo(1).currentline))
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  self:InitFrameImage()
  self:InitFrameLevel()
  self.Text_Fame:SetText(GText("MAIN_UI_FAME"))
end

local function GetCurrentReputationID()
  local SceneId = WorldTravelSubsystem():GetCurrentSceneId()
  local MainMap = UIManager():GetUIObj("LevelMapMain")
  if MainMap and MainMap.RealWildMap then
    SceneId = MainMap.RealWildMap.RegionID
  end
  local ReputationID
  for _, ReputationData in pairs(DataMgr.RegionReputation) do
    for _, RegionId in ipairs(ReputationData.RegionId or {}) do
      if RegionId == SceneId then
        ReputationID = ReputationData.ReputationID
      end
    end
  end
  return ReputationID
end

function M:InitFrameImage()
  local ReputationID = GetCurrentReputationID()
  local ReputationData = DataMgr.RegionReputation
  local RegionData = ReputationData[ReputationID]
  if not ReputationData or not RegionData then
    print(string.format("[Yoko.Guo] WBP_Map_FamePreview.lua LINE=%d InitFrameImage", debug.getinfo(1).currentline))
    return
  end
  local IconImagePath = RegionData.RegionIconPath
  UE4.UResourceLibrary.LoadObjectAsync(self, IconImagePath, {
    self,
    function(self, Object)
      print(string.format("[Yoko.Guo] WBP_Map_FamePreview.lua LINE=%d InitFrameImage", debug.getinfo(1).currentline))
      if Object then
        self.Image_Region:SetBrushResourceObject(Object)
      end
    end
  })
end

function M:InitFrameLevel()
  local ReputationID = GetCurrentReputationID()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not ReputationID then
    print(string.format("[Yoko.Guo] WBP_Map_FamePreview.lua LINE=%d InitFrameLevel", debug.getinfo(1).currentline))
    return
  end
  if not Avatar.RegionReputations[ReputationID] then
    print(string.format("[Yoko.Guo] WBP_Map_FamePreview.lua LINE=%d InitFrameLevel", debug.getinfo(1).currentline))
    return
  end
  local ReputationLevel = Avatar.RegionReputations[ReputationID].ReputationLevel
  if ReputationLevel then
    self.Level_Fame:SetText(tostring(ReputationLevel))
  end
end

function M:UpdateFameImageAndLevel()
  self:InitFrameImage()
  self:InitFrameLevel()
end

function M:SetRegionName(Owner)
  local ReputationID = GetCurrentReputationID()
  local ReputationData = DataMgr.RegionReputation
  local RegionData = ReputationData[ReputationID]
  if not ReputationData or not RegionData then
    print(string.format("[Yoko.Guo] WBP_Map_FamePreview.lua LINE=%d InitFrameImage", debug.getinfo(1).currentline))
    return
  end
  if Owner then
    Owner.Text_RegionName:SetText(GText(RegionData.RegionName))
  end
  self:UpdateFameImageAndLevel()
end

function M:OnBtnClicked()
  PageJumpUtils:JumpToTargetPage("FameMain", GetCurrentReputationID())
end

return M
