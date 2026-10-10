require("UnLua")
local Const = require("BluePrints.UI.Battle.ExclusiveSkill.Battle_SpliseConst")
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

function M:OnLoaded(OwnerPlayer)
  self.Super.OnLoaded(self)
  self.OwnerPlayer = OwnerPlayer
  self.bSpectrumClosing = false
  self.CurrentSpectrumOpacity = Const.Spectrum.ActiveOpacity
  self.CurrentSpectrumTextOpacity = Const.Spectrum.ActiveTextOpacity
  self:RemoveTimer("SpectrumOpacityFade")
  if self.Main then
    self.Main:SetRenderOpacity(self.CurrentSpectrumOpacity)
  end
  self:SetSpectrumTextOpacity(self.CurrentSpectrumTextOpacity)
end

function M:InitBattleCharUI(CharUIId, GradeLevel)
  self.Super.InitBattleCharUI(self, CharUIId, GradeLevel)
  self:UnRegisterOnBuffsChangedDelegate()
  self:RemoveTimer("SpectrumCountdown")
  self.BuffId = Const.Spectrum.BuffId
  self.bSpectrumActive = nil
  self:K2_SetBuffsOwner(self.OwnerPlayer)
  self:RegisterOnBuffsChangedDelegate()
  self:ReceiveOnBuffsChanged()
end

function M:SetSpectrumTextOpacity(Opacity)
  self.CurrentSpectrumTextOpacity = Opacity
  if self.Num_Kami then
    self.Num_Kami:SetRenderOpacity(Opacity)
  end
  if self.Text_Time then
    self.Text_Time:SetRenderOpacity(Opacity)
  end
end

function M:StartSpectrumOpacityFade(TargetOpacity, TargetTextOpacity)
  if self.bSpectrumClosing or not self.Main then
    return
  end
  self:RemoveTimer("SpectrumOpacityFade")
  local StartOpacity = self.CurrentSpectrumOpacity or Const.Spectrum.ActiveOpacity
  local StartTextOpacity = self.CurrentSpectrumTextOpacity or Const.Spectrum.ActiveTextOpacity
  local Duration = Const.Spectrum.FadeDuration
  if Duration <= 0 or math.abs(TargetOpacity - StartOpacity) <= 0.001 and math.abs(TargetTextOpacity - StartTextOpacity) <= 0.001 then
    self.CurrentSpectrumOpacity = TargetOpacity
    self.Main:SetRenderOpacity(TargetOpacity)
    self:SetSpectrumTextOpacity(TargetTextOpacity)
    if TargetTextOpacity <= 0 and self.Num_Kami then
      self.Num_Kami:SetText("0")
    end
    return
  end
  local Elapsed = 0
  self:AddTimer(Const.Spectrum.FadeInterval, function()
    if self.bSpectrumClosing or not self.Main then
      self:RemoveTimer("SpectrumOpacityFade")
      return
    end
    Elapsed = math.min(Elapsed + Const.Spectrum.FadeInterval, Duration)
    local Alpha = Elapsed / Duration
    self.CurrentSpectrumOpacity = StartOpacity + (TargetOpacity - StartOpacity) * Alpha
    self.Main:SetRenderOpacity(self.CurrentSpectrumOpacity)
    self:SetSpectrumTextOpacity(StartTextOpacity + (TargetTextOpacity - StartTextOpacity) * Alpha)
    if Elapsed >= Duration then
      self:RemoveTimer("SpectrumOpacityFade")
      if TargetTextOpacity <= 0 and self.Num_Kami then
        self.Num_Kami:SetText("0")
      end
    end
  end, true, 0, "SpectrumOpacityFade")
end

function M:SetSpectrumActive(bActive)
  local bChanged = self.bSpectrumActive ~= bActive
  self.bSpectrumActive = bActive
  if bActive then
    if bChanged then
      self:AddTimer(Const.Spectrum.UpdateInterval, self.UpdateLeftTime, true, 0, "SpectrumCountdown")
    end
    self:UpdateLeftTime()
  else
    self:RemoveTimer("SpectrumCountdown")
    if self.Progress_Lise then
      self.Progress_Lise:SetPercent(0)
    end
  end
  if bChanged then
    self:StartSpectrumOpacityFade(bActive and Const.Spectrum.ActiveOpacity or Const.Spectrum.InactiveOpacity, bActive and Const.Spectrum.ActiveTextOpacity or Const.Spectrum.InactiveTextOpacity)
  end
end

function M:ReceiveOnBuffsChanged()
  if not IsValid(self.OwnerPlayer) or not self.OwnerPlayer.BuffManager then
    return
  end
  local Buffs = self.OwnerPlayer.BuffManager.Buffs
  local BuffObj
  for _, Buff in pairs(Buffs) do
    if IsValid(Buff) and Buff.BuffId == self.BuffId then
      BuffObj = Buff
      break
    end
  end
  self.BuffObj = BuffObj
  self.TotalTime = IsValid(BuffObj) and BuffObj.LastTime or nil
  self:SetSpectrumActive(IsValid(BuffObj))
end

function M:UpdateLeftTime()
  if not (IsValid(self.BuffObj) and self.TotalTime) or self.TotalTime <= 0 then
    return
  end
  local LeftTime = self.BuffObj:GetLeftTime()
  if LeftTime <= 0 then
    self.BuffObj = nil
    self.TotalTime = nil
    self:SetSpectrumActive(false)
    return
  end
  self.Num_Kami:SetText(string.format("%.0f", LeftTime))
  self.Progress_Lise:SetPercent(math.max(LeftTime / self.TotalTime, 0))
end

function M:RemoveSelf()
  self.bSpectrumClosing = true
  self:RemoveTimer("SpectrumOpacityFade")
  self:RemoveTimer("SpectrumCountdown")
  self:UnRegisterOnBuffsChangedDelegate()
  self:Close()
end

return M
