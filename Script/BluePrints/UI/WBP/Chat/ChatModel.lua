local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local ChatMessage = require("BluePrints.UI.WBP.Chat.ChatMessage")
local MessageList = ChatMessage.MessageList
local TimeUtils = require("Utils.TimeUtils")
local EMCache = require("EMCache.EMCache")
local M = Class("BluePrints.Common.MVC.Model")

function M:GetPrivateChatParentName(SubTabType)
  return ChatCommon.ReddotNamePre .. SubTabType .. ChatCommon.PrivateReddotPost
end

function M:Init()
  M.Super.Init(self)
  self._CurrentChannel = ChatCommon.ChannelDef.Public
  self._CachedMainUISize = nil
  self._CachedMainUIPos = nil
  self._OriginMainUISize = nil
  self._OriginMainUIPos = nil
  self._MessageDict = {}
  for ChannelName, ChannelType in pairs(ChatCommon.ChannelDef) do
    self._MessageDict[ChannelType] = MessageList:New(ChatCommon.ReddotNamePre .. ChannelName .. "_ChannelCD")
  end
  self._CurrentFriendUid = nil
  self._CurrSubTab = ChatCommon.SubTabType.Friend
  self._GuildUids = {}
  self._GuildPrivateLocalSystemTips = {}
  self._CurrentChannelIndex = {}
  self._AllChannelList = nil
  self._HistoryChannelList = nil
  self:InitReddotCount()
  self.SimpleChatOutAnimCurve = LoadObject("CurveFloat'/Game/UI/WBP/Common/VX/UIVX/Curve/Curve_InteractiveItem_PC.Curve_InteractiveItem_PC'")
  AddToRoot(self.SimpleChatOutAnimCurve)
  self.EnteredChannels = {}
  self:UpdateCurrentChannel()
  self:InitRecvChannelIndex()
end

function M:IsChannelExclude(ChannelType)
  return self:GetAvatar().ChatChannelClose[ChannelType]
end

function M:Destory()
  for ChannelName, ChannelType in pairs(ChatCommon.ChannelDef) do
    self._MessageDict[ChannelType]:ClearMessage()
  end
  self._MessageDict = {}
  self._CurrentFriendUid = nil
  self._GuildPrivateLocalSystemTips = {}
  self._CachedMainUISize = nil
  self._CachedMainUIPos = nil
  self._OriginMainUISize = nil
  self._OriginMainUIPos = nil
  self.EnteredChannels = {}
  self._CurrentChannel = ChatCommon.ChannelDef.Public
  RemoveFromRoot(self.SimpleChatOutAnimCurve)
  self.SimpleChatOutAnimCurve = nil
  self:SaveAllChannelIndex()
  M.Super.Destory(self)
end

function M:GetFriendChatDatas()
  return self:GetAvatar().Chats
end

function M:GetGuildChatDatas()
  return self:GetAvatar().GuildChats
end

function M:_GetGuildPrivateLocalSystemTipOwnerUid()
  return self:GetAvatar() and self:GetAvatar().Uid or 0
end

function M:_GetGuildPrivateLocalSystemTipMap(Uid, bCreate, OwnerUid)
  if not Uid then
    return nil
  end
  OwnerUid = tonumber(OwnerUid or self:_GetGuildPrivateLocalSystemTipOwnerUid()) or 0
  if OwnerUid <= 0 then
    return nil
  end
  self._GuildPrivateLocalSystemTips = self._GuildPrivateLocalSystemTips or {}
  local OwnerMap = self._GuildPrivateLocalSystemTips[OwnerUid]
  if not OwnerMap and bCreate then
    OwnerMap = {}
    self._GuildPrivateLocalSystemTips[OwnerUid] = OwnerMap
  end
  if not OwnerMap then
    return nil
  end
  local TipMap = OwnerMap[Uid]
  if not TipMap and bCreate then
    TipMap = {}
    OwnerMap[Uid] = TipMap
  end
  return TipMap
end

