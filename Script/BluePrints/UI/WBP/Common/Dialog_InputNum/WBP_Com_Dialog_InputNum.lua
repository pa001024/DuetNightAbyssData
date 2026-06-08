require("UnLua")
local SecondaryPasswordController = require("BluePrints.UI.WBP.Common.Dialog_InputNum.SecondaryPasswordController")
local M = Class("BluePrints.UI.BP_UIState_C")
local CONST = {PWD_LEN = 6}
local KEY_MAP = {
  Zero = 0,
  One = 1,
  Two = 2,
  Three = 3,
  Four = 4,
  Five = 5,
  Six = 6,
  Seven = 7,
  Eight = 8,
  Nine = 9,
  NumPadZero = 0,
  NumPadOne = 1,
  NumPadTwo = 2,
  NumPadThree = 3,
  NumPadFour = 4,
  NumPadFive = 5,
  NumPadSix = 6,
  NumPadSeven = 7,
  NumPadEight = 8,
  NumPadNine = 9
}

function M:Construct()
  M.Super.Construct(self)
  self.CurrentMode = UIConst.InputNumMode.VERIFY_PWD
  self.InputBuffer = {
    [1] = "",
    [2] = ""
  }
  self.FocusIndex = 1
  self.Params = {}
  for i = 0, 9 do
    local WidgetName = "Num_" .. i
    local Widget = self[WidgetName]
    if Widget then
      Widget:SetGamepadIconVisibility(false)
      if Widget.Btn_Click then
        Widget:BindEventOnClicked(self, function()
          self:OnNumClick(i)
        end)
      end
    end
  end
  self.Btn_Confirm:SetText(GText("UI_PATCH_ENSURE"))
  self.Btn_Erase:BindEventOnClicked(self, self.OnBackspaceClick)
  self.Btn_Clear:BindEventOnClicked(self, self.OnClearClick)
  self.Btn_Confirm:BindEventOnClicked(self, self.OnConfirmClick)
  self.Btn_Erase:BindForbidStateExecuteEvent(self, self.OnBackspaceClick)
  self.Btn_Clear:BindForbidStateExecuteEvent(self, self.OnClearClick)
  self.Btn_Confirm:BindForbidStateExecuteEvent(self, self.OnConfirmClick)
  self.Btn_Forget:SetText(GText("UI_SecPwd_ForgetPwd"))
  self.Btn_Forget:BindEventOnClicked(self, self.OnClickSupport)
  self.Btn_Erase:SetDefaultGamePadImg("RB")
  self.Btn_Erase:SetGamepadIconVisibility(true)
  self.Btn_Confirm:SetDefaultGamePadImg("Y")
  self.Btn_Forget:SetDefaultGamePadImg("View")
  self.Controller_Clear:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.Key_Confirm:CreateSubKeyDesc({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    },
    Type = "Img",
    Desc = GText("UI_Number_ConfirmText")
  })
  self.Key_Close:CreateSubKeyDesc({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Type = "Img",
    Desc = GText("UI_Controller_Close")
  })
  self.CursorLine = 0
  self.CursorOffset = 0
  self.TargetInputBox = nil
  self.bHasConfirmed = false
end

function M:OnLoaded(...)
  local Mode, Params = ...
  self.Params = Params or {}
  self.CurrentMode = Mode or UIConst.InputNumMode.NUMBER
  if self.Params.TextLimit then
    self.TextLimit = self.Params.TextLimit
  elseif self.Params.Max then
    local MaxVal = math.floor(tonumber(self.Params.Max) or 0)
    self.TextLimit = string.len(tostring(MaxVal)) + 1
  else
    self.TextLimit = 9999
  end
  self:UnbindAllFromAnimationFinished(self.Out)
  self.bHasConfirmed = false
  self.bIsProcessing = false
  self.FocusIndex = 1
  self.InputBuffer = {
    [1] = "",
    [2] = ""
  }
  if self.CurrentMode == UIConst.InputNumMode.NUMBER and self.Params.InitVal then
    self.InputBuffer[1] = tostring(self.Params.InitVal)
  end
  self:UpdateLayout()
  self:RefreshDisplay()
  self:UpdateButtonState()
  self:InitGamepadNavigation()
  if self.In then
    self:PlayAnimation(self.In)
  end
end

