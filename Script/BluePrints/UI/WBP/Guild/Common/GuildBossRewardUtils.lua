require("UnLua")
local UIUtils = require("Utils.UIUtils")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local GuildBossUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossUtils")
local GuildBossPointRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossPointRewardUtils")
local StageRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossStageRewardUtils")
local ScoreTierRewardHelper = require("BluePrints.UI.UI_PC.Common.ScoreTierReward.ScoreTierRewardHelper")
local SimpleRewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local M = {}
local POINT_TAB_TYPE = "Point"
local PERSONAL_TAB_TYPE = "Personal"
local GUILD_TAB_TYPE = "Guild"
local STAGE_REDDOT_NODE = "GuildBossProgressReward"
local POINT_REWARD_SLOT_COUNT = 5
M.PERSONAL_TAB_TYPE = PERSONAL_TAB_TYPE
M.GUILD_TAB_TYPE = GUILD_TAB_TYPE
M.POINT_REWARD_SLOT_COUNT = POINT_REWARD_SLOT_COUNT

local function NormalizeDefaultTabType(DefaultType)
  if DefaultType == GUILD_TAB_TYPE then
    return GUILD_TAB_TYPE
  end
  return PERSONAL_TAB_TYPE
end

function M.GetPointRewardSnapshot()
  local AvatarBossData = GuildModel:GetAvatarGuildBossData()
  return ScoreTierRewardHelper.BuildSnapshot(GuildBossPointRewardUtils.GetPointRewardConfig(AvatarBossData), AvatarBossData and AvatarBossData:GetPoint() or 0, function(Index)
    return GuildBossPointRewardUtils.IsPointRewardGot(AvatarBossData, Index)
  end)
end

local function GetPointRewardItems(Widget)
  if Widget.PointRewardItems then
    return Widget.PointRewardItems
  end
  Widget.PointRewardItems = {
    Widget.Reward_01,
    Widget.Reward_02,
    Widget.Reward_03,
    Widget.Reward_04,
    Widget.Reward_05
  }
  return Widget.PointRewardItems
end

