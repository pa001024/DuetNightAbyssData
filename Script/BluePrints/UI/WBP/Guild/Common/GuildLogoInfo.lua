local GuildLogoInfo = Class()
GuildLogoInfo.LogoColor = 0
GuildLogoInfo.LogoMat = 0
GuildLogoInfo.LogoIcon = 0
GuildLogoInfo.BgColor = 0
GuildLogoInfo.BgMat = 0
GuildLogoInfo.BgIcon = 0

function GuildLogoInfo.BuildGuildLogoInfo(LogoColor, LogoMat, LogoIcon, BgColor, BgMat, BgIcon)
  local NewObj = {}
  setmetatable(NewObj, GuildLogoInfo)
  NewObj.LogoColor = tonumber(LogoColor) or 0
  NewObj.LogoMat = tonumber(LogoMat) or 0
  NewObj.LogoIcon = tonumber(LogoIcon) or 0
  NewObj.BgColor = tonumber(BgColor) or 0
  NewObj.BgMat = tonumber(BgMat) or 0
  NewObj.BgIcon = tonumber(BgIcon) or 0
  return NewObj
end

function GuildLogoInfo.New(LogoStr)
  if not LogoStr then
    return nil
  end
  local NewObj = {}
  setmetatable(NewObj, GuildLogoInfo)
  local Logo, Bg = table.unpack(string.split(LogoStr, "|"))
  NewObj.LogoColor, NewObj.LogoMat, NewObj.LogoIcon = table.unpack(string.split(Logo, ","))
  NewObj.BgColor, NewObj.BgMat, NewObj.BgIcon = table.unpack(string.split(Bg, ","))
  NewObj.LogoColor = tonumber(NewObj.LogoColor)
  NewObj.LogoMat = tonumber(NewObj.LogoMat)
  NewObj.LogoIcon = tonumber(NewObj.LogoIcon)
  NewObj.BgColor = tonumber(NewObj.BgColor)
  NewObj.BgMat = tonumber(NewObj.BgMat)
  NewObj.BgIcon = tonumber(NewObj.BgIcon)
  return NewObj
end

function GuildLogoInfo.Empty()
  return GuildLogoInfo.BuildGuildLogoInfo(0, 0, 0, 0, 0, 0)
end

function GuildLogoInfo.Default()
  return GuildLogoInfo.BuildGuildLogoInfo(1, 0, 1001, 1, 0, 1001)
end

function GuildLogoInfo.Parse(LogoInfo)
  if type(LogoInfo) == "string" then
    if "" == LogoInfo then
      return nil
    end
    local Parts = string.split(LogoInfo, "|")
    local LogoParts = string.split(Parts[1] or "", ",")
    local BgParts = string.split(Parts[2] or "", ",")
    return GuildLogoInfo.BuildGuildLogoInfo(LogoParts[1], LogoParts[2], LogoParts[3], BgParts[1], BgParts[2], BgParts[3])
  end
  if type(LogoInfo) ~= "table" then
    return nil
  end
  if LogoInfo.LogoColor ~= nil or nil ~= LogoInfo.BgColor or nil ~= LogoInfo.LogoMat or nil ~= LogoInfo.BgMat then
    local Parsed = GuildLogoInfo.BuildGuildLogoInfo(LogoInfo.LogoColor, LogoInfo.LogoMat, LogoInfo.LogoIcon, LogoInfo.BgColor, LogoInfo.BgMat, LogoInfo.BgIcon)
    Parsed.BGShadingIndex = tonumber(LogoInfo.BGShadingIndex) or tonumber(LogoInfo.T_BGShading) or tonumber(LogoInfo.BgMat) or 0
    Parsed.T_BGType = LogoInfo.T_BGType
    Parsed.T_LogoType = LogoInfo.T_LogoType
    return Parsed
  end
  return GuildLogoInfo.Parse(LogoInfo.LogoInfo or LogoInfo.Logo)
end

function GuildLogoInfo:Pack()
  local Logo = table.concat({
    self.LogoColor,
    self.LogoMat,
    self.LogoIcon
  }, ",")
  local Bg = table.concat({
    self.BgColor,
    self.BgMat,
    self.BgIcon
  }, ",")
  return table.concat({Logo, Bg}, "|")
end

return GuildLogoInfo
