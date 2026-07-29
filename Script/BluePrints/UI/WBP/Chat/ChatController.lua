local ChatModel = require("BluePrints.UI.WBP.Chat.ChatModel")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local TimeUtils = require("Utils.TimeUtils")
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local MiscUtils = require("Utils.MiscUtils")
local AppearanceShareModel = require("BluePrints.UI.WBP.Appearance.AppearanceShareModel")
local AutoChessShareModel = require("BluePrints.UI.AutoChess.AutoChessShareModel")
local json = require("rapidjson")
local GuildDynamicMessageUidOrder = {
  ChangedDecl = {"EditorUid"},
  ChangedLogo = {"EditorUid"},
  JoinMember = {"Uid"},
  LeaveMember = {"Uid"},
  KickMember = {"RequestUid", "TargetUid"},
  SetOwner = {"RequestUid", "TargetUid"},
  SetPermissionSwitch = {"RequestUid"},
  SetTitle = {"RequestUid", "TargetUid"}
}
local GuildDynamicMessageFormatOrder = {
  ChangeGuildName = {"NewName"},
  ChangedDecl = {"EditorUid"},
  ChangedLogo = {"EditorUid"},
  JoinMember = {"Uid"},
  LeaveMember = {"Uid"},
  KickMember = {"RequestUid", "TargetUid"},
  SetOwner = {"RequestUid", "TargetUid"},
  SetPermissionSwitch = {"RequestUid"},
  SetTitle = {
    "RequestUid",
    "TargetUid",
    "Title"
  }
}

local function NormalizeGuildDynamicUid(Value)
  local Uid = tonumber(Value) or 0
  if Uid <= 0 then
    return 0
  end
  return math.floor(Uid)
end

local function GetGuildDynamicFormatTextValue(FormatText, Key)
  if type(FormatText) ~= "table" then
    return nil
  end
  return nil ~= FormatText[Key] and FormatText[Key] or FormatText[tostring(Key)]
end

local function IsGuildDynamicSendToGuildChat(Msg)
  if not Msg or not Msg.Type then
    return false
  end
  if Msg.IsSendToGuildChat and Msg:IsSendToGuildChat() then
    return true
  end
  local Config = DataMgr.GuildMessage and DataMgr.GuildMessage[Msg.Type]
  return Config and (Config.IsSendToGuildChat == true or 1 == Config.IsSendToGuildChat)
end

local GuildPrivateLocalSystemTipContent = {
  [ChatCommon.GuildPrivateDisabledTipFlag] = "UI_PrivateChatDisabledByUser",
  [ChatCommon.GuildPrivateLeftGuildTipFlag] = "GuildHasLeft"
}
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
  M.Super.Init(self)
  EventManager:AddEvent(EventID.OnlineRegionChange, self, self.OnRegionChange)
  self.bTipIgnoreBattle = true
  if 0 == ChatModel:GetQuickMsgDatas():Length() then
    self:SendInitQuickMessage(CommonConst.SystemLanguage)
  end
end

function M:Destory()
  EventManager:RemoveEvent(EventID.OnlineRegionChange, self)
  for _, ChannelType in pairs(ChatCommon.ChannelDef) do
    local CdTimer = self:GetModel():GetChannelCDTimerKey(ChannelType)
    self:SendRequestLeaveChatChannel(ChannelType)
    self:StopTimer(CdTimer)
  end
  M.Super.Destory(self)
end

function M:OnRegionChange(OldState, NewState)
  if NewState == OldState then
    return
  end
  if false == NewState then
    ChatModel:ReadChannelMessage(ChatCommon.ChannelDef.Region)
  end
end

function M:GetModel()
  return ChatModel
end

function M:GetEventName()
  return EventID.ChatControllerEvent
end

function M:OpenView(WorldContex, bBattle)
  return M.Super.OpenView(self, WorldContex, ChatCommon.MainUIId, true, bBattle)
end

function M:GetView(WorldContex)
  return M.Super.GetView(self, WorldContex, ChatCommon.UIName)
end

function M:OverrideButtonSound(button, soundEvent, eventKey)
  button:TryOverrideSoundFunc(function()
    AudioManager(button):PlayUISound(button, soundEvent, eventKey, nil)
  end)
end

function M:SendChatToPlayer(Uid, ContentText)
  local ModContent = self:TryParseMyModSuitInfo(ContentText)
  if ModContent then
    ContentText = ModContent
  end
  local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
  if DyeShareContent and not ModContent then
    ContentText = DyeShareContent
  end
  local AppearanceShareContent = self:TryParseMyAppearancePlanInfo(ContentText)
  if AppearanceShareContent and not ModContent and not DyeShareContent then
    ContentText = AppearanceShareContent
  end
  local GiftContent = self:TryParseGiftInfo(ContentText)
  if GiftContent and not ModContent and not DyeShareContent and not AppearanceShareContent then
    ContentText = GiftContent
  end
  local AsyncCombatRoomContent = self:TryParseAsyncCombatRoomInfo(ContentText)
  if AsyncCombatRoomContent and not GiftContent and not ModContent and not DyeShareContent and not AppearanceShareContent then
    ContentText = AsyncCombatRoomContent
  end
  local GuildRecruitContent = self:TryParseGuildRecruitInfo(ContentText)
  if GuildRecruitContent and not GiftContent and not ModContent and not DyeShareContent and not AppearanceShareContent and not AsyncCombatRoomContent then
    ContentText = GuildRecruitContent
  end
  local AutoChessShareContent = self:TryParseMyAutoChessShareInfo(ContentText)
  if AutoChessShareContent and not GiftContent and not ModContent and not DyeShareContent and not AppearanceShareContent and not AsyncCombatRoomContent and not GuildRecruitContent then
    ContentText = AutoChessShareContent
  end
  self:GetAvatar():ChatToPlayer(Uid, ContentText)
end

function M:RecvChatToPlayer(Uid, ContentText)
  if ChatModel:IsChannelExclude(ChatCommon.ChannelDef.Friend) then
    return
  end
  self:SendChatNewMsgRead()
end

function M:RecvChatChannelSwitch(ChannelType, bOff)
  local LastCurrChannel = ChatModel:GetCurrentChannel()
  ChatModel:UpdateCurrentChannel()
  local ChannelConf = DataMgr.Channel[ChannelType]
  local Msg
  if bOff then
    self:SendRequestLeaveChatChannel(ChannelType)
    self:ClearChannelReddot(ChannelType)
    Msg = string.format(GText("UI_Chat_ChannelClose_Toast"), GText(ChannelConf.Name))
  else
    self:SendRequestEnterChatChannel(ChannelType)
    Msg = string.format(GText("UI_Chat_ChannelOpen_Toast"), GText(ChannelConf.Name))
  end
  if Msg then
    self:ShowToast(Msg)
  end
  if IsValid(self:GetView()) then
    self:GetView():Close()
  else
    local bCloseCurrentChannel = ChannelType == LastCurrChannel
    self:NotifyEvent(ChatCommon.EventID.CloseChatChannel, bCloseCurrentChannel)
  end
end

function M:SendRequestEnterChatChannel(ChannelType, ChannelIndex, online_type)
  if nil == ChannelType then
    ChannelType = ChatModel:GetCurrentChannel()
  end
  if ChatModel:IsChannelExclude(ChannelType) then
    return
  end
  if not self:GetModel().EnteredChannels then
    DebugPrint(ErrorTag, "其他模块初始化失败导致聊天模块初始化进行不下去，这不是聊天的问题!!!!看看上边有没有trace!!!!!!!")
    return
  end
  if not ChatCommon.WorldChannels[ChannelType] or self:GetModel().EnteredChannels[ChannelType] then
    self:RecvRequestEnterChatChannel(ErrorCode.RET_SUCCESS, ChannelType, ChannelIndex, online_type)
    return
  end
  if ChannelType == ChatCommon.ChannelDef.Region then
    self:RecvRequestEnterChatChannel(ErrorCode.RET_SUCCESS, ChannelType, ChannelIndex, online_type)
    return
  end
  self:GetAvatar():RequestEnterWorldChannel(ChannelType)
end

function M:RecvRequestEnterChatChannel(ErrCode, ChannelType, channel_index, online_type)
  self:GetModel().EnteredChannels[ChannelType] = 1
  self:GetModel():SetChannelIndex(online_type or ChannelType, channel_index)
  self:GetModel():SaveChannelIndex(online_type or ChannelType, channel_index)
  self:NotifyEvent(ChatCommon.EventID.EnterChatChannel, ErrCode, ChannelType, channel_index, online_type)
end

function M:SendRequestLeaveChatChannel(ChannelType)
  self:GetModel().EnteredChannels[ChannelType] = nil
  if nil == ChannelType then
    ChannelType = ChatModel:GetCurrentChannel()
  end
  if not ChatCommon.WorldChannels[ChannelType] then
    return
  end
  if ChannelType ~= ChatCommon.ChannelDef.Region then
    self:GetAvatar():RequestLeaveWorldChannel(ChannelType)
  else
    self:GetModel():ClearReddotCount(ChannelType)
  end
end

function M:SendChatToWorld(ChannelType, ContentText)
  local ModContent = self:TryParseMyModSuitInfo(ContentText)
  if ModContent then
    ContentText = ModContent
  end
  local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
  if DyeShareContent and not ModContent then
    ContentText = DyeShareContent
  end
  local AppearanceShareContent = self:TryParseMyAppearancePlanInfo(ContentText)
  if AppearanceShareContent and not ModContent and not DyeShareContent then
    ContentText = AppearanceShareContent
  end
  local AutoChessShareContent = self:TryParseMyAutoChessShareInfo(ContentText)
  if AutoChessShareContent and not ModContent and not DyeShareContent and not AppearanceShareContent then
    ContentText = AutoChessShareContent
  end
  self:GetAvatar():ChatToWorld(ChannelType, ContentText)
end

function M:RecvChatToWorld(ChannelType, ContentText)
  if ChatModel:IsChannelExclude(ChannelType) then
    return
  end
  local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SELF, ChannelType)
  self:_AddMessage(FakeMessage, false)
end

function M:SendChatToTeam(ContentText)
  local ModContent = self:TryParseMyModSuitInfo(ContentText)
  if ModContent then
    ContentText = ModContent
  end
  local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
  if DyeShareContent and not ModContent then
    ContentText = DyeShareContent
  end
  local AutoChessShareContent = self:TryParseMyAutoChessShareInfo(ContentText)
  if AutoChessShareContent and not ModContent and not DyeShareContent then
    ContentText = AutoChessShareContent
  end
  if not GWorld:IsStandAlone() then
    local PC = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    if IsValid(PC) then
      local SinglePC = PC:Cast(UE4.ASinglePlayerController)
      if IsValid(SinglePC) then
        SinglePC:ChatAll(ContentText)
        return
      end
    end
  end
  self:GetAvatar():ChatToTeam(ContentText)
