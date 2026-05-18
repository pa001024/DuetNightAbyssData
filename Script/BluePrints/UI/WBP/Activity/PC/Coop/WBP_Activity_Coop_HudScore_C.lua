require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMDungeonWidget_C"
})

function M:Initialize()
  self.EndTime = nil
  self.Progress = 0
  self.Owner = nil
  self.HasShownToast = nil
end

function M:Construct()
  self.Text_Score_Now:SetText("00")
end

function M:SetupCountDown(EndTime)
  self.EndTime = EndTime
  self:AddTimer(1, self.UpdateCountDown, true, 0, "HUDScoreCountDown")
end

function M:UpdateCountDown()
  local RemainTimeStr = UIUtils.GetLeftTimeStrStyle1(self.EndTime)
  if "TimeOut" == RemainTimeStr then
    RemainTimeStr = "0秒"
  end
  self.WBP_Com_Time.Text_TimeTitle:SetText(RemainTimeStr)
  local NowTime = TimeUtils.NowTime()
  local RemainingTime = self.EndTime - NowTime
  if RemainingTime < 60 and not self.HasShownToast then
    self:PlayAnimation(self.Loop, 0, 0)
    local SuccessToast = UIManager(self):GetUIObj("ExploreToastSuccess")
    if SuccessToast then
      SuccessToast:Close()
    end
    UIManager(self):LoadUINew("ExploreToastFail", "UI_AsyncCombat_RoomEndingSoon")
    self.HasShownToast = true
  end
  if RemainingTime <= 0 then
    self:CleanTimer()
  end
end

return M
