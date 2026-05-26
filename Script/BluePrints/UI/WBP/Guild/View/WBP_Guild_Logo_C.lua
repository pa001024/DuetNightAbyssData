require("UnLua")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

local function GetSizedResourcePath(ResourceData, IsBig, LargePathKey, SmallPathKey, DefaultPathKey)
  if type(ResourceData) ~= "table" then
    return nil
  end
  if true == IsBig then
    return ResourceData[LargePathKey] or ResourceData[SmallPathKey] or ResourceData[DefaultPathKey]
  end
  return ResourceData[SmallPathKey] or ResourceData[LargePathKey] or ResourceData[DefaultPathKey]
end

function M:LoadGuildLogoResources(Parsed)
  local LogoId = tonumber(Parsed.LogoIcon) or tonumber(Parsed.T_LogoType) or tonumber(Parsed.LogoMat) or 0
  local FlagId = tonumber(Parsed.BgIcon) or tonumber(Parsed.T_BGType) or tonumber(Parsed.LogoMat) or 0
  local LogoData = DataMgr.GuildLogo and DataMgr.GuildLogo[LogoId] or nil
  local FlagData = DataMgr.GuildFlag and DataMgr.GuildFlag[FlagId] or nil
  if not LogoData then
    DebugPrint(string.format("不存在ID为%s的公会Logo，请检查GuildLogo表格", tostring(LogoId)))
  end
  if not FlagData then
    DebugPrint(string.format("不存在ID为%s的公会旗帜，请检查GuildFlag表格", tostring(FlagId)))
  end
  local IsBig = self.IsBig == true
  local LogoPath = LogoData and LogoData.LogoPath or nil
  local FlagPath
  if FlagData then
    FlagPath = GetSizedResourcePath(FlagData, IsBig, "FlagPathL", "FlagPathS", "FlagPath")
  end
  self.LogoTextureObj = nil
  self.FlagTextureObj = nil
  if LogoData then
    if LogoPath then
      self.LogoTextureObj = LoadObject(LogoPath)
    end
    if not self.LogoTextureObj then
      RedPrint(string.format("公会Logo没有找到对应资源路径，路径为%s", tostring(LogoPath)))
    end
  end
  if FlagData then
    if FlagPath then
      self.FlagTextureObj = LoadObject(FlagPath)
    end
    if not self.FlagTextureObj then
      RedPrint(string.format("公会旗帜没有找到对应资源路径，路径为%s", tostring(FlagPath)))
    end
  end
  self.T_LogoType = self.LogoTextureObj
  self.T_BGType = self.FlagTextureObj
end

function M:Init(LogoInfo)
  local Parsed = GuildLogoInfo.Parse(LogoInfo) or GuildLogoInfo.Empty()
  self.Color_Index_Logo = tonumber(Parsed.LogoColor) or 0
  self.Color_Index_Flag = tonumber(Parsed.BgColor) or 0
  self.LogoMatIndex = tonumber(Parsed.LogoMat) or 0
  self.BGShadingIndex = tonumber(Parsed.BGShadingIndex) or 0
  self.T_BGShading = self.BGShadingIndex
  self.T_BGTypeIndex = tonumber(Parsed.T_BGType) or tonumber(Parsed.BgIcon) or 0
  self.T_LogoTypeIndex = tonumber(Parsed.T_LogoType) or tonumber(Parsed.LogoIcon) or 0
  self:LoadGuildLogoResources(Parsed)
  self.LogoInfo = Parsed
  self:UpdateFlagMat()
end

function M:PlayIn()
  self:PlayAnimation(self.In)
end

return M
