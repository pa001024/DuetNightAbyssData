local TalkUtils = {}

local ImpressionTypes = {"Benefit", "Morality", "Wisdom", "Empathy", "Chaos"}

---@param DialogueId integer
function TalkUtils:DialogueIdToContent(DialogueId)
    local DialogueInfo = DataMgr.Dialogue[DialogueId]
    if not DialogueInfo then
        error("DialogueId 在 Dialogue 表中不存在: " .. DialogueId)
    end

    local Content = DialogueInfo.Content
    if CommonConst.SystemLanguage ~= CommonConst.SystemLanguages.Default then
        local ContentLanguage = DialogueInfo[CommonConst.SystemLanguage]
        if ContentLanguage then
            Content = ContentLanguage
        end
    end

    return Content
end

function TalkUtils:GetImpressionPlusInfo(ImpressionPlusId)
    local PlusInfo = DataMgr.ImpressionPlus[ImpressionPlusId]
    if PlusInfo then
        local Res = {}
        Res.ImpressionAreaId = PlusInfo.RegionId
        for _, ImpressionType in pairs(ImpressionTypes) do
            local PlusValue = PlusInfo[ImpressionType .. "Plus"]
            if PlusValue > 0 then
                Res.PlusType = ImpressionType
                Res.PlusValue = PlusValue
            end
        end
        return Res
    else
        error("ImpressionPlusId 不存在: " .. ImpressionPlusId)
    end
end

return TalkUtils