end

function M:RecvChatToTeam(ContentText)
  if ChatModel:IsChannelExclude(ChatCommon.ChannelDef.InTeam) then
    return
  end
  local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SELF, ChatCommon.ChannelDef.InTeam)
  self:_AddMessage(FakeMessage, false)
end

function M:SendChatToSettlementOnline(ContentText)
  local ModContent = self:TryParseMyModSuitInfo(ContentText)
  if ModContent then
    ContentText = ModContent
  end
  local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
  if DyeShareContent and not ModContent then
    ContentText = DyeShareContent
  end
  local AutoChessShareContent = self:TryParseMyAutoChessShareInfo(ContentText)
  if AutoChessShareContent and not ModContent and not DyeShareContent then
    ContentText = AutoChessShareContent
  end
  self:GetAvatar():ChatToSettlementOnline(ContentText)
end

function M:RecvChatToSettlementOnline(ContentText)
  if ChatModel:IsChannelExclude(ChatCommon.ChannelDef.SettlementOnline) then
    return
  end
  local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SELF, ChatCommon.ChannelDef.SettlementOnline)
  self:_AddMessage(FakeMessage, false)
end

function M:SendChatToGuild(ContentText)
  local ModContent = self:TryParseMyModSuitInfo(ContentText)
  if ModContent then
    ContentText = ModContent
  end
  local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
  if DyeShareContent and not ModContent then
    ContentText = DyeShareContent
  end
  local AutoChessShareContent = self:TryParseMyAutoChessShareInfo(ContentText)
  if AutoChessShareContent and not ModContent and not DyeShareContent then
    ContentText = AutoChessShareContent
  end
  self:GetAvatar():ChatToGuild(nil, ContentText)
end

function M:RecvChatToGuild(ContentText)
  if ChatModel:IsChannelExclude(ChatCommon.ChannelDef.InGuild) then
    return
  end
  local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SELF, ChatCommon.ChannelDef.InGuild)
  self:_AddMessage(FakeMessage, false)
end

function M:SendMemberChangeTipsToGuild(Nickname, bJoin)
  local TextMessage
  if bJoin then
    TextMessage = string.format(GText("UI_MemberJoinedGuild"), Nickname)
  else
    TextMessage = string.format(GText("UI_MemberLeftGuild"), Nickname)
  end
  self:RecvSystemInfoToGuild(TextMessage)
end

function M:SendKickMemberTipsToGuild(OperatorNickname, TargetNickname)
  local TextMessage = string.format(GText("UI_MemberRemovedFromGuild"), OperatorNickname, TargetNickname)
  self:RecvSystemInfoToGuild(TextMessage)
end

function M:RecvSystemInfoToGuild(ContentText)
  local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SYSTEM, ChatCommon.ChannelDef.InGuild)
  self:_AddMessage(FakeMessage, false)
end

function M:_GetGuildDynamicSystemMsgKey(Message)
  if Message and Message.GuildDynamicKey then
    return Message.GuildDynamicKey
  end
  local SenderUid = Message and Message.Sender and Message.Sender.Uid or 0
  local Time = math.floor(tonumber(Message and Message.Time) or 0)
  local MsgType = Message and (Message.GuildDynamicType or Message.Type) or ""
  local Content = Message and Message.Content or ""
  return string.format("%s_%s_%s_%s", tostring(SenderUid), tostring(Time), tostring(MsgType), tostring(Content))
end

