local ChatCommon = {}
ChatCommon.ChannelDef = {
  TeamUp = CommonConst.ChatChannel.TeamUp,
  Public = CommonConst.ChatChannel.Help,
  InGuild = CommonConst.ChatChannel.InGuild,
  InTeam = CommonConst.ChatChannel.InTeam,
  Friend = CommonConst.ChatChannel.Friend,
  Region = CommonConst.ChatChannel.RegionOnline,
  SettlementOnline = CommonConst.ChatChannel.SettlementOnline
}
ChatCommon.Channel = {
  [CommonConst.ChatChannel.TeamUp] = "World",
  [CommonConst.ChatChannel.Help] = "World",
  [CommonConst.ChatChannel.InTeam] = "World",
  [CommonConst.ChatChannel.Friend] = "World",
  [CommonConst.ChatChannel.RegionOnline] = "Online",
  [CommonConst.ChatChannel.SettlementOnline] = "Online",
  [CommonConst.ChatChannel.InGuild] = "Guild"
}
ChatCommon.ChannelNames = {}
for K, V in pairs(ChatCommon.ChannelDef) do
  ChatCommon.ChannelNames[V] = K
end
ChatCommon.WorldChannels = {
  [CommonConst.ChatChannel.TeamUp] = true,
  [CommonConst.ChatChannel.Help] = true
}
ChatCommon.UIName = "ChatMain"
ChatCommon.MainUIId = 17
ChatCommon.EventID = {
  OpenMainView = "OpenMainView",
  CloseMainView = "CloseMainView",
  EnterChatChannel = "EnterWorldChannel",
  ChatMsgSent = "ChatMsgSent",
  ChatMsgRecv = "ChatMsgRecv",
  ChatBubble = "ChatBubble",
  QuickMsgChanged = "QuickMsgChanged",
  EmotionAdded = "EmotionAdded",
  EmotionRemoved = "EmotionRemoved",
  SelectPlayerToChat = "SelectPlayerToChat",
  SelectGuildMemberToChat = "SelectGuildMemberToChat",
  RefreshGuildPlayerList = "RefreshGuildPlayerList",
  ResetSendBtn = "ResetSendBtn",
  GuildPrivateTargetDisabled = "GuildPrivateTargetDisabled",
  GuildPrivateTargetLeftGuild = "GuildPrivateTargetLeftGuild",
  GuildPrivateTargetEnabled = "GuildPrivateTargetEnabled",
  SendCDTimerUpdate = "SendCDTimerUpdate",
  OnChatBtnListOpen = "OnChatBtnListOpen",
  RecvStickerInPubChannels = "RecvStickerInPubChannels",
  RecvChannelPlayerNum = "RecvChannelPlayerNum",
  RecvAllChatChannel = "RecvAllChatChannel",
  GuildChannelSnapshotRefreshed = "GuildChannelSnapshotRefreshed",
  RefreshGuildMemberChatStatus = "RefreshGuildMemberChatStatus"
}
ChatCommon.MsgType = {
  Other = 0,
  Self = 1,
  System = 2,
  Time = 4
}
ChatCommon.IgnoreSensitiveCheck = false
ChatCommon.DefaultCD = 1
ChatCommon.RichTextTag = {
  Friend = "C_Friend",
  Stranger = "C_Open",
  Self = "Default"
}
ChatCommon.QuickMsgEditDialog = 100091
ChatCommon.AccuseDialog = 100090
ChatCommon.ForbidChatDialog = 100111
ChatCommon.GuildDeleteConfirmDialog = 100372
ChatCommon.GuildPermissionCloseDialog = 100373
ChatCommon.EmojiGroupId = 0
ChatCommon.ReddotMaxCount = 99
ChatCommon.ReddotNamePre = "Chat_"
ChatCommon.PrivateReddotPost = "_Private"
ChatCommon.ReddotName = "ChatMainMenu"
ChatCommon.GuildAggReddotName = "Chat_Guild"
ChatCommon.GuildUidsCacheKey = "Chat.GuildUids"
ChatCommon.GuildSkipDelConfirmKey = "Chat.GuildSkipDelConfirm"
ChatCommon.GuildPrivateDisabledTipFlag = "GuildPrivateDisabledTip"
ChatCommon.GuildPrivateLeftGuildTipFlag = "GuildPrivateLeftGuildTip"
ChatCommon.SubTabType = {Friend = "Friend", Guild = "Guild"}

function ChatCommon.GetChannelTabOrder(ChannelType)
  local Info = DataMgr.Channel[ChannelType]
  return Info and Info.Order or math.huge
end

ChatCommon.Spliter = ": "
ChatCommon.ModSuitCopyHeader = "ModSuitInfo:"
ChatCommon.DyePlanCopyHeader = "DyePlanInfo:"
ChatCommon.AppearancePlanCopyHeader = "AppearancePlanInfo:"
ChatCommon.GiftCopyHeader = "ChatGift:"
ChatCommon.AsyncCombatRoomCopyHeader = "AsyncCombatRoom:"
ChatCommon.GuildRecruitHeader = "GuildRecruit:"
ChatCommon.AutoChessShareHeader = "AutoChessShare:"
ChatCommon.ChatFocusType = {
  Default = 0,
  PlayerList = 1,
  ScrollBox = 2,
  SelectChat = 3,
  InputField = 4,
  QuickReply = 5,
  ChatFace = 6
}
ChatCommon.ChannelCache = "ChatChannel"
_G.ChatCommon = ChatCommon
return ChatCommon
