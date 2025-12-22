local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("EventPortal", {
  [102001] = {
    EventId = 102001,
    JumpUnlockCondition = 120100,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardPreview = 1030077
  },
  [103001] = {
    EventId = 103001,
    JumpUIId = 13,
    JumpUnlockCondition = 4170,
    JumpUnlockTips = "EventPortal_UnlockTips_103001",
    RewardPreview = 1030011
  },
  [103002] = {
    EventId = 103002,
    EventShop = 28,
    JumpUIId = 77,
    JumpUnlockCondition = 8002,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardPreview = 1030021,
    SubBPPath2 = "/Game/UI/WBP/Activity/Widget/Abyss/WBP_Activity_Abyss_Progress.WBP_Activity_Abyss_Progress"
  },
  [103003] = {
    EventId = 103003,
    JumpFinishCondition = 6009,
    JumpFinishDes = "UI_EventPortalFinish",
    JumpUIId = 37,
    JumpUnlockCondition = 100204,
    JumpUnlockTips = "EventPortal_UnlockTips_103003",
    RewardPreview = 50510
  },
  [103004] = {
    EventId = 103004,
    JumpFinishCondition = 6010,
    JumpFinishDes = "UI_EventPortalFinish",
    JumpUIId = 17,
    JumpUnlockCondition = 110105,
    JumpUnlockTips = "EventPortal_UnlockTips_103004",
    RewardPreview = 50518
  },
  [103005] = {
    EventId = 103005,
    JumpUIId = 36,
    JumpUnlockCondition = 8001,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardPreview = 1030051
  },
  [103006] = {
    EventId = 103006,
    IsUseTabJumpBtn = false,
    JumpUIId = 36,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardPreview = 1030071,
    SubBPPath2 = "/Game/UI/WBP/Activity/Widget/JJGame/WBP_Activity_JJGame_TaskEntryBtn.WBP_Activity_JJGame_TaskEntryBtn"
  },
  [103007] = {
    EventId = 103007,
    JumpUIId = 53,
    RewardBPPath = "/Game/UI/WBP/Activity/Widget/Fort/WBP_Activity_Jump_Fort_TaskProgress.WBP_Activity_Jump_Fort_TaskProgress",
    RewardPreview = 1030078
  },
  [103010] = {
    EventId = 103010,
    JumpUIId = 54,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardBPPath = "/Game/UI/WBP/Activity/Widget/FeinaEvent/WBP_Activity_FeinaEvent_LTReward_RText.WBP_Activity_FeinaEvent_LTReward_RText",
    RewardPreview = 1030062
  },
  [103011] = {
    EventId = 103011,
    JumpUIId = 61,
    JumpUnlockCondition = 8029,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardPreview = 1030100,
    ShowBtnMore = 1,
    SubBPPath2 = "/Game/UI/WBP/Activity/Widget/TheaterOnline/WBP_Activity_Theater_TaskEntryBtn.WBP_Activity_Theater_TaskEntryBtn",
    TaskId = 1
  },
  [103012] = {
    EventId = 103012,
    JumpFinishCondition = 6019,
    JumpFinishDes = "UI_EventPortalFinish",
    JumpUIId = 13,
    JumpUnlockCondition = 4170,
    JumpUnlockTips = "EventPortal_UnlockTips_103012",
    RewardPreview = 103012
  },
  [103013] = {
    EventId = 103013,
    JumpFinishCondition = 6020,
    JumpFinishDes = "UI_EventPortalFinish",
    JumpUIId = 67,
    JumpUnlockCondition = 100202,
    JumpUnlockTips = "EventPortal_UnlockTips_103013",
    RewardPreview = 50577
  },
  [108001] = {
    EventId = 108001,
    JumpUIId = 64,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardBPPath = "/Game/UI/WBP/Activity/Widget/Temple/Solo/WBP_Activity_Temple_Solo_Reward.WBP_Activity_Temple_Solo_Reward",
    RewardPreview = 1030079
  },
  [111001] = {
    EventId = 111001,
    EventShop = 71,
    JumpFinishDes = "UI_EventPortalFinish",
    JumpUIId = 69,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardBPPath = "/Game/UI/WBP/Activity/Widget/GuildWar/WBP_Activity_GuildWar_Entrance.WBP_Activity_GuildWar_Entrance",
    RewardPreview = 1030083,
    SubBPPath2 = "/Game/UI/WBP/Activity/Widget/GuildWar/WBP_Activity_GuildWar_JumpBoard.WBP_Activity_GuildWar_JumpBoard"
  },
  [1030022] = {
    EventId = 1030022,
    EventShop = 28,
    JumpUIId = 77,
    JumpUnlockCondition = 8002,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardPreview = 1030022,
    SubBPPath2 = "/Game/UI/WBP/Activity/Widget/Abyss/WBP_Activity_Abyss_Progress.WBP_Activity_Abyss_Progress"
  },
  [1030023] = {
    EventId = 1030023,
    EventShop = 28,
    JumpUIId = 77,
    JumpUnlockCondition = 8002,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardPreview = 1030023,
    SubBPPath2 = "/Game/UI/WBP/Activity/Widget/Abyss/WBP_Activity_Abyss_Progress.WBP_Activity_Abyss_Progress"
  },
  [1030024] = {
    EventId = 1030024,
    EventShop = 28,
    JumpUIId = 77,
    JumpUnlockCondition = 8002,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    RewardPreview = 1030024,
    SubBPPath2 = "/Game/UI/WBP/Activity/Widget/Abyss/WBP_Activity_Abyss_Progress.WBP_Activity_Abyss_Progress"
  },
  [103009001] = {
    EventId = 103009001,
    JumpUIId = 20,
    JumpUnlockCondition = 4360,
    JumpUnlockTips = "EventPortal_UnlockTips_Common",
    SubBPPath2 = "/Game/UI/WBP/Activity/Widget/DoubleMod/WBP_Activity_DoubleMod_Content.WBP_Activity_DoubleMod_Content"
  }
})
