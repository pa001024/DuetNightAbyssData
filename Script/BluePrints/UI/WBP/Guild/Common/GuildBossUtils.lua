local TimeUtils = require("Utils.TimeUtils")
local UIUtils = require("Utils.UIUtils")
local M = {}
local ONE_WEEK_SECONDS = 604800
local GUILD_ACTIVITY_KEEP_DAYS = 14
local GUILD_BOSS_OPEN_GRACE_WEEKS = 2
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")

local function GetGuildActivityWeekday(Now)
  Now = Now or TimeUtils.NowTime()
  local RefreshHMS = TimeUtils.RefreshHMS or {
    5,
    0,
    0
  }
  local RefreshSec = TimeUtils.GetSec(table.unpack(RefreshHMS))
  local DateObj = TimeUtils.TimestampToDataObj(Now - RefreshSec)
  if not DateObj then
    return 1
  end
  return 1 == DateObj.wday and 7 or DateObj.wday - 1
end

local function GetActivityLevelSlotValue(ActivityLevels, Index)
  if not ActivityLevels or Index <= 0 then
    return 0
  end
  if ActivityLevels.GetRef then
    return math.max(0, math.floor(tonumber(ActivityLevels:GetRef(Index)) or 0))
  end
  return math.max(0, math.floor(tonumber(ActivityLevels[Index]) or 0))
end

local function GetActivityLevelByDaysAgo(GuildInfo, DaysAgo)
  if not GuildInfo then
    return 0
  end
  DaysAgo = math.max(0, math.floor(tonumber(DaysAgo) or 0))
  local LastDaySerial = math.floor(tonumber(GuildInfo.ActivityLevelLastDay) or 0)
  if LastDaySerial <= 0 then
    return 0
  end
  local DaySerial = LastDaySerial - DaysAgo
  if DaySerial <= 0 or LastDaySerial - DaySerial >= GUILD_ACTIVITY_KEEP_DAYS then
    return 0
  end
  local SlotIndex = DaySerial % GUILD_ACTIVITY_KEEP_DAYS + 1
  return GetActivityLevelSlotValue(GuildInfo.ActivityLevels, SlotIndex)
end

local function GetCurrentWeekActivitySum(GuildInfo, Now)
  if not GuildInfo then
    return 0
  end
  local Weekday = GetGuildActivityWeekday(Now)
  local Sum = 0
  for DaysAgo = 0, math.max(0, Weekday - 1) do
    Sum = Sum + GetActivityLevelByDaysAgo(GuildInfo, DaysAgo)
  end
  return Sum
end

local function GetPreviousWeekActivitySum(GuildInfo, Now)
  if not GuildInfo then
    return 0
  end
  local Weekday = GetGuildActivityWeekday(Now)
  local Sum = 0
  for DaysAgo = Weekday, Weekday + 6 do
    Sum = Sum + GetActivityLevelByDaysAgo(GuildInfo, DaysAgo)
  end
  return Sum
end

local function IsGuildWithinBossOpenGracePeriod(GuildInfo, Now)
  if not GuildInfo then
    return false
  end
  local CreateTime = math.floor(tonumber(GuildInfo.CreateTime) or 0)
  if CreateTime <= 0 then
    return false
  end
  Now = Now or TimeUtils.NowTime()
  local GraceEndTime = CreateTime
  for _ = 1, GUILD_BOSS_OPEN_GRACE_WEEKS do
    GraceEndTime = TimeUtils.NextWeeklyRefreshTime(GraceEndTime)
  end
  return Now < GraceEndTime
end

local function IsGuildBossActivityUnlocked(GuildInfo, Now)
  if IsGuildWithinBossOpenGracePeriod(GuildInfo, Now) then
    return true
  end
  local NeedActivity = DataMgr.GlobalConstant.GuildBossOpenConditionData and tonumber(DataMgr.GlobalConstant.GuildBossOpenConditionData.ConstantValue) or 3000
  if NeedActivity <= GetPreviousWeekActivitySum(GuildInfo, Now) then
    return true
  end
  return NeedActivity <= GetCurrentWeekActivitySum(GuildInfo, Now)
