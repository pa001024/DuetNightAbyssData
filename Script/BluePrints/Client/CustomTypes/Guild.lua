local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local GuildMember = Class("GuildMember", CustomTypes.CustomAttr)
GuildMember.__Props__ = {
  Uid = prop.prop("Int", "client save", 0),
  Title = prop.prop("Int", "client save", 1),
  LastLogin = prop.prop("Int", "client save", 0),
  WeekActivity = prop.prop("Int", "client save", 0),
  JoinTime = prop.prop("Int", "client save", 0)
}
FormatProperties(GuildMember)
local GuildMemberDict = Class("GuildMemberDict", CustomTypes.CustomDict)
GuildMemberDict.KeyType = BaseTypes.Int
GuildMemberDict.ValueType = GuildMember
local GuildMessage = Class("GuildMessage", CustomTypes.CustomAttr)
GuildMessage.__Props__ = {
  Time = prop.prop("Int", "client save", 0),
  Type = prop.prop("Str", "client save", ""),
  FormatText = prop.prop("Str2StrDict", "client save", {})
}
FormatProperties(GuildMessage)
local GuildMessageList = Class("GuildMessageList", CustomTypes.CustomList)
GuildMessageList.ValueType = GuildMessage
local GuildAttr = {
  _id = prop.prop("ObjId", "client save"),
  GuildId = prop.prop("Int", "client save"),
  OwnerUid = prop.prop("Int", "client save"),
  Name = prop.prop("Str", "client save"),
  Declaration = prop.prop("Str", "client save"),
  Logo = prop.prop("Str", "client save"),
  CreateTime = prop.prop("Int", "client save", 0),
  LastNameEditTime = prop.prop("Int", "client save", 0),
  LastLogoEditTime = prop.prop("Int", "client save", 0),
  AutoAgreeJoinRequest = prop.prop("Bool", "client save", false),
  JoinRequestUids = prop.prop("Int2IntDict", "client save", {}),
  Members = prop.prop("GuildMemberDict", "client save", {}),
  MemberCount = prop.prop("Int", "client save", 0),
  ActivityLevelLastDay = prop.prop("Int", "client save", 0),
  ActivityLevels = prop.prop("IntList", "client save", {}),
  ActivityLevel = prop.prop("Int", "client", 0),
  Exp = prop.prop("Int", "client save", 0),
  Level = prop.prop("Int", "client save", 1),
  DissolveApplyTime = prop.prop("Int", "client save", 0),
  ClosedPermission = prop.prop("Int2StrSetDict", "client save", {}),
  GuildMessages = prop.prop("GuildMessageList", "client save", {}),
  GuildBossData = prop.prop("GuildBoss.GuildBossData", "client save"),
  GuildHomeData = prop.prop("GuildHome.GuildHomeData", "client save")
}
local GuildInfo = Class("GuildInfo", CustomTypes.CustomAttr)
GuildInfo.__Props__ = GuildAttr
FormatProperties(GuildInfo)
local GuildAttrMergeMaxCount = 100

function GuildAttr.Merge(Target, Source, PropNames)
  Target = type(Target) == "table" and Target or {}
  if type(Source) ~= "table" or type(PropNames) ~= "table" then
    return Target
  end
  local Merged = {}
  local Count = 0
  for _, PropName in ipairs(PropNames) do
    Count = Count + 1
    if Count > GuildAttrMergeMaxCount then
      break
    end
    if type(PropName) == "string" and not Merged[PropName] then
      local AttrProp = GuildAttr[PropName]
      if AttrProp and AttrProp.is_prop then
        Merged[PropName] = true
        local Value = Source[PropName]
        if nil == Value and "table" == type(Source.Props) then
          Value = Source.Props[PropName]
        end
        local DumpValue = AttrProp:GetBinaryDump(Value)
        if nil ~= DumpValue then
          Target[PropName] = DumpValue
        end
      end
    end
  end
  return Target
end

function GuildAttr.InitFromData(docs)
  local Inst = {}
  for name, value in pairs(docs or {}) do
    local AttrProp = GuildAttr[name]
    if AttrProp and AttrProp.is_prop then
      local object
      local ok, ret = pcall(function()
        object = AttrProp:GetTypeInstance(value)
      end)
      if not ok then
        return false, nil, name, tostring(ret)
      end
      Inst[name] = object
    end
  end
  return true, Inst
end

return {
  GuildMember = GuildMember,
  GuildMemberDict = GuildMemberDict,
  GuildMessage = GuildMessage,
  GuildMessageList = GuildMessageList,
  GuildInfo = GuildInfo,
  GuildAttr = GuildAttr
}
