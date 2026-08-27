local TeamHallCommon = {
  DebugFlags = {
    EnableSourceTraceScreenPrint = false,
    EnableVerboseLog = false,
    EnableListSummaryLog = false
  },
  ReddotName = {
    TeamRequest = "TeamHallJoinRequest"
  },
  RecruitShare = {PopupId = 100424},
  Recruit = {PopupId = 100423, CustomTagPopupId = 100426},
  EventId = {
    HallDataChanged = "HallDataChanged",
    HallDataCleared = "HallDataCleared",
    ProtocolPending = "ProtocolPending",
    RequestFailed = "RequestFailed",
    RecruitmentListRefreshStateChanged = "RecruitmentListRefreshStateChanged",
    RecruitmentPublishCooldownStateChanged = "RecruitmentPublishCooldownStateChanged",
    RecruitmentStateChanged = "RecruitmentStateChanged",
    RecruitmentExpired = "RecruitmentExpired",
    TeamRequestListChanged = "TeamRequestListChanged",
    TeamRequestNew = "TeamRequestNew",
    TeamRequestPanelClosed = "TeamRequestPanelClosed"
  }
}
_G.TeamHallCommon = TeamHallCommon
return TeamHallCommon
