require("UnLua")
local ScoreTierRewardHelper = require("BluePrints.UI.UI_PC.Common.ScoreTierReward.ScoreTierRewardHelper")
local GuildBossPointRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossPointRewardUtils")
local GuildBossRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossRewardUtils")
local GuildBossUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossUtils")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.UI.UI_PC.Common.ScoreTierReward.ScoreTierRewardPageComponent"
})

function M:Destruct()
  self.Super.Destruct(self)
  self:ScoreTierReward_Destruct()
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self:ScoreTierReward_InitPage({
    Title = GText("UI_GuildBoss_StrongEnemyPoint"),
    Desc = GText("UI_Rougelike_WeekRewardDesc"),
    ClickEmptyText = GText("UI_RougeLike_ClickEmptyContinue"),
    ItemDetailUIName = "GuildBoss",
    EnableRefreshTimer = true,
    ReddotNodeName = "GuildBossPersonPointReward"
  })
end

function M:ScoreTierReward_UpdateRemainTime()
  local RefreshInfo = GuildBossUtils.GetCurrentRefreshConfig()
  if not RefreshInfo then
    return
  end
  local WeekEnd = GuildBossUtils.GetCurrentWeekSlotEndTime(RefreshInfo)
  if not WeekEnd then
    return
  end
  local RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(WeekEnd, nil)
  return RemainTimeDict
end

function M:GetScoreTierRewardSnapshot()
  local AvatarBossData = GuildModel:GetAvatarGuildBossData()
  local RewardInfo = GuildBossPointRewardUtils.GetPointRewardConfig(AvatarBossData)
  return ScoreTierRewardHelper.BuildSnapshot(RewardInfo, AvatarBossData and AvatarBossData:GetPoint() or 0, function(Index)
    return GuildBossPointRewardUtils.IsPointRewardGot(AvatarBossData, Index)
  end)
end

function M:RequestClaimScoreTierReward(Index, Callback)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if nil == Index then
    local function OnClaimAllPointReward(RetCode, Info)
      Callback(RetCode, GuildBossRewardUtils.MergeGuildBossClaimResultItems(Info))
    end
    
    Avatar:GuildBossClaimAllPointReward(OnClaimAllPointReward)
    return
  end
  if Avatar.GuildBossClaimPointReward then
    Avatar:GuildBossClaimPointReward(Callback, Index)
    return
  end
  DebugPrint("WBP_Guild_Boss_Reward: Avatar:GetGuildBossPointReward 尚未接入，Index =", Index)
  if Callback then
    Callback({})
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return self:ScoreTierReward_OnKeyDown(MyGeometry, InKeyEvent)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  return self:ScoreTierReward_OnPreviewKeyDown(MyGeometry, InKeyEvent)
end

function M:Close()
  self.Super.Close(self)
  self:ScoreTierReward_Close()
end

return M
