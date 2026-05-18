local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
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

AssembleComponents(M)
return M
