require("UnLua")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local GuildBossUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
  self:InitUIInfo()
  EventManager:AddEvent(EventID.OnGuildBossStatsUpdate, self, self.OnGuildBossStatsUpdate)
end

function M:InitUIInfo()
  self.Time.Text_TimeTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_ScoreDesc:SetText(GText("UI_GuildBoss_ScoreDesc"))
  self.Text_Score:SetText("0")
  self.LastScore = 0
  self.Panel_Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.StartTimeCountDown = false
  self.WarningShown = false
  self:BindToAnimationFinished(self.Time_Low, {
    self,
    self.PlayWarningSound
  })
end

function M:UpdateRemainTime(GameRemainTime)
  if not self.StartTimeCountDown then
    self.Panel_Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.StartTimeCountDown = true
    self:PlayAnimation(self.Time_In)
  end
  local TimeDict = self:FormatRemainTimeText(GameRemainTime)
  self.Time:SetTimeText("", TimeDict)
  local GuildWarningTime = DataMgr.GlobalConstant.GuildBossWarningTime and DataMgr.GlobalConstant.GuildBossWarningTime.ConstantValue or 30
  if GameRemainTime <= GuildWarningTime and not self.WarningShown then
    UIManager(self):ShowUITip(UIConst.Tip_CommonWarning, GText("UI_GuildBoss_TimeExhausted"))
    self:PlayAnimation(self.Time_Low)
    AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning_short_reverb", nil, nil)
    self.WarningShown = true
  end
end

function M:PlayWarningSound()
  self:PlayAnimation(self.Time_Low)
  AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning_short_reverb", nil, nil)
end

function M:FormatRemainTimeText(RemainSeconds)
  local TimeDict = {}
  table.insert(TimeDict, {
    TimeType = "Min",
    TimeValue = math.floor(RemainSeconds % 3600 / 60)
  })
  table.insert(TimeDict, {
    TimeType = "Sec",
    TimeValue = RemainSeconds % 60
  })
  return TimeDict
end

function M:OnGuildBossStatsUpdate(Snapshot)
  if not Snapshot or not Snapshot.LiveScore then
    return
  end
  local CurScore = math.floor(tonumber(Snapshot.LiveScore) or 0)
  self.Text_Score:SetText(tostring(CurScore))
  if self.LastScore ~= nil and CurScore > self.LastScore then
    AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_score_add", nil, nil)
  end
  self.LastScore = CurScore
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnGuildBossStatsUpdate, self)
  self:UnbindAllFromAnimationFinished(self.Time_Low)
end

return M
