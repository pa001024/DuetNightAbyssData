local Component = {}
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local GuildBaseInfo = require("BluePrints.UI.WBP.Guild.Common.GuildBaseInfo")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")

local function ExtractGuildDisplayData(SourceInfo)
  if type(SourceInfo) ~= "table" then
    return 0, "", nil, nil
  end
  local GuildSimpleInfo = "table" == type(SourceInfo.GuildSimpleInfo) and SourceInfo.GuildSimpleInfo or nil
  local GuildId = tonumber(GuildSimpleInfo and (GuildSimpleInfo.GuildId or GuildSimpleInfo.GuildID or GuildSimpleInfo.Id) or SourceInfo.GuildId or SourceInfo.GuildID or 0) or 0
  local GuildName = GuildSimpleInfo and (GuildSimpleInfo.Name or GuildSimpleInfo.GuildName) or SourceInfo.GuildName or ""
  local GuildLogo = GuildSimpleInfo and (GuildSimpleInfo.LogoInfo or GuildSimpleInfo.Logo or GuildSimpleInfo.GuildLogoInfo or GuildSimpleInfo.GuildLogo) or SourceInfo.GuildLogoInfo or SourceInfo.GuildLogo
  return GuildId, GuildName, GuildLogo, GuildSimpleInfo
end

local function NormalizeGuildSimpleInfo(SourceInfo, FallbackGuildId, FallbackGuildName, FallbackGuildLogo)
  if type(SourceInfo) ~= "table" and nil == FallbackGuildId and nil == FallbackGuildName and nil == FallbackGuildLogo then
    return nil
  end
  local GuildId = tonumber(type(SourceInfo) == "table" and (SourceInfo.GuildId or SourceInfo.GuildID or SourceInfo.Id) or FallbackGuildId or 0) or 0
  local GuildName = type(SourceInfo) == "table" and (SourceInfo.Name or SourceInfo.GuildName) or FallbackGuildName or ""
  local RawGuildLogo = type(SourceInfo) == "table" and (SourceInfo.LogoInfo or SourceInfo.Logo or SourceInfo.GuildLogoInfo or SourceInfo.GuildLogo) or FallbackGuildLogo
  local ParsedGuildLogo = GuildLogoInfo.Parse(RawGuildLogo)
  if GuildId <= 0 and "" == GuildName and nil == ParsedGuildLogo and nil == RawGuildLogo then
    return nil
  end
  return {
    GuildId = GuildId,
    Name = GuildName,
    LogoInfo = ParsedGuildLogo or RawGuildLogo,
    Logo = RawGuildLogo or ParsedGuildLogo
  }
end

local function NormalizePlayerGuildInfo(PlayerInfo)
  if type(PlayerInfo) ~= "table" then
    return
  end
  local GuildId, GuildName, GuildLogo, GuildSimpleInfo = ExtractGuildDisplayData(PlayerInfo)
  local NormalizedGuildSimpleInfo = NormalizeGuildSimpleInfo(GuildSimpleInfo, GuildId, GuildName, GuildLogo)
  local NormalizedGuildLogo = GuildLogoInfo.Parse(GuildLogo) or GuildLogo
  if NormalizedGuildSimpleInfo then
    PlayerInfo.GuildSimpleInfo = NormalizedGuildSimpleInfo
    GuildId = tonumber(NormalizedGuildSimpleInfo.GuildId or 0) or GuildId
    GuildName = NormalizedGuildSimpleInfo.Name or GuildName
    NormalizedGuildLogo = NormalizedGuildSimpleInfo.LogoInfo or NormalizedGuildSimpleInfo.Logo or NormalizedGuildLogo
  end
  PlayerInfo.GuildId = GuildId
  if "" ~= GuildName then
    PlayerInfo.GuildName = GuildName
  end
  if nil ~= NormalizedGuildLogo then
    PlayerInfo.GuildLogoInfo = NormalizedGuildLogo
    PlayerInfo.GuildLogo = NormalizedGuildLogo
  end
end

