local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
local DrawCurveUnits = {
  Slow = 6,
  MidSlow = 10,
  MidFast = 40
}
local DrawCurveTotalUnits = DrawCurveUnits.Slow + DrawCurveUnits.MidSlow + DrawCurveUnits.MidFast
local DrawCurveSpeed = {
  Fast = 18,
  MidFastEnd = 9,
  MidSlowEnd = 4,
  SlowEnd = 1
}
local ResultShowDelay = 0.8
local ResultAnimStartDelay = 0.6
local GachaShowSoundEvent = "event:/ui/activity/limit_gift_pool_gacha_show"
local GachaShowSoundKey = "LimitedPrizePoolGachaShow"
local RollSingleSoundEvent = "event:/ui/activity/limit_gift_pool_gacha_roll_single"
local RollSingleEndSoundEvent = "event:/ui/activity/limit_gift_pool_gacha_roll_single_end"
local FirstItemUnlockSoundEvent = "event:/ui/activity/limit_gift_pool_gacha_sp_item_unlock"
local OtherItemAfterCheckSoundEvent = "event:/ui/activity/limit_gift_pool_gacha_sp_item_after_check"
local BaseDrawInterval = 1.49

function M:Construct()
  self.List = self.List_Item
end

function M:UnbindInAnimationFinished()
  if self.In then
    self:UnbindAllFromAnimationFinished(self.In)
  end
end

function M:Destruct()
  self:UnbindInAnimationFinished()
  self:ClearTimers()
  AudioManager(self):SetEventSoundParam(self, GachaShowSoundKey, {ToEnd = 1})
end

