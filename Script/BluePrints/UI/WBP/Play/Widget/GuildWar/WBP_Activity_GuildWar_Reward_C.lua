require("UnLua")
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

function M:Init()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.Text_Group:SetText(GText("RaidDungeon_Rank_Tier"))
  self.Text_Score:SetText(GText("RaidDungeon_Rank_Percentage"))
  self.Text_Reward:SetText(GText("RaidDungeon_Rank_Reward"))
  local CurrentRaidSeasonId = Avatar.CurrentRaidSeasonId
  local RaidSeasons = Avatar.RaidSeasons[CurrentRaidSeasonId]
  local RaidSeasonData = DataMgr.RaidSeason[RaidSeasons.RaidSeasonId]
  local PreRaidRankData = DataMgr.PreRaidRank[RaidSeasonData.PreRaidRank]
  if not PreRaidRankData then
    DebugPrint("[WBP_Activity_GuildWar_Reward_C] 找不到对应的 PreRaidRankData:", RaidSeasonData.PreRaidRank)
    return
  end
  self.List_Reward:ClearListItems()
  local RankPercentArr = PreRaidRankData.RankPercent or {}
  local RankNameArr = PreRaidRankData.RankName or {}
  local RankRewardArr = PreRaidRankData.RankReward or {}
  for i, RankPercent in ipairs(RankPercentArr) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Parent = self
    if 1 == i then
      Content.RankPercent = RankPercent .. "%"
    else
      local prev = RankPercentArr[i - 1]
      Content.RankPercent = string.format("%d%%-%d%%", prev, RankPercent)
    end
    local RankName = RankNameArr[i]
    local RankReward = RankRewardArr[i]
    if RankName then
      Content.RankName = i
    end
    if RankReward then
      Content.RankReward = RankReward
    end
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
  local Item = UIManager(self):GetUIObj("GuildWarLevel")
  local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
  if Item then
    Item:SelectCellFocus()
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
