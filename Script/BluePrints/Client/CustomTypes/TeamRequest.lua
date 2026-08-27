local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local CommonConst = require("CommonConst")
local TeamRequest = Class("TeamRequest", CustomTypes.CustomAttr)
TeamRequest.__Props__ = {
  Uid = prop.prop("Int", "client"),
  HeadIconId = prop.prop("Int", "client"),
  HeadFrameId = prop.prop("Int", "client"),
  Level = prop.prop("Int", "client"),
  Nickname = prop.prop("Str", "client")
}

function TeamRequest:Init(JoinInfo)
  self.Uid = JoinInfo.Uid
  self.HeadIconId = JoinInfo.HeadIconId
  self.HeadFrameId = JoinInfo.HeadFrameId
  self.Level = JoinInfo.Level
  self.Nickname = JoinInfo.Nickname
end

FormatProperties(TeamRequest)
local TeamRequestList = Class("TeamRequestList", CustomTypes.CustomList)
TeamRequestList.ValueType = TeamRequest

function TeamRequestList:AddNewRequest(JoinInfo)
  self:Append(TeamRequest(JoinInfo))
end

function TeamRequestList:IsAlreadyInList(Uid)
  for i = 1, self:Length() do
    local Request = self:Get(i)
    if Request.Uid == Uid then
      return true
    end
  end
  return false
end

return {TeamRequest = TeamRequest, TeamRequestList = TeamRequestList}
