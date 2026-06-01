local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendModel = FriendController:GetModel()
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local M = {}
M.ActionId = {
  ShowRecord = "SHOW_RECORD",
  AddFriendOnly = "ADD_FRIEND_ONLY",
  AddFriendOrChat = "ADD_FRIEND_OR_CHAT",
  InviteTeam = "INVITE_TEAM",
  JoinLeague = "JOIN_LEAGUE",
  KickGuildMember = "KICK_GUILD_MEMBER",
  LeaveGuild = "LEAVE_GUILD",
  GuildSendPrivateChat = "GUILD_SEND_PRIVATE_CHAT",
  GuildAdjustRole = "GUILD_ADJUST_ROLE",
  KickOutGuildMember = "KICK_OUT_GUILD_Member",
  GuildInvite = "GUILD_INVITE",
  QuitGuild = "QUIT_GUILD",
  DissolveGuild = "DISSOLVE_GUILD"
}
local GetActionBuilders

function M:BuildMenuFuncList(ActionIds, Context)
  local FuncList = {}
  local ActionBuilders = GetActionBuilders()
  for _, ActionId in ipairs(ActionIds or {}) do
    local Builder = ActionBuilders[ActionId]
    if Builder then
      local Func = Builder(Context)
      if Func then
        table.insert(FuncList, Func)
      end
    end
  end
  return FuncList
end

local function CloseMenu(Context)
  if Context and Context.CloseMenu then
    Context.CloseMenu()
    return
  end
  local Owner = Context and Context.Owner
  if Owner and Owner.HeadAnchor then
    Owner.HeadAnchor:Close()
  end
end

local function IsPersonInfoPageOpen()
  local UIManagerComp = GWorld.GameInstance and GWorld.GameInstance:GetGameUIManager()
  if not UIManagerComp then
    return false
  end
  local TopState = UIManagerComp.GetCurrentState and UIManagerComp:GetCurrentState() or nil
  if TopState and TopState.GetUIConfigName and TopState:GetUIConfigName() == PersonInfoCommon.UIName then
    return true
  end
  local View = UIManagerComp:GetUIObj(PersonInfoCommon.UIName)
  return View and View.IsVisible and View:IsVisible()
end

local function BuildShowRecord(Context)
  if IsPersonInfoPageOpen() then
    return nil
  end
  return function(Content, AvatarInfo, GuildFullInfo)
    Content.Text = GText("UI_Chat_ShowRecord")
    
    function Content.Callback()
      local Uid = AvatarInfo.Uid or AvatarInfo.Uuid
      if Uid == GWorld:GetAvatar().Uid then
        PersonInfoController:OpenView()
      else
        GWorld:GetAvatar():CheckOtherPlayerPersonallInfo(Uid, nil, AvatarInfo, GuildFullInfo)
      end
      CloseMenu(Context)
    end
  end
end

local function BuildAddFriendOnly(Context)
  return function(Content, AvatarInfo)
    Content.Text = GText("UI_Friend_AddFriend")
    
    function Content.Callback()
      FriendController:OpenAddFriendDialog(Context and Context.Owner, AvatarInfo)
      CloseMenu(Context)
    end
  end
end

local function BuildAddFriendOrChat(Context)
  return function(Content, AvatarInfo)
    local Uid = AvatarInfo.Uid or AvatarInfo.Uuid
    local TargetUid = FriendController:GetSocialUid(Uid, AvatarInfo)
    if not FriendModel:GetFriendDict()[TargetUid] then
      Content.Text = GText("UI_Friend_AddFriend")
      
      function Content.Callback()
        FriendController:OpenAddFriendDialog(Context and Context.Owner, AvatarInfo)
        CloseMenu(Context)
      end
    else
      Content.Text = GText("UI_Chat_SendMsg")
      
      function Content.Callback()
        ChatController:SelectPlayerToChat(TargetUid)
        CloseMenu(Context)
      end
    end
  end
end

local function BuildInviteTeam(Context)
  return function(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_InviteTeam")
    
    function Content.Callback()
      local Uid = AvatarInfo.Uid or AvatarInfo.Uuid
      TeamController:SendTeamInvite(Uid)
      CloseMenu(Context)
    end
  end
end

local function GuildSendPrivateChat(Context)
  return function(Content, AvatarInfo, GuildFullInfo)
    Content.Text = GText("UI_SendPrivateMessage")
    
    function Content.Callback()
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      local Avatar = GWorld:GetAvatar()
      if not Avatar.GuildChatOpen then
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("GuildPrivateChatClose"))
        return
      end
      if GuildFullInfo.CardGuildChatOpen then
        ChatController:OpenView(nil)
        ChatController:SelectGuildMemberToChat(AvatarInfo.Uid or AvatarInfo.Uuid, nil)
      else
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_PrivateChatNotEnabled"))
      end
    end
  end
