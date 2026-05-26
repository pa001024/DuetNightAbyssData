require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class("BluePrints.UI.WBP.Armory.WBP_Armory_RoleInfo_Base_C")
M._components = {
  "BluePrints.UI.KeyInputComponent"
}

function M:Construct()
  M.Super.Construct(self)
  self.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RS"}
    }
  })
  self.RewardBtn = self.LevelInfo.Btn_ExpReward.Btn_Area
  self.Button_More.bIsFocusable = true
  self.Btn_Info.bIsFocusable = true
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  if self.IsInFocusPath then
    if self.RewardBtn:IsVisible() then
      if not UIUtils.HasAnyFocus(self.RewardBtn) and not UIUtils.HasAnyFocus(self.Button_More) and not UIUtils.HasAnyFocus(self.Btn_Info) then
        self.RewardBtn:SetFocus()
      end
    elseif not UIUtils.HasAnyFocus(self.Button_More) and not UIUtils.HasAnyFocus(self.Btn_Info) then
      self.Button_More:SetFocus()
    end
  end
  self:ClearAllKeyEvents()
  self:AddKeyDownEvent(UIConst.GamePadKey.RightThumb, self.OnGamepadRightThumbstick)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonTop, self.OnFaceButtonTopKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonLeft, self.OnFaceButtonLeftKeyDown)
  self:AddKeyUpEvent(UIConst.GamePadKey.FaceButtonTop, self.OnFaceButtonTopKeyUp)
  self:AddLongPressEvent(UIConst.GamePadKey.FaceButtonLeft, 1, self.OnGamepad_FaceButton_Left_LongPressStart, self.OnGamepad_FaceButton_Left_LongPressCancel, self.OnGamepad_FaceButton_Left_LongPressEnd)
  if self.UnlockBtnParams and self.UnlockBtnParams.bShowCoin then
    self:AddLongPressEvent(UIConst.GamePadKey.FaceButtonTop, 1, self.OnGamepad_FaceButton_Top_LongPressStart, self.OnGamepad_FaceButton_Top_LongPressCancel, self.OnGamepad_FaceButton_Top_LongPressEnd)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputDevice, CurGamepadName)
  if self.IsGamepadInput then
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
  else
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
  end
end

function M:CollectVisibleWidgets()
  if not self._AllWidgets then
    self._AllWidgets = {
      {
        Widget = self.RewardBtn,
        Visible = function()
          return self.LevelInfo:GetBtnExpRewardVisible()
        end
      },
      {
        Widget = self.Button_More,
        Visible = function()
          return self.Tag == "Melee" or self.Tag == "Ranged"
        end
      },
      {
        Widget = self.PosItem,
        Visible = function()
          return self.Tag == "Char"
        end
      },
      {
        Widget = self.Btn_Info,
        Visible = function()
          return self.Btn_Info and self.Btn_Info:IsVisible()
        end
      }
    }
  end
  local Widgets = {}
  for _, Item in ipairs(self._AllWidgets) do
    if Item.Visible and Item.Visible() then
      table.insert(Widgets, Item.Widget)
    end
  end
  return Widgets
end

function M:InitNavigationRules()
  local Widgets = self:CollectVisibleWidgets()
  if 0 == #Widgets then
    return
  end
  for i, Widget in ipairs(Widgets) do
    Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Escape)
    Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    if 1 == i then
      Widget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    else
      Widget:SetNavigationRuleExplicit(EUINavigation.Up, Widgets[i - 1])
    end
    if i == #Widgets then
      Widget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    else
      Widget:SetNavigationRuleExplicit(EUINavigation.Down, Widgets[i + 1])
    end
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Widgets = self:CollectVisibleWidgets()
  if #Widgets > 0 then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), Widgets[1])
  end
  return UWidgetBlueprintLibrary.Handled()
end

function M:UpdateTargetInfo(...)
  M.Super.UpdateTargetInfo(self, ...)
  if self.Describe:IsVisible() or self.Btn_Info:IsVisible() then
    self.bIsFocusable = true
  else
    self.bIsFocusable = false
  end
end

