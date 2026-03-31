require("UnLua")
local WBP_SoloTreasure_HudScore_C = Class({
  "BluePrints.UI.BP_UIState_C"
})

function WBP_SoloTreasure_HudScore_C:Destruct()
  self:UnbindAllFromAnimationFinished(self.Score_Add)
  EventManager:RemoveEvent(EventID.OnUpdateGameScore, self)
  self:StopListeningForInputAction("OpenSoloTreasaureBagOnGamepad1", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("OpenSoloTreasaureBagOnGamepad1", EInputEvent.IE_Released)
  self:StopListeningForInputAction("OpenSoloTreasaureBagOnGamepad2", EInputEvent.IE_Pressed)
  EventManager:RemoveEvent(EventID.OnRepAbyssBattleCount, self)
end

function WBP_SoloTreasure_HudScore_C:InitWidgetUI(IsFromLottery)
  self:InitDungeoObject()
  self:InitData()
  self:InitText()
  self:InitBtn()
  EventManager:AddEvent(EventID.OnUpdateGameScore, self, self.OnUpdateGameScore)
  if nil == IsFromLottery then
    self:ListenForInputAction("OpenSoloTreasaureBagOnGamepad1", EInputEvent.IE_Pressed, false, {
      self,
      self.PrePressOpenBagOnGamepad
    })
    self:ListenForInputAction("OpenSoloTreasaureBagOnGamepad1", EInputEvent.IE_Released, false, {
      self,
      self.ReleasedOpenBagOnGamepad
    })
    self:ListenForInputAction("OpenSoloTreasaureBagOnGamepad2", EInputEvent.IE_Pressed, false, {
      self,
      self.CheckOpenBagOnGamepad
    })
    self:ListenForInputAction("OpenBag", EInputEvent.IE_Pressed, false, {
      self,
      self.OpenBag
    })
    EventManager:AddEvent(EventID.OnChangeKeyBoardSet, self, self.InitBtn)
    self:CloseBattleMainOpenBagListen()
  else
    self.Btn_Bag:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:BindToAnimationFinished(self.Score_Add, {
    self,
    self.ResetAddScore
  })
end

function WBP_SoloTreasure_HudScore_C:InitDungeoObject()
  self.ServerEntity = GWorld:GetServerEntity()
  if not self.ServerEntity then
    return
  end
  self.DungeonObject = self.ServerEntity:GetDungeonObject()
  if not self.DungeonObject then
    return
  end
end

function WBP_SoloTreasure_HudScore_C:CloseBattleMainOpenBagListen()
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if BattleMain then
    BattleMain:CloseOpenBagListening()
  end
end

function WBP_SoloTreasure_HudScore_C:InitData()
  self.CurGameScore = self.DungeonObject and self.DungeonObject.KillMonsterScore or 0
  self.TargetScore = self.DungeonObject and self.DungeonObject.KillMonsterScore or 0
  self.AddGameScore = 0
  self.UpdateGameScoreTotalTime = 0.5
  self.IntervalTime = 0.01
end

function WBP_SoloTreasure_HudScore_C:InitText()
  self.Text_AllNum:SetText(self.CurGameScore)
end

function WBP_SoloTreasure_HudScore_C:InitBtn()
  local ClassPath = UE4.LoadClass("/Game/UI/WBP/Battle/Widget/WBP_Main_Btnlist_Content.WBP_Main_Btnlist_Content_C")
  local Content = NewObject(ClassPath)
  Content.BtnId = 2
  self.Btn_Bag.CurContent = Content
  self.Btn_Bag:LoadImage()
  self.Btn_Bag:RebindClickEvent(self, self.OpenBag)
end

function WBP_SoloTreasure_HudScore_C:PrePressOpenBagOnGamepad()
  self.IsPressed = true
  self.Btn_Bag:ShowSystemEntranceOnGamePadInput(true)
end

function WBP_SoloTreasure_HudScore_C:ReleasedOpenBagOnGamepad()
  self.IsPressed = false
  self.Btn_Bag:ShowSystemEntranceOnGamePadInput()
end

function WBP_SoloTreasure_HudScore_C:PlayOutAnimation()
  self:PlayAnimation(self.Out)
end

function WBP_SoloTreasure_HudScore_C:PlayInAnimation()
  self:PlayAnimation(self.In)
end

function WBP_SoloTreasure_HudScore_C:CheckOpenBagOnGamepad()
  if self.IsPressed then
    self:OpenBag()
  end
end

function WBP_SoloTreasure_HudScore_C:OpenBag()
  UIManager(self):LoadUINew("SoloTreasureBag", function(LoadedWidget)
    DebugPrint("lgc@WBP_SoloTreasure_HudScore_C SoloTreasureBag AsyncLoaded")
  end, "Async")
end

function WBP_SoloTreasure_HudScore_C:ResetAddScore()
  self.AddGameScore = 0
end

function WBP_SoloTreasure_HudScore_C:OnUpdateGameScore(Score, TargetScore)
  self.AddGameScore = self.AddGameScore + Score
  local AddGameScoreText = ""
  if self.AddGameScore > 0 then
    AddGameScoreText = string.format("+%d", self.AddGameScore)
  else
    AddGameScoreText = string.format("%d", self.AddGameScore)
  end
  self.Text_AddNum:SetText(AddGameScoreText)
  self.TargetScore = TargetScore
  if not self:IsPlayingAnimation(self.Score_Add) and self.AddGameScore > 0 then
    self:PlayAnimation(self.Score_Add)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_right_top_score_add", nil, nil)
  end
  self:SetGameScoreWithScrollAnimation()
end

function WBP_SoloTreasure_HudScore_C:SetGameScoreWithScrollAnimation()
  local StepsPerCycle = self.UpdateGameScoreTotalTime / self.IntervalTime
  if self:IsExistTimer("UpdateGameScore") then
    local remain = self.TargetScore - self.CurGameScore
    if 0 ~= remain then
      self.AddScorePerTime = remain / StepsPerCycle
    end
    return
  end
  if self.TargetScore - self.CurGameScore > 0 then
    AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_right_top_score_num_change_loop", "AddScore", nil)
  end
  local IsDone = false
  self.AddScorePerTime = (self.TargetScore - self.CurGameScore) / StepsPerCycle
  self:AddTimer(self.IntervalTime, function()
    if IsDone then
      self.AddGameScore = 0
      self:RemoveTimer("UpdateGameScore")
      return
    end
    self.CurGameScore = self.CurGameScore + self.AddScorePerTime
    if self.AddScorePerTime < 0 then
      self.CurGameScore = math.max(self.CurGameScore, self.TargetScore)
    else
      self.CurGameScore = math.min(self.CurGameScore, self.TargetScore)
    end
    if self.CurGameScore == self.TargetScore then
      IsDone = true
      AudioManager(self):StopSound(self, "AddScore")
    end
    self.Text_AllNum:SetText(Utils.FormatNumber(self.CurGameScore, false))
  end, true, 1, "UpdateGameScore", true)
end

return WBP_SoloTreasure_HudScore_C