function M:_IsGuildPrivateLocalSystemTipMessage(Message, Uid, TipFlag)
  if not (Message and Uid) or not TipFlag then
    return false
  end
  local OwnerUid = self:_GetGuildPrivateLocalSystemTipOwnerUid()
  local MsgOwnerUid = tonumber(Message.GuildPrivateLocalSystemTipOwnerUid or Message.GuildPrivateDisabledTipOwnerUid or 0) or 0
  return true == Message[TipFlag] and Message.Type == CommonConst.MESSAGE_TYPE_SYSTEM and true == Message.IsGuildPrivate and Message.ReceiverUid == Uid and (0 == MsgOwnerUid or MsgOwnerUid == OwnerUid)
end

function M:GetGuildPrivateLocalSystemTip(Uid, TipFlag, OwnerUid)
  local TipMap = self:_GetGuildPrivateLocalSystemTipMap(Uid, false, OwnerUid)
  return TipMap and TipMap[TipFlag] or nil
end

function M:SetGuildPrivateLocalSystemTip(Uid, TipFlag, Message, OwnerUid)
  if not (Uid and TipFlag) or not Message then
    return
  end
  OwnerUid = tonumber(OwnerUid or self:_GetGuildPrivateLocalSystemTipOwnerUid()) or 0
  if OwnerUid <= 0 then
    return
  end
  Message[ChatCommon.GuildPrivateDisabledTipFlag] = TipFlag == ChatCommon.GuildPrivateDisabledTipFlag or nil
  Message[ChatCommon.GuildPrivateLeftGuildTipFlag] = TipFlag == ChatCommon.GuildPrivateLeftGuildTipFlag or nil
  Message.GuildPrivateLocalSystemTipOwnerUid = OwnerUid
  Message.GuildPrivateDisabledTipOwnerUid = OwnerUid
  local TipMap = self:_GetGuildPrivateLocalSystemTipMap(Uid, true, OwnerUid)
  TipMap[TipFlag] = Message
end

function M:ClearGuildPrivateLocalSystemTip(Uid, TipFlag, OwnerUid)
  local TipMap = self:_GetGuildPrivateLocalSystemTipMap(Uid, false, OwnerUid)
  if not TipMap then
    return
  end
  TipMap[TipFlag] = nil
  if nil == next(TipMap) then
    OwnerUid = tonumber(OwnerUid or self:_GetGuildPrivateLocalSystemTipOwnerUid()) or 0
    local OwnerMap = self._GuildPrivateLocalSystemTips and self._GuildPrivateLocalSystemTips[OwnerUid]
    if OwnerMap then
      OwnerMap[Uid] = nil
      if nil == next(OwnerMap) then
        self._GuildPrivateLocalSystemTips[OwnerUid] = nil
      end
    end
  end
end

function M:_HasGuildPrivateLocalSystemTipInView(Uid, TipFlag)
  local List = self._MessageDict and self._MessageDict[ChatCommon.ChannelDef.Friend]
  if not List or not List.ViewList then
    return false
  end
  for _, MsgWrap in ipairs(List.ViewList) do
    local Message = MsgWrap and MsgWrap.Message
    if self:_IsGuildPrivateLocalSystemTipMessage(Message, Uid, TipFlag) then
      return true
    end
  end
  return false
end

function M:_AppendGuildPrivateLocalSystemTipsToCurrentView(Uid)
  local TipMap = self:_GetGuildPrivateLocalSystemTipMap(Uid, false)
  if not TipMap then
    return
  end
  local List = self._MessageDict and self._MessageDict[ChatCommon.ChannelDef.Friend]
  if not List then
    return
  end
  for TipFlag, Message in pairs(TipMap) do
    if not self:_HasGuildPrivateLocalSystemTipInView(Uid, TipFlag) then
      List:AddMessage(Message, false)
    end
  end
end

function M:GetEmojiDatas()
  return self:GetAvatar().Emoticons
end

function M:GetQuickMsgDatas()
  return self:GetAvatar().QuickMessages
end

function M:HasEmojiGroup(GruopId)
  for _, Id in ipairs(self:GetEmojiDatas()) do
    if Id == GruopId then
      return true
    end
  end
  return false
end