function M:Init(Params)
  M.Super.Init(self, Params)
  self.Owner = Params.Parent
  self._OnAddedToFocusPath = Params.OnAddedToFocusPath
  self._OnRemovedFromFocusPath = Params.OnRemovedFromFocusPath
  self:InitNavigationRules()
end

function M:OnParentKeyDown(MyGeometry, InKeyEvent)
  return self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
end

function M:OnParentKeyUp(MyGeometry, InKeyEvent)
  return self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
end

function M:OnFaceButtonTopKeyDown()
  if self.IsPreviewMode then
    return
  end
  if 0 == self.WidgetSwitcher_State:GetActiveWidgetIndex() and self.ConfirmBtns[2]:IsVisible() and not self.ConfirmBtns[2].IsForbidden then
    self:OnReplaceBtnClicked()
    return UIUtils.Handled, true
  end
end

function M:OnFaceButtonLeftKeyDown()
  if not self.Btn_MaxSwitch:IsVisible() then
    return
  end
  if self.IsPreviewMode and self.bNeedPreviewSwitcher or self.IsTargetUnowned then
    self.Btn_MaxSwitch:OnClicked()
  end
end

function M:OnGamepad_FaceButton_Left_LongPressStart()
  if self.IsTargetUnowned or not self.bNeedAttrSwitcher then
    return
  end
  if not self.Btn_MaxSwitch:IsVisible() then
    return
  end
  self.Btn_MaxSwitch.Key_Switch:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime(UIConst.GamePadKey.FaceButtonLeft))
end

function M:OnGamepad_FaceButton_Left_LongPressEnd()
  if self.IsTargetUnowned or not self.bNeedAttrSwitcher then
    return
  end
  if not self.Btn_MaxSwitch:IsVisible() then
    return
  end
  self.Btn_MaxSwitch:OnClicked()
end

function M:OnGamepad_FaceButton_Left_LongPressCancel()
  if self.IsTargetUnowned or not self.bNeedAttrSwitcher then
    return
  end
  if not self.Btn_MaxSwitch:IsVisible() then
    return
  end
  self.Btn_MaxSwitch.Key_Switch:OnButtonReleased()
  self.Btn_MaxSwitch.Key_Switch:StopAllAnimations()
  self.Btn_MaxSwitch.Key_Switch:PlayAnimation(self.Btn_MaxSwitch.Key_Switch.Normal)
end

function M:OnFaceButtonTopKeyUp()
  if 1 == self.WidgetSwitcher_State:GetActiveWidgetIndex() and self.Btn_Unlock:IsVisible() and not UIUtils.HasAnyFocus(self.Btn_Unlock) then
    self:OnUnlockBtnClicked()
    return UIUtils.Handled, true
  end
end

function M:OnGamepadRightThumbstick()
  if self.IsShowModButton then
    self:OnModBtnClicked()
    return UIUtils.Handled, true
  end
  if self.Btn_Info:IsVisible() then
    self:OnBtnDetailsClick()
    return UIUtils.Handled, true
  end
end

function M:OnGamepad_FaceButton_Top_LongPressStart()
  self.Btn_Unlock.Key_Consume:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime(UIConst.GamePadKey.FaceButtonTop))
end

function M:OnGamepad_FaceButton_Top_LongPressEnd()
  self.Btn_Unlock:SetFocus()
end

function M:OnGamepad_FaceButton_Top_LongPressCancel()
  self.Btn_Unlock.Key_Consume:OnButtonReleased()
  self.Btn_Unlock.Key_Consume:StopAllAnimations()
  self.Btn_Unlock.Key_Consume:PlayAnimation(self.Btn_Unlock.Key_Consume.Normal)
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath(self.Parent, self)
  end
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
  if self._OnRemovedFromFocusPath then
    self._OnRemovedFromFocusPath(self.Parent, self)
  end
end

function M:OnUnlockBtnParamsCreated(Params)
  function Params.OnAddedToFocusPath(_self, Widget)
  end
  
  function Params.OnRemovedFromFocusPath(_self, Widget)
  end
end

AssembleComponents(M)
return M
