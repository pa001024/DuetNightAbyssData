local Guide_Text_CountDown_PC = Class("BluePrints.UI.UI_PC.Guide.Guide_TipsAsyncActionUIBase")

function Guide_Text_CountDown_PC:OnLoaded(...)
  Guide_Text_CountDown_PC.Super.OnLoaded(self, ...)
end

function Guide_Text_CountDown_PC:InitializeData(Duration)
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI then
    BattleMainUI.Pos_CountDown:AddChild(self)
    BattleMainUI.Pos_CountDown:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
  end
  if not self:OnTipBegin(Duration, self.OnCountDownEnd, self.In, self.Out) then
    self:OnClose()
    return
  end
  if self.TimerHandle then
    self:RemoveTimer("GuideTextCountDownTick", false)
    self.TimerHandle = nil
  end
  self.TimerHandle = self:AddTimer(1, self.Tick, true, 0, "GuideTextCountDownTick", false)
  self.CountDownTime = math.floor(Duration - 1)
  self.Guide_Text_CountDown_PC.Text_CountDown:SetText(string.format("%d", self.CountDownTime))
  AudioManager(self):PlayUISound(self, "event:/ui/common/battle_countdown", nil, nil)
end

function Guide_Text_CountDown_PC:Tick()
  local LastTime = self.CountDownTime
  self.CountDownTime = math.floor(self.CountDownTime - 1)
  local NumberChange = LastTime - self.CountDownTime > 1.0E-4
  self.Guide_Text_CountDown_PC.Text_CountDown:SetText(string.format("%d", self.CountDownTime))
  self.Guide_Text_CountDown_PC.FX_Text_CountDown_1:SetText(string.format("%d", self.CountDownTime))
  if NumberChange then
    self.Guide_Text_CountDown_PC:PlayAnimation(self.Guide_Text_CountDown_PC.RefreshCountDown)
  end
  if 0 == self.CountDownTime then
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_countdown_end", nil, nil)
  elseif self.CountDownTime > 0 then
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_countdown", nil, nil)
  end
end

function Guide_Text_CountDown_PC:OnCountDownEnd()
  self:RemoveTimer("GuideTextCountDownTick", false)
  self.TimerHandle = nil
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI then
    BattleMainUI.Pos_CountDown:RemoveChild(self)
  end
end

function Guide_Text_CountDown_PC:OnClose()
  self:OnTipRealEnd()
end

function Guide_Text_CountDown_PC:InitCommonCountDown(Duration, bShowZeroText, CountDownSound, LastCountDownSound)
  if self.InCountDown then
    self:OnClose()
    return
  end
  self.CountDownSound = CountDownSound or "event:/ui/common/battle_countdown"
  self.LastCountDownSound = LastCountDownSound or "event:/ui/common/battle_countdown_end"
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI then
    BattleMainUI.Pos_CountDown:AddChild(self)
    BattleMainUI.Pos_CountDown:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if self.TempleTimerHandle then
    self:RemoveTimer("GuideTextCountDownTick", false)
    self.TempleTimerHandle = nil
  end
  self.InCountDown = true
  self.ShowZeroText = bShowZeroText
  self.IsTempleCountDownEnd = false
  self:AddTimer(Duration, self.OnTempleGuideCountDownEnd, false, 0, "TempleGuideCountDown", false)
  if nil ~= self.Guide_Text_CountDown_PC.In then
    self.Guide_Text_CountDown_PC:PlayAnimation(self.Guide_Text_CountDown_PC.In)
  end
  self.TempleTimerHandle = self:AddTimer(1, self.CommonTick, true, 0, "GuideTextCountDownTick", false)
  self.CountDownTime = math.floor(Duration - 1)
  self.Guide_Text_CountDown_PC.Text_CountDown:SetText(string.format("%d", self.CountDownTime))
  AudioManager(self):PlayUISound(self, self.CountDownSound, nil, nil)
end

