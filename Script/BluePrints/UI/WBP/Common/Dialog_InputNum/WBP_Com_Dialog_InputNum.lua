require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local CONST = {PWD_LEN = 6}

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
    if Widget and Widget.Btn_Click then
      Widget:BindEventOnClicked(self, function()
        self:OnNumClick(i)
      end)
    end
  end
  self.Btn_Confirm:SetText(GText("UI_PATCH_ENSURE"))
  self.Btn_Erase:BindEventOnClicked(self, self.OnBackspaceClick)
  self.Btn_Clear:BindEventOnClicked(self, self.OnClearClick)
  self.Btn_Confirm:BindEventOnClicked(self, self.OnConfirmClick)
  self.Btn_Erase:BindForbidStateExecuteEvent(self, self.OnBackspaceClick)
  self.Btn_Clear:BindForbidStateExecuteEvent(self, self.OnClearClick)
  self.Btn_Confirm:BindForbidStateExecuteEvent(self, self.OnConfirmClick)
  if self.Btn_Forget then
    self.Btn_Forget:BindEventOnClicked(self, self.OnForgetClick)
  end
  self.Btn_Confirm:SetDefaultGamePadImg("Y")
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
end

function M:OnLoaded(...)
  local Mode, Params = ...
  self.CurrentMode = Mode or UIConst.InputNumMode.VERIFY_PWD
  self.TextLimit = Params and Params.TextLimit or 9999
  self.Params = Params or {}
  self.InputBuffer = {
    [1] = "",
    [2] = ""
  }
  self.FocusIndex = 1
  self:UpdateLayout()
  if self.CurrentMode == UIConst.InputNumMode.NUMBER and self.Params.InitVal then
    self:SetInputText(tostring(self.Params.InitVal))
  end
  if self.In then
    self:PlayAnimation(self.In)
  end
end

