require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
  self.isSelectedAll = false
  self.disableInteraction = false
  self.CurContent = nil
end

function M:Init(Owner, InItem)
  self.Owner = Owner
  self.ItemData = InItem
  self.Text_Title:SetText(GText(InItem.Title))
  self.Text_SelectAll:SetText(GText("ModFilter_SelectAll"))
  if InItem.HasSelectAll then
    self.Btn_SelectAll.OnClicked:Add(self, self.OnBtnSelectAllClicked)
    self.Btn_SelectAll.OnHovered:Add(self, self.OnBtnSelectAllHovered)
    self.Btn_SelectAll.OnUnhovered:Add(self, self.OnBtnSelectAllUnhovered)
    self.Btn_SelectAll.OnPressed:Add(self, self.OnBtnSelectAllPressed)
    self.SelectAll:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.SelectAll:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:RefreshBaseInfo()
  self:InitListenEvent()
  self:SetGamepadKey("LS")
  self.ListReward.BP_OnItemIsHoveredChanged:Add(self, self.OnItemHoveredChanged)
end

function M:InitSelectionItems(SelectionDatas, SelectionText, IconPaths)
  self.ListReward:ClearListItems()
  local indices = {}
  for index in pairs(SelectionDatas) do
    table.insert(indices, index)
  end
  table.sort(indices)
  for Idx, index in ipairs(indices) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local RewardID = SelectionDatas[index]
    local RewardData = DataMgr.Resource[tonumber(RewardID)] or DataMgr.Resource[RewardID]
    if RewardData then
      Content.Id = RewardData.ResourceId
      Content.Icon = RewardData.Icon
      Content.ItemType = "Resource"
      Content.UIName = RewardData.ResourceName
      Content.Rarity = RewardData.Rarity
      Content.IsShowDetails = true
      Content.Rec = "Reward"
      Content.ParentWidget = self
      Content.IsMultiSelectable = true
      Content.bClick = false
      Content.NoInteractive = true
      Content.HandleMouseDown = true
      Content.OnFocusReceivedEvent = {
        Obj = self,
        Callback = function()
          Content.UI:SetFocus()
        end
      }
      self.ListReward:AddItem(Content)
    end
  end
end

function M:RefreshBigReward(RewardId, IsSelected)
  self.CurReward = nil
  if IsSelected then
    self.Owner:AddSelection(self, RewardId, "")
  else
    self.Owner:RemoveSelection(self, RewardId)
  end
  local allSelected = true
  local numChildren = self.ListReward:GetNumItems()
  for i = 1, numChildren do
    local child = self.ListReward:GetItemAt(i - 1)
    if child and child.UI and child.UI.Content.bClick == false then
      allSelected = false
      break
    end
  end
  if self.isSelectedAll ~= allSelected then
    self.isSelectedAll = allSelected
    self:UpdateSelectionState()
  end
end

function M:UpdateSelectionState()
  if self.isSelectedAll then
    self:PlayAnimation(self.Click)
    self.disableInteraction = true
  else
    self:PlayAnimation(self.Normal)
    self.disableInteraction = false
  end
end

function M:OnBtnSelectAllClicked()
  local isChecked = true
  if self.isSelectedAll then
    isChecked = false
  end
  self.isSelectedAll = not self.isSelectedAll
  local numChildren = self.ListReward:GetNumItems()
  for i = 1, numChildren do
    local child = self.ListReward:GetItemAt(i - 1)
    if child and child.UI and child.UI.Content.bClick ~= isChecked then
      child.UI:OnClickSelected()
    end
  end
  self:PlayCheckSound(isChecked)
  self:UpdateSelectionState()
end

function M:OnSelectionItemChanged(CheckState, selectionUI)
  if CheckState then
    self.Owner:AddSelection(self, selectionUI.Index, selectionUI.Name)
  else
    self.Owner:RemoveSelection(self, selectionUI.Index)
  end
  local allSelected = true
  local numChildren = self.ListReward:GetNumItems()
  for i = 1, numChildren do
    local child = self.ListReward:GetItemAt(i - 1)
    if child and child.UI.Content.bClick == false then
      allSelected = false
      break
    end
  end
  if self.isSelectedAll ~= allSelected then
    self.isSelectedAll = allSelected
    self:UpdateSelectionState()
  end
end

function M:OnBtnSelectAllHovered()
  if self.disableInteraction then
    return
  end
  self:PlayAnimation(self.Hover)
end

function M:OnBtnSelectAllUnhovered()
  if self.disableInteraction then
    return
  end
  self:PlayAnimation(self.Unhover)
end

function M:OnBtnSelectAllPressed()
  if self.disableInteraction then
    return
  end
  self:PlayAnimation(self.Press)
end

function M:PlayCheckSound(IsChecked)
  if IsChecked then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
  end
end

function M:Destruct()
  self.Btn_SelectAll.OnClicked:Remove(self, self.OnBtnSelectAllClicked)
  self.Btn_SelectAll.OnHovered:Remove(self, self.OnBtnSelectAllHovered)
  self.Btn_SelectAll.OnUnhovered:Remove(self, self.OnBtnSelectAllUnhovered)
  self.Btn_SelectAll.OnPressed:Remove(self, self.OnBtnSelectAllPressed)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self:InitNavigationRules()
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.CurInputDevice == ECommonInputType.Gamepad then
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if self.CurInputDevice == ECommonInputType.Gamepad then
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
  local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
  if IsUseGamepad then
    if self:HasAnyUserFocus() or self:HasFocusedDescendants() then
      self.Key_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  else
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.CurInputDevice = CurInputDevice
end

function M:RefreshBaseInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:SetFirstCheckBoxFocusTarget()
  self.ListReward:SetFocus()
end

function M:InitNavigationRules()
  self.Btn_SelectAll:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    self.SetFirstCheckBoxFocusTarget
  })
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and "Gamepad_LeftThumbstick" == InKeyName then
    IsEventHandled = true
    self:OnBtnSelectAllClicked()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:SetGamepadKey(FocusKeyName)
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
end

function M:GetDesiredFocusWidget()
  if self.CurContent == nil then
    return self.ListReward:GetItemAt(0).UI
  else
    return self.CurContent.UI
  end
end

function M:GetNextWrapBox()
  local nextSiftItemIdx = self.Owner.List_Selection:GetChildIndex(self) + 1
  if nextSiftItemIdx < self.Owner.List_Selection:GetChildrenCount() then
    local nextSiftItem = self.Owner.List_Selection:GetChildAt(nextSiftItemIdx)
    return nextSiftItem.WBox_Selection
  end
  return nil
end

function M:GetPrevWrapBox()
  local prevSiftItemIdx = self.Owner.List_Selection:GetChildIndex(self) - 1
  if prevSiftItemIdx >= 0 then
    local prevSiftItem = self.Owner.List_Selection:GetChildAt(prevSiftItemIdx)
    return prevSiftItem.WBox_Selection
  end
  return nil
end

function M:OnItemHoveredChanged(Content, IsHover)
  if not IsValid(Content) then
    return
  end
  if IsHover then
    if IsValid(self.CurContent) and self.CurContent ~= Content then
      self.CurContent.UI:SetUsingGamepad(false)
    end
    self.CurContent = Content
  end
  if IsValid(Content.UI) then
    Content.UI:SetUsingGamepad(self.CurInputDevice and IsHover)
  end
end

return M
