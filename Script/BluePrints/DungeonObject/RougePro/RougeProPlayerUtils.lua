local UIConst = require("BluePrints.UI.UIConst")
local RougeProPlayerUtils = {}

function RougeProPlayerUtils.ShowGetTreasureTips(TreasureIds)
  if not TreasureIds or 0 == #TreasureIds then
    return
  end
  if not GWorld or not GWorld.GameInstance then
    return
  end
  local GameUIManager = GWorld.GameInstance:GetGameUIManager()
  if not GameUIManager then
    return
  end
  local InfoDataList = {}
  for _, TreasureId in ipairs(TreasureIds) do
    local TreasureData = DataMgr.RougeProTreasure[TreasureId]
    if TreasureData then
      InfoDataList[#InfoDataList + 1] = TreasureData
    end
  end
  if 0 == #InfoDataList then
    return
  end
  local Params = {InfoDataList = InfoDataList, Islose = false}
  GameUIManager:LoadUINew(UIConst.GetItemsTip, Params)
end

return RougeProPlayerUtils
