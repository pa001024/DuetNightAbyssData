local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.SelectedPanel = self.Panel_Select
  self.SelectedIcon = self.Icon_Select3
  self.PrizeNameText = self.Text_Name
  self.CheckBoxButton = self.Btn_Select
  self.OwnedText = self.Text_Got
  self.ViewDetailsPanel = self.Panel_CheckDetail
  self.ViewDetailsSwitcher = self.WS_Type
  self.KeyboardViewDetailsKey = self.Btn_Check
  self.GamepadViewDetailsKey = self.Controller_Check
  self.ViewDetailsText = self.Text_CheckDetail
  self.ViewDetailsButton = self.Btn_CheckDetail
  self.ViewDetailsIconButton = self.Btn_Check
  self.SelectedAnimation = self.Select
  self.UnselectedAnimation = self.UnSelect
  self.NormalAnimation = self.Normal
  self.ClickedAnimation = self.Click
  self.PressedAnimation = self.Press
  self.ReleasedAnimation = self.UnPress
  self.HoverAnimation = self.Hover
  self.UnhoverAnimation = self.UnHover
  self.ForbiddenAnimation = self.Forbidden
  self.OwnedText:SetText(GText("UI_LimitedPrizePool_AlreadyGet"))
  self.ViewDetailsText:SetText(GText("UI_LimitedPrizePool_ViewDetails"))
  self.CheckBoxButton.OnClicked:Add(self, self.ToggleSelected)
  self.CheckBoxButton.OnPressed:Add(self, self.OnCheckBoxButtonPressed)
  self.CheckBoxButton.OnReleased:Add(self, self.OnCheckBoxButtonReleased)
  self.CheckBoxButton.OnHovered:Add(self, self.OnCheckBoxButtonHovered)
  self.CheckBoxButton.OnUnhovered:Add(self, self.OnCheckBoxButtonUnhovered)
  self.ViewDetailsButton.OnClicked:Add(self, self.ViewDetails)
  self.ViewDetailsIconButton:Init({
    ClickCallback = self.ViewDetails,
    OwnerWidget = self
  })
  self.SelectedPanel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.ViewDetailsPanel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.OwnedText:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Prize = nil
  self.bSelected = false
  self.bOwned = false
  self.OnSelectedChanged = nil
  self.OnViewDetails = nil
  self.LastAnimation = nil
  self:ListenInputTypeChanged()
  self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
end

function M:Destruct()
  self.CheckBoxButton.OnClicked:Remove(self, self.ToggleSelected)
  self.ViewDetailsButton.OnClicked:Remove(self, self.ViewDetails)
  self:UnlistenInputTypeChanged()
end

function M:SetPrize(Prize)
  if not Prize then
    return
  end
  self.Prize = Prize
  local ItemName = ItemUtils.GetItemName(Prize.Id, Prize.Type)
  self.PrizeNameText:SetText(GText(ItemName))
  local bOwned = false
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    bOwned = Avatar:CheckSkinEnough({
      [Prize.Id] = 1
    })
  end
  self:SetOwned(bOwned)
  self:SetSelected(Prize.bSelected)
end

function M:SetOwned(bOwned)
  if self.bOwned == bOwned then
    return
  end
  self.bOwned = bOwned
  if self.bOwned then
    self:PlayAnimation(self.ForbiddenAnimation)
    self.SelectedPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.ViewDetailsPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.OwnedText:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self:PlayAnimation(self.NormalAnimation)
    self.SelectedPanel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.ViewDetailsPanel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.OwnedText:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:SetSelected(bSelected)
  if self.bOwned or self.bSelected == bSelected then
    return
  end
  self.bSelected = bSelected
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/lingniao_btn_click_level_02", nil, nil)
  if self.bSelected then
    self:PlayAnimation(self.SelectedAnimation)
    self.GamepadViewDetailsKey:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self:PlayAnimation(self.UnselectedAnimation)
    self.GamepadViewDetailsKey:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.OnSelectedChanged and self.OnSelectedChanged[1] and self.OnSelectedChanged[2] then
    self.OnSelectedChanged[2](self.OnSelectedChanged[1], self)
  end
end

function M:GetPrize()
  return self.Prize
end

function M:IsOwned()
  return self.bOwned
end

function M:IsSelected()
  return self.bSelected
end

function M:BindSelectedChanged(OnSelectedChanged)
  self.OnSelectedChanged = OnSelectedChanged
end

function M:UnbindSelectedChanged()
  self.OnSelectedChanged = nil
end

function M:BindViewDetails(OnViewDetails)
  self.OnViewDetails = OnViewDetails
end

function M:UnbindViewDetails()
  self.OnViewDetails = nil
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
    self.ViewDetailsSwitcher:SetActiveWidget(self.KeyboardViewDetailsKey)
  elseif NewInputType == ECommonInputType.Gamepad then
    self.GamepadViewDetailsKey:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      }
    })
    self.ViewDetailsSwitcher:SetActiveWidget(self.GamepadViewDetailsKey)
  else
    self.ViewDetailsSwitcher:SetActiveWidget(self.KeyboardViewDetailsKey)
  end
end

function M:ToggleSelected()
  if self.bOwned then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_LimitedPrizePool_AlreadyGetPrize"))
    return
  end
  if self.LastAnimation then
    self:StopAnimation(self.LastAnimation)
  end
  self:PlayAnimation(self.ClickedAnimation)
  self.LastAnimation = self.ClickedAnimation
  self:SetSelected(not self.bSelected)
end

function M:OnCheckBoxButtonPressed()
  if self.bOwned then
    return
  end
  self:PlayAnimation(self.PressedAnimation)
end

function M:OnCheckBoxButtonReleased()
  if self.bOwned then
    return
  end
  self:PlayAnimation(self.ReleasedAnimation)
end

function M:OnCheckBoxButtonHovered()
  if self.bOwned then
    return
  end
  if self.LastAnimation then
    self:StopAnimation(self.LastAnimation)
  end
  self:PlayAnimation(self.HoverAnimation)
  self.LastAnimation = self.HoverAnimation
end

function M:OnCheckBoxButtonUnhovered()
  if self.bOwned then
    return
  end
  if self.LastAnimation then
    self:StopAnimation(self.LastAnimation)
  end
  self:PlayAnimation(self.UnhoverAnimation)
  self.LastAnimation = self.UnhoverAnimation
end

function M:ViewDetails()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  if self.OnViewDetails and self.OnViewDetails[1] and self.OnViewDetails[2] then
    self.OnViewDetails[2](self.OnViewDetails[1], self)
  end
end

return M
