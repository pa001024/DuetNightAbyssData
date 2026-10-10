require("UnLua")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  M.Super.Construct(self)
  self.Title.Text_Title:SetText(GText("UI_Event_MidTerm_GotoPreview"))
  self.Title.BtnClose.Btn_Close.OnClicked:Add(self, function()
    if not self:IsAnimationPlaying(self.Out) then
      self:PlayAnimation(self.Out)
    end
  end)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self:AddInputMethodChangedListen()
end

function M:Init(Params)
  self.CloseCallback = Params and Params.CloseCallback or nil
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if self.Text_Group then
    self.Text_Group:SetText(GText("RaidDungeon_Rank"))
  end
  if self.Text_Reward then
    self.Text_Reward:SetText(GText("RaidDungeon_Rank_Reward"))
  end
  local SeasonId = Avatar.CurrentRaidSeasonId
  local RaidSeasons = Avatar.RaidSeasons and Avatar.RaidSeasons[SeasonId]
  local PreRaidGroupId = RaidSeasons and RaidSeasons.PreRaidGroupId
  local RankRewardList = GuildWarUtils.GetRaidRankRewardListByGroup(SeasonId, PreRaidGroupId)
  self.List_Reward:ClearListItems()
  for Index, RankRewardData in ipairs(RankRewardList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Parent = self
    local RankRange = RankRewardData.RankRange
    if RankRange and 2 == #RankRange then
      Content.RankPercent = string.format("%d-%d", RankRange[1], RankRange[2])
    end
    Content.RankName = math.min(Index, 5)
    Content.RankReward = RankRewardData.RangeReward
    self.List_Reward:AddItem(Content)
  end
  self.List_Reward:NavigateToIndex(0)
  self:PlayAnimation(self.In)
  self:RefreshControllerUI()
end

function M:RefreshControllerUI()
  local isGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if not isGamepad then
    self.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self.WBox_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Key_CheckReward:SetVisibility(ESlateVisibility.Collapsed)
  self.Key_Check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Key_Check:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    Desc = GText("UI_Controller_Check")
  })
  self.Key_Close:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Key_Close:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_BACK")
  })
end

function M:OnReturnKeyDown()
  AudioManager(self):SetEventSoundParam(self, "Play_DeputeDetail", {ToEnd = 1})
  self.Super.Close(self)
  if self.CloseCallback then
    local Callback = self.CloseCallback
    self.CloseCallback = nil
    Callback(self)
    return
  end
  local Item = UIManager(self):GetUIObj("GuildWarLevel")
  local FloorItem = UIManager(self):GetUIObj("GuildWarFloorLevel")
  local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
  if Item then
    Item:SelectCellFocus()
  elseif FloorItem then
    FloorItem:SelectCellFocus()
  elseif ActivityMain then
    ActivityMain:SetFocus()
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:OnReturnKeyDown()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName and not self:IsAnimationPlaying(self.Out) then
    self:PlayAnimation(self.Out)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
    self.List_Reward:NavigateToIndex(0)
  end
  self:RefreshControllerUI()
end

return M
