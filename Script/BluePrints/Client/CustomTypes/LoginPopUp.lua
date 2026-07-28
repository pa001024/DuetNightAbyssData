local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local LoginPopUpRecord = Class("LoginPopUpRecord", CustomTypes.CustomAttr)
LoginPopUpRecord.__Props__ = {
  PopId = prop.prop("Int", "client save", 0),
  PopTimes = prop.prop("IntList", "client save", {})
}

function LoginPopUpRecord:Init(PopId)
  self.PopId = PopId or 0
end

function LoginPopUpRecord:AppendPopTime(PopTime)
  if not self.PopTimes then
    self.PopTimes = {}
  end
  self.PopTimes:Append(PopTime)
end

FormatProperties(LoginPopUpRecord)
local LoginPopUpRecordDict = Class("LoginPopUpRecordDict", CustomTypes.CustomDict)
LoginPopUpRecordDict.KeyType = BaseTypes.Int
LoginPopUpRecordDict.ValueType = LoginPopUpRecord

function LoginPopUpRecordDict:NewLoginPopUpRecord(PopId)
  if nil == self[PopId] then
    self[PopId] = LoginPopUpRecord(PopId)
  end
  return self[PopId]
end

return {LoginPopUpRecord = LoginPopUpRecord, LoginPopUpRecordDict = LoginPopUpRecordDict}