end

local function BuildInGuildAdjustRoleJob(Context)
  return function(Content, AvatarInfo, GuildFullInfo)
    Content.Text = GText("UI_AdjustMemberRole")
    
    function Content.Callback()
      GuildController:ShowJobLevelView(AvatarInfo.Uid or AvatarInfo.Uuid, GuildFullInfo)
    end
  end
end

local function KickOutGuildMember(Context)
  return function(Content, AvatarInfo, GuildFullInfo)
    Content.Text = GText("UI_KickMemberFromGuild")
    
    function Content.Callback()
      local Params = {
        RightCallbackFunction = function()
          GuildController:SendGuildKickMember(AvatarInfo.Uid or AvatarInfo.Uuid)
        end,
        ShortText = GText("UI_ConfirmKickMember"),
        AutoFocus = true,
        AutoFocusDelayTime = 0.02
      }
      local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      UIManager:ShowCommonPopupUI(GuildCommon.GuildComfirmDialog, Params)
    end
  end
end

local function GuildInvite(Context)
  return function(Content, AvatarInfo, GuildFullInfo, ClickCallback)
    Content.Text = GText("InviteToGuild")
    
    function Content.Callback()
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      if not AvatarInfo.IsOnline then
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("CannotInviteOfflinePlayer"))
        return
      end
      if AvatarInfo.IsInDungeon then
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("PlayerInDungeon"))
        return
      end
      if ClickCallback then
        ClickCallback()
      end
      GuildController:SendInviteJoinGuild(AvatarInfo.Uid or AvatarInfo.Uuid)
    end
  end
end

local function QuitGuild(Context)
  return function(Content, AvatarInfo, GuildFullInfo)
    Content.Text = GText("UI_QuitGuild")
    
    function Content.Callback()
      if GuildFullInfo.IsSelfMaster then
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildMasterCannotQuit"))
        return
      end
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      local Params = {}
      
      function Params.RightCallbackFunction()
        GuildController:SendGuildLeave()
      end
      
      local CurrentLevel = 0
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        CurrentLevel = Avatar.Level or 0
      end
      if CurrentLevel < DataMgr.GlobalConstant.GuildQuitProtectLevel.ConstantValue then
        Params.Tips = {
          string.format(GText("GuildExitProtectToast"), tostring(DataMgr.GlobalConstant.GuildQuitProtectLevel.ConstantValue), tostring(DataMgr.GlobalConstant.GuildQuitLowLevelCoolDownM.ConstantValue))
        }
      else
        Params.Tips = {
          string.format(GText("UI_RejoinGuildCooldown"), tostring(DataMgr.GlobalConstant.GuildQuitRejoinCoolDownH.ConstantValue))
        }
      end
      Params.AutoFocus = true
      Params.AutoFocusDelayTime = 0.02
      UIManager:ShowCommonPopupUI(100365, Params)
    end
  end
end

local function DissolveGuild(Context)
  return function(Content, AvatarInfo, GuildFullInfo)
    Content.Text = GText("UI_DissolveGuild")
    
    function Content.Callback()
      local Params = {
        RightCallbackFunction = function()
          GuildController:SendGuildLeave()
        end,
        ShortText = GText("UI_ConfirmDissolveGuild"),
        AutoFocus = true,
        AutoFocusDelayTime = 0.02
      }
      local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      UIManager:ShowCommonPopupUI(GuildCommon.GuildComfirmDialog, Params)
    end
  end
end

function GetActionBuilders()
  return {
    [M.ActionId.ShowRecord] = BuildShowRecord,
    [M.ActionId.AddFriendOnly] = BuildAddFriendOnly,
    [M.ActionId.AddFriendOrChat] = BuildAddFriendOrChat,
    [M.ActionId.InviteTeam] = BuildInviteTeam,
    [M.ActionId.GuildSendPrivateChat] = GuildSendPrivateChat,
    [M.ActionId.GuildAdjustRole] = BuildInGuildAdjustRoleJob,
    [M.ActionId.KickOutGuildMember] = KickOutGuildMember,
    [M.ActionId.GuildInvite] = GuildInvite,
    [M.ActionId.QuitGuild] = QuitGuild,
    [M.ActionId.DissolveGuild] = DissolveGuild
  }
end

return M