function M:UpdateLayout()
  local TitleText = "TextMap"
  if self.CurrentMode == UIConst.InputNumMode.ENABLE_PWD then
    TitleText = "UI_SecPwd_SetPwdTitle"
    self.Btn_Confirm:SetText(GText("UI_SecPwd_ConfirmSetButton"))
  elseif self.CurrentMode == UIConst.InputNumMode.VERIFY_PWD then
    TitleText = "UI_SecPwd_PwdVerifyTitle"
    self.Btn_Confirm:SetText(GText("UI_PATCH_ENSURE"))
  elseif self.CurrentMode == UIConst.InputNumMode.DISABLE_PWD then
    TitleText = "UI_SecPwd_TurnoffPwdTitle"
    self.Btn_Confirm:SetText(GText("UI_SecPwd_ConfirmTurnoffButton"))
  elseif self.CurrentMode == UIConst.InputNumMode.NUMBER then
    TitleText = "UI_Number_TextInNumber"
    self.Btn_Confirm:SetText(GText("UI_PATCH_ENSURE"))
  end
  if self.Title and TitleText then
    self.Title:InitContent(nil, {Title = TitleText}, self)
    self.Title:BindOnCloseButtonClicked(self, self.CloseSelf)
  end
  local bIsPwdMode = self.CurrentMode ~= UIConst.InputNumMode.NUMBER
  if self.Btn_Forget then
    self.Btn_Forget:SetVisibility((self.CurrentMode == UIConst.InputNumMode.VERIFY_PWD or self.CurrentMode == UIConst.InputNumMode.DISABLE_PWD) and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
  end
  self.Pos_Panel:ClearChildren()
  local ContentWidgetPath
  if self.CurrentMode == UIConst.InputNumMode.NUMBER then
    ContentWidgetPath = "/Game/UI/WBP/Common/Dialog/Widget/InputNum/WBP_Com_Dialog_PanelNum.WBP_Com_Dialog_PanelNum"
  else
    ContentWidgetPath = "/Game/UI/WBP/Common/Dialog/Widget/InputNum/WBP_Com_Dialog_PanelPassword.WBP_Com_Dialog_PanelPassword"
  end
  if ContentWidgetPath then
    self.ContentWidget = UIManager(self):CreateWidget(ContentWidgetPath)
    if not self.ContentWidget then
      return
    end
    local Slot = self.Pos_Panel:AddChildToOverlay(self.ContentWidget)
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    if bIsPwdMode and self.ContentWidget.InitRows then
      self.ContentWidget:InitRows(self.CurrentMode, self)
    elseif self.CurrentMode == UIConst.InputNumMode.NUMBER and self.ContentWidget.Init then
      self.ContentWidget:Init({
        TextLimit = self.TextLimit,
        OwnerPanel = self,
        OnDataChanged = function(Text)
          self.InputBuffer[1] = Text
          self:UpdateButtonState()
        end
      })
    end
  end
end

function M:RefreshDisplay()
  if not self.ContentWidget then
    return
  end
  if self.CurrentMode == UIConst.InputNumMode.NUMBER then
    local CurrentStr = self.InputBuffer[self.FocusIndex]
    if self.ContentWidget.SetText then
      self.bIsSettingText = true
      self.ContentWidget:SetText(CurrentStr)
      self.bIsSettingText = false
    end
  elseif self.ContentWidget.UpdateView then
    self.ContentWidget:UpdateView(self.InputBuffer, self.FocusIndex)
  end
  self:UpdateButtonState()
end

function M:ShowTip(Msg, IsError)
  if not self.InputTip then
    return
  end
  self.InputTip:ShowMessage(Msg, IsError)
end

function M:HideTip()
  if not self.InputTip then
    return
  end
  self.InputTip:HideMessage()
end

function M:OnNumClick(NumVal)
  if self.CurrentMode == UIConst.InputNumMode.NUMBER and self.ContentWidget then
    self.ContentWidget:InsertTextAtCursor(tostring(NumVal))
    self.InputBuffer[1] = self.ContentWidget:GetText()
    self:UpdateButtonState()
    return
  end
  local Str = self.InputBuffer[self.FocusIndex]
  local MaxLen = CONST.PWD_LEN
  if MaxLen <= string.len(Str) then
    self:ShowTip("UI_Number_MaxNumber", false)
    return
  end
  local NewStr = Str .. tostring(NumVal)
  self.InputBuffer[self.FocusIndex] = NewStr
  if self.CurrentMode == UIConst.InputNumMode.ENABLE_PWD and string.len(NewStr) == CONST.PWD_LEN then
    if 1 == self.FocusIndex and string.len(self.InputBuffer[2]) < CONST.PWD_LEN then
      self.FocusIndex = 2
    elseif 2 == self.FocusIndex and string.len(self.InputBuffer[1]) < CONST.PWD_LEN then
      self.FocusIndex = 1
    end
  end
  self:HideTip()
  self:RefreshDisplay()
end

function M:OnBackspaceClick()
  if self.Btn_Erase.IsBtnForbidden and self.Btn_Erase:IsBtnForbidden() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_Number_NothingToDelete"))
    return
  end
  if self.CurrentMode == UIConst.InputNumMode.NUMBER and self.ContentWidget then
    self.ContentWidget:DeleteTextBack()
    self.InputBuffer[1] = self.ContentWidget:GetText()
    self:UpdateButtonState()
    return
  end
  local Str = self.InputBuffer[self.FocusIndex]
  if "" == Str then
    return
  end
  self.InputBuffer[self.FocusIndex] = string.sub(Str, 1, -2)
  self:HideTip()
  self:RefreshDisplay()
end

function M:OnClearClick()
  if self.Btn_Clear.IsBtnForbidden and self.Btn_Clear:IsBtnForbidden() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_Number_EmptyPassword"))
    return
  end
  self.InputBuffer[1] = ""
  self.InputBuffer[2] = ""
  self.FocusIndex = 1
  self:HideTip()
  self:RefreshDisplay()
end

function M:OnClickSupport()
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName()
  if "OpenHarmony" == PlatformName then
    HeroUSDKSubsystem(self):JumpInternalBrowser("kefu")
  else
    HeroUSDKSubsystem(self):OpenService()
  end
end

function M:SwitchFocus(NewIndex)
  if self.CurrentMode ~= UIConst.InputNumMode.ENABLE_PWD then
    return
  end
  if self.FocusIndex == NewIndex then
    return
  end
  self.FocusIndex = NewIndex
  self:RefreshDisplay()
end

function M:OnConfirmClick()
  if self.bIsProcessing then
    return
  end
  local Str1 = self.InputBuffer[1]
  local Str2 = self.InputBuffer[2]
  if self.CurrentMode == UIConst.InputNumMode.NUMBER then
    if "" == Str1 then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_Number_EmptyNumber"))
      return
    end
    local Val = tonumber(Str1)
    local Min = self.Params.Min or 0
    local Max = self.Params.Max or 99999
    if Val < Min then
      Val = Min
    end
    if Max < Val then
      Val = Max
    end
    self.bIsProcessing = true
    self:OnSuccess(Val)
    return
  end
  if string.len(Str1) < CONST.PWD_LEN then
    self:ShowTip("UI_Number_PasswordIncomplete", true)
    return
  end
  if self.CurrentMode == UIConst.InputNumMode.ENABLE_PWD then
    if string.len(Str2) < CONST.PWD_LEN then
      self:ShowTip("UI_Number_PasswordIncomplete", true)
      return
    end
    if Str1 ~= Str2 then
      self:ShowTip("UI_Number_PasswordConflict", true)
      return
    end
    self.bIsProcessing = true
    SecondaryPasswordController:EnableSecondaryPassword(function(Ret)
      if not ErrorCode:Check(Ret) then
        self.bIsProcessing = false
        return
      end
      self:OnSuccess(Str1)
    end, Str1)
  elseif self.CurrentMode == UIConst.InputNumMode.VERIFY_PWD or self.CurrentMode == UIConst.InputNumMode.DISABLE_PWD then
    self.bIsProcessing = true
    SecondaryPasswordController:ValidateSecondaryPasswordOnce(function(Ret)
      if Ret ~= ErrorCode.RET_SUCCESS then
        self.bIsProcessing = false
        if Ret == ErrorCode.RET_FAIL then
          local Text = GText("UI_SecPwd_WrongPwdAlert")
          local ErrorTimes = SecondaryPasswordController:GetSecondaryPasswordErrorTimes()
          local MaxErrorTimes = DataMgr.GlobalConstant.SecondaryPasswordAllowPasswordWrongTime.ConstantValue or 5
          local Warning = string.format(Text, tostring(MaxErrorTimes - ErrorTimes))
          self:ShowTip(Warning, true)
          if SecondaryPasswordController:CheckSecondaryPasswordFreeze() then
            self.bIsProcessing = true
            self:BindToAnimationFinished(self.Out, function()
              SecondaryPasswordController:OpenSecondaryPasswordColdDownPopup(self.Params.CancelCB)
            end)
            self:PlayOutAnimation()
          end
        end
        return
      end
      self:OnSuccess(Str1)
    end, Str1)
  end
end

function M:OnSuccess(Result)
  self.bHasConfirmed = true
  if self.CurrentMode == UIConst.InputNumMode.ENABLE_PWD then
    self:BindToAnimationFinished(self.Out, function()
      UIManager():ShowCommonPopupUI(100313)
    end)
  elseif self.CurrentMode == UIConst.InputNumMode.DISABLE_PWD then
  end
  if self.Params.ConfirmCB and self.Params.ConfirmCB.Func then
    if self.Params.ConfirmCB.Obj then
      self.Params.ConfirmCB.Func(self.Params.ConfirmCB.Obj, Result)
    else
      self.Params.ConfirmCB.Func(Result)
    end
  end
  self:CloseSelf()
end

function M:PlayOutAnimation()
  if self.Out then
    self:PlayAnimation(self.Out)
  else
    self:Close()
  end
end

function M:CloseSelf()
  self:PlayOutAnimation()
  if not self.bHasConfirmed and self.Params.CancelCB and self.Params.CancelCB.Func then
    if self.Params.CancelCB.Obj then
      self.Params.CancelCB.Func(self.Params.CancelCB.Obj)
    else
      self.Params.CancelCB.Func()
    end
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:Close()
  elseif InAnimation == self.In or InAnimation == self.Change then
  end
end

function M:UpdateButtonState()
  local Str1 = self.InputBuffer[1] or ""
  local Str2 = self.InputBuffer[2] or ""
  local CurrStr = self.InputBuffer[self.FocusIndex] or ""
  local PwdLen = CONST.PWD_LEN
  local bCanConfirm = false
  local bCanClear = false
  local bCanErase = false
  if self.CurrentMode == UIConst.InputNumMode.NUMBER then
    bCanConfirm = "" ~= Str1
  elseif self.CurrentMode == UIConst.InputNumMode.ENABLE_PWD then
    bCanConfirm = string.len(Str1) == PwdLen and string.len(Str2) == PwdLen
  else
    bCanConfirm = string.len(Str1) == PwdLen
  end
  bCanClear = "" ~= Str1 or "" ~= Str2
  bCanErase = "" ~= CurrStr
  if self.Btn_Confirm and self.Btn_Confirm.ForbidBtn then
    self.Btn_Confirm:ForbidBtn(not bCanConfirm)
  end
  if self.Btn_Clear and self.Btn_Clear.ForbidBtn then
    self.Btn_Clear:ForbidBtn(not bCanClear)
  end
  if self.Btn_Erase and self.Btn_Erase.ForbidBtn then
    self.Btn_Erase:ForbidBtn(not bCanErase)
  end
  if self.Controller_Clear and self.Controller_Clear.DisableKey then
    if bCanClear then
      self.Controller_Clear:EnableKey()
    else
      self.Controller_Clear:DisableKey()
    end
  end
end

function M:UpdateGamePadUIState(isGamePad)
  if isGamePad then
    self.Panel_Controller_Clear:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WBox_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Panel_Controller_Clear:SetVisibility(ESlateVisibility.Collapsed)
    self.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = Key.KeyName
  if "BackSpace" == KeyName then
    if self.CurrentMode ~= UIConst.InputNumMode.NUMBER then
      self:OnBackspaceClick()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif "Enter" == KeyName or "NumPadEnter" == KeyName or KeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnConfirmClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "SpaceBar" == KeyName then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = Key.KeyName
  local NumVal = KEY_MAP[KeyName]
  if NumVal then
    self:OnNumClick(NumVal)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if "Escape" == KeyName or KeyName == UIConst.GamePadKey.FaceButtonRight then
    self:CloseSelf()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif KeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:OnClearClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif KeyName == UIConst.GamePadKey.SpecialLeft then
    self:OnClickSupport()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif KeyName == UIConst.GamePadKey.RightShoulder then
    self:OnBackspaceClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self.TargetInputBox then
    self.TargetInputBox:SetKeyboardFocus()
  end
  if self.TargetComInput then
    self.TargetComInput:FocusInputField()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:InitGamepadNavigation()
  local function NavUpCallback()
    return self:OnNavigateUpFromKeypad()
  end
  
  local TopRowKeys = {
    self.Num_1,
    self.Num_2,
    self.Num_3
  }
  for _, Btn in ipairs(TopRowKeys) do
    if Btn then
      Btn:SetNavigationRuleCustom(EUINavigation.Up, NavUpCallback)
    end
  end
end

function M:OnNavigateUpFromKeypad()
  if self.CurrentMode ~= UIConst.InputNumMode.NUMBER and self.ContentWidget and self.ContentWidget.GetFocusTargetWidget then
    local TargetWidget = self.ContentWidget:GetFocusTargetWidget()
    if TargetWidget then
      return TargetWidget
    end
  end
  return nil
end

function M:GetKeypadEntryWidget()
  if self.Num_2 and self.Num_2.Btn_Click then
    return self.Num_2.Btn_Click
  end
  return self.Num_5.Btn_Click
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  local IsGamepadInput = CurInputType == ECommonInputType.Gamepad
  if IsGamepadInput then
    self:SetFocus()
  else
    if self.TargetInputBox then
      self.TargetInputBox:SetKeyboardFocus()
    end
    if self.TargetComInput then
      self.TargetComInput:FocusInputField()
    end
  end
  self:UpdateGamePadUIState(IsGamepadInput)
end

function M:BP_GetDesiredFocusTarget()
  return self.Num_1
end

return M