function Guide_Text_CountDown_PC:CommonTick()
  self.CountDownTime = math.floor(self.CountDownTime - 1)
  if self.CountDownTime < 0 then
    self:OnTempleGuideCountDownEnd()
    return
  end
  self.Guide_Text_CountDown_PC.Text_CountDown:SetText(string.format("%d", self.CountDownTime))
  if 0 == self.CountDownTime then
    AudioManager(self):PlayUISound(self, self.LastCountDownSound, nil, nil)
    if self.ShowZeroText == false then
      self.Guide_Text_CountDown_PC.Text_CountDown:SetText(GText("UI_Temple_Countdown_Go"))
    end
  elseif self.CountDownTime > 0 then
    AudioManager(self):PlayUISound(self, self.CountDownSound, nil, nil)
  end
end

function Guide_Text_CountDown_PC:InitTempleCountDown(Duration, bShowZeroText)
  if self.InCountDown then
    self:OnClose()
    return
  end
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI then
    BattleMainUI.Pos_CountDown:AddChild(self)
    BattleMainUI.Pos_CountDown:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.TempleTimerHandle then
    self:RemoveTimer("GuideTextCountDownTick", false)
    self.TempleTimerHandle = nil
  end
  self.InCountDown = true
  self.ShowZeroText = bShowZeroText
  self.IsTempleCountDownEnd = false
  self:AddTimer(Duration, self.OnTempleGuideCountDownEnd, false, 0, "TempleGuideCountDown", false)
  if nil ~= self.Guide_Text_CountDown_PC.In then
    self.Guide_Text_CountDown_PC:PlayAnimation(self.Guide_Text_CountDown_PC.In)
  end
  self.TempleTimerHandle = self:AddTimer(1, self.TempleTick, true, 0, "GuideTextCountDownTick", false)
  self.CountDownTime = math.floor(Duration - 1)
  self.Guide_Text_CountDown_PC.Text_CountDown:SetText(string.format("%d", self.CountDownTime))
  AudioManager(self):PlayUISound(self, "event:/ui/common/count_down_multi_player_challenge", nil, nil)
end

function Guide_Text_CountDown_PC:StartPetRaceCountDown(Duration, bShowZeroText)
  if self.InCountDown then
    self:OnClose()
    return
  end
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI then
    BattleMainUI.Pos_CountDown:AddChild(self)
    BattleMainUI.Pos_CountDown:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.PetRaceTimerHandle then
    self:RemoveTimer("GuideTextCountDownTick", false)
    self.PetRaceTimerHandle = nil
  end
  self.InCountDown = true
  self.ShowZeroText = bShowZeroText
  self.IsPetRaceCountDownEnd = false
  self:AddTimer(Duration, self.OnPetRaceCountDownEnd, false, 0, "PetRaceGuideCountDown", false)
  if nil ~= self.Guide_Text_CountDown_PC.In then
    self.Guide_Text_CountDown_PC:PlayAnimation(self.Guide_Text_CountDown_PC.In)
  end
  self.PetRaceTimerHandle = self:AddTimer(1, self.PetRaceTick, true, 0, "GuideTextCountDownTick", false)
  self.CountDownTime = math.floor(Duration - 1)
  self.Guide_Text_CountDown_PC.Text_CountDown:SetText(string.format("%d", self.CountDownTime))
  AudioManager(self):PlayUISound(self, "event:/ui/common/count_down_multi_player_challenge", nil, nil)
end

function Guide_Text_CountDown_PC:InitStartPetRaceCountDown(Duration, bShowZeroText, RaceId)
  if self.HideUITable == nil then
    self.HideUITable = {
      Pos_Entry = 1,
      Pos_Drops = 1,
      Pos_SpecialDrops = 1,
      Pos_NewMonster = 1,
      Battle_Map = 1,
      Btn_Esc = 1,
      Btn_GuideBook = 1,
      Group_ChatEntry = 1,
      Buff = 1,
      Char_Skill = 1,
      Team = 1,
      Chat_Entry = 1,
      HBox = 1,
      SizeBox_Map = 1,
      Btn_Task = 1,
      Pos_TaskBar = 1,
      Pos_Aim = 1,
      LeftAutoBtnPos = 1,
      HUD_Bar = 1
    }
  end
  local CountDown = Duration or 4
  self.RaceId = RaceId
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local Spline = GameState.PetRaceSplineMaps:FindRef(self.RaceId)
  if Spline then
    Spline:PlayCountDownSequence()
  end
  self.TimerHandle = GWorld.GameInstance:AddTimer(CountDown, function()
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    if BattleMain then
      BattleMain:PetRaceHideOrShowBattleUI(false, self.HideUITable)
    end
    if IsValid(Player) then
      Player:RemoveDisableInputTag("PetRace")
      Player:SetCanInteractiveTrigger(true, "PetRace")
      Player:SetESCMenuForbiddenState(false)
    end
    if Spline then
      Spline:StartRaceLottery()
      Spline.GameLogicComponent:ShowPetRaceInGame(self.RaceId)
      local AudioManager = AudioManager(self)
      local Event = AudioManager:GetFMODEventByPath_Sync("event:/bgm/1_0/0090_system_shooting")
      AudioManager:PlayWorldChallengeSound(Event, nil, 0, true)
    end
  end, false, 0, "PetRaceStartCountDown")
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if BattleMain then
    BattleMain:Show("PetRace")
    BattleMain:PetRaceHideOrShowBattleUI(true, self.HideUITable)
  end
  self:StartPetRaceCountDown(CountDown, bShowZeroText)
