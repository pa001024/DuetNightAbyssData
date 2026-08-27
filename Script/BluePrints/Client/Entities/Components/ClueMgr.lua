local Component = {}

local function RequestStringBoardReddotSync()
  local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
  StringBoardReddotHelper.RequestSyncAllNews()
end

local function SyncStringBoardProgressRewardReddot()
  local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
  InvestigationWallUtils.NotifyProgressRewardEntranceReddotRefresh()
end

function Component:EnterWorld()
  local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
  StringBoardReddotHelper.SyncAllNews()
end

function Component:_OnLoginSuccess()
  local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
  StringBoardReddotHelper.SyncAllNews()
end

function Component:_OnPropChangeClues(Keys)
  RequestStringBoardReddotSync()
end

function Component:_OnPropChangeClueRewards(Keys)
  SyncStringBoardProgressRewardReddot()
end

function Component:LeaveWorld()
  local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
  InvestigationWallUtils.ClearLocalProgressRewardClaimOverrides()
end

function Component:GetClueReward(SortID, InCallback)
  self.logger.debug("GetClueReward Begin", SortID)
  
  local function Callback(Ret, Rewards)
    self.logger.debug("GetClueReward Callback ", Ret, SortID, Rewards)
    if InCallback then
      InCallback(Ret, Rewards)
    end
  end
  
  self:CallServer("GetClueReward", Callback, SortID)
end

function Component:GetAllClueReward(InCallback)
  self.logger.debug("GetAllClueReward Begin")
  
  local function Callback(Ret, Rewards)
    self.logger.debug("GetAllClueReward Callback ", Ret, Rewards)
    if InCallback then
      InCallback(Ret, Rewards)
    end
  end
  
  self:CallServer("GetAllClueReward", Callback)
end

return Component
