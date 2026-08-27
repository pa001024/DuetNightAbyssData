require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UIComponent.TouchComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:InitWithBattleMain(BattleMain)
  self.BattleMain = BattleMain
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self.TrackExit:InitWithTrackHUD(self)
  self.TrackTurn:InitWithTrackHUD(self)
  self.Jump:InitWithTrackHUD(self)
  self.Slide:InitWithTrackHUD(self)
  self.AtkMelee:InitWithTrackHUD(self)
  self.TrackSwitch_L:InitWithTrackHUD(self)
  self.TrackSwitch_R:InitWithTrackHUD(self)
  self:InitTouchLayer(self.OwnerPlayer, 0, 0)
  self:InitTouchListenEvent()
  self:InitTrackTouchItems()
end

function M:InitTrackTouchItems()
  if self.IsInitTrackTouch then
    return
  end
  self.IsInitTrackTouch = true
  self:AddStaticSubTouchItem("MeleeAttack", self.AtkMelee.Joystick, {
    Down = self.AtkMelee.ButtonAtkMeleeDown,
    Move = self.AtkMelee.ButtonAtkMeleeMove,
    Up = self.AtkMelee.ButtonAtkMeleeUp
  }, self.AtkMelee)
end

function M:TryToPlayTargetCommand(KeyName, IsAddInputCache)
  local CharSkill = self.BattleMain and self.BattleMain.Char_Skill
  if not IsValid(CharSkill) then
    return
  end
  CharSkill:TryToPlayTargetCommand(KeyName, IsAddInputCache)
end

function M:TryToStopTargetCommand(KeyName, IsClearInputCache)
  local CharSkill = self.BattleMain and self.BattleMain.Char_Skill
  if not IsValid(CharSkill) then
    return
  end
  CharSkill:TryToStopTargetCommand(KeyName, IsClearInputCache)
end

local TRACK_BTNS = {
  "AtkMelee",
  "Jump",
  "Slide",
  "TrackSwitch_L",
  "TrackSwitch_R",
  "TrackTurn",
  "TrackExit"
}

function M:OnEnterSlideMech(Player, SlideMechEid, Reason)
  self.OwnerPlayer = Player
  self.TrackExit:SetOwnerPlayer(Player)
  for _, btnName in ipairs(TRACK_BTNS) do
    local btn = self[btnName]
    if IsValid(btn) and type(btn.SetOwnerPlayer) == "function" then
      btn:SetOwnerPlayer(Player)
    end
  end
  self.BattleMain.Char_Skill:SetLeftAutoBtnVisibility(UE4.ESlateVisibility.Collapsed)
  self:StartRailForbiddenTimer()
end

function M:OnLeaveSlideMech(Player, SlideMechEid, Reason)
  self.AtkMelee.bRailAttackPending = false
  self.BattleMain.Char_Skill:RefreshLeftAutoBtnPrologueUnlockState()
  self:StopRailForbiddenTimer()
end

function M:StartRailForbiddenTimer()
  if self.RailForbiddenTimer then
    return
  end
  if not self.AddTimer then
    return
  end
  self.RailForbiddenTimer = self:AddTimer(0.1, self.UpdateAllRailForbiddenStates, true)
end

function M:StopRailForbiddenTimer()
  if not self.RailForbiddenTimer then
    return
  end
  self:RemoveTimer(self.RailForbiddenTimer)
  self.RailForbiddenTimer = nil
  for _, btnName in ipairs(TRACK_BTNS) do
    local btn = self[btnName]
    if IsValid(btn) and btn.bIsForbidden then
      btn.bIsForbidden = false
      if btn.Normal then
        EMUIAnimationSubsystem:EMPlayAnimation(btn, btn.Normal)
      end
    end
  end
end

function M:UpdateAllRailForbiddenStates()
  for _, btnName in ipairs(TRACK_BTNS) do
    local btn = self[btnName]
    if IsValid(btn) and type(btn.UpdateForbiddenState) == "function" then
      btn:UpdateForbiddenState()
    end
  end
end

function M:SetDodgeGuideVisible(bShowLeft, bShowRight)
  if bShowLeft or bShowRight then
    self.TrackToastMessageId = 0
    UIManager(self):ShowUITip(UIConst.Tip_CommonWarning, GText("UI_Track_Toast01"), -1, false, self.TrackToastMessageId)
  else
    UIManager(self):HideWarningUITip(self.TrackToastMessageId)
  end
  if bShowLeft and IsValid(self.TrackSwitch_L) then
    self.TrackSwitch_L:StartGuide()
  elseif IsValid(self.TrackSwitch_L) then
    self.TrackSwitch_L:StopGuide()
  end
  if bShowRight and IsValid(self.TrackSwitch_R) then
    self.TrackSwitch_R:StartGuide()
  elseif IsValid(self.TrackSwitch_R) then
    self.TrackSwitch_R:StopGuide()
  end
end

function M:Destruct()
  self:RemoveTouchListenEvent()
end

AssembleComponents(M)
return M