end

function Guide_Text_CountDown_PC:PetRaceTick()
  self.CountDownTime = math.floor(self.CountDownTime - 1)
  if self.CountDownTime < 0 then
    self:OnPetRaceCountDownEnd()
    return
  end
  self.Guide_Text_CountDown_PC.Text_CountDown:SetText(string.format("%d", self.CountDownTime))
  if 0 == self.CountDownTime then
    AudioManager(self):PlayUISound(self, "event:/ui/common/count_down_multi_player_challenge_last_count", nil, nil)
    if self.ShowZeroText == false then
      self.Guide_Text_CountDown_PC.Text_CountDown:SetText(GText("UI_Temple_Countdown_Go"))
    end
  elseif self.CountDownTime > 0 then
    AudioManager(self):PlayUISound(self, "event:/ui/common/count_down_multi_player_challenge", nil, nil)
  end
end

function Guide_Text_CountDown_PC:OnPetRaceCountDownEnd()
  if self.IsPetRaceCountDownEnd then
    return
  end
  self.IsPetRaceCountDownEnd = true
  self:OnPetRaceCountDownRealEnd()
  if self.Guide_Text_CountDown_PC.Out then
    self.Guide_Text_CountDown_PC:PlayAnimation(self.Guide_Text_CountDown_PC.Out)
  end
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI then
    BattleMainUI.Pos_CountDown:RemoveChild(self)
  end
end

function Guide_Text_CountDown_PC:OnPetRaceCountDownRealEnd()
  self.InCountDown = false
  self:RemoveTimer("GuideTextCountDownTick", false)
  self:RemoveTimer("PetRaceGuideCountDown", false)
  self.PetRaceTimerHandle = nil
end

function Guide_Text_CountDown_PC:TempleTick()
  self.CountDownTime = math.floor(self.CountDownTime - 1)
  if self.CountDownTime < 0 then
    self:OnTempleGuideCountDownEnd()
    return
  end
  self.Guide_Text_CountDown_PC.Text_CountDown:SetText(string.format("%d", self.CountDownTime))
  if 0 == self.CountDownTime then
    AudioManager(self):PlayUISound(self, "event:/ui/common/count_down_multi_player_challenge_last_count", nil, nil)
    if self.ShowZeroText == false then
      self.Guide_Text_CountDown_PC.Text_CountDown:SetText(GText("UI_Temple_Countdown_Go"))
    end
  elseif self.CountDownTime > 0 then
    AudioManager(self):PlayUISound(self, "event:/ui/common/count_down_multi_player_challenge", nil, nil)
  end
end

function Guide_Text_CountDown_PC:OnTempleGuideCountDownEnd()
  if self.IsTempleCountDownEnd then
    return
  end
  self.IsTempleCountDownEnd = true
  self:OnTempleCountDownRealEnd()
  if self.Guide_Text_CountDown_PC.Out then
    self.Guide_Text_CountDown_PC:PlayAnimation(self.Guide_Text_CountDown_PC.Out)
  end
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI then
    BattleMainUI.Pos_CountDown:RemoveChild(self)
  end
end

function Guide_Text_CountDown_PC:OnTempleCountDownRealEnd()
  self.InCountDown = false
  self:RemoveTimer("GuideTextCountDownTick", false)
  self:RemoveTimer("TempleGuideCountDown", false)
  self.TempleTimerHandle = nil
end

return Guide_Text_CountDown_PC
