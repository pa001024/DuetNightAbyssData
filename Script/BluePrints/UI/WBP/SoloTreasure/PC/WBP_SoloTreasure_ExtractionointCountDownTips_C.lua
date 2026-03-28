require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnLoaded(...)
  self:InitUI()
end

function M:InitUI()
  self:InitData()
  self:PlayAnimation(self.In)
end

function M:InitData()
  self.EvacuationTime = DataMgr.SoloTreasure.EvacuationTime or 10
  self.Text_Task:SetText(self.EvacuationTime)
  self.Text_Task02:SetText(GText("UI_Extraction_TM_23"))
end

function M:SetCountDownTime(Time, IsPlayAnimation)
  self.Text_Task:SetText(Time)
  if IsPlayAnimation then
    self:PlayAnimation(self.Num_Refresh)
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_one_more_count_down", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_countdown", nil, nil)
  end
end

function M:CloseUI()
  self:RemoveTimer("EvacuationTime")
  self:Close()
end

return M
