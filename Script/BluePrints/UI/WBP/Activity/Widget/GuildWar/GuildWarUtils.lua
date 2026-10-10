require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local SerializeUtils = require("Utils.SerializeUtils")
local EMCache = require("EMCache.EMCache")
local GuildWarUtils = {}
GuildWarUtils.ReddotNodeKey = "Acti_SoloRaidSub"
GuildWarUtils.ReddotRewardKey = "RaidReward"
GuildWarUtils.ShopCacheKey = "RaidShopCache"
GuildWarUtils.EntranceCacheKey = "RaidEntranceCache"
GuildWarUtils.RewardGotCacheKey = "RaidRewardCache"
GuildWarUtils.RaidQuickGoCacheKey = "RaidSettlementQuickGo"
GuildWarUtils.ShowTeamCacheKey = "GuildWarRankShowTeam"

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

function GuildWarUtils.IsRaidEnded()
  local SeasonData, EventData = GuildWarUtils.GetSeasonAndEventData()
  if not SeasonData or not EventData then
    return false
  end
  local StartTime = EventData.EventStartTime
  local EndTime = StartTime + SeasonData.PreRaidTime * 3600 + SeasonData.RaidTime * 3600
  local CurTime = TimeUtils.NowTime()
  return EndTime < CurTime
end

