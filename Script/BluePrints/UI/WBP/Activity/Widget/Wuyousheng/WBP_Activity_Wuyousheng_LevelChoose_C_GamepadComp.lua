local Component = {}

function Component:InitGamePad()
  if ModController:IsMobile() then
    return
  end
  self.Btn_Start.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.Key_Monster:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
end

function Component:HandleGamepadInput(InKeyName)
  local IsHandled = true
  if "Gamepad_FaceButton_Left" == InKeyName then
    if 1 ~= self.FocusMode then
      return true
    end
    self:BtnStartOnClicked()
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    if 1 ~= self.FocusMode then
      return true
    end
    self.Root.RewardText:OnBtnClicked()
  elseif "Gamepad_LeftThumbstick" == InKeyName then
    if 1 ~= self.FocusMode then
      return true
    end
    self.WidgetList[1]:SetFocus()
    self:ChangeFocusMode(2)
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if 1 == self.FocusMode then
      self:OnReturnKeyDown()
    elseif 2 == self.FocusMode then
      self:SetDefaultFocus()
    end
  else
    IsHandled = false
  end
  return IsHandled
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  self:SetDefaultFocus()
  self.IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
  if self.IsUseGamePad then
    self.Btn_Start.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_Monster:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Btn_Start.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_Monster:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function Component:SetDefaultFocus()
  if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
    return
  end
  self:ChangeFocusMode(1)
  if self.SelectedIndex and self.LevelTabList and self.LevelTabList[self.SelectedIndex] then
    self.LevelTabList[self.SelectedIndex]:SetFocus()
    return
  end
  local Item = self.HB_List:GetChildAt(0)
  if Item then
    Item.LevelTab_1:SetFocus()
  end
end

function Component:UpdateBottomKeyInfo(FocusMode)
  local BottomKeyInfo = {}
  if 1 == FocusMode then
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Root.OnReturnKeyDown,
            Owner = self.Root
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  elseif 2 == FocusMode then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Controller_CheckDetails"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Root.OnReturnKeyDown,
            Owner = self.Root
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  elseif 3 == FocusMode then
    BottomKeyInfo = {}
  end
  self.Root.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function Component:UpdateGamepadKeyInfo(FocusMode)
  if 1 == FocusMode then
    self.Btn_Start.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_Monster:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  elseif 2 == FocusMode then
    self.Btn_Start.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_Monster:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function Component:ChangeFocusMode(FocusMode)
  self.FocusMode = FocusMode
  self:UpdateBottomKeyInfo(self.FocusMode)
  self:UpdateGamepadKeyInfo(self.FocusMode)
end

return Component
