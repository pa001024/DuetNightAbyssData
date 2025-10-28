---@param TextMapId string
---@param Language string
---@return string
local function Localize(TextMapId, Language)
    Language = Language or CommonConst.SystemLanguage or CommonConst.SystemLanguages.Default

    if TextMapId == nil then
        return nil
    end
    if Language == nil then
        return nil
    end

    local TextMap = DataMgr["TextMap_" .. Language]
    local TextMapData = TextMap[TextMapId]
    if TextMapData == nil then
        return TextMapId
    end

    local LocalizedText = TextMapData[Language]
    if LocalizedText == nil then
        return TextMapId
    end

    return LocalizedText
end

--- 主角性别
---@param Wildcard string
---@return string
local function ReplaceProtagonistGender(Wildcard)
    local M, F = string.match(Wildcard, "{.-[：:]+(.-)|(.-)}")
    return F
end

--- 前主角性别
---@param Wildcard string
---@return string
local function ReplaceFormerProtagonistGender(Wildcard)
    local M, F = string.match(Wildcard, "{.-[：:]+(.-)|(.-)}")
    return M
end

--- 夜航主角名
---@param Wildcard string
---@return string
local function ReplaceNickName(Wildcard)
    return GText("PlayerDefaultName")
end

--- 泊暮主角名
---@param Wildcard string
---@return string
local function ReplaceNickName2(Wildcard)
    return GText("ExPlayerDefaultName")
end

local M = {}

M.WildcardReplaceFunctionMap = {
    ["{性别[:：]+.-|.-}"] = ReplaceProtagonistGender,
    ["{性别2[:：]+.-|.-}"] = ReplaceFormerProtagonistGender,
    ["{[Nn]ick[Nn]ame}"] = ReplaceNickName,
    ["{[Nn]ick[Nn]ame2}"] = ReplaceNickName2
}

---@param TextMapId string
---@param Language string
---@return string
function M:GetDisplayText(TextMapId, Language)
    local DisplayText = Localize(TextMapId, Language)
    DisplayText = self:ReplaceWildcard(TextMapId, DisplayText)
    return DisplayText
end

---@param TextMapId string
---@param Text string
---@return string
function M:ReplaceWildcard(TextMapId, Text)
    if TextMapId == nil then
        return Text
    end

    local TextMapData = DataMgr.TextMapWildcard[TextMapId]
    if TextMapData == nil then
        return Text
    end

    local ReplacedText = Text
    if TextMapData.WildcardClassification == "Story" then
        local Temp, _ = string.gsub(Text, "{.-}", function(Wildcard)
            for WildcardTypeRegex, Function in pairs(self.WildcardReplaceFunctionMap) do
                if string.match(Wildcard, WildcardTypeRegex) then
                    return Function(Wildcard)
                end
            end
            return Wildcard
        end)
        ReplacedText = Temp
    end

    return ReplacedText
end

return M
