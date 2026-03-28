require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local ModeConfig = {
  [UIConst.InputNumMode.ENABLE_PWD] = {
    "UI_SecPwd_TextInPwd",
    "UI_SecPwd_TextInPwdAgain"
  },
  [UIConst.InputNumMode.VERIFY_PWD] = {
    "UI_SecPwd_TextInPwd"
  }
}

function M:Construct()
  self.DataObjects = {}
  self.ActiveWidgets = {}
end

function M:InitRows(Mode, ParentWidget)
  self.DataObjects = {}
  self.ActiveWidgets = {}
  self.ParentWidget = ParentWidget
  self.List_Password:ClearListItems()
  local Texts = ModeConfig[Mode] or {
    "UI_SecPwd_TextInPwd"
  }
  local RowCount = #Texts
  for i = 1, RowCount do
    local Item = NewObject(UIUtils.GetCommonItemContentClass())
    Item.ItemData = {
      RowIndex = i,
      Text = "",
      DescText = GText(Texts[i]),
      ParentPanel = self,
      ClickObj = self,
      ClickFunc = self.OnChildRowClick,
      bIsFocused = 1 == i
    }
    table.insert(self.DataObjects, Item)
    self.List_Password:AddItem(Item)
  end
end

function M:RegisterRowWidget(RowIndex, Widget)
  self.ActiveWidgets[RowIndex] = Widget
end

function M:UpdateView(InputBuffer, FocusIndex)
  for i, Item in ipairs(self.DataObjects) do
    local RowIndex = Item.ItemData.RowIndex
    local Text = InputBuffer[RowIndex] or ""
    local bIsFocused = RowIndex == FocusIndex
    Item.ItemData.Text = Text
    Item.ItemData.bIsFocused = bIsFocused
    local Widget = self.ActiveWidgets[RowIndex]
    if Widget and Widget.RefreshState then
      Widget:RefreshState(Text, bIsFocused)
    end
  end
end

function M:OnChildRowClick(RowIndex)
  if self.ParentWidget and self.ParentWidget.SwitchFocus then
    self.ParentWidget:SwitchFocus(RowIndex)
  end
end

function M:GetFocusTargetWidget()
  local TargetIndex = self.ParentWidget and self.ParentWidget.FocusIndex or 1
  local Widget = self.ActiveWidgets[TargetIndex]
  if Widget and Widget.Password and Widget.Password.Btn_Click then
    return Widget.Password.Btn_Click
  end
  return nil
end

function M:OnNavigateDownFromRow(RowIndex, bIsEyeColumn)
  local NextIndex = RowIndex + 1
  local NextWidget = self.ActiveWidgets[NextIndex]
  local CurrentWidget = self.ActiveWidgets[RowIndex]
  if bIsEyeColumn then
    if NextWidget and NextWidget.Btn_Visible then
      return NextWidget.Btn_Visible
    end
    if CurrentWidget and CurrentWidget.Password and CurrentWidget.Password.Btn_Click then
      return CurrentWidget.Password.Btn_Click
    end
    return nil
  end
  if NextWidget and NextWidget.Password and NextWidget.Password.Btn_Click then
    return NextWidget.Password.Btn_Click
  end
  if self.ParentWidget then
    return self.ParentWidget:GetKeypadEntryWidget()
  end
  return nil
end

function M:OnNavigateUpFromRow(RowIndex, bIsEyeColumn)
  local PrevIndex = RowIndex - 1
  local PrevWidget = self.ActiveWidgets[PrevIndex]
  if bIsEyeColumn then
    if PrevWidget and PrevWidget.Btn_Visible then
      return PrevWidget.Btn_Visible
    end
    return nil
  end
  if PrevWidget and PrevWidget.Password and PrevWidget.Password.Btn_Click then
    return PrevWidget.Password.Btn_Click
  end
  return nil
end

return M
