local M = Class("BluePrints.Common.MVC.Controller")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")

function M:Init()
  M.Super.Init(self)
  self:InitModelData()
  self:BindRacingChoosePetEvent()
  EventManager:AddEvent(EventID.OnActivityTimeOpen, self, self.RefreshReddotWithActivityOpen)
  EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.RefreshReddotWithActivityClose)
  EventManager:AddEvent(EventID.ConditionComplete, self, self.RefreshReddotWithConditionUnlock)
end

function M:Destory()
  M.Super.Destory(self)
  self:UnBindRacingChoosePetEvent()
  EventManager:RemoveEvent(EventID.OnActivityTimeOpen, self)
  EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
  EventManager:RemoveEvent(EventID.ConditionComplete, self)
end

function M:GetModel()
  return RacingOutsiderModel
end

function M:InitModelData()
  RacingOutsiderModel:InitCurrentStatus()
  RacingOutsiderModel:InitReddotTree()
end

function M:GetEventName()
  return nil
end

function M:OpenView(WorldContex, Param)
end

function M:GetView(WorldContex)
end

function M:SetIsShowRankInfo(IsShow)
  RacingOutsiderModel.IsShowRankInfo = IsShow
end

function M:AddSelectedPetToList(Content)
  RacingOutsiderModel.ChoosePetList = RacingOutsiderModel.ChoosePetList or {}
  RacingOutsiderModel.ChoosePetContentMap = RacingOutsiderModel.ChoosePetContentMap or {}
  RacingOutsiderModel.ChoosePetList[Content.PlayerId] = true
  RacingOutsiderModel.ChoosePetContentMap[Content.PlayerId] = Content
end

function M:RemoveSelectedPetFromList(Content)
  RacingOutsiderModel.ChoosePetContentMap = RacingOutsiderModel.ChoosePetContentMap or {}
  RacingOutsiderModel.ChoosePetList[Content.PlayerId] = nil
  RacingOutsiderModel.ChoosePetContentMap[Content.PlayerId] = nil
end

function M:ClearSelectedPetList(Content)
  RacingOutsiderModel.ChoosePetList = {}
  RacingOutsiderModel.ChoosePetContentMap = {}
end

function M:SetTodayPlayerList(PlayerList)
  DebugPrint("Yihan@ SetTodayPlayerList", PlayerList)
  RacingOutsiderModel.TodayPlayerList = PlayerList
  RacingOutsiderModel.PlayerRumorContentMap = {}
end

function M:SetServerChoosePetList(ChoosePetList)
  RacingOutsiderModel.ChoosePetList = {}
  RacingOutsiderModel.ChoosePetContentMap = {}
  for _, PlayerId in pairs(ChoosePetList or {}) do
    RacingOutsiderModel.ChoosePetList[PlayerId] = true
  end
end

function M:BindRacingChoosePetEvent()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or self.GameEventUnlockKey then
    return
  end
  if Avatar:CheckUIUnlocked("GameEvent") then
    return
  end
  self.GameEventUnlockKey = Avatar:BindOnUIFirstTimeUnlock("GameEvent", function()
    if ActivityUtils.CheckEventIsOpen(RacingActivityConst.ActivityEventId) and RacingOutsiderModel:CheckActivityIsUnlock(RacingActivityConst.ActivityEventId) then
      self:RefreshReddotWithCurrentStatus()
    end
  end)
end

function M:UnBindRacingChoosePetEvent()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not self.GameEventUnlockKey then
    return
  end
  Avatar:UnBindOnUIFirstTimeUnlock("GameEvent", self.GameEventUnlockKey)
  self.GameEventUnlockKey = nil
end

function M:OnRefreshInNextDay()
  RacingOutsiderModel.CurActivityStage = RacingActivityConst.RacingActivityStage.SelectPlayer
  RacingOutsiderModel.ChoosePetList = {}
  EventManager:FireEvent(RacingActivityConst.EventId.NextDayRefresh)
  ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotWatchAndGetRewardKey, true)
  RacingOutsiderModel:SetRacingChoosePetReddotCountOne()
  self:SetTodayPlayerList({})
end

function M:RefreshReddotWithCurrentStatus()
  RacingOutsiderModel:InitCurrentStatus()
  RacingOutsiderModel:InitReddotTree()
end

function M:RefreshReddotWithConditionUnlock(ConditionId)
  if not ActivityUtils.CheckEventIsOpen(RacingActivityConst.ActivityEventId) or not RacingOutsiderModel:CheckActivityIsUnlock(RacingActivityConst.ActivityEventId) then
    return
  end
  local JumpUnlockCondition = DataMgr.EventPortal[RacingActivityConst.ActivityEventId].JumpUnlockCondition
  if JumpUnlockCondition ~= tonumber(ConditionId) then
    return
  end
  self:RefreshReddotWithCurrentStatus()
end

function M:RefreshReddotWithActivityOpen(ActivityId)
  if RacingActivityConst.ActivityEventId ~= ActivityId then
    return
  end
  if not ActivityUtils.CheckEventIsOpen(RacingActivityConst.ActivityEventId) or not RacingOutsiderModel:CheckActivityIsUnlock(RacingActivityConst.ActivityEventId) then
    return
  end
  self:RefreshReddotWithCurrentStatus()
end

function M:RefreshReddotWithActivityClose(ActivityId)
  if RacingActivityConst.ActivityEventId ~= ActivityId then
    return
  end
  RacingOutsiderModel:ClearReddotTreeData()
end

function M:EightThirtyStatusUpdate()
  RacingOutsiderModel.CurActivityStage = RacingActivityConst.RacingActivityStage.GetReward
  EventManager:FireEvent(RacingActivityConst.EventId.EightThirtyRefresh)
  RacingOutsiderModel:RefreshWatchAndGetrewardReddot()
end

function M:EightStatusUpdate()
  RacingOutsiderModel.CurActivityStage = RacingActivityConst.RacingActivityStage.WaitingResult
  EventManager:FireEvent(RacingActivityConst.EventId.EightRefresh)
end

_G.RacingOutsiderController = M
return M