end

function M.GetCurrentRefreshConfig(GuildBossData)
  GuildBossData = GuildBossData or GuildModel:GetGuildBossData()
  if not GuildBossData then
    return nil
  end
  local SeasonKey = GuildBossData:GetSeasonKey()
  if SeasonKey <= 0 then
    SeasonKey = 1
  end
  return DataMgr.GuildBossRefresh[SeasonKey]
end

function M.GetBossOrderList(RefreshInfo, GuildBossData)
  GuildBossData = GuildBossData or GuildModel:GetGuildBossData()
  local BossOrder = GuildBossData and GuildBossData:GetBossOrder()
  if BossOrder and #BossOrder > 0 then
    return BossOrder
  end
  return RefreshInfo and RefreshInfo.BossID or {}
end

function M.GetSeasonWeekCount(RefreshInfo)
  return 6
end

function M.GetCurrentSeasonWeekIndex(RefreshInfo, NowTime, GuildBossData)
  NowTime = NowTime or TimeUtils.NowTime()
  GuildBossData = GuildBossData or GuildModel:GetGuildBossData()
  local CurrentBossIndex = GuildBossData and GuildBossData:GetCurrentBossIndex() or 0
  if CurrentBossIndex > 0 then
    return CurrentBossIndex
  end
  local PeriodStart = RefreshInfo and RefreshInfo.StartTime or 0
  if PeriodStart <= 0 then
    return 1
  end
  return math.floor(math.max(0, NowTime - PeriodStart) / ONE_WEEK_SECONDS) + 1
end

function M.GetActiveBossSlotIndex(WeekIndex, BossCount)
  if BossCount <= 0 then
    return 1
  end
  return (WeekIndex - 1) % BossCount + 1
end

function M.GetWeeksUntilBossSlot(CurrentWeekIndex, TargetSlotIndex, BossCount)
  if BossCount <= 0 then
    return 0
  end
  local CurrentSlot = M.GetActiveBossSlotIndex(CurrentWeekIndex, BossCount)
  if CurrentSlot == TargetSlotIndex then
    return 0
  end
  local Diff = TargetSlotIndex - CurrentSlot
  if Diff <= 0 then
    Diff = Diff + BossCount
  end
  return Diff
end

function M.GetNextBossAppearanceWeekIndex(CurrentWeekIndex, TargetSlotIndex, BossCount, SeasonWeekCount)
  local WeeksUntil = M.GetWeeksUntilBossSlot(CurrentWeekIndex, TargetSlotIndex, BossCount)
  if 0 == WeeksUntil then
    return CurrentWeekIndex
  end
  local NextWeekIndex = CurrentWeekIndex + WeeksUntil
  if SeasonWeekCount < NextWeekIndex then
    return nil
  end
  return NextWeekIndex
end

function M.GetBossSlotTimeRange(RefreshInfo, SlotIndex, NowTime, GuildBossData)
  NowTime = NowTime or TimeUtils.NowTime()
  local PeriodStart = RefreshInfo.StartTime or 0
  local CurrentWeekIndex = M.GetCurrentSeasonWeekIndex(RefreshInfo, NowTime, GuildBossData)
  local StartTime = PeriodStart + (CurrentWeekIndex - 1) * ONE_WEEK_SECONDS
  local EndTime = StartTime + ONE_WEEK_SECONDS
  return StartTime, EndTime
end

