local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildMessage", {
  ChangeGuildName = {
    Content = "UI_GuildNameChanged",
    IsSendToGuildChat = 1,
    Type = "ChangeGuildName"
  },
  ChangedDecl = {
    Content = "UI_GuildDeclarationChanged",
    IsSendToGuildChat = 1,
    Type = "ChangedDecl "
  },
  ChangedLogo = {
    Content = "UI_GuildLogoChanged",
    IsSendToGuildChat = 1,
    Type = "ChangedLogo"
  },
  GuildCreateSuccess = {
    Content = "UI_GuildCreated",
    IsSendToGuildChat = 1,
    Type = "GuildCreateSuccess"
  },
  JoinMember = {
    Content = "UI_MemberJoinedGuild",
    IsSendToGuildChat = 1,
    Type = "JoinMember"
  },
  KickMember = {
    Content = "UI_MemberRemovedFromGuild",
    IsSendToGuildChat = 0,
    Type = "KickMember"
  },
  LeaveMember = {
    Content = "UI_MemberLeftGuild",
    IsSendToGuildChat = 1,
    Type = "LeaveMember"
  },
  SetOwner = {
    Content = "UI_GuildMasterTransferred",
    IsSendToGuildChat = 0,
    Type = "SetOwner"
  },
  SetPermissionSwitch = {
    Content = "UI_RolePermissionsAdjusted",
    IsSendToGuildChat = 0,
    Type = "SetPermissionSwitch"
  },
  SetTitle = {
    Content = "UI_RoleAssigned",
    IsSendToGuildChat = 0,
    Type = "SetTitle"
  }
})