function GuildWarUtils.IsFloorMode(SeasonId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  SeasonId = SeasonId or Avatar.CurrentRaidSeasonId
  local SeasonData = DataMgr.RaidSeason[SeasonId]
  if not SeasonData then
    return false
  end
  return 2 == SeasonData.RaidSeasonType
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

function GuildWarUtils.GetRaidFloorId(Floor, RaidSeasonId, FloorType)
  for FloorId, Conf in pairs(DataMgr.RaidFloor) do
    if Conf and Conf.RaidSeason == RaidSeasonId and Conf.FloorType == FloorType and Conf.Floor == Floor then
      return FloorId
    end
  end
  return nil
end

function GuildWarUtils.GetRaidFloorById(FloorId)
  local RaidFloorInfo = DataMgr.RaidFloor[FloorId]
  if not RaidFloorInfo then
    return 0
  end
  return RaidFloorInfo.Floor
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

function GuildWarUtils.EnterGuildWarAgain(DungeonId, EventId, FloorId, Callback)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local isPreRaid
  if GuildWarUtils.IsFloorMode() then
    local RaidFloorInfo = DataMgr.RaidFloor[FloorId]
    if not RaidFloorInfo then
      return false
    end
    isPreRaid = 1 == RaidFloorInfo.FloorType
  else
    local RaidDungeonConfig = DataMgr.RaidDungeon[DungeonId]
    if not RaidDungeonConfig then
      return false
    end
    isPreRaid = 1 == RaidDungeonConfig.RaidDungeonType
  end
  local UIManager = GWorld.GameInstance:GetGameUIManager()
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
  local CustomParams = {}
  if FloorId and FloorId > 0 then
    CustomParams.FloorId = FloorId
  end
  local SquadId = Avatar.DungeonSquad and Avatar.DungeonSquad.SoloRaid or 0
  DebugPrint("ljl@ EnterGuildWarAgain FloorId", FloorId, "SquadId", SquadId)
  Avatar:EnterEventDungeon(Callback, DungeonId, SquadId, EventId, CustomParams)
  return true
end

function GuildWarUtils.IsShowTeamEnabled()
  return EMCache:Get(GuildWarUtils.ShowTeamCacheKey) == true
end

function GuildWarUtils.SetShowTeamEnabled(bEnabled)
  EMCache:Set(GuildWarUtils.ShowTeamCacheKey, true == bEnabled)
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

function GuildWarUtils.BuildHistoryDateText(UpdateTime)
  local TimeValue = tonumber(UpdateTime)
  if not TimeValue or TimeValue <= 0 then
    return "--"
  end
  return os.date("%Y-%m-%d", TimeValue)
end

function GuildWarUtils.BuildHistoryScoreTexts(RankInfo)
  if type(RankInfo) ~= "table" then
    return "--", nil
  end
  if GuildWarUtils.IsFloorMode(RankInfo.SeasonId) then
    local FloorValue = RankInfo.Floor
    local TimeText = RankInfo.TimeText
    if nil ~= FloorValue or nil ~= TimeText then
      local ScoreText1 = "--"
      if nil ~= FloorValue and "" ~= FloorValue then
        local FloorNum = tonumber(FloorValue) or FloorValue
        local FormatStr = GText("Raid_Season_Floor_Record_Floor")
        if not FormatStr or "" == FormatStr then
          FormatStr = "层数：%d"
        end
        local Ok, Result = pcall(string.format, FormatStr, FloorNum)
        if Ok then
          ScoreText1 = Result
        else
          ScoreText1 = tostring(FloorNum)
        end
      end
      return ScoreText1, TimeText
    end
  end
  if nil == RankInfo.Score then
    return "--", nil
  end
  return RankInfo.Score, nil
end

function GuildWarUtils.BuildHistoryRankParams(TopNInfo)
  local TopNRankInfo = {}
  for Index, Info in ipairs(TopNInfo or {}) do
    if type(Info) == "table" then
      local RankInfo = GuildWarUtils.MakeCommonRankItem(Info, Info.SeasonId)
      if RankInfo then
        RankInfo.SeasonId = Info.SeasonId
        RankInfo.PreRaidGroupId = Info.PreRaidGroupId
        RankInfo.DateText = GuildWarUtils.BuildHistoryDateText(Info.UpdateTime)
        RankInfo.ScoreText1, RankInfo.ScoreText2 = GuildWarUtils.BuildHistoryScoreTexts(RankInfo)
        TopNRankInfo[Index] = RankInfo
      end
    end
  end
  return {
    TitleText = "RaidDungeon_Rank_History",
    MainTab = {
      TitleName = GText("RaidDungeon_Rank_History"),
      StyleName = "TextImage",
      DynamicNode = {"Back", "BottomKey"},
      LeftKey = "NotShow",
      RightKey = "NotShow"
    },
    SubTab = {
      [1] = {
        Text = "RaidDungeon_Rank_History",
        TabId = 1
      }
    },
    ColumnSchema = {
      [1] = {
        {Type = "RankingNum"},
        {Type = "GradeIcon"},
        {
          Type = "TextInfo",
          HeaderName = "RaidDungeon_Rank_Time",
          Text1 = {TextMapId = "%s", ValueKey = "DateText"}
        },
        {
          Type = "TextInfo",
          HeaderName = "RaidDungeon_Max_Point_Rank_2",
          Text1 = {TextMapId = "%s", ValueKey = "ScoreText1"},
          Text2 = {TextMapId = "%s", ValueKey = "ScoreText2"}
        },
        {Type = "Team"}
      }
    },
    TopNRankInfo = {
      [1] = TopNRankInfo
    },
    RankEmptyText = "RaidDungeon_Rank_Empty",
    FillRankingEmptyContent = true,
    PreviewActorTabId = 1,
    FilterBar = {
      ShowTeam = {
        bEnable = true,
        bDefaultChecked = GuildWarUtils.IsShowTeamEnabled(),
        OnCheckChanged = function(bChecked)
          GuildWarUtils.SetShowTeamEnabled(bChecked)
        end
      }
    }
  }
end

function GuildWarUtils.BuildCommonRankParams(SelfRankInfo, TopNInfo, SeasonId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return {}
  end
  SeasonId = SeasonId or Avatar.CurrentRaidSeasonId
  PrintTable(SelfRankInfo, 5, "ljl@ SelfRankInfo")
  PrintTable(TopNInfo, 5, "ljl@ TopNInfo")
  local TopNRankInfo = {}
  for Index, Info in ipairs(TopNInfo or {}) do
    TopNRankInfo[Index] = GuildWarUtils.MakeCommonRankItem(Info, SeasonId)
  end
  local Text1, Text2 = GuildWarUtils.GetRankingText(SeasonId)
  local RaidSeasons = Avatar.RaidSeasons and Avatar.RaidSeasons[SeasonId]
  local PreRaidGroupId = RaidSeasons and RaidSeasons.PreRaidGroupId
  local BtnRewardCfg
  if GuildWarUtils.HasRaidRankRewardByGroup(SeasonId, PreRaidGroupId) then
    BtnRewardCfg = {
      Text = "Raid_Season_Floor_Order_Reward_button",
      OnClicked = function(Owner)
        local RewardUI = UIManager(Owner):LoadUINew("GuildWarRewardPreviewNew")
        if RewardUI and RewardUI.Init then
          RewardUI:Init({
            CloseCallback = function()
              if Owner and Owner.SetFocus then
                Owner:SetFocus()
              end
            end
          })
        end
      end
    }
  end
  return {
    TitleText = "RaidDungeon_Raid_Rank",
    MainTab = {
      TitleName = GText("RaidDungeon_Rank"),
      StyleName = "TextImage",
      DynamicNode = {
        "Back",
        "ResourceBar",
        "BottomKey"
      },
      LeftKey = "Q",
      RightKey = "E"
    },
    SubTab = {
      [1] = {
        Text = "RaidDungeon_Raid_Rank",
        TabId = 1
      }
    },
    ColumnSchema = {
      [1] = {
        {Type = "RankingNum"},
        {Type = "Name"},
        {
          Type = "TextInfo",
          HeaderName = "RaidDungeon_Time_Remain",
          Text1 = Text1,
          Text2 = Text2
        },
        {Type = "Team"}
      }
    },
    TopNRankInfo = {
      [1] = TopNRankInfo
    },
    SelfRankInfo = {
      [1] = GuildWarUtils.MakeCommonSelfRankItem(SelfRankInfo, SeasonId)
    },
    RankEmptyText = "RaidDungeon_Rank_Empty",
    PreviewActorTabId = 1,
    FillRankingEmptyContent = false,
    FilterBar = {
      BtnReward = BtnRewardCfg,
      ShowTeam = {
        bEnable = true,
        bDefaultChecked = GuildWarUtils.IsShowTeamEnabled(),
        OnCheckChanged = function(bChecked)
          GuildWarUtils.SetShowTeamEnabled(bChecked)
        end
      },
      SortVisible = {
        Options = GuildWarUtils.BuildSquadVisibleOptions(SeasonId)
      }
    }
  }
end

function GuildWarUtils.BuildSquadVisibleOptions(SeasonId)
  local Avatar = GWorld:GetAvatar()
  if Avatar and not SeasonId then
    SeasonId = Avatar.CurrentRaidSeasonId
  end
  local RaidSeasons = SeasonId and Avatar and Avatar.RaidSeasons and Avatar.RaidSeasons[SeasonId]
  local bSquadVisible = nil ~= RaidSeasons and RaidSeasons.bSquadView == true
  local PublicOpt = {
    Text = "Raid_Season_Floor_Open_Team",
    Callback = function(Owner, Index)
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:RaidSeasonSetSquadView(true, nil)
      end
    end
  }
  local SelfOnlyOpt = {
    Text = "Raid_Season_Floor_Only_View",
    Callback = function(Owner, Index)
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:RaidSeasonSetSquadView(false, nil)
      end
    end
  }
  if bSquadVisible then
    return {PublicOpt, SelfOnlyOpt}
  end
  return {SelfOnlyOpt, PublicOpt}
end

function GuildWarUtils.FormatRankTime(TimeSec)
  if not TimeSec then
    return nil
  end
  TimeSec = tonumber(TimeSec) or 0
  local TotalCenti = math.floor(TimeSec * 100 + 0.5)
  local CentiSec = TotalCenti % 100
  local TotalSec = math.floor(TotalCenti / 100)
  local Sec = TotalSec % 60
  local Min = math.floor(TotalSec / 60)
  return string.format("%02d:%02d.%02d", Min, Sec, CentiSec)
end

function GuildWarUtils.GetRankingText(SeasonId)
  if GuildWarUtils.IsFloorMode(SeasonId) then
    return {
      TextMapId = "Raid_Season_Floor_Record_Floor",
      ValueKey = "Floor"
    }, {
      TextMapId = "%02d:%02d.%02d",
      ValueKey = "TimeText"
    }
  else
    return {TextMapId = "%.0f", ValueKey = "Score"}, nil
  end
end

function GuildWarUtils.MakeCommonRankItem(Info, SeasonId)
  if type(Info) ~= "table" then
    return
  end
  local RankInfo = {
    Uid = Info.Uid,
    Nickname = Info.Nickname,
    Level = Info.Level,
    Score = Info.Score,
    Floor = Info.Floor,
    PassTime = GuildWarUtils.FormatRankTime(Info.PassTime),
    HeadFrameId = Info.HeadFrameId,
    HeadIconId = Info.HeadIconId,
    TitleBefore = Info.TitleBefore,
    TitleAfter = Info.TitleAfter,
    TitleFrame = Info.TitleFrame,
    bSquadView = Info.bSquadView
  }
  local RoleInfo, PetInfo, WeaponInfo = GuildWarUtils.ParseMaxScoreSquad(Info.MaxSquad)
  if RoleInfo then
    RankInfo.RoleId = RoleInfo[1] and RoleInfo[1].id
    RankInfo.RoleLevel = RoleInfo[1] and RoleInfo[1].level
    RankInfo.Phantom1RoleId = RoleInfo[2] and RoleInfo[2].id
    RankInfo.Phantom2RoleId = RoleInfo[3] and RoleInfo[3].id
  end
  GuildWarUtils.ApplyRankWeaponInfo(RankInfo, WeaponInfo)
  if PetInfo then
    RankInfo.PetId = PetInfo.id
    RankInfo.PetLevel = PetInfo.level
  end
  if GuildWarUtils.IsFloorMode(SeasonId) then
    if Info.Floor ~= nil then
      RankInfo.Floor = tostring(Info.Floor)
    end
    local PassTime = tonumber(Info.PassTime)
    if PassTime and PassTime > 0 then
      RankInfo.TimeText = GuildWarUtils.FormatRankTime(PassTime)
    end
  end
  PrintTable(RankInfo, 5, "ljl@ RankInfo")
  return RankInfo
end

function GuildWarUtils.MakeCommonSelfRankItem(SelfRankInfo, SeasonId)
  local Avatar = GWorld:GetAvatar()
  local RankInfo = {
    Uid = Avatar and Avatar.Uid,
    RankNum = -1
  }
  if Avatar then
    SeasonId = SeasonId or Avatar.CurrentRaidSeasonId
    local RaidSeasons = SeasonId and Avatar.RaidSeasons and Avatar.RaidSeasons[SeasonId]
    if RaidSeasons and RaidSeasons.MaxRaidScore and RaidSeasons.MaxRaidScore > 0 then
      RankInfo.Score = RaidSeasons.MaxRaidScore
    end
  end
  local RoleInfo, PetInfo, WeaponInfo = GuildWarUtils.ParseMaxScoreSquad(SelfRankInfo and SelfRankInfo.MaxSquad)
  if RoleInfo then
    RankInfo.RoleId = RoleInfo[1] and RoleInfo[1].id
    RankInfo.RoleLevel = RoleInfo[1] and RoleInfo[1].level
    RankInfo.Phantom1RoleId = RoleInfo[2] and RoleInfo[2].id
    RankInfo.Phantom2RoleId = RoleInfo[3] and RoleInfo[3].id
  end
  GuildWarUtils.ApplyRankWeaponInfo(RankInfo, WeaponInfo)
  if PetInfo then
    RankInfo.PetId = PetInfo.id
    RankInfo.PetLevel = PetInfo.level
  end
  if GuildWarUtils.IsFloorMode(SeasonId) then
    local Avatar = GWorld:GetAvatar()
    local RaidSeasons = SeasonId and Avatar and Avatar.RaidSeasons and Avatar.RaidSeasons[SeasonId]
    local RaidFloor = tonumber(RaidSeasons and RaidSeasons.RaidFloor)
    if RaidFloor and RaidFloor > 0 then
      RankInfo.Floor = tostring(RaidFloor)
    end
    local RaidFloorPassTime = tonumber(RaidSeasons and RaidSeasons.RaidFloorPassTime)
    if RaidFloorPassTime and RaidFloorPassTime > 0 then
      RankInfo.TimeText = GuildWarUtils.FormatRankTime(RaidFloorPassTime)
    end
  end
  PrintTable(RankInfo, 5, "ljl@ SelfRankInfo")
  return RankInfo
end

local function ParseSnapshotWeapon(Container, WeaponKey)
  if type(Container) ~= "table" then
    return
  end
  local Weapon = Container[WeaponKey or "MeleeWeapon"]
  if type(Weapon) ~= "table" then
    return
  end
  local WeaponId = tonumber(Weapon.WeaponId)
  if not WeaponId or WeaponId <= 0 then
    return
  end
  return {
    id = WeaponId,
    level = Weapon.Level
  }
end

function GuildWarUtils.ParseMaxScoreSquad(SquadSnapShot)
  local SnapShotType = type(SquadSnapShot)
  if "string" ~= SnapShotType and "table" ~= SnapShotType then
    return
  end
  if "" == SquadSnapShot then
    return
  end
  local Squad = SquadSnapShot
  if "string" == SnapShotType then
    local Ok, Result = pcall(function()
      return SerializeUtils:UnSerialize(SquadSnapShot)
    end)
    if not Ok or type(Result) ~= "table" then
      return
    end
    Squad = Result
  end
  if GuildWarUtils.IsEmptyTable(Squad) then
    return
  end
  local RoleInfo, PetInfo, WeaponInfo = {}, {}, {}
  local AvatarInfo = Squad.AvatarInfo
  if type(AvatarInfo) == "table" then
    local CharacterInfo = AvatarInfo.CharacterInfo
    local MainRole = type(CharacterInfo) == "table" and CharacterInfo.RoleInfo
    if type(MainRole) == "table" then
      RoleInfo[1] = {
        id = MainRole.RoleId,
        level = MainRole.Level
      }
    end
    WeaponInfo.Melee = ParseSnapshotWeapon(CharacterInfo)
    WeaponInfo.Ranged = ParseSnapshotWeapon(CharacterInfo, "RangedWeapon")
    local PhantomIndex = 2
    local PhantomInfo1 = AvatarInfo.PhantomInfo1
    local PhantomRole1 = type(PhantomInfo1) == "table" and PhantomInfo1.RoleInfo
    if type(PhantomRole1) == "table" then
      RoleInfo[PhantomIndex] = {
        id = PhantomRole1.RoleId,
        level = PhantomRole1.Level
      }
      PhantomIndex = PhantomIndex + 1
    end
    WeaponInfo.Phantom1 = ParseSnapshotWeapon(PhantomInfo1) or ParseSnapshotWeapon(PhantomInfo1, "RangedWeapon")
    local PhantomInfo2 = AvatarInfo.PhantomInfo2
    local PhantomRole2 = type(PhantomInfo2) == "table" and PhantomInfo2.RoleInfo
    if type(PhantomRole2) == "table" then
      RoleInfo[PhantomIndex] = {
        id = PhantomRole2.RoleId,
        level = PhantomRole2.Level
      }
    end
    WeaponInfo.Phantom2 = ParseSnapshotWeapon(PhantomInfo2) or ParseSnapshotWeapon(PhantomInfo2, "RangedWeapon")
  end
  local CommonCombatInfo = Squad.CommonCombatInfo
  if type(CommonCombatInfo) == "table" then
    PetInfo = {
      id = CommonCombatInfo.pet_id,
      level = CommonCombatInfo.pet_level
    }
  end
  return RoleInfo, PetInfo, WeaponInfo
end

function GuildWarUtils.ApplyRankWeaponInfo(RankInfo, WeaponInfo)
  if type(RankInfo) ~= "table" or type(WeaponInfo) ~= "table" then
    return
  end
  local Melee = WeaponInfo.Melee
  if Melee then
    RankInfo.MeleeWeaponId = Melee.id
    RankInfo.MeleeWeaponLevel = Melee.level
  end
  local Ranged = WeaponInfo.Ranged
  if Ranged then
    RankInfo.RangedWeaponId = Ranged.id
    RankInfo.RangedWeaponLevel = Ranged.level
  end
  local Phantom1 = WeaponInfo.Phantom1
  if Phantom1 then
    RankInfo.Phantom1WeaponId = Phantom1.id
  end
  local Phantom2 = WeaponInfo.Phantom2
  if Phantom2 then
    RankInfo.Phantom2WeaponId = Phantom2.id
  end
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

function GuildWarUtils.HasShopReddot()
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
    local MaxRaidScore = RaidSeasons.MaxRaidScore or 0
    MaxRaidScore = tonumber(MaxRaidScore)
    local SubTabId = GuildWarUtils.GetShopSubTabId(RaidSeasons.Shop)
    for ShopItemId, ShopData in pairs(DataMgr.ShopItem) do
      if ShopData.SubTabId == SubTabId and ShopUtils:GetShopItemCanShow(ShopItemId) then
        local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(ShopData.ItemId)
        if 0 ~= PurchaseLimit and not Avatar:CheckShopItemUnique(ShopData.ItemId) then
          local CoinNum = Avatar:GetResourceNum(ShopData.PriceType) or 0
          CoinNum = tonumber(CoinNum) or 0
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
  return ShowReddot
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
    if ClearCache then
      ReddotManager.ClearLeafNodeCount(GuildWarUtils.ReddotRewardKey)
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
                if not CacheDetail[QuestPhaseId][QuestId] then
                  ReddotManager.IncreaseLeafNodeCount(GuildWarUtils.ReddotRewardKey)
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
      ShowReddot = 0 == RaidSeasons.MaxPreRaidScore and 1 ~= RaidSeasons.BanState
      if GuildWarUtils.IsFloorMode() then
        ShowReddot = 0 == RaidSeasons.PreRaidFloor and 1 ~= RaidSeasons.BanState
      end
    elseif GuildWarUtils.IsOfficalRaidTime() then
      ShowReddot = 0 == RaidSeasons.MaxRaidScore and 0 == RaidSeasons.BanState
      if GuildWarUtils.IsFloorMode() then
        ShowReddot = 0 == RaidSeasons.RaidFloor and 0 == RaidSeasons.BanState
      end
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

function GuildWarUtils.GetRaidRankRewardByGroup(SeasonId, PreRaidGroupId, FinalRank)
  for _, RankRewardData in pairs(DataMgr.RaidRankReward) do
    if RankRewardData.RaidSeason == SeasonId and RankRewardData.RankPercent == PreRaidGroupId then
      local RankRange = RankRewardData.RankRange
      if RankRange and 2 == #RankRange and FinalRank >= RankRange[1] and FinalRank <= RankRange[2] then
        return RankRewardData.RangeReward
      end
    end
  end
  return nil
end

function GuildWarUtils.GetRaidRankRewardListByGroup(SeasonId, PreRaidGroupId)
  local Result = {}
  if not (SeasonId and PreRaidGroupId) or PreRaidGroupId <= 0 then
    return Result
  end
  for _, RankRewardData in pairs(DataMgr.RaidRankReward) do
    if RankRewardData.RaidSeason == SeasonId and RankRewardData.RankPercent == PreRaidGroupId then
      table.insert(Result, RankRewardData)
    end
  end
  table.sort(Result, function(A, B)
    local RangeA = A.RankRange and A.RankRange[1] or 0
    local RangeB = B.RankRange and B.RankRange[1] or 0
    return RangeA < RangeB
  end)
  return Result
end

function GuildWarUtils.HasRaidRankRewardByGroup(SeasonId, PreRaidGroupId)
  return #GuildWarUtils.GetRaidRankRewardListByGroup(SeasonId, PreRaidGroupId) > 0
end

return GuildWarUtils
