local UIUtils = require("Utils.UIUtils")
local M = {}
local FOCUS_FIRST_ITEM_TIMER_KEY = "AutoAssistFocusFirstItem"
local FOCUS_FIRST_ITEM_MAX_RETRY = 10

function M:InitAutoAssistGamepad()
  self.Btn_Edit:SetDefaultGamePadImg("Y")
  self.Btn_Save:SetDefaultGamePadImg("Y")
  self.Btn_Back:SetDefaultGamePadImg("B")
  if IsValid(self.Controller_Switch) and self.Controller_Switch.CreateCommonKey then
    self.Controller_Switch:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      }
    })
  end
  if IsValid(self.Controller_Description) then
    if self.Controller_Description.CreateGamepadKey then
      self.Controller_Description:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
    elseif self.Controller_Description.CreateCommonKey then
      self.Controller_Description:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.SpecialRight
          }
        }
      })
    end
  end
  self:RefreshAutoAssistGamepadHints()
  self:OnUpdateUIStyleByInputTypeChange(UIUtils.UtilsGetCurrentInputType())
end

function M:RefreshAutoAssistGamepadHints()
  if not IsValid(self.Key_Controller_Select) then
    return
  end
  local FocusedContent = self:GetFocusedAutoAssistItem()
  if FocusedContent then
    self.Key_Controller_Select:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = self.IsEdit and GText("UI_CTL_Select") or GText("编辑  待配")
    })
  end
  self.Key_Controller_Select:SetVisibility(FocusedContent and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if IsValid(self.Key_Controller_Back) then
    if self.IsEdit then
      self.Key_Controller_Back:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Key_Controller_Back:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK")
      })
      self.Key_Controller_Back:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
  if self.Key_Controller_Edit then
    self.Key_Controller_Edit:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:CanRecoverAutoAssistFocus()
  return IsValid(self.Owner) and self.Owner.CheckNeedAutoFocusWithInputType and self.Owner:CheckNeedAutoFocusWithInputType()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self.CurInputDeviceType = CurInputType
  self.CurGamepadName = CurGamepadName
  rawset(self, "FocusedAutoAssistItemContent", nil)
  local IsGamepad = CurInputType == ECommonInputType.Gamepad
  self.Panel_Controller:SetVisibility(IsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if IsValid(self.Controller_Switch) then
    self.Controller_Switch:SetVisibility(IsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if IsValid(self.Controller_Description) then
    self.Controller_Description:SetVisibility(IsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if IsGamepad then
    self:RefreshAutoAssistGamepadHints()
    if self:CanRecoverAutoAssistFocus() then
      self:RequestFocusAutoAssistList()
    end
  else
    self:CloseWeaponItemFocusTip()
    self.bAutoAssistToolFocus = false
  end
end

function M:FocusAutoAssistList()
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return true
  end
  self.bAutoAssistToolFocus = false
  rawset(self, "FocusedAutoAssistItemContent", nil)
  self:RefreshAutoAssistGamepadHints()
  if self.List_Item:GetNumItems() > 0 then
    local FirstItem = self.List_Item:GetItemAt(0)
    rawset(self, "FocusedAutoAssistItemContent", FirstItem)
    self:RefreshAutoAssistGamepadHints()
    if FirstItem and self.List_Item.BP_NavigateToItem then
      self.List_Item:BP_NavigateToItem(FirstItem)
    else
      self.List_Item:NavigateToIndex(0)
    end
    local FirstEntry = FirstItem and FirstItem.SelfWidget
    if IsValid(FirstEntry) then
      FirstEntry:SetFocus()
      self:OnAutoAssistItemFocused(FirstItem)
      return true
    end
    self.List_Item:SetFocus()
    return false
  else
    self:SetFocus()
  end
  return true
end

function M:RequestFocusAutoAssistList()
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  if self:FocusAutoAssistList() then
    return
  end
  local RetryCount = 0
  self:AddTimer(0.01, function()
    RetryCount = RetryCount + 1
    if self:FocusAutoAssistList() or RetryCount >= FOCUS_FIRST_ITEM_MAX_RETRY then
      self:RemoveTimer(FOCUS_FIRST_ITEM_TIMER_KEY)
    end
  end, true, 0, FOCUS_FIRST_ITEM_TIMER_KEY, true)
end

function M:FocusAutoAssistTools()
  if not self.IsEdit or self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  self.bAutoAssistToolFocus = true
  rawset(self, "FocusedAutoAssistItemContent", nil)
  self:RefreshAutoAssistGamepadHints()
  self.Sort:SetFocus()
end

function M:HandleAutoAssistGamepad(InKeyName)
  if "Gamepad_FaceButton_Right" == InKeyName then
    return self:HandleBack()
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    self.SwitchCheckBox:SetChecked(not self.SwitchCheckBox:GetChecked(), true)
    return true
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    if self.IsEdit then
      self:SaveChanges()
    else
      self:EnterEditMode()
    end
    return true
  elseif "Gamepad_LeftShoulder" == InKeyName or "Gamepad_RightShoulder" == InKeyName then
    return self.SubTab:Handle_KeyEventOnGamePad(InKeyName)
  elseif "Gamepad_Special_Right" == InKeyName then
    self:ShowDescription()
    return true
  elseif "Gamepad_LeftThumbstick" == InKeyName then
    if self.IsEdit then
      if self.bAutoAssistToolFocus then
        self:FocusAutoAssistList()
      else
        self:FocusAutoAssistTools()
      end
    end
    return true
  end
  return false
end

function M:HandleAutoAssistPreviewKey(InKeyName)
  if "Gamepad_FaceButton_Bottom" == InKeyName and not self.IsEdit and self:GetFocusedAutoAssistItem() then
    self:EnterEditMode()
    return true
  end
  return false
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:HandleAutoAssistPreviewKey(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:HandleAutoAssistGamepad(InKeyName)
  else
    IsHandled = self:HandleAutoAssistPC(InKeyName)
  end
  return IsHandled and UIUtils.Handled or UIUtils.Unhandled
end

return M
