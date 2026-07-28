require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Construct()
  M.Super.Construct(self)
  self.ItemUIPathName = "/Game/UI/WBP/Common/FilterSort/WBP_Com_SiftDialogItem.WBP_Com_SiftDialogItem"
  self.CoopItemIconUIPathName = "/Game/UI/WBP/Activity/Widget/Coop/WBP_Activity_Coop_SiftDialogItem.WBP_Activity_Coop_SiftDialogItem"
  self.SelectionItemUIPathName = "/Game/UI/WBP/Common/FilterSort/WBP_Com_SiftSelection.WBP_Com_SiftSelection"
  self.SelectedItems = {}
  self.IsQuitBtnForbidden = true
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.Owner = Owner
  self.Params = Params
  self.ParentWidget = Params.ParentWidget
  self.List_Selection:ScrollToStart()
  self.Owner:GetButtonBar().Btn_Yes:BindEventOnReleased(self, self.OnBtnYes)
  self.Owner:GetButtonBar().Btn_Quit:BindEventOnReleased(self, self.OnBtnNo)
  for _, ItemData in ipairs(Params.ItemDatas) do
    local ItemUI = self:AddItem(ItemData)
    if ItemData.SelectionDatas then
      ItemUI:InitSelectionItems(ItemData.SelectionDatas, ItemData.SelectionText, ItemData.IconPaths)
    end
  end
  if self.Params.ReselectionCallback then
    self.Params.ReselectionCallback(self)
  end
  self.CurInputDevice = nil
  self:RefreshBaseInfo()
  self:InitListenEvent()
  self:InitGamePadTarget()
  self:InitHintGamepadBtn()
end

function M:AddSelectionItem(ItemData, SelectionData)
  local UIManager = UIManager(GWorld.GameInstance)
  local ItemUI = UIManager:CreateWidget(self.SelectionItemUIPathName)
  self.WBox_Selection:AddChild(ItemUI)
  ItemUI:Init(self, SelectionData, ItemData)
end

function M:AddItem(ItemData)
  local UIManager = UIManager(GWorld.GameInstance)
  local ItemUIPathName = self.ItemUIPathName
  if ItemData.ShowItemIcon then
    ItemUIPathName = self.CoopItemIconUIPathName
  end
  local ItemUI = UIManager:CreateWidget(ItemUIPathName)
  self.List_Selection:AddChild(ItemUI)
  ItemUI:Init(self, ItemData)
  self.List_Selection:ScrollWidgetIntoView(ItemUI, true)
  return ItemUI
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

function M:GetItemDataByItemUI(itemUI)
  local itemIndex = self.List_Selection:GetChildIndex(itemUI) + 1
  local itemData = self.Params and self.Params.ItemDatas and self.Params.ItemDatas[itemIndex] or nil
  return itemData, itemIndex
end

function M:GetSelectionValue(itemUI, SelectionIndexOrValue)
  local itemData = self:GetItemDataByItemUI(itemUI)
  local valueMode = self:GetSelectionValueMode(itemData)
  if "Value" == valueMode then
    if itemUI and itemUI.ListReward then
      return SelectionIndexOrValue
    end
    if itemData and itemData.SelectionDatas then
      return itemData.SelectionDatas[SelectionIndexOrValue] or SelectionIndexOrValue
    end
  end
  if itemUI and itemUI.ListReward and itemData and itemData.SelectionDatas then
    for index, value in pairs(itemData.SelectionDatas) do
      if self:IsSameSelectionValue(value, SelectionIndexOrValue) then
        return index
      end
    end
  end
  return SelectionIndexOrValue
end

function M:GetSelectionIndex(ItemData, SelectionIndexOrValue)
  if not ItemData then
    return SelectionIndexOrValue
  end
  local valueMode = self:GetSelectionValueMode(ItemData)
  if "Value" ~= valueMode then
    return SelectionIndexOrValue
  end
  if ItemData.SelectionDatas then
    for index, value in pairs(ItemData.SelectionDatas) do
      if self:IsSameSelectionValue(value, SelectionIndexOrValue) then
        return index
      end
    end
    if ItemData.SelectionDatas[SelectionIndexOrValue] ~= nil then
      return SelectionIndexOrValue
    end
  end
  return nil
