local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("LimitedPrizePool", {
  [103021] = {
    BigPrizeBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/WBP_LimitedPrizePool_SelectPrize_P.WBP_LimitedPrizePool_SelectPrize_P'",
    BigPrizeMobileBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/WBP_LimitedPrizePool_SelectPrize_M.WBP_LimitedPrizePool_SelectPrize_M'",
    EventId = 103021,
    HistoryBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/LimitedPrizePool/History/WBP_LimitedPrizePool_DetailHistoryContent.WBP_LimitedPrizePool_DetailHistoryContent'",
    LimitedPrizePoolId = {1001, 1002},
    ProcessBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/WBP_LimitedPrizePool_Gacha_P.WBP_LimitedPrizePool_Gacha_P'",
    ProcessMobileBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/WBP_LimitedPrizePool_Gacha_M.WBP_LimitedPrizePool_Gacha_M'",
    ResultBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/WBP_LimitedPrizePool_GetReward_P.WBP_LimitedPrizePool_GetReward_P'",
    ResultMobileBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/WBP_LimitedPrizePool_GetReward_M.WBP_LimitedPrizePool_GetReward_M'",
    RoundBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/LimitedPrizePool/WBP_LimitedPrizePool_RewardSwitchTip.WBP_LimitedPrizePool_RewardSwitchTip'"
  },
  [10302101] = {
    BigPrizeBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/Nun/WBP_LimitedPrizePool_SelectPrize_Nun_P.WBP_LimitedPrizePool_SelectPrize_Nun_P'",
    BigPrizeMobileBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/Nun/WBP_LimitedPrizePool_SelectPrize_Nun_M.WBP_LimitedPrizePool_SelectPrize_Nun_M'",
    EventId = 10302101,
    HistoryBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/LimitedPrizePool/Nun/History/WBP_LimitedPrizePool_DetailHistoryContent_Nun.WBP_LimitedPrizePool_DetailHistoryContent_Nun'",
    LimitedPrizePoolId = {1003, 1004},
    ProcessBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/Nun/WBP_LimitedPrizePool_Gacha_Nun_P.WBP_LimitedPrizePool_Gacha_Nun_P'",
    ProcessMobileBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/Nun/WBP_LimitedPrizePool_Gacha_Nun_M.WBP_LimitedPrizePool_Gacha_Nun_M'",
    ResultBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/Nun/WBP_LimitedPrizePool_GetReward_Nun_P.WBP_LimitedPrizePool_GetReward_Nun_P'",
    ResultMobileBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/Nun/WBP_LimitedPrizePool_GetReward_Nun_M.WBP_LimitedPrizePool_GetReward_Nun_M'",
    RoundBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/LimitedPrizePool/Nun/WBP_LimitedPrizePool_RewardSwitchTip_Nun.WBP_LimitedPrizePool_RewardSwitchTip_Nun'"
  },
  [10302102] = {
    BigPrizeBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/Succubus/WBP_LimitedPrizePool_SelectPrize_Succubus_P.WBP_LimitedPrizePool_SelectPrize_Succubus_P'",
    BigPrizeMobileBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/Succubus/WBP_LimitedPrizePool_SelectPrize_Succubus_M.WBP_LimitedPrizePool_SelectPrize_Succubus_M'",
    BigPrizeSoundEffects = "event:/ui/activity/limit_gift_pool_sub_page_in_lingren",
    BigPrizeVideoPath = "FileMediaSource'/Game/Asset/UIVideo/SystemShow/Activity/Activity_LimitedPrizePool_BG01.Activity_LimitedPrizePool_BG01'",
    EventId = 10302102,
    HistoryBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/LimitedPrizePool/Succubus/History/WBP_LimitedPrizePool_DetailHistoryContent_Succubus.WBP_LimitedPrizePool_DetailHistoryContent_Succubus'",
    LimitedPrizePoolId = {1005, 1006},
    ProcessBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/Succubus/WBP_LimitedPrizePool_Gacha_Succubus_P.WBP_LimitedPrizePool_Gacha_Succubus_P'",
    ProcessMobileBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/Succubus/WBP_LimitedPrizePool_Gacha_Succubus_M.WBP_LimitedPrizePool_Gacha_Succubus_M'",
    ProcessSoundEffects = "event:/ui/activity/limit_gift_pool_gacha_show_lingren",
    ResultBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/PC/LimitedPrizePool/Succubus/WBP_LimitedPrizePool_GetReward_Succubus_P.WBP_LimitedPrizePool_GetReward_Succubus_P'",
    ResultMobileBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Mobile/LimitedPrizePool/Succubus/WBP_LimitedPrizePool_GetReward_Succubus_M.WBP_LimitedPrizePool_GetReward_Succubus_M'",
    RoundBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/LimitedPrizePool/Succubus/WBP_LimitedPrizePool_RewardSwitchTip_Succubus.WBP_LimitedPrizePool_RewardSwitchTip_Succubus'"
  }
})
