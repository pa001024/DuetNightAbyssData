require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  rawset(self.Btn_Unfold, "Btn", self.Btn_Plan)
  self.Btn_Unfold:BindButtonPerformances()
  self.Btn_Unfold:BindEventOnClicked(self, self.OnOpenListBtnClicked)
  rawset(self.BtnEdit, "Btn", self.Btn_Edit)
  self.BtnEdit:BindButtonPerformances()
  self.BtnEdit:BindEventOnClicked(self, self.OnEditBtnClicked)
  rawset(self.BtnShare, "Btn", self.Btn_Share)
  self.BtnShare:BindButtonPerformances()
  self.BtnShare:BindEventOnClicked(self, self.OnShareBtnClicked)
  self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.List_Plan.BP_OnEntryInitialized:Add(self, self.OnEntryInitialized)
  rawset(self, "IsListOpened", false)
  UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
  self:OnUpdateUIStyleByInputTypeChange(UIUtils.UtilsGetCurrentInputType())
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  self:UpdateGamepadKeyVisibility()
end

function M:ForceSetGampadKeyVisibility(Visibility)
  self.GampadKeyVisibility = Visibility
  self:UpdateGamepadKeyVisibility()
end

function M:UpdateGamepadKeyVisibility()
  if self.GampadKeyVisibility then
    self.Key_GamePad:SetVisibility(self.GampadKeyVisibility)
    return
  end
  if self.IsGamepadInput and not self.HasAnyFocus then
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:Destruct()
  UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange)
end

function M:Init(Params)
  self.Owner = Params.Owner
  self._OnEditBtnClicked = Params.OnEditBtnClicked
  self._OnPlanChanged = Params.OnPlanChanged
  self._OnBuildCommunityCode = Params.OnBuildCommunityCode
  self._OnAddedToFocusPath = Params.OnAddedToFocusPath
  self._OnRemovedFromFocusPath = Params.OnRemovedFromFocusPath
  self._OnGetBackReply = Params.OnGetBackReply
  self.PlanNames = Params.PlanNames or {}
  self.SelectedItemIndex = Params.SelectedItemIndex or -1
  self.BtnStyle = Params.BtnStyle or 0
  self.BtnListParams = Params.BtnListParams
  self.WS_State:SetActiveWidgetIndex(self.BtnStyle)
  self:UpdatePlanNames(self.PlanNames, self.SelectedItemIndex)
  self.Panel_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_ShareOption:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = Params.FocusKeyImgPath or "RS"
      }
    }
  })
  if 0 == self.BtnStyle then
    self.Btn_Plan:SetNavigationRuleExplicit(EUINavigation.Right, self.Btn_Edit)
  elseif 1 == self.BtnStyle then
    self.Btn_Plan:SetNavigationRuleExplicit(EUINavigation.Right, self.Btn_Share)
  end
end

function M:UpdatePlanNames(PlanNames, SelectedItemIndex)
  self.Panel_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.PlanNames = PlanNames or {}
  self.SelectedItemIndex = SelectedItemIndex or self.SelectedItemIndex
  self.List_Plan:ClearListItems()
  self.ItemContents = {}
  self.CurContent = nil
  for index, value in ipairs(self.PlanNames) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Text = GText(value)
    Content.Owner = self
    Content.Idx = index
    if self.SelectedItemIndex == index then
      self.CurContent = Content
      Content.IsSelected = true
    else
      Content.IsSelected = false
    end
    table.insert(self.ItemContents, Content)
    self.List_Plan:AddItem(Content)
  end
  if self.CurContent then
    self.Text_Plan:SetText(self.CurContent.Text)
  end
end

function M:SetSelectedItemIdx(SelectedItemIndex)
  if self.CurContent then
    self.CurContent.IsSelected = false
    if self.CurContent.Entry then
      self.CurContent.Entry:OnEntrySelectionChanged()
    end
  end
  self.SelectedItemIndex = SelectedItemIndex
  local Content = self.ItemContents[SelectedItemIndex]
  if Content then
    self.CurContent = Content
    Content.IsSelected = true
    self.Text_Plan:SetText(self.CurContent.Text)
    if self.CurContent.Entry then
      self.CurContent.Entry:OnEntrySelectionChanged()
    end
  end