function M:IsForbidChat()
  if self:GetAvatar().ForbidChatTime > TimeUtils.NowTime() then
    return true
  end
  return false
end

function M:SetCurrentChannel(ChannelType)
  self._CurrentChannel = ChannelType
end

function M:SetCurrentFriendUid(Uid)
  self._CurrentFriendUid = Uid
end

function M:GetCurrentFriendUid()
  return self._CurrentFriendUid
end

function M:SetCurrentSubTab(SubTab)
  self._CurrSubTab = SubTab
end

function M:GetCurrentSubTab()
  return self._CurrSubTab or ChatCommon.SubTabType.Friend
end

function M:UpdateCurrentChannel()
  local CurrChannel = self._CurrentChannel
  while self:IsChannelExclude(CurrChannel) do
    CurrChannel = CurrChannel + 1
    if CurrChannel > ChatCommon.ChannelDef.Friend then
      CurrChannel = ChatCommon.ChannelDef.TeamUp
    end
    if CurrChannel == self._CurrentChannel then
      break
    end
  end
  self._CurrentChannel = CurrChannel
  if self._CurrentChannel == ChatCommon.ChannelDef.SettlementOnline and GWorld:IsStandAlone() then
    self._CurrentChannel = ChatCommon.ChannelDef.Public
  end
end

function M:GetCurrentChannel()
  return self._CurrentChannel
end

function M:GetMainUISize()
  if not self._CachedMainUISize then
    self._CachedMainUISize = FVector2D(0, 0)
  end
  return self._CachedMainUISize
end

function M:GetMainUIPos()
  if not self._CachedMainUIPos then
    self._CachedMainUIPos = FVector2D(0, 0)
  end
  return self._CachedMainUIPos
end

function M:InitOriginMainUITransform(Slot)
  if not self._OriginMainUISize then
    self._OriginMainUISize = Slot:GetSize()
    self:GetMainUISize()
    self._CachedMainUISize.X = self._OriginMainUISize.X
    self._CachedMainUISize.Y = self._OriginMainUISize.Y
  end
  if not self._OriginMainUIPos then
    self._OriginMainUIPos = Slot:GetPosition()
    self:GetMainUIPos()
    self._CachedMainUIPos.X = self._OriginMainUIPos.X
    self._CachedMainUIPos.Y = self._OriginMainUIPos.Y
  end
end

function M:ResetCachedMainUITransform()
  if not self._OriginMainUISize then
    return
  end
  self:GetMainUISize()
  self._CachedMainUISize.X = self._OriginMainUISize.X
  self._CachedMainUISize.Y = self._OriginMainUISize.Y
  if not self._OriginMainUIPos then
    return
  end
  self:GetMainUIPos()
  self._CachedMainUIPos.X = self._OriginMainUIPos.X
  self._CachedMainUIPos.Y = self._OriginMainUIPos.Y
end

function M:HasMainUIChanged()
  return self._CachedMainUISize.X ~= self._OriginMainUISize.X or self._CachedMainUISize.Y ~= self._OriginMainUISize.Y or self._CachedMainUIPos.X ~= self._OriginMainUIPos.X or self._CachedMainUIPos.Y ~= self._OriginMainUIPos.Y
end

function M:AddReddotCount(ChannelType, FriendUid, Message)
  if 1 == self:GetAvatar().ChatChannelMute[ChannelType] then
    return
  end
  if Message and Message.Type == CommonConst.MESSAGE_TYPE_SELF then
    return
  end
  if ChannelType ~= ChatCommon.ChannelDef.Friend then
    local NodeName = ChatCommon.ReddotNamePre .. ChatCommon.ChannelNames[ChannelType]
    local Node = ReddotManager.GetTreeNode(NodeName)
    if Node and Node:GetNodeCount() <= ChatCommon.ReddotMaxCount then
      ReddotManager.IncreaseLeafNodeCount(NodeName)
      Node:UpdateParentsCount()
    end
    return
  end
  if not FriendUid then
    return
  end
  local SubTabType = ChatCommon.SubTabType.Friend
  local bGuildMsg = Message and self:IsMessageGuildPrivate(Message)
  if bGuildMsg then
    SubTabType = ChatCommon.SubTabType.Guild
  end
  local Key = self:GetPrivateChatParentName(SubTabType) .. FriendUid
  local Node = ReddotManager.GetTreeNode(Key)
  if not Node and SubTabType == ChatCommon.SubTabType.Friend then
    Node = self:AddPrivateChatReddotNode(FriendUid, SubTabType, true)
  end
  if not Node then
    return
  end
  if Node:GetNodeCount() <= ChatCommon.ReddotMaxCount then
    ReddotManager.IncreaseLeafNodeCount(Key)
    Node:UpdateParentsCount()
  end
