require("UnLua")
local Settlement_BlackScreen_PC_C = Class("BluePrints.UI.BP_UIState_C")

function Settlement_BlackScreen_PC_C:OnLoaded(...)
  self.bIsFocusable = true
  self.OnInAnimFinished = nil
  self.OnOutAnimFinished = nil
  local bShowFade, Callback, bIsWin = ...
  self:BindToAnimationFinished(self.In, function()
    if self.OnInAnimFinished then
      self.OnInAnimFinished()
    end
  end)
  self:BindToAnimationFinished(self.Out, function()
    AudioManager(self):StopSound(self, "SettlementBlackScreen")
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:HideAllUI(false, Const.BlackScreenHideTag)
    if self.OnOutAnimFinished then
      self.OnOutAnimFinished()
    end
    self:Close()
  end)
  if bShowFade then
    self:FadeIn(Callback, bIsWin)
  end
end

function Settlement_BlackScreen_PC_C:FadeIn(OnInAnimFinished, bIsWin)
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.OnInAnimFinished = OnInAnimFinished
  AudioManager(self):PlayUISound(self, "event:/snapshot/ui/filter_fade_ui_level_ending", "SettlementBlackScreen", {fade_in_time = 1.75})
  if bIsWin then
    AudioManager(self):PlayUISound(self, "event:/ui/common/level_end_success", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/level_end_fail", nil, nil)
  end
  local Avatar = GWorld:GetAvatar()
  local bSkipFadeIn = (not Avatar or not Avatar:IsInHardBoss()) and GWorld.GameInstance and GWorld.GameInstance:CheckInAutoChessDungeon()
  if bSkipFadeIn then
    self:PlayAnimation(self.In, self.In:GetEndTime())
  else
    self:PlayAnimation(self.In)
  end
end

function Settlement_BlackScreen_PC_C:FadeOut(OnOutAnimFinished, bSkipOutAnim)
  if bSkipOutAnim then
    OnOutAnimFinished()
  else
    AudioManager(self):PlayUISound(self, "event:/snapshot/ui/filter_fade_ui_level_ending", "SettlementBlackScreen", {fade_out_time = 1})
    AudioManager(self):SetEventSoundParam(self, "SettlementBlackScreen", {ToEnd = 1})
    self.OnOutAnimFinished = OnOutAnimFinished
    self:AddTimer(0.1, function()
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      UIManager:HideAllUI(true, Const.BlackScreenHideTag)
      self:Show(Const.BlackScreenHideTag)
    end)
    self:PlayAnimation(self.Out)
  end
end

return Settlement_BlackScreen_PC_C
