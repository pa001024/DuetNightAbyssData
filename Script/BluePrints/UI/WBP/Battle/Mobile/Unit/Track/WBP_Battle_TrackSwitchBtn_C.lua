require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.WBP.Battle.Mobile.Unit.Track.TrackBtnCommonComponent"
}

function M:Construct()
  self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
  self.bGuideActive = false
end

function M:StartGuide()
  self.bGuideActive = true
  self:PlayAnimation(self.Loop, 0, 0)
end

function M:StopGuide()
  if not self.bGuideActive then
    return
  end
  self.bGuideActive = false
  self:StopAnimation(self.Loop)
  self:PlayAnimation(self.Loop_End)
end

function M:IsGuideActive()
  return self.bGuideActive == true
end

function M:IsForbidden()
  if not self:IsOnRail() then
    return false
  end
  if not IsValid(self.OwnerPlayer) then
    return true
  end
  return self.OwnerPlayer.IsForbidSwitchSlideMech or self.OwnerPlayer.IsSwitchingSlideMech
end

function M:OnBtnPressed()
  if self:IsForbidden() then
    return
  end
  self:PlayAnimation(self.Press)
  if not self:IsOnRail() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  self.OwnerPlayer:SwitchSlideMech(self.bLeft and -1.0 or 1.0)
  if self.bGuideActive then
    self:StopGuide()
  end
end

function M:OnBtnReleased()
  if IsValid(self.OwnerPlayer) and self.OwnerPlayer.SwitchSlideMech then
    self.OwnerPlayer:SwitchSlideMech(0)
  end
  if self:IsForbidden() then
    return
  end
  self:PlayAnimation(self.Click)
end

AssembleComponents(M)
return M
