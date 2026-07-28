local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local GuildDatas = require("BluePrints.UI.WBP.Guild.Common.GuildDatas")
local GuildTypes = require("BluePrints.Client.CustomTypes.Guild")
local M = Class("BluePrints.Common.MVC.Model")
M._components = {
  "BluePrints.UI.WBP.Guild.Model.GuildModel_VisitorOpComp",
  "BluePrints.UI.WBP.Guild.Model.GuildModel_ManagerOpComp",
  "BluePrints.UI.WBP.Guild.Model.GuildModel_ChatComp",
  "BluePrints.UI.WBP.Guild.Model.GuildModel_ReddotComp"
}

function M:OnInit()
end

function M:OnDestory()
end

function M:Init()
  M.Super.Init(self)
  self.CurrGuild = nil
  self.Context = {}
  self.GuildMemberInfoQueryTimes = {}
  self.GuildMemberInfoPendingCallbacks = {}
  self:OnInit()
end

function M:Destory()
  self:OnDestory()
  M.Super.Destory(self)
end

function M:GetCurrGuild()
  return self.CurrGuild
end

function M:SetCurrGuild(CurrGuild)
  if self.CurrGuild == nil and CurrGuild then
    self:InvokeGuildTaskReddotUpdate()
  end
  self.CurrGuild = CurrGuild
  if nil == CurrGuild then
    self:ClearAllReddot()
  end
  self:InvokeGuildBossRewardReddotUpdate()
end

function M:ParseGuildLogo(ServerLogoInfo)
  return GuildLogoInfo.New(ServerLogoInfo)
end

function M:UpdateCurrGuildProp(Ret, PropName, NewValueOrCb)
  if not self.CurrGuild then
    return false
  end
  if Ret == ErrorCode.RET_SUCCESS then
    if type(NewValueOrCb) == "function" then
      local Cb = NewValueOrCb
      local Val = Cb()
      rawset(self.CurrGuild, PropName, Val)
    else
      local NewValue = NewValueOrCb
      rawset(self.CurrGuild, PropName, NewValue)
    end
    return true
  end
  return false
end

function M:IsInGuild()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  return Avatar.GuildId ~= nil and 0 ~= Avatar.GuildId
end

function M:IsInCurrGuild(Uid)
  if not self:IsInGuild() then
    return false
  end
  local CurrGuild = self:GetCurrGuild()
  if not CurrGuild or not CurrGuild.IsMember then
    return false
  end
  return CurrGuild:IsMember(Uid)
end

function M:GetCurrMember(Uid)
  local CurrGuild = self:GetCurrGuild()
  if not CurrGuild or not CurrGuild.GetMemberByUid then
    return nil
  end
  return CurrGuild:GetMemberByUid(Uid)
end

function M:QueryGuildMemberInfo(Callback, Uids, bCallbackOnly)
  local Avatar = self:GetAvatar()
  if not Avatar or not Avatar.QueryGuildMemberInfo then
    return false, false
  end
  local QueryUids = {}
  for _, Uid in ipairs(Uids or {}) do
    table.insert(QueryUids, Uid)
  end
  table.sort(QueryUids, function(A, B)
    return tostring(A) < tostring(B)
  end)
  local QueryKeyParts = {}
  for _, Uid in ipairs(QueryUids) do
    table.insert(QueryKeyParts, tostring(Uid))
  end
  local QueryKey = table.concat(QueryKeyParts, ",") .. (bCallbackOnly and ":1" or ":0")
  local PendingCallbacks = self.GuildMemberInfoPendingCallbacks[QueryKey]
  if PendingCallbacks then
    if Callback then
      table.insert(PendingCallbacks, Callback)
    end
    return false, true
  end
  local Now = os.time()
  local LastQueryTime = self.GuildMemberInfoQueryTimes[QueryKey]
  if LastQueryTime and Now - LastQueryTime < 2 then
    return false, false
  end
  self.GuildMemberInfoQueryTimes[QueryKey] = Now
  self.GuildMemberInfoPendingCallbacks[QueryKey] = Callback and {Callback} or {}
  Avatar:QueryGuildMemberInfo(function(...)
    local Callbacks = self.GuildMemberInfoPendingCallbacks[QueryKey]
    self.GuildMemberInfoPendingCallbacks[QueryKey] = nil
    for _, PendingCallback in ipairs(Callbacks or {}) do
      PendingCallback(...)
    end
  end, QueryUids, bCallbackOnly)
  return true, true
end

function M:GetGuildQuests()
  return self:GetAvatar().CommonQuestActivity[GuildCommon.GuildDummyEventId]
end

function M:GetGuildActivityRewardLevel()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return 0
  end
  return Avatar.GuildActivityLevelRewardLevel or 0
end

function M:GetGuildActivityLevel()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return 0
  end
  return Avatar.GuildActivityLevel or 0
end

function M:GetGuildActivityRewardRecord()
  return self:GetAvatar().GuildActivityLevelRewardRecord or {}
end

function M:GetAvatarGuildBossData()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return nil
  end
  return GuildDatas.AvatarGuildBossInfo.New(Avatar.GuildBossData)
