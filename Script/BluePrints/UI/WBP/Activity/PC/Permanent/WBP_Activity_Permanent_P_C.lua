require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.WBP.Activity.Widget.Permanent.WBP_Activity_Permanent_Base"
})
M.EFocusState = {
  None = 0,
  PageListFocus = 1,
  RewardGridFocus = 2,
  CoreRewardTips = 3,
  RewardItemTips = 4,
  QaMenuTips = 5
}

function M:InitUI()
  self:InitCommonUI()
  self.GamePadState = M.EFocusState.None
  self.FocusingItemWidget = nil
  self.ForbiddenFocusTarget = nil
end

function M:ShowPage(IsNeedPlayInAnim)
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if IsNeedPlayInAnim then
    self:PlayFadeIn()
  end
  self:RefreshModuleStates()
  self:RefreshView()
  self:InitTimeInfo()
  self:ResetGamePadState()
end

function M:ResetGamePadState()
  if self.FocusingItemWidget then
    self.FocusingItemWidget:ResetKeyHints()
    self.FocusingItemWidget:SetSelected(false)
    self.FocusingItemWidget = nil
  end
  self.GamePadState = M.EFocusState.None
  self.ForbiddenFocusTarget = nil
  self.FocusWidgetName = nil
  self.FocusWidgetWidget = nil
end

function M:SetGamePadState(NewState)
  self.GamePadState = NewState
  self:UpdateKeyHintsForFocusedItem()
  if NewState == M.EFocusState.None then
    self:UpdateParentActivityKeyTips(nil, nil, false)
  else
    self:UpdateParentActivityKeyTips("DefaultWidget", self.List_Item, false)
  end
end

function M:UpdateKeyHintsForFocusedItem()
  if not self.FocusingItemWidget then
    return
  end
  if self.GamePadState == M.EFocusState.PageListFocus then
    local ModuleState = self.FocusingItemWidget.Content and self.FocusingItemWidget.Content.State or nil
    local IsNormal = 1 == ModuleState
    local IsLocked = 2 == ModuleState
    self.FocusingItemWidget:SetKeyHintsVisible(true, true, IsNormal, IsLocked)
  else
    self.FocusingItemWidget:SetKeyHintsVisible(false, false, false, false)
  end
end

function M:OnItemFocused(ItemWidget)
  if self.FocusingItemWidget and self.FocusingItemWidget ~= ItemWidget then
    self.FocusingItemWidget:ResetKeyHints()
    self.FocusingItemWidget:SetSelected(false)
  end
  if ItemWidget then
    self:ExitRewardGridFocus()
    self.FocusingItemWidget = ItemWidget
    self:UpdateKeyHintsForFocusedItem()
    ItemWidget:SetSelected(true)
  end
end

function M:EnterRewardViewMode()
  local S = M.EFocusState
  self:ResetGamePadState()
  self:SetGamePadState(S.PageListFocus)
  if self.List_Item then
    self.List_Item:NavigateToIndex(0)
    self:AddDelayFrameFunc(function()
      if self.List_Item then
        self.List_Item:SetFocus()
      end
    end, 1, "EnterRewardViewFocus")
  end
  return self.List_Item
end

function M:LeaveRewardViewMode()
  if self.GamePadState == M.EFocusState.None then
    return false
  end
  self:ResetGamePadState()
  self:UpdateParentActivityKeyTips(nil, nil, true)
  return true
end

function M:EnterRewardGridFocus()
  if self.GamePadState ~= M.EFocusState.PageListFocus then
    return false
  end
  if not self.FocusingItemWidget then
    return false
  end
  self:SetGamePadState(M.EFocusState.RewardGridFocus)
  self.ForbiddenFocusTarget = "RewardGrid"
  self.FocusingItemWidget:FocusRewardGrid()
  self:EnterActivityForbiddenState()
  return true
end

function M:EnterActivityForbiddenState()
  local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
  if ActivityMain then
    ActivityMain:UpdateCommonWidgetsStyleInPlatform(false)
    ActivityMain:EnterForbiddenState()
  end
end

function M:LeaveActivityForbiddenState()
  local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
  if ActivityMain then
    ActivityMain:UpdateCommonWidgetsStyleInPlatform(true)
    ActivityMain:LeaveForbiddenState()
  end
end

function M:ExitRewardGridFocus()
  if self.GamePadState ~= M.EFocusState.RewardGridFocus and self.GamePadState ~= M.EFocusState.QaMenuTips then
    return false
  end
  if self.ForbiddenFocusTarget == "QaMenu" and self.FocusingItemWidget then
    self.ForbiddenFocusTarget = nil
    self.FocusingItemWidget:CloseQaTips()
  end
  self.ForbiddenFocusTarget = nil
  self:SetGamePadState(M.EFocusState.PageListFocus)
  if self.List_Item then
    self.List_Item:SetFocus()
  end
  self:LeaveActivityForbiddenState()
  return true
end

function M:EnterQaMenuFocus()
  if self.GamePadState ~= M.EFocusState.PageListFocus then
    return false
  end
  if not self.FocusingItemWidget or not self.FocusingItemWidget.Content then
    return false
  end
  if 2 ~= self.FocusingItemWidget.Content.State then
    return false
  end
  self:SetGamePadState(M.EFocusState.QaMenuTips)
  self:EnterActivityForbiddenState()
  self.FocusingItemWidget:TriggerQaTips()
  return true