function M:_BuildGuildDynamicSourceKey(Msg)
  if not Msg then
    return ""
  end
  local Parts = {
    tostring(Msg.Type or ""),
    tostring(math.floor(tonumber(Msg.Time) or 0))
  }
  local FormatText = Msg.FormatText or {}
  local Order = GuildDynamicMessageFormatOrder[Msg.Type] or GuildDynamicMessageUidOrder[Msg.Type]
  local AddedKeys = {}
  if Order then
    for _, Key in ipairs(Order) do
      Parts[#Parts + 1] = string.format("%s=%s", tostring(Key), tostring(GetGuildDynamicFormatTextValue(FormatText, Key) or ""))
      AddedKeys[tostring(Key)] = true
    end
  end
  local Keys = {}
  for Key in pairs(FormatText) do
    if not AddedKeys[tostring(Key)] then
      Keys[#Keys + 1] = tostring(Key)
    end
  end
  table.sort(Keys)
  for _, Key in ipairs(Keys) do
    Parts[#Parts + 1] = string.format("%s=%s", tostring(Key), tostring(GetGuildDynamicFormatTextValue(FormatText, Key) or ""))
  end
  return table.concat(Parts, "|")
end

function M:_ResolveGuildDynamicNickname(Uid)
  Uid = NormalizeGuildDynamicUid(Uid)
  if Uid <= 0 then
    return nil
  end
  self._GuildDynamicNicknameCache = self._GuildDynamicNicknameCache or {}
  local Cached = self._GuildDynamicNicknameCache[Uid]
  if nil ~= Cached then
    return "" ~= Cached and Cached or nil
  end
  local Avatar = self:GetAvatar()
  if Avatar and NormalizeGuildDynamicUid(Avatar.Uid) == Uid then
    local Nickname = Avatar.Nickname or ""
    if "" ~= Nickname then
      self._GuildDynamicNicknameCache[Uid] = Nickname
      return Nickname
    end
  end
  local Member = GuildModel and GuildModel.GetCurrMember and GuildModel:GetCurrMember(Uid)
  if Member and Member.Nickname and "" ~= Member.Nickname then
    self._GuildDynamicNicknameCache[Uid] = Member.Nickname
    return Member.Nickname
  end
  local GuildList = ChatModel and ChatModel.GetGuildUidList and ChatModel:GetGuildUidList() or nil
  local GuildInfo = GuildList and GuildList[Uid]
  if type(GuildInfo) == "table" and GuildInfo.Nickname and "" ~= GuildInfo.Nickname then
    self._GuildDynamicNicknameCache[Uid] = GuildInfo.Nickname
    return GuildInfo.Nickname
  end
  local FriendModel = FriendController and FriendController.GetModel and FriendController:GetModel() or nil
  local FriendDict = FriendModel and FriendModel.GetFriendDict and FriendModel:GetFriendDict() or nil
  local FriendInfo = FriendDict and FriendDict[Uid]
  local FriendNickname = FriendInfo and FriendInfo.Info and FriendInfo.Info.Nickname or nil
  if FriendNickname and "" ~= FriendNickname then
    self._GuildDynamicNicknameCache[Uid] = FriendNickname
    return FriendNickname
  end
  self:_RequestGuildDynamicNickname(Uid)
  return nil
end

function M:_RequestGuildDynamicNickname(Uid)
  Uid = NormalizeGuildDynamicUid(Uid)
  if Uid <= 0 then
    return
  end
  self._GuildDynamicNicknameQuerying = self._GuildDynamicNicknameQuerying or {}
  self._GuildDynamicNicknameFailed = self._GuildDynamicNicknameFailed or {}
  if self._GuildDynamicNicknameQuerying[Uid] or self._GuildDynamicNicknameFailed[Uid] then
    return
  end
  local Avatar = self:GetAvatar()
  if not Avatar or not Avatar.GetOtherPlayerPersonallInfo then
    self._GuildDynamicNicknameFailed[Uid] = true
    return
  end
  self._GuildDynamicNicknameQuerying[Uid] = true
  Avatar:GetOtherPlayerPersonallInfo(Uid, {
    Func = function(PlayerInfo)
      if self._GuildDynamicNicknameQuerying then
        self._GuildDynamicNicknameQuerying[Uid] = nil
      end
      if type(PlayerInfo) ~= "table" then
        self._GuildDynamicNicknameFailed[Uid] = true
        return
      end
      local Nickname = PlayerInfo.Nickname or PlayerInfo.Name or ""
      if "" == Nickname then
        self._GuildDynamicNicknameFailed[Uid] = true
        return
      end
      self._GuildDynamicNicknameCache = self._GuildDynamicNicknameCache or {}
      self._GuildDynamicNicknameCache[Uid] = Nickname
      if ChatModel and ChatModel.RegisterGuildUid then
        ChatModel:RegisterGuildUid(Uid, PlayerInfo)
      end
      self:_RefreshGuildDynamicSystemMessageContents()
    end
  })
end

function M:_ClearGuildDynamicSystemMessageLoadState()
  self._GuildDynamicLoadSerial = (self._GuildDynamicLoadSerial or 0) + 1
  self._GuildDynamicLoadedKeyMap = {}
  self._GuildDynamicLoadedGuildId = nil
end

function M:_GetGuildDynamicTitleDisplayName(Title)
  Title = tonumber(Title) or 0
  if Title <= 0 then
    return tostring(Title)
  end
  local GuildTitleData = DataMgr.GuildTitle and DataMgr.GuildTitle[Title]
  local TitleName = GuildTitleData and GuildTitleData.TitleName
  if TitleName and "" ~= TitleName then
    return GText(TitleName)
  end
  return tostring(Title)
end

function M:_BuildGuildDynamicResolvedText(MsgType, FormatText)
  local ResolvedText = {}
  FormatText = type(FormatText) == "table" and FormatText or {}
  for Key, Value in pairs(FormatText) do
    ResolvedText[Key] = Value
  end
  if "ChangeGuildName" == MsgType then
    ResolvedText.NewName = GetGuildDynamicFormatTextValue(FormatText, "NewName") or GetGuildDynamicFormatTextValue(FormatText, "OldName") or ""
  elseif "SetTitle" == MsgType then
    ResolvedText.Title = self:_GetGuildDynamicTitleDisplayName(GetGuildDynamicFormatTextValue(FormatText, "Title"))
  end
  for _, UidKey in ipairs(GuildDynamicMessageUidOrder[MsgType] or {}) do
    local RawUid = GetGuildDynamicFormatTextValue(FormatText, UidKey)
    local Uid = NormalizeGuildDynamicUid(RawUid)
    local Nickname = self:_ResolveGuildDynamicNickname(Uid)
    ResolvedText[UidKey] = Nickname and "" ~= Nickname and Nickname or tostring(Uid)
  end
  return ResolvedText
end

function M:_FormatGuildDynamicSystemText(MsgType, ResolvedText)
  local Config = DataMgr.GuildMessage and DataMgr.GuildMessage[MsgType]
  local Template = Config and Config.Content and GText(Config.Content) or ""
  local Order = GuildDynamicMessageFormatOrder[MsgType] or {}
  if "GuildCreateSuccess" == MsgType then
    return Template
  end
  if "" ~= Template then
    local NamedResult = Template
    local bReplaced = false
    if type(ResolvedText) == "table" then
      for Key, Value in pairs(ResolvedText) do
        local Pattern = "{" .. tostring(Key) .. "}"
        local NewResult = string.gsub(NamedResult, Pattern, function()
          return tostring(Value)
        end)
        if NewResult ~= NamedResult then
          bReplaced = true
        end
        NamedResult = NewResult
      end
    end
    if bReplaced then
      return NamedResult
    end
    if string.find(Template, "%%") then
      local Args = {}
      for _, Key in ipairs(Order) do
        Args[#Args + 1] = tostring(type(ResolvedText) == "table" and GetGuildDynamicFormatTextValue(ResolvedText, Key) or "")
      end
      local Ok, Result = pcall(string.format, Template, table.unpack(Args))
      if Ok and Result and "" ~= Result then
        return Result
      end
    end
  end
  local Parts = {}
  if type(ResolvedText) == "table" then
    for _, Key in ipairs(Order) do
      local Value = ResolvedText[Key]
      if nil ~= Value and "" ~= Value then
        Parts[#Parts + 1] = tostring(Value)
      end
    end
    if 0 == #Parts then
      for _, Value in pairs(ResolvedText) do
        if nil ~= Value and "" ~= Value then
          Parts[#Parts + 1] = tostring(Value)
        end
      end
    end
  end
  return table.concat(Parts, " ")
end

function M:_BuildGuildDynamicSystemContent(MsgType, FormatText)
  return self:_FormatGuildDynamicSystemText(MsgType, self:_BuildGuildDynamicResolvedText(MsgType, FormatText))
end

function M:_RefreshGuildDynamicSystemMessageContents()
  local bChanged = false
  
  local function RefreshMessage(Message)
    if not Message or not Message.GuildDynamicType then
      return
    end
    local ContentText = self:_BuildGuildDynamicSystemContent(Message.GuildDynamicType, Message.GuildDynamicFormatText)
    if "" ~= ContentText and ContentText ~= Message.Content then
      Message.Content = ContentText
      bChanged = true
    end
  end
  
  local State = self._GuildChannelSnapshotState
  if State and State.DynamicMessages then
    for _, Message in ipairs(State.DynamicMessages) do
      RefreshMessage(Message)
    end
  end
  local List = ChatModel._MessageDict and ChatModel._MessageDict[ChatCommon.ChannelDef.InGuild]
  if List and List.ViewList then
    for _, MsgWrap in ipairs(List.ViewList) do
      RefreshMessage(MsgWrap and MsgWrap.Message)
    end
  end
  if not bChanged then
    return
  end
  if State and State.GuildId then
    self:_RebuildGuildChannelSnapshot(State.GuildId)
  else
    self:NotifyEvent(ChatCommon.EventID.GuildChannelSnapshotRefreshed, ChatCommon.ChannelDef.InGuild)
  end
end

function M:_BuildGuildDynamicSystemMessages(Entries, GuildId)
  if type(Entries) ~= "table" or 0 == #Entries then
    return {}
  end
  if tonumber(self:GetAvatar() and self:GetAvatar().GuildId or 0) ~= tonumber(GuildId or 0) then
    return {}
  end
  table.sort(Entries, function(a, b)
    if (a.Time or 0) == (b.Time or 0) then
      return tostring(a.Key or "") < tostring(b.Key or "")
    end
    return (a.Time or 0) < (b.Time or 0)
  end)
  local Messages = {}
  for _, Entry in ipairs(Entries) do
    local Key = Entry.Key
    if Key then
      local ContentText = self:_BuildGuildDynamicSystemContent(Entry.Type, Entry.FormatText)
      if "" ~= ContentText then
        local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SYSTEM, ChatCommon.ChannelDef.InGuild, Entry.Time)
        FakeMessage.GuildDynamicKey = Key
        FakeMessage.GuildDynamicType = Entry.Type
        FakeMessage.GuildDynamicFormatText = Entry.FormatText
        FakeMessage.GuildSnapshotManaged = true
        FakeMessage.GuildSnapshotSource = "dynamic"
        FakeMessage.GuildSnapshotKey = "dynamic|" .. tostring(Key)
        Messages[#Messages + 1] = FakeMessage
      end
    end
  end
  return Messages
end

function M:_InsertGuildDynamicSystemMessages(Entries, GuildId)
  if type(Entries) ~= "table" or 0 == #Entries then
    return
  end
  if tonumber(self:GetAvatar() and self:GetAvatar().GuildId or 0) ~= tonumber(GuildId or 0) then
    return
  end
  table.sort(Entries, function(a, b)
    if (a.Time or 0) == (b.Time or 0) then
      return tostring(a.Key or "") < tostring(b.Key or "")
    end
    return (a.Time or 0) < (b.Time or 0)
  end)
  local Existing = {}
  local List = ChatModel._MessageDict[ChatCommon.ChannelDef.InGuild]
  if List and List.ViewList then
    for _, MsgWrap in ipairs(List.ViewList) do
      local Message = MsgWrap and MsgWrap.Message
      if Message then
        Existing[self:_GetGuildDynamicSystemMsgKey(Message)] = true
      end
    end
  end
  self._GuildDynamicLoadedKeyMap = self._GuildDynamicLoadedKeyMap or {}
  for _, Entry in ipairs(Entries) do
    local Key = Entry.Key
    if Key and not Existing[Key] and not self._GuildDynamicLoadedKeyMap[Key] then
      local ContentText = self:_BuildGuildDynamicSystemContent(Entry.Type, Entry.FormatText)
      if "" ~= ContentText then
        local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SYSTEM, ChatCommon.ChannelDef.InGuild, Entry.Time)
        FakeMessage.GuildDynamicKey = Key
        FakeMessage.GuildDynamicType = Entry.Type
        FakeMessage.GuildDynamicFormatText = Entry.FormatText
        self._GuildDynamicLoadedKeyMap[Key] = true
        self:_AddMessage(FakeMessage, false)
      end
    end
  end
end

function M:_FinishGuildDynamicSystemMessageLoad(Context)
  if not Context or Context.Done then
    return
  end
  Context.Done = true
  if Context.TimerKey then
    self:StopTimer(Context.TimerKey)
  end
  if self._GuildDynamicLoadSerial ~= Context.Serial then
    return
  end
  if Context.OnComplete then
    Context.OnComplete(self:_BuildGuildDynamicSystemMessages(Context.Entries, Context.GuildId))
  else
    self:_InsertGuildDynamicSystemMessages(Context.Entries, Context.GuildId)
  end
end

function M:_ResolveGuildDynamicSystemMessages(GuildMessages, GuildId, OnComplete)
  local CurrGuildId = tonumber(GuildId or self:GetAvatar() and self:GetAvatar().GuildId or 0) or 0
  if CurrGuildId <= 0 then
    if OnComplete then
      OnComplete({})
    end
    return
  end
  local Entries = {}
  local SeenSourceKey = {}
  for _, Msg in ipairs(GuildMessages or {}) do
    if IsGuildDynamicSendToGuildChat(Msg) then
      local UidKeys = GuildDynamicMessageUidOrder[Msg.Type]
      local SourceKey = self:_BuildGuildDynamicSourceKey(Msg)
      if "" ~= SourceKey and not SeenSourceKey[SourceKey] then
        SeenSourceKey[SourceKey] = true
        local Entry = {
          Type = Msg.Type,
          Time = math.floor(tonumber(Msg.Time) or 0),
          FormatText = Msg.FormatText or {},
          UidKeys = UidKeys and {
            table.unpack(UidKeys)
          } or {},
          Key = SourceKey
        }
        Entries[#Entries + 1] = Entry
      end
    end
  end
  if 0 == #Entries then
    if OnComplete then
      OnComplete({})
    end
    return
  end
  local DynamicMessages = self:_BuildGuildDynamicSystemMessages(Entries, CurrGuildId)
  if OnComplete then
    OnComplete(DynamicMessages)
  else
    self:_InsertGuildDynamicSystemMessages(Entries, CurrGuildId)
  end
end

function M:_GetGuildSnapshotState(GuildId)
  GuildId = tonumber(GuildId or 0) or 0
  self._GuildChannelSnapshotState = self._GuildChannelSnapshotState or {}
  if self._GuildChannelSnapshotState.GuildId ~= GuildId then
    self._GuildChannelSnapshotState = {
      GuildId = GuildId,
      ChatMessages = nil,
      DynamicMessages = nil,
      DynamicSerial = 0
    }
    self._GuildDynamicLoadedKeyMap = {}
    self._GuildDynamicLoadedGuildId = GuildId
  end
  return self._GuildChannelSnapshotState
end

function M:_CloneGuildSnapshotMessage(Msg)
  if type(Msg) ~= "table" then
    return nil
  end
  local NewMsg = {}
  for Key, Value in pairs(Msg) do
    NewMsg[Key] = Value
  end
  return NewMsg
end

function M:_GetGuildChatSnapshotKey(Msg)
  if not Msg then
    return ""
  end
  local SenderUid = Msg.Sender and Msg.Sender.Uid or 0
  local ReceiverUid = Msg.ReceiverUid or 0
  local Time = math.floor(tonumber(Msg.Time) or 0)
  local MsgType = Msg.Type or ""
  local Content = Msg.Content or ""
  return string.format("chat|%s|%s|%s|%s|%s", tostring(SenderUid), tostring(ReceiverUid), tostring(Time), tostring(MsgType), tostring(Content))
end

function M:_PrepareGuildChatSnapshotMessages(Messages)
  local MaxCount = DataMgr.GlobalConstant.GuildMessageCacheMax.ConstantValue
  local MaxTime = DataMgr.GlobalConstant.GuildMessageCacheDuration.ConstantValue * 3600
  local Now = TimeUtils.NowTime()
  local MyUid = self:GetAvatar() and self:GetAvatar().Uid or 0
  local Valid = {}
  local Seen = {}
  for _, Msg in ipairs(Messages or {}) do
    if Msg and Msg.Time and MaxTime >= Now - Msg.Time then
      local NewMsg = self:_CloneGuildSnapshotMessage(Msg)
      if NewMsg then
        NewMsg.ChannelType = ChatCommon.ChannelDef.InGuild
        if NewMsg.Sender and NewMsg.Sender.Uid == MyUid then
          NewMsg.Type = CommonConst.MESSAGE_TYPE_SELF
        end
        local Key = self:_GetGuildChatSnapshotKey(NewMsg)
        if "" ~= Key and not Seen[Key] then
          Seen[Key] = true
          NewMsg.GuildSnapshotManaged = true
          NewMsg.GuildSnapshotSource = "history"
          NewMsg.GuildSnapshotKey = Key
          Valid[#Valid + 1] = NewMsg
        end
      end
    end
  end
  table.sort(Valid, function(a, b)
    if (a.Time or 0) == (b.Time or 0) then
      return self:_GetGuildChatSnapshotKey(a) < self:_GetGuildChatSnapshotKey(b)
    end
    return (a.Time or 0) < (b.Time or 0)
  end)
  if MaxCount < #Valid then
    Valid = table.slice(Valid, #Valid - MaxCount + 1, #Valid)
  end
  return Valid
end

function M:_AddGuildSnapshotEntry(Entries, ExistingKeyMap, Msg, Key, SourceOrder)
  if not Msg or "" == Key or ExistingKeyMap[Key] then
    return
  end
  ExistingKeyMap[Key] = true
  Entries[#Entries + 1] = {
    Message = Msg,
    Key = Key,
    SourceOrder = SourceOrder or 0
  }
end

function M:_CollectCurrentGuildLiveMessages(ExistingKeyMap)
  local LiveMessages = {}
  local SeenLiveKey = {}
  local List = ChatModel._MessageDict[ChatCommon.ChannelDef.InGuild]
  if not List or not List.ViewList then
    return LiveMessages
  end
  for _, MsgWrap in ipairs(List.ViewList) do
    if MsgWrap and MsgWrap.MsgType ~= ChatCommon.MsgType.Time then
      local Msg = MsgWrap.Message
      if Msg and Msg.Content and not Msg.GuildSnapshotManaged then
        Msg.ChannelType = ChatCommon.ChannelDef.InGuild
        local Key = Msg.GuildDynamicKey and "dynamic|" .. tostring(Msg.GuildDynamicKey) or self:_GetGuildChatSnapshotKey(Msg)
        if "" ~= Key and not ExistingKeyMap[Key] and not SeenLiveKey[Key] then
          SeenLiveKey[Key] = true
          LiveMessages[#LiveMessages + 1] = Msg
        end
      end
    end
  end
  return LiveMessages
end

function M:_RebuildGuildChannelSnapshot(GuildId)
  GuildId = tonumber(GuildId or 0) or 0
  if GuildId <= 0 then
    return
  end
  if tonumber(self:GetAvatar() and self:GetAvatar().GuildId or 0) ~= GuildId then
    return
  end
  local State = self._GuildChannelSnapshotState
  if not State or State.GuildId ~= GuildId then
    return
  end
  local Entries = {}
  local ExistingKeyMap = {}
  for _, Msg in ipairs(State.ChatMessages or {}) do
    self:_AddGuildSnapshotEntry(Entries, ExistingKeyMap, Msg, Msg.GuildSnapshotKey or self:_GetGuildChatSnapshotKey(Msg), 1)
  end
  for _, Msg in ipairs(State.DynamicMessages or {}) do
    self:_AddGuildSnapshotEntry(Entries, ExistingKeyMap, Msg, Msg.GuildSnapshotKey or "dynamic|" .. tostring(Msg.GuildDynamicKey or ""), 2)
  end
  for _, Msg in ipairs(self:_CollectCurrentGuildLiveMessages(ExistingKeyMap)) do
    self:_AddGuildSnapshotEntry(Entries, ExistingKeyMap, Msg, self:_GetGuildChatSnapshotKey(Msg), 3)
  end
  table.sort(Entries, function(a, b)
    local TimeA = math.floor(tonumber(a.Message and a.Message.Time) or 0)
    local TimeB = math.floor(tonumber(b.Message and b.Message.Time) or 0)
    if TimeA == TimeB then
      local KeyA = string.format("%s|%s", tostring(a.SourceOrder or 0), tostring(a.Key or ""))
      local KeyB = string.format("%s|%s", tostring(b.SourceOrder or 0), tostring(b.Key or ""))
      return KeyA < KeyB
    end
    return TimeA < TimeB
  end)
  local List = ChatModel._MessageDict[ChatCommon.ChannelDef.InGuild]
  if not List then
    return
  end
  List:ClearMessage()
  for _, Entry in ipairs(Entries) do
    List:AddMessage(Entry.Message, false)
  end
  self:NotifyEvent(ChatCommon.EventID.GuildChannelSnapshotRefreshed, ChatCommon.ChannelDef.InGuild)
  if ChatModel and ChatModel.RestoreGuildUidListFromChatDatas and ChatModel:RestoreGuildUidListFromChatDatas() then
    self:NotifyEvent(ChatCommon.EventID.RefreshGuildPlayerList)
  end
end

function M:LoadGuildChannelSnapshot(ChatMessages, GuildMessages, GuildId)
  if not ChatModel or not ChatModel._MessageDict then
    return
  end
  local Avatar = self:GetAvatar()
  local CurrGuildId = tonumber(GuildId or Avatar and Avatar.GuildId or 0) or 0
  if not (not (CurrGuildId <= 0) and Avatar) or tonumber(Avatar.GuildId or 0) ~= CurrGuildId then
    return
  end
  local State = self:_GetGuildSnapshotState(CurrGuildId)
  if nil ~= ChatMessages then
    State.ChatMessages = self:_PrepareGuildChatSnapshotMessages(ChatMessages)
  end
  if nil ~= GuildMessages then
    State.DynamicSerial = (State.DynamicSerial or 0) + 1
    local DynamicSerial = State.DynamicSerial
    self:_ResolveGuildDynamicSystemMessages(GuildMessages, CurrGuildId, function(DynamicMessages)
      local CurrentState = self._GuildChannelSnapshotState
      if not CurrentState or CurrentState.GuildId ~= CurrGuildId or CurrentState.DynamicSerial ~= DynamicSerial then
        return
      end
      CurrentState.DynamicMessages = DynamicMessages or {}
      self:_RebuildGuildChannelSnapshot(CurrGuildId)
    end)
    return
  end
  self:_RebuildGuildChannelSnapshot(CurrGuildId)
end

function M:LoadGuildDynamicSystemMessages(GuildMessages, GuildId)
  self:LoadGuildChannelSnapshot(nil, GuildMessages or {}, GuildId)
end

function M:ClearGuildChatMessages()
  self:GetModel():ClearMessage(ChatCommon.ChannelDef.InGuild)
  self:ClearChannelReddot(ChatCommon.ChannelDef.InGuild)
  self:_ClearGuildDynamicSystemMessageLoadState()
  self._GuildDynamicNicknameCache = {}
  self._GuildDynamicNicknameQuerying = {}
  self._GuildDynamicNicknameFailed = {}
  self._GuildChannelSnapshotState = nil
  self:NotifyEvent(ChatCommon.EventID.GuildChannelSnapshotRefreshed, ChatCommon.ChannelDef.InGuild)
end

function M:LoadGuildChatHistory(Messages)
  self:LoadGuildChannelSnapshot(Messages or {}, nil)
end

function M:_GetGuildPrivateLocalSystemTipText(TipFlag)
  local TextKey = GuildPrivateLocalSystemTipContent[TipFlag]
  return TextKey and GText(TextKey) or nil
end

function M:_IsGuildPrivateLocalSystemTipMessage(Message, Uid, TipFlag, ContentText)
  if not Message then
    return false
  end
  if not TipFlag then
    return false
  end
  local OwnerUid = self:_GetGuildPrivateLocalSystemTipOwnerUid()
  local MsgOwnerUid = tonumber(Message.GuildPrivateLocalSystemTipOwnerUid or Message.GuildPrivateDisabledTipOwnerUid or 0) or 0
  if MsgOwnerUid > 0 and MsgOwnerUid ~= OwnerUid then
    return false
  end
  if Message[TipFlag] then
    return Message.ReceiverUid == Uid
  end
  if Message.Type == CommonConst.MESSAGE_TYPE_SYSTEM and Message.IsGuildPrivate == true and Message.ReceiverUid == Uid and Message.Content == ContentText then
    Message[TipFlag] = true
    Message.GuildPrivateLocalSystemTipOwnerUid = OwnerUid
    Message.GuildPrivateDisabledTipOwnerUid = OwnerUid
    return true
  end
  return false
end

function M:_FindGuildPrivateLocalSystemTipMessageInView(Uid, TipFlag, ContentText)
  local List = ChatModel._MessageDict and ChatModel._MessageDict[ChatCommon.ChannelDef.Friend]
  if not List or not List.ViewList then
    return nil
  end
  for _, MsgWrap in ipairs(List.ViewList) do
    local Message = MsgWrap and MsgWrap.Message
    if self:_IsGuildPrivateLocalSystemTipMessage(Message, Uid, TipFlag, ContentText) then
      return Message
    end
  end
  return nil
end

function M:_FindGuildPrivateDisabledTipMessageInView(Uid, ContentText)
  return self:_FindGuildPrivateLocalSystemTipMessageInView(Uid, ChatCommon.GuildPrivateDisabledTipFlag, ContentText)
end

function M:_GetGuildPrivateDisabledTipOwnerUid()
  local Avatar = self:GetAvatar()
  return Avatar and Avatar.Uid or 0
end

function M:_GetGuildPrivateLocalSystemTipOwnerUid()
  return self:_GetGuildPrivateDisabledTipOwnerUid()
end

function M:_HasGuildPrivateLocalSystemTip(Uid, TipFlag, ContentText, OwnerUid)
  OwnerUid = tonumber(OwnerUid or self:_GetGuildPrivateLocalSystemTipOwnerUid()) or 0
  if not (not (OwnerUid <= 0) and Uid) or not TipFlag then
    return false
  end
  if ChatModel:GetGuildPrivateLocalSystemTip(Uid, TipFlag, OwnerUid) then
    return true
  end
  return self:_FindGuildPrivateLocalSystemTipMessageInView(Uid, TipFlag, ContentText) ~= nil
end

function M:_ClearGuildPrivateLocalSystemTip(Uid, TipFlag, ContentText, OwnerUid)
  OwnerUid = tonumber(OwnerUid or self:_GetGuildPrivateLocalSystemTipOwnerUid()) or 0
  if not (not (OwnerUid <= 0) and Uid) or not TipFlag then
    return false
  end
  local bHadTip = self:_HasGuildPrivateLocalSystemTip(Uid, TipFlag, ContentText, OwnerUid)
  ChatModel:ClearGuildPrivateLocalSystemTip(Uid, TipFlag, OwnerUid)
  return bHadTip
end

function M:_AddGuildPrivateLocalSystemMessage(Uid, ContentText, TipFlag)
  if not Uid or not ContentText then
    return nil, nil, nil
  end
  TipFlag = TipFlag or ChatCommon.GuildPrivateDisabledTipFlag
  local OwnerUid = self:_GetGuildPrivateLocalSystemTipOwnerUid()
  if OwnerUid <= 0 then
    return nil, nil, nil
  end
  local Message = self:_FindGuildPrivateLocalSystemTipMessageInView(Uid, TipFlag, ContentText)
  if Message then
    ChatModel:SetGuildPrivateLocalSystemTip(Uid, TipFlag, Message, OwnerUid)
  else
    Message = ChatModel:GetGuildPrivateLocalSystemTip(Uid, TipFlag, OwnerUid)
    if not self:_IsGuildPrivateLocalSystemTipMessage(Message, Uid, TipFlag, ContentText) then
      Message = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SYSTEM, ChatCommon.ChannelDef.Friend)
      Message.IsGuildPrivate = true
      Message.ReceiverUid = Uid
      ChatModel:SetGuildPrivateLocalSystemTip(Uid, TipFlag, Message, OwnerUid)
    end
  end
  if ChatModel:GetCurrentChannel() ~= ChatCommon.ChannelDef.Friend or ChatModel:GetCurrentSubTab() ~= ChatCommon.SubTabType.Guild or ChatModel:GetCurrentFriendUid() ~= Uid then
    return Message, nil, nil
  end
  local TimeWrap, MsgWrap
  if not self:_FindGuildPrivateLocalSystemTipMessageInView(Uid, TipFlag, ContentText) then
    TimeWrap, MsgWrap = ChatModel:AddMessage(Message, false)
  end
  return Message, TimeWrap, MsgWrap
end

function M:HandleGuildPrivateTargetDisabled(Uid, bResetSendBtn)
  local DisabledText = self:_GetGuildPrivateLocalSystemTipText(ChatCommon.GuildPrivateDisabledTipFlag)
  local LeftGuildText = self:_GetGuildPrivateLocalSystemTipText(ChatCommon.GuildPrivateLeftGuildTipFlag)
  local bNeedRebuild = self:_ClearGuildPrivateLocalSystemTip(Uid, ChatCommon.GuildPrivateLeftGuildTipFlag, LeftGuildText)
  local _, TimeWrap, MsgWrap = self:_AddGuildPrivateLocalSystemMessage(Uid, DisabledText, ChatCommon.GuildPrivateDisabledTipFlag)
  self:NotifyEvent(ChatCommon.EventID.GuildPrivateTargetDisabled, Uid, TimeWrap, MsgWrap, bNeedRebuild)
  if bResetSendBtn then
    self:NotifyEvent(ChatCommon.EventID.ResetSendBtn)
  end
end

function M:HandleGuildPrivateTargetLeftGuild(Uid, bResetSendBtn)
  local DisabledText = self:_GetGuildPrivateLocalSystemTipText(ChatCommon.GuildPrivateDisabledTipFlag)
  local LeftGuildText = self:_GetGuildPrivateLocalSystemTipText(ChatCommon.GuildPrivateLeftGuildTipFlag)
  local bNeedRebuild = self:_ClearGuildPrivateLocalSystemTip(Uid, ChatCommon.GuildPrivateDisabledTipFlag, DisabledText)
  local _, TimeWrap, MsgWrap = self:_AddGuildPrivateLocalSystemMessage(Uid, LeftGuildText, ChatCommon.GuildPrivateLeftGuildTipFlag)
  self:NotifyEvent(ChatCommon.EventID.GuildPrivateTargetLeftGuild, Uid, TimeWrap, MsgWrap, bNeedRebuild)
  if bResetSendBtn then
    self:NotifyEvent(ChatCommon.EventID.ResetSendBtn)
  end
end

function M:HandleGuildPrivateTargetEnabled(Uid, OwnerUid)
  if not Uid then
    return
  end
  local TipFlags = {
    ChatCommon.GuildPrivateDisabledTipFlag,
    ChatCommon.GuildPrivateLeftGuildTipFlag
  }
  local bChanged = false
  for _, TipFlag in ipairs(TipFlags) do
    local TipText = self:_GetGuildPrivateLocalSystemTipText(TipFlag)
    bChanged = self:_HasGuildPrivateLocalSystemTip(Uid, TipFlag, TipText, OwnerUid) or bChanged
    ChatModel:ClearGuildPrivateLocalSystemTip(Uid, TipFlag, OwnerUid)
  end
  if bChanged then
    self:NotifyEvent(ChatCommon.EventID.GuildPrivateTargetEnabled, Uid)
  end
end

function M:CheckGuildPrivateTargetOpen(Uid)
  if not Uid then
    return
  end
  if not GuildModel:IsInCurrGuild(Uid) then
    self:HandleGuildPrivateTargetLeftGuild(Uid, false)
    return
  end
  local Avatar = self:GetAvatar()
  if not Avatar or not Avatar.QueryGuildChatOpen then
    return
  end
  local OwnerUid = Avatar.Uid
  Avatar:QueryGuildChatOpen(function(Ret, IsOpen)
    if Ret ~= ErrorCode.RET_SUCCESS then
      return
    end
    local CurrAvatar = self:GetAvatar()
    if not CurrAvatar or CurrAvatar.Uid ~= OwnerUid then
      return
    end
    if not GuildModel:IsInCurrGuild(Uid) then
      self:HandleGuildPrivateTargetLeftGuild(Uid, false)
      return
    end
    if not IsOpen then
      self:HandleGuildPrivateTargetDisabled(Uid, false)
    else
      self:HandleGuildPrivateTargetEnabled(Uid, OwnerUid)
    end
  end, Uid)
end

function M:CheckGuildPrivateTargetState(Uid, bResetSendBtn)
  if not Uid then
    return
  end
  if not GuildModel:IsInCurrGuild(Uid) then
    self:HandleGuildPrivateTargetLeftGuild(Uid, bResetSendBtn)
    return
  end
  self:CheckGuildPrivateTargetOpen(Uid)
end

function M:SendChatToGuildMember(Uid, ContentText)
  if not Uid or not ContentText then
    return
  end
  local ModContent = self:TryParseMyModSuitInfo(ContentText)
  if ModContent then
    ContentText = ModContent
  end
  local DyeShareContent = self:TryParseMyDyePlanInfo(ContentText)
  if DyeShareContent and not ModContent then
    ContentText = DyeShareContent
  end
  local AppearanceShareContent = self:TryParseMyAppearancePlanInfo(ContentText)
  if AppearanceShareContent and not ModContent and not DyeShareContent then
    ContentText = AppearanceShareContent
  end
  local Avatar = self:GetAvatar()
  local OwnerUid = Avatar and Avatar.Uid or 0
  if not GuildModel:IsInCurrGuild(Uid) then
    self:HandleGuildPrivateTargetLeftGuild(Uid, true)
    return
  end
  if Avatar.GuildChatOpen == false then
    UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_PrivateChatDisabled"))
    self:NotifyEvent(ChatCommon.EventID.ResetSendBtn)
    return
  end
  Avatar:QueryGuildChatOpen(function(Ret, IsOpen)
    if Ret ~= ErrorCode.RET_SUCCESS then
      self:CheckError(Ret, true)
      self:NotifyEvent(ChatCommon.EventID.ResetSendBtn)
      return
    end
    local CurrAvatar = self:GetAvatar()
    if not CurrAvatar or CurrAvatar.Uid ~= OwnerUid then
      return
    end
    if not GuildModel:IsInCurrGuild(Uid) then
      self:HandleGuildPrivateTargetLeftGuild(Uid, true)
      return
    end
    if not IsOpen then
      self:HandleGuildPrivateTargetDisabled(Uid, true)
      return
    end
    self:HandleGuildPrivateTargetEnabled(Uid, OwnerUid)
    Avatar:ChatToGuildMember(function(ErrCode)
      if not self:CheckError(ErrCode, true) then
        self:NotifyEvent(ChatCommon.EventID.ResetSendBtn)
      end
    end, Uid, ContentText)
  end, Uid)
end

function M:_RemoveLocalGuildPrivateChat(Uid)
  Uid = tonumber(Uid) or 0
  if Uid <= 0 then
    return
  end
  local Avatar = self:GetAvatar()
  if not Avatar or type(Avatar.GuildChats) ~= "table" then
    return
  end
  Avatar.GuildChats[Uid] = nil
  Avatar.GuildChats[tostring(Uid)] = nil
end

function M:SetGuildChatPermission(bAllow)
  local Avatar = self:GetAvatar()
  local bNewValue = bAllow and true or false
  Avatar:SetGuildChatOpen(nil, bNewValue)
  Avatar.GuildChatOpen = bNewValue
  self:NotifyEvent(ChatCommon.EventID.RefreshGuildMemberChatStatus)
  local bNotifyPlayerList = true
  if not bNewValue then
    local Model = self:GetModel()
    local Uids = {}
    for Uid, _ in pairs(Model:GetGuildUidList()) do
      Uids[#Uids + 1] = Uid
    end
    if #Uids > 0 then
      bNotifyPlayerList = false
      local RemainCount = #Uids
      
      local function OnClearDone(ClearUid, Ret)
        if self:CheckError(Ret, true) then
          self:_RemoveLocalGuildPrivateChat(ClearUid)
          Model:UnregisterGuildUid(ClearUid)
          if Model:GetCurrentFriendUid() == ClearUid then
            Model:SetCurrentFriendUid(nil)
          end
        end
        RemainCount = RemainCount - 1
        if RemainCount <= 0 then
          if Model.SyncGuildUidListWithChatDatas then
            Model:SyncGuildUidListWithChatDatas()
          end
          self:NotifyEvent(ChatCommon.EventID.RefreshGuildPlayerList)
        end
      end
      
      for _, Uid in ipairs(Uids) do
        local ClearUid = Uid
        Avatar:ClearGuildPrivateChat(function(Ret)
          OnClearDone(ClearUid, Ret)
        end, ClearUid)
      end
    else
      Model:ClearAllGuildUids()
    end
  end
  if bNotifyPlayerList then
    self:NotifyEvent(ChatCommon.EventID.RefreshGuildPlayerList)
  end
  UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText(bNewValue and "UI_PrivateChatEnabled" or "UI_PrivateChatDisabled"))
end

function M:SendMemberChangeTipsToTeam(MemberInfo, EventType)
  local TextMessage
  if EventType == TeamCommon.EventId.TeamOnAddPlayer then
    TextMessage = string.format(GText("UI_Chat_SbJoin"), MemberInfo.Nickname)
  elseif EventType == TeamCommon.EventId.TeamOnDelPlayer then
    TextMessage = string.format(GText("UI_Chat_SbLeave"), MemberInfo.Nickname)
  end
  if nil ~= TextMessage then
    self:RecvSystemInfoToTeam(TextMessage)
  end
end

function M:RecvSystemInfoToTeam(ContentText)
  local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SYSTEM, ChatCommon.ChannelDef.InTeam)
  self:_AddMessage(FakeMessage, false)
end

function M:SendChangeQuickMessage(Index, ContentText)
  self:GetAvatar():ChangeQuickMessage(Index, ContentText)
end

function M:SendInitQuickMessage(SystemLanguage)
  self:GetAvatar():InitQuickMessage(SystemLanguage)
end

function M:RecvChangeQuickMessage(Index)
  self:NotifyEvent(ChatCommon.EventID.QuickMsgChanged, Index)
end

function M:SendAddEmotion(GroupId)
  self:GetAvatar():AddEmotion(GroupId)
end

function M:RecvAddEmotion(GroupId)
  self:NotifyEvent(ChatCommon.EventID.EmotionAdded, GroupId)
end

function M:SendRemoveEmotion(EmotionId)
  self:GetAvatar():RemoveEmotion(EmotionId)
end

function M:RecvRemoveEmotion(EmotionId)
  self:NotifyEvent(ChatCommon.EventID.EmotionRemoved, EmotionId)
end

function M:SendChatNewMsgRead(CurrFriendUid, SubTabType)
  if self:GetModel():GetCurrentChannel() ~= ChatCommon.ChannelDef.Friend then
    ChatModel:ClearReddotCount(self.CurrChannel)
  end
  if not CurrFriendUid then
    CurrFriendUid = ChatModel:GetCurrentFriendUid()
    if nil == CurrFriendUid then
      return
    end
  end
  if not SubTabType then
    SubTabType = ChatModel:GetCurrentSubTab()
    if nil == SubTabType then
      return
    end
  end
  if SubTabType == ChatCommon.SubTabType.Friend then
    self:GetAvatar():ReadChat(CurrFriendUid, SubTabType)
  else
    self:GetAvatar():ReadGuildPrivateChat(nil, CurrFriendUid, SubTabType)
  end
end

function M:RecvChatNewMsgRead(Uid, SubTabType)
  ChatModel:ReadChannelMessage(ChatCommon.ChannelDef.Friend, Uid, SubTabType)
end

function M:TryParseMyAutoChessShareInfo(MsgStr)
  if AutoChessShareModel.IsAutoChessShareInfoMsg(MsgStr) then
    return AutoChessShareModel.GenerateAutoChessShareMsg()
  end
  return nil
end

function M:ParseAutoChessShareText(MsgWrap)
  if not MsgWrap.AutoChessShareInfo then
    return nil
  end
  local ShareCodeStr, SquadIdx, CostLimit = table.unpack(string.split(MsgWrap.AutoChessShareInfo, "|"))
  return AutoChessShareModel.BuildAutoChessShareDisplayText(SquadIdx)
end

function M:TryParseMyModSuitInfo(MsgStr)
  local ModModel = ModController:GetModel()
  if ModModel:IsModSuitInfoMsg(MsgStr) then
    local ModModel = ModController:GetModel()
    local ModContent = ModModel:GenerateModSuitInfoMsg()
    return ModContent
  end
  return nil
end

function M:TryParseMyDyePlanInfo(MsgStr)
  local ModModel = ModController:GetModel()
  if ModModel:IsDyeShareInfoMsg(MsgStr) then
    local ModModel = ModController:GetModel()
    local DyeShareContent = ModModel:GenerateDyeShareMsg()
    return DyeShareContent
  end
  return nil
end

function M:TryParseGiftInfo(MsgStr)
  if MsgStr == ChatCommon.GiftCopyHeader then
    local GiftContent = self:GenerateGiftMessage()
    return GiftContent
  else
    return nil
  end
end

function M:TryParseAsyncCombatRoomInfo(MsgStr)
  if not MsgStr or "" == MsgStr then
    return nil
  end
  local MsgHeader = string.sub(MsgStr, 1, #ChatCommon.AsyncCombatRoomCopyHeader)
  if MsgHeader == ChatCommon.AsyncCombatRoomCopyHeader then
    return MsgStr
  else
    return nil
  end
end

function M:TryParseGuildRecruitInfo(MsgStr)
  if not MsgStr or "" == MsgStr then
    return nil
  end
  local MsgHeader = string.sub(MsgStr, 1, #ChatCommon.GuildRecruitHeader)
  if MsgHeader == ChatCommon.GuildRecruitHeader then
    return MsgStr
  else
    return nil
  end
end

function M:HandleChatMessage(Message)
  if not self.bInited then
    return
  end
  if Message.Type == CommonConst.MESSAGE_TYPE_PRIVATE then
    Message.ChannelType = ChatCommon.ChannelDef.Friend
    if Message.Sender.Uid == GWorld:GetAvatar().Uid then
      Message.Type = CommonConst.MESSAGE_TYPE_SELF
    end
    local OtherUid = Message.Sender.Uid == GWorld:GetAvatar().Uid and Message.ReceiverUid or Message.Sender.Uid
    if Message.IsGuildPrivate then
      local bGuildChatChanged
      if Message.Type == CommonConst.MESSAGE_TYPE_SELF then
        bGuildChatChanged = ChatModel:RegisterGuildUid(OtherUid, nil)
      else
        bGuildChatChanged = ChatModel:RegisterGuildUid(OtherUid, Message.Sender, true)
      end
      if bGuildChatChanged then
        self:NotifyEvent(ChatCommon.EventID.RefreshGuildPlayerList, OtherUid)
      end
    end
  end
  if Message.Type == CommonConst.MESSAGE_TYPE_LEAGUE or Message.Type == CommonConst.MESSAGE_TYPE_GUILD then
    Message.ChannelType = ChatCommon.ChannelDef.InGuild
    if Message.Sender.Uid == GWorld:GetAvatar().Uid then
      Message.Type = CommonConst.MESSAGE_TYPE_SELF
    end
  end
  if ChatModel:IsChannelExclude(Message.ChannelType) then
    return
  end
  self:_AddMessage(Message, true)
end

function M:SendGiftMessage(UID, Index)
  self.GiftInfo = {
    Index = Index or 1
  }
  self:SendChatToPlayer(UID, ChatCommon.GiftCopyHeader)
end

function M:SendGiftReceivedMessage(UID, Index)
  self.GiftInfo = {
    bGiftReceived = true,
    Index = Index or 1
  }
  self:SendChatToPlayer(UID, ChatCommon.GiftCopyHeader)
end

function M:GenerateGiftMessage()
  if not self.GiftInfo then
    return nil
  end
  return ChatCommon.GiftCopyHeader .. json.encode(self.GiftInfo)
end

function M:_AddMessage(Message, bCalcUnread)
  if UIUtils.IsAsyncCombatRoomMessage(Message) and not UIUtils.IsAsyncCombatRoomMessageValid(Message) then
    return
  end
  local TimeWrap, MsgWrap = self:GetModel():AddMessage(Message, bCalcUnread)
  local Channel = Message.ChannelType
  if MsgWrap:IsSticker() and Channel ~= ChatCommon.ChannelDef.Friend then
    local Uid = Message.Sender.Uid
    local GroupId = MsgWrap.EmojiInfos[1].GroupId
    local Id = MsgWrap.EmojiInfos[1].Id
    local StickerTexPath = DataMgr.ChatEmoji[GroupId][Id]
    self:NotifyEvent(ChatCommon.EventID.RecvStickerInPubChannels, Uid, StickerTexPath)
  end
  local IsSelf = Message.Type == CommonConst.MESSAGE_TYPE_SELF
  if not IsSelf then
    self:NotifyEvent(ChatCommon.EventID.ChatBubble, TimeWrap, MsgWrap)
  end
  if Channel ~= ChatModel:GetCurrentChannel() then
    return
  end
  if Message.Type == CommonConst.MESSAGE_TYPE_SELF then
    self:NotifyEvent(ChatCommon.EventID.ChatMsgSent, TimeWrap, MsgWrap)
  else
    self:NotifyEvent(ChatCommon.EventID.ChatMsgRecv, TimeWrap, MsgWrap)
  end
end

function M:CreateFakeMsg(ContentText, MsgType, Channel, Time)
  return {
    Content = ContentText,
    Time = Time or TimeUtils.NowTime(),
    Sender = self:GetAvatar(),
    Type = MsgType,
    ChannelType = Channel
  }
end

function M:SelectPlayerToChat(Uid)
  self:GetModel():SetCurrentFriendUid(Uid)
  self:NotifyEvent(ChatCommon.EventID.SelectPlayerToChat, Uid)
end

function M:SelectGuildMemberToChat(Uid, AvatarInfo)
  if not Uid then
    return
  end
  if not GuildModel:IsInCurrGuild(Uid) then
    DebugPrint(WarningTag, "[Chat] SelectGuildMemberToChat: Uid 不在当前公会", Uid)
  end
  self:GetModel():RegisterGuildUid(Uid, AvatarInfo)
  self:GetModel():SetCurrentSubTab(ChatCommon.SubTabType.Guild)
  self:GetModel():SetCurrentFriendUid(Uid)
  self:NotifyEvent(ChatCommon.EventID.SelectGuildMemberToChat, Uid)
  self:CheckGuildPrivateTargetState(Uid)
end

function M:DeleteGuildChat(Uid)
  if not Uid then
    return
  end
  self:GetAvatar():ClearGuildPrivateChat(function(Ret)
    if not self:CheckError(Ret, true) then
      return
    end
    self:_RemoveLocalGuildPrivateChat(Uid)
    local Model = self:GetModel()
    Model:UnregisterGuildUid(Uid)
    if Model:GetCurrentFriendUid() == Uid then
      Model:SetCurrentFriendUid(nil)
    end
    self:NotifyEvent(ChatCommon.EventID.RefreshGuildPlayerList)
  end, Uid)
end

function M:OnGuildLeave()
  local Uids = {}
  for Uid, _ in pairs(self:GetModel():GetGuildUidList()) do
    Uids[#Uids + 1] = Uid
  end
  for _, Uid in ipairs(Uids) do
    self:DeleteGuildChat(Uid)
  end
end

function M:OpenPlayerBtnList(WorldContext, AvatarInfo, FuncList, GuildInfo, BtnOption)
  if table.isempty(FuncList) then
    return nil
  end
  local HeadOptionWidget = UIManager(WorldContext):_CreateWidgetNew(DataMgr.WidgetUI.ChatHeadOption.UIName)
  HeadOptionWidget.Owner = WorldContext
  HeadOptionWidget:Init(AvatarInfo, GuildInfo, FuncList, BtnOption)
  return HeadOptionWidget
end

function M:OnMainClose(bBattle)
  ChatModel:SetCurrentFriendUid(nil)
  self:NotifyEvent(ChatCommon.EventID.CloseMainView, bBattle)
end

function M:OnMainOpen(bBattle)
  self:NotifyEvent(ChatCommon.EventID.OpenMainView, bBattle)
end

function M:CheckTextValid(Text, Callback, ShowTipFunc, TextMap, bAllowEmpty)
  if ModController:GetModel():IsModSuitInfoMsg(Text) then
    Callback(true, Text)
    return
  end
  if ModController:GetModel():IsDyeShareInfoMsg(Text) then
    Callback(true, Text)
    return
  end
  local EmptyHint = GText("UI_Chat_NotEmptyText")
  local BannedHint = GText("UI_REGISTER_BANNEDINPUT")
  if TextMap then
    EmptyHint = TextMap.EmptyHint or EmptyHint
    BannedHint = TextMap.BannedHint or BannedHint
  end
  local OldText = Text
  local Trimmed = MiscUtils.Trim(Text)
  if "" == Trimmed then
    if bAllowEmpty then
      Text = OldText
    else
      ShowTipFunc(true, EmptyHint)
      return
    end
  else
    Text = Trimmed
  end
  if string.match(Text, "<(.-)>(.-)</>") then
    ShowTipFunc(false, BannedHint)
    Callback(false)
    return
  end
  for GroupId, Id in string.gmatch(Text, "%[(%d+)|([%w]+)%]") do
    GroupId = tonumber(GroupId) or nil
    if GroupId and not DataMgr.EmojiGroup[GroupId] then
    elseif GroupId ~= ChatCommon.EmojiGroupId then
      ShowTipFunc(false, BannedHint)
      Callback(false)
      return
    end
  end
  if ChatCommon.IgnoreSensitiveCheck then
    Callback(true, Text)
    return
  end
  HeroUSDKUtils.CheckStringSensitive(GWorld.GameInstance, Text, function(self, ReplaceName, NewText, Words)
    ShowTipFunc(false, BannedHint)
    Callback(false)
  end, function(self, NewText)
    Callback(true, Text)
  end)
end

function M:OpenForbidChatDialog(Time, Reason, TimeDelta)
  local View = self:GetView()
  if not IsValid(View) then
    return
  end
  if nil == Time then
    Time = self:GetAvatar().ForbidChatTime
  end
  if nil == Reason then
    Reason = self:GetAvatar().ForbidChatReason
  end
  local timeDifference = TimeDelta and TimeDelta or Time - TimeUtils.NowTime()
  local days = math.floor(timeDifference / 86400)
  local hours = math.floor(timeDifference % 86400 / 3600)
  local minutes = math.floor(timeDifference % 3600 / 60)
  local Params = {
    ShortText = string.format(GText("UI_COMMONPOP_TEXT_100111"), days, hours, minutes)
  }
  self:GetUIMgr(View):ShowCommonPopupUI(ChatCommon.ForbidChatDialog, Params, View)
end

function M:OpenChatReportDialog(Params)
  local View = self:GetView()
  if self:IsGamepad() then
    Params.AutoFocus = true
  end
  self:GetUIMgr(View):ShowCommonPopupUI(ChatCommon.AccuseDialog, Params, View)
end

function M:SetUpSendCDTimer(ChannelType)
  local CdTimer = self:GetModel():GetChannelCDTimerKey(ChannelType)
  self:StopTimer(CdTimer)
  local RawCDRemainTime = DataMgr.Channel[ChannelType].MessageCD
  if 0 == RawCDRemainTime then
    RawCDRemainTime = ChatCommon.DefaultCD
  end
  ChatModel:SetChannelCDRemainTime(RawCDRemainTime, ChannelType)
  local Interval = RawCDRemainTime < 1 and RawCDRemainTime or 1
  self:AddTimer(Interval, function()
    local CDRemianTime = ChatModel:GetChannelCDReaminTime(ChannelType) - Interval
    ChatModel:SetChannelCDRemainTime(CDRemianTime, ChannelType)
    if ChannelType == ChatModel:GetCurrentChannel() then
      self:NotifyEvent(ChatCommon.EventID.SendCDTimerUpdate, CDRemianTime)
    end
    if CDRemianTime <= 0 then
      self:StopTimer(CdTimer)
    end
  end, true, 0, CdTimer)
  if ChannelType == ChatModel:GetCurrentChannel() then
    self:NotifyEvent(ChatCommon.EventID.SendCDTimerUpdate, RawCDRemainTime)
  end
end

function M:IsSendCDTimerExist(ChannelType)
  local CdTimer = self:GetModel():GetChannelCDTimerKey(ChannelType)
  DebugPrint("ChatController :: IsSendCdTimerExist CdTimer = " .. CdTimer)
  return self:IsExistTimer(CdTimer)
end

function M:ParseEmojiToText(MsgWrap)
  local Content = MsgWrap.Message.Content
  if #MsgWrap.EmojiInfos > 0 then
    if MsgWrap:IsSticker() then
      local GroupId = MsgWrap.EmojiInfos[1].GroupId
      local Id = MsgWrap.EmojiInfos[1].Id
      local Error = "Error!!!"
      local EmojiGroupName = DataMgr.EmojiGroup[GroupId].Name or Error
      local EmojiName = DataMgr.ChatEmoji[GroupId][Id].Name or Error
      Content = string.format("[%s|%s]", GText(EmojiGroupName), GText(EmojiName))
    else
      local originalContent = Content
      for _, emojiInfo in ipairs(MsgWrap.EmojiInfos) do
        local GroupId = emojiInfo.GroupId
        local Id = emojiInfo.Id
        local EmojiName = DataMgr.ChatEmoji[GroupId][Id].Name or "Error!!!"
        local EmojiPattern = string.format("%%[%s|%s%%]", GroupId, GText(EmojiName))
        local EmojiReplacement = string.format("[%s]", GText(EmojiName))
        originalContent = originalContent:gsub(EmojiPattern, EmojiReplacement, 1)
      end
      Content = originalContent
    end
  end
  return Content
end

function M:ParseChannelHeader(MsgWrap)
  local Message = MsgWrap.Message
  local ChannelType = Message.ChannelType
  local ChannelConfig = DataMgr.Channel[ChannelType]
  if not ChannelConfig then
    return
  end
  local RichText
  if 4 == ChannelType then
    RichText = "C_Friend"
  elseif 3 == ChannelType then
    RichText = "C_Team"
  elseif ChannelType == ChatCommon.ChannelDef.InGuild then
    RichText = "C_Guild"
  else
    RichText = "C_Open"
  end
  local NameKey = ChannelConfig.Name
  if ChannelType == ChatCommon.ChannelDef.Friend and Message.IsGuildPrivate then
    NameKey = "UI_SendPrivateMessage"
  end
  local RawName = string.format("[%s]", GText(NameKey))
  local Name = string.format("<%s>%s</>", RichText, RawName)
  return Name, RawName
end

function M:ParseSpeakerHeader(MsgWrap)
  local Message = MsgWrap.Message
  local YouTo = ""
  local RichTextTag = ChatCommon.RichTextTag.Self
  local FriendName = GText("UI_Chat_You")
  if Message.ChannelType == ChatCommon.ChannelDef.Friend then
    YouTo = MsgWrap.MsgType == ChatCommon.MsgType.Self and GText("UI_Chat_YouTo") or ""
    RichTextTag = "C_Open"
    local Uid = Message.Sender.Uid
    if MsgWrap.MsgType == ChatCommon.MsgType.Self then
      Uid = Message.ReceiverUid
    end
    if Message.IsGuildPrivate then
      local GuildList = ChatModel:GetGuildUidList()
      local Info = type(GuildList[Uid]) == "table" and GuildList[Uid] or nil
      FriendName = Info and Info.Nickname or Message.Sender.Nickname or tostring(Uid)
    else
      FriendName = FriendController:GetModel():GetFriendDict()[Uid].Info.Nickname
    end
  elseif MsgWrap.MsgType ~= ChatCommon.MsgType.Self then
    local Friend = FriendController:GetModel():GetFriendDict()[Message.Sender.Uid]
    RichTextTag = "C_Open"
    FriendName = Friend and Friend.Info.Nickname or Message.Sender.Nickname
  end
  local Spacker = string.format("%s<%s>%s</>%s", YouTo, RichTextTag, FriendName, ChatCommon.Spliter)
  local RawSpacker = table.concat({
    YouTo,
    FriendName,
    ChatCommon.Spliter
  })
  return Spacker, RawSpacker
end

function M:ParseModSuitText(MsgWrap)
  local Content = MsgWrap.Message.Content
  if not MsgWrap.ModSuitInfo then
    return nil
  end
  local TargetType = MsgWrap.ModSuitInfo.TargetInfo[1]
  local TargetId = MsgWrap.ModSuitInfo.TargetInfo[2]
  local Name = "角色或武器被删除了!!!!"
  local Conf = DataMgr[TargetType][TargetId]
  if "Char" == TargetType then
    if Conf.GenderTag ~= nil then
      Name = MsgWrap.Message.Sender.Nickname
    else
      Name = Conf.CharName
    end
  else
    Name = Conf.WeaponName
  end
  if Name == MsgWrap.Message.Sender.Nickname then
    return string.format(GText("UI_Chat_ModSuitFormat"), Name)
  end
  return string.format(GText("UI_Chat_ModSuitFormat"), GText(Name))
end

function M:ParseDyePlanText(MsgWrap)
  local Content = MsgWrap.Message.Content
  if not MsgWrap.DyePlanInfo then
    return nil
  end
  if not MsgWrap.DyePlanInfo.TargetName then
    return nil
  end
  local Name = MsgWrap.DyePlanInfo.TargetName
  return string.format(GText("UI_Chat_DyeSuitFormat"), GText(Name))
end

function M:ParseAsyncCombatRoomInfoText(MsgWrap)
  if not MsgWrap.AsyncCombatRoomInfo then
    return nil
  end
  local RateResId = MsgWrap.AsyncCombatRoomInfo.RateResId or 206
  local RateRes = DataMgr.Resource[RateResId]
  local Percent = RateRes and RateRes.UseParam and RateRes.UseParam / 100 or 100
  return string.format(GText("UI_AsyncCombat_ChatShare"), Percent)
end

function M:ParseGuildRecruitText(MsgWrap)
  if not MsgWrap.GuildRecruitInfo then
    return nil
  end
  return MsgWrap.GuildRecruitInfo.RecruitMessage or ""
end

function M:ClearChannelReddot(ChannelType)
  if ChannelType ~= ChatCommon.ChannelDef.Friend then
    self:GetModel():ClearReddotCount(ChannelType)
  else
    for _, Friend in pairs(FriendController:GetModel():GetFriendDict()) do
      self:SendChatNewMsgRead(Friend.Uid, ChatCommon.SubTabType.Friend)
    end
    for Uid, _ in pairs(self:GetModel():GetGuildUidList()) do
      self:SendChatNewMsgRead(Uid, ChatCommon.SubTabType.Guild)
    end
  end
end

function M:SendQueryChatChannelBusyInfo()
  if ChatModel:IsInRegionOnlineChannelType() then
    self:GetAvatar():QueryAllRegionOnlineChannelState(ChatModel:GetRegionId())
  else
    self:GetAvatar():QueryAllChatChannelBusyInfo()
  end
end

function M:SetIsEnterChannelContent(Value)
  ChatModel:SetIsEnterChannelContent(Value)
end

function M:RecvAllChatChannelPlayerCountInfo(channel_type, channel_list)
  ChatModel:SetAllChannelList(channel_list)
  self:NotifyEvent(ChatCommon.EventID.RecvAllChatChannel, channel_type, channel_list)
end

function M:StartQueryChatChannelBusyInfo()
  local Avatar = self:GetAvatar()
  if ChatModel:IsInRegionOnlineChannelType() then
    Avatar:QueryRegionOnlineChannelState(ChatModel:GetRegionId(), ChatModel:GetRecvChannelIndex())
  else
    local CurChannel = ChatModel:GetChannelIndex(ChatModel:GetCurrentChannel())
    Avatar:QueryChatChannelBusyInfo({CurChannel})
  end
end

function M:SendQueryRegionOnlineChannelState(RegionId, ChannelIdList)
  if not RegionId or RegionId <= 0 then
    return
  end
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  if ChannelIdList and Avatar.QueryRegionOnlineChannelState then
    Avatar:QueryRegionOnlineChannelState(RegionId, ChannelIdList)
  elseif Avatar.QueryAllRegionOnlineChannelState then
    Avatar:QueryAllRegionOnlineChannelState(RegionId)
  end
end

function M:RecvChatChannelPlayerCountInfo(Channel_type, Channel_list)
  ChatModel:RefreshRecvChannelIndex(Channel_type, Channel_list)
  self:NotifyEvent(ChatCommon.EventID.RecvChannelPlayerNum, Channel_type, Channel_list)
end

function M:OpenChatChannelUI(UIState, TargetChannelType)
  local Params = {}
  Params.TargetChannelType = TargetChannelType
  Params.TabConfigData = {
    LeftKey = "Q",
    RightKey = "E",
    LeftGamePadKey = "LeftShoulder",
    RightGamePadKey = "RightShoulder",
    Tabs = {
      {
        Text = GText("SearchChannel"),
        TabId = 1
      },
      {
        Text = GText("HistoryChannel"),
        TabId = 2
      }
    }
  }
  Params.DontCloseWhenRightBtnClicked = true
  Params.RightCallbackObj = UIState
  
  function Params.RightCallbackFunction(_, _, Dialog)
    if not Dialog or not Dialog.GetContentWidgetByName then
      return
    end
    local ChannelContent = Dialog:GetContentWidgetByName("WBP_Chat_ChannelContent")
    if ChannelContent and ChannelContent.OnSendChannelIndexSelect then
      ChannelContent:OnSendChannelIndexSelect()
    end
  end
  
  UIManager(self):ShowCommonPopupUI(100345, Params, UIState)
end

function M:RecvUpdateChannelIndexChatToWorld(ContentText, ChannelType, DedupKey)
  if ChatModel:IsChannelExclude(ChannelType) then
    return
  end
  if DedupKey then
    local Now = TimeUtils.NowTime()
    self._ChannelSwitchNoticeDedup = self._ChannelSwitchNoticeDedup or {}
    local LastNoticeTime = self._ChannelSwitchNoticeDedup[DedupKey]
    if LastNoticeTime and Now - LastNoticeTime < 2 then
      return
    end
    self._ChannelSwitchNoticeDedup[DedupKey] = Now
    for Key, NoticeTime in pairs(self._ChannelSwitchNoticeDedup) do
      if Now - NoticeTime >= 2 then
        self._ChannelSwitchNoticeDedup[Key] = nil
      end
    end
  end
  local FakeMessage = self:CreateFakeMsg(ContentText, CommonConst.MESSAGE_TYPE_SYSTEM, ChannelType)
  self:_AddMessage(FakeMessage, false)
end

function M:InitChannelData(Widget)
  if Widget.ChannelInfo then
    return
  end
  local ChannelInfo = {}
  for _, Data in pairs(DataMgr.Channel) do
    ChannelInfo[Data.RedDotPriority] = Data
  end
  Widget.ChannelInfo = ChannelInfo
end

function M:GetRedDotNumAndChannelData(Widget)
  for i = #Widget.ChannelInfo, 1, -1 do
    local Data = Widget.ChannelInfo[i]
    local NodeName = ChatCommon.ReddotNamePre .. ChatCommon.ChannelNames[Data.ChannelType]
    local Node = ReddotManager.GetTreeNode(NodeName)
    if Node and Node:GetNodeCount() > 0 then
      return Node:GetNodeCount(), Data
    end
  end
end

function M:UpdateChatIcon(Widget, SIcon)
  local Icon = LoadObject(SIcon)
  if IsValid(Icon) then
    Widget.Image_ChatChannel:SetBrushResourceObject(Icon)
  end
end

function M:OnChatReddotUpdate(Widget)
  local NewCount
  self:InitChannelData(Widget)
  local NodeCount, ChannelData = self:GetRedDotNumAndChannelData(Widget)
  if not NodeCount then
    Widget.CurChannelData = nil
    Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if not Widget.CurChannelData then
    Widget.CurChannelData = ChannelData
    self:UpdateChatIcon(Widget, ChannelData.SIcon)
  elseif Widget.CurChannelData.RedDotPriority < ChannelData.RedDotPriority then
    Widget.CurChannelData = ChannelData
    
    function Widget.RefreshCallBack()
      self:UpdateChatIcon(Widget, ChannelData.SIcon)
    end
    
    Widget:PlayAnimation(Widget.Refresh)
  elseif Widget.CurChannelData ~= ChannelData then
    Widget.CurChannelData = ChannelData
    self:UpdateChatIcon(Widget, ChannelData.SIcon)
  end
  if NodeCount > ChatCommon.ReddotMaxCount then
    NewCount = ChatCommon.ReddotMaxCount .. "+"
  end
  Widget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  Widget:SetNum(NewCount or NodeCount)
end

function M:TryParseMyAppearancePlanInfo(MsgStr)
  if AppearanceShareModel.IsAppearanceShareInfoMsg(MsgStr) then
    return AppearanceShareModel.GenerateAppearanceShareMsg()
  end
  return nil
end

function M:ParseAppearancePlanText(MsgWrap)
  if not MsgWrap.AppearancePlanInfo then
    return nil
  end
  return AppearanceShareModel.BuildAppearancePlanDisplayText(MsgWrap.AppearancePlanInfo)
end

local OldSendChatToWorld = M.SendChatToWorld

function M:SendChatToWorld(ChannelType, ContentText)
  local AppearanceShareContent = self:TryParseMyAppearancePlanInfo(ContentText)
  if AppearanceShareContent then
    ContentText = AppearanceShareContent
  end
  local AutoChessShareContent = self:TryParseMyAutoChessShareInfo(ContentText)
  if AutoChessShareContent and not AppearanceShareContent then
    ContentText = AutoChessShareContent
  end
  return OldSendChatToWorld(self, ChannelType, ContentText)
end

local OldSendChatToTeam = M.SendChatToTeam

function M:SendChatToTeam(ContentText)
  local AppearanceShareContent = self:TryParseMyAppearancePlanInfo(ContentText)
  if AppearanceShareContent then
    ContentText = AppearanceShareContent
  end
  local AutoChessShareContent = self:TryParseMyAutoChessShareInfo(ContentText)
  if AutoChessShareContent and not AppearanceShareContent then
    ContentText = AutoChessShareContent
  end
  return OldSendChatToTeam(self, ContentText)
end

local OldSendChatToSettlementOnline = M.SendChatToSettlementOnline

function M:SendChatToSettlementOnline(ContentText)
  local AppearanceShareContent = self:TryParseMyAppearancePlanInfo(ContentText)
  if AppearanceShareContent then
    ContentText = AppearanceShareContent
  end
  local AutoChessShareContent = self:TryParseMyAutoChessShareInfo(ContentText)
  if AutoChessShareContent and not AppearanceShareContent then
    ContentText = AutoChessShareContent
  end
  return OldSendChatToSettlementOnline(self, ContentText)
end

local OldSendChatToGuild = M.SendChatToGuild

function M:SendChatToGuild(ContentText)
  local AppearanceShareContent = self:TryParseMyAppearancePlanInfo(ContentText)
  if AppearanceShareContent then
    ContentText = AppearanceShareContent
  end
  local AutoChessShareContent = self:TryParseMyAutoChessShareInfo(ContentText)
  if AutoChessShareContent and not AppearanceShareContent then
    ContentText = AutoChessShareContent
  end
  return OldSendChatToGuild(self, ContentText)
end

local OldCheckTextValid = M.CheckTextValid

function M:CheckTextValid(Text, Callback, ShowTipFunc, TextMap, bAllowEmpty)
  if AppearanceShareModel.IsAppearanceShareInfoMsg(Text) then
    Callback(true, Text)
    return
  end
  if AutoChessShareModel.IsAutoChessShareInfoMsg(Text) then
    Callback(true, Text)
    return
  end
  return OldCheckTextValid(self, Text, Callback, ShowTipFunc, TextMap, bAllowEmpty)
end

_G.ChatController = M
return M
