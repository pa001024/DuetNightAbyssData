local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendModel = FriendController:GetModel()
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local PlayerMenuActionRegistry = require("BluePrints.UI.WBP.Chat.View.PlayerMenuActionRegistry")
local MenuActionId = PlayerMenuActionRegistry.ActionId
local Component = {}
local CopyActionIds, RemoveActionById, AddGuildAction

function Component:SetupAnchor(Anchor, Head, AvatarInfo, bSetUpEvent, MessageContent, MenuConfig)
  self.HeadAnchor = Anchor
  self.Head = Head
  self._AvatarInfo = AvatarInfo
  self._bSetUpEvent = bSetUpEvent
  self._MessageContent = MessageContent
  self._MenuConfig = MenuConfig
  if bSetUpEvent then
    self.HeadAnchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
    self.HeadAnchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
  end
end

function Component:SetGuildFullInfo(GuildInfo, NotShowOpreationBtn, NotShowGuildSendPrivateChat)
  self.GuildInfo = GuildInfo
  self.GuildNotShowOpreationBtn = NotShowOpreationBtn
  self.NotShowGuildSendPrivateChat = NotShowGuildSendPrivateChat
end

function Component:CleanUpAnchor()
  if self._bSetUpEvent then
    self.HeadAnchor.OnGetMenuContentEvent:Unbind()
    self.HeadAnchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
  end
  self.HeadAnchor = nil
  self.Head = nil
  self._bSetUpEvent = false
  self._MenuConfig = nil
  self.GuildInfo = nil
end

function Component:OnAnchorGetUserMenuContent(Anchor)
  local ActionIds = {}
  local Avatar = ChatController:GetAvatar()
  local Uid = self._AvatarInfo.Uid or self._AvatarInfo.Uuid
  local IsYourSelf = Uid == Avatar.Uid
  local InBounsScene = GWorld.GameInstance.IsInTempScene and GWorld.GameInstance:IsInTempScene()
  local IsInDungeon = GWorld:GetAvatar():IsInDungeon()
  local IsInHardBoss = GWorld:GetAvatar():IsInHardBoss()
  local bNotInvitable = TeamController:GetModel():GetInviteSendBox()[self._AvatarInfo.Uid] or Avatar:IsInMultiDungeon()
  local TeamData = TeamController:GetModel():GetTeam()
  bNotInvitable = bNotInvitable or 4 == (TeamData and #TeamData.Members)
  local Channel = ChatController:GetModel():GetCurrentChannel()
  local ShouldCheckInviteTeam = false
  if IsInHardBoss then
    if InBounsScene then
      ShouldCheckInviteTeam = true
      ActionIds = IsYourSelf and {} or {
        MenuActionId.AddFriendOrChat,
        MenuActionId.InviteTeam
      }
    else
      ShouldCheckInviteTeam = true
      ActionIds = IsYourSelf and {
        MenuActionId.ShowRecord
      } or {
        MenuActionId.AddFriendOrChat,
        MenuActionId.ShowRecord,
        MenuActionId.InviteTeam
      }
    end
  elseif InBounsScene or IsInDungeon then
    if InBounsScene then
      ActionIds = IsYourSelf and {} or {
        MenuActionId.AddFriendOrChat
      }
    else
      ShouldCheckInviteTeam = true
      ActionIds = IsYourSelf and {} or {
        MenuActionId.AddFriendOrChat,
        MenuActionId.InviteTeam
      }
    end
  else
    ShouldCheckInviteTeam = true
    ActionIds = IsYourSelf and {
      MenuActionId.ShowRecord
    } or {
      MenuActionId.AddFriendOrChat,
      MenuActionId.ShowRecord,
      MenuActionId.InviteTeam
    }
  end
  if not IsYourSelf and not table.isempty(ActionIds) then
    if bNotInvitable and ShouldCheckInviteTeam then
      RemoveActionById(ActionIds, MenuActionId.InviteTeam)
    end
    if (Channel == ChatCommon.ChannelDef.InTeam or Channel == ChatCommon.ChannelDef.Friend) and FriendModel:GetFriendDict()[self._AvatarInfo.Uid] then
      RemoveActionById(ActionIds, MenuActionId.AddFriendOrChat)
    end
  end
  AddGuildAction(ActionIds, self.GuildInfo, self._AvatarInfo, self.GuildNotShowOpreationBtn, self.NotShowGuildSendPrivateChat)
  local ConfigActionIds = self._MenuConfig and self._MenuConfig.VisibleActionIds
  if "table" == type(ConfigActionIds) then
    ActionIds = CopyActionIds(ConfigActionIds)
  end
  local FuncList = PlayerMenuActionRegistry:BuildMenuFuncList(ActionIds, {
    Owner = self,
    AvatarInfo = self._AvatarInfo,
    MessageContent = self._MessageContent,
    CloseMenu = function()
      if self.HeadAnchor then
        self.HeadAnchor:Close()
      end
    end
  })
  return ChatController:OpenPlayerBtnList(self, self._AvatarInfo, FuncList, self.GuildInfo)
end

function Component:HeadMenuOpenChanged(bOpen)
  if self.OnHeadMenuOpenChanged then
    self:OnHeadMenuOpenChanged(bOpen)
  end
  if bOpen then
    return
  end
  if self.Head then
    self.Head:PlayNormal()
  end
end

function CopyActionIds(ActionIds)
  local Copied = {}
  for _, ActionId in ipairs(ActionIds or {}) do
    table.insert(Copied, ActionId)
  end
  return Copied
end

function RemoveActionById(ActionIds, TargetActionId)
  for Idx, ActionId in ipairs(ActionIds or {}) do
    if ActionId == TargetActionId then
      table.remove(ActionIds, Idx)
      return
    end
  end
end

function AddGuildAction(ActionIds, GuildInfo, AvatarInfo, GuildNotShowOpreationBtn, NotShowGuildSendPrivateChat)
  local IsInGuild = GuildController:GetModel():IsInGuild()
  if not IsInGuild then
    return
  end
  if not GuildInfo then
    table.insert(ActionIds, MenuActionId.GuildInvite)
    return
  end
  local MyUid = ChatController:GetAvatar().Uid
  local MemberUid = AvatarInfo.Uuid or AvatarInfo.Uid
  if MyUid == MemberUid then
    local MemberCount = #GuildInfo.Members
    local IsMaster = MyUid == GuildInfo.OwnerUid
    if IsMaster and 1 == MemberCount then
      table.insert(ActionIds, MenuActionId.DissolveGuild)
    else
      if IsMaster then
        GuildInfo.IsSelfMaster = IsMaster
      end
      table.insert(ActionIds, MenuActionId.QuitGuild)
    end
    return
  end
  local SelfGuildInfo = GuildController:GetModel():GetCurrGuild()
  if GuildInfo.GuildId == SelfGuildInfo.GuildId then
    if not NotShowGuildSendPrivateChat then
      table.insert(ActionIds, MenuActionId.GuildSendPrivateChat)
    end
    local SelfMember = GuildController.GetGuildMember(SelfGuildInfo.Members, ChatController:GetAvatar().Uid)
    local CurMember = GuildController.GetGuildMember(GuildInfo.Members, MemberUid)
    local SelfTitle = SelfMember.Title
    local CurTitle = CurMember.Title
    if not GuildNotShowOpreationBtn then
      if SelfTitle >= 3 and SelfTitle > CurTitle then
        table.insert(ActionIds, MenuActionId.GuildAdjustRole)
      end
      if SelfTitle > CurTitle then
        table.insert(ActionIds, MenuActionId.KickOutGuildMember)
      end
    end
  end
end

return Component
