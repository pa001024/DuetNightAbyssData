local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildMessage", {
  BuyComponent = {
    Content = "UI_GuildHomeBuyComponent",
    IsSendToGuildChat = 0,
    TabId = 2,
    Type = "BuyComponent"
  },
  ChangeGuildName = {
    Content = "UI_GuildNameChanged",
    IsSendToGuildChat = 1,
    TabId = 1,
    Type = "ChangeGuildName"
  },
  ChangedDecl = {
    Content = "UI_GuildDeclarationChanged",
    IsSendToGuildChat = 1,
    TabId = 1,
    Type = "ChangedDecl "
  },
  ChangedLogo = {
    Content = "UI_GuildLogoChanged",
    IsSendToGuildChat = 1,
    TabId = 1,
    Type = "ChangedLogo"
  },
  ExchangeFund = {
    Content = "UI_GuildHomeExchangeFund",
    IsSendToGuildChat = 0,
    TabId = 2,
    Type = "ExchangeFund"
  },
  GuildBossStageReward = {
    Content = "UI_GuildHomeGuildBossStageReward",
    IsSendToGuildChat = 0,
    TabId = 3,
    Type = "GuildBossStageReward"
  },
  GuildCreateSuccess = {
    Content = "UI_GuildCreated",
    IsSendToGuildChat = 1,
    TabId = 1,
    Type = "GuildCreateSuccess"
  },
  JoinMember = {
    Content = "UI_MemberJoinedGuild",
    IsSendToGuildChat = 1,
    TabId = 1,
    Type = "JoinMember"
  },
  KickMember = {
    Content = "UI_MemberRemovedFromGuild",
    IsSendToGuildChat = 0,
    TabId = 1,
    Type = "KickMember"
  },
  LeaveMember = {
    Content = "UI_MemberLeftGuild",
    IsSendToGuildChat = 1,
    TabId = 1,
    Type = "LeaveMember"
  },
  PublishLayout = {
    Content = "UI_GuildHomePublishLayout",
    IsSendToGuildChat = 0,
    TabId = 2,
    Type = "PublishLayout"
  },
  SetOwner = {
    Content = "UI_GuildMasterTransferred",
    IsSendToGuildChat = 0,
    TabId = 1,
    Type = "SetOwner"
  },
  SetPermissionSwitch = {
    Content = "UI_RolePermissionsAdjusted",
    IsSendToGuildChat = 0,
    TabId = 1,
    Type = "SetPermissionSwitch"
  },
  SetTitle = {
    Content = "UI_RoleAssigned",
    IsSendToGuildChat = 0,
    TabId = 1,
    Type = "SetTitle"
  }
})