end

function M:OnEntryInitialized(Content, Widget)
  Widget:OnEntrySelectionChanged()
end

function M:OnListItemClicked(Content)
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
  self:SetSelectedItemIdx(Content.Idx)
  self:OpenList(false)
  self.Btn_Plan:SetFocus()
  if self._OnPlanChanged then
    self._OnPlanChanged(self.Owner, Content.Idx)
  end
end

function M:OnOpenListBtnClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_level_02", nil, nil)
  self:OpenList(not self.IsListOpened)
end

function M:OnUnfoldBtnClicked()
  self:OpenList(false)
end

function M:OpenList(bIsOpen)
  if self.IsListOpened == bIsOpen then
    return
  end
  self.IsListOpened = bIsOpen
  self:StopAllAnimations()
  if bIsOpen then
    self:PlayAnimation(self.Expand)
    self.Panel_List:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local Content = self.List_Plan:GetItemAt(self.SelectedItemIndex - 1)
    self.List_Plan:BP_CancelScrollIntoView()
    self.List_Plan:BP_SetSelectedItem(Content)
    self.List_Plan:BP_NavigateToItem(Content)
    self.List_Plan:SetFocus()
  else
    self:PlayAnimation(self.Fold)
    self:UnbindAllFromAnimationFinished(self.Fold)
    self:BindToAnimationFinished(self.Fold, {
      self,
      self.OnFoldAnimationFinished
    })
  end
end

function M:OnFoldAnimationFinished()
  self.Panel_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnEditBtnClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
  if self._OnEditBtnClicked then
    self._OnEditBtnClicked(self.Owner)
  end
end

function M:OnShareBtnClicked()
  if not self.BtnListParams then
    return
  end
  self:InitBtnList()
  if self.Panel_ShareOption and self.Panel_ShareOption.ResetCommunityCodeState then
    self.Panel_ShareOption:ResetCommunityCodeState()
  end
  self.Panel_ShareOption:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Panel_ShareOption:SetFocus()
end

function M:InitBtnList()
  if rawget(self, "LastBtnListParams") == self.BtnListParams then
    return
  end
  rawset(self, "LastBtnListParams", self.BtnListParams)
  self.Panel_ShareOption:Init({
    Owner = self.Owner,
    OnAddedToFocusPath = function()
      if self.IsListOpened and UIUtils.HasAnyFocus(self.List_Plan) then
        self:OpenList(false)
      end
    end,
    OnBuildCommunityCode = self._OnBuildCommunityCode,
    BtnListParams = self.BtnListParams
  })
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.Btn_Plan)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
  if UKismetInputLibrary.InputEvent_IsRepeat(InputEvent) then
    return UIUtils.Handled
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if Const.GamepadFaceButtonRight == InKeyName then
    if UIUtils.HasAnyFocus(self.List_Plan) then
      self:OpenList(false)
      return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.Btn_Plan)
    end
    if UIUtils.HasAnyFocus(self.Panel_ShareOption) then
      return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.Btn_Share)
    end
    if self._OnGetBackReply then
      local Reply = self._OnGetBackReply(self.Owner)
      if Reply then
        return Reply
      end
    end
    return UIUtils.Unhandled
  end
  return UIUtils.Unhandled
end

function M:OnAddedToFocusPath(InFocusEvent)
  self.HasAnyFocus = true
  self:UpdateGamepadKeyVisibility()
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath(self.Owner)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self.HasAnyFocus = false
  self:UpdateGamepadKeyVisibility()
  self:OpenList(false)
  if self._OnRemovedFromFocusPath then
    self._OnRemovedFromFocusPath(self.Owner)
  end
end

return M
