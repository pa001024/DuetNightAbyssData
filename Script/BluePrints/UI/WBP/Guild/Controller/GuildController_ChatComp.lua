local Component = {}
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")

function Component:OnInit()
  self._GuildChatHistoryLoaded = false
  EventManager:AddEvent(EventID.CloseLoading, self, self.OnCloseLoading_Chat)
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnLoginSuccess_Chat)
  EventManager:AddEvent(EventID.OnNetDisconnect, self, self.OnNetDisconnect_Chat)
end

function Component:OnDestory()
  EventManager:RemoveEvent(EventID.CloseLoading, self)
  EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
  EventManager:RemoveEvent(EventID.OnNetDisconnect, self)
end

function Component:OnOpenView(ViewObj)
end

function Component:_ResetGuildChannelSnapshotLoadGuard()
  self._GuildChatHistoryLoaded = false
  self._GuildChatHistoryLoadedGuildId = nil
  self._GuildChatHistoryLoadedAvatar = nil
  self._GuildChannelSnapshotLoad = nil
end

function Component:OnLoginSuccess_Chat()
  self:_ResetGuildChannelSnapshotLoadGuard()
end

function Component:OnNetDisconnect_Chat()
  self:_ResetGuildChannelSnapshotLoadGuard()
end

function Component:_BeginGuildChannelSnapshotLoad(GuildId)
  local Avatar = self:GetAvatar()
  GuildId = tonumber(GuildId or 0) or 0
  if not Avatar or GuildId <= 0 then
    return
  end
  if self._GuildChannelSnapshotLoad and tonumber(self._GuildChannelSnapshotLoad.GuildId or 0) == GuildId then
    self._GuildChannelSnapshotLoad.NeedReload = true
    return
  end
  self._GuildChannelSnapshotLoadSerial = (self._GuildChannelSnapshotLoadSerial or 0) + 1
  self._GuildChannelSnapshotLoad = {
    Serial = self._GuildChannelSnapshotLoadSerial,
    GuildId = GuildId,
    HistoryDone = false,
    DynamicDone = false,
    HistoryMessages = {},
    GuildMessages = {}
  }
  Avatar:GetGuildChatHistory(nil)
  Avatar:GetGuildMessage(nil)
end

function Component:_SubmitGuildChannelSnapshotPart(Part, Ret, Data)
  local State = self._GuildChannelSnapshotLoad
  if not State then
    return false
  end
  local Avatar = self:GetAvatar()
  if not Avatar or tonumber(Avatar.GuildId or 0) ~= State.GuildId then
    self._GuildChannelSnapshotLoad = nil
    return true
  end
  local bSuccess = Ret == ErrorCode.RET_SUCCESS
  if "History" == Part then
    State.HistoryDone = true
    if bSuccess then
    end
    State.HistoryMessages = Data or {} or {}
  elseif "Dynamic" == Part then
    State.DynamicDone = true
    if bSuccess then
    end
    State.GuildMessages = Data or {} or {}
  end
  if State.HistoryDone and State.DynamicDone then
    local NeedReload = State.NeedReload
    ChatController:LoadGuildChannelSnapshot(State.HistoryMessages, State.GuildMessages, State.GuildId)
    self._GuildChannelSnapshotLoad = nil
    if NeedReload and Avatar and tonumber(Avatar.GuildId or 0) == State.GuildId then
      self:_BeginGuildChannelSnapshotLoad(State.GuildId)
    end
  end
  return true
end

function Component:OnCloseLoading_Chat()
  local Avatar = self:GetAvatar()
  if not (Avatar and Avatar.GuildId) or 0 == tonumber(Avatar.GuildId) then
    return
  end
  if self._GuildChatHistoryLoaded and self._GuildChatHistoryLoadedAvatar == Avatar and tonumber(self._GuildChatHistoryLoadedGuildId or 0) == tonumber(Avatar.GuildId or 0) then
    return
  end
  self._GuildChatHistoryLoaded = true
  self._GuildChatHistoryLoadedAvatar = Avatar
  self._GuildChatHistoryLoadedGuildId = tonumber(Avatar.GuildId or 0)
  self:_BeginGuildChannelSnapshotLoad(Avatar.GuildId)
end

function Component:OnGuildIdChanged(GuildId)
  if not GuildId or 0 == tonumber(GuildId) then
    self:_ResetGuildChannelSnapshotLoadGuard()
    ChatController:ClearGuildChatMessages()
    ChatController:OnGuildLeave()
  end
end

function Component:RecvGetGuildChatHistory(SrcParams, Ret, Messages)
  if self:_SubmitGuildChannelSnapshotPart("History", Ret, Messages) then
    return
  end
  if Ret == ErrorCode.RET_SUCCESS then
    ChatController:LoadGuildChatHistory(Messages)
  end
end

function Component:RecvGetGuildMessage(SrcParams, Ret, GuildMessages)
  if self:_SubmitGuildChannelSnapshotPart("Dynamic", Ret, GuildMessages) then
    return
  end
  if Ret == ErrorCode.RET_SUCCESS then
    ChatController:LoadGuildDynamicSystemMessages(GuildMessages, self:GetAvatar() and self:GetAvatar().GuildId)
  end
end

return Component
