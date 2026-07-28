require("UnLua")
local M = Class("BluePrints.UI.WBP.Memory.WBP_Memory_AnimeRoom_Base_C")

function M:Construct()
  M.Super.Construct(self)
  self.List_Anime.BP_OnItemIsHoveredChanged:Add(self, self.OnItemIsHoveredChanged)
  self.List_Anime.BP_OnEntryGenerated:Add(self, self.OnAnimeEntryGenerated)
end

function M:Destruct()
  M.Super.Destruct(self)
  self.List_Anime.BP_OnItemIsHoveredChanged:Remove(self, self.OnItemIsHoveredChanged)
  self.List_Anime.BP_OnEntryGenerated:Remove(self, self.OnAnimeEntryGenerated)
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:RefreshBaseInfo()
end

function M:OnInAnimationFinished()
  M.Super.OnInAnimationFinished(self)
  self:SetFocus()
  if self.UsingGamepad then
    self:SetFocusTarget()
  end
end

function M:OnItemIsHoveredChanged(Item, IsHovered)
  if not IsHovered then
    return
  end
  if self._PendingFocusAfterListRefresh == true then
    return
  end
  self.FocusedIndex = Item.Index
end

function M:RefreshBaseInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType(), GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.UsingGamepad = CurInputDevice == ECommonInputType.Gamepad
  self.Memory_Slider:UpdateUIStyleInPlatform(self.UsingGamepad, CurGamepadName)
  if self.UsingGamepad then
    self:SetFocusTarget()
  end
end

function M:ShouldFocus()
  return not IsValid(self.ReviewDialog)
end

function M:GotFocus()
  return self:HasAnyUserFocus() or self:HasFocusedDescendants()
end

function M:SetFocusTarget()
  if not self:ShouldFocus() then
    return
  end
  if not self:GotFocus() then
    self:SetFocus()
  end
  if self:GotFocus() then
    local Index = self.FocusedIndex or 1
    self.List_Anime:NavigateToIndex(Index - 1)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.UsingGamepad then
    self:SetFocusTarget()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnimeEntryGenerated(EntryUI)
  if self._PendingFocusAfterListRefresh ~= true then
    return
  end
  if not IsValid(EntryUI) then
    return
  end
  self._PendingFocusAfterListRefresh = false
  self:SetFocusTarget()
  local Index = self.FocusedIndex or 1
  self.List_Anime:SetScrollOffset(Index - 1)
end

function M:RefreshAnimeList()
  M.Super.RefreshAnimeList(self)
  self._PendingFocusAfterListRefresh = true
  self.FocusedIndex = nil
  self.MoveDeltaX = 0
  self.MoveDeltaY = 0
  self.LeftStickNavigateTimer = nil
end

function M:HandleAnimeListNavigate(InKeyName)
  local Index = self.FocusedIndex or 1
  local TargetIndex, BackupTargetIndex
  if InKeyName == UIConst.GamePadKey.DPadLeft or InKeyName == UIConst.GamePadKey.LeftStickLeft then
    TargetIndex = Index - 2
    BackupTargetIndex = Index - 1
  elseif InKeyName == UIConst.GamePadKey.DPadRight or InKeyName == UIConst.GamePadKey.LeftStickRight then
    TargetIndex = Index + 2
    BackupTargetIndex = Index + 1
  elseif (InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.LeftStickDown) and 1 == Index % 2 then
    TargetIndex = Index + 1
    BackupTargetIndex = Index - 1
  elseif (InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.LeftStickUp) and 0 == Index % 2 then
    TargetIndex = Index + 1
    BackupTargetIndex = Index - 1
  end
  if not TargetIndex then
    return false
  end
  if TargetIndex < 1 or TargetIndex > #self.CinematicIdList then
    TargetIndex = BackupTargetIndex
  end
  if not TargetIndex or TargetIndex < 1 or TargetIndex > #self.CinematicIdList then
    return false
  end
  self.List_Anime:NavigateToIndex(TargetIndex - 1)
  return true
end

function M:CheckLeftStickKeyName()
  local InKeyName
  if self.MoveDeltaX > 0.5 then
    InKeyName = UIConst.GamePadKey.LeftStickRight
  elseif self.MoveDeltaX < -0.5 then
    InKeyName = UIConst.GamePadKey.LeftStickLeft
  end
  if not InKeyName then
    if self.MoveDeltaY > 0.5 then
      InKeyName = UIConst.GamePadKey.LeftStickUp
    elseif self.MoveDeltaY < -0.5 then
      InKeyName = UIConst.GamePadKey.LeftStickDown
    end
  end
  return InKeyName
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_LeftX" == InKeyName then
    self.MoveDeltaX = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  elseif "Gamepad_LeftY" == InKeyName then
    self.MoveDeltaY = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local NavigateKeyName = self:CheckLeftStickKeyName()
  if not NavigateKeyName then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  if self.LeftStickNavigateTimer then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  self.LeftStickNavigateTimer = self:AddTimer(0.2, function()
    self.LeftStickNavigateTimer = nil
  end, nil, nil, nil, true)
  local IsEventHandled = self:HandleAnimeListNavigate(NavigateKeyName)
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local IsEventHandled = self:HandleAnimeListNavigate(InKeyName)
    if IsEventHandled then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamepadKeyDown(InKeyName)
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:OnClickClose()
  else
    IsEventHandled = self.Com_Tab:Handle_KeyEventOnPC(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnGamepadKeyDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_FaceButton_Right" == InKeyName then
    IsEventHandled = true
    self:OnClickClose()
  else
    IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    IsEventHandled = IsEventHandled or self.Memory_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
  end
  return IsEventHandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local IsEventHandled = self.Memory_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
    if IsEventHandled then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