function M:ApplyInitData(WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
  self.TargetDisplayIndex = WonIndex
  self.bIsBigPrize = bIsBigPrize
  self.AcquiredList = AcquiredList
  self.DrawCount = DrawCount
  self.ConvertFlags = ConvertFlags
  self.InCallback = InCallback
end

function M:PlayInThenStartDraw()
  if not self.In then
    self:StartDrawAnimation()
    return
  end
  self:UnbindInAnimationFinished()
  self:BindToAnimationFinished(self.In, {
    self,
    function()
      if not IsValid(self) then
        return
      end
      self:UnbindInAnimationFinished()
      self:StartDrawAnimation()
    end
  })
  self:PlayAnimation(self.In)
end

function M:Init(RewardPool, WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
  self:ApplyInitData(WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
  self.Panel_Toast:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:ClearTimers()
  self:PopulateList(RewardPool)
  AudioManager(self):PlayUISound(self, GachaShowSoundEvent, GachaShowSoundKey, nil)
  if self.ItemCount <= 1 then
    self:ShowResult()
  else
    self:PlayInThenStartDraw()
  end
end

function M:PopulateList(DataList)
  local DataList = DataList or {}
  self.ItemCount = #DataList
  self.List:ClearListItems()
  for i, ItemData in ipairs(DataList) do
    local Content = UE4.NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = ItemData.Id
    Content.Ids = ItemData.Ids
    Content.Type = ItemData.Type
    Content.Count = ItemData.Count
    Content.bLocked = ItemData.bLocked
    Content.bGot = false
    Content.Number = i
    Content.IsPreviewMode = true
    self.List:AddItem(Content)
  end
end

function M:GetDrawSpeedByStep(Step, IntervalCount, ItemCount)
  if IntervalCount <= 1 then
    return 1
  end
  local ClampedStep = math.max(1, math.min(Step, IntervalCount))
  local DecelStartStep = math.floor(IntervalCount - 2.5 * math.max(ItemCount or 0, 0))
  DecelStartStep = math.max(1, math.min(DecelStartStep, IntervalCount))
  if ClampedStep < DecelStartStep then
    return DrawCurveSpeed.Fast
  end
  local DecelLen = IntervalCount - DecelStartStep + 1
  if DecelLen <= 3 then
    local T = (ClampedStep - DecelStartStep) / math.max(DecelLen - 1, 1)
    return DrawCurveSpeed.Fast - (DrawCurveSpeed.Fast - DrawCurveSpeed.SlowEnd) * T
  end
  local MidFastLen = math.max(1, math.floor(DecelLen * DrawCurveUnits.MidFast / DrawCurveTotalUnits))
  local MidSlowLen = math.max(1, math.floor(DecelLen * DrawCurveUnits.MidSlow / DrawCurveTotalUnits))
  local SlowLen = math.max(1, DecelLen - MidFastLen - MidSlowLen)
  local MidFastEnd = MidFastLen
  local MidSlowEnd = MidFastEnd + MidSlowLen
  local DecelStep = ClampedStep - DecelStartStep + 1
  
  local function SmoothLerp(From, To, T)
    local U = math.max(0, math.min(T, 1))
    local S = U * U * (3 - 2 * U)
    return From + (To - From) * S
  end
  
  if MidFastEnd >= DecelStep then
    local Den = math.max(MidFastLen - 1, 1)
    local T = (DecelStep - 1) / Den
    return SmoothLerp(DrawCurveSpeed.Fast, DrawCurveSpeed.MidFastEnd, T)
  end
  if MidSlowEnd >= DecelStep then
    local Den = math.max(MidSlowLen - 1, 1)
    local T = (DecelStep - MidFastEnd - 1) / Den
    return SmoothLerp(DrawCurveSpeed.MidFastEnd, DrawCurveSpeed.MidSlowEnd, T)
  end
  local Den = math.max(SlowLen - 1, 1)
  local T = (DecelStep - MidSlowEnd - 1) / Den
  return SmoothLerp(DrawCurveSpeed.MidSlowEnd, DrawCurveSpeed.SlowEnd, T)
end

function M:StartDrawAnimation()
  local Count = self.ItemCount or 0
  local TotalSteps = 3 * Count + self.TargetDisplayIndex
  local IntervalCount = math.max(TotalSteps - 1, 0)
  local BaseInterval = BaseDrawInterval
  self.CurrentDrawStep = 1
  self.LastDrawIndex = nil
  
  local function PlayNextStep()
    if not IsValid(self) then
      return
    end
    if self.CurrentDrawStep > TotalSteps then
      self:FinishDrawAnimation(Count)
      return
    end
    local ItemIndex = (self.CurrentDrawStep - 1) % Count + 1
    self:PlayItemAnimation(ItemIndex)
    if self.CurrentDrawStep >= TotalSteps then
      AudioManager(self):PlayUISound(self, RollSingleEndSoundEvent, nil, nil)
      self:FinishDrawAnimation(Count)
      return
    end
    AudioManager(self):PlayUISound(self, RollSingleSoundEvent, nil, nil)
    local CurrentSpeed = self:GetDrawSpeedByStep(self.CurrentDrawStep, IntervalCount, Count)
    local CurrentInterval = BaseInterval / CurrentSpeed
    self.CurrentDrawStep = self.CurrentDrawStep + 1
    self.DrawTimerKey = self:AddTimer(CurrentInterval, PlayNextStep, nil, nil, nil, true)
  end
  
  PlayNextStep()
end

function M:FinishDrawAnimation(Count)
  self.DrawTimerKey = nil
  
  local function OnAllAnimationsFinished()
    if self.ResultDelayTimerKey then
      self:RemoveTimer(self.ResultDelayTimerKey)
      self.ResultDelayTimerKey = nil
    end
    if ResultShowDelay <= 0 then
      self:ShowResult()
      return
    end
    self.ResultDelayTimerKey = self:AddTimer(ResultShowDelay, function()
      if not IsValid(self) then
        return
      end
      self.ResultDelayTimerKey = nil
      self:ShowResult()
    end, nil, nil, nil, true)
  end
  
  local function PlayResultAnimations()
    if self.bIsBigPrize then
      self:PlayAnimation(self.Toast_In)
      if self.DrawCount <= 3 then
        self.Text_Title:SetText(string.format(GText("UI_LimitedPrizePool_BestLuck"), self.DrawCount))
        self.Panel_Toast:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      elseif self.DrawCount <= 5 then
        self.Text_Title:SetText(string.format(GText("UI_LimitedPrizePool_GoodLuck"), self.DrawCount))
        self.Panel_Toast:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      end
      local TargetAnimCount = Count - 1
      if TargetAnimCount <= 0 then
        OnAllAnimationsFinished()
        return
      end
      local AnimCount = 0
      
      local function OnOtherAnimFinished()
        AnimCount = AnimCount + 1
        if AnimCount >= TargetAnimCount then
          OnAllAnimationsFinished()
        end
      end
      
      local function OnTargetAnimFinished()
        AudioManager(self):PlayUISound(self, OtherItemAfterCheckSoundEvent, nil, nil)
        for i = 1, Count do
          if i ~= self.TargetDisplayIndex then
            self:PlayItemResultAnimation(i, OnOtherAnimFinished)
          end
        end
      end
      
      AudioManager(self):PlayUISound(self, FirstItemUnlockSoundEvent, nil, nil)
      self:PlayItemResultAnimation(self.TargetDisplayIndex, OnTargetAnimFinished)
    else
      AudioManager(self):PlayUISound(self, OtherItemAfterCheckSoundEvent, nil, nil)
      self:PlayItemResultAnimation(self.TargetDisplayIndex, OnAllAnimationsFinished)
    end
  end
  
  if ResultAnimStartDelay <= 0 then
    PlayResultAnimations()
  else
    self.ResultAnimStartDelayTimerKey = self:AddTimer(ResultAnimStartDelay, function()
      if not IsValid(self) then
        return
      end
      self.ResultAnimStartDelayTimerKey = nil
      PlayResultAnimations()
    end, nil, nil, nil, true)
  end
end

function M:PlayItemAnimation(Index)
  if self.LastDrawIndex and self.LastDrawIndex ~= Index then
    local LastWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List, self.LastDrawIndex - 1)
    if IsValid(LastWidget) and LastWidget.PlayGachaOutAnimation then
      LastWidget:PlayGachaOutAnimation()
    end
  end
  local ItemWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List, Index - 1)
  if IsValid(ItemWidget) and ItemWidget.PlayGachaInAnimation then
    ItemWidget:PlayGachaInAnimation()
  end
  self.LastDrawIndex = Index
end

function M:PlayItemResultAnimation(Index, CallbackFunc)
  local ItemWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List, Index - 1)
  if IsValid(ItemWidget) then
    if ItemWidget.PlayGachaGetAnimation then
      ItemWidget:PlayGachaGetAnimation(CallbackFunc)
    elseif CallbackFunc then
      CallbackFunc()
    end
  elseif CallbackFunc then
    CallbackFunc()
  end
end

function M:ShowResult()
  if self.AcquiredList and #self.AcquiredList > 0 then
    local ResultWidget = UIManager(self):LoadUINew("LimitedPrizePoolReward", self.AcquiredList, self.DrawCount, self.bIsBigPrize, self.InCallback, self.ConvertFlags)
  end
  self:RemoveFromParent()
end

function M:SkipToResult()
  self:ClearTimers()
  self:ShowResult()
end

function M:ClearTimers()
  if self.DrawTimerKey then
    self:RemoveTimer(self.DrawTimerKey)
    self.DrawTimerKey = nil
  end
  if self.ResultDelayTimerKey then
    self:RemoveTimer(self.ResultDelayTimerKey)
    self.ResultDelayTimerKey = nil
  end
  if self.ResultAnimStartDelayTimerKey then
    self:RemoveTimer(self.ResultAnimStartDelayTimerKey)
    self.ResultAnimStartDelayTimerKey = nil
  end
end

return M
