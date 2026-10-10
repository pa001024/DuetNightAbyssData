require("UnLua")
local Const = require("BluePrints.UI.Battle.ExclusiveSkill.Battle_SpliseConst")
local SpliseMultiplierBase = require("BluePrints.UI.Battle.ExclusiveSkill.Battle_SpliseMultiplierBase")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
  self.DragStart = false
  self.CurrentSliderValue = 0
  self.SliderAccum = 0
  if self.Slider_Multiplier then
    self.Slider_Multiplier.OnValueChanged:Remove(self, self.OnSliderChanged)
    self.Slider_Multiplier.OnMouseCaptureBegin:Remove(self, self.OnSliderCaptureBegin)
    self.Slider_Multiplier.OnMouseCaptureEnd:Remove(self, self.OnSliderCaptureEnd)
    self.Slider_Multiplier.OnValueChanged:Add(self, self.OnSliderChanged)
    self.Slider_Multiplier.OnMouseCaptureBegin:Add(self, self.OnSliderCaptureBegin)
    self.Slider_Multiplier.OnMouseCaptureEnd:Add(self, self.OnSliderCaptureEnd)
  end
end

function M:Destruct()
  self:RemoveTimer("UpdateDial")
  self.bScopeActive = false
  self.DragStart = false
  self.BattleInstance = nil
  self.OwnerEid = nil
  if self.Slider_Multiplier then
    self.Slider_Multiplier.OnValueChanged:Remove(self, self.OnSliderChanged)
    self.Slider_Multiplier.OnMouseCaptureBegin:Remove(self, self.OnSliderCaptureBegin)
    self.Slider_Multiplier.OnMouseCaptureEnd:Remove(self, self.OnSliderCaptureEnd)
  end
end

function M:InitMultiplier(OwnerPlayer)
  self.OwnerPlayer = OwnerPlayer
  self.OwnerEid = IsValid(OwnerPlayer) and OwnerPlayer.Eid or nil
  self.BattleInstance = nil
  self.DragStart = false
  self.SliderAccum = 0
  self.bScopeActive = false
  self.DialConfig = Const.Multiplier.DialConfig.Mobile
  self:CreateMultiplierEntries()
  if self.DynamicEntryBox_Multiplier then
    self.DynamicEntryBox_Multiplier:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
  end
  self:RemoveTimer("UpdateDial")
end

function M:OnSliderCaptureBegin()
  if not self.bScopeActive then
    return
  end
  self.SliderAccum = 0
  self.CurrentSliderValue = self.Slider_Multiplier:GetValue()
  self.DragStart = true
  self.SliderPressFrame = UIUtils.UtilsGetCurrentInputType() == UE4.ECommonInputType.MouseAndKeyboard and UE4.UKismetSystemLibrary.GetFrameCount() or nil
end

function M:OnSliderChanged(Value)
  if not self.DragStart or not self.bScopeActive then
    return
  end
  local PressFrame = self.SliderPressFrame
  self.SliderPressFrame = nil
  if PressFrame and PressFrame == UE4.UKismetSystemLibrary.GetFrameCount() then
    self.CurrentSliderValue = Value
    return
  end
  local Delta = Value - self.CurrentSliderValue
  self.CurrentSliderValue = Value
  if not IsValid(self.OwnerPlayer) or not self.OwnerPlayer.ClientTriggerZoomInput then
    return
  end
  self.SliderAccum = self.SliderAccum + Delta
  local SliderTierStep = Const.Multiplier.SliderDragStep
  local Steps = math.floor(math.abs(self.SliderAccum) / SliderTierStep + 1.0E-7)
  for i = 1, Steps do
    local Dir = self.SliderAccum < 0 and 1 or -1
    self.OwnerPlayer:ClientTriggerZoomInput(Dir)
    self.SliderAccum = self.SliderAccum + Dir * SliderTierStep
  end
end

function M:OnSliderCaptureEnd()
  self.SliderPressFrame = nil
  self.DragStart = false
  self.SliderAccum = 0
  self:SyncSliderToMultiplier()
end

function M:SyncSliderToMultiplier(Index)
  if not self.Slider_Multiplier then
    return
  end
  Index = Index or self:GetMultiplierIndex()
  if Index then
    self.Slider_Multiplier:SetValue((Index - 1) * SpliseMultiplierBase.GetSliderTierStep())
  end
end

function M:CreateMultiplierEntries()
  SpliseMultiplierBase.CreateMultiplierEntries(self)
end

function M:GetMultiplierIndex()
  if not IsValid(self.OwnerPlayer) then
    return nil
  end
  local BattleIns = self.BattleInstance
  if not IsValid(BattleIns) then
    BattleIns = Battle(self.OwnerPlayer)
    self.BattleInstance = BattleIns
    if not IsValid(BattleIns) then
      return nil
    end
  end
  local Multi = UE4.UDataSetFunctionLibrary.GetFloat_ByEid(BattleIns, self.OwnerEid, Const.Multiplier.DataSetKey)
  return SpliseMultiplierBase.GetMultiplierIndex(Multi, self.DialConfig.ReverseSlots)
end

function M:UpdateDial(bSyncSlider)
  if not self.bScopeActive or not self:IsVisible() then
    return
  end
  if not bSyncSlider and (not self.MultiplierEntries or not self.DynamicEntryBox_Multiplier) then
    return
  end
  local Index = self:GetMultiplierIndex()
  if not Index then
    return
  end
  local bIndexChanged = SpliseMultiplierBase.UpdateDial(self, Index)
  if not self.DragStart and (bIndexChanged or bSyncSlider) then
    self:SyncSliderToMultiplier(Index)
  end
end

function M:SetScopeActive(bActive)
  self.bScopeActive = true == bActive
  self.DragStart = false
  self.SliderPressFrame = nil
  self.SliderAccum = 0
  self:SetVisibility(self.bScopeActive and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  self:RemoveTimer("UpdateDial")
  if self.bScopeActive then
    self:UpdateDial(true)
    self:AddTimer(Const.Multiplier.UpdateInterval, self.UpdateDial, true, 0, "UpdateDial")
  end
end

return M