end

function M:IsMessageGuildPrivate(Msg)
  return Msg and Msg.IsGuildPrivate == true
end

function M:ClearReddotCount(ChannelType, FriendUid, SubTabType)
  ChannelType = ChannelType or self._CurrentChannel
  if ChannelType ~= ChatCommon.ChannelDef.Friend then
    local NodeName = ChatCommon.ReddotNamePre .. ChatCommon.ChannelNames[ChannelType]
    ReddotManager.ClearLeafNodeCount(NodeName, true)
  else
    if not FriendUid then
      return
    end
    SubTabType = SubTabType or ChatCommon.SubTabType.Friend
    local NodeName = self:GetPrivateChatParentName(SubTabType) .. FriendUid
    if not ReddotManager.GetTreeNode(NodeName) then
      self:AddPrivateChatReddotNode(FriendUid, SubTabType, true)
    end
    if not ReddotManager.GetTreeNode(NodeName) then
      return
    end
    ReddotManager.ClearLeafNodeCount(NodeName, true)
  end
end

function M:AddPrivateChatReddotNode(Uid, SubTabType, bAppendParent)
  DebugPrint(LXYTag, "Chat  新的好友红点添加，Uid:", Uid)
  if nil == bAppendParent then
    bAppendParent = true
  end
  local ParentNodeName = self:GetPrivateChatParentName(SubTabType)
  local Key = ParentNodeName .. Uid
  local Node = ReddotManager.AddNodeEx(Key, nil, 1, EReddotType.Num)
  ReddotManager.ClearLeafNodeCount(Key)
  local Chat, Unread
  if SubTabType == ChatCommon.SubTabType.Friend then
    Chat = self:GetFriendChatDatas()[Uid]
    Unread = Chat and Chat.GetUnreadCount and Chat:GetUnreadCount() - 1 or 0
  elseif SubTabType == ChatCommon.SubTabType.Guild then
    Chat = self:GetGuildChatDatas()[Uid]
    Unread = Chat and Chat.GetUnreadCount and Chat:GetUnreadCount() or 0
  end
  if Unread > 0 then
    ReddotManager.IncreaseLeafNodeCount(Key, Unread)
  end
  local ParentNode = ReddotManager.AddNodeEx(ParentNodeName, {
    [Key] = {}
  }, 1)
  if bAppendParent then
    if ReddotManager.GetTreeNode(ParentNodeName) and Node then
      ReddotManager.AddNodeEx(ParentNodeName, {
        [Key] = {}
      }, 1)
    end
    local GrandNodeName = ChatCommon.ReddotNamePre .. ChatCommon.ChannelNames[ChatCommon.ChannelDef.Friend]
    local GrandNode
    if ReddotManager.GetTreeNode(GrandNodeName) and ParentNode then
      GrandNode = ReddotManager.AddNodeEx(GrandNodeName, {
        [ParentNodeName] = {}
      })
    end
    if ReddotManager.GetTreeNode(ChatCommon.ReddotName) and GrandNode then
      ReddotManager.AddNodeEx(ChatCommon.ReddotName, {
        [GrandNodeName] = {}
      })
    end
  end
  return Node
end

