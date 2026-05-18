local GuildDatas = require("BluePrints.UI.WBP.Guild.Common.GuildDatas")
local GuildListInfo = GuildDatas.GuildListInfo
local Component = {}

function Component:OnInit()
  self.GuildList = {}
  self.GuildSearchRes = {}
  self.SortedGuildList = {}
  self.FriendGuildList = {}
end

function Component:OnDestory()
end

function Component:SetGuildSearchRes(ServerGuildList)
  self.GuildSearchRes = {}
  for _, ServerGuild in pairs(ServerGuildList) do
    local ListInfo = GuildListInfo.New(ServerGuild)
    table.insert(self.GuildSearchRes, ListInfo)
  end
  table.sort(self.GuildSearchRes, function(Info1, Info2)
    return Info1.Score > Info2.Score
  end)
end

function Component:SetGuildList(ServerGuildList)
  self.GuildList = {}
  for _, ServerGuild in pairs(ServerGuildList) do
    local ListInfo = GuildListInfo.New(ServerGuild)
    table.insert(self.GuildList, ListInfo)
  end
  table.sort(self.GuildList, function(Info1, Info2)
    return Info1.Score > Info2.Score
  end)
end

function Component:CacheGuildIdList(GuildList, FriendGuildList)
  self.SortedGuildList = GuildList
  self.FriendGuildList = FriendGuildList
end

function Component:PickGuildIdFromList()
  local PickedGuildList = {}
  if not self.MinSortListLen then
    self.MinSortListLen = 0
    self.MaxRuleId = 0
    for Id, Rule in pairs(DataMgr.GuildListRule) do
      if 1 ~= Id then
        self.MinSortListLen = self.MinSortListLen + Rule.PickNum
      end
      self.MaxRuleId = math.max(self.MaxRuleId, Id)
    end
  end
  if #self.SortedGuildList <= self.MinSortListLen then
    local Tmp = CommonUtils.DeepCopy(self.FriendGuildList)
    CommonUtils.Shuffle(Tmp)
    for i = 1, DataMgr.GuildListRule[1].PickNum do
      if i <= #Tmp then
        table.insert(PickedGuildList, Tmp[i].GuildId)
      end
    end
    for _, Info in ipairs(self.SortedGuildList) do
      table.insert(PickedGuildList, Info.GuildId)
    end
    return PickedGuildList
  end
  for Id, Rule in pairs(DataMgr.GuildListRule) do
    local Tmp = {}
    if 1 == Id then
      Tmp = CommonUtils.DeepCopy(self.FriendGuildList)
    else
      local Range1 = math.floor(Rule.PecentRange[1] * 0.01 * #self.SortedGuildList)
      local Range2 = math.floor(Rule.PecentRange[2] * 0.01 * #self.SortedGuildList)
      Range1 = math.max(1, Range1)
      Range2 = math.max(Range1, Range2)
      if Id == self.MaxRuleId then
        Range2 = math.max(Range2, self.MinSortListLen)
      end
      Tmp = table.slice(self.SortedGuildList, Range1, Range2)
    end
    if table.isempty(Tmp) then
    else
      CommonUtils.Shuffle(Tmp)
      for i = 1, Rule.PickNum do
        if i <= #Tmp then
          table.insert(PickedGuildList, Tmp[i].GuildId)
        end
      end
    end
  end
  return PickedGuildList
end

function Component:GetGuildList()
  return self.GuildList
end

function Component:GetGuildSearchRes()
  return self.GuildSearchRes
end

return Component
