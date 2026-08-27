require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local BAR_HEIGHT = 708
local PERFECT_PANEL_BOTTOM_Y = 350
local HAMMER_MAIN_OUT_DELAY_TIMER = "HammerMainOutDelay"

local function Clamp(Value, MinValue, MaxValue)
  return math.max(MinValue, math.min(Value, MaxValue))
end

local function SafeSetVisibility(Widget, Visibility)
  if Widget then
    Widget:SetVisibility(Visibility)
  end
end

local function SafeSetText(Widget, TextMapId)
  if Widget and TextMapId then
    Widget:SetText(GText(TextMapId))
  end
end

local function SafePlayAnimation(Widget, Animation, StartAtTime, NumLoopsToPlay, PlayMode, PlaybackSpeed, bRestoreState)
  if Widget and Animation then
    Widget:PlayAnimation(Animation, StartAtTime or 0, NumLoopsToPlay or 1, PlayMode or UE4.EUMGSequencePlayMode.Forward, PlaybackSpeed or 1, true == bRestoreState)
    return true
  end
  return false
end

local function SafeBindAnimationFinished(Widget, Animation, Callback)
  if Widget and Animation and Callback then
    Widget:UnbindAllFromAnimationFinished(Animation)
    Widget:BindToAnimationFinished(Animation, Callback)
    return true
  end
  return false
end

local function GetBarPositionY(Ratio)
  return -BAR_HEIGHT * Clamp(Ratio, 0, 1)
end

local function ParseComboKeys(ComboText)
  local Keys = {}
  local KeySet = {}
  for Key in string.gmatch(string.upper(ComboText or ""), "[%w_]+") do
    if not KeySet[Key] then
      KeySet[Key] = true
      table.insert(Keys, Key)
    end
  end
  return Keys
end

function M:OnLoaded(InitInfo)
  if InitInfo then
    self.UseActor = InitInfo.UseActor
    self.Time = InitInfo.Time
    self.MapIndex = InitInfo.MapIndex
    self.Difficulty = InitInfo.Difficulty
    self.FailedTime = InitInfo.FailedTime
    self.bMapIndexIsLocked = InitInfo.bMapIndexIsLocked
    self.bCanCrack = InitInfo.bCanCrack
  end
  if self.UseActor then
    self:InitAfterBeginPlay()
  end
end

function M:InitAfterBeginPlay()
  self.bHammerUIInitialized = true
  self.bHammerStarted = false
  self.bHammerInputEnabled = false
  self.bHammerInputLocked = false
  self.bHammerGameEnded = false
  self.bHammerCloseNotifiedActor = false
  self.bHammerCloseFromActor = false
  self.bHammerEndPresentationFinished = false
  self.bHammerMainOutAnimationStarted = false
  self.CurrentComboKeys = {}
  self.PressedComboKeys = {}
  self:CacheBarLayout()
  self:ResetHammerEndVisualState()
  self:InitButtonEvents()
  self:InitTextMap()
  self:InitPlatform()
  self:RefreshHammerProgress(0, 0)
  self:SetHammerInputEnabled(false)
  self:RefreshComboCountVisibility()
  self:RefreshComboCount()
  self.Btn_Crack:SetVisibility(self.bCanCrack and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  local Bar = self.Bar
  if Bar then
    SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.Collapsed)
    SafeSetVisibility(Bar.Panel_Perfect, UE4.ESlateVisibility.Collapsed)
  end
  self:PlayHammerEnterAnimation()
end

function M:CacheBarLayout()
  if not self.Bar then
    return
  end
  self.RangeWidget = self.Bar.Panel_Range
  self.ProgressWidget = self.Bar.Panel_Progress
  self.PerfectWidget = self.Bar.Panel_Perfect
  self.RangeSlot = self.RangeWidget and UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.RangeWidget) or nil
  self.ProgressSlot = self.ProgressWidget and UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.ProgressWidget) or nil
  self.PerfectSlot = self.PerfectWidget and UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.PerfectWidget) or nil
  self.RangeBasePosition = self.RangeSlot and self.RangeSlot:GetPosition() or FVector2D(0, 0)
  self.PerfectBasePosition = self.PerfectSlot and self.PerfectSlot:GetPosition() or FVector2D(0, 0)
  self.ProgressBaseSize = self.ProgressSlot and self.ProgressSlot:GetSize() or FVector2D(0, 0)
  self.RangeBaseRenderTranslation = self.RangeWidget and self.RangeWidget.RenderTransform and self.RangeWidget.RenderTransform.Translation or FVector2D(0, 0)
  self.PerfectBaseRenderTranslation = self.PerfectWidget and self.PerfectWidget.RenderTransform and self.PerfectWidget.RenderTransform.Translation or FVector2D(0, 0)
