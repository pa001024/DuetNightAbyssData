require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.RegionId = nil
  self:InitUI()
end

function M:InitUI()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.RegionId = Avatar:GetCurrentRegionId()
  self.Text_Title:SetText(GText("TheaterOnline_Game_Name"))
  self.Text_Progress:SetText(GText("TheaterOnline_Game_Waiting"))
  local CurrentTime = TimeUtils.NowTime()
  local RemainTime = self:CalculateRemainTimeToNextHour()
  local TargetTime = CurrentTime + RemainTime
  local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(TargetTime)
  self.WBP_Com_Time:SetTimeText("", RemainTimeDict)
  self:StartCountdownTimer()
end

function M:CalculateRemainTimeToNextHour()
  local CurrentTime = TimeUtils.NowTime()
  local CurrentDateTime = os.date("*t", CurrentTime)
  local CurrentMinutes = CurrentDateTime.min
  local CurrentSeconds = CurrentDateTime.sec
  local CurrentTotalSeconds = CurrentMinutes * 60 + CurrentSeconds
  local NextTargetSeconds
  if CurrentTotalSeconds <= 1800 then
    NextTargetSeconds = 1800
  else
    NextTargetSeconds = 3600
  end
  return NextTargetSeconds - CurrentTotalSeconds
end

function M:StartCountdownTimer()
  if self.CountdownTimer then
    self:RemoveTimer(self.CountdownTimer)
  end
  self.CountdownTimer = self:AddTimer(1.0, function()
    self:UpdateCountdown()
  end, true, 0, "TheaterCountdown", true)
end

function M:UpdateCountdown()
  local CurrentTime = TimeUtils.NowTime()
  local RemainTime = self:CalculateRemainTimeToNextHour()
  if RemainTime <= 0 then
    if self.CountdownTimer then
      self:RemoveTimer(self.CountdownTimer)
      self.CountdownTimer = nil
    end
    self:Close()
  else
    local TargetTime = CurrentTime + RemainTime
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(TargetTime)
    self.WBP_Com_Time:SetTimeText("", RemainTimeDict)
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local RegionId = Avatar.CurrentRegionId
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if not GameState:IsInRegion() or 101901 ~= RegionId then
    DebugPrint("ayff 离开剧院区域，关闭剧院活动倒计时 regionid:", RegionId)
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:Close()
  if self.CountdownTimer then
    self:RemoveTimer(self.CountdownTimer)
    self.CountdownTimer = nil
  end
  self.Super.Close(self)
end

return M
