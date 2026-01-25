require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Super.Construct(self)
  self:AddDispatcher(EventID.OnPreRaidRankInfo, self, self.OnPreRaidRankInfo)
  self:AddDispatcher(EventID.OnRaidRankInfo, self, self.OnRaidRankInfo)
  self.Btn_Check.Btn_Click.OnClicked:Add(self, self.OpenGuildWarRewardPop)
  self.UpdateInsideBoardTime = 60
end

function M:Destruct()
  self.Super.Destruct(self)
  self:ClearUpdateTimer()
end

function M:Init()
  if not self.Avatar then
    self.Avatar = GWorld:GetAvatar()
    if not self.Avatar then
      return
    end
  end
  self.bAnimation = true
  self:UpdateSeasonData()
  self:ClearUpdateTimer()
  self:TryRaidSeasonRankInfo()
  self.Text_Highest:SetText(GText("RaidDungeon_Max_Point"))
  if self.RaidSeasons:IsPreRaidTime() then
    self.Text_Standard:SetText(GText("RaidDungeon_NextRank_Point"))
    self.Text_Type:SetText(GText("RaidDungeon_PreRaid_Rank"))
    self.Panel_RewardBtn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Reward:SetText(GText("UI_Event_MidTerm_GotoPreview"))
  elseif self.RaidSeasons:IsRaidTime() then
    self.Panel_RewardBtn:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Standard:SetText(GText("RaidDungeon_Raid_Rank_Title"))
    self.Text_Type:SetText(GText("RaidDungeon_Raid_Rank"))
  end
  self.UpdateInsideBoardTimer = self:AddTimer(self.UpdateInsideBoardTime, self.TryRaidSeasonRankInfo, true, 0, "UpdateGuildWar_InsideBoard", true)
end

function M:TryRaidSeasonRankInfo()
  if self.RaidSeasons:IsPreRaidTime() then
    self.Avatar:RaidSeasonGetPreRaidRankInfo()
  elseif self.RaidSeasons:IsRaidTime() then
    self.Avatar:RaidSeasonGetRaidRankInfo()
  end
end

function M:UpdateSeasonData()
  if not self.Avatar then
    return
  end
  self.CurrentRaidSeasonId = self.Avatar.CurrentRaidSeasonId
  self.RaidSeasons = self.Avatar.RaidSeasons[self.CurrentRaidSeasonId]
  self.RaidSeasonData = DataMgr.RaidSeason[self.RaidSeasons.RaidSeasonId]
  self.PreRaidRankData = DataMgr.PreRaidRank[self.RaidSeasonData.PreRaidRank]
end

function M:ClearUpdateTimer()
  if self:IsExistTimer(self.UpdateInsideBoardTimer) then
    self:RemoveTimer(self.UpdateInsideBoardTimer)
    self.UpdateInsideBoardTimer = nil
  end
end

function M:UpdateShow()
  self:UpdateSeasonData()
  local Season = self.RaidSeasons
  if not Season then
    return
  end
  self.WS_Rank:SetActiveWidgetIndex(0)
  local RankIcon
  if Season:IsPreRaidTime() then
    self.Text_Tip01:SetVisibility(ESlateVisibility.Collapsed)
    if 0 == Season.MaxPreRaidScore or 1 == Season.BanState then
      self.WS_Rank:SetActiveWidgetIndex(1)
      self.WS_Row01:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.WS_Rank:SetActiveWidgetIndex(0)
      if 1 == self.RankInfo.PreRaidGroupId then
        self.WS_Row01:SetVisibility(ESlateVisibility.Collapsed)
      else
        self.WS_Row01:SetActiveWidgetIndex(0)
        self.Text_Num:SetText(self.RankInfo and self.RankInfo.NextScore or 0)
        self.WS_Row01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      end
    end
    RankIcon = self["Rank_" .. self.RankInfo.PreRaidGroupId]
  elseif Season:IsRaidTime() then
    if 0 == Season.MaxPreRaidScore or 1 == Season.BanState then
      self.Text_Tip01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.WS_Rank:SetActiveWidgetIndex(1)
      self.WS_Row01:SetActiveWidgetIndex(1)
      self.WS_Row02:SetActiveWidgetIndex(0)
      self.Text_Tip01:SetText(GText("RaidDungeon_PreRaid_Abandon"))
      self.Text_Tip02:SetText(GText("RaidDungeon_PreRaid_Reward"))
    else
      self.Text_Tip01:SetVisibility(ESlateVisibility.Collapsed)
      self.WS_Row01:SetActiveWidgetIndex(0)
      self.WS_Row02:SetActiveWidgetIndex(0)
      self.Text_Num:SetText(self.Rank or GText("UI_CHAR_FORCE_1101"))
      self.WS_Rank:SetActiveWidgetIndex(0)
      if self.bAnimation then
        AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_add_rank", nil, nil)
        self:PlayAnimation(self.Ranking_Up)
      end
    end
    DebugPrint("Season.PreRaidGroupId  " .. Season.PreRaidGroupId)
    RankIcon = self["Rank_" .. Season.PreRaidGroupId]
  end
  local ScoreText = Season:IsPreRaidTime() and Season.MaxPreRaidScore or Season.MaxRaidScore
  if RankIcon then
    local IconDynaMaterial = self.Icon_Rank:GetDynamicMaterial()
    if IconDynaMaterial then
      IconDynaMaterial:SetTextureParameterValue("MainTex", RankIcon)
    end
    if self.bAnimation then
      AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_add_level", nil, nil)
      self:PlayAnimation(self.Rank_Up)
    end
  end
  self.Text_Score:SetText(ScoreText)
  self.bAnimation = false
end

function M:OnPreRaidRankInfo(RankInfo)
  self.RankInfo = RankInfo
  self:UpdateShow()
end

function M:OnRaidRankInfo(RankInfo)
  self.Rank = RankInfo.Rank or -1
  self:UpdateShow()
end

function M:OpenGuildWarRewardPop()
  local GuildWarRewardPop = UIManager(self):LoadUINew("GuildWarRewardPop")
  GuildWarRewardPop:Init()
end

return M
