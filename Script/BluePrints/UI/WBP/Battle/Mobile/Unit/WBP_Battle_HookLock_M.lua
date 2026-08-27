require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local HOOK_HINT_SOUND_PATH = "event:/sfx/common/player/action/commnon_gousuo_hint"
local HOOK_HINT_SOUND_KEY = "GousuoHint"

function M:Init(Hook)
  self:InitButtonOnce()
  if self.InteractionType ~= "Hook" then
    self.Hook = nil
    self.HookComp = nil
    self.Player = nil
  end
  self.InteractionType = "Hook"
  self.SlideSpline = nil
  self:SetInteractionIcon(self.Icon_Hook)
  self.bAnimEnd = true
  self:Open(Hook)
end

function M:InitSlideSpline(SlideSpline, Player)
  self:InitButtonOnce()
  local ShouldPlayHintSound = self.InteractionType ~= "SlideSpline" or self.SlideSpline ~= SlideSpline
  self.InteractionType = "SlideSpline"
  self.SlideSpline = SlideSpline
  self.Hook = nil
  self.HookComp = nil
  self.Player = Player
  self:SetInteractionIcon(self.Icon_Track)
  self.bAnimEnd = true
  self:Open(SlideSpline)
  if ShouldPlayHintSound and IsValid(Player) and Player:IsMainPlayer() then
    AudioManager(self):PlayNormalSound(Player, nil, HOOK_HINT_SOUND_PATH, HOOK_HINT_SOUND_KEY, false)
  end
end

function M:InitButtonOnce()
  if self.bInit then
    return
  end
  self.Button_Area.OnClicked:Add(self, self.OnClickButton)
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      self.bAnimEnd = true
      self:SetVisibility(ESlateVisibility.Collapsed)
    end
  })
  self.bInit = true
end

function M:SetInteractionIcon(IconBrush)
  if IsValid(self.Icon_HookLock) then
    self.Icon_HookLock:SetBrush(IconBrush)
  end
end

function M:OnClickButton()
  if self.InteractionType == "SlideSpline" then
    local Player = self.Player
    if IsValid(Player) and type(Player.TryEnterSlideMech) == "function" then
      local WasEnteringSlideMech = Player.IsFlyingToSlideMech == true or true == Player.IsInSlideMech
      Player:TryEnterSlideMech()
      local IsEnteringSlideMech = IsValid(Player) and (Player.IsFlyingToSlideMech == true or true == Player.IsInSlideMech)
      if not WasEnteringSlideMech and IsEnteringSlideMech and Player.NeedInteractiveEvent then
        EventManager:FireEvent(EventID.OnInteractivePressed)
      end
    end
    return
  end
  if not IsValid(self.HookComp) then
    return
  end
  self.HookComp:StartInteractive(self.Player)
end

function M:Open(Hook)
  if self.bOpen or not self.bAnimEnd then
    return
  end
  if self:IsAnimationPlaying(self.Out) then
    self:StopAnimation(self.Out)
  end
  self.bOpen = true
  self:SetVisibility(ESlateVisibility.Visible)
  self:PlayAnimation(self.In)
end

function M:Close(Owner)
  if not self.bOpen then
    return
  end
  if IsValid(Owner) and Owner ~= self.Hook and Owner ~= self.SlideSpline then
    return
  end
  self.bAnimEnd = false
  self:PlayAnimation(self.Out)
  self.Hook = nil
  self.SlideSpline = nil
  self.HookComp = nil
  self.Player = nil
  self.InteractionType = nil
  self.bOpen = false
end

function M:UpdateOwner(Hook, HookComp, PlayerActor)
  self.InteractionType = "Hook"
  self.Hook = Hook
  self.SlideSpline = nil
  self.HookComp = HookComp
  self.Player = PlayerActor
end

return M