function M:InitReddotCount()
  local ChildNodes = {}
  for ChannelName, ChannelType in pairs(ChatCommon.ChannelDef) do
    local NodeName = ChatCommon.ReddotNamePre .. ChannelName
    if ChannelType ~= ChatCommon.ChannelDef.Friend then
      ReddotManager.AddNodeEx(NodeName, nil, 1, EReddotType.Num)
      ReddotManager.ClearLeafNodeCount(NodeName)
      ChildNodes[NodeName] = {}
    else
      for Uid, _ in pairs(self:GetAvatar().Friends) do
        local Node = self:AddPrivateChatReddotNode(Uid, ChatCommon.SubTabType.Friend, false)
      end
      for Uid, _ in pairs(self:GetGuildChatDatas()) do
        local Node = self:AddPrivateChatReddotNode(Uid, ChatCommon.SubTabType.Guild, false)
      end
      local FriendParentNodeName = self:GetPrivateChatParentName(ChatCommon.SubTabType.Friend)
      if ReddotManager.GetTreeNode(FriendParentNodeName) then
        ReddotManager.AddNodeEx(NodeName, {
          [FriendParentNodeName] = {}
        })
      end
      local GuildParentNodeName = self:GetPrivateChatParentName(ChatCommon.SubTabType.Guild)
      if ReddotManager.GetTreeNode(GuildParentNodeName) then
        ReddotManager.AddNodeEx(NodeName, {
          [GuildParentNodeName] = {}
        })
      end
      if ReddotManager.GetTreeNode(NodeName) then
        ChildNodes[NodeName] = {}
      end
    end
  end
  if next(ChildNodes) ~= nil then
    ReddotManager.AddNodeEx(ChatCommon.ReddotName, ChildNodes)
  end
end

function M:RegisterGuildUid(Uid, AvatarInfo)
  if not Uid then
    return false
  end
  local OldValue = self._GuildUids[Uid]
  local bChanged = false
  if nil == OldValue then
    self._GuildUids[Uid] = AvatarInfo or true
    bChanged = true
  elseif true == OldValue and AvatarInfo then
    self._GuildUids[Uid] = AvatarInfo
    bChanged = true
  elseif type(OldValue) == "table" and type(AvatarInfo) == "table" then
    local function HasDifferentValue(Target, Source)
      local IsChanged = false
      
      for Key, Value in pairs(Source) do
        if Target[Key] ~= Value then
          IsChanged = true
          break
        end
      end
      return IsChanged
    end
    
    if HasDifferentValue(OldValue, AvatarInfo) then
      CommonUtils.MergeTables(OldValue, AvatarInfo)
      bChanged = true
    end
  end
  if not OldValue then
    self:AddPrivateChatReddotNode(Uid, ChatCommon.SubTabType.Guild, true)
  end
  return bChanged
end

function M:UnregisterGuildUid(Uid)
  if not Uid or not self._GuildUids[Uid] then
    return
  end
  self._GuildUids[Uid] = nil
  self:ReadChannelMessage(ChatCommon.ChannelDef.Friend, Uid, ChatCommon.SubTabType.Guild)
end

function M:IsGuildUid(Uid)
  return Uid and self._GuildUids[Uid] ~= nil
end

function M:GetGuildUidList()
  return self._GuildUids
end

function M:RestoreGuildUidListFromChatDatas()
  local GuildChatDatas = self:GetGuildChatDatas()
  if type(GuildChatDatas) ~= "table" then
    return false
  end
  local bChanged = false
  for Uid, Chat in pairs(GuildChatDatas) do
    local NormalizedUid = tonumber(Uid) or 0
    if NormalizedUid > 0 then
      local PlayerInfo = type(Chat) == "table" and Chat.PlayerInfo or nil
      if self:RegisterGuildUid(NormalizedUid, PlayerInfo or true) then
        bChanged = true
      end
    end
  end
  return bChanged
end

function M:ClearAllGuildUids()
  for Uid, _ in pairs(self._GuildUids) do
    self:ReadChannelMessage(ChatCommon.ChannelDef.Friend, Uid, ChatCommon.SubTabType.Guild)
  end
  self._GuildUids = {}
end