local function HasGuildDisplayInfo(PlayerInfo)
  local GuildId, GuildName, GuildLogo = ExtractGuildDisplayData(PlayerInfo)
  if GuildId <= 0 then
    return true
  end
  if "" == GuildName then
    return false
  end
  return GuildLogoInfo.Parse(GuildLogo) ~= nil
end

local function MergePlayerInfoFromAvatarInfo(PlayerInfo, AvatarInfo, PlayerUuid)
  if type(PlayerInfo) ~= "table" or type(AvatarInfo) ~= "table" then
    return
  end
  local AvatarUid = AvatarInfo.Uid or AvatarInfo.Uuid
  if nil ~= PlayerUuid and nil ~= AvatarUid and tostring(AvatarUid) ~= tostring(PlayerUuid) then
    return
  end
  local GuildId = tonumber(AvatarInfo.GuildId or AvatarInfo.GuildID or 0) or 0
  if GuildId > 0 then
    PlayerInfo.GuildId = GuildId
  end
  if nil ~= AvatarInfo.GuildSimpleInfo then
    PlayerInfo.GuildSimpleInfo = AvatarInfo.GuildSimpleInfo
  end
  if nil ~= AvatarInfo.GuildName and AvatarInfo.GuildName ~= "" then
    PlayerInfo.GuildName = AvatarInfo.GuildName
  end
  if nil ~= AvatarInfo.GuildLogoInfo then
    PlayerInfo.GuildLogoInfo = AvatarInfo.GuildLogoInfo
  end
  if nil ~= AvatarInfo.GuildLogo then
    PlayerInfo.GuildLogo = AvatarInfo.GuildLogo
  end
  NormalizePlayerGuildInfo(PlayerInfo)
end

local function TryRequestOtherGuildSimpleInfo(Avatar, PlayerInfo, PlayerUuid)
  if not Avatar or type(PlayerInfo) ~= "table" or nil == PlayerUuid then
    return
  end
  NormalizePlayerGuildInfo(PlayerInfo)
  if HasGuildDisplayInfo(PlayerInfo) then
    return
  end
  local GuildId = tonumber(PlayerInfo.GuildId or 0) or 0
  if GuildId <= 0 then
    return
  end
  Avatar:GetGuildSimpleInfo(function(ret, ServerGuildSimpleInfo)
    if not ErrorCode:Check(ret) then
      return
    end
    if not PlayerInfo or tostring(PlayerInfo.Uuid) ~= tostring(PlayerUuid) then
      return
    end
    local GuildSimpleInfo = GuildBaseInfo.New(ServerGuildSimpleInfo)
    if not GuildSimpleInfo then
      return
    end
    PlayerInfo.GuildSimpleInfo = GuildSimpleInfo
    PlayerInfo.GuildName = GuildSimpleInfo.Name or PlayerInfo.GuildName
    PlayerInfo.GuildLogoInfo = GuildSimpleInfo.LogoInfo or PlayerInfo.GuildLogoInfo
    PlayerInfo.GuildLogo = GuildSimpleInfo.LogoInfo or PlayerInfo.GuildLogo
    NormalizePlayerGuildInfo(PlayerInfo)
    PersonInfoController:HandleOtherPlayerGuildSimpleInfo(PlayerUuid, GuildSimpleInfo)
  end, GuildId)
end

function Component:EnterWorld()
  PersonInfoController:Init()
end

function Component:LeaveWorld()
  PersonInfoController:Destory()
end

function Component:AddCharDisplay(Callback, Id, AppearancePlan, ModPlan)
  if not (Id and AppearancePlan) or not ModPlan then
    DebugPrint("AddCharDisplay Invalid arguments")
    return
  end
  
  local function cb(ret)
    if not ErrorCode:Check(ret) then
      return
    end
    if Callback then
      Callback(ret)
    end
  end
  
  self:CallServer("AddCharDisplay", cb, Id, AppearancePlan, ModPlan)
end

function Component:RemoveCharDisplay(Callback, Index)
  if not Index then
    DebugPrint("RemoveCharDisplay Invalid arguments")
    return
  end
  
  local function cb(ret)
    if not ErrorCode:Check(ret) then
      return
    end
    if Callback then
      Callback(ret)
    end
  end
  
  self:CallServer("RemoveCharDisplay", cb, Index)