end

function M:AddSelection(itemUI, index, name)
  local selectionValue = self:GetSelectionValue(itemUI, index)
  local _, itemIndex = self:GetItemDataByItemUI(itemUI)
  if not self.SelectedItems[itemIndex] then
    self.SelectedItems[itemIndex] = {}
  end
  if not self:TableContains(self.SelectedItems[itemIndex], selectionValue) then
    table.insert(self.SelectedItems[itemIndex], selectionValue)
  end
  self.Owner:GetButtonBar().Btn_Quit:ForbidBtn(false)
  self.IsQuitBtnForbidden = false
end

function M:RemoveSelection(itemUI, index)
  local selectionValue = self:GetSelectionValue(itemUI, index)
  local _, itemIndex = self:GetItemDataByItemUI(itemUI)
  if self.SelectedItems and self.SelectedItems[itemIndex] then
    local indices = self.SelectedItems[itemIndex]
    for i, selectedIndex in ipairs(indices) do
      if self:IsSameSelectionValue(selectedIndex, selectionValue) then
        table.remove(indices, i)
        break
      end
    end
    if next(indices) == nil then
      self.SelectedItems[itemIndex] = nil
    end
  end
  if next(self.SelectedItems) == nil then
    self.Owner:GetButtonBar().Btn_Quit:ForbidBtn(true)
    self.IsQuitBtnForbidden = true
  end
end

function M:TableContains(tbl, val)
  for _, v in ipairs(tbl) do
    if self:IsSameSelectionValue(v, val) then
      return true
    end
  end
  return false
end

function M:OnBtnYes()
  if self.Params.OnConfirmCallback then
    self.Params.OnConfirmCallback(self, self.Owner, self.SelectedItems, self.Params.ItemDatas)
    self:Close()
  end
end

function M:OnBtnNo()
  if not IsValid(self) then
    return
  end
  self.SelectedItems = {}
  self.Owner:GetButtonBar().Btn_Quit:ForbidBtn(true)
  self.IsQuitBtnForbidden = true
  local dimensionCount = self.List_Selection:GetChildrenCount() - 1
  for i = 0, dimensionCount do
    local dimensionItem = self.List_Selection:GetChildAt(i)
    if dimensionItem and dimensionItem.WBox_Selection then
      local tagItems = dimensionItem.WBox_Selection:GetAllChildren()
      local tagCount = tagItems:Num()
      for j = 1, tagCount do
        local tagItem = tagItems:Get(j)
        if tagItem and tagItem.CheckBox_Selection and tagItem.CheckBox_Selection:IsChecked() then
          tagItem.CheckBox_Selection:SetIsChecked(false)
          tagItem:OnItemSelectionChanged()
        end
      end
    elseif dimensionItem and dimensionItem.ListReward then
      local rewardItemNums = dimensionItem.ListReward:GetNumItems()
      for j = 1, rewardItemNums do
        local rewardItem = dimensionItem.ListReward:GetItemAt(j - 1)
        if rewardItem then
          if rewardItem.UI and rewardItem.UI.Content and rewardItem.UI.Content.bClick then
            rewardItem.UI:OnClickSelected()
          else
            rewardItem.bClick = false
          end
        end
      end
      dimensionItem.isSelectedAll = false
      if dimensionItem.UpdateSelectionState then
        dimensionItem:UpdateSelectionState()
      end
    end
  end
  self.Owner.DontCloseWhenLeftBtnClicked = true
end

function M:OnClearSelection()
  self:OnBtnNo()
  self:Close()
end

