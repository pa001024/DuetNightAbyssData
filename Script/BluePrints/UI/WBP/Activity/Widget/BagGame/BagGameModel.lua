local EMCache = require("EMCache.EMCache")
local TimeUtils = require("Utils.TimeUtils")
local M = Class("BluePrints.Common.MVC.Model")
M.GRID_ROWS = 8
M.GRID_COLS = 10
M.VALUE_UNCLICKABLE = 0
M.VALUE_SINGLE_REWARD = 1
M.VALUE_DOUBLE_REWARD = 2
M.VALUE_BLOCKED = -1
M.ItemType = {
  Gun = "Gun",
  Ammo = "Ammo",
  Other = "Other"
}

local function SanitizeGridDistribute(GridDistribute)
  if type(GridDistribute) ~= "string" then
    return GridDistribute
  end
  local CleanValue = GridDistribute
  CleanValue = string.gsub(CleanValue, "\\n", "")
  CleanValue = string.gsub(CleanValue, "/n", "")
  CleanValue = string.gsub(CleanValue, "\r", "")
  CleanValue = string.gsub(CleanValue, "\n", "")
  return CleanValue
end

function M:Init()
  M.Super.Init(self)
  self.CurEventId = DataMgr.BackpackPuzzleConstant and DataMgr.BackpackPuzzleConstant.BagGameEventId and DataMgr.BackpackPuzzleConstant.BagGameEventId.ConstantValue or 103015
  self.EventStartTime = DataMgr.EventMain[self.CurEventId].EventStartTime
  self.EventEndTime = DataMgr.EventMain[self.CurEventId].EventEndTime
  self.LevelsInfo = nil
  self.CurrentLevelId = nil
  self.CurrentScore = 0
  self.GridMatrix = nil
  self.OccupiedMatrix = nil
  self.PlacedItems = {}
  self.CurrentUnconfirmedItem = nil
  self:InitLevelsInfo()
end

function M:Destory()
  self:ClearGameState()
  M.Super.Destory(self)
end

function M:InitLevelsInfo()
  self.LevelsInfo = {}
  local BackpackPuzzleLevel = DataMgr.BackpackPuzzleLevel
  if not BackpackPuzzleLevel then
    return
  end
  local BackpackPuzzleLevelInfo = CommonUtils.CopyTable(BackpackPuzzleLevel)
  for _, Info in pairs(BackpackPuzzleLevelInfo) do
    Info.GridDistribute = SanitizeGridDistribute(Info.GridDistribute)
    table.insert(self.LevelsInfo, Info)
  end
  table.sort(self.LevelsInfo, function(A, B)
    return A.LevelId < B.LevelId
  end)
end

function M:GetLevelsInfo()
  self:InitLevelsInfo()
  return self.LevelsInfo
end

function M:GetEventEndTime()
  if not self.CurEventId then
    self.CurEventId = DataMgr.BackpackPuzzleConstant and DataMgr.BackpackPuzzleConstant.BagGameEventId and DataMgr.BackpackPuzzleConstant.BagGameEventId.ConstantValue or 103015
  end
  if not self.EventEndTime and self.CurEventId and DataMgr.EventMain[self.CurEventId] then
    self.EventStartTime = self.EventStartTime or DataMgr.EventMain[self.CurEventId].EventStartTime
    self.EventEndTime = DataMgr.EventMain[self.CurEventId].EventEndTime
  end
  return self.EventEndTime
end

function M:IsActivityEnded()
  local EventEndTime = self:GetEventEndTime():GetTime()
  return EventEndTime > 0 and EventEndTime < TimeUtils.NowTime()
end

function M:GetLevelCount()
  return self.LevelsInfo and #self.LevelsInfo or 0
end

function M:GetLevelInfo(LevelId)
  local BackpackPuzzleLevelInfo = DataMgr.BackpackPuzzleLevel
  return BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo[LevelId]
end

function M:GetLevelTargetScores(LevelId)
  local LevelInfo = self:GetLevelInfo(LevelId)
  return LevelInfo and LevelInfo.TargetScore or {}
end

function M:GetLevelMaxTargetScore(LevelId)
  local TargetScores = self:GetLevelTargetScores(LevelId)
  local MaxScore = 0
  for _, Score in ipairs(TargetScores) do
    if Score > MaxScore then
      MaxScore = Score
    end
  end
  return MaxScore
end