local function UpdatePointRewardProgressBar(Widget, CurrentPoint, Snapshot)
  if not (IsValid(Widget.Bar_Progress) and Snapshot) or not Snapshot.EachGradePoints then
    if IsValid(Widget.Bar_Progress) then
      Widget.Bar_Progress:SetPercent(0)
    end
    return
  end
  local Thresholds = {}
  for Index = 1, POINT_REWARD_SLOT_COUNT do
    if Snapshot.RewardIds[Index] then
      table.insert(Thresholds, Snapshot.EachGradePoints * Index)
    end
  end
  if 0 == #Thresholds then
    Widget.Bar_Progress:SetPercent(0)
    return
  end
  if 1 == #Thresholds then
    Widget.Bar_Progress:SetPercent(CurrentPoint >= Thresholds[1] and 1.0 or 0)
    return
  end
  local FirstThreshold = Thresholds[1]
  local LastThreshold = Thresholds[#Thresholds]
  if CurrentPoint <= FirstThreshold or FirstThreshold >= LastThreshold then
    Widget.Bar_Progress:SetPercent(0)
    return
  end
  if CurrentPoint >= LastThreshold then
    Widget.Bar_Progress:SetPercent(1.0)
    return
  end
  for Index = 1, #Thresholds - 1 do
    local CurThreshold = Thresholds[Index]
    local NextThreshold = Thresholds[Index + 1]
    if CurrentPoint <= NextThreshold then
      local SegmentCapacity = NextThreshold - CurThreshold
      local SegmentPercent = SegmentCapacity > 0 and (CurrentPoint - CurThreshold) / SegmentCapacity or 0
      Widget.Bar_Progress:SetPercent((Index - 1 + SegmentPercent) / (#Thresholds - 1))
      return
    end
  end
  Widget.Bar_Progress:SetPercent(1.0)
end

function M.ClaimPointRewardSlot(Widget, Index)
  if not Widget or not Index then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.GuildBossClaimPointReward then
    return
  end
  Avatar:GuildBossClaimPointReward(function(RetCode, Rewards)
    if not ErrorCode:Check(RetCode) then
      return
    end
    M.RefreshGuildBossRewardConfigData(Widget)
    if Widget.RefreshItems then
      Widget:RefreshItems()
      local CurConfig = Widget.HasTab and Widget.ConfigData.Datas[Widget.Type] or Widget.ConfigData
      if CurConfig then
        Widget:RefreshBtnGetAll(CurConfig)
        Widget:RefreshTabReddot()
      end
    end
    M.RefreshPointRewardBottom(Widget)
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, Widget)
  end, Index)
end

function M.RefreshPointRewardHeader(Widget)
  if not Widget then
    return
  end
  local Snapshot = M.GetPointRewardSnapshot()
  if Widget.Group_Bottom then
    Widget.Group_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if Widget.Panel_ActivityReward then
    Widget.Panel_ActivityReward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if Widget.Text_ActivityDesc then
    Widget.Text_ActivityDesc:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    Widget.Text_ActivityDesc:SetText(GText("UI_GuildBoss_StrongEnemyPoint"))
  end
  if Widget.Text_Now then
    Widget.Text_Now:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    Widget.Text_Now:SetText(tostring(Snapshot and Snapshot.CurrentScore or 0))
  end
  if Widget.Text_Total then
    Widget.Text_Total:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local DisplayMax = Snapshot and Snapshot.MaxScore or 0
    if Snapshot and Snapshot.RewardIds and Snapshot.EachGradePoints then
      local VisibleCount = math.min(POINT_REWARD_SLOT_COUNT, #Snapshot.RewardIds)
      if VisibleCount > 0 then
        DisplayMax = Snapshot.EachGradePoints * VisibleCount
      end
    end
    Widget.Text_Total:SetText(tostring(DisplayMax))
  end
  if Widget.Bar_Progress then
    Widget.Bar_Progress:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function M.RefreshPointRewardBottom(Widget)
  if not Widget then
    return
  end
  local Snapshot = M.GetPointRewardSnapshot()
  M.RefreshPointRewardHeader(Widget)
  local RewardItems = GetPointRewardItems(Widget)
  local CurrentPoint = Snapshot and Snapshot.CurrentScore or 0
  local EachGradePoints = Snapshot and Snapshot.EachGradePoints or 0
  for Index = 1, POINT_REWARD_SLOT_COUNT do
    local Item = RewardItems[Index]
    if not IsValid(Item) then
      break
    end
    local RewardId = Snapshot and Snapshot.RewardIds and Snapshot.RewardIds[Index]
    if not RewardId or EachGradePoints <= 0 then
      Item:SetVisibility(ESlateVisibility.Collapsed)
    else
      local GradePoints = EachGradePoints * Index
      local RewardsGot = Snapshot.IsRewardGot and Snapshot.IsRewardGot(Index) or false
      Item:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      if Item.Text_Num then
        Item.Text_Num:SetText(tostring(GradePoints))
      end
      Item.ParentUI = Widget
      Item:Setup(Index, GradePoints, CurrentPoint, RewardsGot)
    end
  end
  UpdatePointRewardProgressBar(Widget, CurrentPoint, Snapshot)
end

local function BuildRewardContents(RewardId)
  local Rewards = {}
  local RewardInfo = RewardId and DataMgr.Reward[RewardId]
  if not RewardInfo then
    return Rewards
  end
  local Types = RewardInfo.Type or {}
  local Ids = RewardInfo.Id or {}
  local Counts = RewardInfo.Count or {}
  for Index = 1, #Ids do
    table.insert(Rewards, {
      ItemType = Types[Index],
      ItemId = Ids[Index],
      Count = RewardUtils:GetCount(Counts[Index])
    })
  end
  return Rewards
end

local function FormatGuildBossProgressText(TextKey, Value)
  local Template = GText(TextKey)
  if not Template or Template == TextKey then
    return tostring(Value)
  end
  return Template:gsub("%%d", tostring(Value), 1)
end

local function MergeGuildBossClaimResultItems(Info)
  local MergedRewards = {}
  if not Info or not Info.Rewards then
    return MergedRewards
  end
  for _, RewardEntry in ipairs(Info.Rewards) do
    if RewardEntry and RewardEntry.Items then
      MergedRewards = SimpleRewardBox.MergeDumpTables(MergedRewards, RewardEntry.Items)
    end
  end
  return MergedRewards
end

M.MergeGuildBossClaimResultItems = MergeGuildBossClaimResultItems

function M.GetBossHpProgress(BossId)
  local GuildBossData = GuildModel:GetGuildBossData()
  if not BossId or 0 == BossId or not GuildBossData then
    return 0
  end
  local BossInfo = GuildBossUtils.GetBossInfo(BossId)
  local MaxHp = BossInfo and tonumber(BossInfo.BossTotalHP) or 0
  local CurHp = GuildBossData:GetHpProgressOfBoss(BossId) or 0
  if MaxHp <= 0 then
    return 0
  end
  return math.min(100, math.floor(CurHp) / MaxHp * 100)
end

function M.GetRemainTimeDict()
  local RefreshInfo = GuildBossUtils.GetCurrentRefreshConfig()
  local WeekEnd = RefreshInfo and GuildBossUtils.GetCurrentWeekSlotEndTime(RefreshInfo)
  if not WeekEnd then
    return {}, nil
  end
  return UIUtils.GetLeftTimeStrStyle2(WeekEnd, nil), WeekEnd
end

function M.BuildPointRewardItems(OwnerWidget)
  local AvatarBossData = GuildModel:GetAvatarGuildBossData()
  local Snapshot = ScoreTierRewardHelper.BuildSnapshot(GuildBossPointRewardUtils.GetPointRewardConfig(AvatarBossData), AvatarBossData and AvatarBossData:GetPoint() or 0, function(Index)
    return GuildBossPointRewardUtils.IsPointRewardGot(AvatarBossData, Index)
  end)
  local Items = {}
  if not (Snapshot and Snapshot.RewardIds) or not Snapshot.EachGradePoints then
    return Items
  end
  for Index, RewardId in ipairs(Snapshot.RewardIds) do
    local GradePoints = Snapshot.EachGradePoints * Index
    local RewardsGot = GuildBossPointRewardUtils.IsPointRewardGot(AvatarBossData, Index)
    table.insert(Items, {
      ItemId = Index,
      Type = POINT_TAB_TYPE,
      CanReceive = GradePoints <= (Snapshot.CurrentScore or 0) and not RewardsGot,
      RewardsGot = RewardsGot,
      InProgress = GradePoints > (Snapshot.CurrentScore or 0),
      NotreachText = "UI_GameEvent_ToBeFinished",
      Hint = string.format("%s%d", GText("RougeMiniGamePointsReach"), GradePoints),
      ReceiveButtonText = "UI_Archive_CollectionClaim",
      ReceiveCallBack = M.OnClaimPointReward,
      ReceiveParm = {OwnerWidget = OwnerWidget, Index = Index},
      LeftAligned = true,
      SourceNum = GradePoints,
      ShowIcon = false,
      Rewards = BuildRewardContents(RewardId)
    })
  end
  return Items
end

function M.BuildPointRewardTabData(OwnerWidget)
  local AvatarBossData = GuildModel:GetAvatarGuildBossData()
  return {
    Type = POINT_TAB_TYPE,
    SortType = 2,
    Text_Total = "UI_GuildBoss_StrongEnemyPoint",
    NowNum = AvatarBossData and AvatarBossData:GetPoint() or 0,
    NumMax = GuildBossPointRewardUtils.GetPointMax(AvatarBossData),
    ReceiveButtonText = "UI_GuildBoss_OneClickClaim",
    ReceiveAllCallBack = M.OnClaimAllPointReward,
    ReceiveAllParam = {SelfWidget = OwnerWidget},
    HasCanReceive = GuildBossPointRewardUtils.GetCanClaimRewardCount(AvatarBossData) > 0,
    Items = M.BuildPointRewardItems(OwnerWidget)
  }
end

function M.BuildStageRewardItems(OwnerWidget, IsGuildTab)
  local Items = {}
  for _, StageValue in ipairs(StageRewardUtils.GetStages()) do
    local RewardConfig = DataMgr.GuildBossWeekReward[StageValue]
    if RewardConfig then
      local Rewards = {}
      if IsGuildTab then
        table.insert(Rewards, {
          ItemType = "Resource",
          ItemId = 4005,
          Count = RewardConfig.GuildConstructionPoint or 0
        })
      else
        Rewards = BuildRewardContents(RewardConfig.StageReward)
      end
      local IsReached = StageRewardUtils.IsStageUnlocked(StageValue)
      local RewardsGot = IsGuildTab and IsReached or StageRewardUtils.IsStageRewardGot(StageValue)
      local CanReceive = not IsGuildTab and IsReached and not RewardsGot
      table.insert(Items, {
        ItemId = StageValue,
        Index = StageValue,
        Nums = StageValue,
        Type = IsGuildTab and GUILD_TAB_TYPE or PERSONAL_TAB_TYPE,
        CanReceive = CanReceive,
        RewardsGot = RewardsGot,
        InProgress = not IsReached,
        NotreachText = "UI_GameEvent_ToBeFinished",
        Hint = FormatGuildBossProgressText("UI_GuildBoss_ProgressReached", StageValue),
        ReceiveButtonText = "UI_Archive_CollectionClaim",
        ReceiveCallBack = M.OnClaimStageReward,
        ReceiveParm = {
          OwnerWidget = OwnerWidget,
          Stage = StageValue,
          IsGuild = IsGuildTab
        },
        LeftAligned = false,
        Rewards = Rewards
      })
    end
  end
  return Items
end

function M.BuildStageRewardTabData(OwnerWidget, IsGuildTab, CurrentProgress)
  local ProgressText = FormatGuildBossProgressText("UI_GuildBoss_CurrentProgress", math.floor(CurrentProgress or 0))
  local Items = M.BuildStageRewardItems(OwnerWidget, IsGuildTab)
  local HasCanReceive = false
  for _, Item in ipairs(Items) do
    if Item.CanReceive and not Item.RewardsGot then
      HasCanReceive = true
      break
    end
  end
  local Data = {
    Type = IsGuildTab and GUILD_TAB_TYPE or PERSONAL_TAB_TYPE,
    SortType = 2,
    Text_Total = ProgressText,
    NowNum = CurrentProgress or 0,
    NumMax = 100,
    OnlyShowNowProgress = true,
    ShowSourceNum = true,
    Items = Items,
    HasCanReceive = HasCanReceive
  }
  if IsGuildTab then
    Data.HideReceiveButton = true
    Data.TipText = "UI_GuildBoss_StageRewardDesc"
    Data.ReceiveButtonText = "UI_GuildBoss_OneClickClaim"
    
    function Data.ReceiveAllCallBack()
    end
    
    Data.ReceiveAllParam = {OwnerWidget = OwnerWidget}
  else
    Data.ReceiveButtonText = "UI_GuildBoss_OneClickClaim"
    Data.ReceiveAllCallBack = M.OnClaimAllStageReward
    Data.ReceiveAllParam = {OwnerWidget = OwnerWidget}
  end
  return Data
end

function M.BuildGuildBossRewardParams(OwnerWidget, DefaultType, BossId)
  local CurrentBossId = BossId or StageRewardUtils.GetCurrentBossId()
  local CurrentProgress = M.GetBossHpProgress(CurrentBossId)
  local RemainTimeDict = M.GetRemainTimeDict()
  local TabType = NormalizeDefaultTabType(DefaultType)
  return {
    Owner = OwnerWidget,
    ConfigData = {
      Mode = "GuildBoss",
      TopText = "UI_GuildBoss_ProgressReward",
      TimeText = "UI_ResetRemaining",
      RemainTimeDict = RemainTimeDict,
      HasTab = true,
      Type = TabType,
      PointRewardData = M.BuildPointRewardTabData(OwnerWidget),
      TabInfo = {
        {
          Title = "UI_GuildBoss_RoleReward",
          Type = PERSONAL_TAB_TYPE,
          ReddotName = STAGE_REDDOT_NODE,
          IsShowIcon = false
        },
        {
          Title = "UI_GuildBoss_GuildReward",
          Type = GUILD_TAB_TYPE,
          ReddotName = STAGE_REDDOT_NODE,
          IsShowIcon = false,
          IsForbidden = true,
          ForbiddenReasonText = GText("GuildBossRewardNotOpen")
        }
      },
      Datas = {
        [PERSONAL_TAB_TYPE] = M.BuildStageRewardTabData(OwnerWidget, false, CurrentProgress),
        [GUILD_TAB_TYPE] = M.BuildStageRewardTabData(OwnerWidget, true, CurrentProgress)
      }
    }
  }
end

function M.RefreshGuildBossRewardConfigData(Widget)
  if not Widget or not Widget.Owner then
    return
  end
  local CurrentType = Widget.Type
  local Params = M.BuildGuildBossRewardParams(Widget.Owner, CurrentType)
  local ConfigData = Params and Params.ConfigData
  if not ConfigData then
    return
  end
  Widget.ConfigData = ConfigData
  Widget.Datas = ConfigData.Datas
  Widget.Items = ConfigData.Items
  Widget.TabInfo = ConfigData.TabInfo
  Widget.HasTab = ConfigData.HasTab
  if Widget.Type and not ConfigData.Datas[Widget.Type] then
    Widget.Type = ConfigData.Type
  end
  M.RefreshPointRewardBottom(Widget)
end

function M.RefreshBossStageReddot()
  GuildModel:InvokeGuildBossRewardReddotUpdate()
end

function M.OnClaimPointReward(RewardItem, Content)
  Content = Content or RewardItem
  local ReceiveParm = Content and Content.ConfigData and Content.ConfigData.ReceiveParm
  if not ReceiveParm then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.GuildBossClaimPointReward then
    return
  end
  Avatar:GuildBossClaimPointReward(function(RetCode, Rewards)
    if not ErrorCode:Check(RetCode) then
      return
    end
    local OwnerWidget = RewardItem and RewardItem.Owner
    if OwnerWidget and OwnerWidget.RefreshItems then
      M.RefreshGuildBossRewardConfigData(OwnerWidget)
      OwnerWidget:RefreshItems()
      local CurConfig = OwnerWidget.HasTab and OwnerWidget.ConfigData.Datas[OwnerWidget.Type] or OwnerWidget.ConfigData
      OwnerWidget:RefreshBtnGetAll(CurConfig)
      OwnerWidget:RefreshTabReddot()
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, OwnerWidget)
  end, ReceiveParm.Index)
end

function M.OnClaimAllPointReward(_, ReceiveAllParm)
  if not ReceiveAllParm or not ReceiveAllParm.SelfWidget then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.GuildBossClaimAllPointReward then
    return
  end
  Avatar:GuildBossClaimAllPointReward(function(RetCode, Info)
    if not ErrorCode:Check(RetCode) then
      return
    end
    local OwnerWidget = ReceiveAllParm.SelfWidget
    M.RefreshGuildBossRewardConfigData(OwnerWidget)
    if OwnerWidget and OwnerWidget.RefreshItems then
      OwnerWidget:RefreshItems()
      local CurConfig = OwnerWidget.HasTab and OwnerWidget.ConfigData.Datas[OwnerWidget.Type] or OwnerWidget.ConfigData
      OwnerWidget:RefreshBtnGetAll(CurConfig)
      OwnerWidget:RefreshTabReddot()
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, M.MergeGuildBossClaimResultItems(Info), false, nil, OwnerWidget)
  end)
end

function M.OnClaimStageReward(RewardItem, Content)
  Content = Content or RewardItem
  local Stage = Content and Content.ConfigData and Content.ConfigData.Nums
  if not Stage then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.GuildBossClaimStageReward then
    return
  end
  Avatar:GuildBossClaimStageReward(function(RetCode, Items)
    if not ErrorCode:Check(RetCode) then
      return
    end
    local OwnerWidget = RewardItem and RewardItem.Owner
    if OwnerWidget and OwnerWidget.RefreshItems then
      M.RefreshGuildBossRewardConfigData(OwnerWidget)
      OwnerWidget:RefreshItems()
      local CurConfig = OwnerWidget.HasTab and OwnerWidget.ConfigData.Datas[OwnerWidget.Type] or OwnerWidget.ConfigData
      OwnerWidget:RefreshBtnGetAll(CurConfig)
      OwnerWidget:RefreshTabReddot()
    end
    ReddotManager.DecreaseLeafNodeCount(STAGE_REDDOT_NODE, 1, {Stage = Stage})
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Items, false, nil, OwnerWidget)
  end, StageRewardUtils.GetGuildId(), StageRewardUtils.GetCurrentBossId(), Stage)
end

function M.OnClaimAllStageReward(_, ReceiveAllParm)
  if not ReceiveAllParm or not ReceiveAllParm.SelfWidget then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.GuildBossClaimAllReward then
    return
  end
  Avatar:GuildBossClaimAllReward(function(RetCode, Result)
    if not ErrorCode:Check(RetCode) then
      return
    end
    local OwnerWidget = ReceiveAllParm.SelfWidget
    M.RefreshBossStageReddot()
    M.RefreshGuildBossRewardConfigData(OwnerWidget)
    if OwnerWidget and OwnerWidget.RefreshItems then
      OwnerWidget:RefreshItems()
      local CurConfig = OwnerWidget.HasTab and OwnerWidget.ConfigData.Datas[OwnerWidget.Type] or OwnerWidget.ConfigData
      OwnerWidget:RefreshBtnGetAll(CurConfig)
      OwnerWidget:RefreshTabReddot()
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, M.MergeGuildBossClaimResultItems(Result), false, nil, OwnerWidget)
  end)
end

return M
