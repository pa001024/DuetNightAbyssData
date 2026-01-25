require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local GuildWarUtils = {}
GuildWarUtils.ReddotNodeKey = "Acti_SoloRaidSub"
GuildWarUtils.ReddotRewardKey = "RaidReward"
GuildWarUtils.ShopCacheKey = "RaidShopCache"
GuildWarUtils.EntranceCacheKey = "RaidEntranceCache"
GuildWarUtils.RewardGotCacheKey = "RaidRewardCache"

function GuildWarUtils.IsEventTime()
  local SeasonData, EventData = GuildWarUtils.GetSeasonAndEventData()
  if not SeasonData or not EventData then
    return false
  end
  local StartTime = EventData.EventStartTime
  local EndTime = EventData.EventEndTime
  local CurTime = TimeUtils.NowTime()
  return StartTime <= CurTime and EndTime >= CurTime
end

function GuildWarUtils.IsRaidTime()
  local SeasonData, EventData = GuildWarUtils.GetSeasonAndEventData()
  if not SeasonData or not EventData then
    return false
  end
  local StartTime = EventData.EventStartTime
  local EndTime = StartTime + SeasonData.PreRaidTime * 3600 + SeasonData.RaidTime * 3600
  local CurTime = TimeUtils.NowTime()
  return StartTime <= CurTime and EndTime >= CurTime
end

function GuildWarUtils.IsPreRaidTime()
  local SeasonData, EventData = GuildWarUtils.GetSeasonAndEventData()
  if not SeasonData or not EventData then
    return false
  end
  local StartTime = EventData.EventStartTime
  local EndTime = StartTime + SeasonData.PreRaidTime * 3600
  local CurTime = TimeUtils.NowTime()
  return StartTime <= CurTime and EndTime >= CurTime
end

function GuildWarUtils.IsOfficalRaidTime()
  local SeasonData, EventData = GuildWarUtils.GetSeasonAndEventData()
  if not SeasonData or not EventData then
    return false
  end
  local StartTime = EventData.EventStartTime + SeasonData.PreRaidTime * 3600
  local EndTime = StartTime + SeasonData.RaidTime * 3600
  local CurTime = TimeUtils.NowTime()
  return StartTime <= CurTime and EndTime >= CurTime
end

function GuildWarUtils.GetSeasonAndEventData()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local SeasonData = DataMgr.RaidSeason[Avatar.CurrentRaidSeasonId]
  if not SeasonData then
    return
  end
  local EventData = DataMgr.EventMain[SeasonData.EventId]
  if not EventData then
    return
  end
  return SeasonData, EventData
end

