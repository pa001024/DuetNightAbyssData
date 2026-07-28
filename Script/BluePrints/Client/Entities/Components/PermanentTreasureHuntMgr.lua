local SoloTreasurePermanentDataModel = require("BluePrints.UI.UI_PC.SoloTreasure.SoloTreasurePermanentDataModel")
local PermanentSoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.PermanentSoloTreasureDataModel")
local Component = {}

function Component:EnterWorld()
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnPermanentTreasureHuntLoginSuccess)
end

function Component:LeaveWorld()
  EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
  PermanentSoloTreasureDataModel:UnBindUnlockReddotRefresh()
end

function Component:OnPermanentTreasureHuntLoginSuccess()
  SoloTreasurePermanentDataModel:InitReddotTree()
  local SeasonId = PermanentSoloTreasureDataModel:GetCurrentSeasonId()
  if SeasonId then
    PermanentSoloTreasureDataModel:RefreshLevelListNewReddot(SeasonId)
    PermanentSoloTreasureDataModel:RefreshShopNewReddot(SeasonId)
  end
  PermanentSoloTreasureDataModel:BindUnlockReddotRefresh()
end

function Component:_OnPropChangeTreasureHuntManualInfo(ChangeKeys, OldValue)
  SoloTreasurePermanentDataModel:RefreshManualArchiveRewardReddot()
  EventManager:FireEvent(EventID.OnTreasureHuntManualInfoChanged, ChangeKeys, OldValue)
end

function Component:TreasureHuntsGetTreasureManualReward(id, Callback)
  local function CallBack(RetCode, RewardsReturn)
    self.logger.info("TreasureHuntsGetTreasureManualReward RetCode = " .. tostring(RetCode))
    
    if Callback then
      Callback(RetCode, RewardsReturn)
    end
  end
  
  self:CallServer("TreasureHuntsGetTreasureManualReward", CallBack, id)
end

function Component:TreasureHuntsAlreadyDisplayNewTreasure(TreasureId)
  self:CallServerMethod("TreasureHuntsAlreadyDisplayNewTreasure", {TreasureId})
end

return Component