function M:AddMessage(Message, bCalcUnread)
  DebugPrint("ChatModel::AddMessage", self._CurrentChannel, self._CurrentFriendUid)
  local ChannelType = Message.ChannelType
  DebugPrint("ChatModel::AddMessage", bCalcUnread)
  if bCalcUnread then
    self:AddReddotCount(ChannelType, Message.Sender.Uid, Message)
  end
  if self._CurrentFriendUid and ChannelType == ChatCommon.ChannelDef.Friend and (Message.Type == CommonConst.MESSAGE_TYPE_PRIVATE or Message.Type == CommonConst.MESSAGE_TYPE_SELF) then
    local bSelf = Message.Sender and Message.Sender.Uid == GWorld:GetAvatar().Uid
    local FriendUid = bSelf and Message.ReceiverUid or Message.Sender.Uid
    if bSelf then
      bCalcUnread = false
    end
    if ChannelType ~= self._CurrentChannel then
      return
    end
    if self._CurrentFriendUid ~= FriendUid then
      return
    end
    local bMsgGuild = self:IsMessageGuildPrivate(Message)
    local bTabGuild = self._CurrSubTab == ChatCommon.SubTabType.Guild
    if bMsgGuild ~= bTabGuild then
      return
    end
  end
  DebugPrint("ChatMessage::AddMessage bUnread, " .. tostring(bCalcUnread))
  return self._MessageDict[ChannelType]:AddMessage(Message, bCalcUnread)
end

function M:LoadHistoryMessages(ChannelType, Messages)
  local List = self._MessageDict[ChannelType]
  if not List or type(Messages) ~= "table" then
    return
  end
  local MyUid = GWorld:GetAvatar().Uid
  for _, Msg in ipairs(Messages) do
    Msg.ChannelType = ChannelType
    if Msg.Sender and Msg.Sender.Uid == MyUid then
      Msg.Type = CommonConst.MESSAGE_TYPE_SELF
    end
    List:AddMessage(Msg, false)
  end
end

function M:GetCurrentMsgViewList()
  if self._CurrentChannel == ChatCommon.ChannelDef.Friend then
    local bGuildTab = self._CurrSubTab == ChatCommon.SubTabType.Guild
    local ChatsTable = bGuildTab and self:GetGuildChatDatas() or self:GetFriendChatDatas()
    local TargetChat = {
      Messages = {}
    }
    if self._CurrentFriendUid then
      local RawChat = ChatsTable and ChatsTable[self._CurrentFriendUid]
      if RawChat then
        TargetChat = RawChat
      end
    else
      local FinalIndexies = {}
      local MessagesPerUid = {}
      for Uid, Chat in pairs(ChatsTable or {}) do
        local bVisible = bGuildTab and self:IsGuildUid(Uid) or self:GetAvatar().Friends[Uid] ~= nil
        if bVisible then
          MessagesPerUid[Uid] = Chat.Messages or {}
        end
      end
      for i = 0, DataMgr.GlobalConstant.ChatMsgCountInBattleMain.ConstantValue do
        local Newest
        for Uid, Messages in pairs(MessagesPerUid) do
          if 0 == i then
            FinalIndexies[Uid] = #Messages
          else
            local FinalIndex = FinalIndexies[Uid]
            if 0 == FinalIndex then
            else
              local Msg = Messages[FinalIndex]
              if not Newest or Newest.Time < Msg.Time then
                Newest = Msg
              end
            end
          end
        end
        if not Newest then
        else
          table.insert(TargetChat.Messages, Newest)
          local Uid = Newest.Sender.Uid
          if Uid == GWorld:GetAvatar().Uid then
            Uid = Newest.ReceiverUid
          end
          FinalIndexies[Uid] = FinalIndexies[Uid] - 1
        end
      end
      table.reverse(TargetChat.Messages)
    end
    self._MessageDict[self._CurrentChannel]:UpdateFromChat(TargetChat)
    if bGuildTab and self._CurrentFriendUid then
      self._MessageDict[self._CurrentChannel].ViewList = self._MessageDict[self._CurrentChannel].ViewList or {}
      self:_AppendGuildPrivateLocalSystemTipsToCurrentView(self._CurrentFriendUid)
    end
  end
  return self._MessageDict[self._CurrentChannel].ViewList
end

