local rawset = rawset
local require = require

_G.DataMgr = require("DataMgr")
_G.CommonConst = require("CommonConst")

_G.CommonUtils = require("Utils.CommonUtils")

local Utils = require("Utils")
for k, v in pairs(Utils) do
    rawset(_G, k, v)
end
