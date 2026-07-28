require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
  self.Btn_Clear.OnClicked:Add(self, self.OnBtnClearClicked)
  self.Btn_Clear.OnHovered:Add(self, self.OnBtnClearHovered)
  self.Btn_Clear.OnUnhovered:Add(self, self.OnBtnClearUnhovered)
  self.Btn_Clear.OnPressed:Add(self, self.OnBtnClearPressed)
  self.Btn_Focus.OnClicked:Add(self, self.OnBtnFocusClicked)
  self.Btn_Focus.OnHovered:Add(self, self.OnBtnFocusHovered)
  self.Btn_Focus.OnUnhovered:Add(self, self.OnBtnFocusUnhovered)
end

function M:GetSelectionValueMode(ItemData)
  if ItemData and ItemData.SelectionValueMode then
    return ItemData.SelectionValueMode
  end
  if ItemData and ItemData.ShowItemIcon then
    return "Value"
  end
  return "Index"
end

function M:IsSameSelectionValue(ValueA, ValueB)
  return ValueA == ValueB or tostring(ValueA) == tostring(ValueB)
end

function M:GetSelectionIndexByValue(ItemData, SelectionValue)
  if not ItemData or not ItemData.SelectionDatas then
    return nil
  end
  for index, value in pairs(ItemData.SelectionDatas) do
    if self:IsSameSelectionValue(value, SelectionValue) then
      return index
    end
  end
  if ItemData.SelectionDatas[SelectionValue] ~= nil then
    return SelectionValue
  end
  return nil
end

function M:GetResourceName(SelectionValue)
  if DataMgr and DataMgr.Resource and DataMgr.Resource[SelectionValue] then
    return DataMgr.Resource[SelectionValue].ResourceName
  end
  local NumberValue = tonumber(SelectionValue)
  if NumberValue and DataMgr and DataMgr.Resource and DataMgr.Resource[NumberValue] then
    return DataMgr.Resource[NumberValue].ResourceName
  end
  return nil
end

function M:GetSelectionPreviewText(ItemData, SelectionIndexOrValue)
  if not ItemData then
    return nil
  end
  local selectionIndex = SelectionIndexOrValue
  if self:GetSelectionValueMode(ItemData) == "Value" then
    selectionIndex = self:GetSelectionIndexByValue(ItemData, SelectionIndexOrValue)
  end
  local text = ItemData.SelectionText and selectionIndex and ItemData.SelectionText[selectionIndex] or nil
  if not text and self:GetSelectionValueMode(ItemData) == "Value" then
    text = self:GetResourceName(SelectionIndexOrValue)
  end
  return text
end

function M:Init(Owner, ItemUI, SelectedItems, ItemDatas)
  self:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Owner = Owner
  self.ItemUI = ItemUI
  local previewTexts = {}
  for i, items in pairs(SelectedItems) do
    if type(items) == "table" then
      local processedItems = {}
      local itemData = ItemDatas and ItemDatas[i] or nil
      for _, index in pairs(items) do
        local text = self:GetSelectionPreviewText(itemData, index)
        if text then
          table.insert(processedItems, GText(text))
        end
      end
      local groupText = table.concat(processedItems, GText("、"))
      table.insert(previewTexts, groupText)
    end
  end
  local previewText = table.concat(previewTexts, GText("、"))
  self.Text_Preview:SetText(GText(previewText))
  self.FocusKeyName = "RH"
  self:SetGamepadKey(self.FocusKeyName)
  self:RefreshBaseInfo()
  self:InitListenEvent()
  self.EMScrollBox_1:SetControlScrollbarInside(false)
  self.EMScrollBox_1:SetScrollBarVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnBtnClearClicked()
  self:ClearItemSelection()
  self:PlayAnimation(self.Click)
end

function M:ClearItemSelection()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.ItemUI then
    self.ItemUI:OnClearSelection()
  end
  if self.Owner then
    self.Owner:PreViewDelete(true)
  end
end

function M:OnBtnClearHovered()
  self:PlayAnimation(self.Hover)
end

function M:OnBtnClearUnhovered()
  self:PlayAnimation(self.Unhover)
end

function M:OnBtnClearPressed()
  self:PlayAnimation(self.Press)
end

function M:Destruct()
  self.Btn_Clear.OnClicked:Remove(self, self.OnBtnClearClicked)
  self.Btn_Clear.OnHovered:Remove(self, self.OnBtnClearHovered)
  self.Btn_Clear.OnUnhovered:Remove(self, self.OnBtnClearUnhovered)
  self.Btn_Clear.OnPressed:Remove(self, self.OnBtnClearPressed)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self.Btn_Focus:SetFocus()
  if self.CurrentInputDevice == ECommonInputType.Gamepad then
    self.EMScrollBox_1:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.EMScrollBox_1:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  self:SetNavigationRuleExplicit(EUINavigation.Right, self.Btn_Clear)
  self:SetNavigationRuleExplicit(EUINavigation.Down, self.Owner.Button_FIiliter_List)
  self:SetNavigationRuleExplicit(EUINavigation.Left, self.Btn_Focus)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusLost()
  self:PlayAnimation(self.Text_Normal)
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshBaseInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurrentInputDevice = CurInputDevice
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self.Btn_Focus:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Btn_Focus:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName then
    local Speed = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    local CurScrollOffset = self.EMScrollBox_1:GetScrollOffset()
    local ScrollOffset = math.clamp(CurScrollOffset - Speed, 0, self.EMScrollBox_1:GetScrollOffsetOfEnd())
    self.EMScrollBox_1:SetScrollOffset(ScrollOffset)
  end
  return UWidgetBlueprintLibrary.Handled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnBtnFocusClicked()
  DebugPrint(TXTTag, "OnBtnFocus_Click")
  self:PlayAnimation(self.Text_Click)
end

function M:OnBtnFocusHovered()
  DebugPrint(TXTTag, "OnBtnFocusHovered")
  self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:OnBtnFocusUnhovered()
  self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnBtnFocusPressed()
  self:PlayAnimation(self.Text_Press)
end

function M:SetGamepadKey(FocusKeyName)
  local ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("RH", self.CurGamepadName)
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgLongPath = ImgLongPath}
    }
  })
end

return M
