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
  if not LogoStr or "" == LogoStr then
    return GuildLogoInfo.Default()
  end
  local Parts = string.split(LogoStr, "|")
  local Logo = Parts[1]
  local Bg = Parts[2]
  if not Logo or not Bg then
    return GuildLogoInfo.Default()
  end
  local LogoParts = string.split(Logo, ",")
  local BgParts = string.split(Bg, ",")
  if 3 ~= #LogoParts or 3 ~= #BgParts then
    return GuildLogoInfo.Default()
  end
  local NewObj = {}
  setmetatable(NewObj, GuildLogoInfo)
  NewObj.LogoColor = tonumber(LogoParts[1])
  NewObj.LogoMat = tonumber(LogoParts[2])
  NewObj.LogoIcon = tonumber(LogoParts[3])
  NewObj.BgColor = tonumber(BgParts[1])
  NewObj.BgMat = tonumber(BgParts[2])
  NewObj.BgIcon = tonumber(BgParts[3])
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
