require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:BP_OnEntryReleased()
  if self.Content then
    self.Content.Entry = nil
  end
end

function M:Construct()
  self.Btn_Reward:SetText(GText("UI_AppearanceScore_RewardGet"))
  self.Text_InProgress:SetText(GText("UI_AppearanceScore_RewardProgress"))
  self.Key_GamePad:CreateGamepadKey("LS")
  self.Btn_Reward:BindEventOnClicked(self, self.OnClickedBtn)
end

function M:Destruct()
  self:RemoveInputMethodChangedListen()
end

function M:OnListItemObjectSet(Content)
  Content.Entry = self
  self.Content = Content
  if self.Content.InProgress then
    self.WS_Btn:SetActiveWidgetIndex(2)
  elseif self.Content.CanReceive then
    self.WS_Btn:SetActiveWidgetIndex(0)
  elseif self.Content.RewardsGot then
    self.WS_Btn:SetActiveWidgetIndex(1)
  else
    self.WS_Btn:SetActiveWidgetIndex(2)
  end
  if self.Content.ScoreTarget then
    self.Text_Task:SetText(string.format(GText("UI_AppearanceScore_RewardCondition"), self.Content.ScoreTarget))
  end
  if not self.IsListened then
    self:AddInputMethodChangedListen()
  end
  self.IsListened = true
  self.List_Item:ClearListItems()
  local Rewards = {
    self.Content.RewardId
  }
  for _, RewardId in pairs(Rewards) do
    local RewardInfo = DataMgr.Reward[RewardId]
    if RewardInfo then
      local Ids = RewardInfo.Id or {}
      local RewardCount = RewardInfo.Count or {}
      local TableName = RewardInfo.Type or {}
      for i = 1, #Ids do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local ItemId = Ids[i]
        Content.IsShowDetails = true
        Content.Id = ItemId
        Content.ItemId = ItemId
        Content.Count = RewardUtils:GetCount(RewardCount[i])
        Content.Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
        Content.Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
        Content.ItemType = TableName[i]
        Content.bHasGot = self.Content.RewardsGot
        Content.OnMenuOpenChangedEvents = {
          Obj = self,
          Callback = self.ItemMenuAnchorChanged
        }
        self.List_Item:AddItem(Content)
      end
    end
  end
  self:PlayAnimation(self.In)
end

function M:OnClickedBtn()
  if self.Content and self.Content.ReceiveCallBackObj and self.Content.ReceiveCallBackFunc then
    self.Content.ReceiveCallBackFunc(self.Content.ReceiveCallBackObj, self.Content)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.GameInputModeSubsystem and UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and 0 == self.Content.Owner.IsInViewMode then
    self.Btn_Reward:SetGamePadIconVisible(true)
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  return UIUtils.Handled
end

function M:OnFocusLost(InFocusEvent)
  if self.GameInputModeSubsystem and UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.Btn_Reward:SetGamePadIconVisible(false)
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.LeftThumb then
      IsEventHandled = true
      self:SwitchSelectedMode()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      if 2 == self.Content.Owner.IsInViewMode then
        IsEventHandled = true
        self:SwitchSelectedMode()
      end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      IsEventHandled = true
      if 0 == self.WS_Btn:GetActiveWidgetIndex() then
        self.Btn_Reward:OnBtnClicked()
      end
    end
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  else
    return UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:SwitchSelectedMode()
  if 2 == self.Content.Owner.IsInViewMode then
    self.Content.Owner:UpdateBottomKeyInfo_Normal()
    self.Content.Owner.Btn_Reward:SetGamePadIconVisible(true)
    self.Content.Owner.Archive_Reward.Key_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Content.Owner.IsInViewMode = 0
    self:SetFocus()
  elseif 0 == self.Content.Owner.IsInViewMode then
    self.Content.Owner:UpdateBottomKeyInfo_ViewMode()
    self.Content.Owner.Btn_Reward:SetGamePadIconVisible(false)
    self.Content.Owner.Archive_Reward.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.List_Item:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Content.Owner.IsInViewMode = 2
    self:FocusToRewardItem()
  end
end

function M:FocusToRewardItem()
  self.List_Item:SetVisibility(UIConst.VisibilityOp.Visible)
  local ItemUIs = self.List_Item:GetDisplayedEntryWidgets()
  if ItemUIs:Length() > 0 then
    for i = 1, ItemUIs:Length() do
      local Widget = ItemUIs:GetRef(i)
      if Widget then
        self.List_Item:SetSelectedIndex(i - 1)
        self.List_Item:NavigateToIndex(i - 1)
        return Widget
      end
    end
  end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  self.IsEnter = true
  local IsGamePad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if self.Mobile or not IsGamePad then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self:StopAnimation(self.GamePad_Select)
  self.IsSelected = true
  self:PlayAnimation(self.GamePad_Select, 0, 1, 0)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  self.IsEnter = false
  local IsGamePad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if self.Mobile or not IsGamePad then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self:StopAnimation(self.GamePad_Select)
  self.IsSelected = false
  self:PlayAnimation(self.GamePad_Select, 0, 1, 1)
end

function M:AddInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RemoveInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:InitKeyBoardView()
  else
    self:InitGamepadView()
  end
end

function M:InitGamepadView()
  self.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:InitKeyBoardView()
  self.Btn_Reward:SetGamePadIconVisible(false)
  self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.List_Item:SetVisibility(UIConst.VisibilityOp.Visible)
  if self.IsSelected then
    self:PlayAnimation(self.GamePad_Select, 0, 1, 1)
  end
end

function M:ItemMenuAnchorChanged(IsOpen)
  if self.Content and self.Content.Owner then
    self.Content.Owner:ItemMenuAnchorChanged(IsOpen)
  end
end

return M
