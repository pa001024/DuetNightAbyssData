local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
  M.Super.Init(self)
  self._Avatar = nil
  self:GetAvatar()
  self.RaceGameSpeed = 1
  self.ShowUIList = {
    "PetRaceInGame",
    "PetRaceInGameStart",
    "ActivityRacingResult",
    "PetRaceStartSkip",
    "BattleMain"
  }
  EventManager:AddEvent(EventID.OnRaceGameTimesSet, self, self.SetRaceGameSpeed)
end

function M:SaveTotalPlayerList(List)
  self.TotalPlayerList = List
end

function M:SaveSpeedInfo(SpeedInfo)
  self.SpeedInfo = SpeedInfo
end

function M:SetChoosePlayerList()
  self.ChoosePlayerList = {}
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.RaceLotteryInfo and Avatar.RaceLotteryInfo.RaceLotteryPlayerList then
    self.ChoosePlayerList = Avatar.RaceLotteryInfo.RaceLotteryPlayerList
  end
  self.ChoosePlayerMap = {}
  for _, PlayerId in ipairs(self.ChoosePlayerList) do
    self.ChoosePlayerMap[PlayerId] = true
  end
  self.ScrollingPlayerList = {}
  self.ScrollingPlayerMap = {}
  self.FinishedPlayerMap = {}
  self:ResetScrollingLaneOrder()
  self:FillScrollingPlayerList()
end

function M:ResetScrollingLaneOrder()
  self.ScrollingLaneOrder = {}
  self.ScrollingLaneCursor = 1
  self.ScrollingLaneCount = 0
  self.LastScrollingLaneIndex = nil
  self.ScrollingLaneWidgetMap = {}
end

function M:SetScrollingLaneWidget(LaneIndex, ScrollingWidget)
  if nil == LaneIndex or not ScrollingWidget then
    return
  end
  self.ScrollingLaneWidgetMap[LaneIndex] = ScrollingWidget
end

function M:GetScrollingLaneWidget(LaneIndex)
  return self.ScrollingLaneWidgetMap and self.ScrollingLaneWidgetMap[LaneIndex] or nil
end

function M:RemoveScrollingLaneWidget(LaneIndex, ScrollingWidget)
  if not self.ScrollingLaneWidgetMap then
    return
  end
  if self.ScrollingLaneWidgetMap[LaneIndex] == ScrollingWidget then
    self.ScrollingLaneWidgetMap[LaneIndex] = nil
  end
end

function M:ShuffleScrollingLaneOrder(LaneCount)
  local LaneOrder = {}
  for LaneIndex = 1, LaneCount do
    LaneOrder[LaneIndex] = LaneIndex
  end
  for Index = LaneCount, 2, -1 do
    local RandomIndex = math.random(1, Index)
    LaneOrder[Index], LaneOrder[RandomIndex] = LaneOrder[RandomIndex], LaneOrder[Index]
  end
  if LaneOrder[1] == self.LastScrollingLaneIndex then
    local SwapIndex = math.random(2, LaneCount)
    LaneOrder[1], LaneOrder[SwapIndex] = LaneOrder[SwapIndex], LaneOrder[1]
  end
  self.ScrollingLaneOrder = LaneOrder
  self.ScrollingLaneCursor = 1
  self.ScrollingLaneCount = LaneCount
end

function M:GetNextScrollingLaneIndex(LaneCount)
  LaneCount = math.max(1, LaneCount)
  if self.ScrollingLaneCount ~= LaneCount then
    self:ResetScrollingLaneOrder()
  end
  if not self.ScrollingLaneOrder or self.ScrollingLaneCursor > #self.ScrollingLaneOrder then
    self:ShuffleScrollingLaneOrder(LaneCount)
  end
  local LaneIndex = self.ScrollingLaneOrder[self.ScrollingLaneCursor]
  self.ScrollingLaneCursor = self.ScrollingLaneCursor + 1
  self.LastScrollingLaneIndex = LaneIndex
  return LaneIndex
end

function M:SetInGameCamera(CameraComponent)
  self.CameraComponent = CameraComponent
end

function M:GetInGameCamera()
  return self.CameraComponent
end

function M:SetRaceGameSpeed(Speed)
  self.RaceGameSpeed = Speed
end

function M:GetRaceGameSpeed()
  return self.RaceGameSpeed or 1
end

function M:GetTotalPlayerList()
  return self.TotalPlayerList
end

function M:GetSpeedInfo()
  return self.SpeedInfo
end

function M:GetChoosePlayerList()
  return self.ChoosePlayerList
end

function M:SetPetLoopSound(PetId)
  self.PetLootList = self.PetLootList or {}
  self.PetLootList[PetId] = true
end

function M:GetShowUIList()
  return self.ShowUIList or {}
end

function M:IsPetInLoopSound(PetId)
  return self.PetLootList and self.PetLootList[PetId]
end

function M:ClearPetLoopSound(PetId)
  if self.PetLootList then
    self.PetLootList[PetId] = nil
  end
end

