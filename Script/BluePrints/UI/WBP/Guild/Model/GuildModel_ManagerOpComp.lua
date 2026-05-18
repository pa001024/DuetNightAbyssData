local GuildDatas = require("BluePrints.UI.WBP.Guild.Common.GuildDatas")
local GuildReqLookupTable = GuildDatas.GuildReqLookupTable
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local Component = {}

function Component:OnInit()
  self.GuildReqLookupTable = nil
  self.EditingLogoInfo = GuildLogoInfo.Empty()
end

function Component:OnDestory()
end

function Component:CreateEditingLogoInfo(LogoColor, LogoMat, LogoIcon, BgColor, BgMat, BgIcon)
  self.EditingLogoInfo = GuildLogoInfo.BuildGuildLogoInfo(LogoColor, LogoMat, LogoIcon, BgColor, BgMat, BgIcon)
  return self.EditingLogoInfo
end

function Component:SetEditingLogoInfo(LogoInfo)
  self.EditingLogoInfo = LogoInfo
end

function Component:GetEditingLogoInfo()
  return self.EditingLogoInfo
end

function Component:CreateReqLookTable(OrderList)
  self.GuildReqLookupTable = GuildReqLookupTable.New(OrderList)
  return self.GuildReqLookupTable
end

function Component:GetReqLookTable()
  return self.GuildReqLookupTable
end

return Component
