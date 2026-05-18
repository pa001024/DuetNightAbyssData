local M = Class("BluePrints.Common.MVC.Model")

local function ClearPendingRoomRankRequest(self, Avatar)
  if Avatar and Avatar.UnregisterRoomDamageListListener then
    Avatar:UnregisterRoomDamageListListener(self)
  end
  self.PendingRoomRankRequest = nil
end

function M:Init()
  M.Super.Init(self)
  self.PendingRoomRankRequest = nil
end

function M:Destory()
  local Avatar = self:GetAvatar()
  ClearPendingRoomRankRequest(self, Avatar)
  M.Super.Destory(self)
end

function M:GetAsyncCombatRoomRewardIdList()
  if self.RewardIdList == nil then
    local RewardIdSet = {}
    local RewardIdList = {}
    for key, value in pairs(DataMgr.AsyncCombat) do
      local RewardId = value.ID
      if RewardId and not RewardIdSet[RewardId] then
        RewardIdSet[RewardId] = true
        table.insert(RewardIdList, RewardId)
      end
    end
    self.RewardIdList = RewardIdList
  end
  return self.RewardIdList
end

function M:GetAsyncCombatRoomRewardIndex(RewardId)
  local RewardIdList = self:GetAsyncCombatRoomRewardIdList()
  for index, Id in ipairs(RewardIdList) do
    if Id == RewardId then
      return index
    end
  end
  return 1
end

function M:GetAsyncCombatRoomLevelList()
  if self.RoomLevelList == nil then
    local LevelSet = {}
    local RoomLevelList = {}
    for _, value in pairs(DataMgr.AsyncCombat) do
      local RewardId = value.Level
      if LevelSet and not LevelSet[RewardId] then
        LevelSet[RewardId] = true
        table.insert(RoomLevelList, RewardId)
      end
    end
    table.sort(RoomLevelList)
    self.RoomLevelList = RoomLevelList
  end
  return self.RoomLevelList
end

function M:GetAsyncCombatDifficultyList()
  if self.DifficultyList == nil then
    local BlueId = DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate1.ConstantValue
    local GreenId = DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate2.ConstantValue
    local PurpleId = DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate8.ConstantValue
    local GoldId = DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate20.ConstantValue
    self.DifficultyList = {
      BlueId,
      GreenId,
      PurpleId,
      GoldId
    }
  end
  return self.DifficultyList
end

function M:GetRewardAnimationByDifficultyId(DifficultyId)
  if not self.DifficultyAnimationMap then
    self.DifficultyAnimationMap = {
      [DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate1.ConstantValue] = "Lv_04",
      [DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate2.ConstantValue] = "Lv_03",
      [DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate8.ConstantValue] = "Lv_02",
      [DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate20.ConstantValue] = "Lv_01"
    }
  end
  return self.DifficultyAnimationMap[DifficultyId]
end