end

function Component:UpdateCharDisplay(Callback, Index, Id, AppearancePlan, ModPlan)
  if not (Index and Id and AppearancePlan) or not ModPlan then
    DebugPrint("UpdateCharDisplay Invalid arguments")
    return
  end
  
  local function cb(ret)
    if not ErrorCode:Check(ret) then
      return
    end
    if Callback then
      Callback(ret)
    end
  end
  
  self:CallServer("UpdateCharDisplay", cb, Index, Id, AppearancePlan, ModPlan)
end

function Component:AddWeaponDisplay(Callback, Id, ModPlan)
  if not Id or not ModPlan then
    DebugPrint("AddWeaponDisplay Invalid arguments")
    return
  end
  
  local function cb(ret)
    if not ErrorCode:Check(ret) then
      return
    end
    if Callback then
      Callback(ret)
    end
  end
  
  self:CallServer("AddWeaponDisplay", cb, Id, ModPlan)
end

function Component:RemoveWeaponDisplay(Callback, Index)
  if not Index then
    DebugPrint("RemoveWeaponDisplay Invalid arguments")
    return
  end
  
  local function cb(ret)
    if not ErrorCode:Check(ret) then
      return
    end
    if Callback then
      Callback(ret)
    end
  end
  
  self:CallServer("RemoveWeaponDisplay", cb, Index)
end

function Component:UpdateWeaponDisplay(Callback, Index, Id, ModPlan)
  if not (Index and Id) or not ModPlan then
    DebugPrint("UpdateWeaponDisplay Invalid arguments")
    return
  end
  
  local function cb(ret)
    if not ErrorCode:Check(ret) then
      return
    end
    if Callback then
      Callback(ret)
    end
  end
  
  self:CallServer("UpdateWeaponDisplay", cb, Index, Id, ModPlan)
end

function Component:CheckOtherPlayerPersonallInfo(PlayerUuid, bForceUsedServerData, AvatarInfo)
  self.logger.debug("CheckOtherPlayerPersonallInfo Begin", PlayerUuid)
  if not PlayerUuid then
    DebugPrint("CheckOtherPlayerPersonallInfo Invalid arguments")
    return
  end
  
  local function cb(ret, PlayerInfo)
    self.logger.debug("CheckOtherPlayerPersonallInfo Callback", ret, PlayerUuid, PlayerInfo)
    if not ErrorCode:Check(ret) then
      return
    end
    PlayerInfo.Uuid = PlayerUuid
    MergePlayerInfoFromAvatarInfo(PlayerInfo, AvatarInfo, PlayerUuid)
    TryRequestOtherGuildSimpleInfo(self, PlayerInfo, PlayerUuid)
    PersonInfoController:HandleOpenOtherPlayerView(PlayerInfo, bForceUsedServerData)
    DebugPrint("yklua Had Received Server Open PersonInfo")
  end
  
  DebugPrint("yklua Had Call Open PersonInfo")
  self:CallServer("CheckOtherPlayerPersonallInfo", cb, PlayerUuid)
end

function Component:GetOtherPlayerPersonallInfo(PlayerUuid, CallbackInfo, AvatarInfo)
  if not PlayerUuid then
    DebugPrint("GetOtherPlayerPersonallInfo Invalid arguments")
    return
  end
  
  local function cb(ret, PlayerInfo)
    if not ErrorCode:Check(ret) then
      return
    end
    PlayerInfo.Uuid = PlayerUuid
    MergePlayerInfoFromAvatarInfo(PlayerInfo, AvatarInfo, PlayerUuid)
    CallbackInfo.Func(PlayerInfo)
  end
  
  self:CallServer("CheckOtherPlayerPersonallInfo", cb, PlayerUuid)
end

function Component:SetPersonalInfoVisible(VisibleType)
  self.logger.debug("SetPersonalInfoVisible", VisibleType)
  if not CommonUtils.HasValue(CommonConst.PersonalInfoVisibleType, VisibleType) then
    DebugPrint("SetPersonalInfoVisible Invalid arguments")
    return
  end
  self:CallServerMethod("SetPersonalInfoVisible", VisibleType)
end

return Component
