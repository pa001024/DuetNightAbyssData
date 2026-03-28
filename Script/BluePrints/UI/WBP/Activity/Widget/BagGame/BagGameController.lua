local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
  M.Super.Init(self)
  self.isProcessingCallback = false
end

function M:Destory()
  M.Super.Destory(self)
end

function M:GetEventName()
  return EventID.BagGameControllerEvent
end

function M:GetModel()
  return BagGameModel
end

function M:OpenPlayUI(LevelId, LevelContent, Owner)
  local Params = {Owner = Owner, Content = LevelContent}
  UIManager(Owner):LoadUINew("BagGamePlay", Params)
end

function M:GetView(WorldContex, UIName)
  return M.Super.GetView(self, WorldContex, UIName)
end

function M:StartGame(LevelId)
  return self:GetModel():InitGameState(LevelId)
end

function M:ResetGame()
  local Model = self:GetModel()
  if Model.CurrentLevelId then
    Model:InitGameState(Model.CurrentLevelId)
  end
end

function M:FinishGame(Callback)
  local Model = self:GetModel()
  local LevelId = Model.CurrentLevelId
  local Score = Model:CalculateCurrentScore()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Cb(ErrCode, Ret)
    DebugPrint("FinishGame", ErrorCode:Name(ErrCode))
    if ErrCode == ErrorCode.RET_SUCCESS then
      Callback(true)
    else
      Callback(false)
      local ErrorCodeData = DataMgr.ErrorCode[ErrCode]
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(ErrorCodeData.ErrorCodeContent))
    end
  end
  
  Avatar:BackpackPuzzleFinishGame(LevelId, Score, Cb)
end

function M:CanPlaceItem(BaseRow, BaseCol, ShapeCells)
  return self:GetModel():CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
end

function M:PlaceItem(PlacedRecord)
  local Model = self:GetModel()
  if PlacedRecord.Cells then
    for _, Cell in ipairs(PlacedRecord.Cells) do
      Model:MarkCellOccupied(Cell.Row, Cell.Col, PlacedRecord.DisPlayItemId)
    end
  end
  Model:AddPlacedItem(PlacedRecord)
  Model:SetUnconfirmedItem(PlacedRecord.Widget)
  return true
end

function M:ConfirmPlacedItem(PlacedWidget)
  local Model = self:GetModel()
  if Model:GetUnconfirmedItem() ~= PlacedWidget then
    return false
  end
  Model:SetUnconfirmedItem(nil)
  return true
end

function M:RecycleItem(PlacedWidget)
  local Model = self:GetModel()
  local PlacedRecord, RecordIndex = Model:FindPlacedItemByWidget(PlacedWidget)
  if not PlacedRecord then
    return nil
  end
  if PlacedRecord.Cells then
    for _, Cell in ipairs(PlacedRecord.Cells) do
      Model:ClearCellOccupied(Cell.Row, Cell.Col)
    end
  end
  Model:RemovePlacedItem(RecordIndex)
  if Model:GetUnconfirmedItem() == PlacedWidget then
    Model:SetUnconfirmedItem(nil)
  end
  return PlacedRecord
end

function M:PickUpPlacedItem(PlacedWidget)
  return self:RecycleItem(PlacedWidget)
end

function M:HasUnconfirmedItem()
  return self:GetModel():HasUnconfirmedItem()
end

function M:CalculateScore()
  return self:GetModel():CalculateCurrentScore()
end

function M:OpenRewardPopup(Widget, Type)
  local Params = self:GetModel():BuildRewardParams(Type)
  for LevelId, Data in pairs(Params.ConfigData.Datas) do
    function Data.ReceiveAllCallBack(ReceiveAllParm)
      self:GetAllRewards(ReceiveAllParm)
    end
    
    Data.ReceiveAllParam = {
      RewardModel = self,
      Type = LevelId,
      SelfWidget = nil
    }
    for _, Item in ipairs(Data.Items) do
      function Item.ReceiveCallBack(RewardItem, Content)
        self:GetReward(RewardItem, Content)
      end
      
      Item.ReceiveParm = {RewardModel = self}
    end
  end
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowCommonPopupUI(100213, Params, Widget)
end