function M:CheckIsInRoomByRoomUniqueID(RoomUniqueId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return false
  end
  local AsyncCombat = Avatar.AsyncCombats
  local EventId = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  for k, _ in pairs(AsyncCombat[EventId].OwnedRoom) do
    if k == RoomUniqueId then
      return true
    end
  end
  return false
end

function M:AsyncCombatGetGoingRoomNum()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return 0
  end
  local AsyncCombat = Avatar.AsyncCombats
  local EventId = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  local MaxNum = DataMgr.AsyncCombatEventConstant.AsyncCombat_ConcurrencyLimit.ConstantValue
  local count = 0
  for _ in pairs(AsyncCombat[EventId].GoingRoom) do
    count = count + 1
  end
  return count, MaxNum
end

function M:AsyncCombatGetPlayerInfo()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return 0
  end
  local AsyncCombat = Avatar.AsyncCombats
  local EventId = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  return AsyncCombat[EventId].CreateRoomTimes or 0
end

function M:AsyncCombatGetRoomList(permission, LastRoomUid, callback)
  LastRoomUid = LastRoomUid or 0
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:AsyncCombatGetRoomList(callback, permission, LastRoomUid)
end

function M:AsyncCombatGetOwnedRoom(callback)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:AsyncCombatGetOwnedRoom(callback)
end

function M:AsyncCombatClaimReward(RoomUniqueIds, callback)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:AsyncCombatClaimReward(callback, RoomUniqueIds)
end

function M:AsyncCombatJoinRoom(RoomUniId, bIsMaster, bInvite, callback)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  bIsMaster = bIsMaster or false
  bInvite = bInvite or false
  Avatar:AsyncCombatJoinRoom(callback, RoomUniId, bIsMaster, bInvite)
end

function M:AsyncGetMemberRoomInfo(Callback, RoomUniId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:AsyncCombatGetMemberRoomInfo(Callback, RoomUniId)
end

local function HandleRoomRankData(self, Avatar, RoomData, Callback, RetErrorCode, DamageList)
  if ErrorCode and not ErrorCode:Check(RetErrorCode) then
    if Utils.ScreenPrint then
      Utils.ScreenPrint("CoopRank: request failed: " .. ErrorCode:Name(RetErrorCode))
    end
    return
  end
  if not DamageList or next(DamageList) == nil then
    if Utils.ScreenPrint then
      Utils.ScreenPrint("CoopRank: DamageList is empty")
    end
    return
  end
  local SelfRankInfo, TopNInfo, RankingRoomData = M.BuildRoomRankData(Avatar, RoomData, DamageList)
  if Callback then
    Callback(SelfRankInfo, TopNInfo, RankingRoomData)
  end
end

local function BuildSelfRankFallback(Avatar)
  return {
    Rank = -1,
    Score = 0,
    Uid = Avatar and Avatar.Uid,
    Nickname = Avatar and Avatar.Nickname,
    Level = Avatar and Avatar.Level,
    HeadIconId = Avatar and Avatar.HeadIconId,
    HeadFrameId = Avatar and Avatar.HeadFrameId,
    TitleBefore = Avatar and Avatar.TitleBefore,
    TitleAfter = Avatar and Avatar.TitleAfter,
    TitleFrame = Avatar and Avatar.TitleFrame
  }
end

function M.BuildRoomRankData(Avatar, RoomData, DamageList)
  if not (Avatar and DamageList) or next(DamageList) == nil then
    return nil, nil, nil
  end
  local RankingRoomData = {
    RoomConfId = RoomData and (tonumber(RoomData.RoomConfId) or RoomData.RoomConfId),
    RoomUniqueId = RoomData and RoomData.RoomUniqueId
  }
  local TopNInfo = {}
  for _, Info in pairs(DamageList) do
    local SquadSnapShot = Info.Squad
    local RankInfo = {
      Uid = Info.Uid,
      Nickname = Info.Nickname,
      Level = Info.Level,
      Score = Info.Score or Info.Damage or 0,
      HeadIconId = Info.HeadIconId,
      HeadFrameId = Info.HeadFrameId,
      TitleBefore = Info.TitleBefore,
      TitleAfter = Info.TitleAfter,
      TitleFrame = Info.TitleFrame,
      BanState = Info.BanState,
      Squad = SquadSnapShot,
      IsMaster = Info.IsMaster or false,
      IsMvp = Info.IsMvp or false
    }
    table.insert(TopNInfo, RankInfo)
  end
  table.sort(TopNInfo, function(A, B)
    return (A.Score or 0) > (B.Score or 0)
  end)
  local SelfRankInfo = BuildSelfRankFallback(Avatar)
  for Rank, Info in ipairs(TopNInfo) do
    if Info.Uid == Avatar.Uid then
      SelfRankInfo.Rank = Rank
      SelfRankInfo.Score = Info.Score
      SelfRankInfo.Nickname = Info.Nickname or SelfRankInfo.Nickname
      SelfRankInfo.Level = Info.Level or SelfRankInfo.Level
      SelfRankInfo.HeadIconId = Info.HeadIconId or SelfRankInfo.HeadIconId
      SelfRankInfo.HeadFrameId = Info.HeadFrameId or SelfRankInfo.HeadFrameId
      SelfRankInfo.TitleBefore = Info.TitleBefore or SelfRankInfo.TitleBefore
      SelfRankInfo.TitleAfter = Info.TitleAfter or SelfRankInfo.TitleAfter
      SelfRankInfo.TitleFrame = Info.TitleFrame or SelfRankInfo.TitleFrame
      SelfRankInfo.Squad = Info.Squad
      break
    end
  end
  return SelfRankInfo, TopNInfo, RankingRoomData
end

function M:AsyncCombatGetRoomRankData(RoomData, Callback)
  if not RoomData or not RoomData.RoomUniqueId then
    return
  end
  local Avatar = self:GetAvatar()
  if not Avatar then
    if Utils.ScreenPrint then
      Utils.ScreenPrint("CoopRank: Avatar is nil")
    end
    return
  end
  ClearPendingRoomRankRequest(self, Avatar)
  self.PendingRoomRankRequest = {RoomData = RoomData, Callback = Callback}
  Avatar:RegisterRoomDamageListListener(self, function(RetErrorCode, DamageList)
    local PendingRequest = self.PendingRoomRankRequest
    ClearPendingRoomRankRequest(self, Avatar)
    if not PendingRequest then
      return
    end
    HandleRoomRankData(self, Avatar, PendingRequest.RoomData, PendingRequest.Callback, RetErrorCode, DamageList)
  end)
  Avatar:AsyncCombatGetRoomDamageList(function(ErrCode)
    if ErrorCode and not ErrorCode:Check(ErrCode) then
      ClearPendingRoomRankRequest(self, Avatar)
      if Utils.ScreenPrint then
        Utils.ScreenPrint("CoopRank: request failed: " .. ErrorCode:Name(ErrCode))
      end
    end
  end, RoomData.RoomUniqueId)
end

return M