end

function M:GetGuildBossData()
  local Avatar = self:GetAvatar()
  if not Avatar or not Avatar.GuildInfo then
    return nil
  end
  return GuildDatas.GuildBossInfo.New(Avatar.GuildInfo.GuildBossData)
end

function M:ResolveGuildBossDisplayGuildId(ExplicitGuildId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return 0
  end
  local Explicit = tonumber(ExplicitGuildId)
  if Explicit and Explicit > 0 then
    return Explicit
  end
  local RegionGuildId = self:GetCurrentGuildRegionTargetGuildId()
  if RegionGuildId and RegionGuildId > 0 then
    return RegionGuildId
  end
  return tonumber(Avatar.GuildId) or 0
end

function M:GetGuildBossDataByGuildId(GuildId, Callback)
  local Avatar = self:GetAvatar()
  if not Avatar then
    if Callback then
      Callback(nil)
    end
    return
  end
  GuildId = tonumber(GuildId) or 0
  if GuildId <= 0 then
    GuildId = self:ResolveGuildBossDisplayGuildId(0)
  end
  local SelfGuildId = tonumber(Avatar.GuildId) or 0
  if GuildId <= 0 then
    if Callback then
      Callback(nil)
    end
    return
  end
  if GuildId == SelfGuildId then
    if Callback then
      Callback(self:GetGuildBossData(), Avatar.GuildInfo)
    end
    return
  end
  if not Avatar.QueryGuildAttrs then
    if Callback then
      Callback(nil)
    end
    return
  end
  Avatar:QueryGuildAttrs(function(ErrCode, Attrs)
    local GuildBossData, GuildInfo
    if ErrCode == ErrorCode.RET_SUCCESS and type(Attrs) == "table" then
      local Ok, TypedGuildInfo, FailedPropName, InitErr = GuildTypes.GuildAttr.InitFromData(Attrs)
      if Ok then
        GuildInfo = TypedGuildInfo
        GuildBossData = GuildDatas.GuildBossInfo.New(TypedGuildInfo.GuildBossData)
      else
        DebugPrint("GetGuildBossDataByGuildId InitFromData failed", FailedPropName, InitErr)
      end
    end
    if Callback then
      Callback(GuildBossData, GuildInfo)
    end
  end, GuildId, {
    "GuildBossData",
    "ActivityLevelLastDay",
    "ActivityLevels",
    "CreateTime",
    "GuildId",
    "Name",
    "Logo"
  })
end

function M:GetCurrentGuildRegionTargetGuildId()
  local Avatar = self:GetAvatar()
  if not Avatar or not Avatar.IsInRegionOnline then
    return nil
  end
  local CurrentGuildId = tonumber(Avatar.CurrentGuildId)
  if CurrentGuildId and CurrentGuildId > 0 then
    return CurrentGuildId
  end
  local GuildOnlineAreaID = DataMgr.GlobalConstant.GuildOnlineAreaID and tonumber(DataMgr.GlobalConstant.GuildOnlineAreaID.ConstantValue)
  local CurrentOnlineType = tonumber(Avatar.CurrentOnlineType)
  if not GuildOnlineAreaID or not CurrentOnlineType then
    return nil
  end
  local Prefix = tostring(GuildOnlineAreaID)
  local OnlineTypeText = tostring(CurrentOnlineType)
  if string.sub(OnlineTypeText, 1, string.len(Prefix)) ~= Prefix then
    return nil
  end
  return tonumber(string.sub(OnlineTypeText, string.len(Prefix) + 1))
end

function M:IsGuildBossAssistPlayer(TargetGuildId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return false, nil
  end
  local SelfGuildId = tonumber(Avatar.GuildId) or 0
  if SelfGuildId < 0 then
    return false, nil
  end
  local Target = tonumber(TargetGuildId)
  if not Target or Target <= 0 then
    Target = self:ResolveGuildBossDisplayGuildId(nil)
  end
  if not Target or Target <= 0 then
    return false, nil
  end
  return Target ~= SelfGuildId, Target
end

function M:CanQuestReceive(QuestId)
  local QuestTable = self:GetGuildQuests()
  if not QuestTable then
    return
  end
  local Quest = QuestTable[QuestId]
  if Quest and Quest:CanRecvReward() then
    return true
  end
  return
end

function M:SetGuildEditLogoInfo(Info)
  self.Context.GuildEditLogoInfo = Info or GuildLogoInfo.Default()
end

function M:GetGuildEditLogoInfo()
  return self.Context.GuildEditLogoInfo
end

function M:RequestEnterGuildOnline(GuildId, StartPointIndex)
  local Avatar = GWorld:GetAvatar()
  if Avatar.CurrentGuildId == GuildId and not StartPointIndex then
    local SceneId = WorldTravelSubsystem():GetCurrentSceneId()
    if 3001 == SceneId then
      UIManager(self):ShowUITip("CommonToastMain", GText("GuildAlreadyInside"), 1.5)
      return
    end
  end
  Avatar:RequestEnterGuildOnline(GuildId, nil, nil, StartPointIndex)
end

AssembleComponents(M)
return M