function M:Reselection(SelectedItems)
  if SelectedItems then
    for dimensionIndex, selectedIndices in pairs(SelectedItems) do
      local dimensionItem = self.List_Selection:GetChildAt(dimensionIndex - 1)
      local itemData = self.Params and self.Params.ItemDatas and self.Params.ItemDatas[dimensionIndex] or nil
      if dimensionItem then
        for _, selectionIndexOrValue in ipairs(selectedIndices) do
          local selectionIndex = self:GetSelectionIndex(itemData, selectionIndexOrValue)
          if dimensionItem.WBox_Selection then
            local selectionItem = selectionIndex and dimensionItem.WBox_Selection:GetChildAt(selectionIndex - 1) or nil
            if selectionItem and selectionItem.CheckBox_Selection then
              selectionItem.CheckBox_Selection:SetIsChecked(true)
              selectionItem:OnItemSelectionChanged()
            end
            local totalSelections = dimensionItem.WBox_Selection:GetChildrenCount()
            if #selectedIndices == totalSelections then
              dimensionItem.isSelectedAll = true
            else
              dimensionItem.isSelectedAll = false
            end
          end
          if dimensionItem.ListReward then
            local rewardItem = selectionIndex and dimensionItem.ListReward:GetItemAt(selectionIndex - 1) or nil
            if rewardItem and rewardItem.bClick ~= nil then
              rewardItem.bClick = true
              dimensionItem:RefreshBigReward(rewardItem.Id, true)
            end
            local totalSelections = dimensionItem.ListReward:GetNumItems()
            if #selectedIndices == totalSelections then
              dimensionItem.isSelectedAll = true
            else
              dimensionItem.isSelectedAll = false
            end
          end
        end
      end
    end
  end
end

function M:Close()
  if IsValid(self) then
    M.Super.Close(self)
    if IsValid(self.Owner) then
      self.Owner:Close()
    end
  end
end

function M:Destruct()
  M.Super.Destruct(self)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
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
  self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  self.CurGamepadName = CurGamepadName
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
  if IsUseKeyAndMouse then
  else
    self:InitGamePadTarget()
  end
  self.CurInputDevice = CurInputDevice
end

function M:InitGamePadTarget()
  self.CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
  if self.CurInputDevice == ECommonInputType.Gamepad then
    local firstSiftItem = self.List_Selection:GetChildAt(0)
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(firstSiftItem)
    if firstSiftItem and firstSiftItem.WBox_Selection then
      local firstCheckBox = firstSiftItem.WBox_Selection:GetChildAt(0)
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(firstCheckBox)
      if firstCheckBox and firstCheckBox.CheckBox_Selection then
        self.GameInputModeSubsystem:SetTargetUIFocusWidget(firstCheckBox.CheckBox_Selection)
        self.List_Selection:SetScrollOffset(0)
      end
    elseif firstSiftItem and firstSiftItem.ListReward then
      local firstCheckBox = firstSiftItem.ListReward:GetItemAt(0)
      if firstCheckBox and firstCheckBox.UI then
        self:AddTimer(0.1, function()
          self.GameInputModeSubsystem:SetTargetUIFocusWidget(firstCheckBox.UI)
        end, false)
        self.List_Selection:ScrollToStart()
      else
        self.GameInputModeSubsystem:SetTargetUIFocusWidget(firstSiftItem.ListReward)
        self.List_Selection:ScrollToStart()
      end
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      self:OnBtnYes()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
      if self.IsQuitBtnForbidden then
        self.Owner:OnForbiddenLeftBtnClicked()
      end
      self:OnBtnNo()
    else
      if InKeyName == Const.GamepadFaceButtonRight then
        self.Owner:OnCloseBtnClicked()
      else
      end
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:InitHintGamepadBtn()
  if self.Params.ShowParamsKeyInfoList then
    for idx, KeyInfo in ipairs(self.Params.ShowParamsKeyInfoList) do
      self.Owner["Gamepad_Shortcut0" .. idx]:CreateCommonKey(KeyInfo)
      self.Owner["Gamepad_Shortcut0" .. idx]:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  else
    self.Owner.Gamepad_Shortcut01:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("A", self.CurGamepadName)
        }
      },
      Desc = GText("UI_RougeLike_BlessingConfirm") .. "/" .. GText("UI_PATCH_CANCEL")
    })
    self.Owner.Gamepad_Shortcut01:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Owner.Gamepad_Shortcut02:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("B", self.CurGamepadName)
        }
      },
      Desc = GText("UI_Controller_Close")
    })
    self.Owner.Gamepad_Shortcut02:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

return M