end

function M:ResetHammerEndVisualState()
  self:RemoveTimer(HAMMER_MAIN_OUT_DELAY_TIMER)
  if self.Out then
    self:StopAnimation(self.Out)
    self:UnbindFromAnimationFinished(self.Out, {
      self,
      self.OnHammerMainOutAnimationFinished
    })
  end
  local Bar = self.Bar
  if not Bar then
    return
  end
  Bar:StopAllAnimations()
  local SuccessHitAnimation = self:GetHammerHitResultAnimation(true)
  if SuccessHitAnimation then
    Bar:UnbindAllFromAnimationFinished(SuccessHitAnimation)
  end
  local FailHitAnimation = self:GetHammerHitResultAnimation(false)
  if FailHitAnimation then
    Bar:UnbindAllFromAnimationFinished(FailHitAnimation)
  end
end

function M:InitButtonEvents()
  self.Btn_Start.Btn_Click.OnClicked:Remove(self, self.OnHammerButtonClicked)
  self.Btn_Start.Btn_Click.OnClicked:Add(self, self.OnHammerButtonClicked)
  self.Btn_Crack.Btn_Click.OnClicked:Remove(self, self.OnCrackButtonClicked)
  self.Btn_Crack.Btn_Click.OnClicked:Add(self, self.OnCrackButtonClicked)
  self.Btn_Close:Init("Close", self, self.OnCloseButtonClicked, false)
end

function M:InitTextMap()
  if self.Bar then
    SafeSetText(self.Bar.Text_Perfect, "UI_Hammer_Perfect")
  end
  if self.Btn_Start then
    SafeSetText(self.Btn_Start.Text_Button, self:GetHammerStartTextMap())
  end
  if self.Btn_Crack then
    SafeSetText(self.Btn_Crack.Text_Button, "UI_MiniGame_Decode")
  end
  if self.Combo then
    SafeSetText(self.Combo.Text_Desc, "UI_Hammer_Count")
  end
  if self.Tip then
    SafeSetText(self.Tip.Text_Key, "UI_MinGame_Hammer_KeyTip")
  end
  self:SetHammerTipText(self:GetHammerInputTipTextMap())
end

function M:InitPlatform()
end

function M:PlayHammerEnterAnimation()
  AudioManager(self):PlayUISound(self, "event:/ui/minigame/dachui_open", "HammerOpen", nil)
  SafePlayAnimation(self, self.In)
  if self.Bar then
    SafePlayAnimation(self.Bar, self.Bar.In)
  end
end

function M:GetHammerStartTextMap()
  return "UI_Hammer_Start"
end

function M:SetHammerTipText(TextMapId)
  if self.Tip then
    SafeSetText(self.Tip.Text_Tip, TextMapId)
  end
end

function M:GetHammerInputTipTextMap()
  return "UI_Hammer_InfoClick"
end

function M:OnHammerButtonClicked()
  if self.bHammerGameEnded then
    return
  end
  if not self.bHammerStarted then
    self:StartHammerGame()
    return
  end
  self:HandleStartedHammerButton()
end

function M:HandleStartedHammerButton()
end

function M:StartHammerGame()
  if self.bHammerStarted or not self.UseActor then
    return
  end
  AudioManager(self):PlayUISound(self.Btn_Start, "event:/ui/minigame/dachui_power_on_btn_click", nil, nil)
  self.bHammerStarted = true
  self:OnHammerGameStarted()
  self.UseActor:OnHammerStart(self.UseActor.PlayerEid)
end

function M:OnHammerGameStarted()
  SafePlayAnimation(self, self.Pattern)
  self:SetStartGuideAnimationEnabled(false)
end

function M:OnHammerInputHintReady()
end

function M:OnHammerInputEnabledChanged(bEnabled)
end

function M:HideHammerInputHint()
end

function M:OnCrackButtonClicked()
  if not (not self.bHammerGameEnded and self.UseActor) or not self.bCanCrack then
    return
  end
  AudioManager(self):PlayUISound(self.Btn_Crack, "event:/ui/minigame/dachui_power_on_btn_click", nil, nil)
  self.UseActor:OnHammerCrack(self.UseActor.PlayerEid)