function M:UpdateLayout()
  local TitleText = "TextMap"
  if self.CurrentMode == UIConst.InputNumMode.NUMBER then
    TitleText = "UI_Number_TextInNumber"
  end
  if self.Title and TitleText then
    self.Title:InitContent(nil, {Title = TitleText}, self)
    self.Title:BindOnCloseButtonClicked(self, self.CloseSelf)
  end
  local bIsPwdMode = self.CurrentMode ~= UIConst.InputNumMode.NUMBER
  if self.Btn_Forget then
    self.Btn_Forget:SetVisibility(self.CurrentMode == UIConst.InputNumMode.VERIFY_PWD and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
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
    local Slot = self.Pos_Panel:AddChildToOverlay(self.ContentWidget)
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    if bIsPwdMode and self.ContentWidget.InitRows then
      self.ContentWidget:InitRows(self.CurrentMode)
    else
      self.TargetInputBox = self.ContentWidget.Text_Input
      if self.ContentWidget.Text_Input then
        self.ContentWidget.Text_Input.OnTextChanged:Add(self, function(Widget, Text)
          self.InputBuffer[1] = Text
          self:UpdateButtonState()
        end)
      end
    end
  end
  self:RefreshDisplay()
end

function M:RefreshDisplay()
  if not self.ContentWidget then
    return
  end
  local CurrentStr = self.InputBuffer[self.FocusIndex]
  if self.CurrentMode == UIConst.InputNumMode.NUMBER then
    if self.ContentWidget.SetText then
      self.ContentWidget:SetText(CurrentStr)
    end
    self.ContentWidget:Init({
      TextLimit = self.TextLimit,
      OwnerPanel = self
    })
  else
    local RowCount = self.CurrentMode == UIConst.InputNumMode.ENABLE_PWD and 2 or 1
    for i = 1, RowCount do
      if self.ContentWidget and self.ContentWidget.UpdateRowText then
        self.ContentWidget:UpdateRowText(1, self.InputBuffer[1])
        if self.CurrentMode == UIConst.InputNumMode.ENABLE_PWD then
          self.ContentWidget:UpdateRowText(2, self.InputBuffer[2])
        end
      end
    end
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
    return
  end
  local Str = self.InputBuffer[self.FocusIndex]
  local MaxLen = CONST.PWD_LEN
  if MaxLen <= string.len(Str) then
    return
  end
  local NewStr = Str .. tostring(NumVal)
  if self.CurrentMode == UIConst.InputNumMode.NUMBER then
    local Val = tonumber(NewStr)
    NewStr = tostring(Val)
  end
  self.InputBuffer[self.FocusIndex] = NewStr
  self:RefreshDisplay()
  if self.CurrentMode == UIConst.InputNumMode.ENABLE_PWD and string.len(NewStr) == CONST.PWD_LEN and 1 == self.FocusIndex then
    self:SwitchFocus(2)
  end
end

function M:OnBackspaceClick()
  if self.Btn_Erase.IsBtnForbidden and self.Btn_Erase:IsBtnForbidden() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_Number_NothingToDelete"))
    return
  end
  if self.CurrentMode == UIConst.InputNumMode.NUMBER and self.ContentWidget then
    self.ContentWidget:DeleteTextBack()
    self.InputBuffer[1] = self.ContentWidget:GetText()
    return
  end
  local Str = self.InputBuffer[self.FocusIndex]
  if "" == Str then
    return
  end
  self.InputBuffer[self.FocusIndex] = string.sub(Str, 1, -2)
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
  self:RefreshDisplay()
end

function M:SwitchFocus(NewIndex)
  if self.CurrentMode ~= UIConst.InputNumMode.ENABLE_PWD then
    return
  end
  self.FocusIndex = NewIndex
  self:RefreshDisplay()
end

function M:OnConfirmClick()
  if self.Btn_Confirm.IsBtnForbidden and self.Btn_Confirm:IsBtnForbidden() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_Number_EmptyNumber"))
    return
  end
  local Str1 = self.InputBuffer[1]
  local Str2 = self.InputBuffer[2]
  if self.CurrentMode == UIConst.InputNumMode.NUMBER then
    local Val = tonumber(Str1)
    local Min = self.Params.Min or 0
    local Max = self.Params.Max or 99999
    if Val < Min then
      Val = Min
    end
    if Max < Val then
      Val = Max
    end
    self:OnSuccess(Val)
    return
  end
  if string.len(Str1) < CONST.PWD_LEN then
    self:ShowTip("请完整输入密码", true)
    return
  end
  if self.CurrentMode == UIConst.InputNumMode.ENABLE_PWD then
    if string.len(Str2) < CONST.PWD_LEN then
      self:ShowTip("请完整输入确认密码", true)
      return
    end
    if Str1 ~= Str2 then
      self:ShowTip("两次输入的密码不一致", true)
      self.InputBuffer[2] = ""
      self:SwitchFocus(2)
      return
    end
    self:OnSuccess(Str1)
  elseif self.CurrentMode == UIConst.InputNumMode.VERIFY_PWD then
    self:OnSuccess(Str1)
  end
end

function M:OnSuccess(Result)
  if self.Params.ConfirmCB and self.Params.ConfirmCB.Obj and self.Params.ConfirmCB.Func then
    self.Params.ConfirmCB.Func(self.Params.ConfirmCB.Obj, Result)
  end
  Utils.ScreenPrint("InputResult: " .. tostring(Result))
  self:CloseSelf()
end

function M:CloseSelf()
  if self.Out then
    self:PlayAnimation(self.Out)
  else
    self:Close()
  end
  if self.Params.CloseCB then
    self.Params.CloseCB()
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    M.Super.Close(self)
  elseif InAnimation == self.In or InAnimation == self.Change then
  end
end

function M:UpdateButtonState()
  local HasContent = false
  if self.CurrentMode == UIConst.InputNumMode.NUMBER then
    HasContent = self.InputBuffer[1] ~= nil and self.InputBuffer[1] ~= ""
  else
    HasContent = self.InputBuffer[1] ~= nil and self.InputBuffer[1] ~= "" and (self.CurrentMode ~= UIConst.InputNumMode.ENABLE_PWD or self.InputBuffer[2] ~= nil and self.InputBuffer[2] ~= "")
  end
  if self.Btn_Confirm and self.Btn_Confirm.ForbidBtn then
    self.Btn_Confirm:ForbidBtn(not HasContent)
  end
  if self.Btn_Clear and self.Btn_Clear.ForbidBtn then
    self.Btn_Clear:ForbidBtn(not HasContent)
  end
  if self.Btn_Erase and self.Btn_Erase.ForbidBtn then
    self.Btn_Erase:ForbidBtn(not HasContent)
  end
  if self.Controller_Clear and self.Controller_Clear.DisableKey then
    if HasContent then
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

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = Key.KeyName
  if "Backspace" == KeyName then
    self:OnBackspaceClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Enter" == KeyName or "NumPadEnter" == KeyName or KeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnConfirmClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Escape" == KeyName or KeyName == UIConst.GamePadKey.FaceButtonRight then
    self:CloseSelf()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif KeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:OnClearClick()
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
