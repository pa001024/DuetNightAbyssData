local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendModel = FriendController:GetModel()
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local Component = {}

function Component:SetupAnchor(Anchor, Head, AvatarInfo, bSetUpEvent, MessageContent)
  self.HeadAnchor = Anchor
  self.Head = Head
  self._AvatarInfo = AvatarInfo
  self._bSetUpEvent = bSetUpEvent
  self._MessageContent = MessageContent
  if bSetUpEvent then
    self.HeadAnchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
    self.HeadAnchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
  end
end

function Component:CleanUpAnchor()
  if self._bSetUpEvent then
    self.HeadAnchor.OnGetMenuContentEvent:Unbind()
    self.HeadAnchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
  end
  self.HeadAnchor = nil
  self.Head = nil
  self._bSetUpEvent = false
end

function Component:OnAnchorGetUserMenuContent(Anchor)
  local function InitShowRecordBtn(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_ShowRecord")
    
    function Content.Callback()
      if AvatarInfo.Uid == GWorld:GetAvatar().Uid then
        PersonInfoController:OpenView()
      else
        GWorld:GetAvatar():CheckOtherPlayerPersonallInfo(AvatarInfo.Uid)
      end
      self.HeadAnchor:Close()
    end
  end
  
  local function AddFriend(Content, AvatarInfo)
    local TargetUid = FriendController:GetSocialUid(AvatarInfo.Uid, AvatarInfo)
    if not FriendModel:GetFriendDict()[TargetUid] then
      Content.Text = GText("UI_Friend_AddFriend")
      
      function Content.Callback()
        FriendController:OpenAddFriendDialog(self, AvatarInfo)
        self.HeadAnchor:Close()
      end
    else
      Content.Text = GText("UI_Chat_SendMsg")
      
      function Content.Callback()
        ChatController:SelectPlayerToChat(TargetUid)
        self.HeadAnchor:Close()
      end
    end
  end
  
  local function InviteTeam(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_InviteTeam")
    
    function Content.Callback()
      TeamController:SendTeamInvite(AvatarInfo.Uid)
      self.HeadAnchor:Close()
    end
  end
  
  local AddBlackList = FriendController:GenAddBlackListFunc(self, self.HeadAnchor)
  local Switch = {}
  local Avatar = ChatController:GetAvatar()
  local IsYourSelf = self._AvatarInfo.Uid == Avatar.Uid
  local InBounsScene = GWorld.GameInstance.IsInTempScene and GWorld.GameInstance:IsInTempScene()
  local IsInDungeon = GWorld:GetAvatar():IsInDungeon()
  local IsInHardBoss = GWorld:GetAvatar():IsInHardBoss()
  local bNotInvitable = TeamController:GetModel():GetInviteSendBox()[self._AvatarInfo.Uid] or Avatar:IsInMultiDungeon()
  local TeamData = TeamController:GetModel():GetTeam()
  bNotInvitable = bNotInvitable or 4 == (TeamData and #TeamData.Members)
  local Channel = ChatController:GetModel():GetCurrentChannel()
  local InviteTeamIdx
  local AccusePlayer = FriendController:GenAccusePlayerFunc(self, self.HeadAnchor, self._MessageContent, function()
    self:BroadcastDialogEvent(DialogEvent.HideDialogItem, {
      bHideDialogItem = true,
      DialogItemIndex = 1,
      bShouldPlayAnim = false
    })
    self:BroadcastDialogEvent(DialogEvent.HideDialogItem, {
      bHideDialogItem = true,
      DialogItemIndex = 2,
      bShouldPlayAnim = false
    })
  end, self.OnTextChange, self.OnTextComposing, function()
    if self.bTipsShowed then
      self.Owner:HideDialogTip(2, false)
      self.bTipsShowed = false
    end
  end)
  if IsInHardBoss then
    if InBounsScene then
      InviteTeamIdx = 2
      Switch = IsYourSelf and {} or {
        AddFriend,
        InviteTeam,
        AddBlackList
      }
    else
      InviteTeamIdx = 3
      Switch = IsYourSelf and {InitShowRecordBtn} or {
        AddFriend,
        InitShowRecordBtn,
        InviteTeam,
        AddBlackList
      }
    end
  elseif InBounsScene or IsInDungeon then
    InviteTeamIdx = 2
    if InBounsScene then
      Switch = IsYourSelf and {} or {
        AddFriend,
        AddBlackList,
        AccusePlayer
      }
    else
      Switch = IsYourSelf and {} or {
        AddFriend,
        InviteTeam,
        AddBlackList,
        AccusePlayer
      }
    end
  else
    InviteTeamIdx = 3
    Switch = IsYourSelf and {InitShowRecordBtn} or {
      AddFriend,
      InitShowRecordBtn,
      InviteTeam,
      AddBlackList
    }
  end
  if not IsYourSelf and not table.isempty(Switch) then
    if self._MessageContent and not IsInDungeon and not InBounsScene then
      table.insert(Switch, AccusePlayer)
    end
    if bNotInvitable then
      table.remove(Switch, InviteTeamIdx)
    end
    if (Channel == ChatCommon.ChannelDef.InTeam or Channel == ChatCommon.ChannelDef.Friend) and FriendModel:GetFriendDict()[self._AvatarInfo.Uid] then
      table.remove(Switch, 1)
    end
  end
  return ChatController:OpenPlayerBtnList(self, self._AvatarInfo, Switch)
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

return Component