end

function M:OnCloseButtonClicked()
  if self.bHammerGameEnded then
    return
  end
  AudioManager(self):PlayUISound(self.Btn_Close, "event:/ui/common/click_btn_cancel", nil, nil)
  if not self.UseActor then
    AudioManager(self):SetEventSoundParam(self, "HammerOpen", {ToEnd = 1})
    if self.Close then
      self:Close()
    end
    return
  end
  self.bHammerCloseNotifiedActor = true
  self.UseActor:OnHammerCancel(self.UseActor.PlayerEid)
end

function M:SubmitHammerInput(InputKey)
  if not self.bHammerStarted or self.bHammerGameEnded then
    return
  end
  if self.bHammerInputLocked then
    self:ShowHammerButtonCooldownToast()
    return
  end
  self.UseActor:OnHammerInput(string.upper(InputKey))
end

function M:ShowHammerButtonCooldownToast()
  UIManager(self):ShowUITip("CommonToastMain", GText("UI_Hammer_ButtonCooldown"))
end

function M:RefreshHammerProgress(Progress, MarkerValue)
  self.CurrentHammerMarkerValue = MarkerValue
  local ProgressMax = self.UseActor and self.UseActor.ProgressMax or 1
  local MarkerRatio = Clamp(MarkerValue / ProgressMax, 0, 1)
  if self.ProgressSlot and self.ProgressBaseSize then
    local ProgressSize = FVector2D(self.ProgressBaseSize.X, BAR_HEIGHT * MarkerRatio)
    self.ProgressSlot:SetSize(ProgressSize)
  end
end

function M:RefreshPerfectPanelPosition()
  local ProgressMax = self.UseActor and self.UseActor.ProgressMax or 1
  local MarkerValue = self.CurrentHammerMarkerValue or self.UseActor and self.UseActor.HammerMarkerValue or 0
  local TargetY = PERFECT_PANEL_BOTTOM_Y - BAR_HEIGHT * Clamp(MarkerValue / ProgressMax, 0, 1)
  if self.PerfectSlot and self.PerfectBasePosition then
    self.PerfectSlot:SetPosition(FVector2D(self.PerfectBasePosition.X, TargetY))
  elseif self.PerfectWidget then
    self.PerfectWidget:SetRenderTranslation(FVector2D(self.PerfectBaseRenderTranslation.X, TargetY))
  end
end

function M:ShowHammerKeyFrame(KeyPosition)
  self:RefreshHammerKeyPosition(KeyPosition)
  local Bar = self.Bar
  if not Bar then
    return
  end
  SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.SelfHitTestInvisible)
  SafeSetVisibility(Bar.Panel_Perfect, UE4.ESlateVisibility.Collapsed)
  if not self.bHammerInputEnabled then
    self:HideHammerInputHint()
  end
  SafePlayAnimation(Bar, Bar.Range_In)
end

function M:ShowNextInputHint(ComboText, KeyPosition, bSkipAppearAnimation)
  self:InvalidateHammerInputHintHide()
  self.CurrentComboKeys = ParseComboKeys(ComboText)
  self.PressedComboKeys = {}
  self:RefreshHammerKeyPosition(KeyPosition)
  local Bar = self.Bar
  if Bar then
    SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self:SetHammerInputEnabled(false)
  self:OnHammerInputHintReady(bSkipAppearAnimation)
end

function M:RefreshInitialInputHint()
  if not self.UseActor or not self.UseActor.CurrentInputComboText then
    return
  end
  self:InvalidateHammerInputHintHide()
  self.CurrentComboKeys = ParseComboKeys(self.UseActor.CurrentInputComboText)
  self.PressedComboKeys = {}
  self:RefreshHammerKeyPosition(self.UseActor.CurrentKeyDisplayPos or 0)
  local Bar = self.Bar
  if Bar then
    SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.SelfHitTestInvisible)
    SafeSetVisibility(Bar.Panel_Perfect, UE4.ESlateVisibility.Collapsed)
  end
  self:SetHammerInputEnabled(self.UseActor and self.UseActor.bInputEnabled == true)
  self:OnHammerInputHintReady()
end

function M:RefreshComboKeyHints()
end

function M:OnHammerBarRise(_, CurPercent)
  local SoundPath = 0 == CurPercent and "event:/ui/minigame/dachui_grow_trigger_start" or "event:/ui/minigame/dachui_grow_trigger_repeat"
  AudioManager(self):PlayUISound(self, SoundPath, nil, nil)
