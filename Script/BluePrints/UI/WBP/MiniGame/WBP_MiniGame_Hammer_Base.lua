require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local BAR_HEIGHT = 708

local function Clamp(Value, MinValue, MaxValue)
  return math.max(MinValue, math.min(Value, MaxValue))
end

local function SafeSetVisibility(Widget, Visibility)
  if Widget then
    Widget:SetVisibility(Visibility)
  end
end

local function SafeSetText(Widget, TextMapId)
  if Widget then
    Widget:SetText(GText(TextMapId))
  end
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

function M:SetHammerPlayerInteractive(bInteractive)
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not PlayerCharacter then
    return
  end
  if bInteractive then
    PlayerCharacter:SetCharacterTag("Interactive")
  else
    PlayerCharacter:SetCharacterTagIdle()
  end
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
  self.CurrentComboKeys = {}
  self.PressedComboKeys = {}
  self:CacheBarLayout()
  self:InitButtonEvents()
  self:InitTextMap()
  self:InitPlatform()
  self:SetHammerPlayerInteractive(true)
  self:RefreshHammerProgress(0, 0)
  self:SetHammerInputEnabled(false)
  self:RefreshComboCount()
  self.Btn_Crack:SetVisibility(self.bCanCrack and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  local Bar = self.Bar
  if Bar then
    SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.Collapsed)
    SafeSetVisibility(Bar.Panel_Key, UE4.ESlateVisibility.Collapsed)
    SafeSetVisibility(Bar.Panel_Perfect, UE4.ESlateVisibility.Collapsed)
  end
end

function M:CacheBarLayout()
  if not self.Bar then
    return
  end
  self.RangeWidget = self.Bar.Panel_Range
  self.ProgressWidget = self.Bar.Panel_Progress
  self.RangeSlot = self.RangeWidget and UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.RangeWidget) or nil
  self.ProgressSlot = self.ProgressWidget and UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.ProgressWidget) or nil
  self.RangeBasePosition = self.RangeSlot and self.RangeSlot:GetPosition() or FVector2D(0, 0)
  self.ProgressBaseSize = self.ProgressSlot and self.ProgressSlot:GetSize() or FVector2D(0, 0)
  self.RangeBaseRenderTranslation = self.RangeWidget and self.RangeWidget.RenderTransform and self.RangeWidget.RenderTransform.Translation or FVector2D(0, 0)
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
    SafeSetText(self.Bar.Text_Perfect, "Hammer_Perfect")
  end
  if self.Btn_Start then
    SafeSetText(self.Btn_Start.Text_Button, self:GetHammerStartTextMap())
  end
  if self.Btn_Crack then
    SafeSetText(self.Btn_Crack.Text_Button, "Hammer_Crack")
  end
  if self.Combo then
    SafeSetText(self.Combo.Text_Desc, "Hammer_Count")
  end
  self:SetHammerTipText(self:GetHammerInputTipTextMap())
end

function M:InitPlatform()
end

function M:GetHammerStartTextMap()
  return "Hammer_Start"
end

function M:SetHammerTipText(TextMapId)
  if self.Tip then
    SafeSetText(self.Tip.Text_Tip, TextMapId)
  end
end

function M:GetHammerInputTipTextMap()
  return "Hammer_InfoClick"
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
  self.bHammerStarted = true
  self:OnHammerGameStarted()
  self.UseActor:OnHammerStart(self.UseActor.PlayerEid)
end

function M:OnHammerGameStarted()
end

function M:OnCrackButtonClicked()
  if not (not self.bHammerGameEnded and self.UseActor) or not self.bCanCrack then
    return
  end
  self.UseActor:OnHammerCrack(self.UseActor.PlayerEid)
end

function M:OnCloseButtonClicked()
  if self.bHammerGameEnded then
    return
  end
  if not self.UseActor then
    if self.Close then
      self:Close()
    end
    return
  end
  self.bHammerCloseNotifiedActor = true
  self.UseActor:OnHammerCancel(self.UseActor.PlayerEid)
end