function GuildWarUtils.GetDungeonTicketInfo(DungeonId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return 0, 0, 0
  end
  local RaidDungeonConfig = DataMgr.RaidDungeon[DungeonId]
  if not RaidDungeonConfig then
    return 0, 0, 0
  end
  local isPreRaid = 1 == RaidDungeonConfig.RaidDungeonType
  if isPreRaid then
    return 0, 0, 0
  end
  local TicketNumData = RaidDungeonConfig.TicketNum
  if not TicketNumData then
    return 0, 0, 0
  end
  local ResId = 0
  local ConsumeTicketCount = 0
  for key, value in pairs(TicketNumData) do
    ResId = key
    ConsumeTicketCount = value
    break
  end
  if ResId > 0 then
    local CurrentTicketCount = Avatar.Resources[ResId] and Avatar.Resources[ResId].Count or 0
    return ResId, ConsumeTicketCount, CurrentTicketCount
  end
  return 0, 0, 0
end

function GuildWarUtils.EnterEventDungeon(DungeonId, EventId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local RaidDungeonConfig = DataMgr.RaidDungeon[DungeonId]
  if not RaidDungeonConfig then
    return false
  end
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local isPreRaid = 1 == RaidDungeonConfig.RaidDungeonType
  if isPreRaid then
    if not GuildWarUtils.IsPreRaidTime() then
      UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_PreRaid_End"))
      return false
    end
  elseif not GuildWarUtils.IsOfficalRaidTime() then
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_PreRaid_End"))
    return false
  end
  if not isPreRaid then
    local ResId, ConsumeTicketCount, CurrentTicketCount = GuildWarUtils.GetDungeonTicketInfo(DungeonId)
    if ResId > 0 and CurrentTicketCount < ConsumeTicketCount then
      local Resource = DataMgr.Resource[ResId]
      if Resource then
        UIManager:ShowUITip(UIConst.Tip_CommonToast, string.format(GText("RaidDungeon_NoTicket_Toast"), GText(Resource.ResourceName)))
      else
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_NoTicket_Toast"))
      end
      return false
    end
  end
  Avatar:EnterDungeonAgain()
  return true
end

function GuildWarUtils.IsEmptyTable(tbl)
  if type(tbl) ~= "table" then
    return true
  end
  for _ in pairs(tbl) do
    return false
  end
  return true
end

function GuildWarUtils.GetShopSubTabId(ShopKey)
  local SubTabId
  for _, ShopData in pairs(DataMgr.ShopItem2ShopSubId.Resource[ShopKey] or {}) do
    local ShopIDData = ShopData[1]
    if ShopIDData then
      SubTabId = ShopIDData.SubTabId
    end
    break
  end
  return SubTabId
end

function GuildWarUtils.GetCoinId(ShopKey)
  local SubTabId = GuildWarUtils.GetShopSubTabId(ShopKey)
  if not SubTabId then
    return
  end
  local CoinId = DataMgr.ShopTabSub[SubTabId].TabCoin[1]
  return CoinId
end

function GuildWarUtils.RefreshShopReddot()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
  if not RaidSeasons then
    return
  end
  local SeasonEventId = RaidSeasons.EventId
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
  if not CacheDetail[SeasonEventId] then
    return
  end
  local ShowReddot = false
  pcall(function()
    local CoinId = GuildWarUtils.GetCoinId(RaidSeasons.Shop)
    local CoinNum = Avatar:GetResourceNum(CoinId) or 0
    CoinNum = tonumber(CoinNum) or 0
    local MaxRaidScore = GuildWarUtils.IsPreRaidTime() and RaidSeasons.MaxPreRaidScore or RaidSeasons.MaxRaidScore
    MaxRaidScore = tonumber(MaxRaidScore) or 0
    local SubTabId = GuildWarUtils.GetShopSubTabId(RaidSeasons.Shop)
    for ShopItemId, ShopData in pairs(DataMgr.ShopItem) do
      if ShopData.SubTabId == SubTabId and ShopUtils:GetShopItemCanShow(ShopItemId) then
        local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(ShopData.ItemId)
        if 0 ~= PurchaseLimit and not Avatar:CheckShopItemUnique(ShopData.ItemId) then
          local UnLockRaidPoint = tonumber(ShopData.UnlockRaidPoint) or 0
          local Price = tonumber(ShopData.Price) or 0
          if CoinNum >= Price and MaxRaidScore >= UnLockRaidPoint then
            ShowReddot = true
            break
          end
        end
      end
    end
  end)
  if ShowReddot then
    if not CacheDetail[SeasonEventId][GuildWarUtils.ShopCacheKey] then
      CacheDetail[SeasonEventId][GuildWarUtils.ShopCacheKey] = 1
      ReddotManager.IncreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
    end
  elseif CacheDetail[SeasonEventId][GuildWarUtils.ShopCacheKey] then
    ReddotManager.DecreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
    CacheDetail[SeasonEventId][GuildWarUtils.ShopCacheKey] = nil
  end
end

function GuildWarUtils.RefreshQuestReddot(ClearCache)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
  if not RaidSeasons then
    return
  end
  local SeasonEventId = RaidSeasons.EventId
  local CommonQuestActivity = Avatar.CommonQuestActivity[SeasonEventId]
  if not CommonQuestActivity then
    return
  end
  pcall(function()
    local Node = ReddotManager.GetTreeNode(GuildWarUtils.ReddotRewardKey)
    if not Node then
      ReddotManager.AddNodeEx(GuildWarUtils.ReddotRewardKey)
    end
    ReddotManager.ClearLeafNodeCount(GuildWarUtils.ReddotRewardKey)
    if ClearCache then
      local NodeCache = ReddotManager._GetLeafNodeCache(GuildWarUtils.ReddotRewardKey)
      NodeCache.Detail = {}
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotRewardKey)
    for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
      if PhaseConfig.EventId == SeasonEventId then
        for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
          if Config.QuestPhaseId == QuestPhaseId then
            local QuestData = CommonQuestActivity[QuestId]
            if not (QuestData and QuestData.Progress) or not QuestData.Target then
            else
              local CanReceive = QuestData.Progress >= QuestData.Target
              if CanReceive and not QuestData.RewardsGot then
                if not CacheDetail[QuestPhaseId] then
                  CacheDetail[QuestPhaseId] = {}
                end
                ReddotManager.IncreaseLeafNodeCount(GuildWarUtils.ReddotRewardKey)
                if not CacheDetail[QuestPhaseId][QuestId] then
                  CacheDetail[QuestPhaseId][QuestId] = 1
                end
              end
            end
          end
        end
      end
    end
  end)
end

function GuildWarUtils.RefreshEntranceReddot()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
  if not RaidSeasons then
    return
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
  if not CacheDetail then
    return
  end
  pcall(function()
    local ShowReddot = false
    if GuildWarUtils.IsPreRaidTime() then
      ShowReddot = 0 == RaidSeasons.MaxPreRaidScore
    elseif GuildWarUtils.IsOfficalRaidTime() then
      ShowReddot = 0 == RaidSeasons.MaxRaidScore
    end
    local SeasonEventId = RaidSeasons.EventId
    if ShowReddot then
      if CacheDetail[SeasonEventId][GuildWarUtils.EntranceCacheKey] == nil then
        CacheDetail[SeasonEventId][GuildWarUtils.EntranceCacheKey] = 1
        ReddotManager.IncreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
      end
    elseif CacheDetail[SeasonEventId][GuildWarUtils.EntranceCacheKey] then
      ReddotManager.DecreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
      CacheDetail[SeasonEventId][GuildWarUtils.EntranceCacheKey] = nil
    end
  end)
end

function GuildWarUtils.RefreshRewardGotReddot()
  if GuildWarUtils.IsPreRaidTime() then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
  if not RaidSeasons then
    return
  end
  local SeasonEventId = RaidSeasons.EventId
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
  if not CacheDetail[SeasonEventId] then
    return
  end
  pcall(function()
    local ShowReddot = RaidSeasons.PreRaidGroupId > 0 and not RaidSeasons:IsPreRaidRewardGot()
    if ShowReddot then
      if CacheDetail[SeasonEventId][GuildWarUtils.RewardGotCacheKey] == nil then
        CacheDetail[SeasonEventId][GuildWarUtils.RewardGotCacheKey] = 1
        ReddotManager.IncreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
      end
    elseif CacheDetail[SeasonEventId][GuildWarUtils.RewardGotCacheKey] then
      ReddotManager.DecreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
      CacheDetail[SeasonEventId][GuildWarUtils.RewardGotCacheKey] = nil
    end
  end)
end

return GuildWarUtils
