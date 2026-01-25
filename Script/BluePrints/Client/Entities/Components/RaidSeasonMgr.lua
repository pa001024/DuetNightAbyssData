local Component = {}

function Component:OnRaidSeasonEnd()
  self.logger.debug("ZJT_ OnRaidSeasonEnd 赛季结束 ")
end

function Component:OnRaidSeasonStart(CurrentRaidSeasonId)
  self.logger.debug("ZJT_ OnRaidSeasonEnd 赛季开始 ", CurrentRaidSeasonId)
end

function Component:OnRaidRankStart(CurrentRaidSeasonId, PreRaidGroupId)
  EventManager:FireEvent(EventID.OnRaidRankStart, CurrentRaidSeasonId, PreRaidGroupId)
  self.logger.debug("OnRaidRankStart 正式赛开始", CurrentRaidSeasonId, PreRaidGroupId)
end

function Component:RaidSeasonGetPreRaidRankInfo(InCallBack)
  self.logger.info("RaidSeasonGetPreRaidRankInfo")
  
  local function Cb(ErrCode)
    DebugPrint("RaidSeasonGetPreRaidRankInfo", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode)
    end
  end
  
  self:CallServer("RaidSeasonGetPreRaidRankInfo", Cb)
end

function Component:OnGetPreRaidRankInfo(RankInfo)
  self.logger.debug("OnGetPreRaidRankInfo", RankInfo)
  EventManager:FireEvent(EventID.OnPreRaidRankInfo, RankInfo)
end

function Component:RaidSeasonGetRaidRankInfo(InCallBack)
  self.logger.info("RaidSeasonGetRaidRankInfo")
  
  local function Cb(ErrCode)
    DebugPrint("RaidSeasonGetRaidRankInfo", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode)
    end
  end
  
  self:CallServer("RaidSeasonGetRaidRankInfo", Cb)
end

function Component:OnGetRaidRankInfo(RankInfo)
  self.logger.debug("OnGetRaidRankInfo", RankInfo)
  EventManager:FireEvent(EventID.OnRaidRankInfo, RankInfo)
end

function Component:RaidSeasonGetRaidRankTopN(InCallBack)
  self.logger.info("RaidSeasonGetRaidRankTopN")
  
  local function Cb(ErrCode)
    DebugPrint("RaidSeasonGetRaidRankTopN", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode)
    end
  end
  
  self:CallServer("RaidSeasonGetRaidRankTopN", Cb)
end

function Component:OnGetRaidRankTopN(ErrCode, TopNInfo)
  self.logger.debug("OnGetRaidRankTopN", ErrCode, TopNInfo)
  EventManager:FireEvent(EventID.OnRaidRankInfoTopN, TopNInfo)
end

function Component:RaidSeasonGetPreRankReward(InCallBack)
  self.logger.info("RaidSeasonGetPreRankReward")
  
  local function Cb(ErrCode, Ret)
    DebugPrint("RaidSeasonGetPreRankReward", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("RaidSeasonGetPreRankReward", Cb)
end

return Component