function M:GetChannelCDTimerKey(ChannelType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  return self._MessageDict[ChannelType].TimerKey
end

function M:GetChannelCDReaminTime(ChannelType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  return self._MessageDict[ChannelType].CDRemainTime
end

function M:GetChannelRemovedMsgs(ChannelType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  return self._MessageDict[ChannelType]:GetOnceRemovedMsgs()
end

function M:SetChannelCDRemainTime(RemainTime, ChannelType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  self._MessageDict[ChannelType].CDRemainTime = RemainTime
end

function M:SetChannelMsgCache(MsgCache, ChannelType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  if self._CurrentFriendUid and ChannelType == ChatCommon.ChannelDef.Friend then
    local bGuildTab = self._CurrSubTab == ChatCommon.SubTabType.Guild
    local ChatsTable = bGuildTab and self:GetGuildChatDatas() or self:GetFriendChatDatas()
    local Chat = ChatsTable and ChatsTable[self._CurrentFriendUid]
    if Chat then
      Chat:SetMsgCache(MsgCache)
    end
  end
  self._MessageDict[ChannelType].MsgCache = MsgCache
end

function M:GetChannelMsgCache(ChannelType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  if self._CurrentFriendUid and ChannelType == ChatCommon.ChannelDef.Friend then
    local bGuildTab = self._CurrSubTab == ChatCommon.SubTabType.Guild
    local ChatsTable = bGuildTab and self:GetGuildChatDatas() or self:GetFriendChatDatas()
    local Chat = ChatsTable and ChatsTable[self._CurrentFriendUid]
    if Chat then
      self:SetChannelMsgCache(Chat:GetMsgCache())
    end
  end
  return self._MessageDict[ChannelType].MsgCache
end

function M:GetChannelUnreadCount(ChannelType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  return self._MessageDict[ChannelType].UnreadCount
end

function M:GetChannelNewTipWrap(ChannelType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  return self._MessageDict[ChannelType].NewTipWrap
end

function M:ReadChannelMessage(ChannelType, Uid, SubTabType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  self._MessageDict[ChannelType]:ReadMessage()
  self:ClearReddotCount(ChannelType, Uid, SubTabType)
end

function M:ClearMessage(ChannelType)
  if nil == ChannelType then
    ChannelType = self._CurrentChannel
  end
  return self._MessageDict[ChannelType]:ClearMessage()
end

function M:GetTeamForChat()
  local TeamData = TeamController:GetModel():GetTeam()
  if not GWorld:IsStandAlone() and TeamData then
    TeamData = CommonUtils.CopyTable(TeamData)
    local TeamDataBackup = TeamController:GetModel():GetTeamBackup()
    for j, Member2 in ipairs(TeamController:GetModel():GetTeam().Members or {}) do
      for i, Member in ipairs(TeamDataBackup and TeamDataBackup.Members or {}) do
        if Member.Nickname == Member2.Nickname then
          local NewMember = CommonUtils.CopyTable(Member)
          NewMember.Index = Member2.Index
          TeamData.Members[j] = NewMember
        end
      end
      if Member2.Nickname == GWorld:GetAvatar().Nickname and not TeamDataBackup then
        TeamData.Members[j] = GWorld:GetAvatar()
      end
    end
  end
  return TeamData
end

function M:IsInRegionOnline()
  return self:GetAvatar().IsInRegionOnline
end

function M:GetRegionId()
  return self:GetAvatar().CurrentOnlineType
end

function M:IsInRegionOnlineChannelType()
  local Res = self:IsInRegionOnline() and (self:GetCurrentChannel() == CommonConst.ChatChannel.RegionOnline or UIManager(self):GetUIObj("LevelMapMain"))
  return Res
end

function M:SetChannelIndex(ChannelType, ChannelIndex)
  if not ChannelType or not ChannelIndex then
    return
  end
  if not self._CurrentChannelIndex then
    self._CurrentChannelIndex = {}
  end
  self._CurrentChannelIndex[ChannelType] = ChannelIndex
end

function M:GetChannelIndex(ChannelType)
  if self:IsInRegionOnlineChannelType() then
    ChannelType = self:GetRegionId()
  end
  return self._CurrentChannelIndex[ChannelType]
end

function M:SetAllChannelList(AllChannels)
  self._AllChannelList = AllChannels
  self.FirstIndex = math.maxinteger
  self.LastIndex = math.mininteger
  for Index, v in ipairs(self._AllChannelList) do
    self.FirstIndex = math.min(self.FirstIndex, Index)
    self.LastIndex = math.max(self.LastIndex, Index)
  end
end

function M:GetNumbersContainingOfSearch(Target)
  if not self._AllChannelList then
    return {}
  end
  local TargetStr = tostring(Target)
  local Result = {}
  for Index, State in pairs(self._AllChannelList) do
    if tostring(Index):find(TargetStr, 1, true) then
      table.insert(Result, {Idx = Index, State = State})
    end
    if 9 == #Result then
      break
    end
  end
  return Result
end

function M:GetChannelState(ChannelIndex)
  if not self._AllChannelList then
    return 1
  end
  return self._AllChannelList[ChannelIndex]
end

function M:SetSelectChannelIndex(ChannelIndex)
  self._SelectChannelIndex = ChannelIndex
end

function M:GetSelectChannelIndex()
  return self._SelectChannelIndex
end

function M:InitRecvChannelIndex()
  self.RecvChannelIndex = {}
  local ChannelInfos = EMCache:Get(ChatCommon.ChannelCache, true) or {}
  self.RecvChannelIndex = ChannelInfos
end

function M:SaveAllChannelIndex()
  if not self.RecvChannelIndex then
    return
  end
  EMCache:Set(ChatCommon.ChannelCache, self.RecvChannelIndex, true)
end

function M:SaveChannelIndex(ChannelType, ChannelIndex, online_type)
  if not ChannelIndex or not ChannelType then
    return
  end
  local Type = online_type and online_type or ChannelType
  if not self.RecvChannelIndex[Type] then
    self.RecvChannelIndex[Type] = {}
  end
  table.insert(self.RecvChannelIndex[Type], ChannelIndex)
  for i = #self.RecvChannelIndex[Type] - 1, 1, -1 do
    if self.RecvChannelIndex[Type][i] == ChannelIndex then
      table.remove(self.RecvChannelIndex[Type], i)
    end
  end
  if #self.RecvChannelIndex[Type] > 5 then
    table.remove(self.RecvChannelIndex[Type], 1)
  end
  EMCache:Set(ChatCommon.ChannelCache, self.RecvChannelIndex, true)
end

function M:GetRecvChannelIndex()
  local Type
  if self:IsInRegionOnlineChannelType() then
    Type = self:GetRegionId()
  else
    Type = CommonConst.ChatChannel.Help
  end
  return self.RecvChannelIndex[Type] or {}
end

function M:SetIsEnterChannelContent(Value)
  self.IsEnterChannelContentVar = Value
end

function M:IsEnterChannelContent()
  return self.IsEnterChannelContentVar
end

function M:RefreshRecvChannelIndex(ChannelType, ChannelNumList)
  local Type = ChannelType
  if not self.IsEnterChannelContentVar then
    return
  end
  if not self._HistoryChannelList then
    self._HistoryChannelList = {}
  end
  self._HistoryChannelList[Type] = ChannelNumList
end

function M:GetNumbersContainingOfHistory()
  if not self._HistoryChannelList then
    return {}
  end
  local Type
  if self:IsInRegionOnlineChannelType() then
    Type = self:GetRegionId()
  else
    Type = CommonConst.ChatChannel.Help
  end
  local ChannelIndexInfo = self.RecvChannelIndex[Type]
  if not ChannelIndexInfo then
    return {}
  end
  local ChannelInfo = self._HistoryChannelList[Type] or {}
  local Result = {}
  for i = #ChannelIndexInfo, 1, -1 do
    if ChannelInfo[ChannelIndexInfo[i]] then
      table.insert(Result, {
        Idx = ChannelIndexInfo[i],
        State = ChannelInfo[ChannelIndexInfo[i]]
      })
    else
      table.remove(ChannelIndexInfo, i)
    end
  end
  return Result
end

return M
