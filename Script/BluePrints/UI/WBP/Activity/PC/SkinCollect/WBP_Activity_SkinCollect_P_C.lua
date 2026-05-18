require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Activity.PC.SkinCollect.WBP_Activity_SkinCollect_Base_C"
})
local Name = "BluePrints.UI.WBP.Activity.PC.SkinCollect.WBP_Activity_SkinCollect_P_C"

function M:Initialize(Initializer)
  self.Super.Initialize(self, Initializer)
  self.BaseName = Name
  self.IsInListFocus = false
  self.IsClaimAllBtnVisible = false
  self.bIsFocusable = true
end

local function SafeSetVisibility(widget, op)
  if widget and widget.SetVisibility then
    widget:SetVisibility(op)
  end
end

local function IsWidgetVisible(widget)
  return widget and widget.IsVisible and widget:IsVisible()
end

local function IsGamepadInputActive()
  return UIUtils and UIUtils.IsGamepadInput and UIUtils.IsGamepadInput()
end

function M:SetResourceBarGamepadKeyHidden(isHidden)
  self:RefreshResourceBarGamepadKey(isHidden)
end

function M:RefreshRuleButtonGamepadHint(shouldShow)
  if not self.Com_BtnExplanation then
    return
  end
  local explanationBtn = self.Com_BtnExplanation
  local canShow = true == shouldShow and self:CanOpenActivityRuleByGamePad()
  if explanationBtn.Com_KeyImg and explanationBtn.WidgetSwitcher_0 then
    if canShow then
      explanationBtn.WidgetSwitcher_0:SetActiveWidget(explanationBtn.Com_KeyImg)
      explanationBtn.Com_KeyImg:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Menu"}
        }
      })
    elseif explanationBtn.Com_BtnQa then
      explanationBtn.WidgetSwitcher_0:SetActiveWidget(explanationBtn.Com_BtnQa)
    end
  elseif explanationBtn.SetGamePadImg then
    explanationBtn:SetGamePadImg("Menu")
  end
  if explanationBtn.SetGamePadVisibility then
    explanationBtn:SetGamePadVisibility(canShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  elseif explanationBtn.Com_KeyImg then
    SafeSetVisibility(explanationBtn.Com_KeyImg, canShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:CanOpenActivityRuleByGamePad()
  return self.ActivityConfigData and self.ActivityConfigData.EventRule and self.Com_BtnExplanation and self.Com_BtnExplanation:IsVisible()
end

function M:RefreshFocusedRewardItemGamepadHint(isVisible)
  local rewardWidget = self:GetCurrentRewardSelectedWidget()
  if rewardWidget and rewardWidget.SetListFocusGamepadHintVisible then
    rewardWidget:SetListFocusGamepadHintVisible(true == isVisible)
  end
end

function M:RefreshGamepadActionButtonHints()
  local isGamepad = IsGamepadInputActive()
  local canShowActionOnButtons = isGamepad and not self.IsInListFocus and not self.IsRewardTipsOpen
  self:RefreshRuleButtonGamepadHint(canShowActionOnButtons)
  if self.Btn_Confirm then
    if self.Btn_Confirm.SetDefaultGamePadImg then
      self.Btn_Confirm:SetDefaultGamePadImg("A")
    end
    if self.Btn_Confirm.SetGamepadIconVisibility then
      self.Btn_Confirm:SetGamepadIconVisibility(canShowActionOnButtons)
    elseif self.Btn_Confirm.Key_GamePad then
      SafeSetVisibility(self.Btn_Confirm.Key_GamePad, canShowActionOnButtons and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
    end
  end
  local claimAllBtn = self.GetClaimAllBtn and self:GetClaimAllBtn() or nil
  local hasClaimAll = claimAllBtn and IsWidgetVisible(claimAllBtn)
  local hasUnlockBtn = self.WBP_Activity_SkinCollect_PayBtn and IsWidgetVisible(self.WBP_Activity_SkinCollect_PayBtn)
  local showY = canShowActionOnButtons and (hasClaimAll or hasUnlockBtn)
  if claimAllBtn then
    if claimAllBtn.SetDefaultGamePadImg then
      claimAllBtn:SetDefaultGamePadImg("Y")
    end
    if claimAllBtn.SetGamePadIconVisible then
      claimAllBtn:SetGamePadIconVisible(showY and hasClaimAll)
    end
  end
  local payBtn = self.WBP_Activity_SkinCollect_PayBtn
  if payBtn then
    if payBtn.Img_GamePad and payBtn.Img_GamePad.CreateGamepadKey and not self.PayBtnGamepadKeyInitialized then
      payBtn.Img_GamePad:CreateGamepadKey("Y")
      self.PayBtnGamepadKeyInitialized = true
    end
    if payBtn.SetGamePadIconVisible then
      payBtn:SetGamePadIconVisible(showY and hasUnlockBtn and not hasClaimAll)
    elseif payBtn.Img_GamePad then
      SafeSetVisibility(payBtn.Img_GamePad, not (not (showY and hasUnlockBtn) or hasClaimAll) and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:RefreshParentActivityKeyTips()
  if not self.ParentWidget then
    return
  end
  if self.IsInListFocus then
    if self.IsRewardTipsOpen then
      self.ParentWidget:UpdateActivityKeyTips("EmptyView", self:GetCurrentRewardSelectedWidget())
      return
    end
    local selectedContent = self:GetCurrentRewardSelectedContent()
    local viewName = selectedContent and selectedContent.bCanGet and "ReceiveRewardView" or "CheckMultiRewardDetailView"
    self.ParentWidget:UpdateActivityKeyTips(viewName, self:GetCurrentRewardSelectedWidget())
    return
  end
  local focusTypeName = self.IsClaimAllBtnVisible and "GetAllReward" or nil
  self.ParentWidget:UpdateActivityKeyTips(focusTypeName, nil)
end

function M:RefreshResourceBarGamepadKey(isHidden)
  if not (self.ParentWidget and self.ParentWidget.Activity_Tab and self.ParentWidget.Activity_Tab.WBP_Com_Tab_ResourceBar) or not self.ParentWidget.Activity_Tab.WBP_Com_Tab_ResourceBar.HideGamePadKey then
    return
  end
  local shouldHide = true == isHidden or not IsGamepadInputActive()
  self.ParentWidget.Activity_Tab.WBP_Com_Tab_ResourceBar:HideGamePadKey(shouldHide)
end

function M:OnClaimAllBtnVisibilityChanged(isVisible)
  self.IsClaimAllBtnVisible = true == isVisible
  self:RefreshGamepadActionButtonHints()
  self:RefreshParentActivityKeyTips()
end

function M:HandlePreviewKeyDownInPage(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "SpaceBar" == InKeyName then
    self:OnSpaceBarKeyDown()
    return true
  end
  return false
end

function M:OnSpaceBarKeyDown()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not self:HasClaimableReward(Avatar) then
    return
  end
  self:OnClickClaimAll()
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    return self:OnGamePadButtonDown(InKeyName)
  end
  return false
end

function M:OnGamePadButtonDown(InKeyName)
  return self:Handle_KeyDownOnGamePad(InKeyName)
end

function M:MoveRewardListFocus(direction)
  if not direction or 0 == direction or not self.RewardItemContents then
    return false
  end
  local maxIndex = #self.RewardItemContents
  if maxIndex <= 0 then
    return false
  end
  local currentIndex = self:GetFocusedRewardIndex()
  local targetIndex = math.min(math.max((currentIndex or 1) + direction, 1), maxIndex)
  if targetIndex == currentIndex then
    return true
  end
  return self:FocusRewardItemByIndex(targetIndex)
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  local Key = UIConst.GamePadKey
  if InKeyName == Key.SpecialRight then
    if self.IsInListFocus then
      return true
    end
    if self:CanOpenActivityRuleByGamePad() then
      self:ViewInfoBtnClick()
      return true
    end
    return false
  end
  if self.IsInListFocus then
    if self.IsRewardTipsOpen then
      if InKeyName == Key.RightThumb or InKeyName == Key.LeftThumb or InKeyName == Key.SpecialRight or InKeyName == Key.SpecialLeft or InKeyName == Key.FaceButtonTop or InKeyName == Key.FaceButtonLeft or InKeyName == Key.DPadUp or InKeyName == Key.DPadDown or InKeyName == Key.LeftStickUp or InKeyName == Key.LeftStickDown then
        return true
      end
      return false
    end
    if InKeyName == Key.DPadUp or InKeyName == Key.DPadDown or InKeyName == Key.LeftStickUp or InKeyName == Key.LeftStickDown then
      return true
    end
    if InKeyName == Key.DPadRight or InKeyName == Key.DPadLeft or InKeyName == Key.LeftStickRight or InKeyName == Key.LeftStickLeft then
      local rewardWidget = self:GetCurrentRewardSelectedWidget()
      local direction = (InKeyName == Key.DPadRight or InKeyName == Key.LeftStickRight) and 1 or -1
      if rewardWidget and rewardWidget.IsRewardComItemFocused and rewardWidget:IsRewardComItemFocused() and rewardWidget.MoveRewardComItemFocus then
        local movedInItem = rewardWidget:MoveRewardComItemFocus(direction)
        if movedInItem then
          return true
        end
      end
      return self:MoveRewardListFocus(direction)
    end
    if InKeyName == Key.RightThumb or InKeyName == Key.LeftThumb or InKeyName == Key.FaceButtonTop or InKeyName == Key.FaceButtonLeft then
      return true
    end
    if InKeyName == Key.FaceButtonBottom then
      return self:OnListItemConfirm()
    elseif InKeyName == Key.FaceButtonRight then
      local rewardWidget = self:GetCurrentRewardSelectedWidget()
      if rewardWidget and rewardWidget.IsRewardComItemFocused and rewardWidget:IsRewardComItemFocused() then
        if rewardWidget.FocusRewardItemSelf then
          rewardWidget:FocusRewardItemSelf()
        end
        return true
      end
      return self:LeaveListFocus()
    end
  elseif InKeyName == Key.LeftThumb then
    return self:EnterListFocus()
  elseif InKeyName == Key.FaceButtonTop then
    if self.IsUnlocked then
      self:OnClickClaimAll()
    else
      self:OnClickUnlock()
    end
    return true
  elseif InKeyName == Key.FaceButtonBottom then
    self:OnClickSkinTask()
    return true
  end
  return false
end

function M:EnterListFocus()
  if self.IsInListFocus then
    return true
  end
  local containerType, listContainer = self:GetRewardListContainer()
  if "ListView" == containerType and listContainer and IsValid(listContainer) and listContainer.SetNavigationRuleBase then
    listContainer:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    listContainer:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    listContainer:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    listContainer:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  end
  self.IsInListFocus = true
  self.IsRewardTipsOpen = false
  local focusedIndex = 1
  if not self:FocusRewardItemByIndex(focusedIndex) then
    self.IsInListFocus = false
    return false
  end
  if self.ParentWidget and self.ParentWidget.EnterForbiddenState then
    self.ParentWidget:EnterForbiddenState()
  end
  if self.ParentWidget and self.ParentWidget.UpdateCommonWidgetsStyleInPlatform then
    self.ParentWidget:UpdateCommonWidgetsStyleInPlatform(false)
  end
  self:SetResourceBarGamepadKeyHidden(true)
  self:RefreshGamepadActionButtonHints()
  self:RefreshFocusedRewardItemGamepadHint(true)
  self:RefreshParentActivityKeyTips()
  return true
end

function M:LeaveListFocus(bRefocusParent)
  if not self.IsInListFocus then
    return false
  end
  self.IsInListFocus = false
  self.IsRewardTipsOpen = false
  if self.ParentWidget and self.ParentWidget.LeaveForbiddenState then
    self.ParentWidget:LeaveForbiddenState()
  end
  if self.ParentWidget and self.ParentWidget.UpdateCommonWidgetsStyleInPlatform then
    local isGamepad = UIUtils and UIUtils.IsGamepadInput and UIUtils.IsGamepadInput()
    self.ParentWidget:UpdateCommonWidgetsStyleInPlatform(isGamepad)
  end
  self:SetResourceBarGamepadKeyHidden(false)
  self:RefreshFocusedRewardItemGamepadHint(false)
  self:RefreshGamepadActionButtonHints()
  self:RefreshParentActivityKeyTips()
  if false ~= bRefocusParent and self.ParentWidget then
    self.ParentWidget:SetFocus()
  end
  return true
end

function M:GetCurFocusWidgetInfo()
  if self.IsInListFocus then
    if self.IsRewardTipsOpen then
      return "EmptyView", self:GetCurrentRewardSelectedWidget()
    end
    return "ReceiveRewardView", self:GetCurrentRewardSelectedWidget()
  end
  if self.IsClaimAllBtnVisible then
    return "GetAllReward", nil
  end
  return nil, nil
end

function M:ReceiveEnterStateSelf(StackAction)
  if 1 == StackAction then
    if self.IsInListFocus then
      local _, listContainer = self:GetRewardListContainer()
      local listStillFocused = listContainer and IsValid(listContainer) and listContainer.HasFocusedDescendants and listContainer:HasFocusedDescendants()
      if not listStillFocused then
        self:LeaveListFocus(false)
        return
      end
    end
    self:RefreshParentActivityKeyTips()
  end
end

function M:OnGetItemPageClosed()
  if self.IsInListFocus then
    self:LeaveListFocus(false)
  end
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad)
  if not IsUseGamePad and self.IsInListFocus then
    self:LeaveListFocus()
    return
  end
  self:RefreshGamepadActionButtonHints()
  self:RefreshFocusedRewardItemGamepadHint(IsUseGamePad and self.IsInListFocus and not self.IsRewardTipsOpen)
end

function M:OnListItemConfirm()
  local selectedContent = self:GetCurrentRewardSelectedContent()
  if not selectedContent then
    return false
  end
  if selectedContent.bCanGet then
    return self:TryClaimRewardByIndex(selectedContent.Index)
  else
    return self:OpenCurrentRewardTips()
  end
end

function M:GetDefaultBottomTips()
  local owner = self.ParentWidget or self
  return {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_Controller_CheckReward")
    },
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = owner.OnReturnKeyDown,
          Owner = owner
        }
      },
      Desc = GText("UI_Tips_Close")
    }
  }
end

function M:GetListFocusBottomTips()
  local selectedContent = self:GetCurrentRewardSelectedContent()
  local aDesc = selectedContent and selectedContent.bCanGet and GText("UI_CTL_Claim") or GText("UI_Tips_Ensure")
  return {
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          ClickCallback = self.OnListItemConfirm,
          Owner = self
        }
      },
      Desc = aDesc
    },
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.LeaveListFocus,
          Owner = self
        }
      },
      Desc = GText("UI_Tips_Close")
    }
  }
end

return M
