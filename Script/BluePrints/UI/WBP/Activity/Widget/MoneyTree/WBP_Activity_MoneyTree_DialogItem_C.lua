require("UnLua")
local UIUtils = require("Utils.UIUtils")
local MoneyTreeMgr = require("BluePrints.UI.WBP.Activity.Widget.MoneyTree.MoneyTreeMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local TXT = {
  Today = "UI_Today",
  DayFormat = "MoneyTree_Dialog_DayFormat"
}
local TODAY_COLOR = UE4.UUIFunctionLibrary.StringToSlateColor("FFD98EFF")

function M:Construct()
  self.bIsFocusable = true
  self._RowIndex = 0
  self._DayLeft = 0
  self._DayRight = 0
  self._NormalDayColorLeft = IsValid(self.Text_Day_Singular) and self.Text_Day_Singular.ColorAndOpacity or nil
  self._NormalDayColorRight = IsValid(self.Text_Day_Dual) and self.Text_Day_Dual.ColorAndOpacity or nil
end

function M:OnListItemObjectSet(Content)
  if not Content then
    return
  end
  self.Content = Content
  self:SetData(Content.RowIndex or 0, Content)
end

function M:SetData(_, RowData)
  if not RowData then
    return
  end
  self._RowIndex = RowData.RowIndex or 0
  self._DayLeft = RowData.DayLeft or 0
  self._DayRight = RowData.DayRight or 0
  local CurrentDay = RowData.CurrentDay or 0
  if self.Group_BG then
    local bShowBG = 0 == self._RowIndex % 2
    self.Group_BG:SetVisibility(bShowBG and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  self:RefreshColumn(self._DayLeft, CurrentDay, self.Tag_Today, self.Text_Today, self.Text_Day_Singular, self.Icon_Reward, self.Text_Num, self._NormalDayColorLeft)
  self:RefreshColumn(self._DayRight, CurrentDay, self.Tag_Today_1, self.Text_Today_1, self.Text_Day_Dual, self.Icon_Reward_1, self.Text_Num_1, self._NormalDayColorRight)
end

function M.RefreshColumn(_, Day, CurrentDay, TagToday, TextToday, TextDay, IconReward, TextNum, NormalDayColor)
  if Day <= 0 then
    if TagToday then
      TagToday:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if TextDay then
      TextDay:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if IconReward then
      IconReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if TextNum then
      TextNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    return
  end
  local bIsToday = Day == CurrentDay
  if TagToday then
    TagToday:SetVisibility(bIsToday and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if TextToday then
    TextToday:SetText(GText(TXT.Today))
  end
  if TextDay then
    TextDay:SetText(string.format(GText(TXT.DayFormat), Day))
    if NormalDayColor then
      TextDay:SetColorAndOpacity(bIsToday and TODAY_COLOR or NormalDayColor)
    elseif bIsToday then
      TextDay:SetColorAndOpacity(TODAY_COLOR)
    end
    TextDay:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  local RewardConfig = MoneyTreeMgr.GetDailyRewardConfig(Day)
  local MinReward = RewardConfig and RewardConfig.MinReward or 0
  local MaxReward = RewardConfig and RewardConfig.MaxReward or 0
  if IconReward then
    local ResourceData = RewardConfig and DataMgr.Resource and DataMgr.Resource[RewardConfig.ResourceId]
    local IconObject = ResourceData and ResourceData.Icon and LoadObject(ResourceData.Icon)
    if IsValid(IconObject) then
      IconReward:SetBrushResourceObject(IconObject)
    end
    IconReward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if TextNum then
    local NumText = MinReward == MaxReward and tostring(MinReward) or string.format("%d~%d", MinReward, MaxReward)
    TextNum:SetText(NumText)
    TextNum:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:OnAddedToFocusPath(_)
  if not UIUtils.IsGamepadInput() then
    return
  end
  local Owner = self.Content and self.Content.Owner
  if Owner and IsValid(Owner) and IsValid(Owner.List_Reward) then
    Owner.GamepadFocusedIndex = Owner.List_Reward:GetIndexForItem(self.Content)
  end
end

return M
