local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendModel = FriendController:GetModel()
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local Component = {}

function Component:SetupAnchor(Anchor, Head, AvatarInfo)
  self.HeadAnchor = Anchor
  self.HeadAnchor:Close()
  self.Head = Head
  self.bAnchorOpen = false
  self.Head:BindOnClickEvent(function()
    self.HeadAnchor:Open(true)
  end)
  self._AvatarInfo = AvatarInfo
  self.HeadAnchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
  self.HeadAnchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
end

function Component:CleanUpAnchor()
  if self.HeadAnchor then
    self.HeadAnchor.OnGetMenuContentEvent:Unbind()
    self.HeadAnchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
    self.HeadAnchor:Close()
    self.HeadAnchor = nil
  end
  self.Head = nil
  self.bAnchorOpen = false
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
    Content.Text = GText("UI_Friend_AddFriend")
    
    function Content.Callback()
      FriendController:OpenAddFriendDialog(self, AvatarInfo)
      self.HeadAnchor:Close()
    end
  end
  
  local Switch = {}
  local Avatar = ChatController:GetAvatar()
  local IsYourSelf = self._AvatarInfo.Uid == Avatar.Uid
  local InBounsScene = GWorld.GameInstance.IsInTempScene and GWorld.GameInstance:IsInTempScene()
  local IsInDungeon = GWorld:GetAvatar():IsInDungeon()
  local IsInHardBoss = GWorld:GetAvatar():IsInHardBoss()
  
  local function AccusePlayer(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_Accuse")
    
    function Content.Callback()
      local Params = {
        Nickname = AvatarInfo.Nickname,
        UID = AvatarInfo.Uid,
        Url = AvatarInfo.Url,
        Level = AvatarInfo.Level,
        PictureUniqueId = AvatarInfo.PictureUniqueId,
        TextLenMax = 50,
        ForbidRightBtn = true,
        DontCloseWhenRightBtnClicked = true,
        isPhotoReport = true
      }
      
      function Params.HideItemTips()
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
      end
      
      Params.EditTextConfig = {
        Owner = self,
        TextLimit = 50,
        Events = {
          OnTextChanged = self.OnTextChange,
          OnTextComposing = self.OnTextComposing
        }
      }
      Params.AllowNegativeAttitude = IsInDungeon or IsInHardBoss
      ChatController:OpenChatReportDialog(Params)
      self.HeadAnchor:Close()
    end
  end
  
  if IsInHardBoss then
    if InBounsScene then
      Switch = IsYourSelf and {} or {AddFriend}
    else
      Switch = IsYourSelf and {InitShowRecordBtn} or {AddFriend, InitShowRecordBtn}
    end
  elseif InBounsScene or IsInDungeon then
    Switch = IsYourSelf and {} or {AddFriend}
  else
    Switch = IsYourSelf and {InitShowRecordBtn} or {AddFriend, InitShowRecordBtn}
  end
  if not IsYourSelf and not table.isempty(Switch) then
    table.insert(Switch, AccusePlayer)
  end
  if not IsYourSelf and FriendModel:GetFriendDict()[self._AvatarInfo.Uid] then
    table.remove(Switch, 1)
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
