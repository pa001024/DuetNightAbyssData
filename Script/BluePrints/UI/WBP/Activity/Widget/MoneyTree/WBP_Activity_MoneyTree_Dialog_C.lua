require("UnLua")
local MoneyTreeMgr = require("BluePrints.UI.WBP.Activity.Widget.MoneyTree.MoneyTreeMgr")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})
local TXT = {
  Title_Days = "MoneyTree_Dialog_Title_Days",
  Title_Reward = "MoneyTree_Dialog_Title_Reward"
}

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.GamepadFocusedIndex = 0
  local TotalDays = MoneyTreeMgr.GetTotalDays()
  local CurrentDay = MoneyTreeMgr.GetCurrentDay()
  if IsValid(self.Text_Days) then
    self.Text_Days:SetText(GText(TXT.Title_Days))
  end
  if IsValid(self.Text_Days_1) then
    self.Text_Days_1:SetText(GText(TXT.Title_Days))
  end
  if IsValid(self.Text_RewardNum) then
    self.Text_RewardNum:SetText(GText(TXT.Title_Reward))
  end
  if IsValid(self.Text_RewardNum_1) then
    self.Text_RewardNum_1:SetText(GText(TXT.Title_Reward))
  end
  if IsValid(self.List_Reward) then
    self.List_Reward:ClearListItems()
    local RowCount = math.ceil(TotalDays / 2)
    for RowIdx = 1, RowCount do
      local DayLeft = (RowIdx - 1) * 2 + 1
      local DayRight = RowIdx * 2
      if TotalDays < DayRight then
        DayRight = 0
      end
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.RowIndex = RowIdx
      Content.DayLeft = DayLeft
      Content.DayRight = DayRight
      Content.CurrentDay = CurrentDay
      Content.Owner = self
      self.List_Reward:AddItem(Content)
    end
    self.List_Reward:RequestRefresh()
  end
  if IsValid(self.List_Reward) then
    self.List_Reward:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
    self.List_Reward:SetFocus()
  end
end

function M:InitGamepadView()
  self:ShowGamepadCloseBtn(true)
  self:RefreshScrollHintDeferred()
  self:FocusListDeferred()
end

function M:InitKeyboardView()
  self:ShowGamepadCloseBtn(false)
  self:ShowGamepadScrollBtn(false)
end

function M:OnContentAnalogValueChanged(_, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName ~= UIConst.GamePadKey.RightAnalogY or not IsValid(self.List_Reward) then
    return UIUtils.Unhandled
  end
  local DeltaOffset = -UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  self.List_Reward:SetScrollOffset(self.List_Reward:GetScrollOffset() + DeltaOffset)
  return UIUtils.Handled
end

function M:RefreshScrollHintDeferred(RetryCount)
  RetryCount = RetryCount or 0
  self:AddTimer(0.05, function()
    if not IsValid(self) or not IsValid(self.List_Reward) then
      return
    end
    local MaxOffset = UIUtils.GetMaxScrollOffsetOfListView(self.List_Reward)
    if MaxOffset <= 0 and self.List_Reward:GetNumItems() > 0 and RetryCount < 3 then
      self:RefreshScrollHintDeferred(RetryCount + 1)
      return
    end
    self:ShowGamepadScrollBtn(MaxOffset > 0.01)
  end, false)
end

function M:OnContentFocusReceived(_, _)
  if UIUtils.IsGamepadInput() and IsValid(self.List_Reward) and not self.List_Reward:HasAnyUserFocus() and not self.List_Reward:HasFocusedDescendants() then
    local Idx = self.GamepadFocusedIndex or 0
    self.List_Reward:NavigateToIndex(Idx)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:FocusListDeferred()
  self:AddTimer(0.05, function()
    if not IsValid(self) then
      return
    end
    if not IsValid(self.List_Reward) then
      return
    end
    local Num = self.List_Reward:GetNumItems()
    if Num <= 0 then
      return
    end
    local Idx = self.GamepadFocusedIndex or 0
    if Idx < 0 or Num <= Idx then
      Idx = 0
    end
    self.List_Reward:NavigateToIndex(Idx)
    self.List_Reward:SetFocus()
  end, false)
end

return M