function M:SubmitHammerInput(InputKey)
  if not (self.bHammerStarted and self.bHammerInputEnabled) or self.bHammerInputLocked or self.bHammerGameEnded then
    return
  end
  self.UseActor:OnHammerInput(string.upper(InputKey))
end

function M:RefreshHammerProgress(Progress, MarkerValue)
  local ProgressMax = self.UseActor and self.UseActor.ProgressMax or 1
  local MarkerRatio = Clamp(MarkerValue / ProgressMax, 0, 1)
  if self.ProgressSlot and self.ProgressBaseSize then
    local ProgressSize = FVector2D(self.ProgressBaseSize.X, BAR_HEIGHT * MarkerRatio)
    self.ProgressSlot:SetSize(ProgressSize)
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
    SafeSetVisibility(Bar.Panel_Key, UE4.ESlateVisibility.Collapsed)
  end
end

function M:ShowNextInputHint(ComboText, KeyPosition)
  self.CurrentComboKeys = ParseComboKeys(ComboText)
  self.PressedComboKeys = {}
  self:RefreshHammerKeyPosition(KeyPosition)
  self:RefreshComboKeyHints()
  self:SetHammerInputEnabled(true)
  local Bar = self.Bar
  if Bar then
    SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.SelfHitTestInvisible)
    SafeSetVisibility(Bar.Panel_Key, UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:RefreshInitialInputHint()
  if not self.UseActor or not self.UseActor.CurrentInputComboText then
    return
  end
  self.CurrentComboKeys = ParseComboKeys(self.UseActor.CurrentInputComboText)
  self.PressedComboKeys = {}
  self:RefreshHammerKeyPosition(self.UseActor.CurrentKeyDisplayPos or 0)
  self:RefreshComboKeyHints()
  self:SetHammerInputEnabled(true)
  local Bar = self.Bar
  if Bar then
    SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.SelfHitTestInvisible)
    SafeSetVisibility(Bar.Panel_Key, UE4.ESlateVisibility.SelfHitTestInvisible)
    SafeSetVisibility(Bar.Panel_Perfect, UE4.ESlateVisibility.Collapsed)
  end
end

function M:RefreshComboKeyHints()
end

function M:SetHammerInputEnabled(bEnabled)
  self.bHammerInputEnabled = bEnabled
  self:RefreshHammerButtonEnabled()
end

function M:RefreshHammerButtonEnabled()
  self.Btn_Start.Btn_Click:SetIsEnabled(not self.bHammerStarted or self.bHammerInputEnabled and not self.bHammerInputLocked and not self.bHammerGameEnded)
  self.Btn_Crack.Btn_Click:SetIsEnabled(self.bCanCrack and not self.bHammerGameEnded)
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
end

function M:ShowHammerHitResult(ResultType)
  self.PressedComboKeys = {}
  self:RefreshComboCount()
  if "Perfect" == ResultType then
    self:SetHammerInputEnabled(false)
    local Bar = self.Bar
    if Bar then
      SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.Collapsed)
      SafeSetVisibility(Bar.Panel_Key, UE4.ESlateVisibility.Collapsed)
      SafeSetVisibility(Bar.Panel_Perfect, UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  else
    if "Normal" == ResultType then
      self:SetHammerInputEnabled(false)
      local Bar = self.Bar
      if Bar then
        SafeSetVisibility(Bar.Panel_Range, UE4.ESlateVisibility.Collapsed)
        SafeSetVisibility(Bar.Panel_Key, UE4.ESlateVisibility.Collapsed)
      end
    else
    end
  end
end

function M:RefreshComboCount()
  local ComboCount = self.UseActor and self.UseActor.HammerHitCount or 0
  self.Combo.Text_Num:SetText(tostring(ComboCount))
end

function M:ShowHammerGameEnd(bSuccess, bSkipNotifyActor)
  self.bHammerGameEnded = true
  self.bHammerInputEnabled = false
  self:RefreshHammerButtonEnabled()
  if bSuccess then
  else
  end
  if not bSkipNotifyActor and self.UseActor then
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
  self:SetHammerPlayerInteractive(false)
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
