local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.TitleText = self.Text_Title
  self.ConfirmButton = self.Btn_Select
  self.CloseButton = self.Btn_Close
  self.CloseKeySwitcher = self.WS_Type
  self.KeyboardCloseKey = self.Key_Close
  self.GamepadCloseKey = self.Controller_Close
  self.FadeInAnimation = self.In
  self.FadeOutAnimation = self.Out
  self.Btn_Select_01.OwnedAnimation = self.Owned_L
  self.Btn_Select_01.FocusedAnimation = self.SelectL_In
  self.Btn_Select_01.UnfocusedAnimation = self.SelectL_Out
  self.Btn_Select_02.OwnedAnimation = self.Owned_R
  self.Btn_Select_02.FocusedAnimation = self.SelectR_In
  self.Btn_Select_02.UnfocusedAnimation = self.SelectR_Out
  self.TitleText:SetText(GText("UI_LimitedPrizePool_PleaseSelectFirstPrize"))
  self.ConfirmButton:SetForbidden(true)
  self.ConfirmButton:BindClicked({
    self,
    self.ConfirmSelection
  })
  self.CloseButton:Init("Close", self, self.Close)
  self:BindToAnimationFinished(self.FadeOutAnimation, {
    self,
    self.RemoveFromParent
  })
  self.bHasOwned = false
  self.OwnedSwitchAnimation = nil
  self.OnConfirmSelection = nil
  self.OnClosed = nil
  self.PrizeItems = {
    self.Btn_Select_01,
    self.Btn_Select_02
  }
  for _, PrizeItem in ipairs(self.PrizeItems) do
    if IsValid(PrizeItem) then
      PrizeItem:BindSelectedChanged({
        self,
        self.HandlePrizeItemSelectedChanged
      })
      PrizeItem:BindViewDetails({
        self,
        self.HandlePrizeItemViewDetails
      })
    end
  end
end

function M:Destruct()
  for _, PrizeItem in ipairs(self.PrizeItems) do
    if IsValid(PrizeItem) then
      PrizeItem:UnbindSelectedChanged()
      PrizeItem:UnbindViewDetails()
    end
  end
  self.ConfirmButton:UnbindClicked()
  self:UnlistenInputTypeChanged()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
  if KeyName == UIConst.GamePadKey.LeftThumb then
    local SelectedItem = self:GetSelectedPrizeItem()
    if IsValid(SelectedItem) then
      SelectedItem:ViewDetails()
    end
  elseif KeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:ConfirmSelection()
  elseif KeyName == UIConst.GamePadKey.FaceButtonRight then
    self:Close()
  elseif "Escape" == KeyName then
    self:Close()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
  for _, PrizeItem in pairs(self.PrizeItems) do
    if IsValid(PrizeItem) and PrizeItem:HasKeyboardFocus() then
      PrizeItem:SetSelected(true)
      break
    end
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:Init(Prizes, OnConfirmSelection, OnClosed)
  for i, Prize in pairs(Prizes) do
    local PrizeItem = self.PrizeItems[i]
    if IsValid(PrizeItem) then
      PrizeItem:SetPrize(Prize)
    end
  end
  for _, PrizeItem in pairs(self.PrizeItems) do
    if IsValid(PrizeItem) and PrizeItem:IsOwned() then
      self.bHasOwned = true
      self.OwnedSwitchAnimation = PrizeItem.OwnedAnimation
      break
    end
  end
  self.OnConfirmSelection = OnConfirmSelection
  self.OnClosed = OnClosed
  if self.bHasOwned then
    local FirstNotOwnedPrizeItem = self:GetFirstNotOwnedPrizeItem()
    if IsValid(FirstNotOwnedPrizeItem) then
      FirstNotOwnedPrizeItem:SetSelected(true)
    end
  end
  self:SetFocus()
  self:ListenInputTypeChanged()
  self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
  self:PlayAnimation(self.FadeInAnimation)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/limit_gift_pool_sub_page_in", nil, nil)
end

function M:Close()
  if self:IsAnimationPlaying(self.FadeOutAnimation) then
    return
  end
  self:PlayAnimation(self.FadeOutAnimation)
  if self.OnClosed and self.OnClosed[1] and self.OnClosed[2] then
    self.OnClosed[2](self.OnClosed[1])
  end
end