function M.GetBossSlotState(RefreshInfo, SlotIndex, NowTime, GuildBossData)
  NowTime = NowTime or TimeUtils.NowTime()
  if not (RefreshInfo and SlotIndex) or SlotIndex <= 0 then
    return "Ended"
  end
  local BossOrder = M.GetBossOrderList(RefreshInfo, GuildBossData)
  local BossCount = #BossOrder
  if BossCount <= 0 or SlotIndex > BossCount then
    return "Ended"
  end
  local SeasonWeekCount = M.GetSeasonWeekCount(RefreshInfo)
  local CurrentWeekIndex = M.GetCurrentSeasonWeekIndex(RefreshInfo, NowTime, GuildBossData)
  if SeasonWeekCount < CurrentWeekIndex then
    return "Ended"
  end
  local NextAppearanceWeek = M.GetNextBossAppearanceWeekIndex(CurrentWeekIndex, SlotIndex, BossCount, SeasonWeekCount)
  if not NextAppearanceWeek then
    return "Ended"
  end
  local PeriodStart = RefreshInfo.StartTime or 0
  local NextWeekStartTime = PeriodStart + (NextAppearanceWeek - 1) * ONE_WEEK_SECONDS
  if NowTime >= NextWeekStartTime then
    return "Active"
  end
  return "NotStarted", math.max(0, NextWeekStartTime - NowTime)
end

function M.GetBossStateByBossId(BossId)
  local RefreshInfo = M.GetCurrentRefreshConfig()
  if not RefreshInfo then
    return nil
  end
  local SlotIndex = M.GetBossSlotIndex(RefreshInfo, BossId)
  if not SlotIndex then
    return nil
  end
  local State, RemainSec = M.GetBossSlotState(RefreshInfo, SlotIndex)
  if "Active" == State then
    local Avatar = GWorld:GetAvatar()
    local GuildInfo = Avatar and Avatar.GuildInfo
    if IsGuildBossActivityUnlocked(GuildInfo) then
      return "Active"
    end
    return "ScoreNotEnough", RemainSec
  end
  return State, RemainSec
end

function M.GetAssistGuildBossStateByBossId(GuildBossData, GuildInfo, BossId)
  if not GuildBossData then
    return nil
  end
  local SeasonKey = GuildBossData:GetSeasonKey()
  local RefreshInfo = DataMgr.GuildBossRefresh[SeasonKey]
  if not RefreshInfo then
    return nil
  end
  local BossIndex = M.GetBossSlotIndex(RefreshInfo, BossId, GuildBossData)
  if not BossIndex then
    return nil
  end
  local State, RemainSec = M.GetBossSlotState(RefreshInfo, BossIndex, nil, GuildBossData)
  if "Active" == State then
    if IsGuildBossActivityUnlocked(GuildInfo) then
      return "Active"
    end
    return "ScoreNotEnough"
  end
  return State, RemainSec
end

function M.GetBossInfo(BossId)
  return DataMgr.GuildBossInfo and DataMgr.GuildBossInfo[BossId] or nil
end

function M.GetCurrentWeekSlotEndTime(RefreshInfo, NowTime, GuildBossData)
  if not RefreshInfo then
    return nil
  end
  NowTime = NowTime or TimeUtils.NowTime()
  local PeriodStart = RefreshInfo.StartTime or 0
  local CurrentWeekIndex = M.GetCurrentSeasonWeekIndex(RefreshInfo, NowTime, GuildBossData)
  local SeasonWeekCount = M.GetSeasonWeekCount(RefreshInfo)
  if CurrentWeekIndex > SeasonWeekCount then
    return nil
  end
  return PeriodStart + CurrentWeekIndex * ONE_WEEK_SECONDS
end

function M.GetBossSlotIndex(RefreshInfo, BossId, GuildBossData)
  if not BossId then
    return nil
  end
  for Index, Id in ipairs(M.GetBossOrderList(RefreshInfo, GuildBossData)) do
    if Id == BossId then
      return Index
    end
  end
  return nil
end

function M.BuildGuildWarTestParameter(TrailConfig)
  if not TrailConfig then
    return nil
  end
  if TrailConfig.TestParameter then
    return TrailConfig.TestParameter
  end
  local Rule = TrailConfig.CalulationRule
  if not Rule then
    return nil
  end
  if Rule.Rate then
    return {
      [1] = tostring(math.floor(Rule.Rate * 100 + 0.5)) .. "%"
    }
  end
  if Rule.Hit then
    return {
      [1] = tostring(Rule.Hit)
    }
  end
  return nil
