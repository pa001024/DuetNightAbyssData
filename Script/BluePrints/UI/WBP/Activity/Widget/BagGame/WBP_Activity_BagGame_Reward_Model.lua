local BagGameController = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameController")
local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local ActivityBagGameRewardModel = {}
ActivityBagGameRewardModel.CurEventId = DataMgr.BackpackPuzzleConstant and DataMgr.BackpackPuzzleConstant.BagGameEventId and DataMgr.BackpackPuzzleConstant.BagGameEventId.ConstantValue or 103015

function ActivityBagGameRewardModel:OpenReward(Widget, Type)
  self:SetRewardParams(Type)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowCommonPopupUI(100213, self.Params, Widget)
end

function ActivityBagGameRewardModel:SetRewardParams(Type)
  self.Params = BagGameModel:BuildRewardParams(Type)
  for LevelId, Data in pairs(self.Params.ConfigData.Datas) do
    Data.ReceiveAllCallBack = self.GetAllRewards
    Data.ReceiveAllParam = {RewardModel = self, Type = LevelId}
    for _, Item in ipairs(Data.Items) do
      Item.ReceiveCallBack = self.GetRewards
      Item.ReceiveParm = {RewardModel = self}
    end
  end
end

function ActivityBagGameRewardModel.GetRewards(RewardItem, Content)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Callback(ErrCode, Rewards)
    local BackpackPuzzleLevelInfo = Avatar.BackpackPuzzles and Avatar.BackpackPuzzles[Content.ConfigData.Type]
    local MaxScore = 0
    local RewardsGotInfo
    if BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo.FinishScore then
      MaxScore = BackpackPuzzleLevelInfo.FinishScore
    end
    if BackpackPuzzleLevelInfo then
      RewardsGotInfo = BackpackPuzzleLevelInfo.ScoreRewardsGot
    end
    Content.ConfigData.CanReceive = false
    Content.ConfigData.RewardsGot = false
    if MaxScore < Content.ConfigData.Score then
      Content.ConfigData.InProgress = true
    else
      Content.ConfigData.InProgress = false
      local GotState = RewardsGotInfo and RewardsGotInfo[Content.ConfigData.Index]
      if 2 == GotState then
        Content.ConfigData.CanReceive = false
        Content.ConfigData.RewardsGot = true
      else
        Content.ConfigData.CanReceive = true
        Content.ConfigData.RewardsGot = false
      end
    end
    Content.SelfWidget:RefreshBtn(0 == ErrCode)
    Content.Owner:RefreshButton(Content.ConfigData.ReceiveParm.RewardModel:CheckHaveRewardToGet(Content.ConfigData.Type))
    if not ErrorCode:Check(ErrCode) then
      return
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      RewardItem:SetFocus()
    end, RewardItem)
  end
  
  Avatar:BackpackPuzzleGetScoreReward(Content.ConfigData.Type, Content.ConfigData.Index, Callback)
end

function ActivityBagGameRewardModel:CheckHaveRewardToGet(Type)
  return BagGameModel:HasRewardToGet(Type)
end

function ActivityBagGameRewardModel.GetAllRewards(_PopupWidget, ReceiveAllParm)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Callback(ErrCode, Rewards)
    for i = 0, ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
      local Content = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
      local BackpackPuzzleLevelInfo = Avatar.BackpackPuzzles and Avatar.BackpackPuzzles[Content.ConfigData.Type]
      local MaxScore = 0
      local RewardsGotInfo
      if BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo.FinishScore then
        MaxScore = BackpackPuzzleLevelInfo.FinishScore
      end
      if BackpackPuzzleLevelInfo then
        RewardsGotInfo = BackpackPuzzleLevelInfo.ScoreRewardsGot
      end
      Content.ConfigData.CanReceive = false
      Content.ConfigData.RewardsGot = false
      if MaxScore < Content.ConfigData.Score then
        Content.ConfigData.InProgress = true
      else
        Content.ConfigData.InProgress = false
        local GotState = RewardsGotInfo and RewardsGotInfo[Content.ConfigData.Index]
        if 2 == GotState then
          Content.ConfigData.CanReceive = false
          Content.ConfigData.RewardsGot = true
        else
          Content.ConfigData.CanReceive = true
          Content.ConfigData.RewardsGot = false
        end
      end
      if Content.SelfWidget then
        Content.SelfWidget:RefreshBtn(Content.ConfigData.RewardsGot)
      end
    end
    ReceiveAllParm.SelfWidget:RefreshButton(ReceiveAllParm.RewardModel:CheckHaveRewardToGet(ReceiveAllParm.Type))
    if not ErrorCode:Check(ErrCode) then
      return
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      ReceiveAllParm.SelfWidget:SetFocus()
    end, ReceiveAllParm.SelfWidget)
  end
  
  Avatar:BackpackPuzzleGetAllScoreReward(ReceiveAllParm.Type, Callback)
end

return ActivityBagGameRewardModel
