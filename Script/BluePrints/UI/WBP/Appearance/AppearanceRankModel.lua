local M = {}

local function ParseAccessoryRankData(...)
  local ArgList = {
    ...
  }
  local SelfRankInfo = {}
  local TopNInfo = {}
  if type(ArgList[1]) == "table" and ArgList[1].TopNInfo then
    SelfRankInfo = ArgList[1].SelfRankInfo or {}
    TopNInfo = ArgList[1].TopNInfo or {}
  elseif type(ArgList[1]) == "table" and type(ArgList[2]) == "table" then
    SelfRankInfo = ArgList[1]
    TopNInfo = ArgList[2]
  elseif type(ArgList[1]) == "table" then
    TopNInfo = ArgList[1]
  end
  return SelfRankInfo, TopNInfo
end

local function BuildAccessoryRankSelfInfo(RankPayload)
  local SelfRankInfo, TopNInfo = ParseAccessoryRankData(RankPayload)
  local Avatar = GWorld and GWorld:GetAvatar() or nil
  local FinalSelfRankInfo = SelfRankInfo or {}
  local MatchedRankInfo
  local LocalAccessoryScore = 0
  if Avatar then
    FinalSelfRankInfo.Uid = FinalSelfRankInfo.Uid or Avatar.Uid
    FinalSelfRankInfo.HeadIconId = FinalSelfRankInfo.HeadIconId or Avatar.HeadIconId
    FinalSelfRankInfo.HeadFrameId = FinalSelfRankInfo.HeadFrameId or Avatar.HeadFrameId
    FinalSelfRankInfo.Level = FinalSelfRankInfo.Level or Avatar.Level
    FinalSelfRankInfo.Nickname = FinalSelfRankInfo.Nickname or Avatar.Nickname
    FinalSelfRankInfo.TitleBefore = FinalSelfRankInfo.TitleBefore or Avatar.TitleBefore
    FinalSelfRankInfo.TitleAfter = FinalSelfRankInfo.TitleAfter or Avatar.TitleAfter
    FinalSelfRankInfo.TitleFrame = FinalSelfRankInfo.TitleFrame or Avatar.TitleFrame
    LocalAccessoryScore = tonumber(Avatar.AccssoryScore or 0) or 0
  end
  if Avatar and Avatar.Uid and TopNInfo then
    local AvatarUid = tonumber(Avatar.Uid) or Avatar.Uid
    for Rank, RankInfo in pairs(TopNInfo) do
      local RankUid = RankInfo and (tonumber(RankInfo.Uid) or RankInfo.Uid)
      if RankUid == AvatarUid then
        MatchedRankInfo = RankInfo
        FinalSelfRankInfo.Rank = FinalSelfRankInfo.Rank or Rank
        break
      end
    end
  end
  if MatchedRankInfo then
    FinalSelfRankInfo.Uid = FinalSelfRankInfo.Uid or MatchedRankInfo.Uid
    FinalSelfRankInfo.HeadIconId = FinalSelfRankInfo.HeadIconId or MatchedRankInfo.HeadIconId
    FinalSelfRankInfo.HeadFrameId = FinalSelfRankInfo.HeadFrameId or MatchedRankInfo.HeadFrameId
    FinalSelfRankInfo.Level = FinalSelfRankInfo.Level or MatchedRankInfo.Level
    FinalSelfRankInfo.Nickname = FinalSelfRankInfo.Nickname or MatchedRankInfo.Nickname
    FinalSelfRankInfo.TitleBefore = FinalSelfRankInfo.TitleBefore or MatchedRankInfo.TitleBefore
    FinalSelfRankInfo.TitleAfter = FinalSelfRankInfo.TitleAfter or MatchedRankInfo.TitleAfter
    FinalSelfRankInfo.TitleFrame = FinalSelfRankInfo.TitleFrame or MatchedRankInfo.TitleFrame
  end
  if FinalSelfRankInfo.Score == nil then
    FinalSelfRankInfo.Score = MatchedRankInfo and MatchedRankInfo.Score or LocalAccessoryScore
  end
  return FinalSelfRankInfo, TopNInfo
end

function M:LoadUI(...)
  local SelfRankInfo, TopNInfo = ParseAccessoryRankData(...)
  return UIManager(GWorld.GameInstance):LoadUINew("AppearanceRank", SelfRankInfo, TopNInfo)
end

function M:Open()
  local Avatar = GWorld and GWorld:GetAvatar() or nil
  if not Avatar then
    return
  end
  if self._OpenAccessoryRankUICb then
    EventManager:RemoveEvent(EventID.OnAccessoryRankList, self, self._OpenAccessoryRankUICb)
    self._OpenAccessoryRankUICb = nil
  end
  local PendingRankPayload
  
  local function ClearAccessoryRankListener()
    if self._OpenAccessoryRankUICb then
      EventManager:RemoveEvent(EventID.OnAccessoryRankList, self, self._OpenAccessoryRankUICb)
      self._OpenAccessoryRankUICb = nil
    end
  end
  
  local function TryOpenAccessoryRankUI()
    ClearAccessoryRankListener()
    local SelfRankInfo, TopNInfo = BuildAccessoryRankSelfInfo(PendingRankPayload)
    if type(SelfRankInfo) == "table" then
      PrintTable(SelfRankInfo, 10, "[AccessoryRank] Final SelfRankInfo")
    end
    if type(TopNInfo) == "table" then
      PrintTable(TopNInfo, 10, "[AccessoryRank] Final TopNInfo")
    end
    self:LoadUI(SelfRankInfo, TopNInfo)
  end
  
  function self._OpenAccessoryRankUICb(Obj, RankPayload)
    PendingRankPayload = RankPayload
    DebugPrint("[AccessoryRank] OpenAccessoryRankUI RankPayload Ready")
    if type(RankPayload) == "table" then
      PrintTable(RankPayload, 10, "[AccessoryRank] OpenAccessoryRankUI RankPayload")
    end
    TryOpenAccessoryRankUI()
  end
  
  EventManager:AddEvent(EventID.OnAccessoryRankList, self, self._OpenAccessoryRankUICb)
  Avatar:GetAccessoryRankList(function(ErrCode)
    if not ErrorCode:Check(ErrCode) then
      ClearAccessoryRankListener()
    end
  end)
end

function M:LeaveWorld()
  if self._OpenAccessoryRankUICb then
    EventManager:RemoveEvent(EventID.OnAccessoryRankList, self, self._OpenAccessoryRankUICb)
    self._OpenAccessoryRankUICb = nil
  end
end

return M
