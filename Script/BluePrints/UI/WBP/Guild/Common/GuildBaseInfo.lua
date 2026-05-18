local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local GuildBaseInfo = Class()
GuildBaseInfo.GuildId = 0
GuildBaseInfo.Name = ""
GuildBaseInfo.LogoInfo = ""
GuildBaseInfo.Level = 1
GuildBaseInfo.ActivityLevel = 0
GuildBaseInfo.MemberCount = 0

function GuildBaseInfo.New(ServerInfo)
  if not ServerInfo then
    return nil
  end
  local NewObj = {}
  setmetatable(NewObj, GuildBaseInfo)
  CommonUtils.MergeTables(NewObj, ServerInfo)
  NewObj.Logo = nil
  if not string.isempty(ServerInfo.Logo) then
    NewObj:UpdateLogo(ServerInfo.Logo)
  else
    NewObj:UpdateLogo("1,1,1|1,1,1")
  end
  return NewObj
end

function GuildBaseInfo:UpdateLogo(LogoInfo)
  self.LogoInfo = GuildLogoInfo.New(LogoInfo)
end

return GuildBaseInfo