function M:BindConfirmSelection(OnConfirmSelection)
  self.OnConfirmSelection = OnConfirmSelection
end

function M:UnbindConfirmSelection()
  self.OnConfirmSelection = nil
end

function M:HandlePrizeItemSelectedChanged(PrizeItem)
  if not IsValid(PrizeItem) then
    return
  end
  if PrizeItem:IsSelected() then
    if self.bHasOwned then
      self:PlayAnimation(self.OwnedSwitchAnimation)
    else
      self:PlayAnimation(PrizeItem.FocusedAnimation)
    end
    for _, Item in pairs(self.PrizeItems) do
      if IsValid(Item) and Item ~= PrizeItem and Item:IsOwned() == false then
        Item:SetSelected(false)
      end
    end
  elseif self.bHasOwned then
    self:PlayAnimationReverse(self.OwnedSwitchAnimation)
  else
    self:PlayAnimation(PrizeItem.UnfocusedAnimation)
  end
  self:UpdateConfirmButtonState()
end

function M:HandlePrizeItemViewDetails(PrizeItem)
  if not IsValid(PrizeItem) then
    return
  end
  local Prize = PrizeItem:GetPrize()
  if not Prize then
    return
  end
  local SkinPreviewUIName = "SkinPreview"
  EventManager:AddEvent(EventID.UnLoadUI, self, function(_, UIName)
    if UIName ~= SkinPreviewUIName then
      return
    end
    EventManager:RemoveEvent(EventID.UnLoadUI, self)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    PrizeItem:SetFocus()
  end)
  UIManager(self):LoadUINew(SkinPreviewUIName, {
    TypeId = Prize.Id,
    ItemType = Prize.Type,
    SinglePreview = true,
    HidePurchase = true
  })
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:ConfirmSelection()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm_positive", nil, nil)
  local SelectedItem = self:GetSelectedPrizeItem()
  if not IsValid(SelectedItem) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_LimitedPrizePool_PleaseSelectPrize"))
    return
  end
  if self.OnConfirmSelection and self.OnConfirmSelection[1] and self.OnConfirmSelection[2] then
    self.OnConfirmSelection[2](self.OnConfirmSelection[1], SelectedItem:GetPrize())
  end
end

function M:ListenInputTypeChanged()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SetInputType)
  end
end

function M:UnlistenInputTypeChanged()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SetInputType)
  end
end

function M:SetInputType(NewInputType, NewGamepadName)
  if NewInputType == ECommonInputType.Touch then
  elseif NewInputType == ECommonInputType.Gamepad then
    self.GamepadCloseKey:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.Close,
          Owner = self
        }
      },
      Desc = GText("UI_Tips_Close")
    })
    self.CloseKeySwitcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.CloseKeySwitcher:SetActiveWidget(self.GamepadCloseKey)
    local SelectedItem = self:GetSelectedPrizeItem()
    if SelectedItem then
      SelectedItem:SetFocus()
    else
      local FirstNotOwnedPrizeItem = self:GetFirstNotOwnedPrizeItem()
      if IsValid(FirstNotOwnedPrizeItem) then
        FirstNotOwnedPrizeItem:SetFocus()
        FirstNotOwnedPrizeItem:SetSelected(true)
      end
    end
  else
    self.KeyboardCloseKey:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.Close,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    })
    self.CloseKeySwitcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.CloseKeySwitcher:SetActiveWidget(self.KeyboardCloseKey)
  end
end

function M:UpdateConfirmButtonState()
  local bHasSelected = false
  for _, Item in pairs(self.PrizeItems) do
    if IsValid(Item) and Item:IsSelected() then
      bHasSelected = true
      break
    end
  end
  if bHasSelected then
    self.ConfirmButton:SetForbidden(false)
  else
    self.ConfirmButton:SetForbidden(true)
  end
end

function M:GetSelectedPrizeItem()
  for _, PrizeItem in pairs(self.PrizeItems) do
    if IsValid(PrizeItem) and PrizeItem:IsSelected() then
      return PrizeItem
    end
  end
  return nil
end

function M:GetFirstNotOwnedPrizeItem()
  for _, PrizeItem in pairs(self.PrizeItems) do
    if IsValid(PrizeItem) and not PrizeItem:IsOwned() then
      return PrizeItem
    end
  end
  return nil
end

return M
