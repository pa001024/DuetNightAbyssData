local M = {}
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
M.IsGamePad = false

function M:InitGamePadCompoment()
  if not self.GameInputModeSubsystem then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  self:AddInputMethodChangedListen()
  local CurInputDevice = self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetCurrentInputType() or ECommonInputType.MouseAndKeyboard
  self:RefreshOpInfoByInputDevice(CurInputDevice)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamePad then
    self:FreshGamepadView()
  else
    self:FreshKeyBoardView()
  end
end

function M:FreshGamepadView()
  if not self.bGamepadFirstInited then
    self:FirstInitGamePadView()
    self.bGamepadFirstInited = true
  end
  self:RefreshGamepadPromptState()
end

function M:FreshKeyBoardView()
  self.bBoardHeadMenuOpen = false
  self:PlayAnimation(self.Normal)
  if self.Group_KeyHead then
    self.Group_KeyHead:SetVisibility(UIConst.VisibilityOp.Hidden)
  end
  if self.Btn_Apply and self.Btn_Apply.SetGamepadIconVisibility then
    self.Btn_Apply:SetGamepadIconVisibility(false)
  end
  if self.Btn_Share and self.Btn_Share.SetGamepadIconVisibility then
    self.Btn_Share:SetGamepadIconVisibility(false)
  end
end

function M:FirstInitGamePadView()
  if self.Btn_Apply and self.Btn_Apply.SetGamePadImg then
    self.Btn_Apply:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonBottom)
  end
  if self.Btn_Share and self.Btn_Share.SetGamePadImg then
    self.Btn_Share:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonBottom)
  end
  self.Key_Head:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if not self.IsGamePad then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  self:PlayAnimation(self.Hover)
  self:RefreshGamepadPromptState()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusLost(InFocusEvent)
  if not self.IsGamePad then
    return
  end
  self:PlayAnimation(self.Unhover)
  self:RefreshGamepadPromptState()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if not self.IsGamePad then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.bBoardHeadMenuOpen then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  if self.Team_Head:HandleGamepadHeadFocusInput(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft and self.Team_Head:EnterGamepadHeadFocus() then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    local ActionButton = self.bMineDetailMode and self.Btn_Share or self.Btn_Apply
    if ActionButton and type(ActionButton.OnBtnClicked) == "function" then
      ActionButton:OnBtnClicked()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:SetBoardHeadFocusPromptVisible(bVisible)
  self:RefreshGamepadPromptState()
end

function M:OnBoardHeadMenuOpenChanged(bOpen)
  self.bBoardHeadMenuOpen = bOpen
  if self.TeamBoardOwner and self.TeamBoardOwner.OnRecruitmentPlayerMenuOpenChanged then
    self.TeamBoardOwner:OnRecruitmentPlayerMenuOpenChanged(self, bOpen)
  end
  self:RefreshGamepadPromptState()
end

function M:RefreshGamepadPromptState()
  if not self.IsGamePad then
    if self.Group_KeyHead then
      self.Group_KeyHead:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Btn_Apply and self.Btn_Apply.SetGamepadIconVisibility then
      self.Btn_Apply:SetGamepadIconVisibility(false)
    end
    if self.Btn_Share and self.Btn_Share.SetGamepadIconVisibility then
      self.Btn_Share:SetGamepadIconVisibility(false)
    end
    return
  end
  local bHasItemFocus = self:HasAnyUserFocus()
  local bHasHeadFocus = self.Team_Head:HasGamepadHeadFocus()
  local bShowItemPrompt = bHasItemFocus and not bHasHeadFocus and not self.bBoardHeadMenuOpen
  self.Group_KeyHead:SetVisibility(bShowItemPrompt and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Hidden)
  if self.Btn_Apply and self.Btn_Apply.SetGamepadIconVisibility then
    self.Btn_Apply:SetGamepadIconVisibility(bShowItemPrompt)
  end
  if self.Btn_Share and self.Btn_Share.SetGamepadIconVisibility then
    self.Btn_Share:SetGamepadIconVisibility(bShowItemPrompt)
  end
  if not self.TeamBoardOwner then
    return
  end
  if self.bBoardHeadMenuOpen then
    self.TeamBoardOwner:UpdateTeamBoardBottomKeyInfo("Menu")
  elseif bHasHeadFocus then
    self.TeamBoardOwner:UpdateTeamBoardBottomKeyInfo("Head")
  elseif bShowItemPrompt then
    self.TeamBoardOwner:UpdateTeamBoardBottomKeyInfo("Item")
  else
    self.TeamBoardOwner:UpdateTeamBoardBottomKeyInfo("Default")
  end
end

return M
