local GlobalFunction = {}

function GlobalFunction.IsSkynetServer(...)
  return GWorld and GWorld:IsSkynetServer()
end

if GlobalFunction.IsSkynetServer() then
  GlobalFunction.print = skynet.error
else
  GlobalFunction.print = print
end
GlobalFunction.SoftAssert = GlobalFunction.print
GlobalFunction.require = require
GlobalFunction.ipairs = ipairs
GlobalFunction.pairs = pairs
GlobalFunction.pcall = pcall
GlobalFunction.tostring = tostring
GlobalFunction.getmetatable = getmetatable
GlobalFunction.setmetatable = setmetatable
GlobalFunction.type = type
GlobalFunction.rawset = rawset
GlobalFunction.rawget = rawget
GlobalFunction.string = string
GlobalFunction.table = table
GlobalFunction.math = math
GlobalFunction.os = os
GlobalFunction.assert = assert
GlobalFunction.debug = debug
GlobalFunction.next = next
GlobalFunction.tonumber = tonumber
GlobalFunction.package = package
GlobalFunction.CommonUtils = CommonUtils
GlobalFunction.DataMgr = DataMgr
GlobalFunction.EventID = EventID
GlobalFunction.EventManager = EventManager
GlobalFunction.GWorld = GWorld
GlobalFunction.ErrorCode = ErrorCode
GlobalFunction.ConditionUtils = ConditionUtils
GlobalFunction.UE4 = UE4
GlobalFunction.CommonConst = CommonConst
setmetatable(GlobalFunction, {
  __newindex = function(t, k, v)
    GlobalFunction.print("不允许在关卡服务器代码里设置全局变量: " .. tostring(k) .. " = " .. tostring(v))
  end
})
return GlobalFunction
