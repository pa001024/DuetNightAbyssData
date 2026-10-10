require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Initialize(Initializer)
  self.EventId = nil
  self.ProgressMat = nil
end

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
  self.EventId = ActivityConfigData and ActivityConfigData.EventId
  self:RefreshRemainTimes(PlayerAvatar)
end

function M:RefreshRemainTimes(PlayerAvatar)
  local EventId = self.EventId
  local MainCfg = EventId and DataMgr.HardBossEventMain and DataMgr.HardBossEventMain[EventId]
  if not MainCfg then
    return
  end
  local TotalTimes = math.floor(MainCfg.PeriodRewardTime or 0)
  local RemainTimes = 0
  local Avatar = PlayerAvatar or GWorld:GetAvatar()
  if Avatar and Avatar.HardBossEvent then
    RemainTimes = Avatar.HardBossEvent.RewardTimesLeft or 0
  end
  local TitleText = GText("UI_HardBoss_ChancesRemain")
  if self.Text_Times then
    self.Text_Times:SetText(TitleText)
  end
  if self.Text_Now then
    self.Text_Now:SetText(tostring(RemainTimes))
  end
  if self.Text_Total then
    self.Text_Total:SetText(tostring(TotalTimes))
  end
  self:RefreshProgress(RemainTimes, TotalTimes)
  local bNoTimes = RemainTimes <= 0
  local BgRed = self.BG_Red
  if not IsValid(BgRed) and self.GetWidgetFromName then
    BgRed = self:GetWidgetFromName("BG_Red")
  end
  if IsValid(BgRed) then
    BgRed:SetVisibility(bNoTimes and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshProgress(RemainTimes, TotalTimes)
  local ProgressImage = self.Progress
  if not IsValid(ProgressImage) or not ProgressImage.GetDynamicMaterial then
    return
  end
  if not self.ProgressMat then
    self.ProgressMat = ProgressImage:GetDynamicMaterial()
  end
  if not self.ProgressMat then
    return
  end
  local Total = math.floor(TotalTimes or 0)
  local Percent = 0
  if Total > 0 then
    Percent = math.max(0, math.min((RemainTimes or 0) / Total, 1))
  end
  self.ProgressMat:SetScalarParameterValue("Percent", Percent)
end

function M:Destruct()
  self.EventId = nil
  self.ProgressMat = nil
end

return M