end

function M.FormatGuildWarBuffDesc(BuffConfig)
  if not BuffConfig or not BuffConfig.BuffDes then
    return ""
  end
  local Desc = GText(BuffConfig.BuffDes)
  if BuffConfig.BuffParameter then
    Desc = UIUtils.GenAbyssEntryDesc(Desc, BuffConfig.BuffParameter, 0)
  end
  return Desc
end

function M.FormatGuildWarTestDesc(TrailConfig)
  if not TrailConfig or not TrailConfig.TestDes then
    return ""
  end
  local Desc = GText(TrailConfig.TestDes)
  local TestParameter = M.BuildGuildWarTestParameter(TrailConfig)
  if TestParameter then
    local bIsFormula = false
    for _, v in pairs(TestParameter) do
      if type(v) == "string" and string.match(v, "^%$") then
        bIsFormula = true
        break
      end
    end
    if bIsFormula then
      Desc = UIUtils.GenAbyssEntryDesc(Desc, TestParameter, 0)
    else
      for i, ValStr in pairs(TestParameter) do
        local EscapedVal = string.gsub(ValStr, "%%", "%%%%")
        Desc = string.gsub(Desc, "#" .. i, EscapedVal)
      end
    end
  end
  return Desc
end

function M.CalcTrialProgressPercent(TrialId, Progress)
  local TrialCfg = TrialId and DataMgr.GuildWarTest and DataMgr.GuildWarTest[TrialId] or nil
  local Rule = TrialCfg and TrialCfg.CalulationRule or nil
  local MaxProgress = Rule and (Rule.Rate or Rule.Hit) or nil
  if not MaxProgress or MaxProgress <= 0 then
    return 0
  end
  return math.min(100, math.max(0, (tonumber(Progress) or 0) / MaxProgress * 100))
end

function M.SetBossSlotTimeText(TimeWidget, RefreshInfo, BossId, GuildBossData)
  if not (TimeWidget and RefreshInfo) or not BossId then
    return false
  end
  local SlotIndex = M.GetBossSlotIndex(RefreshInfo, BossId, GuildBossData)
  if not SlotIndex then
    return false
  end
  local State = M.GetBossSlotState(RefreshInfo, SlotIndex, nil, GuildBossData)
  if "Active" ~= State then
    TimeWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return false
  end
  TimeWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local _, EndTime = M.GetBossSlotTimeRange(RefreshInfo, SlotIndex, nil, GuildBossData)
  local RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(EndTime, nil)
  if TimeWidget.SetCountdownTextOnly then
    TimeWidget:SetCountdownTextOnly(RemainTimeDict, "")
  else
    TimeWidget:SetTimeText("", RemainTimeDict)
  end
  return true
end

function M.GetTrialIconPath(Index)
  return string.format("/Game/UI/Texture/Dynamic/Atlas/Guild/T_Guild_Boss_IconTrial_%d.T_Guild_Boss_IconTrial_%d", Index, Index)
end

function M.GetTrialVXIconPath(Index)
  return string.format("/Game/UI/WBP/Common/VX/Guild/Boss/MI_Guild_Boss_Settlement_TrialProgress_%d.MI_Guild_Boss_Settlement_TrialProgress_%d", Index, Index)
end

function M.StartBossTimeRefreshTicker(Widget, TickFunc)
  if Widget.GuildBossTimeTimer then
    return
  end
  Widget.GuildBossTimeTimer = Widget:AddTimer(1, TickFunc, true, 0, "GuildBossTimeRefresh", true)
end

function M.StopBossTimeRefreshTicker(Widget)
  if Widget.GuildBossTimeTimer then
    Widget:RemoveTimer(Widget.GuildBossTimeTimer)
    Widget.GuildBossTimeTimer = nil
  end
end

return M
