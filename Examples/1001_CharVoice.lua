require("UnLua")

-- 配置项开始
local CharId = 5301 -- 角色ID
local AvailableLanguages = {"CN", "EN", "JP", "KR"}
-- 配置项结束

-- 入参处理开始
local args = {}
for i = 1, select("#", ...) do
    args[i] = select(i, ...)
end

if #args > 0 then
    CharId = tonumber(args[1])
end
-- 入参处理结束

local TalkUtils = require("Utils.TalkUtils")

for _, TextLanguage in pairs(AvailableLanguages) do
    CommonConst.SystemLanguage = CommonConst.SystemLanguages[TextLanguage]

    local CharData = DataMgr.CharacterData[CharId]
    if not CharData then
        error("角色不存在")
    end
    print(string.format("%s: %s", CText("UI_Chardata_Char_Name"), CText(CharData.CharName)))
    print(string.format("%s: %s", CText("UI_Voice_Actor_" .. TextLanguage), CText(CharData["Cv" .. TextLanguage .. "Name"])))

    local CharVoiceDatas = DataMgr.CharVoice[CharId]

    local CharVoiceNormal = {}
    local CharVoiceBattle = {}

    for _, Data in pairs(CharVoiceDatas) do
        if Data.VoiceType == 1 then
            table.insert(CharVoiceNormal, Data)
        elseif Data.VoiceType == 2 then
            table.insert(CharVoiceBattle, Data)
        end
    end
    table.sort(CharVoiceNormal, function(a, b)
        return a.VoiceId < b.VoiceId
    end)
    table.sort(CharVoiceBattle, function(a, b)
        return a.VoiceId < b.VoiceId
    end)

    print(string.format("\n===== %s =====", CText("UI_CharVoice_Normal")))
    for _, Data in pairs(CharVoiceNormal) do
        local VoiceDes = ""
        if Data.VoiceDes then
            for _, v in ipairs(Data.VoiceDes) do
                VoiceDes = VoiceDes .. CText(v)
            end
        end
        local VoiceText = GText(Data.VoiceText and Data.VoiceText[1])
        print(string.format("[%d] %s", Data.VoiceId, VoiceDes))
        if Data.Dialogue then
            print(string.format("%s: %s", "狩月人", TalkUtils:DialogueIdToContent(Data.Dialogue)))
            print(string.format("%s: %s", CText(CharData.CharName), VoiceText))
        else
            print(VoiceText)
        end
        print("-----")
    end

    print(string.format("\n===== %s =====", CText("UI_CharVoice_Battle")))
    for _, Data in pairs(CharVoiceBattle) do
        local VoiceDes = ""
        if Data.VoiceDes then
            for _, v in ipairs(Data.VoiceDes) do
                VoiceDes = VoiceDes .. CText(v)
            end
        end
        local VoiceText = GText(Data.VoiceText and Data.VoiceText[1])
        print(string.format("[%d] %s", Data.VoiceId, VoiceDes))
        print(VoiceText)
        print("-----")
    end

    print("\n")
end