end

function M:OpenCoreRewardTips()
  if self.GamePadState ~= M.EFocusState.PageListFocus then
    return false
  end
  if not self.FocusingItemWidget then
    return false
  end
  self.GamePadState = M.EFocusState.CoreRewardTips
  self:UpdateKeyHintsForFocusedItem()
  self:UpdateParentActivityKeyTips("DefaultWidget", self.List_Item, false)
  self.FocusingItemWidget:TriggerCoreRewardTips()
  return true
end

function M:OnQaMenuOpenChanged(bOpen)
  if self.GamePadState == M.EFocusState.None then
    return
  end
  if bOpen then
    self.GamePadState = M.EFocusState.QaMenuTips
    self.ForbiddenFocusTarget = "QaMenu"
    self:UpdateKeyHintsForFocusedItem()
    self:UpdateParentActivityKeyTips("DefaultWidget", self.List_Item, false)
    if self.FocusingItemWidget then
      self.FocusingItemWidget:FocusQaMenu()
    end
  elseif self.ForbiddenFocusTarget == "QaMenu" then
    self.ForbiddenFocusTarget = nil
    self.GamePadState = M.EFocusState.PageListFocus
    self:UpdateKeyHintsForFocusedItem()
    self:UpdateParentActivityKeyTips("DefaultWidget", self.List_Item, false)
    self:LeaveActivityForbiddenState()
    if self.List_Item then
      self.List_Item:SetFocus()
    end
  end
end

function M:OnCoreRewardTipsChanged(bOpen)
  if self.GamePadState == M.EFocusState.None then
    return
  end
  if not bOpen then
    self.GamePadState = M.EFocusState.PageListFocus
    self:UpdateKeyHintsForFocusedItem()
    self:UpdateParentActivityKeyTips("DefaultWidget", self.List_Item, false)
    if self.List_Item then
      self.List_Item:SetFocus()
    end
  end
end

function M:UpdateParentActivityKeyTips(FocusWidgetName, FocusWidgetWidget, bIsFocusToParent)
  self.FocusWidgetName = FocusWidgetName
  self.FocusWidgetWidget = FocusWidgetWidget
  if self.ParentWidget then
    self.ParentWidget:UpdateActivityKeyTips(FocusWidgetName, FocusWidgetWidget)
    if bIsFocusToParent then
      self.ParentWidget:SetFocus()
    end
  end
end

function M:GetDefaultBottomTips()
  local S = M.EFocusState
  if self.GamePadState == S.PageListFocus then
    return {
      {
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.LeaveRewardViewMode,
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Close")
      }
    }
  elseif self.GamePadState == S.RewardGridFocus then
    return {
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Controller_CheckDetails")
      },
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK")
      }
    }
  elseif self.GamePadState == S.QaMenuTips then
    return {
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_Tips_Close")
      }
    }
  elseif self.GamePadState == S.CoreRewardTips or self.GamePadState == S.RewardItemTips then
    return {
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_Tips_Close")
      }
    }
  end
  return nil
end

function M:OnSubTabNavigationRight()
  self:EnterRewardViewMode()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    return self:OnGamePadButtonDown(UIConst.GamePadKey.FaceButtonBottom)
  end
  return UIUtils.Unhandled
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadButtonDown(InKeyName)
  else
    IsEventHandled = false
  end
  return IsEventHandled
end

function M:OnGamePadButtonDown(InKeyName)
  local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  local Key = UIConst.GamePadKey
  local State = M.EFocusState
  local Handled = false
  if self.GamePadState == State.PageListFocus then
    if InKeyName == Key.FaceButtonRight then
      Handled = self:LeaveRewardViewMode()
    elseif InKeyName == Key.LeftThumb then
      Handled = self:EnterRewardGridFocus()
    elseif InKeyName == Key.FaceButtonTop then
      Handled = self:OpenCoreRewardTips()
    elseif InKeyName == Key.SpecialRight then
      Handled = self:EnterQaMenuFocus()
    elseif InKeyName == Key.FaceButtonBottom and self.FocusingItemWidget and self.FocusingItemWidget.Content and 1 == self.FocusingItemWidget.Content.State then
      self:OnGotoClick(self.FocusingItemWidget.Content.KeyId)
      Handled = true
    end
  elseif self.GamePadState == State.RewardGridFocus then
    if InKeyName == Key.FaceButtonRight then
      Handled = self:ExitRewardGridFocus()
    end
  elseif self.GamePadState == State.QaMenuTips then
    if InKeyName == Key.FaceButtonRight then
      Handled = self:ExitRewardGridFocus()
    end
  elseif self.GamePadState == State.CoreRewardTips then
    if InKeyName == Key.FaceButtonRight then
      if self.FocusingItemWidget then
        self.FocusingItemWidget:CloseCoreRewardTips()
      end
      Handled = true
    end
  elseif self.GamePadState == State.RewardItemTips and InKeyName == Key.FaceButtonRight then
    self:SetGamePadState(State.RewardGridFocus)
    if self.FocusingItemWidget then
      self.FocusingItemWidget:FocusRewardGrid()
    end
    Handled = true
  end
  return Handled
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad, bIsWithButton)
  if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
    return
  end
  self:ResetGamePadState()
  self:UpdateParentActivityKeyTips(nil, nil, true)
end

return M
