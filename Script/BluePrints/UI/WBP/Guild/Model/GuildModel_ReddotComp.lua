local Component = {}
local GuildPermissionUtils = require("BluePrints.UI.WBP.Guild.Common.GuildPermissionUtils")
local GUILD_EDIT_SIGN_REDDOT = "GuildEditSign"
local GUILD_EDIT_SIGN_PERMISSION = "ModifyNameEmblem"

local function EnsureGuildEditSignNode()
  if not ReddotManager.GetTreeNode(GUILD_EDIT_SIGN_REDDOT) then
    ReddotManager.AddNode("GuildHub")
  end
end

local function MarkGuildEditSignCreated()
  EnsureGuildEditSignNode()
  local Node = ReddotManager.GetTreeNode(GUILD_EDIT_SIGN_REDDOT)
  if not Node or not Node.Cache then
    return
  end
  if not Node.Cache.Detail then
    Node.Cache.Detail = {}
  end
  if Node.Cache.Detail.HasCreated == nil then
    Node.Cache.Detail.HasCreated = true
  end
end

local function IsNewRegisteredAvatar()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local LastLogoutTime = Avatar.LastLogoutTime or 0
  return LastLogoutTime <= 0
end

function Component:OnInit()
  ReddotManager.AddNode("GuildHub")
  self:InitGuildEditSignReddot()
end

function Component:InitGuildEditSignReddot()
  EnsureGuildEditSignNode()
  if not self:IsInGuild() then
    if IsNewRegisteredAvatar() then
      MarkGuildEditSignCreated()
      ReddotManager.ClearLeafNodeCount(GUILD_EDIT_SIGN_REDDOT, false)
    end
    return
  end
  local CurrGuild = self:GetCurrGuild()
  local Avatar = GWorld:GetAvatar()
  if not CurrGuild or not Avatar then
    return
  end
  local MemberInfo = self:GetCurrMember(Avatar.Uid)
  if not MemberInfo then
    local SelfUid = tonumber(Avatar.Uid)
    for _, Member in ipairs(CurrGuild.Members or {}) do
      if tonumber(Member.Uid) == SelfUid then
        MemberInfo = Member
        break
      end
    end
  end
  if not MemberInfo then
    return
  end
  if not GuildPermissionUtils.GetEffectivePermission(CurrGuild.ClosedPermission, MemberInfo.Title, GUILD_EDIT_SIGN_PERMISSION) then
    ReddotManager.ClearLeafNodeCount(GUILD_EDIT_SIGN_REDDOT, false)
    return
  end
  if IsNewRegisteredAvatar() then
    MarkGuildEditSignCreated()
    ReddotManager.ClearLeafNodeCount(GUILD_EDIT_SIGN_REDDOT, false)
    return
  end
  local Detail = ReddotManager.GetLeafNodeCacheDetail(GUILD_EDIT_SIGN_REDDOT)
  if Detail and Detail.HasCreated == nil then
    Detail.HasCreated = true
    ReddotManager.ClearLeafNodeCount(GUILD_EDIT_SIGN_REDDOT)
    ReddotManager.IncreaseLeafNodeCount(GUILD_EDIT_SIGN_REDDOT)
  end
end

function Component:OnDestory()
end

function Component:TryAddReddotCount(NodeName, ExParam)
  if not self:IsInGuild() then
    return
  end
  ReddotManager.IncreaseLeafNodeCount(NodeName, 1, ExParam)
end

function Component:TrySubReddotCount(NodeName, ExParam)
  if not self:IsInGuild() then
    return
  end
  ReddotManager.DecreaseLeafNodeCount(NodeName, 1, ExParam)
end

function Component:TryClearReddotCount(NodeName, bClearCache, ExParam)
  ReddotManager.ClearNodeCount(NodeName, bClearCache)
end

function Component:ClearAllReddot()
  ReddotManager.ClearNodeCount("GuildHub", true)
end

function Component:InvokeGuildTaskReddotUpdate()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  if Avatar.GuildActivityLevel >= GuildCommon.MaxActivityPoint then
    self:TryClearReddotCount("GuildDailyTask")
    self:TryClearReddotCount("GuildWeekTask")
    return
  end
  local bAllDailyNotComplete = true
  local bAllWeeklyNotComplete = true
  for QuestId, Quest in pairs(Avatar.CommonQuestActivity[GuildCommon.GuildDummyEventId]) do
    local QuestConf = DataMgr.CommonQuestDetail[QuestId]
    if not QuestConf then
    elseif QuestConf.QuestType == CommonConst.CommonQuestType.Daily then
      self:TryAddReddotCount("GuildDailyTask", {QuestId = QuestId})
      self:TrySubReddotCount("GuildDailyTask", {QuestId = QuestId})
      if Quest:IsComplete() then
        bAllDailyNotComplete = false
      end
    elseif QuestConf.QuestType == CommonConst.CommonQuestType.Weekly then
      self:TryAddReddotCount("GuildWeekTask", {QuestId = QuestId})
      self:TrySubReddotCount("GuildWeekTask", {QuestId = QuestId})
      if Quest:IsComplete() then
        bAllWeeklyNotComplete = false
      end
    end
  end
  if bAllDailyNotComplete then
    self:TryClearReddotCount("GuildDailyTask")
  end
  if bAllWeeklyNotComplete then
    self:TryClearReddotCount("GuildWeekTask")
  end
end

return Component
