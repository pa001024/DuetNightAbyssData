require("UnLua")
local WBP_SoloTreasure_HudScore_C = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function WBP_SoloTreasure_HudScore_C:Destruct()
  self:UnbindAllFromAnimationFinished(self.Score_Add)
  EventManager:RemoveEvent(EventID.OnUpdateGameScore, self)
end

function WBP_SoloTreasure_HudScore_C:InitWidgetUI()
  self:InitData()
  self:InitText()
  self:InitBtn()
  EventManager:AddEvent(EventID.OnUpdateGameScore, self, self.OnUpdateGameScore)
  self:BindToAnimationFinished(self.Score_Add, {
    self,
    self.SetDungeonScore
  })
end

function WBP_SoloTreasure_HudScore_C:InitData()
  self.CurGameScore = 0
  self.AddGameScore = 0
  self.UpdateGameScoreTotalTime = 0.5
  self.IntervalTime = 0.01
end

function WBP_SoloTreasure_HudScore_C:InitText()
  self.Text_AllNum:SetText(0)
end

function WBP_SoloTreasure_HudScore_C:InitBtn()
end

function WBP_SoloTreasure_HudScore_C:SetDungeonScore()
  self:SetGameScoreWithScrollAnimation()
end

function WBP_SoloTreasure_HudScore_C:OnUpdateGameScore(Score)
  self.AddGameScore = Score
  local AddGameScoreText = string.format("+%d", self.AddGameScore)
  self.Text_AddNum:SetText(AddGameScoreText)
  self:PlayAnimation(self.Score_Add)
end

function WBP_SoloTreasure_HudScore_C:SetGameScoreWithScrollAnimation()
  local TargetScore = self.CurGameScore + self.AddGameScore
  local IsDone = false
  local AddScorePerTime = self.AddGameScore / (self.UpdateGameScoreTotalTime / self.IntervalTime)
  self:AddTimer(self.IntervalTime, function()
    if IsDone then
      self:RemoveTimer("UpdateGameScore")
      return
    end
    self.CurGameScore = self.CurGameScore + AddScorePerTime
    self.CurGameScore = math.min(self.CurGameScore, TargetScore)
    if self.CurGameScore == TargetScore then
      IsDone = true
    end
    self.Text_AllNum:SetText(Utils.FormatNumber(self.CurGameScore, false))
  end, true, 0, "UpdateGameScore", true)
end

return WBP_SoloTreasure_HudScore_C
