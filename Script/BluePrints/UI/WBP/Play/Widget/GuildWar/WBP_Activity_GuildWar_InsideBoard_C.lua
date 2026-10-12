require("UnLua")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
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

function M:Init(Owner)
  if not self.Avatar then
    self.Avatar = GWorld:GetAvatar()
    if not self.Avatar then
      return
    end
  end
  self.Owner = Owner
  self.bAnimation = true
  self:UpdateSeasonData()
  self:ClearUpdateTimer()
  self:TryRaidSeasonRankInfo()
  self:Init_Floor()
  self.Text_Highest:SetText(GText("RaidDungeon_Max_Point"))
  if self.RaidSeasons:IsPreRaidTime() then
    self.Text_Standard:SetText(GText("RaidDungeon_NextRank_Point"))
    self.Text_Type:SetText(GText("RaidDungeon_PreRaid_Rank"))
    self.Panel_RewardBtn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Reward:SetText(GText("UI_Event_MidTerm_GotoPreview"))
  elseif self.RaidSeasons:IsRaidTime() then
    if CommonConst.RaidSeasonType.Score == self.RaidSeasonType then
      self.Panel_RewardBtn:SetVisibility(ESlateVisibility.Collapsed)
    end
    if CommonConst.RaidSeasonType.Floor == self.RaidSeasonType then
      self.Text_Reward:SetText(GText("UI_Event_MidTerm_GotoPreview"))
      self.Panel_RewardBtn:SetVisibility(self:HasRaidRankRewardPreview() and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    end
    self.Text_Standard:SetText(GText("RaidDungeon_Raid_Rank_Title"))
    self.Text_Type:SetText(GText("RaidDungeon_Raid_Rank"))
  end
  self.UpdateInsideBoardTimer = self:AddTimer(self.UpdateInsideBoardTime, self.TryRaidSeasonRankInfo, true, 0, "UpdateGuildWar_InsideBoard", true)
  if CommonConst.RaidSeasonType.Floor == self.RaidSeasonType then
    self.WS_Row01:SetActiveWidgetIndex(2)
    self.WS_Row02:SetActiveWidgetIndex(1)
    self.Text_History:SetText(GText("Raid_Season_Floor_History"))
    self.Text_Advance:SetText(GText("Raid_Season_Floor_Standard"))
  end
end

function M:Init_Floor()
  local curRaidSeasonData = self.RaidSeasons
  if curRaidSeasonData and DataMgr.RaidSeason then
    self.CurRaidSeasonId = curRaidSeasonData.RaidSeasonId
    self.RaidSeasonTableData = DataMgr.RaidSeason[curRaidSeasonData.RaidSeasonId]
    self.RaidDungeonType = curRaidSeasonData:IsPreRaidTime() and CommonConst.RaidState.PreRaid or curRaidSeasonData:IsRaidTime() and CommonConst.RaidState.Raid or nil
    if self.RaidSeasonTableData then
      self.RaidSeasonType = self.RaidSeasonTableData.RaidSeasonType
    end
  end
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
  if CommonConst.RaidSeasonType.Score == self.RaidSeasonType then
    if Season:IsPreRaidTime() then
      if 1 == Season.BanState then
        self.Panel_Tip01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Ban:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.WS_Rank:SetActiveWidgetIndex(2)
        self.Text_Ban:SetText(GText("RaidDungeon_Rank_Ban"))
        self.Text_Tip01:SetText(GText("RaidDungeon_Rank_Empty"))
        self.Panel_RewardBtn:SetVisibility(ESlateVisibility.Collapsed)
      else
        self.Panel_Tip01:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Ban:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_RewardBtn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if 0 == Season.MaxPreRaidScore then
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
      end
      RankIcon = self["Rank_" .. self.RankInfo.PreRaidGroupId]
    elseif Season:IsRaidTime() then
      if 1 == Season.BanState then
        self.Panel_Tip01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Ban:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.WS_Rank:SetActiveWidgetIndex(2)
        self.WS_Row01:SetActiveWidgetIndex(1)
        self.WS_Row02:SetActiveWidgetIndex(0)
        self.Text_Ban:SetText(GText("RaidDungeon_Rank_Ban"))
        self.Text_Tip01:SetText(GText("RaidDungeon_Rank_Empty"))
        self.Text_Tip02:SetText(GText("RaidDungeon_PreRaid_Reward"))
      else
        self.Panel_Ban:SetVisibility(ESlateVisibility.Collapsed)
        if 0 == Season.MaxPreRaidScore then
          self.Panel_Tip01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
          self.WS_Rank:SetActiveWidgetIndex(1)
          self.WS_Row01:SetActiveWidgetIndex(1)
          self.WS_Row02:SetActiveWidgetIndex(0)
          self.Text_Tip01:SetText(GText("RaidDungeon_PreRaid_Abandon"))
          self.Text_Tip02:SetText(GText("RaidDungeon_PreRaid_Reward"))
        else
          self.Panel_Tip01:SetVisibility(ESlateVisibility.Collapsed)
          self.WS_Row01:SetActiveWidgetIndex(0)
          self.WS_Row02:SetActiveWidgetIndex(0)
          self.Text_Num:SetText(self.Rank or GText("UI_CHAR_FORCE_1101"))
          self.WS_Rank:SetActiveWidgetIndex(0)
          if self.bAnimation then
            AudioManager(self):PlayUISound(self, "event:/ui/activity/gerengonghuizhan_add_rank", nil, nil)
            self:PlayAnimation(self.Ranking_Up)
          end
        end
      end
    end
  end
  local ScoreText = Season:IsPreRaidTime() and Season.MaxPreRaidScore or Season.MaxRaidScore
  local curPreRaidGroupId = Season.PreRaidGroupId
  if Season:IsPreRaidTime() then
    curPreRaidGroupId = self.RankInfo.PreRaidGroupId
  end
  DebugPrint("Season.PreRaidGroupId  " .. curPreRaidGroupId)
  RankIcon = self["Rank_" .. curPreRaidGroupId]
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
  self:UpdateShow_Floor()
end

function M:UpdateShow_Floor()
  self.WS_Rank:SetActiveWidgetIndex(0)
  if CommonConst.RaidSeasonType.Floor == self.RaidSeasonType then
    self.Panel_Ban:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Tip01:SetVisibility(ESlateVisibility.Collapsed)
    self.WS_Row02:SetVisibility(ESlateVisibility.Collapsed)
    if self.RaidSeasons:IsBaned() then
      self.Panel_Ban:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Text_Ban:SetText(GText("RaidDungeon_Rank_Ban"))
      self.WS_Rank:SetActiveWidgetIndex(2)
      self.WS_Row02:SetVisibility(ESlateVisibility.Collapsed)
      return
    end
    if CommonConst.RaidState.PreRaid == self.RaidDungeonType then
      if self.RankInfo and self.RankInfo.PreRaidGroupId > 0 then
        self.WS_Row01:SetActiveWidgetIndex(2)
        self.Text_History:SetText(GText("Raid_Season_Floor_History"))
        self.Text_HistoryFloor:SetText(self.RaidSeasons.PreRaidFloor)
        self.Text_HistoryTime:SetText(UIUtils.FormatSeconds(self:GetDungeonTimeLimit() - self.RaidSeasons.PreRaidFloorPassTime))
        if not (1 ~= self.RankInfo.PreRaidGroupId and self.RankInfo.NextFloor) or not self.RankInfo.NextPassTime then
          self.WS_Row02:SetVisibility(ESlateVisibility.Collapsed)
        else
          self.WS_Row02:SetActiveWidgetIndex(1)
          self.Text_Advance:SetText(GText("Raid_Season_Floor_Standard"))
          self.Text_AdvanceFloor:SetText(self.RankInfo.NextFloor)
          self.Text_AdvanceTime:SetText(UIUtils.FormatSeconds(self:GetDungeonTimeLimit() - self.RankInfo.NextPassTime))
          self.WS_Row02:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
      else
        self.WS_Rank:SetActiveWidgetIndex(1)
        self.WS_Row01:SetActiveWidgetIndex(1)
        self.Text_Tip02:SetText(GText("RaidDungeon_PreRaid_Abandon"))
        self.WS_Row02:SetVisibility(ESlateVisibility.Collapsed)
      end
    elseif CommonConst.RaidState.Raid == self.RaidDungeonType then
      if self.RaidSeasons and self.RaidSeasons.PreRaidGroupId > 0 then
        if not self.Rank or self.Rank <= 0 then
          self.WS_Row01:SetActiveWidgetIndex(1)
          self.Text_Tip02:SetText(GText("UI_AppearanceScore_NoRanktoast"))
          self.WS_Row02:SetVisibility(ESlateVisibility.Collapsed)
        else
          self.WS_Row01:SetActiveWidgetIndex(0)
          self.Text_Standard:SetText(GText("RaidDungeon_Raid_Rank_Title"))
          self.Text_Num:SetText(self.Rank or GText("UI_CHAR_FORCE_1101"))
          self.WS_Row02:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
          self.WS_Row02:SetActiveWidgetIndex(1)
          self.Text_Advance:SetText(GText("Raid_Season_Floor_History"))
          self.Text_AdvanceFloor:SetText(self.RaidSeasons.RaidFloor)
          self.Text_AdvanceTime:SetText(UIUtils.FormatSeconds(self:GetDungeonTimeLimit() - self.RaidSeasons.RaidFloorPassTime))
        end
      else
        self.WS_Row01:SetActiveWidgetIndex(1)
        self.Text_Tip02:SetText(GText("RaidDungeon_PreRaid_Abandon"))
        self.WS_Row02:SetVisibility(ESlateVisibility.Collapsed)
        self.WS_Rank:SetActiveWidgetIndex(1)
      end
    end
  end
end

function M:SetDungeonId(DungeonId)
  self.CurDungeonId = DungeonId
end

function M:GetDungeonTimeLimit()
  local dungeonTableData = DataMgr.Dungeon[self.CurDungeonId]
  local dungeonTimeLimit = dungeonTableData.BPOverrideVars.TimeLimit
  if self.CurDungeonId and dungeonTableData and dungeonTimeLimit then
    return dungeonTimeLimit
  end
  return 0
end

function M:OnPreRaidRankInfo(RankInfo)
  self.RankInfo = RankInfo
  self:UpdateShow()
end

function M:OnRaidRankInfo(RankInfo)
  self.Rank = RankInfo.Rank or -1
  self:UpdateShow()
end

function M:HasRaidRankRewardPreview()
  if not self.RaidSeasons then
    return false
  end
  return GuildWarUtils.HasRaidRankRewardByGroup(self.CurrentRaidSeasonId, self.RaidSeasons.PreRaidGroupId)
end

function M:OpenGuildWarRewardPop()
  if CommonConst.RaidSeasonType.Floor ~= self.RaidSeasonType then
    local GuildWarRewardPop = UIManager(self):LoadUINew("GuildWarRewardPop")
    if GuildWarRewardPop and GuildWarRewardPop.Init then
      GuildWarRewardPop:Init({
        CloseCallback = function()
          if self.Owner then
            self.Owner:SelectCellFocus()
          end
        end
      })
    end
    return
  end
  if self.RaidSeasons:IsPreRaidTime() then
    local GuildWarRewardPop = UIManager(self):LoadUINew("GuildWarRewardPop")
    if GuildWarRewardPop and GuildWarRewardPop.Init then
      GuildWarRewardPop:Init({
        CloseCallback = function()
          if self.Owner then
            self.Owner:SelectCellFocus()
          end
        end
      })
    end
    return
  end
  local RewardUI = UIManager(self):LoadUINew("GuildWarRewardPreviewNew")
  if RewardUI and RewardUI.Init then
    RewardUI:Init({
      CloseCallback = function()
        if self.Owner then
          self.Owner:SelectCellFocus()
        end
      end
    })
  end
end

return M
