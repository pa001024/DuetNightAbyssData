require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local EnumPlayerSignRewardState = ActivityUtils.EnumPlayerSignRewardState
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function BuildItemContent(Owner, RewardData, RewardIndex, RewardState)
  local ItemId = RewardData.Id and RewardData.Id[RewardIndex]
  local ItemType = RewardData.Type and RewardData.Type[RewardIndex]
  if not ItemId or not ItemType then
    return nil
  end
  return {
    ParentWidget = Owner,
    Id = ItemId,
    ItemType = ItemType,
    Count = RewardUtils:GetCount(RewardData.Count and RewardData.Count[RewardIndex] or 0),
    Icon = ItemUtils.GetItemIconPath(ItemId, ItemType),
    Rarity = ItemUtils.GetItemRarity(ItemId, ItemType) or 1,
    IsShowDetails = true,
    UIName = "Activity14DaySignRewardItem",
    bCanGet = RewardState == EnumPlayerSignRewardState.SignedNotRecv,
    bHasGot = RewardState == EnumPlayerSignRewardState.Completed,
    bAllUseAsyncLoadWidget = false
  }
end

function M:InitReward(Index, ConfigData, ParentWidget)
  self.Index = Index
  self.SourceDay = ConfigData.SourceDay or Index
  self.ActivityId = ConfigData.ActivityId
  self.RewardId = ConfigData.RewardId
  self.ParentWidget = ParentWidget
  self.IsBigReward = ConfigData.IsBigReward
  self.CanReceiveReward = ConfigData.CanReceiveReward ~= false
  self.RewardData = DataMgr.Reward[self.RewardId]
  if self.Text_Day then
    local Language = CommonConst.SystemLanguage
    local text
    if Language == CommonConst.SystemLanguages.CN or Language == CommonConst.SystemLanguages.TC then
      text = "Day"
    else
      text = GText("UI_Event_14LoginEvent_Day")
    end
    self.Text_Day:SetText(text)
  end
  if self.Text_DayNum then
    self.Text_DayNum:SetText(tostring(self.SourceDay))
  end
  if self.WS_Bg then
    self.WS_Bg:SetActiveWidgetIndex(self.IsBigReward and 1 or 0)
  end
  if self.Btn_Click then
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnClicked:Add(self, self.OnClickReward)
  end
  self:RefreshRewardByState(ConfigData.RewardState or EnumPlayerSignRewardState.NotSign)
end

function M:RefreshRewardItems()
  for RewardIndex = 1, 2 do
    local ItemWidget = self["Item0" .. RewardIndex]
    local Content = self.RewardData and BuildItemContent(self, self.RewardData, RewardIndex, self.CurRewardState)
    if ItemWidget then
      if Content then
        ItemWidget:SetVisibility(UIConst.VisibilityOp.Visible)
        if ItemWidget.Init then
          ItemWidget:Init(Content)
        end
      else
        ItemWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    end
  end
  self:UpdateInnerNavigation()
end

function M:PlayAnimByRewardState(RewardState)
  self:StopAllAnimations()
  if RewardState == EnumPlayerSignRewardState.Completed and self.Get then
    self:PlayAnimation(self.Get)
  elseif RewardState == EnumPlayerSignRewardState.SignedNotRecv and self.Reward then
    self:PlayAnimation(self.Reward)
  elseif self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function M:RefreshRewardByState(RewardState)
  local OldRewardState = self.CurRewardState
  self.CurRewardState = RewardState or EnumPlayerSignRewardState.NotSign
  self:RefreshInputStyle(UIUtils.IsGamepadInput())
  self:RefreshRewardItems()
  if nil == OldRewardState or OldRewardState ~= self.CurRewardState then
    self:PlayAnimByRewardState(self.CurRewardState)
  end
end

function M:RefreshInputStyle(IsUseGamePad)
  if not self.Btn_Click then
    return
  end
  local CanShowButton = self.CanReceiveReward and self.CurRewardState == EnumPlayerSignRewardState.SignedNotRecv
  local ButtonVisibility = not IsUseGamePad and CanShowButton and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed
  self.Btn_Click:SetVisibility(ButtonVisibility)
end

function M:GetRewardState()
  return self.CurRewardState
end

function M:TryReceiveReward()
  if not self.CanReceiveReward or self.CurRewardState ~= EnumPlayerSignRewardState.SignedNotRecv then
    return false
  end
  local PlayerAvatar = GWorld:GetAvatar()
  if not PlayerAvatar then
    return false
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  PlayerAvatar:DailyLoginGetReward(self.ActivityId, self.Index)
  return true
end

function M:OnClickReward()
  self:TryReceiveReward()
end

function M:OnAddedToFocusPath(InFocusEvent)
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.Hover then
    self:PlayAnimation(self.Hover)
    self.IsHovering = true
  end
  if self.ParentWidget and self.ParentWidget.UpdateParentActivityKeyTips then
    self.ParentWidget:UpdateParentActivityKeyTips("ACheckRewardView", self, false)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if not self.IsHovering then
    return
  end
  if self.Unhover then
    self:PlayAnimation(self.Unhover)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:BP_GetDesiredFocusTarget()
  if self.Item01 and self.Item01:IsVisible() then
    return self.Item01
  end
  return self.Item02 or self.Item01 or self
end

function M:UpdateInnerNavigation()
  if self.Btn_Click then
    self.Btn_Click:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.Btn_Click:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  end
  if self.Item01 then
    self.Item01:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    if self.Item02 and self.Item02:IsVisible() then
      self.Item01:SetNavigationRuleExplicit(EUINavigation.Down, self.Item02)
    else
      self.Item01:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    end
  end
  if self.Item02 then
    self.Item02:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    if self.Item01 and self.Item01:IsVisible() then
      self.Item02:SetNavigationRuleExplicit(EUINavigation.Up, self.Item01)
    else
      self.Item02:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    end
  end
end

return M