function M:GetPlayerFinishScore(LevelId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.BackpackPuzzles then
    return 0
  end
  local LevelInfo = Avatar.BackpackPuzzles[LevelId]
  return LevelInfo and LevelInfo.FinishScore or 0
end

function M:GetPlayerRewardsGot(LevelId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.BackpackPuzzles then
    return {}
  end
  local LevelInfo = Avatar.BackpackPuzzles[LevelId]
  return LevelInfo and LevelInfo.ScoreRewardsGot or {}
end

function M:GetPlayerStarCount(LevelId)
  local FinishScore = self:GetPlayerFinishScore(LevelId)
  local TargetScores = self:GetLevelTargetScores(LevelId)
  local StarCount = 0
  for _, TargetScore in ipairs(TargetScores) do
    if TargetScore <= FinishScore then
      StarCount = StarCount + 1
    end
  end
  return StarCount
end

function M:CanReceiveReward(LevelId, ScoreIndex)
  local FinishScore = self:GetPlayerFinishScore(LevelId)
  local TargetScores = self:GetLevelTargetScores(LevelId)
  local RewardsGot = self:GetPlayerRewardsGot(LevelId)
  if not TargetScores[ScoreIndex] then
    return false
  end
  local TargetScore = TargetScores[ScoreIndex]
  return FinishScore >= TargetScore and 2 ~= RewardsGot[ScoreIndex]
end

function M:HasRewardToGet(LevelId)
  local FinishScore = self:GetPlayerFinishScore(LevelId)
  local TargetScores = self:GetLevelTargetScores(LevelId)
  local RewardsGot = self:GetPlayerRewardsGot(LevelId)
  for i, TargetScore in ipairs(TargetScores) do
    if TargetScore <= FinishScore and 2 ~= RewardsGot[i] then
      return true
    end
  end
  return false
end

function M:GetItemTemplate(TemplateId)
  return DataMgr.PuzzleItemTemplate and DataMgr.PuzzleItemTemplate[TemplateId]
end

function M:GetItemAttr(ItemId)
  return DataMgr.PuzzleItemAttr and DataMgr.PuzzleItemAttr[ItemId]
end

function M:BuildItemContent(TemplateId)
  local TemplateData = self:GetItemTemplate(TemplateId)
  local ItemId = TemplateData and TemplateData.ItemId or TemplateId
  local AttrData = self:GetItemAttr(ItemId)
  return {
    TemplateId = TemplateId,
    ItemId = ItemId,
    CurrentAmmo = TemplateData and TemplateData.CurrentAmmo or 0,
    CurrentStack = TemplateData and TemplateData.CurrentStack or 0,
    ItemType = AttrData and AttrData.ItemType or "Other",
    ItemName = AttrData and AttrData.ItemName or "Item_" .. ItemId,
    ItemGrid = AttrData and AttrData.ItemGrid or "[1]",
    BasicPoint = AttrData and AttrData.BasicPoint or 0,
    GUIPath = AttrData and AttrData.GUIPath or "",
    MaxAmmo = AttrData and AttrData.MaxAmmo or 0,
    MaxStack = AttrData and AttrData.MaxStack or 0,
    IsMirror = AttrData and AttrData.IsMirror or false
  }
end

function M:ParseItemGrid(ItemGrid)
  local Offsets = {}
  if not ItemGrid or "" == ItemGrid then
    return {
      {0, 0}
    }
  end
  local Row = 0
  for RowStr in string.gmatch(ItemGrid, "%[([^%]]+)%]") do
    local Col = 0
    for Value in string.gmatch(RowStr, "(%d+)") do
      if 1 == tonumber(Value) then
        table.insert(Offsets, {Row, Col})
      end
      Col = Col + 1
    end
    Row = Row + 1
  end
  if 0 == #Offsets then
    return {
      {0, 0}
    }
  end
  return Offsets
end

function M:CreateGridMatrix()
  local Matrix = {}
  for Row = 1, M.GRID_ROWS do
    Matrix[Row] = {}
    for Col = 1, M.GRID_COLS do
      Matrix[Row][Col] = 0
    end
  end
  return Matrix
end

function M:ParseGridDistribute(GridDistribute)
  local Matrix = self:CreateGridMatrix()
  GridDistribute = SanitizeGridDistribute(GridDistribute)
  if not GridDistribute or "" == GridDistribute then
    return Matrix
  end
  local Row = 1
  for RowStr in string.gmatch(GridDistribute, "%[([^%]]+)%]") do
    if Row > M.GRID_ROWS then
      break
    end
    local Col = 1
    for Value in string.gmatch(RowStr, "([%-]?%d+)") do
      if Col > M.GRID_COLS then
        break
      end
      Matrix[Row][Col] = tonumber(Value) or 0
      Col = Col + 1
    end
    Row = Row + 1
  end
  return Matrix
end

function M:GetGridValue(Row, Col)
  if not self.GridMatrix then
    return nil
  end
  if Row < 1 or Row > M.GRID_ROWS or Col < 1 or Col > M.GRID_COLS then
    return nil
  end
  return self.GridMatrix[Row][Col]
end

function M:SetGridValue(Row, Col, Value)
  if not self.GridMatrix then
    return
  end
  if Row < 1 or Row > M.GRID_ROWS or Col < 1 or Col > M.GRID_COLS then
    return
  end
  self.GridMatrix[Row][Col] = Value
end

function M:IsCellOccupied(Row, Col)
  if not self.OccupiedMatrix then
    return false
  end
  if not self.OccupiedMatrix[Row] then
    return false
  end
  return self.OccupiedMatrix[Row][Col] ~= nil
end

function M:MarkCellOccupied(Row, Col, PlacedItemId)
  if Row < 1 or Row > M.GRID_ROWS or Col < 1 or Col > M.GRID_COLS then
    return
  end
  if not self.OccupiedMatrix then
    self.OccupiedMatrix = {}
    for r = 1, M.GRID_ROWS do
      self.OccupiedMatrix[r] = {}
    end
  end
  self.OccupiedMatrix[Row][Col] = PlacedItemId
end

function M:ClearCellOccupied(Row, Col)
  if self.OccupiedMatrix and self.OccupiedMatrix[Row] then
    self.OccupiedMatrix[Row][Col] = nil
  end
end

function M:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
  for _, Cell in ipairs(ShapeCells) do
    local Row, Col = Cell.Row, Cell.Col
    if Row >= 1 and Row <= M.GRID_ROWS and Col >= 1 and Col <= M.GRID_COLS then
      local Value = self:GetGridValue(Row, Col)
      if nil == Value or Value == M.VALUE_BLOCKED then
        return false
      end
      if self:IsCellOccupied(Row, Col) then
        return false
      end
    end
  end
  return true
end

function M:InitGameState(LevelId)
  local LevelInfo = self:GetLevelInfo(LevelId)
  if not LevelInfo then
    DebugPrint("BagGameModel:InitGameState - 未找到关卡数据:", LevelId)
    return false
  end
  self.CurrentLevelId = LevelId
  self.CurrentScore = 0
  self.GridMatrix = self:ParseGridDistribute(LevelInfo.GridDistribute)
  self.OccupiedMatrix = {}
  for r = 1, M.GRID_ROWS do
    self.OccupiedMatrix[r] = {}
  end
  self.PlacedItems = {}
  self.CurrentUnconfirmedItem = nil
  return true
end

function M:ClearGameState()
  self.CurrentLevelId = nil
  self.CurrentScore = 0
  self.GridMatrix = nil
  self.OccupiedMatrix = nil
  self.PlacedItems = {}
  self.CurrentUnconfirmedItem = nil
end

function M:AddPlacedItem(PlacedRecord)
  table.insert(self.PlacedItems, PlacedRecord)
end

function M:RemovePlacedItem(RecordIndex)
  if RecordIndex and self.PlacedItems[RecordIndex] then
    table.remove(self.PlacedItems, RecordIndex)
  end
end

function M:FindPlacedItemByWidget(Widget)
  for i, Record in ipairs(self.PlacedItems) do
    if Record.Widget == Widget then
      return Record, i
    end
  end
  return nil, nil
end

function M:GetPlacedItems()
  return self.PlacedItems
end

function M:SetUnconfirmedItem(ItemWidget)
  self.CurrentUnconfirmedItem = ItemWidget
end

function M:GetUnconfirmedItem()
  return self.CurrentUnconfirmedItem
end

function M:HasUnconfirmedItem()
  return self.CurrentUnconfirmedItem ~= nil
end

function M:GetAmmoBasePoint()
  if DataMgr.PuzzleItemAttr then
    for _, AttrData in pairs(DataMgr.PuzzleItemAttr) do
      if AttrData.ItemType == M.ItemType.Ammo then
        return AttrData.BasicPoint or 10
      end
    end
  end
  return 10
end

function M:CalculateItemBaseScore(PlacedRecord)
  if not PlacedRecord then
    return 0
  end
  local BasicPoint = PlacedRecord.BasicPoint or 0
  local ItemType = PlacedRecord.ItemType
  if ItemType == M.ItemType.Gun then
    local AmmoBasePoint = self:GetAmmoBasePoint()
    local CurrentAmmo = PlacedRecord.CurrentAmmo or 0
    local Score = BasicPoint + CurrentAmmo * AmmoBasePoint
    DebugPrint(string.format("Gun得分计算: 基础分=%d + 装弹数=%d × 弹药分=%d = %d", BasicPoint, CurrentAmmo, AmmoBasePoint, Score))
    return Score
  elseif ItemType == M.ItemType.Other then
    local CurrentStack = PlacedRecord.CurrentStack or 1
    local Score = BasicPoint * CurrentStack
    DebugPrint(string.format("Other得分计算: 基础分=%d × 堆叠数=%d = %d", BasicPoint, CurrentStack, Score))
    return Score
  elseif ItemType == M.ItemType.Ammo then
    local CurrentStack = PlacedRecord.CurrentStack or 1
    local Score = BasicPoint * CurrentStack
    DebugPrint(string.format("Ammo得分计算: 基础分=%d × 堆叠数=%d = %d", BasicPoint, CurrentStack, Score))
    return Score
  else
    return BasicPoint
  end
end

function M:CanItemScore(PlacedRecord)
  if not PlacedRecord or not PlacedRecord.Cells then
    return false
  end
  for _, Cell in ipairs(PlacedRecord.Cells) do
    local Value = self:GetGridValue(Cell.Row, Cell.Col)
    if not Value or Value == M.VALUE_UNCLICKABLE or Value == M.VALUE_BLOCKED then
      DebugPrint(string.format("物品不可得分: 格子(%d,%d)值=%s", Cell.Row, Cell.Col, tostring(Value)))
      return false
    end
  end
  return true
end

function M:AreAllPlacedItemsScoring()
  if not self.PlacedItems then
    return true
  end
  for _, Record in ipairs(self.PlacedItems) do
    if not self:CanItemScore(Record) then
      return false
    end
  end
  return true
end

function M:IsItemAllOnDoubleReward(PlacedRecord)
  if not PlacedRecord or not PlacedRecord.Cells then
    return false
  end
  for _, Cell in ipairs(PlacedRecord.Cells) do
    local Value = self:GetGridValue(Cell.Row, Cell.Col)
    if Value ~= M.VALUE_DOUBLE_REWARD then
      return false
    end
  end
  return true
end

function M:CalculateCurrentScore()
  local DoubleRewardScore = 0
  local NormalRewardScore = 0
  for _, Record in ipairs(self.PlacedItems) do
    if self:CanItemScore(Record) then
      local ItemScore = self:CalculateItemBaseScore(Record)
      if self:IsItemAllOnDoubleReward(Record) then
        DoubleRewardScore = DoubleRewardScore + ItemScore
        DebugPrint(string.format("物品 %s 全在额外得分格，基础分=%d（将×2）", tostring(Record.DisPlayItemId), ItemScore))
      else
        NormalRewardScore = NormalRewardScore + ItemScore
        DebugPrint(string.format("物品 %s 在普通得分格，基础分=%d", tostring(Record.DisPlayItemId), ItemScore))
      end
    else
      DebugPrint(string.format("物品 %s 不可得分（有格子在不可得分区域）", tostring(Record.DisPlayItemId)))
    end
  end
  local TotalScore = DoubleRewardScore * 2 + NormalRewardScore
  self.CurrentScore = TotalScore
  DebugPrint(string.format("得分计算完成: 双倍区得分=%d×2=%d, 普通区得分=%d, 总分=%d", DoubleRewardScore, DoubleRewardScore * 2, NormalRewardScore, TotalScore))
  return TotalScore, DoubleRewardScore, NormalRewardScore
end

function M:IsAmmoItem(TemplateId)
  local Content = self:BuildItemContent(TemplateId)
  return Content and Content.ItemType == M.ItemType.Ammo
end

function M:IsGunItem(PlacedRecord)
  if not PlacedRecord or not PlacedRecord.TemplateId then
    return false
  end
  local Content = self:BuildItemContent(PlacedRecord.TemplateId)
  return Content and Content.ItemType == M.ItemType.Gun
end

function M:GetPlacedItemContent(PlacedRecord)
  if not PlacedRecord or not PlacedRecord.TemplateId then
    return nil
  end
  return self:BuildItemContent(PlacedRecord.TemplateId)
end

function M:CheckCellsOverlap(Cells1, Cells2)
  if not Cells1 or not Cells2 then
    return false
  end
  for _, Cell1 in ipairs(Cells1) do
    for _, Cell2 in ipairs(Cells2) do
      if Cell1.Row == Cell2.Row and Cell1.Col == Cell2.Col then
        return true
      end
    end
  end
  return false
end

function M:FindOverlappingGun(AmmoShapeCells)
  if not AmmoShapeCells or 0 == #AmmoShapeCells then
    return nil, false
  end
  for _, Record in ipairs(self.PlacedItems) do
    if self:IsGunItem(Record) and Record.Cells and self:CheckCellsOverlap(AmmoShapeCells, Record.Cells) then
      local GunContent = self:GetPlacedItemContent(Record)
      if GunContent then
        local CurrentAmmo = Record.CurrentAmmo or GunContent.CurrentAmmo or 0
        local MaxAmmo = GunContent.MaxAmmo or 0
        local bCanLoad = CurrentAmmo < MaxAmmo
        return Record, bCanLoad
      end
    end
  end
  return nil, false
end

function M:CalculateLoadResult(GunRecord, AmmoTemplateId, ActualCurrentStack)
  if not GunRecord then
    return 0, 0, false
  end
  local GunContent = self:GetPlacedItemContent(GunRecord)
  local AmmoContent = self:BuildItemContent(AmmoTemplateId)
  if not GunContent or not AmmoContent then
    return 0, 0, false
  end
  local CurrentAmmo = GunRecord.CurrentAmmo or GunContent.CurrentAmmo or 0
  local MaxAmmo = GunContent.MaxAmmo or 0
  local AvailableAmmo = nil ~= ActualCurrentStack and ActualCurrentStack or AmmoContent.CurrentStack or 0
  local CanLoad = MaxAmmo - CurrentAmmo
  local ActualLoad = math.min(CanLoad, AvailableAmmo)
  local Remaining = AvailableAmmo - ActualLoad
  return ActualLoad, Remaining, ActualLoad > 0
end

function M:ExecuteLoadAmmo(GunRecord, LoadAmount)
  if not GunRecord or LoadAmount <= 0 then
    return false
  end
  local GunContent = self:GetPlacedItemContent(GunRecord)
  if not GunContent then
    return false
  end
  local CurrentAmmo = GunRecord.CurrentAmmo or GunContent.CurrentAmmo or 0
  GunRecord.CurrentAmmo = CurrentAmmo + LoadAmount
  DebugPrint("ExecuteLoadAmmo: 武器装配完成，当前弹药=" .. GunRecord.CurrentAmmo)
  return true
end

function M:IsGunAmmoFull(GunRecord)
  if not GunRecord then
    return false
  end
  local GunContent = self:GetPlacedItemContent(GunRecord)
  if not GunContent then
    return false
  end
  local CurrentAmmo = GunRecord.CurrentAmmo or GunContent.CurrentAmmo or 0
  local MaxAmmo = GunContent.MaxAmmo or 0
  return CurrentAmmo >= MaxAmmo
end

function M:IsOtherItem(TemplateId)
  local Content = self:BuildItemContent(TemplateId)
  return Content and Content.ItemType == M.ItemType.Other
end

function M:IsPlacedOtherItem(PlacedRecord)
  if not PlacedRecord or not PlacedRecord.TemplateId then
    return false
  end
  local Content = self:BuildItemContent(PlacedRecord.TemplateId)
  return Content and Content.ItemType == M.ItemType.Other
end

function M:IsSameItem(TemplateId1, TemplateId2)
  local Content1 = self:BuildItemContent(TemplateId1)
  local Content2 = self:BuildItemContent(TemplateId2)
  if not Content1 or not Content2 then
    return false
  end
  return Content1.ItemId == Content2.ItemId
end

function M:FindOverlappingSameOther(DragTemplateId, DragShapeCells)
  if not DragShapeCells or 0 == #DragShapeCells then
    return nil, false
  end
  if not self:IsOtherItem(DragTemplateId) then
    return nil, false
  end
  for _, Record in ipairs(self.PlacedItems) do
    if self:IsPlacedOtherItem(Record) and self:IsSameItem(DragTemplateId, Record.TemplateId) and Record.Cells and self:CheckCellsOverlap(DragShapeCells, Record.Cells) then
      local OtherContent = self:GetPlacedItemContent(Record)
      if OtherContent then
        local CurrentStack = Record.CurrentStack or OtherContent.CurrentStack or 0
        local MaxStack = OtherContent.MaxStack or 0
        local bCanStack = CurrentStack < MaxStack
        return Record, bCanStack
      end
    end
  end
  return nil, false
end

function M:FindOverlappingSameAmmo(DragTemplateId, DragShapeCells)
  if not DragShapeCells or 0 == #DragShapeCells then
    return nil, false
  end
  if not self:IsAmmoItem(DragTemplateId) then
    return nil, false
  end
  for _, Record in ipairs(self.PlacedItems) do
    if Record.ItemType == M.ItemType.Ammo and self:IsSameItem(DragTemplateId, Record.TemplateId) and Record.Cells and self:CheckCellsOverlap(DragShapeCells, Record.Cells) then
      local AmmoContent = self:GetPlacedItemContent(Record)
      if AmmoContent then
        local CurrentStack = Record.CurrentStack or AmmoContent.CurrentStack or 0
        local MaxStack = AmmoContent.MaxStack or 0
        return Record, CurrentStack < MaxStack
      end
    end
  end
  return nil, false
end

function M:FindOverlappingPlacedItem(DragShapeCells)
  if not DragShapeCells or 0 == #DragShapeCells then
    return nil
  end
  for _, Record in ipairs(self.PlacedItems) do
    if Record.Cells and self:CheckCellsOverlap(DragShapeCells, Record.Cells) then
      return Record
    end
  end
  return nil
end

function M:CalculateStackResult(TargetRecord, SourceTemplateId, ActualSourceCurrentStack)
  if not TargetRecord then
    return 0, 0, false
  end
  local TargetContent = self:GetPlacedItemContent(TargetRecord)
  local SourceContent = self:BuildItemContent(SourceTemplateId)
  if not TargetContent or not SourceContent then
    return 0, 0, false
  end
  local CurrentStack = TargetRecord.CurrentStack or TargetContent.CurrentStack or 0
  local MaxStack = TargetContent.MaxStack or 0
  local AvailableStack = nil ~= ActualSourceCurrentStack and ActualSourceCurrentStack or SourceContent.CurrentStack or 0
  local CanStack = MaxStack - CurrentStack
  local ActualStack = math.min(CanStack, AvailableStack)
  local Remaining = AvailableStack - ActualStack
  return ActualStack, Remaining, ActualStack > 0
end

function M:ExecuteStack(TargetRecord, StackAmount)
  if not TargetRecord or StackAmount <= 0 then
    return false
  end
  local TargetContent = self:GetPlacedItemContent(TargetRecord)
  if not TargetContent then
    return false
  end
  local CurrentStack = TargetRecord.CurrentStack or TargetContent.CurrentStack or 0
  TargetRecord.CurrentStack = CurrentStack + StackAmount
  DebugPrint("ExecuteStack: 物品堆叠完成，当前堆叠数=" .. TargetRecord.CurrentStack)
  return true
end

function M:IsOtherStackFull(OtherRecord)
  if not OtherRecord then
    return false
  end
  local OtherContent = self:GetPlacedItemContent(OtherRecord)
  if not OtherContent then
    return false
  end
  local CurrentStack = OtherRecord.CurrentStack or OtherContent.CurrentStack or 0
  local MaxStack = OtherContent.MaxStack or 0
  return CurrentStack >= MaxStack
end

function M:BuildRewardParams(Type)
  local Params = {}
  local ConfigData = {
    HasTab = true,
    ReddotName = "BagGameAward",
    TabInfo = {},
    Datas = {}
  }
  if Type then
    ConfigData.Type = Type
  end
  local LevelsInfo = self:GetLevelsInfo()
  local Avatar = GWorld:GetAvatar()
  local BackpackPuzzleEventInfo = Avatar and Avatar.BackpackPuzzles
  for _, Info in ipairs(LevelsInfo) do
    local TableItem = {}
    TableItem.Title = Info.LevelName
    TableItem.Type = Info.LevelId
    TableItem.ReddotName = "BagGameAward"
    TableItem.IsShowIcon = false
    table.insert(ConfigData.TabInfo, TableItem)
    local SumNum = #Info.TargetReward
    local BackpackPuzzleLevelInfo = BackpackPuzzleEventInfo and BackpackPuzzleEventInfo[Info.LevelId]
    local MaxScore = BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo.FinishScore or 0
    local RewardsGotInfo = BackpackPuzzleLevelInfo and BackpackPuzzleLevelInfo.ScoreRewardsGot
    local Data = {
      Items = {}
    }
    local CurrentNum = 0
    for i = 1, SumNum do
      local Item = {}
      Item.Score = Info.TargetScore[i]
      Item.Index = i
      Item.Type = Info.LevelId
      Item.CanReceive = false
      Item.RewardsGot = false
      if MaxScore < Item.Score then
        Item.InProgress = true
      else
        CurrentNum = CurrentNum + 1
        Item.InProgress = false
        local GotState = RewardsGotInfo and RewardsGotInfo[i]
        if 2 == GotState then
          Item.CanReceive = false
          Item.RewardsGot = true
        else
          Item.CanReceive = true
          Item.RewardsGot = false
        end
      end
      Item.NotreachText = GText("UI_EventReward_NotAchieved")
      Item.Hint = string.format(GText("UI_BackpackPuzzle_Target" .. i), Item.Score)
      Item.Rewards = self:BuildRewardContent(Info.TargetReward[i])
      table.insert(Data.Items, Item)
    end
    Data.ShowIcon = false
    Data.ShowSourceNum = true
    Data.Text_Total = GText("UI_EventReward_Achieved")
    Data.NowNum = CurrentNum
    Data.NumMax = SumNum
    Data.ReceiveButtonText = GText("UI_BattlePass_ClaimAll")
    ConfigData.Datas[Info.LevelId] = Data
  end
  Params.ConfigData = ConfigData
  Params.Title = GText("UI_BackpackPuzzle_RewardBtn")
  return Params
end

function M:BuildRewardContent(RewardId)
  local Rewards = {}
  local RewardInfo = DataMgr.Reward and DataMgr.Reward[RewardId]
  if not RewardInfo then
    return Rewards
  end
  local Ids = RewardInfo.Id or {}
  local RewardCount = RewardInfo.Count or {}
  local TableName = RewardInfo.Type or {}
  for i = 1, #Ids do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local ItemId = Ids[i]
    Content.IsShowDetails = true
    Content.Id = ItemId
    Content.ItemId = ItemId
    Content.Count = RewardUtils:GetCount(RewardCount[i])
    Content.Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
    Content.Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
    Content.ItemType = TableName[i]
    Content.bHasGot = false
    table.insert(Rewards, Content)
  end
  return Rewards
end

function M:BuildLevelListContent(LevelInfo, DataIndex)
  local PlayerScore = self:GetPlayerFinishScore(LevelInfo.LevelId)
  return {
    Id = DataIndex,
    LevelId = LevelInfo.LevelId,
    LevelName = LevelInfo.LevelName,
    LevelDes = LevelInfo.LevelDes,
    UnlockDate = LevelInfo.UnlockDate,
    TargetScore = LevelInfo.TargetScore,
    TargetReward = LevelInfo.TargetReward,
    LevelInitialItem = LevelInfo.LevelInitialItem,
    GridDistribute = LevelInfo.GridDistribute,
    PlayerScore = PlayerScore
  }
end

function M:BuildSettlementRewardContents(TotalScore, TargetScores, TargetRewards)
  local RewardContents = {}
  if not TargetScores or not TargetRewards then
    return RewardContents
  end
  for i, Score in ipairs(TargetScores) do
    if Score <= TotalScore and TargetRewards[i] then
      local Items = self:BuildRewardContent(TargetRewards[i])
      for _, Content in ipairs(Items) do
        table.insert(RewardContents, Content)
      end
    end
  end
  return RewardContents
end

function M:ConvertIndex2Roman(Index)
  if Index < 10 then
    return tostring(Index)
  elseif 10 == Index then
    return "A"
  elseif 11 == Index then
    return "B"
  elseif 12 == Index then
    return "C"
  end
  return tostring(Index)
end

return M
