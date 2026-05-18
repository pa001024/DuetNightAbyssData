local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendModel = FriendController:GetModel()
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local PlayerMenuActionRegistry = require("BluePrints.UI.WBP.Chat.View.PlayerMenuActionRegistry")
local MenuActionId = PlayerMenuActionRegistry.ActionId
local Component = {}

function Component:SetupAnchor(Anchor, Head, AvatarInfo, MenuConfig)
  self.HeadAnchor = Anchor
  self.HeadAnchor:Close()
  self.Head = Head
  self.bAnchorOpen = false
  self.Head:BindOnClickEvent(function()
    self.HeadAnchor:Open(true)
  end)
  self._AvatarInfo = AvatarInfo
  self._MenuConfig = MenuConfig
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
  self._MenuConfig = nil
end

local function CopyActionIds(ActionIds)
  local Copied = {}
  for _, ActionId in ipairs(ActionIds or {}) do
    table.insert(Copied, ActionId)
  end
  return Copied
end

local function RemoveActionById(ActionIds, TargetActionId)
  for Idx, ActionId in ipairs(ActionIds or {}) do
    if ActionId == TargetActionId then
      table.remove(ActionIds, Idx)
      return
    end
  end
end

function Component:OnAnchorGetUserMenuContent(Anchor)
  local ActionIds = {}
  local Avatar = ChatController:GetAvatar()
  local IsYourSelf = self._AvatarInfo.Uid == Avatar.Uid
  local InBounsScene = GWorld.GameInstance.IsInTempScene and GWorld.GameInstance:IsInTempScene()
  local IsInDungeon = GWorld:GetAvatar():IsInDungeon()
  local IsInHardBoss = GWorld:GetAvatar():IsInHardBoss()
  if IsInHardBoss then
    if InBounsScene then
      ActionIds = IsYourSelf and {} or {
        MenuActionId.AddFriendOnly
      }
    else
      ActionIds = IsYourSelf and {
        MenuActionId.ShowRecord
      } or {
        MenuActionId.AddFriendOnly,
        MenuActionId.ShowRecord
      }
    end
  elseif InBounsScene or IsInDungeon then
    ActionIds = IsYourSelf and {} or {
      MenuActionId.AddFriendOnly
    }
  else
    ActionIds = IsYourSelf and {
      MenuActionId.ShowRecord
    } or {
      MenuActionId.AddFriendOnly,
      MenuActionId.ShowRecord
    }
  end
  if not IsYourSelf and FriendModel:GetFriendDict()[self._AvatarInfo.Uid] then
    RemoveActionById(ActionIds, MenuActionId.AddFriendOnly)
  end
  local ConfigActionIds = self._MenuConfig and self._MenuConfig.VisibleActionIds
  if type(ConfigActionIds) == "table" then
    ActionIds = CopyActionIds(ConfigActionIds)
  end
  local FuncList = PlayerMenuActionRegistry:BuildMenuFuncList(ActionIds, {
    Owner = self,
    AvatarInfo = self._AvatarInfo,
    CloseMenu = function()
      if self.HeadAnchor then
        self.HeadAnchor:Close()
      end
    end
  })
  return ChatController:OpenPlayerBtnList(self, self._AvatarInfo, FuncList)
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
