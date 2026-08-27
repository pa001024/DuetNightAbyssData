require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")
local FALU_STATE = {
  NONE = 0,
  NORMAL = 1,
  FORBIDDEN = 2
}

function M:OnLoaded(OwnerPlayer, Params)
  self.Super.OnLoaded(self, OwnerPlayer, Params)
  self.OwnerPlayer = OwnerPlayer
  self.CurState = FALU_STATE.NONE
  self.LastValue = 0
  self.bClosing = false
  self:InitListenEvent()
  self:TryPlayAnimation(self.In)
  local Value = 0
  if IsValid(OwnerPlayer) then
    Value = OwnerPlayer:GetAttr("SecondSp") or 0
  end
  self.LastValue = Value
  self:UpdateNumber(Value)
  self.NormalLimit = 1
  local PassiveEffectClient = IsValid(OwnerPlayer) and OwnerPlayer:GetPassiveEffectClient()
  if IsValid(PassiveEffectClient) and PassiveEffectClient.Falu_Skill03_Value ~= nil then
    self.NormalLimit = PassiveEffectClient.Falu_Skill03_Value
  end
  self:ApplyState(Value)
end

function M:InitListenEvent()
  self:AddDispatcher(EventID.UpdateMainPlayerSecondSp, self, self.OnUpdateValue)
end

function M:OnUpdateValue(Value, OwnerActor)
  if OwnerActor ~= self.OwnerPlayer then
    return
  end
  self:RefreshValue(Value or 0)
end

function M:RefreshValue(Value)
  if self.bClosing then
    return
  end
  if Value > self.LastValue then
    self:TryPlayAnimation(self.Add)
  end
  self:UpdateNumber(Value)
  self:ApplyState(Value)
  self.LastValue = Value
end

function M:UpdateNumber(Value)
  if self.Num_Falu then
    self.Num_Falu:SetText(string.format("%.0f", Value or 0))
  end
end

function M:ApplyState(Value)
  local Limit = self.NormalLimit or 1
  local TargetState = Value >= Limit and FALU_STATE.NORMAL or FALU_STATE.FORBIDDEN
  if TargetState == self.CurState then
    return
  end
  self.CurState = TargetState
  if TargetState == FALU_STATE.NORMAL then
    self:TryPlayAnimation(self.Normal)
  else
    self:TryPlayAnimation(self.Forbidden)
  end
end

function M:TryPlayAnimation(Animation)
  if Animation then
    self:PlayAnimation(Animation)
  end
end

function M:RemoveSelf()
  if self.bClosing then
    return
  end
  self.bClosing = true
  if not self.Out then
    self:Close()
    return
  end
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, function()
    if not IsValid(self) then
      return
    end
    self:UnbindAllFromAnimationFinished(self.Out)
    self:Close()
  end)
  self:PlayAnimation(self.Out)
end

return M
