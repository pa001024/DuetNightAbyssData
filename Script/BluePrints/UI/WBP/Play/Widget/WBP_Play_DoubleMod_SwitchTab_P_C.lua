require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnClicked)
  self.Btn_Click.OnHovered:Add(self, self.OnHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
end

function M:SetConfig(Config)
  self.Config = Config
  local IsLocked = Config.OnCheckLocked and Config.OnCheckLocked() or false
  self:UpdateLockVisual(IsLocked)
  if IsLocked then
    self:UpdateSwitchVisual(false)
    self:SetCurrentTabState(false)
  else
    local IsOn = self:GetCurrentTabState()
    self:UpdateSwitchVisual(IsOn)
  end
end

function M:UpdateLockVisual(IsLocked)
  if not self.Image_Lock then
    return
  end
  local Visibility = IsLocked and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed
  self.Image_Lock:SetVisibility(Visibility)
end

function M:OnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
  if self.Config and self.Config.OnCheckLocked and self.Config.OnCheckLocked() then
    local ToastText = ""
    if self.Config.UnlockRuleId then
      local RuleData = DataMgr.UIUnlockRule[self.Config.UnlockRuleId]
      local CondData = RuleData and DataMgr.Condition[RuleData.ConditionId]
      local TextKey = CondData and CondData.ConditionText
      if TextKey then
        ToastText = GText(TextKey)
      end
    end
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, ToastText)
    return
  end
  local CurrentState = self:GetCurrentTabState()
  local NewState = not CurrentState
  self:UpdateSwitchVisual(NewState)
  self:SetCurrentTabState(NewState)
  if self.Config and self.Config.EventId then
    EventManager:FireEvent(self.Config.EventId, NewState)
  end
end

function M:OnHovered()
  self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
  self:PlayAnimation(self.UnHover)
end

function M:UpdateSwitchVisual(IsOn)
  self:StopAllAnimations()
  local ShowTip = self.Config and self.Config.OnQueryShowTip and self.Config.OnQueryShowTip()
  if IsOn then
    self:PlayAnimation(self.Switch)
    if self.Config and self.Config.TextOn then
      self.Text_TabTitleNormal:SetText(GText(self.Config.TextOn))
    end
    if ShowTip then
      if self.Config.OnTipDismissed then
        self.Config.OnTipDismissed()
      end
      self:PlayAnimationReverse(self.Tips_In_Out)
    end
  else
    self:PlayAnimationReverse(self.Switch)
    if self.Config and self.Config.TextOff then
      self.Text_TabTitleNormal:SetText(GText(self.Config.TextOff))
    end
    if ShowTip then
      if self.Config.TipText then
        self.Text_Tips:SetText(GText(self.Config.TipText))
      end
      self:PlayAnimation(self.Tips_Loop, 0, 0)
    end
  end
end

function M:GetCurrentTabState()
  if self.Config and self.Config.CacheKey then
    return EMCache:Get(self.Config.CacheKey, true) or false
  end
  return false
end

function M:SetCurrentTabState(state)
  if self.Config and self.Config.CacheKey then
    EMCache:Set(self.Config.CacheKey, state, true)
  end
end

return M
