local SoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel")
local Component = {}

function Component:SetTreasureHuntSquad(EventId, EventDungeonId, Squad, IsHard, Callback)
  self.logger.debug("SetTreasureHuntSquad Begin", EventId, EventDungeonId, Squad, IsHard)
  PrintTable(Squad, 3)
  
  local function CallbackFunc(Ret)
    self.logger.debug("SetTreasureHuntSquad Callback", Ret, EventId, EventDungeonId, Squad, IsHard)
    if Callback then
      Callback(Ret)
    end
  end
  
  self:CallServer("SetTreasureHuntSquad", CallbackFunc, EventId, EventDungeonId, Squad, IsHard)
end

function Component:EnterWorld()
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnLoginSuccess)
end

function Component:OnLoginSuccess()
  SoloTreasureDataModel:InitBoardSnapshotOnLogin()
  SoloTreasureDataModel:Init()
  ReddotManager.PrintNodeTree("SoloTreasure_LevelListView")
end

return Component
