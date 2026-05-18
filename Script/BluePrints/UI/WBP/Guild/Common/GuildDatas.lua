local GuildBaseInfo = require("BluePrints.UI.WBP.Guild.Common.GuildBaseInfo")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local GuildMemberInfo = Class()
GuildMemberInfo.Uid = 0
GuildMemberInfo.Title = 1
GuildMemberInfo.LastLogin = 0
GuildMemberInfo.WeekActivity = 0
GuildMemberInfo.HeadIconId = 10001

function GuildMemberInfo.New(ServerInfo)
  if not ServerInfo then
    return nil
  end
  local NewObj = {}
  setmetatable(NewObj, GuildMemberInfo)
  CommonUtils.MergeTables(NewObj, ServerInfo)
  return NewObj
end

function GuildMemberInfo:Merge(ExServerInfo)
  if ExServerInfo.Uid ~= self.Uid then
    return
  end
  CommonUtils.MergeTables(self, ExServerInfo)
end

local GuildMessage = Class()
GuildMessage.Time = 0
GuildMessage.Type = ""

function GuildMessage:GetConfig()
  return DataMgr.GuildMessage and DataMgr.GuildMessage[self.Type]
end

function GuildMessage:IsSendToGuildChat()
  local Config = self:GetConfig()
  return Config and (Config.IsSendToGuildChat == true or 1 == Config.IsSendToGuildChat)
end

function GuildMessage:GetDisplayText()
  local Config = self:GetConfig()
  local Result = ""
  if Config and Config.Content then
    Result = GText(Config.Content)
    for Key, Value in pairs(self.FormatText or {}) do
      Result = string.gsub(Result, "{" .. tostring(Key) .. "}", tostring(Value))
    end
  end
  if "" ~= Result then
    return Result
  end
  local Parts = {}
  for _, Value in pairs(self.FormatText or {}) do
    Parts[#Parts + 1] = tostring(Value)
  end
  return table.concat(Parts, " ")
end

function GuildMessage.New(ServerInfo)
  if not ServerInfo then
    return nil
  end
  local NewObj = {}
  setmetatable(NewObj, GuildMessage)
  CommonUtils.MergeTables(NewObj, ServerInfo)
  return NewObj
end

local GuildListInfo = Class("BluePrints.UI.WBP.Guild.Common.GuildBaseInfo")
GuildListInfo.OwnerUid = 0
GuildListInfo.CreateTime = 0
GuildListInfo.Score = 0
GuildListInfo.Declaration = ""
GuildListInfo.AuditStatus = 0
GuildListInfo.MemberLimit = 0
GuildListInfo.MemberCount = 0

function GuildListInfo.New(ServerInfo)
  if not ServerInfo then
    return nil
  end
  local NewObj = GuildBaseInfo.New(ServerInfo)
  setmetatable(NewObj, GuildListInfo)
  return NewObj
end

local GuildFullInfo = Class("BluePrints.UI.WBP.Guild.Common.GuildBaseInfo")
GuildFullInfo.OwnerUid = 0
GuildFullInfo.Declaration = ""
GuildFullInfo.CreateTime = 0
GuildFullInfo.AuditStatus = 0
GuildFullInfo.AutoAgreeJoinRequest = false
GuildFullInfo.Exp = 0
GuildFullInfo.LastNameEditTime = 0
GuildFullInfo.DissolveApplyTime = 0
GuildFullInfo.Level = 0

function GuildFullInfo.New(ServerInfo)
  if not ServerInfo then
    return nil
  end
  local NewObj = GuildBaseInfo.New(ServerInfo)
  setmetatable(NewObj, GuildFullInfo)
  NewObj.Members = {}
  for i, MemberInfo in pairs(ServerInfo.Members or {}) do
    NewObj:AddMember(MemberInfo)
  end
  NewObj.GuildMessages = {}
  for i, MsgInfo in pairs(ServerInfo.GuildMessages or {}) do
    NewObj:AddDynMessage(MsgInfo)
  end
  return NewObj
end

function GuildFullInfo:AddMember(MemberServerInfo)
  local NewMember = GuildMemberInfo.New(MemberServerInfo)
  table.insert(self.Members, NewMember)
end

function GuildFullInfo:GetMemberByUid(Uid)
  if not Uid or not self.Members then
    return nil
  end
  for _, Member in ipairs(self.Members) do
    if Member.Uid == Uid then
      return Member
    end
  end
  return nil
end

function GuildFullInfo:IsMember(Uid)
  return self:GetMemberByUid(Uid) ~= nil
end

function GuildFullInfo:AddDynMessage(MsgInfo)
  local Msg = GuildMessage.New(MsgInfo)
  table.insert(self.GuildMessages, Msg)
end

local GuildRequestInfo = Class()
GuildRequestInfo.Uid = 0
GuildRequestInfo.ApplyTime = 0

function GuildRequestInfo.New(ServerInfo)
  if not ServerInfo then
    return nil
  end
  local NewObj = {}
  setmetatable(NewObj, GuildRequestInfo)
  CommonUtils.MergeTables(NewObj, ServerInfo)
  return NewObj
end

local GuildReqLookupTable = Class()

function GuildReqLookupTable.New(OrderedReqList)
  if not OrderedReqList then
    return nil
  end
  local NewObj = {}
  setmetatable(NewObj, GuildReqLookupTable)
  NewObj.OrderedReqList = {}
  for i, ReqInfo in ipairs(OrderedReqList or {}) do
    local Req = GuildRequestInfo.New(ReqInfo)
    table.insert(NewObj.OrderedReqList, Req)
  end
  NewObj:Sort()
  return NewObj
end

function GuildReqLookupTable:GetReqByUid(Uid)
  if not Uid then
    return
  end
  return self.OrderedReqList[self.ReqTable[Uid]]
end

function GuildReqLookupTable:Sort()
  table.sort(self.OrderedReqList, function(Req1, Req2)
    return Req1.ApplyTime > Req2.ApplyTime
  end)
  self.ReqTable = {}
  for i, ReqInfo in ipairs(self.OrderedReqList) do
    self.ReqTable[ReqInfo.Uid] = i
  end
end

function GuildReqLookupTable:AddNewReq(Req)
  table.insert(self.OrderedReqList, Req)
  self:Sort()
end

function GuildReqLookupTable:RemoveReq(Req)
  if not Req then
    return
  end
  local Index = self.ReqTable[Req.Uid]
  table.remove(self.OrderedReqList, Index)
  self:Sort()
end

function GuildReqLookupTable:RemoveReqByUid(Uid)
  local Req = self:GetReqByUid(Uid)
  self:RemoveReq(Req)
end

function GuildReqLookupTable:GetOrderList()
  return self.OrderedReqList
end

return {
  GuildMemberInfo = GuildMemberInfo,
  GuildFullInfo = GuildFullInfo,
  GuildListInfo = GuildListInfo,
  GuildRequestInfo = GuildRequestInfo,
  GuildReqLookupTable = GuildReqLookupTable
}
