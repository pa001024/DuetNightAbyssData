require("UnLua")

local TalkUtils = require("Utils.TalkUtils")

local function GetSortedKeys(Table)
    local SortedKeys = {}
    for Key, _ in pairs(Table) do
        table.insert(SortedKeys, Key)
    end
    table.sort(SortedKeys)
    return SortedKeys
end

local function ImpressionPlusIdToText(ImprPlusId)
    local PlusInfo = TalkUtils:GetImpressionPlusInfo(ImprPlusId)
    if PlusInfo then
        if PlusInfo.PlusType ~= nil then
            return string.format("%s %s %s", GText(DataMgr.Region[PlusInfo.ImpressionAreaId].RegionName), GText(DataMgr.ImpressionConfig[PlusInfo.PlusType].StatusName), PlusInfo.PlusValue)
        else
            return "N/A"
        end
    end
end

local Dialogue = DataMgr.Dialogue

local ImprData = {
    -- 支线任务: 尾生抱柱
    [51140008] = {51140009, 51140010},
    [51140037] = {51140038, 51140039},
    [51140064] = {51140065, 51140066, 51140067, 51140068}
}
local Option2ImprData = {}

for _, Data in pairs(Dialogue) do
    local Options = Data.NextOptions or Data.TalkOptions
    if Options then
        for _, OptionId in pairs(Options) do
            local OptionData = Dialogue[OptionId]
            if OptionData.ImprPlusId then
                Option2ImprData[OptionId] = OptionData.ImprPlusId
                ImprData[Data.DialogueId] = ImprData[Data.DialogueId] or {}
                table.insert(ImprData[Data.DialogueId], OptionId)
            end
        end
    end
end

for _, Data in pairs(Dialogue) do
    if Data.ImprPlusId then
        if not Option2ImprData[Data.DialogueId] then
            --- FlowExport 中的选项
            Option2ImprData[Data.DialogueId] = Data.ImprPlusId
        end
    end
end

for _, DialogueId in ipairs(GetSortedKeys(ImprData)) do
    local Data = ImprData[DialogueId]
    print(string.format("[%d] %s", DialogueId, TalkUtils:DialogueIdToContent(DialogueId)))
    for _, OptionId in ipairs(Data) do
        print(string.format("  [%d] %s", OptionId, TalkUtils:DialogueIdToContent(OptionId)))
        print(string.format("    %s", ImpressionPlusIdToText(Option2ImprData[OptionId])))
    end
    print()
end