end

function M:InvalidateHammerInputHintHide()
  self.HammerInputHintHideToken = (self.HammerInputHintHideToken or 0) + 1
end

function M:RefreshComboCountVisibility()
  if not self.Combo then
    return
  end
  local bShowComboCount = not self.UseActor or self.UseActor.bShowHammerComboCount ~= false
  self.Combo:SetVisibility(bShowComboCount and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
end

function M:SetHammerInputEnabled(bEnabled)
  self.bHammerInputEnabled = bEnabled
  self:OnHammerInputEnabledChanged(bEnabled)
  self:RefreshHammerButtonEnabled()
end

function M:SetHammerStartButtonForbidden(bForbidden)
  if not self.Btn_Start or not self.Btn_Start.Btn_Click then
    return
  end
  self.Btn_Start.Btn_Click:SetForbidden(bForbidden)
end

function M:RefreshHammerStartButtonState(bInputAvailable)
  local bStartForbidden = self.bHammerStarted and not self.bHammerGameEnded and not bInputAvailable
  self.Btn_Start.Btn_Click:SetIsEnabled(not self.bHammerGameEnded and (not self.bHammerStarted or not self.bHammerInputLocked))
  self:SetHammerStartButtonForbidden(bStartForbidden)
end

function M:RefreshHammerButtonEnabled()
  local bInputAvailable = self.bHammerInputEnabled and not self.bHammerInputLocked
  self:RefreshHammerStartButtonState(bInputAvailable)
  self.Btn_Crack.Btn_Click:SetIsEnabled(self.bCanCrack and not self.bHammerGameEnded)
  self:RefreshStartGuideAnimation()
end

function M:RefreshStartGuideAnimation()
  local bGuideEnabled = not self.bHammerGameEnded and not self.bHammerStarted
  self:SetStartGuideAnimationEnabled(bGuideEnabled)
end

function M:SetStartGuideAnimationEnabled(bEnabled)
  if not self.Btn_Start or not self.Btn_Start.Guide then
    return
  end
  if bEnabled then
    if self.bStartGuideAnimationPlaying then
      return
    end
    self.bStartGuideAnimationPlaying = true
    self.Btn_Start:PlayAnimation(self.Btn_Start.Guide, 0, 0)
    return
  end
  if not self.bStartGuideAnimationPlaying then
    return
  end
  self.bStartGuideAnimationPlaying = false
  self.Btn_Start:StopAnimation(self.Btn_Start.Guide)
end

function M:RefreshHammerKeyPosition(KeyPosition)
  local ProgressMax = self.UseActor and self.UseActor.ProgressMax or 1
  local KeyRatio = Clamp(KeyPosition / ProgressMax, 0, 1)
  local TargetY = GetBarPositionY(KeyRatio)
  if self.RangeSlot and self.RangeBasePosition then
    self.RangeSlot:SetPosition(FVector2D(self.RangeBasePosition.X, TargetY))
  elseif self.RangeWidget then
    self.RangeWidget:SetRenderTranslation(FVector2D(self.RangeBaseRenderTranslation.X, TargetY))
  end
end

function M:UpdateHammerComboInput(InputKey, bPressed)
  local Key = string.upper(InputKey or "")
  self.PressedComboKeys[Key] = bPressed or nil
end

function M:SetHammerInputLocked(bLocked, RemainTime)
  self.bHammerInputLocked = bLocked
  self.LockRemainTime = RemainTime
  if bLocked then
    self.PressedComboKeys = {}
  end
  self:RefreshHammerButtonEnabled()
  self:RefreshHammerInputReadyAnimation()
end

function M:SetHammerInputHintVisible(bVisible)
  self.bHammerInputHintVisible = bVisible
  if not bVisible then
    self:StopHammerInputHintAnimation()
  end
end

function M:PlayHammerInputHintAppearAnimation()
  local Bar = self.Bar
  if not (Bar and self.bHammerInputHintVisible) or self.bHammerGameEnded then
    return
  end
  local bInputAvailable = self.bHammerInputEnabled and not self.bHammerInputLocked
  self.HammerInputHintAnimationState = bInputAvailable and "Ready" or "Forbidden"
  self:StopHammerInputRemindAnimation()
  if Bar.Btn_Forbidden then
    Bar:StopAnimation(Bar.Btn_Forbidden)
  end
  SafePlayAnimation(Bar, Bar.Btn_In)
  if bInputAvailable then
    self:PlayHammerInputRemindAnimation()
    return
  end
  SafePlayAnimation(Bar, Bar.Btn_Forbidden)
end

function M:GetHammerInputRemindAnimation()
  local Bar = self.Bar
  return Bar and Bar.Btn_Remind or nil
end

function M:PlayHammerInputRemindAnimation()
  local Bar = self.Bar
  local RemindAnimation = self:GetHammerInputRemindAnimation()
  if Bar and RemindAnimation then
    SafePlayAnimation(Bar, RemindAnimation, 0, 0)
  end
end

function M:StopHammerInputRemindAnimation()
  local Bar = self.Bar
  local RemindAnimation = self:GetHammerInputRemindAnimation()
  if Bar and RemindAnimation then
    Bar:StopAnimation(RemindAnimation)
  end
end

function M:RefreshHammerInputReadyAnimation()
  local Bar = self.Bar
  if not (Bar and self.bHammerInputHintVisible) or self.bHammerGameEnded then
    return
  end
  local bInputAvailable = self.bHammerInputEnabled and not self.bHammerInputLocked
  if bInputAvailable then
    if self.HammerInputHintAnimationState == "Ready" then
      return
    end
    self.HammerInputHintAnimationState = "Ready"
    if Bar.Btn_Forbidden then
      Bar:StopAnimation(Bar.Btn_Forbidden)
    end
    self:PlayHammerInputRemindAnimation()
    return
  end
  if self.HammerInputHintAnimationState == "Ready" then
    self:StopHammerInputRemindAnimation()
  end
  self.HammerInputHintAnimationState = nil
end

function M:StopHammerInputHintAnimation()
  local Bar = self.Bar
  if not Bar then
    return
  end
  self.HammerInputHintAnimationState = nil
  self:StopHammerInputRemindAnimation()
  if Bar.Btn_Forbidden then
    Bar:StopAnimation(Bar.Btn_Forbidden)
  end
end

function M:GetHammerHitResultAnimation()
end

function M:PlayHammerHitResultAnimation(bSuccess)
  local Bar = self.Bar
  local Animation = self:GetHammerHitResultAnimation(bSuccess)
  if Bar and Animation then
    SafePlayAnimation(Bar, Animation, nil, nil, nil, nil, true)
  end
  return Animation
end

function M:HideHammerInputHintAfterHitResult(HideToken)
  if HideToken ~= self.HammerInputHintHideToken or self.bHammerInputEnabled or self.bHammerGameEnded then
    return
  end
  self:HideHammerInputHint()
end

function M:PlayHammerHitResultAndDelayHideInput(bSuccess)
  self:InvalidateHammerInputHintHide()
  local HideToken = self.HammerInputHintHideToken
  local Bar = self.Bar
  local Animation = self:GetHammerHitResultAnimation(bSuccess)
  if Bar and Animation then
    SafeBindAnimationFinished(Bar, Animation, function()
      Bar:UnbindAllFromAnimationFinished(Animation)
      self:HideHammerInputHintAfterHitResult(HideToken)
    end)
    self:PlayHammerHitResultAnimation(bSuccess)
    return
  end
  self:PlayHammerHitResultAnimation(bSuccess)
  self:HideHammerInputHintAfterHitResult(HideToken)
end

function M:ShowHammerHitResult(ResultType)
  self.PressedComboKeys = {}
  self:RefreshComboCount()
  if "Perfect" == ResultType then
    self:SetHammerInputEnabled(false)
    local Bar = self.Bar
    if Bar then
      SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.Collapsed)
      self:RefreshPerfectPanelPosition()
      SafeSetVisibility(Bar.Panel_Perfect, UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self:PlayHammerHitResultAndDelayHideInput(true)
  elseif "Normal" == ResultType then
    self:SetHammerInputEnabled(false)
    local Bar = self.Bar
    if Bar then
      SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.Collapsed)
    end
    self:PlayHammerHitResultAndDelayHideInput(true)
  else
    self:SetHammerInputEnabled(false)
    self:PlayHammerHitResultAndDelayHideInput(false)
  end