function M:GetReward(RewardItem, Content)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Model = self:GetModel()
  local LevelId = Content.ConfigData.Type
  local RewardIndex = Content.ConfigData.Index
  
  local function Callback(ErrCode, Rewards)
    local FinishScore = Model:GetPlayerFinishScore(LevelId)
    local RewardsGot = Model:GetPlayerRewardsGot(LevelId)
    local TargetScore = Content.ConfigData.Score
    Content.ConfigData.CanReceive = false
    Content.ConfigData.RewardsGot = false
    if FinishScore < TargetScore then
      Content.ConfigData.InProgress = true
    else
      Content.ConfigData.InProgress = false
      local GotState = RewardsGot[RewardIndex]
      if 2 == GotState then
        Content.ConfigData.CanReceive = false
        Content.ConfigData.RewardsGot = true
      else
        Content.ConfigData.CanReceive = true
        Content.ConfigData.RewardsGot = false
      end
    end
    Content.SelfWidget:RefreshBtn(0 == ErrCode)
    Content.Owner:RefreshButton(Model:HasRewardToGet(LevelId))
    if not ErrorCode:Check(ErrCode) then
      return
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      RewardItem:SetFocus()
    end, RewardItem)
  end
  
  Avatar:BackpackPuzzleGetScoreReward(LevelId, RewardIndex, Callback)
end

function M:GetAllRewards(ReceiveAllParm)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Model = self:GetModel()
  local LevelId = ReceiveAllParm.Type
  
  local function Callback(ErrCode, Rewards)
    for i = 0, ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
      local Content = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
      local ItemLevelId = Content.ConfigData.Type
      local FinishScore = Model:GetPlayerFinishScore(ItemLevelId)
      local RewardsGot = Model:GetPlayerRewardsGot(ItemLevelId)
      local TargetScore = Content.ConfigData.Score
      local ItemIndex = Content.ConfigData.Index
      Content.ConfigData.CanReceive = false
      Content.ConfigData.RewardsGot = false
      if FinishScore < TargetScore then
        Content.ConfigData.InProgress = true
      else
        Content.ConfigData.InProgress = false
        local GotState = RewardsGot[ItemIndex]
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
    ReceiveAllParm.SelfWidget:RefreshButton(Model:HasRewardToGet(LevelId))
    if not ErrorCode:Check(ErrCode) then
      return
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      ReceiveAllParm.SelfWidget:SetFocus()
    end, ReceiveAllParm.SelfWidget)
  end
  
  Avatar:BackpackPuzzleGetAllScoreReward(LevelId, Callback)
end

function M:CheckHaveRewardToGet(LevelId)
  return self:GetModel():HasRewardToGet(LevelId)
end

function M:GetLevelsInfo()
  return self:GetModel():GetLevelsInfo()
end

function M:GetLevelCount()
  return self:GetModel():GetLevelCount()
end

function M:GetLevelInfo(LevelId)
  return self:GetModel():GetLevelInfo(LevelId)
end

function M:GetPlayerFinishScore(LevelId)
  return self:GetModel():GetPlayerFinishScore(LevelId)
end

function M:GetPlayerStarCount(LevelId)
  return self:GetModel():GetPlayerStarCount(LevelId)
end

function M:GetLevelMaxTargetScore(LevelId)
  return self:GetModel():GetLevelMaxTargetScore(LevelId)
end

function M:BuildItemContent(TemplateId)
  return self:GetModel():BuildItemContent(TemplateId)
end

function M:ParseItemGrid(ItemGrid)
  return self:GetModel():ParseItemGrid(ItemGrid)
end

function M:ParseGridDistribute(GridDistribute)
  return self:GetModel():ParseGridDistribute(GridDistribute)
end

_G.BagGameController = M
return M
