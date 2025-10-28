local Utils = {}

local TextUtils = require("Utils.TextUtils")

Utils.GText = function(Text)
    return TextUtils:GetDisplayText(Text)
end
_G.GText = Utils.GText

Utils.CText = function(Text)
    return TextUtils:GetDisplayText(Text, CommonConst.SystemLanguages.CN)
end
_G.CText = Utils.CText

return Utils