end

function M:RefreshComboCount()
  if not self.Combo or not self.Combo.Text_Num then
    return
  end
  if self.UseActor and self.UseActor.bShowHammerComboCount == false then
    return
  end
  local ComboCount = self.UseActor and self.UseActor.HammerHitCount or 0
  self.Combo.Text_Num:SetText(tostring(ComboCount))
  if self.LastHammerComboCount and ComboCount > self.LastHammerComboCount then
    SafePlayAnimation(self.Combo, self.Combo.Refesh)
  end
  self.LastHammerComboCount = ComboCount
end

function M:ShowHammerGameEnd(bSuccess, bSkipNotifyActor)
  self.bHammerGameEnded = true
  self.bHammerInputEnabled = false
  self.bHammerEndSkipNotifyActor = bSkipNotifyActor
  self:InvalidateHammerInputHintHide()
  self:SetHammerInputHintVisible(false)
  self:OnHammerInputEnabledChanged(false)
  self:RefreshHammerButtonEnabled()
  AudioManager(self):SetEventSoundParam(self, "HammerOpen", {ToEnd = 1})
  self:PlayHammerGameEndAnimation(bSuccess)
end

function M:PlayHammerGameEndAnimation(bSuccess)
  local Bar = self.Bar
  local BarOutAnimation = Bar and (bSuccess and Bar.Success_Out or Bar.Fail_Out) or nil
  if BarOutAnimation then
    SafePlayAnimation(Bar, BarOutAnimation, nil, nil, nil, nil, true)
  end
  self:DelayPlayHammerMainOutAnimation()