function M:BuildRacePlayerNoMap()
  local PlayerIdList = {}
  for _, RacePlayer in ipairs(self:GetTotalPlayerList() or {}) do
    if RacePlayer.PlayerId then
      table.insert(PlayerIdList, RacePlayer.PlayerId)
    end
  end
  table.sort(PlayerIdList, function(A, B)
    local ANum = tonumber(A)
    local BNum = tonumber(B)
    if ANum and BNum then
      return ANum < BNum
    end
    return tostring(A) < tostring(B)
  end)
  local PlayerNoMap = {}
  for Index, PlayerId in ipairs(PlayerIdList) do
    PlayerNoMap[PlayerId] = Index
  end
  return PlayerNoMap
end

function M:GetRacePlayerNo(PlayerId, PlayerNoMap)
  return PlayerNoMap and PlayerNoMap[PlayerId] or 0
end

function M:BuildRaceResultPlayerMap()
  local Result = {}
  local PlayerNoMap = self:BuildRacePlayerNoMap()
  local PlayerSpeedInfo = self:GetSpeedInfo()
  for Ranking, RacePlayer in ipairs(self:GetTotalPlayerList() or {}) do
    local PlayerId = RacePlayer.PlayerId
    if PlayerId then
      local PlayerInfo = DataMgr.RaceLotteryPlayer[PlayerId] or {}
      Result[PlayerId] = {
        No = self:GetRacePlayerNo(PlayerId, PlayerNoMap),
        Speed = PlayerSpeedInfo and PlayerSpeedInfo[PlayerId] or PlayerInfo.PlayerDefaultSpeed,
        Ranking = Ranking,
        RumorList = RacePlayer.RumorList or {}
      }
    end
  end
  return Result
end

function M:IsChoosePlayer(PlayerId)
  return nil ~= PlayerId and self.ChoosePlayerMap and self.ChoosePlayerMap[PlayerId] == true
end

function M:IsScrollingPlayer(PlayerId)
  return nil ~= PlayerId and self.ScrollingPlayerMap and self.ScrollingPlayerMap[PlayerId] == true
end

function M:GetScrollingPlayerLimit()
  local Constant = DataMgr.RaceLotteryConstant
  local Limit = Constant and Constant.ShortListedPlayerNum and tonumber(Constant.ShortListedPlayerNum.ConstantValue)
  return Limit or #self.ChoosePlayerList
end

function M:GetSortedRacePlayerIdList()
  local PlayerIdList = {}
  if type(self.TotalPlayerList) == "table" then
    for _, RacePlayer in ipairs(self.TotalPlayerList) do
      if RacePlayer.PlayerId then
        table.insert(PlayerIdList, RacePlayer.PlayerId)
      end
    end
  end
  if #PlayerIdList <= 0 then
    for PlayerId, _ in pairs(DataMgr.RaceLotteryPlayer or {}) do
      table.insert(PlayerIdList, PlayerId)
    end
  end
  table.sort(PlayerIdList, function(A, B)
    local ANum = tonumber(A)
    local BNum = tonumber(B)
    if ANum and BNum then
      return ANum < BNum
    end
    return tostring(A) < tostring(B)
  end)
  return PlayerIdList
end

function M:TryAddScrollingPlayer(PlayerId)
  if nil == PlayerId then
    return false
  end
  if self.FinishedPlayerMap and self.FinishedPlayerMap[PlayerId] then
    return false
  end
  if self.ScrollingPlayerMap and self.ScrollingPlayerMap[PlayerId] then
    return false
  end
  table.insert(self.ScrollingPlayerList, PlayerId)
  self.ScrollingPlayerMap[PlayerId] = true
  return true
end

function M:FillScrollingPlayerList()
  self.ScrollingPlayerList = self.ScrollingPlayerList or {}
  self.ScrollingPlayerMap = self.ScrollingPlayerMap or {}
  self.FinishedPlayerMap = self.FinishedPlayerMap or {}
  local Limit = self:GetScrollingPlayerLimit()
  for _, PlayerId in ipairs(self.ChoosePlayerList or {}) do
    if Limit <= #self.ScrollingPlayerList then
      return
    end
    self:TryAddScrollingPlayer(PlayerId)
  end
  for _, PlayerId in ipairs(self:GetSortedRacePlayerIdList()) do
    if Limit <= #self.ScrollingPlayerList then
      return
    end
    self:TryAddScrollingPlayer(PlayerId)
  end
end

function M:RemoveScrollingPlayer(PlayerId)
  if not self.ScrollingPlayerMap or not self.ScrollingPlayerMap[PlayerId] then
    return
  end
  self.ScrollingPlayerMap[PlayerId] = nil
  for Index = #self.ScrollingPlayerList, 1, -1 do
    if self.ScrollingPlayerList[Index] == PlayerId then
      table.remove(self.ScrollingPlayerList, Index)
      break
    end
  end
end

function M:OnPlayerReachEnd(PlayerId)
  if nil == PlayerId then
    return
  end
  self.FinishedPlayerMap = self.FinishedPlayerMap or {}
  self.FinishedPlayerMap[PlayerId] = true
  if not self:IsScrollingPlayer(PlayerId) then
    return
  end
  self:RemoveScrollingPlayer(PlayerId)
  self:FillScrollingPlayerList()
end

function M:Destory()
  M.Super.Destory(self)
  EventManager:RemoveEvent(EventID.OnRaceGameTimesSet, self)
end

return M