end

function M:DelayPlayHammerMainOutAnimation()
  self:RemoveTimer(HAMMER_MAIN_OUT_DELAY_TIMER)
  local Delay = math.max(self.UIDisappearDelay or 0, 0)
  if Delay <= 0 then
    self:PlayHammerMainOutAnimation()
    return
  end
  self:AddTimer(Delay, function()
    self:PlayHammerMainOutAnimation()
  end, false, 0, HAMMER_MAIN_OUT_DELAY_TIMER, true)
end

function M:PlayHammerMainOutAnimation()
  self:RemoveTimer(HAMMER_MAIN_OUT_DELAY_TIMER)
  if self.bHammerMainOutAnimationStarted then
    return
  end
  self.bHammerMainOutAnimationStarted = true
  if self.Out then
    self:UnbindFromAnimationFinished(self.Out, {
      self,
      self.OnHammerMainOutAnimationFinished
    })
    self:BindToAnimationFinished(self.Out, {
      self,
      self.OnHammerMainOutAnimationFinished
    })
    SafePlayAnimation(self, self.Out)
    return
  end
  self:OnHammerMainOutAnimationFinished()
end

function M:OnHammerMainOutAnimationFinished()
  self.bHammerMainOutAnimationStarted = false
  if self.Out then
    self:UnbindFromAnimationFinished(self.Out, {
      self,
      self.OnHammerMainOutAnimationFinished
    })
  end
  self:NotifyHammerEndPresentationFinished()
end

function M:NotifyHammerEndPresentationFinished()
  if self.bHammerEndPresentationFinished then
    return
  end
  self.bHammerEndPresentationFinished = true
  if not self.bHammerEndSkipNotifyActor and self.UseActor then
    self.UseActor:OnHammerEndPresentationFinished()
  end
end

function M:GameFailed()
  if self.bHammerGameEnded then
    return
  end
  self:ShowHammerGameEnd(false, true)
end

function M:OnEndClose()
  if not self.bHammerGameEnded and not self.bHammerCloseNotifiedActor and not self.bHammerCloseFromActor and self.UseActor then
    self.bHammerCloseNotifiedActor = true
    self.UseActor:OnHammerCancel(self.UseActor.PlayerEid)
  end
end

function M:CleanupHammerUI()
  self:ResetHammerEndVisualState()
  self:SetHammerInputHintVisible(false)
  self:OnHammerInputEnabledChanged(false)
  self:SetStartGuideAnimationEnabled(false)
  if self.Btn_Start and self.Btn_Start.Btn_Click then
    self.Btn_Start.Btn_Click.OnClicked:Remove(self, self.OnHammerButtonClicked)
  end
  if self.Btn_Crack and self.Btn_Crack.Btn_Click then
    self.Btn_Crack.Btn_Click.OnClicked:Remove(self, self.OnCrackButtonClicked)
  end
  self:DestructPlatform()
end

function M:OnDestroyed()
  self:CleanupHammerUI()
end

function M:Destruct()
  self:CleanupHammerUI()
end

function M:DestructPlatform()
end

return M
